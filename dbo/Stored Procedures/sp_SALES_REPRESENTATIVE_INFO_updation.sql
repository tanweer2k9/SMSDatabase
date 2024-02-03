create procedure  [dbo].[sp_SALES_REPRESENTATIVE_INFO_updation]
                                               
                                               
          @SALES_ID  numeric,
          @SALES_HD_ID  numeric,
          @SALES_BR_ID  numeric,
          @SALES_NAME  nvarchar(50) ,
          @SALES_DESCRIPTION  nvarchar(200) ,
          @SALES_STATUS  char(2) 
   
   
     as begin 
   
   
     update SALES_REPRESENTATIVE_INFO
 
     set
          SALES_NAME =  @SALES_NAME,
          SALES_DESCRIPTION =  @SALES_DESCRIPTION,
          SALES_STATUS =  @SALES_STATUS
 
     where 
          SALES_ID =  @SALES_ID
end