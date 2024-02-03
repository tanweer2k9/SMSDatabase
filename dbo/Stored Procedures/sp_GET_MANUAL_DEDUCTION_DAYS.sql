﻿CREATE PROC sp_GET_MANUAL_DEDUCTION_DAYS

@STAFF_ID numeric,
@Date date,
@ACTUAL_DEDUCT_DAYS float,
@DEDUCT_DAYS float out


AS

--declare @STAFF_ID numeric = 26, @Date date = '2018-03-05'
 declare @ID numeric = 0



select @DEDUCT_DAYS = m.MANUAL_SALARY_DEDUCT_DAYS, @ID = m.MANUAL_SALARY_ID from MANUAL_SALARY m where DATEPART(MM,m.MANUL_SALARY_MONTH_YEAR) = DATEPART(MM,@Date) and DATEPART(YYYY,m.MANUL_SALARY_MONTH_YEAR) = DATEPART(YYYY,@Date) and m.MANUAL_SALARY_STAFF_ID = @STAFF_ID

if @ID = 0
	set @DEDUCT_DAYS = -1


update MANUAL_SALARY set MANUAL_SALARY_ACTUAL_DEDUCT_DAYS = 30 - @ACTUAL_DEDUCT_DAYS where MANUAL_SALARY_ID = @ID