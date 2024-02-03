CREATE TABLE [dbo].[EmailHistory] (
    [Id]          NUMERIC (18)    IDENTITY (1, 1) NOT NULL,
    [BrId]        NUMERIC (18)    NULL,
    [ToEmail]     NVARCHAR (100)  NULL,
    [StaffId]     NUMERIC (18)    NULL,
    [StdId]       NUMERIC (18)    NULL,
    [FromDate]    DATETIME        NULL,
    [ToDate]      DATETIME        NULL,
    [EmailModule] NVARCHAR (100)  NULL,
    [Subject]     NVARCHAR (500)  NULL,
    [Body]        NVARCHAR (MAX)  NULL,
    [BCC]         NVARCHAR (200)  NULL,
    [CC]          NVARCHAR (200)  NULL,
    [CreatedDate] DATETIME        NULL,
    [Status]      NVARCHAR (50)   NULL,
    [Error]       NVARCHAR (1000) NULL,
    CONSTRAINT [PK_EmailHistory] PRIMARY KEY CLUSTERED ([Id] ASC)
);



