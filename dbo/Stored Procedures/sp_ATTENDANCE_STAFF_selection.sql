
CREATE procedure  [dbo].[sp_ATTENDANCE_STAFF_selection]
                                               
                                               
	@STATUS char(10),
     @ATTENDANCE_STAFF_TYPE_ID  numeric,
     @ATTENDANCE_STAFF_HD_ID  numeric,
     @ATTENDANCE_STAFF_BR_ID  numeric,
     @ATTENDANCE_STAFF_DATE  date
         
   
   
     AS BEGIN 
   
   
   declare @ATTENDANCE_STAFF_TYPE_ID_NVARCHAR nvarchar(50) = '%'

   if @ATTENDANCE_STAFF_TYPE_ID != 0
   BEGIN
		set @ATTENDANCE_STAFF_TYPE_ID_NVARCHAR = CAST(@ATTENDANCE_STAFF_TYPE_ID  as nvarchar(50))
   END 




if @STATUS = 'S'
BEGIN
	select * from VTEACHER_INFO where [Branch ID] in ( select * from [dbo].[get_centralized_br_id]('S', @ATTENDANCE_STAFF_BR_ID) )and
		[Institute ID] = @ATTENDANCE_STAFF_HD_ID and Status = 'T' and [Leaves Type] not in ('No Deduction', 'Not Generate Salary')
END

if @STATUS = 'L'
 begin

--select * from (
select  t.TECH_ID as [tchId], t.TECH_EMPLOYEE_CODE [Employee Code] ,t.TECH_DESIGNATION, (t.TECH_FIRST_NAME + ' ' + t.TECH_LAST_NAME) as name,
t.TECH_CELL_NO as [Mobile No]    
 from TEACHER_INFO t
 where 
		TECH_BR_ID  in ( select * from [dbo].[get_centralized_br_id]('S', @ATTENDANCE_STAFF_BR_ID) )and
		TECH_HD_ID = @ATTENDANCE_STAFF_HD_ID and
		TECH_ID like @ATTENDANCE_STAFF_TYPE_ID_NVARCHAR and
		TECH_STATUS = 'T' and  @ATTENDANCE_STAFF_DATE >= t.TECH_LEFT_DATE and @ATTENDANCE_STAFF_DATE >= t.TECH_JOINING_DATE
		and t.TECH_LEAVES_TYPE  not in ('No Deduction', 'Not Generate Salary')
		
		 order by t.TECH_RANKING
			
--union all

--select t.TECH_ID as [tchId], t.TECH_DESIGNATION, (t.TECH_FIRST_NAME + ' ' + t.TECH_LAST_NAME) as name,
--t.TECH_CELL_NO as [Mobile No]    
-- from TEACHER_INFO t
-- where 
--		TECH_BR_ID  in ( select * from [dbo].[get_centralized_br_id]('S', @ATTENDANCE_STAFF_BR_ID) )and
--		TECH_HD_ID = @ATTENDANCE_STAFF_HD_ID and
--		TECH_STATUS = 'T' and  @ATTENDANCE_STAFF_DATE <= t.TECH_LEFT_DATE
--)E order by E.tchId

		
 select STAFF_WORKING_DAYS_NAME as Name, STAFF_WORKING_DAYS_DAY_STATUS as Value, STAFF_WORKING_DAYS_TIME_IN as [Time In],
     STAFF_WORKING_DAYS_TIME_OUT as [Time Out], STAFF_WORKING_DAYS_STAFF_ID as [Staff ID]
     from STAFF_WORKING_DAYS
     where
     STAFF_WORKING_DAYS_HD_ID =  @ATTENDANCE_STAFF_HD_ID and 
	 STAFF_WORKING_DAYS_STAFF_ID like @ATTENDANCE_STAFF_TYPE_ID_NVARCHAR and
	 STAFF_WORKING_DAYS_BR_ID =  @ATTENDANCE_STAFF_BR_ID and
     STAFF_WORKING_DAYS_STATUS = 'T'

 end
 
 else  if @STATUS = 'H'
 begin

select count(ANN_HOLI_DATE) 

from ANNUAL_HOLIDAYS

 where 
	ANN_HOLI_HD_ID =  @ATTENDANCE_STAFF_HD_ID and 
	
	ANN_HOLI_BR_ID =  @ATTENDANCE_STAFF_BR_ID AND
	ANN_HOLI_DATE = @ATTENDANCE_STAFF_DATE and	
	ANN_HOLI_STATUS = 'T' 	
	
	
	select WORKING_DAYS_NAME as Name, WORKING_DAYS_VALUE as Value, WORKING_DAYS_DEPENDENCE AS [Dependence]
	from WORKING_DAYS 
	where WORKING_DAYS_HD_ID = @ATTENDANCE_STAFF_HD_ID and
	WORKING_DAYS_BR_ID = @ATTENDANCE_STAFF_BR_ID and
	WORKING_DAYS_STATUS = 'T'
	
	 	SELECT WORKING_HOURS_ID as ID, WORKING_HOURS_TIME_IN as [Time In], WORKING_HOURS_TIME_OUT as [Time Out]
     FROM WORKING_HOURS
     where
      WORKING_HOURS_HD_ID =  @ATTENDANCE_STAFF_HD_ID and 
     WORKING_HOURS_BR_ID =  @ATTENDANCE_STAFF_BR_ID and
     WORKING_HOURS_STATUS = 'T'
     
     
	end
 else  if @STATUS = 'A'
 begin

select * from
(
select * from (select distinct t.TECH_ID as [tchId], t.TECH_EMPLOYEE_CODE [Employee Code], t.TECH_DESIGNATION as dsg,(t.TECH_FIRST_NAME + ' ' + t.TECH_LAST_NAME) as tchName, 
a.ATTENDANCE_STAFF_REMARKS as tchRemarks, a.ATTENDANCE_STAFF_ID as [attId], a.ATTENDANCE_STAFF_TIME_IN as [Start Time], 
a.ATTENDANCE_STAFF_TIME_OUT as [End Time], a.ATTENDANCE_STAFF_CURRENT_TIME_IN as [Current Time In],
a.ATTENDANCE_STAFF_CURRENT_TIME_OUT as [Current Time Out], t.TECH_CELL_NO as [Mobile No], t.TECH_RANKING as Ranking

FROM ATTENDANCE_STAFF a
join TEACHER_INFO t 
on a.ATTENDANCE_STAFF_TYPE_ID = t.TECH_ID


 where 
	ATTENDANCE_STAFF_HD_ID =  @ATTENDANCE_STAFF_HD_ID and 	
	ATTENDANCE_STAFF_BR_ID in ( select * from [dbo].[get_centralized_br_id]('S', @ATTENDANCE_STAFF_BR_ID) )  AND
	ATTENDANCE_STAFF_DATE = @ATTENDANCE_STAFF_DATE and
	ATTENDANCE_STAFF_TYPE != 'Student' and
	TECH_LEAVES_TYPE not in ('No Deduction', 'Not Generate Salary') and
	t.TECH_DESIGNATION != 'Student' and t.TECH_STATUS = 'T')C
	
	
	union all


select B.tchId, B.[Employee Code], B.dsg, B.tchName, B.tchRemarks, B.attId,B.[Start Time], B.[End Time], 
	B.[Start Time] as  [Current Time In], B.[End Time] as [Current Time Out], B.[Mobile No], B.Ranking
	from
	( 
	select tchId, [Employee Code],a.dsg, a.tchName,a.tchRemarks,a.attId,a.[Mobile No],Ranking,
	(select STAFF_WORKING_DAYS_TIME_IN from STAFF_WORKING_DAYS where 
	STAFF_WORKING_DAYS_HD_ID = @ATTENDANCE_STAFF_HD_ID and STAFF_WORKING_DAYS_BR_ID in ( select * from [dbo].[get_centralized_br_id]
	('S', @ATTENDANCE_STAFF_BR_ID) ) and STAFF_WORKING_DAYS_STAFF_ID = tchId and STAFF_WORKING_DAYS_NAME = DATENAME(WEEKDAY, @ATTENDANCE_STAFF_DATE)) as [Start Time], 
	(select STAFF_WORKING_DAYS_TIME_OUT from STAFF_WORKING_DAYS where 
	STAFF_WORKING_DAYS_HD_ID = @ATTENDANCE_STAFF_HD_ID and STAFF_WORKING_DAYS_BR_ID in ( select * from [dbo].[get_centralized_br_id]
	('S', @ATTENDANCE_STAFF_BR_ID) ) and STAFF_WORKING_DAYS_STAFF_ID = tchId and STAFF_WORKING_DAYS_NAME = DATENAME(WEEKDAY, @ATTENDANCE_STAFF_DATE)) as [End Time]
	
	from 
 (select TECH_ID as [tchId], TECH_DESIGNATION as dsg, (TECH_FIRST_NAME + ' ' + TECH_LAST_NAME) as tchName, 'A' as tchRemarks,
 0 as [attId], TECH_EMPLOYEE_CODE [Employee Code], TECH_CELL_NO as [Mobile No], TECH_RANKING as Ranking
  from TEACHER_INFO where  TECH_LEAVES_TYPE not in ('No Deduction', 'Not Generate Salary') and
  TECH_HD_ID =  @ATTENDANCE_STAFF_HD_ID and 

	TECH_BR_ID in ( select * from [dbo].[get_centralized_br_id]('S', @ATTENDANCE_STAFF_BR_ID) ) 
	and @ATTENDANCE_STAFF_DATE >= TECH_LEFT_DATE and @ATTENDANCE_STAFF_DATE >= TECH_JOINING_DATE and TECH_STATUS = 'T' 
	and TECH_ID not in (select ATTENDANCE_STAFF_TYPE_ID from ATTENDANCE_STAFF where ATTENDANCE_STAFF_DATE = @ATTENDANCE_STAFF_DATE 
  and ATTENDANCE_STAFF_HD_ID =  @ATTENDANCE_STAFF_HD_ID and 
	ATTENDANCE_STAFF_BR_ID in ( select * from [dbo].[get_centralized_br_id]('S', @ATTENDANCE_STAFF_BR_ID) ))
	)A
  )B)D where tchId like @ATTENDANCE_STAFF_TYPE_ID_NVARCHAR
  --where dsg in(select ATTENDANCE_STAFF_TYPE from (select ROW_NUMBER() over(order by (select 0)) as sr, ATTENDANCE_STAFF_TYPE from ATTENDANCE_STAFF 
  --where ATTENDANCE_STAFF_DATE = '2014-12-01' group by ATTENDANCE_STAFF_TYPE)A where sr between 5 and  30)
   order by Ranking, tchId,CAST([Start Time] as datetime)
	--and t.TECH_STATUS = 'T'

 select STAFF_WORKING_DAYS_NAME as Name, STAFF_WORKING_DAYS_DAY_STATUS as Value, STAFF_WORKING_DAYS_TIME_IN as [Time In],
     STAFF_WORKING_DAYS_TIME_OUT as [Time Out], STAFF_WORKING_DAYS_STAFF_ID as [Staff ID]
     from STAFF_WORKING_DAYS
     where
     STAFF_WORKING_DAYS_HD_ID =  @ATTENDANCE_STAFF_HD_ID and 
	 --STAFF_WORKING_DAYS_BR_ID =  @ATTENDANCE_STAFF_BR_ID and
     STAFF_WORKING_DAYS_STATUS = 'T'
	



select B.tchId
	from
	( 
	select tchId,a.dsg, [Employee Code],a.tchName,a.tchRemarks,a.attId,a.[Mobile No],Ranking,
	(select STAFF_WORKING_DAYS_TIME_IN from STAFF_WORKING_DAYS where 
	STAFF_WORKING_DAYS_HD_ID = @ATTENDANCE_STAFF_HD_ID and STAFF_WORKING_DAYS_BR_ID in ( select * from [dbo].[get_centralized_br_id]
	('S', @ATTENDANCE_STAFF_BR_ID) ) and STAFF_WORKING_DAYS_STAFF_ID = tchId and STAFF_WORKING_DAYS_NAME = DATENAME(WEEKDAY, @ATTENDANCE_STAFF_DATE)) as [Start Time], 
	(select STAFF_WORKING_DAYS_TIME_OUT from STAFF_WORKING_DAYS where 
	STAFF_WORKING_DAYS_HD_ID = @ATTENDANCE_STAFF_HD_ID and STAFF_WORKING_DAYS_BR_ID in ( select * from [dbo].[get_centralized_br_id]
	('S', @ATTENDANCE_STAFF_BR_ID) ) and STAFF_WORKING_DAYS_STAFF_ID = tchId and STAFF_WORKING_DAYS_NAME = DATENAME(WEEKDAY, @ATTENDANCE_STAFF_DATE)) as [End Time]
	
	from 
 (select TECH_ID as [tchId], TECH_EMPLOYEE_CODE [Employee Code],TECH_DESIGNATION as dsg, (TECH_FIRST_NAME + ' ' + TECH_LAST_NAME) as tchName, 'A' as tchRemarks,
 0 as [attId],  TECH_CELL_NO as [Mobile No], TECH_RANKING as Ranking
  from TEACHER_INFO where TECH_LEAVES_TYPE not in ('No Deduction', 'Not Generate Salary') and 
  @ATTENDANCE_STAFF_DATE >= TECH_LEFT_DATE and @ATTENDANCE_STAFF_DATE >= TECH_JOINING_DATE and TECH_STATUS = 'T' and TECH_ID not in (select ATTENDANCE_STAFF_TYPE_ID from ATTENDANCE_STAFF where ATTENDANCE_STAFF_DATE = @ATTENDANCE_STAFF_DATE 
  and ATTENDANCE_STAFF_HD_ID =  @ATTENDANCE_STAFF_HD_ID and 
	ATTENDANCE_STAFF_BR_ID in ( select * from [dbo].[get_centralized_br_id]('S', @ATTENDANCE_STAFF_BR_ID) )))A
  )B where tchId like @ATTENDANCE_STAFF_TYPE_ID_NVARCHAR  order by Ranking, tchId



	

 
     END


	 else if @STATUS = 'B'
	 begin
		select t.TECH_ID as ID, t.TECH_EMPLOYEE_CODE as Code, t.TECH_FIRST_NAME + ' ' + t.TECH_LAST_NAME as Name, t.TECH_DESIGNATION as Designation,
		d.DEP_NAME as Department, a.ATTENDANCE_STAFF_REMARKS as Remarks
		
		
		from ATTENDANCE_STAFF a
		join TEACHER_INFO t on t.TECH_ID = a.ATTENDANCE_STAFF_TYPE_ID
		join DEPARTMENT_INFO d on d.DEP_ID = t.TECH_DEPARTMENT
		where TECH_LEAVES_TYPE not in ('No Deduction', 'Not Generate Salary') and ATTENDANCE_STAFF_REMARKS = 'A' and t.TECH_STATUS = 'T' and ATTENDANCE_STAFF_DATE = @ATTENDANCE_STAFF_DATE and ATTENDANCE_STAFF_TYPE_ID like @ATTENDANCE_STAFF_TYPE_ID_NVARCHAR and ATTENDANCE_STAFF_HD_ID = @ATTENDANCE_STAFF_HD_ID and ATTENDANCE_STAFF_BR_ID = @ATTENDANCE_STAFF_BR_ID

	 end
 
     END