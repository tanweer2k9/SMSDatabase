CREATE PROC [dbo].[sp_STAFF_MACHINE_ALLOCATION_selection]

AS


select ID, [Employee Code],Name, Designation from VTEACHER_INFO

select * from STAFF_MACHINE_ALLOCATION