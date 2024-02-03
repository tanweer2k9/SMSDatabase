create procedure  [dbo].[sp_CONDUCT_INFO_insertion]
                                               
                                               
          @CONDUCT_HD_ID  numeric,
          @CONDUCT_BR_ID  numeric,
          @CONDUCT_NAME  nvarchar(50) ,
          @CONDUCT_DESC  nvarchar(500) ,
          @CONDUCT_STATUS  char(2) 
   
   
     as  begin
   
   
     insert into CONDUCT_INFO
     values
     (
        @CONDUCT_HD_ID,
        @CONDUCT_BR_ID,
        @CONDUCT_NAME,
        @CONDUCT_DESC,
        @CONDUCT_STATUS
     
     
     )
     
end