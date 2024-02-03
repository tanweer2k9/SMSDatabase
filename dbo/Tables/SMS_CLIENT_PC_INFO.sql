﻿CREATE TABLE [dbo].[SMS_CLIENT_PC_INFO] (
    [SMS_CLIENT_PC_ID]      NUMERIC (18)   IDENTITY (1, 1) NOT NULL,
    [SMS_CLIENT_PC_NAME]    NVARCHAR (100) NULL,
    [SMS_CLIENT_PC_WINDOWS] NVARCHAR (100) NULL,
    [SMS_CLIENT_PC_MAC]     NVARCHAR (100) NULL,
    CONSTRAINT [PK_SMS_CLIENT_PC_INFO] PRIMARY KEY CLUSTERED ([SMS_CLIENT_PC_ID] ASC)
);
