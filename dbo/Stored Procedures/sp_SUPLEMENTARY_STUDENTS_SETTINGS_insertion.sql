CREATE PROC [dbo].[sp_SUPLEMENTARY_STUDENTS_SETTINGS_insertion]



@dt_std dbo.[type_SUPPLEMENTARY_STUDENT_SETTING] readonly,
@SUPL_STD_HD_ID  numeric,
@SUPL_STD_BR_ID  numeric

AS

declare @fee float
declare @GPA float
declare @Percent float
declare @ID numeric

declare @count int = 0
declare @i int = 1

set @count = (select COUNT(*) from @dt_std)

while @i <= @count
BEGIN
select @ID = ID, @GPA = GPA, @fee = Fee, @Percent = [Percent] from (select ROW_NUMBER() over (order by (select 0)) as sr,* from @dt_std)A where sr = @i

update SCHOLARSHIP_GENERATION set SCH_GEN_GPA = @GPA, SCH_GEN_FEE = @fee, SCH_GEN_PERCENT = @Percent where SCH_GEN_ID = @ID

set @i = @i + 1
END




--delete from SUPLEMENTARY_STUDENTS_SETTINGS

--insert into SUPLEMENTARY_STUDENTS_SETTINGS
--select @SUPL_STD_HD_ID, @SUPL_STD_BR_ID, ID,GPA,Fee,Percentage from @dt_std where Fee > 0

select 'ok'