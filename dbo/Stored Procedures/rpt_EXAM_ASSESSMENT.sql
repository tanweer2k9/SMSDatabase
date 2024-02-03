
CREATE PROC [dbo].[rpt_EXAM_ASSESSMENT]


@CLASS_ID numeric ,
@STD_ID numeric , 
@PID numeric

AS




declare @std nvarchar(50) = '%'
if @STD_ID != 0
BEGIN
	set @std = CAST(@STD_ID as nvarchaR(50))
END

declare @is_admin_enter_marks bit = 0
declare @one int = 1

set @is_admin_enter_marks = (select BR_ADM_IS_ENTER_MARKS from BR_ADMIN where BR_ADM_ID = (select CLASS_BR_ID from SCHOOL_PLANE where CLASS_ID = @CLASS_ID))

if @PID = -1
BEGIN
	 set @PID =  (select top(@one) Id  from EXAM_STD_INFO e
	join  EXAM_CRITERIA_KEY_Parent p on p.Id = e.EXAM_STD_PID
	where EXAM_STD_INFO_STD_ID = @STD_ID and EXAM_STD_CLASS_ID = @CLASS_ID order by Id DESC)
END



select * from
(
select e.[Std ID],e.[Class ID] ,s.STDNT_FIRST_NAME [Name], s.STDNT_SCHOOL_ID [School ID], t.TECH_FIRST_NAME as Teacehr, ROUND(e.Height,3)Height ,ROUND(e.Weight,3)Weight, e.[Days Attended], e.[Days Absent],
e.[Teacher Comments],e.[Principal Comments] ,p.CLASS_Name + ' Progress Report' [Class Name],
(DATEDIFF(M,s.STDNT_DOB, GETDATE())) - ((DATEDIFF(M,s.STDNT_DOB, GETDATE())) / 12) * 12  as Months, ((DATEDIFF(M,s.STDNT_DOB, GETDATE())) / 12) as Years,
(select COUNT(*) from EXAM_CRITERIA_KEY k where  k.CRITERIA_KEY_CLASS_ID = @CLASS_ID and  k.CRITERIA_KEY_STD_ID = e.[Std ID] and k.CRITERIA_KEY_PID = @PID
-- and 
--(
--k.CRITERIA_KEY_PRINCIPAL is not null OR --comment due to  
--@is_admin_enter_marks = 1 
--)
) StdCount, e.PID, ISNULL(ep.Title,'') Title, '<p style="margin: 0pt; line-height: 1.25;"><span style="font-family: Times New Roman; font-size: 12pt;font-style: italic">Completes CITREX Online Assignments on time: </span><span style="font-size: 12pt;text-decoration: underline;font-weight: bold;">&nbsp;&nbsp;&nbsp;'+ [Citrix Complete]+'&nbsp;&nbsp;</span></p>
<p style="margin: 0pt; line-height: 1.25;"><span style="font-family: Times New Roman; font-size: 12pt;font-style: italic">CITREX Online Assignments Score Average (English):</span><span style="font-size: 12pt;text-decoration: underline;font-weight: bold;">&nbsp;&nbsp;&nbsp;'+ [Citrix English Score]+'&nbsp;&nbsp;</span></p>
<p style="margin: 0pt; line-height: 1.25;"><span style="font-family: Times New Roman; font-size: 12pt;font-style: italic">CITREX Online Assignments Score Average (Mathematics):</span><span style="font-size: 12pt;text-decoration: underline;font-weight: bold;">&nbsp;&nbsp;&nbsp;'+ [Citrix Math Score]+'&nbsp;&nbsp;</span></p>' + IIF(c.CLASS_NAME = 'Play Group', '', '<p style="margin: 0pt; line-height: 1.25;"><span style="font-family: Times New Roman; font-size: 12pt;font-style: italic">CITREX Online Assignments Score Average (Urdu):</span><span style="font-size: 12pt;text-decoration: underline;font-weight: bold;">&nbsp;&nbsp;&nbsp;'+ [Citrix Urdu Score]+'&nbsp;&nbsp;</span></p>') CitrixInfo


from VExam_std_info e
join STUDENT_INFO s  on s.STDNT_ID = e.[Std ID]
join SCHOOL_PLANE p on p.CLASS_ID = e.[Class ID]
join TEACHER_INFO t on t.TECH_ID = p.CLASS_TEACHER
left join EXAM_CRITERIA_KEY_Parent ep on ep.Id = e.PID
left join CLASS_INFO c on c.CLASS_ID = p.CLASS_CLASS
where e.[Class ID] = @CLASS_ID and e.[Std ID] like @std and s.STDNT_STATUS = 'T' and e.PID = @PID  and s.STDNT_CLASS_PLANE_ID = @CLASS_ID
and e.Disapprove = 0
)B where B.StdCount != 0

order by CAST([School ID] as int)