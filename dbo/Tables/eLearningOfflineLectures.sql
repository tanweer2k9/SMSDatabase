CREATE TABLE [dbo].[eLearningOfflineLectures] (
    [Id]             NUMERIC (18)    IDENTITY (1, 1) NOT NULL,
    [BrId]           NUMERIC (18)    NULL,
    [ClassId]        NUMERIC (18)    NULL,
    [SubjectId]      NUMERIC (18)    NULL,
    [VideoUrl]       NVARCHAR (200)  NULL,
    [Topic]          NVARCHAR (200)  NULL,
    [Date]           DATE            NULL,
    [Description]    NVARCHAR (1000) NULL,
    [IsDeleted]      BIT             NULL,
    [GoogleDriveKey] NVARCHAR (100)  NULL,
    [CreateDate]     DATETIME        NULL,
    [CreateBy]       NUMERIC (18)    NULL,
    [UpdateDate]     DATETIME        NULL,
    [UpdateBy]       NUMERIC (18)    NULL,
    CONSTRAINT [PK_eLearningOfflineLectures] PRIMARY KEY CLUSTERED ([Id] ASC)
);

