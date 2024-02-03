
CREATE procedure  [dbo].[sp_STUDENT_INFO_updation]                                               
          @STDNT_ID  numeric,
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
          @STDNT_STATUS  char(2),
          @STDNT_CLASS_FEE_ID numeric,
          @USER_STATUS char(2),
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
		  @IS_FEE_PLAN_TEMPLATE_CHANGE bit,
		  @STDNT_SCHOLARSHIP_ID numeric,
		  @STDNT_LAB_TYPE nvarchar(50),
		  @STDNT_IS_REJOIN bit
     as begin 
   
 --if(@STDNT_IMG = ( SELECT PATH_STD_IMG FROM PATH_INFO WHERE PATH_STATUS = 'T' ))
 --   begin    
	--	set @STDNT_IMG = ( SELECT STDNT_IMG FROM STUDENT_INFO WHERE STDNT_ID = @STDNT_ID)
 --   end    
    
 --else
    
  
		set @STDNT_IMG = ( ( SELECT PATH_STD_IMG FROM PATH_INFO WHERE PATH_STATUS = 'T' ) + ( CONVERT(nvarchar, @STDNT_ID) ) + '.png' )

      
	  set @STDNT_CLASS_FEE_ID = (select STDNT_CLASS_FEE_ID from STUDENT_INFO where STDNT_ID = @STDNT_ID)

	  
	  
	  

	--  	 if @IS_FEE_PLAN_TEMPLATE_CHANGE = 1
	--	 BEGIN

	--		 update PLAN_FEE_DEF set PLAN_FEE_DEF_STATUS = 'D' where PLAN_FEE_DEF_PLAN_ID = @STDNT_CLASS_FEE_ID

	--		 insert into PLAN_FEE_DEF 
	--		 	  select @STDNT_CLASS_FEE_ID,fee_id,fee_amount,Fee_min,Fee_max,[Status],Operation, 
	--			  CASE WHEN pd.PLAN_FEE_IS_ONCE_PAID is null THEN 
	--			  CASE WHEN A.[Fee Type] like '%Once%' THEN 'F' ELSE (select 'N') END
	--			  ELSE pd.PLAN_FEE_IS_ONCE_PAID END as is_once_paid
	--			  from
	--			  (select @STDNT_CLASS_FEE_ID pid, d.DIS_RUL_DEF_FEE_ID fee_id,f.[Fee Type],d.DIS_RUL_DEF_DISCOUNT fee_amount,0 Fee_min,0 Fee_max,'T' [Status],ISNULL(Operation,'T') Operation
	--			  from VFEE_INFO f
	--			   join DISCOUNT_RULES_DEF d on d.DIS_RUL_DEF_FEE_ID = f.ID
	--				where Status = 'T'	 and d.DIS_RUL_DEF_PID = @STDNT_DISCOUNT_RULE_ID
	--				and [Institute ID] = @STDNT_HD_ID and [Branch ID] = @STDNT_BR_ID 
	--				)A		
	--				left join 
	--				(select * from PLAN_FEE_DEF	where PLAN_FEE_DEF_PLAN_ID = @STDNT_CLASS_FEE_ID)pd
	--				on pd.PLAN_FEE_DEF_FEE_NAME = A.fee_id

	--				delete from PLAN_FEE_DEF where PLAN_FEE_DEF_PLAN_ID = @STDNT_CLASS_FEE_ID and PLAN_FEE_DEF_STATUS = 'D'
	--		 --select @STDNT_CLASS_FEE_ID, d.DIS_RUL_DEF_FEE_ID,d.DIS_RUL_DEF_DISCOUNT,0,0,'T',ISNULL(Operation,'T'), isnull(fd.PLAN_FEE_IS_ONCE_PAID,'F')
	--		 --from VFEE_INFO f
	--		 --join DISCOUNT_RULES_DEF d on d.DIS_RUL_DEF_FEE_ID = f.ID		 
	--		 --left join PLAN_FEE_DEF fd on fd.PLAN_FEE_DEF_FEE_NAME = f.ID
	--		 --where Status = 'T'	 and d.DIS_RUL_DEF_PID = @STDNT_DISCOUNT_RULE_ID
	--	  --   and [Institute ID] = @STDNT_HD_ID and [Branch ID] = @STDNT_BR_ID and fd.PLAN_FEE_DEF_PLAN_ID = @STDNT_CLASS_FEE_ID	
	--	END
	----ELSE
	----	BEGIN
			
	----		insert into PLAN_FEE_DEF select @STDNT_CLASS_FEE_ID, ID,0,0,0,'T',ISNULL(Operation,'T'),CASE WHEN [Fee Type] = 'Once' THEN 'F' ELSE 'N' END from VFEE_INFO				where Status = 'T'	
			
	----	END

		


	--	if @IS_FEE_PLAN_TEMPLATE_CHANGE = 1
	--	BEGIN
	--		update STUDENT_INFO set STDNT_DISCOUNT_RULE_ID = @STDNT_DISCOUNT_RULE_ID where stdnt_id = @STDNT_ID
	--	END

     update STUDENT_INFO
 
     set         
          STDNT_HD_ID =  @STDNT_HD_ID,
          STDNT_BR_ID =  @STDNT_BR_ID,
          STDNT_PARANT_ID =  @STDNT_PARANT_ID,
          STDNT_CLASS_PLANE_ID =  @STDNT_CLASS_PLANE_ID,
          --STDNT_CLASS_FEE_ID = @STDNT_CLASS_FEE_ID,
          STDNT_REG_BY_ID =  @STDNT_REG_BY_ID,
          STDNT_REG_BY_TYPE =  @STDNT_REG_BY_TYPE,
          STDNT_FIRST_NAME =  @STDNT_FIRST_NAME,
          STDNT_LAST_NAME =  @STDNT_LAST_NAME,
          STDNT_GENDER =  @STDNT_GENDER,
          STDNT_NATIONALITY =  @STDNT_NATIONALITY,
          STDNT_RELIGION =  @STDNT_RELIGION,
          STDNT_DOB =  @STDNT_DOB,
          STDNT_PREVIOUS_SCHOOL =  @STDNT_PREVIOUS_SCHOOL,
          STDNT_MOTHR_LANG =  @STDNT_MOTHR_LANG,
          STDNT_EMAIL =  @STDNT_EMAIL,
          STDNT_IMG =  @STDNT_IMG,
          STDNT_EMERGENCY_CNTCT_NAME =  @STDNT_EMERGENCY_CNTCT_NAME,
          STDNT_EMERGENCY_CNTCT_NO =  @STDNT_EMERGENCY_CNTCT_NO,
          STDNT_CELL_NO =  @STDNT_CELL_NO,
          STDNT_TEMP_ADDR =  @STDNT_TEMP_ADDR,
          STDNT_PERM_ADDR =  @STDNT_PERM_ADDR,
          STDNT_TRANSPORT_MODE =  @STDNT_TRANSPORT_MODE,
          STDNT_REG_DATE =  @STDNT_REG_DATE,
          STDNT_STATUS =  @STDNT_STATUS,
		  STDNT_SCHOOL_ID	=	@CLASS_SCHOOL_ID,
          STDNT_REGISTRATION_ID  =  @CLASS_REGISTRATION_ID,
		  STDNT_SESSION_ID = @STDNT_SESSION_ID,
		  STDNT_DESCRIPTION = @STDNT_DESCRIPTION ,
		  --STDNT_DISCOUNT_RULE_ID = @STDNT_DISCOUNT_RULE_ID,
		  STDNT_HOUSE_ID = @STDNT_HOUSE_ID,
		  STDNT_DATE_OF_LEAVING = @STDNT_DATE_OF_LEAVING ,
		  STDNT_WITH_DRAW_NO = @STDNT_WITH_DRAW_NO	,
		  STDNT_CATEGORY = @STDNT_CATEGORY	,
		  STDNT_CONDUCT_ID = @STDNT_CONDUCT_ID,
		  STDNT_REMARKS = @STDNT_REMARKS,
		  STDNT_COA_ID = @STDNT_COA_ID,
		  STDNT_CITY_ID = @STDNT_CITY_ID,
		  STDNT_AREA_ID = @STDNT_AREA_ID,
		  STDNT_SCHOLARSHIP_ID = @STDNT_SCHOLARSHIP_ID,
		  STDNT_LAB_TYPE = @STDNT_LAB_TYPE,
		  STDNT_IS_REJOIN = @STDNT_IS_REJOIN


          where   STDNT_ID =  @STDNT_ID
                    
          Declare @roll numeric
          
          update USER_INFO 
     set         
          USER_DISPLAY_NAME =  @STDNT_FIRST_NAME,         
          USER_STATUS =  @USER_STATUS
  
     where 
          [USER_CODE] =  @STDNT_ID and
          --[USER_HD_ID] = @STDNT_HD_ID and
          --[USER_BR_ID] = @STDNT_BR_ID and
          USER_TYPE = 'Student'
        	
				SET @roll =( select  ISNULL( max(STUDENT_ROLL_NUM_ROLL_NO),0)+1 from  STUDENT_ROLL_NUM				 
				 where STUDENT_ROLL_NUM_HD_ID = @STDNT_HD_ID
				 and STUDENT_ROLL_NUM_BR_ID = @STDNT_BR_ID
				 and STUDENT_ROLL_NUM_PLAN_ID = @STDNT_CLASS_PLANE_ID
				 and STUDENT_ROLL_NUM_STATUS = 'T'
				 and STUDENT_ROLL_NUM_ACTIVE_STATUS in ('new','old')
			)
			
			
		if @STDNT_STATUS = 'T'
			begin
				update STUDENT_ROLL_NUM 
				set
				STUDENT_ROLL_NUM_FEE_ID = @STDNT_CLASS_FEE_ID,
				STUDENT_ROLL_NUM_PLAN_ID = @STDNT_CLASS_PLANE_ID,
				STUDENT_ROLL_NUM_STATUS = @STDNT_STATUS,
				STUDENT_ROLL_NUM_ROLL_NO = @roll,
				STUDENT_ROLL_NUM_ACTIVE_STATUS = 'new'
				where
				STUDENT_ROLL_NUM_HD_ID = @STDNT_HD_ID
				and STUDENT_ROLL_NUM_BR_ID = @STDNT_BR_ID
				and STUDENT_ROLL_NUM_STD_ID = @STDNT_ID			
			end
		else
			begin
				update STUDENT_ROLL_NUM 
				set
				STUDENT_ROLL_NUM_FEE_ID = @STDNT_CLASS_FEE_ID,
				STUDENT_ROLL_NUM_PLAN_ID = @STDNT_CLASS_PLANE_ID,
				STUDENT_ROLL_NUM_STATUS = @STDNT_STATUS,
				STUDENT_ROLL_NUM_ROLL_NO = @roll,
				STUDENT_ROLL_NUM_ACTIVE_STATUS = ''
				where
				STUDENT_ROLL_NUM_HD_ID = @STDNT_HD_ID
				and STUDENT_ROLL_NUM_BR_ID = @STDNT_BR_ID
				and STUDENT_ROLL_NUM_STD_ID = @STDNT_ID
			end
			
end