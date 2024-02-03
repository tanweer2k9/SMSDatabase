CREATE FUNCTION [dbo].[fu_sc_GET_VOUCHER_PREFIX_FULL_NAME] (@Prefix nvarchar(50))
returns  nvarchar(50)

AS BEGIN
declare @Full_Name nvarchar(50) = ''

if @Prefix = 'BR' or @Prefix = 'FE'
BEGIN
	set @Full_Name = 'Bank Receipt'
END
ELSE if @Prefix = 'CP' 
BEGIN
	set @Full_Name = 'Cash Payment'
END 
ELSE if @Prefix = 'BP'
BEGIN
	set @Full_Name = 'Bank Payment'
END 
ELSE if @Prefix = 'CR'
BEGIN
	set @Full_Name = 'Cash Receipt'
END 
ELSE if @Prefix = 'G'
BEGIN
	set @Full_Name = 'General'
END 

return @Full_Name

END