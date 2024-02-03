CREATE PROC [dbo].[sp_BANK_SALARY_TRANSFER_selection]

@HD_ID numeric,
@BR_ID numeric

AS


select BANK_ID, BANK_NAME, BANK_ADDRESS from BANK_INFO where BANK_HD_ID = @HD_ID and BANK_BR_ID = @BR_ID and BANK_STATUS = 'T' and BANK_NAME != 'None'