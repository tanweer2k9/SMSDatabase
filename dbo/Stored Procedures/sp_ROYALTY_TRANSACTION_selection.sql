CREATE procedure  [dbo].[sp_ROYALTY_TRANSACTION_selection]
                                               
                                               
     @STATUS char(10),
     @ROYALTY_TRAN_ID  numeric,
     @ROYALTY_TRAN_BR_ID  numeric
   
   
     AS BEGIN 
   
		declare @to_br_id int = 0

     if @STATUS = 'A'
     BEGIN
		select b2.BR_ADM_ID as ID,   ( 'Royalty from (' +  (select h1.MAIN_INFO_INSTITUTION_FULL_NAME from MAIN_HD_INFO h1 where h1.MAIN_INFO_ID =  b2.BR_ADM_HD_ID) + ') '
		+ CAST(b2.BR_ADM_NAME as nvarchar) + ' to (' +  (select h2.MAIN_INFO_INSTITUTION_FULL_NAME from MAIN_HD_INFO h2 where h2.MAIN_INFO_ID =  b1.BR_ADM_HD_ID) + ') '		
		+ b1.BR_ADM_NAME)  as Name 
		from BR_ADMIN b1 
		join BR_ADMIN b2 on b1.BR_ADM_ID = b2.BR_ADM_ROYALTY_TO_BRANCH		
		where b2.BR_ADM_ROYALTY_TO_BRANCH > 0

		if @ROYALTY_TRAN_BR_ID = 0
			set @ROYALTY_TRAN_BR_ID = (select top(1) b2.BR_ADM_ID from BR_ADMIN b1 
				join BR_ADMIN b2 on b1.BR_ADM_ID = b2.BR_ADM_ROYALTY_TO_BRANCH			
				where b2.BR_ADM_ROYALTY_TO_BRANCH > 0)

		set @to_br_id = (select BR_ADM_ROYALTY_TO_BRANCH from BR_ADMIN where BR_ADM_ID = @ROYALTY_TRAN_BR_ID)
   
		select  c2.COA_UID ID,'Cash in Hand (' + c2.COA_Name + ')' Name from TBL_COA c2
		where  c2.BRC_ID = @to_br_id and c2.COA_isDeleted = 0 and c2.COA_isActive = 1 and c2.COA_PARENTID in 
		(
		select c.COA_UID from TBL_COA c 
		where c.COA_Name = 'Cash in Hand' and c.COA_isDeleted = 0 and c.COA_isActive = 1 and  c.BRC_ID = @to_br_id
		)

		union

		select  c2.COA_UID ID,'Cash at Bank (' + c2.COA_Name + ')' Name from TBL_COA c2
		where  c2.BRC_ID = @to_br_id and c2.COA_isDeleted = 0 and c2.COA_isActive = 1 and c2.COA_PARENTID in 
		(
		select c.COA_UID from TBL_COA c 
		where c.COA_Name = 'Cash at Bank' and c.COA_isDeleted = 0 and c.COA_isActive = 1 and  c.BRC_ID = @to_br_id
		)

		 SELECT ID,[To Date] [Date],[Bank Name],[Cheque No],Comments, c.COA_UID [Payment to] ,Amount FROM VROYALTY_TRANSACTION  r
		 join TBL_VCH_DEF d on d.VCH_DEF_referenceNo = CAST(r.ID as nvarchar(50))
		 join TBL_COA c on  c.COA_UID = d.VCH_DEF_COA	and c.BRC_ID = d.BRC_ID	 and c.COA_Name != 'Royalty'
		 where r.[BR ID] = @ROYALTY_TRAN_BR_ID and c.BRC_ID = @to_br_id and d.BRC_ID = @to_br_id
		 and c.COA_isDeleted = 0

     END  
    
 
     END