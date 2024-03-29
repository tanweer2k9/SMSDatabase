﻿CREATE TABLE [dbo].[BOOKS_INFO] (
    [BOOKS_INFO_ID]             NUMERIC (18)   IDENTITY (1, 1) NOT NULL,
    [BOOKS_INFO_HD_ID]          NUMERIC (18)   NULL,
    [BOOKS_INFO_BR_ID]          NUMERIC (18)   NULL,
    [BOOKS_INFO_BOOK_NO]        NVARCHAR (50)  NULL,
    [BOOKS_INFO_TITLE]          NVARCHAR (100) NULL,
    [BOOKS_INFO_ISBN]           NVARCHAR (50)  NULL,
    [BOOKS_INFO_AUTHOR]         NVARCHAR (100) NULL,
    [BOOKS_INFO_YEAR_PUBLISHED] INT            NULL,
    [BOOKS_INFO_CATEGORY]       NUMERIC (18)   NULL,
    [BOOKS_INFO_RACK_NO]        NVARCHAR (50)  NULL,
    [BOOKS_INFO_SHELF_NO]       NVARCHAR (50)  NULL,
    [BOOKS_INFO_DATE_ARRIVED]   DATE           NULL,
    [BOOKS_INFO_PRICE]          INT            NULL,
    [BOOKS_INFO_QTY]            INT            NULL,
    [BOOKS_INFO_BOOK_STATUS]    NVARCHAR (50)  NULL,
    [BOOKS_INFO_STATUS]         CHAR (1)       NULL,
    CONSTRAINT [PK_BOOKS_INFO] PRIMARY KEY CLUSTERED ([BOOKS_INFO_ID] ASC),
    CONSTRAINT [FK_BOOKS_INFO_BOOKS_CATEGORIES] FOREIGN KEY ([BOOKS_INFO_CATEGORY]) REFERENCES [dbo].[BOOKS_CATEGORIES] ([BOOK_CAT_ID]),
    CONSTRAINT [FK_BOOKS_INFO_BR_ADMIN] FOREIGN KEY ([BOOKS_INFO_BR_ID]) REFERENCES [dbo].[BR_ADMIN] ([BR_ADM_ID]),
    CONSTRAINT [FK_BOOKS_INFO_MAIN_HD_INFO] FOREIGN KEY ([BOOKS_INFO_HD_ID]) REFERENCES [dbo].[MAIN_HD_INFO] ([MAIN_INFO_ID])
);

