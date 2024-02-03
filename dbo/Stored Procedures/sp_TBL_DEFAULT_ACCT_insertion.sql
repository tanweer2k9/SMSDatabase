--     *****************************************************************************************************************************************************************
 
 
--                             Code Type:           Store Procedure For Insertion
--                             Creation Date:       7/11/2014 9:43:35 AM
--                             Auther:              Muhammad Usman Raza Attari
--                             Developed By :       786 Software House 
 
 
--    *****************************************************************************************************************************************************************
 
     CREATE procedure  [dbo].[sp_TBL_DEFAULT_ACCT_insertion]
                                               
                                               
          @CMP_ID nvarchar(50) ,
          @BRC_ID  nvarchar(50),
          @DEFAULT_ACCT_ID  nvarchar(50) ,
          @DEFAULT_ACCT_KEY  nvarchar(50) ,
          @DEFAULT_ACCT_CODE  nvarchar(50) ,
          @DEFAULT_ACCT_MATCH  nvarchar(50) ,
          @DEFAULT_ACCT_isParent  bit,
          @DEFAULT_ACCT_isDeleted  bit
   
   
     as  begin
   
    declare @id int 
   
   --    declare @count int 
   
   --    set @count = 0 
   
   --    set @count = ( select count(DEFAULT_ACCT_ID) from TBL_DEFAULT_ACCT  where   
   --       DEFAULT_ACCT_KEY =  @DEFAULT_ACCT_KEY and 
   --       DEFAULT_ACCT_CODE =  @DEFAULT_ACCT_CODE 
   
   --)  
   
   --  if @count = 0
   
     begin
   
   
   
     set @id = ( select  isnull( (max(cast( DEFAULT_ACCT_ID as int ))),0) + 1 from  TBL_DEFAULT_ACCT 
	
			 where
				 	ISNULL(CMP_ID , '') =  isnull ( @CMP_ID , ISNULL(CMP_ID , '') )  and 
					ISNULL(BRC_ID , '') =  isnull ( @BRC_ID , ISNULL(BRC_ID , '') )  and 
					DEFAULT_ACCT_isDeleted  = ISNULL ( @DEFAULT_ACCT_isDeleted , DEFAULT_ACCT_isDeleted)
	
	 
	 
	 )  
     
   
     insert into TBL_DEFAULT_ACCT
     values
     (
        @CMP_ID,
        @BRC_ID,
        @id,
        @DEFAULT_ACCT_KEY,
        @DEFAULT_ACCT_CODE,
        @DEFAULT_ACCT_MATCH,
        @DEFAULT_ACCT_isParent,
        @DEFAULT_ACCT_isDeleted,
		 LEN(@DEFAULT_ACCT_MATCH)
   
     )
      select 'ok'
     
      end
     
    
     
end