﻿CREATE TYPE [dbo].[type_STAFF_ATTENDANCE] AS TABLE (
    [USERID]    NUMERIC (18)  NULL,
    [CHECKTIME] DATETIME      NULL,
    [CHECKTYPE] NVARCHAR (10) NULL);

