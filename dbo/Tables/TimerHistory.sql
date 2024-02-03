CREATE TABLE [dbo].[TimerHistory] (
    [Id]                INT      IDENTITY (1, 1) NOT NULL,
    [DateTimeInsertion] DATETIME NULL,
    CONSTRAINT [PK_TimerHistory] PRIMARY KEY CLUSTERED ([Id] ASC)
);

