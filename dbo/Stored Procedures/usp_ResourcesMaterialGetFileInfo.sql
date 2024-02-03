CREATE PROC usp_ResourcesMaterialGetFileInfo

@FileId bigint

AS


select Id, FileName +'.' +FileType FileName,IsDownloadable,IsViewable, PublishDate,ExpiryDate from ResourcesMaterialFiles where Id = @FileId