
CREATE PROC [dbo].[usp_ResourcesMaterialGetAllFiles]


@FolderId bigint,
@UserId bigint

AS

declare @IsHeadOffice bit = 0

if (select count(*) from ResourcesMaterialHeadOfficeUsers where UserId = @UserId) > 0 
BEGIN
	set @IsHeadOffice = 1

END

if @IsHeadOffice = 1
BEGIN
	select Id,FileName,FilePath,FileType,IsDownloadable,IsViewable, FORMAT (CreatedDate, 'dd-MM-yyyy hh:mm tt')DateTime from ResourcesMaterialFiles f where FolderId = @FolderId 
END

ELSE 
BEGIN
select f.Id,FileName,FilePath,FileType,IsDownloadable,IsViewable, FORMAT (CreatedDate, 'dd-MM-yyyy hh:mm tt')DateTime from ResourcesMaterialFiles f
join ResourcesMaterialUserAccess u on u.FileId = f.Id 

where FolderId = @FolderId and PublishDate<= cast(GETDATE() as date) and ExpiryDate >= CAST(GETDATE() as date) and u.UserId = @UserId and IsViewable = 1

END