CREATE procedure  [dbo].[sp_PYRL_COMMSN_UNITS_insertion]
                                               
                                               
          @COM_UNITS_HD_ID  numeric,
          @COM_UNITS_BR_ID  numeric,
          @COM_UNITS_DATE  date,
          @COM_UNITS_TOTAL_UNITS  int,
          @COM_UNITS_STATUS  char(2) 
   
   
     as  begin
   

	declare @count int = 0 

	set @count = (select count(*) from PYRL_COMMSN_UNITS where DATEPART(MM,@COM_UNITS_DATE) = DATEPART(MM,COM_UNITS_DATE) and  DATEPART(YYYY,@COM_UNITS_DATE) = DATEPART(YYYY,COM_UNITS_DATE))

   

   if @count = 0
   begin
		 insert into PYRL_COMMSN_UNITS
		 values
		 (
			@COM_UNITS_HD_ID,
			@COM_UNITS_BR_ID,
			@COM_UNITS_DATE,
			@COM_UNITS_TOTAL_UNITS,
			@COM_UNITS_STATUS
		 )
	end

	else 
	begin
		
			update PYRL_COMMSN_UNITS set @COM_UNITS_TOTAL_UNITS = COM_UNITS_TOTAL_UNITS, @COM_UNITS_DATE = COM_UNITS_DATE
			where DATEPART(MM,@COM_UNITS_DATE) = DATEPART(MM,COM_UNITS_DATE) and  DATEPART(YYYY,@COM_UNITS_DATE) = DATEPART(YYYY,COM_UNITS_DATE)
		


		
	end
	
     
end