
CREATE PROC usp_RequestFrActivationStudentInfo

@StudentId numeric

AS

--declare @StudentId numeric = 181410




select b.BR_ADM_ID BrId,b.BR_ADM_NAME BranchName, s.STDNT_FIRST_NAME StudentName, s.STDNT_SCHOOL_ID StudentNo, sp.CLASS_Name Class, s.STDNT_DATE_OF_LEAVING DOL, ISNULL((select top(1)  FEE_COLLECT_FEE_TO_DATE  from FEE_COLLECT where FEE_COLLECT_STD_ID = @StudentId and FEE_COLLECT_FEE_STATUS = 'Fully Received' order by FEE_COLLECT_FEE_TO_DATE DESC),'1900-01-01') FeeMonth from STUDENT_INFO s
join SCHOOL_PLANE sp on sp.CLASS_ID = s.STDNT_CLASS_PLANE_ID
join BR_ADMIN b on b.BR_ADM_ID = s.STDNT_BR_ID
where s.stdnt_id = @StudentId