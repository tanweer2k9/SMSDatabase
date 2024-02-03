CREATE PROC [dbo].[sp_STUDENT_FEE_insertion_FEE_PLAN]


@PLAN_FEE_ID numeric,
@PLAN_FEE_HD_ID numeric,
@PLAN_FEE_BR_ID numeric,
@PLAN_FEE_NAME nvarchar(100),
@PLAN_FEE_TOTAL float


AS


if @PLAN_FEE_ID = 0
begin
	insert into PLAN_FEE values (@PLAN_FEE_HD_ID, @PLAN_FEE_BR_ID, @PLAN_FEE_NAME, @PLAN_FEE_TOTAL, 'T',1,1,1,'',0)
	select SCOPE_IDENTITY()
end

else 
begin
	update PLAN_FEE set @PLAN_FEE_TOTAL = @PLAN_FEE_TOTAL where PLAN_FEE_ID = @PLAN_FEE_ID
	select @PLAN_FEE_ID
end