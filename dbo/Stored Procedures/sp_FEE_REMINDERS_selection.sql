
CREATE procedure  [dbo].[sp_FEE_REMINDERS_selection]
                                               
                                               
     @STATUS char(10),
     @FEE_REMIDNERS_ID  numeric,
	 @FEE_REMIDNERS_HD_ID  numeric,
	 @FEE_REMIDNERS_BR_ID  numeric

   
   
     AS 
   
   
    
   
     SELECT FINAL_FEE_REMINDERS, FEE_REMINDERS,WITHDRAWL_NOTICE FROM FEE_REMINDERS where FEE_REMIDNERS_HD_ID = @FEE_REMIDNERS_HD_ID  and
	 FEE_REMIDNERS_BR_ID = @FEE_REMIDNERS_BR_ID