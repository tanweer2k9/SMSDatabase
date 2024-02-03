CREATE VIEW dbo.VSTAFF_WORKING_DAYS
AS
SELECT        dbo.STAFF_WORKING_DAYS.STAFF_WORKING_DAYS_NAME AS Day, dbo.STAFF_WORKING_DAYS.STAFF_WORKING_DAYS_BR_ID AS BrId, 
                         dbo.STAFF_WORKING_DAYS.STAFF_WORKING_DAYS_DAY_STATUS AS Status, dbo.STAFF_WORKING_DAYS.STAFF_WORKING_DAYS_TIME_IN AS TimeIn, 
                         dbo.STAFF_WORKING_DAYS.STAFF_WORKING_DAYS_TIME_OUT AS TimeOut, dbo.TEACHER_INFO.TECH_FIRST_NAME AS StaffName, dbo.DEPARTMENT_INFO.DEP_NAME AS Department, 
                         dbo.DEPARTMENT_INFO.DEP_RANK AS DeptRank, dbo.TEACHER_INFO.TECH_RANKING AS TechRank, dbo.WORKING_HOURS_PACKAGES.HOURS_PACK_NAME AS PackageName
FROM            dbo.STAFF_WORKING_DAYS INNER JOIN
                         dbo.TEACHER_INFO ON dbo.STAFF_WORKING_DAYS.STAFF_WORKING_DAYS_STAFF_ID = dbo.TEACHER_INFO.TECH_ID INNER JOIN
                         dbo.DEPARTMENT_INFO ON dbo.TEACHER_INFO.TECH_DEPARTMENT = dbo.DEPARTMENT_INFO.DEP_ID INNER JOIN
                         dbo.WORKING_HOURS_PACKAGES ON dbo.STAFF_WORKING_DAYS.STAFF_WORKING_DAYS_PACKAGE_ID = dbo.WORKING_HOURS_PACKAGES.HOURS_PACK_ID
WHERE        (dbo.TEACHER_INFO.TECH_STATUS = 'T') AND (dbo.STAFF_WORKING_DAYS.STAFF_WORKING_DAYS_DAY_STATUS = 'T')
GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'VSTAFF_WORKING_DAYS';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane1', @value = N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
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
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "STAFF_WORKING_DAYS"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 328
            End
            DisplayFlags = 280
            TopColumn = 8
         End
         Begin Table = "TEACHER_INFO"
            Begin Extent = 
               Top = 6
               Left = 366
               Bottom = 136
               Right = 699
            End
            DisplayFlags = 280
            TopColumn = 30
         End
         Begin Table = "DEPARTMENT_INFO"
            Begin Extent = 
               Top = 6
               Left = 737
               Bottom = 136
               Right = 907
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "WORKING_HOURS_PACKAGES"
            Begin Extent = 
               Top = 6
               Left = 945
               Bottom = 136
               Right = 1155
            End
            DisplayFlags = 280
            TopColumn = 0
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
         Column = 3405
         Alias = 6000
         Table = 1170
         Output = 1215
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
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'VSTAFF_WORKING_DAYS';

