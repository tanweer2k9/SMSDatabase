CREATE VIEW dbo.VPLAN_FEE_DEF
AS
SELECT        dbo.PLAN_FEE_DEF.PLAN_FEE_DEF_ID AS ID, dbo.FEE_INFO.FEE_NAME AS [Fee Name], dbo.PLAN_FEE_DEF.PLAN_FEE_DEF_FEE AS Fee, dbo.PLAN_FEE_DEF.PLAN_FEE_DEF_FEE_MIN AS [Min Fee Variation %], 
                         dbo.PLAN_FEE_DEF.PLAN_FEE_DEF_FEE_MAX AS [Max Fee Variation %], dbo.PLAN_FEE_DEF.PLAN_FEE_DEF_STATUS AS Status, dbo.PLAN_FEE_DEF.PLAN_FEE_OPERATION AS Operation, 
                         dbo.FEE_INFO.FEE_TYPE AS [Fee Type], CASE WHEN dbo.PLAN_FEE_DEF.PLAN_FEE_IS_ONCE_PAID = 'T' THEN CAST(1 AS bit) ELSE CAST(0 AS bit) END AS [Is Once Paid], dbo.FEE_INFO.FEE_MONTHS AS [Fee Months], 
                         dbo.PLAN_FEE_DEF.PLAN_FEE_DEF_PLAN_ID AS [Plan ID]
FROM            dbo.PLAN_FEE_DEF INNER JOIN
                         dbo.FEE_INFO ON dbo.PLAN_FEE_DEF.PLAN_FEE_DEF_FEE_NAME = dbo.FEE_INFO.FEE_ID
GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'VPLAN_FEE_DEF';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane1', @value = N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[41] 4[20] 2[28] 3) )"
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
         Begin Table = "PLAN_FEE_DEF"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 267
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "FEE_INFO"
            Begin Extent = 
               Top = 138
               Left = 38
               Bottom = 268
               Right = 263
            End
            DisplayFlags = 280
            TopColumn = 7
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
         Column = 1440
         Alias = 6555
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
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'VPLAN_FEE_DEF';

