CREATE PROC rpt_HOUSE_Basic_Info


@HD_ID numeric,
@BR_ID numeric,
@CLASS_ID numeric


AS




select distinct ID,Name,Description from VHOUSES_INFO  h
join STUDENT_INFO s on s.STDNT_HOUSE_ID = h.ID and s.STDNT_BR_ID = @BR_ID and s.STDNT_STATUS = 'T' and (@CLASS_ID = 0 OR s.STDNT_CLASS_PLANE_ID = @CLASS_ID )
where [Institute ID] = @HD_ID and [Branch ID] = @BR_ID and Status= 'T'