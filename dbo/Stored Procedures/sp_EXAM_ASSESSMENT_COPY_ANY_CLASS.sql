


CREATE PROC [dbo].[sp_EXAM_ASSESSMENT_COPY_ANY_CLASS]

@FromClassId numeric,
@ToClassId numeric
AS


--declare @FromClassId numeric = 19
--declare @ToClassId numeric = 20093


if (select COUNT(*) from EXAM_ASSESS_CATEGORY_INFO where EXAM_CAT_CLASS_ID = @ToClassId) =0
BEGIn



declare @HD_ID numeric
declare @BR_ID numeric


select @HD_ID = CLASS_HD_ID, @BR_ID = CLASS_BR_ID from SCHOOL_PLANE where CLASS_ID = @ToClassId

insert into EXAM_ASSESS_CATEGORY_INFO
select @HD_ID, @BR_ID, EXAM_CAT_MAIN_CAT_ID,@ToClassId ,EXAM_CAT_NAME, EXAM_CAT_DESC, EXAM_CAT_STATUS, EXAM_CAT_ORDER from EXAM_ASSESS_CATEGORY_INFO
where EXAM_CAT_CLASS_ID = @FromClassId



update A set A.EXAM_CAT_MAIN_CAT_ID = NewMainCatId
from
(
select e1.*, (select e3.EXAM_CAT_ID from EXAM_ASSESS_CATEGORY_INFO e3 where e3.EXAM_CAT_CLASS_ID = e1.EXAM_CAT_CLASS_ID and e3.EXAM_CAT_NAME = (select e2.EXAM_CAT_NAME from EXAM_ASSESS_CATEGORY_INFO e2 where e1.EXAM_CAT_MAIN_CAT_ID = e2.EXAM_CAT_ID )) NewMainCatId from EXAM_ASSESS_CATEGORY_INFO e1

where e1.EXAM_CAT_CLASS_ID = @ToClassId

)A where A.NewMainCatId is not null



insert into EXAM_CATEGORY_CRITERIA
select @HD_ID,@BR_ID, NewExamCatID, CAT_CRITERIA_NAME,CAT_CRITERIA_STATUS from 
(

select *,(select A.EXAM_CAT_ID from
(select ea.*, CASE WHEN ea.EXAM_CAT_MAIN_CAT_ID = -1 THEN '' ELSE  (select EXAM_CAT_NAME from  EXAM_ASSESS_CATEGORY_INFO where EXAM_CAT_ID =  ea.EXAM_CAT_MAIN_CAT_ID) END ParntCatName from EXAM_ASSESS_CATEGORY_INFO ea

where ea.EXAM_CAT_CLASS_ID = @ToClassId and ea.EXAM_CAT_NAME = (select EXAM_CAT_NAME from EXAM_ASSESS_CATEGORY_INFO where EXAM_CAT_ID = ec1.CAT_CRITERIA_EXAM_CAT_ID) and ea.EXAM_CAT_DESC= (select EXAM_CAT_DESC from EXAM_ASSESS_CATEGORY_INFO where EXAM_CAT_ID = ec1.CAT_CRITERIA_EXAM_CAT_ID))A
where A.ParntCatName = CASE WHEN (select EXAM_CAT_MAIN_CAT_ID from EXAM_ASSESS_CATEGORY_INFO where EXAM_CAT_ID = ec1.CAT_CRITERIA_EXAM_CAT_ID) = -1 THEN A.ParntCatName ELSE (select EXAM_CAT_NAME from EXAM_ASSESS_CATEGORY_INFO where EXAM_CAT_ID = (select EXAM_CAT_MAIN_CAT_ID from EXAM_ASSESS_CATEGORY_INFO where EXAM_CAT_ID = ec1.CAT_CRITERIA_EXAM_CAT_ID)) END

) NewExamCatID from EXAM_CATEGORY_CRITERIA ec1

where CAT_CRITERIA_EXAM_CAT_ID is not null and ec1.CAT_CRITERIA_EXAM_CAT_ID in (select EXAM_CAT_ID from EXAM_ASSESS_CATEGORY_INFO where EXAM_CAT_CLASS_ID = @FromClassId)
)B where B.NewExamCatID is not null

order by CAT_CRITERIA_ID

select 'ok'

END

ELSE
BEGIN
	select 'There Are Already Assessments in this class'
END