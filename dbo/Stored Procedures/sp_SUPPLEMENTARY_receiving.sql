CREATE PROC [dbo].[sp_SUPPLEMENTARY_receiving]

@dt_receive dbo.[type_SUPPLEMENTARY_Receive] readonly



AS

declare @count int = 0
declare @i int = 1
declare @ID int = 0
declare @fee_receive float
declare @discount float
declare @late_fee_fine float
declare @arrears_received float
declare @status nvarchar(50)



--set @count = (select COUNT(*) from @dt_receive)

--while  @i <= @count
--BEGIN
	

--	 select @ID = ID, @fee_receive = [Fee Received],@discount = Discount,@late_fee_fine = [Late Fee Fine],@arrears_received = [Arrears Received]  ,@status = [Is Fully Received] from (select ROW_NUMBER() OVER(order by ID) as sr, * from @dt_receive)A where sr = @i



--	 update SUPLEMENTARY_DEF set SUPL_DEF_FEE_RECEIVED = @fee_receive, SUPL_DEF_DISCOUNT = @discount,SUPL_DEF_LATE_FEE_FINE = @late_fee_fine,SUPL_DEF_ARREARS_RECEIVED = @arrears_received,SUPL_DEF_STATUS = @status where SUPL_DEF_ID = @ID
--	 set @i = @i + 1
--END

--select 'ok'