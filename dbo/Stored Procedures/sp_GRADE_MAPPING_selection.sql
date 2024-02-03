CREATE procedure  [dbo].[sp_GRADE_MAPPING_selection]
                                               
                                               
     @STATUS char(10),
     @GRADE_MAP_ID  numeric,
     @GRADE_MAP_HD_ID  numeric,
     @GRADE_MAP_BR_ID  numeric
   
   
     AS BEGIN 
     
     
     --declare @STATUS char(10) = 'A'
     --declare @GRADE_MAP_ID  numeric = 0
     --declare @GRADE_MAP_HD_ID  numeric = 2
     --declare @GRADE_MAP_BR_ID  numeric = 1
     
	--declare @count_grade_mapping int = 0
	declare @plan_count int = 0
	declare @grade_plan_count int = 0
	declare @grade_plan_id int
	declare @class_plan_id int = 0
	declare @i int = 1
	declare @t table (id int)
	--set @count_grade_mapping = (select COUNT(*) from GRADE_MAPPING where GRADE_MAP_BR_ID = @GRADE_MAP_BR_ID and GRADE_MAP_HD_ID = @GRADE_MAP_HD_ID)
	set @plan_count = (select COUNT(*) from SCHOOL_PLANE where CLASS_STATUS = 'T' and CLASS_ID not in (select GRADE_MAP_CLASS_ID from GRADE_MAPPING where GRADE_MAP_BR_ID = @GRADE_MAP_BR_ID and GRADE_MAP_HD_ID = @GRADE_MAP_HD_ID) and CLASS_HD_ID = @GRADE_MAP_HD_ID and CLASS_BR_ID = @GRADE_MAP_BR_ID)
	set @grade_plan_count = (select COUNT(*) from PLAN_GRADE where P_GRADE_STATUS = 'T' and P_GRADE_HD_ID = @GRADE_MAP_HD_ID and P_GRADE_BR_ID = @GRADE_MAP_BR_ID)
	set @grade_plan_id = (select top(1) P_GRADE_ID from PLAN_GRADE where P_GRADE_HD_ID = @GRADE_MAP_HD_ID and P_GRADE_BR_ID = @GRADE_MAP_BR_ID)
	
	if @grade_plan_count != 0 and @plan_count != 0
	begin
			
		while @i <= @plan_count
		begin
			set @class_plan_id = 0
			select @class_plan_id = a.[Class ID] from (select ROW_NUMBER() over( order by (select CLASS_ID)) as sr, CLASS_ID as 
			[Class ID]from SCHOOL_PLANE where CLASS_HD_ID = @GRADE_MAP_HD_ID and CLASS_BR_ID = @GRADE_MAP_BR_ID
			and CLASS_STATUS = 'T' and CLASS_ID not in (select GRADE_MAP_CLASS_ID from GRADE_MAPPING 
			where GRADE_MAP_BR_ID = @GRADE_MAP_BR_ID and GRADE_MAP_HD_ID = @GRADE_MAP_HD_ID))a where a.sr = @i
			--select @class_plan_id
			insert into @t values (@class_plan_id)
			--select @class_plan_id
			--insert into GRADE_MAPPING select @GRADE_MAP_HD_ID, @GRADE_MAP_BR_ID, @class_plan_id, @grade_plan_id, 'T'
			set @i = @i + 1
			
		end
		--select * from @t
		set @i = 1
		set @plan_count = (select COUNT(*) from @t)
		
		while @i <= @plan_count
		begin
			set @class_plan_id = (select id from (select ROW_NUMBER() over( order by (select 0)) as sr, id from @t)b where sr = @i )
			--select @class_plan_id
			insert into GRADE_MAPPING select @GRADE_MAP_HD_ID, @GRADE_MAP_BR_ID, @class_plan_id, @grade_plan_id, 'T'
			set @i = @i + 1
		end
		
		
	end
	
     if @STATUS = 'A'
     BEGIN   
    --select * from @t
     SELECT ID, [Class Name],[Grade Plan],Status FROM V_GRADE_PLAN_SCHOOL
     
     where [Institute ID] = @GRADE_MAP_HD_ID and 
     [Branch ID]= @GRADE_MAP_BR_ID
     and Status  !='D'
     
     
     select PLAN_GRADE.P_GRADE_ID as ID ,PLAN_GRADE.P_GRADE_PLAN_NAME as [Grade Name] from PLAN_GRADE
     
     where PLAN_GRADE.P_GRADE_HD_ID =  @GRADE_MAP_HD_ID and
     PLAN_GRADE.P_GRADE_BR_ID=@GRADE_MAP_BR_ID and
     PLAN_GRADE.P_GRADE_STATUS != 'D' 
     
     END  
     ELSE
     BEGIN
  SELECT * FROM GRADE_MAPPING
 
 
     WHERE
--     STATUS =  @STATUS and 
     GRADE_MAP_ID =  @GRADE_MAP_ID and 
     GRADE_MAP_HD_ID =  @GRADE_MAP_HD_ID and 
     GRADE_MAP_BR_ID =  @GRADE_MAP_BR_ID 
 
     END
 
     END