CREATE VIEW dbo.VEXAM_DEF
AS
SELECT        dbo.EXAM_DEF.EXAM_DEF_ID AS ID, dbo.EXAM_DEF.EXAM_DEF_PID AS PID, dbo.TERM_INFO.TERM_NAME AS Term, dbo.SUBJECT_INFO.SUB_NAME AS Subject, 
                         CASE WHEN EXAM_DEF_SUBJECT_TYPE_ID = 0 THEN 'Whole' ELSE
                             (SELECT        SUBJECT_TYPE_NAME
                               FROM            SUBJECT_TYPE_INFO
                               WHERE        SUBJECT_TYPE_ID = EXAM_DEF_SUBJECT_TYPE_ID) END AS [Subject Type], dbo.EXAM_DEF.EXAM_DEF_TOTAL_MARKS AS [Total Marks], 
                         dbo.EXAM_DEF.[EXAM_DEF_PASS_%AGE] AS [Pass %age], dbo.EXAM_DEF.[EXAM_DEF_NEXT_TERM_%AGE] AS [%age In Next Term], dbo.EXAM_DEF.[EXAM_DEF_FINAL_%AGE] AS [%age In Final], 
                         dbo.EXAM_DEF.EXAM_DEF_STATUS AS Status, dbo.EXAM_DEF.EXAM_DEF_CLASS_ID AS [Class ID], dbo.TERM_INFO.TERM_ID AS [Term ID], dbo.SUBJECT_INFO.SUB_ID AS [Subject ID], 
                         dbo.EXAM_DEF.EXAM_DEF_SUBJECT_TYPE_ID AS [Subject Type ID], dbo.EXAM_DEF.EXAM_DEF_MARKS_TYPE AS [Marks Type], dbo.EXAM_DEF.EXAM_DEF_GRACE_NUMBERS AS [Grace Numbers], 
                         dbo.EXAM_DEF.EXAM_DEF_TERM_RANKS_TEST AS [Terms Test], dbo.EXAM_DEF.EXAM_DEF_TERM_RANKS_TEST_PERCENTAGE AS [Terms Test Percent], 
                         dbo.EXAM_DEF.EXAM_DEF_TERM_RANKS_ASSIGNMENTS AS [Terms Assignment], dbo.EXAM_DEF.EXAM_DEF_TERM_RANKS_ASSIGNMENTS_PERCENTAGE AS [Terms Assignment Percent], 
                         dbo.EXAM_DEF.EXAM_DEF_TERM_RANKS_PRESENTATIONS AS [Terms Presentation], dbo.EXAM_DEF.EXAM_DEF_TERM_RANKS_PRESENTATIONS_PERCENTAGE AS [Terms Presentation Percent], 
                         dbo.EXAM_DEF.EXAM_DEF_TERM_RANKS_QUIZ AS [Terms Quiz], dbo.EXAM_DEF.EXAM_DEF_TERM_RANKS_QUIZ_PERCENTAGE AS [Terms Quiz Percent], 
                         dbo.EXAM_DEF.EXAM_DEF_TERM_BEST_TESTS AS [Best Tests], dbo.TERM_INFO.TERM_BR_ID AS [Branch ID]
FROM            dbo.EXAM_DEF INNER JOIN
                         dbo.SCHOOL_PLANE_DEFINITION ON dbo.EXAM_DEF.EXAM_DEF_CLASS_ID = dbo.SCHOOL_PLANE_DEFINITION.DEF_ID INNER JOIN
                         dbo.SUBJECT_INFO ON dbo.SCHOOL_PLANE_DEFINITION.DEF_SUBJECT = dbo.SUBJECT_INFO.SUB_ID INNER JOIN
                         dbo.TERM_INFO ON dbo.SCHOOL_PLANE_DEFINITION.DEF_TERM = dbo.TERM_INFO.TERM_ID
GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'VEXAM_DEF';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane1', @value = N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[29] 4[32] 2[20] 3) )"
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
         Begin Table = "EXAM_DEF"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 434
            End
            DisplayFlags = 280
            TopColumn = 16
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
         Begin Table = "SUBJECT_INFO"
            Begin Extent = 
               Top = 138
               Left = 282
               Bottom = 268
               Right = 452
            End
            DisplayFlags = 280
            TopColumn = 2
         End
         Begin Table = "TERM_INFO"
            Begin Extent = 
               Top = 270
               Left = 38
               Bottom = 400
               Right = 282
            End
            DisplayFlags = 280
            TopColumn = 2
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
         Column = 5610
         Alias = 4455
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
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'VEXAM_DEF';

