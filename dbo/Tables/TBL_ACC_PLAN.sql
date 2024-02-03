﻿CREATE TABLE [dbo].[TBL_ACC_PLAN] (
    [CMP_ID]                                NVARCHAR (50)  NULL,
    [BRC_ID]                                NVARCHAR (50)  NULL,
    [TBL_ACC_PLAN_MAIN_ID]                  INT            IDENTITY (1, 1) NOT NULL,
    [TBL_ACC_PLAN_MAIN_planName]            NVARCHAR (50)  NULL,
    [TBL_ACC_PLAN_MAIN_maxLevel]            INT            NULL,
    [TBL_ACC_PLAN_MAIN_format]              NVARCHAR (100) NULL,
    [TBL_ACC_PLAN_MAIN_transactionLevel]    INT            NULL,
    [TBL_ACC_PLAN_MAIN_isType]              BIT            NULL,
    [TBL_ACC_PLAN_MAIN_areAllFixed]         BIT            NULL,
    [TBL_ACC_PLAN_MAIN_areAllAutoGenerated] BIT            NULL,
    [TBL_ACC_PLAN_MAIN_leveSeperator]       CHAR (1)       NULL,
    [TBL_ACC_PLAN_MAIN_description]         NVARCHAR (200) NULL,
    [TBL_ACC_PLAN_MAIN_isActive]            BIT            NULL,
    [TBL_ACC_PLAN_MAIN_isDeleted]           BIT            NULL,
    CONSTRAINT [PK_TBL_ACC_PLAN] PRIMARY KEY CLUSTERED ([TBL_ACC_PLAN_MAIN_ID] ASC)
);

