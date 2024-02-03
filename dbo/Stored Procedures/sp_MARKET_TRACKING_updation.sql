CREATE procedure  [dbo].[sp_MARKET_TRACKING_updation]
                                               
                                               
          @TRACK_ID  numeric,
          @TRACK_HD_ID  numeric,
          @TRACK_BR_ID  numeric,
          @TRACK_SCHOOL_NAME  nvarchar(100) ,
          @TRACK_SCHOOL_COUNTRY  numeric,
          @TRACK_SCHOOL_CITY  numeric,
          @TRACK_SCHOOL_AREA  numeric,
          @TRACK_SCHOOL_ADDRESS  nvarchar(300) ,
          @TRACK_SCHOOL_MOBILE_NO1  nvarchar(15) ,
          @TRACK_SCHOOL_MOBILE_NO2  nvarchar(15) ,
          @TRACK_SCHOOL_LANDLINE_NO  nvarchar(15) ,
          @TRACK_SCHOOL_EMAIL  nvarchar(100) ,
          @TRACK_SCHOOL_WEBSITE  nvarchar(100) ,
          @TRACK_CONTACT_NAME  nvarchar(100) ,
          @TRACK_CONTACT_DESIGNATION  numeric,
          @TRACK_CONTACT_MOBILE_NO  nvarchar(15) ,
          @TRACK_CONTACT_LANDLINE_NO  nvarchar(15) ,
          @TRACK_CONTACT_EMAIL  nvarchar(100) ,
          @TRACK_SALES_REPRESENTATIVE  numeric ,
          @TRACK_REFFERED_BY  nvarchar(100) ,
          @TRACK_MARKETING_MODE_ID  numeric,
          @TRACK_STATUS  numeric
   
   
     as begin 
   
   
     update MARKET_TRACKING
 
     set
          TRACK_SCHOOL_NAME =  @TRACK_SCHOOL_NAME,
          TRACK_SCHOOL_COUNTRY =  @TRACK_SCHOOL_COUNTRY,
          TRACK_SCHOOL_CITY =  @TRACK_SCHOOL_CITY,
          TRACK_SCHOOL_AREA =  @TRACK_SCHOOL_AREA,
          TRACK_SCHOOL_ADDRESS =  @TRACK_SCHOOL_ADDRESS,
          TRACK_SCHOOL_MOBILE_NO1 =  @TRACK_SCHOOL_MOBILE_NO1,
          TRACK_SCHOOL_MOBILE_NO2 =  @TRACK_SCHOOL_MOBILE_NO2,
          TRACK_SCHOOL_LANDLINE_NO =  @TRACK_SCHOOL_LANDLINE_NO,
          TRACK_SCHOOL_EMAIL =  @TRACK_SCHOOL_EMAIL,
          TRACK_SCHOOL_WEBSITE =  @TRACK_SCHOOL_WEBSITE,
          TRACK_CONTACT_NAME =  @TRACK_CONTACT_NAME,
          TRACK_CONTACT_DESIGNATION =  @TRACK_CONTACT_DESIGNATION,
          TRACK_CONTACT_MOBILE_NO =  @TRACK_CONTACT_MOBILE_NO,
          TRACK_CONTACT_LANDLINE_NO =  @TRACK_CONTACT_LANDLINE_NO,
          TRACK_CONTACT_EMAIL =  @TRACK_CONTACT_EMAIL,
          TRACK_SALES_REPRESENTATIVE =  @TRACK_SALES_REPRESENTATIVE,
          TRACK_REFFERED_BY =  @TRACK_REFFERED_BY,
          TRACK_MARKETING_MODE_ID =  @TRACK_MARKETING_MODE_ID,
          TRACK_STATUS =  @TRACK_STATUS
 
     where 
          TRACK_ID =  @TRACK_ID 
end