CREATE PROCEDURE [dbo].[sp_STUDENT_PROMOTION_INSERTION]
 @CLASS_ID NUMERIC,
 @CLASS_ID_OLD NUMERIC,
 @STD_ID numeric,
 @BR_ID numeric,
 @BR_ID_OLD numeric,
 @USER_NAME nvarchar(50),
 @status char(1),
 @PASSED_OUT_DATE date,
 @IS_PASSED_OUT bit,
 @SESSION_ID numeric

AS
declare @one int=1

declare @HD_ID numeric = (select top(@one) BR_ADM_HD_ID from BR_ADMIN where BR_ADM_ID = @BR_ID)
declare @HD_ID_OLD numeric = (select top(@one) BR_ADM_HD_ID from BR_ADMIN where BR_ADM_ID = @BR_ID_OLD)


if @IS_PASSED_OUT = 1
BEGIN
	update STUDENT_INFO set STDNT_STATUS = 'F', STDNT_CATEGORY = 'Passed Out', STDNT_DATE_OF_LEAVING = @PASSED_OUT_DATE where STDNT_ID = @STD_ID

	insert into StudentPromotion values (@HD_ID,@BR_ID,@STD_ID,NULL,@HD_ID_OLD,@BR_ID_OLD,@CLASS_ID_OLD,GETDATE(), @USER_NAME,@SESSION_ID)
END
ELSE
BEGIN

	update STUDENT_INFO set STDNT_CLASS_PLANE_ID = @CLASS_ID where STDNT_ID = @STD_ID
	update tblStudentClassPlan set ClassId = @CLASS_ID where StudentId = @STD_ID and SessionId = @SESSION_ID 
	update tblStudentSubjectsParent set ClassId = @CLASS_ID where StudentId = @STD_ID and ClassId = @CLASS_ID_OLD

	insert into StudentPromotion values (@HD_ID,@BR_ID,@STD_ID,@CLASS_ID,@HD_ID_OLD,@BR_ID_OLD,@CLASS_ID_OLD,GETDATE(), @USER_NAME,@SESSION_ID)

	if @BR_ID_OLD != @BR_ID
	BEGIN
		declare @fee_id numeric = 0, @coa_id numeric = 0

		select @fee_id = STDNT_CLASS_FEE_ID, @coa_id = STDNT_COA_ID from STUDENT_INFO where STDNT_ID = @STD_ID
		
		update STUDENT_INFO set STDNT_BR_ID = @BR_ID, STDNT_HD_ID = @HD_ID where STDNT_ID = @STD_ID
		update PLAN_FEE set PLAN_FEE_BR_ID = @BR_ID, PLAN_FEE_HD_ID = @HD_ID where PLAN_FEE_ID = @fee_id	
		update USER_INFO set USER_HD_ID = @HD_ID, USER_BR_ID = @BR_ID,[USER_NAME] = REPLACE(STR(@HD_ID, 2), SPACE(1), '0') + '-'+REPLACE(STR(@BR_ID, 3), SPACE(1), '0')+'-'+CAST([USER_ID] as nvarchar(50)) where USER_CODE = @STD_ID and USER_TYPE = 'Student'
		update TBL_COA set BRC_ID = CAST(@BR_ID as nvarchar(10)),CMP_ID = CAST(@HD_ID as nvarchar(10)) where COA_ID = @coa_id
		--Verify whether pLan_fee_Def Feename is null or not for some studnet
		update d set d.PLAN_FEE_DEF_FEE_NAME = f1.FEE_ID
		from PLAN_FEE_DEF d
		left join FEE_INFO f on f.FEE_ID = d.PLAN_FEE_DEF_FEE_NAME
		left join FEE_INFO f1 on f1.FEE_NAME = f.FEE_NAME and f1.FEE_BR_ID = @BR_ID 
		where PLAN_FEE_DEF_PLAN_ID = @fee_id and PLAN_FEE_DEF_STATUS = 'T'

--		select d.PLAN_FEE_DEF_FEE_NAME,f.FEE_ID,f.FEE_NAME,f1.FEE_NAME,f1.FEE_ID,* from PLAN_FEE_DEF d
--left join FEE_INFO f on f.FEE_ID = d.PLAN_FEE_DEF_FEE_NAME
--left join FEE_INFO f1 on f1.FEE_NAME = f.FEE_NAME and f1.FEE_BR_ID = 1 
--  where PLAN_FEE_DEF_PLAN_ID = 150982 and PLAN_FEE_DEF_STATUS = 'T'
	END

END

--select * from StudentPromotion

--declare @roll int
--	BEGIN				
--				update  STUDENT_ROLL_NUM
--				set 
--				STUDENT_ROLL_NUM_STATUS = 'F',
--				STUDENT_ROLL_NUM_ACTIVE_STATUS = ''					
--				where STUDENT_ROLL_NUM_STD_ID = @FEE_COLLECT_STD_ID				
--				and STUDENT_ROLL_NUM_ACTIVE_STATUS in ('new','old','mov')
							    
--				IF @status = 'T'
--				BEGIN
--							if @FEE_COLLECT_PLAN_ID = 0
--							begin								
									
--									insert into STUDENT_ROLL_NUM
--											values
--											(
--												@FEE_COLLECT_HD_ID,
--												@FEE_COLLECT_BR_ID,
--												@FEE_COLLECT_STD_ID,
--												@FEE_COLLECT_PLAN_ID_OLD,
--												@FE_COLLECT_FEE_ID,
--												0,
--												'F',
--												'out',
--												@SESSION
--											)
																											
									
--									update STUDENT_INFO
--									set 
--									--STDNT_CLASS_PLANE_ID = @FEE_COLLECT_PLAN_ID_OLD,
--									STDNT_STATUS = 'F'									
--									where STDNT_ID = @FEE_COLLECT_STD_ID									
								
--							end ---- std that pass out = plan(0)
							
--							else 
--							begin																																
--											insert into STUDENT_ROLL_NUM
--											values
--											(
--												@FEE_COLLECT_HD_ID,
--												@FEE_COLLECT_BR_ID,
--												@FEE_COLLECT_STD_ID,
--												@FEE_COLLECT_PLAN_ID,
--												@FE_COLLECT_FEE_ID,
--												0,
--												'T',
--												'new',
--												@SESSION
--											)											
											
											
											
--declare @count int
--declare @i int = 1
--set @count =  (select ISNULL( TBL.ROW,0) from (	select COUNT( STUDENT_ROLL_NUM_ID) ROW 	from  STUDENT_ROLL_NUM 
--									 where STUDENT_ROLL_NUM_HD_ID = @FEE_COLLECT_HD_ID
--									 and STUDENT_ROLL_NUM_BR_ID = @FEE_COLLECT_BR_ID
--									 and STUDENT_ROLL_NUM_PLAN_ID = @FEE_COLLECT_PLAN_ID
--									 and STUDENT_ROLL_NUM_STATUS = 'T'
--									 and STUDENT_ROLL_NUM_ACTIVE_STATUS in ('new','old')												
--					) TBL
--				)
				
								
--							while @i <= @count 								
--									begin		
									
									
									
--									update STUDENT_ROLL_NUM
--										set
--										STUDENT_ROLL_NUM_ROLL_NO = 	@i
										
--															where STUDENT_ROLL_NUM_HD_ID = @FEE_COLLECT_HD_ID																
--																 and STUDENT_ROLL_NUM_ID = (
											
--																select ID from (		
--																	select  ROW_NUMBER() OVER(ORDER BY STUDENT_ROLL_NUM_ID) ROW,STUDENT_ROLL_NUM_ID ID 	from  STUDENT_ROLL_NUM 
--																							 where STUDENT_ROLL_NUM_HD_ID = @FEE_COLLECT_HD_ID
--																							 and STUDENT_ROLL_NUM_BR_ID = @FEE_COLLECT_BR_ID
--																							 and STUDENT_ROLL_NUM_PLAN_ID = @FEE_COLLECT_PLAN_ID
--																							 and STUDENT_ROLL_NUM_STATUS = 'T'
--																							 and STUDENT_ROLL_NUM_ACTIVE_STATUS in ('new','old')
																							
																
																
--																			) TBL
--																			where TBL.ROW = @i
									
									
--																)	
																 
																 
--																 and STUDENT_ROLL_NUM_ACTIVE_STATUS in ('new','old')

									
												
--									set @i = @i + 1
--									end	---- while @i <= count
						
--												update  STUDENT_INFO						
--												set STDNT_CLASS_PLANE_ID = @FEE_COLLECT_PLAN_ID
--												where STDNT_ID = @FEE_COLLECT_STD_ID
																		
							
										
--							end	---- std doesnt pass
							   
							
--				END -- std with status = 'T'
				
--		ELSE	
--				BEGIN
							   
--				SET @roll =( select max(STUDENT_ROLL_NUM_ROLL_NO) from  STUDENT_ROLL_NUM				 
--							 where STUDENT_ROLL_NUM_HD_ID = @FEE_COLLECT_HD_ID
--							 and STUDENT_ROLL_NUM_BR_ID = @FEE_COLLECT_BR_ID
--							 and STUDENT_ROLL_NUM_PLAN_ID = @FEE_COLLECT_PLAN_ID_OLD
--							 and STUDENT_ROLL_NUM_STATUS = 'T'
--							 and STUDENT_ROLL_NUM_ACTIVE_STATUS in ('new','old')
--						)
							
--				set @roll = (select ISNULL (@roll,0) + 1 )							
--							insert into STUDENT_ROLL_NUM
--							values
--							(
--								@FEE_COLLECT_HD_ID,
--								@FEE_COLLECT_BR_ID,
--								@FEE_COLLECT_STD_ID,
--								@FEE_COLLECT_PLAN_ID_OLD,
--								@FE_COLLECT_FEE_ID,
--								@roll,
--								'T',
--								'old',
--								@SESSION
--							)
							
														
--						END
						
		
				
	
--	END
	

--select 'ok'