CREATE procedure [dbo].[sp_STUDENT_PROMOTION_UPDATION]
 @FEE_COLLECT_HD_ID numeric,
 @FEE_COLLECT_BR_ID numeric,
 @FEE_COLLECT_STD_ID numeric,
 @FEE_COLLECT_PLAN_ID numeric,
 @FEE_COLLECT_PLAN_ID_OLD numeric,
 @SESSION date,
 @status char(1)
AS

if @status = 'B'	----for new session
		 BEGIN
				update STUDENT_ROLL_NUM			
				set	STUDENT_ROLL_NUM_ACTIVE_STATUS = 'mov'
				where STUDENT_ROLL_NUM_HD_ID = @FEE_COLLECT_HD_ID
				and STUDENT_ROLL_NUM_BR_ID = @FEE_COLLECT_BR_ID		
				and STUDENT_ROLL_NUM_ACTIVE_STATUS in ('new','old','mov')
				and STUDENT_ROLL_NUM_STATUS = 'T'
				AND (
					 (  datepart(YYYY, STUDENT_ROLL_NUM_SESSION ) =  datepart(YYYY,@SESSION) - 1  )
					OR
					 (  datepart(YYYY, STUDENT_ROLL_NUM_SESSION ) =  datepart(YYYY,@SESSION) )
						 )
								
		
				update STUDENT_ROLL_NUM			
				set	STUDENT_ROLL_NUM_ACTIVE_STATUS = ''
				where STUDENT_ROLL_NUM_HD_ID = @FEE_COLLECT_HD_ID
				and STUDENT_ROLL_NUM_BR_ID = @FEE_COLLECT_BR_ID		
				and STUDENT_ROLL_NUM_ACTIVE_STATUS in ('new','old','mov')
				and STUDENT_ROLL_NUM_STATUS != 'T'
				AND (
					 (  datepart(YYYY, STUDENT_ROLL_NUM_SESSION ) =  datepart(YYYY,@SESSION) - 1  )
					OR
					 (  datepart(YYYY, STUDENT_ROLL_NUM_SESSION ) =  datepart(YYYY,@SESSION) )
					)
						 
				
				
		End
		
		
		
		
if @status = 'X'
		 BEGIN
				update  STUDENT_ROLL_NUM
				set 
				--STUDENT_ROLL_NUM_STATUS = 'F',
				STUDENT_ROLL_NUM_ACTIVE_STATUS = ''					
				where 
					STUDENT_ROLL_NUM_PLAN_ID in ( @FEE_COLLECT_PLAN_ID_OLD )
			        and STUDENT_ROLL_NUM_STATUS != 'D'
			        and STUDENT_ROLL_NUM_ACTIVE_STATUS = 'mov'			
					AND (
					 (  datepart(YYYY, STUDENT_ROLL_NUM_SESSION ) =  datepart(YYYY,@SESSION) - 1  )
					OR
					 (  datepart(YYYY, STUDENT_ROLL_NUM_SESSION ) =  datepart(YYYY,@SESSION) )
						 )
						
		End
		
		
		
		
select 'ok'