﻿CREATE TABLE [dbo].[SUPPLEMENTARY_MONTHS_INFO] (
    [SUPL_MONTH_ID]     NUMERIC (18)   IDENTITY (1, 1) NOT NULL,
    [SUPL_MONTH_HD_ID]  NUMERIC (18)   NULL,
    [SUPL_MONTH_BR_ID]  NUMERIC (18)   NULL,
    [SUPL_MONTH_NAME]   NVARCHAR (50)  NULL,
    [SUPL_FROM_DATE]    DATE           NULL,
    [SUPL_TO_DATE]      DATE           NULL,
    [SUPL_MONTH_DESC]   NVARCHAR (500) NULL,
    [SUPL_MONTH_STATUS] CHAR (2)       NULL,
    CONSTRAINT [PK_SUPPLEMENTARY_MONTHS_INFO] PRIMARY KEY CLUSTERED ([SUPL_MONTH_ID] ASC),
    CONSTRAINT [FK_SUPPLEMENTARY_MONTHS_INFO_BR_ADMIN] FOREIGN KEY ([SUPL_MONTH_BR_ID]) REFERENCES [dbo].[BR_ADMIN] ([BR_ADM_ID]),
    CONSTRAINT [FK_SUPPLEMENTARY_MONTHS_INFO_MAIN_HD_INFO] FOREIGN KEY ([SUPL_MONTH_HD_ID]) REFERENCES [dbo].[MAIN_HD_INFO] ([MAIN_INFO_ID])
);
