CREATE procedure  [dbo].[sp_FEE_INFO_selection]
                                               
                                               
     @STATUS char(10),
	 @DEFINITION_ID numeric,
	 @DEFINITION_HD_ID numeric,
	 @DEFINITION_BR_ID numeric
   
     AS BEGIN 
   
   
     if @STATUS = 'A'
     BEGIN
   

     SELECT  [ID],[Name],[Fee Type],[Fee Months] ,[Printing Order] ,[Discount Adjustment Priority],Operation,[Description], [Is Discountable],[Status]  FROM VFEE_INFO a
     where 
     [Institute ID] = @DEFINITION_HD_ID and
     [Branch ID] = @DEFINITION_BR_ID and
     [Status] != 'D' 
     order by [Printing Order]

	 select * from TBL_COA where COA_Name = 'Fees' and CMP_ID = @DEFINITION_HD_ID and BRC_ID = @DEFINITION_BR_ID and COA_isDeleted = 0
	 select * from TBL_DEFAULT_ACCT where DEFAULT_ACCT_KEY = 'Fees' and CMP_ID = @DEFINITION_HD_ID and BRC_ID = @DEFINITION_BR_ID and DEFAULT_ACCT_isDeleted = 0
      
     END  
     
     ELSE if  @STATUS = 'B'
     BEGIN
	SELECT * FROM FEE_INFO
 
     WHERE 
     FEE_ID = @DEFINITION_ID
 
     END
     
     
     Else if @STATUS = 'X'
     BEGIN
    SELECT  ISNULL( MAX(FEE_ID +1),1) FROM FEE_INFO
     
     END 
 
     END