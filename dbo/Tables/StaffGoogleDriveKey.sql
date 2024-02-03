CREATE TABLE [dbo].[StaffGoogleDriveKey] (
    [Id]             NUMERIC (18)   IDENTITY (1, 1) NOT NULL,
    [StaffId]        NUMERIC (18)   NULL,
    [GoogleDriveKey] NVARCHAR (100) NULL,
    CONSTRAINT [PK_StaffGoogleDriveKey] PRIMARY KEY CLUSTERED ([Id] ASC)
);

