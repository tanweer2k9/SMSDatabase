CREATE VIEW dbo.VSCHOOL_PLANE
AS
SELECT        dbo.SCHOOL_PLANE.CLASS_ID AS ID, dbo.SCHOOL_PLANE.CLASS_HD_ID AS [Institute ID], dbo.SCHOOL_PLANE.CLASS_BR_ID AS [Branch ID], dbo.SCHOOL_PLANE.CLASS_Name AS Name, 
                         dbo.CLASS_INFO.CLASS_NAME AS Class, dbo.SHIFT_INFO.SHFT_NAME AS Shift, dbo.SECTION_INFO.SECT_NAME AS Section, dbo.DEPARTMENT_INFO.DEP_NAME AS Department, 
                         ISNULL(dbo.TEACHER_INFO.TECH_FIRST_NAME, '') AS [Class Teacher], dbo.SCHOOL_PLANE.CLASS_PRICE AS Fee, dbo.SCHOOL_PLANE.CLASS_Min_VARIATION_PRCNT AS [Min Fee Variation], 
                         dbo.SCHOOL_PLANE.CLASS_Max_VARIATION_PRCNT AS [Max Fee Variation], dbo.SCHOOL_PLANE.CLASS_STATUS AS Status, dbo.SCHOOL_PLANE.CLASS_SESSION_START_DATE AS [Session Start Date], 
                         dbo.SCHOOL_PLANE.CLASS_SESSION_END_DATE AS [Session End Date], dbo.SCHOOL_PLANE.CLASS_MIN_ELECTIVE_SUBJECTS AS [Min Subjects], 
                         dbo.SCHOOL_PLANE.CLASS_MAX_ELECTIVE_SUBJECTS AS [Max Subjects], dbo.SCHOOL_PLANE.CLASS_IS_MANDATORY AS [Is Mandatory], dbo.SCHOOL_PLANE.CLASS_TEACHER AS [Class Teacher ID], 
                         dbo.SCHOOL_PLANE.CLASS_IS_SUBJECT_ATTENDANCE AS [Is Subject Attendance], dbo.SCHOOL_PLANE.CLASS_LEVEL_ID AS [Level ID], dbo.SCHOOL_PLANE.CLASS_SESSION_ID AS [Session Id], 
                         dbo.SCHOOL_PLANE.CLASS_ORDER AS [Order], dbo.LEVELS.LEVEL_LEVEL AS [Level]
FROM            dbo.SCHOOL_PLANE LEFT OUTER JOIN
                         dbo.CLASS_INFO ON dbo.SCHOOL_PLANE.CLASS_CLASS = dbo.CLASS_INFO.CLASS_ID LEFT OUTER JOIN
                         dbo.DEPARTMENT_INFO ON dbo.SCHOOL_PLANE.CLASS_DPRTMNT = dbo.DEPARTMENT_INFO.DEP_ID LEFT OUTER JOIN
                         dbo.SECTION_INFO ON dbo.SCHOOL_PLANE.CLASS_SECTION = dbo.SECTION_INFO.SECT_ID LEFT OUTER JOIN
                         dbo.SHIFT_INFO ON dbo.SCHOOL_PLANE.CLASS_SHIFT = dbo.SHIFT_INFO.SHFT_ID LEFT OUTER JOIN
                         dbo.TEACHER_INFO ON dbo.SCHOOL_PLANE.CLASS_TEACHER = dbo.TEACHER_INFO.TECH_ID LEFT OUTER JOIN
                         dbo.LEVELS ON dbo.SCHOOL_PLANE.CLASS_LEVEL_ID = dbo.LEVELS.LEVEL_ID
GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 2, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'VSCHOOL_PLANE';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane2', @value = N'
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
         Column = 2880
         Alias = 2370
         Table = 2745
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
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'VSCHOOL_PLANE';


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
         Top = -192
         Left = 0
      End
      Begin Tables = 
         Begin Table = "SCHOOL_PLANE"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 308
            End
            DisplayFlags = 280
            TopColumn = 19
         End
         Begin Table = "CLASS_INFO"
            Begin Extent = 
               Top = 138
               Left = 38
               Bottom = 268
               Right = 208
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "DEPARTMENT_INFO"
            Begin Extent = 
               Top = 138
               Left = 246
               Bottom = 268
               Right = 416
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "SECTION_INFO"
            Begin Extent = 
               Top = 270
               Left = 38
               Bottom = 400
               Right = 208
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "SHIFT_INFO"
            Begin Extent = 
               Top = 270
               Left = 246
               Bottom = 400
               Right = 416
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "TEACHER_INFO"
            Begin Extent = 
               Top = 402
               Left = 38
               Bottom = 532
               Right = 371
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "LEVELS"
            Begin Extent = 
               Top = 198
               Left = 454
               Bottom = 328
               Right = 652
            End', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'VSCHOOL_PLANE';

