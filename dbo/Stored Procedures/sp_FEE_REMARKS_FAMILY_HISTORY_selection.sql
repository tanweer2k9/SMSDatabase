  CREATE procedure  sp_FEE_REMARKS_FAMILY_HISTORY_selection
                                               
                                               
     @STATUS char(10),
	 @HD_ID numeric,
	 @BR_ID numeric,
	 @PARENT_ID numeric,
	 @FEE_REMARKS_SESSION_ID numeric
   
   
     AS BEGIN 
   
   
     if @STATUS = 'L'
     BEGIN   
		select * from VPARENT_INFO where [Branch ID] in (  select COMBINE_BRANCHES_ID from COMBINE_BRANCHES where FROM_BRANCH_ID = @BR_ID) and Status = 'T'
		
		SELECT * FROM VFEE_REMARKS_FAMILY_HISTORY where ID is null
     END  
     ELSE IF @STATUS = 'B'

     BEGIN
		select * from VPARENT_INFO where [Branch ID] in (  select COMBINE_BRANCHES_ID from COMBINE_BRANCHES where FROM_BRANCH_ID = @BR_ID) and Status = 'T'
		
		select s.STDNT_ID ID, s.STDNT_SCHOOL_ID [Std #], s.STDNT_FIRST_NAME [Name],ISNULL((select f.FEE_REMARKS from FEE_REMARKS_FAMILY_HISTORY f where f.FEE_REMARKS_STD_ID = s.STDNT_ID and f.FEE_REMARKS_SESSION_ID = @FEE_REMARKS_SESSION_ID),'') as Remarks from STUDENT_INFO s
		
		--left join VFEE_REMARKS_FAMILY_HISTORY f on f.[Std ID] = s.STDNT_ID
		
		
		where 
		  s.STDNT_PARANT_ID = @PARENT_ID
 
 
			 
 
     END
 
     END