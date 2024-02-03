
CREATE PROC [dbo].[rpt_STUDENT_BASIC_INFO]

@HD_ID numeric,
@BR_ID numeric,
@STATUS char(1),
@CLASS_ID numeric,
@SessionId numeric = 0
AS

--declare @HD_ID numeric = 1
--declare @BR_ID numeric = 1



if @STATUS = 'A'
BEGIN

	select *,ROW_NUMBER() over (order by (select 0) ) sr# from 
	(
	select  sp.CLASS_Name Class, STDNT_CLASS_PLANE_ID,s.STDNT_SCHOOL_ID [Roll No], (s.STDNT_FIRST_NAME + ' ' + s.STDNT_LAST_NAME) [Student Name],h.HOUSES_NAME,LEFT (h.HOUSES_NAME,2) as [House Short],CASE WHEN s.STDNT_SCHOOL_ID = '' THEN 50000 ELSE  CONVERT(numeric(18,0),STDNT_SCHOOL_ID) END as [Sch ID], s.STDNT_HOUSE_ID [House ID],CLASS_ORDER [ClassOrder] from 
	STUDENT_INFO s
	LEFT join HOUSES_INFO h on h.HOUSES_ID = s.STDNT_HOUSE_ID
	join SCHOOL_PLANE sp on sp.CLASS_ID = s.STDNT_CLASS_PLANE_ID
	where s.STDNT_HD_ID = @HD_ID and s.STDNT_BR_ID = @BR_ID and s.STDNT_STATUS = 'T' --and s.STDNT_CLASS_PLANE_ID not in (20064,20072)
	)A order by HOUSES_NAME,[ClassOrder],[Sch ID]

END
ELSE if @STATUS = 'C'
BEGIN
		select * from 
	(
	select ROW_NUMBER() over (order by (select 0) ) sr#, sp.CLASS_Name Class, STDNT_CLASS_PLANE_ID,s.STDNT_SCHOOL_ID [Roll No], (s.STDNT_FIRST_NAME + ' ' + s.STDNT_LAST_NAME) [Student Name],h.HOUSES_NAME, LEFT (h.HOUSES_NAME,2) as [House Short],CASE WHEN s.STDNT_SCHOOL_ID = '' THEN 50000 ELSE  CONVERT(numeric(18,0),STDNT_SCHOOL_ID) END as [Sch ID], s.STDNT_HOUSE_ID [House ID],CLASS_ORDER [ClassOrder] from 
	STUDENT_INFO s
	join HOUSES_INFO h on h.HOUSES_ID = s.STDNT_HOUSE_ID
	join SCHOOL_PLANE sp on sp.CLASS_ID = s.STDNT_CLASS_PLANE_ID
	where s.STDNT_HD_ID = @HD_ID and s.STDNT_BR_ID = @BR_ID and s.STDNT_CLASS_PLANE_ID = @CLASS_ID and s.STDNT_STATUS = 'T'
	)A order by [ClassOrder],[Sch ID]
END
ELSE IF @STATUS = 'F'
BEGIN

declare @one int = 1

if @CLASS_ID = 0
BEGIN
	select top(@one) @CLASS_ID = ID from VSCHOOL_PLANE where [Institute ID] = @HD_ID and [Branch ID] = @BR_ID and Status = 'T' and [Session Id] = @sessionId
END

declare @class nvarchar(50) = '%'



if @CLASS_ID != 0
	set @class = CAST(@CLASS_ID as nvarchar(50))




SELECT ROW_NUMBER() over (order by (select 0)) as Serial, [ID] ,[Student School ID] [Std. School ID] ,[Class Plan] as [Class],[First Name],[Last Name],[Parent Name] [Father's Name],[Fatehr Cell #]
,[Family Code],[House],[Registered Date] DOA,[DOB],[Gender],[Father Address],[P. Area] Area,[P. City] City,[Country],[Religion]  ,[Image],[Session],[Institute ID]
,[Branch ID],[Parent ID],[Fee ID],[Student Registration ID],[Register By ID],[Type],[Previous School],[Mother Language],[Emergency Contact Name]
,[Emergency Contact Cell #],[Cell #],[Temperory Address],[Permanant Address],[Transport],[Email Address]   ,[Status],[Date],[Session ID],[Description],[Discount Rule ID]
,[House ID],[Conduct ID],[Conduct],[Date of Leaving],[With Draw No],[Category],[Remarks],[City ID],[City] as [Std. City],[Area ID],[Area] as [Std. Area],[Class ID]
  ,(select COUNT(*) from FEE_COLLECT where FEE_COLLECT_STD_ID = ID) as [Fee Count] FROM VSTUDENT_INFO
         where [Institute ID] = @HD_ID   
    and  [Branch ID] = @BR_ID
    and  [Status] = 'T' and [SessionId] = @SessionId
	and [Class ID] like @class

    order by ID

	
	select ID, Name from VSCHOOL_PLANE where [Institute ID] = @HD_ID and [Branch ID] = @BR_ID and Status = 'T' and [Session Id] = @sessionId order by [Order]
END