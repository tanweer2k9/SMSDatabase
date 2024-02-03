CREATE PROC usp_ResoucesMaterialGetAlreadyAssignedUsersAccessFiles


@FileId bigint,
@AccessType nvarchar(50)
AS


if @AccessType = 'File'
BEGIN
	select CAST(UserId as nvarchar(50)) Users From ResourcesMaterialUserAccess where FileId = @FileId
END
else
BEGIN
	select  CAST(UserId as nvarchar(50))+ '-'+  CAST(FileId as nvarchar(50)) Users  From ResourcesMaterialUserAccess  af
join ResourcesMaterialFiles f on f.Id = af.FileId
join ResourcesMaterialFoldersRelation fr on fr.FolderId = f.FolderId

where  fr.FolderRelationId = @FileId
END