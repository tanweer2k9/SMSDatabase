CREATE PROCEDURE  [dbo].[sp_ELECTIVE_SUBJECT_deletion]
                                               
                                               
          @STATUS char(10),
          @ELE_SUB_ID  numeric,
          @ELE_SUB_HD_ID  numeric,
          @ELE_SUB_BR_ID  numeric
   
   
     AS BEGIN 
   
   
     update ELECTIVE_SUBJECT
	 set ELE_SUB_STATUS = 'D'
 
 
     where 
          ELE_SUB_ID =  @ELE_SUB_ID 
 
end