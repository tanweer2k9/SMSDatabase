CREATE TABLE [dbo].[StudentRegistrationFeePlanMaster] (
    [Id]              NUMERIC (18) IDENTITY (1, 1) NOT NULL,
    [BrId]            NUMERIC (18) NULL,
    [StdRegId]        NUMERIC (18) NULL,
    [YearlyFeePlanId] NUMERIC (18) NULL,
    [Status]          BIT          NULL,
    CONSTRAINT [PK_StudentRegistrationFeePlanMaster] PRIMARY KEY CLUSTERED ([Id] ASC)
);

