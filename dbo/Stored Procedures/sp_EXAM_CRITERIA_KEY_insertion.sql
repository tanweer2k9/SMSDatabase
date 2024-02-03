CREATE procedure  [dbo].[sp_EXAM_CRITERIA_KEY_insertion]
                                               
                                               
          @dt_key dbo.[type_EXAM_CRITERIA_KEY] readonly,
		  @EXAM_STD_INFO_STD_ID  numeric ,
          @EXAM_STD_INFO_HEIGHT  float,
          @EXAM_STD_INFO_WEIGHT  float,
          @EXAM_STD_INFO_DAYS_ATTENDED  int,
          @EXAM_STD_INFO_DAYS_ABSENT  int,
          @EXAM_STD_CLASS_ID  numeric,
          @EXAM_STD_TEACHER_COMMENT  nvarchar(500),
		  @EXAM_STD_PRINCIPAL_COMMENT  nvarchar(500),
		  @EXAM_STD_DISAPPROVE bit,
		  @USER_PK_ID numeric,
		  @Title nvarchar(500),
		  @TitleDate date,
		  @HdId numeric,
		  @BrId numeric,
		  @EXAM_STD_COMPLETE_CITRIX nvarchar(500),
		  @EXAM_STD_CITRIX_ENGLISH_SCORE nvarchar(500),
		  @EXAM_STD_CITRIX_MATH_SCORE nvarchar(500),
		  @EXAM_STD_CITRIX_URDU_SCORE nvarchar(500)
   
   
     as  begin
   
   declare @SessionId numeric = 0
	set @SessionId = (select CLASS_SESSION_ID from SCHOOL_PLANE where CLASS_ID = @EXAM_STD_CLASS_ID)

   	declare @PID numeric = 0
	set @PID = ISNULL((select Id from EXAM_CRITERIA_KEY_Parent where Title = @Title and BrId = @BrId and SessionId = @SessionId),0)
	
	



	delete from EXAM_CRITERIA_KEY where CRITERIA_KEY_CLASS_ID = @EXAM_STD_CLASS_ID and CRITERIA_KEY_STD_ID = @EXAM_STD_INFO_STD_ID and CRITERIA_KEY_TERM_ID in (select distinct [Term ID] from @dt_key) and			CRITERIA_KEY_PID = @PID

	--delete from EXAM_STD_INFO where EXAM_STD_CLASS_ID = @EXAM_STD_CLASS_ID and EXAM_STD_INFO_STD_ID = @EXAM_STD_INFO_STD_ID
	


	if @PID = 0
	BEGIN
		insert into EXAM_CRITERIA_KEY_Parent
		select @HdId,@BrId,@Title,@SessionId,@USER_PK_ID,GETDATE(),NULL,NULL
		set @PID = SCOPE_IDENTITY()
	END
	

     insert into EXAM_CRITERIA_KEY
     select *,@PID from @dt_key

	-- MERGE EXAM_CRITERIA_KEY AS TargetTable 
	--USING @dt_key AS SourceTable  ON (TargetTable. = SourceTable.id)
	--WHEN NOT MATCHED THEN INSERT (id,name) VALUES (SourceTable.id,SourceTable.name)
	--WHEN MATCHED THEN UPDATE SET TargetTable.NAME = SourceTable.NAME;

	
	declare @count int = 0

	set @count = (select COUNT(*) from EXAM_STD_INFO where EXAM_STD_CLASS_ID = @EXAM_STD_CLASS_ID and EXAM_STD_INFO_STD_ID = @EXAM_STD_INFO_STD_ID and EXAM_STD_PID = @PID)

	if @count = 0
	BEGIN
	 insert into EXAM_STD_INFO
     values
     (
        @EXAM_STD_INFO_STD_ID,
        @EXAM_STD_INFO_HEIGHT,
        @EXAM_STD_INFO_WEIGHT,
        @EXAM_STD_INFO_DAYS_ATTENDED,
        @EXAM_STD_INFO_DAYS_ABSENT,
        @EXAM_STD_CLASS_ID,
        @EXAM_STD_TEACHER_COMMENT,
		@EXAM_STD_PRINCIPAL_COMMENT,
		@EXAM_STD_DISAPPROVE,
		@PID,
		@EXAM_STD_COMPLETE_CITRIX,
		@EXAM_STD_CITRIX_ENGLISH_SCORE,
		@EXAM_STD_CITRIX_MATH_SCORE,
		@EXAM_STD_CITRIX_URDU_SCORE,
		@USER_PK_ID,
		GETDATE(),		
		NULL,
		NULL
     )
	END
	ELSE
	BEGIN
		update EXAM_STD_INFO 
		set 
		EXAM_STD_INFO_HEIGHT = @EXAM_STD_INFO_HEIGHT,
		EXAM_STD_INFO_WEIGHT = @EXAM_STD_INFO_WEIGHT,
		EXAM_STD_INFO_DAYS_ATTENDED =  @EXAM_STD_INFO_DAYS_ATTENDED,
        EXAM_STD_INFO_DAYS_ABSENT = @EXAM_STD_INFO_DAYS_ABSENT,        
        EXAM_STD_TEACHER_COMMENT = @EXAM_STD_TEACHER_COMMENT,
		EXAM_STD_PRINCIPAL_COMMENT = @EXAM_STD_PRINCIPAL_COMMENT,
		EXAM_STD_IS_DISAPPROVE = @EXAM_STD_DISAPPROVE,
		EXAM_STD_COMPLETE_CITRIX = @EXAM_STD_COMPLETE_CITRIX,
		EXAM_STD_CITRIX_ENGLISH_SCORE = @EXAM_STD_CITRIX_ENGLISH_SCORE,
		EXAM_STD_CITRIX_MATH_SCORE = @EXAM_STD_CITRIX_MATH_SCORE,
		EXAM_STD_CITRIX_URDU_SCORE = @EXAM_STD_CITRIX_URDU_SCORE,
		UpdatedBy = @USER_PK_ID,
		UpdatedDate = GETDATE()
		where  EXAM_STD_CLASS_ID = @EXAM_STD_CLASS_ID and EXAM_STD_INFO_STD_ID = @EXAM_STD_INFO_STD_ID and EXAM_STD_PID = @PID
	END
	

	 select 'ok'
     
end