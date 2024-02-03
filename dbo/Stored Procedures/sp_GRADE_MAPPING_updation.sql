CREATE procedure  [dbo].[sp_GRADE_MAPPING_updation]
                                               
                                               
          @GRADE_MAP_ID  numeric,
          @GRADE_MAP_HD_ID  numeric,
          @GRADE_MAP_BR_ID  numeric,
          @GRADE_MAP_CLASS_ID  numeric,
          @GRADE_MAP_GRADE_PLAN_ID  numeric ,
          @GRADE_MAP_STATUS  char(2) 
   
   
     as begin 
   
   
     update GRADE_MAPPING
 
     set
          GRADE_MAP_GRADE_PLAN_ID =  @GRADE_MAP_GRADE_PLAN_ID
 
     where 
          GRADE_MAP_ID =  @GRADE_MAP_ID and 
          GRADE_MAP_HD_ID =  @GRADE_MAP_HD_ID and 
          GRADE_MAP_BR_ID =  @GRADE_MAP_BR_ID 
 
end