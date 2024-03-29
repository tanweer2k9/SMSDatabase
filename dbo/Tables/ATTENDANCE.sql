﻿CREATE TABLE [dbo].[ATTENDANCE] (
    [ATTENDANCE_ID]                NUMERIC (18)  IDENTITY (1, 1) NOT NULL,
    [ATTENDANCE_HD_ID]             NUMERIC (18)  NULL,
    [ATTENDANCE_BR_ID]             NUMERIC (18)  NULL,
    [ATTENDANCE_TYPE]              NVARCHAR (50) NULL,
    [ATTENDANCE_TYPE_ID]           NUMERIC (18)  NULL,
    [ATTENDANCE_DATE]              DATE          NULL,
    [ATTENDANCE_REMARKS]           NVARCHAR (50) NULL,
    [ATTENDANCE_STATUS]            NCHAR (10)    NULL,
    [ATTENDANCE_CLASS_ID]          NUMERIC (18)  NULL,
    [ATTENDANCE_TIME_IN]           NVARCHAR (50) NULL,
    [ATTENDANCE_TIME_OUT]          NVARCHAR (50) NULL,
    [ATTENDANCE_EXPECTED_TIME_IN]  NVARCHAR (50) NULL,
    [ATTENDANCE_EXPECTED_TIME_OUT] NVARCHAR (50) NULL,
    [ATTENDANCE_ENTERED_DATE]      DATETIME      NULL,
    [ATTENDANCE_USER]              NVARCHAR (50) NULL,
    [ATTENDANCE_STAFF_PC_NAME]     NVARCHAR (50) NULL,
    [ATTENDANCE_STAFF_MACHINE_NO]  NVARCHAR (50) NULL,
    CONSTRAINT [PK_ATTENDANCE] PRIMARY KEY CLUSTERED ([ATTENDANCE_ID] ASC),
    CONSTRAINT [FK_ATTENDANCE_BR_ADMIN] FOREIGN KEY ([ATTENDANCE_BR_ID]) REFERENCES [dbo].[BR_ADMIN] ([BR_ADM_ID]),
    CONSTRAINT [FK_ATTENDANCE_MAIN_HD_INFO] FOREIGN KEY ([ATTENDANCE_HD_ID]) REFERENCES [dbo].[MAIN_HD_INFO] ([MAIN_INFO_ID]),
    CONSTRAINT [FK_ATTENDANCE_STUDENT_INFO] FOREIGN KEY ([ATTENDANCE_TYPE_ID]) REFERENCES [dbo].[STUDENT_INFO] ([STDNT_ID])
);

