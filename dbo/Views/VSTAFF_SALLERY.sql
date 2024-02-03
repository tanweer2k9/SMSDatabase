CREATE VIEW dbo.VSTAFF_SALLERY
AS
SELECT        dbo.STAFF_SALLERY.STAFF_SALLERY_ID AS ID, dbo.STAFF_SALLERY.STAFF_SALLERY_HD_ID AS [Institute ID], dbo.STAFF_SALLERY.STAFF_SALLERY_BR_ID AS [Branch ID], 
                         dbo.STAFF_SALLERY.STAFF_SALLERY_STAFF_ID AS [Staff ID], dbo.TEACHER_INFO.TECH_EMPLOYEE_CODE AS [Emp Code], dbo.TEACHER_INFO.TECH_FIRST_NAME AS [Staff First Name], 
                         dbo.TEACHER_INFO.TECH_LAST_NAME AS [Staff Last Name], 
                         CASE WHEN dbo.TEACHER_INFO.TECH_LEAVES_TYPE = 'No Deduction' THEN 30 ELSE dbo.STAFF_SALLERY.STAFF_SALLERY_WORKING_DAYS END AS [Working Days], 
                         dbo.STAFF_SALLERY.STAFF_SALLERY_PRESENT + dbo.STAFF_SALLERY.STAFF_SALLERY_LATE AS [Total Presenets], dbo.STAFF_SALLERY.STAFF_SALLERY_ABSENTS AS [Total Absents], 
                         dbo.STAFF_SALLERY.STAFF_SALLERY_LATE AS [Late Days], dbo.STAFF_SALLERY.STAFF_SALLERY_LEAVES AS [Total Leaves], dbo.STAFF_SALLERY.STAFF_SALLERY_DATE AS Date, 
                         dbo.TEACHER_INFO.TECH_SALLERY AS Salary, DATENAME(MM, dbo.STAFF_SALLERY.STAFF_SALLERY_MONTH_DATE) + ' ' + CONVERT(nvarchar(5), DATEPART(YYYY, 
                         dbo.STAFF_SALLERY.STAFF_SALLERY_MONTH_DATE)) AS [Salary Month], dbo.STAFF_SALLERY.STAFF_SALLERY_GROSS_EARN AS [Total Earnings], 
                         dbo.STAFF_SALLERY.STAFF_SALLERY_GROSS_DEDUCT AS [Total Deductions], dbo.STAFF_SALLERY.STAFF_SALLERY_ABSENET_DEDUCT_AMOUNT AS [Absent Detuctions], 
                         dbo.STAFF_SALLERY.STAFF_SALLERY_NET_TOLTAL AS [Net Total], dbo.STAFF_SALLERY.STAFF_SALLERY_NET_STATUS AS Status, dbo.STAFF_SALLERY.STAFF_SALLERY_NET_RECEIVED AS [Net Recieved], 
                         dbo.TEACHER_INFO.TECH_GENDER AS Gender, dbo.TEACHER_INFO.TECH_DESIGNATION AS Designation, dbo.STAFF_SALLERY.STAFF_SALLERY_MONTH_SALARY AS [Month Salary], 
                         dbo.STAFF_SALLERY.STAFF_SALLERY_DEDUCT_DAYS AS [Deduct Days], ISNULL(dbo.STAFF_LEAVES_CALC.STAFF_LEAVES_CALC_MONTHLY_LIMIT, 0) AS [Leaves Limit], 
                         dbo.STAFF_SALLERY.STAFF_SALLERY_RECEIVED_DATE AS [Date Received], dbo.STAFF_SALLERY.STAFF_SALLERY_MONTH_DATE AS [Month Date], 
                         dbo.STAFF_SALLERY.STAFF_SALLERY_PER_DAY_SALARY AS [Per Day Salary], dbo.STAFF_SALLERY.STAFF_SALLERY_OVERTIME_TOTAL_HOURS AS [Total Overtime Hours], 
                         dbo.STAFF_SALLERY.STAFF_SALLERY_OVERTIME_PER_HOUR AS [Per Overtime Hour], dbo.DEPARTMENT_INFO.DEP_NAME AS Department, 
                         dbo.STAFF_SALLERY.STAFF_SALLERY_EARLY_DEPARTURE AS [Early Departure], dbo.STAFF_SALLERY.STAFF_SALLERY_HALF_DAYS AS [Half Days], dbo.DEPARTMENT_INFO.DEP_ID AS [Department ID], 
                         dbo.TEACHER_INFO.TECH_EMAIL AS Email, dbo.TEACHER_INFO.TECH_BANK_ACCOUNT_NO AS Account#, dbo.TEACHER_INFO.TECH_JOINING_DATE AS [Joining Date], 
                         dbo.TEACHER_INFO.TECH_CONFIRMATION_DATE AS [Confirmation Date], dbo.TEACHER_INFO.TECH_BANK_ID AS [Bank ID], dbo.DEPARTMENT_INFO.DEP_RANK AS [Department Rank], 
                         dbo.TEACHER_INFO.TECH_BANK_ACCOUNT_TITLE AS [Account Title], dbo.TEACHER_INFO.TECH_LEAVES_TYPE AS [Leaves Type], dbo.TEACHER_INFO.TECH_RANKING AS [Staff Rank], 
                         dbo.STAFF_LEAVES_CALC.STAFF_LEAVES_CALC_SANDWICH_DAYS AS [Sandwich Days], dbo.BANK_INFO.BANK_NAME AS [Bank Name]
FROM            dbo.STAFF_SALLERY INNER JOIN
                         dbo.TEACHER_INFO ON dbo.STAFF_SALLERY.STAFF_SALLERY_STAFF_ID = dbo.TEACHER_INFO.TECH_ID INNER JOIN
                         dbo.DEPARTMENT_INFO ON dbo.TEACHER_INFO.TECH_DEPARTMENT = dbo.DEPARTMENT_INFO.DEP_ID LEFT OUTER JOIN
                         dbo.STAFF_LEAVES_CALC ON dbo.STAFF_LEAVES_CALC.STAFF_LEAVES_CALC_STAFF_ID = dbo.STAFF_SALLERY.STAFF_SALLERY_STAFF_ID AND DATEADD(dd, 
                         - (DAY(dbo.STAFF_LEAVES_CALC.STAFF_LEAVES_CALC_DATE) - 1), dbo.STAFF_LEAVES_CALC.STAFF_LEAVES_CALC_DATE) = DATEADD(dd, - (DAY(dbo.STAFF_SALLERY.STAFF_SALLERY_MONTH_DATE) - 1), 
                         dbo.STAFF_SALLERY.STAFF_SALLERY_MONTH_DATE) LEFT OUTER JOIN
                         dbo.BANK_INFO ON dbo.BANK_INFO.BANK_ID = dbo.TEACHER_INFO.TECH_BANK_ID
GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 2, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'VSTAFF_SALLERY';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane2', @value = N'
         Or = 1350
         Or = 1350
      End
   End
End
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'VSTAFF_SALLERY';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane1', @value = N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[42] 4[14] 2[28] 3) )"
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
         Top = -288
         Left = 0
      End
      Begin Tables = 
         Begin Table = "STAFF_SALLERY"
            Begin Extent = 
               Top = 198
               Left = 38
               Bottom = 328
               Right = 397
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "TEACHER_INFO"
            Begin Extent = 
               Top = 330
               Left = 38
               Bottom = 460
               Right = 371
            End
            DisplayFlags = 280
            TopColumn = 42
         End
         Begin Table = "DEPARTMENT_INFO"
            Begin Extent = 
               Top = 462
               Left = 38
               Bottom = 592
               Right = 208
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "STAFF_LEAVES_CALC"
            Begin Extent = 
               Top = 294
               Left = 435
               Bottom = 424
               Right = 768
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "BANK_INFO"
            Begin Extent = 
               Top = 294
               Left = 806
               Bottom = 424
               Right = 980
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
         Column = 5040
         Alias = 4095
         Table = 3450
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'VSTAFF_SALLERY';

