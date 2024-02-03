--     *****************************************************************************************************************************************************************
 
 
--                             Code Type:           Store Procedure For selection
--                             Creation Date:       7/11/2014 9:43:35 AM
--                             Auther:              Muhammad Usman Raza Attari
--                             Developed By :       786 Software House 
 
 
--    *****************************************************************************************************************************************************************
 
     CREATE procedure  [dbo].[sp_TBL_DEFAULT_ACCT_selection]
                                               
                                               
     @STATUS nvarchar(10),
     @CMP_ID  nvarchar(50),
     @BRC_ID  nvarchar(50),
     @DEFAULT_ACCT_ID  int,
     @DEFAULT_ACCT_KEY  nvarchar(50) ,
     @DEFAULT_ACCT_isDeleted  bit
   
   
     AS BEGIN 
   
   
     if @STATUS = 'A'
     BEGIN
   
     SELECT 
	 TBL_DEFAULT_ACCT.DEFAULT_ACCT_KEY,
	 TBL_DEFAULT_ACCT.DEFAULT_ACCT_CODE,
	 TBL_DEFAULT_ACCT.DEFAULT_ACCT_MATCH, 
	 TBL_DEFAULT_ACCT.DEFAULT_ACCT_ID , 
	 TBL_DEFAULT_ACCT.DEFAULT_ACCT_isParent 
		FROM 
			TBL_DEFAULT_ACCT
				where
	 				ISNULL(CMP_ID , '') =  isnull ( @CMP_ID , ISNULL(CMP_ID , '') )  and 
					ISNULL(BRC_ID , '') =  isnull ( @BRC_ID , ISNULL(BRC_ID , '') )  and 
					DEFAULT_ACCT_isDeleted = ISNULL ( @DEFAULT_ACCT_isDeleted , DEFAULT_ACCT_isDeleted)
	


     END  
     ELSE  if @STATUS = 'V'
     BEGIN 
  
  SELECT 
  TBL_DEFAULT_ACCT.DEFAULT_ACCT_ID,
  TBL_DEFAULT_ACCT.DEFAULT_ACCT_KEY,
  TBL_DEFAULT_ACCT.DEFAULT_ACCT_CODE,
  TBL_DEFAULT_ACCT.DEFAULT_ACCT_MATCH, 
  TBL_DEFAULT_ACCT.DEFAULT_ACCT_ID , 
  TBL_DEFAULT_ACCT.DEFAULT_ACCT_isParent 
		FROM 
			TBL_DEFAULT_ACCT
				WHERE
					ISNULL(CMP_ID , '') =  isnull ( @CMP_ID , ISNULL(CMP_ID , '') )  and 
					ISNULL(BRC_ID , '') =  isnull ( @BRC_ID , ISNULL(BRC_ID , '') )  and	
					DEFAULT_ACCT_isDeleted = ISNULL ( @DEFAULT_ACCT_isDeleted , DEFAULT_ACCT_isDeleted)--and
					--DEFAULT_ACCT_KEY = @DEFAULT_ACCT_KEY
	END
     
     
     --ELSE  if @STATUS = 'C'
     --BEGIN 
     
     --declare @a nvarchar(20) = '01-01' 
     --declare @lvl int = len(@a)
     
     --select @lvl
   
     --select DEFAULT_ACCT_CODE from TBL_DEFAULT_ACCT	where DEFAULT_ACCT_CODE like @a + '%'
     --End
     
 
END