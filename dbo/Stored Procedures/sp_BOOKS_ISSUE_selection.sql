CREATE procedure  [dbo].[sp_BOOKS_ISSUE_selection]
                                               
                                               
     @STATUS char(10),
     @BOOKS_ISSUE_ID  numeric,
     @BOOKS_ISSUE_HD_ID  numeric,
     @BOOKS_ISSUE_BR_ID  numeric,
	 @BOOKS_ISSUE_BORROWER_TYPE nvarchar(50),
	 @BOOKS_ISSUE_BORROWER_ID numeric

   
   
     AS BEGIN 
   
   
     if @STATUS = 'L'
     BEGIN
		
		declare @fine_per_day int = 0
		declare @free_days int = 0


		select @fine_per_day = BR_ADM_BOOK_FINE_PER_DAY, @free_days = BR_ADM_FREE_DAYS from BR_ADMIN where BR_ADM_ID = @BOOKS_ISSUE_BR_ID

		SELECT ID,[Book No],[Book Title],[Date Borrow],[Due Date],CASE WHEN [Returned Date] = '1900-01-01' THEN ' ' ELSE [Returned Date] END AS [Returned Date],[Fine Per Day],
		CASE WHEN [Returned Date] = '1900-01-01' THEN DATEDIFF(DD,[Due Date],GETDATE()) ELSE DATEDIFF(DD,[Due Date],[Returned Date]) END [Delay Days], 
		CASE WHEN [Returned Date] = '1900-01-01' THEN DATEDIFF(DD,[Due Date],GETDATE()) * @fine_per_day ELSE DATEDIFF(DD,[Due Date],[Returned Date]) * @fine_per_day END as [Total Fine],
		 Notes,[Status] FROM VBOOKS_ISSUE where [Borrower ID] = @BOOKS_ISSUE_BORROWER_ID and [Borrower  Type] = @BOOKS_ISSUE_BORROWER_TYPE order by Status,[Date Borrow] DESC
		
		select ID, [Student School ID], [First Name],[Family Code],[Class Plan] from VSTUDENT_INFO where [Institute ID] = @BOOKS_ISSUE_HD_ID and [Branch ID] = @BOOKS_ISSUE_BR_ID and Status = 'T'
		SELECT ID,[Employee Code],Name, Designation,Department,[Contact #],[Employee Type] FROM VTEACHER_INFO where [Institute ID] = @BOOKS_ISSUE_HD_ID and [Branch ID] = @BOOKS_ISSUE_BR_ID and Status = 'T'
		
		Select A.ID,A.[Book No],A.[Book Title],A.Category,A.[Book ISBN],A.[Book Author],A.[Rack No],A.[Shelf No],(A.Quantity - ISNULL( B.[Book Count],0)) Stock from (SELECT * FROM VBOOKS_INFO where [HD ID] = @BOOKS_ISSUE_HD_ID and [BR ID] = @BOOKS_ISSUE_BR_ID and status = 'T')A
		LEFT join (select [Book Info ID], COUNT(*) [Book Count] from VBOOKS_ISSUE where [HD ID] = @BOOKS_ISSUE_HD_ID and [BR ID] = @BOOKS_ISSUE_BR_ID and Status = 'Issued' group by [Book Info ID])B
		On B.[Book Info ID] = A.ID
		select @fine_per_day [Fine Per Day], @free_days [Free Days]

     END  
		
 
     END