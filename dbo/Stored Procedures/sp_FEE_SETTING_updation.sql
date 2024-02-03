CREATE procedure  [dbo].[sp_FEE_SETTING_updation]                                                                                             
          @FEE_SETTING_ID  numeric,
          @FEE_SETTING_HD_ID  numeric,
          @FEE_SETTING_BR_ID  numeric,
          @FEE_SETTING_FINE  int,
          @FEE_SETTING_REPRINT_CHARGES  float,
          @FEE_SETTING_FEE_CRITERIA  int ,
          @BR_ADM_FEE_HISTORY  bit,
          @FEE_SETTING_REPRINT_HISTORY  bit,
          @FEE_SETTING_ARREARS_WITH_DUE_DATE  bit,
          @FEE_SETTING_INVOICE_MOBILE_NO NVARCHAR(100)
   
     as begin 
     update FEE_SETTING 
     set
          FEE_SETTING_FINE =  @FEE_SETTING_FINE,
          FEE_SETTING_REPRINT_CHARGES =  @FEE_SETTING_REPRINT_CHARGES,
          FEE_SETTING_FEE_CRITERIA =  @FEE_SETTING_FEE_CRITERIA,
          BR_ADM_FEE_HISTORY =  @BR_ADM_FEE_HISTORY,
          FEE_SETTING_REPRINT_HISTORY =  @FEE_SETTING_REPRINT_HISTORY,
          FEE_SETTING_ARREARS_WITH_DUE_DATE =  @FEE_SETTING_ARREARS_WITH_DUE_DATE,          
          FEE_SETTING_INVOICE_MOBILE_NO = @FEE_SETTING_INVOICE_MOBILE_NO
          
 
     where           
          FEE_SETTING_HD_ID =  @FEE_SETTING_HD_ID and 
          FEE_SETTING_BR_ID =  @FEE_SETTING_BR_ID 
 
end