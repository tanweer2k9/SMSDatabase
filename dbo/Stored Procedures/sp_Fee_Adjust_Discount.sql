
CREATE PROC [dbo].[sp_Fee_Adjust_Discount]


@Fee_Collect_Id numeric


AS
--declare @Fee_Collect_Id numeric = 0

declare @count int = 0
declare @discount float = 0
declare @remaining_discount float = 0,@discount_fee_amount float = 0
declare @BR_ID numeric = 0
declare @j int = 1
declare @fee_discount_id numeric = 0
declare @total_fee float = 0
select @discount = SUM(FEE_COLLECT_DEF_FEE + FEE_COLLECT_DEF_ARREARS) from FEE_COLLECT_DEF where FEE_COLLECT_DEF_OPERATION = '-' and FEE_COLLECT_DEF_PID = @Fee_Collect_Id
select @total_fee = SUM(FEE_COLLECT_FEE + FEE_COLLECT_ARREARS) from FEE_COLLECT where FEE_COLLECT_ID = @Fee_Collect_Id


if @discount > 0 and @total_fee > 0
BEGIN

	--WHile loop commented due to from advance fee collection the amount of fee receiving not included discount amount e.g: fees received 35000, current fee 37000 and 1800 discount means 37000-1800	
					 set @remaining_discount = @discount
					
					 set @BR_ID = (select top(@j) FEE_COLLECT_BR_ID from FEE_COLLECT where FEE_COLLECT_ID = @Fee_Collect_Id)
					  select @count = COUNT(*) from FEE_INFO where FEE_BR_ID = @BR_ID and FEE_STATUS = 'T'
					 WHILE @count <=@j
					 BEGIN
						select @fee_discount_id = FEE_ID from (select ROW_NUMBER() over(order by FEE_DISCOUNT_PRIORITY, FEE_ID ) as sr,* from FEE_INFO where FEE_BR_ID = @BR_ID and FEE_STATUS = 'T' )A where sr = @j
						
						set @discount_fee_amount = 0
						select @discount_fee_amount = FEE_COLLECT_DEF_ARREARS from FEE_COLLECT_DEF where FEE_COLLECT_DEF_FEE_NAME = @fee_discount_id and FEE_COLLECT_DEF_PID = @Fee_Collect_Id
						
						if @remaining_discount >@discount_fee_amount
						BEGIN
							update FEE_COLLECT_DEF set FEE_COLLECT_DEF_ARREARS = 0 where FEE_COLLECT_DEF_FEE_NAME = @fee_discount_id and FEE_COLLECT_DEF_PID = @Fee_Collect_Id
							set @remaining_discount = @remaining_discount - @discount_fee_amount
						END
						ELSE
						BEGIN
							update FEE_COLLECT_DEF set FEE_COLLECT_DEF_ARREARS = FEE_COLLECT_DEF_ARREARS - @remaining_discount where FEE_COLLECT_DEF_FEE_NAME = @fee_discount_id and FEE_COLLECT_DEF_PID = @Fee_Collect_Id
							set @remaining_discount = 0
						END
						set @j = @j + 1
							 if @remaining_discount <=0
								 break
					 END

					

					 --update FEE_COLLECT_DEF set FEE_COLLECT_DEF_FEE = 0, FEE_COLLECT_DEF_TOTAL = 0 where FEE_COLLECT_DEF_OPERATION = '-' and FEE_COLLECT_DEF_PID = @Fee_Collect_Id
END