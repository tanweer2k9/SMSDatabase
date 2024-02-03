CREATE TABLE [dbo].[LogHistory] (
    [Id]          NUMERIC (18)   IDENTITY (1, 1) NOT NULL,
    [BrId]        NUMERIC (18)   NULL,
    [TableName]   NVARCHAR (50)  NULL,
    [Field]       NVARCHAR (50)  NULL,
    [RecordId]    NUMERIC (18)   NULL,
    [OldValue]    NVARCHAR (MAX) NULL,
    [NewValue]    NVARCHAR (MAX) NULL,
    [CrudType]    NVARCHAR (50)  NULL,
    [CreatedDate] DATETIME       NULL,
    [CreatedBy]   NUMERIC (18)   NULL,
    CONSTRAINT [PK_LogHistory] PRIMARY KEY CLUSTERED ([Id] ASC)
);

