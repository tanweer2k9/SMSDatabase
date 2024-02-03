CREATE VIEW [dbo].[VSTUDENT_INFO]
AS
SELECT DISTINCT 
                         dbo.STUDENT_INFO.STDNT_ID AS ID, dbo.STUDENT_INFO.STDNT_SCHOOL_ID AS [Student School ID], dbo.STUDENT_INFO.STDNT_REGISTRATION_ID AS [Student Registration ID], 
                         dbo.STUDENT_INFO.STDNT_HD_ID AS [Institute ID], dbo.STUDENT_INFO.STDNT_BR_ID AS [Branch ID], dbo.STUDENT_INFO.STDNT_PARANT_ID AS [Parent ID], dbo.STUDENT_INFO.STDNT_CLASS_FEE_ID AS [Fee ID], 
                         dbo.STUDENT_INFO.STDNT_FIRST_NAME AS [First Name], dbo.STUDENT_INFO.STDNT_LAST_NAME AS [Last Name], dbo.PARENT_INFO.PARNT_FIRST_NAME AS [Parent Name], 
                         dbo.PARENT_INFO.PARNT_FAMILY_CODE AS [Family Code], dbo.SCHOOL_PLANE.CLASS_Name AS [Class Plan], dbo.PLAN_FEE.PLAN_FEE_NAME AS [Fee Plan], dbo.STUDENT_INFO.STDNT_REG_BY_ID AS [Register By ID], 
                         dbo.STUDENT_INFO.STDNT_REG_BY_TYPE AS Type, CONVERT(NVARCHAR(10), dbo.STUDENT_INFO.STDNT_GENDER) AS Gender, dbo.STUDENT_INFO.STDNT_NATIONALITY AS Country, 
                         dbo.STUDENT_INFO.STDNT_RELIGION AS Religion, dbo.STUDENT_INFO.STDNT_DOB AS DOB, dbo.STUDENT_INFO.STDNT_PREVIOUS_SCHOOL AS [Previous School], 
                         dbo.STUDENT_INFO.STDNT_MOTHR_LANG AS [Mother Language], dbo.STUDENT_INFO.STDNT_EMERGENCY_CNTCT_NAME AS [Emergency Contact Name], 
                         dbo.STUDENT_INFO.STDNT_EMERGENCY_CNTCT_NO AS [Emergency Contact Cell #], dbo.STUDENT_INFO.STDNT_CELL_NO AS [Cell #], dbo.STUDENT_INFO.STDNT_TEMP_ADDR AS [Temperory Address], 
                         dbo.STUDENT_INFO.STDNT_PERM_ADDR AS [Permanant Address], dbo.STUDENT_INFO.STDNT_TRANSPORT_MODE AS Transport, dbo.STUDENT_INFO.STDNT_EMAIL AS [Email Address], 
                         dbo.STUDENT_INFO.STDNT_IMG AS Image, dbo.STUDENT_INFO.STDNT_REG_DATE AS [Registered Date], dbo.STUDENT_INFO.STDNT_CLASSES_START_DATE AS DOA, dbo.STUDENT_INFO.STDNT_STATUS AS Status, 
                         CONVERT(NVARCHAR(10), dbo.STUDENT_INFO.STDNT_CLASSES_START_DATE) AS Date, dbo.STUDENT_INFO.STDNT_SESSION_ID AS [Session ID], dbo.STUDENT_INFO.STDNT_DESCRIPTION AS Description, 
                         dbo.STUDENT_INFO.STDNT_DISCOUNT_RULE_ID AS [Discount Rule ID], dbo.STUDENT_INFO.STDNT_HOUSE_ID AS [House ID], dbo.HOUSES_INFO.HOUSES_NAME AS House, 
                         dbo.STUDENT_INFO.STDNT_CONDUCT_ID AS [Conduct ID], dbo.CONDUCT_INFO.CONDUCT_NAME AS Conduct, dbo.STUDENT_INFO.STDNT_DATE_OF_LEAVING AS [Date of Leaving], 
                         dbo.STUDENT_INFO.STDNT_WITH_DRAW_NO AS [With Draw No], dbo.STUDENT_INFO.STDNT_CATEGORY AS Category, dbo.STUDENT_INFO.STDNT_REMARKS AS Remarks, dbo.STUDENT_INFO.STDNT_CITY_ID AS [City ID], 
                         dbo.CITY_INFO.CITY_NAME AS City, dbo.STUDENT_INFO.STDNT_AREA_ID AS [Area ID], dbo.AREA_INFO.AREA_NAME AS Area, dbo.STUDENT_INFO.STDNT_CLASS_PLANE_ID AS [Class ID], 
                         dbo.SESSION_INFO.SESSION_DESC AS Session, dbo.PARENT_INFO.PARNT_CELL_NO AS [Fatehr Cell #], dbo.PARENT_INFO.PARNT_TEMP_ADDR AS [Father Address], ap.AREA_NAME AS [P. Area], cp.CITY_NAME AS [P. City], 
                         dbo.STUDENT_INFO.STDNT_SCHOLARSHIP_ID AS [Scholarship ID], dbo.STUDENT_INFO.STDNT_LAB_TYPE AS [Lab Type], dbo.STUDENT_INFO.STDNT_IS_REJOIN AS [Is Rejoin], dbo.tblStudentClassPlan.SessionId, 
                         u1.USER_DISPLAY_NAME AS CreatedBy, u2.USER_DISPLAY_NAME AS UpdateBy, dbo.STUDENT_INFO.CreatedDate, dbo.STUDENT_INFO.UpdatedDate, dbo.SCHOOL_PLANE.CLASS_ORDER AS [Class Order], 
                         dbo.PARENT_INFO.PARNT_EMAIL AS ParentEmail
FROM            dbo.STUDENT_INFO INNER JOIN
                         dbo.PARENT_INFO ON dbo.STUDENT_INFO.STDNT_PARANT_ID = dbo.PARENT_INFO.PARNT_ID INNER JOIN
                         dbo.PLAN_FEE ON dbo.STUDENT_INFO.STDNT_CLASS_FEE_ID = dbo.PLAN_FEE.PLAN_FEE_ID INNER JOIN
                         dbo.SESSION_INFO ON dbo.STUDENT_INFO.STDNT_SESSION_ID = dbo.SESSION_INFO.SESSION_ID INNER JOIN
                         dbo.tblStudentClassPlan ON dbo.STUDENT_INFO.STDNT_ID = dbo.tblStudentClassPlan.StudentId LEFT OUTER JOIN
                         dbo.USER_INFO AS u1 ON u1.USER_ID = dbo.STUDENT_INFO.CreatedBy LEFT OUTER JOIN
                         dbo.USER_INFO AS u2 ON u2.USER_ID = dbo.STUDENT_INFO.UpdatedBy LEFT OUTER JOIN
                         dbo.SCHOOL_PLANE ON dbo.tblStudentClassPlan.ClassId = dbo.SCHOOL_PLANE.CLASS_ID LEFT OUTER JOIN
                         dbo.AREA_INFO ON dbo.STUDENT_INFO.STDNT_AREA_ID = dbo.AREA_INFO.AREA_ID LEFT OUTER JOIN
                         dbo.CITY_INFO ON dbo.STUDENT_INFO.STDNT_CITY_ID = dbo.CITY_INFO.CITY_ID LEFT OUTER JOIN
                         dbo.HOUSES_INFO ON dbo.STUDENT_INFO.STDNT_HOUSE_ID = dbo.HOUSES_INFO.HOUSES_ID LEFT OUTER JOIN
                         dbo.CONDUCT_INFO ON dbo.STUDENT_INFO.STDNT_CONDUCT_ID = dbo.CONDUCT_INFO.CONDUCT_ID LEFT OUTER JOIN
                         dbo.AREA_INFO AS ap ON dbo.PARENT_INFO.PARNT_AREA = ap.AREA_ID LEFT OUTER JOIN
                         dbo.CITY_INFO AS cp ON dbo.PARENT_INFO.PARNT_CITY = cp.CITY_ID
GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 2, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'VSTUDENT_INFO';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane2', @value = N'isplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "SCHOOL_PLANE"
            Begin Extent = 
               Top = 272
               Left = 404
               Bottom = 402
               Right = 674
            End
            DisplayFlags = 280
            TopColumn = 20
         End
         Begin Table = "AREA_INFO"
            Begin Extent = 
               Top = 138
               Left = 296
               Bottom = 268
               Right = 466
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "CITY_INFO"
            Begin Extent = 
               Top = 402
               Left = 283
               Bottom = 532
               Right = 453
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "HOUSES_INFO"
            Begin Extent = 
               Top = 798
               Left = 284
               Bottom = 928
               Right = 464
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "CONDUCT_INFO"
            Begin Extent = 
               Top = 930
               Left = 38
               Bottom = 1060
               Right = 231
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ap"
            Begin Extent = 
               Top = 534
               Left = 305
               Bottom = 664
               Right = 475
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "cp"
            Begin Extent = 
               Top = 666
               Left = 301
               Bottom = 796
               Right = 471
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
         Column = 6720
         Alias = 2655
         Table = 3345
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
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'VSTUDENT_INFO';




GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane1', @value = N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[42] 4[28] 2[26] 3) )"
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
         Top = -768
         Left = 0
      End
      Begin Tables = 
         Begin Table = "STUDENT_INFO"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 320
            End
            DisplayFlags = 280
            TopColumn = 0
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
         Begin Table = "PLAN_FEE"
            Begin Extent = 
               Top = 678
               Left = 502
               Bottom = 808
               Right = 758
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "SESSION_INFO"
            Begin Extent = 
               Top = 798
               Left = 38
               Bottom = 928
               Right = 246
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "tblStudentClassPlan"
            Begin Extent = 
               Top = 6
               Left = 358
               Bottom = 136
               Right = 528
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "u1"
            Begin Extent = 
               Top = 270
               Left = 38
               Bottom = 400
               Right = 243
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "u2"
            Begin Extent = 
               Top = 402
               Left = 38
               Bottom = 532
               Right = 243
            End
            D', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'VSTUDENT_INFO';



