CREATE TABLE [dbo].[tblStudentSubjectsParent] (
    [Id]          NUMERIC (18) IDENTITY (1, 1) NOT NULL,
    [StudentId]   NUMERIC (18) NULL,
    [ClassId]     NUMERIC (18) NULL,
    [CreatedBy]   NUMERIC (18) NULL,
    [CreatedDate] DATETIME     NULL,
    [UpdateBy]    NUMERIC (18) NULL,
    [UpdateDate]  DATETIME     NULL,
    CONSTRAINT [PK_StudentSubjects] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_tblStudentSubjectsParent_SCHOOL_PLANE] FOREIGN KEY ([ClassId]) REFERENCES [dbo].[SCHOOL_PLANE] ([CLASS_ID]),
    CONSTRAINT [FK_tblStudentSubjectsParent_STUDENT_INFO] FOREIGN KEY ([StudentId]) REFERENCES [dbo].[STUDENT_INFO] ([STDNT_ID])
);

