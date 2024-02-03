CREATE PROC [dbo].[sp_STAFF_MACHINE_ALLOCATION_insertion]

@dt_staff dbo.[type_STAFF_MACHINE_ALLOCATION] readonly

AS

delete from STAFF_MACHINE_ALLOCATION

insert into STAFF_MACHINE_ALLOCATION 
select * from @dt_staff