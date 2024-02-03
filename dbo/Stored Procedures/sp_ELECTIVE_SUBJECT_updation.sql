--     *****************************************************************************************************************************************************************
 
 
--                             Code Type:           Store Procedure For Updation  
--                             Creation Date:       9/13/2014 5:17:10 PM
--                             Auther:              Muhammad Usman Raza Attari
--                             Developed By :       786 Software House 
 
 
--    *****************************************************************************************************************************************************************
 
     CREATE procedure  [dbo].[sp_ELECTIVE_SUBJECT_updation]
                                               
                                               
          @ELE_SUB_ID  numeric,
          @ELE_SUB_HD_ID  numeric,
          @ELE_SUB_BR_ID  numeric,
          @ELE_SUB_NAME  nvarchar(50) ,
          @ELE_SUB_CLASS_ID  numeric,
          @ELE_SUB_STATUS  char(2) ,
          @ELE_SUB_DATETIME  datetime,
          @ELE_SUB_USER   nvarchar(50)
   
   
     as begin 
   
   
     update ELECTIVE_SUBJECT
 
     set
          ELE_SUB_NAME =  @ELE_SUB_NAME,
          ELE_SUB_CLASS_ID =  @ELE_SUB_CLASS_ID,
          ELE_SUB_STATUS =  @ELE_SUB_STATUS,
          ELE_SUB_DATETIME =  @ELE_SUB_DATETIME,
          ELE_SUB_USER =  @ELE_SUB_USER
 
     where 
          ELE_SUB_ID =  @ELE_SUB_ID and 
          ELE_SUB_HD_ID =  @ELE_SUB_HD_ID and 
          ELE_SUB_BR_ID =  @ELE_SUB_BR_ID 
 
end