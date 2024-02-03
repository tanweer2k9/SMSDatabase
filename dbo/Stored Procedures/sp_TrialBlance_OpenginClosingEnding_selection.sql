CREATE procedure [dbo].[sp_TrialBlance_OpenginClosingEnding_selection]

 @CMP_ID nvarchar(50) ,
 @BRC_ID nvarchar(50) ,
 @COA_IsTransaction bit ,
 @COA_levelNo int ,
 @fromDate datetime ,
 @toDate datetime ,
 @isDeleted bit 
 
as

; with tbl_Filtered as 
(

        select TBL_COA.CMP_ID , TBL_COA.BRC_ID , TBL_COA.COA_isDeleted , TBL_COA.COA_UID , TBL_COA.COA_nature from  TBL_COA  
               where TBL_COA.COA_IsTransaction = isnull(@COA_IsTransaction ,COA_IsTransaction) 
                     and TBL_COA.COA_levelNo = isnull(@COA_levelNo ,COA_levelNo)
) 

select 
      TBL_COA.COA_UID
      ,TBL_COA.COA_Name
      ,CompleteWithFormats.O_Debit
      ,CompleteWithFormats.O_Credit
      ,dbo.getLedgerColsingFormating(CompleteWithFormats.COA_nature, cast(CompleteWithFormats.O_Balance as decimal(18,6))) 'O_Balance'
      --,CompleteWithFormats.O_Balance
      ,CompleteWithFormats.C_Debit
      ,CompleteWithFormats.C_Credit
      ,dbo.getLedgerColsingFormating(CompleteWithFormats.COA_nature, cast(CompleteWithFormats.C_Balance as decimal(18,6))) 'C_Balance'
      --,CompleteWithFormats.C_Balance
      ,CompleteWithFormats.L_Debit
      ,CompleteWithFormats.L_Credit
      ,dbo.getLedgerColsingFormating(CompleteWithFormats.COA_nature, cast(CompleteWithFormats.L_Balance as decimal(18,6))) 'L_Balance'
      
      --,CompleteWithFormats.L_Balance
from 
(

                Select FinalComplete.*
                       ,(FinalComplete.O_Debit + FinalComplete.C_Debit) L_Debit
                       ,(FinalComplete.O_Credit + FinalComplete.C_Credit) L_Credit
                       ,O_Balance =( case FinalComplete.COA_nature 
                                          when 'Debit' 
							                    then FinalComplete.O_Debit  - FinalComplete.O_Credit
								                else FinalComplete.O_Credit - FinalComplete.O_Debit 
						                  end
				                   )
	                   ,C_Balance =( case FinalComplete.COA_nature 
                                          when 'Debit' 
				                                then FinalComplete.C_Debit  - FinalComplete.C_Credit
					                            else FinalComplete.C_Credit - FinalComplete.C_Debit 
			                              end
	                                )
	                   ,L_Balance =( case FinalComplete.COA_nature 
                                          when 'Debit' 
				                                then (FinalComplete.O_Debit + FinalComplete.C_Debit)  -  (FinalComplete.O_Credit +FinalComplete.C_Credit)
					                            else (FinalComplete.O_Credit +FinalComplete.C_Credit)  -  (FinalComplete.O_Debit + FinalComplete.C_Debit) 
			                              end
	                                )
                	                
                	                
                	                 
                         from
                (
                         
                        select 
                               Final.COA_UID
                              ,Final.COA_nature
                              ,Final.CMP_ID
                              ,Final.BRC_ID
                              ,sum(Final.O_Debit) O_Debit 
                              ,sum(Final.C_Debit) C_Debit
                              ,sum(Final.O_Credit)O_Credit 
                              ,sum(Final.C_Credit)C_Credit
                              ,Final.COA_isDeleted
                              
                              
                                         from
                                            (      
                                                           
                                                select tbl_Filtered .* , 
                                                       sum(TBL_VCH_DEF.VCH_DEF_credit) O_Credit, 
                                                       sum(TBL_VCH_DEF.VCH_DEF_debit) O_Debit ,
                                                       0 C_Credit, 
                                                       0 C_Debit             
                                                       
                                                       from tbl_Filtered  
                                                            join TBL_VCH_DEF 
                                                                 on TBL_VCH_DEF.VCH_DEF_COA =  tbl_Filtered.COA_UID
                                                                    and TBL_VCH_DEF.VCH_DEF_date < @fromDate
                                                                    and TBL_VCH_DEF.CMP_ID = tbl_Filtered.CMP_ID
                                                                    and TBL_VCH_DEF.BRC_ID = tbl_Filtered.BRC_ID
                                                                    and TBL_VCH_DEF.VCH_DEF_isDeleted = tbl_Filtered.COA_isDeleted
                                                                    and TBL_VCH_DEF.CMP_ID = @CMP_ID
                                                                    and TBL_VCH_DEF.BRC_ID = @BRC_ID
                                                                    and TBL_VCH_DEF.VCH_DEF_isDeleted = @isDeleted
                                                                    
                                                                    Group by tbl_Filtered.CMP_ID, tbl_Filtered.BRC_ID, tbl_Filtered.COA_UID  , tbl_Filtered.COA_nature,tbl_Filtered.COA_isDeleted
                                                           
                                                 union all         
                                                 
                                                select tbl_Filtered .* , 
                                                       0 O_Credit, 
                                                       0 O_Debit ,
                                                       sum(TBL_VCH_DEF.VCH_DEF_credit) C_Credit, 
                                                       sum(TBL_VCH_DEF.VCH_DEF_debit) C_Debit 
                                                       
                                                       
                                                       from tbl_Filtered  
                                                            join TBL_VCH_DEF 
                                                                 on TBL_VCH_DEF.VCH_DEF_COA =  tbl_Filtered.COA_UID
                                                                    and TBL_VCH_DEF.VCH_DEF_date >= @fromDate
                                                                    and TBL_VCH_DEF.VCH_DEF_date <= @toDate
                                                                    and TBL_VCH_DEF.CMP_ID = tbl_Filtered.CMP_ID
                                                                    and TBL_VCH_DEF.BRC_ID = tbl_Filtered.BRC_ID
                                                                    and TBL_VCH_DEF.VCH_DEF_isDeleted = tbl_Filtered.COA_isDeleted
                                                                    and TBL_VCH_DEF.CMP_ID = @CMP_ID
                                                                    and TBL_VCH_DEF.BRC_ID = @BRC_ID
                                                                    and TBL_VCH_DEF.VCH_DEF_isDeleted = @isDeleted
                                                                    
                                                                    Group by tbl_Filtered.CMP_ID, tbl_Filtered.BRC_ID, tbl_Filtered.COA_UID  , tbl_Filtered.COA_nature,tbl_Filtered.COA_isDeleted 
 
                                                           
                                             )Final Group by Final.COA_UID , Final.COA_nature ,Final.CMP_ID,Final.BRC_ID,Final.COA_isDeleted  
                                             
                )FinalComplete
                
)CompleteWithFormats  join TBL_COA 
                           on CompleteWithFormats.CMP_ID = TBL_COA.CMP_ID
                              and CompleteWithFormats.BRC_ID = TBL_COA.BRC_ID
                              and CompleteWithFormats.COA_isDeleted = TBL_COA.COA_isDeleted
                              and  TBL_COA.CMP_ID = @CMP_ID
                              and TBL_COA.BRC_ID  = @BRC_ID
                              and  TBL_COA.COA_isDeleted = @isDeleted
                              and CompleteWithFormats.COA_UID = TBL_COA.COA_UID
							  order by CompleteWithFormats.COA_UID