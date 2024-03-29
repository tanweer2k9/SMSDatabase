﻿CREATE TABLE [dbo].[FEE_INFO] (
    [FEE_ID]                NUMERIC (18)   IDENTITY (1, 1) NOT NULL,
    [FEE_HD_ID]             NUMERIC (18)   NOT NULL,
    [FEE_BR_ID]             NUMERIC (18)   NULL,
    [FEE_NAME]              NVARCHAR (50)  NULL,
    [FEE_DESC]              NVARCHAR (500) NULL,
    [FEE_STATUS]            CHAR (2)       NULL,
    [FEE_TYPE]              NVARCHAR (50)  NULL,
    [FEE_MONTHS]            NVARCHAR (50)  NULL,
    [FEE_RANK]              INT            NULL,
    [FEE_OPERATION]         NVARCHAR (10)  NULL,
    [FEE_DISCOUNT_PRIORITY] INT            NULL,
    [FEE_IS_DISCOUNTABLE]   CHAR (1)       NULL,
    CONSTRAINT [PK_FEE] PRIMARY KEY CLUSTERED ([FEE_ID] ASC),
    CONSTRAINT [FK_FEE_INFO_BR_ADMIN] FOREIGN KEY ([FEE_BR_ID]) REFERENCES [dbo].[BR_ADMIN] ([BR_ADM_ID]),
    CONSTRAINT [FK_FEE_INFO_MAIN_HD_INFO] FOREIGN KEY ([FEE_HD_ID]) REFERENCES [dbo].[MAIN_HD_INFO] ([MAIN_INFO_ID])
);

