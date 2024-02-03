﻿CREATE TABLE [dbo].[ASSESSMENT_INFO] (
    [ASSESSMENT_ID]     NUMERIC (18)   IDENTITY (1, 1) NOT NULL,
    [ASSESSMENT_HD_ID]  NUMERIC (18)   NOT NULL,
    [ASSESSMENT_BR_ID]  NUMERIC (18)   NULL,
    [ASSESSMENT_NAME]   NVARCHAR (50)  NULL,
    [ASSESSMENT_DESC]   NVARCHAR (MAX) NULL,
    [ASSESSMENT_STATUS] CHAR (2)       NULL,
    CONSTRAINT [PK_ASSESSMENT] PRIMARY KEY CLUSTERED ([ASSESSMENT_ID] ASC),
    CONSTRAINT [FK_ASSESSMENT_INFO_BR_ADMIN] FOREIGN KEY ([ASSESSMENT_BR_ID]) REFERENCES [dbo].[BR_ADMIN] ([BR_ADM_ID]),
    CONSTRAINT [FK_ASSESSMENT_INFO_MAIN_HD_INFO] FOREIGN KEY ([ASSESSMENT_HD_ID]) REFERENCES [dbo].[MAIN_HD_INFO] ([MAIN_INFO_ID])
);

