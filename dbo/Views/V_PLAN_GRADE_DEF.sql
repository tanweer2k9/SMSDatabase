CREATE VIEW dbo.V_PLAN_GRADE_DEF
AS
SELECT        dbo.PLAN_GRADE_DEF.DEF_GRADE_ID AS ID, dbo.PLAN_GRADE_DEF.DEF_P_ID AS PID, dbo.GRADE_INFO.GRADE_NAME AS Grade, dbo.PLAN_GRADE_DEF.DEF_GRADE_MIN_LIMIT AS [Lower Limit], 
                         dbo.PLAN_GRADE_DEF.DEF_GRADE_MIN_OPERATOR AS [Lower Operator], dbo.PLAN_GRADE_DEF.DEF_GRADE_MAX_LIMIT AS [Upper Limit], dbo.PLAN_GRADE_DEF.DEF_GRADE_MAX_OPERATOR AS [Upper Operator], 
                         dbo.PLAN_GRADE_DEF.DEF_GRADE_DESCRIPTION AS Description, dbo.PLAN_GRADE_DEF.DEF_GRADE_STATUS AS Status, dbo.PLAN_GRADE_DEF.DEF_GRADE_INFO_ID AS [Grade ID], 
                         dbo.PLAN_GRADE_DEF.DEF_GRADE_POINTS AS [Grade Points]
FROM            dbo.PLAN_GRADE_DEF INNER JOIN
                         dbo.GRADE_INFO ON dbo.PLAN_GRADE_DEF.DEF_GRADE_INFO_ID = dbo.GRADE_INFO.GRADE_ID
GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'V_PLAN_GRADE_DEF';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane1', @value = N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[38] 4[29] 2[15] 3) )"
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
         Begin Table = "PLAN_GRADE_DEF"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 285
            End
            DisplayFlags = 280
            TopColumn = 6
         End
         Begin Table = "GRADE_INFO"
            Begin Extent = 
               Top = 138
               Left = 38
               Bottom = 268
               Right = 211
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
         Column = 3465
         Alias = 3345
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
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'V_PLAN_GRADE_DEF';

