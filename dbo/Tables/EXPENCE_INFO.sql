﻿CREATE TABLE [dbo].[EXPENCE_INFO] (
    [EXPENCE_ID]     NUMERIC (18)   IDENTITY (1, 1) NOT NULL,
    [EXPENCE_HD_ID]  NVARCHAR (50)  NULL,
    [EXPENCE_BR_ID]  NVARCHAR (50)  NULL,
    [EXPENCE_NAME]   NVARCHAR (50)  NULL,
    [EXPENCE_DESC]   NVARCHAR (MAX) NULL,
    [EXPENCE_STATUS] CHAR (2)       NULL,
    CONSTRAINT [PK_EXPENCE] PRIMARY KEY CLUSTERED ([EXPENCE_ID] ASC)
);
