
CREATE VIEW [dbo].[VFEE_COLLECT]
AS
SELECT        FEE_COLLECT_ID AS ID, FEE_COLLECT_HD_ID AS [Institute ID], FEE_COLLECT_BR_ID AS [Branch ID], FEE_COLLECT_STD_ID AS [Student ID], FEE_COLLECT_PLAN_ID AS [Class Plan], FEE_COLLECT_FEE_ID AS [Fee Plan], 
                         FEE_COLLECT_FEE AS [Current Fee], FEE_COLLECT_FEE_PAID AS [Fee Received], FEE_COLLECT_ARREARS AS Arrears, FEE_COLLECT_ARREARS_RECEIVED AS [Arrears Received], FEE_COLLECT_NET_TOATAL AS [Net Total], 
                         FEE_COLLECT_DATE_FEE_GENERATED AS Date, FEE_COLLECT_FEE_STATUS AS Status, CASE WHEN DATEPART(MM, FEE_COLLECT_FEE_FROM_DATE) = DATEPART(MM, FEE_COLLECT_FEE_TO_DATE) 
                         THEN DATENAME(MONTH, FEE_COLLECT_FEE_FROM_DATE) ELSE DATENAME(MONTH, FEE_COLLECT_FEE_FROM_DATE) + ' - ' + DATENAME(MONTH, FEE_COLLECT_FEE_TO_DATE) END AS [Fee Months], 
                         FEE_COLLECT_DATE_FEE_RECEIVED AS [Date Received], FEE_COLLECT_DUE_DAY AS [Due Day], FEE_COLLECT_OPB AS [Openeing Balance], FEE_COLLECT_LATE_FEE_STATUS AS [Late Fee Status], 
                         CASE WHEN DATEPART(MM, FEE_COLLECT_FEE_FROM_DATE) = DATEPART(MM, FEE_COLLECT_FEE_TO_DATE) THEN LEFT(DATENAME(MONTH, FEE_COLLECT_FEE_FROM_DATE), 3) ELSE LEFT(DATENAME(MONTH, 
                         FEE_COLLECT_FEE_FROM_DATE), 3) + ' ' + CONVERT(nvarchar(5), DATEPART(YYYY, FEE_COLLECT_FEE_FROM_DATE)) + ' - ' + LEFT(DATENAME(MONTH, FEE_COLLECT_FEE_TO_DATE), 3) END + ' ' + CONVERT(nvarchar(15), 
                         DATEPART(YYYY, FEE_COLLECT_FEE_TO_DATE)) AS [short Month Year], FEE_COLLECT_ATTENDANCE_FROM_DATE AS [Attendance From Date], FEE_COLLECT_ATTENDANCE_TO_DATE AS [Attendance To Date], 
                         FEE_COLLECT_NOT_CLEARED_BANK_AMOUNT AS [Bank Amount], FEE_COLLECT_PAYMENT_MODE AS [Payment Mode], FEE_COLLECT_FEE_FROM_DATE AS [From Date], FEE_COLLECT_FEE_TO_DATE AS [To Date], 
                         FEE_COLLECT_INSTALLMENT_NAME AS Installement
FROM            dbo.FEE_COLLECT
GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'VFEE_COLLECT';


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
         Begin Table = "FEE_COLLECT"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 377
            End
            DisplayFlags = 280
            TopColumn = 24
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
         Column = 3225
         Alias = 2790
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
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'VFEE_COLLECT';

