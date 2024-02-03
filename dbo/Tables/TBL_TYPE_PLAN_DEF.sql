CREATE TABLE [dbo].[TBL_TYPE_PLAN_DEF] (
    [CMP_ID]                    NVARCHAR (50)  NULL,
    [BRC_ID]                    NVARCHAR (50)  NULL,
    [TYPE_PLAN_DEF_ID]          INT            IDENTITY (1, 1) NOT NULL,
    [TYPE_PLAN_MAIN_ID]         INT            NULL,
    [TYPE_PLAN_DEF_name]        NVARCHAR (200) NULL,
    [TYPE_PLAN_DEF_isActive]    BIT            NULL,
    [TYPE_PLAN_DEF_description] NVARCHAR (200) NULL,
    [TYPE_PLAN_DEF_isDeleted]   BIT            NULL,
    CONSTRAINT [PK_TBL_TYPE_PLAN_DEF] PRIMARY KEY CLUSTERED ([TYPE_PLAN_DEF_ID] ASC)
);

