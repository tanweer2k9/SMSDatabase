﻿CREATE TABLE [dbo].[STAFF_WORKING_DAYS] (
    [STAFF_WORKING_DAYS_ID]         NUMERIC (18)   IDENTITY (1, 1) NOT NULL,
    [STAFF_WORKING_DAYS_HD_ID]      NUMERIC (18)   NULL,
    [STAFF_WORKING_DAYS_BR_ID]      NUMERIC (18)   NULL,
    [STAFF_WORKING_DAYS_NAME]       NVARCHAR (200) NULL,
    [STAFF_WORKING_DAYS_DAY_STATUS] CHAR (2)       NULL,
    [STAFF_WORKING_DAYS_TIME_IN]    NVARCHAR (100) NULL,
    [STAFF_WORKING_DAYS_TIME_OUT]   NVARCHAR (100) NULL,
    [STAFF_WORKING_DAYS_USER]       NVARCHAR (100) NULL,
    [STAFF_WORKING_DAYS_STAFF_ID]   NUMERIC (18)   NULL,
    [STAFF_WORKING_DAYS_DATE]       DATETIME       NULL,
    [STAFF_WORKING_DAYS_PACKAGE_ID] NUMERIC (18)   NULL,
    [STAFF_WORKING_DAYS_STATUS]     CHAR (2)       NULL,
    CONSTRAINT [PK_STAFF_WORKING_DAYS] PRIMARY KEY CLUSTERED ([STAFF_WORKING_DAYS_ID] ASC),
    CONSTRAINT [FK_STAFF_WORKING_DAYS_BR_ADMIN] FOREIGN KEY ([STAFF_WORKING_DAYS_BR_ID]) REFERENCES [dbo].[BR_ADMIN] ([BR_ADM_ID]),
    CONSTRAINT [FK_STAFF_WORKING_DAYS_MAIN_HD_INFO] FOREIGN KEY ([STAFF_WORKING_DAYS_HD_ID]) REFERENCES [dbo].[MAIN_HD_INFO] ([MAIN_INFO_ID]),
    CONSTRAINT [FK_STAFF_WORKING_DAYS_TEACHER_INFO] FOREIGN KEY ([STAFF_WORKING_DAYS_STAFF_ID]) REFERENCES [dbo].[TEACHER_INFO] ([TECH_ID])
);

