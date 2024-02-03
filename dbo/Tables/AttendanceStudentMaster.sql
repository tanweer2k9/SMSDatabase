CREATE TABLE [dbo].[AttendanceStudentMaster] (
    [Id]              NUMERIC (18) IDENTITY (1, 1) NOT NULL,
    [BrId]            NUMERIC (18) NULL,
    [ClassId]         NUMERIC (18) NULL,
    [SubjectId]       NUMERIC (18) NULL,
    [AttendanceDate]  DATE         NULL,
    [ExpectedTimeIn]  DATETIME     NULL,
    [ExpectedTimeOut] DATETIME     NULL,
    [CreatedDate]     DATETIME     NULL,
    [CreatedBy]       NUMERIC (18) NULL,
    [UpdatedDate]     DATETIME     NULL,
    [UpdatedBy]       NUMERIC (18) NULL,
    CONSTRAINT [PK_AttendanceStudent] PRIMARY KEY CLUSTERED ([Id] ASC)
);

