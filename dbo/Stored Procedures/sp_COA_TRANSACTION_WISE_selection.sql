CREATE procedure  [dbo].[sp_COA_TRANSACTION_WISE_selection]
                                               
                                               
     @STATUS char(10),     
     @COA_TRANS_HD_ID  numeric,
     @COA_TRANS_BR_ID  numeric, 
     @COA_TRANS_FROM_DATE datetime,
     @COA_TRANS_TO_DATE datetime
   
   
     AS BEGIN 
   
   
     if @STATUS = 'L'
     BEGIN     
     SELECT * FROM COA where 
     COA_HD_ID in (select * from dbo.get_all_hd_id (@COA_TRANS_HD_ID)) and 
     COA_BR_ID in (select * from dbo.get_all_br_id (@COA_TRANS_BR_ID)) AND
     COA_STATUS = 'T'  
     
      SELECT COA_TRANS_DATE as [Date]     
     from COA_TRANS
     
     
     where
     COA_TRANS_HD_ID in (select * from dbo.get_all_hd_id (@COA_TRANS_HD_ID)) and 
     COA_TRANS_BR_ID in (select * from dbo.get_all_br_id (@COA_TRANS_BR_ID)) and     
     COA_TRANS_STATUS = 'T'  
     order by COA_TRANS_DATE
   
   END    
   
   else if @STATUS = 'S'
   begin
        SELECT COA_TRANS_NAME as Name, COA_TRANS_QTY as Qty, 
     COA_TRANS_VALUE as Value, COA_TRANS_DATE as [Date],  COA_TRANS_ENTER_DATE as [Entered Date],COA_TRANS_CID as CID     
     from COA_TRANS
     
     
     where
     COA_TRANS_HD_ID in (select * from dbo.get_all_hd_id (@COA_TRANS_HD_ID)) and 
     COA_TRANS_BR_ID in (select * from dbo.get_all_br_id (@COA_TRANS_BR_ID)) and 
     COA_TRANS_DATE  between @COA_TRANS_FROM_DATE and @COA_TRANS_TO_DATE and
     --COA_TRANS_DATE >= @COA_TRANS_FROM_DATE and
     --COA_TRANS_DATE <= @COA_TRANS_TO_DATE and
     COA_TRANS_STATUS = 'T'  
     order by COA_TRANS_DATE  

   
        SELECT * FROM COA where 
     COA_HD_ID in (select * from dbo.get_all_hd_id (@COA_TRANS_HD_ID)) and 
     COA_BR_ID in (select * from dbo.get_all_br_id (@COA_TRANS_BR_ID)) AND
     COA_STATUS = 'T'  
     
      SELECT COA_TRANS_NAME as Name, COA_TRANS_QTY as Qty, 
     COA_TRANS_VALUE as Value, COA_TRANS_DATE as [Date], COA_TRANS_CID as CID     
     from COA_TRANS
     
     
     where
     COA_TRANS_HD_ID in (select * from dbo.get_all_hd_id (@COA_TRANS_HD_ID)) and 
     COA_TRANS_BR_ID in (select * from dbo.get_all_br_id (@COA_TRANS_BR_ID)) and 
     COA_TRANS_DATE  between @COA_TRANS_FROM_DATE and @COA_TRANS_TO_DATE and
     --COA_TRANS_DATE >= @COA_TRANS_FROM_DATE and
     --COA_TRANS_DATE <= @COA_TRANS_TO_DATE and
     COA_TRANS_STATUS = 'T'  
     order by COA_TRANS_DATE
 
     END
end