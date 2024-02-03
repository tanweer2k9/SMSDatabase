CREATE PROC dbo.usp_GetClassSubjectsTerms

@ClassId numeric,
@IsCompulsory bit

AS

select t.TERM_ID as Id, t.TERM_NAME Name from TERM_INFO t
join (select distinct DEF_TERM from SCHOOL_PLANE_DEFINITION where DEF_CLASS_ID = @ClassId and DEF_STATUS = 'T' and DEF_IS_COMPULSORY = @IsCompulsory)A
on t.TERM_ID = A.DEF_TERM and t.TERM_STATUS = 'T'