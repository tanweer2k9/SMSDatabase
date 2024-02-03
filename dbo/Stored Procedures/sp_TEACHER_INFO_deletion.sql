CREATE PROCEDURE  [dbo].[sp_TEACHER_INFO_deletion]
                                               
                                               
          @STATUS char(10),
          @TECH_ID  numeric,
          @TECH_HD_ID  numeric,
          @TECH_BR_ID  numeric
   
   
     AS BEGIN 
    if @STATUS = 'D'
      
     BEGIN
     delete from TEACHER_INFO
      where      
         TECH_ID = @TECH_ID         
      
      delete from USER_INFO
      where USER_CODE = @TECH_ID
       and USER_TYPE = 'Teacher'
      

	  delete from TBL_COA  where COA_ID = (select TECH_COA_ID from TEACHER_INFO where TECH_ID = @TECH_ID)
      END
      
       else
      BEGIN        
     update TEACHER_INFO
     Set     
		TECH_STATUS = 'D'  
     where      
        TECH_ID = @TECH_ID  
        
         update USER_INFO
     Set     
		USER_STATUS = 'D'  
     where      
        USER_CODE = @TECH_ID  
        and USER_TYPE = 'Teacher'
      END


	  update TBL_COA set COA_isDeleted = 1 where COA_ID = (select TECH_COA_ID from TEACHER_INFO where TECH_ID = @TECH_ID)
 
end