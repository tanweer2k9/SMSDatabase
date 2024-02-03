
CREATE VIEW [dbo].[VTEACHER_INFO]
AS
SELECT        dbo.TEACHER_INFO.TECH_ID AS ID, dbo.TEACHER_INFO.TECH_HD_ID AS [Institute ID], dbo.TEACHER_INFO.TECH_BR_ID AS [Branch ID], dbo.TEACHER_INFO.TECH_EMPLOYEE_CODE AS [Employee Code], 
                         dbo.TEACHER_INFO.TECH_PARANT_ID AS [Parent ID], dbo.TEACHER_INFO.TECH_REG_BY_ID AS [Register By ID], dbo.TEACHER_INFO.TECH_REG_BY_TYPE AS Type, dbo.TEACHER_INFO.TECH_FIRST_NAME AS [First Name], 
                         dbo.TEACHER_INFO.TECH_LAST_NAME AS [Last Name], dbo.TEACHER_INFO.TECH_FIRST_NAME + N' ' + dbo.TEACHER_INFO.TECH_LAST_NAME AS Name, dbo.PARENT_INFO.PARNT_FULL_NAME AS [Parent Name], 
                         dbo.TEACHER_INFO.TECH_GENDER AS Gender, dbo.TEACHER_INFO.TECH_NATIONALITY AS Country, dbo.TEACHER_INFO.TECH_RELIGION AS Religion, dbo.TEACHER_INFO.TECH_DOB AS DOB, 
                         dbo.TEACHER_INFO.TECH_CNIC AS CNIC, dbo.TEACHER_INFO.TECH_CELL_NO AS [Contact #], dbo.TEACHER_INFO.TECH_RESIDENCE_NO AS [Land Line #], dbo.TEACHER_INFO.TECH_TEMP_ADDER AS [Temperory Address], 
                         dbo.TEACHER_INFO.TECH_PERM_ADDER AS [Permanant Address], dbo.TEACHER_INFO.TECH_MOTHR_LANG AS [Mother Language], dbo.TEACHER_INFO.TECH_QUALIFICATION AS Qualification, 
                         dbo.TEACHER_INFO.TECH_DESIGNATION AS Designation, dbo.TEACHER_INFO.TECH_EXPERIENCE AS Experience, dbo.TEACHER_INFO.TECH_JOINING_DATE AS [Joining Date], 
                         dbo.TEACHER_INFO.TECH_SALLERY AS [Basic Salary], dbo.TEACHER_INFO.TECH_EMAIL AS [Email Address], dbo.TEACHER_INFO.TECH_IMG AS Image, dbo.TEACHER_INFO.TECH_REG_DATE AS [Registered Date], 
                         dbo.TEACHER_INFO.TECH_STATUS AS Status, dbo.TEACHER_INFO.TECH_LEFT_DATE AS [Left Date], dbo.TEACHER_INFO.TECH_RANKING AS Ranking, dbo.TEACHER_INFO.TECH_IS_COMMISION AS [Is Commission], 
                         dbo.TEACHER_INFO.TECH_IS_OVERTIME AS [Is Overtime], dbo.TEACHER_INFO.TECH_CONFIRMATION_DURATION_MONTHS AS [Confiramtion Duration Months], 
                         dbo.TEACHER_INFO.TECH_CONFIRMATION_DATE AS [Confirmation Date], dbo.CITY_INFO.CITY_NAME AS City, dbo.TEACHER_INFO.TECH_CITY AS [City ID], dbo.TEACHER_INFO.TECH_DEPARTMENT AS Department, 
                         dbo.DEPARTMENT_INFO.DEP_NAME AS [Department Name], dbo.TEACHER_INFO.TECH_STAFF_TYPE AS [Employee Type ID], dbo.STAFF_TYPE_INFO.STAFF_TYPE_NAME AS [Employee Type], 
                         dbo.TEACHER_INFO.TECH_DEDUCTION_TYPE AS [Deduction Type], dbo.TEACHER_INFO.TECH_BANK_ACCOUNT_NO AS [Account No], dbo.TEACHER_INFO.TECH_BANK_ACCOUNT_TITLE AS [Account Title], 
                         dbo.TEACHER_INFO.TECH_BANK_ID AS [Bank ID], dbo.BANK_INFO.BANK_NAME AS [Bank Name], dbo.TEACHER_INFO.TECH_LEAVES_TYPE AS [Leaves Type], 
                         dbo.TEACHER_INFO.TECH_IS_VACATION_ALLOWED AS [Is Vacation Allowed], dbo.TEACHER_INFO.TECH_ID_DESIGNATION AS [ID Designation], dbo.TEACHER_INFO.TECH_ID_CARD_NAME AS [ID Card Name]
FROM            dbo.TEACHER_INFO LEFT OUTER JOIN
                         dbo.PARENT_INFO ON dbo.TEACHER_INFO.TECH_PARANT_ID = dbo.PARENT_INFO.PARNT_ID INNER JOIN
                         dbo.DEPARTMENT_INFO ON dbo.TEACHER_INFO.TECH_DEPARTMENT = dbo.DEPARTMENT_INFO.DEP_ID LEFT OUTER JOIN
                         dbo.BANK_INFO ON dbo.TEACHER_INFO.TECH_BANK_ID = dbo.BANK_INFO.BANK_ID LEFT OUTER JOIN
                         dbo.STAFF_TYPE_INFO ON dbo.TEACHER_INFO.TECH_STAFF_TYPE = dbo.STAFF_TYPE_INFO.STAFF_TYPE_ID LEFT OUTER JOIN
                         dbo.CITY_INFO ON dbo.TEACHER_INFO.TECH_CITY = dbo.CITY_INFO.CITY_ID
GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 2, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'VTEACHER_INFO';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane2', @value = N'Column = 2505
         Alias = 1740
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
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'VTEACHER_INFO';


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
         Begin Table = "TEACHER_INFO"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 371
            End
            DisplayFlags = 280
            TopColumn = 42
         End
         Begin Table = "PARENT_INFO"
            Begin Extent = 
               Top = 138
               Left = 38
               Bottom = 268
               Right = 258
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "DEPARTMENT_INFO"
            Begin Extent = 
               Top = 138
               Left = 296
               Bottom = 268
               Right = 466
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "BANK_INFO"
            Begin Extent = 
               Top = 6
               Left = 409
               Bottom = 136
               Right = 579
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "STAFF_TYPE_INFO"
            Begin Extent = 
               Top = 270
               Left = 38
               Bottom = 400
               Right = 239
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "CITY_INFO"
            Begin Extent = 
               Top = 270
               Left = 277
               Bottom = 400
               Right = 447
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
         ', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'VTEACHER_INFO';





