
CREATE procedure  [dbo].[sp_SHORT_LEAVE_selection]
                                               
                                               
    	@STATUS char(10),		
		@ATTENDANCE_STAFF_HD_ID  numeric,
		@ATTENDANCE_STAFF_BR_ID  numeric,
		@ATTENDANCE_STAFF_DATE  date
   
   
     AS BEGIN 
   
   
     if @STATUS = 'L'
     BEGIN   
		select * from
		(select t.TECH_ID as [tchId], t.TECH_DESIGNATION as Designation, (t.TECH_FIRST_NAME + ' ' + t.TECH_LAST_NAME) as Name, '' as Reason, '12:00:00 AM' as [From Time], '12:00:00 AM' as [To Time],t.TECH_RANKING, CAST(0 as bit) [From Annual]
		from TEACHER_INFO t
		where 
			TECH_BR_ID  in ( select * from [dbo].[get_centralized_br_id]('S', @ATTENDANCE_STAFF_BR_ID) )and
			TECH_HD_ID = @ATTENDANCE_STAFF_HD_ID and
			TECH_STATUS = 'T' and  @ATTENDANCE_STAFF_DATE >= t.TECH_LEFT_DATE and @ATTENDANCE_STAFF_DATE >= t.TECH_JOINING_DATE
			and t.TECH_ID not in (select SHORT_LEAVE_STAFF_ID from short_leave where SHORT_LEAVE_DATE = @ATTENDANCE_STAFF_DATE)
			
		union 

		select t.TECH_ID as [tchId], t.TECH_DESIGNATION as Designation, (t.TECH_FIRST_NAME + ' ' + t.TECH_LAST_NAME) as Name,
		SHORT_LEAVE_REASON as Reason, SHORT_LEAVE_FROM_TIME as [From Time], SHORT_LEAVE_TO_TIME as [To Time], t.TECH_RANKING , s.SHORT_LEAVE_IS_ANNUAL[From Annual]
		from SHORT_LEAVE s
		join TEACHER_INFO t on t.TECH_ID = s.SHORT_LEAVE_STAFF_ID
		where s.SHORT_LEAVE_DATE = @ATTENDANCE_STAFF_DATE
		)A
		order by TECH_RANKING, tchId
     END  


	 else if @STATUS = 'A'
		begin
			select 0
		end
 
     END