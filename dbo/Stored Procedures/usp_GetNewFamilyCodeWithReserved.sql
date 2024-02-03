CREATE PROC usp_GetNewFamilyCodeWithReserved


AS

declare @FamilyCode nvarchar(50) = ''
select @FamilyCode = ISNULL(VALUE,'') from DEFAULT_VALUES where VALUE_NAME = 'FamilyCode'


declare @NewFamilyCode nvarchar(50) = ''



if @FamilyCode = ''
BEGIN
	set @NewFamilyCode = (select MAX(family_code)  from
(SELECT CAST(LEFT(Val,PATINDEX('%[^0-9]%', Val+'a')-1) as bigint)as family_code from(
		SELECT SUBSTRING([Family Code], PATINDEX('%[0-9]%', [Family Code]), LEN([Family Code])) Val from VPARENT_INFO 
		)A)B)
END
else
BEGIN
	set @NewFamilyCode = @FamilyCode
END


set @NewFamilyCode  = CAST(CAST(@NewFamilyCode as int) + 1 as nvarchar(50))


if @FamilyCode = ''
BEGIN
	insert into DEFAULT_VALUES
	select 1,1,'StudentAdmisssion','FamilyCode', @NewFamilyCode
END
ELSE
BEGIN
	update DEFAULT_VALUES set VALUE = @NewFamilyCode where VALUE_NAME = 'FamilyCode'
END


select @NewFamilyCode FamilyCode