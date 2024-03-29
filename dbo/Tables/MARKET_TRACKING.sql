﻿CREATE TABLE [dbo].[MARKET_TRACKING] (
    [TRACK_ID]                   NUMERIC (18)   IDENTITY (1, 1) NOT NULL,
    [TRACK_HD_ID]                NUMERIC (18)   NULL,
    [TRACK_BR_ID]                NUMERIC (18)   NULL,
    [TRACK_SCHOOL_NAME]          NVARCHAR (100) NULL,
    [TRACK_SCHOOL_COUNTRY]       NUMERIC (18)   NULL,
    [TRACK_SCHOOL_CITY]          NUMERIC (18)   NULL,
    [TRACK_SCHOOL_AREA]          NUMERIC (18)   NULL,
    [TRACK_SCHOOL_ADDRESS]       NVARCHAR (300) NULL,
    [TRACK_SCHOOL_MOBILE_NO1]    NVARCHAR (15)  NULL,
    [TRACK_SCHOOL_MOBILE_NO2]    NVARCHAR (15)  NULL,
    [TRACK_SCHOOL_LANDLINE_NO]   NVARCHAR (15)  NULL,
    [TRACK_SCHOOL_EMAIL]         NVARCHAR (100) NULL,
    [TRACK_SCHOOL_WEBSITE]       NVARCHAR (100) NULL,
    [TRACK_CONTACT_NAME]         NVARCHAR (100) NULL,
    [TRACK_CONTACT_DESIGNATION]  NUMERIC (18)   NULL,
    [TRACK_CONTACT_MOBILE_NO]    NVARCHAR (15)  NULL,
    [TRACK_CONTACT_LANDLINE_NO]  NVARCHAR (15)  NULL,
    [TRACK_CONTACT_EMAIL]        NVARCHAR (100) NULL,
    [TRACK_SALES_REPRESENTATIVE] NUMERIC (18)   NULL,
    [TRACK_REFFERED_BY]          NVARCHAR (100) NULL,
    [TRACK_MARKETING_MODE_ID]    NUMERIC (18)   NULL,
    [TRACK_STATUS]               NUMERIC (18)   NULL,
    CONSTRAINT [PK_MARKET_TRACKING] PRIMARY KEY CLUSTERED ([TRACK_ID] ASC),
    CONSTRAINT [FK_MARKET_TRACKING_BR_ADMIN] FOREIGN KEY ([TRACK_BR_ID]) REFERENCES [dbo].[BR_ADMIN] ([BR_ADM_ID]),
    CONSTRAINT [FK_MARKET_TRACKING_MAIN_HD_INFO] FOREIGN KEY ([TRACK_HD_ID]) REFERENCES [dbo].[MAIN_HD_INFO] ([MAIN_INFO_ID])
);

