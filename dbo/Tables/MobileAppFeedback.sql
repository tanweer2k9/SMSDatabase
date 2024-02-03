CREATE TABLE [dbo].[MobileAppFeedback] (
    [Id]          NUMERIC (18)    NOT NULL,
    [BrId]        NUMERIC (18)    NULL,
    [StudentId]   NUMERIC (18)    NULL,
    [ClassId]     NUMERIC (18)    NULL,
    [Feedback]    NVARCHAR (1000) NULL,
    [CreatedDate] DATETIME        NULL,
    [CreatedBy]   NUMERIC (18)    NULL,
    CONSTRAINT [PK_MobileAppFeedback] PRIMARY KEY CLUSTERED ([Id] ASC)
);

