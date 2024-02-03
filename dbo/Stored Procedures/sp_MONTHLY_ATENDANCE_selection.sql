CREATE procedure  [dbo].[sp_MONTHLY_ATENDANCE_selection]
                                               
                                               
     @STATUS char(1),
     @PLANE_ID numeric,
     @STDNT_ID numeric,
     @CLASS_HD_ID  numeric,
     @CLASS_BR_ID  numeric,
     @DATE_YEAR nvarchar(10),
     @DATE_MONTH nvarchar(10),
     @DATE_DAY nvarchar(10)
	 
   
     AS BEGIN 
   if @STATUS = 'L'
   BEGIN
      
    select CLASS_ID as Code,CLASS_Name as Name from SCHOOL_PLANE
    where CLASS_STATUS = 'T'
    and CLASS_HD_ID = @CLASS_HD_ID and CLASS_BR_ID = @CLASS_BR_ID   
    
    
   
   END
    ELSE if @STATUS = 'M'
     BEGIN
	select WORKING_DAYS_NAME as Name, WORKING_DAYS_VALUE as Value
    from WORKING_DAYS
    where WORKING_DAYS_HD_ID = @CLASS_HD_ID and
    WORKING_DAYS_BR_ID = @CLASS_BR_ID
    
    SELECT ANN_HOLI_DATE
    from ANNUAL_HOLIDAYS
    where DATEPART(YYYY, ANN_HOLI_DATE)= @DATE_YEAR and DATEPART(mm, ANN_HOLI_DATE) = @DATE_MONTH 
      END
    
    
    ELSE if @STATUS = 'S'
     BEGIN
     select  s.STDNT_ID as [Student ID],  (s.STDNT_FIRST_NAME + ' ' + s.STDNT_LAST_NAME) as Name, 
     r.STUDENT_ROLL_NUM_ROLL_NO AS [Roll No]
 from STUDENT_INFO s   
 join STUDENT_ROLL_NUM r  
 on s.STDNT_ID = r.STUDENT_ROLL_NUM_STD_ID  
 where 
		STDNT_CLASS_PLANE_ID = @PLANE_ID and
		s.STDNT_BR_ID = @CLASS_BR_ID and
		s.STDNT_HD_ID = @CLASS_HD_ID and
	 	s.STDNT_STATUS != 'D' AND 
	 	R.STUDENT_ROLL_NUM_STATUS != 'D' AND r.STUDENT_ROLL_NUM_ACTIVE_STATUS in ('new', 'old')
   
    
      END
    
    
    ELSE if @STATUS = 'A'
     BEGIN
        
        
   SELECT distinct ATTENDANCE_DATE ,ATTENDANCE_REMARKS
   
   from ATTENDANCE
   where 
   ATTENDANCE_TYPE = 'Student' and
   ATTENDANCE_HD_ID = @CLASS_HD_ID and
   ATTENDANCE_BR_ID = @CLASS_BR_ID and
   ATTENDANCE_TYPE_ID = @STDNT_ID and
   DATEPART(YYYY, ATTENDANCE_DATE)= @DATE_YEAR and 
   DATEPART(mm, ATTENDANCE_DATE) = @DATE_MONTH and   
   ATTENDANCE_STATUS != 'D' 
   
   order by ATTENDANCE_DATE
   
    
     END  
     
     
     
     
 
	
 
     END