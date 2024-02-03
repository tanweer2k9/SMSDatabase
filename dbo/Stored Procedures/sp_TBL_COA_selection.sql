
CREATE procedure  [dbo].[sp_TBL_COA_selection]
                       
				                           
          @STATUS nvarchar(50),											   
          @CMP_ID  Nvarchar(50),
		  @BRC_ID nvarchar(50),
          @COA_PARENTID  nvarchar(50) ,
          @COA_UID  nvarchar(50) ,
          @COA_prefix  nvarchar(50) ,
          @COA_levelID  int,
          @COA_definationPlanID  int,
          @COA_type  int,
          @COA_levelNo  int,
		  @COA_IsInventory bit,
		  @COA_IsDeleted bit,
		  @COA_IsTransaction bit,
		  @COA_IsActive bit
          

   
     as  begin
     
    if @STATUS  = 'Report' -- will select main all Financial COA From 
       begin
        
        select  TBL_COA.COA_UID  ,   (dbo.getCOASpaceTotal(TBL_COA.COA_levelNo,'    ') + TBL_COA.COA_Name) 'COA_Name', TBL_TYPE_PLAN_DEF.TYPE_PLAN_DEF_name, TBL_COA.COA_isActive  
        from  TBL_COA 
	    join TBL_TYPE_PLAN_DEF on TBL_COA.COA_type = TBL_TYPE_PLAN_DEF.TYPE_PLAN_DEF_ID 
	    where 
		TBL_COA.COA_IsInventory = @COA_IsInventory  and 
		isnull( TBL_COA.CMP_ID ,'') = isnull(@CMP_ID,isnull(TBL_COA.CMP_ID,'')) and 
		isnull( TBL_COA.BRC_ID ,'') = isnull(@BRC_ID,isnull(TBL_COA.BRC_ID,'')) and 
		COA_isDeleted = ISNULL( @COA_IsDeleted,COA_isDeleted)
        order by TBL_COA.COA_UID
       end
   

   
    if @STATUS  = 'MainReport_Type' -- will select main all Financial COA From 
		begin
			select  TBL_COA.COA_UID  , TBL_COA.COA_Name , TBL_COA.COA_Name , TBL_COA.COA_description  , TBL_TYPE_PLAN_MAIN.TYPE_PLAN_MAIN_name, TBL_COA.COA_isActive  from  TBL_COA 
			join TBL_TYPE_PLAN_MAIN on TBL_COA.COA_type = TBL_TYPE_PLAN_MAIN.TYPE_PLAN_MAIN_ID 

			where 
			TBL_COA.COA_IsInventory = @COA_IsInventory  and 
			isnull( TBL_COA.CMP_ID ,'') = isnull(@CMP_ID,isnull(TBL_COA.CMP_ID,'')) and 
			isnull( TBL_COA.BRC_ID ,'') = isnull(@BRC_ID,isnull(TBL_COA.BRC_ID,'')) and 
			COA_isDeleted = ISNULL( @COA_IsDeleted,COA_isDeleted)
        
		end
   
   
    else if @STATUS  = 'A_Type' -- will select main all Financial COA From
		begin

			select * from TBL_COA 

			where
			
			isnull( TBL_COA.CMP_ID ,'') = isnull(@CMP_ID,isnull(TBL_COA.CMP_ID,'')) and 
			isnull( TBL_COA.BRC_ID ,'') = isnull(@BRC_ID,isnull(TBL_COA.BRC_ID,'')) and 
			COA_isDeleted = ISNULL( @COA_IsDeleted,COA_isDeleted)
        	order by TBL_COA.COA_UID

		end
	else if @STATUS = 'Parent_Row'
	begin
			select * from TBL_COA 

			where
			COA_UID = @COA_UID and			
			isnull( TBL_COA.CMP_ID ,'') = isnull(@CMP_ID,isnull(TBL_COA.CMP_ID,'')) and 
			isnull( TBL_COA.BRC_ID ,'') = isnull(@BRC_ID,isnull(TBL_COA.BRC_ID,'')) and 
			COA_isDeleted = ISNULL( @COA_IsDeleted,COA_isDeleted)
        	order by TBL_COA.COA_UID

			if @COA_prefix = 'Student'
				set @COA_UID = (select top(1) COA_UID from TBL_COA where COA_ID in (select STDNT_COA_ID from STUDENT_INFO where STDNT_ID = @COA_PARENTID))
			else if @COA_prefix = 'Staff'
				set @COA_UID = (select top(1) COA_UID from TBL_COA where COA_ID in (select TECH_COA_ID from TEACHER_INFO where TECH_ID = @COA_PARENTID))
			
			select * from TBL_COA where COA_UID = @COA_UID and			
			isnull( TBL_COA.CMP_ID ,'') = isnull(@CMP_ID,isnull(TBL_COA.CMP_ID,'')) and 
			isnull( TBL_COA.BRC_ID ,'') = isnull(@BRC_ID,isnull(TBL_COA.BRC_ID,'')) and 
			COA_isDeleted = ISNULL( @COA_IsDeleted,COA_isDeleted)
	end

		else if @STATUS  = 'L_Type_Transaction_Active' -- will select main ID and Name Financial COA From
		begin

				
					select 
					
					TBL_COA.COA_UID , TBL_COA.COA_Name --, 
					
					--IMS.dbo.VTBL_ITEM_INTERNAL.ITEM_packing ,  
					
					--IMS.dbo.VTBL_ITEM_INTERNAL.ITEM_defaultUnit ,  
					--IMS.dbo.VTBL_ITEM_INTERNAL.ITEM_maxUnitLevel ,
					
					--IMS.dbo.VTBL_ITEM_INTERNAL.ITEM_firstUnit ,
					--IMS.dbo.VTBL_ITEM_INTERNAL.ITEM_secondUnit ,
					--IMS.dbo.VTBL_ITEM_INTERNAL.ITEM_thirdUnit ,
					
					--IMS.dbo.VTBL_ITEM_INTERNAL.ITEM_firstUnitName ,
					--IMS.dbo.VTBL_ITEM_INTERNAL.ITEM_secondUnitName ,
					--IMS.dbo.VTBL_ITEM_INTERNAL.ITEM_thirdUnitName ,
					
					--IMS.dbo.VTBL_ITEM_INTERNAL.ITEM_purchasePriceFlatRate ,  
     --               IMS.dbo.VTBL_ITEM_INTERNAL.ITEM_purchasePromotionalDiscount ,  
					--IMS.dbo.VTBL_ITEM_INTERNAL.ITEM_purchaseCreditNode ,
					--IMS.dbo.VTBL_ITEM_INTERNAL.ITEM_salePricePriniciple ,
					--IMS.dbo.VTBL_ITEM_INTERNAL.ITEM_salePriceDiscounted 
					
					
					
					from TBL_COA -- left join IMS.dbo.VTBL_ITEM_INTERNAL on IMS.dbo.VTBL_ITEM_INTERNAL.ITEM_COA = TBL_COA.COA_UID and IMS.dbo.VTBL_ITEM_INTERNAL.ITEM_isDeleted = 0 
					where 
					TBL_COA.COA_IsInventory = @COA_IsInventory  and 
					isnull( TBL_COA.CMP_ID ,'') = isnull(@CMP_ID,isnull(TBL_COA.CMP_ID,'')) and 
					isnull( TBL_COA.BRC_ID ,'') = isnull(@BRC_ID,isnull(TBL_COA.BRC_ID,'')) and 
					isnull( COA_isDeleted,'') = ISNULL( @COA_IsDeleted,COA_isDeleted) and
					COA_IsTransaction =@COA_IsTransaction and 
					COA_isActive = @COA_IsActive 
				
		
		end
		else if @STATUS  = 'L_Transaction_Active' -- will select main ID and Name Financial COA From
		begin

			select TBL_COA.COA_UID , TBL_COA.COA_Name from TBL_COA 

			where    
			isnull( TBL_COA.CMP_ID ,'') = isnull(@CMP_ID,isnull(TBL_COA.CMP_ID,'')) and 
			isnull( TBL_COA.BRC_ID ,'') = isnull(@BRC_ID,isnull(TBL_COA.BRC_ID,'')) and 
			COA_isDeleted = ISNULL( @COA_IsDeleted,COA_isDeleted) and
 			 COA_IsTransaction =@COA_IsTransaction and
			  COA_isActive = @COA_IsActive
			   order by TBL_COA.COA_UID 

		end
		
		else if @STATUS  = 'C'
		begin

		select COA_UID , COA_Name from TBL_COA
		where 
		
			isnull( TBL_COA.CMP_ID ,'') = isnull(@CMP_ID,isnull(TBL_COA.CMP_ID,'')) and 
			isnull( TBL_COA.BRC_ID ,'') = isnull(@BRC_ID,isnull(TBL_COA.BRC_ID,'')) and 
			COA_isDeleted = ISNULL( @COA_IsDeleted,COA_isDeleted) and 
			COA_IsInventory = 0
        
		end
		else if @STATUS  = 'Bank'
		begin

		select COA_UID , COA_Name from TBL_COA
		where 
		
			isnull( TBL_COA.CMP_ID ,'') = isnull(@CMP_ID,isnull(TBL_COA.CMP_ID,'')) and 
			isnull( TBL_COA.BRC_ID ,'') = isnull(@BRC_ID,isnull(TBL_COA.BRC_ID,'')) and 
			COA_isDeleted = ISNULL( @COA_IsDeleted,COA_isDeleted) and 
			COA_PARENTID in (
			select COA_UID  from TBL_COA
		where isnull( TBL_COA.CMP_ID ,'') = isnull(@CMP_ID,isnull(TBL_COA.CMP_ID,'')) and 
			isnull( TBL_COA.BRC_ID ,'') = isnull(@BRC_ID,isnull(TBL_COA.BRC_ID,'')) and 
			COA_isDeleted = ISNULL( @COA_IsDeleted,COA_isDeleted) and COA_Name = 'Cash at Bank'   )
        
		end

	END