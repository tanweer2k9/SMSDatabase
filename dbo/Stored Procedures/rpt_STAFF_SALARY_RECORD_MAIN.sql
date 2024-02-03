


CREATE PROC [dbo].[rpt_STAFF_SALARY_RECORD_MAIN]

@HD_ID numeric,
@BR_ID numeric,
@STAFF_ID numeric,
@FROM_DATE date,
@TO_DATE date,
@is_hold bit


AS

declare @tbl table (SNo int, EmpCode nvarchar(50),SalaryMonth nvarchar(50),Name nvarchar(50),Desig nvarchar(50),Dept nvarchar(50),Salary float,DeptID int,joiningDate date,ConfirDate date,DaysWorked int,[Earned Salary]float,RegAll float,OtherPay float,[Gross Salary] float,OtherDed float,IncomeTax float,[Net Salary] float,Remarks nvarchar(50),SalMonYear nvarchar(50))

insert into @tbl


exec [rpt_STAFF_SALARY_RECORD] @HD_ID ,@BR_ID,@STAFF_ID,@FROM_DATE,@TO_DATE,@is_hold

declare @salary int
declare @earned_salary int
declare @gross_salary int
declare @net_salary int
declare @month_salary nvarchar(100)
declare @income_tax int

select @salary = ROUND(SUM(Salary),0) ,@earned_salary = ROUND(SUM([Earned Salary]),0),@gross_salary = ROUND(SUM([Gross Salary]),0) ,@income_tax = ROUND(SUM([IncomeTax]),0),@net_salary = ROUND(SUM([Net Salary]),0)  from @tbl

select top(1) @month_salary = SalMonYear from @tbl 

select ID,Name,@salary Salary,@earned_salary [Earned Salary],@gross_salary [Gross Salary],@income_tax [IncomeTax],@net_salary [Net Salary],@month_salary [Salary Month Year] from VDEPARTMENT_INFO 

where [Institute ID] = @HD_ID and [Branch ID] = @BR_ID and Status = 'T' 
and ID in (select DeptID from @tbl)

order by [Rank]