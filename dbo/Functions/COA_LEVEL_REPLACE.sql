CREATE FUNCTION [dbo].[COA_LEVEL_REPLACE] (@id nvarchar(50), @split_to_char nvarchar(50), @level int, @new_level_value nvarchar(50))
RETURNS nvarchar(1000)


AS 
BEGIN

--declare @id nvarchar(50) = '01-01-01-0000005'
--declare @split_to_char nvarchar(50) = '-'
--declare @level int = 4
--declare @new_level_value nvarchar(50) = '0000008'

declare @new_id nvarchar(50) = ''
declare @i int = 1
declare @id_length int = 0
declare  @t table (id int, val nvarchar(50))
insert into @t select * from dbo.split(@id,@split_to_char)
set @id_length = (select count(*) from @t)

while @i<=@id_length
begin
 if @i != 1
  set @new_id = @new_id + @split_to_char

  if @i = @level
  begin
   set @new_id = @new_id + @new_level_value
  end
  else
  begin
   set @new_id = @new_id + (select val from @t where id = @i)
  end 

 set @i = @i + 1
end
return @new_id

--select @new_id

END