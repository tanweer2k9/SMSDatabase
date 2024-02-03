CREATE TABLE [dbo].[MobileAppPopupMessage] (
    [Id]          NUMERIC (18)    NOT NULL,
    [HdId]        NUMERIC (18)    NULL,
    [BrId]        NUMERIC (18)    NULL,
    [Title]       NVARCHAR (100)  NULL,
    [Message]     NVARCHAR (1000) NULL,
    [Type]        NVARCHAR (50)   NULL,
    [FromDate]    DATE            NULL,
    [ToDate]      DATE            NULL,
    [GoToUrl]     NVARCHAR (200)  NULL,
    [CreatedDate] DATETIME        NULL,
    [CreatedBy]   NUMERIC (18)    NULL,
    [UpdatedDate] DATETIME        NULL,
    [UpdatedBy]   NUMERIC (18)    NULL,
    CONSTRAINT [PK_MobileAppPopupMessage] PRIMARY KEY CLUSTERED ([Id] ASC)
);

