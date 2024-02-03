create procedure  [dbo].[sp_SUMMER_WINTER_INFO_insertion]
                                               
                                               
          @SUM_WIN_SESSION_ID  numeric,
          @SUM_WIN_HD_ID  numeric,
          @SUM_WIN_BR_ID  numeric,
          @SUM_WIN_SUMMER_START_DATE  date,
          @SUM_WIN_SUMMER_END_DATE  date,
          @SUM_WIN_WINTER_START_DATE  date,
          @SUM_WIN_WINTER_END_DATE  date,
          @SUM_WIN_SEMESTER1_START_DATE  date,
          @SUM_WIN_SEMESTER1_END_DATE  date,
          @SUM_WIN_SEMESTER2_START_DATE  date,
          @SUM_WIN_SEMESTER2_END_DATE  date
   
   
     as  begin
   
   
     insert into SUMMER_WINTER_INFO
     values
     (
        @SUM_WIN_SESSION_ID,
        @SUM_WIN_HD_ID,
        @SUM_WIN_BR_ID,
        @SUM_WIN_SUMMER_START_DATE,
        @SUM_WIN_SUMMER_END_DATE,
        @SUM_WIN_WINTER_START_DATE,
        @SUM_WIN_WINTER_END_DATE,
        @SUM_WIN_SEMESTER1_START_DATE,
        @SUM_WIN_SEMESTER1_END_DATE,
        @SUM_WIN_SEMESTER2_START_DATE,
        @SUM_WIN_SEMESTER2_END_DATE
     
     
     )
     
end