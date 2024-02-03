CREATE function [dbo].[get_centralized_br_id]( @status char(2),@br_id numeric )
returns  @t table ([BR ID] int)


as
begin

--declare @t table ([BR ID] int)
--declare @status char = 'S'
--declare @br_id int = 0
	
declare @centra_br int = 0
declare @centra_wtih int = 0
declare @centra_child int = 0
declare @count_centr_child int = 0
declare @i int = 1
	

if @br_id = 0
begin
	insert into @t select BR_ADM_ID from BR_ADMIN
end

else
begin

	if @status = 'P'
	begin
		select @centra_wtih = BR_ADM_PARENT_CENT_BR_ID from BR_ADMIN where BR_ADM_ID = @br_id
		
		if @centra_wtih != -1
		begin
			insert into @t values (@centra_wtih)
			--set @centra_br = CONVERT(nvarchar(10), @centra_wtih)
			set @br_id = @centra_wtih
		end
		else
		begin
			insert into @t values (@br_id)
			--set @centra_br = CONVERT(nvarchar(10), @br_id)
		end
		

		set @count_centr_child = (select COUNT(*) from BR_ADMIN where BR_ADM_PARENT_CENT_BR_ID = @br_id)
		
		while @i <= @count_centr_child
		begin
			set @centra_child = (select BR_ADM_ID from (select ROW_NUMBER() over (order by (select 0)) as sr, BR_ADM_ID 
			from BR_ADMIN where BR_ADM_PARENT_CENT_BR_ID = @br_id)a where sr = @i)
			insert into @t values (@centra_child)
			--set @centra_br =  @centra_br + ',' +CONVERT(nvarchar(10), @centra_child)		
			set @i = @i +1
		end
	end
	else if @status = 'S'
	begin
		select @centra_wtih = BR_ADM_STAFF_CENT_BR_ID from BR_ADMIN where BR_ADM_ID = @br_id
		
		if @centra_wtih != -1
		begin
			insert into @t values (@centra_wtih)
			--set @centra_br = CONVERT(nvarchar(10), @centra_wtih)
			set @br_id = @centra_wtih
		end
		else
		begin
			insert into @t values (@br_id)
			--set @centra_br = CONVERT(nvarchar(10), @br_id)
		end
		

		set @count_centr_child = (select COUNT(*) from BR_ADMIN where BR_ADM_STAFF_CENT_BR_ID = @br_id)
		
		while @i <= @count_centr_child
		begin
			set @centra_child = (select BR_ADM_ID from (select ROW_NUMBER() over (order by (select 0)) as sr, BR_ADM_ID 
			from BR_ADMIN where BR_ADM_STAFF_CENT_BR_ID = @br_id)a where sr = @i)
			insert into @t values (@centra_child)
			--set @centra_br =  @centra_br + ',' +CONVERT(nvarchar(10), @centra_child)		
			set @i = @i +1
		end
	end
end
--select * from @t
return 
	end