CREATE PROCEDURE  [dbo].[sp_STUDENT_INFO_deletion]
                                               
                                               
        
		  @STDNT_ID  numeric
		 
   
     AS
    

		declare @std_Fee_Id numeric = (select STDNT_CLASS_FEE_ID from STUDENT_INFO where STDNT_ID = @STDNT_ID)

	delete from PLAN_FEE_DEF where PLAN_FEE_DEF_PLAN_ID in (select STDNT_CLASS_FEE_ID from STUDENT_INFO where STDNT_ID = @STDNT_ID)

	delete from tblStudentSubjectsChild where PId in (select Id from tblStudentSubjectsParent where StudentId = @STDNT_ID)

	delete from tblStudentSubjectsParent where StudentId = @STDNT_ID

	delete from FEE_COLLECT_DELETED_HISTORY_DEF where FEE_COLLECT_DEF_PID in ( select FEE_COLLECT_ID from FEE_COLLECT where FEE_COLLECT_STD_ID = @STDNT_ID)

	delete from FEE_COLLECT_DELETED_HISTORY where FEE_COLLECT_STD_ID = @STDNT_ID

	delete from FEE_COLLECT_DEF where FEE_COLLECT_DEF_PID in ( select FEE_COLLECT_ID from FEE_COLLECT where FEE_COLLECT_STD_ID = @STDNT_ID)

	delete from FEE_COLLECT where FEE_COLLECT_STD_ID = @STDNT_ID

	delete from tblStudentClassPlan where StudentId = @STDNT_ID

	delete from STUDENT_INFO where STDNT_ID = @STDNT_ID

	delete from PLAN_FEE where PLAN_FEE_ID =@std_Fee_Id