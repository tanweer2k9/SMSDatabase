﻿CREATE TABLE [dbo].[ROYALTY_FEE_SETTING] (
    [ROYALTY_ID]         NUMERIC (18)    IDENTITY (1, 1) NOT NULL,
    [ROYALTY_BR_ID]      NUMERIC (18)    NULL,
    [ROYALTY_FEE_ID]     NUMERIC (18)    NULL,
    [ROYALTY_PERCENTAGE] NUMERIC (18, 2) NULL,
    CONSTRAINT [PK_ROYALTY_FEE_SETTING] PRIMARY KEY CLUSTERED ([ROYALTY_ID] ASC),
    CONSTRAINT [FK_ROYALTY_FEE_SETTING_BR_ADMIN] FOREIGN KEY ([ROYALTY_BR_ID]) REFERENCES [dbo].[BR_ADMIN] ([BR_ADM_ID]),
    CONSTRAINT [FK_ROYALTY_FEE_SETTING_ROYALTY_FEE_SETTING] FOREIGN KEY ([ROYALTY_FEE_ID]) REFERENCES [dbo].[FEE_INFO] ([FEE_ID])
);

