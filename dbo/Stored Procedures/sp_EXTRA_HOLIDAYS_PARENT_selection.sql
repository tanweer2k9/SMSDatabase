
CREATE procedure  [dbo].[sp_EXTRA_HOLIDAYS_PARENT_selection]
                                               
                                               
     @STATUS char(10),
     @ID  numeric,
     @HD_ID  numeric,
     @BR_ID  numeric
   
   
     AS BEGIN 
   
	declare @from_date date = ''
	

     if @STATUS = 'L'
     BEGIN   
		SELECT ID, [From Date], [To Date], [Description], [Type] FROM VEXTRA_HOLIDAYS_PARENT where [BR ID] = @BR_ID
		
			select t.ID, t.[Employee Code], t.Name,t.Designation,t.[Department Name],'' [Time In],'' [Time Out], '' Date from VTEACHER_INFO t
			
			where [Branch ID] = @BR_ID and t.Status = 'T' and t.[Leaves Type] not in ('No Deduction','Not Generate Salary')
     END  
     ELSE
     BEGIN
			SELECT ID, [From Date], [To Date], [Description], [Type] FROM VEXTRA_HOLIDAYS_PARENT where [BR ID] = @BR_ID
			
			select @from_date = [From Date] from VEXTRA_HOLIDAYS_PARENT where ID = @ID
			select t.ID, t.[Employee Code], t.Name,t.Designation,t.[Department Name],e.[Time In],e.[Time Out],'' Date from VEXTRA_HOLIDAYS_CHILD e
			right join VTEACHER_INFO t on e.[Staff ID] = t.ID
			where [Branch ID] = @BR_ID and t.Status = 'T' and t.[Leaves Type] not in ('No Deduction','Not Generate Salary') and PID = @ID and e.Date = @from_date
			union
			select t.ID, t.[Employee Code], t.Name,t.Designation,t.[Department Name],'' [Time In],'' [Time Out],'' Date from VTEACHER_INFO t
			
			where [Branch ID] = @BR_ID and t.Status = 'T' and t.[Leaves Type] not in ('No Deduction','Not Generate Salary') and ID not in(select [Staff ID] from VEXTRA_HOLIDAYS_CHILD where PID = @ID)
 
			--SELECT ID, [From Date], [To Date], [Description], [Type] FROM VEXTRA_HOLIDAYS_PARENT where ID = @ID
   
 
     END
 
     END