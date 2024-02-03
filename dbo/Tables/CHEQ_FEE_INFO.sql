﻿CREATE TABLE [dbo].[CHEQ_FEE_INFO] (
    [CHEQ_FEE_ID]         NUMERIC (18) IDENTITY (1, 1) NOT NULL,
    [CHEQ_FEE_CHEQUE_ID]  NUMERIC (18) NULL,
    [CHEQ_FEE_COLLECT_ID] NUMERIC (18) NULL,
    [CHEQ_FEE_SUMMARY_ID] NUMERIC (18) NULL,
    CONSTRAINT [PK_CHEQ_FEE_INFO] PRIMARY KEY CLUSTERED ([CHEQ_FEE_ID] ASC),
    CONSTRAINT [FK_CHEQ_FEE_INFO_CHEQ_FEE_SUMMARY] FOREIGN KEY ([CHEQ_FEE_SUMMARY_ID]) REFERENCES [dbo].[CHEQ_FEE_SUMMARY] ([CHEQ_FEE_SUM_ID]),
    CONSTRAINT [FK_CHEQ_FEE_INFO_CHEQUE_INFO] FOREIGN KEY ([CHEQ_FEE_CHEQUE_ID]) REFERENCES [dbo].[CHEQUE_INFO] ([CHEQ_ID]),
    CONSTRAINT [FK_CHEQ_FEE_INFO_FEE_COLLECT] FOREIGN KEY ([CHEQ_FEE_COLLECT_ID]) REFERENCES [dbo].[FEE_COLLECT] ([FEE_COLLECT_ID])
);
