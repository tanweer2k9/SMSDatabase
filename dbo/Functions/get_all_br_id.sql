CREATE function [dbo].[get_all_br_id]( @br_id numeric )
returns  @t table ([BR ID] int)


as begin


if @br_id = 0
begin
insert into @t select BR_ADM_ID from BR_ADMIN
end

else
begin
	insert into @t values (@br_id)
end

return
end