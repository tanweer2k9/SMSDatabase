CREATE procedure  [dbo].[sp_SETTINGS_updation]
                                               
                                               
          @ID  numeric,
          @HD_ID  numeric,
          @BR_ID  numeric,
          @Name  nvarchar(100) ,
          @Value  nvarchar(500) 
   
   
     as begin 
   
   
   declare @count int = 0

   set @count = (select COUNT(*) from SETTINGS where Name = @Name)

   if @count = 1
   BEGIN
		update SETTINGS set Value =  @Value   where  Name =  @Name
   END 
   ELSE
   BEGIN
		insert into SETTINGS values (@HD_ID, @BR_ID, @Name, @Value )
   END
end