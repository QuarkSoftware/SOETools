﻿//******************************************************************************************************
//  DataHub.cs - Gbtc
//
//  Copyright © 2016, Grid Protection Alliance.  All Rights Reserved.
//
//  Licensed to the Grid Protection Alliance (GPA) under one or more contributor license agreements. See
//  the NOTICE file distributed with this work for additional information regarding copyright ownership.
//  The GPA licenses this file to you under the MIT License (MIT), the "License"; you may not use this
//  file except in compliance with the License. You may obtain a copy of the License at:
//
//      http://opensource.org/licenses/MIT
//
//  Unless agreed to in writing, the subject software distributed under the License is distributed on an
//  "AS-IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. Refer to the
//  License for the specific language governing permissions and limitations.
//
//  Code Modification History:
//  ----------------------------------------------------------------------------------------------------
//  01/14/2016 - Ritchie Carroll
//       Generated original version of source code.
//
//******************************************************************************************************

using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.IO.Compression;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using System.Web;
using GSF;
using GSF.Collections;
using GSF.Data.Model;
using GSF.Identity;
using GSF.Web.Hubs;
using GSF.Web.Model;
using GSF.Web.Security;
using Microsoft.AspNet.SignalR;
using SOETools.Model;

namespace SOETools
{
    [AuthorizeHubRole]
    public class DataHub : Hub, IRecordOperationsHub
    {
        #region [ Members ]

        // Fields
        private readonly DataContext m_dataContext;
        private readonly DataContext m_coreContext;
        private readonly DataContext m_dbContext;
        private bool m_disposed;

        #endregion

        #region [ Constructors ]

        public DataHub()
        {
            m_dataContext = new DataContext(exceptionHandler: MvcApplication.LogException);
            m_coreContext = new DataContext("securityProvider",exceptionHandler: MvcApplication.LogException);
            m_dbContext = new DataContext("thirdDb", exceptionHandler: MvcApplication.LogException);
        }

        #endregion

        #region [ Properties ]

        /// <summary>
        /// Gets <see cref="IRecordOperationsHub.RecordOperationsCache"/> for SignalR hub.
        /// </summary>
        public RecordOperationsCache RecordOperationsCache => s_recordOperationsCache;

        #endregion

        #region [ Methods ]

        /// <summary>
        /// Releases the unmanaged resources used by the <see cref="DataHub"/> object and optionally releases the managed resources.
        /// </summary>
        /// <param name="disposing">true to release both managed and unmanaged resources; false to release only unmanaged resources.</param>
        protected override void Dispose(bool disposing)
        {
            if (!m_disposed)
            {
                try
                {
                    if (disposing)
                    {
                        m_dataContext?.Dispose();
                        m_coreContext?.Dispose();
                        m_dbContext?.Dispose();
                    }
                }
                finally
                {
                    m_disposed = true;          // Prevent duplicate dispose.
                    base.Dispose(disposing);    // Call base class Dispose().
                }
            }
        }

        public override Task OnConnected()
        {
            // Store the current connection ID for this thread
            s_connectionID.Value = Context.ConnectionId;
            s_connectCount++;

            //MvcApplication.LogStatusMessage($"DataHub connect by {Context.User?.Identity?.Name ?? "Undefined User"} [{Context.ConnectionId}] - count = {s_connectCount}");
            return base.OnConnected();
        }

        public override Task OnDisconnected(bool stopCalled)
        {
            if (stopCalled)
            {
                s_connectCount--;
                //MvcApplication.LogStatusMessage($"DataHub disconnect by {Context.User?.Identity?.Name ?? "Undefined User"} [{Context.ConnectionId}] - count = {s_connectCount}");
            }

            return base.OnDisconnected(stopCalled);
        }

        #endregion

        #region [ Static ]

        // Static Properties

        /// <summary>
        /// Gets the hub connection ID for the current thread.
        /// </summary>
        public static string CurrentConnectionID => s_connectionID.Value;

        // Static Fields
        private static volatile int s_connectCount;
        private static readonly ThreadLocal<string> s_connectionID = new ThreadLocal<string>();
        private static readonly RecordOperationsCache s_recordOperationsCache;

        // Static Methods

        /// <summary>
        /// Gets statically cached instance of <see cref="RecordOperationsCache"/> for <see cref="DataHub"/> instances.
        /// </summary>
        /// <returns>Statically cached instance of <see cref="RecordOperationsCache"/> for <see cref="DataHub"/> instances.</returns>
        public static RecordOperationsCache GetRecordOperationsCache() => s_recordOperationsCache;

        // Static Constructor
        static DataHub()
        {
            // Analyze and cache record operations of security hub
            s_recordOperationsCache = new RecordOperationsCache(typeof(DataHub));
        }

        #endregion

        // Client-side script functionality

        #region [ OpenSEE Table Operations ]

        public Task<Dictionary<int, List<double[]>>> QueryEventData(int eventID)
        {
            return Task.Run(() =>
            {
                const string EventDataQueryFormat =
                    "SELECT " +
                    "    EventData.TimeDomainData, " +
                    "    EventData.FrequencyDomainData " +
                    "FROM " +
                    "    Event JOIN " +
                    "    EventData ON Event.EventDataID = EventData.ID " +
                    "WHERE Event.ID = {0}";

                Dictionary<int, List<double[]>> dataLookup = new Dictionary<int, List<double[]>>();
                byte[] timeDomainData = null;
                byte[] frequencyDomainData = null;

                using (IDataReader reader = m_dbContext.Connection.ExecuteReader(EventDataQueryFormat, eventID))
                {
                    while (reader.Read())
                    {
                        timeDomainData = Decompress((byte[])reader["TimeDomainData"]);
                        frequencyDomainData = Decompress((byte[])reader["FrequencyDomainData"]);
                    }
                }

                if ((object)timeDomainData == null || (object)frequencyDomainData == null)
                    return dataLookup;

                return dataLookup.Merge(
                    GetDataLookup(timeDomainData),
                    GetDataLookup(frequencyDomainData));
            });
        }

        private byte[] Decompress(byte[] compressedBytes)
        {
            using (MemoryStream memoryStream = new MemoryStream(compressedBytes))
            using (GZipStream gzipStream = new GZipStream(memoryStream, CompressionMode.Decompress))
            using (MemoryStream destinationStream = new MemoryStream())
            {
                gzipStream.CopyTo(destinationStream);
                return destinationStream.ToArray();
            }
        }

        private Dictionary<int, List<double[]>> GetDataLookup(byte[] bytes)
        {
            int offset;
            int samples;
            double[] times;

            int channelID;
            List<double[]> dataSeries;
            Dictionary<int, List<double[]>> dataLookup;

            offset = 0;
            samples = LittleEndian.ToInt32(bytes, offset);
            offset += sizeof(int);

            long epoch = new DateTime(1970, 1, 1).Ticks;

            times = new double[samples];

            for (int i = 0; i < samples; i++)
            {
                times[i] = (LittleEndian.ToInt64(bytes, offset) - epoch) / (double)TimeSpan.TicksPerMillisecond;
                offset += sizeof(long);
            }

            dataLookup = new Dictionary<int, List<double[]>>();

            while (offset < bytes.Length)
            {
                dataSeries = new List<double[]>();
                channelID = GetChannelID(LittleEndian.ToInt32(bytes, offset));
                offset += sizeof(int);

                for (int i = 0; i < samples; i++)
                {
                    dataSeries.Add(new double[] { times[i], LittleEndian.ToDouble(bytes, offset) });
                    offset += sizeof(double);
                }

                dataLookup.Add(channelID, dataSeries);
            }

            return dataLookup;
        }

        private int GetChannelID(int seriesID)
        {
            const string QueryFormat =
                "SELECT Channel.ID " +
                "FROM " +
                "    Channel JOIN " +
                "    Series ON Series.ChannelID = Channel.ID " +
                "WHERE Series.ID = {0}";

            return m_dbContext.Connection.ExecuteScalar<int>(QueryFormat, seriesID);
        }

        #endregion

        #region [ CycleDataSOEPointView Table Operations ]



        [RecordOperation(typeof(CycleDataSOEPointView), RecordOperation.QueryRecordCount)]
        public int QueryCycleDataSOEPointViewCount(int parentID, string filterText)
        {
            return m_dbContext.Table<CycleDataSOEPointView>().QueryRecordCount(new RecordRestriction("IncidentID = {0}", parentID));
        }


        [RecordOperation(typeof(CycleDataSOEPointView), RecordOperation.QueryRecords)]
        public IEnumerable<CycleDataSOEPointView> QueryCycleDataSOEPointViewItems(int parentID, string sortField, bool ascending, int page, int pageSize, string filterText)
        {
            return m_dbContext.Table<CycleDataSOEPointView>().QueryRecords(sortField, ascending, page, pageSize, new RecordRestriction("IncidentID = {0}", parentID));
        }

        [AuthorizeHubRole("Administrator")]
        [RecordOperation(typeof(CycleDataSOEPointView), RecordOperation.DeleteRecord)]
        public void DeleteCycleDataSOEPointView(int id)
        {
            m_coreContext.Table<CycleDataSOEPointView>().DeleteRecord(id);
        }

        [AuthorizeHubRole("Administrator")]
        [RecordOperation(typeof(CycleDataSOEPointView), RecordOperation.CreateNewRecord)]
        public CycleDataSOEPointView NewCycleDataSOEPointView()
        {
            return new CycleDataSOEPointView();
        }

        [AuthorizeHubRole("Administrator")]
        [RecordOperation(typeof(CycleDataSOEPointView), RecordOperation.AddNewRecord)]
        public void AddNewCycleDataSOEPointView(CycleDataSOEPointView record)
        {
            m_coreContext.Table<CycleDataSOEPointView>().AddNewRecord(record);
        }

        [AuthorizeHubRole("Administrator")]
        [RecordOperation(typeof(CycleDataSOEPointView), RecordOperation.UpdateRecord)]
        public void UpdateCycleDataSOEPointView(CycleDataSOEPointView record)
        {
            m_coreContext.Table<CycleDataSOEPointView>().UpdateRecord(record);
        }



        #endregion

        #region [ IncidentEventCycleDataView Table Operations ]


        [RecordOperation(typeof(IncidentEventCycleDataView), RecordOperation.QueryRecordCount)]
        public int QueryIncidentEventCycleDataViewCount(int dateRange, string incidentTypes, int minCurrent, int maxCurrent, int ground, float minRatio, float maxRatio, string filterText)
        {
            List<string> restrictions = new List<string>();
            List<object> restrictionParams = new List<object>();

            if (dateRange != -1)
            {
                restrictions.Add($"DATEDIFF(day, StartTime, GETDATE()) <= {{{restrictionParams.Count}}}");
                restrictionParams.Add(dateRange);
            }

            if (!string.IsNullOrEmpty(incidentTypes))
            {
                object[] incidentTypeParams = incidentTypes.Split(',');
                string formatParams = string.Join(",", Enumerable.Range(restrictionParams.Count, incidentTypeParams.Length).Select(index => $"{{{index}}}"));
                restrictions.Add($"IncidentType IN ({formatParams})");
                restrictionParams.AddRange(incidentTypeParams);
            }

            if (minCurrent != -1)
            {
                restrictions.Add($"IMax >= {{{restrictionParams.Count}}}");
                restrictionParams.Add(minCurrent);
            }

            if (maxCurrent != -1)
            {
                restrictions.Add($"IMax < {{{restrictionParams.Count}}}");
                restrictionParams.Add(maxCurrent);
            }

            if (ground != -1)
            {
                restrictions.Add($"IRMax > {{{restrictionParams.Count}}}");
                restrictionParams.Add(ground);
            }

            if (minRatio != -1)
            {
                if (minRatio > 1.0F)
                    restrictions.Add($"(VMax / NominalVoltage) >= {{{restrictionParams.Count}}}");
                else
                    restrictions.Add($"(VMin / NominalVoltage) >= {{{restrictionParams.Count}}}");

                restrictionParams.Add(minRatio);
            }

            if (maxRatio != -1)
            {
                if (maxRatio < 1.0F)
                    restrictions.Add($"(VMin / NominalVoltage) < {{{restrictionParams.Count}}}");
                else
                    restrictions.Add($"(VMax / NominalVoltage) < {{{restrictionParams.Count}}}");

                restrictionParams.Add(maxRatio);
            }

            if ((object)filterText != null)
            {
                restrictions.Add($"Device LIKE {{{restrictionParams.Count}}}");
                restrictionParams.Add(filterText + "%");
            }

            if (restrictions.Any())
            {
                string filterExpression = string.Join(" AND ", restrictions);
                RecordRestriction restriction = new RecordRestriction(filterExpression, restrictionParams.ToArray());
                return m_dbContext.Table<IncidentEventCycleDataView>().QueryRecordCount(restriction);
            }

            return m_dbContext.Table<IncidentEventCycleDataView>().QueryRecordCount();
        }

        [RecordOperation(typeof(IncidentEventCycleDataView), RecordOperation.QueryRecords)]
        public IEnumerable<IncidentEventCycleDataView> QueryIncidentEventCycleDataViewItems(int dateRange, string incidentTypes, int minCurrent, int maxCurrent, int ground, float minRatio, float maxRatio, string sortField, bool ascending, int page, int pageSize, string filterText)
        {
            List<string> restrictions = new List<string>();
            List<object> restrictionParams = new List<object>();

            if (dateRange != -1)
            {
                restrictions.Add($"DATEDIFF(day, StartTime, GETDATE()) <= {{{restrictionParams.Count}}}");
                restrictionParams.Add(dateRange);
            }

            if (!string.IsNullOrEmpty(incidentTypes))
            {
                object[] incidentTypeParams = incidentTypes.Split(',');
                string formatParams = string.Join(",", Enumerable.Range(restrictionParams.Count, incidentTypeParams.Length).Select(index => $"{{{index}}}"));
                restrictions.Add($"IncidentType IN ({formatParams})");
                restrictionParams.AddRange(incidentTypeParams);
            }

            if (minCurrent != -1)
            {
                restrictions.Add($"IMax >= {{{restrictionParams.Count}}}");
                restrictionParams.Add(minCurrent);
            }

            if (maxCurrent != -1)
            {
                restrictions.Add($"IMax < {{{restrictionParams.Count}}}");
                restrictionParams.Add(maxCurrent);
            }

            if (ground != -1)
            {
                restrictions.Add($"IRMax > {{{restrictionParams.Count}}}");
                restrictionParams.Add(ground);
            }

            if (minRatio != -1)
            {
                if (minRatio > 1.0F)
                    restrictions.Add($"(VMax / NominalVoltage) >= {{{restrictionParams.Count}}}");
                else
                    restrictions.Add($"(VMin / NominalVoltage) >= {{{restrictionParams.Count}}}");

                restrictionParams.Add(minRatio);
            }

            if (maxRatio != -1)
            {
                if (maxRatio < 1.0F)
                    restrictions.Add($"(VMin / NominalVoltage) < {{{restrictionParams.Count}}}");
                else
                    restrictions.Add($"(VMax / NominalVoltage) < {{{restrictionParams.Count}}}");

                restrictionParams.Add(maxRatio);
            }

            if ((object)filterText != null)
            {
                restrictions.Add($"Device LIKE {{{restrictionParams.Count}}}");
                restrictionParams.Add(filterText + "%");
            }

            if (restrictions.Any())
            {
                string filterExpression = string.Join(" AND ", restrictions);
                RecordRestriction restriction = new RecordRestriction(filterExpression, restrictionParams.ToArray());
                return m_dbContext.Table<IncidentEventCycleDataView>().QueryRecords(sortField, ascending, page, pageSize, restriction);
            }

            return m_dbContext.Table<IncidentEventCycleDataView>().QueryRecords(sortField, ascending, page, pageSize);
        }

        [AuthorizeHubRole("Administrator")]
        [RecordOperation(typeof(IncidentEventCycleDataView), RecordOperation.DeleteRecord)]
        public void DeleteIncidentEventCycleDataView(int id)
        {
            m_coreContext.Table<IncidentEventCycleDataView>().DeleteRecord(id);
        }

        [AuthorizeHubRole("Administrator")]
        [RecordOperation(typeof(IncidentEventCycleDataView), RecordOperation.CreateNewRecord)]
        public IncidentEventCycleDataView NewIncidentEventCycleDataView()
        {
            return new IncidentEventCycleDataView();
        }

        [AuthorizeHubRole("Administrator")]
        [RecordOperation(typeof(IncidentEventCycleDataView), RecordOperation.AddNewRecord)]
        public void AddNewIncidentEventCycleDataView(IncidentEventCycleDataView record)
        {
            m_coreContext.Table<IncidentEventCycleDataView>().AddNewRecord(record);
        }

        [AuthorizeHubRole("Administrator")]
        [RecordOperation(typeof(IncidentEventCycleDataView), RecordOperation.UpdateRecord)]
        public void UpdateIncidentEventCycleDataView(IncidentEventCycleDataView record)
        {
            m_coreContext.Table<IncidentEventCycleDataView>().UpdateRecord(record);
        }
        #endregion

        #region [ Page Table Operations ]

        [AuthorizeHubRole("Administrator")]
        [RecordOperation(typeof(Page), RecordOperation.QueryRecordCount)]
        public int QueryPageCount(string filterText)
        {
            return m_coreContext.Table<Page>().QueryRecordCount();
        }

        [AuthorizeHubRole("Administrator")]
        [RecordOperation(typeof(Page), RecordOperation.QueryRecords)]
        public IEnumerable<Page> QueryPages(string sortField, bool ascending, int page, int pageSize, string filterText)
        {
            return m_coreContext.Table<Page>().QueryRecords(sortField, ascending, page, pageSize);
        }

        [AuthorizeHubRole("Administrator")]
        [RecordOperation(typeof(Page), RecordOperation.DeleteRecord)]
        public void DeletePage(int id)
        {
            m_coreContext.Table<Page>().DeleteRecord(id);
        }

        [AuthorizeHubRole("Administrator")]
        [RecordOperation(typeof(Page), RecordOperation.CreateNewRecord)]
        public Page NewPage()
        {
            return new Page();
        }

        [AuthorizeHubRole("Administrator")]
        [RecordOperation(typeof(Page), RecordOperation.AddNewRecord)]
        public void AddNewPage(Page record)
        {
            record.CreatedOn = DateTime.UtcNow;
            m_coreContext.Table<Page>().AddNewRecord(record);
        }

        [AuthorizeHubRole("Administrator")]
        [RecordOperation(typeof(Page), RecordOperation.UpdateRecord)]
        public void UpdatePage(Page record)
        {
            m_coreContext.Table<Page>().UpdateRecord(record);
        }

        #endregion

        #region [ Menu Table Operations ]

        [AuthorizeHubRole("Administrator")]
        [RecordOperation(typeof(Menu), RecordOperation.QueryRecordCount)]
        public int QueryMenuCount(string filterText)
        {
            return m_coreContext.Table<Menu>().QueryRecordCount();
        }

        [AuthorizeHubRole("Administrator")]
        [RecordOperation(typeof(Menu), RecordOperation.QueryRecords)]
        public IEnumerable<Menu> QueryMenus(string sortField, bool ascending, int page, int pageSize, string filterText)
        {
            return m_coreContext.Table<Menu>().QueryRecords(sortField, ascending, page, pageSize);
        }

        [AuthorizeHubRole("Administrator")]
        [RecordOperation(typeof(Menu), RecordOperation.DeleteRecord)]
        public void DeleteMenu(int id)
        {
            m_coreContext.Table<Menu>().DeleteRecord(id);
        }

        [AuthorizeHubRole("Administrator")]
        [RecordOperation(typeof(Menu), RecordOperation.CreateNewRecord)]
        public Menu NewMenu()
        {
            return new Menu();
        }

        [AuthorizeHubRole("Administrator")]
        [RecordOperation(typeof(Menu), RecordOperation.AddNewRecord)]
        public void AddNewMenu(Menu record)
        {
            record.CreatedOn = DateTime.UtcNow;
            m_coreContext.Table<Menu>().AddNewRecord(record);
        }

        [AuthorizeHubRole("Administrator")]
        [RecordOperation(typeof(Menu), RecordOperation.UpdateRecord)]
        public void UpdateMenu(Menu record)
        {
            m_coreContext.Table<Menu>().UpdateRecord(record);
        }

        #endregion

        #region [ MenuItem Table Operations ]

        [AuthorizeHubRole("Administrator")]
        [RecordOperation(typeof(MenuItem), RecordOperation.QueryRecordCount)]
        public int QueryMenuItemCount(int parentID, string filterText)
        {
            return m_coreContext.Table<MenuItem>().QueryRecordCount(new RecordRestriction("MenuID = {0}", parentID));
        }

        [AuthorizeHubRole("Administrator")]
        [RecordOperation(typeof(MenuItem), RecordOperation.QueryRecords)]
        public IEnumerable<MenuItem> QueryMenuItems(int parentID, string sortField, bool ascending, int page, int pageSize, string filterText)
        {
            return m_coreContext.Table<MenuItem>().QueryRecords(sortField, ascending, page, pageSize, new RecordRestriction("MenuID = {0}", parentID));
        }

        [AuthorizeHubRole("Administrator")]
        [RecordOperation(typeof(MenuItem), RecordOperation.DeleteRecord)]
        public void DeleteMenuItem(int id)
        {
            m_coreContext.Table<MenuItem>().DeleteRecord(id);
        }

        [AuthorizeHubRole("Administrator")]
        [RecordOperation(typeof(MenuItem), RecordOperation.CreateNewRecord)]
        public MenuItem NewMenuItem()
        {
            return new MenuItem();
        }

        [AuthorizeHubRole("Administrator")]
        [RecordOperation(typeof(MenuItem), RecordOperation.AddNewRecord)]
        public void AddNewMenuItem(MenuItem record)
        {
            // TODO: MenuItem.Text is currently required in database, but empty should be allowed for spacer items
            if (string.IsNullOrEmpty(record.Text))
                record.Text = " ";

            m_coreContext.Table<MenuItem>().AddNewRecord(record);
        }

        [AuthorizeHubRole("Administrator")]
        [RecordOperation(typeof(MenuItem), RecordOperation.UpdateRecord)]
        public void UpdateMenuItem(MenuItem record)
        {
            // TODO: MenuItem.Text is currently required in database, but empty should be allowed for spacer items
            if (string.IsNullOrEmpty(record.Text))
                record.Text = " ";

            m_coreContext.Table<MenuItem>().UpdateRecord(record);
        }

        #endregion

        #region [ ValueListGroup Table Operations ]

        [AuthorizeHubRole("Administrator")]
        [RecordOperation(typeof(ValueListGroup), RecordOperation.QueryRecordCount)]
        public int QueryValueListGroupCount(string filterText)
        {
            return m_dataContext.Table<ValueListGroup>().QueryRecordCount();
        }

        [AuthorizeHubRole("Administrator")]
        [RecordOperation(typeof(ValueListGroup), RecordOperation.QueryRecords)]
        public IEnumerable<ValueListGroup> QueryValueListGroups(string sortField, bool ascending, int page, int pageSize, string filterText)
        {
            return m_dataContext.Table<ValueListGroup>().QueryRecords(sortField, ascending, page, pageSize);
        }

        [AuthorizeHubRole("Administrator")]
        [RecordOperation(typeof(ValueListGroup), RecordOperation.DeleteRecord)]
        public void DeleteValueListGroup(int id)
        {
            m_dataContext.Table<ValueListGroup>().DeleteRecord(id);
        }

        [AuthorizeHubRole("Administrator")]
        [RecordOperation(typeof(ValueListGroup), RecordOperation.CreateNewRecord)]
        public ValueListGroup NewValueListGroup()
        {
            return new ValueListGroup();
        }

        [AuthorizeHubRole("Administrator")]
        [RecordOperation(typeof(ValueListGroup), RecordOperation.AddNewRecord)]
        public void AddNewValueListGroup(ValueListGroup record)
        {
            record.CreatedOn = DateTime.UtcNow;
            m_dataContext.Table<ValueListGroup>().AddNewRecord(record);
        }

        [AuthorizeHubRole("Administrator")]
        [RecordOperation(typeof(ValueListGroup), RecordOperation.UpdateRecord)]
        public void UpdateValueListGroup(ValueListGroup record)
        {
            m_dataContext.Table<ValueListGroup>().UpdateRecord(record);
        }

        #endregion

        #region [ ValueList Table Operations ]


        [AuthorizeHubRole("Administrator")]
        [RecordOperation(typeof(ValueList), RecordOperation.QueryRecordCount)]
        public int QueryValueListCount(int parentID, string filterText)
        {
            return m_dataContext.Table<ValueList>().QueryRecordCount(new RecordRestriction("GroupID = {0}", parentID));
        }

        [AuthorizeHubRole("Administrator")]
        [RecordOperation(typeof(ValueList), RecordOperation.QueryRecords)]
        public IEnumerable<ValueList> QueryValueListItems(int parentID, string sortField, bool ascending, int page, int pageSize, string filterText)
        {
            return m_dataContext.Table<ValueList>().QueryRecords(sortField, ascending, page, pageSize, new RecordRestriction("GroupID = {0}", parentID));
        }

        [AuthorizeHubRole("Administrator")]
        [RecordOperation(typeof(ValueList), RecordOperation.DeleteRecord)]
        public void DeleteValueList(int id)
        {
            m_dataContext.Table<ValueList>().DeleteRecord(id);
        }

        [AuthorizeHubRole("Administrator")]
        [RecordOperation(typeof(ValueList), RecordOperation.CreateNewRecord)]
        public ValueList NewValueList()
        {
            return new ValueList();
        }

        [AuthorizeHubRole("Administrator")]
        [RecordOperation(typeof(ValueList), RecordOperation.AddNewRecord)]
        public void AddNewValueList(ValueList record)
        {
            record.CreatedOn = DateTime.UtcNow;
            m_dataContext.Table<ValueList>().AddNewRecord(record);
        }

        [AuthorizeHubRole("Administrator")]
        [RecordOperation(typeof(ValueList), RecordOperation.UpdateRecord)]
        public void UpdateValueList(ValueList record)
        {
            m_dataContext.Table<ValueList>().UpdateRecord(record);
        }

        #endregion

        #region [ Miscellaneous Hub Operations ]

        /// <summary>
        /// Gets page setting for specified page.
        /// </summary>
        /// <param name="pageID">ID of page record.</param>
        /// <param name="key">Setting key name.</param>
        /// <param name="defaultValue">Setting default value.</param>
        /// <returns>Page setting for specified page.</returns>
        public string GetPageSetting(int pageID, string key, string defaultValue)
        {
            Page page = m_coreContext.Table<Page>().LoadRecord(pageID);
            Dictionary<string, string> pageSettings = (page?.ServerConfiguration ?? "").ParseKeyValuePairs();
            AppModel model = MvcApplication.DefaultModel;
            return model.GetPageSetting(pageSettings, model.Global.PageDefaults, key, defaultValue);
        }

        /// <summary>
        /// Gets the absolute path for a virtual path, e.g., ~/Images/Menu
        /// </summary>
        /// <param name="path">Virtual path o convert to absolute path.</param>
        /// <returns>Absolute path for a virtual path.</returns>
        public string GetAbsolutePath(string path)
        {
            if (string.IsNullOrWhiteSpace(path))
                return "";

            return VirtualPathUtility.ToAbsolute(path);
        }

        /// <summary>
        /// Gets UserAccount table ID for current user.
        /// </summary>
        /// <returns>UserAccount.ID for current user.</returns>
        public Guid GetCurrentUserID()
        {
            Guid userID;
            AuthorizationCache.UserIDs.TryGetValue(UserInfo.CurrentUserID, out userID);
            return userID;
        }

        #endregion
    }
}
