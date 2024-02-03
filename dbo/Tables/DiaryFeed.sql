CREATE TABLE [dbo].[DiaryFeed] (
    [Id]              NUMERIC (18)    IDENTITY (1, 1) NOT NULL,
    [HdId]            NUMERIC (18)    NULL,
    [BrId]            NUMERIC (18)    NULL,
    [Title]           NVARCHAR (500)  NULL,
    [FeedType]        NVARCHAR (100)  NULL,
    [FeedDescription] NVARCHAR (1000) NULL,
    [ImageUrl]        NVARCHAR (200)  NULL,
    [ClassId]         NUMERIC (18)    NULL,
    [StudentId]       NUMERIC (18)    NULL,
    [IsActive]        BIT             NULL,
    [IsDeleted]       BIT             NULL,
    [CreateDate]      DATETIME        NULL,
    [CreateBy]        NUMERIC (18)    NULL,
    [UpdateDate]      DATETIME        NULL,
    [UpdateBy]        NUMERIC (18)    NULL,
    CONSTRAINT [PK_DiaryFeed] PRIMARY KEY CLUSTERED ([Id] ASC)
);

