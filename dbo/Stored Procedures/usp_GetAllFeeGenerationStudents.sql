

CREATE PROC [dbo].[usp_GetAllFeeGenerationStudents]

  
  @FEE_COLLECT_BR_ID numeric,
  @IS_COMBINE_BRANCHES bit,
  @status char(1),
  @FEE_COLLECT_PLAN_ID numeric,
  @FEE_COLLECT_FEE_FROM_DATE date,
  @FEE_COLLECT_FEE_TO_DATE date 

AS

		declare @class_plan_id_nvarchar nvarchar(50) = '%'
		declare @parent_id_nvarchar nvarchar(50) = '%'

		 declare @meesage nvarchar(MAX) = ''
		declare @tblTotalStudents table (Sr int identity(1,1),STDNT_ID numeric, STDNT_SCHOOL_ID nvarchar(20),STDNT_CLASS_PLANE_ID numeric,STDNT_CLASS_FEE_ID numeric,STDNT_BR_ID numeric, ToMonth int)

		 IF @status = 'C' or @status = 'F'--IF @status is 'F' then  it is parent id
		 BEGIN
			if @status = 'C'
			BEGIN
				set @class_plan_id_nvarchar = CAST(@FEE_COLLECT_PLAN_ID as nvarchar(50))
			END
			ELSE
			BEGIN
				set @parent_id_nvarchar = CAST(@FEE_COLLECT_PLAN_ID as nvarchar(50)) 
			END
			insert into @tblTotalStudents
			select Distinct (STDNT_ID) [Student ID],s.STDNT_SCHOOL_ID,s.STDNT_CLASS_PLANE_ID, STDNT_CLASS_FEE_ID, STDNT_BR_ID,ToMonth  from STUDENT_INFO s
			join PLAN_FEE f on f.PLAN_FEE_ID = s.STDNT_CLASS_FEE_ID
			join FeeYearlyPlanDef yd on yd.PId = f.PLAN_FEE_YEARLY_PLAN_ID and IsDeleted = 0 and FromMonth = DATEPART(MM, @FEE_COLLECT_FEE_FROM_DATE)
			where  STDNT_CLASS_PLANE_ID like @class_plan_id_nvarchar and STDNT_PARANT_ID like @parent_id_nvarchar  and STDNT_STATUS = 'T'  and f.PLAN_FEE_IS_FEE_GENERATE = 1
		END
		ELSE IF @status = 'M'
			BEGIN
			declare @tbl_br_id table (BR_ID int)
			if @IS_COMBINE_BRANCHES = 1
			BEGIN
				insert into @tbl_br_id
				select COMBINE_BRANCHES_ID from COMBINE_BRANCHES where FROM_BRANCH_ID  = @FEE_COLLECT_BR_ID
			END
			ELSE
			BEGIN
				insert into @tbl_br_id
				select @FEE_COLLECT_BR_ID
			END

			if @FEE_COLLECT_BR_ID = 4 and @FEE_COLLECT_FEE_FROM_DATE = '2021-11-01'
			BEGIN
				insert into @tblTotalStudents
				select Distinct (STDNT_ID) [Student ID],STDNT_SCHOOL_ID,s.STDNT_CLASS_PLANE_ID, STDNT_CLASS_FEE_ID, STDNT_BR_ID,ToMonth from STUDENT_INFO s
				join PLAN_FEE f on f.PLAN_FEE_ID = s.STDNT_CLASS_FEE_ID 
				join FeeYearlyPlanDef yd on yd.PId = f.PLAN_FEE_YEARLY_PLAN_ID and IsDeleted = 0 and FromMonth = DATEPART(MM, @FEE_COLLECT_FEE_FROM_DATE)
				where  STDNT_BR_ID in ( select BR_ID from @tbl_br_id) and STDNT_STATUS = 'T'  and f.PLAN_FEE_IS_FEE_GENERATE = 1 and s.STDNT_ID in (select STDNT_ID from STUDENT_INFO where STDNT_ID not in (select FEE_COLLECT_STD_ID from FEE_COLLECT with (nolock) where FEE_COLLECT_BR_ID = 4 and FEE_COLLECT_FEE_FROM_DATE = '2021-11-01'  ) and STDNT_BR_ID = 4 and STDNT_STATUS = 'T' and STDNT_CLASSES_START_DATE <='2021-10-23') 
			END
			ELSE
			BEGIN
				insert into @tblTotalStudents
				select Distinct (STDNT_ID) [Student ID],STDNT_SCHOOL_ID,s.STDNT_CLASS_PLANE_ID, STDNT_CLASS_FEE_ID, STDNT_BR_ID,ToMonth from STUDENT_INFO s
				join PLAN_FEE f on f.PLAN_FEE_ID = s.STDNT_CLASS_FEE_ID 
				join FeeYearlyPlanDef yd on yd.PId = f.PLAN_FEE_YEARLY_PLAN_ID and IsDeleted = 0 and FromMonth = DATEPART(MM, @FEE_COLLECT_FEE_FROM_DATE)
				where  STDNT_BR_ID in ( select BR_ID from @tbl_br_id) and STDNT_STATUS = 'T'  and f.PLAN_FEE_IS_FEE_GENERATE = 1
			END
		END


		declare @k int =1 
		declare @total_student int = 0
		select @total_student = count(*) from @tblTotalStudents

		declare @std_max_date_end date = ''
       declare @std_max_date_start date = ''
	   declare @one int = 1
	  

		while @k <= @total_student									
		begin
			declare @FEE_COLLECT_STD_ID numeric = 0, @STDNT_SCHOOL_ID nvarchar(20)
									
			select @FEE_COLLECT_FEE_TO_DATE = EOMONTH(DATEFROMPARTS(DATEPART(YYYY,@FEE_COLLECT_FEE_FROM_DATE),ToMonth,1)) ,@FEE_COLLECT_STD_ID = STDNT_ID ,@STDNT_SCHOOL_ID = STDNT_SCHOOL_ID,@FEE_COLLECT_BR_ID = STDNT_BR_ID from @tblTotalStudents where Sr = @k

			select top(@one) @std_max_date_end = max(FEE_COLLECT_FEE_TO_DATE) from FEE_COLLECT where   FEE_COLLECT_BR_ID = @FEE_COLLECT_BR_ID and FEE_COLLECT_STD_ID = @FEE_COLLECT_STD_ID
				if @std_max_date_end is not null
					begin
						select @std_max_date_start = FEE_COLLECT_FEE_FROM_DATE from FEE_COLLECT where FEE_COLLECT_FEE_TO_DATE = @std_max_date_end  and  FEE_COLLECT_BR_ID = @FEE_COLLECT_BR_ID and FEE_COLLECT_STD_ID = @FEE_COLLECT_STD_ID
					end
					else
					begin
						select @std_max_date_start = (DATEADD(MM,-1, @FEE_COLLECT_FEE_FROM_DATE))
					end
				set @std_max_date_end = (select ISNULL(@std_max_date_end, (DATEADD(MM,-1, @FEE_COLLECT_FEE_FROM_DATE))))
									
			if not (DATEADD(MM, DATEDIFF(MM, 0,@std_max_date_end),0) between DATEADD(MM, DATEDIFF(MM, 0,@FEE_COLLECT_FEE_FROM_DATE),0) and DATEADD(MM, DATEDIFF(MM, 0,@FEE_COLLECT_FEE_TO_DATE),0) and DATEADD(MM, DATEDIFF(MM, 0,@std_max_date_start),0) between DATEADD(MM, DATEDIFF(MM, 0,@FEE_COLLECT_FEE_FROM_DATE),0) and DATEADD(MM, DATEDIFF(MM, 0, @FEE_COLLECT_FEE_TO_DATE),0) and DATEADD(MM, DATEDIFF(MM, 0, @std_max_date_start),0) <= DATEADD(MM, DATEDIFF(MM, 0, @FEE_COLLECT_FEE_FROM_DATE),0) or DATEADD(MM, DATEDIFF(MM, 0,@FEE_COLLECT_FEE_FROM_DATE),0) = DATEADD(MM, DATEDIFF(MM, 0,DATEADD(MM,1,@std_max_date_end)), 0))
			begin
				set @meesage = @meesage + @STDNT_SCHOOL_ID + ' '
			end
			set @k = @k +1
		end -- end while loop


		select * from @tblTotalStudents

		select @meesage Message