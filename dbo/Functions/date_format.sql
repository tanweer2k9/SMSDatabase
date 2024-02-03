create function [dbo].[date_format]( @current_date nvarchar(10),@format nvarchar(10) )
returns nvarchar(10)

as
	begin
	
		--DECLARE @format nvarchar(10) = 'yy/dd/mm'
		--DECLARE @current_date date = '2012/05/20'
		DECLARE @part nvarchar(5)		
		Declare @count int = 1
		declare @date nvarchar(15) = ''

		while @count<8
			begin
			
				set @part = ( select substring (@format,@count,2) ) 		
					if @part = 'dd'			
						begin
							set @date = @date + '/' + convert(nvarchar(5), (SELECT datepart(DD, @current_date)) )
							--select @date + '123'
						end
					else if @part = 'mm'
						begin
							set @date = @date + '/' + convert(nvarchar(5), (SELECT datepart(MM, @current_date)) )					
						end
					else if @part = 'yy'
						begin				
							set @date = @date + '/' + convert(nvarchar(5), (SELECT datepart(YY, @current_date)) )
						end
			
				set @count = @count + 3
			end
			
			set @date = (select SUBSTRING(@date,2,10))
			
			return(@date);
	end