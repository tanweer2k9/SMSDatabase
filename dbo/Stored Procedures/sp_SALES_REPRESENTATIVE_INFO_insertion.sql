create procedure  [dbo].[sp_SALES_REPRESENTATIVE_INFO_insertion]
                                               
                                               
          @SALES_HD_ID  numeric,
          @SALES_BR_ID  numeric,
          @SALES_NAME  nvarchar(50) ,
          @SALES_DESCRIPTION  nvarchar(200) ,
          @SALES_STATUS  char(2) 
   
   
     as  begin
   
   
     insert into SALES_REPRESENTATIVE_INFO
     values
     (
        @SALES_HD_ID,
        @SALES_BR_ID,
        @SALES_NAME,
        @SALES_DESCRIPTION,
        @SALES_STATUS
     
     
     )
     
end