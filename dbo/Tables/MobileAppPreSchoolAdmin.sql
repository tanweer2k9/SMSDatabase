CREATE TABLE [dbo].[MobileAppPreSchoolAdmin] (
    [Id]          NUMERIC (18) IDENTITY (1, 1) NOT NULL,
    [UserId]      NUMERIC (18) NULL,
    [CreatedDate] DATETIME     NULL,
    [UpdatedDate] DATETIME     NULL,
    CONSTRAINT [PK_MobileAppPreSchoolAdmin] PRIMARY KEY CLUSTERED ([Id] ASC)
);

