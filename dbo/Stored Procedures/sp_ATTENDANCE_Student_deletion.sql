CREATE PROCEDURE  [dbo].[sp_ATTENDANCE_Student_deletion]
                                               
                                               
          @STATUS char(10),
          @ATTENDANCE_ID  numeric,
          @ATTENDANCE_HD_ID  numeric,
          @ATTENDANCE_BR_ID  numeric
   
   
     AS BEGIN 
   
   
     UPDATE ATTENDANCE 
     SET ATTENDANCE_STATUS = 'D'
      
 
 
     where 
          ATTENDANCE_ID =  @ATTENDANCE_ID and 
          ATTENDANCE_HD_ID =  @ATTENDANCE_HD_ID and 
          ATTENDANCE_BR_ID =  @ATTENDANCE_BR_ID 
 
end