CREATE procedure  [dbo].[sp_EXAM_CATEGORY_CRITERIA_selection]
                                               
                                               
      @STATUS char(1),
     @CAT_CRITERIA_ID  numeric,
     @CAT_CRITERIA_HD_ID numeric,
	 @CAT_CRITERIA_BR_ID numeric,
	 @CLASS_ID numeric,
	 @CATEGORY_ID numeric,
	 @SessionId numeric
   
     AS BEGIN 
   
   declare @one int = 1
     if @STATUS = 'L'
     BEGIN
   
		   SELECT * FROM vEXAM_CATEGORY_CRITERIA 
		   where
		   [Institute ID] = @CAT_CRITERIA_HD_ID and
			 [Branch ID] = @CAT_CRITERIA_BR_ID and
			 [Status] != 'D'


			Select ID,Name from VSCHOOL_PLANE  
			where
			
			[Institute ID] = @CAT_CRITERIA_HD_ID and
			 [Branch ID] = @CAT_CRITERIA_BR_ID and
			 [Status] = 'T' and ID in (select EXAM_CAT_CLASS_ID from EXAM_ASSESS_CATEGORY_INFO where EXAM_CAT_HD_ID = @CAT_CRITERIA_HD_ID and EXAM_CAT_BR_ID = @CAT_CRITERIA_BR_ID and EXAM_CAT_STATUS = 'T')
			 and [Session Id] = @SessionId and [Level] = 1 order by [Order]

			 IF @CLASS_ID = 0
			 set @class_id = (select top(@one) ID from VSCHOOL_PLANE where [Institute ID] = @CAT_CRITERIA_HD_ID and [Branch ID] = @CAT_CRITERIA_BR_ID and
			 [Status] = 'T')
			 
			 IF @cATEGORY_ID = 0
			 set @category_id = (select top(@one) ID from VEXAM_ASSESS_CATEGORY_INFO where [Institute ID] = @CAT_CRITERIA_HD_ID and
			 [Branch ID] = @CAT_CRITERIA_BR_ID and
			 [Status] = 'T') 

			 
			
			 

			  SELECT  ID,NAME,[Class ID], [Main Category ID]  FROM VEXAM_ASSESS_CATEGORY_INFO 
			  WHERE 
			 [Institute ID] = @CAT_CRITERIA_HD_ID and
			 [Branch ID] = @CAT_CRITERIA_BR_ID and [MAIN Category ID]= -1 and
			 Status = 'T'

			
			 
			 SELECT  ID,NAME,[Main Category ID]  FROM VEXAM_ASSESS_CATEGORY_INFO 
			 WHERE 
			 [Institute ID] = @CAT_CRITERIA_HD_ID and
			 [Branch ID] = @CAT_CRITERIA_BR_ID and 
			 Status = 'T'
			 

			 

     END  
     
 
     END