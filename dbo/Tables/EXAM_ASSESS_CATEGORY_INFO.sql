﻿CREATE TABLE [dbo].[EXAM_ASSESS_CATEGORY_INFO] (
    [EXAM_CAT_ID]          NUMERIC (18)   IDENTITY (1, 1) NOT NULL,
    [EXAM_CAT_HD_ID]       NUMERIC (18)   NULL,
    [EXAM_CAT_BR_ID]       NUMERIC (18)   NULL,
    [EXAM_CAT_MAIN_CAT_ID] NUMERIC (18)   NULL,
    [EXAM_CAT_CLASS_ID]    NUMERIC (18)   NULL,
    [EXAM_CAT_NAME]        NVARCHAR (100) NULL,
    [EXAM_CAT_DESC]        NVARCHAR (500) NULL,
    [EXAM_CAT_STATUS]      CHAR (2)       NULL,
    [EXAM_CAT_ORDER]       INT            NULL,
    CONSTRAINT [PK_EXAM_ASSESS_CATEGORY_INFO] PRIMARY KEY CLUSTERED ([EXAM_CAT_ID] ASC),
    CONSTRAINT [FK_EXAM_ASSESS_CATEGORY_INFO_BR_ADMIN] FOREIGN KEY ([EXAM_CAT_BR_ID]) REFERENCES [dbo].[BR_ADMIN] ([BR_ADM_ID]),
    CONSTRAINT [FK_EXAM_ASSESS_CATEGORY_INFO_MAIN_HD_INFO] FOREIGN KEY ([EXAM_CAT_HD_ID]) REFERENCES [dbo].[MAIN_HD_INFO] ([MAIN_INFO_ID]),
    CONSTRAINT [FK_EXAM_ASSESS_CATEGORY_INFO_SCHOOL_PLANE] FOREIGN KEY ([EXAM_CAT_CLASS_ID]) REFERENCES [dbo].[SCHOOL_PLANE] ([CLASS_ID])
);
