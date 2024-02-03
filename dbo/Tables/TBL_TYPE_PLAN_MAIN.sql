CREATE TABLE [dbo].[TBL_TYPE_PLAN_MAIN] (
    [CMP_ID]                            NVARCHAR (50) NULL,
    [BRC_ID]                            NVARCHAR (50) NULL,
    [TYPE_PLAN_MAIN_ID]                 INT           IDENTITY (1, 1) NOT NULL,
    [TYPE_PLAN_MAIN_name]               NVARCHAR (50) NULL,
    [TYPE_PLAN_MAIN_isSameForAllChilds] BIT           NULL,
    [TYPE_PLAN_MAIN_isActive]           BIT           NULL,
    [TYPE_PLAN_MAIN_defaultType]        INT           NULL,
    [TYPE_PLAN_MAIN_isDeleted]          BIT           NULL,
    CONSTRAINT [PK_TBL_TYPE_PLAN_MAIN] PRIMARY KEY CLUSTERED ([TYPE_PLAN_MAIN_ID] ASC)
);

