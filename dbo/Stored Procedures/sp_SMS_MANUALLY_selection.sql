CREATE procedure  [dbo].[sp_SMS_MANUALLY_selection]
                                               
                                               
     @STATUS nvarchar(50),
     @SMS_MANUALLY_MESSAGE nvarchar(200),
     @SMS_MANUALLY_HD_ID  numeric,
     @SMS_MANUALLY_BR_ID  numeric,
     @SMS_MANUALLY_PLANE numeric
     
   
   
     AS BEGIN 
   
   declare @class_plan nvarchar(50) = '%'
	select  ID, Name
	from VSCHOOL_PLANE
	where [Institute ID] = @SMS_MANUALLY_HD_ID and [Branch ID] = @SMS_MANUALLY_BR_ID
	
	
	if @SMS_MANUALLY_PLANE != '0'
				   begin
						set @class_plan = CAST((@SMS_MANUALLY_PLANE) as nvarchar(50))
				   end

	
	
	if @STATUS = 'all'
     begin
					      
					   select ROW_NUMBER() over (order by (SELECT 0)) as Sr, * from ( select ID, ([First Name] + ' ' + [Last Name]) as Name, [Contact #] as [Mobile #], 'Staff' as [Person], REPLACE(@SMS_MANUALLY_MESSAGE, '^Name^', ( [First Name] + ' ' + [Last Name] )) as[Message], 'T' as [Send Status]
					   from VTEACHER_INFO where [Institute ID] = @SMS_MANUALLY_HD_ID and [Branch ID] = @SMS_MANUALLY_BR_ID and [Status] = 'T'
					   
					   
					   union all
					   
					   select  ID, [Full Name] as Name, [1st Relation Cell #] as [Mobile #], 'Parent' as [Person], REPLACE(@SMS_MANUALLY_MESSAGE, '^Name^', (  [Full Name] )) as[Message], 'T' as [Send Status]
					   from VPARENT_INFO where [Institute ID] = @SMS_MANUALLY_HD_ID and [Branch ID] = @SMS_MANUALLY_BR_ID and [Status] = 'T'

						union all
												
					   select ID, ([First Name] + ' ' + [Last Name]) as Name, [Cell #] as [Mobile #], 'Student' as [Person], REPLACE(@SMS_MANUALLY_MESSAGE, '^Name^', ( [First Name] + ' ' + [Last Name] )) as[Message], 'T' as [Send Status]
					   from VSTUDENT_INFO where [Institute ID] = @SMS_MANUALLY_HD_ID and [Branch ID] = @SMS_MANUALLY_BR_ID and [Status] = 'T'  and [Class Plan] like @SMS_MANUALLY_PLANE  ) A
					   
			
		end   
				
     else if @STATUS = 'student'     
				
				select  ROW_NUMBER() over (order by (SELECT 0)) as Sr ,  STDNT_ID as ID, STDNT_LAST_NAME, STDNT_FIRST_NAME  as Name, STDNT_CELL_NO as [Mobile #], 'Student' as [Person], REPLACE(@SMS_MANUALLY_MESSAGE, '^Name^', ( STDNT_FIRST_NAME )) as[Message], 'T' as [Send Status]
				from STUDENT_INFO where STDNT_HD_ID = @SMS_MANUALLY_HD_ID and STDNT_BR_ID = @SMS_MANUALLY_BR_ID  and STDNT_STATUS = 'T' and STDNT_CLASS_PLANE_ID like @SMS_MANUALLY_PLANE 
 
 
      else if @STATUS = 'parent'
     		   select  ROW_NUMBER() over (order by p.ID) as Sr ,  p.ID, [Full Name] as Name, [1st Relation Cell #] as [Mobile #], 'Parent' as [Person], REPLACE(@SMS_MANUALLY_MESSAGE, '^Name^', ([Full Name] )) as[Message], 'T' as [Send Status]
			   from VPARENT_INFO p   join STUDENT_INFO s on s.STDNT_PARANT_ID = p.ID			   
			   where s.STDNT_HD_ID = @SMS_MANUALLY_HD_ID and s.STDNT_BR_ID = @SMS_MANUALLY_BR_ID  and s.STDNT_STATUS = 'T' and s.STDNT_CLASS_PLANE_ID like @SMS_MANUALLY_PLANE
			   
			  
			  
		else if @STATUS = 'staff'
			   select ROW_NUMBER() over (order by ID) as Sr ,  ID, ([First Name] + ' ' + [Last Name]) as Name, [Contact #] as [Mobile #], 'Staff' as [Person], REPLACE(@SMS_MANUALLY_MESSAGE, '^Name^', ( [First Name] + ' ' + [Last Name] )) as[Message], 'T' as [Send Status]
			   from VTEACHER_INFO where [Institute ID] = @SMS_MANUALLY_HD_ID and [Branch ID] = @SMS_MANUALLY_BR_ID   and [Status] = 'T'
				
		
		else if @STATUS = 'student_parent'
		
					   select ROW_NUMBER() over (order by (SELECT 0)) as Sr, * from ( select p.ID, [Full Name] as Name, [1st Relation Cell #] as [Mobile #], 'Parent' as [Person], REPLACE(@SMS_MANUALLY_MESSAGE, '^Name^', ([Full Name] )) as[Message], 'T' as [Send Status]
			   from VPARENT_INFO p   join STUDENT_INFO s on s.STDNT_PARANT_ID = p.ID			   
			   where s.STDNT_HD_ID = @SMS_MANUALLY_HD_ID and s.STDNT_BR_ID = @SMS_MANUALLY_BR_ID  and s.STDNT_STATUS = 'T' and s.STDNT_CLASS_PLANE_ID like @SMS_MANUALLY_PLANE
			   
			  

						union all

						select  ID, ([First Name] + ' ' + [Last Name]) as Name, [Cell #] as [Mobile #], 'Student' as [Person], REPLACE(@SMS_MANUALLY_MESSAGE, '^Name^', ( [First Name] + ' ' + [Last Name] )) as[Message], 'T' as [Send Status]
					   from VSTUDENT_INFO where [Institute ID] = @SMS_MANUALLY_HD_ID and [Branch ID] = @SMS_MANUALLY_BR_ID  and [Status] = 'T'  and [Class Plan] like @SMS_MANUALLY_PLANE ) A
			   
		
		else
		
		select ROW_NUMBER() over (order by (SELECT 0)) as Sr ,  ID, [Full Name] as Name, [1st Relation Cell #] as [Mobile #], 'Parent' as [Person], REPLACE('test', '^Name^', ( [Full Name] )) as[Message], 'T' as [Send Status] 
		from VPARENT_INFO  WHERE [Full Name] =  'IftikharIftikhar' 
		
     END