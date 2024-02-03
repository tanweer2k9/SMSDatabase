CREATE TABLE [dbo].[RoyalityClassesAllowed] (
    [Id]          NUMERIC (18)  IDENTITY (1, 1) NOT NULL,
    [BrId]        NUMERIC (18)  NULL,
    [ClassId]     NUMERIC (18)  NULL,
    [CreateDate]  DATETIME      NULL,
    [CreatedBy]   NUMERIC (18)  NULL,
    [UpdatedDate] DATETIME      NULL,
    [UpdateBy]    NUMERIC (18)  NULL,
    [Session]     NVARCHAR (50) NULL,
    CONSTRAINT [PK_RoyalityClassesAllowed] PRIMARY KEY CLUSTERED ([Id] ASC)
);



