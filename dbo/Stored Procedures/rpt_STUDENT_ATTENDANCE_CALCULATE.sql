CREATE PROC [dbo].[rpt_STUDENT_ATTENDANCE_CALCULATE]
     
     @FEE_COLLECT_HD_ID  numeric,
     @FEE_COLLECT_BR_ID  numeric,
	 @FROM_DATE date,
	 @TO_DATE date
AS

--declare @FROM_DATE date = ''
--declare @TO_DATE date = ''

--set @FEE_COLLECT_DATE = (select top(1) FEE_COLLECT_DATE_FEE_GENERATED from FEE_COLLECT where FEE_COLLECT_FEE_FROM_DATE = @FEE_COLLECT_DATE)
--set @FROM_DATE = (DATEADD(mm, DATEDIFF(mm,0,(select MIN(FEE_COLLECT_FEE_FROM_DATE) from FEE_COLLECT where FEE_COLLECT_DATE_FEE_GENERATED = @FEE_COLLECT_DATE)), 0))
--set @TO_DATE = DATEADD(d, -1, DATEADD(m, DATEDIFF(m, 0, (select MAX(FEE_COLLECT_FEE_TO_DATE) from FEE_COLLECT where FEE_COLLECT_DATE_FEE_GENERATED = @FEE_COLLECT_DATE)) + 1, 0))




--declare @FROM_DATE date = '2014-01-01'
--declare @TO_DATE date = '2014-01-31'

--declare @FEE_COLLECT_HD_ID  numeric = 1
--declare @FEE_COLLECT_BR_ID  numeric = 1


;with tbl as
(select ATTENDANCE_TYPE_ID as [Std ID], COUNT(ATTENDANCE_REMARKS) as Attendance, 'Present' as Remarks from ATTENDANCE 
where ATTENDANCE_REMARKS = 'P' and ATTENDANCE_DATE between @FROM_DATE and @TO_DATE group by ATTENDANCE_TYPE_ID
union 
select ATTENDANCE_TYPE_ID as [Std ID], COUNT(ATTENDANCE_REMARKS) as Attendance, 'Absent' as Remarks from ATTENDANCE 
where ATTENDANCE_REMARKS = 'A' and ATTENDANCE_DATE between @FROM_DATE and @TO_DATE group by ATTENDANCE_TYPE_ID
union 
select ATTENDANCE_TYPE_ID as [Std ID], COUNT(ATTENDANCE_REMARKS) as Attendance, 'Leave' as Remarks from ATTENDANCE 
where ATTENDANCE_REMARKS = 'LE' and ATTENDANCE_DATE between @FROM_DATE and @TO_DATE group by ATTENDANCE_TYPE_ID
union 
select ATTENDANCE_TYPE_ID as [Std ID], COUNT(ATTENDANCE_REMARKS) as Attendance, 'Late' as Remarks from ATTENDANCE 
where ATTENDANCE_REMARKS = 'LA' and ATTENDANCE_DATE between @FROM_DATE and @TO_DATE group by ATTENDANCE_TYPE_ID
)
,pivt_tbl as
(
select * from tbl

pivot
(SUM([Attendance]) for Remarks in (	[Present], [Absent], [Leave], [Late])) as tbl_after_pivot)

,final_tbl as
(
select [Std ID], ISNULL(Present,0) as Present,ISNULL(Absent,0 ) as Absent,ISNULL(Leave,0) as Leave,ISNULL(Late,0) as Late from pivt_tbl
)
select [Std ID], SUM(Present) as Present,SUM(Absent) as Absent,SUM(Leave) as Leave,SUM(Late) as Late from final_tbl group by [Std ID]