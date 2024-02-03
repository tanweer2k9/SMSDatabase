CREATE procedure  [dbo].[sp_COA_TRANS_updation]
                                               
                                               
          @COA_TRANS_ID  numeric,
          @COA_TRANS_HD_ID  numeric,
          @COA_TRANS_BR_ID  numeric,
          @COA_TRANS_NAME  nvarchar(4000) ,
          @COA_TRANS_QTY  numeric,
          @COA_TRANS_VALUE  float,
          @COA_TRANS_CID  numeric,
          @COA_TRANS_DATE  date,
          @COA_TRANS_ENTER_DATE datetime,
          @COA_TRANS_STATUS  char(2) 
   
   
     as begin 
   
   
     update COA_TRANS
 
     set
          COA_TRANS_NAME =  @COA_TRANS_NAME,
          COA_TRANS_QTY =  @COA_TRANS_QTY,
          COA_TRANS_VALUE =  @COA_TRANS_VALUE,
          COA_TRANS_CID =  @COA_TRANS_CID,
          COA_TRANS_DATE =  @COA_TRANS_DATE,
          COA_TRANS_ENTER_DATE = @COA_TRANS_ENTER_DATE,
          COA_TRANS_STATUS =  @COA_TRANS_STATUS
 
     where 
          COA_TRANS_ID =  @COA_TRANS_ID and 
          COA_TRANS_HD_ID =  @COA_TRANS_HD_ID and 
          COA_TRANS_BR_ID =  @COA_TRANS_BR_ID 
 
end