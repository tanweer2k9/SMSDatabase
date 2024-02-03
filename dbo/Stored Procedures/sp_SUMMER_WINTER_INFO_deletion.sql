CREATE PROCEDURE  [dbo].[sp_SUMMER_WINTER_INFO_deletion]
                                               
                                               
          @STATUS char(10),
          @SUM_WIN_ID  numeric,
          @SUM_WIN_HD_ID  numeric,
          @SUM_WIN_BR_ID  numeric
   
   
     AS BEGIN 
   
   
     delete from SUMMER_WINTER_INFO
 
 
     where 
          SUM_WIN_ID =  @SUM_WIN_ID 
 
end