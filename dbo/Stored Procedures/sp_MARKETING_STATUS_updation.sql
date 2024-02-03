create procedure  [dbo].[sp_MARKETING_STATUS_updation]
                                               
                                               
          @MARK_STATUS_ID  numeric,
          @MARK_STATUS_HD_ID  numeric,
          @MARK_STATUS_BR_ID  numeric,
          @MARK_STATUS_NAME  nvarchar(50) ,
          @MARK_STATUS_DESCRIPTION  nvarchar(300) ,
          @MARK_STATUS  char(2) 
   
   
     as begin 
   
   
     update MARKETING_STATUS
 
     set
          MARK_STATUS_NAME =  @MARK_STATUS_NAME,
          MARK_STATUS_DESCRIPTION =  @MARK_STATUS_DESCRIPTION,
          MARK_STATUS =  @MARK_STATUS
 
     where 
          MARK_STATUS_ID =  @MARK_STATUS_ID  
         
end