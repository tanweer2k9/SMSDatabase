CREATE PROCEDURE  [dbo].[sp_DOCUMENT_INFO_deletion]
                                               
                                               
          @DOC_ID  numeric
   
   
     AS BEGIN 
   
   
     delete from DOCUMENT_INFO
 
 
     where 
          DOC_ID =  @DOC_ID 
 
end