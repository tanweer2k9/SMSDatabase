CREATE procedure  [dbo].[sp_STAFF_TYPE_INFO_selection]
                                               
                                               
     @STATUS char(10),
     @STAFF_TYPE_ID  numeric,
     @STAFF_TYPE_HD_ID  numeric,
     @STAFF_TYPE_BR_ID  numeric
   
   
     AS BEGIN 
   
   
     if @STATUS = 'L'
     BEGIN
   
     SELECT  [ID],[Name],[Description],[Status] FROM VSTAFF_TYPE_INFO
		where 
		 [Institute ID] = @STAFF_TYPE_HD_ID and
		 [Branch ID] = @STAFF_TYPE_BR_ID and
		 [Status] != 'D' 
     END  
     ELSE
     BEGIN
  SELECT * FROM STAFF_TYPE_INFO
 
 
     WHERE
     STAFF_TYPE_ID =  @STAFF_TYPE_ID and 
     STAFF_TYPE_HD_ID =  @STAFF_TYPE_HD_ID and 
     STAFF_TYPE_BR_ID =  @STAFF_TYPE_BR_ID 
 
     END
 
     END