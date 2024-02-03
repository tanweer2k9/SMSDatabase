
CREATE VIEW [dbo].[rpt_VSupplementary_Bills]
AS
SELECT DISTINCT 
                         dbo.STUDENT_INFO.STDNT_ID AS [Std ID], dbo.STUDENT_INFO.STDNT_FIRST_NAME AS [First Name], dbo.STUDENT_INFO.STDNT_LAST_NAME AS [Last Name], dbo.SCHOOL_PLANE.CLASS_Name AS Class, 
                         dbo.PARENT_INFO.PARNT_FIRST_NAME AS [Father Name], dbo.BR_ADMIN.BR_ADM_BANK_NAME AS [Bank Name], dbo.BR_ADMIN.BR_ADM_ACCT_TITLE AS [Bank Acct Title], 
                         dbo.BR_ADMIN.BR_ADM_ACCT_NO AS [Bank Acct no], dbo.STUDENT_INFO.STDNT_SCHOOL_ID AS [School ID], dbo.PARENT_INFO.PARNT_CELL_NO AS [Parent Cell], 
                         dbo.STUDENT_INFO.STDNT_CELL_NO AS [Student Cell], dbo.PARENT_INFO.PARNT_TEMP_ADDR + ' ' + dbo.AREA_INFO.AREA_NAME + ' ' + dbo.CITY_INFO.CITY_NAME AS [Parent Address], 
                         dbo.PARENT_INFO.PARNT_FAMILY_CODE AS [Family Code], dbo.STUDENT_INFO.STDNT_PARANT_ID AS [Parent ID], SUPLEMENTARY_PARENT_1.SUPL_MONTH_NAME AS [Month Name], 
                         dbo.SUPLEMENTARY_DEF.SUPL_DEF_ID AS [Challan No], dbo.STUDENT_FEE_NOTES.STD_FEE_NOTES_DESCRIPTION AS Notes, SUPLEMENTARY_PARENT_1.SUPL_DUE_DATE AS [Due Date], 
                         SUPLEMENTARY_PARENT_1.SUPL_HD_ID AS [HD ID], SUPLEMENTARY_PARENT_1.SUPL_BR_ID AS [BR ID], dbo.SCHOOL_PLANE.CLASS_ID AS [Class ID], 
                         dbo.SUPLEMENTARY_DEF.SUPL_DEF_FEE_COLLECT_ID AS [Fee Collect ID]
FROM            dbo.STUDENT_FEE_NOTES INNER JOIN
                         dbo.AREA_INFO INNER JOIN
                         dbo.PARENT_INFO INNER JOIN
                         dbo.STUDENT_INFO ON dbo.PARENT_INFO.PARNT_ID = dbo.STUDENT_INFO.STDNT_PARANT_ID ON dbo.AREA_INFO.AREA_ID = dbo.PARENT_INFO.PARNT_AREA INNER JOIN
                         dbo.CITY_INFO ON dbo.PARENT_INFO.PARNT_CITY = dbo.CITY_INFO.CITY_ID INNER JOIN
                         dbo.SUPLEMENTARY_DEF ON dbo.STUDENT_INFO.STDNT_ID = dbo.SUPLEMENTARY_DEF.SUPL_DEF_STUDENT_ID INNER JOIN
                         dbo.SUPLEMENTARY_PARENT AS SUPLEMENTARY_PARENT_1 ON dbo.SUPLEMENTARY_DEF.SUPL_DEF_PID = SUPLEMENTARY_PARENT_1.SUPL_ID INNER JOIN
                         dbo.SCHOOL_PLANE ON dbo.STUDENT_INFO.STDNT_CLASS_PLANE_ID = dbo.SCHOOL_PLANE.CLASS_ID ON 
                         dbo.STUDENT_FEE_NOTES.STD_FEE_NOTES_CLASS_ID = dbo.SCHOOL_PLANE.CLASS_ID LEFT OUTER JOIN
                         dbo.BR_ADMIN ON dbo.STUDENT_INFO.STDNT_BR_ID = dbo.BR_ADMIN.BR_ADM_ID
WHERE        (dbo.SCHOOL_PLANE.CLASS_IS_SUPPLEMENTARY_BILLS = 1) AND (dbo.SUPLEMENTARY_DEF.SUPL_DEF_FEE > 0)
GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 2, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'rpt_VSupplementary_Bills';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane2', @value = N'           End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "SCHOOL_PLANE"
            Begin Extent = 
               Top = 140
               Left = 183
               Bottom = 270
               Right = 453
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "BR_ADMIN"
            Begin Extent = 
               Top = 190
               Left = 860
               Bottom = 320
               Right = 1277
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
         Column = 5100
         Alias = 3375
         Table = 4560
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
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'rpt_VSupplementary_Bills';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane1', @value = N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[37] 4[29] 2[26] 3) )"
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
         Begin Table = "STUDENT_FEE_NOTES"
            Begin Extent = 
               Top = 4
               Left = 778
               Bottom = 134
               Right = 1031
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "AREA_INFO"
            Begin Extent = 
               Top = 270
               Left = 38
               Bottom = 400
               Right = 208
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "PARENT_INFO"
            Begin Extent = 
               Top = 6
               Left = 1043
               Bottom = 136
               Right = 1263
            End
            DisplayFlags = 280
            TopColumn = 39
         End
         Begin Table = "STUDENT_INFO"
            Begin Extent = 
               Top = 3
               Left = 495
               Bottom = 133
               Right = 777
            End
            DisplayFlags = 280
            TopColumn = 3
         End
         Begin Table = "CITY_INFO"
            Begin Extent = 
               Top = 270
               Left = 246
               Bottom = 400
               Right = 416
            End
            DisplayFlags = 280
            TopColumn = 1
         End
         Begin Table = "SUPLEMENTARY_DEF"
            Begin Extent = 
               Top = 11
               Left = 11
               Bottom = 141
               Right = 231
            End
            DisplayFlags = 280
            TopColumn = 3
         End
         Begin Table = "SUPLEMENTARY_PARENT_1"
            Begin Extent = 
               Top = 10
               Left = 299
               Bottom = 140
               Right = 504
 ', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'rpt_VSupplementary_Bills';

