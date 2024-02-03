﻿CREATE TABLE [dbo].[INSTALLMENT_INFO] (
    [INSTALLMENT_ID]     NUMERIC (18)   IDENTITY (1, 1) NOT NULL,
    [INSTALLMENT_HD_ID]  NUMERIC (18)   NOT NULL,
    [INSTALLMENT_BR_ID]  NUMERIC (18)   NULL,
    [INSTALLMENT_NAME]   NVARCHAR (50)  NULL,
    [INSTALLMENT_DESC]   NVARCHAR (MAX) NULL,
    [INSTALLMENT_RANK]   INT            NULL,
    [INSTALLMENT_STATUS] CHAR (2)       NULL,
    CONSTRAINT [PK_INSTALLMENT] PRIMARY KEY CLUSTERED ([INSTALLMENT_ID] ASC),
    CONSTRAINT [FK_INSTALLMENT_INFO_BR_ADMIN] FOREIGN KEY ([INSTALLMENT_BR_ID]) REFERENCES [dbo].[BR_ADMIN] ([BR_ADM_ID]),
    CONSTRAINT [FK_INSTALLMENT_INFO_MAIN_HD_INFO] FOREIGN KEY ([INSTALLMENT_HD_ID]) REFERENCES [dbo].[MAIN_HD_INFO] ([MAIN_INFO_ID])
);
