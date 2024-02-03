create procedure  [dbo].[sp_HOUSES_INFO_insertion]
                                               
                                               
          @HOUSES_HD_ID  numeric,
          @HOUSES_BR_ID  numeric,
          @HOUSES_NAME  nvarchar(50) ,
          @HOUSES_DESC  nvarchar(500) ,
          @HOUSES_STATUS  char(2) 
   
   
     as  begin
   
   
     insert into HOUSES_INFO
     values
     (
        @HOUSES_HD_ID,
        @HOUSES_BR_ID,
        @HOUSES_NAME,
        @HOUSES_DESC,
        @HOUSES_STATUS
     
     
     )
     
end