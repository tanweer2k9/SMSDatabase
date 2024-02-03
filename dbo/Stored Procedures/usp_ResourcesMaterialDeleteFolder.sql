

CREATE PROC [dbo].[usp_ResourcesMaterialDeleteFolder]




@Id bigint,
@UserId bigint

AS


declare @countFolders int = 0
declare @countFiles int = 0

declare @msg nvarchar(50)= '' 
 select @countFolders = COUNT(*) from ResourcesMaterialFolders where ParentId = @Id and IsDeleted = 0

if @countFolders = 0
BEGIN
	 select @countFiles = COUNT(*) from ResourcesMaterialFiles where FolderId = @Id 
	 if @countFiles = 0
	 BEGIN
		update ResourcesMaterialFolders set IsDeleted = 1, UpdatedBy = @UserId, UpdatedDate = GETDATE()  where Id = @Id

		delete from ResourcesMaterialFoldersRelation where FolderId = @Id

		select @msg = 'ok'
	 END
	 ELSE
	 BEGIN
		select @msg = 'Files'
	 END
END
ELSE
BEGIN
select @msg = 'Folders'
END


select @msg msg