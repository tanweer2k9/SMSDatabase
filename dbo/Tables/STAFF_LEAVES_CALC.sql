﻿CREATE TABLE [dbo].[STAFF_LEAVES_CALC] (
    [STAFF_LEAVES_CALC_ID]                  NUMERIC (18) IDENTITY (1, 1) NOT NULL,
    [STAFF_LEAVES_CALC_STAFF_ID]            NUMERIC (18) NULL,
    [STAFF_LEAVES_CALC_DATE]                DATE         NULL,
    [STAFF_LEAVES_CALC_MONTHLY_LIMIT]       FLOAT (53)   NULL,
    [STAFF_LEAVES_CALC_LEAVE]               FLOAT (53)   NULL,
    [STAFF_LEAVES_CALC_ABSENT]              FLOAT (53)   NULL,
    [STAFF_LEAVES_CALC_PRESENT]             NUMERIC (18) NULL,
    [STAFF_LEAVES_CALC_LATE]                NUMERIC (18) NULL,
    [STAFF_LEAVES_CALC_MONTH_STATUS]        CHAR (2)     NULL,
    [STAFF_LEAVES_CALC_YEAR_STATUS]         CHAR (2)     NULL,
    [STAFF_LEAVES_CALC_LATE_LIMIT]          INT          NULL,
    [STAFF_LEAVES_CALC_CAUSAL_LEAVES]       FLOAT (53)   NULL,
    [STAFF_LEAVES_CALC_ANNUAL_LEAVES]       FLOAT (53)   NULL,
    [STAFF_LEAVES_CALC_ANNUAL_LEAVES_LIMIT] FLOAT (53)   NULL,
    [STAFF_LEAVES_CALC_SANDWICH_DAYS]       INT          NULL,
    CONSTRAINT [PK_STAFF_LEAVES_CALC] PRIMARY KEY CLUSTERED ([STAFF_LEAVES_CALC_ID] ASC),
    CONSTRAINT [FK_STAFF_LEAVES_CALC_TEACHER_INFO] FOREIGN KEY ([STAFF_LEAVES_CALC_STAFF_ID]) REFERENCES [dbo].[TEACHER_INFO] ([TECH_ID])
);

