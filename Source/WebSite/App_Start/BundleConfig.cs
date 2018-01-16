﻿//******************************************************************************************************
//  BundleConfig.cs - Gbtc
//
//  Copyright © 2016, Grid Protection Alliance.  All Rights Reserved.
//
//  Licensed to the Grid Protection Alliance (GPA) under one or more contributor license agreements. See
//  the NOTICE file distributed with this work for additional information regarding copyright ownership.
//  The GPA licenses this file to you under the MIT License (MIT), the "License"; you may
//  not use this file except in compliance with the License. You may obtain a copy of the License at:
//
//      http://opensource.org/licenses/MIT
//
//  Unless agreed to in writing, the subject software distributed under the License is distributed on an
//  "AS-IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. Refer to the
//  License for the specific language governing permissions and limitations.
//
//  Code Modification History:
//  ----------------------------------------------------------------------------------------------------
//  02/17/2016 - J. Ritchie Carroll
//       Generated original version of source code.
//
//******************************************************************************************************

using System.Web.Optimization;
using System.Web.Optimization.React;

namespace SOETools
{
    public class BundleConfig
    {
        // For more information on bundling, visit http://go.microsoft.com/fwlink/?LinkId=301862
        public static void RegisterBundles(BundleCollection bundles)
        {

            bundles.Add(new ScriptBundle("~/js.bundle/jquery").Include(
                        $"~/Scripts/jquery-2.2.1.js"));

            bundles.Add(new ScriptBundle("~/js.bundle/jqueryui").Include(
                        $"~/Scripts/jquery-ui.js"));

            bundles.Add(new ScriptBundle("~/js.bundle/jqueryval").Include(
                        $"~/Scripts/jquery.validate.js",
                        $"~/Scripts/jquery.validate.unobtrusive.js"));

            // Use the development version of Modernizr to develop with and learn from. Then, when you're
            // ready for production, use the build tool at http://modernizr.com to pick only the tests you need.
            bundles.Add(new ScriptBundle("~/js.bundle/modernizr").Include(
                        "~/Scripts/modernizr-*"));

            bundles.Add(new ScriptBundle("~/js.bundle/bootstrap").Include(
                        $"~/Scripts/bootstrap.js",
                        "~/Scripts/ie10-viewport-bug-workaround.js",
                        "~/Scripts/respond.js",
                        $"~/Scripts/bootstrap-datepicker.js",
                        $"~/Scripts/bootstrap-toolkit.js"));

            bundles.Add(new ScriptBundle("~/js.bundle/fileinput").Include(
                        $"~/Scripts/fileinput.js"));

            bundles.Add(new ScriptBundle("~/js.bundle/primeui").Include(
                        "~/Scripts/plugins-all.js",
                        $"~/Scripts/mustache.js",
                        "~/Scripts/primeui.js"));

            bundles.Add(new ScriptBundle("~/js.bundle/signalR").Include(
                        $"~/Scripts/jquery.signalR-2.2.0.js"));

            bundles.Add(new ScriptBundle("~/js.bundle/gsfwebclient").Include(
                        "~/Scripts/gsf.web.client.js"));

            bundles.Add(new ScriptBundle("~/js.bundle/gsfwebprimeui").Include(
                        "~/Scripts/gsf.web.primeui.js"));

            bundles.Add(new ScriptBundle("~/js.bundle/site").Include(
                        "~/Scripts/Site.js",
                        "~/Scripts/js.cookie.js"));

            bundles.Add(new ScriptBundle("~/js.bundle/knockout").Include(
                        "~/Scripts/knockout-3.4.0.js",
                        "~/Scripts/knockout.mapping-latest.js",
                        $"~/Scripts/knockout.validation.js",
                        $"~/Scripts/ko-reactor.js",
                        "~/Scripts/ko.observableDictionary.js"));

            bundles.Add(new StyleBundle("~/css.bundle/bootstrap").Include(
                        $"~/Content/bootstrap-datepicker3.css",
                        "~/Content/bootstrap-sidebar.css"));

            bundles.Add(new StyleBundle("~/css.bundle/fileinput").Include(
                        "~/Content/fileinput.css"));

            bundles.Add(new StyleBundle("~/css.bundle/jqueryui").Include(
                        $"~/Content/jquery-ui.css"));

            bundles.Add(new StyleBundle("~/css.bundle/primeui").Include(
                        "~/Content/primeui-theme.css",
                        $"~/Content/font-awesome.css",
                        $"~/Content/primeui.css"));

            bundles.Add(new StyleBundle("~/css.bundle/site").Include(
                        "~/Content/Site.css"));

            // date range picker bundles
            bundles.Add(new StyleBundle("~/css/daterangepicker").Include(
                "~/Content/datarangepicker.css"));

            bundles.Add(new ScriptBundle("~/js/daterangepicker").Include(
                "~/Scripts/lib/moment.js",
                "~/Scripts/lib/datarangepicker.js"));

            // react bundles
            bundles.Add(new ScriptBundle("~/js/react").Include(
                "~/Scripts/lib/react/react.js",
                "~/Scripts/lib/react/react-dom.js",
                "~/Scripts/lib/react/remarkable.js"));

            bundles.Add(new BabelBundle("~/jsx/components").Include(
                "~/Scripts/JSX/DateRangePicker.jsx",
                "~/Scripts/JSX/Table.jsx"));

            // Code removed for clarity.
#if Debug
            BundleTable.EnableOptimizations = true;
#endif


        }

    }
}