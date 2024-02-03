CREATE PROC [dbo].[sp_BRANCH_ROYALTY_selection]




AS

select ROW_NUMBER() OVer(order by BR_ADM_ID) as Sr,BR_ADM_ID [From Branch], BR_ADM_ROYALTY_TO_BRANCH [To Branch]  from BR_ADMIN 

where BR_ADM_ROYALTY_TO_BRANCH > 0


select BR_ADM_ID ID, (h.MAIN_INFO_INSTITUTION_FULL_NAME + ' (' + BR_ADM_NAME + ')') Name, d.DEFAULT_ACCT_KEY [Key], d.DEFAULT_ACCT_CODE Code from BR_ADMIN br 
join MAIN_HD_INFO h on h.MAIN_INFO_ID = br.BR_ADM_HD_ID
Left join TBL_DEFAULT_ACCT d on d.BRC_ID = br.BR_ADM_ID and d.DEFAULT_ACCT_KEY = 'Royalty' 
where BR_ADM_STATUS = 'T'