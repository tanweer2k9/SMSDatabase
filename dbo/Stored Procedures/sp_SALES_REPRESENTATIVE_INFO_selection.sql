create procedure  [dbo].[sp_SALES_REPRESENTATIVE_INFO_selection]
                                               
                                               
     @STATUS char(10),
     @SALES_ID  numeric,
     @SALES_HD_ID  numeric,
     @SALES_BR_ID  numeric
   
   
     AS BEGIN 
   
   
     if @STATUS = 'A'
     BEGIN
   
     SELECT ID, Name, [Description], [Status] FROM VSALES_REPRESENTATIVE_INFO where Status != 'D' and [Institute ID] = @SALES_HD_ID and [Branch ID] = @SALES_BR_ID
     END  
     ELSE
     BEGIN
  SELECT * FROM SALES_REPRESENTATIVE_INFO
 
 
     WHERE
     SALES_ID =  @SALES_ID and 
     SALES_HD_ID =  @SALES_HD_ID and 
     SALES_BR_ID =  @SALES_BR_ID 
 
     END
 
     END