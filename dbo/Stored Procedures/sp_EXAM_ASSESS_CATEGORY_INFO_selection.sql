CREATE procedure  [dbo].[sp_EXAM_ASSESS_CATEGORY_INFO_selection]
                                               
                                               
     @STATUS char(1),
     @EXAM_CAT_ID  numeric,
   @EXAM_CAT_HD_ID numeric,
	 @EXAM_CAT_BR_ID numeric,
	 @SessionId numeric
   
     AS BEGIN 
   
   
     if @STATUS = 'L'
     BEGIN
   
			 SELECT ID, Name,[Main Category ID], [Class ID],Description,Status,[Order] FROM VEXAM_ASSESS_CATEGORY_INFO
			where
			[Institute ID] = @EXAM_CAT_HD_ID and
			 [Branch ID] = @EXAM_CAT_BR_ID and
			 [Status] != 'D' 
			 and [Class ID] in (select ID from VSCHOOL_PLANE where [Session Id] = @SessionId)
			 order by [Order]

			Select ID,Name from VSCHOOL_PLANE
			where
			[Institute ID] = @EXAM_CAT_HD_ID and
			 [Branch ID] = @EXAM_CAT_BR_ID and
			 [Status] = 'T' and [Session Id] = @SessionId and [Level] = 1 order by [Order]

			 declare @class_id int =0
			 set @class_id = (select top(1) ID from VSCHOOL_PLANE where [Institute ID] = @EXAM_CAT_HD_ID and
			 [Branch ID] = @EXAM_CAT_BR_ID and
			 [Status] = 'T' and [Session Id] = @SessionId and [Level] = 1) 


			 select -1, 'None'
			 union
			 SELECT  ID,NAME FROM VEXAM_ASSESS_CATEGORY_INFO WHERE 
			 [Institute ID] = @EXAM_CAT_HD_ID and
			 [Branch ID] = @EXAM_CAT_BR_ID and
			 [Status] = 'T' and [Main Category ID] = -1
			 and [Class ID] = @class_id
     END  
     
 
     END