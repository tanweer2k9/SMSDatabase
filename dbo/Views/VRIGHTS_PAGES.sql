﻿CREATE VIEW dbo.VRIGHTS_PAGES
AS
SELECT        dbo.RIGHTS_PAGES.RIGHTS_PAGES_ID AS ID, dbo.RIGHTS_PAGES.RIGHTS_PAGES_NAME AS [Page Name], dbo.RIGHTS_PAGES.RIGHTS_PAGES_TEXT AS [Page Text], 
                         dbo.RIGHTS_PAGES.RIGHTS_PAGES_PARENT_CODE AS [Page Parent Code], dbo.RIGHTS_PAGES.RIGHTS_PAGES_CHILD_CODE AS [Page Child Code], 
                         dbo.RIGHTS_PACKAGES_CHILD.PACKAGES_DEF_STATUS AS [Page Status], dbo.RIGHTS_PACKAGES_CHILD.PACKAGES_DEF_LOAD_STATUS AS [Load Status], dbo.RIGHTS_PACKAGES_PARENT.PACKAGES_ID AS [Package ID], 
                         dbo.RIGHTS_PACKAGES_PARENT.PACKAGES_NAME AS [Package Name], dbo.RIGHTS_PACKAGES_PARENT.PACKAGES_TYPE AS [Package Type], dbo.RIGHTS_PACKAGES_PARENT.PACKAGES_HD_ID AS [Institute ID], 
                         dbo.RIGHTS_PACKAGES_PARENT.PACKAGES_BR_ID AS [Branch ID], dbo.RIGHTS_PACKAGES_CHILD.PACKAGES_DEF_IS_DASHBOARD AS Dashboard, dbo.RIGHTS_PAGES.RIGHTS_PAGES_URL AS Url, 
                         dbo.RIGHTS_PAGES.RIGHTS_PAGES_COLOR AS Color, dbo.RIGHTS_PAGES.RIGHTS_PAGES_ICON AS Icon
FROM            dbo.RIGHTS_PAGES LEFT OUTER JOIN
                         dbo.RIGHTS_PACKAGES_CHILD ON dbo.RIGHTS_PAGES.RIGHTS_PAGES_ID = dbo.RIGHTS_PACKAGES_CHILD.PACKAGES_DEF_RIGHTS_PAGES_ID LEFT OUTER JOIN
                         dbo.RIGHTS_PACKAGES_PARENT ON dbo.RIGHTS_PACKAGES_PARENT.PACKAGES_ID = dbo.RIGHTS_PACKAGES_CHILD.PACKAGES_DEF_PID