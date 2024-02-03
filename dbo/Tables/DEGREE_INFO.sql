﻿CREATE TABLE [dbo].[DEGREE_INFO] (
    [DGRE_ID]     NUMERIC (18)   IDENTITY (1, 1) NOT NULL,
    [DGRE_HD_ID]  NUMERIC (18)   NOT NULL,
    [DGRE_BR_ID]  NUMERIC (18)   NULL,
    [DGRE_NAME]   NVARCHAR (50)  NULL,
    [DGRE_DESC]   NVARCHAR (MAX) NOT NULL,
    [DGRE_STATUS] CHAR (2)       NULL,
    CONSTRAINT [PK_DEGREE] PRIMARY KEY CLUSTERED ([DGRE_ID] ASC),
    CONSTRAINT [FK_DEGREE_INFO_BR_ADMIN] FOREIGN KEY ([DGRE_BR_ID]) REFERENCES [dbo].[BR_ADMIN] ([BR_ADM_ID]),
    CONSTRAINT [FK_DEGREE_INFO_MAIN_HD_INFO] FOREIGN KEY ([DGRE_HD_ID]) REFERENCES [dbo].[MAIN_HD_INFO] ([MAIN_INFO_ID])
);
