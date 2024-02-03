CREATE TABLE [dbo].[StudentRegistrationFeePlanDetail] (
    [Id]         NUMERIC (18) IDENTITY (1, 1) NOT NULL,
    [PId]        NUMERIC (18) NULL,
    [FeeId]      NUMERIC (18) NULL,
    [Fee]        FLOAT (53)   NULL,
    [Status]     BIT          NULL,
    [IsOncePaid] CHAR (1)     NULL,
    CONSTRAINT [PK_StudentRegistrationFeePlanDetail] PRIMARY KEY CLUSTERED ([Id] ASC)
);

