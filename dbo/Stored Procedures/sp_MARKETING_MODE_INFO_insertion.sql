create procedure  [dbo].[sp_MARKETING_MODE_INFO_insertion]
                                               
                                               
          @MODE_HD_ID  numeric,
          @MODE_BR_ID  numeric,
          @MODE_NAME  nvarchar(50) ,
          @MODE_DESCRIPTION  nvarchar(200) ,
          @MODE_STATUS  char(2) 
   
   
     as  begin
   
   
     insert into MARKETING_MODE_INFO
     values
     (
        @MODE_HD_ID,
        @MODE_BR_ID,
        @MODE_NAME,
        @MODE_DESCRIPTION,
        @MODE_STATUS
     
     
     )
     
end