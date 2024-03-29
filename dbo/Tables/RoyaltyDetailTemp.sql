﻿CREATE TABLE [dbo].[RoyaltyDetailTemp] (
    [Id]                    NUMERIC (18)   IDENTITY (1, 1) NOT NULL,
    [BrId]                  NUMERIC (18)   NULL,
    [Session]               NVARCHAR (50)  NULL,
    [Name]                  NVARCHAR (100) NULL,
    [StudentNo]             NVARCHAR (100) NULL,
    [ClassId]               NUMERIC (18)   NULL,
    [Class]                 NVARCHAR (100) NULL,
    [FeeType]               NVARCHAR (20)  NULL,
    [FeeName]               NVARCHAR (100) NULL,
    [TotalFee]              FLOAT (53)     NULL,
    [TotalArears]           FLOAT (53)     NULL,
    [Fee]                   FLOAT (53)     NULL,
    [Royality]              FLOAT (53)     NULL,
    [RoyalityDiscountCovid] FLOAT (53)     NULL,
    [Percent]               FLOAT (53)     NULL,
    [ClassOrder]            INT            NULL,
    [NoOfMonths]            INT            NULL,
    [DOA]                   DATE           NULL,
    [FromDate]              DATE           NULL,
    [Remarks]               NVARCHAR (300) NULL,
    [RoyaltyArrears]        FLOAT (53)     NULL,
    [Datetime]              DATETIME       NULL,
    CONSTRAINT [PK_RoyaltyDetailTemp] PRIMARY KEY CLUSTERED ([Id] ASC)
);

