CREATE TYPE [dbo].[type_dt_Exam_Forecast] AS TABLE (
    [Subject]      NVARCHAR (100) NULL,
    [StdId]        NUMERIC (18)   NULL,
    [MidSemester1] NVARCHAR (50)  NULL,
    [PreMock]      NVARCHAR (50)  NULL,
    [Mock]         NVARCHAR (50)  NULL);

