﻿CREATE TABLE [dbo].[EXAM_STD_COMMENTS] (
    [EXAM_STD_COM_ID]        NUMERIC (18)    IDENTITY (1, 1) NOT NULL,
    [EXAM_STD_COM_STD_ID]    NUMERIC (18)    NULL,
    [EXAM_STD_COM_CLASS_ID]  NUMERIC (18)    NULL,
    [EXAM_STD_COM_TERM_ID]   NUMERIC (18)    NULL,
    [EXAM_STD_COM_COMMENTS]  NVARCHAR (1000) NULL,
    [EXAM_STD_COM_IS_RETEST] BIT             NULL,
    CONSTRAINT [PK_EXAM_STD_COMMENTS] PRIMARY KEY CLUSTERED ([EXAM_STD_COM_ID] ASC),
    CONSTRAINT [FK_EXAM_STD_COMMENTS_SCHOOL_PLANE] FOREIGN KEY ([EXAM_STD_COM_CLASS_ID]) REFERENCES [dbo].[SCHOOL_PLANE] ([CLASS_ID]),
    CONSTRAINT [FK_EXAM_STD_COMMENTS_STUDENT_INFO] FOREIGN KEY ([EXAM_STD_COM_STD_ID]) REFERENCES [dbo].[STUDENT_INFO] ([STDNT_ID]),
    CONSTRAINT [FK_EXAM_STD_COMMENTS_TERM_INFO] FOREIGN KEY ([EXAM_STD_COM_TERM_ID]) REFERENCES [dbo].[TERM_INFO] ([TERM_ID])
);

