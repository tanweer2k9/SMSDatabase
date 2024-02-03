create procedure  [dbo].[sp_EXAM_APPROVAL_SETTINGS_updation]
                                               
                                               
          @APPROVAL_ID  numeric,
          @APPROVAL_HD_ID  numeric,
          @APPROVAL_BR_ID  numeric,
          @APPROVAL_STAFF_ID  numeric,
          @APPROVAL_DESIGNATION  nvarchar(50) ,
          @APPROVAL_RANK  int,
          @APPROVAL_STATUS  char(1) 
   
   
     as begin 
   
   
     update EXAM_APPROVAL_SETTINGS
 
     set
          APPROVAL_STAFF_ID =  @APPROVAL_STAFF_ID,
          APPROVAL_DESIGNATION =  @APPROVAL_DESIGNATION,
          APPROVAL_RANK =  @APPROVAL_RANK,
          APPROVAL_STATUS =  @APPROVAL_STATUS
 
     where 
          APPROVAL_ID =  @APPROVAL_ID and 
          APPROVAL_HD_ID =  @APPROVAL_HD_ID and 
          APPROVAL_BR_ID =  @APPROVAL_BR_ID 
 
end