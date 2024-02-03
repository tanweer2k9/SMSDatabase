CREATE PROC [dbo].[sp_TEACHER_INFO_updation_ranking]

@TECh_ID numeric,
@TECH_RANKING numeric

AS



update TEACHER_INFO set TECH_RANKING = @TECH_RANKING 
where TECH_ID = @TECh_ID