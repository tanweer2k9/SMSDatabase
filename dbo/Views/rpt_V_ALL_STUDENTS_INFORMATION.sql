CREATE VIEW [dbo].[rpt_V_ALL_STUDENTS_INFORMATION]
AS
SELECT        dbo.STUDENT_INFO.STDNT_HD_ID AS [Institute ID], dbo.STUDENT_INFO.STDNT_BR_ID AS [Branch ID], dbo.STUDENT_INFO.STDNT_SCHOOL_ID AS [School ID], dbo.STUDENT_INFO.STDNT_ID AS [Student ID], 
                         dbo.STUDENT_INFO.STDNT_PARANT_ID AS [Parent ID], dbo.PARENT_INFO.PARNT_FIRST_NAME AS [Parent Name], dbo.STUDENT_INFO.STDNT_CLASS_PLANE_ID AS [Class ID], 
                         dbo.SCHOOL_PLANE.CLASS_Name AS [Class Name], dbo.STUDENT_INFO.STDNT_FIRST_NAME AS [Student Name], dbo.STUDENT_INFO.STDNT_GENDER AS Gender, 
                         dbo.STUDENT_INFO.STDNT_DOB AS [Student DOB], dbo.STUDENT_INFO.STDNT_EMAIL AS [Student Email], dbo.STUDENT_INFO.STDNT_EMERGENCY_CNTCT_NO AS [Emergency Cell], 
                         dbo.STUDENT_INFO.STDNT_TRANSPORT_MODE AS Transport, dbo.STUDENT_INFO.STDNT_REG_DATE AS [Registeration Date], dbo.STUDENT_INFO.STDNT_STATUS AS Status, 
                         dbo.HOUSES_INFO.HOUSES_NAME AS House, CAST(dbo.STUDENT_INFO.STDNT_SCHOOL_ID AS int) AS [Sch ID]
FROM            dbo.STUDENT_INFO INNER JOIN
                         dbo.PARENT_INFO ON dbo.STUDENT_INFO.STDNT_PARANT_ID = dbo.PARENT_INFO.PARNT_ID INNER JOIN
                         dbo.SCHOOL_PLANE ON dbo.STUDENT_INFO.STDNT_CLASS_PLANE_ID = dbo.SCHOOL_PLANE.CLASS_ID INNER JOIN
                         dbo.HOUSES_INFO ON dbo.STUDENT_INFO.STDNT_HOUSE_ID = dbo.HOUSES_INFO.HOUSES_ID
GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'rpt_V_ALL_STUDENTS_INFORMATION';


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
               Left = 38
               Bottom = 136
               Right = 320
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "PARENT_INFO"
            Begin Extent = 
               Top = 138
               Left = 38
               Bottom = 268
               Right = 258
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "SCHOOL_PLANE"
            Begin Extent = 
               Top = 270
               Left = 38
               Bottom = 400
               Right = 308
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "HOUSES_INFO"
            Begin Extent = 
               Top = 138
               Left = 296
               Bottom = 268
               Right = 476
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
         Column = 5415
         Alias = 2175
         Table = 1170
         Output = 1590
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
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'rpt_V_ALL_STUDENTS_INFORMATION';

