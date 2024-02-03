﻿CREATE FUNCTION InitialCap(@String VARCHAR(8000))
                  RETURNS VARCHAR(8000)
                 AS
 BEGIN 

                   DECLARE @Position INT;

SELECT @String   = STUFF(LOWER(@String),1,1,UPPER(LEFT(@String,1))) COLLATE Latin1_General_Bin,
                    @Position = PATINDEX('%[^A-Za-z''][a-z]%',@String COLLATE Latin1_General_Bin);

                    WHILE @Position > 0
                    SELECT @String   = STUFF(@String,@Position,2,UPPER(SUBSTRING(@String,@Position,2))) COLLATE Latin1_General_Bin,
                    @Position = PATINDEX('%[^A-Za-z''][a-z]%',@String COLLATE Latin1_General_Bin);

                     RETURN @String;
  END ;