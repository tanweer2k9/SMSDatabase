CREATE procedure  [dbo].[sp_COA_TRANS_insertion]
                                               
                                               
          @COA_TRANS_HD_ID  numeric,
          @COA_TRANS_BR_ID  numeric,
          @COA_TRANS_NAME  nvarchar(4000) ,
          @COA_TRANS_QTY  numeric,
          @COA_TRANS_VALUE  float,
          @COA_TRANS_CID  numeric,
          @COA_TRANS_DATE  date,
          @COA_TRANS_ENTER_DATE  datetime,
          @COA_TRANS_STATUS  char(2) 
   
   
     as  begin
   
   
   
     insert into COA_TRANS
     values
     (
        @COA_TRANS_HD_ID,
        @COA_TRANS_BR_ID,
        @COA_TRANS_NAME,
        @COA_TRANS_QTY,
        @COA_TRANS_VALUE,
        @COA_TRANS_CID,
        @COA_TRANS_DATE,
        @COA_TRANS_ENTER_DATE,
        @COA_TRANS_STATUS
     
     
     )
     
end