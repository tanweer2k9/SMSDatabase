
CREATE PROCEDURE  [dbo].[sp_PLAN_FEE_deletion]
          @STATUS char(2),
          @PLAN_FEE_ID  numeric,
          @PLAN_FEE_HD_ID  numeric,
          @PLAN_FEE_BR_ID  numeric
   
   
     AS BEGIN 
   

   declare @student_fee_id_count int = 0
   
   set @student_fee_id_count = (select count(*) from STUDENT_INFO where STDNT_CLASS_FEE_ID= @PLAN_FEE_ID and STDNT_STATUS != 'D')

   if @student_fee_id_count = 0
   begin

		   if @STATUS = 'U'
		   begin
			update PLAN_FEE
			set
				PLAN_FEE_STATUS = 'D'
			where 
				  PLAN_FEE_ID =  @PLAN_FEE_ID and 
				  PLAN_FEE_HD_ID =  @PLAN_FEE_HD_ID and 
				  PLAN_FEE_BR_ID =  @PLAN_FEE_BR_ID 
 
		
		   end
   
			else
			begin 
				delete from PLAN_FEE 
				where 
          
				  PLAN_FEE_ID =  @PLAN_FEE_ID and 
				  PLAN_FEE_HD_ID =  @PLAN_FEE_HD_ID and 
				  PLAN_FEE_BR_ID =  @PLAN_FEE_BR_ID 
			end

			SELECT 'OK'
 
	end
	else
	begin
		SELECT 'not deleted'
	end













































	END