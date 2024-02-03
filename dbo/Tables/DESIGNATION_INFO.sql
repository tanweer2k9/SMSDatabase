﻿CREATE TABLE [dbo].[DESIGNATION_INFO] (
    [DESIGNATION_ID]     NUMERIC (18)   IDENTITY (1, 1) NOT NULL,
    [DESIGNATION_HD_ID]  NUMERIC (18)   NULL,
    [DESIGNATION_BR_ID]  NUMERIC (18)   NULL,
    [DESIGNATION_NAME]   NVARCHAR (50)  NULL,
    [DESIGNATION_DESC]   NVARCHAR (MAX) NULL,
    [DESIGNATION_STATUS] NCHAR (2)      NULL,
    CONSTRAINT [PK_DESIGNATION_INFO] PRIMARY KEY CLUSTERED ([DESIGNATION_ID] ASC),
    CONSTRAINT [FK_DESIGNATION_INFO_BR_ADMIN] FOREIGN KEY ([DESIGNATION_BR_ID]) REFERENCES [dbo].[BR_ADMIN] ([BR_ADM_ID]),
    CONSTRAINT [FK_DESIGNATION_INFO_MAIN_HD_INFO] FOREIGN KEY ([DESIGNATION_HD_ID]) REFERENCES [dbo].[MAIN_HD_INFO] ([MAIN_INFO_ID])
);

