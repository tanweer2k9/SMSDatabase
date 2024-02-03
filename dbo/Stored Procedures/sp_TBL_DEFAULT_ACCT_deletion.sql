CREATE PROCEDURE  [dbo].[sp_TBL_DEFAULT_ACCT_deletion]
          @STATUS nvarchar(200),
          @CMP_ID  nvarchar(50),
          @BRC_ID  nvarchar(50),
          --@DEFAULT_ACCT_ID  int,
          @DEFAULT_ACCT_KEY  nvarchar(60)-- ,
          --@DEFAULT_ACCT_isDeleted  bit  
              
     AS BEGIN 
     
     if @STATUS = 'D'
     Begin
		
		delete from TBL_DEFAULT_ACCT		
		where 
					ISNULL(CMP_ID , '') =  isnull ( @CMP_ID , ISNULL(CMP_ID , '') )  and 
					ISNULL(BRC_ID , '') =  isnull ( @BRC_ID , ISNULL(BRC_ID , '') )  and 
					--DEFAULT_ACCT_isDeleted = 1 and 
				--DEFAULT_ACCT_isDeleted = ISNULL ( @DEFAULT_ACCT_isDeleted , DEFAULT_ACCT_isDeleted) and 
				    DEFAULT_ACCT_KEY = @DEFAULT_ACCT_KEY
     End
     
     ELSE
     BEGIN
		
		delete from TBL_DEFAULT_ACCT		
				
     END
     
     
	

		select 'ok'
		 
end