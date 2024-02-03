CREATE FUNCTION [dbo].[getValueInNumericFormat]
(
	
	 @value decimal(18,6),  @flength int
)
RETURNS nvarchar(200)
AS
BEGIN
	


declare @valueActualDecimal as nvarchar(50)
declare @valuebeforedecimal as int
declare @valueafterdecimal as nvarchar(50)
declare @valueainComma as nvarchar(50)


if @flength =0
  set @valueActualDecimal = cast( cast((@value%1) as decimal(18,0)) as nvarchar)
  else if @flength =1
  set @valueActualDecimal = cast( cast((@value%1) as decimal(18,1)) as nvarchar)
  else if @flength =2
      set @valueActualDecimal = cast( cast((@value%1) as decimal(18,2)) as nvarchar)
          else if @flength =3
          set @valueActualDecimal = cast( cast((@value%1) as decimal(18,3)) as nvarchar)
            else if @flength =4
              set @valueActualDecimal = cast( cast((@value%1) as decimal(18,4)) as nvarchar)
                  else if @flength =5
                  set @valueActualDecimal = cast( cast((@value%1) as decimal(18,5)) as nvarchar)
                      else if @flength =6
                      set @valueActualDecimal = cast( cast((@value%1) as decimal(18,6)) as nvarchar)


set @valuebeforedecimal = cast(@value as int)
set @valueafterdecimal   = substring( cast((@value%1) as nvarchar) , 3 , LEN(@value%1)-2)
set @valueainComma = REPLACE( CONVERT(nvarchar, CAST(@valuebeforedecimal as money) ,1) , '.00' , '' )
return @valueainComma + substring(CAST(@valueActualDecimal as nvarchar),2,LEN(@valueActualDecimal))


END