create procedure  [dbo].[sp_AREA_INFO_insertion]
                                               
                                               
          @AREA_HD_ID  numeric,
          @AREA_BR_ID  numeric,
          @AREA_NAME  nvarchar(50) ,
          @AREA_DESC  nvarchar(500) ,
          @AREA_STATUS  char(2) 
   
   
     as  begin
   
   
     insert into AREA_INFO
     values
     (
        @AREA_HD_ID,
        @AREA_BR_ID,
        @AREA_NAME,
        @AREA_DESC,
        @AREA_STATUS
     
     
     )
     
end