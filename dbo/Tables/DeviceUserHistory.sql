CREATE TABLE [dbo].[DeviceUserHistory] (
    [Id]          NUMERIC (18)   IDENTITY (1, 1) NOT NULL,
    [BrId]        NUMERIC (18)   NULL,
    [UserType]    NVARCHAR (50)  NULL,
    [DeviceId]    NUMERIC (18)   NULL,
    [UserInfoId]  NUMERIC (18)   NULL,
    [TableOrPage] NVARCHAR (100) NULL,
    [TablePkId]   NUMERIC (18)   NULL,
    [CreatedDate] DATETIME       NULL,
    CONSTRAINT [PK_DeviceUserHistory] PRIMARY KEY CLUSTERED ([Id] ASC)
);

