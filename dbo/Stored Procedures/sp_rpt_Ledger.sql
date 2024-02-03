CREATE procedure [dbo].[sp_rpt_Ledger]

@CMP_ID nvarchar(50),
@BRC_ID nvarchar(50),
@fromDate datetime,
@toDate datetime,
@COA_UID nvarchar(50),
@isDeleted bit
as

declare @accoutType nvarchar(50)
set @accoutType = (select TBL_COA.COA_nature from TBL_COA where TBL_COA.COA_UID =  @COA_UID ) --'Debit'

;with tbl_LedgerWithoutSR as
(
   select 'OpeningBalance' [Color_Status],  A.VCH_DEF_date , a.VCH_MAIN_ID,  a.VCH_DEF_narration ,  
       sum(A.VCH_DEF_debit) [VCH_DEF_debit] , sum(A.VCH_DEF_credit)[VCH_DEF_credit] , 
       SUM(A.RowBalance)[RowBalance] 
       from (

				select null [VCH_DEF_date] , null VCH_MAIN_ID , 'Opening Balance' VCH_DEF_narration , 
					   TBL_VCH_DEF.VCH_DEF_debit VCH_DEF_debit ,
					   TBL_VCH_DEF.VCH_DEF_credit VCH_DEF_credit, 
					   RowBalance =( case @accoutType when 'Debit' 
													 then TBL_VCH_DEF.VCH_DEF_debit  - TBL_VCH_DEF.VCH_DEF_credit
													 else TBL_VCH_DEF.VCH_DEF_credit - TBL_VCH_DEF.VCH_DEF_debit 
									  end
									) 
				                    



				from      TBL_VCH_DEF 
				where     TBL_VCH_DEF.VCH_DEF_COA = @COA_UID
						  and TBL_VCH_DEF.VCH_DEF_date < @fromDate
						  and CMP_ID = @CMP_ID
						  and BRC_ID = @BRC_ID
						  and VCH_DEF_isDeleted = @isDeleted
						  

            )A 
             group by  A.VCH_DEF_date , A.VCH_MAIN_ID , A.VCH_DEF_narration 


		  
    
  union all
      
select 'Transaction' [Color_Status] ,  TBL_VCH_DEF.VCH_DEF_date , TBL_VCH_DEF.VCH_MAIN_ID , 
       TBL_VCH_DEF.VCH_DEF_narration , 
       TBL_VCH_DEF.VCH_DEF_debit , TBL_VCH_DEF.VCH_DEF_credit, 
       RowBalance = ( case @accoutType when 'Debit' 
                                     then TBL_VCH_DEF.VCH_DEF_debit  - TBL_VCH_DEF.VCH_DEF_credit
                                     else TBL_VCH_DEF.VCH_DEF_credit - TBL_VCH_DEF.VCH_DEF_debit 
                      end
                    )



from TBL_VCH_DEF 
where TBL_VCH_DEF.VCH_DEF_COA = @COA_UID
      and TBL_VCH_DEF.VCH_DEF_date >= @fromDate
      and TBL_VCH_DEF.VCH_DEF_date <= @toDate
       and CMP_ID = @CMP_ID
						  and BRC_ID = @BRC_ID
						  and VCH_DEF_isDeleted = @isDeleted
      
)

, tbl_LedgerWithSR as(
select ROW_NUMBER() over (order by VCH_DEF_date ) as sr,* from tbl_LedgerWithoutSR
)

, tbl_LedgerWithoutFormat as(
select  RunningSum = 
                     (
                     
                     select SUM(tbl_2.[RowBalance]) from tbl_LedgerWithSR tbl_2 
                     where tbl_2.sr <= tbl_1.sr
                     
                      )  , * from tbl_LedgerWithSR tbl_1
)

select dbo.getLedgerColsingFormating(@accoutType , cast(RunningSum as decimal(18,6))) 'RunningSum' , * from tbl_LedgerWithoutFormat

--select * from tbl_LedgerWithoutSR