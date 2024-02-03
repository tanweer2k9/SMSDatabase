﻿CREATE TABLE [dbo].[SALARY_HOLD_DAYS] (
    [ID]       NUMERIC (18) IDENTITY (1, 1) NOT NULL,
    [STAFF_ID] NUMERIC (18) NULL,
    [DATE]     DATE         NULL,
    [DAYS]     INT          NULL,
    [IS_PAID]  BIT          NULL,
    CONSTRAINT [PK_SALARY_HOLD_DAYS] PRIMARY KEY CLUSTERED ([ID] ASC),
    CONSTRAINT [FK_SALARY_HOLD_DAYS_TEACHER_INFO] FOREIGN KEY ([STAFF_ID]) REFERENCES [dbo].[TEACHER_INFO] ([TECH_ID])
);

