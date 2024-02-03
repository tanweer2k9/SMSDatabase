

CREATE procedure  [dbo].[sp_SCHOOL_PLANE_selection]                                                                                              
     @STATUS char(10),
     @CLASS_ID  numeric,
     @CLASS_HD_ID  numeric,
     @CLASS_BR_ID numeric  ,
	 @CLASS_SESSION_ID numeric 
     AS BEGIN    
   
   -- declare @SessionId numeric = 0
   --set @SessionId = (select SESSION_ID from SESSION_INFO where SESSION_DESC = '2018-2019' and SESSION_BR_ID = @CLASS_BR_ID)

   IF @STATUS = 'L'
   BEGIN

  
   --select  ISNULL( MAX( CLASS_ID ),0)+1 as Code from SCHOOL_PLANE
   --select ISNULL( MAX( ID ),0)+1 as [max] , 
   select * from VSCHOOL_PLANE  
    
   where [Institute ID] = @CLASS_HD_ID   
    and  [Branch ID] = @CLASS_BR_ID and [Session Id] = @CLASS_SESSION_ID
    and  [Status] != 'D'order by [Order]
    
   --group by ID ,[Institute ID] ,[Branch ID],Name ,Class,Term,Shift,Section,Department,[Class Teacher],Fee,[Min Fee Variation],[Max Fee Variation],[Status]
   
   select DEF_ID as ID,DEF_SUBJECT as Subject,DEF_TEACHER as Teacher,DEF_TERM as Term, DEF_START_TIME as [Start Time],DEF_END_TIME as [End Time],DEF_STATUS as  Status, DEF_IS_COMPULSORY [Is Compulsory] from SCHOOL_PLANE_DEFINITION   
   where DEF_ID = 0
   
   
   
   --select CLASS_ID as ID,CLASS_NAME as Name from CLASS_INFO as Class
   --where CLASS_STATUS = 'T'
   --and CLASS_HD_ID = @CLASS_HD_ID and CLASS_BR_ID = @CLASS_BR_ID
  
   --select SECT_ID as IDI,SECT_NAME as Name from SECTION_INFO as Section
   --where SECT_STATUS = 'T'
   --and SECT_HD_ID = @CLASS_HD_ID and SECT_BR_ID = @CLASS_BR_ID
   
   --select DEP_ID as ID,DEP_NAME as Name from DEPARTMENT_INFO as Department
   --where DEP_STATUS = 'T'
   --and DEP_HD_ID = @CLASS_HD_ID and DEP_BR_ID = @CLASS_BR_ID
  
   --select SHFT_ID as ID,SHFT_NAME as Name from SHIFT_INFO as Shift
   --where SHFT_STATUS = 'T'
   --and SHFT_HD_ID = @CLASS_HD_ID and SHFT_BR_ID = @CLASS_BR_ID
      
   --select SUB_ID as ID,SUB_NAME as Name from SUBJECT_INFO as [Subject]
   --where SUB_STATUS = 'T'
   --and SUB_HD_ID = @CLASS_HD_ID and SUB_BR_ID = @CLASS_BR_ID
    
   --select TECH_ID as ID,TECH_FIRST_NAME as Name from TEACHER_INFO as [Teacher]
   --where TECH_STATUS = 'T'
   --and TECH_HD_ID = @CLASS_HD_ID AND TECH_BR_ID in ( select * from [dbo].[get_centralized_br_id]('S', @CLASS_BR_ID)) 
   
   --select * from VTEACHER_INFO
		 --where [Institute ID] = @CLASS_HD_ID   
   -- and  [Branch ID] = @CLASS_BR_ID
   -- and  [Status] != 'D' and [Status] != 'F'
      
   --select TERM_ID as ID,TERM_NAME as Name from TERM_INFO as [Term]
   --where TERM_STATUS = 'T'
   --and TERM_HD_ID = @CLASS_HD_ID and TERM_BR_ID = @CLASS_BR_ID      
   
   END
   
   
     Else if @STATUS = 'A'
     BEGIN
     
	select * from VSCHOOL_PLANE   
	    
   where [Institute ID] = @CLASS_HD_ID   
    and  [Branch ID] = @CLASS_BR_ID and [Session Id] = @CLASS_SESSION_ID
    
    select * from SCHOOL_PLANE_DEFINITION
   
     END  
     
     
     
     ELSE IF  @STATUS =  'B'
     BEGIN
     
	 --SELECT * FROM SCHOOL_PLANE 	 
	select * from VSCHOOL_PLANE      
	
	where 		    
	[Institute ID] = @CLASS_HD_ID   
    and  [Branch ID] = @CLASS_BR_ID and [Session Id] = @CLASS_SESSION_ID
    and  [Status] != 'D'    order by [Order]
      
   --group by ID ,[Institute ID] ,[Branch ID],Name ,Class,Term,Shift,Section,Department,[Class Teacher],Fee,[Min Fee Variation],[Max Fee Variation],[Status]
   
   
	
	--select DEF_ID as ID,DEF_SUBJECT as [Subject],DEF_TEACHER as Teacher,DEF_TERM as Term,DEF_START_TIME as [Start Time],DEF_END_TIME as [End Time],DEF_STATUS as [Status] from SCHOOL_PLANE_DEFINITION      
	--where [DEF_CLASS_ID] = @CLASS_ID
	-- and [DEF_STATUS] != 'D'
	--select ID,Subject,Teacher, Term, [Start Time], [End Time],Status from VSCHOOL_PLANE_DEFINITION
	select DEF_ID as ID,DEF_SUBJECT as Subject,DEF_TEACHER as Teacher,DEF_TERM as Term, DEF_START_TIME as [Start Time],DEF_END_TIME as [End Time],DEF_STATUS as  Status, DEF_IS_COMPULSORY [Is Compulsory] from SCHOOL_PLANE_DEFINITION
	where DEF_CLASS_ID = @CLASS_ID and DEF_STATUS != 'D'
   
     
 
     END
     
     ELSE IF @STATUS = 'D'
     begin
		select v.*, p.CLASS_TEACHER as [Incharge ID] from VSCHOOL_PLANE	v
		join SCHOOL_PLANE p on p.CLASS_ID = v.ID
		where 
			[Institute ID] like dbo.set_where_like(@CLASS_HD_ID) and
			[Branch ID] like dbo.set_where_like(@CLASS_BR_ID) and
			Status = 'T'	
						
		select STDNT_ID as [Std ID], STDNT_CLASS_PLANE_ID as [Class ID], STDNT_PARANT_ID as [Parent ID] from STUDENT_INFO
		
		
     end
     
     ELSE IF @STATUS = 'C'
     begin
		select ID,[Institute ID] as [HD ID], [Branch ID] as [BR ID], Name from VSCHOOL_PLANE where Status = 'T' and [Session Id] = @CLASS_SESSION_ID
     end
     
     select CLASS_ID as ID,CLASS_NAME as Name from CLASS_INFO as Class
   where CLASS_STATUS = 'T'
   and CLASS_HD_ID = @CLASS_HD_ID and CLASS_BR_ID = @CLASS_BR_ID
  
   select SECT_ID as IDI,SECT_NAME as Name from SECTION_INFO as Section
   where SECT_STATUS = 'T'
   and SECT_HD_ID = @CLASS_HD_ID and SECT_BR_ID = @CLASS_BR_ID
   
   select DEP_ID as ID,DEP_NAME as Name from DEPARTMENT_INFO as Department
   where DEP_STATUS = 'T'
   and DEP_HD_ID = @CLASS_HD_ID and DEP_BR_ID = @CLASS_BR_ID
  
   select SHFT_ID as ID,SHFT_NAME as Name from SHIFT_INFO as Shift
   where SHFT_STATUS = 'T'
   and SHFT_HD_ID = @CLASS_HD_ID and SHFT_BR_ID = @CLASS_BR_ID
      
   select SUB_ID as ID,SUB_NAME as Name from SUBJECT_INFO as [Subject]
   where SUB_STATUS = 'T'
   and SUB_HD_ID = @CLASS_HD_ID and SUB_BR_ID = @CLASS_BR_ID
    
   select TECH_ID as ID,TECH_FIRST_NAME as Name from TEACHER_INFO as [Teacher]
   where TECH_STATUS = 'T'
   and TECH_HD_ID = @CLASS_HD_ID AND TECH_BR_ID in ( select * from [dbo].[get_centralized_br_id]('S', @CLASS_BR_ID)) 
   
   --select * from VTEACHER_INFO
		 --where [Institute ID] = @CLASS_HD_ID   
   -- and  [Branch ID] = @CLASS_BR_ID
   -- and  [Status] != 'D' and [Status] != 'F'
      
   select TERM_ID as ID,TERM_NAME as Name from TERM_INFO as [Term]
   where TERM_STATUS = 'T'
   and TERM_HD_ID = @CLASS_HD_ID and TERM_BR_ID = @CLASS_BR_ID   and TERM_SESSION_ID = @CLASS_SESSION_ID   order by TERM_RANK
   
   select MAX(DEF_ID) from SCHOOL_PLANE_DEFINITION

   select Level_ID ID, Level_Name Name from Levels where Level_STATUS = 'T' 


END