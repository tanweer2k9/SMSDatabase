create procedure  [dbo].[sp_SUPPLEMENTARY_MONTHS_INFO_insertion]
                                               
                                               
          @SUPL_MONTH_HD_ID  numeric,
          @SUPL_MONTH_BR_ID  numeric,
          @SUPL_MONTH_NAME  nvarchar(50) ,
          @SUPL_FROM_DATE  date,
          @SUPL_TO_DATE  date,
          @SUPL_MONTH_DESC  nvarchar(500) ,
          @SUPL_MONTH_STATUS  char(2) 
   
   
     as  begin
   
   
     insert into SUPPLEMENTARY_MONTHS_INFO
     values
     (
        @SUPL_MONTH_HD_ID,
        @SUPL_MONTH_BR_ID,
        @SUPL_MONTH_NAME,
        @SUPL_FROM_DATE,
        @SUPL_TO_DATE,
        @SUPL_MONTH_DESC,
        @SUPL_MONTH_STATUS
     
     
     )
     
end