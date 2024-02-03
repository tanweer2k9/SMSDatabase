create procedure  [dbo].[sp_SUPPLEMENTARY_MONTHS_INFO_updation]
                                               
                                               
          @SUPL_MONTH_ID  numeric,
          @SUPL_MONTH_HD_ID  numeric,
          @SUPL_MONTH_BR_ID  numeric,
          @SUPL_MONTH_NAME  nvarchar(50) ,
          @SUPL_FROM_DATE  date,
          @SUPL_TO_DATE  date,
          @SUPL_MONTH_DESC  nvarchar(500) ,
          @SUPL_MONTH_STATUS  char(2) 
   
   
     as begin 
   
   
     update SUPPLEMENTARY_MONTHS_INFO
 
     set
          SUPL_MONTH_NAME =  @SUPL_MONTH_NAME,
          SUPL_FROM_DATE =  @SUPL_FROM_DATE,
          SUPL_TO_DATE =  @SUPL_TO_DATE,
          SUPL_MONTH_DESC =  @SUPL_MONTH_DESC,
          SUPL_MONTH_STATUS =  @SUPL_MONTH_STATUS
 
     where 
          SUPL_MONTH_ID =  @SUPL_MONTH_ID and 
          SUPL_MONTH_HD_ID =  @SUPL_MONTH_HD_ID and 
          SUPL_MONTH_BR_ID =  @SUPL_MONTH_BR_ID 
 
end