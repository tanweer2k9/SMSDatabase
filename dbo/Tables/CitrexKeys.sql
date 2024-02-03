CREATE TABLE [dbo].[CitrexKeys] (
    [Id]                  NUMERIC (18)   IDENTITY (1, 1) NOT NULL,
    [BrId]                NUMERIC (18)   NULL,
    [CitrexSchoolId]      NVARCHAR (50)  NULL,
    [CitrexEncyprtionKey] NVARCHAR (100) NULL,
    [Status]              BIT            NULL,
    CONSTRAINT [PK_CitrexKeys] PRIMARY KEY CLUSTERED ([Id] ASC)
);

