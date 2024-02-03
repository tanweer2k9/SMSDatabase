CREATE procedure  [dbo].[sp_STAFF_LOAN_selection]
                                               
                                               
     @STATUS char(10),
     @STAFF_LOAN_ID  numeric,
     @STAFF_LOAN_HD_ID  numeric,
     @STAFF_LOAN_BR_ID  numeric
   
   
     AS BEGIN 
   
   
     if @STATUS = 'L'
     BEGIN
   
	 SELECT * FROM VTEACHER_INFO
      where 
    [Institute ID] = @STAFF_LOAN_HD_ID
    and  [Branch ID] in (select * from [dbo].[get_centralized_br_id]('S', @STAFF_LOAN_BR_ID))
    and [Status] = 'T' order by Ranking
    
    
     SELECT l.STAFF_LOAN_ID as [ID], t.TECH_FIRST_NAME + ' '+t.TECH_LAST_NAME as Name ,
     l.STAFF_LOAN_AMOUNT_TYPE as [Amount Type], l.STAFF_LOAN_AMOUNT as Amount, 
      l.STAFF_LOAN_DEDUCTION_TYPE as [Deduction Type], l.STAFF_LOAN_INSTALLS as [Total Installements],
      l.STAFF_LOAN_BASIC_SALARY as Salary, l.STAFF_LOAN_STAFF_ID as [Staff ID], l.STAFF_LOAN_STATUS as [Status]   
     FROM STAFF_LOAN l
     join TEACHER_INFO t
     on l.STAFF_LOAN_STAFF_ID = t.TECH_ID
     where
     l.STAFF_LOAN_HD_ID = @STAFF_LOAN_HD_ID and 
     l.STAFF_LOAN_BR_ID in (select * from [dbo].[get_centralized_br_id]('S', @STAFF_LOAN_BR_ID)) and
    l.STAFF_LOAN_STATUS = 'T'
     
     select LOAN_TYPE_ID as ID, LOAN_TYPE_BASIC_INSTALLEMENT_NO as [Installement No], LOAN_TYPE_MONTH as [Month],
     LOAN_TYPE_YEAR as [Year], LOAN_TYPE_AMOUNT as [Installement Amount], LOAN_TYPE_INSTALLEMENT_STATUS as [Status], LOAN_TYPE_LOAN_ID as [Loan ID]
     
     from LOAN_TYPE
     where
     LOAN_TYPE_STATUS = 'T'
 
     END
 
     END