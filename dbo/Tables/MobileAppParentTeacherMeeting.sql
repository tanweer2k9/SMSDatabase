CREATE TABLE [dbo].[MobileAppParentTeacherMeeting] (
    [Id]              NUMERIC (18)    IDENTITY (1, 1) NOT NULL,
    [BrId]            NUMERIC (18)    NULL,
    [StudentId]       NUMERIC (18)    NULL,
    [ClassId]         NUMERIC (18)    NULL,
    [Title]           NVARCHAR (500)  NULL,
    [Description]     NVARCHAR (1000) NULL,
    [MeetingDateTime] DATETIME        NULL,
    [IsParentRequest] BIT             NULL,
    [RequestStatus]   NVARCHAR (50)   NULL,
    [CreatedDate]     DATETIME        NULL,
    [CreatedBy]       NUMERIC (18)    NULL,
    [UpdatedDate]     DATETIME        NULL,
    [UpdatedBy]       NUMERIC (18)    NULL,
    CONSTRAINT [PK_MobileAppParentTeacherMeeting] PRIMARY KEY CLUSTERED ([Id] ASC)
);

