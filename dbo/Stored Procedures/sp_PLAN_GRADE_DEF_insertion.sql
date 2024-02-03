CREATE procedure  [dbo].[sp_PLAN_GRADE_DEF_insertion]
                                               
                                               
          @DEF_P_ID  numeric,
          @DEF_GRADE_MIN_LIMIT  float ,
          @DEF_GRADE_MIN_OPERATOR  nvarchar(50) ,
          @DEF_GRADE_MAX_LIMIT  float,
          @DEF_GRADE_MAX_OPERATOR  nvarchar(50) ,
          @DEF_GRADE_INFO_ID  numeric ,
          @DEF_GRADE_STATUS  char(2) ,
		  @DEF_GRADE_DESCRIPTION nvarchar(300),
          @status char(2),
		  @DEF_GRADE_POINTS float
   
   
     as  
     
     --declare @BR_ID int = 0
     --declare @HD_ID int = 0
     --select @BR_ID = p.P_GRADE_BR_ID, @HD_ID = p.P_GRADE_HD_ID from PLAN_GRADE p
     --declare @grade_info_id int  = (select GRADE_ID from GRADE_INFO where GRADE_NAME = @DEF_GRADE_INFO_ID and GRADE_HD_ID =@HD_ID and GRADE_BR_ID = @BR_ID)
     
     if @status = 'I'     
     begin   
      declare @id int 
   
     set @id = ( select  isnull( (max(cast( P_GRADE_ID as int ))),0) from  PLAN_GRADE )     
   
     insert into PLAN_GRADE_DEF
     values
     (        
        @id,
        @DEF_GRADE_MIN_LIMIT,
        @DEF_GRADE_MIN_OPERATOR,
        @DEF_GRADE_MAX_LIMIT,
        @DEF_GRADE_MAX_OPERATOR,
        @DEF_GRADE_INFO_ID,
		@DEF_GRADE_DESCRIPTION,
        @DEF_GRADE_STATUS,
		@DEF_GRADE_POINTS          
     )
     
end



else
begin
 insert into PLAN_GRADE_DEF
     values
     (  
        @DEF_P_ID,
        @DEF_GRADE_MIN_LIMIT,
        @DEF_GRADE_MIN_OPERATOR,
        @DEF_GRADE_MAX_LIMIT,
        @DEF_GRADE_MAX_OPERATOR,
        @DEF_GRADE_INFO_ID,
		@DEF_GRADE_DESCRIPTION,
        @DEF_GRADE_STATUS,
		@DEF_GRADE_POINTS
     )

end