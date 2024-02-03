--     *****************************************************************************************************************************************************************
 
 
--                             Code Type:           Store Procedure For Deletion  
--                             Creation Date:       5/12/2014 10:40:26 AM
--                             Auther:              Muhammad Usman Raza Attari
--                             Developed By :       786 Software House 
 
 
--    *****************************************************************************************************************************************************************
 
     CREATE PROCEDURE  [dbo].[sp_TBL_VCH_MAIN_deletion]
                                               
                                               
          @STATUS char(10),
          @CMP_ID  nvarchar(50),
		  @BRC_ID  nvarchar(50),
		  @VCH_isDeleted bit ,
		  @VCH_ID  nvarchar(50) ,
          @VCH_prefix  nvarchar(30) 
   
   
     AS BEGIN 
   
   
     update  TBL_VCH_MAIN
 
 set TBL_VCH_MAIN.VCH_isDeleted =1
 
     where 
		    isnull(CMP_ID , '') =ISNULL( @CMP_ID,ISNULL(CMP_ID,'')) and
			isnull(BRC_ID , '') =ISNULL( @BRC_ID,ISNULL(BRC_ID,'')) and
		    VCH_MID =  @VCH_ID 
 

 update  TBL_VCH_DEF
 
 set TBL_VCH_DEF.VCH_DEF_isDeleted =1
 
     where 
			isnull(CMP_ID , '') =ISNULL( @CMP_ID,ISNULL(CMP_ID,'')) and
			isnull(BRC_ID , '') =ISNULL( @BRC_ID,ISNULL(BRC_ID,'')) and
		    VCH_MAIN_ID =  @VCH_ID

end