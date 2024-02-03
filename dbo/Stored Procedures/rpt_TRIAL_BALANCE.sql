CREATE PROCEDURE [dbo].[rpt_TRIAL_BALANCE]

		 @START_DATE date ,
		 @END_DATE date ,
		 @HD_ID numeric,
		 @BR_ID numeric ,
		 @STATUS char(2)

AS BEGIN

--declare @START_DATE date = '2013-03-30'
--declare @END_DATE date = '2013-11-30'
--declare @HD_ID numeric = 1
--declare @BR_ID numeric = 1
--declare @STATUS char(2) = 'R'


--if @STATUS = 'B'
--begin
--	SELECT ID,Name FROM V_BRANCH_INFO
--		where [Institute ID] = @HD_ID
--		and [Status] != 'D'
--end


--else 
if @STATUS = 'R'
begin
	
;with tbl as
(
		select ID,Name, [Type], Class, Designation, ISNULL(Sum(Debit),0) as Debit, ISNULL(Sum(Credit),0) as Credit from 		
		(
		select f.FEE_COLLECT_STD_ID as ID, s.STDNT_FIRST_NAME as Name, 'Student' as [Type], p.CLASS_Name as Class, '-' as Designation,
		SUM(f.FEE_COLLECT_FEE + f.FEE_COLLECT_ARREARS) as Debit, 0 as Credit
		from FEE_COLLECT  f
		join STUDENT_INFO s
		on s.STDNT_ID = f.FEE_COLLECT_STD_ID
		join SCHOOL_PLANE p
		on p.CLASS_ID = s.STDNT_CLASS_PLANE_ID	

		where f.FEE_COLLECT_DATE_FEE_GENERATED between @START_DATE and @END_DATE and f.FEE_COLLECT_BR_ID in ( select * from dbo.get_all_br_id(@BR_ID)) 
		and f.FEE_COLLECT_HD_ID in ( select * from dbo.get_all_hd_id(@HD_ID)) and f.FEE_COLLECT_FEE_STATUS not in ('Fully Transfered', 'Partially Transfered')
		group by f.FEE_COLLECT_STD_ID, s.STDNT_FIRST_NAME, p.CLASS_Name		
		
		union all	
		
		select f.FEE_COLLECT_STD_ID as ID, s.STDNT_FIRST_NAME as Name, 'Student' as [Type], p.CLASS_Name as Class, '-' as Designation,
		SUM(f.FEE_COLLECT_FEE_PAID + f.FEE_COLLECT_ARREARS_RECEIVED) as Debit, 0 as Credit
		from FEE_COLLECT  f
		join STUDENT_INFO s
		on s.STDNT_ID = f.FEE_COLLECT_STD_ID
		join SCHOOL_PLANE p
		on p.CLASS_ID = s.STDNT_CLASS_PLANE_ID	

		where f.FEE_COLLECT_DATE_FEE_GENERATED between @START_DATE and @END_DATE and f.FEE_COLLECT_BR_ID in ( select * from dbo.get_all_br_id(@BR_ID)) 
		and f.FEE_COLLECT_HD_ID in ( select * from dbo.get_all_hd_id(@HD_ID)) and f.FEE_COLLECT_FEE_STATUS = 'Partially Transfered'
		group by f.FEE_COLLECT_STD_ID, s.STDNT_FIRST_NAME, p.CLASS_Name
		
		
		union all
		
		select fr.FEE_COLLECT_STD_ID as ID, s.STDNT_FIRST_NAME as Name, 'Student' as [Type], p.CLASS_Name as Class, '-' as Designation,
		0 as Debit, SUM(fr.FEE_COLLECT_FEE_PAID + fr.FEE_COLLECT_ARREARS_RECEIVED) as Credit
		from FEE_COLLECT  fr
		join STUDENT_INFO s
		on s.STDNT_ID = fr.FEE_COLLECT_STD_ID
		join SCHOOL_PLANE p
		on p.CLASS_ID = s.STDNT_CLASS_PLANE_ID	

		where fr.FEE_COLLECT_DATE_FEE_RECEIVED between @START_DATE and @END_DATE and fr.FEE_COLLECT_BR_ID in ( select * from dbo.get_all_br_id(@BR_ID)) 
		and fr.FEE_COLLECT_HD_ID in (select * from dbo.get_all_hd_id(@HD_ID)) and fr.FEE_COLLECT_FEE_STATUS  != 'Fully Transfered'
		group by fr.FEE_COLLECT_STD_ID, s.STDNT_FIRST_NAME, p.CLASS_Name 
		)A group by A.ID, A.Name,A.Type, A.Class,A.Designation, A.Debit, A.Credit
		)
		select ROW_NUMBER() over (order by (ID)) as Sr#,ID,Name,Type,Class,Designation,ISNULL(SUM(Debit),0) as Debit,ISNULL(SUM(Credit),0) as Credit from tbl group by ID,Name,Type,Class,Designation

		union all

		select ROW_NUMBER() over (order by (s.STAFF_SALLERY_STAFF_ID)) as Sr#, s.STAFF_SALLERY_STAFF_ID as ID, t.TECH_FIRST_NAME as Name, 'Staff' as [Type], '-' as CLass, t.TECH_DESIGNATION as Designation,
		SUM(s.STAFF_SALLERY_NET_RECEIVED) as Debit, SUM(sr.STAFF_SALLERY_NET_TOLTAL) as Credit
		from STAFF_SALLERY  s
		join TEACHER_INFO t
		on t.TECH_ID = s.STAFF_SALLERY_STAFF_ID
		join STAFF_SALLERY sr
		on t.TECH_ID = sr.STAFF_SALLERY_STAFF_ID


		where s.STAFF_SALLERY_DATE between @START_DATE and @END_DATE 	
		and sr.STAFF_SALLERY_DATE between @START_DATE and @END_DATE 	
		and s.STAFF_SALLERY_HD_ID in (select * from dbo.get_all_hd_id(@HD_ID)) and s.STAFF_SALLERY_BR_ID in (select * from dbo.get_centralized_br_id('S',@BR_ID))
		group by s.STAFF_SALLERY_STAFF_ID, t.TECH_FIRST_NAME, t.TECH_DESIGNATION

end

END