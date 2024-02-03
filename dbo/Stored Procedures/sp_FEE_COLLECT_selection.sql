
CREATE procedure  [dbo].[sp_FEE_COLLECT_selection]                                                                                            
     @STATUS char(10),
     @FEE_COLLECT_ID  numeric,
     @FEE_COLLECT_ID_DESC  numeric,
     @FEE_COLLECT_HD_ID  numeric,
     @FEE_COLLECT_BR_ID  numeric,
	 @FEE_COLLECT_CLASS_IDS nvarchar(500) = ''	   
     AS BEGIN    

Begin Try

	 declare @SessionId numeric

	 set @SessionId = (select BR_ADM_SESSION from BR_ADMIN where BR_ADM_ID = @FEE_COLLECT_BR_ID)


	 declare @tbl_br_id table (BR_ID int)
	 if (select COUNT(*) from COMBINE_BRANCHES where FROM_BRANCH_ID = @FEE_COLLECT_BR_ID) > 0
				BEGIN
					insert into @tbl_br_id
					select COMBINE_BRANCHES_ID from COMBINE_BRANCHES where FROM_BRANCH_ID  = @FEE_COLLECT_BR_ID
				END
				ELSE
				BEGIN
					insert into @tbl_br_id
					select @FEE_COLLECT_BR_ID
				END

	 -- variable @FEE_COLLECT_ID is Student ID
	 -- variable @FEE_COLLECT_ID_DESC is Fee ID
	  if @FEE_COLLECT_ID_DESC = -2
	 BEGIN
		set @FEE_COLLECT_ID = (select STDNT_ID from STUDENT_INFO  with (nolock) where STDNT_BR_ID = @FEE_COLLECT_BR_ID and STDNT_HD_ID = @FEE_COLLECT_HD_ID and  CAST(STDNT_SCHOOL_ID as numeric) = @FEE_COLLECT_ID 
		and STDNT_STATUS != 'D' 
		)
		set @FEE_COLLECT_ID_DESC = (select top(1) FEE_COLLECT_ID from FEE_COLLECT with (nolock) where FEE_COLLECT_STD_ID = @FEE_COLLECT_ID and FEE_COLLECT_FEE_STATUS not like '%Transfered%' order by FEE_COLLECT_ID DESC)
	 END

	 if @FEE_COLLECT_ID = -1
		BEGIN
			
			select @FEE_COLLECT_ID =  FEE_COLLECT_STD_ID,@FEE_COLLECT_ID_DESC = FEE_COLLECT_ID  from FEE_COLLECT with (nolock) where FEE_COLLECT_CHALLAN_NO = @FEE_COLLECT_ID_DESC
		END

	 declare @is_advance_account bit = 0

	 set @is_advance_account = (select top(1) BR_ADM_IS_ADVANCE_ACCOUNTING from BR_ADMIN where BR_ADM_HD_ID =@FEE_COLLECT_HD_ID and BR_ADM_ID = @FEE_COLLECT_BR_ID)

	 --Change [Invoice ID] to nvarchar due to Ina Accounts Vch_reference In Main tbl_vch_main is multiple invoice Ids comma seperate
	 declare @tbl table ([Invoice ID] nvarchar(100),[COA Code] nvarchaR(100),Amount nvarchaR(100), [Cash Type] nvarchar(50))
	 
	 --Due to remove left join in soreprocedure exec
	-- declare @tbl table ([Invoice ID] int,hand_code nvarchaR(100), Cash_in_hand nvarchaR(100), bank_code nvarchaR(100),Cash_at_bank nvarchaR(100),
	--chequ_date date, cheque_no nvarchaR(100))

	insert into @tbl exec sp_FEE_COLLECT_selection_acounts @FEE_COLLECT_ID_DESC, @FEE_COLLECT_HD_ID, @FEE_COLLECT_BR_ID

	 Declare @max_date Date
   if @STATUS = 'G'
   begin
		
   select ID,[Student School ID], [Institute ID],[Branch ID],[Class Plan] as [Class Name],[First Name] as [Student Name],[Parent Name] as Parent, [Family Code],[Cell #] as [Cell NO#], [Fee ID], [Fee Plan] as [Fee Name], [Parent ID],[Status] from VSTUDENT_INFO
   where [Institute ID] = @FEE_COLLECT_HD_ID and SessionId = @SessionId and
   [Branch ID] = @FEE_COLLECT_BR_ID 
   and
   [Status] != 'D' order by [Class Order], [Student School ID]
   
   
   select 0 ID,'All Classess' Name
   union
   select ID,Name from VSCHOOL_PLANE where [Institute ID] = @FEE_COLLECT_HD_ID and [Branch ID] = @FEE_COLLECT_BR_ID and [status] = 'T'     and  [Session Id] = @SessionId
   

   select c.*,  h.MAIN_INFO_INSTITUTION_SHORT_NAME + ' - ' +b.BR_ADM_NAME [Branch]from combine_branches c
join BR_ADMIN b on c.COMBINE_BRANCHES_ID = b.BR_ADM_ID
join MAIN_HD_INFO h on h.MAIN_INFO_ID = b.BR_ADM_HD_ID


   end
   
   
   
   else if @STATUS = 'L'
   begin
	   
		SELECT *,([Current Fee] + Arrears - [Fee Received] - [Arrears Received]) as Remaining FROM VFEE_COLLECT_DEF  as Collection_deff	    with (nolock) 
		where ID is null
		   
	    SELECT *,([Current Fee] + Arrears - [Fee Received] - [Arrears Received]) as Remaining FROM VFEE_COLLECT as Receiveables		 with (nolock)	   
		where [Institute ID] = @FEE_COLLECT_HD_ID and
	   [Branch ID] = @FEE_COLLECT_BR_ID and
	   [Status] is null 
	
		SELECT * FROM VFEE_COLLECT as Paid  with (nolock)
		where [Institute ID] = @FEE_COLLECT_HD_ID and
	   [Branch ID] = @FEE_COLLECT_BR_ID and
	   [Status] is null 
	
		select ID,[Student School ID], [Institute ID],[Branch ID],[Class Plan] as [Class Name],[First Name] as [Student Name],[Parent Name] as Parent, [Family Code],[Cell #] as [Cell NO#], 
		[Fee ID], [Fee Plan] as [Fee Name], [Status] from VSTUDENT_INFO with (nolock)
		where [Institute ID] = @FEE_COLLECT_HD_ID and  SessionId = @SessionId 
		and [Branch ID] = @FEE_COLLECT_BR_ID and
	   [Status] != 'D'
	   
		--SELECT * FROM VSTUDENT_ROLL_NUM as Bills
	 --   where [Institute ID] = @FEE_COLLECT_HD_ID and
	 --  [Branch ID] = @FEE_COLLECT_BR_ID and
	 --  [Status] != 'D'
	 --  and [Active Status] in ('new','old','')
	
		SELECT * FROM VFEE_COLLECT as closed  with (nolock)
		where [Institute ID] = @FEE_COLLECT_HD_ID and
	   [Branch ID] = @FEE_COLLECT_BR_ID and
	   [Status] is null 
	 
		SELECT * FROM VFEE_COLLECT as Transfered  with (nolock)
		where [Institute ID] = @FEE_COLLECT_HD_ID and
	   [Branch ID] = @FEE_COLLECT_BR_ID and
	   [Status] is null 
      
	   select s.STDNT_FIRST_NAME as [Name], s.STDNT_CELL_NO as [Student Cell], p.PARNT_FIRST_NAME as [Parent Name], p.PARNT_CELL_NO as [Parent Cell]
	   from STUDENT_INFO s  with (nolock)
	   join PARENT_INFO p  with (nolock) on s.STDNT_PARANT_ID = p.PARNT_ID
	   where 
	   STDNT_HD_ID = @FEE_COLLECT_HD_ID and
	   STDNT_BR_ID = @FEE_COLLECT_BR_ID and
	   STDNT_ID = 0

	   select * from VFEE_INFO  with (nolock) where [Institute ID] = @FEE_COLLECT_HD_ID and [Branch ID] = 0 order by [Discount Adjustment Priority]
	   select FEE_NAME from FEE_SETTING s  with (nolock)
	   join FEE_INFO f on f.FEE_ID = s.FEE_SETTING_FEE_CRITERIA	   
	   where FEE_SETTING_HD_ID = @FEE_COLLECT_HD_ID and FEE_SETTING_BR_ID = 0
     END
     
     
     Else if @STATUS = 'B'
     BEGIN
     
       
		SELECT *,([Current Fee] + Arrears - [Fee Received] - [Arrears Received]) as Remaining FROM VFEE_COLLECT_DEF as Collection_deff	   
		where ID is null
	
		SELECT *,([Current Fee] + Arrears - [Fee Received] - [Arrears Received]) as Remaining FROM VFEE_COLLECT as Receiveables	   
		where 
		--[Institute ID] = @FEE_COLLECT_HD_ID and
	 --  [Branch ID] = @FEE_COLLECT_BR_ID and	   
	   [Student ID] = @FEE_COLLECT_ID and
	   [Status] in ( 'Partially Received' , 'Receivable','Partially Received')
	
	    SELECT * FROM VFEE_COLLECT as [Fully Received]
		where 
		--[Institute ID] = @FEE_COLLECT_HD_ID and
	 --  [Branch ID] = @FEE_COLLECT_BR_ID and
	   [Student ID] = @FEE_COLLECT_ID and
	   [Status] ='Fully Received' 
		
		
		select ID, [Student School ID],[Institute ID],[Branch ID], [First Name] as [Student Name], [Family Code], [Parent Name] as Parent,[Cell #] as [Cell NO#], [Class Plan] as [Class Name], 
		[Fee ID], [Fee Plan] as [Fee Name], [Status] from VSTUDENT_INFO
		where [Institute ID] = @FEE_COLLECT_HD_ID and SessionId = @SessionId and
	   [Branch ID] = @FEE_COLLECT_BR_ID and
	   [Status] != 'D'

        SELECT * FROM VFEE_COLLECT as [closed]
		where [Institute ID] = @FEE_COLLECT_HD_ID and
	   [Branch ID] = @FEE_COLLECT_BR_ID and
	   [Student ID] = @FEE_COLLECT_ID and
	   [Status] ='Closed' 
	   
	   
	   SELECT * FROM VFEE_COLLECT as [Transfered]
		where 
		--[Institute ID] = @FEE_COLLECT_HD_ID and
	 --  [Branch ID] = @FEE_COLLECT_BR_ID and
	   [Student ID] = @FEE_COLLECT_ID and
	   [Status] in ('Fully Transfered', 'Partially Transfered' )

     
     END


 Else if @STATUS = 'R'
     BEGIN
     
     
		

	    declare @stat nvarchar(15) = ( SELECT [Status] FROM VFEE_COLLECT
	    where 
		[Institute ID] = @FEE_COLLECT_HD_ID and
			  [Branch ID] = @FEE_COLLECT_BR_ID and
			  [ID] = @FEE_COLLECT_ID_DESC and 
			  [Student ID] =  @FEE_COLLECT_ID)
			  
	   
	   
		   if(@stat = 'Receivable')
		   Begin
				   	SELECT FEE_COLLECT_DEF_ID AS ID,FEE_NAME AS [Fee Name], FEE_COLLECT_DEF_FEE AS [Current Fee], FEE_COLLECT_DEF_FEE_PAID AS [Fee Received],
				   			   FEE_COLLECT_DEF_MIN AS [Min Fee Variation %], FEE_COLLECT_DEF_MAX AS [Max Fee Variation %],FEE_COLLECT_DEF_OPERATION AS [Operation],
				   			   FEE_COLLECT_DEF_ARREARS AS [Arrears],FEE_COLLECT_DEF_ARREARS_RECEIVED as [Arrears Received],FEE_COLLECT_DEF_TOTAL as [Total Fee],
							   (FEE_COLLECT_DEF_FEE + FEE_COLLECT_DEF_ARREARS - FEE_COLLECT_DEF_FEE_PAID - FEE_COLLECT_DEF_ARREARS_RECEIVED) as Remaining
					FROM       FEE_COLLECT_DEF 
					join FEE_INFO on FEE_COLLECT_DEF_FEE_NAME = FEE_ID
					where FEE_COLLECT_DEF_PID = @FEE_COLLECT_ID_DESC
					--and	(FEE_COLLECT_DEF_FEE != 0  or FEE_COLLECT_DEF_FEE_PAID != 0 or FEE_COLLECT_DEF_ARREARS != 0 or FEE_COLLECT_DEF_ARREARS_RECEIVED != 0 or FEE_NAME = 'Discount' or FEE_NAME = 'Late Fee Fine')
					
		   End
		   
		   
		   Else
		   Begin
		   	  	SELECT FEE_COLLECT_DEF_ID AS ID,FEE_NAME AS [Fee Name], FEE_COLLECT_DEF_FEE AS [Current Fee], FEE_COLLECT_DEF_FEE_PAID AS [Fee Received],
				   			   FEE_COLLECT_DEF_MIN AS [Min Fee Variation %], FEE_COLLECT_DEF_MAX AS [Max Fee Variation %],FEE_COLLECT_DEF_OPERATION AS [Operation],
				   			   FEE_COLLECT_DEF_ARREARS AS [Arrears],FEE_COLLECT_DEF_ARREARS_RECEIVED as [Arrears Received],FEE_COLLECT_DEF_TOTAL as [Total Fee],
							   (FEE_COLLECT_DEF_FEE + FEE_COLLECT_DEF_ARREARS - FEE_COLLECT_DEF_FEE_PAID - FEE_COLLECT_DEF_ARREARS_RECEIVED) as Remaining
					FROM       FEE_COLLECT_DEF
					join FEE_INFO on FEE_COLLECT_DEF_FEE_NAME = FEE_ID   					
					where FEE_COLLECT_DEF_PID = @FEE_COLLECT_ID_DESC
		   End
		   
	       
	
		SELECT *,([Current Fee] + Arrears - [Fee Received] - [Arrears Received]) as Remaining FROM VFEE_COLLECT as Receiveables	  
		left join @tbl t on t.[Invoice ID] = CAST(Receiveables.ID as nvarchar(50))
		where 
		--[Institute ID] = @FEE_COLLECT_HD_ID and
	 --  [Branch ID] = @FEE_COLLECT_BR_ID and	   
	   [Student ID] = @FEE_COLLECT_ID and
	   [Status] in ( 'Partially Received' , 'Receivable','Partially Received')
	
	    SELECT *,([Current Fee] + Arrears - [Fee Received] - [Arrears Received]) as Remaining FROM VFEE_COLLECT as Paid
		left join @tbl t on t.[Invoice ID] =  CAST(Paid.ID as nvarchar(50))
		where 
		--[Institute ID] = @FEE_COLLECT_HD_ID and
	 --  [Branch ID] = @FEE_COLLECT_BR_ID and
	   [Student ID] = @FEE_COLLECT_ID and
	   [Status] ='Fully Received'
	
		select ID, [Student School ID] ,[Institute ID],[Branch ID], [First Name] as [Student Name], [Family Code], [Parent Name] as Parent,[Cell #] as [Cell NO#], [Class Plan] as [Class Name], 
		[Fee ID], [Fee Plan] as [Fee Name], [Status] from VSTUDENT_INFO
		where [Institute ID] = @FEE_COLLECT_HD_ID and SessionId = @SessionId and
	   [Branch ID] = @FEE_COLLECT_BR_ID and
	   [Status] != 'D'

		SELECT * FROM VFEE_COLLECT as closed
		left join @tbl t on t.[Invoice ID] = CAST(closed.ID as nvarchar(50))
		where [Institute ID] = @FEE_COLLECT_HD_ID and
	   [Branch ID] = @FEE_COLLECT_BR_ID and
	   [Student ID] = @FEE_COLLECT_ID and
	   [Status] ='Closed'
	   
	    SELECT *,([Current Fee] + Arrears - [Fee Received] - [Arrears Received]) as Remaining FROM VFEE_COLLECT as [Transfered]
		left join @tbl t on t.[Invoice ID] =  CAST([Transfered].ID as nvarchar(50))
		where 
		--[Institute ID] = @FEE_COLLECT_HD_ID and
	 --  [Branch ID] = @FEE_COLLECT_BR_ID and
	   [Student ID] = @FEE_COLLECT_ID and
	   [Status] in ('Fully Transfered', 'Partially Transfered' )
	   
	   select s.STDNT_FIRST_NAME as [Name], s.STDNT_CELL_NO as [Student Cell], p.PARNT_FIRST_NAME as [Parent Name], p.PARNT_CELL_NO as [Parent Cell]
	   from STUDENT_INFO s
	   join PARENT_INFO p on s.STDNT_PARANT_ID = p.PARNT_ID
	   where 
	   STDNT_HD_ID = @FEE_COLLECT_HD_ID and
	   STDNT_BR_ID = @FEE_COLLECT_BR_ID and
	   STDNT_ID = @FEE_COLLECT_ID

	   select * from VFEE_INFO where [Institute ID] = @FEE_COLLECT_HD_ID and [Branch ID] = @FEE_COLLECT_BR_ID order by [Discount Adjustment Priority]
	   select FEE_NAME from FEE_SETTING s
	   join FEE_INFO f on f.FEE_ID = s.FEE_SETTING_FEE_CRITERIA	   
	   where FEE_SETTING_HD_ID = @FEE_COLLECT_HD_ID and FEE_SETTING_BR_ID = @FEE_COLLECT_BR_ID
     END
    
    
  
 Else if @STATUS = 'S'
     BEGIN
		
		
		If @FEE_COLLECT_ID  < 1
		Begin
			Set @FEE_COLLECT_ID = ( select top(1)ID from VSCHOOL_PLANE where [Status] = 'T' and [Institute ID] = 9 and [Branch ID] = 10)
		End
		
		set @max_date = (select MAX([Date]) from VFEE_COLLECT)
	
		
		select * from
		(select distinct(v.ID) ID,[Student School ID],[Student ID],Name,Class,[Parent Name],Section,[Current Fee],[Fee Received],Arrears,[Arrears Received],[Net Total], [Date],[Status], [Student Cell], [Parent Cell],CAST([Student School ID] as int) [Student School ID1],''Payment,0 [Cash in Hand],0 [Cash at Bank], ''[Hand Code], '' [Bank Code],m.VCH_MID [VCH Main ID], d.FEE_COLLECT_DEF_FEE [Late fee Fine],[Net Total] as [Received Amount],[Installment Name],[Class Plan],CLassOrder  from VFEE_COLLECT_QUERY v
		left join TBL_VCH_MAIN m on m.VCH_referenceNo = CAST(ID as nvarchar(20))
		--join ( select val from dbo.split(@FEE_COLLECT_CLASS_IDS,';'))C on  [Class Plan] = CASE WHEN @FEE_COLLECT_CLASS_IDS = '' THEN 0 ELSE CAST(c.val as numeric) END
		Left join FEE_INFO f on f.FEE_BR_ID = v.[Branch ID] and f.FEE_NAME = 'Late Fee Fine'
left join FEE_COLLECT_DEF d on v.ID = d.FEE_COLLECT_DEF_PID and d.FEE_COLLECT_DEF_FEE_NAME = f.FEE_ID
		 where [Institute ID] = @FEE_COLLECT_HD_ID and [Branch ID] = @FEE_COLLECT_BR_ID 
		 and [Status]  = 'Receivable'
		 --and [Class Plan] in ( select * from dbo.split(@FEE_COLLECT_CLASS_IDS,';'))
		 and [Net Total] > 0
		 and [Student Status] = 'T')A
		 order by CLassOrder, CAST([Student School ID] as int)
		 --and DATEPART(MM,[Date]) = DATEPART(MM,@max_date) 
		 --and DATEPART(YY,[Date]) = DATEPART(YY,@max_date)
		
			
		select ID,Name from VSCHOOL_PLANE
		 where  [Institute ID] = @FEE_COLLECT_HD_ID and
		[Branch ID] = @FEE_COLLECT_BR_ID and  [Session Id] = @SessionId and
		[Status] = 'T'		order by [Order]
		


		
		
     END
	 -- Fee collect sipmple from student screen
  ELSE IF @STATUS = 'F'
     BEGIN		
		
		
		If @FEE_COLLECT_ID  < 1
		Begin
			Set @FEE_COLLECT_ID = ( select top(1)ID from VSCHOOL_PLANE where [Status] = 'T')
		End
		
		set @max_date = (select MAX([Date]) from VFEE_COLLECT)
	
		
		select distinct(ID),[Student School ID],[Student ID],Name,[Parent Name],Section,[Current Fee],[Fee Received],Arrears,[Arrears Received],[Net Total],[Date],[Status], [Student Cell], [Parent Cell], ''Payment,''[Payment Text],0 [Cash in Hand],0 [Cash at Bank], ''[Hand Code], '' [Bank Code] from VFEE_COLLECT_QUERY
		 where [Status]  = 'Receivable'
		 and [Student ID] = @FEE_COLLECT_ID
		 and [Net Total] > 0
		 order by [Student ID]
		
			
		select ID,Name from VSCHOOL_PLANE
		 where  [Institute ID] = @FEE_COLLECT_HD_ID and
		[Branch ID] = @FEE_COLLECT_BR_ID and
		[Status] = 'T'
	 END


	 
	 IF @STATUS = 'S' or @STATUS = 'L' or @STATUS = 'R' or @STATUS = 'F'
	 BEGIN

			declare @cash_in_hand_account nvarchar(100) =''
			select @cash_in_hand_account = COA_UID from TBL_COA  with (nolock) where COA_Name = 'Cash in Hand' and CMP_ID = CAST(@FEE_COLLECT_HD_ID as nvarchar(50)) and BRC_ID = CAST(@FEE_COLLECT_BR_ID as nvarchar(50))

			declare @cash_at_bank_account nvarchar(100) =''
			select @cash_at_bank_account = COA_UID from TBL_COA   with (nolock) where COA_Name = 'Cash at Bank' and CMP_ID = CAST(@FEE_COLLECT_HD_ID as nvarchar(50)) and BRC_ID = CAST(@FEE_COLLECT_BR_ID as nvarchar(50))

		 if @STATUS = 'L' or @STATUS = 'R'
		 BEGIN
		
			select COA_UID, COA_Name from TBL_COA   with (nolock) where COA_PARENTID = @cash_in_hand_account and COA_isDeleted = 0 and CMP_ID = CAST(@FEE_COLLECT_HD_ID as nvarchar(50)) and BRC_ID = CAST(@FEE_COLLECT_BR_ID as nvarchar(50))

		
			select COA_UID, COA_Name from TBL_COA   with (nolock) where COA_PARENTID = @cash_at_bank_account and COA_isDeleted = 0 and CMP_ID = CAST(@FEE_COLLECT_HD_ID as nvarchar(50)) and BRC_ID = CAST(@FEE_COLLECT_BR_ID as nvarchar(50))

		 END
		 ELSE
		 BEGIN
			select COA_UID, 'CH-' +COA_Name from TBL_COA where COA_PARENTID = @cash_in_hand_account and COA_isDeleted = 0 and CMP_ID = CAST(@FEE_COLLECT_HD_ID as nvarchar(50)) and BRC_ID = CAST(@FEE_COLLECT_BR_ID as nvarchar(50))
				union
		
			select COA_UID, 'CB-' +COA_Name from TBL_COA where COA_PARENTID = @cash_at_bank_account and COA_isDeleted = 0 and CMP_ID = CAST(@FEE_COLLECT_HD_ID as nvarchar(50)) and BRC_ID = CAST(@FEE_COLLECT_BR_ID as nvarchar(50))

			select 'nothing'
		 END
				
	 END
	 declare @one int = 1

	 declare @vch_main_id nvarchar(50) = ''
	 set @vch_main_id = (select top(@one) VCH_MID from TBL_VCH_MAIN   with (nolock) where BRC_ID = CAST(@FEE_COLLECT_BR_ID as nvarchar(50)) and VCH_referenceNo in (select CAST(val as nvarchar(50)) from dbo.split(CAST(@FEE_COLLECT_ID_DESC as nvarchar(50)),',')))

	  declare @voucher_date date = ''
	 set @voucher_date = (select VCH_SERIES_DATE from TBL_VCH_SERIES   with (nolock) where VCH_SERIES_BR_ID = @FEE_COLLECT_BR_ID and VCH_SERIES_VCH_MAIN_ID = CAST(@FEE_COLLECT_ID_DESC as nvarchar(50)))
	 set @voucher_date = ISNULL(@voucher_date,getdate())


	 --Caluculation of fee voucher transfer
	 declare @coa_transfer nvarchar(100) = (select top(1) c.COA_Name from TBL_VCH_DEF d   with (nolock) 
join TBL_VCH_DEF d1  with (nolock)  on d1.BRC_ID = d.BRC_ID and d1.CMP_ID = d.CMP_ID and d1.VCH_MAIN_ID = d.VCH_MAIN_ID  and  d1.VCH_DEF_referenceNo = CAST(@FEE_COLLECT_ID_DESC as nvarchar(50)) and d1.VCH_DEF_ItemCOA = 'Transfered To' and d.VCH_DEF_credit = 0 join TBL_COA c on c.COA_UID = d.VCH_DEF_COA and c.CMP_ID = d.CMP_ID and c.BRC_ID = d.BRC_ID and c.COA_isDeleted = 0)

 declare @FEE_COLLECT_FROM_DATE date = ''
 select  @FEE_COLLECT_FROM_DATE =FEE_COLLECT_FEE_FROM_DATE from FEE_COLLECT   with (nolock) where FEE_COLLECT_ID  = @FEE_COLLECT_ID_DESC

 select @FEE_COLLECT_FROM_DATE FEE_COLLECT_FROM_DATE ,isnull(MAX(FEE_COLLECT_ID),0) + 1 as roll_no, @FEE_COLLECT_ID [Std ID],@FEE_COLLECT_ID_DESC as [Invoice ID],(select SUM(ADV_FEE_AMOUNT - ADV_FEE_AMOUNT_ADJUST) from FEE_ADVANCE where ADV_FEE_STD_ID = @FEE_COLLECT_ID) as [Advance Fee],(select ADV_FEE_DEF_AMOUNT from FEE_ADVANCE_DEF   with (nolock) where FEE_ADVANCE_DEF.ADV_FEE_DEF_FEE_COLLECT_ID = @FEE_COLLECT_ID_DESC) ThisInvoiceAdvanceFee , @vch_main_id [VCH Main ID],@voucher_date [Voucher Date], @coa_transfer  [Coa Fee Transfer],(SELECT  top (@one)VCH_referenceNo  FROM (SELECT ID, [HD ID],[BR ID],Date,[COA Account],Amount,Comments,[VCH Main ID],VCH_referenceNo,CAST ('<M>' + REPLACE(m.VCH_referenceNo, ',', '</M><M>') + '</M>' AS XML) AS String       from VFEE_MULTIPLE_RECEIVED_AMOUNT r   with (nolock) join TBL_VCH_MAIN m   with (nolock) on r.[VCH Main ID] = m.VCH_MID and r.[BR ID] = m.BRC_ID where  m.VCH_chequeBankName in ('Multiple Cheques', 'Multiple Cash Received','Transfered From')) AS A CROSS APPLY String.nodes ('/M') AS Split(a) where Split.a.value('.', 'VARCHAR(100)') =  @FEE_COLLECT_ID_DESC) MultipleCashReceviedFeesIds from FEE_COLLECT


 declare @cheq_summary_id numeric = 0

  select top(1) @cheq_summary_id =   CHEQ_FEE_SUMMARY_ID from CHEQ_FEE_INFO   with (nolock) where CHEQ_FEE_COLLECT_ID = @FEE_COLLECT_ID_DESC

 
 declare @total_cash_fees float = 0


 select @total_cash_fees =  SUM(FEE_COLLECT_CASH_DEPOSITE) from FEE_COLLECT   with (nolock) where FEE_COLLECT_ID in (select CHEQ_FEE_COLLECT_ID from CHEQ_FEE_INFO where CHEQ_FEE_SUMMARY_ID = @cheq_summary_id)

	select * from VCHEQUE_INFO where ID in (select CHEQ_FEE_CHEQUE_ID from CHEQ_FEE_INFO   with (nolock) where CHEQ_FEE_SUMMARY_ID = @cheq_summary_id)

	 select  FEE_COLLECT_ID ID, FEE_COLLECT_STD_ID [Student ID], FEE_COLLECT_LATE_FEE_STATUS [Late Fee Status], FEE_COLLECT_DATE_FEE_RECEIVED [Date Received], Fee_collect_Payment_Mode [Payment Mode], @total_cash_fees [Cash Deposite],(select top(1) CHEQ_FEE_SUM_FEE_IDS from CHEQ_FEE_SUMMARY where CHEQ_FEE_SUM_ID = @cheq_summary_id) as CHEQ_FEE_SUM_FEE_IDS from FEE_COLLECT   with (nolock) where FEE_COLLECT_ID = @FEE_COLLECT_ID_DESC

	--select ID,[School Name],[Branch Name],[Std# No.],Class,[Std Name],[Parent Name],[Family Code],Remaining,[Bank Amount] from
	--(select ROW_NUMBER() over(partition by (f.[Student ID]) order by [Date] DESC) as sr,
	select f.ID ID,h.MAIN_INFO_INSTITUTION_FULL_NAME [School Name],b.BR_ADM_NAME [Branch Name],s.STDNT_SCHOOL_ID [Std# No.],f.[short Month Year] [Fee Month],sp.CLASS_Name Class,s.STDNT_FIRST_NAME [Std Name],p.PARNT_FIRST_NAME [Parent Name], p.PARNT_FAMILY_CODE [Family Code], (f.[Current Fee] + f.Arrears - f.[Fee Received] - f.[Arrears Received]) as Remaining, [Bank Amount]  from VFEE_COLLECT f  with (nolock) 
	join MAIN_HD_INFO h   with (nolock) on h.MAIN_INFO_ID = f.[Institute ID]
	join BR_ADMIN b   with (nolock) on b.BR_ADM_ID = f.[Branch ID]
	join STUDENT_INFO s   with (nolock) on s.STDNT_ID = f.[Student ID]
	join PARENT_INFO p   with (nolock) on p.PARNT_ID = s.STDNT_PARANT_ID
	join SCHOOL_PLANE sp   with (nolock) on sp.CLASS_ID = f.[Class Plan]
	
	 and DATEPART( MM,f.[From Date]) = DATEPART( MM,@FEE_COLLECT_FROM_DATE) and  DATEPART( YYYY,f.[From Date]) = DATEPART( YYYY,@FEE_COLLECT_FROM_DATE)
	where s.STDNT_BR_ID in (select a.BR_ID from @tbl_br_id a)
	

select ID, Date,[COA Account],Amount,Comments,ISNULL(B.COA_Name,'') [Transfer To] from  (SELECT ID,[HD ID],[BR ID],Date,[COA Account],Amount,Comments,[VCH Main ID],Split.a.value('.', 'VARCHAR(100)') AS [Invoice ID]   FROM 
 (SELECT ID, [HD ID],[BR ID],Date,[COA Account],Amount,Comments,[VCH Main ID],CAST ('<M>' + REPLACE(m.VCH_referenceNo, ',', '</M><M>') + '</M>' AS XML) AS String       from VFEE_MULTIPLE_RECEIVED_AMOUNT r  with (nolock)  join TBL_VCH_MAIN m on r.[VCH Main ID] = m.VCH_MID and r.[BR ID] = m.BRC_ID where  m.VCH_chequeBankName in ('Multiple Cheques', 'Multiple Cash Received','Transfered From','')) AS A CROSS APPLY String.nodes ('/M') AS Split(a)) r
	left join (select VCH_MAIN_ID, COA_Name from

(SELECT distinct VCH_MAIN_ID, COA_Name,Split.a.value('.', 'VARCHAR(100)') AS [Invoice ID]   FROM 
 (select d2.VCH_MAIN_ID, c.COA_Name,CAST ('<M>' + REPLACE(d1.VCH_DEF_referenceNo, ',', '</M><M>') + '</M>' AS XML) AS String from  TBL_VCH_DEF d1  with (nolock) 
join TBL_VCH_DEF d2   with (nolock) on d1.VCH_DEF_GRDNo = CAST(d2.VCH_DEF_countID as nvarchar(50))
join TBL_VCH_DEF d3   with (nolock) on d3.VCH_MAIN_ID = d1.VCH_MAIN_ID and d3.BRC_ID = d2.BRC_ID and d3.VCH_DEF_debit > 0
join TBL_COA c   with (nolock) on c.COA_UID = d3.VCH_DEF_COA and c.COA_isDeleted = 0 and c.BRC_ID = CAST(@FEE_COLLECT_BR_ID as nvarchar(10))
where  d1.VCH_DEF_ItemCOA = 'Transfered To') AS A CROSS APPLY String.nodes ('/M') AS Split(a)) r where [Invoice ID] = CAST(@FEE_COLLECT_ID_DESC as nvarchar(10)))B on B.VCH_MAIN_ID = r.[VCH Main ID]
	where [Invoice ID] = @FEE_COLLECT_ID_DESC order by Date
--This is split of d1.VCH_DEF_referenceNo into multiple invoice so that we can get Transfer To easily


--	select ID, Date,[COA Account],Amount,ISNULL(B.COA_Name,'') [Transfer To] from VFEE_MULTIPLE_RECEIVED_AMOUNT r
--	left join (select distinct d2.VCH_MAIN_ID, c.COA_Name from  TBL_VCH_DEF d1
--join TBL_VCH_DEF d2 on d1.VCH_DEF_GRDNo = CAST(d2.VCH_DEF_countID as nvarchar(50))
--join TBL_VCH_DEF d3 on d3.VCH_MAIN_ID = d1.VCH_MAIN_ID and d3.BRC_ID = d2.BRC_ID and d3.VCH_DEF_debit > 0
--join TBL_COA c on c.COA_UID = d3.VCH_DEF_COA and c.COA_isDeleted = 0 and c.BRC_ID = CAST(@FEE_COLLECT_BR_ID as nvarchar(10))
--where d1.VCH_DEF_referenceNo = CAST(@FEE_COLLECT_ID_DESC as nvarchar(10)) and d1.VCH_DEF_ItemCOA = 'Transfered To')B on B.VCH_MAIN_ID = r.[VCH Main ID]
--	where [HD ID] = @FEE_COLLECT_HD_ID and [BR ID] = @FEE_COLLECT_BR_ID and [Invoice ID] = @FEE_COLLECT_ID_DESC

	select COA_UID, 'CH-' +COA_Name from TBL_COA where COA_PARENTID = @cash_in_hand_account and COA_isDeleted = 0 and CMP_ID = CAST(@FEE_COLLECT_HD_ID as nvarchar(50)) and BRC_ID = CAST(@FEE_COLLECT_BR_ID as nvarchar(50))
				union
		
			select COA_UID, 'CB-' +COA_Name from TBL_COA where COA_PARENTID = @cash_at_bank_account and COA_isDeleted = 0 and CMP_ID = CAST(@FEE_COLLECT_HD_ID as nvarchar(50)) and BRC_ID = CAST(@FEE_COLLECT_BR_ID as nvarchar(50))
	--f.[From Date] between b.BR_ADM_ACCT_START_DATE and b.BR_ADM_ACCT_END_DATE
	--where f.Status not in ('Fully Transfered', 'Partially Transfered' )
	--)A where sr = 1
	select  ISNULL(d.FilePath,'') FilePath, ISNULL(d.CommentsUser,'') CommentsUser from FeeChallanStudentsUploadPaymentMaster m   with (nolock) 
	left join FeeChallanStudentsUploadPaymentDetail d   with (nolock) on d.PId = m.Id and d.IsDeleted = 0 and m.PaymentStatus = 'In Review'
	where m.InvoiceId =  @FEE_COLLECT_ID_DESC

End Try
Begin Catch

  --IF @@TRANCOUNT > 0
  --       ROLLBACK
		 declare @error nvarchar(max) =  'ErrorNumber: ' + CAST(ERROR_NUMBER() as nvarchar(50)) + ' , ERROR_MESSAGE: ' + ERROR_MESSAGE() + ', ERROR_LINE: ' + CAST(ERROR_LINE() as nvarchar(50)) + ', StoreProcedure:' +  ERROR_PROCEDURE() + ',  ERROR_STATE : '+  CAST(ERROR_STATE() as nvarchar(20))
		 declare @data nvarchar(max) = '@FEE_COLLECT_ID :' + CAST(@FEE_COLLECT_ID as nvarchar(50))+ ' , @FEE_COLLECT_ID_DESC: ' + CAST(@FEE_COLLECT_ID_DESC as nvarchar(50))
		declare @ErrorId numeric = 0
		exec dbo.usp_CustomErrorsInsert 'sp_FEE_COLLECT_selection: ', @error, @data,@ErrorId out
		
		declare @showError nvarchar(100) = ''
		select @showError = 'Something Wrong Check ErrorId: ' + CAST( @ErrorId as nvarchar(50))

		RAISERROR(@showError,16,1)
End Catch 

END