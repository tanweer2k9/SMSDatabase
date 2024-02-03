CREATE procedure  [dbo].[sp_TOTAL_ATENDANCE_Teacher_selection]
                                               
                                               
     @STATUS char(1),
     @STAFF_ID numeric,
     @DESIGNATION_NAME nvarchar(50),
     @ATTENDANCE_HD_ID  numeric,
     @ATTENDANCE_BR_ID  numeric,
     @DATE_YEAR nvarchar(10),
     @DATE_MONTH nvarchar(10)
	    

     AS BEGIN 

	 
	declare @t table (ATTENDANCE_STAFF_DATE date,ATTENDANCE_STAFF_REMARKS nvarchar(50),ATTENDANCE_STAFF_TIME_IN nvarchar(50),	
	ATTENDANCE_STAFF_TIME_OUT nvarchar(50), ATTENDANCE_STAFF_CURRENT_TIME_IN nvarchar(50), ATTENDANCE_STAFF_CURRENT_TIME_OUT nvarchar(50))


   if @STATUS = 'L'
   BEGIN
      
    select DESIGNATION_ID as ID, DESIGNATION_NAME as Name from DESIGNATION_INFO
    where DESIGNATION_STATUS != 'D'
    and DESIGNATION_HD_ID = @ATTENDANCE_HD_ID and DESIGNATION_BR_ID = @ATTENDANCE_BR_ID
   END
    ELSE if @STATUS = 'S'
     BEGIN
	select TECH_ID as [Staff ID], (TECH_FIRST_NAME + ' ' + TECH_LAST_NAME) as Name, TECH_DESIGNATION as Designation
	from TEACHER_INFO 
	where TECH_DESIGNATION = @DESIGNATION_NAME and 
	TECH_BR_ID in (select * from [dbo].[get_centralized_br_id]('S', @ATTENDANCE_BR_ID)) and
	TECH_HD_ID in (select * from [dbo].[get_all_hd_id](@ATTENDANCE_HD_ID)) and 
	TECH_STATUS != 'D'	  order by TECH_RANKING
    
    END
    ELSE if @STATUS = 'A'
     BEGIN
     select STAFF_WORKING_DAYS_NAME as Name, STAFF_WORKING_DAYS_DAY_STATUS as Value, STAFF_WORKING_DAYS_STAFF_ID as [Staff ID]
     from STAFF_WORKING_DAYS
     where 
     STAFF_WORKING_DAYS_BR_ID = @ATTENDANCE_BR_ID and
     STAFF_WORKING_DAYS_HD_ID = @ATTENDANCE_HD_ID
    --select WORKING_DAYS_NAME as Name, WORKING_DAYS_VALUE as Value
    --from WORKING_DAYS
    --where WORKING_DAYS_HD_ID = @ATTENDANCE_HD_ID and
    --WORKING_DAYS_BR_ID = @ATTENDANCE_BR_ID
    
    
	SELECT COUNT(ANN_HOLI_DATE)
    from ANNUAL_HOLIDAYS
    where 
    ANN_HOLI_BR_ID = @ATTENDANCE_BR_ID and
    ANN_HOLI_HD_ID = @ATTENDANCE_HD_ID and
    ANN_HOLI_STATUS = 'T' and 
    DATEPART(YYYY, ANN_HOLI_DATE)= @DATE_YEAR and 
    DATEPART(mm, ANN_HOLI_DATE) = @DATE_MONTH
        
 select COUNT(distinct a.ATTENDANCE_STAFF_DATE)
 from  ATTENDANCE_STAFF a
 where 
		a.ATTENDANCE_STAFF_TYPE = @DESIGNATION_NAME and
		DATEPART(YYYY, a.ATTENDANCE_STAFF_DATE) = @DATE_YEAR and	
		DATEPART(MM, a.ATTENDANCE_STAFF_DATE) = @DATE_MONTH and		
		a.ATTENDANCE_STAFF_TYPE_ID = @STAFF_ID and
		a.ATTENDANCE_STAFF_BR_ID in (select * from [dbo].[get_centralized_br_id]('S', @ATTENDANCE_BR_ID)) and
		a.ATTENDANCE_STAFF_HD_ID = @ATTENDANCE_HD_ID and
	 	a.ATTENDANCE_STAFF_STATUS != 'D'
	 	
	 	
	 	
	 	
	insert into @t

	select  a.ATTENDANCE_STAFF_DATE, a.ATTENDANCE_STAFF_REMARKS, a.ATTENDANCE_STAFF_TIME_IN as [Time In],
	a.ATTENDANCE_STAFF_TIME_OUT as [Time Out], a.ATTENDANCE_STAFF_CURRENT_TIME_IN as [Current Time In], 
	a.ATTENDANCE_STAFF_CURRENT_TIME_OUT as [Current Time Out]
 from ATTENDANCE_STAFF a
 where 
		a.ATTENDANCE_STAFF_TYPE = @DESIGNATION_NAME and
		DATEPART(YYYY, a.ATTENDANCE_STAFF_DATE) = @DATE_YEAR and	
		DATEPART(MM, a.ATTENDANCE_STAFF_DATE) = @DATE_MONTH and		
		a.ATTENDANCE_STAFF_TYPE_ID = @STAFF_ID and
		a.ATTENDANCE_STAFF_BR_ID in (select * from [dbo].[get_centralized_br_id]('S', @ATTENDANCE_BR_ID)) and
		a.ATTENDANCE_STAFF_HD_ID = @ATTENDANCE_HD_ID and
	 	a.ATTENDANCE_STAFF_STATUS != 'D'		


	
	select C.ATTENDANCE_STAFF_DATE, C.ATTENDANCE_STAFF_REMARKS, C.ATTENDANCE_STAFF_TIME_IN, D.ATTENDANCE_STAFF_TIME_OUT,C.ATTENDANCE_STAFF_CURRENT_TIME_IN, C.ATTENDANCE_STAFF_CURRENT_TIME_OUT from

	(select * from
	(select ROW_NUMBER() over (partition by ATTENDANCE_STAFF_DATE order by ATTENDANCE_STAFF_DATE ASC, 
	CAST(ATTENDANCE_STAFF_TIME_IN as datetime) ASC) as sr,* from @t )A where A.sr = 1)C
	join 

	(select * from 
	(select ROW_NUMBER() over (partition by ATTENDANCE_STAFF_DATE order by ATTENDANCE_STAFF_DATE ASC, 
	CAST(ATTENDANCE_STAFF_TIME_IN as datetime) DESC) as sr,* from @t)B where B.sr = 1)D
	on C.ATTENDANCE_STAFF_DATE = D.ATTENDANCE_STAFF_DATE


	select WORKING_DAYS_NAME as Name, WORKING_DAYS_VALUE as Value from WORKING_DAYS


		declare @count int = 1
		select @count = COUNT(*) from (Select ATTENDANCE_STAFF_DATE from @t group by ATTENDANCE_STAFF_DATE)A
		--select @count
		--select DATEDIFF(S, CAST(ATTENDANCE_STAFF_TIME_IN as datetime),CAST(ATTENDANCE_STAFF_TIME_OUT as datetime)) + 1 as seconds,CAST(ATTENDANCE_STAFF_TIME_IN as datetime) as time_in,CAST(ATTENDANCE_STAFF_TIME_OUT as datetime) as time_out,* from @t
		--SELECT DATEADD(S,SUM(seconds),'1900-01-01') as DAILy_Time FROM (select DATEDIFF(S, CAST(ATTENDANCE_STAFF_TIME_IN as datetime),CAST(ATTENDANCE_STAFF_TIME_OUT as datetime)) + 1 as seconds,CAST(ATTENDANCE_STAFF_TIME_IN as datetime) as time_in,CAST(ATTENDANCE_STAFF_TIME_OUT as datetime) as time_out,* from @t)A group by ATTENDANCE_STAFF_DATE
		select DATEADD(S,SUM(DATEDIFF(S, CAST(ATTENDANCE_STAFF_TIME_IN as datetime),CAST(ATTENDANCE_STAFF_TIME_OUT as datetime)))/ @count,'1900-01-01') from @t 


     END  
     
     
 
     END