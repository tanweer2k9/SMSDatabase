﻿CREATE TABLE [dbo].[GRADE_MAPPING] (
    [GRADE_MAP_ID]            NUMERIC (18) IDENTITY (1, 1) NOT NULL,
    [GRADE_MAP_HD_ID]         NUMERIC (18) NOT NULL,
    [GRADE_MAP_BR_ID]         NUMERIC (18) NOT NULL,
    [GRADE_MAP_CLASS_ID]      NUMERIC (18) NULL,
    [GRADE_MAP_GRADE_PLAN_ID] NUMERIC (18) NULL,
    [GRADE_MAP_STATUS]        CHAR (2)     NULL,
    CONSTRAINT [PK_GRADE_MAPPING] PRIMARY KEY CLUSTERED ([GRADE_MAP_ID] ASC),
    CONSTRAINT [FK_GRADE_MAPPING_BR_ADMIN] FOREIGN KEY ([GRADE_MAP_BR_ID]) REFERENCES [dbo].[BR_ADMIN] ([BR_ADM_ID]),
    CONSTRAINT [FK_GRADE_MAPPING_MAIN_HD_INFO] FOREIGN KEY ([GRADE_MAP_HD_ID]) REFERENCES [dbo].[MAIN_HD_INFO] ([MAIN_INFO_ID]),
    CONSTRAINT [FK_GRADE_MAPPING_PLAN_GRADE] FOREIGN KEY ([GRADE_MAP_GRADE_PLAN_ID]) REFERENCES [dbo].[PLAN_GRADE] ([P_GRADE_ID]),
    CONSTRAINT [FK_GRADE_MAPPING_SCHOOL_PLANE] FOREIGN KEY ([GRADE_MAP_CLASS_ID]) REFERENCES [dbo].[SCHOOL_PLANE] ([CLASS_ID])
);

