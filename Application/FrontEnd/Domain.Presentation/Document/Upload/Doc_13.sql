 DECLARE @DATA AS DATETIME,                                                                                                                                           
         @JULDATE_DATA AS INT,                                                                                                                                        
 		@CURRENT AS DATETIME,                                                                                                                                         
 		@JULDATE_CURRENT AS INT,                                                                                                                                      
 		@DATEGENERATE AS DATETIME,                                                                                                                                    
 		@CAPITAL AS DECIMAL(18,2),                                                                                                                                    
 		@GROUPTH AS DECIMAL(18,2),                                                                                                                                    
 		@INDIVIDUALTH AS DECIMAL(18,2),                                                                                                                               
 		@SOETH AS DECIMAL(18,2),                                                                                                                                      
 		@RPTH AS DECIMAL(18,2),                                                                                                                                       
 		@SPOTDATE_PROJECTION DATETIME,                                                                                                                                
 		@HOLCLPT AS INTEGER,                                                                                                                                          
 		@MAXYEAR AS INT,                                                                                                                                              
 		@SUBMAXYEAR AS INT,                                                                                                                                           
 		@COUNTERYEAR AS INT,                                                                                                                                          
 		@DATA_YCRT AS DATETIME,                                                                                                                                       
 		@PREVBRANPRCDATE AS DATETIME                                                                                                                                  
                                                                                                                                                                      
 -------------------------------------------------------PARAMETERS                                                                                                    
                                                                                                                                                                      
 SELECT @DATA = BRANPRCDATE,                                                                                                                                          
        @JULDATE_DATA = DATEDIFF(DAY, '31 DEC 1971', @DATA),                                                                                                          
 	   @CURRENT = BRANPRCDATE,                                                                                                                                        
        @JULDATE_CURRENT = DATEDIFF(DAY, '31 DEC 1971', @CURRENT),                                                                                                    
 	   @SPOTDATE_PROJECTION = DATEADD(DAY, 1, @CURRENT),                                                                                                              
        @HOLCLPT = 1,                                                                                                                                                 
 	   @DATA_YCRT =  PREVBRANPRCDATE                                                                                                                                  
 FROM [OPICSDB1].[OPICS].dbo.BRPS                                                                                                                  
 WHERE BR = 01                                                                                                                                                        
                                                                                                                                                                      
                                                                                                                                                                      
 SELECT TOP 1 @CAPITAL = ROUND(A.NilaiKapital,2)/1000000,                                                                                                             
              @INDIVIDUALTH = ROUND((A.NilaiKapital*B.Value/100.00)/1000000,2),                                                                                       
              @RPTH = ROUND((A.NilaiKapital*C.Value/100.0)/1000000,2),                                                                                                
 	         @GROUPTH = ROUND((A.NilaiKapital*D.Value/100.0)/1000000,2),                                                                                              
 	         @SOETH = ROUND((A.NilaiKapital*E.Value/100.0)/1000000,2)                                                                                                 
 FROM MasterLLLKapital A                                                                                                                                              
                                                                                                                                                                      
 LEFT JOIN MasterLLLParameters B                                                                                                                                      
 ON B.ParameterCode = 'MLL-001'                                                                                                                                       
                                                                                                                                                                      
 LEFT JOIN MasterLLLParameters C                                                                                                                                      
 ON C.ParameterCode = 'MLL-002'                                                                                                                                       
                                                                                                                                                                      
 LEFT JOIN MasterLLLParameters D                                                                                                                                      
 ON D.ParameterCode = 'MLL-003'                                                                                                                                       
                                                                                                                                                                      
 LEFT JOIN MasterLLLParameters E                                                                                                                                      
 ON E.ParameterCode = 'MLL-004'                                                                                                                                       
                                                                                                                                                                      
 WHERE A.IsAktif = '1'                                                                                                                                                
                                                                                                                                                                      
                                                                                                                                                                      
                                                                                                                                                                      
                                                                                                                                                                      
                                                                                                                                                                      
 --CLEAR DATA                                                                                                                                                         
 DELETE MasterLLLParametersScreen                                                                                                                                     
 WHERE TransType = 'INTRA'                                                                                                                                            
                                                                                                                                                                      
                                                                                                                                                                      
 --INSERT DATA                                                                                                                                                        
 SELECT ROUND(A.NilaiKapital,2) Kapital,                                                                                                                              
        ROUND((A.NilaiKapital*B.Value/100.0),2) Individu,                                                                                                             
 	    B.Value IndividuPersen,                                                                                                                                       
        ROUND((A.NilaiKapital*C.Value/100.0),2) RelatedParty,                                                                                                         
 	    C.Value RelatedPartyPersen,                                                                                                                                   
 	    ROUND((A.NilaiKapital*D.Value/100.0),2) [Group],                                                                                                              
 	    D.Value GroupPersen,                                                                                                                                          
 	    ROUND((A.NilaiKapital*E.Value/100.0),2) SOE,                                                                                                                  
 	    E.Value SOEPersen                                                                                                                                             
 INTO #TEMP_PARAMETER                                                                                                                                                 
 FROM MasterLLLKapital A                                                                                                                                              
                                                                                                                                                                      
 LEFT JOIN MasterLLLParameters B                                                                                                                                      
 ON B.ParameterCode = 'MLL-001'                                                                                                                                       
                                                                                                                                                                      
 LEFT JOIN MasterLLLParameters C                                                                                                                                      
 ON C.ParameterCode = 'MLL-002'                                                                                                                                       
                                                                                                                                                                      
 LEFT JOIN MasterLLLParameters D                                                                                                                                      
 ON D.ParameterCode = 'MLL-003'                                                                                                                                       
                                                                                                                                                                      
 LEFT JOIN MasterLLLParameters E                                                                                                                                      
 ON E.ParameterCode = 'MLL-004'                                                                                                                                       
                                                                                                                                                                      
 WHERE A.IsAktif = '1'                                                                                                                                                
                                                                                                                                                                      
 INSERT INTO MasterLLLParametersScreen(TransType, ParIndex, ParameterName, Persen, Nilai)                                                                             
 SELECT 'INTRA',                                                                                                                                                      
 	   ParIndex,                                                                                                                                                      
 	   ParameterName,                                                                                                                                                 
 	   Persen,                                                                                                                                                        
 	   Nilai                                                                                                                                                          
 FROM                                                                                                                                                                 
 (                                                                                                                                                                    
 	SELECT 1 ParIndex,                                                                                                                                                
 		   'Capital' ParameterName,                                                                                                                                   
 		   '-' Persen,                                                                                                                                                
 		   Kapital Nilai                                                                                                                                              
 	FROM #TEMP_PARAMETER                                                                                                                                              
 	UNION ALL                                                                                                                                                         
 	SELECT 2 ParIndex,                                                                                                                                                
 		   'Individual' ParameterName,                                                                                                                                
 		   IndividuPersen,                                                                                                                                            
 		   Individu                                                                                                                                                   
 	FROM #TEMP_PARAMETER                                                                                                                                              
 	UNION ALL                                                                                                                                                         
 	SELECT 3 ParIndex,                                                                                                                                                
 		   'Related Party' ParameterName,                                                                                                                             
 		   RelatedPartyPersen,                                                                                                                                        
 		   RelatedParty                                                                                                                                               
 	FROM #TEMP_PARAMETER                                                                                                                                              
 	UNION ALL                                                                                                                                                         
 	SELECT 4 ParIndex,                                                                                                                                                
 		   'Group' ParameterName,                                                                                                                                     
 		   GroupPersen,                                                                                                                                               
 		   [Group]                                                                                                                                                    
 	FROM #TEMP_PARAMETER                                                                                                                                              
 	UNION ALL                                                                                                                                                         
 	SELECT 5 ParIndex,                                                                                                                                                
 		   'SOE' ParameterName,                                                                                                                                       
 		   SOEPersen,                                                                                                                                                 
 		   SOE                                                                                                                                                        
 	FROM #TEMP_PARAMETER                                                                                                                                              
 )A                                                                                                                                                                   
 ORDER BY A.ParIndex                                                                                                                                                  
                                                                                                                                                                      
                                                                                                                                                                      
                                                                                                                                                                      
 -------------------------------------------------------TEMPORARY CURRENCY                                                                                            
                                                                                                                                                                      
 DELETE TrxLLLTempCurrencyScreen                                                                                                                                      
 WHERE TransType = 'INTRA';                                                                                                                                           
                                                                                                                                                                      
 DELETE TrxLLLTempCurrencySimulation                                                                                                                                  
 WHERE TransType = 'INTRA';                                                                                                                                           
                                                                                                                                                                      
                                                                                                                                                                      
                                                                                                                                                                      
 INSERT INTO TrxLLLTempCurrencyScreen(ExecutionDate, TransType, CCY, Rate, CalcRule)                                                                                  
 SELECT GETDATE(),                                                                                                                                                    
        'INTRA',                                                                                                                                                      
 	   A.CCY,                                                                                                                                                         
        A.SPOTRATE_8,                                                                                                                                                 
 	   B.A6NBDP                                                                                                                                                       
                                                                                                                                                                      
 FROM [OPICSDB1].[OPICS].dbo.REVP A                                                                                                                
                                                                                                                                                                      
 LEFT JOIN [IBMDA400LIVE].[S849BD8W].[SIDMLIB].SDCURRPD B                                                                                                   
 ON A.CCY = B.A6CYCD COLLATE SQL_Latin1_General_CP1_CI_AS;                                                                                                            
                                                                                                                                                                      
                                                                                                                                                                      
                                                                                                                                                                      
 INSERT INTO TrxLLLTempCurrencySimulation(ExecutionDate, TransType, CCY, Rate, CalcRule)                                                                              
 SELECT A.ExecutionDate,                                                                                                                                              
 	   A.TransType,                                                                                                                                                   
 	   A.CCY,                                                                                                                                                         
 	   A.Rate,                                                                                                                                                        
 	   A.CalcRule                                                                                                                                                     
 FROM TrxLLLTempCurrencyScreen A                                                                                                                                      
 WHERE TransType = 'INTRA';                                                                                                                                           
                                                                                                                                                                      
                                                                                                                                                                      
                                                                                                                                                                      
 IF OBJECT_ID('TEMP_HLDY_FX', 'U') IS NOT NULL                                                                                                                        
 	DROP TABLE TEMP_HLDY_FX;                                                                                                                                          
                                                                                                                                                                      
 SELECT CALENDARID, HOLIDATE                                                                                                                                          
 INTO TEMP_HLDY_FX                                                                                                                                                    
 FROM [OPICSDB1].[OPICS].dbo.HLDY                                                                                                                  
 WHERE HOLIDATE BETWEEN @DATA AND DATEADD(YEAR, 10, @DATA);                                                                                                           
                                                                                                                                                                      
                                                                                                                                                                      
 -------------------------------------------------------CLEAR DATA                                                                                                    
                                                                                                                                                                      
 --CLEAN DATA                                                                                                                                                         
 DELETE TrxLLLLN                                                                                                                                                      
 WHERE Tanggal = DAY(@CURRENT)                                                                                                                                        
   AND Bulan = MONTH(@CURRENT)                                                                                                                                        
   AND Tahun = YEAR(@CURRENT)                                                                                                                                         
   AND TransType IN ('TRANS', 'VALUE')                                                                                                                                
                                                                                                                                                                      
 DELETE TrxLLLBG                                                                                                                                                      
 WHERE Tanggal = DAY(@CURRENT)                                                                                                                                        
   AND Bulan = MONTH(@CURRENT)                                                                                                                                        
   AND Tahun = YEAR(@CURRENT)                                                                                                                                         
   AND TransType IN ('TRANS', 'VALUE')                                                                                                                                
                                                                                                                                                                      
 DELETE TrxLLLLC                                                                                                                                                      
 WHERE Tanggal = DAY(@CURRENT)                                                                                                                                        
   AND Bulan = MONTH(@CURRENT)                                                                                                                                        
   AND Tahun = YEAR(@CURRENT)                                                                                                                                         
   AND TransType IN ('TRANS', 'VALUE')                                                                                                                                
                                                                                                                                                                      
 DELETE TrxLLLFX                                                                                                                                                      
 WHERE Tanggal = DAY(@CURRENT)                                                                                                                                        
   AND Bulan = MONTH(@CURRENT)                                                                                                                                        
   AND Tahun = YEAR(@CURRENT)                                                                                                                                         
   AND TransType IN ('TRANS', 'VALUE')                                                                                                                                
                                                                                                                                                                      
 DELETE TrxLLLMTMDRTV                                                                                                                                                 
 WHERE Tanggal = DAY(@CURRENT)                                                                                                                                        
   AND Bulan = MONTH(@CURRENT)                                                                                                                                        
   AND Tahun = YEAR(@CURRENT)                                                                                                                                         
   AND TransType IN ('TRANS', 'VALUE')                                                                                                                                
                                                                                                                                                                      
 DELETE TrxLLLNotionalDRTV                                                                                                                                            
 WHERE Tanggal = DAY(@CURRENT)                                                                                                                                        
   AND Bulan = MONTH(@CURRENT)                                                                                                                                        
   AND Tahun = YEAR(@CURRENT)                                                                                                                                         
   AND TransType IN ('TRANS', 'VALUE')                                                                                                                                
                                                                                                                                                                      
 DELETE TrxLLLInterbank                                                                                                                                               
 WHERE Tanggal = DAY(@CURRENT)                                                                                                                                        
   AND Bulan = MONTH(@CURRENT)                                                                                                                                        
   AND Tahun = YEAR(@CURRENT)                                                                                                                                         
   AND TransType IN ('TRANS', 'VALUE')                                                                                                                                
                                                                                                                                                                      
 DELETE TrxLLLSBLCBG                                                                                                                                                  
 WHERE Tanggal = DAY(@CURRENT)                                                                                                                                        
   AND Bulan = MONTH(@CURRENT)                                                                                                                                        
   AND Tahun = YEAR(@CURRENT)                                                                                                                                         
   AND TransType IN ('TRANS', 'VALUE')                                                                                                                                
                                                                                                                                                                      
 DELETE TrxLLLSBLCLN                                                                                                                                                  
 WHERE Tanggal = DAY(@CURRENT)                                                                                                                                        
   AND Bulan = MONTH(@CURRENT)                                                                                                                                        
   AND Tahun = YEAR(@CURRENT)                                                                                                                                         
   AND TransType IN ('TRANS', 'VALUE')                                                                                                                                
                                                                                                                                                                      
 DELETE TrxLLLPLEDGETD                                                                                                                                                
 WHERE Tanggal = DAY(@CURRENT)                                                                                                                                        
   AND Bulan = MONTH(@CURRENT)                                                                                                                                        
   AND Tahun = YEAR(@CURRENT)                                                                                                                                         
   AND TransType IN ('TRANS', 'VALUE')                                                                                                                                
                                                                                                                                                                      
 DELETE TrxLLLPLEDGETDSummary                                                                                                                                         
 WHERE Tanggal = DAY(@CURRENT)                                                                                                                                        
 AND Bulan = MONTH(@CURRENT)                                                                                                                                          
 AND Tahun = YEAR(@CURRENT)                                                                                                                                           
 AND TransType IN ('TRANS', 'VALUE')                                                                                                                                  
                                                                                                                                                                      
                                                                                                                                                                      
 -------------------------------------------------------A. OS LN     
 
 --start Hendry (find reporting date)
 DECLARE @tempHolidayTable TABLE
(
RowNumber numeric(10), 
HolidayDate datetime
) 

insert into @tempHolidayTable
select ROW_NUMBER() OVER (ORDER BY holidaydate ASC),HolidayDate from MasterNationalHoliday 
where holidaydate >= @CURRENT+1 and CCY = 'IDR'
order by holidaydate asc

DECLARE @MaxRowCount int,
@RowNumber int,
@DayAdded int

SELECT @MaxRowCount=MAX(RowNumber) FROM @tempHolidayTable
SET @RowNumber=1
SET @DayAdded=0

WHILE @RowNumber<=@MaxRowCount
BEGIN
	
	if @CURRENT + @RowNumber <> (select HolidayDate from @tempHolidayTable where RowNumber=@RowNumber)
	BEGIN
		break
	END

	SET @DayAdded=(@DayAdded+1)
	SET @RowNumber=(@RowNumber+1)
END

DECLARE @CHECKDATE AS DATETIME

SET @CHECKDATE = @CURRENT+@DayAdded

IF DATENAME(weekday, @CHECKDATE) = 'Friday'
BEGIN
	--IF DATENAME(MONTH, @CHECKDATE) = DATENAME(MONTH, @CHECKDATE+1)
	--AND DATENAME(MONTH, @CHECKDATE) = DATENAME(MONTH, @CHECKDATE+2)
	--AND DATENAME(MONTH, @CHECKDATE) = DATENAME(MONTH, @CHECKDATE+3)
	--BEGIN
	--	SET @CHECKDATE=@CHECKDATE+2
	--END

	IF DATENAME(MONTH, @CHECKDATE) <> DATENAME(MONTH, @CHECKDATE+1)
	BEGIN
		SET @CHECKDATE=@CHECKDATE
	END
	ELSE IF DATENAME(MONTH, @CHECKDATE) <> DATENAME(MONTH, @CHECKDATE+2)
	BEGIN
		SET @CHECKDATE=@CHECKDATE+1
	END
	ELSE IF DATENAME(MONTH, @CHECKDATE) <> DATENAME(MONTH, @CHECKDATE+3)
	BEGIN
		SET @CHECKDATE=@CHECKDATE+2
	END
	ELSE
	BEGIN
		SET @CHECKDATE=@CHECKDATE+2
	END
	
END

delete from @tempHolidayTable

insert into @tempHolidayTable
select ROW_NUMBER() OVER (ORDER BY holidaydate ASC),HolidayDate from MasterNationalHoliday 
where holidaydate >= @CHECKDATE and CCY = 'IDR'
order by holidaydate asc

SELECT @MaxRowCount=MAX(RowNumber) FROM @tempHolidayTable
SET @RowNumber=1
SET @DayAdded=0

WHILE @RowNumber<=@MaxRowCount
BEGIN
	
	if @CHECKDATE + @RowNumber <> (select HolidayDate from @tempHolidayTable where RowNumber=@RowNumber)
	BEGIN
		break
	END

	SET @DayAdded=(@DayAdded+1)
	SET @RowNumber=(@RowNumber+1)
END

select @CHECKDATE+@DayAdded

IF DATENAME(weekday, @CHECKDATE) = 'Friday'
BEGIN

	IF DATENAME(MONTH, @CHECKDATE) <> DATENAME(MONTH, @CHECKDATE+1)
	BEGIN
		SET @CHECKDATE=@CHECKDATE
	END
	ELSE IF DATENAME(MONTH, @CHECKDATE) <> DATENAME(MONTH, @CHECKDATE+2)
	BEGIN
		SET @CHECKDATE=@CHECKDATE+1
	END
	ELSE IF DATENAME(MONTH, @CHECKDATE) <> DATENAME(MONTH, @CHECKDATE+3)
	BEGIN
		SET @CHECKDATE=@CHECKDATE+2
	END
	ELSE
	BEGIN
		SET @CHECKDATE=@CHECKDATE+2
	END
	
END
--end Hendry (find reporting date)                                                                                                 
                                                                                                                                                                      
 --GET LOAN BY TRANSACTIONDATE EDITED BY VINCENT 26-10-2018 TO ADD A.TreasuryApprovedBy   
 
 --OLD QUERY                                                                            
 --SELECT CONVERT(INT, ISNULL(D.CustomerIDTo, a.CustomerID)) CustomerID,                                                                                                
 --       RANK() OVER(PARTITION BY CustomerID, FirstReffNo  ORDER BY CASE WHEN A.LNRemarkID in ('PRE') THEN A.NewInterestDueDate                                        
 --															WHEN A.LNRemarkID in ('REP') and ISNULL(CombineLoanStatus,'') <> '1'                                      
 --																		then a.NewInterestDueDate                                                                     
 --															WHEN A.LNRemarkID in ('RRP','PPE') THEN A.NewInterestValueDate                                            
 --															WHEN A.LNRemarkID in ('PAR') THEN A.NewPrincipalValueDate                                                 
 --															ELSE A.TransactionDate END desc,A.TransNo desc) RankLoanEvent,                                            
 	                                                                                                                                                                  
 --       ROW_NUMBER() OVER(PARTITION BY CustomerID, FirstReffNo, CASE WHEN a.lnremarkid in ('NEW', 'R/O', 'RPA', 'REV', 'RRA') THEN 
	--															CASE WHEN TreasuryApprovedBy IS NOT NULL THEN 'Y' ELSE 'N' END
	--															ELSE                                                          
	--															CASE WHEN LADApprovedByDateIn  IS NOT NULL THEN 'Y' ELSE 'N' END                                                                             
 --															   END                                                                                                    
 --															   ORDER BY CASE WHEN A.LNRemarkID in ('PRE')                                                             
 --	                                                                                            THEN A.NewInterestDueDate                                             
 --															   WHEN A.LNRemarkID in ('REP') and ISNULL(CombineLoanStatus,'') <> '1'                                   
 --															   			then a.NewInterestDueDate                                                                     
 --															   WHEN A.LNRemarkID in ('RRP','PPE') THEN A.NewInterestValueDate                                         
 --															   WHEN A.LNRemarkID in ('PAR') THEN A.NewPrincipalValueDate                                              
 --															   ELSE A.TransactionDate END desc,A.TransNo desc)                                                        
 --															   RankLoanEventByValDate,                                                                                
 --	   A.TransactionDate,                                                                                                                                             
 --	   A.TransNo,                                                                                                                                                     
 --	   A.FirstReffNo,                                                                                                                                                 
 --	   A.LADApprovedByDateIn,                                                                                                                                         
 --	   A.TreasuryApprovedBy,                                                                                                                                          
 --	   A.LNRemarkID,                                                                                                                                                  
 --	   C.lnremarkname,                                                                                                                                                
 --	   A.WITHDRAWNCURRENCY,                                                                                                                                           
 --	   A.DefaultAmount,                                                                                                                                               
 --	   A.Amount OriginalAmount,                                                                                                                                       
 --	   A.Amount*B.Rate Amount,                                                                                                                                        
 --	   A.NewPrincipalValueDate,                                                                                                                                       
 --	   A.NewPrincipalMaturedDate,                                                                                                                                     
 --	   A.NewInterestDueDate,                                                                                                                                          
 --	   A.NewInterestValueDate,                                                                                                                                        
 --	   CASE WHEN A.LNRemarkID in ('PRE') THEN A.NewInterestDueDate                                                                                                    
 --			WHEN A.LNRemarkID in ('REP') and ISNULL(CombineLoanStatus,'') <> '1'                                                                                      
 --						then a.NewInterestDueDate                                                                                                                     
 --			WHEN A.LNRemarkID in ('RRP','PPE') THEN A.NewInterestValueDate                                                                                            
 --			WHEN A.LNRemarkID in ('PAR') THEN A.NewPrincipalValueDate                                                                                                 
 --		    ELSE A.TransactionDate                                                                                                                                    
 --	   END LLLValueDate                                                                                                                                               
 --INTO #TEMP_LN_TRANS                                                                                                                                                  
 --FROM  [ERPLIVE].[BMIERP].dbo.TrxFundingConfirmation  a                                                                                                      
                                                                                                                                                                      
 --LEFT JOIN TrxLLLTempCurrencyScreen B                                                                                                                                 
 --ON A.WITHDRAWNCURRENCY = B.CCY AND B.TransType = 'INTRA'                                                                                                             
                                                                                                                                                                      
 --LEFT JOIN [ERPLIVE].[BMIERP].dbo.masterlnremark C                                                                                                           
 --ON A.LNRemarkID = C.lnremarkid                                                                                                                                       
                                                                                                                                                                      
 --LEFT JOIN MasterExceptionCustomerLLL D                                                                                                                               
 --ON CONVERT(INT, a.CustomerID) = CONVERT(INT, D.CustomerIDFrom)                                                                                                       
                                                                                                                                                                      
 --WHERE A.Flag='0'                                                                                                                                                     
 --	AND ISNULL(a.FirstReffNo,'') <>''                                                                                                                                 
 --	AND LNApprovedBy is not null                                                                                                                                      
 --	AND CASE WHEN A.LNRemarkID in ('PRE') THEN A.NewInterestDueDate                                                                                                   
 --	        WHEN A.LNRemarkID in ('REP') and ISNULL(CombineLoanStatus,'') <> '1' THEN A.NewInterestDueDate                                                            
 --			WHEN A.LNRemarkID in ('RRP','PPE') THEN A.NewInterestValueDate                                                                                            
 --			WHEN A.LNRemarkID in ('PAR') THEN A.NewPrincipalValueDate                                                                                                 
 --			ELSE A.TransactionDate                                                                                                                                    
 --		END <= @CURRENT                                                                                                                                               
                                                                                                                                                                      
 --	AND CASE WHEN A.LNRemarkID in ('PRE','REP') THEN @CURRENT                                                                                                         
 --			ELSE A.NewPrincipalMaturedDate                                                                                                                            
 --		END >= @CURRENT                                                                                                                                               
                                                                                                                                                                      
 --ORDER BY CASE WHEN A.LNRemarkID in ('PRE') THEN A.NewInterestDueDate                                                                                                 
 --           	WHEN A.LNRemarkID in ('REP') and ISNULL(CombineLoanStatus,'') <> '1' then a.NewInterestDueDate                                                        
 --           	WHEN A.LNRemarkID in ('RRP','PPE') THEN A.NewInterestValueDate                                                                                        
 --           	WHEN A.LNRemarkID in ('PAR') THEN A.NewPrincipalValueDate                                                                                             
 --           	ELSE A.TransactionDate END desc,A.TransNo desc;   
 
 --NEW QUERY HENDRY
 SELECT CONVERT(INT, ISNULL(D.CustomerIDTo, a.CustomerID)) CustomerID,                                                                                                
        RANK() OVER(PARTITION BY CustomerID, FirstReffNo  ORDER BY CASE WHEN A.LNRemarkID in ('PRE') THEN A.NewInterestDueDate                                        
 															WHEN A.LNRemarkID in ('REP') and ISNULL(CombineLoanStatus,'') <> '1'                                      
 																		then a.NewInterestDueDate                                                                     
 															WHEN A.LNRemarkID in ('RRP','PPE') THEN A.NewInterestValueDate                                            
 															WHEN A.LNRemarkID in ('PAR') THEN A.NewPrincipalValueDate                                                 
 															ELSE A.TransactionDate END desc,A.TransNo desc) RankLoanEvent,                                            
 	                                                                                                                                                                  
        ROW_NUMBER() OVER(PARTITION BY CustomerID, FirstReffNo, CASE WHEN a.lnremarkid in ('NEW', 'R/O', 'RPA', 'REV', 'RRA') THEN 
																CASE WHEN TreasuryApprovedBy IS NOT NULL THEN 'Y' ELSE 'N' END
																ELSE                                                          
																CASE WHEN LADApprovedByDateIn  IS NOT NULL THEN 'Y' ELSE 'N' END                                                                             
 															   END                                                                                                    
 															   ORDER BY CASE WHEN A.LNRemarkID in ('PRE')                                                             
 	                                                                                            THEN A.NewInterestDueDate                                             
 															   WHEN A.LNRemarkID in ('REP') and ISNULL(CombineLoanStatus,'') <> '1'                                   
 															   			then a.NewInterestDueDate                                                                     
 															   WHEN A.LNRemarkID in ('RRP','PPE') THEN A.NewInterestValueDate                                         
 															   WHEN A.LNRemarkID in ('PAR') THEN A.NewPrincipalValueDate                                              
 															   ELSE A.TransactionDate END desc,A.TransNo desc)                                                        
 															   RankLoanEventByValDate,                                                                                
 	   A.TransactionDate,                                                                                                                                             
 	   A.TransNo,                                                                                                                                                     
 	   A.FirstReffNo,                                                                                                                                                 
 	   A.LADApprovedByDateIn,                                                                                                                                         
 	   A.TreasuryApprovedBy,                                                                                                                                          
 	   A.LNRemarkID,                                                                                                                                                  
 	   C.lnremarkname,                                                                                                                                                
 	   A.WITHDRAWNCURRENCY,                                                                                                                                           
 	   A.DefaultAmount,                                                                                                                                               
 	   A.Amount OriginalAmount,
	   case when E.CU = 'Committed' then (A.Amount*B.Rate) --drawdown amount
			+ ( (cast(DATEDIFF(day,A.TransactionDate,@CHECKDATE) as float) / cast(360 as float)) --@CHECKDATE = Reporting Date, A.TransactionDate = Value Date
				* (A.Amount*B.Rate) --drawdown amount
					* (A.CustomerRate/100) ) --interest rate 
					+ ( (ISNULL(E.AMT,0) - ISNULL(G.TotalDD,0)) --unused amount
						* case when DATEDIFF(day,@CHECKDATE,E.AvailabilityPeriodTo) < 366 then (20/100) else (50/100) end ) --FKK
		else (A.Amount*B.Rate) --drawdown amount
			+ ( (cast(DATEDIFF(day,A.TransactionDate,@CHECKDATE) as float) / cast(360 as float)) --@CHECKDATE = Reporting Date, A.TransactionDate = Value Date
				* (A.Amount*B.Rate) --drawdown amount
					* (A.CustomerRate/100) ) --interest rate
						end as Amount,                                                                                                                                 
 	   --A.Amount*B.Rate Amount,                                                                                                                                        
 	   A.NewPrincipalValueDate,                                                                                                                                       
 	   A.NewPrincipalMaturedDate,                                                                                                                                     
 	   A.NewInterestDueDate,                                                                                                                                          
 	   A.NewInterestValueDate,                                                                                                                                        
 	   CASE WHEN A.LNRemarkID in ('PRE') THEN A.NewInterestDueDate                                                                                                    
 			WHEN A.LNRemarkID in ('REP') and ISNULL(CombineLoanStatus,'') <> '1'                                                                                      
 						then a.NewInterestDueDate                                                                                                                     
 			WHEN A.LNRemarkID in ('RRP','PPE') THEN A.NewInterestValueDate                                                                                            
 			WHEN A.LNRemarkID in ('PAR') THEN A.NewPrincipalValueDate                                                                                                 
 		    ELSE A.TransactionDate                                                                                                                                    
 	   END LLLValueDate                                                                                                                                               
 INTO #TEMP_LN_TRANS                                                                                                                                                  
 FROM  [ERPLIVE].[BMIERP].dbo.TrxFundingConfirmation  a                                                                                                      
                                                                                                                                                                      
 LEFT JOIN TrxLLLTempCurrencyScreen B                                                                                                                                 
 ON A.WITHDRAWNCURRENCY = B.CCY AND B.TransType = 'INTRA'                                                                                                             
                                                                                                                                                                      
 LEFT JOIN [ERPLIVE].[BMIERP].dbo.masterlnremark C                                                                                                           
 ON A.LNRemarkID = C.lnremarkid                                                                                                                                       
                                                                                                                                                                      
 LEFT JOIN MasterExceptionCustomerLLL D                                                                                                                               
 ON CONVERT(INT, a.CustomerID) = CONVERT(INT, D.CustomerIDFrom)          
 
 LEFT JOIN (select distinct (AMT*RATE) as AMT,case when CU like '%Uncommitted%' then 'Uncommitted' else CU end as CU,CANUMCDM,[03C-14],CUSTACNUM,AvailabilityPeriodTo from T_FacilityMaster a
		LEFT JOIN TrxLLLTempCurrencyScreen B                                                                                                                                 
		ON A.CCY = B.CCY AND B.TransType = 'INTRA' 
		where Flag=0 and TYPETXN='LOAN'
 ) E ON A.CANO1 = E.CANUMCDM --> find limit per-CA
	AND A.AgreementNo1 = E.[03C-14] 
	AND A.CustomerID = E.CUSTACNUM
 LEFT JOIN (
 Select CANO1,sum(DD) AS totalDD from(
	Select CANO1,FirstReffNo,DD,TransDate from(
	   SELECT                                                                  
 	   distinct CANO1,FirstReffNo,A.Amount*Rate AS DD,TransactionDate,TransDate = MAX(A.TransactionDate) OVER (PARTITION BY FirstReffNo)                                                                                                                                           
	   FROM  TrxFundingConfirmation  a                                                                                                                                                                                                                                                   
	   LEFT JOIN TrxLLLTempCurrencyScreen B                                                                                                                                 
	   ON A.WITHDRAWNCURRENCY = B.CCY AND B.TransType = 'INTRA'
	   WHERE A.Flag='0'                                                                                                                                                     
 	   AND ISNULL(a.FirstReffNo,'') <>''                                                                                                                                 
 	   AND LNApprovedBy is not null                                                                                                                                      
 	   AND CASE WHEN A.LNRemarkID in ('PRE') THEN A.NewInterestDueDate                                                                                                   
 			WHEN A.LNRemarkID in ('REP') and ISNULL(CombineLoanStatus,'') <> '1' THEN A.NewInterestDueDate                                                            
 			WHEN A.LNRemarkID in ('RRP','PPE') THEN A.NewInterestValueDate                                                                                            
 			WHEN A.LNRemarkID in ('PAR') THEN A.NewPrincipalValueDate                                                                                                 
 			ELSE A.TransactionDate                                                                                                                                    
 		END <= @CURRENT                                                                                                                                                            
 	  AND CASE WHEN A.LNRemarkID in ('PRE','REP') THEN @CURRENT                                                                                                         
 			ELSE A.NewPrincipalMaturedDate                                                                                                                            
 		END >= @CURRENT     
	  AND LNRemarkID not in ('PRE','REP')  
	) MaxDate where TransactionDate=TransDate	                                                                                                                                   
  ) A
	group by CANo1
 ) G ON E.CANUMCDM=G.CANo1 --> find total outstanding per-CA
 WHERE A.Flag='0'                                                                                                                                                     
 	AND ISNULL(a.FirstReffNo,'') <>''                                                                                                                                 
 	AND LNApprovedBy is not null                                                                                                                                      
 	AND CASE WHEN A.LNRemarkID in ('PRE') THEN A.NewInterestDueDate                                                                                                   
 	        WHEN A.LNRemarkID in ('REP') and ISNULL(CombineLoanStatus,'') <> '1' THEN A.NewInterestDueDate                                                            
 			WHEN A.LNRemarkID in ('RRP','PPE') THEN A.NewInterestValueDate                                                                                            
 			WHEN A.LNRemarkID in ('PAR') THEN A.NewPrincipalValueDate                                                                                                 
 			ELSE A.TransactionDate                                                                                                                                    
 		END <= @CURRENT                                                                                                                                               
                                                                                                                                                                      
 	AND CASE WHEN A.LNRemarkID in ('PRE','REP') THEN @CURRENT                                                                                                         
 			ELSE A.NewPrincipalMaturedDate                                                                                                                            
 		END >= @CURRENT                                                                                                                                               
                                                                                                                                                                      
 ORDER BY CASE WHEN A.LNRemarkID in ('PRE') THEN A.NewInterestDueDate                                                                                                 
            	WHEN A.LNRemarkID in ('REP') and ISNULL(CombineLoanStatus,'') <> '1' then a.NewInterestDueDate                                                        
            	WHEN A.LNRemarkID in ('RRP','PPE') THEN A.NewInterestValueDate                                                                                        
            	WHEN A.LNRemarkID in ('PAR') THEN A.NewPrincipalValueDate                                                                                             
            	ELSE A.TransactionDate END desc,A.TransNo desc;                                                                                                    
                                                                                                                                                                      
                                                                                                                                                                      
 --GET LOAN BY VALUEDATE  EDITED BY VINCENT 26-10-2018 TO ADD A.TreasuryApprovedBy    
 
 --OLD QUERY                                                                                
 --SELECT CONVERT(INT, ISNULL(D.CustomerIDTo, a.CustomerID)) CustomerID,                                                                                                
 --       RANK() OVER(PARTITION BY CustomerID, FirstReffNo  ORDER BY CASE WHEN A.LNRemarkID in ('PRE') THEN A.NewInterestDueDate                                        
 --															WHEN A.LNRemarkID in ('REP') then a.NewInterestDueDate                                                    
 --															WHEN A.LNRemarkID in ('RRP','PPE', 'RRA', 'REV') THEN A.NewInterestValueDate                              
 --															WHEN A.LNRemarkID in ('PAR') THEN A.NewPrincipalValueDate                                                 
 --															ELSE A.TransactionDate END desc,A.TransNo desc) RankLoanEvent,                                            
 	                                                                                                                                                                  
 --       ROW_NUMBER() OVER(PARTITION BY CustomerID, FirstReffNo, CASE WHEN a.lnremarkid in ('NEW', 'R/O', 'RPA', 'REV', 'RRA') THEN 
	--															CASE WHEN TreasuryApprovedBy IS NOT NULL THEN 'Y' ELSE 'N' END
	--															ELSE                                                          
	--															CASE WHEN LADApprovedByDateIn  IS NOT NULL THEN 'Y' ELSE 'N' END                                                                                
 --															   END                                                                                                    
 --															   ORDER BY CASE WHEN A.LNRemarkID in ('PRE')                                                             
 --	                                                                                            THEN A.NewInterestDueDate                                             
 --															   WHEN A.LNRemarkID in ('REP') THEN a.NewInterestDueDate                                                 
 --															   WHEN A.LNRemarkID in ('RRP','PPE', 'RRA', 'REV') THEN A.NewInterestValueDate                           
 --															   WHEN A.LNRemarkID in ('PAR') THEN A.NewPrincipalValueDate                                              
 --															   ELSE A.TransactionDate END desc,A.TransNo desc)                                                        
 --															   RankLoanEventByValDate,                                                                                
 --	   A.TransactionDate,                                                                                                                                             
 --	   A.TransNo,                                                                                                                                                     
 --	   A.FirstReffNo,                                                                                                                                                 
 --	   A.LADApprovedByDateIn,                                                                                                                                         
 --	   A.TreasuryApprovedBy,                                                                                                                                          
 --	   A.LNRemarkID,                                                                                                                                                  
 --	   C.lnremarkname,                                                                                                                                                
 --	   A.WITHDRAWNCURRENCY,                                                                                                                                           
 --	   A.DefaultAmount,                                                                                                                                               
 --	   A.Amount OriginalAmount,                                                                                                                                       
 --	   A.Amount*B.Rate Amount,                                                                                                                                        
 --	   A.NewPrincipalValueDate,                                                                                                                                       
 --	   A.NewPrincipalMaturedDate,                                                                                                                                     
 --	   A.NewInterestDueDate,                                                                                                                                          
 --	   A.NewInterestValueDate                                                                                                                                         
 --INTO #TEMP_LN_VALUE                                                                                                                                                  
 --FROM  [ERPLIVE].[BMIERP].dbo.TrxFundingConfirmation  a                                                                                                      
                                                                                                                                                                      
 --LEFT JOIN TrxLLLTempCurrencyScreen B                                                                                                                                 
 --ON A.WITHDRAWNCURRENCY = B.CCY AND B.TransType = 'INTRA'                                                                                                             
                                                                                                                                                                      
 --LEFT JOIN [ERPLIVE].[BMIERP].dbo.masterlnremark C                                                                                                           
 --ON A.LNRemarkID = C.lnremarkid                                                                                                                                       
                                                                                                                                                                      
 --LEFT JOIN MasterExceptionCustomerLLL D                                                                                                                               
 --ON CONVERT(INT, a.CustomerID) = CONVERT(INT, D.CustomerIDFrom)                                                                                                       
                                                                                                                                                                      
 --WHERE A.Flag='0'                                                                                                                                                     
 --	AND ISNULL(a.FirstReffNo,'') <>''                                                                                                                                 
 --	AND LNApprovedBy is not null                                                                                                                                      
 --	AND CASE WHEN A.LNRemarkID in ('PRE') THEN A.NewInterestDueDate                                                                                                   
 --	        WHEN A.LNRemarkID in ('REP') THEN A.NewInterestDueDate                                                                                                    
 --			WHEN A.LNRemarkID in ('RRP','PPE', 'RRA', 'REV') THEN A.NewInterestValueDate                                                                              
 --			WHEN A.LNRemarkID in ('PAR') THEN A.NewPrincipalValueDate                                                                                                 
 --			ELSE A.NewPrincipalValueDate                                                                                                                              
 --		END <= @CURRENT                                                                                                                                               
                                                                                                                                                                      
 --	AND CASE WHEN A.LNRemarkID in ('PRE','REP') THEN @CURRENT                                                                                                         
 --			ELSE A.NewPrincipalMaturedDate                                                                                                                            
 --		END >= @CURRENT                                                                                                                                               
                                                                                                                                                                      
 --ORDER BY CASE WHEN A.LNRemarkID in ('PRE') THEN A.NewInterestDueDate                                                                                                 
 --           	WHEN A.LNRemarkID in ('REP') then a.NewInterestDueDate                                                                                                
 --           	WHEN A.LNRemarkID in ('RRP','PPE', 'RRA', 'REV') THEN A.NewInterestValueDate                                                                          
 --           	WHEN A.LNRemarkID in ('PAR') THEN A.NewPrincipalValueDate                                                                                             
 --           	ELSE A.TransactionDate END desc,A.TransNo desc;            
 
 --NEW QUERY HENDRY
 SELECT CONVERT(INT, ISNULL(D.CustomerIDTo, a.CustomerID)) CustomerID,                                                                                                
        RANK() OVER(PARTITION BY CustomerID, FirstReffNo  ORDER BY CASE WHEN A.LNRemarkID in ('PRE') THEN A.NewInterestDueDate                                        
 															WHEN A.LNRemarkID in ('REP') then a.NewInterestDueDate                                                    
 															WHEN A.LNRemarkID in ('RRP','PPE', 'RRA', 'REV') THEN A.NewInterestValueDate                              
 															WHEN A.LNRemarkID in ('PAR') THEN A.NewPrincipalValueDate                                                 
 															ELSE A.TransactionDate END desc,A.TransNo desc) RankLoanEvent,                                            
 	                                                                                                                                                                  
        ROW_NUMBER() OVER(PARTITION BY CustomerID, FirstReffNo, CASE WHEN a.lnremarkid in ('NEW', 'R/O', 'RPA', 'REV', 'RRA') THEN 
																CASE WHEN TreasuryApprovedBy IS NOT NULL THEN 'Y' ELSE 'N' END
																ELSE                                                          
																CASE WHEN LADApprovedByDateIn  IS NOT NULL THEN 'Y' ELSE 'N' END                                                                                
 															   END                                                                                                    
 															   ORDER BY CASE WHEN A.LNRemarkID in ('PRE')                                                             
 	                                                                                            THEN A.NewInterestDueDate                                             
 															   WHEN A.LNRemarkID in ('REP') THEN a.NewInterestDueDate                                                 
 															   WHEN A.LNRemarkID in ('RRP','PPE', 'RRA', 'REV') THEN A.NewInterestValueDate                           
 															   WHEN A.LNRemarkID in ('PAR') THEN A.NewPrincipalValueDate                                              
 															   ELSE A.TransactionDate END desc,A.TransNo desc)                                                        
 															   RankLoanEventByValDate,                                                                                
 	   A.TransactionDate,                                                                                                                                             
 	   A.TransNo,                                                                                                                                                     
 	   A.FirstReffNo,                                                                                                                                                 
 	   A.LADApprovedByDateIn,                                                                                                                                         
 	   A.TreasuryApprovedBy,                                                                                                                                          
 	   A.LNRemarkID,                                                                                                                                                  
 	   C.lnremarkname,                                                                                                                                                
 	   A.WITHDRAWNCURRENCY,                                                                                                                                           
 	   A.DefaultAmount,                                                                                                                                               
 	   A.Amount OriginalAmount,  
	   case when E.CU = 'Committed' then (A.Amount*B.Rate) --drawdown amount
			+ ( (cast(DATEDIFF(day,A.NewPrincipalValueDate,@CHECKDATE) as float) / cast(360 as float)) --@CHECKDATE = Reporting Date, A.TransactionDate = Value Date
				* (A.Amount*B.Rate) --drawdown amount
					* (A.CustomerRate/100) ) --interest rate
					+ ( (ISNULL(E.AMT,0) - ISNULL(G.TotalDD,0)) --unused amount
						* case when DATEDIFF(day,@CHECKDATE,E.AvailabilityPeriodTo) < 366 then (20/100) else (50/100) end ) --FKK
		else (A.Amount*B.Rate) --drawdown amount
			+ ( (cast(DATEDIFF(day,A.NewPrincipalValueDate,@CHECKDATE) as float) / cast(360 as float)) --@CHECKDATE = Reporting Date, A.NewPrincipalValueDate = Value Date
				* (A.Amount*B.Rate) --drawdown amount
					* (A.CustomerRate/100) ) --interest rate
						end as Amount,                                                                                                                                   
 	   --A.Amount*B.Rate Amount,                                                                                                                                        
 	   A.NewPrincipalValueDate,                                                                                                                                       
 	   A.NewPrincipalMaturedDate,                                                                                                                                     
 	   A.NewInterestDueDate,                                                                                                                                          
 	   A.NewInterestValueDate                                                                                                                                         
 INTO #TEMP_LN_VALUE                                                                                                                                                  
 FROM  [ERPLIVE].[BMIERP].dbo.TrxFundingConfirmation  a                                                                                                      
                                                                                                                                                                      
 LEFT JOIN TrxLLLTempCurrencyScreen B                                                                                                                                 
 ON A.WITHDRAWNCURRENCY = B.CCY AND B.TransType = 'INTRA'                                                                                                             
                                                                                                                                                                      
 LEFT JOIN [ERPLIVE].[BMIERP].dbo.masterlnremark C                                                                                                           
 ON A.LNRemarkID = C.lnremarkid                                                                                                                                       
                                                                                                                                                                      
 LEFT JOIN MasterExceptionCustomerLLL D                                                                                                                               
 ON CONVERT(INT, a.CustomerID) = CONVERT(INT, D.CustomerIDFrom)        
 
 LEFT JOIN (select distinct (AMT*RATE) as AMT,case when CU like '%Uncommitted%' then 'Uncommitted' else CU end as CU,CANUMCDM,[03C-14],CUSTACNUM,AvailabilityPeriodTo from T_FacilityMaster a
		LEFT JOIN TrxLLLTempCurrencyScreen B                                                                                                                                 
		ON A.CCY = B.CCY AND B.TransType = 'INTRA' 
		where Flag=0 and TYPETXN='LOAN'
 ) E ON A.CANO1 = E.CANUMCDM --> find limit per-CA
	AND A.AgreementNo1 = E.[03C-14] 
	AND A.CustomerID = E.CUSTACNUM
 LEFT JOIN (
 Select CANO1,sum(DD) AS totalDD from(
	Select CANO1,FirstReffNo,DD,TransDate from(
	   SELECT                                                                  
 	   distinct CANO1,FirstReffNo,A.Amount*Rate AS DD,TransactionDate,TransDate = MAX(A.TransactionDate) OVER (PARTITION BY FirstReffNo)                                                                                                                                           
	   FROM  TrxFundingConfirmation  a                                                                                                                                                                                                                                                   
	   LEFT JOIN TrxLLLTempCurrencyScreen B                                                                                                                                 
	   ON A.WITHDRAWNCURRENCY = B.CCY AND B.TransType = 'INTRA'
	   WHERE A.Flag='0'                                                                                                                                                     
 	   AND ISNULL(a.FirstReffNo,'') <>''                                                                                                                                 
 	   AND LNApprovedBy is not null                                                                                                                                      
 	   AND CASE WHEN A.LNRemarkID in ('PRE') THEN A.NewInterestDueDate                                                                                                   
 			WHEN A.LNRemarkID in ('REP') and ISNULL(CombineLoanStatus,'') <> '1' THEN A.NewInterestDueDate                                                            
 			WHEN A.LNRemarkID in ('RRP','PPE') THEN A.NewInterestValueDate                                                                                            
 			WHEN A.LNRemarkID in ('PAR') THEN A.NewPrincipalValueDate                                                                                                 
 			ELSE A.TransactionDate                                                                                                                                    
 		END <= @CURRENT                                                                                                                                                            
 	  AND CASE WHEN A.LNRemarkID in ('PRE','REP') THEN @CURRENT                                                                                                         
 			ELSE A.NewPrincipalMaturedDate                                                                                                                            
 		END >= @CURRENT     
	  AND LNRemarkID not in ('PRE','REP')  
	) MaxDate where TransactionDate=TransDate	                                                                                                                                   
  ) A
	group by CANo1
 ) G ON E.CANUMCDM=G.CANo1 --> find total outstanding per-CA                                                                                               
                                                                                                                                                                      
 WHERE A.Flag='0'                                                                                                                                                     
 	AND ISNULL(a.FirstReffNo,'') <>''                                                                                                                                 
 	AND LNApprovedBy is not null                                                                                                                                      
 	AND CASE WHEN A.LNRemarkID in ('PRE') THEN A.NewInterestDueDate                                                                                                   
 	        WHEN A.LNRemarkID in ('REP') THEN A.NewInterestDueDate                                                                                                    
 			WHEN A.LNRemarkID in ('RRP','PPE', 'RRA', 'REV') THEN A.NewInterestValueDate                                                                              
 			WHEN A.LNRemarkID in ('PAR') THEN A.NewPrincipalValueDate                                                                                                 
 			ELSE A.NewPrincipalValueDate                                                                                                                              
 		END <= @CURRENT                                                                                                                                               
                                                                                                                                                                      
 	AND CASE WHEN A.LNRemarkID in ('PRE','REP') THEN @CURRENT                                                                                                         
 			ELSE A.NewPrincipalMaturedDate                                                                                                                            
 		END >= @CURRENT                                                                                                                                               
                                                                                                                                                                      
 ORDER BY CASE WHEN A.LNRemarkID in ('PRE') THEN A.NewInterestDueDate                                                                                                 
            	WHEN A.LNRemarkID in ('REP') then a.NewInterestDueDate                                                                                                
            	WHEN A.LNRemarkID in ('RRP','PPE', 'RRA', 'REV') THEN A.NewInterestValueDate                                                                          
            	WHEN A.LNRemarkID in ('PAR') THEN A.NewPrincipalValueDate                                                                                             
            	ELSE A.TransactionDate END desc,A.TransNo desc;                                                                                           
                                                                                                                                                                      
                                                                                                                                                                      
                                                                                                                                                                      
 --(1. TRANS)                                                                                                                                                         
 INSERT INTO TrxLLLLN(Tanggal, Bulan, Tahun, TransType, CustomerID, TransDate, TransNo, FirstReffNo, LNRemarkID,                                                      
 WithdrawnCCY, DefaultAmount, NewPrincipalValueDate, NewPrincipalMaturedDate, NewInterestDueDate,                                                                     
 NewInterestValueDate, Amount, Description, CCY, OriginalAmount)                                                                                                      
 SELECT DAY(@CURRENT),                                                                                                                                                
        MONTH(@CURRENT),                                                                                                                                              
 	   YEAR(@CURRENT),                                                                                                                                                
 	   'TRANS',                                                                                                                                                       
 	   A.CustomerID,                                                                                                                                                  
 	   A.TransactionDate,                                                                                                                                             
 	   A.TransNo,                                                                                                                                                     
 	   A.FirstReffNo,                                                                                                                                                 
 	   A.LNRemarkID,                                                                                                                                                  
 	   A.WITHDRAWNCURRENCY,                                                                                                                                           
 	   a.DefaultAmount,                                                                                                                                               
 	   a.NewPrincipalValueDate,                                                                                                                                       
 	   a.NewPrincipalMaturedDate,                                                                                                                                     
 	   a.NewInterestDueDate,                                                                                                                                          
 	   a.NewInterestValueDate,                                                                                                                                        
 	   a.Amount,                                                                                                                                                      
 	   ISNULL(A.TransNo, '') + ' / ' + ISNULL(A.FirstReffNo, '') + ' / (' + ISNULL(A.lnremarkname, '') + ')' + '/' + CONVERT(VARCHAR, A.TransactionDate, 106) ,       
 	   A.WITHDRAWNCURRENCY,                                                                                                                                           
 	   A.OriginalAmount                                                                                                                                               
 FROM #TEMP_LN_TRANS A                                                                                                                                                
 WHERE RankLoanEvent = 1                                                                                                                                              
 AND A.NewPrincipalMaturedDate IS NOT NULL                                                                                                                            
                                                                                                                                                                      
                                                                                                                                                                      
                                                                                                                                                                      
 --(2. VALUE) EDITED BY VINCENT 26-10-2018 TO ADD WHERE CONDITION TreasuryApprovedBy OR LADApprovedByDateIn                                                           
 INSERT INTO TrxLLLLN(Tanggal, Bulan, Tahun, TransType, CustomerID, TransDate, TransNo, FirstReffNo, LNRemarkID,                                                      
 WithdrawnCCY, DefaultAmount, NewPrincipalValueDate, NewPrincipalMaturedDate, NewInterestDueDate,                                                                     
 NewInterestValueDate, Amount, Description, CCY, OriginalAmount)                                                                                                      
 SELECT DAY(@CURRENT),                                                                                                                                                
        MONTH(@CURRENT),                                                                                                                                              
 	   YEAR(@CURRENT),                                                                                                                                                
 	   'VALUE',                                                                                                                                                       
 	   A.CustomerID,                                                                                                                                                  
 	   A.TransactionDate,                                                                                                                                             
 	   A.TransNo,                                                                                                                                                     
 	   A.FirstReffNo,                                                                                                                                                 
 	   A.LNRemarkID,                                                                                                                                                  
 	   A.WITHDRAWNCURRENCY,                                                                                                                                           
 	   a.DefaultAmount,                                                                                                                                               
 	   a.NewPrincipalValueDate,                                                                                                                                       
 	   a.NewPrincipalMaturedDate,                                                                                                                                     
 	   a.NewInterestDueDate,                                                                                                                                          
 	   a.NewInterestValueDate,                                                                                                                                        
 	   a.Amount,                                                                                                                                                      
 	   ISNULL(A.TransNo, '') + ' / ' + ISNULL(A.FirstReffNo, '') + ' / (' + ISNULL(A.lnremarkname, '') + ')' + '/' + CONVERT(VARCHAR, A.TransactionDate, 106),        
 	   A.WITHDRAWNCURRENCY,                                                                                                                                           
 	   A.OriginalAmount                                                                                                                                               
 FROM #TEMP_LN_VALUE A                                                                                                                                                
 WHERE RankLoanEventByValDate = 1                                                                                                                                     
  AND case when A.LNRemarkID in ('NEW','R/O','RPA','REV','RRA') then A.TreasuryApprovedBy                                                                             
        else A.LADApprovedByDateIn end                                                                                                                                
        IS NOT NULL                                                                                                                                                   
 AND A.NewPrincipalMaturedDate IS NOT NULL                                                                                                                            
                                                                                                                                                                      
                                                                                                                                                                      
 -------------------------------------------------------B. BG                                                                                                         
                                                                                                                                                                      
 -- LCBG AMBIL DARI GLJENPPD ( AMBIL UNTUK LC DAN BG SEKALIAN )                                                                                                       
 SELECT ISNULL(C.CustNO, A.BTCUST) BTCUST,                                                                                                                            
 		A.BTCYCD,                                                                                                                                                     
 		A.BTNRDC,                                                                                                                                                     
 		A.BTNRDC + ' / ' + CONVERT(VARCHAR, VLDT, 106) DESCRIPTIONING,                                                                                                
 		A.OriginalAmount*B.Rate/POWER(10, B.CalcRule) Amount,                                                                                                         
 		A.OriginalAmount/POWER(10, B.CalcRule) [OriginalAmount],                                                                                                      
 		A.SubType,                                                                                                                                                    
 		A.Source                                                                                                                                                      
 INTO #TEMP_LCBG                                                                                                                                                      
 FROM                                                                                                                                                                 
 (                                                                                                                                                                    
 	SELECT RIGHT('000000' + CONVERT(VARCHAR, BTCUST), 6)BTCUST,                                                                                                       
 		   BTCYCD,                                                                                                                                                    
 		   BTNRDC,                                                                                                                                                    
 		   SUM( CASE WHEN BTDCIN = 'C'                                                                                                                                
 						THEN -1*BTPTAM                                                                                                                                
 					ELSE BTPTAM                                                                                                                                       
 				END                                                                                                                                                   
 			) OriginalAmount,                                                                                                                                         
 			B.SubType,                                                                                                                                                
 			'GLJENPPD' Source,                                                                                                                                        
 			DATEADD(DAY,  A.BTVLDT, '31 DEC 1971') VLDT                                                                                                               
 	FROM                                                                                                                                                              
 	(                                                                                                                                                                 
 	  SELECT *                                                                                                                                                        
 	  FROM [IBMDA400LIVE].[S849BD8W].[SIDMLIB].GLJENPPD                                                                                                     
 	  WHERE ISNUMERIC(BTACCD) = 1                                                                                                                                     
 	) A                                                                                                                                                               
 	INNER JOIN MasterLLLAccountCode B                                                                                                                                 
 	ON A.BTACCD = B.Acod                                                                                                                                              
 	WHERE B.SubType IN ('LC', 'BG')                                                                                                                                   
 	GROUP BY BTCUST, BTCYCD, BTNRDC, BTVLDT, B.SubType                                                                                                                
                                                                                                                                                                      
 	UNION ALL                                                                                                                                                         
                                                                                                                                                                      
 	SELECT RIGHT('000000' + CONVERT(VARCHAR, A.CNUM), 6),                                                                                                             
 		   A.CCY,                                                                                                                                                     
 		   A.ANAM,                                                                                                                                                    
 		   A.LDBL,                                                                                                                                                    
 		   B.SubType,                                                                                                                                                 
 		   'ACCNTAB' Source,                                                                                                                                          
 		   GETDATE()                                                                                                                                                  
 	FROM [IBMDA400LIVE].[S849BD8W].[SIDMLIB].ACCNTAB A                                                                                                      
 	INNER JOIN MasterLLLAccountCode B                                                                                                                                 
 	ON A.ACOD = B.Acod                                                                                                                                                
 	WHERE B.SubType IN ('LC', 'BG')                                                                                                                                   
 	                                                                                                                                                                  
 )A                                                                                                                                                                   
 LEFT JOIN TrxLLLTempCurrencyScreen B                                                                                                                                 
 ON A.BTCYCD = B.CCY AND B.TransType = 'INTRA'                                                                                                                        
                                                                                                                                                                      
 LEFT JOIN MasterAlternateCustNo C                                                                                                                                    
 ON ISNULL(C.AlternateNo, 0) = A.BTCUST                                                                                                                               
                                                                                                                                                                      
 WHERE OriginalAmount <> 0                                                                                                                                            
                                                                                                                                                                      
                                                                                                                                                                      
                                                                                                                                                                      
 --(1. TRANS)                                                                                                                                                         
 INSERT INTO TrxLLLBG(Tanggal, Bulan, Tahun, TransType, CustomerID, CCY, Anam, Amount, OriginalAmount, Source, Description)                                           
 SELECT DAY(@CURRENT),                                                                                                                                                
        MONTH(@CURRENT),                                                                                                                                              
 	   YEAR(@CURRENT),                                                                                                                                                
 	   'TRANS',                                                                                                                                                       
 	   A.BTCUST,                                                                                                                                                      
 	   A.BTCYCD,                                                                                                                                                      
 	   A.BTNRDC,                                                                                                                                                      
 	   A.Amount,                                                                                                                                                      
 	   A.OriginalAmount,                                                                                                                                              
 	   A.Source,                                                                                                                                                      
 	   A.DESCRIPTIONING                                                                                                                                               
 FROM #TEMP_LCBG  A                                                                                                                                                   
 WHERE SubType = 'BG';                                                                                                                                                
                                                                                                                                                                      
                                                                                                                                                                      
                                                                                                                                                                      
 --(2. VALUE)                                                                                                                                                         
 INSERT INTO TrxLLLBG(Tanggal, Bulan, Tahun, TransType, CustomerID, CCY, Anam, Amount, OriginalAmount, Source, Description)                                           
 SELECT DAY(@CURRENT),                                                                                                                                                
        MONTH(@CURRENT),                                                                                                                                              
 	   YEAR(@CURRENT),                                                                                                                                                
 	   'VALUE',                                                                                                                                                       
 	   A.BTCUST,                                                                                                                                                      
 	   A.BTCYCD,                                                                                                                                                      
 	   A.BTNRDC,                                                                                                                                                      
 	   A.Amount,                                                                                                                                                      
 	   A.OriginalAmount,                                                                                                                                              
 	   A.Source,                                                                                                                                                      
 	   A.DESCRIPTIONING                                                                                                                                               
 FROM #TEMP_LCBG  A                                                                                                                                                   
 WHERE SubType = 'BG';                                                                                                                                                
                                                                                                                                                                      
                                                                                                                                                                      
 -------------------------------------------------------C. LC                                                                                                         
                                                                                                                                                                      
                                                                                                                                                                      
 --(1. TRANS)                                                                                                                                                         
 INSERT INTO TrxLLLLC(Tanggal, Bulan, Tahun, TransType, CustomerID, CCY, Anam, Amount, OriginalAmount, Source, Description)                                           
 SELECT DAY(@CURRENT),                                                                                                                                                
        MONTH(@CURRENT),                                                                                                                                              
 	   YEAR(@CURRENT),                                                                                                                                                
 	   'TRANS',                                                                                                                                                       
 	   A.BTCUST,                                                                                                                                                      
 	   A.BTCYCD,                                                                                                                                                      
 	   A.BTNRDC,                                                                                                                                                      
 	   A.Amount,                                                                                                                                                      
 	   A.OriginalAmount,                                                                                                                                              
 	   A.Source,                                                                                                                                                      
 	   A.DESCRIPTIONING                                                                                                                                               
 FROM #TEMP_LCBG  A                                                                                                                                                   
 WHERE SubType = 'LC';                                                                                                                                                
                                                                                                                                                                      
                                                                                                                                                                      
 --(2. VALUE)                                                                                                                                                         
 INSERT INTO TrxLLLLC(Tanggal, Bulan, Tahun, TransType, CustomerID, CCY, Anam, Amount, OriginalAmount, Source, Description)                                           
 SELECT DAY(@CURRENT),                                                                                                                                                
        MONTH(@CURRENT),                                                                                                                                              
 	   YEAR(@CURRENT),                                                                                                                                                
 	   'VALUE',                                                                                                                                                       
 	   A.BTCUST,                                                                                                                                                      
 	   A.BTCYCD,                                                                                                                                                      
 	   A.BTNRDC,                                                                                                                                                      
 	   A.Amount,                                                                                                                                                      
 	   A.OriginalAmount,                                                                                                                                              
 	   A.Source,                                                                                                                                                      
 	   A.DESCRIPTIONING                                                                                                                                               
 FROM #TEMP_LCBG  A                                                                                                                                                   
 WHERE SubType = 'LC';                                                                                                                                                
                                                                                                                                                                      
                                                                                                                                                                      
 -------------------------------------------------------E.INTERBANK                                                                                                   
                                                                                                                                                                      
 --(1. TRANS)                                                                                                                                                         
 INSERT INTO TrxLLLInterbank(Tanggal, Bulan, Tahun, TransType, CustomerID,                                                                                            
                             Amount, Description, CCY, OriginalAmount)                                                                                                
 (SELECT DAY(@CURRENT),                                                                                                                                               
        MONTH(@CURRENT),                                                                                                                                              
 	   YEAR(@CURRENT),                                                                                                                                                
 	   'TRANS',                                                                                                                                                       
        RIGHT('000000' + CONVERT(VARCHAR, A.CNUM), 6),                                                                                                                
 	   A.LDBL*C.Rate/POWER(10, C.CalcRule),                                                                                                                           
 	   '(Begining Balance) - ' + A.ANAM,                                                                                                                              
 	   A.CCY,                                                                                                                                                         
 	   A.LDBL/POWER(10,C.CalcRule)                                                                                                                                    
                                                                                                                                                                      
 FROM [IBMDA400LIVE].[S849BD8W].[SIDMLIB].ACCNTAB A                                                                                                         
                                                                                                                                                                      
 INNER JOIN MasterLLLAccountCode B                                                                                                                                    
 ON A.ACOD = B.ACOD                                                                                                                                                   
                                                                                                                                                                      
 LEFT JOIN TrxLLLTempCurrencyScreen C                                                                                                                                 
 ON A.CCY = C.CCY AND C.TransType = 'INTRA'                                                                                                                           
                                                                                                                                                                      
 WHERE B.SubType IN ('NOSTRO')                                                                                                                                        
 AND A.LDBL <> 0.0                                                                                                                                                    
                                                                                                                                                                      
                                                                                                                                                                      
 UNION                                                                                                                                                                
                                                                                                                                                                      
                                                                                                                                                                      
 SELECT DAY(@CURRENT),                                                                                                                                                
        MONTH(@CURRENT),                                                                                                                                              
 	   YEAR(@CURRENT),                                                                                                                                                
 	   'TRANS',                                                                                                                                                       
 	   RIGHT('000000' + CONVERT(VARCHAR, A.CUSN), 6),                                                                                                                 
 	   CASE WHEN A.DORC = 1                                                                                                                                           
 				THEN -1*A.MVAM                                                                                                                                        
 			ELSE A.MVAM                                                                                                                                               
 	   END *C.Rate/POWER(10, C.CalcRule),                                                                                                                             
 	   'Movement' DESCRIPTION,                                                                                                                                        
 	   A.CCYD,                                                                                                                                                        
 	   CASE WHEN A.DORC = 1                                                                                                                                           
 				THEN -1*A.MVAM                                                                                                                                        
 			ELSE A.MVAM                                                                                                                                               
 	   END /POWER(10, C.CalcRule)                                                                                                                                     
 FROM [IBMDA400LIVE].[S849BD8W].[SIDMLIB].RSACMTPD A                                                                                                        
                                                                                                                                                                      
 INNER JOIN MasterLLLAccountCode B                                                                                                                                    
 ON A.ACDE = B.ACOD                                                                                                                                                   
                                                                                                                                                                      
 LEFT JOIN TrxLLLTempCurrencyScreen C                                                                                                                                 
 ON A.CCYD = C.CCY AND C.TransType = 'INTRA'                                                                                                                          
                                                                                                                                                                      
 WHERE B.SubType = 'NOSTRO')                                                                                                                                          
                                                                                                                                                                      
                                                                                                                                                                      
 INSERT INTO TrxLLLInterbank(Tanggal, Bulan, Tahun, TransType, CustomerID, DEALNO, PRODUCT, PRODTYPE, CCY,                                                            
                             OriginalAmount, Amount, VDATE, MDATE, Description)                                                                                       
 SELECT  DAY(@CURRENT),                                                                                                                                               
         MONTH(@CURRENT),                                                                                                                                             
 	    YEAR(@CURRENT),                                                                                                                                               
 	    'TRANS',                                                                                                                                                      
 	    DLDT.CNO,                                                                                                                                                     
 		DLDT.DEALNO,                                                                                                                                                  
 		DLDT.PRODUCT,                                                                                                                                                 
 		DLDT.PRODTYPE,                                                                                                                                                
 		DLDT.CCY,                                                                                                                                                     
 		ABS(DLDT.CCYAMT) CCYAMT,                                                                                                                                      
 		ROUND((ABS(DLDT.CCYAMT * B.Rate)), 2) INTERBANK_AMT,                                                                                                          
 		DLDT.VDATE,                                                                                                                                                   
 		DLDT.MDATE,                                                                                                                                                   
 		'OPICS'                                                                                                                                                       
 FROM [OPICSDB1].[OPICS].dbo.DLDT                                                                                                                  
                                                                                                                                                                      
 LEFT JOIN TrxLLLTempCurrencyScreen B                                                                                                                                 
 ON DLDT.CCY = B.CCY COLLATE SQL_Latin1_General_CP1_CI_AS AND B.TransType = 'INTRA'                                                                                   
                                                                                                                                                                      
 WHERE PRODUCT = 'EURO'                                                                                                                                               
     AND MDATE >= @CURRENT                                                                                                                                            
 	AND CCYAMT > 0                                                                                                                                                    
 	AND ISNULL(REVREASON, '') =  ''                                                                                                                                   
 	AND AL = 'A';                                                                                                                                                     
                                                                                                                                                                      
                                                                                                                                                                      
                                                                                                                                                                      
 --(2. VALUE)                                                                                                                                                         
 INSERT INTO TrxLLLInterbank(Tanggal, Bulan, Tahun, TransType, CustomerID,                                                                                            
                             Amount, Description, CCY, OriginalAmount)                                                                                                
 (SELECT DAY(@CURRENT),                                                                                                                                               
        MONTH(@CURRENT),                                                                                                                                              
 	   YEAR(@CURRENT),                                                                                                                                                
 	   'VALUE',                                                                                                                                                       
        RIGHT('000000' + CONVERT(VARCHAR, A.CNUM), 6),                                                                                                                
 	   A.LDBL*C.Rate/POWER(10, C.CalcRule),                                                                                                                           
 	   '(Begining Balance) - ' + A.ANAM,                                                                                                                              
 	   A.CCY,                                                                                                                                                         
 	   A.LDBL/POWER(10,C.CalcRule)                                                                                                                                    
                                                                                                                                                                      
 FROM [IBMDA400LIVE].[S849BD8W].[SIDMLIB].ACCNTAB A                                                                                                         
                                                                                                                                                                      
 INNER JOIN MasterLLLAccountCode B                                                                                                                                    
 ON A.ACOD = B.ACOD                                                                                                                                                   
                                                                                                                                                                      
 LEFT JOIN TrxLLLTempCurrencyScreen C                                                                                                                                 
 ON A.CCY = C.CCY AND C.TransType = 'INTRA'                                                                                                                           
                                                                                                                                                                      
 WHERE B.SubType = 'NOSTRO'                                                                                                                                           
 AND A.LDBL <> 0.0                                                                                                                                                    
                                                                                                                                                                      
                                                                                                                                                                      
 UNION                                                                                                                                                                
                                                                                                                                                                      
                                                                                                                                                                      
 SELECT DAY(@CURRENT),                                                                                                                                                
        MONTH(@CURRENT),                                                                                                                                              
 	   YEAR(@CURRENT),                                                                                                                                                
 	   'VALUE',                                                                                                                                                       
 	   RIGHT('000000' + CONVERT(VARCHAR, A.CUSN), 6),                                                                                                                 
 	   CASE WHEN A.DORC = 1                                                                                                                                           
 				THEN -1*A.MVAM                                                                                                                                        
 			ELSE A.MVAM                                                                                                                                               
 	   END *C.Rate/POWER(10, C.CalcRule),                                                                                                                             
 	   'Movement' DESCRIPTION,                                                                                                                                        
 	   A.CCYD,                                                                                                                                                        
 	   A.MVAM/POWER(10, C.CalcRule)                                                                                                                                   
 FROM [IBMDA400LIVE].[S849BD8W].[SIDMLIB].RSACMTPD A                                                                                                        
                                                                                                                                                                      
 INNER JOIN MasterLLLAccountCode B                                                                                                                                    
 ON A.ACDE = B.ACOD                                                                                                                                                   
                                                                                                                                                                      
 LEFT JOIN TrxLLLTempCurrencyScreen C                                                                                                                                 
 ON A.CCYD = C.CCY AND C.TransType = 'INTRA'                                                                                                                          
                                                                                                                                                                      
 WHERE B.SubType = 'NOSTRO'                                                                                                                                           
 AND A.VUDT = @JULDATE_DATA)                                                                                                                                          
                                                                                                                                                                      
                                                                                                                                                                      
 INSERT INTO TrxLLLInterbank(Tanggal, Bulan, Tahun, TransType, CustomerID, DEALNO, PRODUCT, PRODTYPE, CCY,                                                            
                             OriginalAmount, Amount, VDATE, MDATE, Description)                                                                                       
 SELECT  DAY(@CURRENT),                                                                                                                                               
         MONTH(@CURRENT),                                                                                                                                             
 	    YEAR(@CURRENT),                                                                                                                                               
 	    'VALUE',                                                                                                                                                      
 	    DLDT.CNO,                                                                                                                                                     
 		DLDT.DEALNO,                                                                                                                                                  
 		DLDT.PRODUCT,                                                                                                                                                 
 		DLDT.PRODTYPE,                                                                                                                                                
 		DLDT.CCY,                                                                                                                                                     
 		ABS(DLDT.CCYAMT) CCYAMT,                                                                                                                                      
 		ROUND((ABS(DLDT.CCYAMT * B.Rate)), 2) INTERBANK_AMT,                                                                                                          
 		DLDT.VDATE,                                                                                                                                                   
 		DLDT.MDATE,                                                                                                                                                   
 		'OPICS'                                                                                                                                                       
 FROM [OPICSDB1].[OPICS].dbo.DLDT                                                                                                                  
                                                                                                                                                                      
 LEFT JOIN TrxLLLTempCurrencyScreen B                                                                                                                                 
 ON DLDT.CCY = B.CCY COLLATE SQL_Latin1_General_CP1_CI_AS AND B.TransType = 'INTRA'                                                                                   
                                                                                                                                                                      
 WHERE PRODUCT = 'EURO'                                                                                                                                               
     AND MDATE >= @CURRENT                                                                                                                                            
 	AND CCYAMT > 0                                                                                                                                                    
 	AND ISNULL(REVREASON, '') =  ''                                                                                                                                   
 	AND AL = 'A';                                                                                                                                                     
                                                                                                                                                                      
                                                                                                                                                                      
 -------------------------------------------------------D. OS FOREX                                                                                                   
                                                                                                                                                                      
 --HOLIDAY                                                                                                                                                            
 IF OBJECT_ID('TEMP_HLDY_FX', 'U') IS NOT NULL                                                                                                                        
 	DROP TABLE TEMP_HLDY_FX;                                                                                                                                          
                                                                                                                                                                      
 SELECT CALENDARID, HOLIDATE                                                                                                                                          
 INTO TEMP_HLDY_FX                                                                                                                                                    
 FROM [OPICSDB1].[OPICS].dbo.HLDY                                                                                                                  
 WHERE HOLIDATE BETWEEN @DATA AND DATEADD(YEAR, 10, @DATA);                                                                                                           
                                                                                                                                                                      
                                                                                                                                                                      
                                                                                                                                                                      
 --TEMP FOREX                                                                                                                                                         
 SELECT A.DEALNO,                                                                                                                                                     
        A.CUST,                                                                                                                                                       
        A.SPOTFWDIND,                                                                                                                                                 
 	   A.ORIGOCAMT,                                                                                                                                                   
 	   A.CCY,                                                                                                                                                         
 	   A.CCYAMT,                                                                                                                                                      
 	   A.CCYBAMT,                                                                                                                                                     
 	   A.CTRCCY,                                                                                                                                                      
 	   A.CTRAMT,                                                                                                                                                      
 	   A.CTRBAMT,                                                                                                                                                     
 	   A.VDATE,                                                                                                                                                       
 	   A.DEALDATE,                                                                                                                                                    
 	   A.PS                                                                                                                                                           
 INTO #TEMP_FX                                                                                                                                                        
 FROM [OPICSDB1].[OPICS].dbo.FXDH A                                                                                                                
 WHERE PRODTYPE NOT IN ('TI','FT','CE','PU') AND REVDATE IS NULL                                                                                                      
 AND (CCYSETTDATE > @DATA OR CTRSETTDATE > @DATA)                                                                                                                     
                                                                                                                                                                      
                                                                                                                                                                      
                                                                                                                                                                      
                                                                                                                                                                      
 --FX SPOT                                                                                                                                                            
 SELECT A.DEALNO,                                                                                                                                                     
        A.CUST,                                                                                                                                                       
 	   A.SPOTFWDIND SPOTFWDIND,                                                                                                                                       
 	   A.ORIGOCAMT,                                                                                                                                                   
 	   A.CCY,                                                                                                                                                         
        ROUND(A.CCYAMT*B.Rate, 0)  CCYREVALAMT,                                                                                                                       
 	   A.CCYAMT,                                                                                                                                                      
 	   A.CCYBAMT,                                                                                                                                                     
 	   A.CTRCCY,                                                                                                                                                      
 	   ROUND(A.CTRAMT*C.Rate, 0)  CTRREVALAMT,                                                                                                                        
 	   A.CTRAMT,                                                                                                                                                      
 	   A.CTRBAMT,                                                                                                                                                     
 	   A.VDATE,                                                                                                                                                       
 	   A.DEALDATE,                                                                                                                                                    
 	   B.Rate RateFinal,                                                                                                                                              
 	   A.PS                                                                                                                                                           
 INTO #TEMP_FX_SPOT                                                                                                                                                   
 FROM #TEMP_FX A                                                                                                                                                      
 LEFT JOIN TrxLLLTempCurrencyScreen B                                                                                                                                 
 ON A.CCY = B.CCY COLLATE SQL_Latin1_General_CP1_CI_AS                                                                                                                
                  AND B.TransType = 'INTRA'                                                                                                                           
 LEFT JOIN TrxLLLTempCurrencyScreen C                                                                                                                                 
 ON A.CTRCCY = C.CCY COLLATE SQL_Latin1_General_CP1_CI_AS                                                                                                             
                     AND C.TransType = 'INTRA'                                                                                                                        
                                                                                                                                                                      
 WHERE A.SPOTFWDIND = 'S'                                                                                                                                             
 ORDER BY A.DEALNO                                                                                                                                                    
                                                                                                                                                                      
                                                                                                                                                                      
                                                                                                                                                                      
 --FX FORWARD                                                                                                                                                         
 SELECT A.DEALNO,                                                                                                                                                     
        A.CUST,                                                                                                                                                       
 	   A.CCY,                                                                                                                                                         
 	   A.ORIGOCAMT,                                                                                                                                                   
 	   A.CCYAMT,                                                                                                                                                      
 	   A.CCYBAMT,                                                                                                                                                     
 	   A.CTRCCY,                                                                                                                                                      
 	   A.CTRAMT,                                                                                                                                                      
 	   A.VDATE,                                                                                                                                                       
 	   A.CTRBAMT,                                                                                                                                                     
 	   A.DEALDATE,                                                                                                                                                    
 	   @DATA EXECUTEDATE,                                                                                                                                             
 	   A.PS                                                                                                                                                           
 INTO #TEMP_FX_FWD                                                                                                                                                    
 FROM #TEMP_FX A                                                                                                                                                      
 WHERE A.SPOTFWDIND = 'F'                                                                                                                                             
 ORDER BY DEALNO                                                                                                                                                      
                                                                                                                                                                      
                                                                                                                                                                      
                                                                                                                                                                      
 --DETAIL FX FWD                                                                                                                                                      
 /*                                                                                                                                                                   
  SELECT PERIOD                                                                                                                                                       
  SCALAR1, DUEDATE1, FIX1, COUNTERSPOTDATE1 LANGSUNG DI'SELECT' SUPAYA RESERVE COLOUM                                                                                 
  KEMUDIAN FIX1 AKAN DIGANTI MENJADI NULL                                                                                                                             
                                                                                                                                                                      
  @SPOTDATE_PROJECTION DIGUNAKAN UNTUK PERKIRAAN AWAL... NANTI AKAN DIADJUSTMENT TERHADAP                                                                             
  HOLIDAY UNTUK CCY DAN CTR-NYA                                                                                                                                       
 */                                                                                                                                                                   
                                                                                                                                                                      
 --REVP MID                                                                                                                                                           
 SELECT A.CCY,                                                                                                                                                        
 	   @DATA MATDATESPOT,                                                                                                                                             
 	   B.Rate SPOTRATE_8,                                                                                                                                             
                                                                                                                                                                      
 	   CASE WHEN LTRIM(RTRIM(A.PERIOD1)) = '' THEN '0D' ELSE LTRIM(RTRIM(A.PERIOD1)) END PERIOD1,                                                                     
 	   0 SCALAR1,                                                                                                                                                     
 	   'X' TERM1,                                                                                                                                                     
 	   @DATA MATDATE1,                                                                                                                                                
 	   A.RATE1_8 RATE1,                                                                                                                                               
                                                                                                                                                                      
 	   CASE WHEN LTRIM(RTRIM(A.PERIOD2)) = '' THEN '0D' ELSE LTRIM(RTRIM(A.PERIOD2)) END PERIOD2,                                                                     
 	   0 SCALAR2,                                                                                                                                                     
 	   'X' TERM2,                                                                                                                                                     
 	   @DATA MATDATE2,                                                                                                                                                
 	   A.RATE2_8 RATE2,                                                                                                                                               
                                                                                                                                                                      
 	   CASE WHEN LTRIM(RTRIM(A.PERIOD3)) = '' THEN '0D' ELSE LTRIM(RTRIM(A.PERIOD3)) END PERIOD3,                                                                     
 	   0 SCALAR3,                                                                                                                                                     
 	   'X' TERM3,                                                                                                                                                     
 	   @DATA MATDATE3,                                                                                                                                                
 	   A.RATE3_8 RATE3,                                                                                                                                               
                                                                                                                                                                      
 	   CASE WHEN LTRIM(RTRIM(A.PERIOD4)) = '' THEN '0D' ELSE LTRIM(RTRIM(A.PERIOD4)) END PERIOD4,                                                                     
 	   0 SCALAR4,                                                                                                                                                     
 	   'X' TERM4,                                                                                                                                                     
 	   @DATA MATDATE4,                                                                                                                                                
 	   A.RATE4_8 RATE4,                                                                                                                                               
                                                                                                                                                                      
 	   CASE WHEN LTRIM(RTRIM(A.PERIOD5)) = '' THEN '0D' ELSE LTRIM(RTRIM(A.PERIOD5)) END PERIOD5,                                                                     
 	   'X' TERM5,                                                                                                                                                     
 	   0 SCALAR5,                                                                                                                                                     
 	   @DATA MATDATE5,                                                                                                                                                
 	   A.RATE5_8 RATE5,                                                                                                                                               
                                                                                                                                                                      
 	   CASE WHEN LTRIM(RTRIM(A.PERIOD6)) = '' THEN '0D' ELSE LTRIM(RTRIM(A.PERIOD6)) END PERIOD6,                                                                     
 	   0 SCALAR6,                                                                                                                                                     
 	   'X' TERM6,                                                                                                                                                     
 	   @DATA MATDATE6,                                                                                                                                                
 	   A.RATE6_8 RATE6,                                                                                                                                               
                                                                                                                                                                      
 	   CASE WHEN LTRIM(RTRIM(A.PERIOD7)) = '' THEN '0D' ELSE LTRIM(RTRIM(A.PERIOD7)) END PERIOD7,                                                                     
 	   0 SCALAR7,                                                                                                                                                     
 	   'X' TERM7,                                                                                                                                                     
 	   @DATA MATDATE7,                                                                                                                                                
 	   A.RATE7_8 RATE7,                                                                                                                                               
                                                                                                                                                                      
 	   CASE WHEN LTRIM(RTRIM(A.PERIOD8)) = '' THEN '0D' ELSE LTRIM(RTRIM(A.PERIOD8)) END PERIOD8,                                                                     
 	   0 SCALAR8,                                                                                                                                                     
 	   'X' TERM8,                                                                                                                                                     
 	   @DATA MATDATE8,                                                                                                                                                
 	   A.RATE8_8 RATE8,                                                                                                                                               
                                                                                                                                                                      
 	   CASE WHEN LTRIM(RTRIM(A.PERIOD9)) = '' THEN '0D' ELSE LTRIM(RTRIM(A.PERIOD9)) END PERIOD9,                                                                     
 	   0 SCALAR9,                                                                                                                                                     
 	   'X' TERM9,                                                                                                                                                     
 	   @DATA MATDATE9,                                                                                                                                                
 	   A.RATE9_8 RATE9                                                                                                                                                
 INTO #TEMP_REVP_MID                                                                                                                                                  
 FROM [OPICSDB1].[OPICS].dbo.REVP A                                                                                                                
 LEFT JOIN TrxLLLTempCurrencyScreen B                                                                                                                                 
 ON A.CCY = B.CCY COLLATE SQL_Latin1_General_CP1_CI_AS                                                                                                                
 AND B.TransType = 'INTRA';                                                                                                                                           
                                                                                                                                                                      
                                                                                                                                                                      
                                                                                                                                                                      
 --REVP BID                                                                                                                                                           
 SELECT A.CCY,                                                                                                                                                        
 	   @DATA MATDATESPOT,                                                                                                                                             
 	   A.SPOTRATE_8,                                                                                                                                                  
                                                                                                                                                                      
 	   CASE WHEN LTRIM(RTRIM(A.PERIOD1)) = '' THEN '0D' ELSE LTRIM(RTRIM(A.PERIOD1)) END PERIOD1,                                                                     
 	   0 SCALAR1,                                                                                                                                                     
 	   'X' TERM1,                                                                                                                                                     
 	   @DATA MATDATE1,                                                                                                                                                
 	   A.RATE1_8 RATE1,                                                                                                                                               
                                                                                                                                                                      
 	   CASE WHEN LTRIM(RTRIM(A.PERIOD2)) = '' THEN '0D' ELSE LTRIM(RTRIM(A.PERIOD2)) END PERIOD2,                                                                     
 	   0 SCALAR2,                                                                                                                                                     
 	   'X' TERM2,                                                                                                                                                     
 	   @DATA MATDATE2,                                                                                                                                                
 	   A.RATE2_8 RATE2,                                                                                                                                               
                                                                                                                                                                      
 	   CASE WHEN LTRIM(RTRIM(A.PERIOD3)) = '' THEN '0D' ELSE LTRIM(RTRIM(A.PERIOD3)) END PERIOD3,                                                                     
 	   0 SCALAR3,                                                                                                                                                     
 	   'X' TERM3,                                                                                                                                                     
 	   @DATA MATDATE3,                                                                                                                                                
 	   A.RATE3_8 RATE3,                                                                                                                                               
                                                                                                                                                                      
 	   CASE WHEN LTRIM(RTRIM(A.PERIOD4)) = '' THEN '0D' ELSE LTRIM(RTRIM(A.PERIOD4)) END PERIOD4,                                                                     
 	   0 SCALAR4,                                                                                                                                                     
 	   'X' TERM4,                                                                                                                                                     
 	   @DATA MATDATE4,                                                                                                                                                
 	   A.RATE4_8 RATE4,                                                                                                                                               
                                                                                                                                                                      
 	   CASE WHEN LTRIM(RTRIM(A.PERIOD5)) = '' THEN '0D' ELSE LTRIM(RTRIM(A.PERIOD5)) END PERIOD5,                                                                     
 	   'X' TERM5,                                                                                                                                                     
 	   0 SCALAR5,                                                                                                                                                     
 	   @DATA MATDATE5,                                                                                                                                                
 	   A.RATE5_8 RATE5,                                                                                                                                               
                                                                                                                                                                      
 	   CASE WHEN LTRIM(RTRIM(A.PERIOD6)) = '' THEN '0D' ELSE LTRIM(RTRIM(A.PERIOD6)) END PERIOD6,                                                                     
 	   0 SCALAR6,                                                                                                                                                     
 	   'X' TERM6,                                                                                                                                                     
 	   @DATA MATDATE6,                                                                                                                                                
 	   A.RATE6_8 RATE6,                                                                                                                                               
                                                                                                                                                                      
 	   CASE WHEN LTRIM(RTRIM(A.PERIOD7)) = '' THEN '0D' ELSE LTRIM(RTRIM(A.PERIOD7)) END PERIOD7,                                                                     
 	   0 SCALAR7,                                                                                                                                                     
 	   'X' TERM7,                                                                                                                                                     
 	   @DATA MATDATE7,                                                                                                                                                
 	   A.RATE7_8 RATE7,                                                                                                                                               
                                                                                                                                                                      
 	   CASE WHEN LTRIM(RTRIM(A.PERIOD8)) = '' THEN '0D' ELSE LTRIM(RTRIM(A.PERIOD8)) END PERIOD8,                                                                     
 	   0 SCALAR8,                                                                                                                                                     
 	   'X' TERM8,                                                                                                                                                     
 	   @DATA MATDATE8,                                                                                                                                                
 	   A.RATE8_8 RATE8,                                                                                                                                               
                                                                                                                                                                      
 	   CASE WHEN LTRIM(RTRIM(A.PERIOD9)) = '' THEN '0D' ELSE LTRIM(RTRIM(A.PERIOD9)) END PERIOD9,                                                                     
 	   0 SCALAR9,                                                                                                                                                     
 	   'X' TERM9,                                                                                                                                                     
 	   @DATA MATDATE9,                                                                                                                                                
 	   A.RATE9_8 RATE9                                                                                                                                                
 INTO #TEMP_REVP_BID                                                                                                                                                  
 FROM [OPICSDB1].[OPICSBID].dbo.REVP A;                                                                                                               
                                                                                                                                                                      
                                                                                                                                                                      
                                                                                                                                                                      
 --REVP OFF                                                                                                                                                           
 SELECT A.CCY,                                                                                                                                                        
 	   @DATA MATDATESPOT,                                                                                                                                             
 	   A.SPOTRATE_8,                                                                                                                                                  
                                                                                                                                                                      
 	   CASE WHEN LTRIM(RTRIM(A.PERIOD1)) = '' THEN '0D' ELSE LTRIM(RTRIM(A.PERIOD1)) END PERIOD1,                                                                     
 	   0 SCALAR1,                                                                                                                                                     
 	   'X' TERM1,                                                                                                                                                     
 	   @DATA MATDATE1,                                                                                                                                                
 	   A.RATE1_8 RATE1,                                                                                                                                               
                                                                                                                                                                      
 	   CASE WHEN LTRIM(RTRIM(A.PERIOD2)) = '' THEN '0D' ELSE LTRIM(RTRIM(A.PERIOD2)) END PERIOD2,                                                                     
 	   0 SCALAR2,                                                                                                                                                     
 	   'X' TERM2,                                                                                                                                                     
 	   @DATA MATDATE2,                                                                                                                                                
 	   A.RATE2_8 RATE2,                                                                                                                                               
                                                                                                                                                                      
 	   CASE WHEN LTRIM(RTRIM(A.PERIOD3)) = '' THEN '0D' ELSE LTRIM(RTRIM(A.PERIOD3)) END PERIOD3,                                                                     
 	   0 SCALAR3,                                                                                                                                                     
 	   'X' TERM3,                                                                                                                                                     
 	   @DATA MATDATE3,                                                                                                                                                
 	   A.RATE3_8 RATE3,                                                                                                                                               
                                                                                                                                                                      
 	   CASE WHEN LTRIM(RTRIM(A.PERIOD4)) = '' THEN '0D' ELSE LTRIM(RTRIM(A.PERIOD4)) END PERIOD4,                                                                     
 	   0 SCALAR4,                                                                                                                                                     
 	   'X' TERM4,                                                                                                                                                     
 	   @DATA MATDATE4,                                                                                                                                                
 	   A.RATE4_8 RATE4,                                                                                                                                               
                                                                                                                                                                      
 	   CASE WHEN LTRIM(RTRIM(A.PERIOD5)) = '' THEN '0D' ELSE LTRIM(RTRIM(A.PERIOD5)) END PERIOD5,                                                                     
 	   'X' TERM5,                                                                                                                                                     
 	   0 SCALAR5,                                                                                                                                                     
 	   @DATA MATDATE5,                                                                                                                                                
 	   A.RATE5_8 RATE5,                                                                                                                                               
                                                                                                                                                                      
 	   CASE WHEN LTRIM(RTRIM(A.PERIOD6)) = '' THEN '0D' ELSE LTRIM(RTRIM(A.PERIOD6)) END PERIOD6,                                                                     
 	   0 SCALAR6,                                                                                                                                                     
 	   'X' TERM6,                                                                                                                                                     
 	   @DATA MATDATE6,                                                                                                                                                
 	   A.RATE6_8 RATE6,                                                                                                                                               
                                                                                                                                                                      
 	   CASE WHEN LTRIM(RTRIM(A.PERIOD7)) = '' THEN '0D' ELSE LTRIM(RTRIM(A.PERIOD7)) END PERIOD7,                                                                     
 	   0 SCALAR7,                                                                                                                                                     
 	   'X' TERM7,                                                                                                                                                     
 	   @DATA MATDATE7,                                                                                                                                                
 	   A.RATE7_8 RATE7,                                                                                                                                               
                                                                                                                                                                      
 	   CASE WHEN LTRIM(RTRIM(A.PERIOD8)) = '' THEN '0D' ELSE LTRIM(RTRIM(A.PERIOD8)) END PERIOD8,                                                                     
 	   0 SCALAR8,                                                                                                                                                     
 	   'X' TERM8,                                                                                                                                                     
 	   @DATA MATDATE8,                                                                                                                                                
 	   A.RATE8_8 RATE8,                                                                                                                                               
                                                                                                                                                                      
 	   CASE WHEN LTRIM(RTRIM(A.PERIOD9)) = '' THEN '0D' ELSE LTRIM(RTRIM(A.PERIOD9)) END PERIOD9,                                                                     
 	   0 SCALAR9,                                                                                                                                                     
 	   'X' TERM9,                                                                                                                                                     
 	   @DATA MATDATE9,                                                                                                                                                
 	   A.RATE9_8 RATE9                                                                                                                                                
 INTO #TEMP_REVP_OFF                                                                                                                                                  
 FROM [OPICSDB1].[OPICSOFF].dbo.REVP A;                                                                                                               
                                                                                                                                                                      
                                                                                                                                                                      
 --UPDATE TERM AND SCALAR 1                                                                                                                                           
                                                                                                                                                                      
 --MID                                                                                                                                                                
 UPDATE A                                                                                                                                                             
 	SET A.TERM1 = RIGHT(A.PERIOD1, 1),                                                                                                                                
 	    A.SCALAR1 = CONVERT(INTEGER, SUBSTRING(A.PERIOD1, 1, LEN(A.PERIOD1)-1)),                                                                                      
                                                                                                                                                                      
 		A.TERM2 = RIGHT(A.PERIOD2, 1),                                                                                                                                
 	    A.SCALAR2 = CONVERT(INTEGER, SUBSTRING(A.PERIOD2, 1, LEN(A.PERIOD2)-1)),                                                                                      
                                                                                                                                                                      
 		A.TERM3 = RIGHT(A.PERIOD3, 1),                                                                                                                                
 	    A.SCALAR3 = CONVERT(INTEGER, SUBSTRING(A.PERIOD3, 1, LEN(A.PERIOD3)-1)),                                                                                      
                                                                                                                                                                      
 		A.TERM4 = RIGHT(A.PERIOD4, 1),                                                                                                                                
 	    A.SCALAR4 = CONVERT(INTEGER, SUBSTRING(A.PERIOD4, 1, LEN(A.PERIOD4)-1)),                                                                                      
                                                                                                                                                                      
 		A.TERM5 = RIGHT(A.PERIOD5, 1),                                                                                                                                
 	    A.SCALAR5 = CONVERT(INTEGER, SUBSTRING(A.PERIOD5, 1, LEN(A.PERIOD5)-1)),                                                                                      
                                                                                                                                                                      
 		A.TERM6 = RIGHT(A.PERIOD6, 1),                                                                                                                                
 	    A.SCALAR6 = CONVERT(INTEGER, SUBSTRING(A.PERIOD6, 1, LEN(A.PERIOD6)-1)),                                                                                      
                                                                                                                                                                      
 		A.TERM7 = RIGHT(A.PERIOD7, 1),                                                                                                                                
 	    A.SCALAR7 = CONVERT(INTEGER, SUBSTRING(A.PERIOD7, 1, LEN(A.PERIOD7)-1)),                                                                                      
                                                                                                                                                                      
 		A.TERM8 = RIGHT(A.PERIOD8, 1),                                                                                                                                
 	    A.SCALAR8 = CONVERT(INTEGER, SUBSTRING(A.PERIOD8, 1, LEN(A.PERIOD8)-1)),                                                                                      
                                                                                                                                                                      
 		A.TERM9 = RIGHT(A.PERIOD9, 1),                                                                                                                                
 	    A.SCALAR9 = CONVERT(INTEGER, SUBSTRING(A.PERIOD9, 1, LEN(A.PERIOD9)-1))                                                                                       
 FROM #TEMP_REVP_MID A                                                                                                                                                
                                                                                                                                                                      
 --BID                                                                                                                                                                
 UPDATE A                                                                                                                                                             
 	SET A.TERM1 = RIGHT(A.PERIOD1, 1),                                                                                                                                
 	    A.SCALAR1 = CONVERT(INTEGER, SUBSTRING(A.PERIOD1, 1, LEN(A.PERIOD1)-1)),                                                                                      
                                                                                                                                                                      
 		A.TERM2 = RIGHT(A.PERIOD2, 1),                                                                                                                                
 	    A.SCALAR2 = CONVERT(INTEGER, SUBSTRING(A.PERIOD2, 1, LEN(A.PERIOD2)-1)),                                                                                      
                                                                                                                                                                      
 		A.TERM3 = RIGHT(A.PERIOD3, 1),                                                                                                                                
 	    A.SCALAR3 = CONVERT(INTEGER, SUBSTRING(A.PERIOD3, 1, LEN(A.PERIOD3)-1)),                                                                                      
                                                                                                                                                                      
 		A.TERM4 = RIGHT(A.PERIOD4, 1),                                                                                                                                
 	    A.SCALAR4 = CONVERT(INTEGER, SUBSTRING(A.PERIOD4, 1, LEN(A.PERIOD4)-1)),                                                                                      
                                                                                                                                                                      
 		A.TERM5 = RIGHT(A.PERIOD5, 1),                                                                                                                                
 	    A.SCALAR5 = CONVERT(INTEGER, SUBSTRING(A.PERIOD5, 1, LEN(A.PERIOD5)-1)),                                                                                      
                                                                                                                                                                      
 		A.TERM6 = RIGHT(A.PERIOD6, 1),                                                                                                                                
 	    A.SCALAR6 = CONVERT(INTEGER, SUBSTRING(A.PERIOD6, 1, LEN(A.PERIOD6)-1)),                                                                                      
                                                                                                                                                                      
 		A.TERM7 = RIGHT(A.PERIOD7, 1),                                                                                                                                
 	    A.SCALAR7 = CONVERT(INTEGER, SUBSTRING(A.PERIOD7, 1, LEN(A.PERIOD7)-1)),                                                                                      
                                                                                                                                                                      
 		A.TERM8 = RIGHT(A.PERIOD8, 1),                                                                                                                                
 	    A.SCALAR8 = CONVERT(INTEGER, SUBSTRING(A.PERIOD8, 1, LEN(A.PERIOD8)-1)),                                                                                      
                                                                                                                                                                      
 		A.TERM9 = RIGHT(A.PERIOD9, 1),                                                                                                                                
 	    A.SCALAR9 = CONVERT(INTEGER, SUBSTRING(A.PERIOD9, 1, LEN(A.PERIOD9)-1))                                                                                       
 FROM #TEMP_REVP_BID A                                                                                                                                                
                                                                                                                                                                      
                                                                                                                                                                      
 --OFF                                                                                                                                                                
 UPDATE A                                                                                                                                                             
 	SET A.TERM1 = RIGHT(A.PERIOD1, 1),                                                                                                                                
 	    A.SCALAR1 = CONVERT(INTEGER, SUBSTRING(A.PERIOD1, 1, LEN(A.PERIOD1)-1)),                                                                                      
                                                                                                                                                                      
 		A.TERM2 = RIGHT(A.PERIOD2, 1),                                                                                                                                
 	    A.SCALAR2 = CONVERT(INTEGER, SUBSTRING(A.PERIOD2, 1, LEN(A.PERIOD2)-1)),                                                                                      
                                                                                                                                                                      
 		A.TERM3 = RIGHT(A.PERIOD3, 1),                                                                                                                                
 	    A.SCALAR3 = CONVERT(INTEGER, SUBSTRING(A.PERIOD3, 1, LEN(A.PERIOD3)-1)),                                                                                      
                                                                                                                                                                      
 		A.TERM4 = RIGHT(A.PERIOD4, 1),                                                                                                                                
 	    A.SCALAR4 = CONVERT(INTEGER, SUBSTRING(A.PERIOD4, 1, LEN(A.PERIOD4)-1)),                                                                                      
                                                                                                                                                                      
 		A.TERM5 = RIGHT(A.PERIOD5, 1),                                                                                                                                
 	    A.SCALAR5 = CONVERT(INTEGER, SUBSTRING(A.PERIOD5, 1, LEN(A.PERIOD5)-1)),                                                                                      
                                                                                                                                                                      
 		A.TERM6 = RIGHT(A.PERIOD6, 1),                                                                                                                                
 	    A.SCALAR6 = CONVERT(INTEGER, SUBSTRING(A.PERIOD6, 1, LEN(A.PERIOD6)-1)),                                                                                      
                                                                                                                                                                      
 		A.TERM7 = RIGHT(A.PERIOD7, 1),                                                                                                                                
 	    A.SCALAR7 = CONVERT(INTEGER, SUBSTRING(A.PERIOD7, 1, LEN(A.PERIOD7)-1)),                                                                                      
                                                                                                                                                                      
 		A.TERM8 = RIGHT(A.PERIOD8, 1),                                                                                                                                
 	    A.SCALAR8 = CONVERT(INTEGER, SUBSTRING(A.PERIOD8, 1, LEN(A.PERIOD8)-1)),                                                                                      
                                                                                                                                                                      
 		A.TERM9 = RIGHT(A.PERIOD9, 1),                                                                                                                                
 	    A.SCALAR9 = CONVERT(INTEGER, SUBSTRING(A.PERIOD9, 1, LEN(A.PERIOD9)-1))                                                                                       
 FROM #TEMP_REVP_OFF A                                                                                                                                                
                                                                                                                                                                      
                                                                                                                                                                      
                                                                                                                                                                      
 --JOIN KE FX UNTUK CCY                                                                                                                                               
 SELECT A.*                                                                                                                                                           
 INTO #TEMP_FX_FWD_RATE                                                                                                                                               
 FROM                                                                                                                                                                 
 (                                                                                                                                                                    
 	SELECT 'CCY' FXTYPE,                                                                                                                                              
 		   A.DEALNO,                                                                                                                                                  
 		   A.ORIGOCAMT,                                                                                                                                               
 		   A.CUST,                                                                                                                                                    
 		   A.CCY CCYMAIN,                                                                                                                                             
 		   A.CTRCCY CCYCTR,                                                                                                                                           
 		   A.CCYAMT AMT,                                                                                                                                              
 		   A.VDATE,                                                                                                                                                   
 		   A.CCYBAMT,                                                                                                                                                 
 		   A.CTRBAMT,                                                                                                                                                 
 		   A.DEALDATE,                                                                                                                                                
 		   A.PS,                                                                                                                                                      
 		   CASE WHEN A.PS = 'P' THEN B.CCY ELSE C.CCY END CCY,                                                                                                        
 		   CASE WHEN A.PS = 'P' THEN B.MATDATESPOT ELSE C.MATDATESPOT END MATDATESPOT,                                                                                
 		   CASE WHEN A.PS = 'P' THEN B.SPOTRATE_8 ELSE C.SPOTRATE_8 END SPOTRATE_8,                                                                                   
                                                                                                                                                                      
 		   CASE WHEN A.PS = 'P' THEN B.PERIOD1 ELSE C.PERIOD1 END PERIOD1,                                                                                            
 		   CASE WHEN A.PS = 'P' THEN B.SCALAR1 ELSE C.SCALAR1 END SCALAR1,                                                                                            
 		   CASE WHEN A.PS = 'P' THEN B.TERM1 ELSE C.TERM1 END TERM1,                                                                                                  
 		   CASE WHEN A.PS = 'P' THEN B.MATDATE1 ELSE C.MATDATE1 END MATDATE1,                                                                                         
 		   CASE WHEN A.PS = 'P' THEN B.RATE1 ELSE C.RATE1 END RATE1,                                                                                                  
                                                                                                                                                                      
 		   CASE WHEN A.PS = 'P' THEN B.PERIOD2 ELSE C.PERIOD2 END PERIOD2,                                                                                            
 		   CASE WHEN A.PS = 'P' THEN B.SCALAR2 ELSE C.SCALAR2 END SCALAR2,                                                                                            
 		   CASE WHEN A.PS = 'P' THEN B.TERM2 ELSE C.TERM2 END TERM2,                                                                                                  
 		   CASE WHEN A.PS = 'P' THEN B.MATDATE2 ELSE C.MATDATE2 END MATDATE2,                                                                                         
 		   CASE WHEN A.PS = 'P' THEN B.RATE2 ELSE C.RATE2 END RATE2,                                                                                                  
                                                                                                                                                                      
 		   CASE WHEN A.PS = 'P' THEN B.PERIOD3 ELSE C.PERIOD3 END PERIOD3,                                                                                            
 		   CASE WHEN A.PS = 'P' THEN B.SCALAR3 ELSE C.SCALAR3 END SCALAR3,                                                                                            
 		   CASE WHEN A.PS = 'P' THEN B.TERM3 ELSE C.TERM3 END TERM3,                                                                                                  
 		   CASE WHEN A.PS = 'P' THEN B.MATDATE3 ELSE C.MATDATE3 END MATDATE3,                                                                                         
 		   CASE WHEN A.PS = 'P' THEN B.RATE3 ELSE C.RATE3 END RATE3,                                                                                                  
                                                                                                                                                                      
 		   CASE WHEN A.PS = 'P' THEN B.PERIOD4 ELSE C.PERIOD4 END PERIOD4,                                                                                            
 		   CASE WHEN A.PS = 'P' THEN B.SCALAR4 ELSE C.SCALAR4 END SCALAR4,                                                                                            
 		   CASE WHEN A.PS = 'P' THEN B.TERM4 ELSE C.TERM4 END TERM4,                                                                                                  
 		   CASE WHEN A.PS = 'P' THEN B.MATDATE4 ELSE C.MATDATE4 END MATDATE4,                                                                                         
 		   CASE WHEN A.PS = 'P' THEN B.RATE4 ELSE C.RATE4 END RATE4,                                                                                                  
                                                                                                                                                                      
 		   CASE WHEN A.PS = 'P' THEN B.PERIOD5 ELSE C.PERIOD5 END PERIOD5,                                                                                            
 		   CASE WHEN A.PS = 'P' THEN B.SCALAR5 ELSE C.SCALAR5 END SCALAR5,                                                                                            
 		   CASE WHEN A.PS = 'P' THEN B.TERM5 ELSE C.TERM5 END TERM5,                                                                                                  
 		   CASE WHEN A.PS = 'P' THEN B.MATDATE5 ELSE C.MATDATE5 END MATDATE5,                                                                                         
 		   CASE WHEN A.PS = 'P' THEN B.RATE5 ELSE C.RATE5 END RATE5,                                                                                                  
                                                                                                                                                                      
 		   CASE WHEN A.PS = 'P' THEN B.PERIOD6 ELSE C.PERIOD6 END PERIOD6,                                                                                            
 		   CASE WHEN A.PS = 'P' THEN B.SCALAR6 ELSE C.SCALAR6 END SCALAR6,                                                                                            
 		   CASE WHEN A.PS = 'P' THEN B.TERM6 ELSE C.TERM6 END TERM6,                                                                                                  
 		   CASE WHEN A.PS = 'P' THEN B.MATDATE6 ELSE C.MATDATE6 END MATDATE6,                                                                                         
 		   CASE WHEN A.PS = 'P' THEN B.RATE6 ELSE C.RATE6 END RATE6,                                                                                                  
                                                                                                                                                                      
 		   CASE WHEN A.PS = 'P' THEN B.PERIOD7 ELSE C.PERIOD7 END PERIOD7,                                                                                            
 		   CASE WHEN A.PS = 'P' THEN B.SCALAR7 ELSE C.SCALAR7 END SCALAR7,                                                                                            
 		   CASE WHEN A.PS = 'P' THEN B.TERM7 ELSE C.TERM7 END TERM7,                                                                                                  
 		   CASE WHEN A.PS = 'P' THEN B.MATDATE7 ELSE C.MATDATE7 END MATDATE7,                                                                                         
 		   CASE WHEN A.PS = 'P' THEN B.RATE7 ELSE C.RATE7 END RATE7,                                                                                                  
                                                                                                                                                                      
 		   CASE WHEN A.PS = 'P' THEN B.PERIOD8 ELSE C.PERIOD8 END PERIOD8,                                                                                            
 		   CASE WHEN A.PS = 'P' THEN B.SCALAR8 ELSE C.SCALAR8 END SCALAR8,                                                                                            
 		   CASE WHEN A.PS = 'P' THEN B.TERM8 ELSE C.TERM8 END TERM8,                                                                                                  
 		   CASE WHEN A.PS = 'P' THEN B.MATDATE8 ELSE C.MATDATE8 END MATDATE8,                                                                                         
 		   CASE WHEN A.PS = 'P' THEN B.RATE8 ELSE C.RATE8 END RATE8,                                                                                                  
                                                                                                                                                                      
 		   CASE WHEN A.PS = 'P' THEN B.PERIOD9 ELSE C.PERIOD9 END PERIOD9,                                                                                            
 		   CASE WHEN A.PS = 'P' THEN B.SCALAR9 ELSE C.SCALAR9 END SCALAR9,                                                                                            
 		   CASE WHEN A.PS = 'P' THEN B.TERM9 ELSE C.TERM9 END TERM9,                                                                                                  
 		   CASE WHEN A.PS = 'P' THEN B.MATDATE9 ELSE C.MATDATE9 END MATDATE9,                                                                                         
 		   CASE WHEN A.PS = 'P' THEN B.RATE9 ELSE C.RATE9 END RATE9                                                                                                   
 	FROM #TEMP_FX_FWD A                                                                                                                                               
                                                                                                                                                                      
 	LEFT JOIN #TEMP_REVP_BID B                                                                                                                                        
 	ON A.CCY = B.CCY                                                                                                                                                  
                                                                                                                                                                      
 	LEFT JOIN #TEMP_REVP_OFF C                                                                                                                                        
 	ON A.CCY = C.CCY                                                                                                                                                  
                                                                                                                                                                      
 	UNION ALL                                                                                                                                                         
                                                                                                                                                                      
 	SELECT 'CTR' FXTYPE,                                                                                                                                              
 		   A.DEALNO,                                                                                                                                                  
 		   A.ORIGOCAMT,                                                                                                                                               
 		   A.CUST,                                                                                                                                                    
 		   A.CTRCCY CCYMAIN,                                                                                                                                          
 		   A.CCY CCYCTR,                                                                                                                                              
 		   A.CTRAMT AMT,                                                                                                                                              
 		   A.VDATE,                                                                                                                                                   
 		   A.CCYBAMT,                                                                                                                                                 
 		   A.CTRBAMT,                                                                                                                                                 
 		   A.DEALDATE,                                                                                                                                                
 		   A.PS,                                                                                                                                                      
 		   CASE WHEN A.PS = 'S' THEN B.CCY ELSE C.CCY END CCY,                                                                                                        
 		   CASE WHEN A.PS = 'S' THEN B.MATDATESPOT ELSE C.MATDATESPOT END MATDATESPOT,                                                                                
 		   CASE WHEN A.PS = 'S' THEN B.SPOTRATE_8 ELSE C.SPOTRATE_8 END SPOTRATE_8,                                                                                   
                                                                                                                                                                      
 		   CASE WHEN A.PS = 'S' THEN B.PERIOD1 ELSE C.PERIOD1 END PERIOD1,                                                                                            
 		   CASE WHEN A.PS = 'S' THEN B.SCALAR1 ELSE C.SCALAR1 END SCALAR1,                                                                                            
 		   CASE WHEN A.PS = 'S' THEN B.TERM1 ELSE C.TERM1 END TERM1,                                                                                                  
 		   CASE WHEN A.PS = 'S' THEN B.MATDATE1 ELSE C.MATDATE1 END MATDATE1,                                                                                         
 		   CASE WHEN A.PS = 'S' THEN B.RATE1 ELSE C.RATE1 END RATE1,                                                                                                  
                                                                                                                                                                      
 		   CASE WHEN A.PS = 'S' THEN B.PERIOD2 ELSE C.PERIOD2 END PERIOD2,                                                                                            
 		   CASE WHEN A.PS = 'S' THEN B.SCALAR2 ELSE C.SCALAR2 END SCALAR2,                                                                                            
 		   CASE WHEN A.PS = 'S' THEN B.TERM2 ELSE C.TERM2 END TERM2,                                                                                                  
 		   CASE WHEN A.PS = 'S' THEN B.MATDATE2 ELSE C.MATDATE2 END MATDATE2,                                                                                         
 		   CASE WHEN A.PS = 'S' THEN B.RATE2 ELSE C.RATE2 END RATE2,                                                                                                  
                                                                                                                                                                      
 		   CASE WHEN A.PS = 'S' THEN B.PERIOD3 ELSE C.PERIOD3 END PERIOD3,                                                                                            
 		   CASE WHEN A.PS = 'S' THEN B.SCALAR3 ELSE C.SCALAR3 END SCALAR3,                                                                                            
 		   CASE WHEN A.PS = 'S' THEN B.TERM3 ELSE C.TERM3 END TERM3,                                                                                                  
 		   CASE WHEN A.PS = 'S' THEN B.MATDATE3 ELSE C.MATDATE3 END MATDATE3,                                                                                         
 		   CASE WHEN A.PS = 'S' THEN B.RATE3 ELSE C.RATE3 END RATE3,                                                                                                  
                                                                                                                                                                      
 		   CASE WHEN A.PS = 'S' THEN B.PERIOD4 ELSE C.PERIOD4 END PERIOD4,                                                                                            
 		   CASE WHEN A.PS = 'S' THEN B.SCALAR4 ELSE C.SCALAR4 END SCALAR4,                                                                                            
 		   CASE WHEN A.PS = 'S' THEN B.TERM4 ELSE C.TERM4 END TERM4,                                                                                                  
 		   CASE WHEN A.PS = 'S' THEN B.MATDATE4 ELSE C.MATDATE4 END MATDATE4,                                                                                         
 		   CASE WHEN A.PS = 'S' THEN B.RATE4 ELSE C.RATE4 END RATE4,                                                                                                  
                                                                                                                                                                      
 		   CASE WHEN A.PS = 'S' THEN B.PERIOD5 ELSE C.PERIOD5 END PERIOD5,                                                                                            
 		   CASE WHEN A.PS = 'S' THEN B.SCALAR5 ELSE C.SCALAR5 END SCALAR5,                                                                                            
 		   CASE WHEN A.PS = 'S' THEN B.TERM5 ELSE C.TERM5 END TERM5,                                                                                                  
 		   CASE WHEN A.PS = 'S' THEN B.MATDATE5 ELSE C.MATDATE5 END MATDATE5,                                                                                         
 		   CASE WHEN A.PS = 'S' THEN B.RATE5 ELSE C.RATE5 END RATE5,                                                                                                  
                                                                                                                                                                      
 		   CASE WHEN A.PS = 'S' THEN B.PERIOD6 ELSE C.PERIOD6 END PERIOD6,                                                                                            
 		   CASE WHEN A.PS = 'S' THEN B.SCALAR6 ELSE C.SCALAR6 END SCALAR6,                                                                                            
 		   CASE WHEN A.PS = 'S' THEN B.TERM6 ELSE C.TERM6 END TERM6,                                                                                                  
 		   CASE WHEN A.PS = 'S' THEN B.MATDATE6 ELSE C.MATDATE6 END MATDATE6,                                                                                         
 		   CASE WHEN A.PS = 'S' THEN B.RATE6 ELSE C.RATE6 END RATE6,                                                                                                  
                                                                                                                                                                      
 		   CASE WHEN A.PS = 'S' THEN B.PERIOD7 ELSE C.PERIOD7 END PERIOD7,                                                                                            
 		   CASE WHEN A.PS = 'S' THEN B.SCALAR7 ELSE C.SCALAR7 END SCALAR7,                                                                                            
 		   CASE WHEN A.PS = 'S' THEN B.TERM7 ELSE C.TERM7 END TERM7,                                                                                                  
 		   CASE WHEN A.PS = 'S' THEN B.MATDATE7 ELSE C.MATDATE7 END MATDATE7,                                                                                         
 		   CASE WHEN A.PS = 'S' THEN B.RATE7 ELSE C.RATE7 END RATE7,                                                                                                  
                                                                                                                                                                      
 		   CASE WHEN A.PS = 'S' THEN B.PERIOD8 ELSE C.PERIOD8 END PERIOD8,                                                                                            
 		   CASE WHEN A.PS = 'S' THEN B.SCALAR8 ELSE C.SCALAR8 END SCALAR8,                                                                                            
 		   CASE WHEN A.PS = 'S' THEN B.TERM8 ELSE C.TERM8 END TERM8,                                                                                                  
 		   CASE WHEN A.PS = 'S' THEN B.MATDATE8 ELSE C.MATDATE8 END MATDATE8,                                                                                         
 		   CASE WHEN A.PS = 'S' THEN B.RATE8 ELSE C.RATE8 END RATE8,                                                                                                  
                                                                                                                                                                      
 		   CASE WHEN A.PS = 'S' THEN B.PERIOD9 ELSE C.PERIOD9 END PERIOD9,                                                                                            
 		   CASE WHEN A.PS = 'S' THEN B.SCALAR9 ELSE C.SCALAR9 END SCALAR9,                                                                                            
 		   CASE WHEN A.PS = 'S' THEN B.TERM9 ELSE C.TERM9 END TERM9,                                                                                                  
 		   CASE WHEN A.PS = 'S' THEN B.MATDATE9 ELSE C.MATDATE9 END MATDATE9,                                                                                         
 		   CASE WHEN A.PS = 'S' THEN B.RATE9 ELSE C.RATE9 END RATE9                                                                                                   
 	FROM #TEMP_FX_FWD A                                                                                                                                               
                                                                                                                                                                      
 	LEFT JOIN #TEMP_REVP_BID B                                                                                                                                        
 	ON A.CTRCCY = B.CCY                                                                                                                                               
                                                                                                                                                                      
 	LEFT JOIN #TEMP_REVP_OFF C                                                                                                                                        
 	ON A.CTRCCY = C.CCY                                                                                                                                               
 )A                                                                                                                                                                   
                                                                                                                                                                      
                                                                                                                                                                      
                                                                                                                                                                      
 --CHECKING SPOTDATE /HOLIDAY, UPDATE DEUDATEX SEBAGAI SPOTDATE TERLEBIH DAHULU(KARENA PENENTUAN W/M/Y DARI SPOTDATE)                                                 
 UPDATE A                                                                                                                                                             
 	SET A.MATDATESPOT = dbo.GET_SPOT_FX(A.MATDATESPOT, A.FXTYPE, A.CCYMAIN, A.CCYCTR, 2),                                                                             
 	       A.MATDATE1 = dbo.GET_SPOT_FX(A.MATDATE1, A.FXTYPE, A.CCYMAIN, A.CCYCTR, 2),                                                                                
 		   A.MATDATE2 = dbo.GET_SPOT_FX(A.MATDATE2, A.FXTYPE, A.CCYMAIN, A.CCYCTR, 2),                                                                                
 		   A.MATDATE3 = dbo.GET_SPOT_FX(A.MATDATE3, A.FXTYPE, A.CCYMAIN, A.CCYCTR, 2),                                                                                
 		   A.MATDATE4 = dbo.GET_SPOT_FX(A.MATDATE4, A.FXTYPE, A.CCYMAIN, A.CCYCTR, 2),                                                                                
 		   A.MATDATE5 = dbo.GET_SPOT_FX(A.MATDATE5, A.FXTYPE, A.CCYMAIN, A.CCYCTR, 2),                                                                                
 		   A.MATDATE6 = dbo.GET_SPOT_FX(A.MATDATE6, A.FXTYPE, A.CCYMAIN, A.CCYCTR, 2),                                                                                
 		   A.MATDATE7 = dbo.GET_SPOT_FX(A.MATDATE7, A.FXTYPE, A.CCYMAIN, A.CCYCTR, 2),                                                                                
 		   A.MATDATE8 = dbo.GET_SPOT_FX(A.MATDATE8, A.FXTYPE, A.CCYMAIN, A.CCYCTR, 2),                                                                                
 		   A.MATDATE9 = dbo.GET_SPOT_FX(A.MATDATE9, A.FXTYPE, A.CCYMAIN, A.CCYCTR, 2)                                                                                 
 FROM #TEMP_FX_FWD_RATE A                                                                                                                                             
                                                                                                                                                                      
                                                                                                                                                                      
                                                                                                                                                                      
                                                                                                                                                                      
 --UPDATE MATURITY DATE                                                                                                                                               
 UPDATE A                                                                                                                                                             
 	SET A.MATDATE1 = dbo.GET_MATDATE_FX(A.MATDATE1, A.SCALAR1, A.TERM1),                                                                                              
         A.MATDATE2 = dbo.GET_MATDATE_FX(A.MATDATE2, A.SCALAR2, A.TERM2),                                                                                             
         A.MATDATE3 = dbo.GET_MATDATE_FX(A.MATDATE3, A.SCALAR3, A.TERM3),                                                                                             
 	    A.MATDATE4 = dbo.GET_MATDATE_FX(A.MATDATE4, A.SCALAR4, A.TERM4),                                                                                              
 		A.MATDATE5 = dbo.GET_MATDATE_FX(A.MATDATE5, A.SCALAR5, A.TERM5),                                                                                              
 	    A.MATDATE6 = dbo.GET_MATDATE_FX(A.MATDATE6, A.SCALAR6, A.TERM6),                                                                                              
 		A.MATDATE7 = dbo.GET_MATDATE_FX(A.MATDATE7, A.SCALAR7, A.TERM7),                                                                                              
 		A.MATDATE8 = dbo.GET_MATDATE_FX(A.MATDATE8, A.SCALAR8, A.TERM8),                                                                                              
 		A.MATDATE9 = dbo.GET_MATDATE_FX(A.MATDATE9, A.SCALAR9, A.TERM9)                                                                                               
                                                                                                                                                                      
 FROM #TEMP_FX_FWD_RATE A                                                                                                                                             
                                                                                                                                                                      
                                                                                                                                                                      
                                                                                                                                                                      
 --CHECKING HOLIDAY UNTUK MATURITY DATE                                                                                                                               
 UPDATE A                                                                                                                                                             
 	SET A.MATDATE1 = dbo.GET_NONHOLIDATE_FX(MATDATE1, A.FXTYPE, A.CCYMAIN, A.CCYCTR, A.TERM1),                                                                        
 		A.MATDATE2 = dbo.GET_NONHOLIDATE_FX(MATDATE2, A.FXTYPE, A.CCYMAIN, A.CCYCTR, A.TERM2),                                                                        
 		A.MATDATE3 = dbo.GET_NONHOLIDATE_FX(MATDATE3, A.FXTYPE, A.CCYMAIN, A.CCYCTR, A.TERM3),                                                                        
 		A.MATDATE4 = dbo.GET_NONHOLIDATE_FX(MATDATE4, A.FXTYPE, A.CCYMAIN, A.CCYCTR, A.TERM4),                                                                        
 		A.MATDATE5 = dbo.GET_NONHOLIDATE_FX(MATDATE5, A.FXTYPE, A.CCYMAIN, A.CCYCTR, A.TERM5),                                                                        
 		A.MATDATE6 = dbo.GET_NONHOLIDATE_FX(MATDATE6, A.FXTYPE, A.CCYMAIN, A.CCYCTR, A.TERM6),                                                                        
 		A.MATDATE7 = dbo.GET_NONHOLIDATE_FX(MATDATE7, A.FXTYPE, A.CCYMAIN, A.CCYCTR, A.TERM7),                                                                        
 		A.MATDATE8 = dbo.GET_NONHOLIDATE_FX(MATDATE8, A.FXTYPE, A.CCYMAIN, A.CCYCTR, A.TERM8),                                                                        
 		A.MATDATE9 = dbo.GET_NONHOLIDATE_FX(MATDATE9, A.FXTYPE, A.CCYMAIN, A.CCYCTR, A.TERM9)                                                                         
 FROM #TEMP_FX_FWD_RATE A                                                                                                                                             
                                                                                                                                                                      
                                                                                                                                                                      
                                                                                                                                                                      
 --SET NULL UNTUK PERIODE YANG TERMS NYA NULL                                                                                                                         
 UPDATE A                                                                                                                                                             
 	SET A.MATDATE1 = CASE WHEN A.SCALAR1 = 0 THEN NULL ELSE MATDATE1 END,                                                                                             
 		A.MATDATE2 = CASE WHEN A.SCALAR2 = 0 THEN NULL ELSE MATDATE2 END,                                                                                             
 		A.MATDATE3 = CASE WHEN A.SCALAR3 = 0 THEN NULL ELSE MATDATE3 END,                                                                                             
 		A.MATDATE4 = CASE WHEN A.SCALAR4 = 0 THEN NULL ELSE MATDATE4 END,                                                                                             
 		A.MATDATE5 = CASE WHEN A.SCALAR5 = 0 THEN NULL ELSE MATDATE5 END,                                                                                             
 		A.MATDATE6 = CASE WHEN A.SCALAR6 = 0 THEN NULL ELSE MATDATE6 END,                                                                                             
 		A.MATDATE7 = CASE WHEN A.SCALAR7 = 0 THEN NULL ELSE MATDATE7 END,                                                                                             
 		A.MATDATE8 = CASE WHEN A.SCALAR8 = 0 THEN NULL ELSE MATDATE8 END,                                                                                             
 		A.MATDATE9 = CASE WHEN A.SCALAR9 = 0 THEN NULL ELSE MATDATE9 END                                                                                              
                                                                                                                                                                      
 FROM #TEMP_FX_FWD_RATE A                                                                                                                                             
                                                                                                                                                                      
                                                                                                                                                                      
                                                                                                                                                                      
                                                                                                                                                                      
                                                                                                                                                                      
 -- HITUNG REGRESI, MENENTUKAN POSISI VALUE DATE                                                                                                                      
 SELECT A.FXTYPE,                                                                                                                                                     
        A.DEALNO,                                                                                                                                                     
 	   A.CUST,                                                                                                                                                        
 	   A.ORIGOCAMT,                                                                                                                                                   
        A.CCYMAIN,                                                                                                                                                    
 	   A.CCYCTR,                                                                                                                                                      
 	   A.AMT,                                                                                                                                                         
 	   A.VDATE,                                                                                                                                                       
 	   A.PS,                                                                                                                                                          
 	   A.CCYBAMT,                                                                                                                                                     
 	   A.CTRBAMT,                                                                                                                                                     
 	   A.DEALDATE,                                                                                                                                                    
 	   A.SPOTRATE_8,                                                                                                                                                  
        CASE WHEN A.VDATE <= A.MATDATESPOT THEN DATEADD(DAY, -1, A.MATDATESPOT)                                                                                       
 		    WHEN A.VDATE BETWEEN A.MATDATE1 AND A.MATDATE2 THEN A.MATDATE1                                                                                            
 	        WHEN A.VDATE BETWEEN A.MATDATE2 AND A.MATDATE3 THEN A.MATDATE2                                                                                            
 			WHEN A.VDATE BETWEEN A.MATDATE3 AND A.MATDATE4 THEN A.MATDATE3                                                                                            
 			WHEN A.VDATE BETWEEN A.MATDATE4 AND A.MATDATE5 THEN A.MATDATE4                                                                                            
 			WHEN A.VDATE BETWEEN A.MATDATE5 AND A.MATDATE6 THEN A.MATDATE5                                                                                            
 			WHEN A.VDATE BETWEEN A.MATDATE6 AND A.MATDATE7 THEN A.MATDATE6                                                                                            
 			WHEN A.VDATE BETWEEN A.MATDATE7 AND A.MATDATE8 THEN A.MATDATE7                                                                                            
 			WHEN A.VDATE BETWEEN A.MATDATE8 AND A.MATDATE9 THEN A.MATDATE8                                                                                            
 		END DATE_LOWER,                                                                                                                                               
 		CASE WHEN A.VDATE <= A.MATDATESPOT THEN A.MATDATESPOT                                                                                                         
 			 WHEN A.VDATE BETWEEN A.MATDATE1 AND A.MATDATE2 THEN A.MATDATE2                                                                                           
 	         WHEN A.VDATE BETWEEN A.MATDATE2 AND A.MATDATE3 THEN A.MATDATE3                                                                                           
 			 WHEN A.VDATE BETWEEN A.MATDATE3 AND A.MATDATE4 THEN A.MATDATE4                                                                                           
 			 WHEN A.VDATE BETWEEN A.MATDATE4 AND A.MATDATE5 THEN A.MATDATE5                                                                                           
 			 WHEN A.VDATE BETWEEN A.MATDATE5 AND A.MATDATE6 THEN A.MATDATE6                                                                                           
 			 WHEN A.VDATE BETWEEN A.MATDATE6 AND A.MATDATE7 THEN A.MATDATE7                                                                                           
 			 WHEN A.VDATE BETWEEN A.MATDATE7 AND A.MATDATE8 THEN A.MATDATE8                                                                                           
 			 WHEN A.VDATE BETWEEN A.MATDATE8 AND A.MATDATE9 THEN A.MATDATE9                                                                                           
 		END DATE_UPPER,                                                                                                                                               
 		CASE WHEN A.VDATE <= A.MATDATESPOT THEN A.SPOTRATE_8                                                                                                          
 			 WHEN A.VDATE BETWEEN A.MATDATE1 AND A.MATDATE2 THEN A.RATE1                                                                                              
 	         WHEN A.VDATE BETWEEN A.MATDATE2 AND A.MATDATE3 THEN A.RATE2                                                                                              
 			 WHEN A.VDATE BETWEEN A.MATDATE3 AND A.MATDATE4 THEN A.RATE3                                                                                              
 			 WHEN A.VDATE BETWEEN A.MATDATE4 AND A.MATDATE5 THEN A.RATE4                                                                                              
 			 WHEN A.VDATE BETWEEN A.MATDATE5 AND A.MATDATE6 THEN A.RATE5                                                                                              
 			 WHEN A.VDATE BETWEEN A.MATDATE6 AND A.MATDATE7 THEN A.RATE6                                                                                              
 			 WHEN A.VDATE BETWEEN A.MATDATE7 AND A.MATDATE8 THEN A.RATE7                                                                                              
 			 WHEN A.VDATE BETWEEN A.MATDATE8 AND A.MATDATE9 THEN A.RATE8                                                                                              
 		END RATE_LOWER,                                                                                                                                               
 		CASE WHEN A.VDATE <= A.MATDATESPOT THEN A.SPOTRATE_8                                                                                                          
 			 WHEN A.VDATE BETWEEN A.MATDATE1 AND A.MATDATE2 THEN A.RATE2                                                                                              
 	         WHEN A.VDATE BETWEEN A.MATDATE2 AND A.MATDATE3 THEN A.RATE3                                                                                              
 			 WHEN A.VDATE BETWEEN A.MATDATE3 AND A.MATDATE4 THEN A.RATE4                                                                                              
 			 WHEN A.VDATE BETWEEN A.MATDATE4 AND A.MATDATE5 THEN A.RATE5                                                                                              
 			 WHEN A.VDATE BETWEEN A.MATDATE5 AND A.MATDATE6 THEN A.RATE6                                                                                              
 			 WHEN A.VDATE BETWEEN A.MATDATE6 AND A.MATDATE7 THEN A.RATE7                                                                                              
 			 WHEN A.VDATE BETWEEN A.MATDATE7 AND A.MATDATE8 THEN A.RATE8                                                                                              
 			 WHEN A.VDATE BETWEEN A.MATDATE8 AND A.MATDATE9 THEN A.RATE9                                                                                              
 		END RATE_UPPER                                                                                                                                                
 INTO #TEMP_REGRESSION                                                                                                                                                
 FROM #TEMP_FX_FWD_RATE A                                                                                                                                             
                                                                                                                                                                      
                                                                                                                                                                      
                                                                                                                                                                      
 --HITUNG RATE AKHIR                                                                                                                                                  
 SELECT A.FXTYPE,                                                                                                                                                     
        A.DEALNO,                                                                                                                                                     
 	   A.ORIGOCAMT,                                                                                                                                                   
 	   A.CUST,                                                                                                                                                        
        A.CCYMAIN,                                                                                                                                                    
 	   A.CCYCTR,                                                                                                                                                      
 	   A.AMT,                                                                                                                                                         
 	   A.VDATE,                                                                                                                                                       
 	   A.CCYBAMT,                                                                                                                                                     
 	   A.CTRBAMT,                                                                                                                                                     
 	   A.DEALDATE,                                                                                                                                                    
 	   A.PS,                                                                                                                                                          
 	   A.DELTA_Y,                                                                                                                                                     
 	   A.DELTA_X,                                                                                                                                                     
 	   A.DX,                                                                                                                                                          
 	   A.RATE_LOWER,                                                                                                                                                  
 	   A.SPOTRATE_8,                                                                                                                                                  
 	   CASE WHEN A.DELTA_X <> 0                                                                                                                                       
 				THEN A.RATE_LOWER + (A.DELTA_Y/A.DELTA_X)*DX                                                                                                          
 			ELSE A.RATE_LOWER                                                                                                                                         
 	   END RATE_FINAL,                                                                                                                                                
 	   ROUND(CASE WHEN A.DELTA_X <> 0                                                                                                                                 
 						THEN A.RATE_LOWER + (A.DELTA_Y/A.DELTA_X)*DX                                                                                                  
 					ELSE A.RATE_LOWER                                                                                                                                 
 			 END * A.AMT, 0) REVALAMT                                                                                                                                 
 INTO #TEMP_FXFINAL                                                                                                                                                   
 FROM                                                                                                                                                                 
 (                                                                                                                                                                    
 	SELECT A.FXTYPE,                                                                                                                                                  
 	       A.DEALNO,                                                                                                                                                  
 		   A.ORIGOCAMT,                                                                                                                                               
 		   A.CUST,                                                                                                                                                    
 		   A.CCYMAIN,                                                                                                                                                 
 		   A.CCYCTR,                                                                                                                                                  
 		   A.AMT,                                                                                                                                                     
 		   A.VDATE,                                                                                                                                                   
 		   A.CCYBAMT,                                                                                                                                                 
 		   A.CTRBAMT,                                                                                                                                                 
 		   A.DEALDATE,                                                                                                                                                
 		   A.PS,                                                                                                                                                      
 		   A.SPOTRATE_8,                                                                                                                                              
 		   DATE_LOWER,                                                                                                                                                
 		   DATE_UPPER,                                                                                                                                                
 		   A.RATE_LOWER,                                                                                                                                              
 		   A.RATE_UPPER,                                                                                                                                              
 		   A.RATE_UPPER - A.RATE_LOWER DELTA_Y,                                                                                                                       
 		   DATEDIFF(DAY, A.DATE_LOWER, A.DATE_UPPER) DELTA_X,                                                                                                         
 		   DATEDIFF(DAY, A.DATE_LOWER, A.VDATE) DX                                                                                                                    
 	FROM #TEMP_REGRESSION A                                                                                                                                           
                                                                                                                                                                      
 )A                                                                                                                                                                   
                                                                                                                                                                      
                                                                                                                                                                      
                                                                                                                                                                      
 ---- UNION WITH FX SPOT                                                                                                                                              
 SELECT A.*                                                                                                                                                           
 INTO #TEMP_PVFX                                                                                                                                                      
 FROM                                                                                                                                                                 
 (                                                                                                                                                                    
 	SELECT A.DEALNO,                                                                                                                                                  
 	       A.CUST,                                                                                                                                                    
 		   'F' SPOTFWDIND,                                                                                                                                            
 		   A.ORIGOCAMT,                                                                                                                                               
 		   A.CCYMAIN CCY,                                                                                                                                             
 		   A.REVALAMT CCYREVALAMT,                                                                                                                                    
 		   B.CCYMAIN CTRCCY,                                                                                                                                          
 		   B.REVALAMT AS CTRREVALAMT,                                                                                                                                 
 		   A.CCYBAMT,                                                                                                                                                 
 		   A.CTRBAMT,                                                                                                                                                 
 		   A.VDATE,                                                                                                                                                   
 		   A.DEALDATE,                                                                                                                                                
 		   A.PS,                                                                                                                                                      
 		   A.RATE_FINAL FINALRATECCY,                                                                                                                                 
 		   B.RATE_FINAL FINALRATECTR,                                                                                                                                 
 		   (A.RATE_FINAL - A.SPOTRATE_8)/A.SPOTRATE_8 SWAPPOINT_CCY,                                                                                                  
 		   (B.RATE_FINAL - B.SPOTRATE_8)/B.SPOTRATE_8 SWAPPOINT_CTR,                                                                                                  
 		   A.AMT CCYAMT,                                                                                                                                              
 		   B.AMT CTRAMT                                                                                                                                               
 	FROM #TEMP_FXFINAL A                                                                                                                                              
 	LEFT JOIN #TEMP_FXFINAL B                                                                                                                                         
 	ON A.DEALNO = B.DEALNO                                                                                                                                            
 	WHERE A.FXTYPE = 'CCY'                                                                                                                                            
 	AND B.FXTYPE = 'CTR'                                                                                                                                              
                                                                                                                                                                      
 	UNION ALL                                                                                                                                                         
                                                                                                                                                                      
 	SELECT A.DEALNO,                                                                                                                                                  
 	       A.CUST,                                                                                                                                                    
 		   A.SPOTFWDIND,                                                                                                                                              
 		   A.ORIGOCAMT,                                                                                                                                               
 		   A.CCY,                                                                                                                                                     
 		   A.CCYREVALAMT,                                                                                                                                             
 		   A.CTRCCY,                                                                                                                                                  
 		   A.CTRREVALAMT,                                                                                                                                             
 		   A.CCYBAMT,                                                                                                                                                 
 		   A.CTRBAMT,                                                                                                                                                 
 		   A.VDATE,                                                                                                                                                   
 		   A.DEALDATE,                                                                                                                                                
 		   A.PS,                                                                                                                                                      
 		   0.0 FINALRATECCY,                                                                                                                                          
 		   0.0 FINALRATECTR,                                                                                                                                          
 		   0.0 SWAPPOINT_CCY,                                                                                                                                         
 		   0.0 SWAPPOINT_CTR,                                                                                                                                         
 		   A.CCYAMT,                                                                                                                                                  
 		   A.CTRAMT                                                                                                                                                   
 	FROM #TEMP_FX_SPOT A                                                                                                                                              
 )A                                                                                                                                                                   
 LEFT JOIN TrxLLLTempCurrencyScreen B1                                                                                                                                
 ON A.CCY = B1.CCY COLLATE SQL_Latin1_General_CP1_CI_AS                                                                                                               
 AND B1.TransType = 'INTRA'                                                                                                                                           
                                                                                                                                                                      
 LEFT JOIN TrxLLLTempCurrencyScreen B2                                                                                                                                
 ON A.CTRCCY = B2.CCY COLLATE SQL_Latin1_General_CP1_CI_AS                                                                                                            
 AND B2.TransType = 'INTRA'                                                                                                                                           
                                                                                                                                                                      
                                                                                                                                                                      
 --(1. TRANS)                                                                                                                                                         
 INSERT INTO TrxLLLFX(Tanggal, Bulan, Tahun, DealNo, TransType, NotAmount, NotAmountOriginal, PVAmount,                                                               
                      CustomerID, PE, Amount, CCY, CTRCCY, DealInd, FinalRateCCY, FinalRateCTRCCY,                                                                    
 					 SwapPointCCY, SwapPointCTRCCY, OriginalAmountCCY, OriginalAmountCTRCCY)                                                                          
 SELECT DAY(@CURRENT),                                                                                                                                                
        MONTH(@CURRENT),                                                                                                                                              
 	   YEAR(@CURRENT),                                                                                                                                                
 	   DEALNO,                                                                                                                                                        
 	   'TRANS',                                                                                                                                                       
 	   CASE WHEN A.PS = 'P'THEN A.CCYBAMT ELSE A.CTRBAMT END NOTIONAL_AMOUNT,                                                                                         
 	   CASE WHEN A.PS = 'P' THEN A.CCYAMT ELSE A.CTRAMT END NOTAMOUNTORIGINAL,                                                                                        
 	   CASE WHEN CCYREVALAMT + CTRREVALAMT > 0                                                                                                                        
 				THEN CCYREVALAMT + CTRREVALAMT                                                                                                                        
 			ELSE 0                                                                                                                                                    
 	   END PV,                                                                                                                                                        
 	   CUST,                                                                                                                                                          
 	   CASE WHEN DATEDIFF(DAY, DEALDATE, VDATE)/360.0 <= 1                                                                                                            
 				THEN 0.01                                                                                                                                             
 			WHEN DATEDIFF(DAY, A.DEALDATE, A.VDATE)/360.0 > 1 AND DATEDIFF(DAY, A.DEALDATE, A.VDATE)/360.0 <= 5                                                       
 				THEN 0.05                                                                                                                                             
 			ELSE 0.075                                                                                                                                                
 	   END PE,                                                                                                                                                        
 	   ABS(                                                                                                                                                           
 			CASE WHEN A.PS = 'P'THEN A.CCYBAMT ELSE A.CTRBAMT END                                                                                                     
 	   )                                                                                                                                                              
 	   *                                                                                                                                                              
 	   (                                                                                                                                                              
 			 CASE WHEN DATEDIFF(DAY, DEALDATE, VDATE)/360.0 <= 1                                                                                                      
 						THEN 0.01                                                                                                                                     
 					WHEN DATEDIFF(DAY, A.DEALDATE, A.VDATE)/360.0 > 1 AND DATEDIFF(DAY, A.DEALDATE, A.VDATE)/360.0 <= 5                                               
 						THEN 0.05                                                                                                                                     
 					ELSE 0.075                                                                                                                                        
 			  END                                                                                                                                                     
 	   )                                                                                                                                                              
 	   +                                                                                                                                                              
 	   (                                                                                                                                                              
 		    CASE WHEN CCYREVALAMT + CTRREVALAMT > 0                                                                                                                   
 					THEN CCYREVALAMT + CTRREVALAMT                                                                                                                    
 				ELSE 0                                                                                                                                                
 		   END                                                                                                                                                        
 	   ) Amount,                                                                                                                                                      
 	   CCY,                                                                                                                                                           
 	   CTRCCY,                                                                                                                                                        
 	   SPOTFWDIND,                                                                                                                                                    
 	   FINALRATECCY,                                                                                                                                                  
 	   FINALRATECTR,                                                                                                                                                  
 	   SWAPPOINT_CCY,                                                                                                                                                 
 	   SWAPPOINT_CTR,                                                                                                                                                 
 	   CCYAMT,                                                                                                                                                        
 	   CTRAMT                                                                                                                                                         
 FROM #TEMP_PVFX A                                                                                                                                                    
 WHERE A.SPOTFWDIND = 'F';                                                                                                                                            
                                                                                                                                                                      
                                                                                                                                                                      
 --(2. VALUE)                                                                                                                                                         
 INSERT INTO TrxLLLFX(Tanggal, Bulan, Tahun, DealNo, TransType, NotAmount, NotAmountOriginal, PVAmount,                                                               
                      CustomerID, PE, Amount, CCY, CTRCCY, DealInd, FinalRateCCY, FinalRateCTRCCY,                                                                    
 					 SwapPointCCY, SwapPointCTRCCY, OriginalAmountCCY, OriginalAmountCTRCCY)                                                                          
 SELECT DAY(@CURRENT),                                                                                                                                                
        MONTH(@CURRENT),                                                                                                                                              
 	   YEAR(@CURRENT),                                                                                                                                                
 	   DEALNO,                                                                                                                                                        
 	   'VALUE',                                                                                                                                                       
 	   CASE WHEN A.PS = 'P'THEN A.CCYBAMT ELSE A.CTRBAMT END NOTIONAL_AMOUNT,                                                                                         
 	   CASE WHEN A.PS = 'P' THEN A.CCYAMT ELSE A.CTRAMT END NOTAMOUNTORIGINAL,                                                                                        
 	   CASE WHEN CCYREVALAMT + CTRREVALAMT > 0                                                                                                                        
 				THEN CCYREVALAMT + CTRREVALAMT                                                                                                                        
 			ELSE 0                                                                                                                                                    
 	   END PV,                                                                                                                                                        
 	   CUST,                                                                                                                                                          
 	   CASE WHEN DATEDIFF(DAY, DEALDATE, VDATE)/360.0 <= 1                                                                                                            
 				THEN 0.01                                                                                                                                             
 			WHEN DATEDIFF(DAY, A.DEALDATE, A.VDATE)/360.0 > 1 AND DATEDIFF(DAY, A.DEALDATE, A.VDATE)/360.0 <= 5                                                       
 				THEN 0.05                                                                                                                                             
 			ELSE 0.075                                                                                                                                                
 	   END PE,                                                                                                                                                        
 	   ABS(                                                                                                                                                           
 			CASE WHEN A.PS = 'P'THEN A.CCYBAMT ELSE A.CTRBAMT END                                                                                                     
 	   )                                                                                                                                                              
 	   *                                                                                                                                                              
 	   (                                                                                                                                                              
 			 CASE WHEN DATEDIFF(DAY, DEALDATE, VDATE)/360.0 <= 1                                                                                                      
 						THEN 0.01                                                                                                                                     
 					WHEN DATEDIFF(DAY, A.DEALDATE, A.VDATE)/360.0 > 1 AND DATEDIFF(DAY, A.DEALDATE, A.VDATE)/360.0 <= 5                                               
 						THEN 0.05                                                                                                                                     
 					ELSE 0.075                                                                                                                                        
 			  END                                                                                                                                                     
 	   )                                                                                                                                                              
 	   +                                                                                                                                                              
 	   (                                                                                                                                                              
 		    CASE WHEN CCYREVALAMT + CTRREVALAMT > 0                                                                                                                   
 					THEN CCYREVALAMT + CTRREVALAMT                                                                                                                    
 				ELSE 0                                                                                                                                                
 		   END                                                                                                                                                        
 	   ) Amount,                                                                                                                                                      
 	   CCY,                                                                                                                                                           
 	   CTRCCY,                                                                                                                                                        
 	   SPOTFWDIND,                                                                                                                                                    
 	   FINALRATECCY,                                                                                                                                                  
 	   FINALRATECTR,                                                                                                                                                  
 	   SWAPPOINT_CCY,                                                                                                                                                 
 	   SWAPPOINT_CTR,                                                                                                                                                 
 	   CCYAMT,                                                                                                                                                        
 	   CTRAMT                                                                                                                                                         
 FROM #TEMP_PVFX A                                                                                                                                                    
 WHERE A.SPOTFWDIND = 'F';                                                                                                                                            
                                                                                                                                                                      
                                                                                                                                                                      
 -------------------------------------------------------E. DERIVATIVE                                                                           
                                                                                                                                                
  --HOLIDAY                                                                                                                                     
 IF OBJECT_ID('TEMP_HLDY_SWAP', 'U') IS NOT NULL                                                                                                
 	DROP TABLE TEMP_HLDY_SWAP;                                                                                                                  
                                                                                                                                                
 SELECT CALENDARID, HOLIDATE                                                                                                                    
 INTO TEMP_HLDY_SWAP                                                                                                                            
 FROM [OPICSDB1].[OPICS].dbo.HLDY                                                                                            
 WHERE HOLIDATE BETWEEN @CURRENT AND DATEADD(YEAR, 10, @CURRENT);                                                                               
                                                                                                                                                
                                                                                                                                                
                                                                                                                                                
  --GET ALL DATA SCHEDULER                                                                                                                      
 SELECT  A.SOURCE,                                                                                                                              
         A.SEQ,                                                                                                                                 
 		A.SCHDSEQ,                                                                                                                              
 		A.CNO,                                                                                                                                  
 		A.PRODTYPE,                                                                                                                             
 		A.PRODUCT,                                                                                                                              
 		A.DEALIND,                                                                                                                              
 		A.DEALNO,                                                                                                                               
 		A.RATECODE,                                                                                                                             
 		A.PAYRECIND,                                                                                                                            
 		A.FIXFLOATIND,                                                                                                                          
 		A.CALCRULE,                                                                                                                             
 		A.NETIPAY,                                                                                                                              
 		A.VERDATE,                                                                                                                              
 		A.BASIS,                                                                                                                                
 		A.SCHDTYPE,                                                                                                                             
 		A.PRINAMT,                                                                                                                              
 		A.PRINCCY,                                                                                                                              
 		A.INTRATE_8,                                                                                                                            
 		A.IMPLINTRATE_8,                                                                                                                        
 		A.SPREAD_8,                                                                                                                             
 		A.INTSTRTDTE,                                                                                                                           
 		A.INTENDDTE,                                                                                                                            
 		A.IPAYDATE,                                                                                                                             
 		A.MATINTDTE,                                                                                                                            
 		A.INTAMT,                                                                                                                               
 		A.INTCCY,                                                                                                                               
 		'XXX' CTRCCY,                                                                                                                           
 		0 COUNTER_ENDDATE,                                                                                                                      
 		A.IMPLINTAMT,                                                                                                                           
 		A.NOTIONAL_AMT,                                                                                                                         
 		A.PPAYAMT,                                                                                                                              
 		A.PVAMT,                                                                                                                                
 		A.PVBAMT,                                                                                                                               
 		A.EXCHAMT,                                                                                                                              
 		A.EXCHBAMT                                                                                                                              
 INTO #TEMP_SWAP                                                                                                                                
 FROM(                                                                                                                                          
                                                                                                                                                
 	SELECT  'SWDS' SOURCE,                                                                                                                      
 			SWDS.SEQ,                                                                                                                           
 			SWDH.PRODUCT,                                                                                                                       
 			SWDS.SCHDSEQ,                                                                                                                       
 			SWDH.DEALIND,                                                                                                                       
 			SWDH.CNO,                                                                                                                           
 			SWDH.PRODTYPE,                                                                                                                      
 			SWDS.DEALNO,                                                                                                                        
 			SWDS.RATECODE,                                                                                                                      
 			SWDS.PAYRECIND,                                                                                                                     
 			SWDS.FIXFLOATIND,                                                                                                                   
 			SWDS.CALCRULE,                                                                                                                      
 			SWDS.BASIS,                                                                                                                         
 			SWDS.SCHDTYPE,                                                                                                                      
 			SWDS.NETIPAY,                                                                                                                       
 			SWDS.VERDATE,                                                                                                                       
                                                                                                                                                
 			SWDS.PRINAMT,                                                                                                                       
 			SWDS.PRINCCY,                                                                                                                       
 			SWDS.INTRATE_8,                                                                                                                     
 			SWDS.IMPLINTRATE_8,                                                                                                                 
 			SWDS.SPREAD_8,                                                                                                                      
                                                                                                                                                
                                                                                                                                                
 			SWDS.INTSTRTDTE,                                                                                                                    
 			SWDS.IPAYDATE INTENDDTE,                                                                                                            
 			SWDS.IPAYDATE,                                                                                                                      
 			SWDS.INTENDDTE MATINTDTE,                                                                                                           
                                                                                                                                                
 			SWDS.INTAMT,                                                                                                                        
 			SWDS.INTCCY,                                                                                                                        
 			SWDS.IMPLINTAMT,                                                                                                                    
 			SWDS.PPAYAMT,                                                                                                                       
 			SWDS.PVAMT,                                                                                                                         
 			SWDS.PVBAMT,                                                                                                                        
                                                                                                                                                
 			ABS(SWDT.NOTCCYAMT)NOTIONAL_AMT,                                                                                                    
 			0 EXCHAMT,                                                                                                                          
 			0 EXCHBAMT                                                                                                                          
                                                                                                                                                
 	FROM [OPICSDB1].[OPICS].dbo.SWDS SWDS                                                                                    
                                                                                                                                                
 	LEFT JOIN  [OPICSDB1].[OPICS].dbo.SWDH SWDH                                                                              
 	ON  SWDH.BR = SWDS.BR                                                                                                                       
 	   AND SWDH.DEALNO = SWDS.DEALNO                                                                                                            
 	   AND SWDH.PRODUCT = SWDS.PRODUCT                                                                                                          
 	   AND SWDH.PRODTYPE = SWDS.PRODTYPE                                                                                                        
 	   AND SWDH.DEALIND= SWDS.DEALIND                                                                                                           
                                                                                                                                                
 	LEFT JOIN  [OPICSDB1].[OPICS].dbo.SWDT SWDT                                                                              
 	ON  SWDT.BR = SWDS.BR                                                                                                                       
 	   AND SWDT.DEALNO = SWDS.DEALNO                                                                                                            
 	   AND SWDT.PRODUCT = SWDS.PRODUCT                                                                                                          
 	   AND SWDT.PRODTYPE = SWDS.PRODTYPE                                                                                                        
 	   AND SWDT.DEALIND= SWDS.DEALIND                                                                                                           
 	   AND SWDT.SEQ = SWDS.SEQ                                                                                                                  
                                                                                                                                                
 	WHERE SWDS.BR = '01'                                                                                                                        
 	 AND SWDS.IPAYDATE > @DATA     --DIMANA @DATA ADALAH TANGGAL TERJADINYA TRANSAKSI                                                           
 	 AND ISNULL(SWDH.REVREASON, '') = ''                                                                                                        
 	 AND SWDH.VERDATE IS NOT NULL                                                                                                               
 	 AND ((SWDH.DEALIND = 'O' and SWDH.ACTIVEIND = 'Y') OR SWDH.DEALIND = 'S')                                                                  
                                                                                                                                                
 	UNION ALL                                                                                                                                   
                                                                                                                                                
 	SELECT  'INIT EXCHANGE' SOURCE,                                                                                                             
 			SWDT.SEQ,                                                                                                                           
 			SWDH.PRODUCT,                                                                                                                       
 			'IEX' SCHDSEQ,                                                                                                                      
 			SWDH.DEALIND,                                                                                                                       
 			SWDH.CNO,                                                                                                                           
 			SWDH.PRODTYPE,                                                                                                                      
 			SWDH.DEALNO,                                                                                                                        
 			'FIXED' RATECODE,                                                                                                                   
 			SWDT.PAYRECIND,                                                                                                                     
 			'X' FIXFLOATIND,                                                                                                                    
 			'X' CALCRULE,                                                                                                                       
 			'X' BASIS,                                                                                                                          
 			'X' SCHDTYPE,                                                                                                                       
 			0 NETIPAY,                                                                                                                          
 			NULL VERDATE,                                                                                                                       
                                                                                                                                                
 			0 PRINAMT, --ABS(SWDT.INITEXCHAMT) PRINAMT,                                                                                         
 			'X' PRINCCY, --SWDT.INITEXCHCCY PRINCCY,                                                                                            
 			0 INTRATE_8,                                                                                                                        
 			0 IMPLINTRATE_8,                                                                                                                    
 			0 SPREAD_8,                                                                                                                         
                                                                                                                                                
 			@DATA INTSTRTDTE,                                                                                                                   
 			SWDT.INITEXCHDATE INTENDDTE,                                                                                                        
 			SWDT.INITEXCHDATE IPAYDATE,                                                                                                         
 			SWDT.INITEXCHDATE MATINTDTE,                                                                                                        
                                                                                                                                                
 			SWDT.INITEXCHAMT INTAMT,                                                                                                            
 			SWDT.INITEXCHCCY INTCCY,                                                                                                            
 			0 IMPLINTAMT,                                                                                                                       
 			0.0 PPAYAMT,                                                                                                                        
 			0.0 PVAMT,                                                                                                                          
 			0.0 PVBAMT,                                                                                                                         
                                                                                                                                                
 			ABS(SWDT.NOTCCYAMT)NOTIONAL_AMT,                                                                                                    
 			SWDT.NPVAMTINITEXCH EXCHAMT,                                                                                                        
 			SWDT.NPVBAMTINITEXCH EXCHBAMT                                                                                                       
                                                                                                                                                
 	FROM [OPICSDB1].[OPICS].dbo.SWDT SWDT                                                                                    
                                                                                                                                                
 	LEFT JOIN [OPICSDB1].[OPICS].dbo.SWDH  SWDH                                                                              
 	ON  SWDH.BR = SWDT.BR                                                                                                                       
 	 AND SWDH.DEALNO = SWDT.DEALNO                                                                                                              
 	 AND SWDH.PRODUCT = SWDT.PRODUCT                                                                                                            
 	 AND SWDH.PRODTYPE = SWDT.PRODTYPE                                                                                                          
 	 AND SWDH.DEALIND= SWDT.DEALIND                                                                                                             
                                                                                                                                                
 	WHERE SWDT.BR = '01'                                                                                                                        
 	 AND SWDT.INITEXCHDATE > @DATA                                                                                                              
 	 AND ISNULL(SWDH.REVREASON, '') = ''                                                                                                        
 	 AND SWDH.VERDATE IS NOT NULL                                                                                                               
 	 AND ((SWDH.DEALIND = 'O' AND SWDH.ACTIVEIND = 'Y') OR SWDH.DEALIND = 'S')                                                                  
                                                                                                                                                
 	UNION ALL                                                                                                                                   
                                                                                                                                                
 	SELECT 'FINAL EXCHANGE' SOURCE,                                                                                                             
 			SWDT.SEQ,                                                                                                                           
 			SWDH.PRODUCT,                                                                                                                       
 			'FEX' SCHDSEQ,                                                                                                                      
 			SWDH.DEALIND,                                                                                                                       
 			SWDH.CNO,                                                                                                                           
 			SWDH.PRODTYPE,                                                                                                                      
 			SWDH.DEALNO,                                                                                                                        
 			'FIXED' RATECODE,                                                                                                                   
 			SWDT.PAYRECIND,                                                                                                                     
 			'X' FIXFLOATIND,                                                                                                                    
 			'X' CALCRULE,                                                                                                                       
 			SWDT.BASIS,                                                                                                                         
 			'X' SCHDTYPE,                                                                                                                       
 			0 NETIPAY,                                                                                                                          
 			NULL VERDATE,                                                                                                                       
                                                                                                                                                
 			0 PRINAMT,--ABS(SWDT.FINEXCHAMT) PRINAMT,                                                                                           
 			'X' PRINCCY, --SWDT.FINEXCHCCY PRINCCY,                                                                                             
 			0 INTRATE_8,                                                                                                                        
 			0 IMPLINTRATE_8,                                                                                                                    
 			SWDT.SPREAD_8,                                                                                                                      
                                                                                                                                                
 			@DATA INTSTRTDTE,                                                                                                                   
 			SWDT.FINEXCHDATE INTENDDTE,                                                                                                         
 			SWDT.FINEXCHDATE IPAYDATE,                                                                                                          
 			SWDT.FINEXCHDATE MATINTDTE,                                                                                                         
                                                                                                                                                
 			SWDT.FINEXCHAMT INTAMT,                                                                                                             
 			SWDT.FINEXCHCCY INTCCY,                                                                                                             
 			0 IMPLINTAMT,                                                                                                                       
 			0.0 PPAYAMT,                                                                                                                        
 			0.0 PVAMT,                                                                                                                          
 			0.0 PVBAMT,                                                                                                                         
                                                                                                                                                
 			ABS(SWDT.NOTCCYAMT) NOTIONAL_AMT,                                                                                                   
 			SWDT.NPVAMTFINEXCH EXCHAMT,                                                                                                         
 			SWDT.NPVBAMTFINEXCH EXCHBAMT                                                                                                        
                                                                                                                                                
 	FROM [OPICSDB1].[OPICS].dbo.SWDT SWDT                                                                                    
                                                                                                                                                
 	LEFT JOIN [OPICSDB1].[OPICS].dbo.SWDH SWDH                                                                               
 	ON SWDH.BR = SWDT.BR                                                                                                                        
 	 AND SWDH.DEALNO = SWDT.DEALNO                                                                                                              
 	 AND SWDH.PRODUCT = SWDT.PRODUCT                                                                                                            
 	 AND SWDH.PRODTYPE = SWDT.PRODTYPE                                                                                                          
 	 AND SWDH.DEALIND= SWDT.DEALIND                                                                                                             
                                                                                                                                                
 	WHERE SWDT.BR = '01'                                                                                                                        
 	 AND SWDT.FINEXCHDATE > @DATA                                                                                                               
 	 AND ISNULL(SWDH.REVREASON, '') = ''                                                                                                        
 	 AND SWDH.VERDATE IS NOT NULL                                                                                                               
 	 AND ((SWDH.DEALIND = 'O' AND SWDH.ACTIVEIND = 'Y') OR SWDH.DEALIND = 'S')                                                                  
                                                                                                                                                
 )A                                                                                                                                             
                                                                                                                                                
                                                                                                                                                
                                                                                                                                                
                                                                                                                                                
 --UPDATE COUNTER CCY SEQ 1                                                                                                                     
 UPDATE A                                                                                                                                       
 	SET A.CTRCCY = ISNULL(B.INTCCY, '')                                                                                                         
 FROM #TEMP_SWAP A                                                                                                                              
 LEFT JOIN #TEMP_SWAP B                                                                                                                         
 ON A.CNO = B.CNO                                                                                                                               
    AND A.DEALNO = B.DEALNO                                                                                                                     
    AND A.PRODTYPE = B.PRODTYPE                                                                                                                 
    AND A.SCHDSEQ = B.SCHDSEQ                                                                                                                   
    AND B.SEQ = 2                                                                                                                               
 WHERE A.SEQ = 1                                                                                                                                
                                                                                                                                                
                                                                                                                                                
                                                                                                                                                
                                                                                                                                                
 --UPDATE COUNTER CCY SEQ 2                                                                                                                     
 UPDATE A                                                                                                                                       
 	SET A.CTRCCY = ISNULL(B.INTCCY, '')                                                                                                         
 FROM #TEMP_SWAP A                                                                                                                              
 LEFT JOIN #TEMP_SWAP B                                                                                                                         
 ON A.CNO = B.CNO                                                                                                                               
    AND A.DEALNO = B.DEALNO                                                                                                                     
    AND A.PRODTYPE = B.PRODTYPE                                                                                                                 
    AND A.SCHDSEQ = B.SCHDSEQ                                                                                                                   
    AND B.SEQ = 1                                                                                                                               
 WHERE A.SEQ = 2                                                                                                                                
                                                                                                                                                
                                                                                                                                                
                                                                                                                                                
 --MAKING TEMPLATE CURRENCY, DDFT START FROM HERE                                                                                               
 SELECT DISTINCT CCY                                                                                                                            
 INTO #TEMP_CCY                                                                                                                                 
 FROM [OPICSDB1].[OPICS].dbo.YCRT                                                                                            
                                                                                                                                                
                                                                                                                                                
                                                                                                                                                
 --RESERVE SLOT                                                                                                                                 
 SELECT B.CCY, A.*                                                                                                                              
 INTO #TEMPLATE                                                                                                                                 
 FROM                                                                                                                                           
 (                                                                                                                                              
 	SELECT 1 URUTAN, 'O/N' MTYEND, 0 SCALAR, 'O/N' TERM UNION                                                                                   
 	SELECT 3 URUTAN, '1D' MTYEND, 1 SCALAR, 'D'  TERM UNION                                                                                     
 	SELECT 4 URUTAN, '1W' MTYEND, 1 SCALAR, 'W'  TERM UNION                                                                                     
 	SELECT 5 URUTAN, '2W' MTYEND, 2 SCALAR, 'W'  TERM UNION                                                                                     
 	SELECT 6 URUTAN, '1M' MTYEND, 1 SCALAR, 'M'  TERM UNION                                                                                     
 	SELECT 7 URUTAN, '2M' MTYEND, 2 SCALAR, 'M'  TERM UNION                                                                                     
 	SELECT 8 URUTAN, '3M' MTYEND, 3 SCALAR, 'M'  TERM UNION                                                                                     
 	SELECT 9 URUTAN, '6M' MTYEND, 6 SCALAR, 'M'  TERM UNION                                                                                     
 	SELECT 10 URUTAN, '1Y' MTYEND, 1 SCALAR, 'Y'  TERM UNION                                                                                    
 	SELECT 11 URUTAN, '2Y' MTYEND, 2 SCALAR, 'Y'  TERM UNION                                                                                    
 	SELECT 12 URUTAN, '3Y' MTYEND, 3 SCALAR, 'Y'  TERM UNION                                                                                    
 	SELECT 13 URUTAN, '4Y' MTYEND, 4 SCALAR, 'Y'  TERM UNION                                                                                    
 	SELECT 14 URUTAN, '5Y' MTYEND, 5 SCALAR, 'Y'  TERM UNION                                                                                    
 	SELECT 15 URUTAN, '6Y' MTYEND, 6 SCALAR, 'Y'  TERM UNION                                                                                    
 	SELECT 15 URUTAN, '7Y' MTYEND, 7 SCALAR, 'Y'  TERM UNION                                                                                    
 	SELECT 16 URUTAN, '8Y' MTYEND, 8 SCALAR, 'Y'  TERM UNION                                                                                    
 	SELECT 17 URUTAN, '9Y' MTYEND, 9 SCALAR, 'Y'  TERM UNION                                                                                    
 	SELECT 18 URUTAN, '10Y'MTYEND,10 SCALAR, 'Y'  TERM                                                                                          
 )A                                                                                                                                             
 LEFT JOIN #TEMP_CCY B                                                                                                                          
 ON 1 =1                                                                                                                                        
                                                                                                                                                
                                                                                                                                                
                                                                                                                                                
 --TANGGAL UNTUK @DATA_YCRT                                                                                                                     
 SELECT @DATA_YCRT = CASE WHEN COUNT(*) = 0                                                                                                     
 							THEN @DATA_YCRT                                                                                                     
 						ELSE @DATA                                                                                                              
 					END                                                                                                                         
 FROM [OPICSDB1].[OPICS].dbo.YCRT A                                                                                          
 WHERE A.LSTMNTDTE = @DATA AND CCY IN ('IDR', 'USD', 'JPY')                                                                                     
                                                                                                                                                
                                                                                                                                                
 --------------------STEP 0, FINAL SELECTION - START OF DDFT --- MID                                                                            
 SELECT A.CCY,                                                                                                                                  
        A.MTYEND,                                                                                                                               
 	   A.SCALAR,                                                                                                                                
 	   A.TERM,                                                                                                                                  
 	   B.MIDRATE_8,                                                                                                                             
 	   B.MIDSPREAD_8,                                                                                                                           
 	   B.COUNTER_DUEDATE,                                                                                                                       
 	   @DATA SPOTDATE,                                                                                                                          
 	   @DATA DUEDATE,                                                                                                                           
 	   A.URUTAN,                                                                                                                                
 	   ISNULL(B.CONTRIBRATE, 'CUSTOME') CONTRIBRATE                                                                                             
 INTO #TEMP_YCRT_MID                                                                                                                            
 FROM #TEMPLATE A                                                                                                                               
 LEFT JOIN                                                                                                                                      
 (                                                                                                                                              
 	SELECT A.CCY,                                                                                                                               
 		   A.MTYEND,                                                                                                                            
 		   A.MIDRATE_8,                                                                                                                         
 		   A.MIDSPREAD_8,                                                                                                                       
 		   0 COUNTER_DUEDATE,                                                                                                                   
 		   A.CONTRIBRATE                                                                                                                        
 	FROM [OPICSDB1].[OPICS].dbo.YCRT A                                                                                       
 	WHERE A.LSTMNTDTE = @DATA_YCRT AND CCY IN ('IDR', 'USD', 'JPY')                                                                             
                                                                                                                                                
 	UNION                                                                                                                                       
                                                                                                                                                
 	SELECT A.CCY,                                                                                                                               
 		   A.MTYEND,                                                                                                                            
 		   A.MIDRATE_8,                                                                                                                         
 		   A.MIDSPREAD_8,                                                                                                                       
 		   0 COUNTER_DUEDATE,                                                                                                                   
 		   A.CONTRIBRATE                                                                                                                        
 	FROM [OPICSDB1].[OPICS].dbo.YCRT A                                                                                       
 	WHERE CCY NOT IN ('IDR', 'USD', 'JPY')                                                                                                      
 )B                                                                                                                                             
 ON A.CCY = B.CCY                                                                                                                               
 AND A.MTYEND = B.MTYEND COLLATE Latin1_General_BIN                                                                                             
                                                                                                                                                
 SELECT A.CCY,                                                                                                                                  
        A.MTYEND,                                                                                                                               
 	   A.SCALAR,                                                                                                                                
 	   A.TERM,                                                                                                                                  
 	   B.MIDRATE_8,                                                                                                                             
 	   B.MIDSPREAD_8,                                                                                                                           
 	   B.COUNTER_DUEDATE,                                                                                                                       
 	   @DATA SPOTDATE,                                                                                                                          
 	   @DATA DUEDATE,                                                                                                                           
 	   A.URUTAN,                                                                                                                                
 	   ISNULL(B.CONTRIBRATE, 'CUSTOME') CONTRIBRATE                                                                                             
 INTO #TEMP_YCRT_BID                                                                                                                            
 FROM #TEMPLATE A                                                                                                                               
 LEFT JOIN                                                                                                                                      
 (                                                                                                                                              
 	SELECT A.CCY,                                                                                                                               
 		   A.MTYEND,                                                                                                                            
 		   A.MIDRATE_8,                                                                                                                         
 		   A.MIDSPREAD_8,                                                                                                                       
 		   0 COUNTER_DUEDATE,                                                                                                                   
 		   A.CONTRIBRATE                                                                                                                        
 	FROM [OPICSDB1].[OPICSBID].dbo.YCRT A                                                                                       
 	WHERE A.LSTMNTDTE = @DATA_YCRT AND CCY IN ('IDR', 'USD', 'JPY')                                                                             
                                                                                                                                                
 	UNION                                                                                                                                       
                                                                                                                                                
 	SELECT A.CCY,                                                                                                                               
 		   A.MTYEND,                                                                                                                            
 		   A.MIDRATE_8,                                                                                                                         
 		   A.MIDSPREAD_8,                                                                                                                       
 		   0 COUNTER_DUEDATE,                                                                                                                   
 		   CONTRIBRATE                                                                                                                          
 	FROM [OPICSDB1].[OPICSBID].dbo.YCRT A                                                                                       
 	WHERE CCY NOT IN ('IDR', 'USD', 'JPY')                                                                                                      
 )B                                                                                                                                             
 ON A.CCY = B.CCY                                                                                                                               
 AND A.MTYEND = B.MTYEND COLLATE Latin1_General_BIN                                                                                             
                                                                                                                                                
 SELECT A.CCY,                                                                                                                                  
        A.MTYEND,                                                                                                                               
 	   A.SCALAR,                                                                                                                                
 	   A.TERM,                                                                                                                                  
 	   B.MIDRATE_8,                                                                                                                             
 	   B.MIDSPREAD_8,                                                                                                                           
 	   B.COUNTER_DUEDATE,                                                                                                                       
 	   @DATA SPOTDATE,                                                                                                                          
 	   @DATA DUEDATE,                                                                                                                           
 	   A.URUTAN,                                                                                                                                
 	   ISNULL(B.CONTRIBRATE, 'CUSTOME') CONTRIBRATE                                                                                             
 INTO #TEMP_YCRT_OFF                                                                                                                            
 FROM #TEMPLATE A                                                                                                                               
 LEFT JOIN                                                                                                                                      
 (                                                                                                                                              
 	SELECT A.CCY,                                                                                                                               
 		   A.MTYEND,                                                                                                                            
 		   A.MIDRATE_8,                                                                                                                         
 		   A.MIDSPREAD_8,                                                                                                                       
 		   0 COUNTER_DUEDATE,                                                                                                                   
 		   A.CONTRIBRATE                                                                                                                        
 	FROM [OPICSDB1].[OPICSOFF].dbo.YCRT A                                                                                       
 	WHERE A.LSTMNTDTE = @DATA_YCRT AND CCY IN ('IDR', 'USD', 'JPY')                                                                             
                                                                                                                                                
 	UNION                                                                                                                                       
                                                                                                                                                
 	SELECT A.CCY,                                                                                                                               
 		   A.MTYEND,                                                                                                                            
 		   A.MIDRATE_8,                                                                                                                         
 		   A.MIDSPREAD_8,                                                                                                                       
 		   0 COUNTER_DUEDATE,                                                                                                                   
 		   A.CONTRIBRATE                                                                                                                        
 	FROM [OPICSDB1].[OPICSOFF].dbo.YCRT A                                                                                       
 	WHERE CCY NOT IN ('IDR', 'USD', 'JPY')                                                                                                      
 )B                                                                                                                                             
 ON A.CCY = B.CCY                                                                                                                               
 AND A.MTYEND = B.MTYEND COLLATE Latin1_General_BIN                                                                                             
                                                                                                                                                
                                                                                                                                                
                                                                                                                                                
                                                                                                                                                
 --STEP 1 - UPDATE MATURITY DATE                                                                                                                
 UPDATE A                                                                                                                                       
 	SET A.DUEDATE = dbo.GET_MATDATE_SWAP(A.SPOTDATE, A.SCALAR, A.TERM)                                                                          
 FROM #TEMP_YCRT_MID A                                                                                                                          
                                                                                                                                                
 UPDATE A                                                                                                                                       
 	SET A.DUEDATE = dbo.GET_MATDATE_SWAP(A.SPOTDATE, A.SCALAR, A.TERM)                                                                          
 FROM #TEMP_YCRT_BID A                                                                                                                          
                                                                                                                                                
 UPDATE A                                                                                                                                       
 	SET A.DUEDATE = dbo.GET_MATDATE_SWAP(A.SPOTDATE, A.SCALAR, A.TERM)                                                                          
 FROM #TEMP_YCRT_OFF A                                                                                                                          
                                                                                                                                                
                                                                                                                                                
 --STEP 2 - UPDATE MATURITY DATE DENGAN HOLIDAY                                                                                                 
 UPDATE A                                                                                                                                       
 	SET A.DUEDATE = dbo.GET_NONHOLIDATE_SWAP(A.DUEDATE, A.CCY, A.TERM)                                                                          
 FROM #TEMP_YCRT_MID A                                                                                                                          
                                                                                                                                                
 UPDATE A                                                                                                                                       
 	SET A.DUEDATE = dbo.GET_NONHOLIDATE_SWAP(A.DUEDATE, A.CCY, A.TERM)                                                                          
 FROM #TEMP_YCRT_BID A                                                                                                                          
                                                                                                                                                
 UPDATE A                                                                                                                                       
 	SET A.DUEDATE = dbo.GET_NONHOLIDATE_SWAP(A.DUEDATE, A.CCY, A.TERM)                                                                          
 FROM #TEMP_YCRT_OFF A                                                                                                                          
                                                                                                                                                
                                                                                                                                                
                                                                                                                                                
 --STEP 3, MENENTUKAN PARRATE YANG MASI KOSONG                                                                                                  
                                                                                                                                                
 --WEEKLY                                                                                                                                       
 UPDATE A                                                                                                                                       
 	SET A.MIDRATE_8 = B.MIDRATE_8 +                                                                                                             
 	                  (DATEDIFF(DAY, B.DUEDATE, A.DUEDATE))*((C.MIDRATE_8 - B.MIDRATE_8)/DATEDIFF(DAY, B.DUEDATE, C.DUEDATE)),                  
 	    A.MIDSPREAD_8 = 0                                                                                                                       
                                                                                                                                                
 FROM #TEMP_YCRT_MID A                                                                                                                          
                                                                                                                                                
 LEFT JOIN #TEMP_YCRT_MID B                                                                                                                     
 ON A.CCY = B.CCY AND B.MTYEND = '1D'                                                                                                           
                                                                                                                                                
 LEFT JOIN #TEMP_YCRT_MID C                                                                                                                     
 ON A.CCY = C.CCY AND C.MTYEND = '1M'                                                                                                           
                                                                                                                                                
 WHERE A.MTYEND IN ('1W', '2W')                                                                                                                 
                                                                                                                                                
 UPDATE A                                                                                                                                       
 	SET A.MIDRATE_8 = B.MIDRATE_8 +                                                                                                             
 	                  (DATEDIFF(DAY, B.DUEDATE, A.DUEDATE))*((C.MIDRATE_8 - B.MIDRATE_8)/DATEDIFF(DAY, B.DUEDATE, C.DUEDATE)),                  
 	    A.MIDSPREAD_8 = 0                                                                                                                       
                                                                                                                                                
 FROM #TEMP_YCRT_BID A                                                                                                                          
                                                                                                                                                
 LEFT JOIN #TEMP_YCRT_BID B                                                                                                                     
 ON A.CCY = B.CCY AND B.MTYEND = '1D'                                                                                                           
                                                                                                                                                
 LEFT JOIN #TEMP_YCRT_BID C                                                                                                                     
 ON A.CCY = C.CCY AND C.MTYEND = '1M'                                                                                                           
                                                                                                                                                
 WHERE A.MTYEND IN ('1W', '2W')                                                                                                                 
                                                                                                                                                
 UPDATE A                                                                                                                                       
 	SET A.MIDRATE_8 = B.MIDRATE_8 +                                                                                                             
 	                  (DATEDIFF(DAY, B.DUEDATE, A.DUEDATE))*((C.MIDRATE_8 - B.MIDRATE_8)/DATEDIFF(DAY, B.DUEDATE, C.DUEDATE)),                  
 	    A.MIDSPREAD_8 = 0                                                                                                                       
                                                                                                                                                
 FROM #TEMP_YCRT_OFF A                                                                                                                          
                                                                                                                                                
 LEFT JOIN #TEMP_YCRT_OFF B                                                                                                                     
 ON A.CCY = B.CCY AND B.MTYEND = '1D'                                                                                                           
                                                                                                                                                
 LEFT JOIN #TEMP_YCRT_OFF C                                                                                                                     
 ON A.CCY = C.CCY AND C.MTYEND = '1M'                                                                                                           
                                                                                                                                                
 WHERE A.MTYEND IN ('1W', '2W')                                                                                                                 
                                                                                                                                                
                                                                                                                                                
                                                                                                                                                
 --ANNUALLY 4Y                                                                                                                                  
 UPDATE A                                                                                                                                       
 	SET A.MIDRATE_8 = B.MIDRATE_8 +                                                                                                             
 	                  (DATEDIFF(DAY, B.DUEDATE, A.DUEDATE))*((C.MIDRATE_8 - B.MIDRATE_8)/DATEDIFF(DAY, B.DUEDATE, C.DUEDATE)),                  
 	    A.MIDSPREAD_8 = 0                                                                                                                       
                                                                                                                                                
 FROM #TEMP_YCRT_MID A                                                                                                                          
                                                                                                                                                
 LEFT JOIN #TEMP_YCRT_MID B                                                                                                                     
 ON A.CCY = B.CCY AND B.MTYEND = '3Y'                                                                                                           
                                                                                                                                                
 LEFT JOIN #TEMP_YCRT_MID C                                                                                                                     
 ON A.CCY = C.CCY AND C.MTYEND = '5Y'                                                                                                           
                                                                                                                                                
 WHERE A.MTYEND IN ('4Y')                                                                                                                       
                                                                                                                                                
 UPDATE A                                                                                                                                       
 	SET A.MIDRATE_8 = B.MIDRATE_8 +                                                                                                             
 	                  (DATEDIFF(DAY, B.DUEDATE, A.DUEDATE))*((C.MIDRATE_8 - B.MIDRATE_8)/DATEDIFF(DAY, B.DUEDATE, C.DUEDATE)),                  
 	    A.MIDSPREAD_8 = 0                                                                                                                       
                                                                                                                                                
 FROM #TEMP_YCRT_BID A                                                                                                                          
                                                                                                                                                
 LEFT JOIN #TEMP_YCRT_BID B                                                                                                                     
 ON A.CCY = B.CCY AND B.MTYEND = '3Y'                                                                                                           
                                                                                                                                                
 LEFT JOIN #TEMP_YCRT_BID C                                                                                                                     
 ON A.CCY = C.CCY AND C.MTYEND = '5Y'                                                                                                           
                                                                                                                                                
 WHERE A.MTYEND IN ('4Y')                                                                                                                       
                                                                                                                                                
 UPDATE A                                                                                                                                       
 	SET A.MIDRATE_8 = B.MIDRATE_8 +                                                                                                             
 	                  (DATEDIFF(DAY, B.DUEDATE, A.DUEDATE))*((C.MIDRATE_8 - B.MIDRATE_8)/DATEDIFF(DAY, B.DUEDATE, C.DUEDATE)),                  
 	    A.MIDSPREAD_8 = 0                                                                                                                       
                                                                                                                                                
 FROM #TEMP_YCRT_OFF A                                                                                                                          
                                                                                                                                                
 LEFT JOIN #TEMP_YCRT_OFF B                                                                                                                     
 ON A.CCY = B.CCY AND B.MTYEND = '3Y'                                                                                                           
                                                                                                                                                
 LEFT JOIN #TEMP_YCRT_OFF C                                                                                                                     
 ON A.CCY = C.CCY AND C.MTYEND = '5Y'                                                                                                           
                                                                                                                                                
 WHERE A.MTYEND IN ('4Y')                                                                                                                       
                                                                                                                                                
                                                                                                                                                
                                                                                                                                                
 --ANNUALLY 6-9Y                                                                                                                                
 UPDATE A                                                                                                                                       
 	SET A.MIDRATE_8 = B.MIDRATE_8 +                                                                                                             
 	                  (DATEDIFF(DAY, B.DUEDATE, A.DUEDATE))*((C.MIDRATE_8 - B.MIDRATE_8)/DATEDIFF(DAY, B.DUEDATE, C.DUEDATE)),                  
 	    A.MIDSPREAD_8 = 0                                                                                                                       
                                                                                                                                                
 FROM #TEMP_YCRT_MID A                                                                                                                          
                                                                                                                                                
 LEFT JOIN #TEMP_YCRT_MID B                                                                                                                     
 ON A.CCY = B.CCY AND B.MTYEND = '5Y'                                                                                                           
                                                                                                                                                
 LEFT JOIN #TEMP_YCRT_MID C                                                                                                                     
 ON A.CCY = C.CCY AND C.MTYEND = '10Y'                                                                                                          
                                                                                                                                                
 WHERE A.MTYEND IN ('6Y', '7Y', '8Y', '9Y')                                                                                                     
                                                                                                                                                
 UPDATE A                                                                                                                                       
 	SET A.MIDRATE_8 = B.MIDRATE_8 +                                                                                                             
 	                  (DATEDIFF(DAY, B.DUEDATE, A.DUEDATE))*((C.MIDRATE_8 - B.MIDRATE_8)/DATEDIFF(DAY, B.DUEDATE, C.DUEDATE)),                  
 	    A.MIDSPREAD_8 = 0                                                                                                                       
                                                                                                                                                
 FROM #TEMP_YCRT_BID A                                                                                                                          
                                                                                                                                                
 LEFT JOIN #TEMP_YCRT_BID B                                                                                                                     
 ON A.CCY = B.CCY AND B.MTYEND = '5Y'                                                                                                           
                                                                                                                                                
 LEFT JOIN #TEMP_YCRT_BID C                                                                                                                     
 ON A.CCY = C.CCY AND C.MTYEND = '10Y'                                                                                                          
                                                                                                                                                
 WHERE A.MTYEND IN ('6Y', '7Y', '8Y', '9Y')                                                                                                     
                                                                                                                                                
 UPDATE A                                                                                                                                       
 	SET A.MIDRATE_8 = B.MIDRATE_8 +                                                                                                             
 	                  (DATEDIFF(DAY, B.DUEDATE, A.DUEDATE))*((C.MIDRATE_8 - B.MIDRATE_8)/DATEDIFF(DAY, B.DUEDATE, C.DUEDATE)),                  
 	    A.MIDSPREAD_8 = 0                                                                                                                       
                                                                                                                                                
 FROM #TEMP_YCRT_OFF A                                                                                                                          
                                                                                                                                                
 LEFT JOIN #TEMP_YCRT_OFF B                                                                                                                     
 ON A.CCY = B.CCY AND B.MTYEND = '5Y'                                                                                                           
                                                                                                                                                
 LEFT JOIN #TEMP_YCRT_OFF C                                                                                                                     
 ON A.CCY = C.CCY AND C.MTYEND = '10Y'                                                                                                          
                                                                                                                                                
 WHERE A.MTYEND IN ('6Y', '7Y', '8Y', '9Y')                                                                                                     
                                                                                                                                                
                                                                                                                                                
                                                                                                                                                
 --NULL                                                                                                                                         
 UPDATE A                                                                                                                                       
 	SET A.MIDRATE_8 = CASE WHEN ISNULL(A.MIDRATE_8, 0) = 0 THEN 0 ELSE A.MIDRATE_8 END,                                                         
 	    A.MIDSPREAD_8 = CASE WHEN ISNULL(A.MIDSPREAD_8, 0) = 0 THEN 0 ELSE MIDSPREAD_8 END                                                      
 FROM #TEMP_YCRT_MID A                                                                                                                          
                                                                                                                                                
 UPDATE A                                                                                                                                       
 	SET A.MIDRATE_8 = CASE WHEN ISNULL(A.MIDRATE_8, 0) = 0 THEN 0 ELSE A.MIDRATE_8 END,                                                         
 	    A.MIDSPREAD_8 = CASE WHEN ISNULL(A.MIDSPREAD_8, 0) = 0 THEN 0 ELSE MIDSPREAD_8 END                                                      
 FROM #TEMP_YCRT_BID A                                                                                                                          
                                                                                                                                                
 UPDATE A                                                                                                                                       
 	SET A.MIDRATE_8 = CASE WHEN ISNULL(A.MIDRATE_8, 0) = 0 THEN 0 ELSE A.MIDRATE_8 END,                                                         
 	    A.MIDSPREAD_8 = CASE WHEN ISNULL(A.MIDSPREAD_8, 0) = 0 THEN 0 ELSE MIDSPREAD_8 END                                                      
 FROM #TEMP_YCRT_OFF A                                                                                                                          
                                                                                                                                                
                                                                                                                                                
                                                                                                                                                
 --STEP 4                                                                                                                                       
 SELECT A.CCY,                                                                                                                                  
        A.SPOTDATE,                                                                                                                             
        A.SCALAR,                                                                                                                               
 	   A.TERM,                                                                                                                                  
        A.MTYEND MTY,                                                                                                                           
 	   A.MIDRATE_8 RATE,                                                                                                                        
 	   A.MIDSPREAD_8 SPREAD_RATE,                                                                                                               
 	   A.DUEDATE MATDATE,                                                                                                                       
 	   A.URUTAN,                                                                                                                                
 	   A.CONTRIBRATE,                                                                                                                           
        CASE WHEN URUTAN < 11                                                                                                                   
 				THEN CONVERT(DECIMAL(12,10), 1.0/(1.0+(A.MIDRATE_8+A.MIDSPREAD_8)*DATEDIFF(DAY, A.SPOTDATE, A.DUEDATE)/(360*100)))              
 			ELSE NULL                                                                                                                           
        END DISCFACT_10                                                                                                                         
 INTO #TEMP_DDFT_MID                                                                                                                            
 FROM #TEMP_YCRT_MID A                                                                                                                          
                                                                                                                                                
 SELECT A.CCY,                                                                                                                                  
        A.SPOTDATE,                                                                                                                             
        A.SCALAR,                                                                                                                               
 	   A.TERM,                                                                                                                                  
        A.MTYEND MTY,                                                                                                                           
 	   A.MIDRATE_8 RATE,                                                                                                                        
 	   A.MIDSPREAD_8 SPREAD_RATE,                                                                                                               
 	   A.DUEDATE MATDATE,                                                                                                                       
 	   A.URUTAN,                                                                                                                                
 	   A.CONTRIBRATE,                                                                                                                           
        CASE WHEN URUTAN < 11                                                                                                                   
 				THEN CONVERT(DECIMAL(12,10), 1.0/(1.0+(A.MIDRATE_8+A.MIDSPREAD_8)*DATEDIFF(DAY, A.SPOTDATE, A.DUEDATE)/(360*100)))              
 			ELSE NULL                                                                                                                           
        END DISCFACT_10                                                                                                                         
 INTO #TEMP_DDFT_BID                                                                                                                            
 FROM #TEMP_YCRT_BID A                                                                                                                          
                                                                                                                                                
 SELECT A.CCY,                                                                                                                                  
        A.SPOTDATE,                                                                                                                             
        A.SCALAR,                                                                                                                               
 	   A.TERM,                                                                                                                                  
        A.MTYEND MTY,                                                                                                                           
 	   A.MIDRATE_8 RATE,                                                                                                                        
 	   A.MIDSPREAD_8 SPREAD_RATE,                                                                                                               
 	   A.DUEDATE MATDATE,                                                                                                                       
 	   A.URUTAN,                                                                                                                                
 	   A.CONTRIBRATE,                                                                                                                           
        CASE WHEN URUTAN < 11                                                                                                                   
 				THEN CONVERT(DECIMAL(12,10), 1.0/(1.0+(A.MIDRATE_8+A.MIDSPREAD_8)*DATEDIFF(DAY, A.SPOTDATE, A.DUEDATE)/(360*100)))              
 			ELSE NULL                                                                                                                           
        END DISCFACT_10                                                                                                                         
 INTO #TEMP_DDFT_OFF                                                                                                                            
 FROM #TEMP_YCRT_OFF A                                                                                                                          
                                                                                                                                                
                                                                                                                                                
                                                                                                                                                
 --STEP 5 BOOTSTRAPPING                                                                                                                         
                                                                                                                                                
 --MAXIMUM PERULANGAN - MID                                                                                                                     
 SELECT @MAXYEAR = 2,                                                                                                                           
        @SUBMAXYEAR = 1                                                                                                                         
                                                                                                                                                
 WHILE (@MAXYEAR <= 10)                                                                                                                         
 BEGIN                                                                                                                                          
                                                                                                                                                
 	--SET VARIABLE                                                                                                                              
 	SELECT @SUBMAXYEAR = 1;                                                                                                                     
                                                                                                                                                
                                                                                                                                                
 	--LOOPING                                                                                                                                   
 	WHILE(@SUBMAXYEAR < @MAXYEAR)                                                                                                               
 	BEGIN                                                                                                                                       
                                                                                                                                                
 		--HITUNGAN PART                                                                                                                         
 		UPDATE A                                                                                                                                
 		       SET A.DISCFACT_10 = ISNULL(A.DISCFACT_10, 0) +                                                                                   
 			                       0.01*(A.RATE + A.SPREAD_RATE)*B.DISCFACT_10*                                                                 
 								   ROUND(1.00000000000*DATEDIFF(DAY, C.MATDATE, B.MATDATE)/360, 14)                                             
 		FROM #TEMP_DDFT_MID A                                                                                                                   
                                                                                                                                                
 		LEFT JOIN #TEMP_DDFT_MID B                                                                                                              
 		ON A.CCY = B.CCY                                                                                                                        
 		   AND B.TERM = 'Y'                                                                                                                     
 		   AND B.SCALAR = @SUBMAXYEAR                                                                                                           
                                                                                                                                                
 		LEFT JOIN #TEMP_DDFT_MID C                                                                                                              
 		ON A.CCY = C.CCY                                                                                                                        
 		   AND C.TERM = CASE WHEN @SUBMAXYEAR = 1 THEN 'O/N' ELSE 'Y' END                                                                       
 		   AND C.SCALAR = CASE WHEN @SUBMAXYEAR = 1 THEN 0 ELSE @SUBMAXYEAR - 1 END                                                             
                                                                                                                                                
 		WHERE A.TERM = 'Y'                                                                                                                      
 		   AND A.SCALAR = @MAXYEAR                                                                                                              
                                                                                                                                                
                                                                                                                                                
 		--FOR COUNTER                                                                                                                           
 		SELECT @SUBMAXYEAR = @SUBMAXYEAR + 1;                                                                                                   
 	END                                                                                                                                         
                                                                                                                                                
                                                                                                                                                
                                                                                                                                                
 	--UPDATE NILAI AKHIR                                                                                                                        
 	UPDATE A                                                                                                                                    
 		SET A.DISCFACT_10 = ROUND((1-A.DISCFACT_10)/(0.01*(A.RATE+A.SPREAD_RATE)*                                                               
 		                     ROUND(1.000000000000*DATEDIFF(DAY, B.MATDATE, A.MATDATE)/360,14) + 1),14)                                          
 	FROM #TEMP_DDFT_MID A                                                                                                                       
 	LEFT JOIN #TEMP_DDFT_MID B                                                                                                                  
 	ON A.CCY = B.CCY                                                                                                                            
 	   AND B.TERM = 'Y'                                                                                                                         
 	   AND B.SCALAR = @MAXYEAR - 1                                                                                                              
 	WHERE A.TERM = 'Y'                                                                                                                          
 	   AND A.SCALAR = @MAXYEAR                                                                                                                  
                                                                                                                                                
                                                                                                                                                
                                                                                                                                                
 	--FOR COUNTER                                                                                                                               
 	SELECT @MAXYEAR = @MAXYEAR + 1                                                                                                              
 END                                                                                                                                            
                                                                                                                                                
                                                                                                                                                
                                                                                                                                                
 --MAXIMUM PERULANGAN - BID                                                                                                                     
 SELECT @MAXYEAR = 2,                                                                                                                           
        @SUBMAXYEAR = 1                                                                                                                         
                                                                                                                                                
 WHILE (@MAXYEAR <= 10)                                                                                                                         
 BEGIN                                                                                                                                          
                                                                                                                                                
 	--SET VARIABLE                                                                                                                              
 	SELECT @SUBMAXYEAR = 1;                                                                                                                     
                                                                                                                                                
                                                                                                                                                
 	--LOOPING                                                                                                                                   
 	WHILE(@SUBMAXYEAR < @MAXYEAR)                                                                                                               
 	BEGIN                                                                                                                                       
                                                                                                                                                
 		--HITUNGAN PART                                                                                                                         
 		UPDATE A                                                                                                                                
 		       SET A.DISCFACT_10 = ISNULL(A.DISCFACT_10, 0) +                                                                                   
 			                       0.01*(A.RATE + A.SPREAD_RATE)*B.DISCFACT_10*                                                                 
 								   ROUND(1.00000000000*DATEDIFF(DAY, C.MATDATE, B.MATDATE)/360, 14)                                             
 		FROM #TEMP_DDFT_BID A                                                                                                                   
                                                                                                                                                
 		LEFT JOIN #TEMP_DDFT_BID B                                                                                                              
 		ON A.CCY = B.CCY                                                                                                                        
 		   AND B.TERM = 'Y'                                                                                                                     
 		   AND B.SCALAR = @SUBMAXYEAR                                                                                                           
                                                                                                                                                
 		LEFT JOIN #TEMP_DDFT_BID C                                                                                                              
 		ON A.CCY = C.CCY                                                                                                                        
 		   AND C.TERM = CASE WHEN @SUBMAXYEAR = 1 THEN 'O/N' ELSE 'Y' END                                                                       
 		   AND C.SCALAR = CASE WHEN @SUBMAXYEAR = 1 THEN 0 ELSE @SUBMAXYEAR - 1 END                                                             
                                                                                                                                                
 		WHERE A.TERM = 'Y'                                                                                                                      
 		   AND A.SCALAR = @MAXYEAR                                                                                                              
                                                                                                                                                
                                                                                                                                                
 		--FOR COUNTER                                                                                                                           
 		SELECT @SUBMAXYEAR = @SUBMAXYEAR + 1;                                                                                                   
 	END                                                                                                                                         
                                                                                                                                                
                                                                                                                                                
                                                                                                                                                
 	--UPDATE NILAI AKHIR                                                                                                                        
 	UPDATE A                                                                                                                                    
 		SET A.DISCFACT_10 = ROUND((1-A.DISCFACT_10)/(0.01*(A.RATE+A.SPREAD_RATE)*                                                               
 		                     ROUND(1.000000000000*DATEDIFF(DAY, B.MATDATE, A.MATDATE)/360,14) + 1),14)                                          
 	FROM #TEMP_DDFT_BID A                                                                                                                       
 	LEFT JOIN #TEMP_DDFT_BID B                                                                                                                  
 	ON A.CCY = B.CCY                                                                                                                            
 	   AND B.TERM = 'Y'                                                                                                                         
 	   AND B.SCALAR = @MAXYEAR - 1                                                                                                              
 	WHERE A.TERM = 'Y'                                                                                                                          
 	   AND A.SCALAR = @MAXYEAR                                                                                                                  
                                                                                                                                                
                                                                                                                                                
                                                                                                                                                
 	--FOR COUNTER                                                                                                                               
 	SELECT @MAXYEAR = @MAXYEAR + 1                                                                                                              
 END                                                                                                                                            
                                                                                                                                                
                                                                                                                                                
                                                                                                                                                
 --MAXIMUM PERULANGAN - OFF                                                                                                                     
 SELECT @MAXYEAR = 2,                                                                                                                           
        @SUBMAXYEAR = 1                                                                                                                         
                                                                                                                                                
 WHILE (@MAXYEAR <= 10)                                                                                                                         
 BEGIN                                                                                                                                          
                                                                                                                                                
 	--SET VARIABLE                                                                                                                              
 	SELECT @SUBMAXYEAR = 1;                                                                                                                     
                                                                                                                                                
                                                                                                                                                
 	--LOOPING                                                                                                                                   
 	WHILE(@SUBMAXYEAR < @MAXYEAR)                                                                                                               
 	BEGIN                                                                                                                                       
                                                                                                                                                
 		--HITUNGAN PART                                                                                                                         
 		UPDATE A                                                                                                                                
 		       SET A.DISCFACT_10 = ISNULL(A.DISCFACT_10, 0) +                                                                                   
 			                       0.01*(A.RATE + A.SPREAD_RATE)*B.DISCFACT_10*                                                                 
 								   ROUND(1.00000000000*DATEDIFF(DAY, C.MATDATE, B.MATDATE)/360, 14)                                             
 		FROM #TEMP_DDFT_OFF A                                                                                                                   
                                                                                                                                                
 		LEFT JOIN #TEMP_DDFT_OFF B                                                                                                              
 		ON A.CCY = B.CCY                                                                                                                        
 		   AND B.TERM = 'Y'                                                                                                                     
 		   AND B.SCALAR = @SUBMAXYEAR                                                                                                           
                                                                                                                                                
 		LEFT JOIN #TEMP_DDFT_OFF C                                                                                                              
 		ON A.CCY = C.CCY                                                                                                                        
 		   AND C.TERM = CASE WHEN @SUBMAXYEAR = 1 THEN 'O/N' ELSE 'Y' END                                                                       
 		   AND C.SCALAR = CASE WHEN @SUBMAXYEAR = 1 THEN 0 ELSE @SUBMAXYEAR - 1 END                                                             
                                                                                                                                                
 		WHERE A.TERM = 'Y'                                                                                                                      
 		   AND A.SCALAR = @MAXYEAR                                                                                                              
                                                                                                                                                
                                                                                                                                                
 		--FOR COUNTER                                                                                                                           
 		SELECT @SUBMAXYEAR = @SUBMAXYEAR + 1;                                                                                                   
 	END                                                                                                                                         
                                                                                                                                                
                                                                                                                                                
                                                                                                                                                
 	--UPDATE NILAI AKHIR                                                                                                                        
 	UPDATE A                                                                                                                                    
 		SET A.DISCFACT_10 = ROUND((1-A.DISCFACT_10)/(0.01*(A.RATE+A.SPREAD_RATE)*                                                               
 		                     ROUND(1.000000000000*DATEDIFF(DAY, B.MATDATE, A.MATDATE)/360,14) + 1),14)                                          
 	FROM #TEMP_DDFT_OFF A                                                                                                                       
 	LEFT JOIN #TEMP_DDFT_OFF B                                                                                                                  
 	ON A.CCY = B.CCY                                                                                                                            
 	   AND B.TERM = 'Y'                                                                                                                         
 	   AND B.SCALAR = @MAXYEAR - 1                                                                                                              
 	WHERE A.TERM = 'Y'                                                                                                                          
 	   AND A.SCALAR = @MAXYEAR                                                                                                                  
                                                                                                                                                
                                                                                                                                                
                                                                                                                                                
 	--FOR COUNTER                                                                                                                               
 	SELECT @MAXYEAR = @MAXYEAR + 1                                                                                                              
 END                                                                                                                                            
                                                                                                                                                
                                                                                                                                                
                                                                                                                                                
                                                                                                                                                
 --------------------STEP 6, FINAL SELECTION - END OF DDFT                                                                                      
                                                                                                                                                
 --CLEAR 1                                                                                                                                      
 DELETE A                                                                                                                                       
 FROM #TEMP_DDFT_MID A                                                                                                                          
 WHERE MTY NOT IN ('O/N','1D','1M','3M','6M','1Y','2Y','3Y','5Y','10Y')                                                                         
 AND A.CCY <> 'USD'                                                                                                                             
                                                                                                                                                
 DELETE A                                                                                                                                       
 FROM #TEMP_DDFT_BID A                                                                                                                          
 WHERE MTY NOT IN ('O/N','1D','1M','3M','6M','1Y','2Y','3Y','5Y','10Y')                                                                         
 AND A.CCY <> 'USD'                                                                                                                             
                                                                                                                                                
 DELETE A                                                                                                                                       
 FROM #TEMP_DDFT_OFF A                                                                                                                          
 WHERE MTY NOT IN ('O/N','1D','1M','3M','6M','1Y','2Y','3Y','5Y','10Y')                                                                         
 AND A.CCY <> 'USD'                                                                                                                             
                                                                                                                                                
                                                                                                                                                
                                                                                                                                                
 --CLEAR 2                                                                                                                                      
 DELETE A                                                                                                                                       
 FROM #TEMP_DDFT_MID A                                                                                                                          
 WHERE MTY NOT IN ('O/N','1D','1W','2W','1M','3M','6M','1Y','2Y','3Y','5Y','10Y')                                                               
 AND A.CCY = 'USD'                                                                                                                              
                                                                                                                                                
 DELETE A                                                                                                                                       
 FROM #TEMP_DDFT_BID A                                                                                                                          
 WHERE MTY NOT IN ('O/N','1D','1W','2W','1M','3M','6M','1Y','2Y','3Y','5Y','10Y')                                                               
 AND A.CCY = 'USD'                                                                                                                              
                                                                                                                                                
 DELETE A                                                                                                                                       
 FROM #TEMP_DDFT_OFF A                                                                                                                          
 WHERE MTY NOT IN ('O/N','1D','1W','2W','1M','3M','6M','1Y','2Y','3Y','5Y','10Y')                                                               
 AND A.CCY = 'USD'                                                                                                                              
                                                                                                                                                
                                                                                                                                                
 --CLEAR 3                                                                                                                                      
 DELETE A                                                                                                                                       
 FROM #TEMP_DDFT_MID A                                                                                                                          
 WHERE CONTRIBRATE IN ('CHFSWAP')                                                                                                               
 AND A.CCY IN ('CHF') AND MTY = '1Y'                                                                                                            
                                                                                                                                                
 DELETE A                                                                                                                                       
 FROM #TEMP_DDFT_BID A                                                                                                                          
 WHERE CONTRIBRATE IN ('CHFSWAP')                                                                                                               
 AND A.CCY IN ('CHF') AND MTY = '1Y'                                                                                                            
                                                                                                                                                
 DELETE A                                                                                                                                       
 FROM #TEMP_DDFT_OFF A                                                                                                                          
 WHERE CONTRIBRATE IN ('CHFSWAP')                                                                                                               
 AND A.CCY IN ('CHF') AND MTY = '1Y'                                                                                                            
                                                                                                                                                
                                                                                                                                                
                                                                                                                                                
                                                                                                                                                
 --PILIH TRANSAKSI HEADERNYA UNTUK MENENTUKAN PAIRING                                                                                           
 SELECT DISTINCT(SWDH.DEALNO)                                                                                                                   
 INTO #TEMP_NONPAIR                                                                                                                             
 FROM  [OPICSDB1].[OPICSBID].dbo.SWDH SWDH                                                                                      
 WHERE SWDH.NPVBAMT <> 0                                                                                                                        
  AND SWDH.REVREASON = ''                                                                                                                       
  AND SWDH.VERDATE IS NOT NULL                                                                                                                  
  AND ((SWDH.DEALIND = 'O' and SWDH.ACTIVEIND = 'Y') OR SWDH.DEALIND = 'S')                                                                     
  AND LTRIM(RTRIM(ISNULL(SWDH.DEALLINKNO,''))) = ''                                                                                             
  AND MATDATE > @DATA                                                                                                                           
                                                                                                                                                
                                                                                                                                                
                                                                                                                                                
                                                                                                                                                
 --SELECT UPPER AND LOWER HITUNGAN, UDAH DI INCLUDE NON-PAIRING                                                                                 
 SELECT A.CNO,                                                                                                                                  
        A.SOURCE,                                                                                                                               
        A.DEALNO,                                                                                                                               
 	   A.DEALIND,                                                                                                                               
 	   A.PRODUCT,                                                                                                                               
 	   A.PRODTYPE,                                                                                                                              
 	   A.SEQ,                                                                                                                                   
 	   A.SCHDSEQ,                                                                                                                               
 	   A.INTCCY,                                                                                                                                
 	   A.IPAYDATE,                                                                                                                              
 	   A.PRINAMT,                                                                                                                               
 	   A.PRINCCY,                                                                                                                               
 	   A.SCHDTYPE,                                                                                                                              
 	   A.INTRATE_8,                                                                                                                             
 	   A.SPREAD_8,                                                                                                                              
 	   A.NOTIONAL_AMT,                                                                                                                          
 	   A.INTSTRTDTE,                                                                                                                            
 	   A.INTENDDTE,                                                                                                                             
 	   A.MATINTDTE,                                                                                                                             
 	   A.INTAMT,                                                                                                                                
 	   A.IMPLINTAMT,                                                                                                                            
 	   A.PPAYAMT,                                                                                                                               
 	   A.PVAMT,                                                                                                                                 
 	   A.PVBAMT,                                                                                                                                
 	   A.PAYRECIND,                                                                                                                             
 	   A.FIXFLOATIND,                                                                                                                           
                                                                                                                                                
        ABS(DATEDIFF(DAY, A.INTSTRTDTE, DDFT.MATDATE)) STARTDATE_DELTA,                                                                         
 	   CASE WHEN DATEDIFF(DAY, A.INTSTRTDTE, DDFT.MATDATE) <= 0                                                                                 
 	          THEN 'L'                                                                                                                          
 			ELSE 'U'                                                                                                                            
        END STARTDATE_INDICATOR,                                                                                                                
                                                                                                                                                
 	   ABS(DATEDIFF(DAY, A.INTENDDTE, DDFT.MATDATE)) ENDDATE_DELTA,                                                                             
 	   CASE WHEN DATEDIFF(DAY, A.INTENDDTE, DDFT.MATDATE) <= 0                                                                                  
 	          THEN 'L'                                                                                                                          
 			ELSE 'U'                                                                                                                            
        END ENDDATE_INDICATOR,                                                                                                                  
        CASE WHEN E.DEALNO IS NOT NULL --AND A.PRODTYPE = 'IR'                                                                                  
 				THEN CASE WHEN A.PAYRECIND = 'R'                                                                                                
 							THEN DDFT.DISCFACT_BID                                                                                              
 						  ELSE DDFT.DISCFACT_OFF                                                                                                
 					  END                                                                                                                       
 			ELSE DDFT.DISCFACT_MID                                                                                                              
 	   END DISCFACT_10,                                                                                                                         
 	   DDFT.MATDATE DDFT_MATDATE,                                                                                                               
 	   DDFT.MTY,                                                                                                                                
 	   A.EXCHAMT,                                                                                                                               
 	   A.EXCHBAMT                                                                                                                               
                                                                                                                                                
 INTO #TEMP_DF                                                                                                                                  
 FROM #TEMP_SWAP A                                                                                                                              
                                                                                                                                                
 LEFT JOIN                                                                                                                                      
 (                                                                                                                                              
 	SELECT B.CCY, B.SPOTDATE, B.SCALAR, B.TERM, B.MTY, B.RATE,                                                                                  
 	       B.SPREAD_RATE, B.MATDATE, B.URUTAN, B.CONTRIBRATE,                                                                                   
 	       B.DISCFACT_10 DISCFACT_MID,                                                                                                          
 		   C.DISCFACT_10 DISCFACT_BID,                                                                                                          
 		   D.DISCFACT_10 DISCFACT_OFF                                                                                                           
 	FROM #TEMP_DDFT_MID B                                                                                                                       
                                                                                                                                                
 	LEFT JOIN #TEMP_DDFT_BID C                                                                                                                  
 	ON B.CCY = C.CCY AND B.MTY = C.MTY AND B.CONTRIBRATE = C.CONTRIBRATE                                                                        
                                                                                                                                                
 	LEFT JOIN #TEMP_DDFT_OFF D                                                                                                                  
 	ON B.CCY = D.CCY AND B.MTY = D.MTY AND B.CONTRIBRATE = D.CONTRIBRATE                                                                        
 )DDFT                                                                                                                                          
 ON A.INTCCY = DDFT.CCY                                                                                                                         
                                                                                                                                                
 LEFT JOIN #TEMP_NONPAIR E                                                                                                                      
 ON A.DEALNO = E.DEALNO;                                                                                                                        
                                                                                                                                                
                                                                                                                                                
                                                                                                                                                
 --GET UPPER AND LOWER AND SPOTDATE                                                                                                             
 SELECT RANK() OVER(PARTITION BY PRODTYPE, CNO, DEALNO, SEQ, SCHDSEQ ORDER BY ENDDATE_DELTA) ROWNUMBER,                                         
        A.*                                                                                                                                     
 INTO #TEMP_DF_RANK                                                                                                                             
 FROM                                                                                                                                           
 (                                                                                                                                              
 	SELECT A.*,                                                                                                                                 
 		   RANK() OVER(PARTITION BY CNO, DEALNO, SEQ, SCHDSEQ, PRODTYPE, STARTDATE_INDICATOR                                                    
 		               ORDER BY STARTDATE_DELTA) STARTDATE_RANK,                                                                                
 		   RANK() OVER(PARTITION BY CNO, DEALNO, SEQ, SCHDSEQ, PRODTYPE, ENDDATE_INDICATOR                                                      
 		               ORDER BY ENDDATE_DELTA) ENDDATE_RANK                                                                                     
 	FROM #TEMP_DF A                                                                                                                             
                                                                                                                                                
 )A                                                                                                                                             
 WHERE A.STARTDATE_RANK = 1 OR A.ENDDATE_RANK = 1 OR MTY = 'O/N'                                                                                
                                                                                                                                                
                                                                                                                                                
                                                                                                                                                
                                                                                                                                                
                                                                                                                                                
 --KUMPULIN DATA: URUTAN FIN UPPER AND FIN LOWER                                                                                                
 SELECT A.CNO,                                                                                                                                  
        A.SOURCE,                                                                                                                               
        A.DEALNO,                                                                                                                               
 	   A.PRODTYPE,                                                                                                                              
 	   A.DEALIND,                                                                                                                               
 	   A.PRODUCT,                                                                                                                               
 	   A.SEQ,                                                                                                                                   
 	   A.SCHDSEQ,                                                                                                                               
 	   A.INTCCY,                                                                                                                                
        A.PRINAMT,                                                                                                                              
 	   A.IPAYDATE,                                                                                                                              
        A.PRINCCY,                                                                                                                              
 	   A.SCHDTYPE,                                                                                                                              
        A.INTRATE_8,                                                                                                                            
        A.SPREAD_8,                                                                                                                             
        A.NOTIONAL_AMT,                                                                                                                         
 	   A.INTSTRTDTE,                                                                                                                            
 	   A.INTENDDTE,                                                                                                                             
 	   A.MATINTDTE,                                                                                                                             
 	   E.DDFT_MATDATE DDFT_MATDATE,                                                                                                             
 	   A.INTAMT,                                                                                                                                
 	   A.IMPLINTAMT,                                                                                                                            
 	   A.PPAYAMT,                                                                                                                               
 	   A.PVAMT,                                                                                                                                 
 	   A.PVBAMT,                                                                                                                                
 	   A.PAYRECIND,                                                                                                                             
 	   A.FIXFLOATIND,                                                                                                                           
                                                                                                                                                
 	   DATEDIFF(DAY, E.DDFT_MATDATE, C.INTSTRTDTE) INITDELTA,                                                                                   
 	   DATEDIFF(DAY, E.DDFT_MATDATE, A.INTENDDTE) FINDELTA,                                                                                     
                                                                                                                                                
 	   DATEDIFF(DAY, E.DDFT_MATDATE, D.DDFT_MATDATE) INIT_LDELTA,                                                                               
 	   D.DISCFACT_10 INIT_LDISCFACT,                                                                                                            
 	   DATEDIFF(DAY, E.DDFT_MATDATE, C.DDFT_MATDATE) INIT_UDELTA,                                                                               
 	   C.DISCFACT_10 INIT_UDISCFACT,                                                                                                            
                                                                                                                                                
 	   DATEDIFF(DAY, E.DDFT_MATDATE, A.DDFT_MATDATE) FIN_UDELTA,                                                                                
 	   A.DISCFACT_10 FIN_UDISCFACT,                                                                                                             
 	   DATEDIFF(DAY, E.DDFT_MATDATE, B.DDFT_MATDATE) FIN_LDELTA,                                                                                
 	   B.DISCFACT_10 FIN_LDISCFACT,                                                                                                             
                                                                                                                                                
 	   CONVERT(DEC(18, 10), 0) [TCI/TBI],                                                                                                       
        CONVERT(DEC(18, 10), 0) [TCI/TDI],                                                                                                      
        CONVERT(DEC(18, 10), 0) [TDI-TCI],                                                                                                      
        CONVERT(DEC(18, 10), 0) [TDI-TBI],                                                                                                      
        CONVERT(DEC(18, 10), 0) [TCI-TBI],                                                                                                      
        CONVERT(DEC(18, 10), 0) [TCF/TBF],                                                                                                      
        CONVERT(DEC(18, 10), 0) [TCF/TDF],                                                                                                      
        CONVERT(DEC(18, 10), 0) [TDF-TCF],                                                                                                      
        CONVERT(DEC(18, 10), 0) [TDF-TBF],                                                                                                      
        CONVERT(DEC(18, 10), 0) [TCF-TBF],                                                                                                      
 	   CONVERT(DEC(18, 10), 0) INIT_REAL_DISCFACT,                                                                                              
 	   CONVERT(DEC(18, 10), 0) FIN_REAL_DISCFACT,                                                                                               
                                                                                                                                                
 	   A.EXCHAMT,                                                                                                                               
 	   A.EXCHBAMT                                                                                                                               
                                                                                                                                                
 INTO #TEMP_FIRST_LEG                                                                                                                           
 FROM #TEMP_DF_RANK A                                                                                                                           
                                                                                                                                                
 LEFT JOIN #TEMP_DF_RANK B                                                                                                                      
 ON A.CNO = B.CNO                                                                                                                               
    AND A.DEALNO = B.DEALNO                                                                                                                     
    AND A.SEQ = B.SEQ                                                                                                                           
    AND A.SCHDSEQ = B.SCHDSEQ                                                                                                                   
    AND B.ENDDATE_INDICATOR = 'L' AND B.ENDDATE_RANK = 1                                                                                        
                                                                                                                                                
 LEFT JOIN #TEMP_DF_RANK C                                                                                                                      
 ON A.CNO = C.CNO                                                                                                                               
    AND A.DEALNO = C.DEALNO                                                                                                                     
    AND A.SEQ = C.SEQ                                                                                                                           
    AND A.SCHDSEQ = C.SCHDSEQ                                                                                                                   
    AND C.STARTDATE_INDICATOR = 'U' AND C.STARTDATE_RANK = 1                                                                                    
                                                                                                                                                
 LEFT JOIN #TEMP_DF_RANK D                                                                                                                      
 ON A.CNO = D.CNO                                                                                                                               
    AND A.DEALNO = D.DEALNO                                                                                                                     
    AND A.SEQ = D.SEQ                                                                                                                           
    AND A.SCHDSEQ = D.SCHDSEQ                                                                                                                   
    AND D.STARTDATE_INDICATOR = 'L' AND D.STARTDATE_RANK = 1                                                                                    
                                                                                                                                                
 LEFT JOIN #TEMP_DF_RANK E                                                                                                                      
 ON A.CNO = E.CNO                                                                                                                               
    AND A.DEALNO = E.DEALNO                                                                                                                     
    AND A.SEQ = E.SEQ                                                                                                                           
    AND A.SCHDSEQ = E.SCHDSEQ                                                                                                                   
    AND E.MTY = 'O/N'                                                                                                                           
                                                                                                                                                
 WHERE A.ENDDATE_INDICATOR = 'U' AND A.ENDDATE_RANK = 1;                                                                                        
                                                                                                                                                
                                                                                                                                                
                                                                                                                                                
 /*                                                                                                                                             
 UPDATE UNTUK YANG DELTA-NYA 0,                                                                                                                 
 ADA 2 CASE : 1. JIKA LOWER = SPOTDATE, PASTI INTSTRDATE = SPOTDATE                                                                             
                 KARENA, JIKA INTSTRDATE BEDA SATU HARI ATAU LEBIH DARI SPOTDATE, MAKA PASTI LOWER <> SPOTDATE                                  
              2. JIKA LOWER = MAX DDFT(TIDAK MUNGKIN)                                                                                           
 			 3. JIKA STARTDATE < SPOTDATE                                                                                                       
 YANG DIBAWAH UNTUK NO 3.                                                                                                                       
 */                                                                                                                                             
 --1. JIKA LOWER = SPOTDATE, PASTI INTSTRDATE = SPOTDATE                                                                                        
 --TARUH DI (SELECT FINAL)                                                                                                                      
 --2. (TIDAK MUNGKIN TERJADI)                                                                                                                   
 --3. JIKA STARTDATE < SPOTDATE                                                                                                                 
                                                                                                                                                
 UPDATE A                                                                                                                                       
 	SET A.INIT_LDELTA = CASE WHEN INITDELTA < 0 THEN NULL ELSE A.INIT_LDELTA END,                                                               
 	    A.INIT_LDISCFACT = CASE WHEN INITDELTA < 0 THEN NULL ELSE A.INIT_LDISCFACT END,                                                         
 	    A.INIT_UDELTA = CASE WHEN INITDELTA < 0 THEN NULL ELSE A.INIT_UDELTA END,                                                               
 		A.INIT_UDISCFACT = CASE WHEN INITDELTA < 0 THEN NULL ELSE A.INIT_UDISCFACT END                                                          
 FROM #TEMP_FIRST_LEG A                                                                                                                         
                                                                                                                                                
                                                                                                                                                
                                                                                                                                                
 --UPDATE REAL DISCOUNT FACTOR                                                                                                                  
 UPDATE A                                                                                                                                       
        SET [TCI/TBI] = CONVERT(DEC(18, 10), A.INITDELTA)/INIT_LDELTA,                                                                          
 	       [TCI/TDI] = CONVERT(DEC(18, 10), A.INITDELTA)/INIT_UDELTA,                                                                           
 	       [TDI-TCI] = CONVERT(DEC(18, 10), A.INIT_UDELTA) - CONVERT(DEC(18, 10), A.INITDELTA),                                                 
 	       [TDI-TBI] = CONVERT(DEC(18, 10), A.INIT_UDELTA) - CONVERT(DEC(18, 10), A.INIT_LDELTA),                                               
 	       [TCI-TBI] = CONVERT(DEC(18, 10), A.INITDELTA) - CONVERT(DEC(18, 10), A.INIT_LDELTA)                                                  
 FROM #TEMP_FIRST_LEG A                                                                                                                         
 WHERE INIT_LDELTA <> 0                                                                                                                         
                                                                                                                                                
 UPDATE A                                                                                                                                       
        SET [TCF/TBF] = CONVERT(DEC(18, 10), A.FINDELTA)/FIN_LDELTA,                                                                            
 	       [TCF/TDF] = CONVERT(DEC(18, 10), A.FINDELTA)/FIN_UDELTA,                                                                             
 	       [TDF-TCF] = CONVERT(DEC(18, 10), A.FIN_UDELTA) - CONVERT(DEC(18, 10), A.FINDELTA),                                                   
 	       [TDF-TBF] = CONVERT(DEC(18, 10), A.FIN_UDELTA) - CONVERT(DEC(18, 10), A.FIN_LDELTA),                                                 
 	       [TCF-TBF] = CONVERT(DEC(18, 10), A.FINDELTA) - CONVERT(DEC(18, 10), A.FIN_LDELTA)                                                    
                                                                                                                                                
 FROM #TEMP_FIRST_LEG A                                                                                                                         
 WHERE FIN_LDELTA <> 0                                                                                                                          
                                                                                                                                                
                                                                                                                                                
                                                                                                                                                
 --SELECT FINAL, INITDELTA < 0 MUNGKIN, TAPI FINDELTA < 0 GA MASUK OUTSTANDING                                                                  
 UPDATE A                                                                                                                                       
 	SET                                                                                                                                         
 	    INIT_REAL_DISCFACT = CASE WHEN A.INITDELTA > 0 AND A.INIT_LDELTA <> 0                                                                   
 								THEN CONVERT(DEC(18,10), POWER(A.INIT_LDISCFACT, A.[TCI/TBI]*([TDI-TCI]/[TDI-TBI])))*                           
 									 CONVERT(DEC(18,10), POWER(A.INIT_UDISCFACT, A.[TCI/TDI]*([TCI-TBI]/[TDI-TBI])))                            
 							  WHEN A.INIT_LDELTA = 0                                                                                            
 								THEN 1.0                                                                                                        
 							  ELSE 0                                                                                                            
 						 END,                                                                                                                   
                                                                                                                                                
 	    FIN_REAL_DISCFACT = CASE WHEN A.FIN_LDELTA <> 0                                                                                         
 		                        THEN CONVERT(DEC(18,10), POWER(A.FIN_LDISCFACT, A.[TCF/TBF]*([TDF-TCF]/[TDF-TBF])))*                            
 						             CONVERT(DEC(18,10), POWER(A.FIN_UDISCFACT, A.[TCF/TDF]*([TCF-TBF]/[TDF-TBF])))                             
 							 ELSE 0                                                                                                             
 						END                                                                                                                     
 FROM #TEMP_FIRST_LEG A;                                                                                                                        
                                                                                                                                                
                                                                                                                                                
                                                                                                                                                
                                                                                                                                                
                                                                                                                                                
                                                                                                                                                
                                                                                                                                                
 --UPDATE PVAMT                                                                                                                                 
 UPDATE A                                                                                                                                       
 	SET A.PVAMT = CASE WHEN A.INTCCY IN ('IDR', 'JPY', 'ITL')                                                                                   
 							THEN ROUND((A.PPAYAMT + A.INTAMT) * A.FIN_REAL_DISCFACT, 0)                                                         
 					   ELSE ROUND((A.PPAYAMT + A.INTAMT) * A.FIN_REAL_DISCFACT, 2)                                                              
 				 END,                                                                                                                           
 	    A.PVBAMT = ROUND(CASE WHEN A.INTCCY IN ('IDR', 'JPY', 'ITL')                                                                            
 								THEN ROUND((A.PPAYAMT + A.INTAMT) * A.FIN_REAL_DISCFACT, 0)*B.Rate                                              
 							ELSE ROUND((A.PPAYAMT + A.INTAMT) * A.FIN_REAL_DISCFACT, 2)*B.Rate                                                  
 						 END, 0)                                                                                                                
 FROM #TEMP_FIRST_LEG A                                                                                                                         
 LEFT JOIN TrxLLLTempCurrencyScreen B                                                                                                           
 ON A.INTCCY = B.CCY COLLATE SQL_Latin1_General_CP1_CI_AS                                                                                       
                  AND B.TransType = 'INTRA';                                                                                                    
                                                                                                                                                
                                                                                                                                                
                                                                                                                                                
 --GET SECOND LEG                                                                                                                               
 SELECT A.CNO,                                                                                                                                  
        A.SOURCE,                                                                                                                               
        A.DEALNO,                                                                                                                               
 	   A.PRODTYPE,                                                                                                                              
 	   A.PRODUCT,                                                                                                                               
 	   A.DEALIND,                                                                                                                               
 	   A.SEQ,                                                                                                                                   
 	   A.SCHDSEQ,                                                                                                                               
 	   B.IPAYDATE,                                                                                                                              
 	   A.INTSTRTDTE,                                                                                                                            
 	   A.INTENDDTE,                                                                                                                             
 	   DATEDIFF(DAY, A.INTSTRTDTE, A.INTENDDTE) n,                                                                                              
 	   DATEDIFF(DAY, A.INTSTRTDTE, A.MATINTDTE) n_for_cashflow,                                                                                 
 	   CAST(SUBSTRING(B.BASIS, 2, 3) AS INT) BASIS,                                                                                             
 	   A.PPAYAMT,                                                                                                                               
 	   B.PRINAMT,                                                                                                                               
 	   B.PRINCCY,                                                                                                                               
 	   B.INTRATE_8,                                                                                                                             
 	   B.SPREAD_8,                                                                                                                              
 	   B.INTCCY,                                                                                                                                
 	   B.INTAMT,   ----UNTUK KAKI-FLOAT AMBIL YANG IMPLINTAMT(NOT WORKING, BACK TO INTAMT)                                                      
 	   B.NOTIONAL_AMT,                                                                                                                          
 	   A.INIT_REAL_DISCFACT,                                                                                                                    
 	   A.FIN_REAL_DISCFACT,                                                                                                                     
                                                                                                                                                
 	   CONVERT(DEC(38, 10), 0.0)  PVAMT,                                                                                                        
 	   CONVERT(DEC(38, 10), 0.0)  PVBAMT                                                                                                        
 INTO #TEMP_FLOAT                                                                                                                               
 FROM #TEMP_FIRST_LEG A                                                                                                                         
 LEFT JOIN #TEMP_SWAP B                                                                                                                         
 ON  A.CNO = B.CNO                                                                                                                              
 AND A.DEALNO = B.DEALNO                                                                                                                        
 AND A.PRODTYPE = B.PRODTYPE                                                                                                                    
 AND A.SEQ = B.SEQ                                                                                                                              
 AND A.SCHDSEQ = B.SCHDSEQ                                                                                                                      
                                                                                                                                                
 WHERE B.FIXFLOATIND = 'L'                                                                                                                      
                                                                                                                                                
                                                                                                                                                
                                                                                                                                                
 --UPDATE IMPLIED RATE                                                                                                                          
 UPDATE A                                                                                                                                       
 	SET A.INTRATE_8 = CASE WHEN A.FIN_REAL_DISCFACT <> 0 AND A.INIT_REAL_DISCFACT <> 0                                                          
 							  THEN	((INIT_REAL_DISCFACT/FIN_REAL_DISCFACT - 1)*100*(CONVERT(DEC(18, 10), A.BASIS)/A.n) + A.SPREAD_8)           
 						   ELSE INTRATE_8                                                                                                       
 					  END                                                                                                                       
 FROM #TEMP_FLOAT A                                                                                                                             
                                                                                                                                                
                                                                                                                                                
                                                                                                                                                
 --UPDATE CASHFLOW                                                                                                                              
 UPDATE A                                                                                                                                       
 	SET A.INTAMT = CASE WHEN INTAMT = 0                                                                                                         
 						THEN ROUND(A.PRINAMT*A.INTRATE_8*0.01*A.n_for_cashflow/360, 2)                                                          
 				        ELSE INTAMT                                                                                                             
 				   END                                                                                                                          
 FROM #TEMP_FLOAT A                                                                                                                             
                                                                                                                                                
                                                                                                                                                
                                                                                                                                                
 --UPDATE PV                                                                                                                                    
 UPDATE A                                                                                                                                       
 	SET A.PVAMT = CASE WHEN A.SCHDSEQ NOT IN ('FEX', 'IEX')                                                                                     
 	                    THEN CASE WHEN A.INTCCY IN ('IDR', 'JPY', 'ITL')                                                                        
 						              THEN ROUND((A.PPAYAMT + INTAMT)*FIN_REAL_DISCFACT,0)                                                      
 								  ELSE ROUND((A.PPAYAMT + INTAMT)*FIN_REAL_DISCFACT,2)                                                          
 							 END                                                                                                                
 					   ELSE 0.00                                                                                                                
 				  END,                                                                                                                          
 		A.PVBAMT =ROUND(CASE WHEN A.SCHDSEQ NOT IN ('FEX', 'IEX')                                                                               
 								THEN CASE WHEN A.INTCCY IN ('IDR', 'JPY', 'ITL')                                                                
 											  THEN ROUND((A.PPAYAMT + INTAMT)*FIN_REAL_DISCFACT,0)                                              
 										  ELSE ROUND((A.PPAYAMT + INTAMT)*FIN_REAL_DISCFACT,2)                                                  
 									 END                                                                                                        
 							   ELSE 0.00                                                                                                        
 						  END*B.Rate, 0)                                                                                                        
 FROM #TEMP_FLOAT A                                                                                                                             
 LEFT JOIN TrxLLLTempCurrencyScreen B                                                                                                           
 ON A.INTCCY = B.CCY COLLATE SQL_Latin1_General_CP1_CI_AS                                                                                       
                  AND B.TransType = 'INTRA'                                                                                                     
                                                                                                                                                
                                                                                                                                                
                                                                                                                                                
                                                                                                                                                
                                                                                                                                                
                                                                                                                                                
                                                                                                                                                
 --GABUNGIN SEMUANYA - UPDATE ATURAN NON-PAIRING                                                                                                
 SELECT A.CNO,                                                                                                                                  
        A.SOURCE,                                                                                                                               
        A.DEALNO,                                                                                                                               
 	   A.PRODTYPE,                                                                                                                              
 	   A.PRODUCT,                                                                                                                               
 	   A.DEALIND,                                                                                                                               
 	   A.SEQ,                                                                                                                                   
 	   A.SCHDSEQ,                                                                                                                               
 	   A.INTSTRTDTE,                                                                                                                            
 	   A.INTENDDTE,                                                                                                                             
 	   A.PAYRECIND,                                                                                                                             
 	   A.FIXFLOATIND,                                                                                                                           
 	   A.PPAYAMT,                                                                                                                               
 	   A.PRINAMT,                                                                                                                               
 	   A.PRINCCY,                                                                                                                               
 	   A.IPAYDATE,                                                                                                                              
 	   CASE WHEN B.CNO IS NULL                                                                                                                  
 				THEN A.INTRATE_8                                                                                                                
 			ELSE B.INTRATE_8                                                                                                                    
 	   END INTRATE_8,                                                                                                                           
 	   A.SPREAD_8,                                                                                                                              
 	   A.INTCCY,                                                                                                                                
 	   CASE WHEN B.CNO IS NULL                                                                                                                  
 				THEN A.INTAMT                                                                                                                   
 			ELSE B.INTAMT                                                                                                                       
 	   END INTAMT,                                                                                                                              
 	   A.NOTIONAL_AMT,                                                                                                                          
 	   A.INIT_REAL_DISCFACT,                                                                                                                    
 	   A.FIN_REAL_DISCFACT,                                                                                                                     
 	   CASE WHEN B.CNO IS NULL                                                                                                                  
 				THEN A.PVAMT                                                                                                                    
 			ELSE B.PVAMT                                                                                                                        
 	   END PVAMT,                                                                                                                               
 	   CASE WHEN B.CNO IS NULL                                                                                                                  
 				THEN A.PVBAMT                                                                                                                   
 			ELSE B.PVBAMT                                                                                                                       
 	   END PVBAMT                                                                                                                               
 INTO #TEMP_FINAL_MTM                                                                                                                           
 FROM #TEMP_FIRST_LEG A                                                                                                                         
                                                                                                                                                
 LEFT JOIN #TEMP_FLOAT B                                                                                                                        
 ON  A.CNO = B.CNO                                                                                                                              
 	AND A.DEALNO = B.DEALNO                                                                                                                     
 	AND A.PRODTYPE = B.PRODTYPE                                                                                                                 
 	AND A.SEQ = B.SEQ                                                                                                                           
 	AND A.SCHDSEQ = B.SCHDSEQ                                                                                                                   
                                                                                                                                                
                                                                                                                                                
 --UPDATE ATURAN NON-PAIRING                                                                                                                    
 UPDATE A                                                                                                                                       
 	SET A.PVBAMT = CASE WHEN A.SCHDSEQ = 'FEX' AND ABS(A.NOTIONAL_AMT) = ABS(A.INTAMT) AND B.DEALNO IS NULL                                     
 							THEN A.PVBAMT                                                                                                       
 						ELSE CASE WHEN B.DEALNO IS NOT NULL                                                                                     
 										THEN CASE WHEN A.PAYRECIND = 'R'                                                                        
 														THEN A.PVAMT*C.SPOTRATE_8                                                               
 													  ELSE A.PVAMT*D.SPOTRATE_8                                                                 
 												  END                                                                                           
 										ELSE A.PVAMT*E.SPOTRATE_8                                                                               
                                    END                                                                                                         
 				   END                                                                                                                          
 FROM #TEMP_FINAL_MTM A                                                                                                                         
                                                                                                                                                
 LEFT JOIN #TEMP_NONPAIR B                                                                                                                      
 ON A.DEALNO = B.DEALNO                                                                                                                         
                                                                                                                                                
 LEFT JOIN [OPICSDB1].[OPICS].dbo.REVP E                                                                                     
 ON A.INTCCY = E.CCY                                                                                                                            
                                                                                                                                                
 LEFT JOIN [OPICSDB1].[OPICSBID].dbo.REVP C                                                                                     
 ON A.INTCCY = C.CCY                                                                                                                            
                                                                                                                                                
 LEFT JOIN [OPICSDB1].[OPICSOFF].dbo.REVP D                                                                                     
 ON A.INTCCY = D.CCY                                                                                                                            
                                                                                                                                                                      
                                                                                                                                                                      
                                                                                                                                                                      
                                                                                                                                                                      
                                                                                                                                                                      
                                                                                                                                                                      
 --NOTIONAL AMOUNT, UNTUK DEALNO YANG UDAH BERJALAN                                                                                                                   
 SELECT ABS(SWDS.PRINAMT) ORIGINAL_AMOUNT,                                                                                                                            
 	   ABS(SWDS.PRINAMT)*B.Rate AMOUNT,                                                                                                                               
 	   SWDS.PRINCCY,                                                                                                                                                  
 	   SWDS.DEALNO,                                                                                                                                                   
 	   SWDH.CNO,                                                                                                                                                      
 	   SWDS.PRODUCT,                                                                                                                                                  
 	   SWDS.PRODTYPE,                                                                                                                                                 
 	   SWDS.DEALIND,                                                                                                                                                  
 	   -- CASE WHEN SWDS.FIXFLOATIND = 'X'                                                                                                                            
 	   	--	THEN DATEDIFF(DAY, SWDH.DEALDATE, SWDH.MATDATE)/360.0                                                                                                     
 	   	--ELSE DATEDIFF(DAY, @DATA, SWDS.INTENDDTE)/360.0                                                                                                             
 	   -- END MATURITY,                                                                                                                                               
 	   DATEDIFF(DAY, @DATA, SWDH.MATDATE)/360.0 MATURITY,                                                                                                             
 	   RANK() OVER(PARTITION BY SWDS.DEALNO ORDER BY DATEDIFF(DAY, @DATA, SWDS.INTENDDTE) DESC) URUTAN,                                                               
 	   SWDS.SCHDSEQ DESCRIPTION                                                                                                                                       
 INTO #TEMP_NOTIONAL_BERJALAN                                                                                                                                         
 FROM #TEMP_FINAL_MTM SWDS                                                                                                                                            
                                                                                                                                                                      
 LEFT JOIN [OPICSDB1].[OPICS].dbo.SWDH                                                                                                             
 ON SWDS.DEALNO = SWDH.DEALNO                                                                                                                                         
                                                                                                                                                                      
 LEFT JOIN TrxLLLTempCurrencyScreen B                                                                                                                                 
 ON SWDS.PRINCCY = B.CCY COLLATE Latin1_General_BIN                                                                                                                   
 AND B.TransType = 'INTRA'                                                                                                                                            
                                                                                                                                                                      
 WHERE @DATA BETWEEN SWDS.INTSTRTDTE                                                                                                                                  
 AND SWDS.INTENDDTE                                                                                                                                                   
 AND SWDS.PAYRECIND = 'R'                                                                                                                                             
 AND SWDS.PRINCCY <> 'X'                                                                                                                                              
                                                                                                                                                                      
                                                                                                                                                                      
 --NOTIONAL AMOUNT, UNTUK DEALNO YANG BARU DIMANA DEALDATE NYA UDAH MULAI TAPI INTEREST STARTDATE NYA BLUM MULAI                                                      
 SELECT ABS(SWDS.PRINAMT) ORIGINAL_AMOUNT,                                                                                                                            
 	   ABS(SWDS.PRINAMT)*B.Rate AMOUNT,                                                                                                                               
 	   SWDS.PRINCCY,                                                                                                                                                  
 	   SWDS.DEALNO,                                                                                                                                                   
 	   SWDH.CNO,                                                                                                                                                      
 	   SWDS.PRODUCT,                                                                                                                                                  
 	   SWDS.PRODTYPE,                                                                                                                                                 
 	   SWDS.DEALIND,                                                                                                                                                  
 	  -- CASE WHEN SWDS.FIXFLOATIND = 'X'                                                                                                                             
 			--	THEN DATEDIFF(DAY, SWDH.DEALDATE, SWDH.MATDATE)/360.0                                                                                                 
 			--ELSE DATEDIFF(DAY, @DATA, SWDS.INTENDDTE)/360.0                                                                                                         
 	  -- END MATURITY,                                                                                                                                                
 	   DATEDIFF(DAY, @DATA, SWDH.MATDATE)/360.0 MATURITY,                                                                                                             
 	   RANK() OVER(PARTITION BY SWDS.DEALNO ORDER BY DATEDIFF(DAY, @DATA, SWDS.INTENDDTE) DESC) URUTAN,                                                               
 	   SWDS.SCHDSEQ DESCRIPTION                                                                                                                                       
 INTO #TEMP_NOTIONAL_BARU                                                                                                                                             
 FROM [OPICSDB1].[OPICS].dbo.SWDS                                                                                                                  
                                                                                                                                                                      
 LEFT JOIN [OPICSDB1].[OPICS].dbo.SWDH                                                                                                             
 ON SWDS.DEALNO = SWDH.DEALNO                                                                                                                                         
                                                                                                                                                                      
 LEFT JOIN TrxLLLTempCurrencyScreen B                                                                                                                                 
 ON SWDS.PRINCCY = B.CCY COLLATE Latin1_General_BIN                                                                                                                   
 AND B.TransType = 'INTRA'                                                                                                                                            
                                                                                                                                                                      
 WHERE @DATA BETWEEN SWDH.DEALDATE                                                                                                                                    
 AND SWDS.INTSTRTDTE                                                                                                                                                  
 AND ISNULL(SWDH.REVREASON, '') = ''                                                                                                                                  
 AND SWDS.PAYRECIND = 'R'                                                                                                                                             
 AND SWDS.SCHDSEQ = 1                                                                                                                                                 
 AND SWDS.DEALNO NOT IN (SELECT DISTINCT DEALNO FROM #TEMP_NOTIONAL_BERJALAN WHERE URUTAN=1)                                                                          
 AND SWDS.PRINCCY <> 'X'                                                                                                                                              
                                                                                                                                                                      
                                                                                                                                                                      
 --NOTIONAL AMOUNT                                                                                                                                                    
 SELECT *                                                                                                                                                             
 INTO #TEMP_NOTIONAL                                                                                                                                                  
 FROM                                                                                                                                                                 
 (                                                                                                                                                                    
     --UNTUK DEALNO YANG UDAH BERJALAN                                                                                                                                
 	SELECT *                                                                                                                                                          
 	FROM #TEMP_NOTIONAL_BERJALAN                                                                                                                                      
                                                                                                                                                                      
                                                                                                                                                                      
 	UNION                                                                                                                                                             
                                                                                                                                                                      
 	--UNTUK DEALNO YANG BARU DIMANA DEALDATE NYA UDAH MULAI TAPI INTEREST STARTDATE NYA BLUM MULAI                                                                    
 	SELECT *                                                                                                                                                          
 	FROM #TEMP_NOTIONAL_BARU                                                                                                                                          
                                                                                                                                                                      
 )A                                                                                                                                                                   
 WHERE A.URUTAN = 1;                                                                                                                                                  
                                                                                                                                                                      
                                                                                                                                                                      
                                                                                                                                                                      
                                                                                                                                                                      
 --MTM (1.TRANS)                                                                                                                                                      
 INSERT INTO TrxLLLMTMDRTV (Tanggal, Bulan, Tahun, TransType, CustomerID, SourceTable, DEALNO,                                                                        
                            SEQ, SCHDSEQ, PRODUCT, PRODTYPE, DEALIND, Amount, CCY, OriginalAmount)                                                                    
 SELECT DAY(@CURRENT),                                                                                                                                                
        MONTH(@CURRENT),                                                                                                                                              
 	   YEAR(@CURRENT),                                                                                                                                                
 	   'TRANS',                                                                                                                                                       
 	   A.CNO,                                                                                                                                                         
 	   A.SOURCE,                                                                                                                                                      
 	   A.DEALNO,                                                                                                                                                      
 	   A.SEQ,                                                                                                                                                         
 	   A.SCHDSEQ,                                                                                                                                                     
 	   A.PRODUCT,                                                                                                                                                     
 	   A.PRODTYPE,                                                                                                                                                    
 	   A.DEALIND,                                                                                                                                                     
 	   A.PVBAMT,                                                                                                                                                      
 	   A.PRINCCY,                                                                                                                                                     
 	   A.PVAMT                                                                                                                                                        
 FROM #TEMP_FINAL_MTM A                                                                                                                                               
                                                                                                                                                                      
                                                                                                                                                                      
 --MTM (2.VALUE)                                                                                                                                                      
 INSERT INTO TrxLLLMTMDRTV (Tanggal, Bulan, Tahun, TransType, CustomerID, SourceTable, DEALNO,                                                                        
                            SEQ, SCHDSEQ, PRODUCT, PRODTYPE, DEALIND, Amount, CCY, OriginalAmount)                                                                    
 SELECT DAY(@CURRENT),                                                                                                                                                
        MONTH(@CURRENT),                                                                                                                                              
 	   YEAR(@CURRENT),                                                                                                                                                
 	   'VALUE',                                                                                                                                                       
 	   A.CNO,                                                                                                                                                         
 	   A.SOURCE,                                                                                                                                                      
 	   A.DEALNO,                                                                                                                                                      
 	   A.SEQ,                                                                                                                                                         
 	   A.SCHDSEQ,                                                                                                                                                     
 	   A.PRODUCT,                                                                                                                                                     
 	   A.PRODTYPE,                                                                                                                                                    
 	   A.DEALIND,                                                                                                                                                     
 	   A.PVBAMT,                                                                                                                                                      
 	   A.PRINCCY,                                                                                                                                                     
 	   A.PVAMT                                                                                                                                                        
 FROM #TEMP_FINAL_MTM A                                                                                                                                               
                                                                                                                                                                      
                                                                                                                                                                      
                                                                                                                                                                      
                                                                                                                                                                      
 --NOTAMT (1.TRANS)                                                                                                                                                   
 INSERT INTO TrxLLLNotionalDRTV (Tanggal, Bulan, Tahun, TransType, CustomerID,                                                                                        
                                 DEALNO, SEQ, PRODUCT, PRODTYPE, DEALIND,                                                                                             
 								AMOUNT, PE, PrinCCY, OriginalAmount, Description )                                                                                    
 SELECT DAY(@CURRENT),                                                                                                                                                
        MONTH(@CURRENT),                                                                                                                                              
 	   YEAR(@CURRENT),                                                                                                                                                
 	   'TRANS',                                                                                                                                                       
 	   A.CNO,                                                                                                                                                         
 	   A.DEALNO,                                                                                                                                                      
 	   NULL SEQ,                                                                                                                                                      
 	   A.PRODUCT,                                                                                                                                                     
 	   A.PRODTYPE,                                                                                                                                                    
 	   A.DEALIND,                                                                                                                                                     
 	   A.AMOUNT,                                                                                                                                                      
 	   CASE WHEN A.MATURITY <= 1 THEN CASE WHEN A.PRODTYPE = 'IR'                                                                                                     
 											 THEN 0                                                                                                                   
 										   ELSE 0.01                                                                                                                  
 									   END                                                                                                                            
             WHEN A.MATURITY > 1 AND A.MATURITY <= 5 THEN CASE WHEN A.PRODTYPE = 'IR'                                                                                 
 											 THEN 0.005                                                                                                               
 										   ELSE 0.055                                                                                                                 
 									   END                                                                                                                            
 			WHEN A.MATURITY > 5 THEN CASE WHEN A.PRODTYPE = 'IR'                                                                                                      
 											 THEN 0.015                                                                                                               
 										   ELSE 0.09                                                                                                                  
 									   END                                                                                                                            
                                                                                                                                                                      
 	   END PE,                                                                                                                                                        
 	   A.PRINCCY,                                                                                                                                                     
 	   A.ORIGINAL_AMOUNT,                                                                                                                                             
 	   A.DESCRIPTION                                                                                                                                                  
 FROM #TEMP_NOTIONAL A                                                                                                                                                
                                                                                                                                                                      
                                                                                                                                                                      
                                                                                                                                                                      
 --NOTAMT (2.VALUE)                                                                                                                                                   
 INSERT INTO TrxLLLNotionalDRTV (Tanggal, Bulan, Tahun, TransType, CustomerID,                                                                                        
                                 DEALNO, SEQ, PRODUCT, PRODTYPE, DEALIND,                                                                                             
 								AMOUNT, PE, PrinCCY, OriginalAmount, Description )                                                                                    
 SELECT DAY(@CURRENT),                                                                                                                                                
        MONTH(@CURRENT),                                                                                                                                              
 	   YEAR(@CURRENT),                                                                                                                                                
 	   'VALUE',                                                                                                                                                       
 	   A.CNO,                                                                                                                                                         
 	   A.DEALNO,                                                                                                                                                      
 	   NULL SEQ,                                                                                                                                                      
 	   A.PRODUCT,                                                                                                                                                     
 	   A.PRODTYPE,                                                                                                                                                    
 	   A.DEALIND,                                                                                                                                                     
 	   A.AMOUNT,                                                                                                                                                      
 	   CASE WHEN A.MATURITY <= 1 THEN CASE WHEN A.PRODTYPE = 'IR'                                                                                                     
 											 THEN 0                                                                                                                   
 										   ELSE 0.01                                                                                                                  
 									   END                                                                                                                            
             WHEN A.MATURITY > 1 AND A.MATURITY <= 5 THEN CASE WHEN A.PRODTYPE = 'IR'                                                                                 
 											 THEN 0.005                                                                                                               
 										   ELSE 0.055                                                                                                                 
 									   END                                                                                                                            
 			WHEN A.MATURITY > 5 THEN CASE WHEN A.PRODTYPE = 'IR'                                                                                                      
 											 THEN 0.015                                                                                                               
 										   ELSE 0.09                                                                                                                  
 									   END                                                                                                                            
                                                                                                                                                                      
 	   END PE,                                                                                                                                                        
 	   A.PRINCCY,                                                                                                                                                     
 	   A.ORIGINAL_AMOUNT,                                                                                                                                             
 	   A.DESCRIPTION                                                                                                                                                  
 FROM #TEMP_NOTIONAL A                                                                                                                                                
                                                                                                                                                                      
                                                                                                                                                                      
                                                                                                                                                                      
 -------------------------------------------------------F. SBLC LN                                                                                                    
                                                                                                                                                                      
 --(1. TRANS)                                                                                                                                                         
 INSERT INTO TrxLLLSBLCLN (Tanggal, Bulan, Tahun, TransType, CustomerID, TransNo, SBLCID,                                                                             
                           CANumber, AgreementNo, CCY1, Amount, OriginalAmount1, CCY2, CCY3, OriginalAmount2, OriginalAmount3)                                        
 SELECT DAY(@CURRENT),                                                                                                                                                
        MONTH(@CURRENT),                                                                                                                                              
 	   YEAR(@CURRENT),                                                                                                                                                
 	   'TRANS',                                                                                                                                                       
 	   A.CustomerID,                                                                                                                                                  
 	   B.TransNo,                                                                                                                                                     
 	   B.SBLCID,                                                                                                                                                      
 	   A.CaNumCDM,                                                                                                                                                    
 	   A.CurCAAgreementNo,                                                                                                                                            
 	   B.PartOutCCY,                                                                                                                                                  
 	   B.PartoutAmount*D.Rate,                                                                                                                                        
 	   B.PartOutAmount,                                                                                                                                               
 	   NULL,                                                                                                                                                          
 	   NULL,                                                                                                                                                          
 	   NULL,                                                                                                                                                          
 	   NULL                                                                                                                                                           
 FROM [ERPLIVE].[BMIERP].dbo.MasterSBLCTransaction A                                                                                                         
                                                                                                                                                                      
 LEFT JOIN [ERPLIVE].[BMIERP].dbo.TrxSBLCTransaction B                                                                                                       
 ON B.SBLCID = A.SBLCID                                                                                                                                               
                                                                                                                                                                      
 LEFT JOIN [ERPLIVE].[BMIERP].dbo.MasterCustomer C                                                                                                           
 ON C.CustomerID = A.CustomerID                                                                                                                                       
                                                                                                                                                                      
 LEFT JOIN TrxLLLTempCurrencyScreen D                                                                                                                                 
 ON B.PartOutCCY = D.CCY AND D.TransType = 'INTRA'                                                                                                                    
                                                                                                                                                                      
 WHERE B.Flag = 0                                                                                                                                                     
 AND B.SBLCRemarkID NOT IN ('ERTM','TERM') AND ISNULL(B.Status,'') <> 'T'                                                                                             
 AND B.interestmatureddate >= @CURRENT                                                                                                                                
 AND convert(varchar(10),B.ApprovalDate,120) <= convert(varchar(10),@CURRENT,120)                                                                                     
 ORDER BY A.CustomerID;                                                                                                                                               
                                                                                                                                                                      
                                                                                                                                                                      
                                                                                                                                                                      
 --(2. VALUE)                                                                                                                                                         
 INSERT INTO TrxLLLSBLCLN (Tanggal, Bulan, Tahun, TransType, CustomerID, TransNo, SBLCID,                                                                             
                           CANumber, AgreementNo, CCY1, Amount, OriginalAmount1, CCY2, CCY3, OriginalAmount2, OriginalAmount3)                                        
 SELECT DAY(@CURRENT),                                                                                                                                                
        MONTH(@CURRENT),                                                                                                                                              
 	   YEAR(@CURRENT),                                                                                                                                                
 	   'VALUE',                                                                                                                                                       
 	   A.CustomerID,                                                                                                                                                  
 	   B.TransNo,                                                                                                                                                     
 	   B.SBLCID,                                                                                                                                                      
 	   A.CaNumCDM,                                                                                                                                                    
 	   A.CurCAAgreementNo,                                                                                                                                            
 	   B.PartOutCCY,                                                                                                                                                  
 	   B.PartoutAmount*D.Rate,                                                                                                                                        
 	   B.PartOutAmount,                                                                                                                                               
 	   NULL,                                                                                                                                                          
 	   NULL,                                                                                                                                                          
 	   NULL,                                                                                                                                                          
 	   NULL                                                                                                                                                           
 FROM [ERPLIVE].[BMIERP].dbo.MasterSBLCTransaction A                                                                                                         
                                                                                                                                                                      
 LEFT JOIN [ERPLIVE].[BMIERP].dbo.TrxSBLCTransaction B                                                                                                       
 ON B.SBLCID = A.SBLCID                                                                                                                                               
                                                                                                                                                                      
 LEFT JOIN [ERPLIVE].[BMIERP].dbo.MasterCustomer C                                                                                                           
 ON C.CustomerID = A.CustomerID                                                                                                                                       
                                                                                                                                                                      
 LEFT JOIN TrxLLLTempCurrencyScreen D                                                                                                                                 
 ON B.PartOutCCY = D.CCY AND D.TransType = 'INTRA'                                                                                                                    
                                                                                                                                                                      
 WHERE B.Flag = 0                                                                                                                                                     
 AND B.SBLCRemarkID NOT IN ('ERTM','TERM') AND ISNULL(B.Status,'') <> 'T'                                                                                             
 AND B.Interestvaluedate <= @CURRENT                                                                                                                                  
 AND B.interestmatureddate >= @CURRENT                                                                                                                                
 AND convert(varchar(10),B.ApprovalDate,120) <= convert(varchar(10),@CURRENT,120)                                                                                     
 ORDER BY A.CustomerID;                                                                                                                                               
                                                                                                                                                                      
 --(3. Trans By Facility Master)Added by Vincent 24-20-2018 to add sblcln beside from sblc using facility master				                                      
  INSERT INTO TrxLLLSBLCLN (Tanggal, Bulan, Tahun, TransType, CustomerID, TransNo, SBLCID,                                                                            
 			CANumber, AgreementNo, CCY1, Amount, OriginalAmount1, CCY2, CCY3, OriginalAmount2, OriginalAmount3)                                                       
 	SELECT  DAY(@CURRENT),                                                                                                                                            
 			MONTH(@CURRENT),                                                                                                                                          
 			YEAR(@CURRENT),                                                                                                                                           
            'TRANS',                                                                                                                                                  
 			B.CustomerID,                                                                                                                                             
 			NULL,                                                                                                                                                     
 			NULL,                                                                                                                                                     
 			C.CurrentCANumber,                                                                                                                                        
 			C.AgreementNo,                                                                                                                                            
            C.GCCY2,                                                                                                                                                  
 			ISNULL(C.ParticipationAmt*D1.Rate, 0) +                                                                                                                   
  			ISNULL(C.ParticipationAmt1*D2.Rate, 0) + ISNULL(C.ParticipationAmt2*D3.Rate, 0) SBLC_AMT,                                                                 
            C.ParticipationAmt,                                                                                                                                       
            C.GCCYPartAmt1,                                                                                                                                           
            C.GCCYPartAmt2,                                                                                                                                           
            C.ParticipationAmt1,                                                                                                                                      
            C.ParticipationAmt2                                                                                                                                       
 	FROM [ERPLIVE].[BMIERP].dbo.T_FacilityMaster A                                                                                                           
                                                                                                                                                                      
 	LEFT JOIN [ERPLIVE].[BMIERP].dbo.MasterCustomer B                                                                                                        
 	ON B.CustomerID = A.Custacnum                                                                                                                                     
                                                                                                                                                                      
 	INNER JOIN [ERPLIVE].[BMIERP].dbo.T_DetailsGuarantee C                                                                                                   
 	ON A.Custacnum = C.CustNo                                                                                                                                         
 	AND A.CANUMCDM = C.CurrentCANumber and A.[03C-14] = C.AgreementNo                                                                                                 
 	AND A.TYPETXN = C.TYPETXN                                                                                                                                         
                                                                                                                                                                      
 	LEFT JOIN TrxLLLTempCurrencyScreen D1                                                                                                                             
 	ON C.GCCY2 = D1.CCY  AND D1.TransType = 'INTRA'                                                                                                                   
                                                                                                                                                                      
 	LEFT JOIN TrxLLLTempCurrencyScreen D2                                                                                                                             
 	ON C.GCCYPartAmt1 = D2.CCY AND D2.TransType = 'INTRA'                                                                                                             
                                                                                                                                                                      
 	LEFT JOIN TrxLLLTempCurrencyScreen D3                                                                                                                             
 	ON C.GCCYPartAmt2 = D3.CCY  AND D3.TransType = 'INTRA'                                                                                                            
                                                                                                                                                                      
 	INNER JOIN                                                                                                                                                        
 	(                                                                                                                                                                 
 	SELECT DISTINCT CustomerID                                                                                                                                        
 	FROM TrxLLLLN E                                                                                                                                                   
 	WHERE E.Tanggal = DAY(@CURRENT)                                                                                                                                   
 		AND E.Bulan =  MONTH(@CURRENT)                                                                                                                                
 		AND E.Tahun =  YEAR(@CURRENT)                                                                                                                                 
 		AND E.TransType = 'TRANS'                                                                                                                                     
 	)E2                                                                                                                                                               
 	ON CONVERT(INT, E2.CustomerID) = CONVERT(INT, A.CUSTACNUM)                                                                                                        
                                                                                                                                                                      
 	WHERE A.statusbmi like '5%'                                                                                                                                       
 	AND ISNULL(PTCNUMBER,'')<>''                                                                                                                                      
 	AND ISNULL(A.GuarantorYN,'') ='Yes'                                                                                                                               
 	AND C.GPeriodeTo >= @CURRENT                                                                                                                                      
 	AND C.TypeOfGuarantee IN ('06')                                                                                                                                   
 	AND KodePenerbitAgunan IN (794) and ISNULL(C.includeLLL,'') = 'Y'                                                                                                 
 	AND C.TYPETXN IN ('LOAN','LOAN SYND')                                                                                                                             
                                                                                                                                                                      
 	UNION                                                                                                                                                             
                                                                                                                                                                      
 	SELECT  DAY(@CURRENT),                                                                                                                                            
 			MONTH(@CURRENT),                                                                                                                                          
 			YEAR(@CURRENT),                                                                                                                                           
            'TRANS',                                                                                                                                                 
 			B.CustomerID,                                                                                                                                             
 			CONVERT(VARCHAR, C.GUARANTEEID),                                                                                                                          
 			NULL,                                                                                                                                                     
 			C.CurrentCANumber,                                                                                                                                        
 			C.AgreementNo,                                                                                                                                            
            C.GCCY2,                                                                                                                                                   
 			ISNULL(C.ParticipationAmt*D1.Rate, 0) +                                                                                                                   
  			ISNULL(C.ParticipationAmt1*D2.Rate, 0) + ISNULL(C.ParticipationAmt2*D3.Rate, 0) SBLC_AMT,                                                                 
            C.ParticipationAmt,                                                                                                                                       
            C.GCCYPartAmt1,                                                                                                                                           
            C.GCCYPartAmt2,                                                                                                                                           
            C.ParticipationAmt1,                                                                                                                                      
            C.ParticipationAmt2                                                                                                                                       
 	FROM [ERPLIVE].[BMIERP].dbo.T_FacilityMaster A                                                                                                           
                                                                                                                                                                      
 	LEFT JOIN [ERPLIVE].[BMIERP].dbo.MasterCustomer B                                                                                                        
 	ON B.CustomerID = A.Custacnum                                                                                                                                     
                                                                                                                                                                      
 	INNER JOIN [ERPLIVE].[BMIERP].dbo.T_DetailsGuarantee C                                                                                                   
 	ON A.Custacnum = C.CustNo                                                                                                                                         
 	AND A.CANUMCDM = C.CurrentCANumber and A.[03C-14] = C.AgreementNo                                                                                                 
 	AND A.TYPETXN = C.TYPETXN                                                                                                                                         
                                                                                                                                                                      
 	INNER JOIN [ERPLIVE].[BMIERP].dbo.MasterAlternateCustNo ALTNO                                                                                            
 	ON ALTNO.CustNO = B.CustomerID AND ISNULL(ALTNO.AlternateNo,'') <> ''                                                                                             
                                                                                                                                                                      
 	LEFT JOIN TrxLLLTempCurrencyScreen D1                                                                                                                             
 	ON C.GCCY2 = D1.CCY  AND D1.TransType = 'INTRA'                                                                                                                   
                                                                                                                                                                      
 	LEFT JOIN TrxLLLTempCurrencyScreen D2                                                                                                                             
 	ON C.GCCYPartAmt1 = D2.CCY AND D2.TransType = 'INTRA'                                                                                                             
                                                                                                                                                                      
 	LEFT JOIN TrxLLLTempCurrencyScreen D3                                                                                                                             
 	ON C.GCCYPartAmt2 = D3.CCY  AND D3.TransType = 'INTRA'                                                                                                            
                                                                                                                                                                      
 	INNER JOIN                                                                                                                                                        
 	(                                                                                                                                                                 
 	SELECT DISTINCT CustomerID                                                                                                                                        
 	FROM TrxLLLLN E                                                                                                                                                   
 	WHERE E.Tanggal = DAY(@CURRENT)                                                                                                                                   
 		AND E.Bulan =  MONTH(@CURRENT)                                                                                                                                
 		AND E.Tahun =  YEAR(@CURRENT)                                                                                                                                 
 		AND E.TransType = 'TRANS'                                                                                                                                     
 	)E2                                                                                                                                                               
 	ON CONVERT(INT, E2.CustomerID) = CONVERT(INT, ALTNO.Alternateno)                                                                                                  
                                                                                                                                                                      
 	WHERE A.statusbmi like '5%'                                                                                                                                       
 	AND ISNULL(A.GuarantorYN,'') ='Yes'                                                                                                                               
 	AND ISNULL(PTCNUMBER,'')<>''                                                                                                                                      
 	AND C.GPeriodeTo >= @CURRENT                                                                                                                                      
 	AND C.TypeOfGuarantee IN ('06')                                                                                                                                   
 	AND KodePenerbitAgunan IN (794) and ISNULL(C.includeLLL,'') = 'Y'                                                                                                 
 	AND C.TYPETXN IN ('LOAN','LOAN SYND')                                                                                                                             
 	AND  B.CustomerID = ALTNO.CustNO                                                                                                                                  
                                                                                                                                                                      
                                                                                                                                                                      
                                                                                                                                                                      
 --(4. Value By Facility Master)Added by Vincent 24-20-2018 to add sblcln beside from sblc using facility master	                                                  
 INSERT INTO TrxLLLSBLCLN (Tanggal, Bulan, Tahun, TransType, CustomerID, TransNo, SBLCID,                                                                             
 			CANumber, AgreementNo, CCY1, Amount, OriginalAmount1, CCY2, CCY3, OriginalAmount2, OriginalAmount3)                                                       
 	SELECT  DAY(@CURRENT),                                                                                                                                            
 			MONTH(@CURRENT),                                                                                                                                          
 			YEAR(@CURRENT),                                                                                                                                           
                     'VALUE',                                                                                                                                         
 			B.CustomerID,                                                                                                                                             
 			CONVERT(VARCHAR, C.GUARANTEEID),                                                                                                                          
 			NULL,                                                                                                                                                     
 			C.CurrentCANumber,                                                                                                                                        
 			C.AgreementNo,                                                                                                                                            
            C.GCCY2,                                                                                                                                                  
 			ISNULL(C.ParticipationAmt*D1.Rate, 0) +                                                                                                                   
  			ISNULL(C.ParticipationAmt1*D2.Rate, 0) + ISNULL(C.ParticipationAmt2*D3.Rate, 0) SBLC_AMT,                                                                 
            C.ParticipationAmt,                                                                                                                                       
            C.GCCYPartAmt1,                                                                                                                                           
            C.GCCYPartAmt2,                                                                                                                                           
            C.ParticipationAmt1,                                                                                                                                      
            C.ParticipationAmt2                                                                                                                                       
 	FROM [ERPLIVE].[BMIERP].dbo.T_FacilityMaster A                                                                                                           
                                                                                                                                                                      
 	LEFT JOIN [ERPLIVE].[BMIERP].dbo.MasterCustomer B                                                                                                        
 	ON B.CustomerID = A.Custacnum                                                                                                                                     
                                                                                                                                                                      
 	INNER JOIN [ERPLIVE].[BMIERP].dbo.T_DetailsGuarantee C                                                                                                   
 	ON A.Custacnum = C.CustNo                                                                                                                                         
 	AND A.CANUMCDM = C.CurrentCANumber and A.[03C-14] = C.AgreementNo                                                                                                 
 	AND A.TYPETXN = C.TYPETXN                                                                                                                                         
                                                                                                                                                                      
 	LEFT JOIN TrxLLLTempCurrencyScreen D1                                                                                                                             
 	ON C.GCCY2 = D1.CCY  AND D1.TransType = 'INTRA'                                                                                                                   
                                                                                                                                                                      
 	LEFT JOIN TrxLLLTempCurrencyScreen D2                                                                                                                             
 	ON C.GCCYPartAmt1 = D2.CCY AND D2.TransType = 'INTRA'                                                                                                             
                                                                                                                                                                      
 	LEFT JOIN TrxLLLTempCurrencyScreen D3                                                                                                                             
 	ON C.GCCYPartAmt2 = D3.CCY  AND D3.TransType = 'INTRA'                                                                                                            
                                                                                                                                                                      
 	INNER JOIN                                                                                                                                                        
 	(                                                                                                                                                                 
 	SELECT DISTINCT CustomerID                                                                                                                                        
 	FROM TrxLLLLN E                                                                                                                                                   
 	WHERE E.Tanggal = DAY(@CURRENT)                                                                                                                                   
 		AND E.Bulan =  MONTH(@CURRENT)                                                                                                                                
 		AND E.Tahun =  YEAR(@CURRENT)                                                                                                                                 
 		AND E.TransType = 'VALUE'                                                                                                                                     
 	)E2                                                                                                                                                               
 	ON CONVERT(INT, E2.CustomerID) = CONVERT(INT, A.CUSTACNUM)                                                                                                        
                                                                                                                                                                      
 	WHERE A.statusbmi like '5%'                                                                                                                                       
 	AND ISNULL(PTCNUMBER,'')<>''                                                                                                                                      
 	AND ISNULL(A.GuarantorYN,'') ='Yes'                                                                                                                               
 		AND @CURRENT BETWEEN C.GPeriodeFrom and C.GPeriodeTo                                                                                                          
 	AND C.TypeOfGuarantee IN ('06')                                                                                                                                   
 	AND KodePenerbitAgunan IN (794) and ISNULL(C.includeLLL,'') = 'Y'                                                                                                 
 	AND C.TYPETXN IN ('LOAN','LOAN SYND')                                                                                                                             
                                                                                                                                                                      
 	UNION                                                                                                                                                             
                                                                                                                                                                      
 	SELECT  DAY(@CURRENT),                                                                                                                                            
 			MONTH(@CURRENT),                                                                                                                                          
 			YEAR(@CURRENT),                                                                                                                                           
                             'VALUE',                                                                                                                                 
 			B.CustomerID,                                                                                                                                             
 			CONVERT(VARCHAR, C.GUARANTEEID),                                                                                                                          
 			NULL,                                                                                                                                                     
 			C.CurrentCANumber,                                                                                                                                        
 			C.AgreementNo,                                                                                                                                            
            C.GCCY2,                                                                                                                                                  
 			ISNULL(C.ParticipationAmt*D1.Rate, 0) +                                                                                                                   
  			ISNULL(C.ParticipationAmt1*D2.Rate, 0) + ISNULL(C.ParticipationAmt2*D3.Rate, 0) SBLC_AMT,                                                                 
            C.ParticipationAmt,                                                                                                                                       
            C.GCCYPartAmt1,                                                                                                                                           
            C.GCCYPartAmt2,                                                                                                                                           
            C.ParticipationAmt1,                                                                                                                                      
            C.ParticipationAmt2                                                                                                                                       
 	FROM [ERPLIVE].[BMIERP].dbo.T_FacilityMaster A                                                                                                           
                                                                                                                                                                      
 	LEFT JOIN [ERPLIVE].[BMIERP].dbo.MasterCustomer B                                                                                                        
 	ON B.CustomerID = A.Custacnum                                                                                                                                     
                                                                                                                                                                      
 	INNER JOIN [ERPLIVE].[BMIERP].dbo.T_DetailsGuarantee C                                                                                                   
 	ON A.Custacnum = C.CustNo                                                                                                                                         
 	AND A.CANUMCDM = C.CurrentCANumber and A.[03C-14] = C.AgreementNo                                                                                                 
 	AND A.TYPETXN = C.TYPETXN                                                                                                                                         
                                                                                                                                                                      
 	INNER JOIN [ERPLIVE].[BMIERP].dbo.MasterAlternateCustNo ALTNO                                                                                            
 	ON ALTNO.CustNO = B.CustomerID AND ISNULL(ALTNO.AlternateNo,'') <> ''                                                                                             
                                                                                                                                                                      
 	LEFT JOIN TrxLLLTempCurrencyScreen D1                                                                                                                             
 	ON C.GCCY2 = D1.CCY  AND D1.TransType = 'INTRA'                                                                                                                   
                                                                                                                                                                      
 	LEFT JOIN TrxLLLTempCurrencyScreen D2                                                                                                                             
 	ON C.GCCYPartAmt1 = D2.CCY AND D2.TransType = 'INTRA'                                                                                                             
                                                                                                                                                                      
 	LEFT JOIN TrxLLLTempCurrencyScreen D3                                                                                                                             
 	ON C.GCCYPartAmt2 = D3.CCY  AND D3.TransType = 'INTRA'                                                                                                            
                                                                                                                                                                      
 	INNER JOIN                                                                                                                                                        
 	(                                                                                                                                                                 
 	SELECT DISTINCT CustomerID                                                                                                                                        
 	FROM TrxLLLLN E                                                                                                                                                   
 	WHERE E.Tanggal = DAY(@CURRENT)                                                                                                                                   
 		AND E.Bulan =  MONTH(@CURRENT)                                                                                                                                
 		AND E.Tahun =  YEAR(@CURRENT)                                                                                                                                 
 		AND E.TransType = 'VALUE'                                                                                                                                     
 	)E2                                                                                                                                                               
 	ON CONVERT(INT, E2.CustomerID) = CONVERT(INT, ALTNO.Alternateno)                                                                                                  
                                                                                                                                                                      
 	WHERE A.statusbmi like '5%'                                                                                                                                       
 	AND ISNULL(A.GuarantorYN,'') ='Yes'                                                                                                                               
 	AND ISNULL(PTCNUMBER,'')<>''                                                                                                                                      
 	AND @CURRENT BETWEEN C.GPeriodeFrom and C.GPeriodeTo                                                                                                              
 	AND C.TypeOfGuarantee IN ('06')                                                                                                                                   
 	AND KodePenerbitAgunan IN (794) and ISNULL(C.includeLLL,'') = 'Y'                                                                                                 
 	AND C.TYPETXN IN ('LOAN','LOAN SYND')                                                                                                                             
 	AND  B.CustomerID = ALTNO.CustNO                                                                                                                                  
                                                                                                                                                                      
                                                                                                                                                                      
 -------------------------------------------------------G. SBLC GUARANTEE                                                                                             
                                                                                                                                                                      
 --(1. TRANS) Edited by Vincent 24-10-2018 to change condition that not all beside BG put inside                                                                      
 INSERT INTO TrxLLLSBLCBG(Tanggal, Bulan, Tahun, TransType, CustomerID, GuaranteeID,                                                                                  
                          CANumber, AgreementNo, TypeTXN, Amount, CCY1, CCY2, CCY3,                                                                                   
 						 OriginalAmount1, OriginalAmount2, OriginalAmount3)                                                                                           
 SELECT DAY(@CURRENT),                                                                                                                                                
        MONTH(@CURRENT),                                                                                                                                              
 	   YEAR(@CURRENT),                                                                                                                                                
 	   'TRANS',                                                                                                                                                       
 	   B.CustomerID,                                                                                                                                                  
 	   CONVERT(VARCHAR, C.GUARANTEEID),                                                                                                                               
 	   C.CurrentCANumber,                                                                                                                                             
 	   C.AgreementNo,                                                                                                                                                 
 	   C.TYPETXN,                                                                                                                                                     
 	   ISNULL(C.ParticipationAmt*D1.Rate, 0) +                                                                                                                        
 	     ISNULL(C.ParticipationAmt1*D2.Rate, 0) + ISNULL(C.ParticipationAmt2*D3.Rate, 0) SBLC_AMT,                                                                    
 	   C.GCCY2,                                                                                                                                                       
 	   C.GCCYPartAmt1,                                                                                                                                                
 	   C.GCCYPartAmt2,                                                                                                                                                
 	   C.ParticipationAmt,                                                                                                                                            
 	   C.ParticipationAmt1,                                                                                                                                           
 	   C.ParticipationAmt2                                                                                                                                            
 FROM [ERPLIVE].[BMIERP].dbo.T_FacilityMaster A                                                                                                              
                                                                                                                                                                      
 LEFT JOIN [ERPLIVE].[BMIERP].dbo.MasterCustomer B                                                                                                           
 ON B.CustomerID = A.Custacnum                                                                                                                                        
                                                                                                                                                                      
 INNER JOIN [ERPLIVE].[BMIERP].dbo.T_DetailsGuarantee C                                                                                                      
 ON A.Custacnum = C.CustNo                                                                                                                                            
    AND A.CANUMCDM = C.CurrentCANumber and A.[03C-14] = C.AgreementNo                                                                                                 
    AND A.TYPETXN = C.TYPETXN                                                                                                                                         
                                                                                                                                                                      
 LEFT JOIN TrxLLLTempCurrencyScreen D1                                                                                                                                
 ON C.GCCY2 = D1.CCY  AND D1.TransType = 'INTRA'                                                                                                                      
                                                                                                                                                                      
 LEFT JOIN TrxLLLTempCurrencyScreen D2                                                                                                                                
 ON C.GCCYPartAmt1 = D2.CCY AND D2.TransType = 'INTRA'                                                                                                                
                                                                                                                                                                      
 LEFT JOIN TrxLLLTempCurrencyScreen D3                                                                                                                                
 ON C.GCCYPartAmt2 = D3.CCY  AND D3.TransType = 'INTRA'                                                                                                               
                                                                                                                                                                      
 INNER JOIN                                                                                                                                                           
 (                                                                                                                                                                    
 	SELECT DISTINCT CustomerID                                                                                                                                        
 	FROM TrxLLLBG E                                                                                                                                                   
 	WHERE E.Tanggal = DAY(@CURRENT)                                                                                                                                   
 	  AND E.Bulan =  MONTH(@CURRENT)                                                                                                                                  
 	  AND E.Tahun =  YEAR(@CURRENT)                                                                                                                                   
       AND E.TransType = 'TRANS'                                                                                                                                      
                                                                                                                                                                      
        UNION                                                                                                                                                         
                                                                                                                                                                      
 	SELECT DISTINCT CustomerID                                                                                                                                        
 	FROM TrxLLLLC E                                                                                                                                                   
 	WHERE E.Tanggal = DAY(@CURRENT)                                                                                                                                   
 	  AND E.Bulan =  MONTH(@CURRENT)                                                                                                                                  
 	  AND E.Tahun =  YEAR(@CURRENT)                                                                                                                                   
       AND E.TransType = 'TRANS'                                                                                                                                      
                                                                                                                                                                      
        UNION                                                                                                                                                         
                                                                                                                                                                      
 	SELECT DISTINCT CustomerID                                                                                                                                        
 	FROM TrxLLLFX E                                                                                                                                                   
 	WHERE E.Tanggal = DAY(@CURRENT)                                                                                                                                   
 	  AND E.Bulan =  MONTH(@CURRENT)                                                                                                                                  
 	  AND E.Tahun =  YEAR(@CURRENT)                                                                                                                                   
       AND E.TransType = 'TRANS'                                                                                                                                      
                                                                                                                                                                      
        UNION                                                                                                                                                         
                                                                                                                                                                      
 	SELECT DISTINCT CustomerID                                                                                                                                        
 	FROM TrxLLLMTMDRTV E                                                                                                                                              
 	WHERE E.Tanggal = DAY(@CURRENT)                                                                                                                                   
 	  AND E.Bulan =  MONTH(@CURRENT)                                                                                                                                  
 	  AND E.Tahun =  YEAR(@CURRENT)                                                                                                                                   
       AND E.TransType = 'TRANS'                                                                                                                                      
                                                                                                                                                                      
        UNION                                                                                                                                                         
                                                                                                                                                                      
 	SELECT DISTINCT CustomerID                                                                                                                                        
 	FROM TrxLLLNotionalDRTV E                                                                                                                                         
 	WHERE E.Tanggal = DAY(@CURRENT)                                                                                                                                   
 	  AND E.Bulan =  MONTH(@CURRENT)                                                                                                                                  
 	  AND E.Tahun =  YEAR(@CURRENT)                                                                                                                                   
       AND E.TransType = 'TRANS'                                                                                                                                      
 )E2                                                                                                                                                                  
 ON CONVERT(INT, E2.CustomerID) = CONVERT(INT, A.CUSTACNUM)                                                                                                           
                                                                                                                                                                      
                                                                                                                                                                      
 WHERE A.statusbmi like '5%'                                                                                                                                          
    AND ISNULL(A.GuarantorYN,'') ='Yes'                                                                                                                               
    AND C.GPeriodeTo >= @CURRENT                                                                                                                                      
    AND C.TypeOfGuarantee IN ('06')                                                                                                                                   
    AND KodePenerbitAgunan IN (794,795) and ISNULL(C.includeLLL,'') = 'Y'                                                                                             
    AND ((C.TYPETXN='B/G' AND A.CounterGTee ='C') OR C.TYPETXN IN('ACC','B/G','BB w ELC','BD wo ELC','CCY OPTION','CCY SWAP','FX','IBD','IMPORT','IRS','L/C'))        
                                                                                                                                                                      
 UNION                                                                                                                                                                
                                                                                                                                                                      
 SELECT DAY(@CURRENT),                                                                                                                                                
        MONTH(@CURRENT),                                                                                                                                              
 	   YEAR(@CURRENT),                                                                                                                                                
 	   'TRANS',                                                                                                                                                       
 	   ALTNO.Alternateno As CustomerID,                                                                                                                               
 	   CONVERT(VARCHAR, C.GUARANTEEID),                                                                                                                               
 	   C.CurrentCANumber,                                                                                                                                             
 	   C.AgreementNo,                                                                                                                                                 
 	   C.TYPETXN,                                                                                                                                                     
 	   ISNULL(C.ParticipationAmt*D1.Rate, 0) + ISNULL(C.ParticipationAmt1*D2.Rate, 0) +                                                                               
 	      ISNULL(C.ParticipationAmt2*D3.Rate, 0) SBLC_AMT,                                                                                                            
 	   C.GCCY2,                                                                                                                                                       
 	   C.GCCYPartAmt1,                                                                                                                                                
 	   C.GCCYPartAmt2,                                                                                                                                                
 	   C.ParticipationAmt,                                                                                                                                            
 	   C.ParticipationAmt1,                                                                                                                                           
 	   C.ParticipationAmt2                                                                                                                                            
 FROM [ERPLIVE].[BMIERP].dbo.T_FacilityMaster A                                                                                                              
                                                                                                                                                                      
 LEFT JOIN [ERPLIVE].[BMIERP].dbo.MasterCustomer B                                                                                                           
 ON B.CustomerID = A.Custacnum                                                                                                                                        
                                                                                                                                                                      
 INNER JOIN [ERPLIVE].[BMIERP].dbo.T_DetailsGuarantee C                                                                                                      
 ON A.Custacnum = C.CustNo                                                                                                                                            
    AND A.CANUMCDM = C.CurrentCANumber and A.[03C-14] = C.AgreementNo                                                                                                 
    AND A.TYPETXN = C.TYPETXN                                                                                                                                         
                                                                                                                                                                      
 INNER JOIN [ERPLIVE].[BMIERP].dbo.MasterAlternateCustNo ALTNO                                                                                               
 ON ALTNO.CustNO = B.CustomerID AND ISNULL(ALTNO.AlternateNo,'') <> ''                                                                                                
                                                                                                                                                                      
 LEFT JOIN TrxLLLTempCurrencyScreen D1                                                                                                                                
 ON C.GCCY2 = D1.CCY  AND D1.TransType = 'INTRA'                                                                                                                      
                                                                                                                                                                      
 LEFT JOIN TrxLLLTempCurrencyScreen D2                                                                                                                                
 ON C.GCCYPartAmt1 = D2.CCY AND D2.TransType = 'INTRA'                                                                                                                
                                                                                                                                                                      
 LEFT JOIN TrxLLLTempCurrencyScreen D3                                                                                                                                
 ON C.GCCYPartAmt2 = D3.CCY  AND D3.TransType = 'INTRA'                                                                                                               
                                                                                                                                                                      
 INNER JOIN                                                                                                                                                           
 (                                                                                                                                                                    
 	SELECT DISTINCT CustomerID                                                                                                                                        
 	FROM TrxLLLBG E                                                                                                                                                   
 	WHERE E.Tanggal = DAY(@CURRENT)                                                                                                                                   
 	  AND E.Bulan =  MONTH(@CURRENT)                                                                                                                                  
 	  AND E.Tahun =  YEAR(@CURRENT)                                                                                                                                   
       AND E.TransType = 'TRANS'                                                                                                                                      
                                                                                                                                                                      
        UNION                                                                                                                                                         
                                                                                                                                                                      
 	SELECT DISTINCT CustomerID                                                                                                                                        
 	FROM TrxLLLLC E                                                                                                                                                   
 	WHERE E.Tanggal = DAY(@CURRENT)                                                                                                                                   
 	  AND E.Bulan =  MONTH(@CURRENT)                                                                                                                                  
 	  AND E.Tahun =  YEAR(@CURRENT)                                                                                                                                   
       AND E.TransType = 'TRANS'                                                                                                                                      
                                                                                                                                                                      
        UNION                                                                                                                                                         
                                                                                                                                                                      
 	SELECT DISTINCT CustomerID                                                                                                                                        
 	FROM TrxLLLFX E                                                                                                                                                   
 	WHERE E.Tanggal = DAY(@CURRENT)                                                                                                                                   
 	  AND E.Bulan =  MONTH(@CURRENT)                                                                                                                                  
 	  AND E.Tahun =  YEAR(@CURRENT)                                                                                                                                   
       AND E.TransType = 'TRANS'                                                                                                                                      
                                                                                                                                                                      
        UNION                                                                                                                                                         
                                                                                                                                                                      
 	SELECT DISTINCT CustomerID                                                                                                                                        
 	FROM TrxLLLMTMDRTV E                                                                                                                                              
 	WHERE E.Tanggal = DAY(@CURRENT)                                                                                                                                   
 	  AND E.Bulan =  MONTH(@CURRENT)                                                                                                                                  
 	  AND E.Tahun =  YEAR(@CURRENT)                                                                                                                                   
       AND E.TransType = 'TRANS'                                                                                                                                      
                                                                                                                                                                      
        UNION                                                                                                                                                         
                                                                                                                                                                      
 	SELECT DISTINCT CustomerID                                                                                                                                        
 	FROM TrxLLLNotionalDRTV E                                                                                                                                         
 	WHERE E.Tanggal = DAY(@CURRENT)                                                                                                                                   
 	  AND E.Bulan =  MONTH(@CURRENT)                                                                                                                                  
 	  AND E.Tahun =  YEAR(@CURRENT)                                                                                                                                   
       AND E.TransType = 'TRANS'                                                                                                                                      
 )E2                                                                                                                                                                  
 ON CONVERT(INT, E2.CustomerID) = CONVERT(INT, ALTNO.Alternateno)                                                                                                     
                                                                                                                                                                      
 WHERE A.statusbmi like '5%'                                                                                                                                          
    AND ISNULL(A.GuarantorYN,'') ='Yes'                                                                                                                               
    AND C.GPeriodeTo >= @CURRENT                                                                                                                                      
    AND C.TypeOfGuarantee IN ('06')                                                                                                                                   
    AND KodePenerbitAgunan IN (794,795) and ISNULL(C.includeLLL,'') = 'Y'                                                                                             
    AND ((C.TYPETXN='B/G' AND A.CounterGTee ='C') OR C.TYPETXN IN('ACC','B/G','BB w ELC','BD wo ELC','CCY OPTION','CCY SWAP','FX','IBD','IMPORT','IRS','L/C'))        
    AND  B.CustomerID = ALTNO.CustNO                                                                                                                                  
                                                                                                                                                                      
                                                                                                                                                                      
                                                                                                                                                                      
 --(2. VALUE) Edited by Vincent 24-10-2018 to change condition that not all beside BG put inside                                                                      
 INSERT INTO TrxLLLSBLCBG(Tanggal, Bulan, Tahun, TransType, CustomerID, GuaranteeID,                                                                                  
                          CANumber, AgreementNo, TypeTXN, Amount, CCY1, CCY2, CCY3,                                                                                   
 						 OriginalAmount1, OriginalAmount2, OriginalAmount3)                                                                                           
 SELECT DAY(@CURRENT),                                                                                                                                                
        MONTH(@CURRENT),                                                                                                                                              
 	   YEAR(@CURRENT),                                                                                                                                                
 	   'VALUE',                                                                                                                                                       
 	   B.CustomerID,                                                                                                                                                  
 	   CONVERT(VARCHAR, C.GUARANTEEID),                                                                                                                               
 	   C.CurrentCANumber,                                                                                                                                             
 	   C.AgreementNo,                                                                                                                                                 
 	   C.TYPETXN,                                                                                                                                                     
 	   ISNULL(C.ParticipationAmt*D1.Rate, 0) +                                                                                                                        
 	     ISNULL(C.ParticipationAmt1*D2.Rate, 0) + ISNULL(C.ParticipationAmt2*D3.Rate, 0) SBLC_AMT,                                                                    
 	   C.GCCY2,                                                                                                                                                       
 	   C.GCCYPartAmt1,                                                                                                                                                
 	   C.GCCYPartAmt2,                                                                                                                                                
 	   C.ParticipationAmt,                                                                                                                                            
 	   C.ParticipationAmt1,                                                                                                                                           
 	   C.ParticipationAmt2                                                                                                                                            
 FROM [ERPLIVE].[BMIERP].dbo.T_FacilityMaster A                                                                                                              
                                                                                                                                                                      
 LEFT JOIN [ERPLIVE].[BMIERP].dbo.MasterCustomer B                                                                                                           
 ON B.CustomerID = A.Custacnum                                                                                                                                        
                                                                                                                                                                      
 INNER JOIN [ERPLIVE].[BMIERP].dbo.T_DetailsGuarantee C                                                                                                      
 ON A.Custacnum = C.CustNo                                                                                                                                            
    AND A.CANUMCDM = C.CurrentCANumber and A.[03C-14] = C.AgreementNo                                                                                                 
    AND A.TYPETXN = C.TYPETXN                                                                                                                                         
                                                                                                                                                                      
 LEFT JOIN TrxLLLTempCurrencyScreen D1                                                                                                                                
 ON C.GCCY2 = D1.CCY  AND D1.TransType = 'INTRA'                                                                                                                      
                                                                                                                                                                      
 LEFT JOIN TrxLLLTempCurrencyScreen D2                                                                                                                                
 ON C.GCCYPartAmt1 = D2.CCY AND D2.TransType = 'INTRA'                                                                                                                
                                                                                                                                                                      
 LEFT JOIN TrxLLLTempCurrencyScreen D3                                                                                                                                
 ON C.GCCYPartAmt2 = D3.CCY  AND D3.TransType = 'INTRA'                                                                                                               
                                                                                                                                                                      
 INNER JOIN                                                                                                                                                           
 (                                                                                                                                                                    
 	SELECT DISTINCT CustomerID                                                                                                                                        
 	FROM TrxLLLBG E                                                                                                                                                   
 	WHERE E.Tanggal = DAY(@CURRENT)                                                                                                                                   
 	  AND E.Bulan =  MONTH(@CURRENT)                                                                                                                                  
 	  AND E.Tahun =  YEAR(@CURRENT)                                                                                                                                   
       AND E.TransType = 'VALUE'                                                                                                                                      
                                                                                                                                                                      
        UNION                                                                                                                                                         
                                                                                                                                                                      
 	SELECT DISTINCT CustomerID                                                                                                                                        
 	FROM TrxLLLLC E                                                                                                                                                   
 	WHERE E.Tanggal = DAY(@CURRENT)                                                                                                                                   
 	  AND E.Bulan =  MONTH(@CURRENT)                                                                                                                                  
 	  AND E.Tahun =  YEAR(@CURRENT)                                                                                                                                   
       AND E.TransType = 'VALUE'                                                                                                                                      
                                                                                                                                                                      
        UNION                                                                                                                                                         
                                                                                                                                                                      
 	SELECT DISTINCT CustomerID                                                                                                                                        
 	FROM TrxLLLFX E                                                                                                                                                   
 	WHERE E.Tanggal = DAY(@CURRENT)                                                                                                                                   
 	  AND E.Bulan =  MONTH(@CURRENT)                                                                                                                                  
 	  AND E.Tahun =  YEAR(@CURRENT)                                                                                                                                   
       AND E.TransType = 'VALUE'                                                                                                                                      
                                                                                                                                                                      
        UNION                                                                                                                                                         
                                                                                                                                                                      
 	SELECT DISTINCT CustomerID                                                                                                                                        
 	FROM TrxLLLMTMDRTV E                                                                                                                                              
 	WHERE E.Tanggal = DAY(@CURRENT)                                                                                                                                   
 	  AND E.Bulan =  MONTH(@CURRENT)                                                                                                                                  
 	  AND E.Tahun =  YEAR(@CURRENT)                                                                                                                                   
       AND E.TransType = 'VALUE'                                                                                                                                      
                                                                                                                                                                      
        UNION                                                                                                                                                         
                                                                                                                                                                      
 	SELECT DISTINCT CustomerID                                                                                                                                        
 	FROM TrxLLLNotionalDRTV E                                                                                                                                         
 	WHERE E.Tanggal = DAY(@CURRENT)                                                                                                                                   
 	  AND E.Bulan =  MONTH(@CURRENT)                                                                                                                                  
 	  AND E.Tahun =  YEAR(@CURRENT)                                                                                                                                   
       AND E.TransType = 'VALUE'                                                                                                                                      
 )E2                                                                                                                                                                  
 ON CONVERT(INT, E2.CustomerID) = CONVERT(INT, A.CUSTACNUM)                                                                                                           
                                                                                                                                                                      
 WHERE A.statusbmi like '5%'                                                                                                                                          
    AND ISNULL(A.GuarantorYN,'') ='Yes'                                                                                                                               
    AND @CURRENT BETWEEN C.GPeriodeFrom and C.GPeriodeTo                                                                                                              
    AND C.TypeOfGuarantee IN ('06')                                                                                                                                   
    AND KodePenerbitAgunan IN (794,795) and ISNULL(C.includeLLL,'') = 'Y'                                                                                             
    AND ((C.TYPETXN='B/G' AND A.CounterGTee ='C') OR C.TYPETXN IN('ACC','B/G','BB w ELC','BD wo ELC','CCY OPTION','CCY SWAP','FX','IBD','IMPORT','IRS','L/C'))        
                                                                                                                                                                      
 UNION                                                                                                                                                                
                                                                                                                                                                      
 SELECT DAY(@CURRENT),                                                                                                                                                
        MONTH(@CURRENT),                                                                                                                                              
 	   YEAR(@CURRENT),                                                                                                                                                
 	   'VALUE',                                                                                                                                                       
 	   ALTNO.Alternateno As CustomerID,                                                                                                                               
 	   CONVERT(VARCHAR, C.GUARANTEEID),                                                                                                                               
 	   C.CurrentCANumber,                                                                                                                                             
 	   C.AgreementNo,                                                                                                                                                 
 	   C.TYPETXN,                                                                                                                                                     
 	   ISNULL(C.ParticipationAmt*D1.Rate, 0) + ISNULL(C.ParticipationAmt1*D2.Rate, 0) +                                                                               
 	      ISNULL(C.ParticipationAmt2*D3.Rate, 0) SBLC_AMT,                                                                                                            
 	   C.GCCY2,                                                                                                                                                       
 	   C.GCCYPartAmt1,                                                                                                                                                
 	   C.GCCYPartAmt2,                                                                                                                                                
 	   C.ParticipationAmt,                                                                                                                                            
 	   C.ParticipationAmt1,                                                                                                                                           
 	   C.ParticipationAmt2                                                                                                                                            
 FROM [ERPLIVE].[BMIERP].dbo.T_FacilityMaster A                                                                                                              
                                                                                                                                                                      
 LEFT JOIN [ERPLIVE].[BMIERP].dbo.MasterCustomer B                                                                                                           
 ON B.CustomerID = A.Custacnum                                                                                                                                        
                                                                                                                                                                      
 INNER JOIN [ERPLIVE].[BMIERP].dbo.T_DetailsGuarantee C                                                                                                      
 ON A.Custacnum = C.CustNo                                                                                                                                            
    AND A.CANUMCDM = C.CurrentCANumber and A.[03C-14] = C.AgreementNo                                                                                                 
    AND A.TYPETXN = C.TYPETXN                                                                                                                                         
                                                                                                                                                                      
 INNER JOIN [ERPLIVE].[BMIERP].dbo.MasterAlternateCustNo ALTNO                                                                                               
 ON ALTNO.CustNO = B.CustomerID AND ISNULL(ALTNO.AlternateNo,'') <> ''                                                                                                
                                                                                                                                                                      
 LEFT JOIN TrxLLLTempCurrencyScreen D1                                                                                                                                
 ON C.GCCY2 = D1.CCY  AND D1.TransType = 'INTRA'                                                                                                                      
                                                                                                                                                                      
 LEFT JOIN TrxLLLTempCurrencyScreen D2                                                                                                                                
 ON C.GCCYPartAmt1 = D2.CCY AND D2.TransType = 'INTRA'                                                                                                                
                                                                                                                                                                      
 LEFT JOIN TrxLLLTempCurrencyScreen D3                                                                                                                                
 ON C.GCCYPartAmt2 = D3.CCY  AND D3.TransType = 'INTRA'                                                                                                               
                                                                                                                                                                      
 INNER JOIN                                                                                                                                                           
 (                                                                                                                                                                    
 	SELECT DISTINCT CustomerID                                                                                                                                        
 	FROM TrxLLLBG E                                                                                                                                                   
 	WHERE E.Tanggal = DAY(@CURRENT)                                                                                                                                   
 	  AND E.Bulan =  MONTH(@CURRENT)                                                                                                                                  
 	  AND E.Tahun =  YEAR(@CURRENT)                                                                                                                                   
       AND E.TransType = 'VALUE'                                                                                                                                      
                                                                                                                                                                      
        UNION                                                                                                                                                         
                                                                                                                                                                      
 	SELECT DISTINCT CustomerID                                                                                                                                        
 	FROM TrxLLLLC E                                                                                                                                                   
 	WHERE E.Tanggal = DAY(@CURRENT)                                                                                                                                   
 	  AND E.Bulan =  MONTH(@CURRENT)                                                                                                                                  
 	  AND E.Tahun =  YEAR(@CURRENT)                                                                                                                                   
       AND E.TransType = 'VALUE'                                                                                                                                      
                                                                                                                                                                      
        UNION                                                                                                                                                         
                                                                                                                                                                      
 	SELECT DISTINCT CustomerID                                                                                                                                        
 	FROM TrxLLLFX E                                                                                                                                                   
 	WHERE E.Tanggal = DAY(@CURRENT)                                                                                                                                   
 	  AND E.Bulan =  MONTH(@CURRENT)                                                                                                                                  
 	  AND E.Tahun =  YEAR(@CURRENT)                                                                                                                                   
       AND E.TransType = 'VALUE'                                                                                                                                      
                                                                                                                                                                      
        UNION                                                                                                                                                         
                                                                                                                                                                      
 	SELECT DISTINCT CustomerID                                                                                                                                        
 	FROM TrxLLLMTMDRTV E                                                                                                                                              
 	WHERE E.Tanggal = DAY(@CURRENT)                                                                                                                                   
 	  AND E.Bulan =  MONTH(@CURRENT)                                                                                                                                  
 	  AND E.Tahun =  YEAR(@CURRENT)                                                                                                                                   
       AND E.TransType = 'VALUE'                                                                                                                                      
                                                                                                                                                                      
        UNION                                                                                                                                                         
                                                                                                                                                                      
 	SELECT DISTINCT CustomerID                                                                                                                                        
 	FROM TrxLLLNotionalDRTV E                                                                                                                                         
 	WHERE E.Tanggal = DAY(@CURRENT)                                                                                                                                   
 	  AND E.Bulan =  MONTH(@CURRENT)                                                                                                                                  
 	  AND E.Tahun =  YEAR(@CURRENT)                                                                                                                                   
       AND E.TransType = 'VALUE'                                                                                                                                      
 )E2                                                                                                                                                                  
 ON CONVERT(INT, E2.CustomerID) = CONVERT(INT, ALTNO.Alternateno)                                                                                                     
                                                                                                                                                                      
 WHERE A.statusbmi like '5%'                                                                                                                                          
    AND ISNULL(A.GuarantorYN,'') ='Yes'                                                                                                                               
    AND @CURRENT BETWEEN C.GPeriodeFrom and C.GPeriodeTo                                                                                                              
    AND C.TypeOfGuarantee IN ('06')                                                                                                                                   
    AND KodePenerbitAgunan IN (794,795) and ISNULL(C.includeLLL,'') = 'Y'                                                                                             
    AND ((C.TYPETXN='B/G' AND A.CounterGTee ='C') OR C.TYPETXN IN('ACC','B/G','BB w ELC','BD wo ELC','CCY OPTION','CCY SWAP','FX','IBD','IMPORT','IRS','L/C'))        
    AND  B.CustomerID = ALTNO.CustNO                                                                                                                                  
                                                                                                                                                                      
                                                                                                                                                                      
 -------------------------------------------------------H. PLEDGE TD                                                                                                  
                                                                                                                                                                      
 --(1. TRANS)                                                                                                                                                         
 INSERT INTO TrxLLLPLEDGETD(Tanggal, Bulan, Tahun, TransType, CustomerID,TransNo,                                                                                     
                            CoveredCust,CCY, ValueDate, DueDate, Amount, OriginalAmount,IsLNCA,IsBGCA,IsLCCA)                                                         
 SELECT  DAY(@CURRENT),                                                                                                                                               
         MONTH(@CURRENT),                                                                                                                                             
 		YEAR(@CURRENT),                                                                                                                                               
 		'TRANS',                                                                                                                                                      
 		A.CustomerID,                                                                                                                                                 
 		A.Transno,                                                                                                                                                    
 		(SELECT TOP 1 Custacnum FROM [ERPLIVE].[BMIERP].dbo.T_FacilityMaster WHERE CANumCDM = A.CANO1 ) As CoveredCust,                                      
 		A.CurrencyID,                                                                                                                                                 
 		A.ValueDate,                                                                                                                                                  
 		A.DueDate,                                                                                                                                                    
 		A.Amount*C.Rate,                                                                                                                                              
 		A.Amount,                                                                                                                                                     
 		IIF(A.CANO1Type = 'LOAN' OR A.CANO2Type = 'LOAN' OR A.CANO3Type = 'LOAN','Y','N'),                                                                            
 		IIF(A.CANO1Type = 'B/G' OR A.CANO2Type = 'B/G' OR A.CANO3Type = 'B/G','Y','N'),                                                                               
 		IIF(A.CANO1Type = 'L/C' OR A.CANO2Type = 'L/C' OR A.CANO3Type = 'L/C','Y','N')                                                                                
 FROM [ERPLIVE].[BMIERP].dbo.TrxTDFundingConfirmation A                                                                                                      
                                                                                                                                                                      
 LEFT JOIN [ERPLIVE].[BMIERP].dbo.MasterCustomer B                                                                                                           
 ON B.CustomerID = A.CustomerID                                                                                                                                       
                                                                                                                                                                      
 LEFT JOIN TrxLLLTempCurrencyScreen C                                                                                                                                 
 ON A.CurrencyID = C.CCY AND C.TransType = 'INTRA'                                                                                                                    
                                                                                                                                                                      
 WHERE A.DueDate >= @CURRENT                                                                                                                                          
   AND A.TDRemarkID IN('NEW','R/O')                                                                                                                                   
   AND A.Flag IN(0)                                                                                                                                                   
   AND ISNULL(A.PledgedTD,'') = 'Y'                                                                                                                                   
   AND ISNULL(OperationApprovedBy,'') <> ''                                                                                                                           
   AND NOT EXISTS(SELECT T2.TransNo                                                                                                                                   
                  FROM [ERPLIVE].[BMIERP].dbo.TrxTDFundingConfirmation T2                                                                                    
 				 WHERE T2.ReffNo = A.TransNo                                                                                                                          
 				   AND T2.Flag = 0                                                                                                                                    
 				   AND T2.TDRemarkID = 'BRK')                                                                                                                         
 ORDER BY CoveredCust;                                                                                                                                                
                                                                                                                                                                      
                                                                                                                                                                      
 --(2. VALUE)                                                                                                                                                         
 INSERT INTO TrxLLLPLEDGETD(Tanggal, Bulan, Tahun, TransType, CustomerID,TransNo,                                                                                     
                            CoveredCust,CCY, ValueDate, DueDate, Amount, OriginalAmount,IsLNCA,IsBGCA,IsLCCA)                                                         
 SELECT  DAY(@CURRENT),                                                                                                                                               
         MONTH(@CURRENT),                                                                                                                                             
 		YEAR(@CURRENT),                                                                                                                                               
 		'VALUE',                                                                                                                                                      
 		A.CustomerID,                                                                                                                                                 
 		A.Transno,                                                                                                                                                    
 		(SELECT TOP 1 Custacnum FROM [ERPLIVE].[BMIERP].dbo.T_FacilityMaster WHERE CANumCDM = A.CANO1 ) As CoveredCust,                                      
 		A.CurrencyID,                                                                                                                                                 
 		A.ValueDate,                                                                                                                                                  
 		A.DueDate,                                                                                                                                                    
 		A.Amount*C.Rate,                                                                                                                                              
 		A.Amount,                                                                                                                                                     
 		IIF(A.CANO1Type = 'LOAN' OR A.CANO2Type = 'LOAN' OR A.CANO3Type = 'LOAN','Y','N'),                                                                            
 		IIF(A.CANO1Type = 'B/G' OR A.CANO2Type = 'B/G' OR A.CANO3Type = 'B/G','Y','N'),                                                                               
 		IIF(A.CANO1Type = 'L/C' OR A.CANO2Type = 'L/C' OR A.CANO3Type = 'L/C','Y','N')                                                                                
 FROM [ERPLIVE].[BMIERP].dbo.TrxTDFundingConfirmation A                                                                                                      
                                                                                                                                                                      
 LEFT JOIN [ERPLIVE].[BMIERP].dbo.MasterCustomer B                                                                                                           
 ON B.CustomerID = A.CustomerID                                                                                                                                       
                                                                                                                                                                      
 LEFT JOIN TrxLLLTempCurrencyScreen C                                                                                                                                 
 ON A.CurrencyID = C.CCY AND C.TransType = 'INTRA'                                                                                                                    
 WHERE A.DueDate >= @CURRENT                                                                                                                                          
   AND A.ValueDate <= @CURRENT                                                                                                                                        
   AND A.TDRemarkID IN('NEW','R/O')                                                                                                                                   
   AND A.Flag IN(0)                                                                                                                                                   
   AND ISNULL(A.PledgedTD,'') = 'Y'                                                                                                                                   
   AND ISNULL(OperationApprovedBy,'') <> ''                                                                                                                           
   AND NOT EXISTS(SELECT T2.TransNo                                                                                                                                   
                  FROM [ERPLIVE].[BMIERP].dbo.TrxTDFundingConfirmation T2                                                                                    
 				 WHERE T2.ReffNo = A.TransNo                                                                                                                          
 				   AND T2.Flag = 0                                                                                                                                    
 				   AND T2.TDRemarkID = 'BRK')                                                                                                                         
 ORDER BY CoveredCust;                                                                                                                                                
                                                                                                                                                                      
                                                                                                                                                                      
 INSERT INTO TrxLLLPLEDGETDSummary (Tanggal,Bulan,Tahun,TransType,CustID)                                                                                             
 SELECT DISTINCT PLDTS.Tanggal,                                                                                                                                       
                 PLDTS.Bulan,                                                                                                                                         
 				PLDTS.Tahun,                                                                                                                                          
 				TransType,                                                                                                                                            
 				ISNULL(CoveredCust,CustomerID)                                                                                                                        
 FROM TrxLLLPLEDGETD PLDTS                                                                                                                                            
 WHERE PLDTS.Tanggal = DAY(@CURRENT)                                                                                                                                  
 AND PLDTS.Bulan = MONTH(@CURRENT)                                                                                                                                    
 AND PLDTS.Tahun = YEAR(@CURRENT)                                                                                                                                     
 AND TransType IN ('VALUE', 'TRANS');                                                                                                                                 
                                                                                                                                                                      
                                                                                                                                                                      
                                                                                                                                                                      
 --GET LN (CUSTOMERID, CA, AMOUNT_PER_CUSTOMER_PER_FIRSTAGREEMENTNUMBER)                                                                                              
 ;WITH LNBYFIRSTAGREE As (                                                                                                                                            
 	SELECT LN.CustomerID,                                                                                                                                             
 		   TF.ListOfCANo As CANo,                                                                                                                                     
 		   B.[03C-12] As FirstOfAgreementNo,                                                                                                                          
 		   LN.Amount As CALnAmount,                                                                                                                                   
 		   LN.TransType                                                                                                                                               
     FROM TrxLLLLN LN                                                                                                                                                 
                                                                                                                                                                      
 	INNER JOIN [ERPLIVE].[BMIERP].dbo.TrxFundingConfirmation TF                                                                                              
 	ON TF.Transno = LN.TransNo                                                                                                                                        
                                                                                                                                                                      
 	INNER JOIN	(                                                                                                                                                     
 				SELECT bz.*,                                                                                                                                          
 				       bx.FundingFacilityID                                                                                                                           
 				FROM [ERPLIVE].[BMIERP].dbo.T_FacilityMaster bz                                                                                              
                                                                                                                                                                      
 				LEFT JOIN [ERPLIVE].[BMIERP].dbo.MasterFundingFacilityType bx                                                                                
 				ON bz.TypeOfFacility=bx.TypeofFacility                                                                                                                
                                                                                                                                                                      
 				WHERE bx.Flag='0'                                                                                                                                     
 				      AND bz.Flag<>'4'                                                                                                                                
 				      AND (bz.TYPETXN='LOAN' or bz.TYPETXN='LOAN SYND')                                                                                               
 				)B                                                                                                                                                    
      ON b.CUSTACNUM=TF.CustomerID                                                                                                                                    
 	 AND b.CANUMCDM=TF.ListOfCANo                                                                                                                                     
 	 AND b.[03C-14]=TF.ListOfAgreementNo                                                                                                                              
      AND b.Flag<>'4'                                                                                                                                                 
 	 AND (b.TYPETXN='LOAN' OR b.TYPETXN='LOAN SYND')                                                                                                                  
 	 AND b.FundingFacilityID=TF.LoanFacilityType                                                                                                                      
                                                                                                                                                                      
 	 WHERE LN.Tanggal = DAY(@CURRENT)                                                                                                                                 
 	 AND LN.Bulan = MONTH(@CURRENT)                                                                                                                                   
 	 AND LN.Tahun =YEAR(@CURRENT)                                                                                                                                     
 	 AND LN.TransType IN ('TRANS', 'VALUE')                                                                                                                           
 )                                                                                                                                                                    
                                                                                                                                                                      
 ,LNSUMBYFIRST AS (                                                                                                                                                   
 	SELECT LG.CustomerID As CustomerID,                                                                                                                               
 	       LG.FirstOfAgreementNo As FirstOfAgreementNo,                                                                                                               
 		   LG.TransType,                                                                                                                                              
 		   SUM(LG.CALnAmount) AS CALnAmount                                                                                                                           
 	FROM LNBYFIRSTAGREE LG                                                                                                                                            
 	GROUP BY LG.CustomerID, LG.TransType, LG.FirstOfAgreementNo                                                                                                       
 )                                                                                                                                                                    
                                                                                                                                                                      
 ,LNDISTCCA AS (                                                                                                                                                      
 	SELECT DISTINCT LG.CustomerID As CustomerID,                                                                                                                      
 	                LG.CANo As CANo,                                                                                                                                  
 					LG.FirstOfAgreementNo As FirstOfAgreementNo,                                                                                                      
 					LG.TransType                                                                                                                                      
 	FROM LNBYFIRSTAGREE LG                                                                                                                                            
 )                                                                                                                                                                    
                                                                                                                                                                      
 ,LNBYCAOUT AS (                                                                                                                                                      
                                                                                                                                                                      
 	SELECT LNDISTCCA.CustomerID,                                                                                                                                      
 	       LNDISTCCA.CANo As CANo,                                                                                                                                    
 		   LNDISTCCA.TransType,                                                                                                                                       
 		   LNSUMBYFIRST.CALnAmount As CALnAmount                                                                                                                      
     FROM LNDISTCCA                                                                                                                                                   
                                                                                                                                                                      
 	LEFT JOIN LNSUMBYFIRST                                                                                                                                            
 	ON LNDISTCCA.CustomerID = LNSUMBYFIRST.CustomerID                                                                                                                 
 	AND LNSUMBYFIRST.FirstOfAgreementNo = LNDISTCCA.FirstOfAgreementNo                                                                                                
 	AND LNDISTCCA.TransType = LNSUMBYFIRST.TransType                                                                                                                  
 )                                                                                                                                                                    
                                                                                                                                                                      
                                                                                                                                                                      
                                                                                                                                                                      
 --GET LC DAN BG                                                                                                                                                      
 ,LCBYCUSTOUT AS (                                                                                                                                                    
 	SELECT LC.CustomerID,                                                                                                                                             
 	       LC.TransType,                                                                                                                                              
 	       SUM(LC.Amount) AS LCAmount                                                                                                                                 
 	FROM TrxLLLLC LC                                                                                                                                                  
 	WHERE LC.Tanggal = DAY(@CURRENT)                                                                                                                                  
 	AND LC.Bulan = MONTH(@CURRENT)                                                                                                                                    
 	AND LC.Tahun =YEAR(@CURRENT)                                                                                                                                      
 	AND LC.TransType IN ('VALUE', 'TRANS')                                                                                                                            
 	GROUP BY LC.TransType, LC.CustomerID                                                                                                                              
 )                                                                                                                                                                    
                                                                                                                                                                      
 ,BGBYCUSTOUT AS (                                                                                                                                                    
 	SELECT BG.CustomerID,                                                                                                                                             
 	       BG.TransType,                                                                                                                                              
 	       SUM(BG.Amount) AS BGAmount                                                                                                                                 
 	FROM TrxLLLBG BG                                                                                                                                                  
 	WHERE BG.Tanggal = DAY(@CURRENT)                                                                                                                                  
 	AND BG.Bulan = MONTH(@CURRENT)                                                                                                                                    
 	AND BG.Tahun =YEAR(@CURRENT)                                                                                                                                      
 	AND BG.TransType IN ('VALUE', 'TRANS')                                                                                                                            
 	GROUP BY BG.TransType, BG.CustomerID                                                                                                                              
 )                                                                                                                                                                    
                                                                                                                                                                      
 --CALCULATE ALL PLEDGE LN AMOUNT PER CA/DATE                                                                                                                         
 ,LNBYCA AS (                                                                                                                                                         
 	SELECT (SELECT TOP 1 Custacnum                                                                                                                                    
 	        FROM [ERPLIVE].[BMIERP].dbo.T_FacilityMaster                                                                                                     
 			WHERE CANumCDM = TF.CANO1 ) As CoveredCust,                                                                                                               
 	        TF.Transno As PledgeTransNo,                                                                                                                              
 			TF.CANo1 AS CANo,                                                                                                                                         
 			PLD.Amount As PledgeAmount,                                                                                                                               
 			PLD.TransType                                                                                                                                             
 	FROM TrxLLLPLEDGETD PLD                                                                                                                                           
                                                                                                                                                                      
 	INNER JOIN [ERPLIVE].[BMIERP].dbo.TrxTDFundingConfirmation TF                                                                                            
 	ON PLD.Transno = TF.Transno                                                                                                                                       
                                                                                                                                                                      
 	WHERE PLD.Tanggal= DAY(@CURRENT)                                                                                                                                  
 	  AND PLD.Bulan = MONTH(@CURRENT)                                                                                                                                 
 	  AND PLD.Tahun =YEAR(@CURRENT) AND TF.CANO1Type = 'LOAN'                                                                                                         
 	  AND PLD.TransType IN ('TRANS', 'VALUE')                                                                                                                         
                                                                                                                                                                      
 	UNION                                                                                                                                                             
                                                                                                                                                                      
 	SELECT (SELECT TOP 1 Custacnum                                                                                                                                    
 	        FROM [ERPLIVE].[BMIERP].dbo.T_FacilityMaster                                                                                                     
 			WHERE CANumCDM = TF.CANO2 ) As CoveredCust,                                                                                                               
 			TF.Transno As PledgeTransNo,                                                                                                                              
 			TF.CANo2 AS CANo,                                                                                                                                         
 	        PLD.Amount As PledgeAmount,                                                                                                                               
 			PLD.TransType                                                                                                                                             
 	FROM TrxLLLPLEDGETD PLD                                                                                                                                           
                                                                                                                                                                      
 	INNER JOIN [ERPLIVE].[BMIERP].dbo.TrxTDFundingConfirmation TF                                                                                            
 	ON PLD.Transno = TF.Transno                                                                                                                                       
                                                                                                                                                                      
 	WHERE PLD.Tanggal= DAY(@CURRENT)                                                                                                                                  
 	  AND PLD.Bulan = MONTH(@CURRENT)                                                                                                                                 
 	  AND PLD.Tahun =YEAR(@CURRENT) AND TF.CANO2Type = 'LOAN'                                                                                                         
 	  AND PLD.TransType IN ('TRANS', 'VALUE')                                                                                                                         
                                                                                                                                                                      
 	UNION                                                                                                                                                             
                                                                                                                                                                      
 	SELECT (SELECT TOP 1 Custacnum                                                                                                                                    
 	        FROM [ERPLIVE].[BMIERP].dbo.T_FacilityMaster                                                                                                     
 			WHERE CANumCDM = TF.CANO3 ) As CoveredCust,                                                                                                               
 	        TF.Transno As PledgeTransNo,                                                                                                                              
 			TF.CANo3 As CANo,                                                                                                                                         
 	        PLD.Amount As PledgeAmount,                                                                                                                               
 			PLD.TransType                                                                                                                                             
 	FROM TrxLLLPLEDGETD PLD                                                                                                                                           
                                                                                                                                                                      
 	INNER JOIN [ERPLIVE].[BMIERP].dbo.TrxTDFundingConfirmation TF                                                                                            
 	ON PLD.Transno = TF.Transno                                                                                                                                       
                                                                                                                                                                      
 	WHERE PLD.Tanggal= DAY(@CURRENT)                                                                                                                                  
 	AND PLD.Bulan = MONTH(@CURRENT)                                                                                                                                   
 	AND PLD.Tahun =YEAR(@CURRENT) AND TF.CANO3Type = 'LOAN'                                                                                                           
 	AND PLD.TransType IN ('TRANS', 'VALUE')                                                                                                                           
 )                                                                                                                                                                    
                                                                                                                                                                      
 ,LNBYCAPLEDGEPERROW AS (                                                                                                                                             
 	SELECT LNBYCA.CoveredCust As CoveredCust,                                                                                                                         
 	       LNBYCA.CANo As CANo,                                                                                                                                       
 		   SUM(LNBYCA.PledgeAmount) As PledgeAmount,                                                                                                                  
 		   LNBYCA.TransType                                                                                                                                           
 	FROM LNBYCA                                                                                                                                                       
 	GROUP BY LNBYCA.CoveredCust, LNBYCA.TransType, LNBYCA.CANo                                                                                                        
 )                                                                                                                                                                    
                                                                                                                                                                      
 --SUM ALL PLEDGE AND LN BY CA                                                                                                                                        
 ,LNBYCAPLEDGEDET AS (                                                                                                                                                
 	SELECT LNBYCAPLEDGEPERROW.CoveredCust As CoveredCust,                                                                                                             
 	       LNBYCAPLEDGEPERROW.PledgeAmount As PledgeAmount,                                                                                                           
 	       LNBYCAOUT.CALnAmount As TotalOutPerPlg,                                                                                                                    
 	       IIF(LNBYCAPLEDGEPERROW.PledgeAmount > LNBYCAOUT.CALnAmount,                                                                                                
 		         LNBYCAOUT.CALnAmount,                                                                                                                                
 				 LNBYCAPLEDGEPERROW.PledgeAmount) As TotalCalc,                                                                                                       
 		   LNBYCAPLEDGEPERROW.TransType                                                                                                                               
 	FROM LNBYCAPLEDGEPERROW                                                                                                                                           
                                                                                                                                                                      
 	INNER JOIN LNBYCAOUT                                                                                                                                              
 	ON LNBYCAPLEDGEPERROW.CoveredCust = LNBYCAOUT.CustomerID                                                                                                          
 	AND LNBYCAPLEDGEPERROW.CANo = LNBYCAOUT.CANo                                                                                                                      
 	AND LNBYCAPLEDGEPERROW.TransType = LNBYCAOUT.TransType                                                                                                            
 )                                                                                                                                                                    
                                                                                                                                                                      
 ,LCBYPLEDGETD AS (                                                                                                                                                   
                                                                                                                                                                      
 	SELECT PLD.CoveredCust,                                                                                                                                           
 	       SUM(PLD.Amount) As PledgeAmount,                                                                                                                           
 		   SUM(LYPD.TotalCalc) As TotalCalc,                                                                                                                          
 		   PLD.TransType                                                                                                                                              
 	FROM TrxLLLPLEDGETD PLD                                                                                                                                           
                                                                                                                                                                      
 	LEFT JOIN LNBYCAPLEDGEDET LYPD                                                                                                                                    
 	ON PLD.CoveredCust =  LYPD.CoveredCust                                                                                                                            
 	AND PLD.TransType = LYPD.TransType                                                                                                                                
                                                                                                                                                                      
 	WHERE PLD.Tanggal= DAY(@CURRENT)                                                                                                                                  
 	AND PLD.Bulan = MONTH(@CURRENT)                                                                                                                                   
 	AND PLD.Tahun =YEAR(@CURRENT) AND PLD.IsLCCA = 'Y'                                                                                                                
 	AND PLD.TransType IN ('VALUE', 'TRANS')                                                                                                                           
 	GROUP BY PLD.CoveredCust, PLD.TransType                                                                                                                           
 )                                                                                                                                                                    
                                                                                                                                                                      
 ,BGBYPLEDGETD As (                                                                                                                                                   
                                                                                                                                                                      
 	SELECT PLD.CoveredCust,                                                                                                                                           
 	       SUM(PLD.Amount) As PledgeAmount,                                                                                                                           
 		   SUM(LYPD.TotalCalc) As TotalCalc,                                                                                                                          
 		   PLD.TransType                                                                                                                                              
 	FROM TrxLLLPLEDGETD PLD                                                                                                                                           
                                                                                                                                                                      
 	LEFT JOIN LNBYCAPLEDGEDET LYPD                                                                                                                                    
 	ON PLD.CoveredCust =  LYPD.CoveredCust                                                                                                                            
 	AND PLD.TransType = LYPD.TransType                                                                                                                                
                                                                                                                                                                      
 	WHERE PLD.Tanggal= DAY(@CURRENT)                                                                                                                                  
 	AND PLD.Bulan = MONTH(@CURRENT)                                                                                                                                   
 	AND PLD.Tahun =YEAR(@CURRENT) AND PLD.IsBGCA = 'Y'                                                                                                                
 	AND PLD.TransType IN ('VALUE', 'TRANS')                                                                                                                           
 	GROUP BY PLD.CoveredCust, PLD.TransType                                                                                                                           
 )                                                                                                                                                                    
                                                                                                                                                                      
                                                                                                                                                                      
 --UPDATE OUTSTANDING                                                                                                                                                 
 UPDATE TrxLLLPLEDGETDSummary                                                                                                                                         
 	SET TotalLN = (SELECT SUM(LNBYCAPLEDGEDET.TotalCalc)                                                                                                              
 	               FROM LNBYCAPLEDGEDET                                                                                                                               
 				   WHERE LNBYCAPLEDGEDET.CoveredCust = PLDTS.CustID                                                                                                   
 				         AND LNBYCAPLEDGEDET.TransType = PLDTS.TransType),                                                                                            
 		TotalLC = (SELECT IIF(LCBYCUSTOUT.LCAmount > LCBYPLEDGETD.PledgeAmount - ISNULL(LCBYPLEDGETD.TotalCalc,0),                                                    
 		                       LCBYPLEDGETD.PledgeAmount - ISNULL(LCBYPLEDGETD.TotalCalc,0)                                                                           
 							   ,LCBYCUSTOUT.LCAmount)                                                                                                                 
 					FROM LCBYCUSTOUT                                                                                                                                  
 					INNER JOIN LCBYPLEDGETD                                                                                                                           
 					ON LCBYCUSTOUT.CustomerID =  LCBYPLEDGETD.CoveredCust                                                                                             
 					And LCBYCUSTOUT.TransType = LCBYPLEDGETD.TransType                                                                                                
 					WHERE LCBYCUSTOUT.CustomerID = PLDTS.CustID                                                                                                       
 					      AND LCBYCUSTOUT.TransType = PLDTS.TransType),                                                                                               
 		TotalBG = (SELECT IIF(BGBYCUSTOUT.BGAmount > BGBYPLEDGETD.PledgeAmount - ISNULL(BGBYPLEDGETD.TotalCalc,0),                                                    
 		                      BGBYPLEDGETD.PledgeAmount - ISNULL(BGBYPLEDGETD.TotalCalc,0),                                                                           
 							  BGBYCUSTOUT.BGAmount)                                                                                                                   
 					FROM BGBYCUSTOUT                                                                                                                                  
 					INNER JOIN BGBYPLEDGETD                                                                                                                           
 					ON BGBYCUSTOUT.CustomerID =  BGBYPLEDGETD.CoveredCust                                                                                             
 					AND BGBYCUSTOUT.TransType = BGBYPLEDGETD.TransType                                                                                                
 					WHERE BGBYCUSTOUT.CustomerID = PLDTS.CustID                                                                                                       
 					    AND BGBYCUSTOUT.TransType = PLDTS.TransType)                                                                                                  
 FROM TrxLLLPLEDGETDSummary PLDTS                                                                                                                                     
 WHERE Tanggal = DAY(@CURRENT)                                                                                                                                        
 AND Bulan = MONTH(@CURRENT)                                                                                                                                          
 AND Tahun = YEAR(@CURRENT)                                                                                                                                           
 AND TransType IN ('VALUE', 'TRANS');                                                                                                                                 
                                                                                                                                                                      
                                                                                                                                                                      
                                                                                                                                                                      
 -------------------------------------------------------HITUNG OUTSTANDING                                                                                            
                                                                                                                                                                      
 --LN                                                                                                                                                                 
 SELECT A.CustomerID,                                                                                                                                                 
        A.TransType,                                                                                                                                                  
        FLOOR(SUM(A.Amount)/1000000) OS_LN                                                                                                                            
 INTO #TEMP_LN1                                                                                                                                                       
 FROM TrxLLLLN A                                                                                                                                                      
 WHERE A.Tanggal = DAY(@CURRENT)                                                                                                                                      
   AND A.Bulan = MONTH(@CURRENT)                                                                                                                                      
   AND A.Tahun = YEAR(@CURRENT)                                                                                                                                       
   AND A.TransType IN ('TRANS', 'VALUE')                                                                                                                              
 GROUP BY A.CustomerID, A.TransType                                                                                                                                   
                                                                                                                                                                      
                                                                                                                                                                      
                                                                                                                                                                      
 --BG                                                                                                                                                                 
 SELECT A.CustomerID,                                                                                                                                                 
        A.TransType,                                                                                                                                                  
        FLOOR(SUM(A.Amount)/1000000) OS_BG                                                                                                                            
 INTO #TEMP_BG1                                                                                                                                                       
 FROM TrxLLLBG A                                                                                                                                                      
 WHERE A.Tanggal = DAY(@CURRENT)                                                                                                                                      
   AND A.Bulan = MONTH(@CURRENT)                                                                                                                                      
   AND A.Tahun = YEAR(@CURRENT)                                                                                                                                       
   AND A.TransType IN ('TRANS', 'VALUE')                                                                                                                              
 GROUP BY A.CustomerID, A.TransType                                                                                                                                   
                                                                                                                                                                      
                                                                                                                                                                      
                                                                                                                                                                      
 --LC                                                                                                                                                                 
 SELECT A.CustomerID,                                                                                                                                                 
 	   A.TransType,                                                                                                                                                   
        FLOOR(SUM(A.Amount)/1000000) OS_LC                                                                                                                            
 INTO #TEMP_LC1                                                                                                                                                       
 FROM TrxLLLLC A                                                                                                                                                      
 WHERE A.Tanggal = DAY(@CURRENT)                                                                                                                                      
   AND A.Bulan = MONTH(@CURRENT)                                                                                                                                      
   AND A.Tahun = YEAR(@CURRENT)                                                                                                                                       
   AND A.TransType IN ('TRANS', 'VALUE')                                                                                                                              
 GROUP BY A.CustomerID, A.TransType                                                                                                                                   
                                                                                                                                                                      
                                                                                                                                                                      
                                                                                                                                                                      
 --FX                                                                                                                                                                 
 SELECT A.CustomerID,                                                                                                                                                 
 	   A.TransType,                                                                                                                                                   
        FLOOR(SUM(ABS(A.NotAmount*A.PE) + PVAmount)/1000000) OS_FX                                                                                                    
 INTO #TEMP_FX1                                                                                                                                                       
 FROM TrxLLLFX A                                                                                                                                                      
 WHERE A.Tanggal = DAY(@CURRENT)                                                                                                                                      
   AND A.Bulan = MONTH(@CURRENT)                                                                                                                                      
   AND A.Tahun = YEAR(@CURRENT)                                                                                                                                       
   AND A.TransType IN ('TRANS', 'VALUE')                                                                                                                              
 GROUP BY A.CustomerID, A.TransType                                                                                                                                   
                                                                                                                                                                      
                                                                                                                                                                      
                                                                                                                                                                      
 --(MTM) DERIVATIVE                                                                                                                                                   
 SELECT A.CustomerID,                                                                                                                                                 
        A.DEALNO,                                                                                                                                                     
        A.Amount,                                                                                                                                                     
 	   A.TransType                                                                                                                                                    
 INTO #TEMP_MTM                                                                                                                                                       
 FROM TrxLLLMTMDRTV A                                                                                                                                                 
 WHERE Tanggal = DAY(@CURRENT)                                                                                                                                        
   AND Bulan = MONTH(@CURRENT)                                                                                                                                        
   AND Tahun = YEAR(@CURRENT)                                                                                                                                         
   AND TransType IN ('TRANS', 'VALUE')                                                                                                                                
                                                                                                                                                                      
                                                                                                                                                                      
 --(MTM GROUP BY CNO & DEALNO) DERIVATIVE                                                                                                                             
 SELECT A.CustomerID,                                                                                                                                                 
        A.TransType,                                                                                                                                                  
        SUM(Amount) Amount                                                                                                                                            
 INTO #TEMP_MTM_GROUP                                                                                                                                                 
 FROM                                                                                                                                                                 
 (                                                                                                                                                                    
 	SELECT A.CustomerID,                                                                                                                                              
 	       A.TransType,                                                                                                                                               
 	       A.DEALNO,                                                                                                                                                  
 		   Amount = SUM(Amount)                                                                                                                                       
 	FROM #TEMP_MTM A                                                                                                                                                  
 	GROUP BY A.CustomerID, A.TransType, A.DEALNO                                                                                                                      
 	HAVING SUM(Amount) > 0                                                                                                                                            
 )A                                                                                                                                                                   
 GROUP BY A.CustomerID, A.TransType                                                                                                                                   
                                                                                                                                                                      
                                                                                                                                                                      
                                                                                                                                                                      
 --(NOTIONAL AMT) DERIVATIVE                                                                                                                                          
 SELECT CustomerID,                                                                                                                                                   
        A.TransType,                                                                                                                                                  
        CASE WHEN PRODTYPE = 'IR'                                                                                                                                     
 	          THEN FLOOR(ISNULL(A.Amount*PE, 0))                                                                                                                      
 	   END OS_IR,                                                                                                                                                     
 	   CASE WHEN PRODTYPE = 'CS'                                                                                                                                      
 			  THEN FLOOR(ISNULL(A.Amount*PE, 0))                                                                                                                      
 	   END OS_CS                                                                                                                                                      
 INTO #TEMP_NOTAMT                                                                                                                                                    
 FROM TrxLLLNotionalDRTV A                                                                                                                                            
 WHERE Tanggal = DAY(@CURRENT)                                                                                                                                        
   AND Bulan = MONTH(@CURRENT)                                                                                                                                        
   AND Tahun = YEAR(@CURRENT)                                                                                                                                         
   AND A.TransType IN ('TRANS', 'VALUE')                                                                                                                              
                                                                                                                                                                      
                                                                                                                                                                      
                                                                                                                                                                      
 --(NOTIONAL AMT GROUP BY CNO) DERIVATIVE                                                                                                                             
 SELECT A.CustomerID,                                                                                                                                                 
        A.TransType,                                                                                                                                                  
        SUM(OS_IR) OS_IR,                                                                                                                                             
 	   SUM(OS_CS) OS_CS                                                                                                                                               
 INTO #TEMP_NOTAMT_GROUP                                                                                                                                              
 FROM #TEMP_NOTAMT A                                                                                                                                                  
 GROUP BY A.CustomerID, A.TransType                                                                                                                                   
                                                                                                                                                                      
                                                                                                                                                                      
                                                                                                                                                                      
 --(NOT+PV) DERIVATIVE                                                                                                                                                
 SELECT ISNULL(A.CustomerID, B.CustomerID) CustomerID,                                                                                                                
        ISNULL(A.TransType, B.TransType) TransType,                                                                                                                   
        FLOOR(ISNULL(A.Amount/1000000, 0)) AMOUNT_MTM,                                                                                                                
 	   FLOOR(ISNULL(B.OS_CS/1000000, 0)) OS_CS,                                                                                                                       
 	   FLOOR(ISNULL(B.OS_IR/1000000, 0)) OS_IR,                                                                                                                       
 	   FLOOR((ISNULL(A.Amount, 0) + ISNULL(B.OS_CS, 0) + ISNULL(B.OS_IR, 0))/1000000) OS_IRCS                                                                         
 INTO #TEMP_DERIVATIVE1                                                                                                                                               
 FROM #TEMP_MTM_GROUP A                                                                                                                                               
 FULL OUTER JOIN #TEMP_NOTAMT_GROUP B                                                                                                                                 
 ON A.CustomerID = B.CustomerID                                                                                                                                       
 AND A.TransType = B.TransType;                                                                                                                                       
                                                                                                                                                                      
                                                                                                                                                                      
                                                                                                                                                                      
 --INTERBANK                                                                                                                                                          
 SELECT A.CustomerID,                                                                                                                                                 
        A.TransType,                                                                                                                                                  
        FLOOR(SUM(A.Amount)/1000000) OS_InterBank                                                                                                                     
 INTO #TEMP_INTERBANK1                                                                                                                                                
 FROM TrxLLLInterbank A                                                                                                                                               
 WHERE Tanggal = DAY(@CURRENT)                                                                                                                                        
   AND Bulan = MONTH(@CURRENT)                                                                                                                                        
   AND Tahun = YEAR(@CURRENT)                                                                                                                                         
   AND A.TransType IN ('TRANS', 'VALUE')                                                                                                                              
 GROUP BY A.CustomerID, A.TransType;                                                                                                                                  
                                                                                                                                                                      
                                                                                                                                                                      
                                                                                                                                                                      
                                                                                                                                                                      
 --SBLC_LN                                                                                                                                                            
 SELECT A.CustomerID,                                                                                                                                                 
        A.TransType,                                                                                                                                                  
        FLOOR(SUM(A.Amount)/1000000) OS_SBLCLN                                                                                                                        
 INTO #TEMP_SBLCLN1                                                                                                                                                   
 FROM TrxLLLSBLCLN A                                                                                                                                                  
 WHERE Tanggal = DAY(@CURRENT)                                                                                                                                        
   AND Bulan = MONTH(@CURRENT)                                                                                                                                        
   AND Tahun = YEAR(@CURRENT)                                                                                                                                         
   AND A.TransType IN ('TRANS', 'VALUE')                                                                                                                              
 GROUP BY A.CustomerID, A.TransType;                                                                                                                                  
                                                                                                                                                                      
                                                                                                                                                                      
                                                                                                                                                                      
                                                                                                                                                                      
 --SBLC_BG                                                                                                                                                            
 --SELECT A.CustomerID,                                                                                                                                               
 --       A.TransType,                                                                                                                                                
 --       FLOOR(SUM(A.Amount)/1000000) OS_SBLCBG                                                                                                                      
 --INTO #TEMP_SBLCBG1                                                                                                                                                 
 --FROM TrxLLLSBLCBG A                                                                                                                                                
 --WHERE Tanggal = DAY(@CURRENT)                                                                                                                                      
 --  AND Bulan = MONTH(@CURRENT)                                                                                                                                      
 --  AND Tahun = YEAR(@CURRENT)                                                                                                                                       
 --  AND A.TransType IN ('TRANS', 'VALUE')                                                                                                                            
 --GROUP BY A.CustomerID, A.TransType;                                                                                                                                
                                                                                                                                                                      
                                                                                                                                                                      
                                                                                                                                                                      
                                                                                                                                                                      
--Vincent ADD SBLCBG 25-10-2018 AFTER EDITED BY Vincent 24-10-2018 to add type txn GROUP OS_SBLCBG                                                                    
 SELECT A.CustomerID,                                                                                                                                                 
        A.TransType,                                                                                                                                                  
        CASE WHEN FLOOR(SUM(A.Amount)/1000000) > OS_BG                                                                                                                
        THEN OS_BG ELSE FLOOR(SUM(A.Amount)/1000000) END AS OS_SBLCBG                                                                                                 
 INTO #TEMP_SBLCBG1                                                                                                                                                   
 FROM TrxLLLSBLCBG A                                                                                                                                                  
 LEFT JOIN #TEMP_BG1 B                                                                                                                                                
 ON CONVERT(INT, B.CustomerID) = CONVERT(INT, A.CustomerID) AND A.TransType = B.TransType                                                                             
 WHERE A.Tanggal = DAY(@CURRENT)                                                                                                                                      
   AND A.Bulan = MONTH(@CURRENT)                                                                                                                                      
   AND A.Tahun = YEAR(@CURRENT)                                                                                                                                       
   AND A.TransType IN ('TRANS', 'VALUE')                                                                                                                              
   AND A.TypeTXN LIKE '%B/G%'                                                                                                                                         
 GROUP BY A.CustomerID, A.TransType,B.OS_BG                                                                                                                           
 ORDER BY CUSTOMERID DESC                                                                                                                                             
                                                                                                                                                                      
                                                                                                                                                                      
                                                                                                                                                                      
                                                                                                                                                                      
--Vincent ADD OS_SBLCLC 25-10-2018 AFTER EDITED BY Vincent 24-10-2018 to add type txn GROUP OS_SBLCLC                                                                 
 SELECT A.CustomerID,                                                                                                                                                 
        A.TransType,                                                                                                                                                  
        CASE WHEN FLOOR(SUM(A.Amount)/1000000) > OS_LC                                                                                                                
        THEN OS_LC ELSE FLOOR(SUM(A.Amount)/1000000) END AS OS_SBLCLC                                                                                                 
 INTO #TEMP_SBLCLC1                                                                                                                                                   
 FROM TrxLLLSBLCBG A                                                                                                                                                  
 LEFT JOIN #TEMP_LC1 B                                                                                                                                                
 ON CONVERT(INT, B.CustomerID) = CONVERT(INT, A.CustomerID) AND A.TransType = B.TransType                                                                             
 WHERE A.Tanggal = DAY(@CURRENT)                                                                                                                                      
   AND A.Bulan = MONTH(@CURRENT)                                                                                                                                      
   AND A.Tahun = YEAR(@CURRENT)                                                                                                                                       
   AND A.TransType IN ('TRANS', 'VALUE')                                                                                                                              
   AND A.TypeTXN   IN ('ACC', 'BB w ELC', 'BD wo ELC', 'IBD', 'IMPORT', 'L/C')                                                                                        
 GROUP BY A.CustomerID, A.TransType,B.OS_LC                                                                                                                           
 ORDER BY CUSTOMERID DESC                                                                                                                                             
                                                                                                                                                                      
                                                                                                                                                                      
                                                                                                                                                                      
                                                                                                                                                                      
--Vincent ADD OS_SBLCFX 25-10-2018 AFTER EDITED BY Vincent 24-10-2018 to add type txn GROUP OS_SBLCFX                                                                 
 SELECT A.CustomerID,                                                                                                                                                 
        A.TransType,                                                                                                                                                  
        CASE WHEN FLOOR(SUM(A.Amount)/1000000) > OS_FX                                                                                                                
        THEN OS_FX ELSE FLOOR(SUM(A.Amount)/1000000) END AS OS_SBLCFX                                                                                                 
 INTO #TEMP_SBLCFX1                                                                                                                                                   
 FROM TrxLLLSBLCBG A                                                                                                                                                  
 LEFT JOIN #TEMP_FX1 B                                                                                                                                                
 ON CONVERT(INT, B.CustomerID) = CONVERT(INT, A.CustomerID) AND A.TransType = B.TransType                                                                             
 WHERE A.Tanggal = DAY(@CURRENT)                                                                                                                                      
   AND A.Bulan = MONTH(@CURRENT)                                                                                                                                      
   AND A.Tahun = YEAR(@CURRENT)                                                                                                                                       
   AND A.TransType IN ('TRANS', 'VALUE')                                                                                                                              
 AND A.TypeTXN LIKE '%FX%'                                                                                                                                            
 GROUP BY A.CustomerID, A.TransType,B.OS_FX                                                                                                                           
 ORDER BY CUSTOMERID DESC                                                                                                                                             
                                                                                                                                                                      
                                                                                                                                                                      
                                                                                                                                                                      
                                                                                                                                                                      
--Vincent ADD OS_SBLCIRCS 25-10-2018 AFTER EDITED BY Vincent 24-10-2018 to add type txn GROUP OS_SBLCIRCS                                                             
  SELECT A.CustomerID,                                                                                                                                                
        A.TransType,                                                                                                                                                  
        CASE WHEN FLOOR(SUM(A.Amount)/1000000) > OS_IRCS                                                                                                              
        THEN OS_IRCS ELSE FLOOR(SUM(A.Amount)/1000000) END AS OS_SBLCIRCS                                                                                             
 INTO #TEMP_SBLCIRCS1                                                                                                                                                 
 FROM TrxLLLSBLCBG A                                                                                                                                                  
 LEFT JOIN #TEMP_DERIVATIVE1 B                                                                                                                                        
 ON CONVERT(INT, B.CustomerID) = CONVERT(INT, A.CustomerID) AND A.TransType = B.TransType                                                                             
 WHERE A.Tanggal = DAY(@CURRENT)                                                                                                                                      
   AND A.Bulan = MONTH(@CURRENT)                                                                                                                                      
   AND A.Tahun = YEAR(@CURRENT)                                                                                                                                       
   AND A.TransType IN ('TRANS', 'VALUE')                                                                                                                              
   AND A.TypeTXN   IN ('CCY OPTION', 'CCY SWAP', 'IRS')                                                                                                               
 GROUP BY A.CustomerID, A.TransType,B.OS_IRCS                                                                                                                         
 ORDER BY CUSTOMERID DESC                                                                                                                                             
                                                                                                                                                                      
                                                                                                                                                                      
                                                                                                                                                                      
                                                                                                                                                                      
                                                                                                                                                                      
                                                                                                                                                                      
 --PLEDGETD                                                                                                                                                           
 SELECT A.CustID CustomerID,                                                                                                                                          
        A.TransType,                                                                                                                                                  
        FLOOR(SUM(ISNULL(A.TotalLN,0) + ISNULL(A.TotalBG,0) + ISNULL(A.TotalLC,0))/1000000) OS_PLEDGETD                                                               
 INTO #TEMP_PLEDGETD1                                                                                                                                                 
 FROM TrxLLLPLEDGETDSummary A                                                                                                                                         
 WHERE Tanggal = DAY(@CURRENT)                                                                                                                                        
   AND Bulan = MONTH(@CURRENT)                                                                                                                                        
   AND Tahun = YEAR(@CURRENT)                                                                                                                                         
   AND A.TransType IN ('TRANS', 'VALUE')                                                                                                                              
 GROUP BY A.CustID, A.TransType                                                                                                                                       
                                                                                                                                                                      
                                                                                                                                                                      
                                                                                                                                                                      
                                                                                                                                                                      
 --------------------------------------------------- INSERT INTO PHYSICAL TABLE                                                                                       
                                                                                                                                                                      
 --CUSTOMER                                                                                                                                                           
 SELECT A.BBCUST, A.BBCRNM BBCNA1                                                                                                                                     
 INTO #TEMP_CUST                                                                                                                                                      
 FROM [IBMDA400LIVE].[S849BD8W].[SIDMLIB].SDCUSTPD A                                                                                                                    
                                                                                                                                                                      
 INNER JOIN [IBMDA400LIVE].[S849BD8W].[SIDMLIB].CLINTCB B                                                                                                   
 ON A.BBCUST = B.CNUM                                                                                                                                                 
                                                                                                                                                                      
 INNER JOIN [ERPLIVE].[BMIERP].dbo.MasterCustomer C                                                                                                          
 ON A.BBCUST = C.CustomerID                                                                                                                                           
                                                                                                                                                                      
 WHERE CRNM <> 'DO NOT USE' AND RECI = 'D'                                                                                                                            
 AND C.CustomerStatusID in (1, 7, 8);                                                                                                                                 
                                                                                                                                                                      
                                                                                                                                                                      
                                                                                                                                                                      
 -- DELETE OLD DATA                                                                                                                                                   
 DELETE TrxLLLOutstanding                                                                                                                                             
 WHERE Tanggal = DAY(@CURRENT) AND                                                                                                                                    
       Bulan = MONTH(@CURRENT) AND                                                                                                                                    
 	  Tahun = YEAR(@CURRENT)  AND                                                                                                                                     
 	  TransType IN ('TRANS', 'VALUE')                                                                                                                                 
                                                                                                                                                                      
                                                                                                                                                                      
                                                                                                                                                                      
 --INSERT (1. TRANS) edited by Vincent to calculate sblcbg from sblcbg, sblclc, sblcfx, sblcircs                                                                      
 INSERT INTO TrxLLLOutstanding                                                                                                                                        
 (Tanggal, Bulan, Tahun, TransType, CustomerNo, LN, BG, LC, Interbank, Forex, MTM, DerivativeCCS,                                                                     
  DerivativeIRS, TotalDerivative, TotalOS, JaminanPlacement, SBLCLN, SBLCBG, PLEDGETD, GeneratedBy, DateGenerate)                                                     
 SELECT DAY(@CURRENT),                                                                                                                                                
        MONTH(@CURRENT),                                                                                                                                              
 	   YEAR(@CURRENT),                                                                                                                                                
        'TRANS',                                                                                                                                                      
 	   CUST.BBCUST,                                                                                                                                                   
 	   CASE WHEN A.OS_LN = 0.00 THEN NULL ELSE A.OS_LN END LN,                                                                                                        
 	   CASE WHEN B.OS_BG = 0.00 THEN NULL ELSE B.OS_BG END BG,                                                                                                        
 	   CASE WHEN C.OS_LC = 0.00 THEN NULL ELSE C.OS_LC END LC,                                                                                                        
 	   CASE WHEN F.OS_Interbank = 0.00 THEN NULL ELSE F.OS_Interbank END Interbank,                                                                                   
 	   CASE WHEN D.OS_FX = 0.00 THEN NULL ELSE D.OS_FX END FX,                                                                                                        
 	   CASE WHEN E.AMOUNT_MTM = 0.00 THEN NULL ELSE E.AMOUNT_MTM END MTM,                                                                                             
 	   CASE WHEN E.OS_CS = 0.00 THEN NULL ELSE E.OS_CS END DERV_CS,                                                                                                   
 	   CASE WHEN E.OS_IR = 0.00 THEN NULL ELSE E.OS_IR END DERV_IR,                                                                                                   
 	   CASE WHEN E.OS_IRCS = 0.00 THEN NULL ELSE E.OS_IRCS END DERV,                                                                                                  
 	   ISNULL(A.OS_LN, 0) + ISNULL(B.OS_BG, 0) + ISNULL(C.OS_LC, 0) + ISNULL(F.OS_InterBank, 0) +                                                                     
 	     ISNULL(D.OS_FX, 0) + ISNULL(E.OS_IRCS, 0) TOTALOS,                                                                                                           
 	   CASE WHEN CUST2.IsPrime = 'Y'                                                                                                                                  
 				THEN CASE WHEN F.OS_Interbank = 0.00                                                                                                                  
 						    THEN NULL                                                                                                                                 
 					      ELSE CASE WHEN F.OS_Interbank > @CAPITAL THEN @CAPITAL ELSE F.OS_InterBank END                                                              
 				END                                                                                                                                                   
 			ELSE NULL                                                                                                                                                 
 	   END JaminanPlacement,                                                                                                                                          
       CASE WHEN G.OS_SBLCLN = 0.00                                                                                                                                   
       		THEN NULL                                                                                                                                                 
       	ELSE CASE WHEN G.OS_SBLCLN > A.OS_LN THEN A.OS_LN ELSE G.OS_SBLCLN END                                                                                        
       END SBLCLN,                                                                                                                                                    
       SBLCBG = CASE WHEN (J.OS_SBLCBG IS NULL) AND (K.OS_SBLCLC IS NULL) AND (L.OS_SBLCFX IS NULL) AND (M.OS_SBLCIRCS IS NULL) THEN NULL                             
       ELSE ISNULL(J.OS_SBLCBG, 0) + ISNULL(K.OS_SBLCLC, 0) + ISNULL(L.OS_SBLCFX, 0) + ISNULL(M.OS_SBLCIRCS, 0) END,                                                  
 	   I.OS_PLEDGETD PLEDGETD,                                                                                                                                        
 	   'SERVICE',                                                                                                                                                     
 	   GETDATE()                                                                                                                                                      
 FROM #TEMP_CUST CUST                                                                                                                                                 
                                                                                                                                                                      
 LEFT JOIN [ERPLIVE].[BMIERP].dbo.MasterCustomer CUST2                                                                                                       
 ON CONVERT(VARCHAR, CUST2.CustomerID) = CONVERT(VARCHAR, CUST.BBCUST)                                                                                                
                                                                                                                                                                      
 LEFT JOIN #TEMP_LN1 A                                                                                                                                                
 ON CONVERT(INT, A.CustomerID) = CONVERT(INT, CUST.BBCUST) AND A.TransType = 'TRANS'                                                                                  
                                                                                                                                                                      
 LEFT JOIN #TEMP_BG1 B                                                                                                                                                
 ON CONVERT(INT, B.CustomerID) = CONVERT(INT, CUST.BBCUST) AND B.TransType = 'TRANS'                                                                                  
                                                                                                                                                                      
 LEFT JOIN #TEMP_LC1 C                                                                                                                                                
 ON CONVERT(INT, C.CustomerID) = CONVERT(INT, CUST.BBCUST) AND C.TransType = 'TRANS'                                                                                  
                                                                                                                                                                      
 LEFT JOIN #TEMP_FX1 D                                                                                                                                                
 ON CONVERT(INT, D.CustomerID) = CONVERT(INT, CUST.BBCUST) AND D.TransType = 'TRANS'                                                                                  
                                                                                                                                                                      
 LEFT JOIN #TEMP_DERIVATIVE1 E                                                                                                                                        
 ON CONVERT(INT, E.CustomerID) = CONVERT(INT, CUST.BBCUST) AND E.TransType = 'TRANS'                                                                                  
                                                                                                                                                                      
 LEFT JOIN #TEMP_INTERBANK1 F                                                                                                                                         
 ON CONVERT(INT, F.CustomerID) = CONVERT(INT, CUST.BBCUST) AND F.TransType = 'TRANS'                                                                                  
                                                                                                                                                                      
 LEFT JOIN #TEMP_SBLCLN1 G                                                                                                                                            
 ON CONVERT(INT, G.CustomerID) = CONVERT(INT, CUST.BBCUST) AND G.TransType = 'TRANS'                                                                                  
                                                                                                                                                                      
 LEFT JOIN #TEMP_SBLCBG1 H                                                                                                                                            
 ON CONVERT(INT, H.CustomerID) = CONVERT(INT, CUST.BBCUST) AND H.TransType = 'TRANS'                                                                                  
                                                                                                                                                                      
 LEFT JOIN #TEMP_PLEDGETD1 I                                                                                                                                          
 ON CONVERT(INT, I.CustomerID) = CONVERT(INT, CUST.BBCUST) AND I.TransType = 'TRANS'                                                                                  
                                                                                                                                                                      
 LEFT JOIN #TEMP_SBLCBG1 J                                                                                                                                            
 ON CONVERT(INT, J.CustomerID) = CONVERT(INT, CUST.BBCUST) AND J.TransType = 'TRANS'                                                                                  
                                                                                                                                                                      
 LEFT JOIN #TEMP_SBLCLC1 K                                                                                                                                            
 ON CONVERT(INT, K.CustomerID) = CONVERT(INT, CUST.BBCUST) AND K.TransType = 'TRANS'                                                                                  
                                                                                                                                                                      
 LEFT JOIN #TEMP_SBLCFX1 L                                                                                                                                            
 ON CONVERT(INT, L.CustomerID) = CONVERT(INT, CUST.BBCUST) AND L.TransType = 'TRANS'                                                                                  
                                                                                                                                                                      
 LEFT JOIN #TEMP_SBLCIRCS1 M                                                                                                                                          
 ON CONVERT(INT, M.CustomerID) = CONVERT(INT, CUST.BBCUST) AND M.TransType = 'TRANS'                                                                                  
                                                                                                                                                                      
                                                                                                                                                                      
                                                                                                                                                                      
 --INSERT (2. VALUE) edited by Vincent to calculate sblcbg from sblcbg, sblclc, sblcfx, sblcircs                                                                      
 INSERT INTO TrxLLLOutstanding                                                                                                                                        
 (Tanggal, Bulan, Tahun, TransType, CustomerNo, LN, BG, LC, Interbank, Forex, MTM, DerivativeCCS,                                                                     
  DerivativeIRS, TotalDerivative, TotalOS, JaminanPlacement, SBLCLN, SBLCBG, PLEDGETD, GeneratedBy, DateGenerate)                                                     
 SELECT DAY(@CURRENT),                                                                                                                                                
        MONTH(@CURRENT),                                                                                                                                              
 	   YEAR(@CURRENT),                                                                                                                                                
        'VALUE',                                                                                                                                                      
 	   CUST.BBCUST,                                                                                                                                                   
 	   CASE WHEN A.OS_LN = 0.00 THEN NULL ELSE A.OS_LN END LN,                                                                                                        
 	   CASE WHEN B.OS_BG = 0.00 THEN NULL ELSE B.OS_BG END BG,                                                                                                        
 	   CASE WHEN C.OS_LC = 0.00 THEN NULL ELSE C.OS_LC END LC,                                                                                                        
 	   CASE WHEN F.OS_Interbank = 0.00 THEN NULL ELSE F.OS_Interbank END Interbank,                                                                                   
 	   CASE WHEN D.OS_FX = 0.00 THEN NULL ELSE D.OS_FX END FX,                                                                                                        
 	   CASE WHEN E.AMOUNT_MTM = 0.00 THEN NULL ELSE E.AMOUNT_MTM END MTM,                                                                                             
 	   CASE WHEN E.OS_CS = 0.00 THEN NULL ELSE E.OS_CS END DERV_CS,                                                                                                   
 	   CASE WHEN E.OS_IR = 0.00 THEN NULL ELSE E.OS_IR END DERV_IR,                                                                                                   
 	   CASE WHEN E.OS_IRCS = 0.00 THEN NULL ELSE E.OS_IRCS END DERV,                                                                                                  
 	   ISNULL(A.OS_LN, 0) + ISNULL(B.OS_BG, 0) + ISNULL(C.OS_LC, 0) + ISNULL(F.OS_InterBank, 0) +                                                                     
 	     ISNULL(D.OS_FX, 0) + ISNULL(E.OS_IRCS, 0) TOTALOS,                                                                                                           
 	   CASE WHEN CUST2.IsPrime = 'Y'                                                                                                                                  
 				THEN CASE WHEN F.OS_Interbank = 0.00                                                                                                                  
 						    THEN NULL                                                                                                                                 
 					      ELSE CASE WHEN F.OS_Interbank > @CAPITAL THEN @CAPITAL ELSE F.OS_InterBank END                                                              
 				END                                                                                                                                                   
 			ELSE NULL                                                                                                                                                 
 	   END JaminanPlacement,                                                                                                                                          
       CASE WHEN G.OS_SBLCLN = 0.00                                                                                                                                   
       		THEN NULL                                                                                                                                                 
       	ELSE CASE WHEN G.OS_SBLCLN > A.OS_LN THEN A.OS_LN ELSE G.OS_SBLCLN END                                                                                        
       END SBLCLN,                                                                                                                                                    
       SBLCBG = CASE WHEN (J.OS_SBLCBG IS NULL) AND (K.OS_SBLCLC IS NULL) AND (L.OS_SBLCFX IS NULL) AND (M.OS_SBLCIRCS IS NULL) THEN NULL                             
       ELSE ISNULL(J.OS_SBLCBG, 0) + ISNULL(K.OS_SBLCLC, 0) + ISNULL(L.OS_SBLCFX, 0) + ISNULL(M.OS_SBLCIRCS, 0) END,                                                  
 	   I.OS_PLEDGETD PLEDGETD,                                                                                                                                        
 	   'SERVICE',                                                                                                                                                     
 	   GETDATE()                                                                                                                                                      
 FROM #TEMP_CUST CUST                                                                                                                                                 
                                                                                                                                                                      
 LEFT JOIN [ERPLIVE].[BMIERP].dbo.MasterCustomer CUST2                                                                                                       
 ON CONVERT(VARCHAR, CUST2.CustomerID) = CONVERT(VARCHAR, CUST.BBCUST)                                                                                                
                                                                                                                                                                      
 LEFT JOIN #TEMP_LN1 A                                                                                                                                                
 ON CONVERT(INT, A.CustomerID) = CONVERT(INT, CUST.BBCUST) AND A.TransType = 'VALUE'                                                                                  
                                                                                                                                                                      
 LEFT JOIN #TEMP_BG1 B                                                                                                                                                
 ON CONVERT(INT, B.CustomerID) = CONVERT(INT, CUST.BBCUST) AND B.TransType = 'VALUE'                                                                                  
                                                                                                                                                                      
 LEFT JOIN #TEMP_LC1 C                                                                                                                                                
 ON CONVERT(INT, C.CustomerID) = CONVERT(INT, CUST.BBCUST) AND C.TransType = 'VALUE'                                                                                  
                                                                                                                                                                      
 LEFT JOIN #TEMP_FX1 D                                                                                                                                                
 ON CONVERT(INT, D.CustomerID) = CONVERT(INT, CUST.BBCUST) AND D.TransType = 'VALUE'                                                                                  
                                                                                                                                                                      
 LEFT JOIN #TEMP_DERIVATIVE1 E                                                                                                                                        
 ON CONVERT(INT, E.CustomerID) = CONVERT(INT, CUST.BBCUST) AND E.TransType = 'VALUE'                                                                                  
                                                                                                                                                                      
 LEFT JOIN #TEMP_INTERBANK1 F                                                                                                                                         
 ON CONVERT(INT, F.CustomerID) = CONVERT(INT, CUST.BBCUST) AND F.TransType = 'VALUE'                                                                                  
                                                                                                                                                                      
 LEFT JOIN #TEMP_SBLCLN1 G                                                                                                                                            
 ON CONVERT(INT, G.CustomerID) = CONVERT(INT, CUST.BBCUST) AND G.TransType = 'VALUE'                                                                                  
                                                                                                                                                                      
 LEFT JOIN #TEMP_SBLCBG1 H                                                                                                                                            
 ON CONVERT(INT, H.CustomerID) = CONVERT(INT, CUST.BBCUST) AND H.TransType = 'VALUE'                                                                                  
                                                                                                                                                                      
 LEFT JOIN #TEMP_PLEDGETD1 I                                                                                                                                          
 ON CONVERT(INT, I.CustomerID) = CONVERT(INT, CUST.BBCUST) AND I.TransType = 'VALUE'                                                                                  
                                                                                                                                                                      
 LEFT JOIN #TEMP_SBLCBG1 J                                                                                                                                            
 ON CONVERT(INT, J.CustomerID) = CONVERT(INT, CUST.BBCUST) AND J.TransType = 'VALUE'                                                                                  
                                                                                                                                                                      
 LEFT JOIN #TEMP_SBLCLC1 K                                                                                                                                            
 ON CONVERT(INT, K.CustomerID) = CONVERT(INT, CUST.BBCUST) AND K.TransType = 'VALUE'                                                                                  
                                                                                                                                                                      
 LEFT JOIN #TEMP_SBLCFX1 L                                                                                                                                            
 ON CONVERT(INT, L.CustomerID) = CONVERT(INT, CUST.BBCUST) AND L.TransType = 'VALUE'                                                                                  
                                                                                                                                                                      
 LEFT JOIN #TEMP_SBLCIRCS1 M                                                                                                                                          
 ON CONVERT(INT, M.CustomerID) = CONVERT(INT, CUST.BBCUST) AND M.TransType = 'VALUE'                                                                                  
                                                                                                                                                                      
                                                                                                                                                                      
                                                                                                                                                                      
                                                                                                                                                                      
 -----------------------------------------------------------------------------------------------------------------------------                                        
 -----------------------------------------------------------------------------------------------------------------------------                                        
                                                                                                                                                                      
 -------------------------------------------------------AVAIBILITY                                                                                                    
                                                                                                                                                                      
                                                                                                                                                                      
 --SELECTION CUSTOMER WITH GROUP                                                                                                                                      
 SELECT A.CustomerID,                                                                                                                                                 
        A.CustomerName,                                                                                                                                               
        CASE WHEN LTRIM(RTRIM(B.CustomerGroupStatus)) = 'D'                                                                                                           
 				THEN NULL                                                                                                                                             
 			ELSE LTRIM(RTRIM(A.CustomerGroupID))                                                                                                                      
 	   END CustomerGroupID,                                                                                                                                           
 	   A.IsRelatedParty,                                                                                                                                              
 	   A.IsSOE,                                                                                                                                                       
 	   B.SpecialTreatment,                                                                                                                                            
 	   B.MinSBLC,                                                                                                                                                     
 	   B.MaxSBLC,                                                                                                                                                     
 	   B.BufferSBLC                                                                                                                                                   
 INTO #TEMP_CUSTGROUP                                                                                                                                                 
 FROM                                                                                                                                                                 
 (                                                                                                                                                                    
 	SELECT 'GROUP1' SOURCE,                                                                                                                                           
 	       a.CustomerID,                                                                                                                                              
 	       a.CustomerName,                                                                                                                                            
 		   a.CustomerGroupID,                                                                                                                                         
 		   a.IsRelatedParty,                                                                                                                                          
 		   a.IsSOE                                                                                                                                                    
 	FROM [ERPLIVE].[BMIERP].dbo.MasterCustomer a                                                                                                             
 	WHERE ISNULL(a.CustomerGroupID, '') <> ''                                                                                                                         
                                                                                                                                                                      
 	UNION ALL                                                                                                                                                         
                                                                                                                                                                      
 	SELECT 'GROUP2' SOURCE,                                                                                                                                           
 	       a.CustomerID,                                                                                                                                              
 		   a.CustomerName,                                                                                                                                            
 		   a.CustomerGroupID2,                                                                                                                                        
 		   a.IsRelatedParty,                                                                                                                                          
 		   a.IsSOE                                                                                                                                                    
 	FROM [ERPLIVE].[BMIERP].dbo.MasterCustomer a                                                                                                             
 	WHERE ISNULL(a.CustomerGroupID2, '') <> ''                                                                                                                        
                                                                                                                                                                      
 	UNION ALL                                                                                                                                                         
                                                                                                                                                                      
 	SELECT 'GROUP3' SOURCE,                                                                                                                                           
 		   a.CustomerID,                                                                                                                                              
 		   a.CustomerName,                                                                                                                                            
 		   a.CustomerGroupID3,                                                                                                                                        
 		   a.IsRelatedParty,                                                                                                                                          
 		   a.IsSOE                                                                                                                                                    
 	FROM [ERPLIVE].[BMIERP].dbo.MasterCustomer a                                                                                                             
 	WHERE ISNULL(a.CustomerGroupID3, '') <> ''                                                                                                                        
                                                                                                                                                                      
 	UNION ALL                                                                                                                                                         
                                                                                                                                                                      
 	SELECT 'GROUP4' SOURCE,                                                                                                                                           
 	       a.CustomerID,                                                                                                                                              
 		   a.CustomerName,                                                                                                                                            
 		   a.CustomerGroupID4,                                                                                                                                        
 		   a.IsRelatedParty,                                                                                                                                          
 		   a.IsSOE                                                                                                                                                    
 	FROM [ERPLIVE].[BMIERP].dbo.MasterCustomer a                                                                                                             
 	WHERE ISNULL(a.CustomerGroupID4, '') <> ''                                                                                                                        
                                                                                                                                                                      
 	UNION ALL                                                                                                                                                         
                                                                                                                                                                      
 	SELECT 'GROUP5' SOURCE,                                                                                                                                           
 	       a.CustomerID,                                                                                                                                              
 		   a.CustomerName,                                                                                                                                            
 		   a.CustomerGroupID5,                                                                                                                                        
 		   a.IsRelatedParty,                                                                                                                                          
 		   a.IsSOE                                                                                                                                                    
 	FROM [ERPLIVE].[BMIERP].dbo.MasterCustomer a                                                                                                             
 	WHERE ISNULL(a.CustomerGroupID5, '') <> ''                                                                                                                        
                                                                                                                                                                      
                                                                                                                                                                      
 	UNION ALL                                                                                                                                                         
                                                                                                                                                                      
 	SELECT 'GROUP6' SOURCE,                                                                                                                                           
 	       a.CustomerID,                                                                                                                                              
 		   a.CustomerName,                                                                                                                                            
 		   a.CustomerGroupID6,                                                                                                                                        
 		   a.IsRelatedParty,                                                                                                                                          
 		   a.IsSOE                                                                                                                                                    
 	FROM [ERPLIVE].[BMIERP].dbo.MasterCustomer a                                                                                                             
 	WHERE ISNULL(a.CustomerGroupID6, '') <> ''                                                                                                                        
                                                                                                                                                                      
                                                                                                                                                                      
 	UNION ALL                                                                                                                                                         
                                                                                                                                                                      
 	SELECT 'GROUP7' SOURCE,                                                                                                                                           
 	       a.CustomerID,                                                                                                                                              
 		   a.CustomerName,                                                                                                                                            
 		   a.CustomerGroupID7,                                                                                                                                        
 		   a.IsRelatedParty,                                                                                                                                          
 		   a.IsSOE                                                                                                                                                    
 	FROM [ERPLIVE].[BMIERP].dbo.MasterCustomer a                                                                                                             
 	WHERE ISNULL(a.CustomerGroupID7, '') <> ''                                                                                                                        
                                                                                                                                                                      
 	UNION ALL                                                                                                                                                         
                                                                                                                                                                      
 	SELECT 'GROUP8' SOURCE,                                                                                                                                           
 	       a.CustomerID,                                                                                                                                              
 		   a.CustomerName,                                                                                                                                            
 		   a.CustomerGroupID8,                                                                                                                                        
 		   a.IsRelatedParty,                                                                                                                                          
 		   a.IsSOE                                                                                                                                                    
 	FROM [ERPLIVE].[BMIERP].dbo.MasterCustomer a                                                                                                             
 	WHERE ISNULL(a.CustomerGroupID8, '') <> ''                                                                                                                        
                                                                                                                                                                      
 	UNION ALL                                                                                                                                                         
                                                                                                                                                                      
 	SELECT 'GROUP9' SOURCE,                                                                                                                                           
 	       a.CustomerID,                                                                                                                                              
 		   a.CustomerName,                                                                                                                                            
 		   a.CustomerGroupID9,                                                                                                                                        
 		   a.IsRelatedParty,                                                                                                                                          
 		   a.IsSOE                                                                                                                                                    
 	FROM [ERPLIVE].[BMIERP].dbo.MasterCustomer a                                                                                                             
 	WHERE ISNULL(a.CustomerGroupID9, '') <> ''                                                                                                                        
                                                                                                                                                                      
 	UNION ALL                                                                                                                                                         
                                                                                                                                                                      
 	SELECT 'GROUP10' SOURCE,                                                                                                                                          
 	       a.CustomerID,                                                                                                                                              
 		   a.CustomerName,                                                                                                                                            
 		   a.CustomerGroupID10,                                                                                                                                       
 		   a.IsRelatedParty,                                                                                                                                          
 		   a.IsSOE                                                                                                                                                    
 	FROM [ERPLIVE].[BMIERP].dbo.MasterCustomer a                                                                                                             
 	WHERE ISNULL(a.CustomerGroupID10, '') <> ''                                                                                                                       
                                                                                                                                                                      
 	UNION ALL                                                                                                                                                         
                                                                                                                                                                      
 	--UNTUK CUSTOMER YANG TIDAK PUNYA GROUP                                                                                                                           
 	SELECT 'GROUP0' SOURCE,                                                                                                                                           
 	       a.CustomerID,                                                                                                                                              
 		   a.CustomerName,                                                                                                                                            
 		   a.CustomerGroupID5,                                                                                                                                        
 		   a.IsRelatedParty,                                                                                                                                          
 		   a.IsSOE                                                                                                                                                    
 	FROM [ERPLIVE].[BMIERP].dbo.MasterCustomer a                                                                                                             
 	WHERE ISNULL(a.CustomerGroupID, '') = ''                                                                                                                          
 	  AND ISNULL(a.CustomerGroupID2, '') = ''                                                                                                                         
 	  AND ISNULL(a.CustomerGroupID3, '') = ''                                                                                                                         
 	  AND ISNULL(a.CustomerGroupID4, '') = ''                                                                                                                         
 	  AND ISNULL(a.CustomerGroupID5, '') = ''                                                                                                                         
 	  AND ISNULL(a.CustomerGroupID6, '') = ''                                                                                                                         
 	  AND ISNULL(a.CustomerGroupID7, '') = ''                                                                                                                         
 	  AND ISNULL(a.CustomerGroupID8, '') = ''                                                                                                                         
 	  AND ISNULL(a.CustomerGroupID9, '') = ''                                                                                                                         
 	  AND ISNULL(a.CustomerGroupID10, '') = ''                                                                                                                        
                                                                                                                                                                      
 )A                                                                                                                                                                   
 LEFT JOIN [ERPLIVE].[BMIERP].dbo.MasterCustomerGroup B                                                                                                      
 ON A.CustomerGroupID = B.CustomerGroupID                                                                                                                             
 ORDER BY CustomerID                                                                                                                                                  
                                                                                                                                                                      
                                                                                                                                                                      
                                                                                                                                                                      
 --SPECIAL AAGREEMENT FOR CUSTOMER GROUP I.E SINARMAS                                                                                                                 
 SELECT ROW_NUMBER() OVER(PARTITION BY A.CustomerGroupID, B.TransType ORDER BY B.TotalOS DESC) RankPriority,                                                          
        B.CustomerNo,                                                                                                                                                 
        A.CustomerGroupID,                                                                                                                                            
        B.TotalOS,                                                                                                                                                    
 	   CONVERT(DECIMAL(20, 2), 0.00) TotalOSGroup,                                                                                                                    
 	   CONVERT(DECIMAL(20, 2), 0.00) TotalSBLCGroup,                                                                                                                  
 	   CONVERT(DECIMAL(20, 2), 0.00) SBLC,                                                                                                                            
 	   CONVERT(DECIMAL(20, 2), 0.00) Avaibility,                                                                                                                      
 	   CONVERT(DECIMAL(20, 2), 0.00) SisaSBLC,                                                                                                                        
 	   A.MinSBLC,                                                                                                                                                     
 	   A.MaxSBLC,                                                                                                                                                     
 	   A.BufferSBLC,                                                                                                                                                  
 	   B.TransType                                                                                                                                                    
 INTO #TEMP_STREAT                                                                                                                                                    
 FROM #TEMP_CUSTGROUP A                                                                                                                                               
                                                                                                                                                                      
 LEFT JOIN TrxLLLOutstanding B                                                                                                                                        
 ON A.CustomerID = B.CustomerNo                                                                                                                                       
                                                                                                                                                                      
 LEFT JOIN [ERPLIVE].[BMIERP].dbo.MasterCustomer C                                                                                                           
 ON A.CustomerID = C.CustomerID                                                                                                                                       
                                                                                                                                                                      
 WHERE B.Tanggal = DAY(@CURRENT) AND                                                                                                                                  
 B.Bulan = MONTH(@CURRENT) AND B.Tahun = YEAR(@CURRENT)                                                                                                               
 AND B.TransType IN ('VALUE', 'TRANS')                                                                                                                                
 AND ISNULL(A.SpecialTreatment, '') = 'Y'                                                                                                                             
                                                                                                                                                                      
                                                                                                                                                                      
                                                                                                                                                                      
                                                                                                                                                                      
                                                                                                                                                                      
 --UPDATE TOTAL OS                                                                                                                                                    
 UPDATE A                                                                                                                                                             
 	SET A.TotalOSGroup = B.TotalOSGroup,                                                                                                                              
 		A.TotalSBLCGroup = CASE WHEN B.TotalOSGroup > @GROUPTH AND ABS(B.TotalOSGroup - @GROUPTH)/C.Rate > A.MaxSBLC                                                  
 									THEN A.MaxSBLC*C.Rate                                                                                                             
 								WHEN B.TotalOSGroup > @GROUPTH AND ABS(B.TotalOSGroup - @GROUPTH)/C.Rate <= A.MaxSBLC                                                 
 									THEN (B.TotalOSGroup - @GROUPTH)*(1 + A.BufferSBLC)                                                                               
 								WHEN B.TotalOSGroup <= @GROUPTH AND B.TotalOSGroup/C.Rate > A.MinSBLC                                                                 
 									THEN A.MinSBLC*C.Rate                                                                                                             
 							    WHEN B.TotalOSGroup/C.Rate <= A.MinSBLC                                                                                               
 									THEN 0.00                                                                                                                         
 								ELSE 0.00                                                                                                                             
 						   END                                                                                                                                        
 FROM #TEMP_STREAT A                                                                                                                                                  
 LEFT JOIN                                                                                                                                                            
 (                                                                                                                                                                    
 	 SELECT A.CustomerGroupID,                                                                                                                                        
 	        A.TransType,                                                                                                                                              
 	        SUM(A.TotalOS) TotalOSGroup                                                                                                                               
 	 FROM #TEMP_STREAT A                                                                                                                                              
 	 GROUP BY A.CustomerGroupID, A.TransType                                                                                                                          
 )B                                                                                                                                                                   
 ON A.CustomerGroupID = B.CustomerGroupID                                                                                                                             
 AND A.TransType = B.TransType                                                                                                                                        
                                                                                                                                                                      
 LEFT JOIN TrxLLLTempCurrencyScreen C                                                                                                                                 
 ON C.CCY = 'USD' AND C.TransType = 'INTRA';                                                                                                                          
                                                                                                                                                                      
                                                                                                                                                                      
                                                                                                                                                                      
                                                                                                                                                                      
 --RUN SCENARIO FOR SBLC                                                                                                                                              
 UPDATE A                                                                                                                                                             
 	SET A.SBLC = CASE WHEN A.TotalOSGroup > @GROUPTH --SCENARIO C                                                                                                     
 						THEN (A.TotalOS/A.TotalOSGroup) * A.TotalSBLCGroup                                                                                            
 					                                                                                                                                                  
 					  WHEN A.TotalOSGroup <= @GROUPTH AND A.TotalOSGroup/C.Rate > A.MinSBLC  --SCENARIO B                                                             
 						THEN                                                                                                                                          
 							CASE WHEN (SELECT SUM(B.TotalOS)/C.Rate                                                                                                   
 							           FROM #TEMP_STREAT B                                                                                                            
 									   WHERE B.CustomerGroupID = A.CustomerGroupID                                                                                    
 									   AND B.TransType = A.TransType                                                                                                  
 									   AND B.RankPriority <= A.RankPriority                                                                                           
 									   GROUP BY B.CustomerGroupID, B.TransType) <= A.MinSBLC                                                                          
 									THEN A.TotalOS                                                                                                                    
                                                                                                                                                                      
 								 WHEN (SELECT SUM(B.TotalOS)/C.Rate                                                                                                   
 							           FROM #TEMP_STREAT B                                                                                                            
 									   WHERE B.CustomerGroupID = A.CustomerGroupID                                                                                    
 									   AND B.RankPriority <= A.RankPriority                                                                                           
 									   AND B.TransType = A.TransType                                                                                                  
 									   GROUP BY B.CustomerGroupID, B.TransType) > A.MinSBLC                                                                           
 									   AND                                                                                                                            
 									   (SELECT SUM(B.TotalOS)/C.Rate                                                                                                  
 							           FROM #TEMP_STREAT B                                                                                                            
 									   WHERE B.CustomerGroupID = A.CustomerGroupID                                                                                    
 									   AND B.TransType = A.TransType                                                                                                  
 									   AND B.RankPriority < A.RankPriority                                                                                            
 									   GROUP BY B.CustomerGroupID, B.TransType) <=  A.MinSBLC                                                                         
 									THEN A.MinSBLC*C.Rate - (SELECT SUM(B.TotalOS)                                                                                    
 															 FROM #TEMP_STREAT B                                                                                      
 															 WHERE B.CustomerGroupID = A.CustomerGroupID                                                              
 															 AND B.RankPriority < A.RankPriority                                                                      
 															 AND B.TransType = A.TransType                                                                            
 															 GROUP BY B.CustomerGroupID, B.TransType)                                                                 
 								                                                                                                                                      
 								  ELSE CASE WHEN A.RankPriority = 1 THEN A.MinSBLC*C.Rate ELSE 0.0 END                                                                
 							END                                                                                                                                       
 					                                                                                                                                                  
 					  ELSE 0.00 --SCENARIO A                                                                                                                          
 				 END                                                                                                                                                  
 FROM #TEMP_STREAT A                                                                                                                                                  
                                                                                                                                                                      
 LEFT JOIN TrxLLLTempCurrencyScreen C                                                                                                                                 
 ON C.CCY = 'USD' AND C.TransType = 'INTRA';                                                                                                                          
                                                                                                                                                                      
                                                                                                                                                                      
                                                                                                                                                                      
 --UPDATE AVAIBILITY 1                                                                                                                                                
 UPDATE A                                                                                                                                                             
 	SET A.Avaibility = @INDIVIDUALTH + A.SBLC - A.TotalOS,                                                                                                            
 	    A.SisaSBLC = CASE WHEN A.TotalOSGroup > @GROUPTH                                                                                                              
 							THEN A.MaxSBLC * C.Rate - A.TotalSBLCGroup                                                                                                
 						  WHEN A.TotalOSGroup <= @GROUPTH AND A.TotalOSGroup > A.MinSBLC                                                                              
 						    THEN A.MinSBLC * C.Rate - A.TotalSBLCGroup                                                                                                
 						  ELSE 0.00                                                                                                                                   
 					 END                                                                                                                                              
 FROM #TEMP_STREAT A                                                                                                                                                  
                                                                                                                                                                      
 LEFT JOIN TrxLLLTempCurrencyScreen C                                                                                                                                 
 ON C.CCY = 'USD' AND C.TransType = 'INTRA';                                                                                                                          
                                                                                                                                                                      
                                                                                                                                                                      
                                                                                                                                                                      
                                                                                                                                                                      
 --CHANGE RANKPRIORITY BERDASARKAN AVAIBILITY DAN UPDATE TOTAL ADDITIONAL AVAIBILITY                                                                                  
 UPDATE A                                                                                                                                                             
 	SET A.RankPriority = B.Ranking                                                                                                                                    
 FROM #TEMP_STREAT A                                                                                                                                                  
 LEFT JOIN                                                                                                                                                            
 (                                                                                                                                                                    
 	SELECT B.CustomerNo,                                                                                                                                              
 	       ROW_NUMBER() OVER(PARTITION BY B.CustomerGroupID, B.TransType ORDER BY B.Avaibility) Ranking,                                                              
 		   B.Avaibility,                                                                                                                                              
 		   B.CustomerGroupID,                                                                                                                                         
 		   B.TransType                                                                                                                                                
 	FROM #TEMP_STREAT B                                                                                                                                               
 	WHERE B.Avaibility < 0                                                                                                                                            
 )B                                                                                                                                                                   
 ON A.CustomerNo = B.CustomerNo                                                                                                                                       
 AND A.CustomerGroupID = B.CustomerGroupID                                                                                                                            
 AND A.TransType = B.TransType                                                                                                                                        
                                                                                                                                                                      
                                                                                                                                                                      
                                                                                                                                                                      
                                                                                                                                                                      
 --UPDATE INDIVIDUAL SBLC UNTUK YANG EXCESS SECARA PRIBADI                                                                                                            
 WHILE (SELECT TOP 1 A.Avaibility FROM #TEMP_STREAT A WHERE A.Avaibility < 0 AND A.SisaSBLC > 0) < 0                                                                  
 	BEGIN                                                                                                                                                             
 		                                                                                                                                                              
                                                                                                                                                                      
 		UPDATE A                                                                                                                                                      
 		SET A.SBLC = A.SBLC + CASE WHEN A.SisaSBLC - ABS(A.Avaibility) > 0                                                                                            
 									THEN ABS(A.Avaibility)                                                                                                            
 								   ELSE A.SisaSBLC                                                                                                                    
 							  END,                                                                                                                                    
 			A.Avaibility = @INDIVIDUALTH + A.SBLC + CASE WHEN A.SisaSBLC - ABS(A.Avaibility) > 0                                                                      
 															THEN ABS(A.Avaibility)                                                                                    
 														   ELSE A.SisaSBLC                                                                                            
 													 END                                                                                                              
 												  - A.TotalOS,                                                                                                        
 		    A.SisaSBLC = CASE WHEN A.SisaSBLC - ABS(A.Avaibility) > 0                                                                                                 
 							    THEN A.SisaSBLC - ABS(A.Avaibility)                                                                                                   
 							  ELSE 0                                                                                                                                  
 						 END                                                                                                                                          
 		FROM #TEMP_STREAT A                                                                                                                                           
 		WHERE A.RankPriority = 1;                                                                                                                                     
                                                                                                                                                                      
                                                                                                                                                                      
 		UPDATE A                                                                                                                                                      
 			SET A.RankPriority = B.Ranking,                                                                                                                           
 			    A.SisaSBLC = C.SisaSBLC                                                                                                                               
 		FROM #TEMP_STREAT A                                                                                                                                           
 		LEFT JOIN                                                                                                                                                     
 		(                                                                                                                                                             
 			SELECT B.CustomerNo,                                                                                                                                      
 				   ROW_NUMBER() OVER(PARTITION BY B.CustomerGroupID, B.TransType ORDER BY B.Avaibility) Ranking,                                                      
 				   B.Avaibility,                                                                                                                                      
 				   B.CustomerGroupID,                                                                                                                                 
 				   B.TransType                                                                                                                                        
 			FROM #TEMP_STREAT B                                                                                                                                       
 			WHERE B.Avaibility < 0                                                                                                                                    
 		)B                                                                                                                                                            
 		ON A.CustomerNo = B.CustomerNo AND A.CustomerGroupID = B.CustomerGroupID                                                                                      
 		AND A.TransType = B.TransType                                                                                                                                 
                                                                                                                                                                      
 		LEFT JOIN #TEMP_STREAT C                                                                                                                                      
 		ON C.RankPriority = 1 AND A.CustomerGroupID = C.CustomerGroupID                                                                                               
 		AND A.TransType = C.TransType                                                                                                                                 
                                                                                                                                                                      
                                                                                                                                                                      
 	END                                                                                                                                                               
                                                                                                                                                                      
                                                                                                                                                                      
                                                                                                                                                                      
 --UPDATE AVAIBILITY 2                                                                                                                                                
 UPDATE A                                                                                                                                                             
 	SET A.Avaibility = @INDIVIDUALTH + A.SBLC - A.TotalOS                                                                                                             
 FROM #TEMP_STREAT A                                                                                                                                                  
                                                                                                                                                                      
                                                                                                                                                                      
                                                                                                                                                                      
 --UPDATE KE - DETAIL                                                                                                                                                 
 UPDATE A                                                                                                                                                             
 	SET A.CCY1 = 'IDR',                                                                                                                                               
 	    A.Amount = B.SBLC,                                                                                                                                            
 		A.OriginalAmount1 = B.SBLC,                                                                                                                                   
 		A.AgreementNo = 'Special Arrangement'                                                                                                                         
 FROM TrxLLLSBLCBG A                                                                                                                                                  
                                                                                                                                                                      
 INNER JOIN #TEMP_STREAT B                                                                                                                                            
 ON A.CustomerID = B.CustomerNo                                                                                                                                       
 AND A.TransType = B.TransType                                                                                                                                        
                                                                                                                                                                      
 WHERE A.Tanggal = DAY(@CURRENT) AND                                                                                                                                  
       A.Bulan = MONTH(@CURRENT) AND                                                                                                                                  
 	  A.Tahun = YEAR(@CURRENT)  AND                                                                                                                                   
 	  A.TransType IN ('VALUE', 'TRANS');                                                                                                                              
                                                                                                                                                                      
                                                                                                                                                                      
 --INSERT KE - DETAIL                                                                                                                                                 
 INSERT INTO TrxLLLSBLCBG ( Tanggal, Bulan, Tahun, TransType, CustomerID, GuaranteeID,                                                                                
                            CANumber, AgreementNo, TypeTXN, Amount, CCY1, CCY2, CCY3,                                                                                 
 	                       OriginalAmount1, OriginalAmount2, OriginalAmount3)                                                                                         
 SELECT DAY(@CURRENT), MONTH(@CURRENT), YEAR(@CURRENT), A.TransType,                                                                                                  
        A.CustomerNo, '000000' GuaranteeID, 'IN0150490' CANumber,                                                                                                     
 	   'SPECIAL ARRANGEMENT', '' TypeTXN, A.SBLC*1000000 Amount,                                                                                                      
 	   'IDR' CCY1, NULL CCY2, NULL CCY3,                                                                                                                              
 	   A.SBLC*1000000 OriginalAmount1, NULL OriginalAmount2,                                                                                                          
 	   NULL OriginalAmount3                                                                                                                                           
 FROM #TEMP_STREAT A                                                                                                                                                  
                                                                                                                                                                      
 LEFT JOIN TrxLLLSBLCBG B                                                                                                                                             
 ON B.Tanggal = DAY(@CURRENT)                                                                                                                                         
 AND B.Bulan = MONTH(@CURRENT)                                                                                                                                        
 AND B.Tahun = YEAR(@CURRENT)                                                                                                                                         
 AND A.CustomerNo = B.CustomerID                                                                                                                                      
 AND A.TransType = B.TransType                                                                                                                                        
                                                                                                                                                                      
 WHERE B.CustomerID IS NULL                                                                                                                                           
                                                                                                                                                                      
                                                                                                                                                                      
                                                                                                                                                                      
 --UPDATE KE - OUTSTANDING UTAMA                                                                                                                                      
 UPDATE A                                                                                                                                                             
 	SET A.SBLCBG = B.SBLC                                                                                                                                             
 FROM TrxLLLOutstanding A                                                                                                                                             
                                                                                                                                                                      
 INNER JOIN #TEMP_STREAT B                                                                                                                                            
 ON A.CustomerNo = B.CustomerNo                                                                                                                                       
 AND A.TransType = B.TransType                                                                                                                                        
                                                                                                                                                                      
 WHERE A.Tanggal = DAY(@CURRENT) AND                                                                                                                                  
       A.Bulan = MONTH(@CURRENT) AND                                                                                                                                  
 	  A.Tahun = YEAR(@CURRENT)  AND                                                                                                                                   
 	  A.TransType IN ('TRANS', 'VALUE');                                                                                                                              
                                                                                                                                                                      
                                                                                                                                                                      
                                                                                                                                                                      
 -------------------------------------------------------SCREEN - DETAIL GROUPING ORDER BY AVAIBILITY                                                                  
                                                                                                                                                                      
 --(1) INDIVIDUAL                                                                                                                                                     
 SELECT A.CustomerNo,                                                                                                                                                 
        A.TransType,                                                                                                                                                  
        'Individu' JenisOS,                                                                                                                                           
        A.TotalOS TOTALOS,                                                                                                                                            
 	   @INDIVIDUALTH Threshold,                                                                                                                                       
 	   @INDIVIDUALTH - ISNULL(A.TotalOS,0) EXCESS,                                                                                                                    
 	   ISNULL(A.SBLCLN,0) + ISNULL(A.SBLCBG,0) + ISNULL(A.PLEDGETD,0) JAMINAN,                                                                                        
 	   @INDIVIDUALTH - ISNULL(A.TotalOS,0) + ISNULL(A.SBLCLN,0) + ISNULL(A.SBLCBG,0) + ISNULL(A.PLEDGETD,0) AVAIBILITY                                                
 INTO #TEMP_INDIVIDUALOS_IN                                                                                                                                           
 FROM TrxLLLOutstanding A                                                                                                                                             
                                                                                                                                                                      
 LEFT JOIN [ERPLIVE].[BMIERP].dbo.MasterCustomer B                                                                                                           
 ON A.CustomerNo = B.CustomerID                                                                                                                                       
                                                                                                                                                                      
 WHERE ISNULL(B.IsSOE, '') <> 'Y'                                                                                                                                     
   AND ISNULL(B.IsRelatedParty, '') <> 'Y'                                                                                                                            
   AND Tanggal = DAY(@CURRENT) AND                                                                                                                                    
       Bulan = MONTH(@CURRENT) AND                                                                                                                                    
 	  Tahun = YEAR(@CURRENT)  AND                                                                                                                                     
 	  TransType IN ('TRANS', 'VALUE');                                                                                                                                
                                                                                                                                                                      
                                                                                                                                                                      
                                                                                                                                                                      
 --(2) GROUP-OPEN, INNER JOIN SUPAYA YANG GA PUNYA GROUP GA USAH DISUM                                                                                                
 SELECT A.CustomerID,                                                                                                                                                 
        B.TransType,                                                                                                                                                  
        B.CustomerGroupID,                                                                                                                                            
        B.JenisOS,                                                                                                                                                    
 	   B.TOTALOS,                                                                                                                                                     
 	   B.Threshold,                                                                                                                                                   
 	   B.EXCESS,                                                                                                                                                      
 	   B.JAMINAN,                                                                                                                                                     
 	   B.AVAIBILITY                                                                                                                                                   
 INTO #TEMP_GROUPOS_IN                                                                                                                                                
 FROM #TEMP_CUSTGROUP A                                                                                                                                               
 INNER JOIN                                                                                                                                                           
 (                                                                                                                                                                    
 	SELECT  B.CustomerGroupID,                                                                                                                                        
 	        A.TransType,                                                                                                                                              
 			'Grup' JenisOS,                                                                                                                                           
 			SUM(A.TotalOS) TOTALOS,                                                                                                                                   
 			@GROUPTH Threshold,                                                                                                                                       
 			@GROUPTH - ISNULL(SUM(A.TotalOS),0) EXCESS,                                                                                                               
 			SUM(ISNULL(A.SBLCLN,0)) + SUM(ISNULL(A.SBLCBG,0)) + SUM(ISNULL(A.PLEDGETD,0)) JAMINAN,                                                                    
 			@GROUPTH - ISNULL(SUM(A.TotalOS),0) + ISNULL(SUM(A.SBLCLN),0) +                                                                                           
 			           ISNULL(SUM(A.SBLCBG),0) + ISNULL(SUM(A.PLEDGETD),0) AVAIBILITY                                                                                 
 	FROM TrxLLLOutstanding A                                                                                                                                          
                                                                                                                                                                      
 	INNER JOIN #TEMP_CUSTGROUP B                                                                                                                                      
 	ON A.CustomerNo = B.CustomerID                                                                                                                                    
                                                                                                                                                                      
 	WHERE A.TransType IN ('TRANS', 'VALUE')                                                                                                                           
 	AND A.Tahun = YEAR(@CURRENT)                                                                                                                                      
 	AND A.Bulan = MONTH(@CURRENT)                                                                                                                                     
 	AND A.Tanggal =  DAY(@CURRENT)                                                                                                                                    
 	GROUP BY B.CustomerGroupID, A.TransType                                                                                                                           
 )B                                                                                                                                                                   
 ON A.CustomerGroupID = B.CustomerGroupID                                                                                                                             
                                                                                                                                                                      
 WHERE ISNULL(A.CustomerGroupID, '') <> ''                                                                                                                            
 AND  ISNULL(A.IsSOE, '') <> 'Y'                                                                                                                                      
 AND ISNULL(A.IsRelatedParty, '') <> 'Y';                                                                                                                             
                                                                                                                                                                      
                                                                                                                                                                      
                                                                                                                                                                      
 --(3) SOE                                                                                                                                                            
 SELECT A.CustomerNo,                                                                                                                                                 
        A.TransType,                                                                                                                                                  
        'State of Enterprise' JenisOS,                                                                                                                                
        A.TotalOS TOTALOS,                                                                                                                                            
 	   @SOETH Threshold,                                                                                                                                              
 	   @SOETH - ISNULL(A.TotalOS,0) EXCESS,                                                                                                                           
 	   ISNULL(A.SBLCLN,0) + ISNULL(A.SBLCBG,0) + ISNULL(A.PLEDGETD,0) JAMINAN,                                                                                        
 	   @SOETH - ISNULL(A.TotalOS,0) + ISNULL(A.SBLCLN,0) + ISNULL(A.SBLCBG,0) + ISNULL(A.PLEDGETD,0) AVAIBILITY                                                       
 INTO #TEMP_SOEOS_IN                                                                                                                                                  
 FROM TrxLLLOutstanding A                                                                                                                                             
                                                                                                                                                                      
 LEFT JOIN [ERPLIVE].[BMIERP].dbo.MasterCustomer B                                                                                                           
 ON A.CustomerNo = B.CustomerID                                                                                                                                       
                                                                                                                                                                      
 WHERE A.TransType IN ('TRANS', 'VALUE')                                                                                                                              
 AND ISNULL(B.IsSOE, '') = 'Y'                                                                                                                                        
 AND A.Tahun = YEAR(@CURRENT)                                                                                                                                         
 AND A.Bulan = MONTH(@CURRENT)                                                                                                                                        
 AND A.Tanggal =  DAY(@CURRENT)                                                                                                                                       
                                                                                                                                                                      
                                                                                                                                                                      
                                                                                                                                                                      
 --(4) RELATED PARTY -GROUP                                                                                                                                           
 SELECT A.CustomerID CustomerNo,                                                                                                                                      
        B.TransType,                                                                                                                                                  
        B.JenisOS,                                                                                                                                                    
 	   B.TOTALOS,                                                                                                                                                     
 	   B.Threshold,                                                                                                                                                   
 	   B.EXCESS,                                                                                                                                                      
 	   B.JAMINAN,                                                                                                                                                     
 	   B.AVAIBILITY                                                                                                                                                   
 INTO #TEMP_RPOS_GROUP_IN                                                                                                                                             
 FROM [ERPLIVE].[BMIERP].dbo.MasterCustomer A                                                                                                                
 LEFT JOIN                                                                                                                                                            
 (                                                                                                                                                                    
 	SELECT  'Related Party Group' JenisOS,                                                                                                                            
 	        A.TransType,                                                                                                                                              
 			SUM(A.TotalOS) TOTALOS,                                                                                                                                   
 			@RPTH Threshold,                                                                                                                                          
 			@RPTH - ISNULL(SUM(A.TotalOS),0) EXCESS,                                                                                                                  
 			SUM(ISNULL(A.JaminanPlacement,0)) + SUM(ISNULL(A.SBLCLN,0)) + SUM(ISNULL(A.SBLCBG,0)) + SUM(ISNULL(A.PLEDGETD,0)) JAMINAN,                                
 			@RPTH - SUM(ISNULL(A.TotalOS,0)) + SUM(ISNULL(A.JaminanPlacement,0)) +                                                                                    
 			        SUM(ISNULL(A.SBLCLN,0)) + SUM(ISNULL(A.SBLCBG,0)) + SUM(ISNULL(A.PLEDGETD,0)) AVAIBILITY                                                          
 	FROM TrxLLLOutstanding A                                                                                                                                          
                                                                                                                                                                      
 	INNER JOIN #TEMP_CUSTGROUP B                                                                                                                                      
 	ON A.CustomerNo = B.CustomerID                                                                                                                                    
                                                                                                                                                                      
 	WHERE B.IsRelatedParty = 'Y'                                                                                                                                      
 	AND Tanggal = DAY(@CURRENT) AND                                                                                                                                   
       Bulan = MONTH(@CURRENT) AND                                                                                                                                    
 	  Tahun = YEAR(@CURRENT)  AND                                                                                                                                     
 	  TransType IN ('TRANS', 'VALUE')                                                                                                                                 
                                                                                                                                                                      
 	GROUP BY B.IsRelatedParty, A.TransType                                                                                                                            
 )B                                                                                                                                                                   
 ON 1=1                                                                                                                                                               
 WHERE A.IsRelatedParty = 'Y'                                                                                                                                         
                                                                                                                                                                      
                                                                                                                                                                      
                                                                                                                                                                      
 --(5) INDIVIDUAL(RELATED PARTY)                                                                                                                                      
 SELECT A.CustomerNo,                                                                                                                                                 
        A.TransType,                                                                                                                                                  
        'Related Party Individu' JenisOS,                                                                                                                             
        A.TotalOS TOTALOS,                                                                                                                                            
 	   @RPTH Threshold,                                                                                                                                               
 	   @RPTH - ISNULL(A.TotalOS,0) EXCESS,                                                                                                                            
 	   ISNULL(A.JaminanPlacement,0) + ISNULL(A.SBLCLN,0) + ISNULL(A.SBLCBG,0) + ISNULL(A.PLEDGETD,0) JAMINAN,                                                         
 	   @RPTH - ISNULL(A.TotalOS,0) + ISNULL(A.JaminanPlacement,0) + ISNULL(A.SBLCLN,0) +                                                                              
 	           ISNULL(A.SBLCBG,0) + ISNULL(A.PLEDGETD,0) AVAIBILITY                                                                                                   
 INTO #TEMP_RPOS_INDIVIDU_IN                                                                                                                                          
 FROM TrxLLLOutstanding A                                                                                                                                             
                                                                                                                                                                      
 LEFT JOIN [ERPLIVE].[BMIERP].dbo.MasterCustomer B                                                                                                           
 ON A.CustomerNo = B.CustomerID                                                                                                                                       
                                                                                                                                                                      
 WHERE B.IsRelatedParty = 'Y'                                                                                                                                         
 AND Tanggal = DAY(@CURRENT) AND                                                                                                                                      
     Bulan = MONTH(@CURRENT) AND                                                                                                                                      
 	Tahun = YEAR(@CURRENT)  AND                                                                                                                                       
 	TransType IN ('TRANS', 'VALUE')                                                                                                                                   
                                                                                                                                                                      
                                                                                                                                                                      
                                                                                                                                                                      
 --ClEAR DATA                                                                                                                                                         
 DELETE TrxLLLAvaibilityDetailScreen                                                                                                                                  
 WHERE TransType IN ('TRANS', 'VALUE')                                                                                                                                
                                                                                                                                                                      
                                                                                                                                                                      
                                                                                                                                                                      
 --GROUPING ALL                                                                                                                                                       
 INSERT INTO TrxLLLAvaibilityDetailScreen(TransType, CustomerID, CustomerName,                                                                                        
                                          CustomerGroupID, CustomerGroupName,                                                                                         
                                          JenisOS, TotalOS, Threshold, Excess, Jaminan,                                                                               
 										 Avaibility, RankPriority)                                                                                                    
 SELECT  A.TransType,                                                                                                                                                 
         A.CustomerID,                                                                                                                                                
         B.BBCNA1,                                                                                                                                                    
 		A.CustomerGroupID,                                                                                                                                            
 		C.CustomerGroupName,                                                                                                                                          
 		A.JenisOS,                                                                                                                                                    
 		A.TOTALOS,                                                                                                                                                    
 		A.Threshold,                                                                                                                                                  
 		A.EXCESS,                                                                                                                                                     
 		A.JAMINAN,                                                                                                                                                    
 		A.AVAIBILITY,                                                                                                                                                 
 		RANK() OVER(PARTITION BY A.CustomerID, A.TransType ORDER BY AVAIBILITY)                                                                                       
 FROM                                                                                                                                                                 
 (                                                                                                                                                                    
 	SELECT A.CustomerNo CustomerID,                                                                                                                                   
 		   NULL CustomerGroupID,                                                                                                                                      
 		   A.TransType,                                                                                                                                               
 		   A.JenisOS,                                                                                                                                                 
 		   A.TOTALOS,                                                                                                                                                 
 		   A.Threshold,                                                                                                                                               
 		   A.EXCESS,                                                                                                                                                  
 		   A.JAMINAN,                                                                                                                                                 
 		   A.AVAIBILITY                                                                                                                                               
 	FROM #TEMP_INDIVIDUALOS_IN A                                                                                                                                      
                                                                                                                                                                      
 	UNION ALL                                                                                                                                                         
                                                                                                                                                                      
 	SELECT A.CustomerID,                                                                                                                                              
 		   A.CustomerGroupID,                                                                                                                                         
 		   A.TransType,                                                                                                                                               
 		   A.JenisOS,                                                                                                                                                 
 		   A.TOTALOS,                                                                                                                                                 
 		   A.Threshold,                                                                                                                                               
 		   A.EXCESS,                                                                                                                                                  
 		   A.JAMINAN,                                                                                                                                                 
 		   A.AVAIBILITY                                                                                                                                               
 	FROM #TEMP_GROUPOS_IN A                                                                                                                                           
                                                                                                                                                                      
 	UNION ALL                                                                                                                                                         
                                                                                                                                                                      
 	SELECT A.CustomerNo,                                                                                                                                              
 		   NULL CustomerGroupID,                                                                                                                                      
 		   A.TransType,                                                                                                                                               
 		   A.JenisOS,                                                                                                                                                 
 		   A.TOTALOS,                                                                                                                                                 
 		   A.Threshold,                                                                                                                                               
 		   A.EXCESS,                                                                                                                                                  
 		   A.JAMINAN,                                                                                                                                                 
 		   A.AVAIBILITY                                                                                                                                               
 	FROM #TEMP_SOEOS_IN A                                                                                                                                             
                                                                                                                                                                      
 	UNION ALL                                                                                                                                                         
                                                                                                                                                                      
 	SELECT A.CustomerNo,                                                                                                                                              
 		   NULL CustomerGroupID,                                                                                                                                      
 		   A.TransType,                                                                                                                                               
 		   A.JenisOS,                                                                                                                                                 
 		   A.TOTALOS,                                                                                                                                                 
 		   A.Threshold,                                                                                                                                               
 		   A.EXCESS,                                                                                                                                                  
 		   A.JAMINAN,                                                                                                                                                 
 		   A.AVAIBILITY                                                                                                                                               
 	FROM #TEMP_RPOS_GROUP_IN A                                                                                                                                        
                                                                                                                                                                      
 	UNION ALL                                                                                                                                                         
                                                                                                                                                                      
 	SELECT A.CustomerNo,                                                                                                                                              
 		   NULL CustomerGroupID,                                                                                                                                      
 		   A.TransType,                                                                                                                                               
 		   A.JenisOS,                                                                                                                                                 
 		   A.TOTALOS,                                                                                                                                                 
 		   A.Threshold,                                                                                                                                               
 		   A.EXCESS,                                                                                                                                                  
 		   A.JAMINAN,                                                                                                                                                 
 		   A.AVAIBILITY                                                                                                                                               
 	FROM #TEMP_RPOS_INDIVIDU_IN A                                                                                                                                     
 )A                                                                                                                                                                   
                                                                                                                                                                      
 LEFT JOIN #TEMP_CUST B                                                                                                                                               
 ON A.CustomerID = B.BBCUST                                                                                                                                           
                                                                                                                                                                      
 LEFT JOIN [ERPLIVE].[BMIERP].dbo.MasterCustomerGroup C                                                                                                      
 ON A.CustomerGroupID = C.CustomerGroupID                                                                                                                             
                                                                                                                                                                      
 ORDER BY A.CustomerID                                                                                                                                                
                                                                                                                                                                      
                                                                                                                                                                      
 -------------------------------------------------------SCREEN - PLAIN GROUP                                                                                          
                                                                                                                                                                      
                                                                                                                                                                      
 --CLEAR DATA SCREEN                                                                                                                                                  
 DELETE TrxLLLOutstandingScreen                                                                                                                                       
                                                                                                                                                                      
                                                                                                                                                                      
                                                                                                                                                                      
 --TOP 'DATEGENERATE'                                                                                                                                                 
 SELECT TOP 1 @DATEGENERATE = DateGenerate                                                                                                                            
 FROM TrxLLLOutstanding A                                                                                                                                             
 WHERE Tanggal = DAY(@CURRENT) AND                                                                                                                                    
       Bulan = MONTH(@CURRENT) AND                                                                                                                                    
 	  Tahun = YEAR(@CURRENT)                                                                                                                                          
 ORDER BY DateGenerate DESC                                                                                                                                           
                                                                                                                                                                      
                                                                                                                                                                      
                                                                                                                                                                      
 --OPEN                                                                                                                                                               
 SELECT  B.CustomerGroupID,                                                                                                                                           
         C.CustomerGroupName,                                                                                                                                         
 		SUM(A.LN) LN,                                                                                                                                                 
 	    SUM(A.BG) BG,                                                                                                                                                 
 	    SUM(A.LC) LC,                                                                                                                                                 
 	    SUM(A.Interbank) INTERBANK,                                                                                                                                   
 	    SUM(A.Forex) FOREX,                                                                                                                                           
 	    SUM(A.MTM) MTM,                                                                                                                                               
 	    SUM(A.DerivativeCCS) DRTVCCS,                                                                                                                                 
 	    SUM(A.DerivativeIRS) DRTVIRS,                                                                                                                                 
 	    SUM(A.TotalDerivative) TOTDRTV,                                                                                                                               
 	    SUM(A.TotalOS) TOTALOS,                                                                                                                                       
 		SUM(A.JaminanPlacement) JAMINANPLACEMENT,                                                                                                                     
 	    SUM(A.SBLCLN) SBLCLN,                                                                                                                                         
 	    SUM(A.SBLCBG) SBLCBG,                                                                                                                                         
 	    SUM(A.PLEDGETD) PLEDGETD,                                                                                                                                     
 	    @GROUPTH - ISNULL(SUM(A.TotalOS),0) + ISNULL(SUM(A.JaminanPlacement),0) +                                                                                     
 		           ISNULL(SUM(A.SBLCLN),0) + ISNULL(SUM(A.SBLCBG),0) + ISNULL(SUM(A.PLEDGETD),0) AVAIBILITY                                                           
                                                                                                                                                                      
 INTO #TEMP_PLAINGROUP_OP                                                                                                                                             
 FROM TrxLLLOutstanding A                                                                                                                                             
                                                                                                                                                                      
 LEFT JOIN #TEMP_CUSTGROUP B                                                                                                                                          
 ON A.CustomerNo = B.CustomerID                                                                                                                                       
                                                                                                                                                                      
 LEFT JOIN [ERPLIVE].[BMIERP].dbo.MasterCustomerGroup C                                                                                                      
 ON B.CustomerGroupID = C.CustomerGroupID                                                                                                                             
                                                                                                                                                                      
 WHERE A.TransType = 'OPEN'                                                                                                                                           
 AND ISNULL(B.CustomerGroupID, '') <> ''                                                                                                                              
 AND A.Tahun = YEAR(@CURRENT)                                                                                                                                         
 AND A.Bulan = MONTH(@CURRENT)                                                                                                                                        
 AND A.Tanggal = DAY(@CURRENT)                                                                                                                                        
                                                                                                                                                                      
 GROUP BY B.CustomerGroupID, C.CustomerGroupName                                                                                                                      
                                                                                                                                                                      
                                                                                                                                                                      
                                                                                                                                                                      
 --INTRA                                                                                                                                                              
 SELECT  B.CustomerGroupID,                                                                                                                                           
         C.CustomerGroupName,                                                                                                                                         
 		A.TransType,                                                                                                                                                  
 		SUM(A.LN) LN,                                                                                                                                                 
 	    SUM(A.BG) BG,                                                                                                                                                 
 	    SUM(A.LC) LC,                                                                                                                                                 
 	    SUM(A.Interbank) INTERBANK,                                                                                                                                   
 	    SUM(A.Forex) FOREX,                                                                                                                                           
 	    SUM(A.MTM) MTM,                                                                                                                                               
 	    SUM(A.DerivativeCCS) DRTVCCS,                                                                                                                                 
 	    SUM(A.DerivativeIRS) DRTVIRS,                                                                                                                                 
 	    SUM(A.TotalDerivative) TOTDRTV,                                                                                                                               
 	    SUM(A.TotalOS) TOTALOS,                                                                                                                                       
 		SUM(A.JaminanPlacement) JAMINANPLACEMENT,                                                                                                                     
 	    SUM(A.SBLCLN) SBLCLN,                                                                                                                                         
 	    SUM(A.SBLCBG) SBLCBG,                                                                                                                                         
 	    SUM(A.PLEDGETD) PLEDGETD,                                                                                                                                     
 	    @GROUPTH - ISNULL(SUM(A.TotalOS),0) + ISNULL(SUM(A.JaminanPlacement),0) +                                                                                     
 		           ISNULL(SUM(A.SBLCLN),0) + ISNULL(SUM(A.SBLCBG),0) + ISNULL(SUM(A.PLEDGETD),0) AVAIBILITY                                                           
                                                                                                                                                                      
 INTO #TEMP_PLAINGROUP_IN                                                                                                                                             
 FROM TrxLLLOutstanding A                                                                                                                                             
                                                                                                                                                                      
 LEFT JOIN #TEMP_CUSTGROUP B                                                                                                                                          
 ON A.CustomerNo = B.CustomerID                                                                                                                                       
                                                                                                                                                                      
 LEFT JOIN [ERPLIVE].[BMIERP].dbo.MasterCustomerGroup C                                                                                                      
 ON B.CustomerGroupID = C.CustomerGroupID                                                                                                                             
                                                                                                                                                                      
 WHERE A.TransType IN ('TRANS', 'VALUE')                                                                                                                              
 AND ISNULL(B.CustomerGroupID, '') <> ''                                                                                                                              
 AND A.Tahun = YEAR(@CURRENT)                                                                                                                                         
 AND A.Bulan = MONTH(@CURRENT)                                                                                                                                        
 AND A.Tanggal = DAY(@CURRENT)                                                                                                                                        
 GROUP BY B.CustomerGroupID, C.CustomerGroupName, TransType;                                                                                                          
                                                                                                                                                                      
                                                                                                                                                                      
                                                                                                                                                                      
 --GET ALL DATA                                                                                                                                                       
 SELECT ISNULL(ISNULL(A.CustomerGroupID, B.CustomerGroupID), C.CustomerGroupID) CustomerGroupID,                                                                      
        ISNULL(ISNULL(A.CustomerGroupName, B.CustomerGroupName), C.CustomerGroupName) CustomerGroupName,                                                              
                                                                                                                                                                      
 	   A.LN OPLN,                                                                                                                                                     
 	   A.BG OPBG,                                                                                                                                                     
 	   A.LC OPLC,                                                                                                                                                     
 	   A.INTERBANK OPINTERBANK,                                                                                                                                       
 	   A.FOREX OPFOREX,                                                                                                                                               
 	   A.MTM OPMTM,                                                                                                                                                   
 	   A.DRTVCCS OPDRTVCCS,                                                                                                                                           
 	   A.DRTVIRS OPDRTVIRS,                                                                                                                                           
 	   A.TOTDRTV OPTOTDRTV,                                                                                                                                           
 	   A.TOTALOS OPTOTALOS,                                                                                                                                           
 	   A.JAMINANPLACEMENT OPJAMINANPLACEMENT,                                                                                                                         
 	   A.SBLCLN OPSBLCLN,                                                                                                                                             
 	   A.SBLCBG OPSBLCBG,                                                                                                                                             
 	   A.PLEDGETD OPPLEDGETD,                                                                                                                                         
 	   A.AVAIBILITY OPAVAIBILITY,                                                                                                                                     
                                                                                                                                                                      
 	   B.LN TRLN,                                                                                                                                                     
 	   B.BG TRBG,                                                                                                                                                     
 	   B.LC TRLC,                                                                                                                                                     
 	   B.INTERBANK TRINTERBANK,                                                                                                                                       
 	   B.FOREX TRFOREX,                                                                                                                                               
 	   B.MTM TRMTM,                                                                                                                                                   
 	   B.DRTVCCS TRDRTVCCS,                                                                                                                                           
 	   B.DRTVIRS TRDRTVIRS,                                                                                                                                           
 	   B.TOTDRTV TRTOTDRTV,                                                                                                                                           
 	   B.TOTALOS TRTOTALOS,                                                                                                                                           
 	   B.JAMINANPLACEMENT TRJAMINANPLACEMENT,                                                                                                                         
 	   B.SBLCLN TRSBLCLN,                                                                                                                                             
 	   B.SBLCBG TRSBLCBG,                                                                                                                                             
 	   B.PLEDGETD TRPLEDGETD,                                                                                                                                         
 	   B.AVAIBILITY TRAVAIBILITY,                                                                                                                                     
                                                                                                                                                                      
 	   C.LN VLLN,                                                                                                                                                     
 	   C.BG VLBG,                                                                                                                                                     
 	   C.LC VLLC,                                                                                                                                                     
 	   C.INTERBANK VLINTERBANK,                                                                                                                                       
 	   C.FOREX VLFOREX,                                                                                                                                               
 	   C.MTM VLMTM,                                                                                                                                                   
 	   C.DRTVCCS VLDRTVCCS,                                                                                                                                           
 	   C.DRTVIRS VLDRTVIRS,                                                                                                                                           
 	   C.TOTDRTV VLTOTDRTV,                                                                                                                                           
 	   C.TOTALOS VLTOTALOS,                                                                                                                                           
 	   C.JAMINANPLACEMENT VLJAMINANPLACEMENT,                                                                                                                         
 	   C.SBLCLN VLSBLCLN,                                                                                                                                             
 	   C.SBLCBG VLSBLCBG,                                                                                                                                             
 	   C.PLEDGETD VLPLEDGETD,                                                                                                                                         
 	   C.AVAIBILITY VLAVAIBILITY                                                                                                                                      
 INTO #TEMP_PLAINGROUP_ALL                                                                                                                                            
 FROM #TEMP_PLAINGROUP_OP A                                                                                                                                           
                                                                                                                                                                      
 FULL OUTER JOIN                                                                                                                                                      
 (                                                                                                                                                                    
    SELECT * FROM #TEMP_PLAINGROUP_IN B                                                                                                                               
    WHERE B.TransType = 'TRANS'                                                                                                                                       
 )B                                                                                                                                                                   
 ON A.CustomerGroupID = B.CustomerGroupID                                                                                                                             
                                                                                                                                                                      
                                                                                                                                                                      
 LEFT JOIN                                                                                                                                                            
 (                                                                                                                                                                    
    SELECT * FROM #TEMP_PLAINGROUP_IN B                                                                                                                               
    WHERE B.TransType = 'VALUE'                                                                                                                                       
 )C                                                                                                                                                                   
 ON A.CustomerGroupID = C.CustomerGroupID                                                                                                                             
                                                                                                                                                                      
                                                                                                                                                                      
                                                                                                                                                                      
                                                                                                                                                                      
                                                                                                                                                                      
                                                                                                                                                                      
 --INSERT DATA GROUP                                                                                                                                                  
 INSERT INTO TrxLLLOutstandingScreen                                                                                                                                  
 (DateGenerate, CustomerNo, CustomerName, GroupID1,                                                                                                                   
  OPLN, OPBG, OPLC, OPInterbank, OPForex, OPMTM, OPDerivativeCCS, OPDerivativeIRS, OPTotalDerivative, OPTotalOS, OPThreshold,                                         
  OPJaminanPlacement, OPSBLCLN, OPSBLCBG, OPPLEDGETD, OPAvaibility, OPGeneratedBy, OPDateGenerate,                                                                    
  TRLN, TRBG, TRLC, TRInterbank, TRForex, TRMTM, TRDerivativeCCS, TRDerivativeIRS, TRTotalDerivative, TRTotalOS, TRThreshold,                                         
  TRJaminanPlacement, TRSBLCLN, TRSBLCBG, TRPLEDGETD, TRAvaibility, TRGeneratedBy, TRDateGenerate,                                                                    
  VLLN, VLBG, VLLC, VLInterbank, VLForex, VLMTM, VLDerivativeCCS, VLDerivativeIRS, VLTotalDerivative, VLTotalOS, VLThreshold,                                         
  VLJaminanPlacement, VLSBLCLN, VLSBLCBG, VLPLEDGETD, VLAvaibility, VLGeneratedBy, VLDateGenerate                                                                     
 )                                                                                                                                                                    
 SELECT @DATEGENERATE,                                                                                                                                                
 	   000000,                                                                                                                                                        
 	   A.CustomerGroupName,                                                                                                                                           
 	   A.CustomerGroupID,                                                                                                                                             
 	   A.OPLN,                                                                                                                                                        
 	   A.OPBG,                                                                                                                                                        
 	   A.OPLC,                                                                                                                                                        
 	   A.OPINTERBANK,                                                                                                                                                 
 	   A.OPFOREX,                                                                                                                                                     
 	   A.OPMTM,                                                                                                                                                       
 	   A.OPDRTVCCS,                                                                                                                                                   
 	   A.OPDRTVIRS,                                                                                                                                                   
 	   A.OPTOTDRTV,                                                                                                                                                   
 	   A.OPTOTALOS,                                                                                                                                                   
 	   @GROUPTH,                                                                                                                                                      
 	   A.OPJAMINANPLACEMENT,                                                                                                                                          
 	   A.OPSBLCLN,                                                                                                                                                    
 	   A.OPSBLCBG,                                                                                                                                                    
 	   A.OPPLEDGETD,                                                                                                                                                  
 	   A.OPAVAIBILITY,                                                                                                                                                
 	   'SERVICE',                                                                                                                                                     
 	   GETDATE(),                                                                                                                                                     
                                                                                                                                                                      
 	   A.TRLN,                                                                                                                                                        
 	   A.TRBG,                                                                                                                                                        
 	   A.TRLC,                                                                                                                                                        
 	   A.TRINTERBANK,                                                                                                                                                 
 	   A.TRFOREX,                                                                                                                                                     
 	   A.TRMTM,                                                                                                                                                       
 	   A.TRDRTVCCS,                                                                                                                                                   
 	   A.TRDRTVIRS,                                                                                                                                                   
 	   A.TRTOTDRTV,                                                                                                                                                   
 	   A.TRTOTALOS,                                                                                                                                                   
 	   @GROUPTH,                                                                                                                                                      
 	   A.TRJAMINANPLACEMENT,                                                                                                                                          
 	   A.TRSBLCLN,                                                                                                                                                    
 	   A.TRSBLCBG,                                                                                                                                                    
 	   A.TRPLEDGETD,                                                                                                                                                  
 	   A.TRAVAIBILITY,                                                                                                                                                
 	   'SERVICE',                                                                                                                                                     
 	   GETDATE(),                                                                                                                                                     
                                                                                                                                                                      
 	   A.VLLN,                                                                                                                                                        
 	   A.VLBG,                                                                                                                                                        
 	   A.VLLC,                                                                                                                                                        
 	   A.VLINTERBANK,                                                                                                                                                 
 	   A.VLFOREX,                                                                                                                                                     
 	   A.VLMTM,                                                                                                                                                       
 	   A.VLDRTVCCS,                                                                                                                                                   
 	   A.VLDRTVIRS,                                                                                                                                                   
 	   A.VLTOTDRTV,                                                                                                                                                   
 	   A.VLTOTALOS,                                                                                                                                                   
 	   @GROUPTH,                                                                                                                                                      
 	   A.VLJAMINANPLACEMENT,                                                                                                                                          
 	   A.VLSBLCLN,                                                                                                                                                    
 	   A.VLSBLCBG,                                                                                                                                                    
 	   A.VLPLEDGETD,                                                                                                                                                  
 	   A.VLAVAIBILITY,                                                                                                                                                
 	   'SERVICE',                                                                                                                                                     
 	   GETDATE()                                                                                                                                                      
 FROM #TEMP_PLAINGROUP_ALL A                                                                                                                                          
                                                                                                                                                                      
 -------------------------------------------------------SCREEN - INDIVIDUAL                                                                                           
                                                                                                                                                                      
                                                                                                                                                                      
 --INSERT DATA INDIVIDU                                                                                                                                               
 INSERT INTO TrxLLLOutstandingScreen                                                                                                                                  
 (ErrorIndicatorJoinAvaibility, DateGenerate, CustomerNo, CustomerName, GroupID1, GroupID2,                                                                           
  GroupID3, GroupID4, GroupID5, GroupID6, GroupID7, GroupID8, GroupID9, GroupID10,                                                                                    
  IsSOE, ISRelatedParty,                                                                                                                                              
                                                                                                                                                                      
  OPLN, OPBG, OPLC, OPInterbank, OPForex, OPMTM, OPDerivativeCCS,                                                                                                     
  OPDerivativeIRS, OPTotalDerivative, OPTotalOS, OPThreshold, OPJaminanPlacement, OPSBLCLN,                                                                           
  OPSBLCBG, OPPLEDGETD, OPAvaibility, OPGeneratedBy, OPDateGenerate,                                                                                                  
                                                                                                                                                                      
  TRLN, TRBG, TRLC, TRInterbank, TRForex, TRMTM, TRDerivativeCCS,                                                                                                     
  TRDerivativeIRS, TRTotalDerivative, TRTotalOS, TRThreshold, TRJaminanPlacement, TRSBLCLN,                                                                           
  TRSBLCBG, TRPLEDGETD, TRAvaibility, TRGeneratedBy, TRDateGenerate,                                                                                                  
                                                                                                                                                                      
  VLLN, VLBG, VLLC, VLInterbank, VLForex, VLMTM, VLDerivativeCCS,                                                                                                     
  VLDerivativeIRS, VLTotalDerivative, VLTotalOS, VLThreshold, VLJaminanPlacement, VLSBLCLN,                                                                           
  VLSBLCBG, VLPLEDGETD, VLAvaibility, VLGeneratedBy, VLDateGenerate                                                                                                   
 )                                                                                                                                                                    
 SELECT CASE WHEN F1.Avaibility IS NULL OR F2.Avaibility IS NULL THEN 'ERROR' ELSE NULL END,                                                                          
        @DATEGENERATE,                                                                                                                                                
 	   ISNULL(ISNULL(A.CustomerNo, B1.CustomerNo), B2.CustomerNo) [Cust No],                                                                                          
 	   ISNULL(ISNULL(E1.BBCNA1, E2.BBCNA1), E3.BBCNA1) [Cust Name],                                                                                                   
 	   CASE WHEN LTRIM(RTRIM(G1.CustomerGroupStatus)) = 'D'                                                                                                           
 	           THEN NULL                                                                                                                                              
 			ELSE ISNULL(ISNULL(C1.CustomerGroupID, C2.CustomerGroupID), C3.CustomerGroupID)                                                                           
 	   END GroupID1,                                                                                                                                                  
 	   CASE WHEN LTRIM(RTRIM(G2.CustomerGroupStatus)) = 'D'                                                                                                           
 				THEN NULL                                                                                                                                             
 			ELSE ISNULL(ISNULL(C1.CustomerGroupID2, C2.CustomerGroupID2), C3.CustomerGroupID2)                                                                        
 	   END GroupID2,                                                                                                                                                  
 	   CASE WHEN LTRIM(RTRIM(G3.CustomerGroupStatus)) = 'D'                                                                                                           
 				THEN NULL                                                                                                                                             
 			ELSE ISNULL(ISNULL(C1.CustomerGroupID3, C2.CustomerGroupID3), C3.CustomerGroupID3)                                                                        
 	   END GroupID3,                                                                                                                                                  
 	   CASE WHEN LTRIM(RTRIM(G4.CustomerGroupStatus)) = 'D'                                                                                                           
 				THEN NULL                                                                                                                                             
 			ELSE ISNULL(ISNULL(C1.CustomerGroupID4, C2.CustomerGroupID4), C3.CustomerGroupID4)                                                                        
 	   END GroupID4,                                                                                                                                                  
 	   CASE WHEN LTRIM(RTRIM(G5.CustomerGroupStatus)) = 'D'                                                                                                           
 				THEN NULL                                                                                                                                             
 			ELSE ISNULL(ISNULL(C1.CustomerGroupID5, C2.CustomerGroupID5), C3.CustomerGroupID5)                                                                        
 	   END GroupID5,                                                                                                                                                  
 	   CASE WHEN LTRIM(RTRIM(G6.CustomerGroupStatus)) = 'D'                                                                                                           
 				THEN NULL                                                                                                                                             
 			ELSE ISNULL(ISNULL(C1.CustomerGroupID6, C2.CustomerGroupID6), C3.CustomerGroupID6)                                                                        
 	   END GroupID6,                                                                                                                                                  
 	   CASE WHEN LTRIM(RTRIM(G7.CustomerGroupStatus)) = 'D'                                                                                                           
 				THEN NULL                                                                                                                                             
 			ELSE ISNULL(ISNULL(C1.CustomerGroupID7, C2.CustomerGroupID7), C3.CustomerGroupID7)                                                                        
 	   END GroupID7,                                                                                                                                                  
 	   CASE WHEN LTRIM(RTRIM(G8.CustomerGroupStatus)) = 'D'                                                                                                           
 				THEN NULL                                                                                                                                             
 			ELSE ISNULL(ISNULL(C1.CustomerGroupID8, C2.CustomerGroupID8), C3.CustomerGroupID8)                                                                        
 	   END GroupID8,                                                                                                                                                  
 	   CASE WHEN LTRIM(RTRIM(G9.CustomerGroupStatus)) = 'D'                                                                                                           
 				THEN NULL                                                                                                                                             
 			ELSE ISNULL(ISNULL(C1.CustomerGroupID9, C2.CustomerGroupID9), C3.CustomerGroupID9)                                                                        
 	   END GroupID9,                                                                                                                                                  
 	   CASE WHEN LTRIM(RTRIM(G10.CustomerGroupStatus)) = 'D'                                                                                                          
 				THEN NULL                                                                                                                                             
 			ELSE ISNULL(ISNULL(C1.CustomerGroupID10, C2.CustomerGroupID10), C3.CustomerGroupID10)                                                                     
 	   END GroupID10,                                                                                                                                                 
 	   ISNULL(ISNULL(C1.IsSOE, C2.IsSOE), C3.IsSOE) IsSOE,                                                                                                            
        ISNULL(ISNULL(C1.IsRelatedParty, C2.IsRelatedParty), C3.IsRelatedParty) IsRelatedParty,                                                                       
                                                                                                                                                                      
 	   A.LN [OP LN],                                                                                                                                                  
 	   A.BG [OP BG],                                                                                                                                                  
 	   A.LC [OP LC],                                                                                                                                                  
 	   A.Interbank [OP Interbank],                                                                                                                                    
 	   A.Forex [OP FX],                                                                                                                                               
 	   A.MTM [OP MTM],                                                                                                                                                
 	   A.DerivativeCCS [OP DRTV CCS],                                                                                                                                 
 	   A.DerivativeIRS [OP DRTV IRS],                                                                                                                                 
 	   A.TotalDerivative [OP DRTV],                                                                                                                                   
 	   A.TotalOS [OP Total OS],                                                                                                                                       
 	   F1.Threshold [Threshold], ----THE IMPORTANT FIELD                                                                                                              
 	   A.JaminanPlacement [OP Jaminan Placement],                                                                                                                     
 	   A.SBLCLN [OP SBLCLN],                                                                                                                                          
 	   A.SBLCBG [OP SBLCBG],                                                                                                                                          
 	   A.PLEDGETD [OP PLEDGE TD],                                                                                                                                     
 	   F1.Avaibility [OP Avaibility], ----THE IMPORTANT FIELD                                                                                                         
 	   A.GeneratedBy [OP GeneratedBy],                                                                                                                                
 	   A.DateGenerate [OP GeneratedDate],                                                                                                                             
                                                                                                                                                                      
 	   B1.LN [IN LN],                                                                                                                                                 
 	   B1.BG [IN BG],                                                                                                                                                 
 	   B1.LC [IN LC],                                                                                                                                                 
 	   B1.Interbank [IN Interbank],                                                                                                                                   
 	   B1.Forex [IN FX],                                                                                                                                              
 	   B1.MTM [IN MTM],                                                                                                                                               
 	   B1.DerivativeCCS [IN DRTV CCS],                                                                                                                                
 	   B1.DerivativeIRS [IN DRTV IRS],                                                                                                                                
 	   B1.TotalDerivative [IN DRTV],                                                                                                                                  
 	   B1.TotalOS [IN Total OS],                                                                                                                                      
 	   F2.Threshold [Threshold], ----THE IMPORTANT FIELD                                                                                                              
 	   B1.JaminanPlacement [IN Jaminan Placement],                                                                                                                    
 	   B1.SBLCLN [IN SBLCLN],                                                                                                                                         
 	   B1.SBLCBG [IN SBLCBG],                                                                                                                                         
 	   B1.PLEDGETD [IN PLEDGE TD],                                                                                                                                    
 	   F2.Avaibility [OP Avaibility], ----THE IMPORTANT FIELD                                                                                                         
 	   B2.GeneratedBy [IN GeneratedBy],                                                                                                                               
 	   B2.DateGenerate [IN GeneratedDate],                                                                                                                            
                                                                                                                                                                      
 	   B2.LN [IN LN],                                                                                                                                                 
 	   B2.BG [IN BG],                                                                                                                                                 
 	   B2.LC [IN LC],                                                                                                                                                 
 	   B2.Interbank [IN Interbank],                                                                                                                                   
 	   B2.Forex [IN FX],                                                                                                                                              
 	   B2.MTM [IN MTM],                                                                                                                                               
 	   B2.DerivativeCCS [IN DRTV CCS],                                                                                                                                
 	   B2.DerivativeIRS [IN DRTV IRS],                                                                                                                                
 	   B2.TotalDerivative [IN DRTV],                                                                                                                                  
 	   B2.TotalOS [IN Total OS],                                                                                                                                      
 	   F3.Threshold [Threshold], ----THE IMPORTANT FIELD                                                                                                              
 	   B2.JaminanPlacement [IN Jaminan Placement],                                                                                                                    
 	   B2.SBLCLN [IN SBLCLN],                                                                                                                                         
 	   B2.SBLCBG [IN SBLCBG],                                                                                                                                         
 	   B2.PLEDGETD [IN PLEDGE TD],                                                                                                                                    
 	   F3.Avaibility [OP Avaibility], ----THE IMPORTANT FIELD                                                                                                         
 	   B2.GeneratedBy [IN GeneratedBy],                                                                                                                               
 	   B2.DateGenerate [IN GeneratedDate]                                                                                                                             
                                                                                                                                                                      
 FROM TrxLLLOutstanding A                                                                                                                                             
                                                                                                                                                                      
 FULL OUTER JOIN                                                                                                                                                      
 (                                                                                                                                                                    
 	SELECT * FROM TrxLLLOutstanding B                                                                                                                                 
     WHERE B.TransType = 'TRANS'                                                                                                                                      
 	  AND B.Tahun = YEAR(@CURRENT)                                                                                                                                    
 	  AND B.Bulan =  MONTH(@CURRENT)                                                                                                                                  
 	  AND B.Tanggal = DAY(@CURRENT)                                                                                                                                   
 )B1                                                                                                                                                                  
 ON A.CustomerNo = B1.CustomerNo                                                                                                                                      
                                                                                                                                                                      
 FULL OUTER JOIN                                                                                                                                                      
 (                                                                                                                                                                    
 	SELECT * FROM TrxLLLOutstanding B                                                                                                                                 
     WHERE B.TransType = 'VALUE'                                                                                                                                      
 	  AND B.Tahun = YEAR(@CURRENT)                                                                                                                                    
 	  AND B.Bulan =  MONTH(@CURRENT)                                                                                                                                  
 	  AND B.Tanggal = DAY(@CURRENT)                                                                                                                                   
 )B2                                                                                                                                                                  
 ON A.CustomerNo = B2.CustomerNo                                                                                                                                      
                                                                                                                                                                      
 LEFT JOIN [ERPLIVE].[BMIERP].dbo.MasterCustomer C1                                                                                                          
 ON A.CustomerNo = C1.CustomerID                                                                                                                                      
                                                                                                                                                                      
 LEFT JOIN [ERPLIVE].[BMIERP].dbo.MasterCustomer C2                                                                                                          
 ON B1.CustomerNo = C2.CustomerID                                                                                                                                     
                                                                                                                                                                      
 LEFT JOIN [ERPLIVE].[BMIERP].dbo.MasterCustomer C3                                                                                                          
 ON B2.CustomerNo = C3.CustomerID                                                                                                                                     
                                                                                                                                                                      
 LEFT JOIN #TEMP_CUST E1                                                                                                                                              
 ON A.CustomerNo = E1.BBCUST COLLATE SQL_Latin1_General_CP1_CI_AS                                                                                                     
                                                                                                                                                                      
 LEFT JOIN #TEMP_CUST E2                                                                                                                                              
 ON B1.CustomerNo = E2.BBCUST COLLATE SQL_Latin1_General_CP1_CI_AS                                                                                                    
                                                                                                                                                                      
 LEFT JOIN #TEMP_CUST E3                                                                                                                                              
 ON B2.CustomerNo = E3.BBCUST COLLATE SQL_Latin1_General_CP1_CI_AS                                                                                                    
                                                                                                                                                                      
 LEFT JOIN TrxLLLAvaibilityDetailScreen F1                                                                                                                            
 ON A.CustomerNo = F1.CustomerID AND F1.RankPriority = 1 AND F1.TransType IN ('OPEN')                                                                                 
                                                                                                                                                                      
 LEFT JOIN TrxLLLAvaibilityDetailScreen F2                                                                                                                            
 ON B1.CustomerNo = F2.CustomerID AND F2.RankPriority = 1 AND F2.TransType IN ('TRANS')                                                                               
                                                                                                                                                                      
 LEFT JOIN TrxLLLAvaibilityDetailScreen F3                                                                                                                            
 ON B2.CustomerNo = F3.CustomerID AND F3.RankPriority = 1 AND F3.TransType IN ('VALUE')                                                                               
                                                                                                                                                                      
 LEFT JOIN [ERPLIVE].[BMIERP].dbo.MasterCustomerGroup G1                                                                                                     
 ON ISNULL(ISNULL(C1.CustomerGroupID, C2.CustomerGroupID), C3.CustomerGroupID) = G1.CustomerGroupID--UTK 'TR'&'VL' SAMA                                               
                                                                                                                                                                      
 LEFT JOIN [ERPLIVE].[BMIERP].dbo.MasterCustomerGroup G2                                                                                                     
 ON ISNULL(ISNULL(C1.CustomerGroupID2, C2.CustomerGroupID2), C3.CustomerGroupID2) = G2.CustomerGroupID                                                                
                                                                                                                                                                      
 LEFT JOIN [ERPLIVE].[BMIERP].dbo.MasterCustomerGroup G3                                                                                                     
 ON ISNULL(ISNULL(C1.CustomerGroupID3, C2.CustomerGroupID3), C3.CustomerGroupID3) = G3.CustomerGroupID                                                                
                                                                                                                                                                      
 LEFT JOIN [ERPLIVE].[BMIERP].dbo.MasterCustomerGroup G4                                                                                                     
 ON ISNULL(ISNULL(C1.CustomerGroupID4, C2.CustomerGroupID4), C3.CustomerGroupID4) = G4.CustomerGroupID                                                                
                                                                                                                                                                      
 LEFT JOIN [ERPLIVE].[BMIERP].dbo.MasterCustomerGroup G5                                                                                                     
 ON ISNULL(ISNULL(C1.CustomerGroupID5, C2.CustomerGroupID5), C3.CustomerGroupID5) = G5.CustomerGroupID                                                                
                                                                                                                                                                      
 LEFT JOIN [ERPLIVE].[BMIERP].dbo.MasterCustomerGroup G6                                                                                                     
 ON ISNULL(ISNULL(C1.CustomerGroupID6, C2.CustomerGroupID6), C3.CustomerGroupID6) = G6.CustomerGroupID                                                                
                                                                                                                                                                      
 LEFT JOIN [ERPLIVE].[BMIERP].dbo.MasterCustomerGroup G7                                                                                                     
 ON ISNULL(ISNULL(C1.CustomerGroupID7, C2.CustomerGroupID7), C3.CustomerGroupID7) = G7.CustomerGroupID                                                                
                                                                                                                                                                      
 LEFT JOIN [ERPLIVE].[BMIERP].dbo.MasterCustomerGroup G8                                                                                                     
 ON ISNULL(ISNULL(C1.CustomerGroupID8, C2.CustomerGroupID8), C3.CustomerGroupID8) = G8.CustomerGroupID                                                                
                                                                                                                                                                      
 LEFT JOIN [ERPLIVE].[BMIERP].dbo.MasterCustomerGroup G9                                                                                                     
 ON ISNULL(ISNULL(C1.CustomerGroupID9, C2.CustomerGroupID9), C3.CustomerGroupID9) = G9.CustomerGroupID                                                                
                                                                                                                                                                      
 LEFT JOIN [ERPLIVE].[BMIERP].dbo.MasterCustomerGroup G10                                                                                                    
 ON ISNULL(ISNULL(C1.CustomerGroupID10, C2.CustomerGroupID10), C3.CustomerGroupID10) = G10.CustomerGroupID                                                            
                                                                                                                                                                      
 WHERE A.TransType IN ('OPEN')                                                                                                                                        
 AND A.Tahun = YEAR(@CURRENT)                                                                                                                                         
 AND A.Bulan =  MONTH(@CURRENT)                                                                                                                                       
 AND A.Tanggal = DAY(@CURRENT);                                                                                                                                       
                                                                                                                                                                      
                                                                                                                                                                      
 ---------------------------------------------------------UPDATE LIMIT SBLC 1-%THRESHOLD                                                                              
                                                                                                                                                                      
 --INDIVIDU                                                                                                                                                           
 UPDATE A                                                                                                                                                             
 	SET A.OPIsExcessSBLC = CASE WHEN A.OPSBLCLN > @CAPITAL - A.OPThreshold                                                                                            
 									THEN -1                                                                                                                           
 								ELSE 1                                                                                                                                
 						   END,                                                                                                                                       
 	    A.TRIsExcessSBLC = CASE WHEN A.TRSBLCLN > @CAPITAL - A.TRThreshold                                                                                            
 									THEN -1                                                                                                                           
 								ELSE 1                                                                                                                                
 						   END,                                                                                                                                       
         A.VLIsExcessSBLC = CASE WHEN A.VLSBLCLN > @CAPITAL - A.VLThreshold                                                                                           
 									THEN -1                                                                                                                           
 								ELSE 1                                                                                                                                
 						   END                                                                                                                                        
 FROM TrxLLLOutstandingScreen A                                                                                                                                       
                                                                                                                                                                      
                                                                                                                                                                      
                                                                                                                                                                      
 --GROUP                                                                                                                                                              
 UPDATE A                                                                                                                                                             
 	SET A.OPIsExcessSBLC = A.OPIsExcessSBLC *                                                                                                                         
 	                       ISNULL(B1.OPIsExcessSBLC, 1) * ISNULL(B2.OPIsExcessSBLC, 1) * ISNULL(B3.OPIsExcessSBLC, 1) *                                               
 						   ISNULL(B4.OPIsExcessSBLC, 1) * ISNULL(B5.OPIsExcessSBLC, 1) * ISNULL(B6.OPIsExcessSBLC, 1) *                                               
 						   ISNULL(B7.OPIsExcessSBLC, 1) * ISNULL(B8.OPIsExcessSBLC, 1) * ISNULL(B9.OPIsExcessSBLC, 1) *                                               
 						   ISNULL(B10.OPIsExcessSBLC, 1),                                                                                                             
 	    A.TRIsExcessSBLC = A.TRIsExcessSBLC *                                                                                                                         
 	                       ISNULL(B1.TRIsExcessSBLC, 1) * ISNULL(B2.TRIsExcessSBLC, 1) * ISNULL(B3.TRIsExcessSBLC, 1) *                                               
 						   ISNULL(B4.TRIsExcessSBLC, 1) * ISNULL(B5.TRIsExcessSBLC, 1) * ISNULL(B6.TRIsExcessSBLC, 1) *                                               
 						   ISNULL(B7.TRIsExcessSBLC, 1) * ISNULL(B8.TRIsExcessSBLC, 1) * ISNULL(B9.TRIsExcessSBLC, 1) *                                               
 						   ISNULL(B10.TRIsExcessSBLC, 1),                                                                                                             
         A.VLIsExcessSBLC = A.VLIsExcessSBLC *                                                                                                                        
 	                       ISNULL(B1.VLIsExcessSBLC, 1) * ISNULL(B2.VLIsExcessSBLC, 1) * ISNULL(B3.VLIsExcessSBLC, 1) *                                               
 						   ISNULL(B4.VLIsExcessSBLC, 1) * ISNULL(B5.VLIsExcessSBLC, 1) * ISNULL(B6.VLIsExcessSBLC, 1) *                                               
 						   ISNULL(B7.VLIsExcessSBLC, 1) * ISNULL(B8.VLIsExcessSBLC, 1) * ISNULL(B9.VLIsExcessSBLC, 1) *                                               
 						   ISNULL(B10.VLIsExcessSBLC, 1)                                                                                                              
 FROM TrxLLLOutstandingScreen A                                                                                                                                       
                                                                                                                                                                      
 LEFT JOIN TrxLLLOutstandingScreen B1                                                                                                                                 
 ON A.GroupID1 = B1.GroupID1 AND B1.CustomerNo = 0                                                                                                                    
                                                                                                                                                                      
 LEFT JOIN TrxLLLOutstandingScreen B2                                                                                                                                 
 ON A.GroupID2 = B2.GroupID1 AND B2.CustomerNo = 0                                                                                                                    
                                                                                                                                                                      
 LEFT JOIN TrxLLLOutstandingScreen B3                                                                                                                                 
 ON A.GroupID3 = B3.GroupID1 AND B3.CustomerNo = 0                                                                                                                    
                                                                                                                                                                      
 LEFT JOIN TrxLLLOutstandingScreen B4                                                                                                                                 
 ON A.GroupID4 = B4.GroupID1 AND B4.CustomerNo = 0                                                                                                                    
                                                                                                                                                                      
 LEFT JOIN TrxLLLOutstandingScreen B5                                                                                                                                 
 ON A.GroupID5 = B5.GroupID1 AND B5.CustomerNo = 0                                                                                                                    
                                                                                                                                                                      
 LEFT JOIN TrxLLLOutstandingScreen B6                                                                                                                                 
 ON A.GroupID6 = B6.GroupID1 AND B6.CustomerNo = 0                                                                                                                    
                                                                                                                                                                      
 LEFT JOIN TrxLLLOutstandingScreen B7                                                                                                                                 
 ON A.GroupID7 = B7.GroupID1 AND B7.CustomerNo = 0                                                                                                                    
                                                                                                                                                                      
 LEFT JOIN TrxLLLOutstandingScreen B8                                                                                                                                 
 ON A.GroupID8 = B8.GroupID1 AND B8.CustomerNo = 0                                                                                                                    
                                                                                                                                                                      
 LEFT JOIN TrxLLLOutstandingScreen B9                                                                                                                                 
 ON A.GroupID9 = B9.GroupID1 AND B9.CustomerNo = 0                                                                                                                    
                                                                                                                                                                      
 LEFT JOIN TrxLLLOutstandingScreen B10                                                                                                                                
 ON A.GroupID10 = B10.GroupID1 AND B10.CustomerNo = 0                                                                                                                 
                                                                                                                                                                      
 WHERE A.CustomerNo <> 0;                                                                                                                                             
                                                                                                                                                                      
 ---------------------------------------------- INSERT INTO HISTORY                                                                                                   
                                                                                                                                                                      
 ------------Parameter                                                                                                                                                
 --CLEAR DATA                                                                                                                                                         
 DELETE MasterLLLParametersHistory                                                                                                                                    
 WHERE Tanggal = DAY(@CURRENT)                                                                                                                                        
   AND Bulan = MONTH(@CURRENT)                                                                                                                                        
   AND Tahun = YEAR(@CURRENT)                                                                                                                                         
   AND TransType = 'INTRA'                                                                                                                                            
                                                                                                                                                                      
                                                                                                                                                                      
 --INSERT DATA                                                                                                                                                        
 INSERT INTO MasterLLLParametersHistory(Tanggal, Bulan, Tahun, TransType, ParIndex, ParameterName, Persen, Nilai)                                                     
 SELECT DAY(@CURRENT),                                                                                                                                                
        MONTH(@CURRENT),                                                                                                                                              
 	   YEAR(@CURRENT),                                                                                                                                                
 	   'INTRA',                                                                                                                                                       
 	   ParIndex,                                                                                                                                                      
 	   ParameterName,                                                                                                                                                 
 	   Persen,                                                                                                                                                        
 	   Nilai                                                                                                                                                          
 FROM MasterLLLParametersScreen                                                                                                                                       
 WHERE TransType = 'INTRA'                                                                                                                                            
 ORDER BY ParIndex                                                                                                                                                    
                                                                                                                                                                      
                                                                                                                                                                      
                                                                                                                                                                      
 ------------Currency                                                                                                                                                 
 --CLEAR DATA                                                                                                                                                         
 DELETE TrxLLLTempCurrencyHistory                                                                                                                                     
 WHERE Tanggal = DAY(@CURRENT)                                                                                                                                        
   AND Bulan = MONTH(@CURRENT)                                                                                                                                        
   AND Tahun = YEAR(@CURRENT)                                                                                                                                         
   AND TransType = 'INTRA'                                                                                                                                            
                                                                                                                                                                      
                                                                                                                                                                      
 --INSERT DATA                                                                                                                                                        
 INSERT INTO TrxLLLTempCurrencyHistory(Tanggal, Bulan, Tahun, ExecutionDate, TransType, CCY, Rate, CalcRule)                                                          
 SELECT DAY(@CURRENT),                                                                                                                                                
        MONTH(@CURRENT),                                                                                                                                              
 	   YEAR(@CURRENT),                                                                                                                                                
 	   ExecutionDate, TransType, CCY, Rate, CalcRule                                                                                                                  
 FROM TrxLLLTempCurrencyScreen A                                                                                                                                      
 WHERE A.TransType = 'INTRA'                                                                                                                                          
                                                                                                                                                                      
                                                                                                                                                                      
                                                                                                                                                                      
                                                                                                                                                                      
 ------------OUTSTANDING                                                                                                                                              
                                                                                                                                                                      
 --CLEAR DATA                                                                                                                                                         
 DELETE TrxLLLOutstandingHistory                                                                                                                                      
 WHERE Tanggal = DAY(@CURRENT)                                                                                                                                        
   AND Bulan = MONTH(@CURRENT)                                                                                                                                        
   AND Tahun = YEAR(@CURRENT)                                                                                                                                         
                                                                                                                                                                      
                                                                                                                                                                      
 --INSERT DATA                                                                                                                                                        
 INSERT INTO TrxLLLOutstandingHistory(Tanggal, Bulan, Tahun, DateGenerate, CustomerNo, CustomerName,                                                                  
                                      GroupID1,	GroupID2, GroupID3, GroupID4, GroupID5, GroupID6,                                                                     
 									 GroupID7, GroupID8, GroupID9, GroupID10, IsSOE, ISRelatedParty, OPLN,	OPBG,                                                     
 									 OPLC,	OPInterbank, OPForex, OPMTM, OPDerivativeCCS, OPDerivativeIRS,                                                            
 									 OPTotalDerivative,	OPTotalOS, OPThreshold, OPJaminanPlacement,	OPSBLCLN,	OPSBLCBG,                                             
 									 OPPLEDGETD, OPIsExcessSBLC, OPAvaibility, OPGeneratedBy, OPDateGenerate,                                                         
 									 TRLN, TRBG, TRLC, TRInterbank, TRForex, TRMTM, TRDerivativeCCS, TRDerivativeIRS,                                                 
 									 TRTotalDerivative,	TRTotalOS, TRThreshold, TRJaminanPlacement, TRSBLCLN, TRSBLCBG,                                               
 									 TRPLEDGETD, TRIsExcessSBLC, TRAvaibility, TRGeneratedBy, TRDateGenerate,                                                         
 									 VLLN, VLBG, VLLC, VLInterbank, VLForex, VLMTM, VLDerivativeCCS, VLDerivativeIRS, VLTotalDerivative,                              
 									 VLTotalOS, VLThreshold, VLJaminanPlacement, VLSBLCLN, VLSBLCBG, VLPLEDGETD, VLIsExcessSBLC,                                      
 									 VLAvaibility, VLGeneratedBy, VLDateGenerate,                                                                                     
 									 ErrorIndicatorJoinAvaibility)                                                                                                    
 SELECT DAY(@CURRENT),                                                                                                                                                
        MONTH(@CURRENT),                                                                                                                                              
 	   YEAR(@CURRENT),                                                                                                                                                
 	   DateGenerate,	CustomerNo,	CustomerName,	GroupID1,	GroupID2,	GroupID3,                                                                                 
        GroupID4, GroupID5, GroupID6, GroupID7, GroupID8, GroupID9, GroupID10,                                                                                        
 	   IsSOE, ISRelatedParty,                                                                                                                                         
 	   OPLN, OPBG, OPLC, OPInterbank, OPForex, OPMTM, OPDerivativeCCS, OPDerivativeIRS,                                                                               
 	   OPTotalDerivative, OPTotalOS, OPThreshold, OPJaminanPlacement, OPSBLCLN, OPSBLCBG,                                                                             
 	   OPPLEDGETD, OPIsExcessSBLC, OPAvaibility, OPGeneratedBy, OPDateGenerate,                                                                                       
 	   TRLN, TRBG, TRLC, TRInterbank, TRForex, TRMTM, TRDerivativeCCS, TRDerivativeIRS,                                                                               
 	   TRTotalDerivative, TRTotalOS, TRThreshold, TRJaminanPlacement, TRSBLCLN, TRSBLCBG,                                                                             
 	   TRPLEDGETD, TRIsExcessSBLC, TRAvaibility, TRGeneratedBy, TRDateGenerate,                                                                                       
 	   VLLN, VLBG, VLLC, VLInterbank, VLForex, VLMTM, VLDerivativeCCS, VLDerivativeIRS,                                                                               
 	   VLTotalDerivative, VLTotalOS, VLThreshold, VLJaminanPlacement, VLSBLCLN, VLSBLCBG,                                                                             
 	   VLPLEDGETD, VLIsExcessSBLC, VLAvaibility, VLGeneratedBy, VLDateGenerate,                                                                                       
 	   ErrorIndicatorJoinAvaibility                                                                                                                                   
 FROM TrxLLLOutstandingScreen                                                                                                                                      
                                                                                                                                                                      
                                                                                                                                                                      
 -------------AVAIBILITY                                                                                                                                              
 --CLEAR DATA                                                                                                                                                         
 DELETE TrxLLLAvaibilityDetailHistory                                                                                                                                 
 WHERE Tanggal = DAY(@CURRENT)                                                                                                                                        
   AND Bulan = MONTH(@CURRENT)                                                                                                                                        
   AND Tahun = YEAR(@CURRENT)                                                                                                                                         
   AND TransType IN ('TRANS', 'VALUE');                                                                                                                               
                                                                                                                                                                      
                                                                                                                                                                      
 --INSERT DATA                                                                                                                                                        
 INSERT INTO TrxLLLAvaibilityDetailHistory(Tanggal, Bulan, Tahun, TransType, CustomerID, CustomerName,                                                                
                                           CustomerGroupID, CustomerGroupName, JenisOS, TotalOS,                                                                      
 										  Threshold, Excess, Jaminan, Avaibility, RankPriority)                                                                       
 SELECT DAY(@CURRENT),                                                                                                                                                
        MONTH(@CURRENT),                                                                                                                                              
 	   YEAR(@CURRENT),                                                                                                                                                
 	   TransType, CustomerID, CustomerName, CustomerGroupID, CustomerGroupName,                                                                                       
        JenisOS, TotalOS, Threshold, Excess, Jaminan, Avaibility, RankPriority                                                                                        
 FROM TrxLLLAvaibilityDetailScreen A                                                                                                                                  
 WHERE A.TransType IN ('TRANS', 'VALUE');                                                                                                                             
