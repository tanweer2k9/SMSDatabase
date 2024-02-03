create procedure  [dbo].[sp_SUBJECT_GRADE_INFO_updation]
                                               
                                               
          @SUB_GRADE_ID  numeric,
          @SUB_GRADE_HD_ID  numeric,
          @SUB_GRADE_BR_ID  numeric,
          @SUB_GRADE_NAME  nvarchar(50) ,
          @SUB_GRADE_DESC  nvarchar(500) ,
          @SUB_GRADE_STATUS  char(2) 
   
   
     as begin 
   
   
     update SUBJECT_GRADE_INFO
 
     set
          SUB_GRADE_NAME =  @SUB_GRADE_NAME,
          SUB_GRADE_DESC =  @SUB_GRADE_DESC,
          SUB_GRADE_STATUS =  @SUB_GRADE_STATUS
 
     where 
          SUB_GRADE_ID =  @SUB_GRADE_ID and 
          SUB_GRADE_HD_ID =  @SUB_GRADE_HD_ID and 
          SUB_GRADE_BR_ID =  @SUB_GRADE_BR_ID 
 
end