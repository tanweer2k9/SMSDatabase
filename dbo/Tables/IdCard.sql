CREATE TABLE [dbo].[IdCard] (
    [Id]           NUMERIC (18)     IDENTITY (1, 1) NOT NULL,
    [StaffId]      NUMERIC (18)     NULL,
    [StudentId]    NUMERIC (18)     NULL,
    [ClassId]      NUMERIC (18)     NULL,
    [RandomString] UNIQUEIDENTIFIER NULL,
    [DateTime]     DATETIME         NULL,
    [Active]       BIT              NULL,
    [ExpiryDate]   DATE             NULL,
    CONSTRAINT [PK_IdCard] PRIMARY KEY CLUSTERED ([Id] ASC)
);

