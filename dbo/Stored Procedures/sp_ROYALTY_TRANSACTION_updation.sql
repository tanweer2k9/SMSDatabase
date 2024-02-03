CREATE procedure  [dbo].[sp_ROYALTY_TRANSACTION_updation]
                                               
                                               
          @ROYALTY_TRAN_ID  numeric,
          @ROYALTY_TRAN_BR_ID  numeric,
          @ROYALTY_TRAN_AMOUNT  float,
          @ROYALTY_TRAN_FROM_DATE  date,
          @ROYALTY_TRAN_TO_DATE  date,
          @ROYALTY_TRAN_BANK_NAME  nvarchar(100) ,
          @ROYALTY_TRAN_CHEQUE_NO  nvarchar(100) ,
          @ROYALTY_TRAN_COMMENTS  nvarchar(1000) ,
		  @ROYALTY_TRAN_CREATED_BY nvarchar(50),
		  @ROYALTY_TRAN_DATETIME datetime,
		  @ROYALTY_TRAN_PAYMENTS_TO nvarchar(50)
   
     as begin 
   
   
     update ROYALTY_TRANSACTION
 
     set
          ROYALTY_TRAN_AMOUNT =  @ROYALTY_TRAN_AMOUNT,
          ROYALTY_TRAN_FROM_DATE =  @ROYALTY_TRAN_FROM_DATE,
          ROYALTY_TRAN_TO_DATE =  @ROYALTY_TRAN_TO_DATE,
          ROYALTY_TRAN_BANK_NAME =  @ROYALTY_TRAN_BANK_NAME,
          ROYALTY_TRAN_CHEQUE_NO =  @ROYALTY_TRAN_CHEQUE_NO,
          ROYALTY_TRAN_COMMENTS =  @ROYALTY_TRAN_COMMENTS,
		  ROYALTY_TRAN_CREATED_BY =ROYALTY_TRAN_CREATED_BY + ','+  @ROYALTY_TRAN_CREATED_BY,
		  ROYALTY_TRAN_DATETIME =ROYALTY_TRAN_DATETIME + ','  + @ROYALTY_TRAN_DATETIME
 
     where 
         
          ROYALTY_TRAN_BR_ID =  @ROYALTY_TRAN_BR_ID 
 
end