
 CREATE procedure  [dbo].[sp_EXTRA_HOLIDAYS_PARENT_insertion]
                                               
          @ID numeric,                              
          @HD_ID  numeric,
          @BR_ID  numeric,
          @FROM_DATE  date,
          @TO_DATE  date,
          @DESCRIPTION_STATUS  nvarchar(500) ,
          @DAY_TYPE  nvarchar(50) ,
          @IS_SALARY_GENERATED  bit,
          @CREATED_BY  nvarchar(50) ,
          @CREATED_DATE  datetime,
          @UPDATED_BY  nvarchar(50) ,
          @UPDATED_DATE  datetime
   
   
     as  begin
   
   

   if @ID = 0
   BEGIN
     insert into EXTRA_HOLIDAYS_PARENT
     values
     (
        @HD_ID,
        @BR_ID,
        @FROM_DATE,
        @TO_DATE,
        @DESCRIPTION_STATUS,
        @DAY_TYPE,
        @IS_SALARY_GENERATED,
        @CREATED_BY,
        @CREATED_DATE,
        @UPDATED_BY,
        @UPDATED_DATE
     )
	 set @ID = SCOPE_IDENTITY()
	 END
	 ELSE
	 BEGIN
		 update EXTRA_HOLIDAYS_PARENT
 
		 set
			  FROM_DATE =  @FROM_DATE,
			  TO_DATE =  @TO_DATE,
			  DESCRIPTION_STATUS =  @DESCRIPTION_STATUS,
			  DAY_TYPE =  @DAY_TYPE,
			  IS_SALARY_GENERATED =  @IS_SALARY_GENERATED,
			  CREATED_BY =  @CREATED_BY,
			  CREATED_DATE =  @CREATED_DATE,
			  UPDATED_BY =  @UPDATED_BY,
			  UPDATED_DATE =  @UPDATED_DATE
 
		 where 
          ID =  @ID
	 END

	 select @ID 

	 END