﻿CREATE TABLE [dbo].[SUPLEMENTARY_STUDENTS_SETTINGS] (
    [SUPL_STD_ID]         NUMERIC (18) IDENTITY (1, 1) NOT NULL,
    [SUPL_STD_HD_ID]      NUMERIC (18) NULL,
    [SUPL_STD_BR_ID]      NUMERIC (18) NULL,
    [SUPL_STD_STUDENT_ID] NUMERIC (18) NULL,
    [SUPL_STD_GPA]        FLOAT (53)   NULL,
    [SUPL_STD_FEE]        FLOAT (53)   NULL,
    [SUPL_STD_Percentage] FLOAT (53)   NULL,
    CONSTRAINT [PK_SUPLEMENTARY_STUDENTS_SETTINGS] PRIMARY KEY CLUSTERED ([SUPL_STD_ID] ASC),
    CONSTRAINT [FK_SUPLEMENTARY_STUDENTS_SETTINGS_BR_ADMIN] FOREIGN KEY ([SUPL_STD_BR_ID]) REFERENCES [dbo].[BR_ADMIN] ([BR_ADM_ID]),
    CONSTRAINT [FK_SUPLEMENTARY_STUDENTS_SETTINGS_MAIN_HD_INFO] FOREIGN KEY ([SUPL_STD_HD_ID]) REFERENCES [dbo].[MAIN_HD_INFO] ([MAIN_INFO_ID]),
    CONSTRAINT [FK_SUPLEMENTARY_STUDENTS_SETTINGS_STUDENT_INFO] FOREIGN KEY ([SUPL_STD_STUDENT_ID]) REFERENCES [dbo].[STUDENT_INFO] ([STDNT_ID])
);

