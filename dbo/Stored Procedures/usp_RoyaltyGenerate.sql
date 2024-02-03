CREATE PROC [dbo].[usp_RoyaltyGenerate]

 @Session nvarchar(50) ,
 @BrId numeric ,
 @FromDate date ,
 @ToDate date 

AS
delete from RoyaltyDetailTemp where brid = @BrId and FromDate between @FromDate and @ToDate

insert into RoyaltyDetailTemp
select @BrId,@Session,*,GETDATE() from dbo.tf_RoyalityAll (@Session,@BrId,@FromDate,@ToDate)