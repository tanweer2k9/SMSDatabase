
CREATE PROC [dbo].[sp_STAFF_SALLERY_GET_SMS]

 @HD_ID numeric ,
 @BR_ID numeric ,
 @DATE date 

 AS


--declare @HD_ID numeric = 1
--declare @BR_ID numeric = 1
--declare @DATE date = '2016-05-26'

declare @t_sms table (mobile_no nvarchar(20), msg nvarchar(1000), screen_id int)



declare @count int = 0
declare @i int = 1
declare @staff_salary_id numeric = 0 

set @count = (select COUNT(*) from STAFF_SALLERY where STAFF_SALLERY_HD_ID = @HD_ID and STAFF_SALLERY_BR_ID = @BR_ID and DATEPART(MM,STAFF_SALLERY_MONTH_DATE) = DATEPART(MM,@DATE) and DATEPART(YYYY,STAFF_SALLERY_MONTH_DATE) = DATEPART(YYYY,@DATE))

WHILE @i <= @count
BEGIN
	select @staff_salary_id = STAFF_SALLERY_ID  from (select ROW_NUMBER() over(order by (select 0)) as sr,STAFF_SALLERY_ID from STAFF_SALLERY where STAFF_SALLERY_HD_ID = @HD_ID and STAFF_SALLERY_BR_ID = @BR_ID and DATEPART(MM,STAFF_SALLERY_MONTH_DATE) = DATEPART(MM,@DATE) and DATEPART(YYYY,STAFF_SALLERY_MONTH_DATE) = DATEPART(YYYY,@DATE))A where sr = @i


	insert into @t_sms exec dbo.[sp_SMS_INSERT] @HD_ID, @BR_ID,@staff_salary_id,0, 'S'
	set @i  = @i + 1
END




select * from @t_sms