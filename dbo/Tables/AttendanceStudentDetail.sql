CREATE TABLE [dbo].[AttendanceStudentDetail] (
    [Id]      NUMERIC (18)  IDENTITY (1, 1) NOT NULL,
    [PId]     NUMERIC (18)  NULL,
    [StdId]   NUMERIC (18)  NULL,
    [Remarks] NVARCHAR (50) NULL,
    [TimeIn]  NVARCHAR (50) NULL,
    [TimeOut] NVARCHAR (50) NULL,
    CONSTRAINT [PK_AttendanceStudentDetail] PRIMARY KEY CLUSTERED ([Id] ASC)
);

