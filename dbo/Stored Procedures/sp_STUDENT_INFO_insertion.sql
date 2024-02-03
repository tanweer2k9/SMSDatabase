


CREATE procedure  [dbo].[sp_STUDENT_INFO_insertion]                                                                                              
          @STDNT_HD_ID  numeric,
          @STDNT_BR_ID  numeric,
          @STDNT_PARANT_ID  numeric,
          @STDNT_CLASS_PLANE_ID  numeric,
          @STDNT_REG_BY_ID  numeric,
          @STDNT_REG_BY_TYPE  nvarchar(50) ,
          @STDNT_FIRST_NAME  nvarchar(50) ,
          @STDNT_LAST_NAME  nvarchar(50) ,
          @STDNT_GENDER  bit,
          @STDNT_NATIONALITY  nvarchar(50) ,
          @STDNT_RELIGION  nvarchar(50) ,
          @STDNT_DOB  datetime,
          @STDNT_PREVIOUS_SCHOOL  nvarchar(50) ,
          @STDNT_MOTHR_LANG  nvarchar(50) ,
          @STDNT_EMAIL  nvarchar(50) ,
          @STDNT_IMG  nvarchar(max) ,
          @STDNT_EMERGENCY_CNTCT_NAME  nvarchar(50) ,
          @STDNT_EMERGENCY_CNTCT_NO  nvarchar(20) ,
          @STDNT_CELL_NO  nvarchar(20) ,
          @STDNT_TEMP_ADDR  nvarchar(max) ,
          @STDNT_PERM_ADDR  nvarchar(max) ,
          @STDNT_TRANSPORT_MODE  nvarchar(50) ,
          @STDNT_REG_DATE  date,
          @STDNT_DATE date,
          @STDNT_STATUS  char(2),
          @STDNT_CLASS_FEE_ID numeric,
          @CLASS_SCHOOL_ID NVARCHAR(50),
          @CLASS_REGISTRATION_ID NVARCHAR(50),
		  @STDNT_SESSION_ID numeric,
		  @STDNT_DESCRIPTION nvarchar(4000),
		  @STDNT_DISCOUNT_RULE_ID numeric,
		  @STDNT_HOUSE_ID numeric,
		  @STDNT_DATE_OF_LEAVING date,
		  @STDNT_WITH_DRAW_NO	nvarchar(200),
		  @STDNT_CATEGORY	nvarchar(50),
		  @STDNT_CONDUCT_ID	numeric,
		  @STDNT_REMARKS	nvarchar(2000),
		  @STDNT_COA_ID numeric,
		  @STDNT_CITY_ID numeric,
		  @STDNT_AREA_ID numeric,
		  @STDNT_SCHOLARSHIP_ID numeric,
		  @STDNT_LAB_TYPE nvarchar(50),
		  @STDNT_IS_REJOIN bit,
          @USER_NAME nvarchar(50),
          @USER_PASSWORD nvarchar(50),
          @USER_STATUS char(2)      
     as  begin
	 declare @user_id numeric
     Declare @id nvarchar(50)    
     Declare @roll numeric
     Declare @fee_max numeric         
      

	 -- if @STDNT_CLASS_FEE_ID != 0
	 -- begin
		--		---- dplicate fee plan insertion ------
     
		-- insert into PLAN_FEE
		-- select PLAN_FEE_HD_ID,PLAN_FEE_BR_ID,PLAN_FEE_NAME,PLAN_FEE_TOTAL_FEE,PLAN_FEE_STATUS from PLAN_FEE 
		-- where PLAN_FEE_ID = @STDNT_CLASS_FEE_ID
     
		----set @fee_max = ( select MAX(PLAN_FEE_ID) from PLAN_FEE where PLAN_FEE_HD_ID = @STDNT_HD_ID and PLAN_FEE_BR_ID = @STDNT_BR_ID )	
		-- set @fee_max = (select SCOPE_IDENTITY())
	
		--		---- dplicate fee plan def insertion ------
          
		-- insert into PLAN_FEE_DEF
		-- select @fee_max,PLAN_FEE_DEF_FEE_NAME,PLAN_FEE_DEF_FEE,PLAN_FEE_DEF_FEE_MIN,PLAN_FEE_DEF_FEE_MAX,PLAN_FEE_DEF_STATUS,PLAN_FEE_OPERATION from PLAN_FEE_DEF
		-- where PLAN_FEE_DEF_PLAN_ID = @STDNT_CLASS_FEE_ID and PLAN_FEE_DEF_STATUS = 'T'
  --   end
	 --else
	 --begin

	 --This will always be zero because Now Fees will be insert in Fee Plan
	 set @STDNT_DISCOUNT_RULE_ID = 0

	 if @STDNT_DISCOUNT_RULE_ID > 0
		 BEGIN
			insert into PLAN_FEE select @STDNT_HD_ID, @STDNT_BR_ID, @STDNT_FIRST_NAME, 0,'T',1.2,1,1,'',1
			set @fee_max = (select SCOPE_IDENTITY())
		
			insert into PLAN_FEE_DEF 
			select @fee_max, d.DIS_RUL_DEF_FEE_ID,d.DIS_RUL_DEF_DISCOUNT,0,0,'T',ISNULL(Operation,'T'), CASE WHEN [Fee Type] like '%Once%' THEN 'F' ELSE 'N' END 
			 from VFEE_INFO f
			 join DISCOUNT_RULES_DEF d on d.DIS_RUL_DEF_FEE_ID = f.ID		 
			 where Status = 'T'	 and d.DIS_RUL_DEF_PID = @STDNT_DISCOUNT_RULE_ID
			and [Institute ID] = @STDNT_HD_ID and [Branch ID] = @STDNT_BR_ID
		END
	ELSE
		BEGIN
			insert into PLAN_FEE select @STDNT_HD_ID, @STDNT_BR_ID, @STDNT_FIRST_NAME, 0,'T',1.2,1,1,'',1
			set @fee_max = (select SCOPE_IDENTITY())
			insert into PLAN_FEE_DEF select @fee_max, ID,0,0,0,'T',ISNULL(Operation,'T'),CASE WHEN [Fee Type] like '%Once%' THEN 'F' ELSE 'N' END from VFEE_INFO	where Status = 'T'	and [Branch ID] = @STDNT_BR_ID 
			set @STDNT_CLASS_FEE_ID = @fee_max
		END
		
		
		set @STDNT_CLASS_FEE_ID = @fee_max
	 --end	 
  --   set @STDNT_CLASS_FEE_ID = @fee_max         

   
    insert into STUDENT_INFO
     values
     (      
        @STDNT_HD_ID,
        @STDNT_BR_ID,
        @STDNT_PARANT_ID,
        @STDNT_CLASS_PLANE_ID,
        @STDNT_CLASS_FEE_ID,
        @STDNT_REG_BY_ID,
        @STDNT_REG_BY_TYPE,
        @STDNT_FIRST_NAME,
        @STDNT_LAST_NAME,
        @STDNT_GENDER,
        @STDNT_NATIONALITY,
        @STDNT_RELIGION,
        @STDNT_DOB,
        @STDNT_PREVIOUS_SCHOOL,
        @STDNT_MOTHR_LANG,
        @STDNT_EMAIL,
        @STDNT_IMG,
        @STDNT_EMERGENCY_CNTCT_NAME,
        @STDNT_EMERGENCY_CNTCT_NO,
        @STDNT_CELL_NO,
        @STDNT_TEMP_ADDR,
        @STDNT_PERM_ADDR,
        @STDNT_TRANSPORT_MODE,
        @STDNT_REG_DATE,
        @STDNT_DATE,
        @STDNT_STATUS,
        @CLASS_SCHOOL_ID,
        @CLASS_REGISTRATION_ID,
		@STDNT_SESSION_ID,
		@STDNT_DESCRIPTION ,
		@STDNT_DISCOUNT_RULE_ID ,
		@STDNT_HOUSE_ID ,
		@STDNT_DATE_OF_LEAVING ,
		@STDNT_WITH_DRAW_NO	,
		@STDNT_CATEGORY	,
		@STDNT_CONDUCT_ID,
		@STDNT_REMARKS,
		@STDNT_COA_ID,		
		@STDNT_CITY_ID,
		@STDNT_AREA_ID,
		@STDNT_SCHOLARSHIP_ID,
		@STDNT_LAB_TYPE,
		@STDNT_IS_REJOIN
     )     
       

	  --set @id = ( select  isnull( max(STDNT_ID),0 ) + 1 from  STUDENT_INFO )				
	  set @id = SCOPE_IDENTITY()				
	 set @STDNT_IMG = ( ( SELECT PATH_STD_IMG FROM PATH_INFO WHERE PATH_STATUS = 'T' ) + @id + '.png' )
		--set @user_id = (select isnull (MAX(USER_ID),1) from USER_INFO)
	update STUDENT_INFO set STDNT_IMG = @STDNT_IMG where STDNT_ID = @id
		
    insert into USER_INFO
     values
     (
      @STDNT_HD_ID,
      @STDNT_BR_ID,
      @id,
      @USER_NAME, --+ CONVERT(nvarchar(15), @user_id +1),
      @STDNT_FIRST_NAME,
      'Student',
      @USER_PASSWORD,
      @USER_STATUS,
      NULL      
     )

	 set @user_id = SCOPE_IDENTITY()
	 update USER_INFO set USER_NAME = @USER_NAME + CONVERT(nvarchar(15), @user_id) where USER_ID = @user_id

	SET @roll =( select  ISNULL( max(STUDENT_ROLL_NUM_ROLL_NO),0)+1 from  STUDENT_ROLL_NUM				 
				 where STUDENT_ROLL_NUM_HD_ID = @STDNT_HD_ID
				 and STUDENT_ROLL_NUM_BR_ID = @STDNT_BR_ID
				 and STUDENT_ROLL_NUM_PLAN_ID = @STDNT_CLASS_PLANE_ID
				 and STUDENT_ROLL_NUM_STATUS = 'T'				 
				 and STUDENT_ROLL_NUM_ACTIVE_STATUS in ('new','old')
				)


	if @STDNT_STATUS = 'T'
	begin
			insert into STUDENT_ROLL_NUM
			Values
			(
				@STDNT_HD_ID,
				@STDNT_BR_ID,
				@id,
				@STDNT_CLASS_PLANE_ID,
				@STDNT_CLASS_FEE_ID,
				@roll,
				@STDNT_STATUS,
				'new',
				getdate()
			)     
   
	end
	
	else
		begin
			insert into STUDENT_ROLL_NUM
		Values
		(
			@STDNT_HD_ID,
			@STDNT_BR_ID,
			@id,
			@STDNT_CLASS_PLANE_ID,
			@STDNT_CLASS_FEE_ID,
			@roll,
			@STDNT_STATUS,
			'',
			getdate()
		)     
   
	end
	
	  select @id  as 'ID',@STDNT_IMG as [Path],'ok' [Insert],@USER_NAME + CONVERT(nvarchar(15), @user_id +1) as [Login Name],@USER_PASSWORD as [Password],@roll as [Roll No]
    
end