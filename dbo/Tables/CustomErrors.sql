CREATE TABLE [dbo].[CustomErrors] (
    [Id]       BIGINT          IDENTITY (1, 1) NOT NULL,
    [SpName]   NVARCHAR (100)  NULL,
    [Error]    NVARCHAR (1000) NULL,
    [Data]     NVARCHAR (MAX)  NULL,
    [DateTime] DATETIME        NULL,
    CONSTRAINT [PK_CustomErrors] PRIMARY KEY CLUSTERED ([Id] ASC)
);

