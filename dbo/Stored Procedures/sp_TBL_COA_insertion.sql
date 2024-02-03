CREATE procedure  [dbo].[sp_TBL_COA_insertion]
                                               
                                               
          @CMP_ID  nvarchar(50),
		  @BRC_ID  nvarchar(50),
          @COA_PARENTID  nvarchar(50) ,
          @COA_UID  nvarchar(50) ,
          @COA_prefix  nvarchar(50) ,
          @COA_levelID  int,
          @COA_definationPlanID  int,
          @COA_Name  nvarchar(200) ,
          @COA_type  int,
          @COA_isActive  bit,
          @COA_description  nvarchar(200) ,
          @COA_Inventory  BIT ,
          @COA_levelNo  int,
		  @COA_IsTransaction BIT,
		  @COA_nature nvarchar(50),
		  @COA_IsDeleted bit,
		  @COA_isDeletionAllowed bit,
		  @STATUS nvarchar(50)
   
     as  begin
   

 --  delete from  TBL_COA 
	--where  
	--	 COA_UID = @COA_UID AND 
	--	 isnull(CMP_ID , '') =ISNULL( @CMP_ID,ISNULL(CMP_ID,'')) and
	--	 isnull(BRC_ID , '') =ISNULL( @BRC_ID,ISNULL(BRC_ID,'')) and 
 --		 COA_isDeleted = isnull(@COA_IsDeleted,COA_isDeleted)		
 		 
 		 if @STATUS = 'I'
		 begin
 			 declare @value nvarchar(50) 
 			 declare @id nvarchar(50)
 		 
 			  set @id = (select  (isnull(MAX( TBL_COA.COA_UID),@COA_PARENTID)) from TBL_COA
			
				where 
				COA_PARENTID =@COA_PARENTID  and 
				isnull(CMP_ID , '') =ISNULL( @CMP_ID,ISNULL(CMP_ID,'')) and
				isnull(BRC_ID , '') =ISNULL( @BRC_ID,ISNULL(BRC_ID,'')) 
				)

		
				declare @level nvarchar(50) =  ''
	 			declare @lenght_seprator int = (select LEN(TBL_ACC_PLAN_MAIN_leveSeperator) from TBL_ACC_PLAN where CMP_ID = @CMP_ID and BRC_ID = @BRC_ID)	
				select @level = RIGHT(LEFT(@id, (select SUM(LEN(TBL_ACC_PLAN_DEF_format)) + COUNT(*) * (@lenght_seprator) - @lenght_seprator from TBL_ACC_PLAN_DEF where CMP_ID = @CMP_ID and BRC_ID = @BRC_ID and TBL_ACC_PLAN_DEF_levelNo <= @COA_levelNo)),(select LEN(TBL_ACC_PLAN_DEF_format) from TBL_ACC_PLAN_DEF where CMP_ID = @CMP_ID and BRC_ID = @BRC_ID and TBL_ACC_PLAN_DEF_levelNo = @COA_levelNo))
		
				
 				 declare @max int  =  CAST((@level)as int)+1
				 declare @max_length int = len(@level) - LEN(@max)
 
				 declare @zeros nvarchar(50) = ''
				 declare @i int = 1 
				 while @i <= @max_length
					 begin
     					set @zeros = @zeros + '0'
    					set @i = @i + 1   
					 end
				set @COA_UID = dbo.COA_LEVEL_REPLACE(@COA_PARENTID,'-',@COA_levelNo,(@zeros + CAST((@max)as nvarchar)))
				
				set @COA_levelID = @max

				--if @COA_levelNo != 3
				--set @COA_levelID = @max
			end

		--if(@COA_levelNo = 4 and @STATUS = 'I')
 	--	 begin
 	--		 declare @level nvarchar(50) =  RIGHT(@id,5)
 		 
 	--		 declare @max int  =  CAST((@level)as int)+1
		--	 declare @max_length int = len(@max)
 
		--	 declare @zeros nvarchar(50) = ''
		--	 declare @i int = 1 
		--	 while @i <= (5- @max_length)
		--		 begin
  --   				set @zeros = @zeros + '0'
  --  				set @i = @i + 1   
		--		 end
		--	set @COA_UID = dbo.COA_LEVEL_REPLACE(@COA_PARENTID,'-',@COA_levelNo,(@zeros + CAST((@max)as nvarchar)))

		--end

		--else if (@COA_levelNo = 3 and @STATUS = 'I')
		--begin
		--	set @level  =  RIGHT(@id,8)
 	--		declare @level2 nvarchar (50) = left(@level,2)
 	--		set  @max   =  CAST((@level2)as int)+1
		--	set  @max_length = len(@max) 
		--	set  @zeros  = ''
		--	set @i  = 1	
		--	while @i <= (2- @max_length)
		--	begin
  --   			set @zeros = @zeros + '0'
  --  			set @i = @i + 1
		--	end  
		--	set @COA_UID = dbo.COA_LEVEL_REPLACE(@COA_PARENTID,'-',@COA_levelNo,(@zeros + CAST((@max)as nvarchar)))	
		--end

   
     insert into TBL_COA
     values
     (
        @CMP_ID,
		@BRC_ID,
        @COA_PARENTID,
        @COA_UID,
        @COA_prefix,
        @COA_levelID,
        @COA_definationPlanID,
        @COA_Name,
        @COA_type,
        @COA_isActive,
        @COA_description,
        @COA_Inventory,
        @COA_levelNo,
		@COA_IsTransaction,
		@COA_nature,
		@COA_IsDeleted,
		@COA_isDeletionAllowed
     )
     select 'ok',@COA_UID, SCOPE_IDENTITY()
end