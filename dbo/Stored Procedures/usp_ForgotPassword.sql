CREATE PROC usp_ForgotPassword 
@MoibleNo nvarchar(15)  

As



declare @one int = 1

select top(@one) Username,Password, Name,UserId,BrId,HdId  from
(
select  u.USER_NAME Username,u.USER_PASSWORD Password, ISNULL(p.PARNT_FIRST_NAME,'') Name, u.USER_ID UserId, u.USER_BR_ID BrId, u.USER_HD_ID HdId from USER_INFO u
join PARENT_INFO p on u.USER_CODE = p.PARNT_ID and u.USER_TYPE = 'Parent'
join STUDENT_INFO s on s.STDNT_PARANT_ID = p.PARNT_ID
join SCHOOL_PLANE sp on sp.CLASS_ID = s.STDNT_CLASS_PLANE_ID and sp.CLASS_STATUS = 'T'
join LEVELS l on l.LEVEL_ID = sp.CLASS_LEVEL_ID and l.LEVEL_LEVEL = 1
join BR_ADMIN b on b.BR_ADM_ID = s.STDNT_BR_ID and b.BR_ADM_STATUS = 'T'
where USER_STATUS = 'T' and USER_TYPE = 'Parent' and s.STDNT_STATUS = 'T'

and p.PARNT_CELL_NO = @MoibleNo
union 
select  u.USER_NAME Username,u.USER_PASSWORD Password,ISNULL(t.TECH_FIRST_NAME,'') Name, u.USER_ID UserId, u.USER_BR_ID BrId, u.USER_HD_ID HdId  from USER_INFO u
join TEACHER_INFO t on u.USER_CODE = t.TECH_ID
join BR_ADMIN b on b.BR_ADM_ID = u.USER_BR_ID and b.BR_ADM_STATUS = 'T'
join SCHOOL_PLANE sp on sp.CLASS_TEACHER = t.TECH_ID and sp.CLASS_SESSION_ID = b.BR_ADM_SESSION
join LEVELS l on l.LEVEL_ID = sp.CLASS_LEVEL_ID and l.LEVEL_LEVEL = 1
where USER_STATUS = 'T' and (USER_TYPE = 'A' OR USER_TYPE = 'Teacher') and t.TECH_STATUS = 'T'

and t.TECH_CELL_NO = @MoibleNo
union 
select  u.USER_NAME Username,u.USER_PASSWORD Password,ISNULL(t.TECH_FIRST_NAME,'') Name, u.USER_ID UserId, u.USER_BR_ID BrId, u.USER_HD_ID HdId  from USER_INFO u
join TEACHER_INFO t on u.USER_CODE = t.TECH_ID
join BR_ADMIN b on b.BR_ADM_ID = u.USER_BR_ID and b.BR_ADM_STATUS = 'T'
join MobileAppPreSchoolAdmin ad on ad.UserId = u.USER_ID
where t.TECH_CELL_NO = @MoibleNo
)A