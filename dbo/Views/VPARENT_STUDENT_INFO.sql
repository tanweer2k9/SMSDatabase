CREATE VIEW dbo.VPARENT_STUDENT_INFO
AS
SELECT     dbo.PARENT_INFO.PARNT_ID AS ID, dbo.PARENT_INFO.PARNT_HD_ID AS [Institute ID], dbo.PARENT_INFO.PARNT_BR_ID AS [Branch ID], 
                      dbo.PARENT_INFO.PARNT_FAMILY_CODE AS [Family Code], dbo.STUDENT_INFO.STDNT_SCHOOL_ID AS [Std School ID], 
                      dbo.STUDENT_INFO.STDNT_FIRST_NAME AS [Student Name], dbo.PARENT_INFO.PARNT_REG_BY_ID AS [Register By ID], 
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
                      dbo.PARENT_INFO.PARNT_REG2 AS [2nd Relation], dbo.STUDENT_INFO.STDNT_ID AS [Student ID]
FROM         dbo.PARENT_INFO LEFT OUTER JOIN
                      dbo.STUDENT_INFO ON dbo.PARENT_INFO.PARNT_ID = dbo.STUDENT_INFO.STDNT_PARANT_ID
GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'VPARENT_STUDENT_INFO';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane1', @value = N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[31] 4[30] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = -96
         Left = 0
      End
      Begin Tables = 
         Begin Table = "PARENT_INFO"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 258
            End
            DisplayFlags = 280
            TopColumn = 1
         End
         Begin Table = "STUDENT_INFO"
            Begin Extent = 
               Top = 138
               Left = 38
               Bottom = 268
               Right = 320
            End
            DisplayFlags = 280
            TopColumn = 1
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 2955
         Alias = 2550
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'VPARENT_STUDENT_INFO';

