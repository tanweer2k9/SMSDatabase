
CREATE procedure  [dbo].[sp_SUPLEMENTARY_STUDENTS_SETTINGS_selection]
                                               
                                               
     @STATUS char(10),
     @SUPL_STD_ID  numeric,
     @SUPL_STD_HD_ID  numeric,
     @SUPL_STD_BR_ID  numeric,
	 @SUPL_STD_STUDENT_ID numeric,
	 @SUPL_CLASS_ID numeric
   
   
     AS 
   
   
   declare @class nvarchar(50) = '%'
   declare @std nvarchar(50) = '%'

   if @SUPL_STD_STUDENT_ID != 0
		set @std = CAST(@SUPL_STD_STUDENT_ID as nvarchar(50))

	if @SUPL_CLASS_ID != 0
		set @class = CAST(@SUPL_CLASS_ID as nvarchar(50))


   select * from
   (
   select sg.SCH_GEN_ID ID, s.STDNT_SCHOOL_ID [School ID],CAST(s.STDNT_SCHOOL_ID as int) as [School ID int], s.STDNT_FIRST_NAME [Student Name], sp.CLASS_Name Class,s.STDNT_LAB_TYPE [Lab Type],sc.SCH_DRAW_NAME [Scholarship],f.FEE_COLLECT_NET_TOATAL [Normal Fee], dbo.get_month_name(f.FEE_COLLECT_FEE_FROM_DATE,f.FEE_COLLECT_FEE_TO_DATE) [Month],sg.SCH_GEN_GPA GPA, sg.SCH_GEN_FEE Fee ,sg.SCH_GEN_PERCENT Percentage,sp.CLASS_ID [Class ID],s.STDNT_SCHOLARSHIP_ID [Scholarship ID], (sg.SCH_GEN_FEE *sg.SCH_GEN_PERCENT)/100  [Fee Due],sg.SCH_GEN_STD_ID [Std ID]
    from SCHOLARSHIP_GENERATION sg
   join STUDENT_INFO s on s.STDNT_ID = sg.SCH_GEN_STD_ID
   join SCHOOL_PLANE sp on sp.CLASS_ID = s.STDNT_CLASS_PLANE_ID
   join FEE_COLLECT f on f.FEE_COLLECT_ID = sg.SCH_GEN_FEE_COLLECT_ID
   left join SCHOLARSHIP_WITHDRAWL sc on sc.SCH_DRAW_ID = s.STDNT_SCHOLARSHIP_ID
   where SCH_GEN_HD_ID =@SUPL_STD_HD_ID and SCH_GEN_BR_ID = @SUPL_STD_BR_ID and SCH_GEN_IS_CLEARED = 0 and s.STDNT_STATUS = 'T'
   )A where A.[Class ID] like @class and A.[Std ID] like @std order by A.[Class ID],A.[School ID int]



   select d.* from 
   SCHOLARSHIP_WITHDRAWL p
   join SCHOLARSHIP_WITHDRAWL_DEF d on d.SCH_DRAW_DEF_PID = p.SCH_DRAW_ID
   where p.SCH_DRAW_HD_ID = @SUPL_STD_HD_ID and p.SCH_DRAW_BR_ID = @SUPL_STD_BR_ID
   

   select distinct ID, Name from VSCHOOL_PLANE where ID in (select SCH_GEN_CLASS_ID from SCHOLARSHIP_GENERATION where SCH_GEN_HD_ID =@SUPL_STD_HD_ID and SCH_GEN_BR_ID = @SUPL_STD_BR_ID and SCH_GEN_IS_CLEARED = 0)

   select  ID,[Student School ID], [Institute ID],[Branch ID],[Class Plan] as [Class Name],[First Name] as [Student Name],[Parent Name] as Parent, [Family Code],[Cell #] as [Cell NO#], [Fee ID], [Fee Plan] as [Fee Name], [Parent ID],[Status],[Class ID] from VSTUDENT_INFO
   where [Status] = 'T' and [Class ID] like @class  and ID in (select SCH_GEN_STD_ID from SCHOLARSHIP_GENERATION where SCH_GEN_HD_ID =@SUPL_STD_HD_ID and SCH_GEN_BR_ID = @SUPL_STD_BR_ID and SCH_GEN_IS_CLEARED = 0)

     
  -- Select ID,[School ID],[Student Name],[Class],GPA,Fee,Percentage from




  --   (SELECT [Student ID] ID,[School ID],[Student Name],[Class],GPA,Fee,Percentage,[Class ID],CAST([School ID] as int) as [School ID int]  FROM VSUPLEMENTARY_STUDENTS_SETTINGS
	 -- where [HD ID] = @SUPL_STD_HD_ID and [BR ID] = @SUPL_STD_BR_ID and [Student ID] in (select STDNT_ID from STUDENT_INFO where STDNT_STATUS = 'T' )
	 --union
	 --select s.STDNT_ID, s.STDNT_SCHOOL_ID,s.STDNT_FIRST_NAME,sp.CLASS_Name, 0,0,0,s.STDNT_CLASS_PLANE_ID as [Class ID],CAST(s.STDNT_SCHOOL_ID as int) as [School ID int] from 
	 --STUDENT_INFO s
	 --join SCHOOL_PLANE sp on sp.CLASS_ID = s.STDNT_CLASS_PLANE_ID
	 --where sp.CLASS_IS_SUPPLEMENTARY_BILLS = 1 and s.STDNT_HD_ID = @SUPL_STD_HD_ID and s.STDNT_BR_ID = @SUPL_STD_BR_ID
	 --and s.STDNT_ID not in (SELECT [Student ID] FROM VSUPLEMENTARY_STUDENTS_SETTINGS
	 -- where [HD ID] = @SUPL_STD_HD_ID and [BR ID] = @SUPL_STD_BR_ID ) and s.STDNT_STATUS = 'T'
	 -- )A order by A.[Class ID],A.[School ID int]