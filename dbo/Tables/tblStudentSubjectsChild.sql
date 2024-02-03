CREATE TABLE [dbo].[tblStudentSubjectsChild] (
    [Id]        NUMERIC (18) IDENTITY (1, 1) NOT NULL,
    [PId]       NUMERIC (18) NULL,
    [SubjectId] NUMERIC (18) NULL,
    [TermId]    NUMERIC (18) NULL,
    CONSTRAINT [PK_tblStudentSubjectsChild] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_tblStudentSubjectsChild_SUBJECT_INFO] FOREIGN KEY ([SubjectId]) REFERENCES [dbo].[SUBJECT_INFO] ([SUB_ID]),
    CONSTRAINT [FK_tblStudentSubjectsChild_tblStudentSubjectsParent] FOREIGN KEY ([PId]) REFERENCES [dbo].[tblStudentSubjectsParent] ([Id]),
    CONSTRAINT [FK_tblStudentSubjectsChild_TERM_INFO] FOREIGN KEY ([TermId]) REFERENCES [dbo].[TERM_INFO] ([TERM_ID])
);

