﻿CREATE TABLE [dbo].[CITY_INFO] (
    [CITY_ID]     NUMERIC (18)   IDENTITY (1, 1) NOT NULL,
    [CITY_HD_ID]  NUMERIC (18)   NOT NULL,
    [CITY_BR_ID]  NUMERIC (18)   NULL,
    [CITY_NAME]   NVARCHAR (50)  NULL,
    [CITY_DESC]   NVARCHAR (500) NULL,
    [CITY_STATUS] CHAR (2)       NULL,
    CONSTRAINT [PK_CITY] PRIMARY KEY CLUSTERED ([CITY_ID] ASC),
    CONSTRAINT [FK_CITY_INFO_BR_ADMIN] FOREIGN KEY ([CITY_BR_ID]) REFERENCES [dbo].[BR_ADMIN] ([BR_ADM_ID]),
    CONSTRAINT [FK_CITY_INFO_MAIN_HD_INFO] FOREIGN KEY ([CITY_HD_ID]) REFERENCES [dbo].[MAIN_HD_INFO] ([MAIN_INFO_ID])
);

