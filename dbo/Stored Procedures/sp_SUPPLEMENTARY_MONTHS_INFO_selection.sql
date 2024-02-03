CREATE procedure  [dbo].[sp_SUPPLEMENTARY_MONTHS_INFO_selection]
                                               
                                               
     @STATUS char(10),
     @SUPL_MONTH_ID  numeric,
     @SUPL_MONTH_HD_ID  numeric,
     @SUPL_MONTH_BR_ID  numeric
   
   
     AS BEGIN 
   
   
     if @STATUS = 'L'
     BEGIN
   
		SELECT ID,Name,[From Date],[To Date],Description,Status FROM VSUPPLEMENTARY_MONTHS_INFO where [Institute ID] = @SUPL_MONTH_HD_ID and [Branch ID] = @SUPL_MONTH_BR_ID order by [From Date] DESC
     END  
     
	 ELSE IF @STATUS = 'G'
	 BEGIN
		declare @start_date date = ''
		declare @end_date date = ''
		select top(1) @start_date = FEE_COLLECT_FEE_FROM_DATE, @end_date = FEE_COLLECT_FEE_TO_DATE from (select distinct FEE_COLLECT_FEE_FROM_DATE,FEE_COLLECT_FEE_TO_DATE from FEE_COLLECT where FEE_COLLECT_ID in ( select SCH_GEN_FEE_COLLECT_ID from SCHOLARSHIP_GENERATION where SCH_GEN_HD_ID = @SUPL_MONTH_HD_ID and SCH_GEN_BR_ID = @SUPL_MONTH_BR_ID and SCH_GEN_IS_CLEARED = 0 and SCH_GEN_PERCENT > 0))A

		select REPLACE(dbo.get_month_name(@start_date,@end_date),' to ','-')

		 select ID,Name from VSCHOOL_PLANE where ID in (select distinct SCH_GEN_CLASS_ID from SCHOLARSHIP_GENERATION where SCH_GEN_HD_ID = @SUPL_MONTH_HD_ID and SCH_GEN_BR_ID = @SUPL_MONTH_BR_ID and SCH_GEN_IS_CLEARED = 0) order by ID

		 select ID,[Student School ID], [Institute ID],[Branch ID],[Class Plan] as [Class Name],[First Name] as [Student Name],[Parent Name] as Parent, [Family Code],[Cell #] as [Cell NO#], [Fee ID], [Fee Plan] as [Fee Name], [Parent ID],[Status] from VSTUDENT_INFO where ID in (select SCH_GEN_STD_ID from SCHOLARSHIP_GENERATION where SCH_GEN_HD_ID = @SUPL_MONTH_HD_ID and SCH_GEN_BR_ID = @SUPL_MONTH_BR_ID and SCH_GEN_IS_CLEARED = 0 and SCH_GEN_PERCENT > 0) order by [Class ID], CAST([Student School ID] as int)

		--SELECT ID,Name FROM VSUPPLEMENTARY_MONTHS_INFO where [Institute ID] = @SUPL_MONTH_HD_ID and [Branch ID] = @SUPL_MONTH_BR_ID and Status = 'T' order by [From Date] DESC	
	 END


     END