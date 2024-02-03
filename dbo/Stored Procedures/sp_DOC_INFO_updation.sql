CREATE procedure  [dbo].[sp_DOC_INFO_updation]
                                               
                                               
          @DOC_INFO_ID  numeric,       
          @DOC_INFO_NAME  nvarchar(500) ,
          @DOC_INFO_CUSTODAN  nvarchar(500) ,      
          @DOC_INFO_STATUS  char(2) ,
		  @DOC_INFO_TEXT nvarchar(50)
   
     as begin 
   
   
     update DOC_INFO
 
     set
         
          DOC_INFO_NAME =  @DOC_INFO_NAME,
          DOC_INFO_CUSTODAN =  @DOC_INFO_CUSTODAN,         
          DOC_INFO_STATUS =  @DOC_INFO_STATUS,
          DOC_INFO_TEXT = @DOC_INFO_TEXT
 
     where 
          DOC_INFO_ID =  @DOC_INFO_ID 
          
 
end