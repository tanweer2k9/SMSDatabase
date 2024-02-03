
CREATE PROC [dbo].[sp_MAIN_SWITCH_ins_upd_sel]

@MAIN_SWITCH_STATUS char(1),
@MAIN_SWITCH_MESSAGE nvarchar(1000),
@POINT_OUT_URL nvarchar(200)

As

declare @count int = 0

if @MAIN_SWITCH_STATUS = 'A'
begin
	 select * from VMAIN_SWITCH
	 select MAIN_INFO_INSTITUTION_FULL_NAME, MAIN_INFO_ID   from MAIN_HD_INFO where MAIN_INFO_POINTOUT_URL = @POINT_OUT_URL
	 select *   from VMAIN_HD_INFO 
end

else
begin
	set @count = (select count(*) from VMAIN_SWITCH)

	if @count = 0
	begin
		insert into MAIN_SWITCH values (@MAIN_SWITCH_STATUS, @MAIN_SWITCH_MESSAGE)
	end
	else
	begin
		update MAIN_SWITCH set MAIN_SWITCH_STATUS = @MAIN_SWITCH_STATUS, MAIN_SWITCH_MESSAGE = @MAIN_SWITCH_MESSAGE
	end
end