CREATE procedure  [dbo].[sp_STAFF_REFUNDED_updation]
                                               
                                               
          @STAFF_REFUNDED_DEDUCTION_NAME  nvarchar(200),
          @STAFF_REFUNDED_HD_ID  numeric,
          @STAFF_REFUNDED_BR_ID  numeric,
          @STAFF_REFUNDED_STAFF_ID  numeric,
          @STAFF_REFUNDED_STATUS  nvarchar(50)

   
   
     as begin 
   declare @staff_id numeric = 0
   declare @PID numeric = 0
   declare @count_rows int = 0
   declare @i int = 1
   declare @dedcut_id numeric = 0
   
   set @count_rows = (select COUNT(*) from STAFF_SALLERY where STAFF_SALLERY_STAFF_ID = @STAFF_REFUNDED_STAFF_ID)
   
   
   
   while @i <= @count_rows
   begin  
   
   set @PID = (select STAFF_SALLERY_ID from 
					(select row_number() over (order by STAFF_SALLERY_ID) as row,*  from  STAFF_SALLERY where STAFF_SALLERY_STAFF_ID = @STAFF_REFUNDED_STAFF_ID) as t
				where row = @i)
 
	set @dedcut_id = (select DEDUCTION_ID from DEDUCTION where DEDUCTION_NAME = @STAFF_REFUNDED_DEDUCTION_NAME)
 
	update STAFF_SALLERY_DEFF
     set
          STAFF_SALLERY_DEFF_REFUND_STATUS =  @STAFF_REFUNDED_STATUS          
 
     where 
        STAFF_SALLERY_DEFF_NAME = convert(nvarchar(10),@dedcut_id) and 
        STAFF_SALLERY_DEFF_PID = @PID and
        STAFF_SALLERY_DEFF_AMOUNT_TYPE = 'D' and
        STAFF_SALLERY_DEFF_REFUND = 'T'
        
        
        set @i = @i +1
	end
end