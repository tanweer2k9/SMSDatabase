﻿CREATE TABLE [dbo].[FEE_HISTORY_DEF] (
    [FEE_HISTORY_DEF_ID]               NUMERIC (18) IDENTITY (1, 1) NOT NULL,
    [FEE_HISTORY_DEF_HID]              NUMERIC (18) NULL,
    [FEE_HISTORY_DEF_PID]              NUMERIC (18) NULL,
    [FEE_HISTORY_DEF_NAME]             NUMERIC (18) NULL,
    [FEE_HISTORY_DEF_FEE]              FLOAT (53)   NULL,
    [FEE_HISTORY_DEF_PAID]             FLOAT (53)   NULL,
    [FEE_HISTORY_DEF_MIN]              FLOAT (53)   NULL,
    [FEE_HISTORY_DEF_MAX]              FLOAT (53)   NULL,
    [FEE_HISTORY_DEF_OPERATION]        CHAR (1)     NULL,
    [FEE_HISTORY_DEF_ARREARS]          FLOAT (53)   NULL,
    [FEE_HISTORY_DEF_ARREARS_RECEIVED] FLOAT (53)   NULL,
    [FEE_HISTORY_DEF_TOTAL]            FLOAT (53)   NULL,
    CONSTRAINT [PK_FEE_HISTORY_DEF] PRIMARY KEY CLUSTERED ([FEE_HISTORY_DEF_ID] ASC),
    CONSTRAINT [FK_FEE_HISTORY_DEF_FEE_HISTORY] FOREIGN KEY ([FEE_HISTORY_DEF_PID]) REFERENCES [dbo].[FEE_HISTORY] ([FEE_HISTORY_ID]) ON DELETE CASCADE,
    CONSTRAINT [FK_FEE_HISTORY_DEF_FEE_INFO] FOREIGN KEY ([FEE_HISTORY_DEF_NAME]) REFERENCES [dbo].[FEE_INFO] ([FEE_ID])
);

