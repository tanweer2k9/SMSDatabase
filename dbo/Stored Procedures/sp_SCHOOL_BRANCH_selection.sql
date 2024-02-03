CREATE PROC [dbo].[sp_SCHOOL_BRANCH_selection]

@STATUS char(1),
@HD_ID numeric,
@BR_ID numeric


AS


if @STATUS = 'A'
BEGIN
	select ID, [Institute Name] from VMAIN_HD_INFO
	select ID, Name,[Institute ID] as [HD ID] from V_BRANCH_INFO a
END
ELSE if @STATUS = 'B' --B For Branch Info
BEGIN
	select b.BR_ADM_NAME BranchName, h.MAIN_INFO_INSTITUTION_FULL_NAME SchoolName, b.BR_ADM_FONTS Fonts, b.BR_ADM_REPORTS_LOGO Logo from BR_ADMIN b
	join MAIN_HD_INFO h on h.MAIN_INFO_ID = b.BR_ADM_HD_ID
	where b.BR_ADM_ID = @BR_ID
END