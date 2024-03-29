﻿CREATE proc [dbo].[sp_SCHOOL_REGISTRATION]

	@STATUS char(1)
AS

	if @STATUS = 'L'
	begin
		select NATIONALITY_ID as ID, NATIONALITY_NAME as Name from NATIONALITY_INFO where NATIONALITY_HD_ID = 1 and NATIONALITY_BR_ID = 1
		select INST_LEVEL_ID as ID, INST_LEVEL_NAME as Name from INSTITUTION_LEVEL_INFO where INST_LEVEL_HD_ID = 1 and INST_LEVEL_BR_ID = 1
		select MAIN_INFO_ID, MAIN_INFO_EMAIL from MAIN_HD_INFO
		select BR_ADM_ID, BR_ADM_EMAIL from BR_ADMIN
	end