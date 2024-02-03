

CREATE PROC [dbo].[usp_ResouresMaterialAddFile]

@Id bigint,
@BrId bigint,
@FileName nvarchar(100),
@FilePath nvarchar(500),
@FileType nvarchar(50),
@FolderId int,
@IsDownloadable bit,
@IsViewable bit,
@PublishDate date,
@ExpiryDate date,
@CreatedBy bigint
AS




if @Id = 0
BEGIN


insert into ResourcesMaterialFiles
select @BrId,@FileName,@FilePath,@FileType,@FolderId,@IsDownloadable,@IsViewable,@PublishDate,@ExpiryDate,GETDATE(),@CreatedBy,NULL,NULL

declare @FileId bigint = (select SCOPE_IDENTITY())

insert into ResourcesMaterialUserAccess
select @FileId, UserId from ResourcesMaterialUserAccessFolders where FolderId = @FolderId
END
ELSE
BEGIN
	update ResourcesMaterialFiles set ExpiryDate = @ExpiryDate, PublishDate = @PublishDate, IsViewable = @IsViewable, IsDownloadable = @IsDownloadable, UpdatedBy = @CreatedBy, UpdatedDate = GETDATE() where Id = @Id
END