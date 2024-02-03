create procedure  [dbo].[sp_CITY_INFO_insertion]
                                               
                                               
          @CITY_HD_ID  numeric,
          @CITY_BR_ID  numeric,
          @CITY_NAME  nvarchar(50) ,
          @CITY_DESC  nvarchar(500) ,
          @CITY_STATUS  char(2) 
   
   
     as  begin
   
   
     insert into CITY_INFO
     values
     (
        @CITY_HD_ID,
        @CITY_BR_ID,
        @CITY_NAME,
        @CITY_DESC,
        @CITY_STATUS
     
     
     )
     
end