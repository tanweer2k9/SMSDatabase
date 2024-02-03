
CREATE PROC [dbo].[usp_ResourcesMaterialUpdateUserAccess]

@FileId bigint,
@Users nvarchar(MAX),
@AccessType nvarchar(50)
AS

if @AccessType = 'File'
BEGIN

delete from ResourcesMaterialUserAccess where FileId = @FileId

insert into ResourcesMaterialUserAccess
select @FileId,CAST(val as numeric) UserId from dbo.split(@Users, ',') where ISNUMERIC(val) = 1
END
BEGIN if @AccessType = 'Folder'

delete from ResourcesMaterialUserAccessFolders where FolderId in (select FolderId from ResourcesMaterialFoldersRelation r
where FolderRelationId = @FileId)



insert into ResourcesMaterialUserAccessFolders
select FolderId,CAST(val as numeric) UserId from dbo.split(@Users, ',') s
cross join ResourcesMaterialFoldersRelation r
where FolderRelationId = @FileId and ISNUMERIC(val) = 1


declare @tblFileIds table (FileId bigint)

insert into @tblFileIds
select f.Id
from ResourcesMaterialFiles f
join ResourcesMaterialFoldersRelation r on r.FolderId = f.FolderId
where FolderRelationId = @FileId

delete from ResourcesMaterialUserAccess where FileId in (select FileId from @tblFileIds f)


insert into ResourcesMaterialUserAccess
select FileId, CAST(val as numeric) UserId from dbo.split(@Users, ',') s
cross join @tblFileIds
where ISNUMERIC(val) = 1

END