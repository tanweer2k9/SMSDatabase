CREATE VIEW [dbo].[rpt_VSupplementaryBills]
AS
SELECT        dbo.STUDENT_INFO.STDNT_FIRST_NAME AS [First Name], dbo.STUDENT_INFO.STDNT_LAST_NAME AS [Last Name], dbo.SCHOOL_PLANE.CLASS_Name AS Class, dbo.SECTION_INFO.SECT_NAME AS Section, 
                         dbo.STUDENT_INFO.STDNT_ID AS [Std ID], dbo.STUDENT_FEE_NOTES.STD_FEE_NOTES_DESCRIPTION AS Notes, dbo.STUDENT_FEE_NOTES.STD_FEE_NOTES_STATUS, 
                         dbo.PARENT_INFO.PARNT_FIRST_NAME AS [Father Name], dbo.BR_ADMIN.BR_ADM_BANK_NAME AS [Bank Name], dbo.BR_ADMIN.BR_ADM_ACCT_TITLE AS [Bank Acct Title], 
                         dbo.BR_ADMIN.BR_ADM_ACCT_NO AS [Bank Acct no], dbo.STUDENT_INFO.STDNT_SCHOOL_ID AS [School ID], dbo.PARENT_INFO.PARNT_CELL_NO AS [Parent Cell], 
                         dbo.STUDENT_INFO.STDNT_CELL_NO AS [Student Cell], dbo.PARENT_INFO.PARNT_TEMP_ADDR + ' ' + dbo.AREA_INFO.AREA_NAME + ' ' + dbo.CITY_INFO.CITY_NAME AS [Parent Address], 
                         dbo.PARENT_INFO.PARNT_FAMILY_CODE AS [Family Code], dbo.STUDENT_INFO.STDNT_PARANT_ID AS [Parent ID]
FROM            dbo.AREA_INFO INNER JOIN
                         dbo.PARENT_INFO INNER JOIN
                         dbo.STUDENT_INFO ON dbo.PARENT_INFO.PARNT_ID = dbo.STUDENT_INFO.STDNT_PARANT_ID ON dbo.AREA_INFO.AREA_ID = dbo.PARENT_INFO.PARNT_AREA INNER JOIN
                         dbo.CITY_INFO ON dbo.PARENT_INFO.PARNT_CITY = dbo.CITY_INFO.CITY_ID LEFT OUTER JOIN
                         dbo.BR_ADMIN ON dbo.STUDENT_INFO.STDNT_BR_ID = dbo.BR_ADMIN.BR_ADM_ID CROSS JOIN
                         dbo.CLASS_INFO INNER JOIN
                         dbo.STUDENT_FEE_NOTES INNER JOIN
                         dbo.SCHOOL_PLANE ON dbo.STUDENT_FEE_NOTES.STD_FEE_NOTES_CLASS_ID = dbo.SCHOOL_PLANE.CLASS_ID ON dbo.CLASS_INFO.CLASS_ID = dbo.SCHOOL_PLANE.CLASS_CLASS INNER JOIN
                         dbo.SECTION_INFO ON dbo.SCHOOL_PLANE.CLASS_SECTION = dbo.SECTION_INFO.SECT_ID
WHERE        (dbo.STUDENT_FEE_NOTES.STD_FEE_NOTES_STATUS = 'T')
GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 2, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'rpt_VSupplementaryBills';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane2', @value = N'           DisplayFlags = 280
            TopColumn = 2
         End
         Begin Table = "SCHOOL_PLANE"
            Begin Extent = 
               Top = 6
               Left = 735
               Bottom = 136
               Right = 1005
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "SECTION_INFO"
            Begin Extent = 
               Top = 138
               Left = 992
               Bottom = 268
               Right = 1162
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
         Column = 3615
         Alias = 3375
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
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'rpt_VSupplementaryBills';


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
            TopColumn = 0
         End
         Begin Table = "STUDENT_INFO"
            Begin Extent = 
               Top = 6
               Left = 415
               Bottom = 136
               Right = 697
            End
            DisplayFlags = 280
            TopColumn = 0
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
         Begin Table = "BR_ADMIN"
            Begin Extent = 
               Top = 138
               Left = 329
               Bottom = 268
               Right = 746
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "CLASS_INFO"
            Begin Extent = 
               Top = 138
               Left = 784
               Bottom = 268
               Right = 954
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "STUDENT_FEE_NOTES"
            Begin Extent = 
               Top = 138
               Left = 38
               Bottom = 268
               Right = 291
            End
 ', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'rpt_VSupplementaryBills';

