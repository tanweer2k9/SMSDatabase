CREATE VIEW [dbo].[VBOOKS_INFO]
AS
SELECT        dbo.BOOKS_INFO.BOOKS_INFO_ID AS ID, dbo.BOOKS_INFO.BOOKS_INFO_HD_ID AS [HD ID], dbo.BOOKS_INFO.BOOKS_INFO_BR_ID AS [BR ID], dbo.BOOKS_INFO.BOOKS_INFO_BOOK_NO AS [Book No], 
                         dbo.BOOKS_INFO.BOOKS_INFO_TITLE AS [Book Title], dbo.BOOKS_INFO.BOOKS_INFO_ISBN AS [Book ISBN], dbo.BOOKS_INFO.BOOKS_INFO_AUTHOR AS [Book Author], 
                         dbo.BOOKS_INFO.BOOKS_INFO_YEAR_PUBLISHED AS [Published Year], dbo.BOOKS_INFO.BOOKS_INFO_CATEGORY AS [Category ID], dbo.BOOKS_CATEGORIES.BOOK_CAT_NAME AS Category, 
                         dbo.BOOKS_INFO.BOOKS_INFO_RACK_NO AS [Rack No], dbo.BOOKS_INFO.BOOKS_INFO_SHELF_NO AS [Shelf No], dbo.BOOKS_INFO.BOOKS_INFO_DATE_ARRIVED AS [Date Arrived], 
                         dbo.BOOKS_INFO.BOOKS_INFO_PRICE AS Price, dbo.BOOKS_INFO.BOOKS_INFO_QTY AS Quantity, dbo.BOOKS_INFO.BOOKS_INFO_BOOK_STATUS AS [Book Status], 
                         dbo.BOOKS_INFO.BOOKS_INFO_STATUS AS Status
FROM            dbo.BOOKS_INFO INNER JOIN
                         dbo.BOOKS_CATEGORIES ON dbo.BOOKS_INFO.BOOKS_INFO_CATEGORY = dbo.BOOKS_CATEGORIES.BOOK_CAT_ID
GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'VBOOKS_INFO';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane1', @value = N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[33] 4[28] 2[20] 3) )"
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
         Begin Table = "BOOKS_INFO"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 295
            End
            DisplayFlags = 280
            TopColumn = 12
         End
         Begin Table = "BOOKS_CATEGORIES"
            Begin Extent = 
               Top = 6
               Left = 333
               Bottom = 136
               Right = 560
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
         Column = 3165
         Alias = 3045
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
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'VBOOKS_INFO';

