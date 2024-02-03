CREATE procedure  [dbo].[sp_MARKETING_STATUS_selection]
                                               
                                               
     @STATUS char(10),
     @MARK_STATUS_ID  numeric,
     @MARK_STATUS_HD_ID  numeric,
     @MARK_STATUS_BR_ID  numeric
   
   
     AS BEGIN 
   
   
     if @STATUS = 'A'
     BEGIN
     SELECT ID, Name, [Description], [Status] FROM VMARKETING_STATUS where Status != 'D' and [Institute ID] = @MARK_STATUS_HD_ID and [Branch ID] = @MARK_STATUS_BR_ID
     END  
     ELSE
     BEGIN
  SELECT * FROM MARKETING_STATUS
 
 
     WHERE
     MARK_STATUS_ID =  @MARK_STATUS_ID and 
     MARK_STATUS_HD_ID =  @MARK_STATUS_HD_ID and 
     MARK_STATUS_BR_ID =  @MARK_STATUS_BR_ID 
 
     END
 
     END