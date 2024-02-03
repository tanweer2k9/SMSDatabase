CREATE TABLE [dbo].[FeeYearlyPlan] (
    [Id]          NUMERIC (18)   IDENTITY (1, 1) NOT NULL,
    [HdId]        NUMERIC (18)   NULL,
    [BrId]        NUMERIC (18)   NULL,
    [Name]        NVARCHAR (100) NULL,
    [PlanStatus]  BIT            NULL,
    [CreateDate]  DATETIME       NULL,
    [CreatedBy]   NUMERIC (18)   NULL,
    [UpdatedDate] DATETIME       NULL,
    [UpdateBy]    NUMERIC (18)   NULL,
    CONSTRAINT [PK_FeeMonthlyPlan] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_FeeMonthlyPlan_BR_ADMIN] FOREIGN KEY ([BrId]) REFERENCES [dbo].[BR_ADMIN] ([BR_ADM_ID]),
    CONSTRAINT [FK_FeeMonthlyPlan_MAIN_HD_INFO] FOREIGN KEY ([HdId]) REFERENCES [dbo].[MAIN_HD_INFO] ([MAIN_INFO_ID])
);

