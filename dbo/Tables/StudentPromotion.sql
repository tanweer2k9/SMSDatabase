CREATE TABLE [dbo].[StudentPromotion] (
    [Id]              NUMERIC (18)  IDENTITY (1, 1) NOT NULL,
    [HdId]            NUMERIC (18)  NULL,
    [BrId]            NUMERIC (18)  NULL,
    [StudentId]       NUMERIC (18)  NULL,
    [ClassId]         NUMERIC (18)  NULL,
    [OldHdId]         NUMERIC (18)  NULL,
    [OldBrId]         NUMERIC (18)  NULL,
    [OldClassId]      NUMERIC (18)  NULL,
    [CreatedDateTime] DATETIME      NULL,
    [CreatedBy]       NVARCHAR (50) NULL,
    [SessionId]       NUMERIC (18)  NULL,
    CONSTRAINT [PK_StudentPromotion] PRIMARY KEY CLUSTERED ([Id] ASC)
);

