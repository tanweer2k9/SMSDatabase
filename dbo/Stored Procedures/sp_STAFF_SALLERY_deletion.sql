CREATE PROCEDURE  [dbo].[sp_STAFF_SALLERY_deletion]
                                               
                                               
          @STATUS char(10),
          @STAFF_SALLERY_DATE  numeric,
          @STAFF_SALLERY_HD_ID  numeric,
          @STAFF_SALLERY_BR_ID  numeric
   
   
     AS BEGIN 
   
   
     delete from STAFF_SALLERY
 
 
     where 
     
          DATEPART(MM,STAFF_SALLERY_DATE) = DATEPART(MM, @STAFF_SALLERY_DATE) and
          DATEPART(YYYY,STAFF_SALLERY_DATE) = DATEPART(YYYY, @STAFF_SALLERY_DATE) and
          STAFF_SALLERY_HD_ID =  @STAFF_SALLERY_HD_ID and 
          STAFF_SALLERY_BR_ID like [dbo].[get_centralized_br_id]('S', @STAFF_SALLERY_BR_ID) 
 
end