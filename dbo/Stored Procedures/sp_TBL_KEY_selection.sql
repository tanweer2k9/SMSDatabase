--     *****************************************************************************************************************************************************************
 
 
--                             Code Type:           Store Procedure For selection
--                             Creation Date:       7/10/2014 3:33:45 PM
--                             Auther:              Muhammad Usman Raza Attari
--                             Developed By :       786 Software House 
 
 
--    *****************************************************************************************************************************************************************
 
     CREATE procedure  [dbo].[sp_TBL_KEY_selection]
                                               
                                               
     @STATUS nvarchar(10),
     @GEN_FORM_CMP_ID  int,
     @GEN_FORM_ID  int,
     @GEN_FORM_key  nvarchar(50) ,
     @GEN_FORM_Prefix  nvarchar(50) 
   
   
     AS BEGIN 
   
   
     if @STATUS = 'A'
     BEGIN
   
     SELECT * FROM TBL_KEY
     END  
     ELSE  if @STATUS = 'V'
     BEGIN
  SELECT GEN_FORM_key,GEN_FORM_value FROM TBL_KEY
 
 
     WHERE
		GEN_FORM_Prefix =  @GEN_FORM_Prefix 
     END
 
     END