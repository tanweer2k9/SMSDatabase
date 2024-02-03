create procedure  [dbo].[sp_MARKET_TRACKING_DEF_insertion]
                                               
                                               
          @TRACK_DEF_PID  numeric,
          @TRACK_DEF_MEETING_DATE  datetime,
          @TRACK_DEF_MEETING_PERSON  nvarchar(100) ,
          @TRACK_DEF_COMMENTS_BY_CLIENT  nvarchar(300) ,
          @TRACK_DEF_COMMENTS_BY_MARKETIG_AGENT  nvarchar(300) ,
          @TRACK_DEF_NEXT_SCHEDULE_MEETING  datetime
   
   
     as  begin
   
   
     insert into MARKET_TRACKING_DEF
     values
     (
        @TRACK_DEF_PID,
        @TRACK_DEF_MEETING_DATE,
        @TRACK_DEF_MEETING_PERSON,
        @TRACK_DEF_COMMENTS_BY_CLIENT,
        @TRACK_DEF_COMMENTS_BY_MARKETIG_AGENT,
        @TRACK_DEF_NEXT_SCHEDULE_MEETING
     
     
     )
     
end