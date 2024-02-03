create procedure  [dbo].[sp_OVETIME_ADVANCE_updation]
                                               
                                               
          @OVRTM_ADV_ID  numeric,
          @OVRTM_ADV_HD_ID  numeric,
          @OVRTM_ADV_BR_ID  numeric,
          @OVRTM_ADV_STAFF_ID  numeric,
          @OVRTM_ADV_AMOUNT  float,
          @OVRTM_ADV_DATE  date,
          @OVRTM_ADV_ADJUST_AMOUNT  float,
          @OVRTM_ADV_ADJUST_DATE  date,
          @OVRTM_ADV_ENTERED_DATE  datetime,
          @OVRTM_ADV_USER  nvarchar(50) ,
          @OVRTM_ADV_STATUS  char(1) 
   
   
     as begin 
   
   
     update OVETIME_ADVANCE
 
     set
          OVRTM_ADV_STAFF_ID =  @OVRTM_ADV_STAFF_ID,
          OVRTM_ADV_AMOUNT =  @OVRTM_ADV_AMOUNT,
          OVRTM_ADV_DATE =  @OVRTM_ADV_DATE,
          OVRTM_ADV_ADJUST_AMOUNT =  @OVRTM_ADV_ADJUST_AMOUNT,
          OVRTM_ADV_ADJUST_DATE =  @OVRTM_ADV_ADJUST_DATE,
          OVRTM_ADV_ENTERED_DATE =  @OVRTM_ADV_ENTERED_DATE,
          OVRTM_ADV_USER =  @OVRTM_ADV_USER,
          OVRTM_ADV_STATUS =  @OVRTM_ADV_STATUS
 
     where 
          OVRTM_ADV_ID =  @OVRTM_ADV_ID and 
          OVRTM_ADV_HD_ID =  @OVRTM_ADV_HD_ID and 
          OVRTM_ADV_BR_ID =  @OVRTM_ADV_BR_ID 
 
end