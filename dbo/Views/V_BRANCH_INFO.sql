CREATE VIEW dbo.V_BRANCH_INFO
AS
SELECT DISTINCT 
                         dbo.BR_ADMIN.BR_ADM_ID AS ID, dbo.BR_ADMIN.BR_ADM_HD_ID AS [Institute ID], dbo.BR_ADMIN.BR_ADM_NAME AS Name, dbo.BR_ADMIN.BR_ADM_ADDRESS AS Address, dbo.BR_ADMIN.BR_ADM_PHONE AS Land_line, 
                         dbo.BR_ADMIN.BR_ADM_EMAIL AS Email, dbo.BR_ADMIN.BR_ADM_MOBILE AS Mobile, dbo.BR_ADMIN.BR_ADM_FAX AS Fax, dbo.BR_ADMIN.BR_ADM_STATUS AS Status, dbo.USER_INFO.USER_STATUS AS [Login Status], 
                         dbo.USER_INFO.USER_TYPE AS Type, dbo.BR_ADMIN.BR_ADM_CITY AS City, dbo.BR_ADMIN.BR_ADM_COUNTRY AS Country, dbo.BR_ADMIN.BR_ADM_ACCT_START_DATE AS [Start Date], 
                         dbo.BR_ADMIN.BR_ADM_ACCT_END_DATE AS [End Date], dbo.BR_ADMIN.BR_ADM_WEBSITE AS Website, dbo.FEE_SETTING.BR_ADM_FEE_HISTORY AS [Fee History], dbo.FEE_SETTING.FEE_SETTING_FINE AS [Fee Fine], 
                         dbo.FEE_SETTING.FEE_SETTING_FEE_CRITERIA AS [Fee Criteria], dbo.FEE_SETTING.FEE_SETTING_REPRINT_CHARGES AS [Fee Reprinting Charges], 
                         dbo.FEE_SETTING.FEE_SETTING_INVOICE_MOBILE_NO AS [Invoice Mobile No], dbo.WORKING_HOURS.WORKING_HOURS_TIME_IN AS [Time In], dbo.WORKING_HOURS.WORKING_HOURS_TIME_OUT AS [Time Out], 
                         dbo.FEE_SETTING.BR_ADM_FEE_HISTORY AS [Maintain Fee History], dbo.FEE_SETTING.FEE_SETTING_REPRINT_HISTORY AS [Maintain Reprint History], 
                         dbo.FEE_SETTING.FEE_SETTING_ARREARS_WITH_DUE_DATE AS [Arrears Within Due Date], dbo.BR_ADMIN.BR_ADM_BANK_NAME AS [Bank Name], dbo.BR_ADMIN.BR_ADM_ACCT_TITLE AS [Bank Acct Title], 
                         dbo.BR_ADMIN.BR_ADM_ACCT_NO AS [Bank Acct No], dbo.REPORT_SETTING.REPORT_SETTING_REPORT_NAME AS [Report Name], dbo.REPORT_SETTING.REPORT_SETTING_REPORT_VALUE AS [Report Value], 
                         dbo.BR_ADMIN.BR_ADM_STAFF_CENT_BR_ID AS [Staff Centralize ID], dbo.BR_ADMIN.BR_ADM_PARENT_CENT_BR_ID AS [Parent Centralize ID], dbo.BR_ADMIN.BR_ADM_ASSEMENT_TYPE AS [Assessment Type], 
                         dbo.USER_INFO.USER_PASSWORD AS Password, dbo.USER_INFO.USER_NAME AS [User Name], dbo.BR_ADMIN.BR_ADM_PAYROLL_MINUTES_IN_HOUR AS [Minutes in hour], 
                         dbo.BR_ADMIN.BR_ADM_PAYROLL_HOURS_IN_DAY AS [Hours in day], dbo.BR_ADMIN.BR_ADM_PAYROLL_IS_OVERTIME_MONTHLY_SLIP_GENERATE AS [Is Overtime Generate in Slip], 
                         dbo.BR_ADMIN.BR_ADM_PAYROLL_LATE_MINUTES AS [Late Minutes], dbo.BR_ADMIN.BR_ADM_PAYROLL_COMMSSION_FORMULA AS Commission, 
                         dbo.BR_ADMIN.BR_ADM_OVERTIME_AFTER_TIMEOUT AS [Overtime After Time Out], dbo.BR_ADMIN.BR_ADM_OVERTIME_CALCULATION_TYPE AS [Overtime Calculation Type], 
                         dbo.BR_ADMIN.BR_ADM_IS_ADVANCE_ACCOUNTING AS [Is Advance Accounting], dbo.BR_ADMIN.BR_ADM_IS_ADVANCE_CLASS_PLAN AS [Is Advacne Class Plan], 
                         dbo.BR_ADMIN.BR_ADM_IS_FEES_WITH_ACCOUNTS AS [Is Fees with Accounts], dbo.BR_ADMIN.BR_ADM_FEES_PER_MONTHS AS [Fees Per Month], 
                         dbo.BR_ADMIN.BR_ADM_STUDENT_LATE_MINUTES AS [Student Late Minutes], dbo.BR_ADMIN.BR_ADM_SESSION AS [Session ID], dbo.BR_ADMIN.BR_ADM_EARLY_MINUTES_ALLOWED AS [Early Minutes Allowed], 
                         dbo.BR_ADMIN.BR_ADM_HALF_DAY_MINUTES AS [Half Day Minutes], dbo.FeeChallanBankDetail.BankDetail1, dbo.FeeChallanBankDetail.BankDetail2, dbo.FeeChallanBankDetail.CareOfTitle
FROM            dbo.USER_INFO RIGHT OUTER JOIN
                         dbo.BR_ADMIN INNER JOIN
                         dbo.REPORT_SETTING ON dbo.BR_ADMIN.BR_ADM_ID = dbo.REPORT_SETTING.REPORT_SETTING_BR_ID ON dbo.USER_INFO.USER_BR_ID = dbo.BR_ADMIN.BR_ADM_ID AND 
                         dbo.USER_INFO.USER_HD_ID = dbo.BR_ADMIN.BR_ADM_HD_ID LEFT OUTER JOIN
                         dbo.FEE_SETTING ON dbo.BR_ADMIN.BR_ADM_ID = dbo.FEE_SETTING.FEE_SETTING_BR_ID LEFT OUTER JOIN
                         dbo.WORKING_HOURS ON dbo.BR_ADMIN.BR_ADM_ID = dbo.WORKING_HOURS.WORKING_HOURS_BR_ID AND dbo.BR_ADMIN.BR_ADM_HD_ID = dbo.WORKING_HOURS.WORKING_HOURS_HD_ID LEFT OUTER JOIN
                         dbo.FeeChallanBankDetail ON dbo.FeeChallanBankDetail.BrId = dbo.BR_ADMIN.BR_ADM_ID
WHERE        (dbo.USER_INFO.USER_TYPE = 'A') AND (dbo.USER_INFO.USER_STATUS <> 'D') AND (dbo.BR_ADMIN.BR_ADM_STATUS <> 'D') AND (dbo.USER_INFO.USER_ID NOT IN
                             (SELECT        TECH_USER_INFO_ID
                               FROM            dbo.TEACHER_INFO))
GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 2, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'V_BRANCH_INFO';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane2', @value = N' Column = 2730
         Alias = 3210
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
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'V_BRANCH_INFO';


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
         Begin Table = "USER_INFO"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 243
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "BR_ADMIN"
            Begin Extent = 
               Top = 138
               Left = 38
               Bottom = 268
               Right = 455
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "REPORT_SETTING"
            Begin Extent = 
               Top = 270
               Left = 38
               Bottom = 400
               Right = 309
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "FEE_SETTING"
            Begin Extent = 
               Top = 402
               Left = 38
               Bottom = 532
               Right = 346
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "WORKING_HOURS"
            Begin Extent = 
               Top = 534
               Left = 38
               Bottom = 664
               Right = 286
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "FeeChallanBankDetail"
            Begin Extent = 
               Top = 6
               Left = 281
               Bottom = 136
               Right = 451
            End
            DisplayFlags = 280
            TopColumn = 3
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
        ', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'V_BRANCH_INFO';

