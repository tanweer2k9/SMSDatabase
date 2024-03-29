﻿CREATE TABLE [dbo].[SESSION_INFO] (
    [SESSION_ID]         NUMERIC (18)   IDENTITY (1, 1) NOT NULL,
    [SESSION_HD_ID]      NUMERIC (18)   NOT NULL,
    [SESSION_BR_ID]      NUMERIC (18)   NULL,
    [SESSION_DESC]       NVARCHAR (MAX) NOT NULL,
    [SESSION_STATUS]     CHAR (2)       NULL,
    [SESSION_START_DATE] DATE           NULL,
    [SESSION_END_DATE]   DATE           NULL,
    [SESSION_RANK]       INT            NULL,
    CONSTRAINT [PK_SESSION] PRIMARY KEY CLUSTERED ([SESSION_ID] ASC),
    CONSTRAINT [FK_SESSION_INFO_BR_ADMIN] FOREIGN KEY ([SESSION_BR_ID]) REFERENCES [dbo].[BR_ADMIN] ([BR_ADM_ID]),
    CONSTRAINT [FK_SESSION_INFO_MAIN_HD_INFO] FOREIGN KEY ([SESSION_HD_ID]) REFERENCES [dbo].[MAIN_HD_INFO] ([MAIN_INFO_ID])
);

