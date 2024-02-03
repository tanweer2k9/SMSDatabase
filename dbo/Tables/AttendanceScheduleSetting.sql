CREATE TABLE [dbo].[AttendanceScheduleSetting] (
    [Id]                     NUMERIC (18)   IDENTITY (1, 1) NOT NULL,
    [AttendanceBrId]         NUMERIC (18)   NULL,
    [AttendanceScheduleTime] DATETIME       NULL,
    [AtendanceScheduleType]  NVARCHAR (50)  NULL,
    [Status]                 BIT            NULL,
    [ToEmail]                NVARCHAR (50)  NULL,
    [CCEmail]                NVARCHAR (200) NULL,
    [BCC]                    NVARCHAR (200) NULL,
    [IsStop]                 BIT            NULL,
    CONSTRAINT [PK_AttendanceScheduleSetting] PRIMARY KEY CLUSTERED ([Id] ASC)
);

