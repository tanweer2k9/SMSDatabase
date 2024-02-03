﻿CREATE TABLE [dbo].[EXAM_STD_INFO] (
    [EXAM_STD_INFO_ID]              NUMERIC (18)   IDENTITY (1, 1) NOT NULL,
    [EXAM_STD_INFO_STD_ID]          NUMERIC (18)   NULL,
    [EXAM_STD_INFO_HEIGHT]          FLOAT (53)     NULL,
    [EXAM_STD_INFO_WEIGHT]          FLOAT (53)     NULL,
    [EXAM_STD_INFO_DAYS_ATTENDED]   INT            NULL,
    [EXAM_STD_INFO_DAYS_ABSENT]     INT            NULL,
    [EXAM_STD_CLASS_ID]             NUMERIC (18)   NULL,
    [EXAM_STD_TEACHER_COMMENT]      NVARCHAR (500) NULL,
    [EXAM_STD_PRINCIPAL_COMMENT]    NVARCHAR (500) NULL,
    [EXAM_STD_IS_DISAPPROVE]        BIT            NULL,
    [EXAM_STD_PID]                  NUMERIC (18)   NULL,
    [EXAM_STD_COMPLETE_CITRIX]      NVARCHAR (500) NULL,
    [EXAM_STD_CITRIX_ENGLISH_SCORE] NVARCHAR (500) NULL,
    [EXAM_STD_CITRIX_MATH_SCORE]    NVARCHAR (500) NULL,
    [EXAM_STD_CITRIX_URDU_SCORE]    NVARCHAR (500) NULL,
    [CreatedBy]                     NUMERIC (18)   NULL,
    [CreatedDate]                   DATETIME       NULL,
    [UpdatedBy]                     NUMERIC (18)   NULL,
    [UpdatedDate]                   DATETIME       NULL,
    CONSTRAINT [PK_EXAM_STD_INFO] PRIMARY KEY CLUSTERED ([EXAM_STD_INFO_ID] ASC),
    CONSTRAINT [FK_EXAM_STD_INFO_EXAM_CRITERIA_KEY_Parent] FOREIGN KEY ([EXAM_STD_PID]) REFERENCES [dbo].[EXAM_CRITERIA_KEY_Parent] ([Id]),
    CONSTRAINT [FK_EXAM_STD_INFO_SCHOOL_PLANE] FOREIGN KEY ([EXAM_STD_CLASS_ID]) REFERENCES [dbo].[SCHOOL_PLANE] ([CLASS_ID]),
    CONSTRAINT [FK_EXAM_STD_INFO_STUDENT_INFO] FOREIGN KEY ([EXAM_STD_INFO_STD_ID]) REFERENCES [dbo].[STUDENT_INFO] ([STDNT_ID])
);



