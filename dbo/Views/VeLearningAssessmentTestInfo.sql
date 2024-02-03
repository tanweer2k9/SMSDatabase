

CREATE VIEW [dbo].[VeLearningAssessmentTestInfo]
AS
SELECT        dbo.eLearningAssessmentTestInfo.Id, dbo.eLearningAssessmentTestInfo.BrId, dbo.eLearningAssessmentTestInfo.ClassId, dbo.eLearningAssessmentTestInfo.SubjectId, dbo.eLearningAssessmentTestInfo.Name, 
                         dbo.eLearningAssessmentTestInfo.PublishDate, dbo.eLearningAssessmentTestInfo.TotalMarks, dbo.eLearningAssessmentTestInfo.UpdatedBy, dbo.eLearningAssessmentTestInfo.UpdatedDate, 
                         dbo.eLearningAssessmentTestInfo.CreatedBy, dbo.eLearningAssessmentTestInfo.CreatedDate, dbo.eLearningAssessmentTestInfo.IsDeleted, dbo.eLearningAssessmentTestInfo.DueDate, 
                         dbo.eLearningAssessmentTestInfo.TotalTime, dbo.eLearningAssessmentTestInfo.TotalQuestion, dbo.SCHOOL_PLANE.CLASS_Name AS Class, dbo.SUBJECT_INFO.SUB_NAME AS Subject
FROM            dbo.eLearningAssessmentTestInfo INNER JOIN
                         dbo.SCHOOL_PLANE ON dbo.eLearningAssessmentTestInfo.ClassId = dbo.SCHOOL_PLANE.CLASS_ID INNER JOIN
                         dbo.SUBJECT_INFO ON dbo.eLearningAssessmentTestInfo.SubjectId = dbo.SUBJECT_INFO.SUB_ID
GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'VeLearningAssessmentTestInfo';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane1', @value = N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[30] 4[32] 2[20] 3) )"
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
         Begin Table = "eLearningAssessmentTestInfo"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 208
            End
            DisplayFlags = 280
            TopColumn = 7
         End
         Begin Table = "SCHOOL_PLANE"
            Begin Extent = 
               Top = 6
               Left = 246
               Bottom = 136
               Right = 515
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "SUBJECT_INFO"
            Begin Extent = 
               Top = 6
               Left = 553
               Bottom = 136
               Right = 750
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
         Column = 3420
         Alias = 3615
         Table = 2730
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
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'VeLearningAssessmentTestInfo';

