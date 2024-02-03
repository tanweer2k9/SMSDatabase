

CREATE PROC [dbo].[usp_ResourcesMaterialGetUsersForAccess]

@UserId bigint,
@FileId bigint,
@AccessType nvarchar(50)

AS

if @AccessType = 'File'
BEGIN


select [key],title,ParentId,IsSelected from 
(select 'T1' [key], 'Branches' title, '0' ParentId, CAST(0 as bit) IsSelected,  0 BrId, '' Designation
union
select 'B' + CAST(b.BR_ADM_ID as nvarchar(5)), b.BR_ADM_NAME,'T1', CAST(0 as bit) IsSelected, b.BR_ADM_ID,'' Designation from BR_ADMIN b where b.BR_ADM_STATUS = 'T'
union
select CAST(u.USER_ID as nvarchar(15)), t.TECH_FIRST_NAME + ' (' +t.TECH_DESIGNATION +' - '+t.TECH_EMAIL+')', 'B' + CAST(b.BR_ADM_ID as nvarchar(5)), IIF(a.Id is null, CAST(0 as bit), CAST(1 as bit)) IsSelected, b.BR_ADM_ID, t.TECH_DESIGNATION from BR_ADMIN b 
join TEACHER_INFO t on t.TECH_BR_ID = b.BR_ADM_ID and t.TECH_STATUS = 'T' 
join USER_INFO u on u.user_code = t.tech_id and u.USER_TYPE in ('A','Teacher')  and u.USER_STATUS = 'T' 
left join ResourcesMaterialUserAccess a on a.UserId = u.User_Id and a.FileId = @FileId
where BR_ADM_STATUS = 'T'  
)A order by BrId,Designation

END
ELSE
BEGIN
	select [key],title,ParentId,IsSelected from 
(select 'T1' [key], 'Branches' title, '0' ParentId, CAST(0 as bit) IsSelected,  0 BrId, '' Designation
union
select 'B' + CAST(b.BR_ADM_ID as nvarchar(5)), b.BR_ADM_NAME,'T1', CAST(0 as bit) IsSelected, b.BR_ADM_ID,'' Designation from BR_ADMIN b where b.BR_ADM_STATUS = 'T'
union
select CAST(u.USER_ID as nvarchar(15)), t.TECH_FIRST_NAME + ' (' +t.TECH_DESIGNATION +' - '+t.TECH_EMAIL+')', 'B' + CAST(b.BR_ADM_ID as nvarchar(5)), IIF(a.Id is null, CAST(0 as bit), CAST(1 as bit)) IsSelected, b.BR_ADM_ID, t.TECH_DESIGNATION from BR_ADMIN b 
join TEACHER_INFO t on t.TECH_BR_ID = b.BR_ADM_ID and t.TECH_STATUS = 'T' 
join USER_INFO u on u.user_code = t.tech_id and u.USER_TYPE in ('A','Teacher')  and u.USER_STATUS = 'T' 
left join ResourcesMaterialUserAccessFolders a on a.UserId = u.User_Id and a.FolderId = @FileId
where BR_ADM_STATUS = 'T'  
)A order by BrId,Designation
END