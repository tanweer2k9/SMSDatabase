
     CREATE procedure  sp_MANUAL_SALARY_selection
                                               
                                               
    
     @MANUAL_SALARY_HD_ID  numeric,
     @MANUAL_SALARY_BR_ID  numeric,
	 @MANUL_SALARY_MONTH_YEAR date
   
     AS BEGIN 
	

   
     SELECT t.ID,[Employee Code],Name,Designation,[Department Name],CONVERT(nvarchar(100),[Joining Date],103)[Joining Date], m.MANUAL_SALARY_DEDUCT_DAYS [Deduct Days],m.MANUAL_SALARY_ACTUAL_DEDUCT_DAYS [Actual Days]
FROM VTEACHER_INFO t

left join MANUAL_SALARY m on m.MANUAL_SALARY_STAFF_ID = t.ID and  DATEPART(MM,m.MANUL_SALARY_MONTH_YEAR) = DATEPART(MM,@MANUL_SALARY_MONTH_YEAR) and DATEPART(YYYY,m.MANUL_SALARY_MONTH_YEAR) = DATEPART(YYYY,@MANUL_SALARY_MONTH_YEAR)
where
[Institute ID] =  @MANUAL_SALARY_HD_ID 
    and  [Branch ID] = @MANUAL_SALARY_BR_ID
    and Status =  'T'
	  
	order by Ranking

     END