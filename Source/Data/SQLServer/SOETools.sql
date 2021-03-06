USE [Master]
GO
CREATE DATABASE [SOETools]
GO
USE [SOETools]
GO
/****** Object:  Table [dbo].[AccessLog]    Script Date: 1/16/2018 9:24:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[AccessLog](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[UserName] [varchar](200) NOT NULL,
	[AccessGranted] [bit] NOT NULL,
	[CreatedOn] [datetime] NOT NULL,
 CONSTRAINT [PK_AccessLog] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ApplicationRole]    Script Date: 1/16/2018 9:24:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ApplicationRole](
	[ID] [uniqueidentifier] NOT NULL,
	[Name] [varchar](200) NOT NULL,
	[Description] [varchar](max) NULL,
	[NodeID] [uniqueidentifier] NOT NULL,
	[CreatedOn] [datetime] NOT NULL,
	[CreatedBy] [varchar](200) NOT NULL,
	[UpdatedOn] [datetime] NOT NULL,
	[UpdatedBy] [varchar](200) NOT NULL,
 CONSTRAINT [PK_ApplicationRole] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ApplicationRoleSecurityGroup]    Script Date: 1/16/2018 9:24:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ApplicationRoleSecurityGroup](
	[ApplicationRoleID] [uniqueidentifier] NOT NULL,
	[SecurityGroupID] [uniqueidentifier] NOT NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ApplicationRoleUserAccount]    Script Date: 1/16/2018 9:24:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ApplicationRoleUserAccount](
	[ApplicationRoleID] [uniqueidentifier] NOT NULL,
	[UserAccountID] [uniqueidentifier] NOT NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ErrorLog]    Script Date: 1/16/2018 9:24:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ErrorLog](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Source] [varchar](200) NOT NULL,
	[Type] [varchar](max) NULL,
	[Message] [varchar](max) NOT NULL,
	[Detail] [varchar](max) NULL,
	[CreatedOn] [datetime] NOT NULL,
 CONSTRAINT [PK_ErrorLog] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Menu]    Script Date: 1/16/2018 9:24:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Menu](
	[ID] [int]IDENTITY(1,1) NOT NULL,
	[Name] [varchar](64) NULL,
	[Abbreviation] [varchar](12) NULL,
	[Description] [varchar](max) NULL,
	[CreatedOn] [datetime] NOT NULL,
 CONSTRAINT [PK_Menu2] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[MenuItem]    Script Date: 1/16/2018 9:24:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[MenuItem](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[MenuID] [int] NOT NULL,
	[PageID] [int] NOT NULL,
	[Image] [varchar](200) NOT NULL,
	[ImageAlt] [varchar](200) NULL,
	[Text] [varchar](20) NOT NULL,
	[Link] [varchar](200) NULL,
	[SortOrder] [int] NULL,
	[Description] [varchar](max) NULL,
	[Enabled] [bit] NOT NULL,
 CONSTRAINT [PK_MenuItem2] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Node]    Script Date: 1/16/2018 9:24:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING OFF
GO
CREATE TABLE [dbo].[Node](
	[ID] [uniqueidentifier] NOT NULL,
	[Name] [varchar](200) NOT NULL,
	[Description] [varchar](max) NULL,
	[Enabled] [bit] NOT NULL,
	[CreatedOn] [datetime] NOT NULL,
	[CreatedBy] [varchar](200) NOT NULL,
	[UpdatedOn] [datetime] NOT NULL,
	[UpdatedBy] [varchar](200) NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Page]    Script Date: 1/16/2018 9:24:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Page](
	[ID] [int]IDENTITY(1,1) NOT NULL,
	[Name] [varchar](64) NOT NULL,
	[Title] [varchar](64) NOT NULL,
	[MenuID] [int] NOT NULL,
	[PageLocation] [varchar](200) NOT NULL,
	[ServerConfiguration] [varchar](max) NULL,
	[ClientConfiguration] [varchar](max) NULL,
	[IncludedRoles] [varchar](200) NULL,
	[ExcludedRoles] [varchar](200) NULL,
	[Description] [varchar](max) NULL,
	[Enabled] [bit] NOT NULL,
	[CreatedOn] [datetime] NULL,
 CONSTRAINT [PK_Page4] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[SecurityGroup]    Script Date: 1/16/2018 9:24:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[SecurityGroup](
	[ID] [uniqueidentifier] NOT NULL,
	[Name] [varchar](200) NOT NULL,
	[Description] [varchar](max) NULL,
	[CreatedOn] [datetime] NOT NULL,
	[CreatedBy] [varchar](200) NOT NULL,
	[UpdatedOn] [datetime] NOT NULL,
	[UpdatedBy] [varchar](200) NOT NULL,
 CONSTRAINT [PK_SecurityGroup] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[SecurityGroupUserAccount]    Script Date: 1/16/2018 9:24:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SecurityGroupUserAccount](
	[SecurityGroupID] [uniqueidentifier] NOT NULL,
	[UserAccountID] [uniqueidentifier] NOT NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Settings]    Script Date: 1/16/2018 9:24:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Settings](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Scope] [varchar](64) NULL,
	[Name] [varchar](64) NULL,
	[Value] [varchar](512) NULL,
	[ApplicationInstance] [bit] NOT NULL,
	[Roles] [varchar](200) NULL,
 CONSTRAINT [PK_Settings] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[UserAccount]    Script Date: 1/16/2018 9:24:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[UserAccount](
	[ID] [uniqueidentifier] NOT NULL,
	[Name] [varchar](200) NOT NULL,
	[Password] [varchar](200) NULL,
	[FirstName] [varchar](200) NULL,
	[LastName] [varchar](200) NULL,
	[DefaultNodeID] [uniqueidentifier] NOT NULL,
	[Phone] [varchar](200) NULL,
	[Email] [varchar](200) NULL,
	[LockedOut] [bit] NOT NULL,
	[UseADAuthentication] [bit] NOT NULL,
	[ChangePasswordOn] [datetime] NULL,
	[CreatedOn] [datetime] NOT NULL,
	[CreatedBy] [varchar](50) NOT NULL,
	[UpdatedOn] [datetime] NOT NULL,
	[UpdatedBy] [varchar](50) NOT NULL,
 CONSTRAINT [PK_UserAccount] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO

CREATE TABLE [dbo].[Document](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Filename] [varchar](200) NOT NULL,
	[DocumentTypeKey] [int] NULL,
	[DocumentBlob] [varbinary](max) NULL,
	[Enabled] [bit] NOT NULL,
	[CreatedOn] [datetime] NOT NULL,
	[CreatedByID] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_Document] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO


CREATE TABLE [dbo].[NoticeLog](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[PatchID] [int] NOT NULL,
	[NoticeMethodKey] [int] NULL,
	[NoticeLevelKey] [int] NULL,
	[ToUsers] [varchar](1024) NULL,
	[XcUsers] [varchar](1024) NULL,
	[Text] [varchar](max) NULL,
	[SentOn] [datetime] NULL,
	[CreatedOn] [datetime] NULL,
 CONSTRAINT [PK_NoticeLog] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[NoticeUserLink]    Script Date: 1/16/2018 9:22:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NoticeUserLink](
	[UserID] [int] NOT NULL,
	[NoticeLevelKey] [int] NOT NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ValueList]    Script Date: 1/16/2018 9:22:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ValueList](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[GroupID] [int] NOT NULL,
	[Key] [int] NOT NULL,
	[Text] [varchar](200) NULL,
	[AltText1] [varchar](200) NULL,
	[AltText2] [varchar](200) NULL,
	[Abbreviation] [varchar](12) NULL,
	[Value] [int] NULL,
	[Flag] [bit] NOT NULL,
	[Description] [varchar](max) NULL,
	[SortOrder] [int] NULL,
	[IsDefault] [bit] NOT NULL,
	[Hidden] [bit] NOT NULL,
	[Enabled] [bit] NOT NULL,
	[CreatedOn] [datetime] NOT NULL,
 CONSTRAINT [PK_ValueList5] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ValueListGroup]    Script Date: 1/16/2018 9:22:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ValueListGroup](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](200) NULL,
	[Description] [varchar](max) NULL,
	[Enabled] [bit] NOT NULL,
	[CreatedOn] [datetime] NULL,
 CONSTRAINT [PK_ValueListGroup2] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

/****** Object:  View [dbo].[AppRoleSecurityGroupDetail]    Script Date: 1/16/2018 9:24:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[AppRoleSecurityGroupDetail] 
AS
SELECT ApplicationRoleSecurityGroup.ApplicationRoleID, ApplicationRoleSecurityGroup.SecurityGroupID, ApplicationRole.Name AS ApplicationRoleName, ApplicationRole.Description AS ApplicationRoleDescription, SecurityGroup.Name AS SecurityGroupName, SecurityGroup.Description AS SecurityGroupDescription
FROM ApplicationRoleSecurityGroup WITH (NOLOCK), ApplicationRole WITH (NOLOCK), SecurityGroup WITH (NOLOCK)
WHERE ApplicationRoleSecurityGroup.ApplicationRoleID = ApplicationRole.ID AND ApplicationRoleSecurityGroup.SecurityGroupID = SecurityGroup.ID

GO
/****** Object:  View [dbo].[AppRoleUserAccountDetail]    Script Date: 1/16/2018 9:24:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[AppRoleUserAccountDetail]
AS
SELECT     dbo.ApplicationRoleUserAccount.ApplicationRoleID, dbo.ApplicationRoleUserAccount.UserAccountID, UserAccount.Name AS UserName, UserAccount.FirstName, UserAccount.LastName, UserAccount.Email, 
                      dbo.ApplicationRole.Name AS ApplicationRoleName, dbo.ApplicationRole.Description AS ApplicationRoleDescription
FROM         dbo.ApplicationRoleUserAccount WITH (NOLOCK) INNER JOIN
                      dbo.ApplicationRole WITH (NOLOCK) ON dbo.ApplicationRoleUserAccount.ApplicationRoleID = dbo.ApplicationRole.ID INNER JOIN
                      UserAccount WITH (NOLOCK) ON dbo.ApplicationRoleUserAccount.UserAccountID = UserAccount.ID

GO
/****** Object:  View [dbo].[SecurityGroupUserAccountDetail]    Script Date: 1/16/2018 9:24:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[SecurityGroupUserAccountDetail]
AS
SELECT     dbo.SecurityGroupUserAccount.SecurityGroupID, dbo.SecurityGroupUserAccount.UserAccountID, UserAccount.Name AS UserName, UserAccount.FirstName, UserAccount.LastName, UserAccount.Email, 
                      dbo.SecurityGroup.Name AS SecurityGroupName, dbo.SecurityGroup.Description AS SecurityGroupDescription
FROM         dbo.SecurityGroupUserAccount WITH (NOLOCK) INNER JOIN
                      dbo.SecurityGroup WITH (NOLOCK) ON dbo.SecurityGroupUserAccount.SecurityGroupID = dbo.SecurityGroup.ID INNER JOIN
                      UserAccount WITH (NOLOCK) ON dbo.SecurityGroupUserAccount.UserAccountID = UserAccount.ID

GO

INSERT [dbo].[SecurityGroup] ([ID], [Name], [Description], [CreatedOn], [CreatedBy], [UpdatedOn], [UpdatedBy]) VALUES (N'ab45dad0-dcf9-451a-91b9-a53680355001', N'S-1-5-32-545', NULL, GETDATE(), N'IIS APPPOOL\.NET v4.5', GETDATE(), N'IIS APPPOOL\.NET v4.5')
GO
INSERT [dbo].[ApplicationRole] ([ID], [Name], [Description], [NodeID], [CreatedOn], [CreatedBy], [UpdatedOn], [UpdatedBy]) VALUES (N'07ea52e5-3444-4662-82e3-620c4ad1b60b', N'Administrator', N'Administrator Role', N'e8db85cf-f625-41d9-b58d-31663cea84d2', GETDATE(), N'IIS APPPOOL\.NET v4.5', GETDATE(), N'IIS APPPOOL\.NET v4.5')
GO
INSERT [dbo].[ApplicationRole] ([ID], [Name], [Description], [NodeID], [CreatedOn], [CreatedBy], [UpdatedOn], [UpdatedBy]) VALUES (N'd9df1672-6fde-4c53-bf66-64ffdcaf18f4', N'Viewer', N'Viewer Role', N'e8db85cf-f625-41d9-b58d-31663cea84d2', GETDATE(), N'IIS APPPOOL\.NET v4.5', GETDATE(), N'IIS APPPOOL\.NET v4.5')
GO
INSERT [dbo].[ApplicationRoleSecurityGroup] ([ApplicationRoleID], [SecurityGroupID]) VALUES (N'07ea52e5-3444-4662-82e3-620c4ad1b60b', N'ab45dad0-dcf9-451a-91b9-a53680355001')
GO
SET IDENTITY_INSERT [dbo].[Menu] ON 
GO
INSERT [dbo].[Menu] ([ID], [Name], [Abbreviation], [Description], [CreatedOn]) VALUES (0, N'All Menus', N'All', N'Menu items that appear in all menus (except null)', CAST(N'2016-03-11 13:35:08.923' AS DateTime))
GO
INSERT [dbo].[Menu] ([ID], [Name], [Abbreviation], [Description], [CreatedOn]) VALUES (1, N'Home', N'Home', N'Base Menu', CAST(N'2016-02-23 10:41:07.507' AS DateTime))
GO
INSERT [dbo].[Menu] ([ID], [Name], [Abbreviation], [Description], [CreatedOn]) VALUES (2, N'Application Settings', N'AppSettings', N'Application Settings Menu', CAST(N'2016-03-01 16:24:01.473' AS DateTime))
GO
INSERT [dbo].[Menu] ([ID], [Name], [Abbreviation], [Description], [CreatedOn]) VALUES (3, N'System Settings', N'SysSettings', N'System Settings Menu', CAST(N'2016-03-01 16:25:30.383' AS DateTime))
GO
INSERT [dbo].[Menu] ([ID], [Name], [Abbreviation], [Description], [CreatedOn]) VALUES (100, N'Null', N'Null', N'No Menu will be displayed for this menu designation', CAST(N'2016-02-23 10:42:01.710' AS DateTime))
GO
SET IDENTITY_INSERT [dbo].[Menu] OFF
GO
SET IDENTITY_INSERT [dbo].[MenuItem] ON 
GO
INSERT [dbo].[MenuItem] ([ID], [MenuID], [PageID], [Image], [ImageAlt], [Text], [Link], [SortOrder], [Description], [Enabled]) VALUES (67, 0, 1, N'home.png', N'Home', N'Dashboard', NULL, 0, NULL, 1)
GO
INSERT [dbo].[MenuItem] ([ID], [MenuID], [PageID], [Image], [ImageAlt], [Text], [Link], [SortOrder], [Description], [Enabled]) VALUES (68, 0, 0, N'empty.png', N'·', N'  ', NULL, 1000, NULL, 1)
GO
INSERT [dbo].[MenuItem] ([ID], [MenuID], [PageID], [Image], [ImageAlt], [Text], [Link], [SortOrder], [Description], [Enabled]) VALUES (69, 0, 100, N'help.png', N'Help', N'Help', NULL, 1010, NULL, 1)
GO
INSERT [dbo].[MenuItem] ([ID], [MenuID], [PageID], [Image], [ImageAlt], [Text], [Link], [SortOrder], [Description], [Enabled]) VALUES (71, 1, 20, N'SOEData.png', N'', N'SOE Data', NULL, 10, N'', 1)
GO
INSERT [dbo].[MenuItem] ([ID], [MenuID], [PageID], [Image], [ImageAlt], [Text], [Link], [SortOrder], [Description], [Enabled]) VALUES (77, 1, 70, N'patchHistory.png', N'History', N'SOE History', NULL, 70, NULL, 1)
GO
INSERT [dbo].[MenuItem] ([ID], [MenuID], [PageID], [Image], [ImageAlt], [Text], [Link], [SortOrder], [Description], [Enabled]) VALUES (79, 1, 200, N'settings.png', N'Settings', N'Settings', NULL, 90, N'Goes to Menu 2', 1)
GO
INSERT [dbo].[MenuItem] ([ID], [MenuID], [PageID], [Image], [ImageAlt], [Text], [Link], [SortOrder], [Description], [Enabled]) VALUES (80, 1, 0, N'empty.png', N'·', N'', NULL, 100, NULL, 1)
GO
INSERT [dbo].[MenuItem] ([ID], [MenuID], [PageID], [Image], [ImageAlt], [Text], [Link], [SortOrder], [Description], [Enabled]) VALUES (83, 2, 210, N'settingsDetail.png', N'Vendor', N'Vendor List', NULL, 10, NULL, 1)
GO
INSERT [dbo].[MenuItem] ([ID], [MenuID], [PageID], [Image], [ImageAlt], [Text], [Link], [SortOrder], [Description], [Enabled]) VALUES (84, 2, 220, N'settingsDetail.png', N'Platform', N'Platform List', NULL, 20, NULL, 1)
GO
INSERT [dbo].[MenuItem] ([ID], [MenuID], [PageID], [Image], [ImageAlt], [Text], [Link], [SortOrder], [Description], [Enabled]) VALUES (85, 2, 230, N'settingsDetail.png', N'BUG', N'Business Units', NULL, 30, NULL, 1)
GO
INSERT [dbo].[MenuItem] ([ID], [MenuID], [PageID], [Image], [ImageAlt], [Text], [Link], [SortOrder], [Description], [Enabled]) VALUES (86, 2, 0, N'empty.png', N'·', N' ', NULL, 40, NULL, 1)
GO
INSERT [dbo].[MenuItem] ([ID], [MenuID], [PageID], [Image], [ImageAlt], [Text], [Link], [SortOrder], [Description], [Enabled]) VALUES (87, 2, 300, N'user.png', N'User', N'Security Users', NULL, 50, N'', 1)
GO
INSERT [dbo].[MenuItem] ([ID], [MenuID], [PageID], [Image], [ImageAlt], [Text], [Link], [SortOrder], [Description], [Enabled]) VALUES (88, 2, 310, N'userGroup.png', N'Groups', N'Security Groups', NULL, 60, NULL, 1)
GO
INSERT [dbo].[MenuItem] ([ID], [MenuID], [PageID], [Image], [ImageAlt], [Text], [Link], [SortOrder], [Description], [Enabled]) VALUES (89, 2, 0, N'empty.png', N'·', N' ', NULL, 70, NULL, 1)
GO
INSERT [dbo].[MenuItem] ([ID], [MenuID], [PageID], [Image], [ImageAlt], [Text], [Link], [SortOrder], [Description], [Enabled]) VALUES (90, 2, 500, N'settingsDetail.png', N'System Settings', N'System Settings', NULL, 100, N'', 1)
GO
INSERT [dbo].[MenuItem] ([ID], [MenuID], [PageID], [Image], [ImageAlt], [Text], [Link], [SortOrder], [Description], [Enabled]) VALUES (91, 3, 200, N'settings.png', N'Settings', N'Settings', NULL, 10, NULL, 1)
GO
INSERT [dbo].[MenuItem] ([ID], [MenuID], [PageID], [Image], [ImageAlt], [Text], [Link], [SortOrder], [Description], [Enabled]) VALUES (92, 3, 0, N'empty.png', N'·', N'', NULL, 20, NULL, 1)
GO
INSERT [dbo].[MenuItem] ([ID], [MenuID], [PageID], [Image], [ImageAlt], [Text], [Link], [SortOrder], [Description], [Enabled]) VALUES (93, 3, 501, N'settingsDetail.png', N'Pages', N'System Pages', NULL, 30, NULL, 1)
GO
INSERT [dbo].[MenuItem] ([ID], [MenuID], [PageID], [Image], [ImageAlt], [Text], [Link], [SortOrder], [Description], [Enabled]) VALUES (94, 3, 502, N'settingsDetail.png', N'Menus', N'System Menus', NULL, 40, NULL, 1)
GO
INSERT [dbo].[MenuItem] ([ID], [MenuID], [PageID], [Image], [ImageAlt], [Text], [Link], [SortOrder], [Description], [Enabled]) VALUES (95, 3, 504, N'settingsDetail.png', N'Value Lists', N'System Value Lists', NULL, 50, NULL, 1)
GO
INSERT [dbo].[MenuItem] ([ID], [MenuID], [PageID], [Image], [ImageAlt], [Text], [Link], [SortOrder], [Description], [Enabled]) VALUES (96, 0, 91, N'sopepb.png', N'soe epb', N'SOE Epb', NULL, 1005, NULL, 1)
GO
INSERT [dbo].[MenuItem] ([ID], [MenuID], [PageID], [Image], [ImageAlt], [Text], [Link], [SortOrder], [Description], [Enabled]) VALUES (97, 0, 0, N'empty.png', N'.', N' ', NULL, 1009, NULL, 1)
GO
SET IDENTITY_INSERT [dbo].[MenuItem] OFF
GO
INSERT [dbo].[Node] ([ID], [Name], [Description], [Enabled], [CreatedOn], [CreatedBy], [UpdatedOn], [UpdatedBy]) VALUES (N'e8db85cf-f625-41d9-b58d-31663cea84d2', N'Default', N'Default node', 1, CAST(N'2016-02-22 19:57:14.203' AS DateTime), N'GPA\rcarroll', CAST(N'2016-02-22 19:57:14.203' AS DateTime), N'GPA\rcarroll')
GO
SET IDENTITY_INSERT [dbo].[Page] ON 
GO
INSERT [dbo].[Page] ([ID], [Name], [Title], [MenuID], [PageLocation], [ServerConfiguration], [ClientConfiguration], [IncludedRoles], [ExcludedRoles], [Description], [Enabled], [CreatedOn]) VALUES (1, N'Home', N'SOE Tools Dashboard', 1, N'~/', NULL, NULL, NULL, NULL, NULL, 1, CAST(N'2016-02-23 10:36:24.170' AS DateTime))
GO
INSERT [dbo].[Page] ([ID], [Name], [Title], [MenuID], [PageLocation], [ServerConfiguration], [ClientConfiguration], [IncludedRoles], [ExcludedRoles], [Description], [Enabled], [CreatedOn]) VALUES (2, N'Faults', N'Incidents', 1, N'~/Main/Faults', NULL, NULL, NULL, NULL, NULL, 1, CAST(N'2016-06-14 16:49:47.910' AS DateTime))
GO
INSERT [dbo].[Page] ([ID], [Name], [Title], [MenuID], [PageLocation], [ServerConfiguration], [ClientConfiguration], [IncludedRoles], [ExcludedRoles], [Description], [Enabled], [CreatedOn]) VALUES (3, N'VoltSource', N'SOE Voltage Source Dashboard', 1, N'~/Main/VoltSource', NULL, NULL, NULL, NULL, NULL, 1, CAST(N'2016-06-15 13:15:31.043' AS DateTime))
GO
INSERT [dbo].[Page] ([ID], [Name], [Title], [MenuID], [PageLocation], [ServerConfiguration], [ClientConfiguration], [IncludedRoles], [ExcludedRoles], [Description], [Enabled], [CreatedOn]) VALUES (10, N'CycleDataSOEPointView', N'Display SOE Data', 100, N'~/Main/CycleDataSOEPointView', NULL, NULL, N'', NULL, NULL, 1, CAST(N'2016-03-01 14:09:31.490' AS DateTime))
GO
INSERT [dbo].[Page] ([ID], [Name], [Title], [MenuID], [PageLocation], [ServerConfiguration], [ClientConfiguration], [IncludedRoles], [ExcludedRoles], [Description], [Enabled], [CreatedOn]) VALUES (20, N'IncidentEventCycleDataView', N'Incidents', 1, N'~/Main/IncidentEventCycleDataView', NULL, NULL, NULL, NULL, NULL, 1, CAST(N'2016-04-25 17:25:13.803' AS DateTime))
GO
INSERT [dbo].[Page] ([ID], [Name], [Title], [MenuID], [PageLocation], [ServerConfiguration], [ClientConfiguration], [IncludedRoles], [ExcludedRoles], [Description], [Enabled], [CreatedOn]) VALUES (70, N'History', N'Historical SOE Data', 1, N'~/Main/History', NULL, NULL, NULL, NULL, NULL, 1, CAST(N'2016-02-23 10:36:24.170' AS DateTime))
GO
INSERT [dbo].[Page] ([ID], [Name], [Title], [MenuID], [PageLocation], [ServerConfiguration], [ClientConfiguration], [IncludedRoles], [ExcludedRoles], [Description], [Enabled], [CreatedOn]) VALUES (80, N'Notification', N'SOE Notification Log', 1, N'~/Main/Notification', NULL, NULL, NULL, NULL, NULL, 0, CAST(N'2016-02-23 10:36:24.170' AS DateTime))
GO
INSERT [dbo].[Page] ([ID], [Name], [Title], [MenuID], [PageLocation], [ServerConfiguration], [ClientConfiguration], [IncludedRoles], [ExcludedRoles], [Description], [Enabled], [CreatedOn]) VALUES (91, N'SOEEpb', N'SOE Epb', 1, N'~/Main/DisplayPDF/SOEEpb', N'pdfLink=~/Docs/test.pdf', NULL, NULL, NULL, NULL, 1, CAST(N'2016-02-29 11:12:36.277' AS DateTime))
GO
INSERT [dbo].[Page] ([ID], [Name], [Title], [MenuID], [PageLocation], [ServerConfiguration], [ClientConfiguration], [IncludedRoles], [ExcludedRoles], [Description], [Enabled], [CreatedOn]) VALUES (100, N'Help', N'SOE Process Overview', 1, N'~/Main/Help', NULL, NULL, NULL, NULL, NULL, 1, CAST(N'2016-02-23 10:36:24.170' AS DateTime))
GO
INSERT [dbo].[Page] ([ID], [Name], [Title], [MenuID], [PageLocation], [ServerConfiguration], [ClientConfiguration], [IncludedRoles], [ExcludedRoles], [Description], [Enabled], [CreatedOn]) VALUES (200, N'Settings.Home', N'Application Settings Management', 2, N'~/Settings/Home', NULL, NULL, NULL, NULL, NULL, 1, CAST(N'2016-03-01 10:38:31.783' AS DateTime))
GO
INSERT [dbo].[Page] ([ID], [Name], [Title], [MenuID], [PageLocation], [ServerConfiguration], [ClientConfiguration], [IncludedRoles], [ExcludedRoles], [Description], [Enabled], [CreatedOn]) VALUES (210, N'Settings.Vendors', N'Manage Patch Sources', 2, N'~/Settings/Vendors', NULL, NULL, NULL, NULL, NULL, 0, CAST(N'2016-03-01 10:49:56.613' AS DateTime))
GO
INSERT [dbo].[Page] ([ID], [Name], [Title], [MenuID], [PageLocation], [ServerConfiguration], [ClientConfiguration], [IncludedRoles], [ExcludedRoles], [Description], [Enabled], [CreatedOn]) VALUES (220, N'Settings.Platforms', N'Manage Platforms', 2, N'~/Settings/Platforms', NULL, NULL, NULL, NULL, NULL, 0, CAST(N'2016-03-01 10:49:40.640' AS DateTime))
GO
INSERT [dbo].[Page] ([ID], [Name], [Title], [MenuID], [PageLocation], [ServerConfiguration], [ClientConfiguration], [IncludedRoles], [ExcludedRoles], [Description], [Enabled], [CreatedOn]) VALUES (230, N'Settings.BusinessUnits', N'Business Units', 2, N'~/Settings/BusinessUnits', NULL, NULL, NULL, NULL, NULL, 0, CAST(N'2016-03-01 10:49:12.690' AS DateTime))
GO
INSERT [dbo].[Page] ([ID], [Name], [Title], [MenuID], [PageLocation], [ServerConfiguration], [ClientConfiguration], [IncludedRoles], [ExcludedRoles], [Description], [Enabled], [CreatedOn]) VALUES (300, N'Security.Users', N'Manage Users', 2, N'~/Security/Users', NULL, NULL, N'Administrator', NULL, NULL, 1, CAST(N'2016-02-23 10:36:24.170' AS DateTime))
GO
INSERT [dbo].[Page] ([ID], [Name], [Title], [MenuID], [PageLocation], [ServerConfiguration], [ClientConfiguration], [IncludedRoles], [ExcludedRoles], [Description], [Enabled], [CreatedOn]) VALUES (310, N'Security.Groups', N'Manage Groups', 2, N'~/Security/Groups', NULL, NULL, N'Administrator', NULL, NULL, 1, CAST(N'2016-03-03 11:14:30.300' AS DateTime))
GO
INSERT [dbo].[Page] ([ID], [Name], [Title], [MenuID], [PageLocation], [ServerConfiguration], [ClientConfiguration], [IncludedRoles], [ExcludedRoles], [Description], [Enabled], [CreatedOn]) VALUES (500, N'System.Home', N'System Settings Management', 3, N'~/System/Home', NULL, NULL, N'Administrator', NULL, NULL, 1, CAST(N'2016-02-23 10:36:24.170' AS DateTime))
GO
INSERT [dbo].[Page] ([ID], [Name], [Title], [MenuID], [PageLocation], [ServerConfiguration], [ClientConfiguration], [IncludedRoles], [ExcludedRoles], [Description], [Enabled], [CreatedOn]) VALUES (501, N'System.Pages', N'Edit System Pages', 3, N'~/System/Pages', NULL, NULL, N'Administrator', NULL, NULL, 1, CAST(N'2016-02-23 10:36:24.170' AS DateTime))
GO
INSERT [dbo].[Page] ([ID], [Name], [Title], [MenuID], [PageLocation], [ServerConfiguration], [ClientConfiguration], [IncludedRoles], [ExcludedRoles], [Description], [Enabled], [CreatedOn]) VALUES (502, N'System.Menus', N'Edit System Menus', 3, N'~/System/Menus', NULL, NULL, N'Administrator', NULL, NULL, 1, CAST(N'2016-02-27 09:34:37.567' AS DateTime))
GO
INSERT [dbo].[Page] ([ID], [Name], [Title], [MenuID], [PageLocation], [ServerConfiguration], [ClientConfiguration], [IncludedRoles], [ExcludedRoles], [Description], [Enabled], [CreatedOn]) VALUES (503, N'System.MenuItems', N'Page Menu Items', 3, N'', NULL, NULL, N'Administrator', NULL, N'Pop-up only', 1, CAST(N'2016-02-23 10:36:24.170' AS DateTime))
GO
INSERT [dbo].[Page] ([ID], [Name], [Title], [MenuID], [PageLocation], [ServerConfiguration], [ClientConfiguration], [IncludedRoles], [ExcludedRoles], [Description], [Enabled], [CreatedOn]) VALUES (504, N'System.ValueListGroups', N'Edit Value Lists', 3, N'~/System/ValueListGroups', NULL, NULL, N'Administrator', NULL, NULL, 1, CAST(N'2016-02-23 10:36:24.170' AS DateTime))
GO
INSERT [dbo].[Page] ([ID], [Name], [Title], [MenuID], [PageLocation], [ServerConfiguration], [ClientConfiguration], [IncludedRoles], [ExcludedRoles], [Description], [Enabled], [CreatedOn]) VALUES (505, N'System.ValueListItems', N'Value List Items', 3, N'', NULL, NULL, N'Administrator', NULL, NULL, 1, CAST(N'2016-02-29 15:26:20.593' AS DateTime))
GO
INSERT [dbo].[Page] ([ID], [Name], [Title], [MenuID], [PageLocation], [ServerConfiguration], [ClientConfiguration], [IncludedRoles], [ExcludedRoles], [Description], [Enabled], [CreatedOn]) VALUES (900, N'External', N'External Page Reference', 100, N'', NULL, NULL, NULL, NULL, NULL, 1, CAST(N'2016-02-23 10:36:24.170' AS DateTime))
GO
SET IDENTITY_INSERT [dbo].[Page] OFF
GO
SET IDENTITY_INSERT [dbo].[Settings] ON 
GO
INSERT [dbo].[Settings] ([ID], [Scope], [Name], [Value], [ApplicationInstance], [Roles]) VALUES (1, N'layout.setting', N'menuImagePath', N'~/Images/Menu/', 0, N'Administrator')
GO
INSERT [dbo].[Settings] ([ID], [Scope], [Name], [Value], [ApplicationInstance], [Roles]) VALUES (2, N'page.default', N'pageImagePath', N'~/Images/{pageName}', 0, N'Administrator')
GO
INSERT [dbo].[Settings] ([ID], [Scope], [Name], [Value], [ApplicationInstance], [Roles]) VALUES (3, N'app.setting', N'applicationName', N'SOETools', 0, N'Administrator')
GO
INSERT [dbo].[Settings] ([ID], [Scope], [Name], [Value], [ApplicationInstance], [Roles]) VALUES (4, N'app.setting', N'applicationDescription', N'Sequence of Events Tools', 0, N'Administrator')
GO
INSERT [dbo].[Settings] ([ID], [Scope], [Name], [Value], [ApplicationInstance], [Roles]) VALUES (5, N'app.setting', N'applicationKeywords', N'open source, utility, software, SOE, management', 0, N'Administrator')
GO
INSERT [dbo].[Settings] ([ID], [Scope], [Name], [Value], [ApplicationInstance], [Roles]) VALUES (6, N'app.setting', N'bootstrapTheme', N'~/Content/bootstrap.min.css', 0, N'Administrator')
GO
INSERT [dbo].[Settings] ([ID], [Scope], [Name], [Value], [ApplicationInstance], [Roles]) VALUES (7, N'layout.setting', N'showCopyright', N'true', 0, N'Administrator')
GO
INSERT [dbo].[Settings] ([ID], [Scope], [Name], [Value], [ApplicationInstance], [Roles]) VALUES (8, N'layout.setting', N'copyrightText', N'Copyright © 2016, Grid Protection Alliance', 0, N'Administrator')
GO
INSERT [dbo].[Settings] ([ID], [Scope], [Name], [Value], [ApplicationInstance], [Roles]) VALUES (9, N'layout.setting', N'copyrightUrl', N'~/Main/Contact', 0, N'Administrator')
GO
SET IDENTITY_INSERT [dbo].[Settings] OFF
GO

SET IDENTITY_INSERT [dbo].[ValueList] ON 

GO
INSERT [dbo].[ValueList] ([ID], [GroupID], [Key], [Text], [AltText1], [AltText2], [Abbreviation], [Value], [Flag], [Description], [SortOrder], [IsDefault], [Hidden], [Enabled], [CreatedOn]) VALUES (1, 1, 1, N'24 Hrs', NULL, NULL, NULL, 1, 0, N'', 10, 0, 0, 1, CAST(N'2016-06-13 17:22:46.883' AS DateTime))
GO
INSERT [dbo].[ValueList] ([ID], [GroupID], [Key], [Text], [AltText1], [AltText2], [Abbreviation], [Value], [Flag], [Description], [SortOrder], [IsDefault], [Hidden], [Enabled], [CreatedOn]) VALUES (2, 1, 2, N'7 Days', NULL, NULL, NULL, 7, 0, N'', 20, 0, 0, 1, CAST(N'2016-06-13 17:23:10.330' AS DateTime))
GO
INSERT [dbo].[ValueList] ([ID], [GroupID], [Key], [Text], [AltText1], [AltText2], [Abbreviation], [Value], [Flag], [Description], [SortOrder], [IsDefault], [Hidden], [Enabled], [CreatedOn]) VALUES (3, 1, 3, N'30 Days', NULL, NULL, NULL, 30, 0, NULL, 30, 0, 0, 1, CAST(N'2016-06-13 19:02:32.660' AS DateTime))
GO
INSERT [dbo].[ValueList] ([ID], [GroupID], [Key], [Text], [AltText1], [AltText2], [Abbreviation], [Value], [Flag], [Description], [SortOrder], [IsDefault], [Hidden], [Enabled], [CreatedOn]) VALUES (4, 1, 4, N'90 Days', NULL, NULL, NULL, 90, 0, NULL, 40, 0, 0, 1, CAST(N'2016-06-13 19:02:48.130' AS DateTime))
GO
INSERT [dbo].[ValueList] ([ID], [GroupID], [Key], [Text], [AltText1], [AltText2], [Abbreviation], [Value], [Flag], [Description], [SortOrder], [IsDefault], [Hidden], [Enabled], [CreatedOn]) VALUES (5, 2, 1, N'800', NULL, NULL, NULL, 800, 0, N'', 10, 0, 0, 1, CAST(N'2016-06-13 19:16:00.913' AS DateTime))
GO
INSERT [dbo].[ValueList] ([ID], [GroupID], [Key], [Text], [AltText1], [AltText2], [Abbreviation], [Value], [Flag], [Description], [SortOrder], [IsDefault], [Hidden], [Enabled], [CreatedOn]) VALUES (6, 2, 2, N'1,500', NULL, NULL, NULL, 1500, 0, NULL, 20, 0, 0, 1, CAST(N'2016-06-13 19:16:48.110' AS DateTime))
GO
INSERT [dbo].[ValueList] ([ID], [GroupID], [Key], [Text], [AltText1], [AltText2], [Abbreviation], [Value], [Flag], [Description], [SortOrder], [IsDefault], [Hidden], [Enabled], [CreatedOn]) VALUES (7, 2, 3, N'3,000', NULL, NULL, NULL, 3000, 0, NULL, 30, 0, 0, 1, CAST(N'2016-06-13 19:17:04.450' AS DateTime))
GO
INSERT [dbo].[ValueList] ([ID], [GroupID], [Key], [Text], [AltText1], [AltText2], [Abbreviation], [Value], [Flag], [Description], [SortOrder], [IsDefault], [Hidden], [Enabled], [CreatedOn]) VALUES (8, 2, 4, N'4,500', NULL, NULL, NULL, 4500, 0, NULL, 40, 0, 0, 1, CAST(N'2016-06-13 19:17:17.953' AS DateTime))
GO
INSERT [dbo].[ValueList] ([ID], [GroupID], [Key], [Text], [AltText1], [AltText2], [Abbreviation], [Value], [Flag], [Description], [SortOrder], [IsDefault], [Hidden], [Enabled], [CreatedOn]) VALUES (9, 2, 5, N'6,000', NULL, NULL, NULL, 6000, 0, NULL, 60, 0, 0, 1, CAST(N'2016-06-13 19:17:38.763' AS DateTime))
GO
INSERT [dbo].[ValueList] ([ID], [GroupID], [Key], [Text], [AltText1], [AltText2], [Abbreviation], [Value], [Flag], [Description], [SortOrder], [IsDefault], [Hidden], [Enabled], [CreatedOn]) VALUES (10, 3, 1, N'1.1', NULL, NULL, NULL, 11, 0, NULL, 10, 0, 0, 1, CAST(N'2016-06-13 19:18:43.667' AS DateTime))
GO
INSERT [dbo].[ValueList] ([ID], [GroupID], [Key], [Text], [AltText1], [AltText2], [Abbreviation], [Value], [Flag], [Description], [SortOrder], [IsDefault], [Hidden], [Enabled], [CreatedOn]) VALUES (11, 3, 2, N'0.9', NULL, NULL, NULL, 9, 0, NULL, 20, 0, 0, 1, CAST(N'2016-06-13 19:18:56.117' AS DateTime))
GO
INSERT [dbo].[ValueList] ([ID], [GroupID], [Key], [Text], [AltText1], [AltText2], [Abbreviation], [Value], [Flag], [Description], [SortOrder], [IsDefault], [Hidden], [Enabled], [CreatedOn]) VALUES (12, 3, 3, N'0.7', NULL, NULL, NULL, 7, 0, NULL, 30, 0, 0, 1, CAST(N'2016-06-13 19:19:08.633' AS DateTime))
GO
INSERT [dbo].[ValueList] ([ID], [GroupID], [Key], [Text], [AltText1], [AltText2], [Abbreviation], [Value], [Flag], [Description], [SortOrder], [IsDefault], [Hidden], [Enabled], [CreatedOn]) VALUES (13, 3, 4, N'0.3', NULL, NULL, NULL, 3, 0, NULL, 40, 0, 0, 1, CAST(N'2016-06-13 19:19:28.243' AS DateTime))
GO
SET IDENTITY_INSERT [dbo].[ValueList] OFF
GO
SET IDENTITY_INSERT [dbo].[ValueListGroup] ON 

GO
INSERT [dbo].[ValueListGroup] ([ID], [Name], [Description], [Enabled], [CreatedOn]) VALUES (1, N'timeWindows', N'This will be the settings for Time periods used in dashboard tables', 1, CAST(N'2016-04-18 00:00:00.000' AS DateTime))
GO
INSERT [dbo].[ValueListGroup] ([ID], [Name], [Description], [Enabled], [CreatedOn]) VALUES (2, N'faultBin', N'settings for fault bin', 1, CAST(N'2016-06-13 19:14:35.980' AS DateTime))
GO
INSERT [dbo].[ValueListGroup] ([ID], [Name], [Description], [Enabled], [CreatedOn]) VALUES (3, N'voltageBin', N'settings for voltage bin, these will be save as integers and divided by ten on the front end to get decimal value.', 1, CAST(N'2016-06-13 19:17:59.820' AS DateTime))
GO
SET IDENTITY_INSERT [dbo].[ValueListGroup] OFF
GO
ALTER TABLE [dbo].[Document] ADD  CONSTRAINT [DF_Document_TypeValue]  DEFAULT ((6)) FOR [DocumentTypeKey]
GO
ALTER TABLE [dbo].[Document] ADD  CONSTRAINT [DF_Document_enabled]  DEFAULT ((1)) FOR [Enabled]
GO
ALTER TABLE [dbo].[Document] ADD  CONSTRAINT [DF_Document_dtCreated]  DEFAULT (getdate()) FOR [CreatedOn]
GO
ALTER TABLE [dbo].[NoticeLog] ADD  CONSTRAINT [DF_NoticeLog_dtCreated]  DEFAULT (getdate()) FOR [CreatedOn]
GO
ALTER TABLE [dbo].[ValueList] ADD  CONSTRAINT [DF_ValueList5_bitValue]  DEFAULT ((0)) FOR [Flag]
GO
ALTER TABLE [dbo].[ValueList] ADD  CONSTRAINT [DF_ValueList5_defaultValue]  DEFAULT ((0)) FOR [IsDefault]
GO
ALTER TABLE [dbo].[ValueList] ADD  CONSTRAINT [DF_ValueList5_private]  DEFAULT ((0)) FOR [Hidden]
GO
ALTER TABLE [dbo].[ValueList] ADD  CONSTRAINT [DF_ValueList5_enabled]  DEFAULT ((1)) FOR [Enabled]
GO
ALTER TABLE [dbo].[ValueList] ADD  CONSTRAINT [DF_ValueList5_dtCreated]  DEFAULT (getdate()) FOR [CreatedOn]
GO
ALTER TABLE [dbo].[ValueListGroup] ADD  CONSTRAINT [DF_ValueListGroup2_enabled]  DEFAULT ((1)) FOR [Enabled]
GO
ALTER TABLE [dbo].[ValueListGroup] ADD  CONSTRAINT [DF_ValueListGroup2_dtCreated]  DEFAULT (getdate()) FOR [CreatedOn]
GO

/****** Object:  Index [PK_Node]    Script Date: 1/16/2018 9:24:35 AM ******/
ALTER TABLE [dbo].[Node] ADD  CONSTRAINT [PK_Node] PRIMARY KEY NONCLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AccessLog] ADD  CONSTRAINT [DF_AccessLog_Timestamp]  DEFAULT (getutcdate()) FOR [CreatedOn]
GO
ALTER TABLE [dbo].[ApplicationRole] ADD  CONSTRAINT [DF_ApplicationRole_ID]  DEFAULT (newid()) FOR [ID]
GO
ALTER TABLE [dbo].[ApplicationRole] ADD  CONSTRAINT [DF_ApplicationRole_CreatedOn]  DEFAULT (getutcdate()) FOR [CreatedOn]
GO
ALTER TABLE [dbo].[ApplicationRole] ADD  CONSTRAINT [DF_ApplicationRole_CreatedBy]  DEFAULT (suser_name()) FOR [CreatedBy]
GO
ALTER TABLE [dbo].[ApplicationRole] ADD  CONSTRAINT [DF_ApplicationRole_UpdatedOn]  DEFAULT (getutcdate()) FOR [UpdatedOn]
GO
ALTER TABLE [dbo].[ApplicationRole] ADD  CONSTRAINT [DF_ApplicationRole_UpdatedBy]  DEFAULT (getutcdate()) FOR [UpdatedBy]
GO
ALTER TABLE [dbo].[ErrorLog] ADD  CONSTRAINT [DF_ErrorLog_CreatedOn]  DEFAULT (getutcdate()) FOR [CreatedOn]
GO
ALTER TABLE [dbo].[Menu] ADD  CONSTRAINT [DF_Menu2_CreatedOn]  DEFAULT (getdate()) FOR [CreatedOn]
GO
ALTER TABLE [dbo].[MenuItem] ADD  CONSTRAINT [DF_MenuItem2_MenuID]  DEFAULT ((1)) FOR [MenuID]
GO
ALTER TABLE [dbo].[MenuItem] ADD  CONSTRAINT [DF_MenuItem2_PageID]  DEFAULT ((1)) FOR [PageID]
GO
ALTER TABLE [dbo].[MenuItem] ADD  CONSTRAINT [DF_MenuItem2_image]  DEFAULT ('tbd.png') FOR [Image]
GO
ALTER TABLE [dbo].[MenuItem] ADD  CONSTRAINT [DF_MenuItem2_imageAlt]  DEFAULT ('Placekeeper') FOR [ImageAlt]
GO
ALTER TABLE [dbo].[MenuItem] ADD  CONSTRAINT [DF_MenuItem2_text]  DEFAULT ('MenuItem') FOR [Text]
GO
ALTER TABLE [dbo].[MenuItem] ADD  CONSTRAINT [DF_MenuItem2_enabled]  DEFAULT ((1)) FOR [Enabled]
GO
ALTER TABLE [dbo].[Node] ADD  CONSTRAINT [DF_Node_ID]  DEFAULT (newid()) FOR [ID]
GO
ALTER TABLE [dbo].[Node] ADD  CONSTRAINT [DF_Node_Enabled]  DEFAULT ((0)) FOR [Enabled]
GO
ALTER TABLE [dbo].[Node] ADD  CONSTRAINT [DF_Node_CreatedOn]  DEFAULT (getutcdate()) FOR [CreatedOn]
GO
ALTER TABLE [dbo].[Node] ADD  CONSTRAINT [DF_Node_CreatedBy]  DEFAULT (suser_name()) FOR [CreatedBy]
GO
ALTER TABLE [dbo].[Node] ADD  CONSTRAINT [DF_Node_UpdatedOn]  DEFAULT (getutcdate()) FOR [UpdatedOn]
GO
ALTER TABLE [dbo].[Node] ADD  CONSTRAINT [DF_Node_UpdatedBy]  DEFAULT (suser_name()) FOR [UpdatedBy]
GO
ALTER TABLE [dbo].[Page] ADD  CONSTRAINT [DF_Page4_menuID]  DEFAULT ((1)) FOR [MenuID]
GO
ALTER TABLE [dbo].[Page] ADD  CONSTRAINT [DF_Page4_PageLocation]  DEFAULT ('/') FOR [PageLocation]
GO
ALTER TABLE [dbo].[Page] ADD  CONSTRAINT [DF_Page4_enabled]  DEFAULT ((1)) FOR [Enabled]
GO
ALTER TABLE [dbo].[Page] ADD  CONSTRAINT [DF_Page4_CreatedOn]  DEFAULT (getdate()) FOR [CreatedOn]
GO
ALTER TABLE [dbo].[SecurityGroup] ADD  CONSTRAINT [DF_SecurityGroup_ID]  DEFAULT (newid()) FOR [ID]
GO
ALTER TABLE [dbo].[SecurityGroup] ADD  CONSTRAINT [DF_SecurityGroup_CreatedOn]  DEFAULT (getutcdate()) FOR [CreatedOn]
GO
ALTER TABLE [dbo].[SecurityGroup] ADD  CONSTRAINT [DF_SecurityGroup_CreatedBy]  DEFAULT (suser_name()) FOR [CreatedBy]
GO
ALTER TABLE [dbo].[SecurityGroup] ADD  CONSTRAINT [DF_SecurityGroup_UpdatedOn]  DEFAULT (getutcdate()) FOR [UpdatedOn]
GO
ALTER TABLE [dbo].[SecurityGroup] ADD  CONSTRAINT [DF_SecurityGroup_UpdatedBy]  DEFAULT (getutcdate()) FOR [UpdatedBy]
GO
ALTER TABLE [dbo].[Settings] ADD  CONSTRAINT [DF_Settings_Internal]  DEFAULT ((0)) FOR [ApplicationInstance]
GO
ALTER TABLE [dbo].[Settings] ADD  CONSTRAINT [DF_Settings_Roles]  DEFAULT ('Administrator, Owner') FOR [Roles]
GO
ALTER TABLE [dbo].[UserAccount] ADD  CONSTRAINT [DF_UserAccount_ID]  DEFAULT (newid()) FOR [ID]
GO
ALTER TABLE [dbo].[UserAccount] ADD  CONSTRAINT [DF_UserAccount_LockedOut]  DEFAULT ((0)) FOR [LockedOut]
GO
ALTER TABLE [dbo].[UserAccount] ADD  CONSTRAINT [DF_UserAccount_UseADAuthentication]  DEFAULT ((1)) FOR [UseADAuthentication]
GO
ALTER TABLE [dbo].[UserAccount] ADD  CONSTRAINT [DF_UserAccount_ChangePasswordOn]  DEFAULT (dateadd(day,(90),getutcdate())) FOR [ChangePasswordOn]
GO
ALTER TABLE [dbo].[UserAccount] ADD  CONSTRAINT [DF_UserAccount_CreatedOn]  DEFAULT (getutcdate()) FOR [CreatedOn]
GO
ALTER TABLE [dbo].[UserAccount] ADD  CONSTRAINT [DF_UserAccount_CreatedBy]  DEFAULT (suser_name()) FOR [CreatedBy]
GO
ALTER TABLE [dbo].[UserAccount] ADD  CONSTRAINT [DF_UserAccount_UpdatedOn]  DEFAULT (getutcdate()) FOR [UpdatedOn]
GO
ALTER TABLE [dbo].[UserAccount] ADD  CONSTRAINT [DF_UserAccount_UpdatedBy]  DEFAULT (suser_name()) FOR [UpdatedBy]
GO
ALTER TABLE [dbo].[ApplicationRole]  WITH CHECK ADD  CONSTRAINT [FK_ApplicationRole_Node] FOREIGN KEY([NodeID])
REFERENCES [dbo].[Node] ([ID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[ApplicationRole] CHECK CONSTRAINT [FK_ApplicationRole_Node]
GO
ALTER TABLE [dbo].[ApplicationRoleSecurityGroup]  WITH CHECK ADD  CONSTRAINT [FK_ApplicationRoleSecurityGroup_ApplicationRole] FOREIGN KEY([ApplicationRoleID])
REFERENCES [dbo].[ApplicationRole] ([ID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[ApplicationRoleSecurityGroup] CHECK CONSTRAINT [FK_ApplicationRoleSecurityGroup_ApplicationRole]
GO
ALTER TABLE [dbo].[ApplicationRoleSecurityGroup]  WITH CHECK ADD  CONSTRAINT [FK_ApplicationRoleSecurityGroup_SecurityGroup] FOREIGN KEY([SecurityGroupID])
REFERENCES [dbo].[SecurityGroup] ([ID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[ApplicationRoleSecurityGroup] CHECK CONSTRAINT [FK_ApplicationRoleSecurityGroup_SecurityGroup]
GO
ALTER TABLE [dbo].[ApplicationRoleUserAccount]  WITH CHECK ADD  CONSTRAINT [FK_ApplicationRoleUserAccount_ApplicationRole] FOREIGN KEY([ApplicationRoleID])
REFERENCES [dbo].[ApplicationRole] ([ID])
GO
ALTER TABLE [dbo].[ApplicationRoleUserAccount] CHECK CONSTRAINT [FK_ApplicationRoleUserAccount_ApplicationRole]
GO
ALTER TABLE [dbo].[ApplicationRoleUserAccount]  WITH CHECK ADD  CONSTRAINT [FK_ApplicationRoleUserAccount_UserAccount] FOREIGN KEY([UserAccountID])
REFERENCES [dbo].[UserAccount] ([ID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[ApplicationRoleUserAccount] CHECK CONSTRAINT [FK_ApplicationRoleUserAccount_UserAccount]
GO
ALTER TABLE [dbo].[SecurityGroupUserAccount]  WITH CHECK ADD  CONSTRAINT [FK_SecurityGroupUserAccount_SecurityGroup] FOREIGN KEY([SecurityGroupID])
REFERENCES [dbo].[SecurityGroup] ([ID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[SecurityGroupUserAccount] CHECK CONSTRAINT [FK_SecurityGroupUserAccount_SecurityGroup]
GO
ALTER TABLE [dbo].[SecurityGroupUserAccount]  WITH CHECK ADD  CONSTRAINT [FK_SecurityGroupUserAccount_UserAccount] FOREIGN KEY([UserAccountID])
REFERENCES [dbo].[UserAccount] ([ID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[SecurityGroupUserAccount] CHECK CONSTRAINT [FK_SecurityGroupUserAccount_UserAccount]
GO
ALTER TABLE [dbo].[UserAccount]  WITH CHECK ADD  CONSTRAINT [FK_UserAccount_Node] FOREIGN KEY([DefaultNodeID])
REFERENCES [dbo].[Node] ([ID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[UserAccount] CHECK CONSTRAINT [FK_UserAccount_Node]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The menu associated with this page.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Page', @level2type=N'COLUMN',@level2name=N'MenuID'
GO
