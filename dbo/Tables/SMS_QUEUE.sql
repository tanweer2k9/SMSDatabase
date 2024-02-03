﻿CREATE TABLE [dbo].[SMS_QUEUE] (
    [SMS_QUEUE_ID]        NUMERIC (18)   IDENTITY (1, 1) NOT NULL,
    [SMS_QUEUE_HD_ID]     NUMERIC (18)   NULL,
    [SMS_QUEUE_BR_ID]     NUMERIC (18)   NULL,
    [SMS_QUEUE_MOBILE_NO] NVARCHAR (100) NULL,
    [SMS_QUEUE_MESSAGE]   NVARCHAR (200) NULL,
    [SMS_QUEUE_SCREEN_ID] FLOAT (53)     NULL,
    [SMS_QUEUE_USER_ID]   NUMERIC (18)   NULL,
    [SMS_QUEUE_DATE_TIME] DATETIME       NULL,
    [SMS_QUEUE_STATUS]    CHAR (2)       NULL,
    CONSTRAINT [PK_SMS_QUEUE] PRIMARY KEY CLUSTERED ([SMS_QUEUE_ID] ASC),
    CONSTRAINT [FK_SMS_QUEUE_BR_ADMIN] FOREIGN KEY ([SMS_QUEUE_BR_ID]) REFERENCES [dbo].[BR_ADMIN] ([BR_ADM_ID]),
    CONSTRAINT [FK_SMS_QUEUE_MAIN_HD_INFO] FOREIGN KEY ([SMS_QUEUE_HD_ID]) REFERENCES [dbo].[MAIN_HD_INFO] ([MAIN_INFO_ID])
);

