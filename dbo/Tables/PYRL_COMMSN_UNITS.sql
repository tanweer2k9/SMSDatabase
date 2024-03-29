﻿CREATE TABLE [dbo].[PYRL_COMMSN_UNITS] (
    [COM_UNITS_ID]          NUMERIC (18) IDENTITY (1, 1) NOT NULL,
    [COM_UNITS_HD_ID]       NUMERIC (18) NULL,
    [COM_UNITS_BR_ID]       NUMERIC (18) NULL,
    [COM_UNITS_DATE]        DATE         NULL,
    [COM_UNITS_TOTAL_UNITS] INT          NULL,
    [COM_UNITS_STATUS]      CHAR (2)     NULL,
    CONSTRAINT [PK_PYRL_COMMSN_UNITS] PRIMARY KEY CLUSTERED ([COM_UNITS_ID] ASC),
    CONSTRAINT [FK_PYRL_COMMSN_UNITS_BR_ADMIN] FOREIGN KEY ([COM_UNITS_BR_ID]) REFERENCES [dbo].[BR_ADMIN] ([BR_ADM_ID]),
    CONSTRAINT [FK_PYRL_COMMSN_UNITS_MAIN_HD_INFO] FOREIGN KEY ([COM_UNITS_HD_ID]) REFERENCES [dbo].[MAIN_HD_INFO] ([MAIN_INFO_ID])
);

