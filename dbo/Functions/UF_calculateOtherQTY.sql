CREATE FUNCTION [dbo].[UF_calculateOtherQTY] ( @BRC_ID nvarchar(50),@CMP_ID nvarchar(50), @CurrentQty float, @CurrentUnit nvarchar(50),@CurrentItem nvarchar(50))

RETURNS  @returnTable TABLE (QTY1 float,QTY2 float,QTY3 float)
  


AS
BEGIN

 DECLARE @tmpQty1 float,  @tmpQty2 float,  @tmpQty3 float, @tmpFirstUnit nvarchar(50), @tmpSecondUnit nvarchar(50), @tmpThirdUnit nvarchar(50),  @tmpFormulaQty2 float,  @tmpFormulaQty3 float  
 DECLARE @tmpreturnTable TABLE (QTY1 float,QTY2 float,QTY3 float)


   


set @tmpFirstUnit =( select TBL_ITEM.ITEM_firstUnit from TBL_ITEM where TBL_ITEM.ITEM_CMP_ID = @CMP_ID and TBL_ITEM.ITEM_COA = @CurrentItem)
set @tmpSecondUnit = (select TBL_ITEM.ITEM_secondUnit from TBL_ITEM where TBL_ITEM.ITEM_CMP_ID = @CMP_ID and TBL_ITEM.ITEM_COA = @CurrentItem)
set @tmpThirdUnit = (select TBL_ITEM.ITEM_ThirdUnit from TBL_ITEM where TBL_ITEM.ITEM_CMP_ID = @CMP_ID and TBL_ITEM.ITEM_COA = @CurrentItem)

set @tmpFormulaQty2 =( select cast(TBL_ITEM.ITEM_secondUnitQTY as nvarchar) from TBL_ITEM where TBL_ITEM.ITEM_CMP_ID = @CMP_ID and TBL_ITEM.ITEM_COA = @CurrentItem)
set @tmpFormulaQty3 = (select cast(TBL_ITEM.ITEM_thirdUnitQTY as nvarchar) from TBL_ITEM where TBL_ITEM.ITEM_CMP_ID = @CMP_ID and TBL_ITEM.ITEM_COA = @CurrentItem)



	if @CurrentUnit = @tmpFirstUnit
		begin

			
			set @tmpQty1 = @CurrentQty
			set @tmpQty2 = @CurrentQty * @tmpFormulaQty2
			set @tmpQty3 = @CurrentQty * @tmpFormulaQty2 * @tmpFormulaQty3


		end
		else if @CurrentUnit = @tmpSecondUnit
		begin

			
			set @tmpQty1 = @CurrentQty / @tmpFormulaQty2
			set @tmpQty2 = @CurrentQty 	
			set @tmpQty3 = @CurrentQty *  @tmpFormulaQty3


		end
			else if @CurrentUnit = @tmpThirdUnit
		begin

			
			set @tmpQty1 = @CurrentQty / @tmpFormulaQty2 /@tmpFormulaQty3
			set @tmpQty2 = @CurrentQty / @tmpFormulaQty2	
			set @tmpQty3 = @CurrentQty


		end




   
   -- copy to the result of the function the required columns
   INSERT @returnTable
   SELECT QTY1, QTY2, QTY3
   FROM @tmpreturnTable
   RETURN
END