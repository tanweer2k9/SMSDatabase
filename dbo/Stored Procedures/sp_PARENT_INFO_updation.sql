CREATE procedure  [dbo].[sp_PARENT_INFO_updation]
                                               
                                               
          @PARNT_ID  numeric,
          @PARNT_HD_ID  numeric,
          @PARNT_BR_ID  numeric,
          @PARNT_REG_BY_ID  numeric,
          @PARNT_REG_BY_TYPE  nvarchar(50) ,
          @PARNT_FULL_NAME  nvarchar(50) ,
          @PARNT_FIRST_NAME  nvarchar(50) ,
          @PARNT_LAST_NAME  nvarchar(50) ,
          @PARNT_NATIONALITY  nvarchar(50) ,
          @PARNT_RELIGION  nvarchar(50) ,
          @PARNT_DOB  datetime,
          @PARNT_CNIC  nvarchar(20) ,
          @PARNT_OCCUPATION  nvarchar(50) ,
          @PARNT_MOTHR_LANG  nvarchar(50) ,
          @PARNT_EMAIL  nvarchar(50) ,
          @PARNT_IMG  nvarchar(max) ,
          @PARNT_CELL_NO  nvarchar(20) ,
          @PARNT_RESIDENCE_NO  nvarchar(20) ,
          @PARNT_OFFICE_NO  nvarchar(20) ,
          @PARNT_TEMP_ADDR  nvarchar(max) ,
          @PARNT_PERM_ADDR  nvarchar(max) ,
          @PARNT_FIRST_NAME2  nvarchar(50) ,
          @PARNT_LAST_NAME2  nvarchar(50) ,
          @PARNT_NATIONALITY2  nvarchar(50) ,
          @PARNT_RELIGION2  nvarchar(50) ,
          @PARNT_DOB2  datetime,
          @PARNT_CNIC2  nvarchar(50) ,
          @PARNT_OCCUPATION2  nvarchar(50) ,
          @PARNT_MOTHR_LANG2  nvarchar(50) ,
          @PARNT_EMAIL2  nvarchar(50) ,
          @PARNT_IMG2  nvarchar(max) ,
          @PARNT_CELL_NO2  nvarchar(20) ,
          @PARNT_RESIDENCE_NO2  nvarchar(20) ,
          @PARNT_OFFICE_NO2  nvarchar(20) ,
          @PARNT_TEMP_ADDR2  nvarchar(max) ,
          @PARNT_PERM_ADDR2  nvarchar(max) ,
          @PARNT_REG_DATE  datetime,
          @PARNT_STATUS  char(2) ,
		  @PARNT_REG  nvarchar(50),
		  @PARNT_REG2  nvarchar(50),
		  @STATUS char(1),
		
		 @USER_STATUS char(2),
		  @PARNT_FAMILY_CODE nvarchar(50),
		  @PARNT_AREA numeric,
		  @PARNT_CITY numeric
   
     as begin 
   
   
    if(@PARNT_IMG = ( SELECT PATH_PAR_IMG FROM PATH_INFO WHERE PATH_STATUS = 'T' ))
    begin    
		set @PARNT_IMG = ( SELECT PARNT_IMG FROM PARENT_INFO WHERE PARNT_ID = @PARNT_ID)			
    end 
    
    else    
    begin
		set @PARNT_IMG = ( ( SELECT PATH_PAR_IMG FROM PATH_INFO WHERE PATH_STATUS = 'T' ) + ( CONVERT(nvarchar, @PARNT_ID) ) + 'F.png' )			
    end
   

    if(@PARNT_IMG2 = ( SELECT PATH_PAR_IMG FROM PATH_INFO WHERE PATH_STATUS = 'T' ))
    begin    		
		set @PARNT_IMG2 = ( SELECT PARNT_IMG2 FROM PARENT_INFO WHERE PARNT_ID = @PARNT_ID)		
    end 
    
    else    
    begin		
		set @PARNT_IMG2 = ( ( SELECT PATH_PAR_IMG FROM PATH_INFO WHERE PATH_STATUS = 'T' ) + ( CONVERT(nvarchar, @PARNT_ID) ) + 'M.png' )		
    end

   

   if @STATUS = 'S'--student update
	begin
		
		     update PARENT_INFO
 
     set
          PARNT_REG_BY_ID =  @PARNT_REG_BY_ID,
          PARNT_REG_BY_TYPE =  @PARNT_REG_BY_TYPE,
          PARNT_FULL_NAME =  @PARNT_FULL_NAME,
          PARNT_FIRST_NAME =  @PARNT_FIRST_NAME,
          PARNT_LAST_NAME =  @PARNT_LAST_NAME,
          
          PARNT_OCCUPATION =  @PARNT_OCCUPATION,



          PARNT_CELL_NO =  @PARNT_CELL_NO,

          PARNT_TEMP_ADDR =  @PARNT_TEMP_ADDR,
          PARNT_PERM_ADDR =  @PARNT_PERM_ADDR,
          PARNT_FIRST_NAME2 =  @PARNT_FIRST_NAME2,
          PARNT_LAST_NAME2 =  @PARNT_LAST_NAME2,



          PARNT_OCCUPATION2 =  @PARNT_OCCUPATION2,


          PARNT_CELL_NO2 =  @PARNT_CELL_NO2,

          PARNT_TEMP_ADDR2 =  @PARNT_TEMP_ADDR2,
          PARNT_PERM_ADDR2 =  @PARNT_PERM_ADDR2,

          PARNT_REG = @PARNT_REG,
          PARNT_REG2 = @PARNT_REG2,		  
		  PARNT_FAMILY_CODE  = @PARNT_FAMILY_CODE ,
		  PARNT_AREA=@PARNT_AREA,
		  PARNT_CITY=@PARNT_CITY
 
     where 
          PARNT_ID =  @PARNT_ID
          --and PARNT_HD_ID =  @PARNT_HD_ID
          --and PARNT_BR_ID =  @PARNT_BR_ID 
	end
   else
   begin
     update PARENT_INFO
 
     set
          PARNT_REG_BY_ID =  @PARNT_REG_BY_ID,
          PARNT_REG_BY_TYPE =  @PARNT_REG_BY_TYPE,
          PARNT_FULL_NAME =  @PARNT_FULL_NAME,
          PARNT_FIRST_NAME =  @PARNT_FIRST_NAME,
          PARNT_LAST_NAME =  @PARNT_LAST_NAME,
          PARNT_NATIONALITY =  @PARNT_NATIONALITY,
          PARNT_RELIGION =  @PARNT_RELIGION,
          PARNT_DOB =  @PARNT_DOB,
          PARNT_CNIC =  @PARNT_CNIC,
          PARNT_OCCUPATION =  @PARNT_OCCUPATION,
          PARNT_MOTHR_LANG =  @PARNT_MOTHR_LANG,
          PARNT_EMAIL =  @PARNT_EMAIL,
          PARNT_IMG =  @PARNT_IMG,
          PARNT_CELL_NO =  @PARNT_CELL_NO,
          PARNT_RESIDENCE_NO =  @PARNT_RESIDENCE_NO,
          PARNT_OFFICE_NO =  @PARNT_OFFICE_NO,
          PARNT_TEMP_ADDR =  @PARNT_TEMP_ADDR,
          PARNT_PERM_ADDR =  @PARNT_PERM_ADDR,
          PARNT_FIRST_NAME2 =  @PARNT_FIRST_NAME2,
          PARNT_LAST_NAME2 =  @PARNT_LAST_NAME2,
          PARNT_NATIONALITY2 =  @PARNT_NATIONALITY2,
          PARNT_RELIGION2 =  @PARNT_RELIGION2,
          PARNT_DOB2 =  @PARNT_DOB2,
          PARNT_CNIC2 =  @PARNT_CNIC2,
          PARNT_OCCUPATION2 =  @PARNT_OCCUPATION2,
          PARNT_MOTHR_LANG2 =  @PARNT_MOTHR_LANG2,
          PARNT_EMAIL2 =  @PARNT_EMAIL2,
          PARNT_IMG2 =  @PARNT_IMG2,
          PARNT_CELL_NO2 =  @PARNT_CELL_NO2,
          PARNT_RESIDENCE_NO2 =  @PARNT_RESIDENCE_NO2,
          PARNT_OFFICE_NO2 =  @PARNT_OFFICE_NO2,
          PARNT_TEMP_ADDR2 =  @PARNT_TEMP_ADDR2,
          PARNT_PERM_ADDR2 =  @PARNT_PERM_ADDR2,
          PARNT_REG_DATE =  @PARNT_REG_DATE,
          PARNT_STATUS =  @PARNT_STATUS,
          PARNT_REG = @PARNT_REG,
          PARNT_REG2 = @PARNT_REG2,		  
		  PARNT_FAMILY_CODE  = @PARNT_FAMILY_CODE, 
		  PARNT_AREA=@PARNT_AREA,
		  PARNT_CITY=@PARNT_CITY
 
     where 
          PARNT_ID =  @PARNT_ID
          --and PARNT_HD_ID =  @PARNT_HD_ID
          --and PARNT_BR_ID =  @PARNT_BR_ID 
          
    end

	






           update USER_INFO 
     set
         
          USER_DISPLAY_NAME =  @PARNT_FULL_NAME,         
          USER_STATUS =  @USER_STATUS          
          where
			USER_CODE = @PARNT_ID
			--and USER_HD_ID = @PARNT_HD_ID
			--and USER_BR_ID = @PARNT_BR_ID
			and USER_TYPE ='Parent'
			 

		declare @tb table(code int)
		insert into @tb 
		SELECT LEFT(Val,PATINDEX('%[^0-9]%', Val+'a')-1)as family_code from(
		SELECT SUBSTRING([Family Code], PATINDEX('%[0-9]%', [Family Code]), LEN([Family Code])) Val from VPARENT_INFO 
		where [Institute ID] = @PARNT_HD_ID and [Branch ID] = @PARNT_BR_ID)A
		select MAX(code) from @tb
		
		
 
end