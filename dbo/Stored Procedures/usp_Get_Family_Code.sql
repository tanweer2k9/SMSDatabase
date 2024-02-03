
CREATE PROC [dbo].[usp_Get_Family_Code]



AS


declare @family_code nvarchar(100) = ''

set @family_code = (select MAX(family_code) + 1 from
(SELECT CAST(LEFT(Val,PATINDEX('%[^0-9]%', Val+'a')-1) as bigint)as family_code from(
		SELECT SUBSTRING([Family Code], PATINDEX('%[0-9]%', [Family Code]), LEN([Family Code])) Val from VPARENT_INFO 
		)A)B)
		
		
select ISNULL(@family_code,'1')