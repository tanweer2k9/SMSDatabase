CREATE TABLE [dbo].[FeeYearlyPlanDef] (
    [Id]            NUMERIC (18) IDENTITY (1, 1) NOT NULL,
    [PId]           NUMERIC (18) NULL,
    [InstallmentId] NUMERIC (18) NULL,
    [FromMonth]     INT          NULL,
    [ToMonth]       INT          NULL,
    [FeeFormula]    FLOAT (53)   NULL,
    [IsDeleted]     BIT          NULL,
    CONSTRAINT [PK_FeeMonthlyPlanDef] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_FeeMonthlyPlanDef_FeeMonthlyPlan] FOREIGN KEY ([PId]) REFERENCES [dbo].[FeeYearlyPlan] ([Id]),
    CONSTRAINT [FK_FeeMonthlyPlanDef_INSTALLMENT_INFO] FOREIGN KEY ([InstallmentId]) REFERENCES [dbo].[INSTALLMENT_INFO] ([INSTALLMENT_ID])
);

