CREATE TABLE [dbo].[StudentRegistration] (
    [Id]                 NUMERIC (18)   IDENTITY (1, 1) NOT NULL,
    [BrId]               NUMERIC (18)   NULL,
    [RegistrationNo]     NVARCHAR (100) NULL,
    [StudentName]        NVARCHAR (100) NULL,
    [ClassId]            NUMERIC (18)   NULL,
    [DateOfRegistration] DATE           NULL,
    [Gender]             NVARCHAR (50)  NULL,
    [SessionId]          NUMERIC (18)   NULL,
    [ParentName]         NVARCHAR (100) NULL,
    [ParentMobileNo]     NVARCHAR (15)  NULL,
    [Address]            NVARCHAR (100) NULL,
    [AreaId]             NUMERIC (18)   NULL,
    [CityId]             NUMERIC (18)   NULL,
    [CNIC]               NVARCHAR (50)  NULL,
    [Occupation]         NVARCHAR (100) NULL,
    [Comments]           NVARCHAR (MAX) NULL,
    [CreatedDate]        DATETIME       NULL,
    [CreatedBy]          NUMERIC (18)   NULL,
    [UpdatedDate]        DATETIME       NULL,
    [UpdatedBy]          NUMERIC (18)   NULL,
    CONSTRAINT [PK_StudentRegistration] PRIMARY KEY CLUSTERED ([Id] ASC)
);

