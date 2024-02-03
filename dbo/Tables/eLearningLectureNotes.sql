CREATE TABLE [dbo].[eLearningLectureNotes] (
    [Id]           NUMERIC (18)   IDENTITY (1, 1) NOT NULL,
    [BrId]         NUMERIC (18)   NULL,
    [ClassId]      NUMERIC (18)   NULL,
    [SubjectId]    NUMERIC (18)   NULL,
    [Topic]        NVARCHAR (200) NULL,
    [Date]         DATE           NULL,
    [GeneralNotes] NVARCHAR (MAX) NULL,
    [FilePath]     NVARCHAR (200) NULL,
    [IsDeleted]    BIT            NULL,
    [CreateDate]   DATETIME       NULL,
    [CreateBy]     NUMERIC (18)   NULL,
    [UpdateDate]   DATETIME       NULL,
    [UpdateBy]     NUMERIC (18)   NULL,
    CONSTRAINT [PK_eLearningLectureNotes] PRIMARY KEY CLUSTERED ([Id] ASC)
);

