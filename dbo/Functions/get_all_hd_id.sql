CREATE function [dbo].[get_all_hd_id]( @hd_id numeric )
returns  @t table ([HD ID] int)


as begin


if @hd_id = 0
begin
insert into @t select MAIN_INFO_ID from MAIN_HD_INFO
end

else
begin
	insert into @t values (@hd_id)
end

return
end