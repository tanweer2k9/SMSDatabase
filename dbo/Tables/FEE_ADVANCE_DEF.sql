﻿CREATE TABLE [dbo].[FEE_ADVANCE_DEF] (
    [ADV_FEE_DEF_ID]             NUMERIC (18) IDENTITY (1, 1) NOT NULL,
    [ADV_FEE_DEF_PID]            NUMERIC (18) NULL,
    [ADV_FEE_DEF_FROM_DATE]      DATE         NULL,
    [ADV_FEE_DEF_TO_DATE]        DATE         NULL,
    [ADV_FEE_DEF_AMOUNT]         FLOAT (53)   NULL,
    [ADV_FEE_DEF_ADJUST_DATE]    DATE         NULL,
    [ADV_FEE_DEF_FEE_COLLECT_ID] NUMERIC (18) NULL,
    [ADV_FEE_DEF_STATUS]         CHAR (2)     NULL,
    CONSTRAINT [PK_ADVANCE_FEE_DEF] PRIMARY KEY CLUSTERED ([ADV_FEE_DEF_ID] ASC),
    CONSTRAINT [FK_FEE_ADVANCE_DEF_FEE_ADVANCE] FOREIGN KEY ([ADV_FEE_DEF_PID]) REFERENCES [dbo].[FEE_ADVANCE] ([ADV_FEE_ID]),
    CONSTRAINT [FK_FEE_ADVANCE_DEF_FEE_COLLECT] FOREIGN KEY ([ADV_FEE_DEF_FEE_COLLECT_ID]) REFERENCES [dbo].[FEE_COLLECT] ([FEE_COLLECT_ID])
);

