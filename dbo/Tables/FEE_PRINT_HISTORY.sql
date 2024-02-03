﻿CREATE TABLE [dbo].[FEE_PRINT_HISTORY] (
    [FEE_PRINT_HISTORY_ID]               NUMERIC (18)  IDENTITY (1, 1) NOT NULL,
    [FEE_PRINT_HISTORY_HD_ID]            NUMERIC (18)  NULL,
    [FEE_PRINT_HISTORY_BR_ID]            NUMERIC (18)  NULL,
    [FEE_PRINT_HISTORY_BILL_ID]          NUMERIC (18)  NULL,
    [FEE_PRINT_HISTORY_DATE]             DATETIME      NULL,
    [FEE_PRINT_HISTORY_INSERTED_BY_ID]   NUMERIC (18)  NULL,
    [FEE_PRINT_HISTORY_INSERTED_BY_TYPE] NVARCHAR (50) NULL,
    [FEE_PRINT_HISTORY_STATUS]           CHAR (2)      NULL,
    CONSTRAINT [PK_FEE_PRINT_HISTORY] PRIMARY KEY CLUSTERED ([FEE_PRINT_HISTORY_ID] ASC),
    CONSTRAINT [FK_FEE_PRINT_HISTORY_BR_ADMIN] FOREIGN KEY ([FEE_PRINT_HISTORY_BR_ID]) REFERENCES [dbo].[BR_ADMIN] ([BR_ADM_ID]),
    CONSTRAINT [FK_FEE_PRINT_HISTORY_FEE_COLLECT] FOREIGN KEY ([FEE_PRINT_HISTORY_BILL_ID]) REFERENCES [dbo].[FEE_COLLECT] ([FEE_COLLECT_ID]),
    CONSTRAINT [FK_FEE_PRINT_HISTORY_MAIN_HD_INFO] FOREIGN KEY ([FEE_PRINT_HISTORY_HD_ID]) REFERENCES [dbo].[MAIN_HD_INFO] ([MAIN_INFO_ID])
);
