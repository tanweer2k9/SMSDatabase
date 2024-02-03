
CREATE PROC [dbo].[usp_CustomErrorsInsert]

@SpName nvarchar(100),
@Error nvarchar(1000),
@Data nvarchar(MAX),
@ErrorId bigint out

AS




insert into CustomErrors VALUES (@SpName,@Error,@Data,GETDATE())

set @ErrorId = SCOPE_IDENTITY()