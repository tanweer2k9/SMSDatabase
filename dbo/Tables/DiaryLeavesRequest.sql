CREATE TABLE [dbo].[DiaryLeavesRequest] (
    [Id]          NUMERIC (18)   IDENTITY (1, 1) NOT NULL,
    [HdId]        NUMERIC (18)   NULL,
    [BrId]        NUMERIC (18)   NULL,
    [StudentId]   NUMERIC (18)   NULL,
    [ClassId]     NUMERIC (18)   NULL,
    [LeavesType]  NVARCHAR (50)  NULL,
    [StartDate]   DATE           NULL,
    [EndDate]     DATE           NULL,
    [Reason]      NVARCHAR (500) NULL,
    [CreatedDate] DATETIME       NULL,
    [UpdatedDate] DATETIME       NULL,
    [CreatedBy]   NUMERIC (18)   NULL,
    [UpdateBy]    NUMERIC (18)   NULL,
    CONSTRAINT [PK_DiaryLeavesRequest] PRIMARY KEY CLUSTERED ([Id] ASC)
);

