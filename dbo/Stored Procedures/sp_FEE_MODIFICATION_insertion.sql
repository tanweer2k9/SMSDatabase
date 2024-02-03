CREATE PROCEDURE [dbo].[sp_FEE_MODIFICATION_insertion]

@FEE_COLLECT_PLAN_ID NUMERIC,
@FEE_COLLECT_DEFF NVARCHAR(50),
@FEE_COLLECT_FEE FLOAT,
@FEE_COLLECT_FEE_MIN FLOAT,
@FEE_COLLECT_FEE_MAX FLOAT,
@FEE_COLLECT_OPERATE char(1),
 @FEE_COLLECT_HD_ID numeric,
 @FEE_COLLECT_BR_ID numeric,
 @status char(1)

AS

declare @fee_deff_id int = (select FEE_ID from FEE_INFO where FEE_BR_ID = @FEE_COLLECT_BR_ID and FEE_HD_ID = @FEE_COLLECT_HD_ID and FEE_NAME = @FEE_COLLECT_DEFF)
	if @status !='A'

			BEGIN
				delete from PLAN_FEE_DEF
				 where PLAN_FEE_DEF_FEE_NAME = @fee_deff_id and 
				 PLAN_FEE_DEF_PLAN_ID in ( select STDNT_CLASS_FEE_ID from STUDENT_INFO where STDNT_CLASS_PLANE_ID = @FEE_COLLECT_PLAN_ID )

				insert into PLAN_FEE_DEF
				select STDNT_CLASS_FEE_ID,@fee_deff_id,@FEE_COLLECT_FEE,@FEE_COLLECT_FEE_MIN,@FEE_COLLECT_FEE_MAX,'T',@FEE_COLLECT_OPERATE,'' from STUDENT_INFO where STDNT_CLASS_PLANE_ID = @FEE_COLLECT_PLAN_ID
											
			END
			
	Else
			BEGIN
				delete from PLAN_FEE_DEF
				 where PLAN_FEE_DEF_FEE_NAME = @fee_deff_id and 
				 PLAN_FEE_DEF_PLAN_ID in ( select ID from VPLAN_FEE where [Institute ID] = @FEE_COLLECT_HD_ID and [Branch ID] = @FEE_COLLECT_BR_ID )

				insert into PLAN_FEE_DEF
				select ID,@fee_deff_id,@FEE_COLLECT_FEE,@FEE_COLLECT_FEE_MIN,@FEE_COLLECT_FEE_MAX,'T',@FEE_COLLECT_OPERATE,'' from VPLAN_FEE where [Institute ID] = @FEE_COLLECT_HD_ID and [Branch ID] = @FEE_COLLECT_BR_ID
											
			END
			
	

select 'ok'