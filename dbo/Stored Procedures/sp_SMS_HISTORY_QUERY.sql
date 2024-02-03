CREATE PROC [dbo].[sp_SMS_HISTORY_QUERY]

-- from session
 @HD_ID AS NUMERIC,
 @BR_ID AS NUMERIC,
 @USER_LOGIN_ID AS NUMERIC,

 -- from page
 @FROM_DATE AS DATE,
 @TO_DATE AS DATE

 AS
 BEGIN

 declare @usertype as nvarchar(50)
 declare @adminCheck as int
 select @usertype = (select top(1) USER_TYPE from USER_INFO where USER_ID=@USER_LOGIN_ID)
 select @adminCheck= count(*) from TEACHER_INFO where TECH_USER_INFO_ID=@USER_LOGIN_ID
 if @usertype='SA'
 begin
 SELECT ROW_NUMBER()OVER (ORDER BY (SELECT 0)) AS Serial,[Message ID]      ,[Mobile No]      ,[Message]      ,[Date]      ,[Screen Name]      ,[User Login ID]     
 ,[Client PC Name]      ,[Client PC OS]
	   FROM VSMS_HISTORY_QUERY v WHERE HD_ID=@HD_ID 
and cast(Date as date) between @FROM_DATE and @TO_DATE
 end
 else if @usertype='IT'
 
 begin
 SELECT ROW_NUMBER()OVER (ORDER BY (SELECT 0)) AS Serial,[Message ID]      ,[Mobile No]      ,[Message]      ,[Date]      ,[Screen Name]      ,[User Login ID]     
 ,[Client PC Name]      ,[Client PC OS]
	   FROM VSMS_HISTORY_QUERY v WHERE cast(Date as date) between @FROM_DATE and @TO_DATE

 end

 

 else if @usertype='A' and @adminCheck=0
 begin
 SELECT ROW_NUMBER()OVER (ORDER BY (SELECT 0)) AS Serial,[Message ID]      ,[Mobile No]      ,[Message]      ,[Date]      ,[Screen Name]      ,[User Login ID]     
 ,[Client PC Name]      ,[Client PC OS]
	   FROM VSMS_HISTORY_QUERY v WHERE HD_ID=@HD_ID AND BR_ID=@BR_ID 
and cast(Date as date) between @FROM_DATE and @TO_DATE
 end
 
 else if @usertype='A' and @adminCheck<>0

 begin
SELECT ROW_NUMBER()OVER (ORDER BY (SELECT 0)) AS Serial,[Message ID]      ,[Mobile No]      ,[Message]      ,[Date]      ,[Screen Name]      ,[User Login ID]     
 ,[Client PC Name]      ,[Client PC OS]
	   FROM VSMS_HISTORY_QUERY v WHERE HD_ID=@HD_ID AND BR_ID=@BR_ID AND [User Login ID]=@USER_LOGIN_ID
and cast(Date as date) between @FROM_DATE and @TO_DATE
end

END