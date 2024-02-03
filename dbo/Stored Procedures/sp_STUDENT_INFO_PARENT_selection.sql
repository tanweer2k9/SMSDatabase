
CREATE PROC [sp_STUDENT_INFO_PARENT_selection]

	@BR_ID numeric

AS



select p.ID, [Family Code], p.[1st Relation Name] GuardianName, p.[1st Relation Cell #] [Cell],p.[1ST Relation] Relation,p.Area,p.City,p.[1st Relation Permanant Address] Address   from VPARENT_INFO p
		join MAIN_HD_INFO h on h.MAIN_INFO_ID = p.[Institute ID]
		join BR_ADMIN b on b.BR_ADM_ID = p.[Branch ID]
		 where
		 [Branch ID] in  (select COMBINE_BRANCHES_ID from COMBINE_BRANCHES where FROM_BRANCH_ID = @BR_ID) --( select * from [dbo].[get_centralized_br_id]('P', @STDNT_BR_ID))
    and  [Status]  = 'T'
    order by ID asc