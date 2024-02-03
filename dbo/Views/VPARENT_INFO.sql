CREATE VIEW [dbo].[VPARENT_INFO]
AS
SELECT        dbo.PARENT_INFO.PARNT_ID AS ID, dbo.PARENT_INFO.PARNT_HD_ID AS [Institute ID], dbo.PARENT_INFO.PARNT_BR_ID AS [Branch ID], 
                         dbo.PARENT_INFO.PARNT_FAMILY_CODE AS [Family Code], dbo.PARENT_INFO.PARNT_REG_BY_ID AS [Register By ID], 
                         dbo.PARENT_INFO.PARNT_REG_BY_TYPE AS Type, dbo.PARENT_INFO.PARNT_FULL_NAME AS [Full Name], 
                         dbo.PARENT_INFO.PARNT_FIRST_NAME AS [1st Relation Name], dbo.PARENT_INFO.PARNT_FIRST_NAME2 AS [2nd Relation Name], 
                         dbo.PARENT_INFO.PARNT_LAST_NAME AS [1st Relation Last Name], dbo.PARENT_INFO.PARNT_NATIONALITY AS [1st Relation Country], 
                         dbo.PARENT_INFO.PARNT_RELIGION AS [1st Relation Religion], dbo.PARENT_INFO.PARNT_DOB AS [1st Relation DOB], 
                         dbo.PARENT_INFO.PARNT_CNIC AS [1st Relation CNIC], dbo.PARENT_INFO.PARNT_OCCUPATION AS [1st Relation Occupation], 
                         dbo.PARENT_INFO.PARNT_MOTHR_LANG AS [1st Relation Language], dbo.PARENT_INFO.PARNT_CELL_NO AS [1st Relation Cell #], 
                         dbo.PARENT_INFO.PARNT_IMG AS [1st Relation Image], dbo.PARENT_INFO.PARNT_IMG2 AS [2nd Relation Image], 
                         dbo.PARENT_INFO.PARNT_EMAIL AS [1st Relation Email Address], dbo.PARENT_INFO.PARNT_RESIDENCE_NO AS [1st Relation Land Line #], 
                         dbo.PARENT_INFO.PARNT_OFFICE_NO AS [1st Relation Office #], dbo.PARENT_INFO.PARNT_TEMP_ADDR AS [1st Relation Temperory Address], 
                         dbo.PARENT_INFO.PARNT_PERM_ADDR AS [1st Relation Permanant Address], dbo.PARENT_INFO.PARNT_TEMP_ADDR2 AS [2nd Relation Temperory Address], 
                         dbo.PARENT_INFO.PARNT_PERM_ADDR2 AS [2nd Relation Permanant Address], dbo.PARENT_INFO.PARNT_OFFICE_NO2 AS [2nd Relation Office #], 
                         dbo.PARENT_INFO.PARNT_RESIDENCE_NO2 AS [2nd Relation Land Line #], dbo.PARENT_INFO.PARNT_CELL_NO2 AS [2nd Relation Cell #], 
                         dbo.PARENT_INFO.PARNT_EMAIL2 AS [2nd Relation Email Address], dbo.PARENT_INFO.PARNT_MOTHR_LANG2 AS [2nd Relation Language], 
                         dbo.PARENT_INFO.PARNT_OCCUPATION2 AS [2nd Relation Occupation], dbo.PARENT_INFO.PARNT_CNIC2 AS [2nd Relation CNIC], 
                         dbo.PARENT_INFO.PARNT_DOB2 AS [2nd Relation DOB], dbo.PARENT_INFO.PARNT_RELIGION2 AS [2nd Relation Religion], 
                         dbo.PARENT_INFO.PARNT_NATIONALITY2 AS [2nd Relation Country], dbo.PARENT_INFO.PARNT_LAST_NAME2 AS [2nd Relation Last Name], 
                         dbo.PARENT_INFO.PARNT_REG_DATE AS [Registered Date], dbo.PARENT_INFO.PARNT_STATUS AS Status, dbo.PARENT_INFO.PARNT_REG AS [1ST Relation], 
                         dbo.PARENT_INFO.PARNT_REG2 AS [2nd Relation], dbo.PARENT_INFO.PARNT_AREA AS [Area ID], dbo.PARENT_INFO.PARNT_CITY AS [City ID], 
                         dbo.AREA_INFO.AREA_NAME AS Area, dbo.CITY_INFO.CITY_NAME AS City
FROM            dbo.PARENT_INFO LEFT OUTER JOIN
                         dbo.AREA_INFO ON dbo.PARENT_INFO.PARNT_AREA = dbo.AREA_INFO.AREA_ID LEFT OUTER JOIN
                         dbo.CITY_INFO ON dbo.PARENT_INFO.PARNT_CITY = dbo.CITY_INFO.CITY_ID