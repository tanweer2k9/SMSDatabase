﻿CREATE TABLE [dbo].[SMS_NOTIFICATION_SETTINGS] (
    [SMS_NOTIFICATION_ID]                NUMERIC (18)   IDENTITY (1, 1) NOT NULL,
    [SMS_NOTIFICATION_HD_ID]             NUMERIC (18)   NULL,
    [SMS_NOTIFICATION_BR_ID]             NUMERIC (18)   NULL,
    [SMS_NOTIFICATION_NAME]              NVARCHAR (150) NULL,
    [SMS_NOTIFICATION_EVENT_DAYS]        INT            NULL,
    [SMS_NOTIFICATION_SHOW_AT_DASHBOARD] CHAR (2)       NULL,
    [SMS_NOTIFICATION_STATUS]            CHAR (2)       NULL,
    CONSTRAINT [PK_SMS_NOTIFICATION_SETTINGS] PRIMARY KEY CLUSTERED ([SMS_NOTIFICATION_ID] ASC),
    CONSTRAINT [FK_SMS_NOTIFICATION_SETTINGS_BR_ADMIN] FOREIGN KEY ([SMS_NOTIFICATION_BR_ID]) REFERENCES [dbo].[BR_ADMIN] ([BR_ADM_ID]),
    CONSTRAINT [FK_SMS_NOTIFICATION_SETTINGS_MAIN_HD_INFO] FOREIGN KEY ([SMS_NOTIFICATION_HD_ID]) REFERENCES [dbo].[MAIN_HD_INFO] ([MAIN_INFO_ID])
);
