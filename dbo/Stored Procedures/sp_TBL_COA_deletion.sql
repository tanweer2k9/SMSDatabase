CREATE PROCEDURE  [dbo].[sp_TBL_COA_deletion]
                                               
                                               
          @STATUS nvarchar(10),
          @CMP_ID nvarchar(50),	
		  @BRC_ID nvarchar(50),										   
          @COA_UID  nvarchar(50),
		  @COA_isDeleted bit,
		  @COA_ID numeric
		  --@COA_isDeletionAllowed bit
         
   
   
     AS BEGIN 
   
     
	 if @STATUS = 'Student'
	 begin
	
		set @COA_ID = (select STDNT_COA_ID from STUDENT_INFO where STDNT_ID = @COA_ID)
	 update TBL_COA
	
			set COA_isDeleted = 1
     where
		    COA_ID = @COA_ID
	end
	else if @STATUS = 'Staff'
	 begin
	
		set @COA_ID = (select TECH_COA_ID from TEACHER_INFO where TECH_ID = @COA_ID)

	 update TBL_COA	
		set COA_isDeleted = 1
     where	 
		COA_ID = @COA_ID
	end
	else
	begin

     update TBL_COA
	
			set COA_isDeleted = 1
     where
		    COA_UID =  @COA_UID  and
			isnull(CMP_ID , '') =ISNULL( @CMP_ID,ISNULL(CMP_ID,'')) and
			isnull(BRC_ID , '') =ISNULL( @BRC_ID,ISNULL(BRC_ID,''))
	end
	  
   
end