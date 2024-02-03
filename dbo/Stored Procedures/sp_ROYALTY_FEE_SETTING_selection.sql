CREATE procedure  [dbo].[sp_ROYALTY_FEE_SETTING_selection]
                                               
                                               
     @STATUS char(10),
     @ROYALTY_ID  numeric,
     @ROYALTY_BR_ID  numeric
   
   
     AS BEGIN 
   
		
     
		select b2.BR_ADM_ID as ID,   ( 'Royalty from (' +  (select h1.MAIN_INFO_INSTITUTION_FULL_NAME from MAIN_HD_INFO h1 where h1.MAIN_INFO_ID =  b2.BR_ADM_HD_ID) + ') '
		+ CAST(b2.BR_ADM_NAME as nvarchar) + ' to (' +  (select h2.MAIN_INFO_INSTITUTION_FULL_NAME from MAIN_HD_INFO h2 where h2.MAIN_INFO_ID =  b1.BR_ADM_HD_ID) + ') '		
		+ b1.BR_ADM_NAME)  as Name 
		from BR_ADMIN b1 
		join BR_ADMIN b2 on b1.BR_ADM_ID = b2.BR_ADM_ROYALTY_TO_BRANCH		
		
		where b2.BR_ADM_ROYALTY_TO_BRANCH > 0

		if @ROYALTY_BR_ID = 0
			set @ROYALTY_BR_ID = (select top(1) b2.BR_ADM_ID from BR_ADMIN b1 
				join BR_ADMIN b2 on b1.BR_ADM_ID = b2.BR_ADM_ROYALTY_TO_BRANCH			
				where b2.BR_ADM_ROYALTY_TO_BRANCH > 0)


		SELECT ID,[Fee ID], Percentage FROM VROYALTY_FEE_SETTING where [BR ID] = @ROYALTY_BR_ID

		select ID,Name from VFEE_INFO where [Branch ID] = @ROYALTY_BR_ID and Status = 'T'

 
     END