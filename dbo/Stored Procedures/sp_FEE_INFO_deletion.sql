CREATE PROCEDURE  [dbo].[sp_FEE_INFO_deletion]
                                               
                                               
          @STATUS char(10),
		  @DEFINITION_ID  numeric
   
     AS  
   









     declare @DEFINITION_HD_ID  numeric
   declare @DEFINITION_BR_ID  numeric

   declare @HD_ID nvarchar(50) = ''
   declare @BR_ID nvarchar(50) = ''


   declare @count int = 0
   declare @fee_old_name nvarchar(100) = ''



   select @fee_old_name = FEE_NAME, @DEFINITION_HD_ID = FEE_HD_ID , @DEFINITION_BR_ID= FEE_BR_ID from FEE_INFO where FEE_ID = @DEFINITION_ID
      
   set @HD_ID = CAST((@DEFINITION_HD_ID) as nvarchar(50))
   set @BR_ID = CAST((@DEFINITION_BR_ID) as nvarchar(50))


   
     --delete from FEE_INFO
     if @STATUS = 'D'
     BEGIN
     delete from FEE_INFO
      where      
         FEE_ID = @DEFINITION_ID 
      END
         
		 
      else
      BEGIN   
     
     update FEE_INFO
     Set
     
		FEE_STATUS = 'D' 
     where      
         FEE_ID = @DEFINITION_ID  


		update TBL_COA set COA_isDeleted = 1
		where CMP_ID = @HD_ID and BRC_ID = @BR_ID and COA_Name = @fee_old_name and COA_isDeleted = 0
 
end