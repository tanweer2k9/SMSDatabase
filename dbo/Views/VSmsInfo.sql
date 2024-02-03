CREATE VIEW dbo.VSmsInfo
AS
SELECT        dbo.FEE_COLLECT.FEE_COLLECT_ID AS InvoiceId, dbo.FEE_COLLECT.FEE_COLLECT_INSTALLMENT_NAME AS Installment, dbo.STUDENT_INFO.STDNT_FIRST_NAME AS StudentName, 
                         dbo.PARENT_INFO.PARNT_FIRST_NAME AS ParentName, dbo.PARENT_INFO.PARNT_EMAIL AS ParentEmail, dbo.STUDENT_INFO.STDNT_SCHOOL_ID AS StdNo, dbo.STUDENT_INFO.STDNT_ID AS StdId, 
                         dbo.PARENT_INFO.PARNT_REG AS Relation, dbo.BranchSetting.IsSmsEnabled, dbo.PARENT_INFO.PARNT_CELL_NO AS MobileNo, dbo.BR_ADMIN.BR_ADM_STATUS, dbo.USER_INFO.USER_ID AS UserId, 
                         dbo.STUDENT_INFO.STDNT_BR_ID AS BrId, dbo.STUDENT_INFO.STDNT_HD_ID AS HdId, dbo.BranchSetting.IsEmailEnabled
FROM            dbo.STUDENT_INFO LEFT OUTER JOIN
                         dbo.FEE_COLLECT ON dbo.FEE_COLLECT.FEE_COLLECT_STD_ID = dbo.STUDENT_INFO.STDNT_ID LEFT OUTER JOIN
                         dbo.PARENT_INFO ON dbo.STUDENT_INFO.STDNT_PARANT_ID = dbo.PARENT_INFO.PARNT_ID LEFT OUTER JOIN
                         dbo.USER_INFO ON dbo.USER_INFO.USER_CODE = dbo.PARENT_INFO.PARNT_ID AND dbo.USER_INFO.USER_TYPE = 'Parent' LEFT OUTER JOIN
                         dbo.BR_ADMIN ON dbo.FEE_COLLECT.FEE_COLLECT_BR_ID = dbo.BR_ADMIN.BR_ADM_ID AND dbo.STUDENT_INFO.STDNT_BR_ID = dbo.BR_ADMIN.BR_ADM_ID AND 
                         dbo.STUDENT_INFO.STDNT_BR_ID = dbo.BR_ADMIN.BR_ADM_ID LEFT OUTER JOIN
                         dbo.BranchSetting ON dbo.BR_ADMIN.BR_ADM_ID = dbo.BranchSetting.BrId
WHERE        (dbo.BR_ADMIN.BR_ADM_STATUS = 'T')
GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 2, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'VSmsInfo';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane2', @value = N'3495
         Alias = 1920
         Table = 3600
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
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'VSmsInfo';


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
               Left = 412
               Bottom = 136
               Right = 690
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "FEE_COLLECT"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 374
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "PARENT_INFO"
            Begin Extent = 
               Top = 6
               Left = 728
               Bottom = 136
               Right = 947
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "USER_INFO"
            Begin Extent = 
               Top = 6
               Left = 985
               Bottom = 136
               Right = 1190
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "BR_ADMIN"
            Begin Extent = 
               Top = 166
               Left = 371
               Bottom = 296
               Right = 785
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "BranchSetting"
            Begin Extent = 
               Top = 138
               Left = 797
               Bottom = 268
               Right = 995
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
         Column = ', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'VSmsInfo';

