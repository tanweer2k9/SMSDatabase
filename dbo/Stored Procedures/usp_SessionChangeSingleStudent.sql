 CREATE PROC usp_SessionChangeSingleStudent

 @Old_Session nvarchar(50),
 @New_Session nvarchar(50),
 @BrId numeric,
 @StudentId numeric
 AS
 
 
 
-- declare @Old_Session nvarchar(50) = '2020-2021'
--declare @New_Session nvarchar(50) = '2021-2022'
--declare @BrId numeric = 2
--declare @StudentId numeric = 191989


-- declare @Old_Session nvarchar(50) = '2020-2021'
--declare @New_Session nvarchar(50) = '2021-2022'
--declare @BrId numeric = 2
--declare @StudentId numeric = 191989
 
 
 --Student Subject Parent New Session Insertion
insert into tblStudentSubjectsParent
select StudentId, sp1.CLASS_ID,2,GETDATE(),NULL,NULL from tblStudentSubjectsParent p
join STUDENT_INFO s on s.STDNT_ID = p.StudentId --and s.STDNT_STATUS = 'T'
join SCHOOL_PLANE sp on sp.CLASS_ID = p.ClassId 
join LEVELS l on l.LEVEL_ID = sp.CLASS_LEVEL_ID 
join SESSION_INFO si on si.SESSION_ID = sp.CLASS_SESSION_ID and si.SESSION_DESC = @Old_Session
join SCHOOL_PLANE sp1 on sp1.CLASS_Name = sp.CLASS_Name  and sp1.CLASS_BR_ID = sp.CLASS_BR_ID
join SESSION_INFO si1 on si1.SESSION_ID = sp1.CLASS_SESSION_ID and si1.SESSION_DESC = @New_Session
join BR_ADMIN b on b.BR_ADM_ID = s.STDNT_BR_ID and b.BR_ADM_STATUS = 'T'
where sp.CLASS_BR_ID = @BrId and s.STDNT_ID = @StudentId
order by sp.CLASS_BR_ID, sp.CLASS_ORDER, STDNT_SCHOOL_ID







 --Student Subject CHild  New Session Insertion
insert into tblStudentSubjectsChild
select p1.Id,SubjectId, t2.TERM_ID from tblStudentSubjectsChild c
join tblStudentSubjectsParent p on c.PId = p.Id
join SCHOOL_PLANE sp on sp.CLASS_ID = p.ClassId 
join LEVELS l on l.LEVEL_ID = sp.CLASS_LEVEL_ID 
join SESSION_INFO si on si.SESSION_ID = sp.CLASS_SESSION_ID and si.SESSION_DESC = @Old_Session
join STUDENT_INFO s on s.STDNT_ID = p.StudentId --and STDNT_STATUS = 'T'


join SCHOOL_PLANE sp1 on sp1.CLASS_Name = sp.CLASS_Name  and sp1.CLASS_BR_ID = sp.CLASS_BR_ID
join SESSION_INFO si1 on si1.SESSION_ID = sp1.CLASS_SESSION_ID and si1.SESSION_DESC = @New_Session
join tblStudentSubjectsParent p1 on p1.StudentId = p.StudentId and p1.ClassId = sp1.CLASS_ID

join TERM_INFO t1 on t1.TERM_ID = c.TermId
join TERM_INFO t2 on t2.TERM_NAME = t1.TERM_NAME and t1.TERM_BR_ID = t2.TERM_BR_ID and t2.TERM_SESSION_ID = si1.SESSION_ID
where sp.CLASS_BR_ID = @BrId and s.STDNT_ID = @StudentId

 order by p1.Id, t2.TERM_ID,c.SubjectId


--Student Class Plan  New session Insertion
insert into tblStudentClassPlan
select StudentId, sp1.CLASS_ID, si1.SESSION_ID from tblStudentClassPlan c
join SESSION_INFO s on s.SESSION_ID = c.SessionId and s.SESSION_DESC = @Old_Session
join STUDENT_INFO st on st.STDNT_ID = c.StudentId --and st.STDNT_STATUS = 'T'
join SCHOOL_PLANE sp on sp.CLASS_ID = c.ClassId 

join SCHOOL_PLANE sp1 on sp1.CLASS_Name = sp.CLASS_Name  and sp1.CLASS_BR_ID = sp.CLASS_BR_ID
join SESSION_INFO si1 on si1.SESSION_ID = sp1.CLASS_SESSION_ID and si1.SESSION_DESC = @New_Session
where sp.CLASS_BR_ID = @BrId and st.STDNT_ID = @StudentId
order by sp1.CLASS_BR_ID, sp.CLASS_ORDER, st.STDNT_SCHOOL_ID


--Update Students to New ClassId of New Session
update s set STDNT_CLASS_PLANE_ID = sp1.CLASS_ID
--select * 
from STUDENT_INFO s
join SCHOOL_PLANE sp on sp.CLASS_ID = s.STDNT_CLASS_PLANE_ID
join SCHOOL_PLANE sp1 on sp1.CLASS_Name = sp.CLASS_Name and sp1.CLASS_SESSION_ID = (select SESSION_ID from SESSION_INFO where SESSION_DESC = @New_Session and SESSION_BR_ID = sp1.CLASS_BR_ID) and sp.CLASS_BR_ID = sp1.CLASS_BR_ID
where sp.CLASS_BR_ID = @BrId and s.STDNT_ID = @StudentId