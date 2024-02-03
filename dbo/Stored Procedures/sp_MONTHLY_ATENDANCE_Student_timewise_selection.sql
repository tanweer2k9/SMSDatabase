CREATE procedure  [dbo].[sp_MONTHLY_ATENDANCE_Student_timewise_selection]
                                               
                                               
     @STATUS char(1),
	 @STDNT_ID numeric,
     @CLASS_ID numeric,
     @ATTENDANCE_HD_ID  numeric,
     @ATTENDANCE_BR_ID  numeric,
     @DATE_YEAR nvarchar(10),
     @DATE_MONTH nvarchar(10),
     @DATE_DAY nvarchar(10)
	 
   
     AS BEGIN 
   if @STATUS = 'L'
   BEGIN
      
    select CLASS_ID as ID, CLASS_Name as Name from SCHOOL_PLANE
    where CLASS_STATUS = 'T'
    and CLASS_HD_ID = @ATTENDANCE_HD_ID and CLASS_BR_ID = @ATTENDANCE_BR_ID 
    
    
   
   END
    ELSE if @STATUS = 'M'
     BEGIN
	select WORKING_DAYS_NAME as Name, WORKING_DAYS_VALUE as Value
    from WORKING_DAYS
    where 
    WORKING_DAYS_HD_ID = @ATTENDANCE_HD_ID and
    WORKING_DAYS_BR_ID = @ATTENDANCE_BR_ID
    

    
    SELECT ANN_HOLI_DATE
    from ANNUAL_HOLIDAYS
    where DATEPART(YYYY, ANN_HOLI_DATE)= @DATE_YEAR and DATEPART(mm, ANN_HOLI_DATE) = @DATE_MONTH 
    and ANN_HOLI_HD_ID = @ATTENDANCE_HD_ID and ANN_HOLI_BR_ID = @ATTENDANCE_BR_ID
      


		select wd.WORKING_DAYS_NAME Name, wd.WORKING_DAYS_VALUE Value, wh.WORKING_HOURS_TIME_IN [Time In], wh.WORKING_HOURS_TIME_OUT [Time Out]
	from WORKING_HOURS wh
	cross join WORKING_DAYS wd
	where WORKING_HOURS_HD_ID = @ATTENDANCE_HD_ID and WORKING_HOURS_BR_ID = @ATTENDANCE_BR_ID
	and WORKING_DAYS_HD_ID = @ATTENDANCE_HD_ID and WORKING_DAYS_BR_ID = @ATTENDANCE_BR_ID
 --   select WORKING_DAYS_NAME as Name, WORKING_DAYS_VALUE as Value
	--from WORKING_DAYS, WORKING_HOURS
 --   STAFF_WORKING_DAYS_TIME_IN as [Time In], STAFF_WORKING_DAYS_TIME_OUT as [Time Out],
 --   STAFF_WORKING_DAYS_STAFF_ID as [Staff ID]
 --   from STAFF_WORKING_DAYS
 --   where STAFF_WORKING_DAYS_HD_ID = @ATTENDANCE_HD_ID and
 --   STAFF_WORKING_DAYS_BR_ID = @ATTENDANCE_BR_ID
      
      END
    
    
    ELSE if @STATUS = 'S'
     BEGIN
     
	 select s.STDNT_ID [Std ID], s.STDNT_SCHOOL_ID [Sch ID], (s.STDNT_FIRST_NAME + ' ' + s.STDNT_LAST_NAME) as Name, sp.CLASS_Name as [Class Plan]
	 from STUDENT_INFO s
	 join SCHOOL_PLANE sp on sp.CLASS_ID = s.STDNT_CLASS_PLANE_ID
	 where STDNT_CLASS_PLANE_ID = @CLASS_ID
	 and s.STDNT_HD_ID = @ATTENDANCE_HD_ID
	 and s.STDNT_BR_ID = @ATTENDANCE_BR_ID
	 and s.STDNT_STATUS = 'T'
	 order by STDNT_SCHOOL_ID, s.STDNT_ID


    
      END
    
    
    ELSE if @STATUS = 'A'
     BEGIN
        
   SELECT ATTENDANCE_DATE ,ATTENDANCE_REMARKS, ATTENDANCE_TIME_IN, 
   ATTENDANCE_TIME_OUT, ATTENDANCE_EXPECTED_TIME_IN as [Current Time In], 
   ATTENDANCE_EXPECTED_TIME_OUT as [Current Time Out]
   
   from ATTENDANCE
   where 
   ATTENDANCE_CLASS_ID = @CLASS_ID and
   ATTENDANCE_HD_ID = @ATTENDANCE_HD_ID and
   ATTENDANCE_BR_ID = @ATTENDANCE_BR_ID and
   ATTENDANCE_TYPE_ID = @STDNT_ID and
   DATEPART(YYYY, ATTENDANCE_DATE)= @DATE_YEAR and 
   DATEPART(mm, ATTENDANCE_DATE) = @DATE_MONTH
   
   
   order by ATTENDANCE_DATE, CAST(ATTENDANCE_TIME_IN as datetime)

   
   select WORKING_HOURS_TIME_IN as [Time In], WORKING_HOURS_TIME_OUT as [Time Out]
   from WORKING_HOURS
   where WORKING_HOURS_BR_ID = @ATTENDANCE_BR_ID and
   WORKING_HOURS_HD_ID = @ATTENDANCE_HD_ID and
   WORKING_HOURS_STATUS = 'T'
    
     END  
     
     
     
     
 
	
 
     END