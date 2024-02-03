--     *****************************************************************************************************************************************************************
 
 
--                             Code Type:           Store Procedure For Updation  
--                             Creation Date:       9/13/2014 8:21:40 PM
--                             Auther:              Muhammad Usman Raza Attari
--                             Developed By :       786 Software House 
 
 
--    *****************************************************************************************************************************************************************
 
     CREATE procedure  [dbo].[sp_DISCOUNT_RULES_updation]
                                               
                                               
          @DIS_RUL_ID  numeric,
          @DIS_RUL_HD_ID  numeric,
          @DIS_RUL_BR_ID  numeric,
          @DIS_RUL_NAME  nvarchar(200) ,
          @DIS_RUL_STATUS  char(2) ,
          @DIS_RUL_DATETIME  datetime,
          @DIS_RUL_USER  nvarchar(50) ,
		  @DIS_RUL_CLASS_ID numeric
   
   
     as begin 
   
   
     update DISCOUNT_RULES
 
     set
          DIS_RUL_NAME =  @DIS_RUL_NAME,
          DIS_RUL_STATUS =  @DIS_RUL_STATUS,
          DIS_RUL_DATETIME =  @DIS_RUL_DATETIME,
          DIS_RUL_USER =  @DIS_RUL_USER,
		  DIS_RUL_CLASS_ID = @DIS_RUL_CLASS_ID
 
     where 
          DIS_RUL_ID =  @DIS_RUL_ID and 
          DIS_RUL_HD_ID =  @DIS_RUL_HD_ID and 
          DIS_RUL_BR_ID =  @DIS_RUL_BR_ID 
 
end