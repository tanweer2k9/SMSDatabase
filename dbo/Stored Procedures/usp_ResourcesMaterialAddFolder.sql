
CREATE PROC [dbo].[usp_ResourcesMaterialAddFolder]

@Name nvarchar(200),
@ParentId bigint,
@CreatedBy bigint,
@FolderType int,
@Id bigint


AS



if @Id = 0
BEGIN
	insert into ResourcesMaterialFolders 
select @Name,@ParentId,0,@FolderType,GETDATE(),@CreatedBy,NULL,NULL

select @Id = SCOPE_IDENTITY()



declare @tbl table(Sr int identity(1,1),Id bigint, urlId nvarchar(MAX))
;with tab1(ID,Parent_ID) as
(select Id,f.ParentId  from ResourcesMaterialFolders f where id = @Id
union all
select t1.Id,t1.ParentId from ResourcesMaterialFolders t1,tab1 
where tab1.Parent_ID = t1.ID)


insert into ResourcesMaterialFoldersRelation
select 
@Id,t.Id
from tab1 t
join ResourcesMaterialFolders f on f.Id= t.ID
order by f.Id 

insert into ResourcesMaterialUserAccessFolders
select @Id, UserId from ResourcesMaterialUserAccessFolders where FolderId = @ParentId


END
ELSE
BEGIN
	update ResourcesMaterialFolders set Name = @Name, UpdatedBy = @CreatedBy, UpdatedDate = GETDATE()  where Id = @Id
END

select 'ok' msg, @Id Id