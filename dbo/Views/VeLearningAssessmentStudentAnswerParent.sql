CREATE VIEW dbo.VeLearningAssessmentStudentAnswerParent
AS
SELECT        dbo.eLearningAssessmentTestInfo.Id AS TestId, dbo.eLearningAssessmentStudentAnswerParent.Id AS ParentId, dbo.eLearningAssessmentTestInfo.BrId, dbo.SCHOOL_PLANE.CLASS_Name, 
                         dbo.STUDENT_INFO.STDNT_FIRST_NAME, dbo.eLearningAssessmentStudentAnswerParent.TestInfoId, dbo.eLearningAssessmentStudentAnswerParent.StudentId, 
                         dbo.eLearningAssessmentStudentAnswerParent.MarksUpdatedBy, dbo.eLearningAssessmentStudentAnswerParent.MarksUpdatedDate, dbo.eLearningAssessmentStudentAnswerParent.CreatedDate AS Expr2, 
                         dbo.eLearningAssessmentStudentAnswerParent.IsCompleted, dbo.eLearningAssessmentStudentAnswerParent.ReamingTimeSeconds, dbo.eLearningAssessmentStudentAnswerParent.ObtainMarks, 
                         dbo.eLearningAssessmentStudentAnswerParent.StartTime, dbo.eLearningAssessmentTestInfo.ClassId, dbo.eLearningAssessmentTestInfo.SubjectId, dbo.eLearningAssessmentTestInfo.Name, 
                         dbo.eLearningAssessmentTestInfo.PublishDate, dbo.eLearningAssessmentTestInfo.TotalMarks, dbo.eLearningAssessmentTestInfo.TotalQuestion, dbo.eLearningAssessmentTestInfo.DueDate, 
                         dbo.eLearningAssessmentTestInfo.TotalTime, dbo.eLearningAssessmentTestInfo.IsDeleted, dbo.eLearningAssessmentTestInfo.CreatedDate, dbo.eLearningAssessmentTestInfo.CreatedBy, 
                         dbo.eLearningAssessmentTestInfo.UpdatedDate, dbo.eLearningAssessmentTestInfo.UpdatedBy
FROM            dbo.STUDENT_INFO INNER JOIN
                         dbo.SCHOOL_PLANE ON dbo.STUDENT_INFO.STDNT_CLASS_PLANE_ID = dbo.SCHOOL_PLANE.CLASS_ID INNER JOIN
                         dbo.eLearningAssessmentStudentAnswerParent ON dbo.eLearningAssessmentStudentAnswerParent.StudentId = dbo.STUDENT_INFO.STDNT_ID INNER JOIN
                         dbo.eLearningAssessmentTestInfo ON dbo.eLearningAssessmentStudentAnswerParent.TestInfoId = dbo.eLearningAssessmentTestInfo.Id
GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'VeLearningAssessmentStudentAnswerParent';


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
         Begin Table = "STUDENT_INFO"
            Begin Extent = 
               Top = 6
               Left = 799
               Bottom = 136
               Right = 1081
            End
            DisplayFlags = 280
            TopColumn = 7
         End
         Begin Table = "SCHOOL_PLANE"
            Begin Extent = 
               Top = 6
               Left = 491
               Bottom = 136
               Right = 761
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "eLearningAssessmentStudentAnswerParent"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 245
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "eLearningAssessmentTestInfo"
            Begin Extent = 
               Top = 6
               Left = 283
               Bottom = 136
               Right = 453
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
         Column = 3495
         Alias = 3030
         Table = 6495
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
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'VeLearningAssessmentStudentAnswerParent';

