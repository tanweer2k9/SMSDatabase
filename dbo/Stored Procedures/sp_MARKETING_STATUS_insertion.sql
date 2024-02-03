create procedure  [dbo].[sp_MARKETING_STATUS_insertion]
                                               
                                               
          @MARK_STATUS_HD_ID  numeric,
          @MARK_STATUS_BR_ID  numeric,
          @MARK_STATUS_NAME  nvarchar(50) ,
          @MARK_STATUS_DESCRIPTION  nvarchar(300) ,
          @MARK_STATUS  char(2) 
   
   
     as  begin
   
   
     insert into MARKETING_STATUS
     values
     (
        @MARK_STATUS_HD_ID,
        @MARK_STATUS_BR_ID,
        @MARK_STATUS_NAME,
        @MARK_STATUS_DESCRIPTION,
        @MARK_STATUS
     
     
     )
     
end