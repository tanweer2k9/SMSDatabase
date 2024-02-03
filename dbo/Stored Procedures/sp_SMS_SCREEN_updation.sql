CREATE procedure  [dbo].[sp_SMS_SCREEN_updation]
                                               
                                               
          @SMS_SCREEN_ID  numeric,
          @SMS_SCREEN_HD_ID  numeric,
          @SMS_SCREEN_BR_ID  numeric,
          @SMS_SCREEN_NAME  nvarchar(100) ,
          @SMS_SCREEN_INSERT  char(2) ,
          @SMS_SCREEN_UPDATE  char(2) ,
          @SMS_SCREEN_DELETE  char(2) ,
          @SMS_SCREEN_OPEN  char(2) ,
          @SMS_SCREEN_STUDENT  char(2) ,
          @SMS_SCREEN_PARENTS  char(2) ,
          @SMS_SCREEN_ADMIN  char(2) ,
          @SMS_SCREEN_SUPER_ADMIN  char(2) ,
          @SMS_SCREEN_STAFF  char(2) ,
          @SMS_SCREEN_DATE_TIME  DATETIME ,
          @SMS_SCREEN_STATUS  char(2) ,
		  @RIGHTS_PAGE_NAME nvarchar(50)
   
   
     as begin 
   
   
     update SMS_SCREEN
 
     set
          SMS_SCREEN_NAME =  @SMS_SCREEN_NAME,
          SMS_SCREEN_INSERT =  @SMS_SCREEN_INSERT,
          SMS_SCREEN_UPDATE =  @SMS_SCREEN_UPDATE,
          SMS_SCREEN_DELETE =  @SMS_SCREEN_DELETE,
          SMS_SCREEN_OPEN =  @SMS_SCREEN_OPEN,
          SMS_SCREEN_STUDENT =  @SMS_SCREEN_STUDENT,
          SMS_SCREEN_PARENTS =  @SMS_SCREEN_PARENTS,
          SMS_SCREEN_ADMIN =  @SMS_SCREEN_ADMIN,
          SMS_SCREEN_SUPER_ADMIN =  @SMS_SCREEN_SUPER_ADMIN,
          SMS_SCREEN_STAFF =  @SMS_SCREEN_STAFF,
          SMS_SCREEN_DATE_TIME =  @SMS_SCREEN_DATE_TIME,
          SMS_SCREEN_STATUS =  @SMS_SCREEN_STATUS,
		  RIGHTS_PAGE_NAME =@RIGHTS_PAGE_NAME
 
     where 
          SMS_SCREEN_ID =  @SMS_SCREEN_ID and 
          SMS_SCREEN_HD_ID =  @SMS_SCREEN_HD_ID and 
          SMS_SCREEN_BR_ID =  @SMS_SCREEN_BR_ID 
 
end