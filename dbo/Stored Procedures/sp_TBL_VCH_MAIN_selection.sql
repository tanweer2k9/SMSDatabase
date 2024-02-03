


     CREATE procedure  [dbo].[sp_TBL_VCH_MAIN_selection]
                                               
                                               
		  @STATUS char(10),
		  @CMP_ID  nvarchar(50),
		  @BRC_ID  nvarchar(50),
		  @VCH_isDeleted bit ,
		  @VCH_MID  nvarchar(50),
		  @VCH_prefix  nvarchar(30),
		  @FROM_DATE date,
		  @TO_DATE date
		 
     
     AS BEGIN 
   
   
     if @STATUS = 'A'
     BEGIN
   
		   IF @VCH_prefix = 'FE'
		   BEGIN
		   declare @tbl table (ID nvarchar(50), ChequeNo nvarchar(50), Date datetime, Credit float, Debit float, DebitAccountName nvarchar(100),CreditAccountName nvarchar(100),CreditNarration nvarchar(1000),DebitNarration nvarchar(500), PaymentTo nvarchar(100))
		   declare @tbl1 table (ID nvarchar(50), CreditNarration nvarchar(1000))
			insert into @tbl

		  select ID, MAX(ChequeNo) ChequeNo, MAX(Date) Date, SUM(Credit) Credit, SUM(Debit) Debit, MAX(DebitAccountName) DebitAccountName,MAX(CreditAccountName) CreditAccountName,MAX(CreditNarration) CreditNarration,MAX(DebitNarration) DebitNarration, MAX(VCH_paidTo)  from
(select m.VCH_MID Id, IIF(d.VCH_DEF_COA != 'Transfered To',ISNULL(ci.CHEQ_CHEQUE_NO,''), m.VCH_chequeNo) ChequeNo, VCH_date [Date], d.VCH_DEF_credit Credit, d.VCH_DEF_debit Debit, IIF(d.VCH_DEF_credit = 0, c.COA_Name,'') DebitAccountName,IIF(d.VCH_DEF_debit = 0, c.COA_Name,'') CreditAccountName,IIF(d.VCH_DEF_debit = 0, d.VCH_DEF_referenceNo,'') CreditNarration, IIF(d.VCH_DEF_credit = 0, d.VCH_DEF_ItemCOA,'') DebitNarration, m.VCH_paidTo from TBL_VCH_MAIN m
join TBL_VCH_DEF d on d.VCH_MAIN_ID = m.VCH_MID
join TBL_COA c on c.COA_UID = d.VCH_DEF_COA and c.BRC_ID = d.BRC_ID and c.COA_isDeleted = 0
left join CHEQUE_INFO ci on CAST(ci.CHEQ_ID as nvarchar(50)) = m.VCH_referenceNo

					where isnull(m.CMP_ID , '') =ISNULL( @CMP_ID,ISNULL(m.CMP_ID,'')) and
					isnull(m.BRC_ID , '') =ISNULL( @BRC_ID,ISNULL(m.CMP_ID,'')) and
					m.VCH_isDeleted = isnull((@VCH_isDeleted) , m.VCH_isDeleted) 
					and m.VCH_prefix = @VCH_prefix and VCH_DEF_ItemCOA in ('Multiple Cheques Received', 'Transfered To')
					and m.VCH_date between @FROM_DATE and @TO_DATE )A
					group by Id order by MAX(Date)


					insert into @tbl1
					select A.ID, 'Name: ' + s.STDNT_FIRST_NAME + ', St#: ' + s.STDNT_SCHOOL_ID  as CreditNarration from FEE_COLLECT f 
					--+ ', Class: '+ sp.CLASS_Name +', Ins: '+ ISNULL(f.FEE_COLLECT_INSTALLMENT_NAME, '')
					join STUDENT_INFO s on s.STDNT_ID = f.FEE_COLLECT_STD_ID
					--join SCHOOL_PLANE sp on sp.CLASS_ID = f.FEE_COLLECT_PLAN_ID
					join

					(select ID, CreditNarration, Split.a.value('.', 'VARCHAR(100)') FeeId FROM (SELECT ID,CreditNarration,CAST ('<M>' + REPLACE(CreditNarration, ',', '</M><M>') + '</M>' AS XML) AS String       from @tbl t ) AS A CROSS APPLY String.nodes ('/M') AS Split(a) )A on A.FeeId = f.FEE_COLLECT_ID

					select t.ID,ChequeNo,Date,Credit,Debit,DebitAccountName,CreditAccountName,B.CreditNarration,DebitNarration, PaymentTo from
					(select ID, STUFF((
						SELECT '& ' + CreditNarration 
						FROM @tbl1 t1
						WHERE (t.ID = t1.ID) 
						FOR XML PATH(''),TYPE).value('(./text())[1]','VARCHAR(MAX)')
					  ,1,2,'') AS CreditNarration from @tbl1 t
					 group by ID)B
					 join @tbl t on t.ID = B.ID
		   END
		   ELSE
		   BEGIN
				select ID, MAX(ChequeNo) ChequeNo, MAX(Date) Date, SUM(Credit) Credit, SUM(Debit) Debit, MAX(DebitAccountName) DebitAccountName,MAX(CreditAccountName) CreditAccountName,MAX(CreditNarration) CreditNarration,MAX(DebitNarration) DebitNarration, MAX(PaymentTo)  PaymentTo from
				(select m.VCH_MID Id, m.VCH_chequeNo ChequeNo, VCH_date [Date], d.VCH_DEF_credit Credit, d.VCH_DEF_debit Debit, IIF(d.VCH_DEF_credit = 0, c.COA_Name,'') DebitAccountName,IIF(d.VCH_DEF_debit = 0, c.COA_Name,'') CreditAccountName,IIF(d.VCH_DEF_debit = 0, d.VCH_DEF_narration,'') CreditNarration, IIF(d.VCH_DEF_credit = 0, d.VCH_DEF_narration,'') DebitNarration, m.VCH_paidTo PaymentTo from TBL_VCH_MAIN m
join TBL_VCH_DEF d on d.VCH_MAIN_ID = m.VCH_MID
join TBL_COA c on c.COA_UID = d.VCH_DEF_COA and c.BRC_ID = d.BRC_ID and c.COA_isDeleted = 0
			
where isnull(m.CMP_ID , '') =ISNULL( @CMP_ID,ISNULL(m.CMP_ID,'')) and
					isnull(m.BRC_ID , '') =ISNULL( @BRC_ID,ISNULL(m.CMP_ID,'')) and
					m.VCH_isDeleted = isnull((@VCH_isDeleted) , m.VCH_isDeleted) 
					and m.VCH_prefix = @VCH_prefix and m.VCH_date between @FROM_DATE and @TO_DATE  )A
					group by Id order by MAX(Date)
		   END

     END  


	 SELECT * FROM TBL_VCH_DEF
    WHERE
     
     VCH_MAIN_ID =  @VCH_MID  and 
	 
		    isnull(CMP_ID , '') =ISNULL( @CMP_ID,ISNULL(CMP_ID,'')) and
			isnull(BRC_ID , '') =ISNULL( @BRC_ID,ISNULL(BRC_ID,'')) and
			TBL_VCH_DEF.VCH_DEF_isDeleted = isnull((@VCH_isDeleted) , TBL_VCH_DEF.VCH_DEF_isDeleted) 
  --   ELSE if @STATUS = 'V'
  --   BEGIN
  
  -- SELECT * FROM VTBL_VCH_MAIN   
  --  WHERE
		--    isnull([Institute ID] , '') =ISNULL( @CMP_ID,ISNULL([Institute ID],'')) and
		--	isnull([Branch ID] , '') =ISNULL( @BRC_ID,ISNULL([Branch ID],'')) and
		--	[Is Deleted] = isnull((@VCH_isDeleted) , [Is Deleted]) and
  --  		ID =  @VCH_MID and 
		--	Prefix =  @VCH_prefix
 


  --SELECT * FROM TBL_VCH_DEF
  --  WHERE
     
  --   VCH_MAIN_ID =  @VCH_MID  and 
	 
		--    isnull(CMP_ID , '') =ISNULL( @CMP_ID,ISNULL(CMP_ID,'')) and
		--	isnull(BRC_ID , '') =ISNULL( @BRC_ID,ISNULL(BRC_ID,'')) and
		--	TBL_VCH_DEF.VCH_DEF_isDeleted = isnull((@VCH_isDeleted) , TBL_VCH_DEF.VCH_DEF_isDeleted) 
 
  --   END

     END