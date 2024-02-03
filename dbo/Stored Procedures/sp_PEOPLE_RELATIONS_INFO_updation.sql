create procedure  [dbo].[sp_PEOPLE_RELATIONS_INFO_updation]
                                               
                                               
          @DEFINITION_ID  numeric,
          @DEFINITION_NAME  nvarchar(50) ,
          @DEFINITION_DESC  nvarchar(max) ,
          @DEFINITION_STATUS  char(2) 
   
   
   
     as begin 
   
   
     update PEOPLE_RELATIONS_INFO
 
     set
         
          PEOPLE_RELATIONS_NAME =  @DEFINITION_NAME,
          PEOPLE_RELATIONS_DESC =  @DEFINITION_DESC,
          PEOPLE_RELATIONS_STATUS =  @DEFINITION_STATUS
 
 where 
 
	PEOPLE_RELATIONS_ID = @DEFINITION_ID
 
 
end