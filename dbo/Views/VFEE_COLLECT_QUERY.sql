CREATE VIEW dbo.VFEE_COLLECT_QUERY
AS
SELECT        dbo.FEE_COLLECT.FEE_COLLECT_ID AS ID, dbo.STUDENT_INFO.STDNT_HD_ID AS [Institute ID], dbo.STUDENT_INFO.STDNT_BR_ID AS [Branch ID], dbo.FEE_COLLECT.FEE_COLLECT_STD_ID AS [Student ID], 
                         dbo.STUDENT_INFO.STDNT_SCHOOL_ID AS [Student School ID], dbo.FEE_COLLECT.FEE_COLLECT_FEE AS [Current Fee], dbo.FEE_COLLECT.FEE_COLLECT_FEE_PAID AS [Fee Received], 
                         dbo.FEE_COLLECT.FEE_COLLECT_ARREARS AS Arrears, dbo.FEE_COLLECT.FEE_COLLECT_ARREARS_RECEIVED AS [Arrears Received], dbo.FEE_COLLECT.FEE_COLLECT_NET_TOATAL AS [Net Total], 
                         dbo.FEE_COLLECT.FEE_COLLECT_DATE_FEE_GENERATED AS Date, CASE WHEN (FEE_COLLECT.FEE_COLLECT_FEE_PAID + FEE_COLLECT.FEE_COLLECT_ARREARS_RECEIVED) < 1000 AND 
                         (FEE_COLLECT_FEE_STATUS = 'Partially Received' OR
                         FEE_COLLECT_FEE_STATUS = 'Partially Received') THEN 'Receivable' ELSE dbo.FEE_COLLECT.FEE_COLLECT_FEE_STATUS END AS Status, dbo.FEE_COLLECT.FEE_COLLECT_PLAN_ID AS [Class Plan], 
                         dbo.STUDENT_INFO.STDNT_FIRST_NAME AS Name, dbo.PARENT_INFO.PARNT_FIRST_NAME AS [Parent Name], dbo.SCHOOL_PLANE.CLASS_Name AS Class, dbo.SECTION_INFO.SECT_NAME AS Section, 
                         CASE WHEN DATEPART(MM, FEE_COLLECT_FEE_FROM_DATE) = DATEPART(MM, FEE_COLLECT_FEE_TO_DATE) THEN DATENAME(MONTH, FEE_COLLECT_FEE_FROM_DATE) + ' ' + DATENAME(YEAR, 
                         FEE_COLLECT_FEE_TO_DATE) ELSE DATENAME(MONTH, FEE_COLLECT_FEE_FROM_DATE) + ' - ' + DATENAME(MONTH, FEE_COLLECT_FEE_TO_DATE) + ' ' + DATENAME(YEAR, FEE_COLLECT_FEE_TO_DATE) 
                         END AS [Fee Months], dbo.FEE_COLLECT.FEE_COLLECT_DATE_FEE_RECEIVED AS [Date Received], dbo.STUDENT_INFO.STDNT_CELL_NO AS [Student Cell], dbo.PARENT_INFO.PARNT_CELL_NO AS [Parent Cell], 
                         dbo.STUDENT_INFO.STDNT_PARANT_ID AS [Parent ID], dbo.STUDENT_INFO.STDNT_STATUS AS [Student Status], f.PLAN_FEE_NOTES AS [Fee Notes], dbo.FEE_COLLECT.FEE_COLLECT_FEE_FROM_DATE AS [From Date], 
                         dbo.FEE_COLLECT.FEE_COLLECT_FEE_TO_DATE AS [To Date], dbo.FEE_COLLECT.FEE_COLLECT_INSTALLMENT_NAME AS [Installment Name], dbo.SCHOOL_PLANE.CLASS_ORDER AS CLassOrder, 
                         dbo.FEE_COLLECT.FEE_COLLECT_CHALLAN_NO AS [Challan No], dbo.FEE_COLLECT.FEE_COLLECT_BILL_NO AS [Bill No]
FROM            dbo.PARENT_INFO INNER JOIN
                         dbo.STUDENT_INFO ON dbo.PARENT_INFO.PARNT_ID = dbo.STUDENT_INFO.STDNT_PARANT_ID INNER JOIN
                         dbo.FEE_COLLECT ON dbo.STUDENT_INFO.STDNT_ID = dbo.FEE_COLLECT.FEE_COLLECT_STD_ID INNER JOIN
                         dbo.SCHOOL_PLANE ON dbo.FEE_COLLECT.FEE_COLLECT_PLAN_ID = dbo.SCHOOL_PLANE.CLASS_ID INNER JOIN
                         dbo.SECTION_INFO ON dbo.SCHOOL_PLANE.CLASS_SECTION = dbo.SECTION_INFO.SECT_ID LEFT OUTER JOIN
                         dbo.PLAN_FEE AS f ON f.PLAN_FEE_ID = dbo.STUDENT_INFO.STDNT_CLASS_FEE_ID
GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 2, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'VFEE_COLLECT_QUERY';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane2', @value = N'80
         Alias = 4155
         Table = 4455
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
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'VFEE_COLLECT_QUERY';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane1', @value = N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[29] 4[35] 2[33] 3) )"
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
         Top = -384
         Left = 0
      End
      Begin Tables = 
         Begin Table = "PARENT_INFO"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 114
               Right = 240
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "STUDENT_INFO"
            Begin Extent = 
               Top = 114
               Left = 38
               Bottom = 222
               Right = 289
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "FEE_COLLECT"
            Begin Extent = 
               Top = 330
               Left = 38
               Bottom = 438
               Right = 345
            End
            DisplayFlags = 280
            TopColumn = 30
         End
         Begin Table = "SCHOOL_PLANE"
            Begin Extent = 
               Top = 222
               Left = 38
               Bottom = 330
               Right = 286
            End
            DisplayFlags = 280
            TopColumn = 22
         End
         Begin Table = "SECTION_INFO"
            Begin Extent = 
               Top = 6
               Left = 278
               Bottom = 114
               Right = 429
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "f"
            Begin Extent = 
               Top = 6
               Left = 467
               Bottom = 136
               Right = 723
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
         Column = 34', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'VFEE_COLLECT_QUERY';



