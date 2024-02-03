﻿CREATE TABLE [dbo].[RIGHTS_PACKAGES_CHILD] (
    [PACKAGES_DEF_ID]              NUMERIC (18) IDENTITY (1, 1) NOT NULL,
    [PACKAGES_DEF_PID]             NUMERIC (18) NULL,
    [PACKAGES_DEF_RIGHTS_PAGES_ID] NUMERIC (18) NULL,
    [PACKAGES_DEF_STATUS]          BIT          NULL,
    [PACKAGES_DEF_LOAD_STATUS]     BIT          NULL,
    [PACKAGES_DEF_IS_DASHBOARD]    BIT          NULL,
    CONSTRAINT [PK_RIGHTS_PACKAGES_CHILD] PRIMARY KEY CLUSTERED ([PACKAGES_DEF_ID] ASC),
    CONSTRAINT [FK_RIGHTS_PACKAGES_CHILD_RIGHTS_PACKAGES_PARENT] FOREIGN KEY ([PACKAGES_DEF_PID]) REFERENCES [dbo].[RIGHTS_PACKAGES_PARENT] ([PACKAGES_ID]),
    CONSTRAINT [FK_RIGHTS_PACKAGES_CHILD_RIGHTS_PAGES] FOREIGN KEY ([PACKAGES_DEF_RIGHTS_PAGES_ID]) REFERENCES [dbo].[RIGHTS_PAGES] ([RIGHTS_PAGES_ID])
);
