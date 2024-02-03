CREATE VIEW dbo.VExamStudents
AS
SELECT        dbo.EXAM_ENTRY.EXAM_ENTRY_OBTAIN_MARKS AS ObtainMarks, dbo.EXAM_ENTRY.EXAM_ENTRY_OBTAINED_MARKS_LOG AS ObtainMarksLog, dbo.EXAM_ENTRY.EXAM_ENTRY_ENTER_DATE AS CreatedDate, 
                         dbo.EXAM_ENTRY.UPDATED_DATE AS UpdatedDate, dbo.EXAM_ENTRY.CREATED_BY AS CreatedBy, dbo.EXAM_ENTRY.UPDATED_BY AS UpdatedBy, dbo.SCHOOL_PLANE.CLASS_Name AS Class, 
                         dbo.STUDENT_INFO.STDNT_FIRST_NAME AS StudentName, dbo.SUBJECT_INFO.SUB_NAME AS Subject, dbo.TERM_INFO.TERM_NAME AS Term, dbo.SESSION_INFO.SESSION_DESC AS Session, 
                         dbo.STUDENT_INFO.STDNT_SCHOOL_ID AS StdNo, dbo.SCHOOL_PLANE.CLASS_ORDER AS ClassOrder, dbo.EXAM_ENTRY.EXAM_ENTRY_ID, dbo.EXAM_ENTRY.EXAM_ENTRY_PLAN_EXAM_ID
FROM            dbo.EXAM_DEF INNER JOIN
                         dbo.EXAM_ENTRY ON dbo.EXAM_DEF.EXAM_DEF_ID = dbo.EXAM_ENTRY.EXAM_ENTRY_PLAN_EXAM_ID INNER JOIN
                         dbo.SCHOOL_PLANE_DEFINITION ON dbo.EXAM_DEF.EXAM_DEF_CLASS_ID = dbo.SCHOOL_PLANE_DEFINITION.DEF_ID INNER JOIN
                         dbo.SCHOOL_PLANE ON dbo.SCHOOL_PLANE_DEFINITION.DEF_CLASS_ID = dbo.SCHOOL_PLANE.CLASS_ID INNER JOIN
                         dbo.STUDENT_INFO ON dbo.EXAM_ENTRY.EXAM_ENTRY_STUDENT_ID = dbo.STUDENT_INFO.STDNT_ID INNER JOIN
                         dbo.SUBJECT_INFO ON dbo.SCHOOL_PLANE_DEFINITION.DEF_SUBJECT = dbo.SUBJECT_INFO.SUB_ID INNER JOIN
                         dbo.TERM_INFO ON dbo.SCHOOL_PLANE_DEFINITION.DEF_TERM = dbo.TERM_INFO.TERM_ID INNER JOIN
                         dbo.SESSION_INFO ON dbo.SCHOOL_PLANE.CLASS_SESSION_ID = dbo.SESSION_INFO.SESSION_ID
GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 2, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'VExamStudents';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane2', @value = N'    End
            DisplayFlags = 280
            TopColumn = 8
         End
         Begin Table = "SESSION_INFO"
            Begin Extent = 
               Top = 270
               Left = 38
               Bottom = 400
               Right = 246
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
         Column = 3750
         Alias = 2955
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
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'VExamStudents';


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
         Begin Table = "EXAM_DEF"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 434
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "EXAM_ENTRY"
            Begin Extent = 
               Top = 6
               Left = 472
               Bottom = 136
               Right = 768
            End
            DisplayFlags = 280
            TopColumn = 2
         End
         Begin Table = "SCHOOL_PLANE_DEFINITION"
            Begin Extent = 
               Top = 138
               Left = 38
               Bottom = 268
               Right = 244
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "SCHOOL_PLANE"
            Begin Extent = 
               Top = 6
               Left = 806
               Bottom = 136
               Right = 1076
            End
            DisplayFlags = 280
            TopColumn = 20
         End
         Begin Table = "STUDENT_INFO"
            Begin Extent = 
               Top = 138
               Left = 282
               Bottom = 268
               Right = 564
            End
            DisplayFlags = 280
            TopColumn = 27
         End
         Begin Table = "SUBJECT_INFO"
            Begin Extent = 
               Top = 138
               Left = 602
               Bottom = 268
               Right = 800
            End
            DisplayFlags = 280
            TopColumn = 2
         End
         Begin Table = "TERM_INFO"
            Begin Extent = 
               Top = 138
               Left = 838
               Bottom = 268
               Right = 1082
        ', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'VExamStudents';

