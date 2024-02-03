create  procedure [dbo].[sp_LOAN_TYPE_INSTALLEMENT_UPDATION]

		  @STAFF_DEFF_ID  numeric,          
          @crrnt_month int ,
          @crrnt_year int
          
          
          as
          begin
			update LOAN_TYPE
			set LOAN_TYPE_INSTALLEMENT_STATUS = 'T'
			where LOAN_TYPE_LOAN_ID = @STAFF_DEFF_ID  and LOAN_TYPE_MONTH = @crrnt_month and LOAN_TYPE_YEAR = @crrnt_year and LOAN_TYPE_STATUS = 'T'			
		  end