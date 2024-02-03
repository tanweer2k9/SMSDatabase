CREATE VIEW dbo.VSCHOOL_PLANE_DEFINITION
AS
SELECT        dbo.SCHOOL_PLANE_DEFINITION.DEF_ID AS ID, dbo.SUBJECT_INFO.SUB_NAME AS Subject, dbo.TEACHER_INFO.TECH_FIRST_NAME AS Teacher, dbo.TERM_INFO.TERM_NAME AS Term, 
                         dbo.SCHOOL_PLANE_DEFINITION.DEF_START_TIME AS [Start Time], dbo.SCHOOL_PLANE_DEFINITION.DEF_END_TIME AS [End Time], dbo.SCHOOL_PLANE_DEFINITION.DEF_STATUS AS Status, 
                         dbo.SCHOOL_PLANE_DEFINITION.DEF_CLASS_ID AS [Class ID], dbo.SCHOOL_PLANE_DEFINITION.DEF_SUBJECT AS [Subject ID], dbo.SCHOOL_PLANE_DEFINITION.DEF_TEACHER AS [Teacher ID], 
                         dbo.SCHOOL_PLANE_DEFINITION.DEF_TERM AS [Term ID], dbo.SCHOOL_PLANE_DEFINITION.DEF_IS_COMPULSORY AS [Is Compulsory]
FROM            dbo.SCHOOL_PLANE_DEFINITION INNER JOIN
                         dbo.SUBJECT_INFO ON dbo.SCHOOL_PLANE_DEFINITION.DEF_SUBJECT = dbo.SUBJECT_INFO.SUB_ID AND dbo.SUBJECT_INFO.SUB_STATUS <> 'D' INNER JOIN
                         dbo.TEACHER_INFO ON dbo.SCHOOL_PLANE_DEFINITION.DEF_TEACHER = dbo.TEACHER_INFO.TECH_ID INNER JOIN
                         dbo.TERM_INFO ON dbo.SCHOOL_PLANE_DEFINITION.DEF_TERM = dbo.TERM_INFO.TERM_ID AND dbo.TERM_INFO.TERM_STATUS <> 'D'
GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'VSCHOOL_PLANE_DEFINITION';


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
         Begin Table = "SCHOOL_PLANE_DEFINITION"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 244
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "SUBJECT_INFO"
            Begin Extent = 
               Top = 138
               Left = 38
               Bottom = 268
               Right = 236
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "TEACHER_INFO"
            Begin Extent = 
               Top = 270
               Left = 38
               Bottom = 400
               Right = 371
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "TERM_INFO"
            Begin Extent = 
               Top = 402
               Left = 38
               Bottom = 532
               Right = 282
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
         Column = 1440
         Alias = 900
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
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'VSCHOOL_PLANE_DEFINITION';

