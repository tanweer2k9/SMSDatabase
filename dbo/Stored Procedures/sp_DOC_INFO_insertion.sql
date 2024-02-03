CREATE procedure  [dbo].[sp_DOC_INFO_insertion]
                                               
                                               
          @DOC_INFO_ACT_ID  numeric,
          @DOC_INFO_ACT_TYPE  nvarchar(20) ,
          @DOC_INFO_NAME  nvarchar(500) ,
          @DOC_INFO_CUSTODAN  nvarchar(500) ,
          @DOC_INFO_TEXT  nvarchar(500),
          @DOC_INFO_PATH  nvarchar(max) ,
          @DOC_INFO_STATUS  char(2)
		  
   
     as  begin
     
     declare @id as nvarchar(50)
     
     set @id =( select max(DOC_INFO_ID) + 1 from DOC_INFO) 
     set @DOC_INFO_PATH = ( ( SELECT PATH_STD_DOC FROM PATH_INFO WHERE PATH_STATUS = 'T' ) + (@id )+ ( @DOC_INFO_PATH) )
	
      
     insert into DOC_INFO
     values
     (        
        @DOC_INFO_ACT_ID,
        @DOC_INFO_ACT_TYPE,
        @DOC_INFO_NAME,
        @DOC_INFO_CUSTODAN,
        @DOC_INFO_TEXT,
        @DOC_INFO_PATH,
        @DOC_INFO_STATUS    
     )
     
    
     select 'ok' [Insert],@DOC_INFO_PATH as [Path]  from DOC_INFO
     
     
end