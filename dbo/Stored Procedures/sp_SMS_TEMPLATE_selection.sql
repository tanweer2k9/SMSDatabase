CREATE procedure  [dbo].[sp_SMS_TEMPLATE_selection]
                                               
                                               
     @STATUS char(10),
     @SMS_TEMPLATE_ID  numeric,
     @SMS_TEMPLATE_HD_ID  numeric,
     @SMS_TEMPLATE_BR_ID  numeric
   
   
     AS BEGIN 
   
   
     if @STATUS = 'L'
     BEGIN
   
     select SMS_TEMPLATE_ID AS [ID], SMS_TEMPLATE_SCREEN_ID as [Screen ID], s.SMS_SCREEN_NAME as [Screen Name], SMS_TEMPLATE_INSERT_MSG AS [Insert Msg], 
            SMS_TEMPLATE_INSERT_VAR_ID AS [Insert Var ID], SMS_TEMPLATE_UPDATE_MSG AS [Update Msg], 
            SMS_TEMPLATE_UPDATE_VAR_ID AS [Update Var ID], SMS_TEMPLATE_DELETE_MSG AS [Delete Msg], 
            SMS_TEMPLATE_DELETE_VAR_ID AS [Delete Var ID], SMS_TEMPLATE_OPEN_MSG AS [Open Msg], 
            SMS_TEMPLATE_OPEN_VAR_ID AS [Open Var ID], SMS_TEMPLATE_STATUS AS Status
FROM         dbo.SMS_TEMPLATE t
join SMS_SCREEN s
on s.SMS_SCREEN_ID = t.SMS_TEMPLATE_SCREEN_ID
where
SMS_TEMPLATE_HD_ID = @SMS_TEMPLATE_HD_ID and
SMS_TEMPLATE_BR_ID = @SMS_TEMPLATE_BR_ID and
s.SMS_SCREEN_STATUS = 'T' and
SMS_TEMPLATE_STATUS = 'T'


select * from VSMS_SCREEN
     where
     HD_ID =  @SMS_TEMPLATE_HD_ID and 
     BR_ID =  @SMS_TEMPLATE_BR_ID and
     [Status] = 'T'

select SMS_VARIABLES_ID as ID, SMS_VARIABLES_NAME as Name
from SMS_VARIABLES
where 
SMS_VARIABLES_BR_ID = @SMS_TEMPLATE_BR_ID and
SMS_VARIABLES_HD_ID = @SMS_TEMPLATE_HD_ID and
SMS_VARIABLES_STATUS = 'T'
     END
 
     END