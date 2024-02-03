CREATE PROC [dbo].[sp_ROYALTY_TRANSACTION_QUERY]


 @STATUS char(1),
 @USER_BR_ID numeric,
 @BR_ID numeric,
@FROM_DATE date,
@TO_DATE date

AS
--declare @br_id int = 3

declare @count int = 0
Declare @calculate_royalty_br int = 0
declare @class nvarchar(50) = '%'


select BR_ADM_ID ID, BR_ADM_NAME Name  from BR_ADMIN where BR_ADM_ROYALTY_TO_BRANCH = @USER_BR_ID



set @count = (select COUNT(*) from BR_ADMIN where BR_ADM_ROYALTY_TO_BRANCH = @USER_BR_ID)

if @count != 0 and @BR_ID = 0
BEGIN
	set @BR_ID = (select top(1) BR_ADM_ID from BR_ADMIN where BR_ADM_ROYALTY_TO_BRANCH = @USER_BR_ID)
END


IF @BR_ID = 0
BEGIN
	set @calculate_royalty_br = CAST(@USER_BR_ID as int)
END
ELSE
BEGIN
	set @calculate_royalty_br = CAST(@BR_ID as int) 
END







declare @to_br_id int = (select BR_ADM_ROYALTY_TO_BRANCH from BR_ADMIN where BR_ADM_ID =@calculate_royalty_br)

select ROW_NUMBER() Over(order by ID) as Sr,ID,[Bank Name],[Cheque No],Comments,Date,[Royalty Fee],[Royalty Dueable], Paid,([Royalty Dueable] - Paid) Due ,([Royalty Fee] - Paid) [Total Due]  from
(select r.ID,(select ISNULL(SUM(FEE_COLLECT_ROYALTY_FEE),0) from FEE_COLLECT where FEE_COLLECT_DATE_FEE_GENERATED between [From Date] and [To Date] and FEE_COLLECT_BR_ID = [BR ID]) as [Royalty Fee],
(select ISNULL(SUM(FEE_COLLECT_ROYALTY_PAID),0) from FEE_COLLECT where FEE_COLLECT_DATE_FEE_RECEIVED between [From Date] and [To Date] and FEE_COLLECT_BR_ID = [BR ID]) as [Royalty Dueable],
Amount Paid,[To Date] as [Date],[Bank Name],[Cheque No],Comments
,c.COA_Name Account
 from VROYALTY_TRANSACTION r
join TBL_VCH_DEF d on d.VCH_DEF_referenceNo = CAST(r.ID as nvarchar(50))
join TBL_COA c on  c.COA_UID = d.VCH_DEF_COA	and c.BRC_ID = d.BRC_ID	 and c.COA_Name != 'Royalty'
where r.[BR ID] = @calculate_royalty_br and c.BRC_ID = @to_br_id and d.BRC_ID = @to_br_id and r.[To Date] between @FROM_DATE and @TO_DATE
and c.COA_isDeleted = 0)A

 --select * from TBL_VCH_DEF
 --select * from VROYALTY_TRANSACTION