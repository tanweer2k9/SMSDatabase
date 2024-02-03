CREATE procedure  [dbo].[sp_TOTAL_ATENDANCE_selection]
                                               
                                               
     @STATUS char(1),
     @PLANE_ID numeric,
     @CLASS_HD_ID  numeric,
     @CLASS_BR_ID  numeric,
     @DATE_YEAR nvarchar(10),
     @DATE_MONTH nvarchar(10)
	 
   
     AS BEGIN 
     declare @hd_id int 
     declare @br_id int 
     if @CLASS_HD_ID = 0
    begin
		set @hd_id = 1	
    end
    else
    begin
		set @hd_id = @CLASS_HD_ID
    end
    
     if @CLASS_BR_ID = 0
    begin
		set @br_id = 1	
    end
     else
    begin
		set @br_id = @CLASS_BR_ID
    end
    
     
   if @STATUS = 'L'
   BEGIN
      
    select CLASS_ID as ID, CLASS_Name as Name from SCHOOL_PLANE
    where CLASS_STATUS = 'T'
    and CLASS_HD_ID = @CLASS_HD_ID and CLASS_BR_ID = @CLASS_BR_ID   
   
   END
    ELSE if @STATUS = 'S'
     BEGIN
   
     select p.CLASS_Name as [Plane Name], p.CLASS_CLASS as Class, p.CLASS_SECTION as Section, p.CLASS_TEACHER as [Class Incharge]
     from SCHOOL_PLANE p where p.CLASS_ID = @PLANE_ID
   
    
    select WORKING_DAYS_NAME as Name, WORKING_DAYS_VALUE as Value
    from WORKING_DAYS
    where WORKING_DAYS_HD_ID = @hd_id and
    WORKING_DAYS_BR_ID = @br_id
    
    
	SELECT COUNT(ANN_HOLI_DATE)
    from ANNUAL_HOLIDAYS
    where
    ANN_HOLI_BR_ID = @br_id and
    ANN_HOLI_HD_ID = @hd_id and
    ANN_HOLI_STATUS = 'T' and 
    DATEPART(YYYY, ANN_HOLI_DATE)= @DATE_YEAR and 
    DATEPART(mm, ANN_HOLI_DATE) = @DATE_MONTH
        
 select COUNT(distinct a.ATTENDANCE_DATE)
 from STUDENT_INFO s  
 join STUDENT_ROLL_NUM r
 on s.STDNT_ID = r.STUDENT_ROLL_NUM_STD_ID 
 join ATTENDANCE a
 on s.STDNT_ID = a.ATTENDANCE_TYPE_ID
 where 
		STDNT_CLASS_PLANE_ID = @PLANE_ID and
		DATEPART(YYYY, a.ATTENDANCE_DATE) = @DATE_YEAR and	
		DATEPART(MM, a.ATTENDANCE_DATE) = @DATE_MONTH and
		a.ATTENDANCE_TYPE = 'Student' and
		s.STDNT_BR_ID =  @CLASS_BR_ID and
		s.STDNT_HD_ID = @CLASS_HD_ID and
	 	s.STDNT_STATUS = 'T' AND 
	 	R.STUDENT_ROLL_NUM_STATUS = 'T' and r.STUDENT_ROLL_NUM_ACTIVE_STATUS in ('new', 'old')
	 	
	 	
	 	
	select a.ATTENDANCE_REMARKS
 from STUDENT_INFO s  
 join STUDENT_ROLL_NUM r
 on s.STDNT_ID = r.STUDENT_ROLL_NUM_STD_ID 
 join ATTENDANCE a
 on s.STDNT_ID = a.ATTENDANCE_TYPE_ID
 where 
		STDNT_CLASS_PLANE_ID = @PLANE_ID and
		DATEPART(YYYY, a.ATTENDANCE_DATE) = @DATE_YEAR and	
		DATEPART(MM, a.ATTENDANCE_DATE) = @DATE_MONTH and
		a.ATTENDANCE_TYPE = 'Student' and
		s.STDNT_BR_ID =  @CLASS_BR_ID and
		s.STDNT_HD_ID = @CLASS_HD_ID and
	 	s.STDNT_STATUS = 'T' AND 
	 	R.STUDENT_ROLL_NUM_STATUS = 'T' and r.STUDENT_ROLL_NUM_ACTIVE_STATUS in ('new', 'old')
	 	
	select COUNT(STDNT_ID)
     
    from STUDENT_INFO
    where STDNT_CLASS_PLANE_ID = @PLANE_ID and 
    STDNT_BR_ID = @CLASS_BR_ID and
    STDNT_HD_ID = @CLASS_HD_ID and 
    STDNT_STATUS = 'T' 
    
     END  
     
     
     
     
 
	
 
     END