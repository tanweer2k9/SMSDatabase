﻿CREATE TABLE [dbo].[LOAN_TYPE] (
    [LOAN_TYPE_ID]                    NUMERIC (18)  IDENTITY (1, 1) NOT NULL,
    [LOAN_TYPE_BASIC_INSTALLEMENT_NO] NUMERIC (18)  NULL,
    [LOAN_TYPE_MONTH]                 NVARCHAR (20) NULL,
    [LOAN_TYPE_YEAR]                  NVARCHAR (20) NULL,
    [LOAN_TYPE_AMOUNT]                FLOAT (53)    NULL,
    [LOAN_TYPE_LOAN_ID]               NUMERIC (18)  NULL,
    [LOAN_TYPE_INSTALLEMENT_STATUS]   CHAR (2)      NULL,
    [LOAN_TYPE_STATUS]                CHAR (2)      NULL,
    CONSTRAINT [PK_LOAN_TYPE] PRIMARY KEY CLUSTERED ([LOAN_TYPE_ID] ASC),
    CONSTRAINT [FK_LOAN_TYPE_STAFF_LOAN] FOREIGN KEY ([LOAN_TYPE_LOAN_ID]) REFERENCES [dbo].[STAFF_LOAN] ([STAFF_LOAN_ID])
);

