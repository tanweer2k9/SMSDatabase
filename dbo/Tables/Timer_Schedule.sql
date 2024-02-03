CREATE TABLE [dbo].[Timer_Schedule] (
    [ID]        NUMERIC (18)  IDENTITY (1, 1) NOT NULL,
    [DateTimer] DATETIME      NULL,
    [Type]      NVARCHAR (50) NULL,
    [BrId]      NUMERIC (18)  NULL,
    CONSTRAINT [PK_Timer_Schedule] PRIMARY KEY CLUSTERED ([ID] ASC)
);

