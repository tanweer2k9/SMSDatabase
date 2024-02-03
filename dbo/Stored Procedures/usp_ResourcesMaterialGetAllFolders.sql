
CREATE PROC [dbo].[usp_ResourcesMaterialGetAllFolders]

@FolderType int = 1,
@UserId bigint
AS

declare @IsHeadOffice bit = 0

if (select count(*) from ResourcesMaterialHeadOfficeUsers where UserId = @UserId) > 0 
BEGIN
	set @IsHeadOffice = 1

END

if @IsHeadOffice = 1
BEGIN
select Id,Name,ParentId,@IsHeadOffice IsHeadOffice from ResourcesMaterialFolders where IsDeleted = 0 and FolderType = @FolderType
END
ELSE
BEGIN

	select Id,Name,ParentId,@IsHeadOffice IsHeadOffice from ResourcesMaterialFolders f
join (select distinct r.FolderRelationId from ResourcesMaterialFoldersRelation r
join ResourcesMaterialFiles f on f.FolderId = r.FolderId
join ResourcesMaterialUserAccess u on u.FileId = f.Id 

where   PublishDate<= cast(GETDATE() as date) and ExpiryDate >= CAST(GETDATE() as date) and u.UserId = @UserId and IsViewable = 1) r on r.FolderRelationId = f.Id

where  IsDeleted = 0 and  FolderType = @FolderType
END