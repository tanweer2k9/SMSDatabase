CREATE procedure  [dbo].[sp_EXAM_APPROVAL_STATUS_updation]
                                               
                                               
          @EXAM_APPROVAL_PLAN_EXAM_ID  int,
          @EXAM_APPROVAL_RANKWISE_STATUS  nvarchar(100) 
   
   
     as begin 
   
   
     update EXAM_APPROVAL_STATUS
 
     set
          EXAM_APPROVAL_RANKWISE_STATUS =  @EXAM_APPROVAL_RANKWISE_STATUS
	WHERE EXAM_APPROVAL_PLAN_EXAM_ID =  @EXAM_APPROVAL_PLAN_EXAM_ID
end