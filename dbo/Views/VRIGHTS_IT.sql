﻿CREATE VIEW dbo.VRIGHTS_IT
AS
SELECT        RIGHTS_PAGES_ID AS ID, RIGHTS_PAGES_NAME AS [Page Name], RIGHTS_PAGES_TEXT AS [Page Text], RIGHTS_PAGES_PARENT_CODE AS [Page Parent Code], RIGHTS_PAGES_CHILD_CODE AS [Page Child Code], 
                         RIGHTS_PAGES_URL AS Url, RIGHTS_PAGES_COLOR AS Color, RIGHTS_PAGES_ICON AS Icon
FROM            dbo.RIGHTS_PAGES