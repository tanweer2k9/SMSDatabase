

CREATE procedure [dbo].[sp_FEE_MODIFICATION_UPDATION]
 @FEE_COLLECT_HD_ID numeric,
 @FEE_COLLECT_BR_ID numeric,
 @FEE_COLLECT_STD_ID numeric,
 @FEE_COLLECT_FEE_ID numeric,
 @FEE_COLLECT_FEE float,
 @FEE_COLLECT_OPERATE char(1),
 @Value_type char(1),
 @fee_value nvarchar(50),
 @status char(1)
AS


declare @class_plan nvarchar(50) = '%', @one int= 1


set @FEE_COLLECT_BR_ID = (select top(@one) FEE_BR_ID From FEE_INFO where FEE_ID = @FEE_COLLECT_FEE_ID)


if @FEE_COLLECT_STD_ID != 0
begin
	set @class_plan = CAST((@FEE_COLLECT_STD_ID) as nvarchar(50))
end

if @status ='B'
		 BEGIN				
				update VFEE_MODIFICATION
				set 
				[Fee] = @FEE_COLLECT_FEE								
				WHERE [Student ID] = @FEE_COLLECT_STD_ID and [Fee ID] =  @FEE_COLLECT_FEE_ID



				--if @Value_type = '%' and @FEE_COLLECT_OPERATE = '+'
				--begin
				--	---set @FEE_COLLECT_FEE =   ( @FEE_COLLECT_FEE + ( @FEE_COLLECT_FEE * ( select Fee from VFEE_MODIFICATION WHERE [Student ID] = @FEE_COLLECT_STD_ID and [Fee Name] =  @FEE_COLLECT_DEFF ) )/100 )
				--	---set @FEE_COLLECT_FEE =   ( @FEE_COLLECT_FEE + ( @FEE_COLLECT_FEE * ( select Fee from VFEE_MODIFICATION WHERE [Student ID] = @FEE_COLLECT_STD_ID and [Fee Name] =  @FEE_COLLECT_DEFF ) )/100 )
				--	select @FEE_COLLECT_FEE =  Fee + ( (@FEE_COLLECT_FEE * Fee)/100 ) ,@FEE_COLLECT_OPERATE = Operator from VFEE_MODIFICATION WHERE [Student ID] = @FEE_COLLECT_STD_ID and [Fee Name] =  @FEE_COLLECT_DEFF
					
				--end
				
		  --   else if @Value_type = '%' and @FEE_COLLECT_OPERATE = '-'
				--begin
				--	select @FEE_COLLECT_FEE =  Fee - ( (@FEE_COLLECT_FEE * Fee)/100 ) ,@FEE_COLLECT_OPERATE = Operator from VFEE_MODIFICATION WHERE [Student ID] = @FEE_COLLECT_STD_ID and [Fee Name] =  @FEE_COLLECT_DEFF
				--end
		 
				--update VFEE_MODIFICATION
				--set 
				--[Fee] = @FEE_COLLECT_FEE,
				--[Min Fee %age] = @FEE_COLLECT_FEE_MIN,
				--[Max Fee %age] = @FEE_COLLECT_FEE_MAX,
				--Operator = @FEE_COLLECT_OPERATE				
				--WHERE [Student ID] = @FEE_COLLECT_STD_ID and [Fee Name] =  @FEE_COLLECT_DEFF
				--select * from VFEE_MODIFICATION WHERE [Student ID] = @FEE_COLLECT_STD_ID and [Fee Name] =  @FEE_COLLECT_DEFF
		End

		ELSE if @status = 'C'
		begin
			
			if @fee_value = 'Add'
			begin
				if @Value_type = '%'
				begin
					update VFEE_MODIFICATION set Fee = Fee + (Fee * @FEE_COLLECT_FEE / 100) where [Class ID] like @class_plan and [Fee ID] = @FEE_COLLECT_FEE_ID
				end
				else
				begin
					update VFEE_MODIFICATION set Fee = Fee + @FEE_COLLECT_FEE where [Class ID] like @class_plan and [Fee ID] = @FEE_COLLECT_FEE_ID
				end
			end
			else if @fee_value = 'Replace'
			begin
				update VFEE_MODIFICATION set Fee = @FEE_COLLECT_FEE where [Class ID] like @class_plan and [Fee ID] = @FEE_COLLECT_FEE_ID
			end
			else if @fee_value = 'Subtract'
			begin
				if @Value_type = '%'
				begin
					update VFEE_MODIFICATION set Fee = Fee - (Fee * @FEE_COLLECT_FEE / 100) where [Class ID] like @class_plan and [Fee ID] = @FEE_COLLECT_FEE_ID
				end
				else
				begin
					update VFEE_MODIFICATION set Fee = Fee - @FEE_COLLECT_FEE where [Class ID] like @class_plan and [Fee ID] = @FEE_COLLECT_FEE_ID
				end 
			end
		end
	
--ELSE if @status = 'A'
--		Begin
		
--		declare @min_std numeric
--		declare @max_std numeric
				
--				IF @Value_type != '%'
--					BEGIN
					
--						update VFEE_MODIFICATION
--						set 
--						[Fee] =  @FEE_COLLECT_FEE,
--						[Min Fee %age] = @FEE_COLLECT_FEE_MIN,
--						[Max Fee %age] = @FEE_COLLECT_FEE_MAX,
--						[Operator] = @FEE_COLLECT_OPERATE
--						where [Institute ID] = @FEE_COLLECT_HD_ID
--						and [Branch ID] = @FEE_COLLECT_BR_ID
--						and [Fee Name] = @FEE_COLLECT_DEFF	
--						select 1	
--					END
				
			
			
--				ELSE if @Value_type = '%' and @FEE_COLLECT_OPERATE = '+'
--					begin																						
--								select @min_std = ISNULL( MIN([Student ID]),0), @max_std = ISNULL( MAX([Student ID]),0) from VFEE_MODIFICATION where [Institute ID] = @FEE_COLLECT_HD_ID and [Branch ID] = @FEE_COLLECT_BR_ID 								
--								while @min_std <= @max_std
--									begin
--										 update VFEE_MODIFICATION
--										 set 
--											--[Fee] = ( select V.Fee + ( (@FEE_COLLECT_FEE * V.Fee)/100 ) from VFEE_MODIFICATION V WHERE [Student ID] = @min_std and [Fee Name] =  @FEE_COLLECT_DEFF),
--											[Fee] = Fee + ( (@FEE_COLLECT_FEE * Fee)/100 ) ,											
--											[Min Fee %age] = @FEE_COLLECT_FEE_MIN,
--											[Max Fee %age] = @FEE_COLLECT_FEE_MAX																						
--											WHERE [Student ID] = @min_std and [Fee Name] =  @FEE_COLLECT_DEFF
										
--										set @min_std = @min_std + 1
--									end 

--					end
					
					
					
				
--		 ELSE if @Value_type = '%' and @FEE_COLLECT_OPERATE = '-'
--					begin																						
--								select @min_std = ISNULL( MIN([Student ID]),0), @max_std = ISNULL( MAX([Student ID]),0) from VFEE_MODIFICATION where [Institute ID] = @FEE_COLLECT_HD_ID and [Branch ID] = @FEE_COLLECT_BR_ID 
								
--								while @min_std <= @max_std
--									begin
--										 update VFEE_MODIFICATION
--										 set 
--											--[Fee] = ( select V.Fee - ( (@FEE_COLLECT_FEE * V.Fee)/100 ) from VFEE_MODIFICATION V WHERE [Student ID] = @min_std and [Fee Name] =  @FEE_COLLECT_DEFF),
--											[Fee] = Fee - ( (@FEE_COLLECT_FEE * Fee)/100 ) ,
--											[Min Fee %age] = @FEE_COLLECT_FEE_MIN,
--											[Max Fee %age] = @FEE_COLLECT_FEE_MAX																						
--											WHERE [Student ID] = @min_std and [Fee Name] =  @FEE_COLLECT_DEFF
										
--										set @min_std = @min_std + 1
--									end 
--					end
		 		
				
--		END
		

else if @status = 'A' -- Add Fee Definition
begin	
	declare @fee_operation char(1), @fee_type nvarchar(10) = ''
	
	 select @fee_operation = Operation, @fee_type = [Fee Type] from VFEE_INFO where ID = @FEE_COLLECT_FEE_ID
	set @fee_operation = ISNULL(@fee_operation, '+')

	insert into PLAN_FEE_DEF select STDNT_CLASS_FEE_ID, @FEE_COLLECT_FEE_ID, @FEE_COLLECT_FEE,0,0, 'T', @fee_operation,IIF(@fee_type like '%Once%', 'F','N') from STUDENT_INFO where STDNT_CLASS_PLANE_ID like @class_plan and STDNT_STATUS = 'T' and STDNT_BR_ID = @FEE_COLLECT_BR_ID
	and STDNT_ID not in (select [Student ID] from VFEE_MODIFICATION where [Class ID] like @class_plan and [Fee ID] = @FEE_COLLECT_FEE_ID and [Branch ID] =  @FEE_COLLECT_BR_ID)
	
	
end

else if @status = 'D'-- Delete Fee Definition
begin	
	delete from PLAN_FEE_DEF where PLAN_FEE_DEF_ID in (select [Plan Fee Def ID] from VFEE_MODIFICATION where [Class ID] like @class_plan and [Fee ID] = @FEE_COLLECT_FEE_ID)  
end

ELSE if @status = 'S'
		Begin
			update STUDENT_ROLL_NUM			
			set	STUDENT_ROLL_NUM_ACTIVE_STATUS = 'mov'
			where STUDENT_ROLL_NUM_HD_ID = @FEE_COLLECT_HD_ID
			and STUDENT_ROLL_NUM_BR_ID = @FEE_COLLECT_BR_ID		
			and STUDENT_ROLL_NUM_ACTIVE_STATUS in ('new','old','mov')
			and STUDENT_ROLL_NUM_STATUS !='D'
		End



select 'ok'