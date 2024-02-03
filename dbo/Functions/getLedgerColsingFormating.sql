CREATE function [dbo].[getLedgerColsingFormating](@pStatus nvarchar(20), @pValue decimal(18,6))
RETURNS nvarchar(50)
as
begin

declare @prefixPositive  nvarchar(10)
declare @prefixNegative  nvarchar(10)
declare @Positivevalue  decimal(18,6)

 if @pStatus = 'Debit'
    begin
    set @prefixPositive = 'Dr. '
    set @prefixNegative = 'Cr. '
    end
    else if @pStatus = 'Credit'
        begin
        set @prefixPositive = 'Cr. '
        set @prefixNegative = 'Dr. '
        
    end
    
    if @pValue < 0
       begin
       set @Positivevalue = substring(cast(@pValue as nvarchar) , 2, len(cast(@pValue as nvarchar)))
       return @prefixNegative + GEN.dbo.getValueInNumericFormat(cast(@Positivevalue as decimal(18,6)),3)
       
       end
       else 
           return @prefixPositive + GEN.dbo.getValueInNumericFormat(@pValue,3)
       
       return 0
end