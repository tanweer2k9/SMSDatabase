
CREATE procedure  [dbo].[sp_PARENT_INFO_selection]
                                               
                                               
     @STATUS char(10),
     @PARNT_ID  numeric,
     @PARNT_HD_ID  numeric,
     @PARNT_BR_ID  numeric
   
   
  AS BEGIN 
   if @STATUS = 'L'
    BEGIN
    SELECT * FROM VPARENT_INFO
    where 
    --[Institute ID] = @PARNT_HD_ID            and
     [Branch ID] in (select COMBINE_BRANCHES_ID from COMBINE_BRANCHES where FROM_BRANCH_ID = @PARNT_BR_ID)
    and [Status] !='D'
	
	
	select LANG_ID as Code,LANG_NAME as Name from LANG_INFO
	where LANG_STATUS = 'T'
		and LANG_HD_ID = @PARNT_HD_ID and LANG_BR_ID = @PARNT_BR_ID

	
	select RELIGION_ID as Code,RELIGION_NAME as Name from RELIGION_INFO
	where RELIGION_STATUS = 'T'
		and RELIGION_HD_ID = @PARNT_HD_ID and RELIGION_BR_ID = @PARNT_BR_ID

	
	select NATIONALITY_ID as Code,NATIONALITY_NAME as Name from NATIONALITY_INFO
	where NATIONALITY_STATUS = 'T'
		and NATIONALITY_HD_ID = @PARNT_HD_ID and NATIONALITY_BR_ID = @PARNT_BR_ID


	select USER_CODE as ID , USER_STATUS  as [Status] from USER_INFO
	where USER_TYPE = 'Parent' 
	and USER_STATUS != 'D'
	and USER_HD_ID = @PARNT_HD_ID and USER_BR_ID in ( select * from [dbo].[get_centralized_br_id]('P', @PARNT_BR_ID)) 

	select ID,Name from VPEOPLE_RELATIONS_INFO
	
	where [Institute ID] = @PARNT_HD_ID            
    and  [Branch ID] = @PARNT_BR_ID
    and [Status] !='D'


	select ID,Name from VAREA_INFO
	
	where [Institute ID] = @PARNT_HD_ID            
    and  [Branch ID] = @PARNT_BR_ID
    and [Status] !='D'

		select ID,Name from VCITY_INFO
	
	where [Institute ID] = @PARNT_HD_ID            
    and  [Branch ID] = @PARNT_BR_ID
    and [Status] !='D'

		
	
	END
    
   
     ELSE if @STATUS = 'B'
     BEGIN
	SELECT * FROM VPARENT_INFO
 
          where  ID = @PARNT_ID   
		and  [Status] != 'D'
   
   
	select USER_STATUS as [Login Status]  from USER_INFO
	where USER_CODE = @PARNT_ID and
		 USER_TYPE = 'Parent'
		 and USER_HD_ID = @PARNT_HD_ID and USER_BR_ID = @PARNT_BR_ID
		END
    
    
    
    Else if @STATUS = 'A'
     BEGIN
  SELECT * FROM VPARENT_INFO
     WHERE        
     [Institute ID] =  @PARNT_HD_ID and 
     [Branch ID] in ( select * from [dbo].[get_centralized_br_id]('P', @PARNT_BR_ID))  
 
     END
 
  END