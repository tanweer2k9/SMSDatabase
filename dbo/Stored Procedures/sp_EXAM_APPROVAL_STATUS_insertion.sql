create procedure  [dbo].[sp_EXAM_APPROVAL_STATUS_insertion]
                                               
                                               
          @EXAM_APPROVAL_PLAN_EXAM_ID  int,
          @EXAM_APPROVAL_RANKWISE_STATUS  nvarchar(100) 
   
   
     as  begin
   
   
     insert into EXAM_APPROVAL_STATUS
     values
     (
        @EXAM_APPROVAL_PLAN_EXAM_ID,
        @EXAM_APPROVAL_RANKWISE_STATUS
     
     
     )
     
end