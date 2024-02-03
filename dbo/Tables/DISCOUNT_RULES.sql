﻿CREATE TABLE [dbo].[DISCOUNT_RULES] (
    [DIS_RUL_ID]       NUMERIC (18)   IDENTITY (1, 1) NOT NULL,
    [DIS_RUL_HD_ID]    NUMERIC (18)   NULL,
    [DIS_RUL_BR_ID]    NUMERIC (18)   NULL,
    [DIS_RUL_NAME]     NVARCHAR (200) NULL,
    [DIS_RUL_STATUS]   CHAR (2)       NULL,
    [DIS_RUL_DATETIME] DATETIME       NULL,
    [DIS_RUL_USER]     NVARCHAR (50)  NULL,
    [DIS_RUL_CLASS_ID] NUMERIC (18)   NULL,
    CONSTRAINT [PK_DISCOUNT_RULES] PRIMARY KEY CLUSTERED ([DIS_RUL_ID] ASC),
    CONSTRAINT [FK_DISCOUNT_RULES_BR_ADMIN] FOREIGN KEY ([DIS_RUL_BR_ID]) REFERENCES [dbo].[BR_ADMIN] ([BR_ADM_ID]),
    CONSTRAINT [FK_DISCOUNT_RULES_MAIN_HD_INFO] FOREIGN KEY ([DIS_RUL_HD_ID]) REFERENCES [dbo].[MAIN_HD_INFO] ([MAIN_INFO_ID]),
    CONSTRAINT [FK_DISCOUNT_RULES_SCHOOL_PLANE] FOREIGN KEY ([DIS_RUL_CLASS_ID]) REFERENCES [dbo].[SCHOOL_PLANE] ([CLASS_ID])
);
