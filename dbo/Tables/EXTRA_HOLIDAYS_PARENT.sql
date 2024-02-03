﻿CREATE TABLE [dbo].[EXTRA_HOLIDAYS_PARENT] (
    [ID]                  NUMERIC (18)   IDENTITY (1, 1) NOT NULL,
    [HD_ID]               NUMERIC (18)   NULL,
    [BR_ID]               NUMERIC (18)   NULL,
    [FROM_DATE]           DATE           NULL,
    [TO_DATE]             DATE           NULL,
    [DESCRIPTION_STATUS]  NVARCHAR (500) NULL,
    [DAY_TYPE]            NVARCHAR (50)  NULL,
    [IS_SALARY_GENERATED] BIT            NULL,
    [CREATED_BY]          NVARCHAR (50)  NULL,
    [CREATED_DATE]        DATETIME       NULL,
    [UPDATED_BY]          NVARCHAR (50)  NULL,
    [UPDATED_DATE]        DATETIME       NULL,
    CONSTRAINT [PK_EXTRA_HOLIDAYS_PARENT] PRIMARY KEY CLUSTERED ([ID] ASC),
    CONSTRAINT [FK_EXTRA_HOLIDAYS_PARENT_BR_ADMIN] FOREIGN KEY ([BR_ID]) REFERENCES [dbo].[BR_ADMIN] ([BR_ADM_ID]),
    CONSTRAINT [FK_EXTRA_HOLIDAYS_PARENT_MAIN_HD_INFO] FOREIGN KEY ([HD_ID]) REFERENCES [dbo].[MAIN_HD_INFO] ([MAIN_INFO_ID])
);

