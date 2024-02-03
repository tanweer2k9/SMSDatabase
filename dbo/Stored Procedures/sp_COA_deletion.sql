
CREATE PROCEDURE  [dbo].[sp_COA_deletion]
                                               
                                               
          @STATUS char(10),
          @COA_ID  numeric,
          @COA_HD_ID  numeric,
          @COA_BR_ID  numeric
   
   
     AS BEGIN 

	 
	 declare @coa_uid nvarchar(50) = null
	 select @coa_uid = COA_UID from TBL_COA where COA_ID = @COA_ID

	 declare @count int = 0

select @count = COUNT(*) from TBL_VCH_DEF where VCH_DEF_COA = @coa_uid and BRC_ID = @COA_BR_ID

if @count = 0
BEGIN

   UPDATE COA 
   SET
   COA_STATUS = 'D'
   
   where 
          COA_ID =  @COA_ID and 
          COA_HD_ID =  @COA_HD_ID and 
          COA_BR_ID =  @COA_BR_ID 

		  select 'ok'

END
ELSE
BEGIN
	select 'Already in use'
END
end