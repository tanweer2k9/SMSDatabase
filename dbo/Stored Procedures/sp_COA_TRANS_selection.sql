CREATE procedure  [dbo].[sp_COA_TRANS_selection]
                                               
                                               
     @STATUS char(10),
     @COA_TRANS_ID  numeric,
     @COA_TRANS_HD_ID  numeric,
     @COA_TRANS_BR_ID  numeric
   
   
     AS BEGIN 
   
   
     if @STATUS = 'L'
     BEGIN
	
	SELECT * FROM COA where 
     COA_HD_ID =  @COA_TRANS_HD_ID and 
     COA_BR_ID =  @COA_TRANS_BR_ID AND
     COA_STATUS != 'D'      
     
     
     SELECT COA_TRANS_ID as ID, COA_TRANS_NAME as Name, COA_TRANS_QTY as Qty, 
     COA_TRANS_VALUE as value, COA_TRANS_CID as [Account ID], c.COA_NAME as [Category Name], COA_TRANS_DATE as [Date] 
     FROM COA_TRANS
     join COA c
     on COA_TRANS_CID = c.COA_ID
     where
     COA_TRANS_HD_ID =  @COA_TRANS_HD_ID and 
     COA_TRANS_BR_ID =  @COA_TRANS_BR_ID and 
     COA_TRANS_STATUS != 'D' 
     order by Date desc
   
   END 
      
     
     ELSE
     BEGIN
  SELECT * FROM COA_TRANS
 
 
     WHERE
     COA_TRANS_ID =  @COA_TRANS_ID and 
     COA_TRANS_HD_ID =  @COA_TRANS_HD_ID and 
     COA_TRANS_BR_ID =  @COA_TRANS_BR_ID and 
     COA_TRANS_STATUS != 'D' 
 
     END
 
     END