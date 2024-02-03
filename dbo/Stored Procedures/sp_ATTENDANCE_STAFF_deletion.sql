CREATE PROCEDURE  [dbo].[sp_ATTENDANCE_STAFF_deletion]
                                               
                                               
          @STATUS char(10),
          @ATTENDANCE_STAFF_ID  numeric,
          @ATTENDANCE_STAFF_HD_ID  numeric,
          @ATTENDANCE_STAFF_BR_ID  numeric
   
   
     AS BEGIN 
   
   
     UPDATE ATTENDANCE_STAFF
 SET ATTENDANCE_STAFF_STATUS = 'D'
 
     where 
          ATTENDANCE_STAFF_ID =  @ATTENDANCE_STAFF_ID and 
          ATTENDANCE_STAFF_HD_ID =  @ATTENDANCE_STAFF_HD_ID and 
          ATTENDANCE_STAFF_BR_ID =  @ATTENDANCE_STAFF_BR_ID 
 
end