


CREATE procedure [dbo].[rpt_ALL_STUDENTS_Selection]


@CLASS numeric,
@GENDER numeric,
@STATUS char(1),
@BR_ID numeric,
@HD_ID numeric,
@ORDER_BY nvarchar(50)


as

begin




if @Class= 0
	
	
	if @GENDER != 2
	
	
		if @STATUS != 'A'
		BEGIN
			if @ORDER_BY = 'Student No'
			BEGIN
				select [School ID], [Student Name], CASE WHEN Gender = 1 THEN 'Male' ELSE 'Female' END Gender, House,[Status],[Class ID],[Parent Name]  from rpt_V_ALL_STUDENTS_INFORMATION where [Branch ID] in (select * from dbo.get_all_br_id (@BR_ID)) and [Institute ID] in (select * from dbo.get_all_hd_id (@HD_ID)) and 
				Gender = @GENDER and [Status] = @STATUS 
				order by [Class ID], [Sch ID]
			END
			ELSE if @ORDER_BY = 'Student Name'
			BEGIN
				select [School ID], [Student Name], CASE WHEN Gender = 1 THEN 'Male' ELSE 'Female' END Gender, House,[Status],[Class ID]  ,[Parent Name] from rpt_V_ALL_STUDENTS_INFORMATION where [Branch ID] in (select * from dbo.get_all_br_id (@BR_ID)) and [Institute ID] in (select * from dbo.get_all_hd_id (@HD_ID)) and 
				Gender = @GENDER and [Status] = @STATUS 
				order by [Class ID],[Student Name]
			END
			ELSE if @ORDER_BY = 'Class Name'
			BEGIN
				select [School ID], [Student Name], CASE WHEN Gender = 1 THEN 'Male' ELSE 'Female' END Gender, House,[Status],[Class ID]  ,[Parent Name] from rpt_V_ALL_STUDENTS_INFORMATION where [Branch ID] in (select * from dbo.get_all_br_id (@BR_ID)) and [Institute ID] in (select * from dbo.get_all_hd_id (@HD_ID)) and 
				Gender = @GENDER and [Status] = @STATUS 
				order by [Class ID],[Class Name]
			END
			ELSE if @ORDER_BY = 'Gender'
			BEGIN
				select [School ID], [Student Name], CASE WHEN Gender = 1 THEN 'Male' ELSE 'Female' END Gender, House,[Status],[Class ID]  ,[Parent Name] from rpt_V_ALL_STUDENTS_INFORMATION where [Branch ID] in (select * from dbo.get_all_br_id (@BR_ID)) and [Institute ID] in (select * from dbo.get_all_hd_id (@HD_ID)) and 
				Gender = @GENDER and [Status] = @STATUS 
				order by [Class ID],Gender
			END
			ELSE if @ORDER_BY = 'House'
			BEGIN
				select [School ID], [Student Name], CASE WHEN Gender = 1 THEN 'Male' ELSE 'Female' END Gender, House,[Status],[Class ID]  ,[Parent Name] from rpt_V_ALL_STUDENTS_INFORMATION where [Branch ID] in (select * from dbo.get_all_br_id (@BR_ID)) and [Institute ID] in (select * from dbo.get_all_hd_id (@HD_ID)) and 
				Gender = @GENDER and [Status] = @STATUS 
				order by [Class ID],House
			END
		END
		ELSE
		BEGIN

		BEGIN
			if @ORDER_BY = 'Student No'
			BEGIN
				select [School ID], [Student Name], CASE WHEN Gender = 1 THEN 'Male' ELSE 'Female' END Gender, House,[Status],[Class ID]  ,[Parent Name] from rpt_V_ALL_STUDENTS_INFORMATION where [Branch ID] in (select * from dbo.get_all_br_id (@BR_ID)) and [Institute ID] in (select * from dbo.get_all_hd_id (@HD_ID)) and Gender = @GENDER
			and [Status] != 'D'
				order by [Class ID],[Sch ID]
			END
			ELSE if @ORDER_BY = 'Student Name'
			BEGIN
			select [School ID], [Student Name], CASE WHEN Gender = 1 THEN 'Male' ELSE 'Female' END Gender, House,[Status],[Class ID]  ,[Parent Name] from rpt_V_ALL_STUDENTS_INFORMATION where [Branch ID] in (select * from dbo.get_all_br_id (@BR_ID)) and [Institute ID] in (select * from dbo.get_all_hd_id (@HD_ID)) and Gender = @GENDER
			and [Status] != 'D'
				order by [Class ID],[Student Name]
			END
			ELSE if @ORDER_BY = 'Class Name'
			BEGIN
				select [School ID], [Student Name], CASE WHEN Gender = 1 THEN 'Male' ELSE 'Female' END Gender, House,[Status],[Class ID]  ,[Parent Name] from rpt_V_ALL_STUDENTS_INFORMATION where [Branch ID] in (select * from dbo.get_all_br_id (@BR_ID)) and [Institute ID] in (select * from dbo.get_all_hd_id (@HD_ID)) and Gender = @GENDER
			and [Status] != 'D'
				order by [Class ID],[Class Name]
			END
			ELSE if @ORDER_BY = 'Gender'
			BEGIN
				select [School ID], [Student Name], CASE WHEN Gender = 1 THEN 'Male' ELSE 'Female' END Gender, House,[Status],[Class ID]  ,[Parent Name] from rpt_V_ALL_STUDENTS_INFORMATION where [Branch ID] in (select * from dbo.get_all_br_id (@BR_ID)) and [Institute ID] in (select * from dbo.get_all_hd_id (@HD_ID)) and Gender = @GENDER
			and [Status] != 'D'
				order by [Class ID],Gender
			END
			ELSE if @ORDER_BY = 'House'
			BEGIN
				select [School ID], [Student Name], CASE WHEN Gender = 1 THEN 'Male' ELSE 'Female' END Gender, House,[Status],[Class ID]  ,[Parent Name] from rpt_V_ALL_STUDENTS_INFORMATION where [Branch ID] in (select * from dbo.get_all_br_id (@BR_ID)) and [Institute ID] in (select * from dbo.get_all_hd_id (@HD_ID)) and Gender = @GENDER
			and [Status] != 'D'
				order by [Class ID],House
			END
		END

			
			
		END
		
	
	else
		if @STATUS != 'A'
			--if @ORDER_BY = 'Student No' OR @ORDER_BY = 'Class ID'
		select [School ID], [Student Name], CASE WHEN Gender = 1 THEN 'Male' ELSE 'Female' END Gender, House,[Status],[Class ID]  ,[Parent Name] from rpt_V_ALL_STUDENTS_INFORMATION
		 where [Branch ID] in (select * from dbo.get_all_br_id (@BR_ID)) and [Institute ID] in (select * from dbo.get_all_hd_id (@HD_ID))  and [Status] = @STATUS 
		  order by  CASE WHEN @ORDER_BY != 'Class Name' THEN [Class ID] END, CASE WHEN @ORDER_BY = 'Student No' THEN [Sch ID] END, CASE WHEN @ORDER_BY = 'Student Name' THEN [Student Name] WHEN @ORDER_BY = 'Class Name' THEN [Class Name] WHEN @ORDER_BY = 'House' THEN House END, CASE WHEN @ORDER_BY = 'Gender' THEN Gender END
		
		else
		select [School ID], [Student Name], CASE WHEN Gender = 1 THEN 'Male' ELSE 'Female' END Gender, House,[Status],[Class ID]  ,[Parent Name] from rpt_V_ALL_STUDENTS_INFORMATION 
		where [Branch ID] in (select * from dbo.get_all_br_id (@BR_ID)) and [Institute ID] in (select * from dbo.get_all_hd_id (@HD_ID)) and [Status] != 'D'
		  order by CASE WHEN @ORDER_BY != 'Class Name' THEN [Class ID] END, CASE WHEN @ORDER_BY = 'Student No' THEN [Sch ID] END, CASE WHEN @ORDER_BY = 'Student Name' THEN [Student Name] WHEN @ORDER_BY = 'Class Name' THEN [Class Name] WHEN @ORDER_BY = 'House' THEN House END, CASE WHEN @ORDER_BY = 'Gender' THEN Gender END
	--select [School ID], [Student Name], CASE WHEN Gender = 0 THEN 'Male' ELSE 'Female' END Gender, House,[Status],[Class ID]  ,[Parent Name] from rpt_V_ALL_STUDENTS_INFORMATION where [Branch ID] = @BR_ID and [Institute ID] = @HD_ID and [Status] != 'D'



else
	
	if @GENDER != 2	
	
		if @STATUS != 'A'
		select [School ID], [Student Name], CASE WHEN Gender = 1 THEN 'Male' ELSE 'Female' END Gender, House,[Status],[Class ID]  ,[Parent Name] from rpt_V_ALL_STUDENTS_INFORMATION 
		where [Branch ID] in (select * from dbo.get_all_br_id (@BR_ID)) and [Institute ID] in (select * from dbo.get_all_hd_id (@HD_ID)) and 
		Gender = @GENDER and [Status] = @STATUS and [Class ID] = @CLASS 
		 order by CASE WHEN @ORDER_BY != 'Class Name' THEN [Class ID] END, CASE WHEN @ORDER_BY = 'Student No' THEN [Sch ID] END, CASE WHEN @ORDER_BY = 'Student Name' THEN [Student Name] WHEN @ORDER_BY = 'Class Name' THEN [Class Name] WHEN @ORDER_BY = 'House' THEN House END, CASE WHEN @ORDER_BY = 'Gender' THEN Gender END
		
		else
		select [School ID], [Student Name], CASE WHEN Gender = 1 THEN 'Male' ELSE 'Female' END Gender, House,[Status],[Class ID]  ,[Parent Name] from rpt_V_ALL_STUDENTS_INFORMATION where [Branch ID] in (select * from dbo.get_all_br_id (@BR_ID)) and [Institute ID] in (select * from dbo.get_all_hd_id (@HD_ID)) and Gender = @GENDER
		and [Status] != 'D' and [Class ID] = @CLASS 
		 order by CASE WHEN @ORDER_BY != 'Class Name' THEN [Class ID] END, CASE WHEN @ORDER_BY = 'Student No' THEN [Sch ID] END, CASE WHEN @ORDER_BY = 'Student Name' THEN [Student Name] WHEN @ORDER_BY = 'Class Name' THEN [Class Name] WHEN @ORDER_BY = 'House' THEN House END, CASE WHEN @ORDER_BY = 'Gender' THEN Gender END
		
	else
		if @STATUS != 'A'
		select [School ID], [Student Name], CASE WHEN Gender = 1 THEN 'Male' ELSE 'Female' END Gender, House,[Status],[Class ID]  ,[Parent Name] from rpt_V_ALL_STUDENTS_INFORMATION where [Branch ID] in (select * from dbo.get_all_br_id (@BR_ID)) and [Institute ID] in (select * from dbo.get_all_hd_id (@HD_ID))  and [Status] = @STATUS
		and [Class ID] = @CLASS 
		 order by CASE WHEN @ORDER_BY != 'Class Name' THEN [Class ID] END, CASE WHEN @ORDER_BY = 'Student No' THEN [Sch ID] END, CASE WHEN @ORDER_BY = 'Student Name' THEN [Student Name] WHEN @ORDER_BY = 'Class Name' THEN [Class Name] WHEN @ORDER_BY = 'House' THEN House END, CASE WHEN @ORDER_BY = 'Gender' THEN Gender END
		
		else
		select [School ID], [Student Name], CASE WHEN Gender = 1 THEN 'Male' ELSE 'Female' END Gender, House,[Status],[Class ID]  ,[Parent Name] from rpt_V_ALL_STUDENTS_INFORMATION 	where [Branch ID] in (select * from dbo.get_all_br_id (@BR_ID)) and [Institute ID] in (select * from dbo.get_all_hd_id (@HD_ID)) and [Class ID] = @CLASS
		and [Status] != 'D' 
		 order by CASE WHEN @ORDER_BY != 'Class Name' THEN [Class ID] END, CASE WHEN @ORDER_BY = 'Student No' THEN [Sch ID] END, CASE WHEN @ORDER_BY = 'Student Name' THEN [Student Name] WHEN @ORDER_BY = 'Class Name' THEN [Class Name] WHEN @ORDER_BY = 'House' THEN House END, CASE WHEN @ORDER_BY = 'Gender' THEN Gender END
	







--begin

--	if 
--	@Class != 'ALL'
	
--	and
	
--	@SelectBy='All'
	
--	select * from rpt_V_ALL_STUDENTS_INFORMATION
--	where [Class ID]=@Class 

--end











--begin

--if @Class='All'


--begin
--		if
--			@SelectBy='Transport'
--			select * from rpt_V_ALL_STUDENTS_INFORMATION
--			where Transport=@Values 
--end	

--begin		
--		if
--			@SelectBy='Gender'
--			select * from rpt_V_ALL_STUDENTS_INFORMATION
--			where Gender=@Values
--end			
		
--begin		
		
--		if 
--			@SelectBy='Student DOB'
--			select * from rpt_V_ALL_STUDENTS_INFORMATION
--			where [Student DOB]=@Values
--end



--end













--begin

--if @Class!='All'


--begin
--		if
--			@SelectBy='Transport'
--			select * from rpt_V_ALL_STUDENTS_INFORMATION
--			where [Class ID]=@Class and Transport=@Values 
--end	

--begin		
--		if
--			@SelectBy='Gender'
--			select * from rpt_V_ALL_STUDENTS_INFORMATION
--			where [Class ID]=@Class and Gender=@Values
--end			
		
--begin		
		
--		if 
--			@SelectBy='Student DOB'
--			select * from rpt_V_ALL_STUDENTS_INFORMATION
--			where [Class ID]=@Class and [Student DOB]=@Values
--end



--end


















end