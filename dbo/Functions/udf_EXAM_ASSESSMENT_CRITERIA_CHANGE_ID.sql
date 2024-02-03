CREATE FUNCTION udf_EXAM_ASSESSMENT_CRITERIA_CHANGE_ID (@criteria_id numeric, @old_class_id numeric,@new_class_id numeric)
returns numeric

AS
BEGIN

declare @cat_criteria_id numeric = 0 
declare @cat_criteria_name nvarchar(100) = '' 

declare @exam_cat_name_parent nvarchar(200) = ''
declare @exam_cat_main_cat_id_parent  numeric = 0 
declare @exam_cat_name nvarchar(200) = ''
declare @exam_cat_main_cat_id  numeric = 0 
declare @exam_cat_Desc nvarchar(10) = ''

declare @new_exam_cat_id numeric = 0
declare @new_exam_cat_main_cat_id_parent  numeric = 0 

declare @critearia_id numeric = 0

--select * from EXAM_CATEGORY_CRITERIA ecc where CAT_CRITERIA_ID = @criteria_id
select @cat_criteria_id = CAT_CRITERIA_EXAM_CAT_ID, @cat_criteria_name = CAT_CRITERIA_NAME from EXAM_CATEGORY_CRITERIA ecc where CAT_CRITERIA_ID = @criteria_id

--select * from EXAM_ASSESS_CATEGORY_INFO where EXAM_CAT_ID = @cat_criteria_id
select @exam_cat_name_parent = EXAM_CAT_NAME,@exam_cat_main_cat_id_parent = EXAM_CAT_MAIN_CAT_ID, @exam_cat_Desc = EXAM_CAT_DESC from EXAM_ASSESS_CATEGORY_INFO where EXAM_CAT_ID = @cat_criteria_id

if @exam_cat_main_cat_id_parent != -1
BEGIN
	--select * from EXAM_ASSESS_CATEGORY_INFO where EXAM_CAT_ID = @exam_cat_main_cat_id_parent
	select @exam_cat_name = EXAM_CAT_NAME,@exam_cat_main_cat_id = EXAM_CAT_MAIN_CAT_ID from EXAM_ASSESS_CATEGORY_INFO where EXAM_CAT_ID = @exam_cat_main_cat_id_parent
END


if @exam_cat_main_cat_id_parent != -1
BEGIN
	--select * from EXAM_ASSESS_CATEGORY_INFO where EXAM_CAT_NAME = @exam_cat_name and EXAM_CAT_CLASS_ID = @new_class_id --and EXAM_CAT_NAME = @exam_cat_name_parent
	select @new_exam_cat_id = EXAM_CAT_ID from EXAM_ASSESS_CATEGORY_INFO where EXAM_CAT_NAME = @exam_cat_name and EXAM_CAT_CLASS_ID = @new_class_id
END

	--select * from EXAM_ASSESS_CATEGORY_INFO where EXAM_CAT_MAIN_CAT_ID = @new_exam_cat_id and EXAM_CAT_NAME = @exam_cat_name_parent --and LTRIM(RTRIM(EXAM_CAT_DESC)) = LTRIM(RTRIM(@exam_cat_Desc)) 
	select @new_exam_cat_main_cat_id_parent = EXAM_CAT_ID from EXAM_ASSESS_CATEGORY_INFO where EXAM_CAT_MAIN_CAT_ID = @new_exam_cat_id and EXAM_CAT_NAME = @exam_cat_name_parent and LTRIM(RTRIM(EXAM_CAT_DESC)) = LTRIM(RTRIM(@exam_cat_Desc))


	--select * from EXAM_CATEGORY_CRITERIA where CAT_CRITERIA_EXAM_CAT_ID = @new_exam_cat_main_cat_id_parent and CAT_CRITERIA_NAME = @cat_criteria_name
	select @critearia_id = CAT_CRITERIA_ID from EXAM_CATEGORY_CRITERIA where CAT_CRITERIA_EXAM_CAT_ID = @new_exam_cat_main_cat_id_parent and CAT_CRITERIA_NAME = @cat_criteria_name

	return @critearia_id



END