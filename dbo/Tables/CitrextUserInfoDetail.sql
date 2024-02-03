CREATE TABLE [dbo].[CitrextUserInfoDetail] (
    [Id]        NUMERIC (18)  IDENTITY (1, 1) NOT NULL,
    [PId]       NUMERIC (18)  NULL,
    [ClassId]   NUMERIC (18)  NULL,
    [ClassName] NVARCHAR (50) NULL,
    [Session]   NVARCHAR (50) NULL,
    CONSTRAINT [PK_CitextUserInfoDetail] PRIMARY KEY CLUSTERED ([Id] ASC)
);

