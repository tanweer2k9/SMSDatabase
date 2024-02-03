CREATE PROC [dbo].[usp_ResourcesMaterialGetUserEmails]

@FileId bigint,
@Users nvarchar(MAX),
@AccessType nvarchar(50)
AS


if @AccessType = 'File'
BEGIN

DECLARE @Names VARCHAR(8000) 

declare @FolderId bigint = 0, @FileName nvarchar(100) = ''






select @FolderId = FolderId, @FileName = FileName + '.' + FileType from ResourcesMaterialFiles where Id = @FileId


;with tab1(ID,Parent_ID) as
(select Id,f.ParentId  from ResourcesMaterialFolders f where id = @FolderId
union all
select t1.Id,t1.ParentId from ResourcesMaterialFolders t1,tab1 
where tab1.Parent_ID = t1.ID)



select 
--f.Id,f.ParentId,f.Name 
 @Names = COALESCE(@Names + ' --> ', '') +  Name
from tab1 t
join ResourcesMaterialFolders f on f.Id= t.ID
order by f.Id 



select @Names = 'Resources --> ' + @Names + ' --> ' + @FileName 



select  CAST(t.TECH_BR_ID as bigint) BrId, CAST(t.TECH_ID  as bigint)StaffId,t.TECH_FIRST_NAME Name, ISNULL(t.TECH_EMAIL,'') Email, @Names FullPath, @FileName FileName from
(
select CAST(val as numeric) UserId from dbo.split(@Users, ',') where ISNUMERIC(val) = 1

)A
join USER_INFO u on u.USER_ID = A.UserId
join TEACHER_INFO t on t.TECH_ID = u.USER_CODE
END
ELSE
BEGIN
	declare @tblFilesUsers table (UserId bigint,FileId bigint)

	 WHILE LEN(@Users) >0
	 BEGIN
		declare @IEntry nvarchar(200) = ''
		IF CHARINDEX(',', @Users) > 0
		BEGIN
			set @IEntry = SUBSTRING(@Users,0,CHARINDEX(',',@Users))
		END	
		ELSE
		BEGIN
			set @IEntry = @Users
			set @Users = ''
		END

			declare @Id numeric  = 0, @Remarks nvarchar(10)
			set @Id = CAST(SUBSTRING(@IEntry,1,CHARINDEX('-',@IEntry) - 1)  as numeric)
			set @Remarks = SUBSTRING(@IEntry,CHARINDEX('-',@IEntry) +1,LEN(@IEntry) - CHARINDEX('-',@IEntry))
			insert into @tblFilesUsers 
			select @Id, @Remarks
			set @Users = REPLACE(@Users,@IEntry + ',','')
	 END
	 
	 
	
		;WITH cte_numbers(Id, Name, url,urlId) 
		AS (
			SELECT        
			Id,
			Name,
			CAST(Name as varchar(MAX)) url,
			CAST(Id as varchar(MAX)) urlId
		  FROM ResourcesMaterialFolders 
		  WHERE ParentId = 0 and IsDeleted = 0
			UNION ALL
			SELECT    
				mn.Id, 
				mn.Name,
				  cn.url + '-->' + CAST(mn.Name as varchar(MAX)),
					cn.urlId + '-->' + CAST(mn.Id as varchar(MAX))
			FROM    ResourcesMaterialFolders mn
			  join cte_numbers cn on cn.Id = mn.ParentId and IsDeleted = 0
   
		)

		
		----insert into @tblUserEmails
		SELECT CAST(t.TECH_BR_ID as bigint) BrId, CAST(t.TECH_ID as bigint) StaffId,t.TECH_FIRST_NAME Name, ISNULL(t.TECH_EMAIL,'') Email,  url + '-->' + f.FileName + '.'+ FileType FullPath,f.FileName + '.'+ FileType FileName
		FROM cte_numbers c 

		join ResourcesMaterialFiles f on f.FolderId = c.Id
		join @tblFilesUsers A on A.FileId = f.Id
		join USER_INFO u on u.USER_ID = A.UserId
		join TEACHER_INFO t on t.TECH_ID = u.USER_CODE
END