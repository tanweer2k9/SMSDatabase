CREATE procedure  [dbo].[sp_ELECTIVE_SUBJECT_insertion]
                                               
                                               
          @ELE_SUB_HD_ID  numeric,
          @ELE_SUB_BR_ID  numeric,
          @ELE_SUB_NAME  nvarchar(50) ,
          @ELE_SUB_CLASS_ID  numeric,
          @ELE_SUB_STATUS  char(2) ,
          @ELE_SUB_DATETIME  datetime,
          @ELE_SUB_USER  nvarchar(50) 
   
   
     as  begin
   
   
     insert into ELECTIVE_SUBJECT
     values
     (
        @ELE_SUB_HD_ID,
        @ELE_SUB_BR_ID,
        @ELE_SUB_NAME,
        @ELE_SUB_CLASS_ID,
        @ELE_SUB_STATUS,
        @ELE_SUB_DATETIME,
        @ELE_SUB_USER
     
     
     )

	 select SCOPE_IDENTITY()
     
end