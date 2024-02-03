CREATE TABLE [dbo].[TBL_COA] (
    [CMP_ID]                NVARCHAR (50)  NULL,
    [BRC_ID]                NVARCHAR (50)  NULL,
    [COA_ID]                INT            IDENTITY (1, 1) NOT NULL,
    [COA_PARENTID]          NVARCHAR (50)  NULL,
    [COA_UID]               NVARCHAR (50)  NULL,
    [COA_prefix]            NVARCHAR (50)  NULL,
    [COA_levelID]           INT            NULL,
    [COA_definationPlanID]  INT            NULL,
    [COA_Name]              NVARCHAR (200) NULL,
    [COA_type]              INT            NULL,
    [COA_isActive]          BIT            NULL,
    [COA_description]       NVARCHAR (200) NULL,
    [COA_IsInventory]       BIT            NULL,
    [COA_levelNo]           INT            NULL,
    [COA_IsTransaction]     BIT            NULL,
    [COA_nature]            NVARCHAR (50)  NULL,
    [COA_isDeleted]         BIT            NULL,
    [COA_isDeletionAllowed] BIT            NULL,
    CONSTRAINT [PK_TBL_COA] PRIMARY KEY CLUSTERED ([COA_ID] ASC)
);

