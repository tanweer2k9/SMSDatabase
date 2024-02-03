﻿CREATE procedure  [dbo].[sp_ATTENDANCE_Student_selection]
                                               
                                               
     @STATUS char(10),
     @ATTENDANCE_ID  numeric,
     @ATTENDANCE_HD_ID  numeric,
     @ATTENDANCE_BR_ID  numeric,
     @ATTENDANCE_DATE  date,
     @PLAN_ID numeric     
   
   
     AS BEGIN 
   
   
     if @STATUS = 'L'
     BEGIN    

SELECT ID, Name, [Class Teacher] as Incharge FROM VSCHOOL_PLANE    
WHERE [Institute ID] = @ATTENDANCE_HD_ID   
   and  [Branch ID] = @ATTENDANCE_BR_ID
   and  Status = 'T'
 
 end
 
 else  if @STATUS = 'S'
 begin

select  s.STDNT_ID, r.STUDENT_ROLL_NUM_ROLL_NO, (s.STDNT_FIRST_NAME + ' ' + s.STDNT_LAST_NAME) as name,
s.STDNT_PARANT_ID as [Parent ID], p.PARNT_FULL_NAME as [Parent name] ,p.PARNT_CELL_NO as [Parent Cell], s.STDNT_CELL_NO as [Student Cell]
 
 from STUDENT_INFO s   
 join STUDENT_ROLL_NUM r  
 on s.STDNT_ID = r.STUDENT_ROLL_NUM_STD_ID  
 join PARENT_INFO p
 on s.STDNT_PARANT_ID = p.PARNT_ID
 where 
		STDNT_CLASS_PLANE_ID = @PLAN_ID and
		s.STDNT_BR_ID = @ATTENDANCE_BR_ID and
		s.STDNT_HD_ID = @ATTENDANCE_HD_ID and		
	 	s.STDNT_STATUS = 'T' AND 
	 	R.STUDENT_ROLL_NUM_STATUS = 'T' and r.STUDENT_ROLL_NUM_ACTIVE_STATUS in ('new', 'old')
 
  order by r.STUDENT_ROLL_NUM_ROLL_NO
  
  
	select TECH_FIRST_NAME
 from SCHOOL_PLANE 
 join TEACHER_INFO on CLASS_TEACHER = TECH_ID
 where 
		CLASS_ID = @PLAN_ID and
		CLASS_BR_ID = @ATTENDANCE_BR_ID and
		CLASS_HD_ID = @ATTENDANCE_HD_ID and
		CLASS_STATUS != 'D' 

 end
 
 else  if @STATUS = 'H'
 begin

select count(ANN_HOLI_DATE) 

from ANNUAL_HOLIDAYS

 where 
	ANN_HOLI_HD_ID =  @ATTENDANCE_HD_ID and 
	ANN_HOLI_BR_ID =  @ATTENDANCE_BR_ID AND
	ANN_HOLI_DATE = @ATTENDANCE_DATE and	
	ANN_HOLI_STATUS != 'D' 	
	
	
	select WORKING_DAYS_NAME as Name, WORKING_DAYS_VALUE as Value
	from WORKING_DAYS 
	where WORKING_DAYS_HD_ID = @ATTENDANCE_HD_ID and
	WORKING_DAYS_BR_ID = @ATTENDANCE_BR_ID and
	WORKING_DAYS_STATUS != 'D'
	end
	else  if @STATUS = 'A'
 begin

select s.STDNT_ID, r.STUDENT_ROLL_NUM_ROLL_NO, (s.STDNT_FIRST_NAME + ' ' + s.STDNT_LAST_NAME) as name, a.ATTENDANCE_REMARKS, a.ATTENDANCE_ID,
s.STDNT_PARANT_ID as [Parent ID], p.PARNT_FULL_NAME as [Parent name], p.PARNT_CELL_NO as [Parent Cell], s.STDNT_CELL_NO as [Student Cell]

FROM ATTENDANCE a
join STUDENT_ROLL_NUM r 
on a.ATTENDANCE_TYPE_ID = r.STUDENT_ROLL_NUM_STD_ID and r.STUDENT_ROLL_NUM_PLAN_ID = @PLAN_ID
join STUDENT_INFO s
on a.ATTENDANCE_TYPE_ID = s.STDNT_ID
join PARENT_INFO p
 on s.STDNT_PARANT_ID = p.PARNT_ID


 where 
	ATTENDANCE_HD_ID =  @ATTENDANCE_HD_ID and 
	ATTENDANCE_BR_ID =  @ATTENDANCE_BR_ID AND
	ATTENDANCE_DATE = @ATTENDANCE_DATE and
	ATTENDANCE_TYPE = 'Student' and
	ATTENDANCE_STATUS  = 'T' AND
	s.STDNT_STATUS = 'T' AND 
	r.STUDENT_ROLL_NUM_STATUS = 'T' and r.STUDENT_ROLL_NUM_ACTIVE_STATUS in ('new', 'old')

 order by r.STUDENT_ROLL_NUM_ROLL_NO
-- with AA (ID,ROLL_NO,NAME,REMARKS,ATTND,P_ID,P_NAME,MOBILE1,MOBILE2)
--as
--(

--select s.STDNT_ID, r.STUDENT_ROLL_NUM_ROLL_NO, (s.STDNT_FIRST_NAME + ' ' + s.STDNT_LAST_NAME) as name, a.ATTENDANCE_REMARKS, a.ATTENDANCE_ID,
--s.STDNT_PARANT_ID as [Parent ID], p.PARNT_FULL_NAME as [Parent name], p.PARNT_CELL_NO as [Parent Cell], s.STDNT_CELL_NO as [Student Cell]

--FROM ATTENDANCE a
--join STUDENT_ROLL_NUM r 
--on a.ATTENDANCE_TYPE_ID = r.STUDENT_ROLL_NUM_STD_ID and r.STUDENT_ROLL_NUM_PLAN_ID = @PLAN_ID
--join STUDENT_INFO s
--on a.ATTENDANCE_TYPE_ID = s.STDNT_ID
--join PARENT_INFO p
-- on s.STDNT_PARANT_ID = p.PARNT_ID 
-- where
--	ATTENDANCE_HD_ID =  @ATTENDANCE_HD_ID and 
--	ATTENDANCE_BR_ID =  @ATTENDANCE_BR_ID AND
--	ATTENDANCE_DATE = @ATTENDANCE_DATE and
--	ATTENDANCE_TYPE = 'Student' and
--	ATTENDANCE_STATUS  != 'D' AND
--	s.STDNT_STATUS != 'D' AND 
--	r.STUDENT_ROLL_NUM_STATUS != 'D'
 
-- )
--,
 
-- B (ID,ROLL_NO,NAME,REMARKS,ATTND,P_ID,P_NAME,MOBILE1,MOBILE2)
--as
--(
--  select  s.STDNT_ID, r.STUDENT_ROLL_NUM_ROLL_NO, (s.STDNT_FIRST_NAME + ' ' + s.STDNT_LAST_NAME) as name,
--'A' as ATTENDANCE_REMARKS, 0 as ATTENDANCE_ID,
--s.STDNT_PARANT_ID as [Parent ID], p.PARNT_FULL_NAME as [Parent name] ,p.PARNT_CELL_NO as [Parent Cell], s.STDNT_CELL_NO as [Student Cell]
 
-- from STUDENT_INFO s 
-- join STUDENT_ROLL_NUM r  
-- on s.STDNT_ID = r.STUDENT_ROLL_NUM_STD_ID  
-- join PARENT_INFO p
-- on s.STDNT_PARANT_ID = p.PARNT_ID
-- where s.STDNT_CLASS_PLANE_ID = @PLAN_ID and

--	s.STDNT_BR_ID = @ATTENDANCE_BR_ID and
--	s.STDNT_HD_ID = @ATTENDANCE_HD_ID and
--	s.STDNT_STATUS != 'D' AND 
--	r.STUDENT_ROLL_NUM_STATUS != 'D'
 
-- )
--select * from B
--where B.ID != (select ID from AA)


--union

--select s.STDNT_ID, r.STUDENT_ROLL_NUM_ROLL_NO, (s.STDNT_FIRST_NAME + ' ' + s.STDNT_LAST_NAME) as name, a.ATTENDANCE_REMARKS, a.ATTENDANCE_ID,
--s.STDNT_PARANT_ID as [Parent ID], p.PARNT_FULL_NAME as [Parent name], p.PARNT_CELL_NO as [Parent Cell], s.STDNT_CELL_NO as [Student Cell]

--FROM ATTENDANCE a
--join STUDENT_ROLL_NUM r 
--on a.ATTENDANCE_TYPE_ID = r.STUDENT_ROLL_NUM_STD_ID and r.STUDENT_ROLL_NUM_PLAN_ID = @PLAN_ID
--join STUDENT_INFO s
--on a.ATTENDANCE_TYPE_ID = s.STDNT_ID
--join PARENT_INFO p
-- on s.STDNT_PARANT_ID = p.PARNT_ID 
-- where
--	ATTENDANCE_HD_ID =  @ATTENDANCE_HD_ID and 
--	ATTENDANCE_BR_ID =  @ATTENDANCE_BR_ID AND
--	ATTENDANCE_DATE = @ATTENDANCE_DATE and
--	ATTENDANCE_TYPE = 'Student' and
--	ATTENDANCE_STATUS  != 'D' AND
--	s.STDNT_STATUS != 'D' AND 
--	r.STUDENT_ROLL_NUM_STATUS != 'D'

--order by ID
 
 

	select TECH_FIRST_NAME
 from SCHOOL_PLANE 
 join TEACHER_INFO on CLASS_TEACHER = TECH_ID
 where 
		CLASS_ID = @PLAN_ID and
		CLASS_BR_ID = @ATTENDANCE_BR_ID and
		CLASS_HD_ID = @ATTENDANCE_HD_ID and
		CLASS_STATUS != 'D' 
	
	
	--SELECT * FROM ATTENDANCE
 --   WHERE
 --   ATTENDANCE_ID =  @ATTENDANCE_ID and 
 --   ATTENDANCE_HD_ID =  @ATTENDANCE_HD_ID and 
 --   ATTENDANCE_BR_ID =  @ATTENDANCE_BR_ID AND
	--ATTENDANCE_STATUS  != 'D'
	
	
	--SELECT CLASS_ID as ID, CLASS_Name as Name, CLASS_TEACHER as Incharge FROM SCHOOL_PLANE    
	--WHERE CLASS_HD_ID = @ATTENDANCE_HD_ID   
 --   and  CLASS_BR_ID = @ATTENDANCE_BR_ID
 --   and  CLASS_STATUS != 'D'     
    
    
 --   SELECT * FROM STUDENT_ROLL_NUM
 --   WHERE STUDENT_ROLL_NUM_BR_ID =  @ATTENDANCE_HD_ID and 
 --   STUDENT_ROLL_NUM_BR_ID =  @ATTENDANCE_BR_ID AND
	--STUDENT_ROLL_NUM_STATUS != 'D'
     
     
 --    SELECT * FROM STUDENT_INFO
 --   WHERE STDNT_HD_ID =  @ATTENDANCE_HD_ID and 
 --   STDNT_BR_ID =  @ATTENDANCE_BR_ID AND
	--STDNT_STATUS != 'D'	
 
     END
     
 
END