
CREATE PROC usp_StudentAttendanceInsertion

@BrId numeric,
@ClassId numeric,
@SubjectId numeric,
@AttendanceDate date,
@CreatedBy numeric,
@AttendanceRemarks nvarchar(max)


AS


declare @AttendanceStudentMasterId  numeric = 0

select @AttendanceStudentMasterId = ISNULL(Id,0) from AttendanceStudentMaster where ClassId = @ClassId and AttendanceDate = @AttendanceDate


if @AttendanceStudentMasterId = 0
BEGIN
	insert into AttendanceStudentMaster
	select @BrId, @ClassId,@SubjectId, @AttendanceDate, '','',GETDATE(), @CreatedBy, NULL,NULL
	set @AttendanceStudentMasterId = SCOPE_IDENTITY()
END
ELSE
BEGIN
	update AttendanceStudentMaster set UpdatedDate = GETDATE(), UpdatedBy = @CreatedBy
	where ClassId = @ClassId and AttendanceDate = @AttendanceDate
END

declare @tbl table (StdId numeric, Remarks nvarchar(50), PId numeric)


	 WHILE LEN(@AttendanceRemarks) >0
	 BEGIN
		declare @IEntry nvarchar(200) = ''
		IF CHARINDEX(',', @AttendanceRemarks) > 0
		BEGIN
			set @IEntry = SUBSTRING(@AttendanceRemarks,0,CHARINDEX(',',@AttendanceRemarks))
		END	
		ELSE
		BEGIN
			set @IEntry = @AttendanceRemarks
			set @AttendanceRemarks = ''
		END

			declare @Id numeric  = 0, @Remarks nvarchar(10)
			set @Id = CAST(SUBSTRING(@IEntry,1,CHARINDEX('-',@IEntry) - 1)  as numeric)
			set @Remarks = SUBSTRING(@IEntry,CHARINDEX('-',@IEntry) +1,LEN(@IEntry) - CHARINDEX('-',@IEntry))
			insert into @tbl 
			select @Id, @Remarks,@AttendanceStudentMasterId
			set @AttendanceRemarks = REPLACE(@AttendanceRemarks,@IEntry + ',','')
		
	 END


		  MERGE INTO AttendanceStudentDetail AS Target
		USING @tbl AS Source
		ON Target.PId = Source.PId and Target.StdId = Source.StdId 
		WHEN MATCHED THEN
			UPDATE SET Target.Remarks = Source.Remarks
		WHEN NOT MATCHED THEN           
			INSERT (PId,StdId,Remarks)
			VALUES (Source.PId, Source.StdId,Source.Remarks);




select t.Remarks, s.STDNT_FIRST_NAME StudentName, p.PARNT_FIRST_NAME ParentName, p.PARNT_CELL_NO ParentMobileNo, s.STDNT_BR_ID BrId,t.StdId, u.USER_ID UserId from @tbl t
join STUDENT_INFO s on s.STDNT_ID = t.StdId
join PARENT_INFO p on p.PARNT_ID = s.STDNT_PARANT_ID
join USER_INFO u on u.USER_ID = t.StdId and u.USER_TYPE = 'Student'