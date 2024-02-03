CREATE VIEW [dbo].[VSUPLEMENTARY_STUDENTS_SETTINGS]
AS
SELECT        dbo.SUPLEMENTARY_STUDENTS_SETTINGS.SUPL_STD_ID AS ID, dbo.SUPLEMENTARY_STUDENTS_SETTINGS.SUPL_STD_HD_ID AS [HD ID], 
                         dbo.SUPLEMENTARY_STUDENTS_SETTINGS.SUPL_STD_BR_ID AS [BR ID], dbo.SUPLEMENTARY_STUDENTS_SETTINGS.SUPL_STD_STUDENT_ID AS [Student ID], 
                         dbo.STUDENT_INFO.STDNT_SCHOOL_ID AS [School ID], dbo.STUDENT_INFO.STDNT_FIRST_NAME AS [Student Name], dbo.SCHOOL_PLANE.CLASS_Name AS Class, 
                         dbo.SUPLEMENTARY_STUDENTS_SETTINGS.SUPL_STD_GPA AS GPA, dbo.SUPLEMENTARY_STUDENTS_SETTINGS.SUPL_STD_FEE AS Fee, 
                         dbo.SUPLEMENTARY_STUDENTS_SETTINGS.SUPL_STD_Percentage AS Percentage, dbo.SCHOOL_PLANE.CLASS_ID AS [Class ID]
FROM            dbo.SUPLEMENTARY_STUDENTS_SETTINGS INNER JOIN
                         dbo.STUDENT_INFO ON dbo.SUPLEMENTARY_STUDENTS_SETTINGS.SUPL_STD_STUDENT_ID = dbo.STUDENT_INFO.STDNT_ID INNER JOIN
                         dbo.SCHOOL_PLANE ON dbo.STUDENT_INFO.STDNT_CLASS_PLANE_ID = dbo.SCHOOL_PLANE.CLASS_ID
GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'VSUPLEMENTARY_STUDENTS_SETTINGS';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane1', @value = N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[35] 4[34] 2[13] 3) )"
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
         Begin Table = "SUPLEMENTARY_STUDENTS_SETTINGS"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 252
            End
            DisplayFlags = 280
            TopColumn = 3
         End
         Begin Table = "STUDENT_INFO"
            Begin Extent = 
               Top = 6
               Left = 290
               Bottom = 136
               Right = 572
            End
            DisplayFlags = 280
            TopColumn = 27
         End
         Begin Table = "SCHOOL_PLANE"
            Begin Extent = 
               Top = 6
               Left = 610
               Bottom = 136
               Right = 875
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
         Column = 2460
         Alias = 3555
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
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'VSUPLEMENTARY_STUDENTS_SETTINGS';

