CREATE TABLE [dbo].[tblStudentClassPlan] (
    [Id]        NUMERIC (18) IDENTITY (1, 1) NOT NULL,
    [StudentId] NUMERIC (18) NULL,
    [ClassId]   NUMERIC (18) NULL,
    [SessionId] NUMERIC (18) NULL,
    CONSTRAINT [PK_tblStudentClassPlan] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_tblStudentClassPlan_SCHOOL_PLANE] FOREIGN KEY ([ClassId]) REFERENCES [dbo].[SCHOOL_PLANE] ([CLASS_ID]),
    CONSTRAINT [FK_tblStudentClassPlan_SESSION_INFO] FOREIGN KEY ([SessionId]) REFERENCES [dbo].[SESSION_INFO] ([SESSION_ID]),
    CONSTRAINT [FK_tblStudentClassPlan_STUDENT_INFO] FOREIGN KEY ([StudentId]) REFERENCES [dbo].[STUDENT_INFO] ([STDNT_ID])
);

