CREATE function dbo.tf_GetClassSubjects(@ClassId numeric,@IsCompulsory bit,@TermId numeric)
returns @tbl table (Id numeric, Name nvarchar(100))

AS BEGIN

insert into @tbl
select s.SUB_ID as Id, s.SUB_NAME Name from SUBJECT_INFO s
join (select distinct DEF_SUBJECT from SCHOOL_PLANE_DEFINITION where DEF_CLASS_ID = @ClassId and DEF_STATUS != 'D' and DEF_IS_COMPULSORY = @IsCompulsory and (@TermId = 0 OR DEF_TERM = @TermId))A
on s.SUB_ID = A.DEF_SUBJECT and s.SUB_STATUS = 'T'



return
END