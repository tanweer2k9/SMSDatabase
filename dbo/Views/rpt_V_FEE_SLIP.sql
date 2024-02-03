

CREATE VIEW [dbo].[rpt_V_FEE_SLIP]
AS
SELECT        dbo.FEE_COLLECT.FEE_COLLECT_ID AS ID, dbo.FEE_COLLECT.FEE_COLLECT_HD_ID AS [Institute ID], dbo.FEE_COLLECT.FEE_COLLECT_BR_ID AS [Branch ID], dbo.STUDENT_INFO.STDNT_FIRST_NAME AS [First Name], 
                         dbo.STUDENT_INFO.STDNT_LAST_NAME AS [Last Name], dbo.SCHOOL_PLANE.CLASS_Name AS Class, dbo.SECTION_INFO.SECT_NAME AS Section, dbo.STUDENT_INFO.STDNT_ID AS [Std ID], 
                         dbo.FEE_COLLECT.FEE_COLLECT_DATE_FEE_GENERATED AS Date, dbo.get_month_name(dbo.FEE_COLLECT.FEE_COLLECT_FEE_FROM_DATE, dbo.FEE_COLLECT.FEE_COLLECT_FEE_TO_DATE) AS Month, 
                         dbo.FEE_COLLECT.FEE_COLLECT_ARREARS AS Arrears, dbo.STUDENT_FEE_NOTES.STD_FEE_NOTES_DESCRIPTION AS Notes, dbo.STUDENT_FEE_NOTES.STD_FEE_NOTES_STATUS, 
                         dbo.FEE_COLLECT.FEE_COLLECT_FEE_STATUS AS Status, dbo.PARENT_INFO.PARNT_FIRST_NAME AS [Father Name], dbo.FEE_COLLECT.FEE_COLLECT_PLAN_ID AS [Class ID], 
                         dbo.BR_ADMIN.BR_ADM_BANK_NAME AS [Bank Name], dbo.BR_ADMIN.BR_ADM_ACCT_TITLE AS [Bank Acct Title], dbo.BR_ADMIN.BR_ADM_ACCT_NO AS [Bank Acct no], CASE WHEN LEN(DATENAME(MONTH, 
                         dbo.FEE_COLLECT.FEE_COLLECT_DUE_DAY)) > 5 THEN LEFT(DATENAME(MONTH, dbo.FEE_COLLECT.FEE_COLLECT_DUE_DAY), 3) + '.' ELSE DATENAME(MONTH, dbo.FEE_COLLECT.FEE_COLLECT_DUE_DAY) 
                         END + '  ' + CAST(DATEPART(DAY, dbo.FEE_COLLECT.FEE_COLLECT_DUE_DAY) AS nvarchar(50)) + ', ' + CAST(DATEPART(YEAR, dbo.FEE_COLLECT.FEE_COLLECT_DUE_DAY) AS nvarchar(50)) AS [Due Date], 
                         dbo.FEE_COLLECT.FEE_COLLECT_FEE_FROM_DATE AS [Start Date], dbo.FEE_COLLECT.FEE_COLLECT_FEE_TO_DATE AS [End Date], dbo.STUDENT_INFO.STDNT_SCHOOL_ID AS [School ID], 
                         dbo.PARENT_INFO.PARNT_CELL_NO AS [Parent Cell], dbo.STUDENT_INFO.STDNT_CELL_NO AS [Student Cell], dbo.FEE_COLLECT.FEE_COLLECT_ATTENDANCE_FROM_DATE AS [Attendance From Date], 
                         dbo.FEE_COLLECT.FEE_COLLECT_ATTENDANCE_TO_DATE AS [Attendance To Date], dbo.PARENT_INFO.PARNT_TEMP_ADDR + ' ' + dbo.AREA_INFO.AREA_NAME + ' ' + dbo.CITY_INFO.CITY_NAME AS [Parent Address], 
                         dbo.PARENT_INFO.PARNT_FAMILY_CODE AS [Family Code], dbo.FEE_SETTING.FEE_SETTING_FINE AS [Late Fee Fine], dbo.FEE_SETTING.FEE_SETTING_REPRINT_CHARGES AS [Reprinting Charges], 
                         dbo.STUDENT_INFO.STDNT_PARANT_ID AS [Parent ID], dbo.FEE_COLLECT.FEE_COLLECT_INSTALLMENT_NAME AS [Installment Name], dbo.BR_ADMIN.BR_ADM_NAME AS [Branch Name], 
                         dbo.MAIN_HD_INFO.MAIN_INFO_LOGO_REPORTS AS [Logo Reports], dbo.FEE_COLLECT.FEE_COLLECT_NET_TOATAL AS [Net Total], dbo.SCHOOL_PLANE.CLASS_ORDER AS ClassOrder, 
                         dbo.FeeChallanBankDetail.BankDetail1, dbo.FeeChallanBankDetail.BankDetail2, dbo.FeeChallanBankDetail.CareOfTitle, dbo.FeeChallanBankDetail.SchoolCopyInstruction, dbo.FeeChallanBankDetail.ParentCopyInstruction, 
                         dbo.FeeChallanBankDetail.IsTotalFeeOnFeeChallan, dbo.FEE_COLLECT.FEE_COLLECT_BILL_NO AS BillNo, dbo.FEE_COLLECT.FEE_COLLECT_CHALLAN_NO AS ChallanNo, dbo.FeeChallanBankDetail.BankCopyInstruction, 
                         CASE WHEN LEN(DATENAME(MONTH, dbo.FEE_COLLECT.FEE_COLLECT_VALID_DATE)) > 5 THEN LEFT(DATENAME(MONTH, dbo.FEE_COLLECT.FEE_COLLECT_VALID_DATE), 3) + '.' ELSE DATENAME(MONTH, 
                         dbo.FEE_COLLECT.FEE_COLLECT_VALID_DATE) END + '  ' + CAST(DATEPART(DAY, dbo.FEE_COLLECT.FEE_COLLECT_VALID_DATE) AS nvarchar(50)) + ', ' + CAST(DATEPART(YEAR, 
                         dbo.FEE_COLLECT.FEE_COLLECT_VALID_DATE) AS nvarchar(50)) AS ValidDate, dbo.PARENT_INFO.PARNT_EMAIL AS ParentEmail
FROM            dbo.FEE_COLLECT INNER JOIN
                         dbo.STUDENT_INFO ON dbo.FEE_COLLECT.FEE_COLLECT_STD_ID = dbo.STUDENT_INFO.STDNT_ID INNER JOIN
                         dbo.SCHOOL_PLANE ON dbo.FEE_COLLECT.FEE_COLLECT_PLAN_ID = dbo.SCHOOL_PLANE.CLASS_ID LEFT OUTER JOIN
                         dbo.STUDENT_FEE_NOTES ON dbo.FEE_COLLECT.FEE_COLLECT_HD_ID = dbo.STUDENT_FEE_NOTES.STD_FEE_NOTES_HD_ID AND 
                         dbo.FEE_COLLECT.FEE_COLLECT_BR_ID = dbo.STUDENT_FEE_NOTES.STD_FEE_NOTES_BR_ID AND dbo.SCHOOL_PLANE.CLASS_ID = dbo.STUDENT_FEE_NOTES.STD_FEE_NOTES_CLASS_ID INNER JOIN
                         dbo.PARENT_INFO ON dbo.STUDENT_INFO.STDNT_PARANT_ID = dbo.PARENT_INFO.PARNT_ID LEFT OUTER JOIN
                         dbo.BR_ADMIN ON dbo.STUDENT_INFO.STDNT_BR_ID = dbo.BR_ADMIN.BR_ADM_ID INNER JOIN
                         dbo.CLASS_INFO ON dbo.SCHOOL_PLANE.CLASS_CLASS = dbo.CLASS_INFO.CLASS_ID INNER JOIN
                         dbo.SECTION_INFO ON dbo.SCHOOL_PLANE.CLASS_SECTION = dbo.SECTION_INFO.SECT_ID INNER JOIN
                         dbo.AREA_INFO ON dbo.PARENT_INFO.PARNT_AREA = dbo.AREA_INFO.AREA_ID INNER JOIN
                         dbo.CITY_INFO ON dbo.PARENT_INFO.PARNT_CITY = dbo.CITY_INFO.CITY_ID INNER JOIN
                         dbo.MAIN_HD_INFO ON dbo.FEE_COLLECT.FEE_COLLECT_HD_ID = dbo.MAIN_HD_INFO.MAIN_INFO_ID LEFT OUTER JOIN
                         dbo.FEE_SETTING ON dbo.FEE_SETTING.FEE_SETTING_BR_ID = dbo.BR_ADMIN.BR_ADM_ID LEFT OUTER JOIN
                         dbo.FeeChallanBankDetail ON dbo.FeeChallanBankDetail.BrId = dbo.BR_ADMIN.BR_ADM_ID
GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 2, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'rpt_V_FEE_SLIP';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane2', @value = N'nd
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "SECTION_INFO"
            Begin Extent = 
               Top = 114
               Left = 327
               Bottom = 222
               Right = 478
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "AREA_INFO"
            Begin Extent = 
               Top = 416
               Left = 281
               Bottom = 544
               Right = 434
            End
            DisplayFlags = 280
            TopColumn = 2
         End
         Begin Table = "CITY_INFO"
            Begin Extent = 
               Top = 439
               Left = 449
               Bottom = 570
               Right = 616
            End
            DisplayFlags = 280
            TopColumn = 2
         End
         Begin Table = "MAIN_HD_INFO"
            Begin Extent = 
               Top = 29
               Left = 550
               Bottom = 159
               Right = 860
            End
            DisplayFlags = 280
            TopColumn = 20
         End
         Begin Table = "FEE_SETTING"
            Begin Extent = 
               Top = 654
               Left = 38
               Bottom = 762
               Right = 328
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "FeeChallanBankDetail"
            Begin Extent = 
               Top = 198
               Left = 514
               Bottom = 351
               Right = 782
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
         Column = 11085
         Alias = 4785
         Table = 4065
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
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'rpt_V_FEE_SLIP';










GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane1', @value = N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[32] 4[41] 2[27] 3) )"
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
               Bottom = 114
               Right = 345
            End
            DisplayFlags = 280
            TopColumn = 30
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
         Begin Table = "SCHOOL_PLANE"
            Begin Extent = 
               Top = 222
               Left = 38
               Bottom = 330
               Right = 283
            End
            DisplayFlags = 280
            TopColumn = 22
         End
         Begin Table = "STUDENT_FEE_NOTES"
            Begin Extent = 
               Top = 330
               Left = 38
               Bottom = 438
               Right = 274
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "PARENT_INFO"
            Begin Extent = 
               Top = 438
               Left = 38
               Bottom = 546
               Right = 240
            End
            DisplayFlags = 280
            TopColumn = 39
         End
         Begin Table = "BR_ADMIN"
            Begin Extent = 
               Top = 546
               Left = 38
               Bottom = 654
               Right = 420
            End
            DisplayFlags = 280
            TopColumn = 41
         End
         Begin Table = "CLASS_INFO"
            Begin Extent = 
               Top = 222
               Left = 321
               Bottom = 330
               Right = 476
            E', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'rpt_V_FEE_SLIP';







