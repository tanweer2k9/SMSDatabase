CREATE TABLE [dbo].[CitrextUserInfoMaster] (
    [Id]       NUMERIC (18)    IDENTITY (1, 1) NOT NULL,
    [BrId]     NUMERIC (18)    NULL,
    [UserPkId] NUMERIC (18)    NULL,
    [Name]     NVARCHAR (100)  NULL,
    [Role]     NVARCHAR (50)   NULL,
    [Mobile]   NVARCHAR (50)   NULL,
    [Email]    NVARCHAR (50)   NULL,
    [DateTime] DATETIME        NULL,
    [Response] NVARCHAR (2000) NULL,
    CONSTRAINT [PK_CitrextUserInfoMaster] PRIMARY KEY CLUSTERED ([Id] ASC)
);

