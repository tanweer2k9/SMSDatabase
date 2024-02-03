CREATE TABLE [dbo].[TBL_VAL_PLAN] (
    [CMP_ID]                              NVARCHAR (50)  NULL,
    [BRC_ID]                              NVARCHAR (50)  NULL,
    [VAL_PLAN_ID]                         INT            NULL,
    [VAL_PLAN_name]                       NVARCHAR (50)  NULL,
    [VAL_PLAN_isAllowtoUpdate]            BIT            NULL,
    [VAL_PLAN_isAllowtoInsert]            BIT            NULL,
    [VAL_PLAN_isAllowtoDelete]            BIT            NULL,
    [VAL_PLAN_isAllowtoAddChild]          BIT            NULL,
    [VAL_PLAN_isAllowToPerformActiveness] BIT            NULL,
    [VAL_PLAN_isAllowtoPrefixInCode]      BIT            NULL,
    [VAL_PLAN_isAutoBasedOnPrefix]        BIT            NULL,
    [VAL_PLAN_isSingleAutoForAllLevels]   BIT            NULL,
    [VAL_PLAN_isSameForChilds]            BIT            NULL,
    [VAL_PLAN_prefixCode]                 NVARCHAR (50)  NULL,
    [VAL_PLAN_description]                NVARCHAR (200) NULL,
    [VAL_PLAN_isDeleted]                  BIT            NULL
);

