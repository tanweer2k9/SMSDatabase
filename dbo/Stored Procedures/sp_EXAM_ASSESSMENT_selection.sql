CREATE PROC [dbo].[sp_EXAM_ASSESSMENT_selection]
	 
	 
	 @STATUS char(10),     
	 @HD_ID numeric,
	 @BR_ID numeric,
     @CLASS_ID numeric,
	 @STD_ID numeric,
	 @PID numeric

	 AS


	 select * from VEXAM_ASSESS_CATEGORY_INFO where [Institute ID] = @HD_ID and [Branch ID] = @BR_ID and [Class ID] = @CLASS_ID order by [Order]
	 
	  select ecc.CAT_CRITERIA_ID [Criteria ID],ecc.CAT_CRITERIA_NAME [Question],CASE when eck.CRITERIA_KEY_PRINCIPAL is null THEN eck.CRITERIA_KEY ELSE eck.CRITERIA_KEY_PRINCIPAL END as [key],ecc.CAT_CRITERIA_EXAM_CAT_ID [Category ID],T.TERM_ASSESS_ID [Term ID]  from EXAM_CATEGORY_CRITERIA ecc
	 join EXAM_CRITERIA_KEY eck on eck.CRITERIA_KEY_CAT_CRITERIA_ID = ecc.CAT_CRITERIA_ID and eck.CRITERIA_KEY_CLASS_ID = @CLASS_ID
	 join TERM_ASSESSMENT_INFO t on t.TERM_ASSESS_ID = eck.CRITERIA_KEY_TERM_ID and t.TERM_ASSESS_STATUS = 'T'
	 where eck.CRITERIA_KEY_STD_ID = @STD_ID and eck.CRITERIA_KEY_PID = @PID  order by [Criteria ID]

	 select ID, Name, [Rank] from VTERM_ASSESSMENT_INFO where [Institute ID] = @HD_ID and [Branch ID] =  @BR_ID 
	and [Start Date] < GETDATE() and Status = 'T'