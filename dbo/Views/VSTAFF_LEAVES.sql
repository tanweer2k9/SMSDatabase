CREATE VIEW [dbo].[VSTAFF_LEAVES]
AS
SELECT        STAFF_LEAVES_ID AS ID, STAFF_LEAVES_NAME AS Name, STAFF_LEAVES_YEAR AS Year, STAFF_LEAVES_MONTHLY_LIMIT AS Month, STAFF_LEAVES_TRANSFER_YEAR AS [Transfer Year], 
                         STAFF_LEAVES_TRANSFER_MONTH AS [Transfer Month], STAFF_LEAVES_STAFF_ID AS [Staff ID], STAFF_LEAVES_ABSENT_DEDUCTION AS [Absent Deduction], 
                         STAFF_LEAVES_LATE_PER_ABSENT AS [Late Per Absent], STAFF_LEAVES_DEDUCTION_LEAVES AS [Deduction Leaves], STAFF_LEAVES_ADD_WEEKEND_HOLIDAYS AS [Add Weekend Holidays], 
                         STAFF_LEAVES_ADD_EXCEPTIONAL_HOLIDAYS AS [Add Exceptional Holidays], STAFF_LEAVES_ADD_DEDUCTION AS [Add Deduction], STAFF_LEAVES_ADD_ALLOWANCES AS [Add Allowance], 
                         STAFF_LEAVES_ADD_LOAN AS [Add Loan], STAFF_LEAVES_DEDUCT_LEAVES_STATUS AS [Deduct Limit Leaves], STAFF_LEAVES_DEDUCT_ABSENT_STATUS AS [Deduct Limit Absent], 
                         STAFF_LEAVES_DATE AS [Enter Date], STAFF_LEAVES_USER AS [User], STAFF_LEAVES_STATUS AS Status, STAFF_LEAVES_HD_ID AS [Institute ID], STAFF_LEAVES_BR_ID AS [Branch ID], 
                         STAFF_LEAVES_CONSECUTIVE_ABSENT_STATUS AS [Consecutive Absent Status], STAFF_LEAVES_CONSECUTIVE_LEAVES_STATUS AS [Consecutive Leave Status], 
                         STAFF_LEAVES_CONSECUTIVE_BEFORE_WEEKENDS AS [Consecutive Before Count], STAFF_LEAVES_CONSECUTIVE_AFTER_WEEKENDS AS [Consecutive After Count], 
                         STAFF_LEAVES_DEDUCT_LEAVES_COUNT AS [Deduct Leaves Count], STAFF_LEAVES_DEDUCT_ABSENT_COUNT AS [Deduct Absent Count], STAFF_LEAVES_PER_DAY_SALARY_TYPE AS [Per Day Salary Type], 
                         STAFF_LEAVES_LATE_DEDUCTION_TYPE AS [Late Deduction Type], STAFF_LEAVES_PAYROLL_MINUTES_IN_HOUR AS [Minutes in One Hour], STAFF_LEAVES_PAYROLL_HOURS_IN_DAY AS [Hours in One Day], 
                         STAFF_LEAVES_PAYROLL_OVERTIME_MINUTES_IN_HOUR_BEFORE_TIMEIN AS [Minutes in One Hour Overtime Before Timein], 
                         STAFF_LEAVES_PAYROLL_EARLY_DEPARTURE_MINUTES AS [Early departure Minutes], STAFF_LEAVES_SUMMER_LEAVES AS [Summer Leaves], STAFF_LEAVES_WINTER_LEAVES AS [Winter Leaves], 
                         STAFF_LEAVES_EARLY_PER_ABSENT AS [Early Per Absent]
FROM            dbo.STAFF_LEAVES