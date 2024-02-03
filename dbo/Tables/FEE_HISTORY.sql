﻿CREATE TABLE [dbo].[FEE_HISTORY] (
    [FEE_HISTORY_ID]               NUMERIC (18)    IDENTITY (1, 1) NOT NULL,
    [FEE_HISTORY_PID]              NUMERIC (18)    NULL,
    [FEE_HISTORY_FEE]              FLOAT (53)      NULL,
    [FEE_HISTORY_PAID]             FLOAT (53)      NULL,
    [FEE_HISTORY_DATE]             DATE            NULL,
    [FEE_HISTORY_STATUS]           NVARCHAR (30)   NULL,
    [FEE_HISTORY_ARREARS]          FLOAT (53)      NULL,
    [FEE_HISTORY_NET_TOTAL]        FLOAT (53)      NULL,
    [FEE_HISTORY_ARREARS_RECEIVED] FLOAT (53)      NULL,
    [FEE_HISTORY_PREVIOUS_DATE]    NVARCHAR (1000) NULL,
    CONSTRAINT [PK_FEE_HISTORY_COLLECT] PRIMARY KEY CLUSTERED ([FEE_HISTORY_ID] ASC),
    CONSTRAINT [FK_FEE_HISTORY_FEE_COLLECT] FOREIGN KEY ([FEE_HISTORY_PID]) REFERENCES [dbo].[FEE_COLLECT] ([FEE_COLLECT_ID]) ON DELETE CASCADE
);

