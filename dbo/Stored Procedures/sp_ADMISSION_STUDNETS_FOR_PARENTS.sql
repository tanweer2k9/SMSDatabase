

CREATE PROC [dbo].[sp_ADMISSION_STUDNETS_FOR_PARENTS]

@HD_ID numeric,
@BR_ID numeric,
@USER_ID numeric,
@STATUS char


AS



select s.STDNT_HD_ID [HD ID],s.STDNT_BR_ID [BR ID],s.STDNT_IMG [Image],STDNT_SCHOOL_ID [Student #], s.STDNT_ID ID,sp.CLASS_ID [Class ID],STDNT_FIRST_NAME Name, sp.CLASS_Name [Class],p.PARNT_CELL_NO [Cell #], p.PARNT_FAMILY_CODE [Family Code], h.HOUSES_NAME [House], FORMAT(s.STDNT_DOB, 'dd-MMM-yyyy', 'en-us') DOB,p.PARNT_PERM_ADDR + ' ' + a.AREA_NAME + ', '+ c.CITY_NAME [Address], l.LEVEL_LEVEL [Class Level],CASE WHEN s.STDNT_GENDER = 1 THEN 'Male' ELSE 'Female' END Gender, u.USER_ID UserPkId,ISNULL(eh.IsAssessmentExamShow, cast(1 as bit)) IsAssessmentExamShow,ISNULL(eh.IsRegularExamShow, cast(1 as bit)) IsRegularExamShow  from STUDENT_INFO s 
join SCHOOL_PLANE sp on sp.CLASS_ID = s.STDNT_CLASS_PLANE_ID
join PARENT_INFO p on p.PARNT_ID = s.STDNT_PARANT_ID
join HOUSES_INFO h on h.HOUSES_ID = s.STDNT_HOUSE_ID
left join AREA_INFO a on a.AREA_ID = p.PARNT_AREA
left join CITY_INFO c on c.CITY_ID = p.PARNT_CITY
join LEVELS l on l.LEVEL_ID = sp.CLASS_LEVEL_ID
join USER_INFO u on u.USER_CODE = s.STDNT_ID and u.USER_TYPE = 'Student'
left join ExamHault eh on eh.BrId = s.STDNT_BR_ID
where STDNT_PARANT_ID = @USER_ID and STDNT_STATUS = 'T'