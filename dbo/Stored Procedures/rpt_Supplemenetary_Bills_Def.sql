
CREATE PROC [dbo].[rpt_Supplemenetary_Bills_Def]

@HD_ID numeric,
@BR_ID numeric
AS

declare @PID int = 0
declare @Notes nvarchar(500) = ''
declare @Fee_Name nvarchar(500) = ''


declare @Month_Name nvarchar(50) = ''

--set @Month_Name = (select SUPL_MONTH_NAME from SUPLEMENTARY_PARENT where SUPL_HD_ID = @HD_ID and SUPL_BR_ID = @BR_ID)

select @PID = p.SUPL_ID,@Notes = p.SUPL_NOTES1, @Fee_Name = p.SUPL_NAME,@Month_Name = SUPL_MONTH_NAME from SUPLEMENTARY_PARENT p where SUPL_HD_ID = @HD_ID and SUPL_BR_ID = @BR_ID
 
 select * from
 (
select d1.SUPL_DEF_ID,1 as ID,CASE WHEN (select COUNT(*) from SUPLEMENTARY_DEF where SUPL_DEF_STUDENT_ID = d1.SUPL_DEF_STUDENT_ID and SUPL_DEF_ID < d1.SUPL_DEF_ID) = 0 THEN '1'ELSE  CAST(((select COUNT(*) from SUPLEMENTARY_DEF where SUPL_DEF_STUDENT_ID = d1.SUPL_DEF_STUDENT_ID and SUPL_DEF_ID < d1.SUPL_DEF_ID) + 1) as nvarchar(2)) END as sr,(@Fee_Name + ' (' + CAST(d1.SUPL_DEF_PERCENTAGE as nvarchar) + '%)') Particular, d1.SUPL_DEF_FEE Fee,d1.SUPL_DEF_STUDENT_ID STD_ID from SUPLEMENTARY_DEF d1 where SUPL_DEF_PID = @PID
union
select d2.SUPL_DEF_ID,2 ID,'' as sr, ('For ' + REPLACE((select dbo.get_month_name(FEE_COLLECT_FEE_FROM_DATE,FEE_COLLECT_FEE_TO_DATE) from FEE_COLLECT where FEE_COLLECT_ID = SUPL_DEF_FEE_COLLECT_ID),' to ','-') + ' (G.P.A ' + CAST(d2.SUPL_DEF_GPA as nvarchar) + ')')  Particular, Null,d2.SUPL_DEF_STUDENT_ID STD_ID from SUPLEMENTARY_DEF d2 where SUPL_DEF_PID = @PID
union
select d3.SUPL_DEF_ID,3 ID,'' as sr, @Notes  Particular, Null,d3.SUPL_DEF_STUDENT_ID STD_ID from SUPLEMENTARY_DEF d3 where SUPL_DEF_PID = @PID
)A order by A.SUPL_DEF_ID,A.STD_ID,ID