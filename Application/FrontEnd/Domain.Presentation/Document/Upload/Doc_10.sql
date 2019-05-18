--PERIOD = TANGGAL AKHIR BULAN KERJA
--ENDOFMONTH = TANGGAL AKHIR BULAN
DECLARE @PERIOD DATETIME, 
        @PREVDATE DATETIME, 
	    @JULDATE INT, 
	    @INITPERIOD DATETIME,
		@ENDOFMONTH DATETIME

SELECT @PERIOD = CONVERT(datetime, '[PARAMS_PERIOD]', 103),
       @INITPERIOD = CONVERT(DATETIME, '01-' + RIGHT( '0' + CONVERT(VARCHAR,MONTH(@PERIOD)), 2) + '-' + CONVERT(VARCHAR, YEAR(@PERIOD)), 103),
       @PREVDATE = DATEADD(MONTH, -1, @PERIOD),
       @JULDATE = DATEDIFF(DAY, CONVERT(DATETIME, '31-12-1971', 103), @PERIOD),
	   @ENDOFMONTH = DATEADD (dd, -1, DATEADD(mm, DATEDIFF(mm, 0, @PERIOD) + 1, 0))

--CURRENCY
SELECT A.G2CYCD, A.G2SPRT, A.G2HIDT, B.A6NBDP
INTO #Currency
FROM MIDAS_SDCUHSPD A
LEFT JOIN MIDAS_SDCURRPD B
ON A.G2CYCD = B.A6CYCD AND A.Bulan = B.Bulan AND A.Tahun = B.Tahun
WHERE A.G2HIDT =  @JULDATE AND A.Bulan = MONTH(@PERIOD) AND A.Tahun = YEAR(@PERIOD)
--=================================================================START==================================================================--
--===============================================================BAKI DEBET===============================================================--

--GET BAKIDEBET OF TRX IN RANGE
select dbo.getRegExOnly(ISNULL(B.[03C-12], '') , '[^0-9a-zA-Z_\(\)\-\-\''\.\/\ ]') AS NoAkadAwal, CONVERT(VARCHAR,1) + RIGHT(B.CANUMCDM,7) + B.CUSTACNUM + C.TrxTypeID + D.FacilityCode AS NomorRekeningFasilitas,
	   A.CustomerID, rank() over(PARTITION BY CustomerID, FirstReffNo
								order by case when a.LNRemarkID in ('PRE') then a.NewInterestDueDate
												when LNRemarkID in ('REP') then a.NewInterestDueDate
												when LNRemarkID in ('RRP','PPE','REV','RRA') then a.NewInterestValueDate
												when LNRemarkID in ('NEW','R/O','RPA','PAR') then a.NewPrincipalValueDate
												else a.NewPrincipalValueDate end desc,a.TransNo desc)[No]
,a.FirstReffNo, a.LNRemarkID, a.WITHDRAWNCURRENCY, b.CCY, a.Amount as Amount, NewPrincipalValueDate, NewPrincipalMaturedDate, NewInterestValueDate, NewInterestDueDate, a.LADApprovedByDateIn
into #TempBakiDebet
from [ERPLINKSERVER].TrxFundingConfirmation a
inner join ERP_T_FacilityMaster b on b.Flag<>'4' and (b.TYPETXN='LOAN' or b.TYPETXN='LOAN SYND')
								and b.STATUSBMI in ('5. Opened','6. Completion Notified')
								and b.CUSTACNUM=a.CustomerID and b.CANUMCDM=a.ListOfCANo and b.[03C-14]=a.ListOfAgreementNo
								and b.TypeOfFacility=a.TypeOfFacility
LEFT JOIN T_MasterTrxType c ON b.TYPETXN = c.TrxType
LEFT JOIN T_MasterTypeFacility d ON b.TypeOfFacility = d.TypeOfFacility
where a.Flag in ('0','2')
and (case when LNRemarkID in ('PRE') and @PERIOD >= a.NewInterestDueDate then @PERIOD
            when LNRemarkID in ('PRE') and @PERIOD < a.NewInterestDueDate then a.NewInterestDueDate
            when LNRemarkID in ('REP') and @PERIOD >= a.NewInterestDueDate then @PERIOD
            when LNRemarkID in ('REP') and @PERIOD < a.NewInterestDueDate then a.NewInterestDueDate
            when LNRemarkID in ('RRP','PPE','REV','RRA') and @PERIOD >= a.NewInterestValueDate then @PERIOD
            when LNRemarkID in ('RRP','PPE','REV','RRA') and @PERIOD < a.NewInterestValueDate then a.NewInterestValueDate
            when LNRemarkID in ('PAR','NEW','R/O','RPA') and @PERIOD >= a.NewPrincipalValueDate then @PERIOD
            when LNRemarkID in ('PAR','NEW','R/O','RPA') and @PERIOD < a.NewPrincipalValueDate then a.NewPrincipalValueDate
            else a.NewPrincipalValueDate end)
    <= @PERIOD
AND B.bulan = MONTH(@PERIOD) AND B.Tahun = YEAR(@PERIOD)
AND (case when LNRemarkID in ('PRE','REP') then @PERIOD
			when LNRemarkID in ('REV','RRA','RRP') then a.NewInterestDueDate
            else a.NewPrincipalMaturedDate end) >= @PERIOD

AND ISNULL(a.FirstReffNo,'')<>''
AND ISNULL(a.LADApprovedByDateIn,'')<>''
AND ISNULL(B.ApprovedBy, '') <> ''
AND B.[03C-17] <= @PERIOD
order by case when LNRemarkID in ('PRE') then a.NewInterestDueDate
            when LNRemarkID in ('REP') then a.NewInterestDueDate
            when LNRemarkID in ('RRP','PPE','REV','RRA') then a.NewInterestValueDate
            when LNRemarkID in ('NEW','R/O','RPA','PAR') then a.NewPrincipalValueDate
            else a.NewPrincipalValueDate end,a.TransNo

--GET BAKI DEBET
SELECT A.Amount * B.G2SPRT / C.G2SPRT AS OriginalAmount, A.Amount * B.G2SPRT AS Amount, NoAkadAwal, CustomerID, NomorRekeningFasilitas
INTO #BakiDebet
FROM #TempBakiDebet A
LEFT JOIN #CURRENCY B ON A.WITHDRAWNCURRENCY = B.G2CYCD
LEFT JOIN #CURRENCY C ON A.CCY = C.G2CYCD
WHERE A.[No]=1 and A.LNRemarkID not in ('PRE','REP')

--GET SUM OF BAKIDEBET PER FACILITY
SELECT SUM(OriginalAmount) AS OriginalAmount, ROUND(SUM(Amount), 0) AS Amount, NoAkadAwal, CustomerID, NomorRekeningFasilitas
INTO #SumOfBakiDebet
FROM #BakiDebet
GROUP BY NoAkadAwal, CustomerID, NomorRekeningFasilitas

--===============================================================BAKI DEBET===============================================================--
--==================================================================END===================================================================--
--=================================================================START==================================================================--
--==============================================================BAKI DEBET TR=============================================================--
--GET BAKI DEBET TR
SELECT DISTINCT MASTER.KEY97, Customer.GFCPNC AS CustomerID, Master.AMT_O_S/POWER(10,Currency.A6NBDP) AS OriginalAmount, Master.AMT_O_S/POWER(10, Currency.A6NBDP) * Currency.G2SPRT AS Amount, FinanceMaster.ACTUALRATE AS SukuBunga
INTO #BakiDebetTR
FROM TI_MASTER Master
INNER JOIN TI_EXEMPL30 Exemplar ON Master.Exemplar = Exemplar.KEY97 AND Master.Tahun = Exemplar.Tahun AND Master.Bulan = Exemplar.Bulan
INNER JOIN #CURRENCY Currency ON Master.CCY = Currency.G2CYCD
INNER JOIN TI_PARTYDTLS PartyDetails ON Master.PCP_PTY = PartyDetails.KEY97 AND Master.Tahun = PartyDetails.Tahun AND Master.Bulan = PartyDetails.Bulan
INNER JOIN MIDAS_GFPF Customer ON PartyDetails.CUS_MNM = Customer.GFCUS1 AND Master.Tahun = Customer.Tahun AND Master.Bulan = Customer.Bulan
INNER JOIN TI_PRODTYPE ProductType ON Master.PRODTYPE = ProductType.KEY97 AND Master.Tahun = ProductType.Tahun AND Master.Bulan = ProductType.Bulan
INNER JOIN TI_FNCEMASTER FinanceMaster ON Master.KEY97 = FinanceMaster.KEY97 AND Master.Tahun = FinanceMaster.Tahun AND Master.Bulan = FinanceMaster.Bulan
WHERE Exemplar.CODE79 = 'FSA' AND ProductType.Name = 'Import' AND
ISNULL(Master.AMT_O_S ,0) > 0 AND Master.STATUS <> 'BKF' AND
        Master.Bulan = MONTH(@PERIOD) And Master.Tahun = YEAR(@PERIOD)

--GET SUM OF BAKIDEBET TR PER FACILITY
SELECT SUM(OriginalAmount) AS OriginalAmount, ROUND(SUM(Amount),0) AS Amount, MAX(SukuBunga) AS SukuBunga, CustomerID
INTO #SumOfBakiDebetTR
FROM #BakiDebetTR
GROUP BY CustomerID

--==============================================================BAKI DEBET TR=============================================================--
--==================================================================END===================================================================--
--=================================================================START==================================================================--
--===============================================================REALISASI================================================================--

--GET Realisasi OF TRX IN RANGE
select dbo.getRegExOnly(ISNULL(B.[03C-12],''), '[^0-9a-zA-Z_\(\)\-\-\''\.\/\ ]') AS NoAkadAwal, CONVERT(VARCHAR,1) + RIGHT(B.CANUMCDM,7) + B.CUSTACNUM + C.TrxTypeID + D.FacilityCode AS NomorRekeningFasilitas,
	   A.CustomerID, rank() over(PARTITION BY CustomerID, FirstReffNo
								order by case when LNRemarkID in ('RRA') then a.NewInterestValueDate
											  when LNRemarkID in ('NEW','RPA') then a.NewPrincipalValueDate
											  else a.NewPrincipalValueDate end desc,a.TransNo desc)[No]
,a.FirstReffNo, a.LNRemarkID, a.WITHDRAWNCURRENCY, a.DefaultAmount, NewPrincipalValueDate, NewPrincipalMaturedDate, NewInterestValueDate, NewInterestDueDate, a.LADApprovedByDateIn
into #TempRealisasi
from [ERPLINKSERVER].TrxFundingConfirmation a
inner join ERP_T_FacilityMaster b on b.Flag<>'4' and (b.TYPETXN='LOAN' or b.TYPETXN='LOAN SYND')
								and b.STATUSBMI in ('5. Opened','6. Completion Notified')
								and b.CUSTACNUM=a.CustomerID and b.CANUMCDM=a.ListOfCANo and b.[03C-14]=a.ListOfAgreementNo
								and b.TypeOfFacility=a.TypeOfFacility
LEFT JOIN T_MasterTrxType c ON b.TYPETXN = c.TrxType
LEFT JOIN T_MasterTypeFacility d ON b.TypeOfFacility = d.TypeOfFacility
where a.Flag in ('0','2')
AND (case when LNRemarkID in ('RRA') then MONTH(a.NewInterestValueDate)
          when LNRemarkID in ('NEW','RPA') then MONTH(a.NewPrincipalValueDate)
     else MONTH(a.NewPrincipalValueDate) end)
    = MONTH(@PERIOD)

AND (case when LNRemarkID in ('RRA') then YEAR(a.NewInterestValueDate)
          when LNRemarkID in ('NEW','RPA') then YEAR(a.NewPrincipalValueDate)
     else YEAR(a.NewPrincipalValueDate) end)
    = YEAR(@PERIOD)
AND B.bulan = MONTH(@PERIOD) AND B.Tahun = YEAR(@PERIOD)
AND ISNULL(B.ApprovedBy, '') <> ''
AND B.[03C-17] <= @PERIOD
AND ISNULL(a.FirstReffNo,'')<>''
AND ISNULL(a.LADApprovedByDateIn,'')<>''
and LNRemarkID in ('NEW','RPA','RRA')
order by case when LNRemarkID in ('RRA') then a.NewInterestValueDate
              when LNRemarkID in ('NEW','RPA') then a.NewPrincipalValueDate
              else a.NewPrincipalValueDate end,a.TransNo

--GET Realisasi
SELECT A.DefaultAmount * B.G2SPRT AS Amount, NoAkadAwal, CustomerID, NomorRekeningFasilitas
INTO #Realisasi
FROM #TempRealisasi A
LEFT JOIN #CURRENCY B ON A.WITHDRAWNCURRENCY = B.G2CYCD
WHERE A.[No]=1

--GET SUM OF Realisasi PER FACILITY
SELECT ROUND(SUM(Amount), 0) AS Amount, NoAkadAwal, CustomerID, NomorRekeningFasilitas
INTO #SumOfRealisasi
FROM #Realisasi
GROUP BY NoAkadAwal, CustomerID, NomorRekeningFasilitas

--===============================================================REALISASI================================================================--
--==================================================================END===================================================================--
--=================================================================START==================================================================--
--===============================================================FACILITY===================================================================--

----GET ALL FACILITY DATA
SELECT rank() over(PARTITION BY B.CUSTACNUM,B.[03C-12], B.TYPETXN, B.TypeOfFacility
					order by B.CUSTACNUM,B.CurCADate desc
					)[RowNo],
B.TerminationDate,
A.CustomerName AS CustomerName,
B.CANUMCDM AS CANumber,
B.PREVCANUM,
B.CUSTACNUM AS CustomerID,
B.CAEXPDT AS ExpiryDate,
B.StatusBMI AS StatusBMI,
'D' AS FlagDetail,
MONTH(@PERIOD) AS Bulan,
YEAR(@PERIOD) AS Tahun,
CONVERT(VARCHAR,1) + RIGHT(b.CANUMCDM,7) + B.CUSTACNUM + D.TrxTypeID + E.FacilityCode AS NomorRekeningFasilitas,
'CR' + A.CustomerID AS CIF,
B.KodeSifatKredit AS KodeSifatKredit,
B.KodeJenisKredit AS KodeJenisKredit,
'00' AS KodeAkadPembiayaan,
dbo.getRegExOnly(ISNULL(B.[03C-12],''), '[^0-9a-zA-Z_\(\)\-\-\''\.\/\ ]') AS NomorAkadAwal,
B.[03C-13] AS TanggalAkadAwal,
dbo.getRegExOnly(ISNULL(B.SIDLastAgreementNo,''), '[^0-9a-zA-Z_\(\)\-\-\''\.\/\ ]') AS NomorAkadAkhir,
B.SIDLastAgreementDate AS TanggalAkadAkhir,
B.[03C-19] AS BaruAtauPerpanjangan,
B.[03C-13] AS TanggalAwalKredit,
B.[03C-17] AS TanggalMulai,
B.[03C-18] AS TanggalJatuhTempo,
'99' AS KodeKategoriDebitur,
B.Purpose AS KodeJenisPenggunaan,
CASE WHEN (ISNULL(A.UsageOrientation,'') <> '9' AND ISNULL(A.UsageOrientation,'') <> '') THEN A.UsageOrientation ELSE '3' END KodeOrientasiPenggunaan,
C.KodeBidangUsaha AS KodeSektorEkonomi,
C.KodeSandiKabupatenKota AS KodeDATI2,
ROUND(B.AMT * F.G2SPRT, 0) AS NilaiProyek, --Sama dengan Plafon
B.CCY AS KodeValuta,
ISNULL(G.CustomerRate,0) AS ProsentaseSukuBunga,
'2' AS JenisSukuBunga,
'001' AS KreditProgramPemerintah,
'' AS TakeOverDari,
'048' AS SumberDana,
CASE WHEN B.[COMBINED?] > 0 THEN ROUND(B.[COMBINED?] * F.G2SPRT, 0) ELSE ROUND(B.AMT * F.G2SPRT, 0) END AS PlafonAwal, --Bila 0 maka sama dengan plafon
CASE WHEN E.FacilityCode = '14' AND @PERIOD <= B.AvailabilityPeriodTo THEN (CASE WHEN B.[COMBINED?] > 0 THEN ROUND(B.[COMBINED?] * F.G2SPRT, 0) ELSE ROUND(B.AMT * F.G2SPRT, 0) END)
WHEN E.FacilityCode = '14' AND @PERIOD > B.AvailabilityPeriodTo THEN ISNULL(H.Amount,'0')
ELSE ROUND(B.AMT * F.G2SPRT, 0) END Plafon,
0 AS RealisasiBulanBerjalan,
0 AS Denda,
0 AS BakiDebet,
0 AS NilaiDalamMataUangAsal,
A.ReserveRatingID AS KodeKolektibilitas,
'1900-01-01' AS TanggalMacet,
'' AS KodeSebabMacet,
0 AS TunggakanPokok,
0 AS TunggakanBunga,
'' AS JumlahHariTunggakan,
0 AS FrekuensiTunggakan,
0 AS FrekuensiRestrukturisasi,
'1900-01-01' AS TanggalRestrukturisasiAwal,
'1900-01-01' AS TanggalRestrukturisasiAkhir,
'' AS KodeCaraRestrukturisasi,
'00' AS KodeKondisi,
'1900-01-01' AS TanggalKondisi,
dbo.getRegExOnly(CONVERT(VARCHAR,1) + CASE WHEN ISNULL(B.PREVCANUM,'') = '' THEN RIGHT(B.CANUMCDM,7) ELSE RIGHT(B.PREVCANUM,7) END + B.CUSTACNUM + D.TrxTypeID + E.FacilityCode + '-' + CONVERT(VARCHAR,1) + RIGHT(B.CANUMCDM,7) + B.CUSTACNUM + D.TrxTypeID + E.FacilityCode + ' ' + B.TYPETXN + '-' + B.TypeOfFacility, '[^0-9a-zA-Z_\ \@\#\$\%\^\&\*\(\)\{\}\[\]\<\>\~\-\-\`\''\"\.\,\:\;\/\?\!]') AS Keterangan,
'030' AS KodeKantorCabang,
'C' AS OperasiData
into #Facility
FROM [ERPLINKSERVER].MasterCustomer A
INNER JOIN ERP_T_FacilityMaster B ON A.CustomerID = B.custacnum
LEFT JOIN MasterSLIKDebiturBadanUsaha C ON 'CR' + A.CustomerID = C.CIF
INNER JOIN T_MasterTrxType D ON B.TYPETXN = D.TrxType
INNER JOIN T_MasterTypeFacility E ON B.TypeOfFacility = E.TypeOfFacility
LEFT JOIN #CURRENCY F ON F.G2CYCD = B.CCY
LEFT JOIN (SELECT CustomerID, ListOfCANo, ListOfAgreementNo, TypeOfFacility, 
				  MAX(CustomerRate) AS CustomerRate
		   FROM [ERPLINKSERVER].TrxFundingConfirmation
		   WHERE NewPrincipalValueDate = MONTH(@PERIOD) AND NewPrincipalValueDate= YEAR(@PERIOD)
		   GROUP BY CustomerID, ListOfCANo, ListOfAgreementNo, TypeOfFacility) G
		   ON B.CUSTACNUM = G.CustomerID and B.CANUMCDM = G.ListOfCANo and B.[03C-14] = G.ListOfAgreementNo
		   and B.TypeOfFacility = G.TypeOfFacility
LEFT JOIN #SumOfBakiDebet H ON CONVERT(VARCHAR,1) + RIGHT(b.CANUMCDM,7) + B.CUSTACNUM + D.TrxTypeID + E.FacilityCode = H.NomorRekeningFasilitas
WHERE A.CustomerStatusID in (1,7,8) AND
(B.STATUSBMI = '5. Opened' OR (B.STATUSBMI = '6. Completion Notified' AND MONTH(B.TerminationDate) = MONTH(@PERIOD) AND YEAR(B.TerminationDate) = YEAR(@PERIOD))) AND (B.TYPETXN='LOAN' OR B.TYPETXN='LOAN SYND') AND B.Flag in ('0','2') AND YEAR(B.CAEXPDT) > 2014
AND ISNULL(B.ApprovedBy, '') <> ''
AND B.[03C-17] <= @ENDOFMONTH
AND B.bulan = MONTH(@PERIOD) AND B.Tahun = YEAR(@PERIOD)
order by B.CUSTACNUM,B.CurCADate desc

----===============================================================FACILITY===================================================================--
----==================================================================END===================================================================--
--=================================================================START==================================================================--
--=============================================================FACILITY IBD===================================================================--

----GET ALL FACILITY DATA
SELECT rank() over(PARTITION BY B.CUSTACNUM,B.[03C-12], B.TYPETXN, B.TypeOfFacility
					order by B.CUSTACNUM,B.CurCADate desc
					)[RowNo],
B.TerminationDate,
A.CustomerName AS CustomerName,
B.CANUMCDM AS CANumber,
B.PREVCANUM,
B.CUSTACNUM AS CustomerID,
B.CAEXPDT AS ExpiryDate,
B.StatusBMI AS StatusBMI,
'D' AS FlagDetail,
MONTH(@PERIOD) AS Bulan,
YEAR(@PERIOD) AS Tahun,
CONVERT(VARCHAR,1) + RIGHT(b.CANUMCDM,7) + B.CUSTACNUM + D.TrxTypeID + E.FacilityCode AS NomorRekeningFasilitas,
'CR' + A.CustomerID AS CIF,
B.KodeSifatKredit AS KodeSifatKredit,
B.KodeJenisKredit AS KodeJenisKredit,
'00' AS KodeAkadPembiayaan,
dbo.getRegExOnly(ISNULL(B.[03C-12],''), '[^0-9a-zA-Z_\(\)\-\-\''\.\/\ ]') AS NomorAkadAwal,
B.[03C-13] AS TanggalAkadAwal,
dbo.getRegExOnly(ISNULL(B.SIDLastAgreementNo,''), '[^0-9a-zA-Z_\(\)\-\-\''\.\/\ ]') AS NomorAkadAkhir,
B.SIDLastAgreementDate AS TanggalAkadAkhir,
B.[03C-19] AS BaruAtauPerpanjangan,
B.[03C-13] AS TanggalAwalKredit,
B.[03C-17] AS TanggalMulai,
B.[03C-18] AS TanggalJatuhTempo,
'99' AS KodeKategoriDebitur,
'1' AS KodeJenisPenggunaan,
'2' AS KodeOrientasiPenggunaan,
C.KodeBidangUsaha AS KodeSektorEkonomi,
C.KodeSandiKabupatenKota AS KodeDATI2,
ROUND(B.AMT * F.G2SPRT, 0) AS NilaiProyek, --Sama dengan Plafon
B.CCY AS KodeValuta,
0 AS ProsentaseSukuBunga,
'1' AS JenisSukuBunga,
'001' AS KreditProgramPemerintah,
'' AS TakeOverDari,
'048' AS SumberDana,
CASE WHEN B.[COMBINED?] > 0 THEN ROUND(B.[COMBINED?] * F.G2SPRT, 0) ELSE ROUND(B.AMT * F.G2SPRT, 0) END AS PlafonAwal, --Bila 0 maka sama dengan plafon
ROUND(B.AMT * F.G2SPRT, 0) AS Plafon,
0 AS RealisasiBulanBerjalan,
0 AS Denda,
0 AS BakiDebet,
0 AS NilaiDalamMataUangAsal,
A.ReserveRatingID AS KodeKolektibilitas,
'1900-01-01' AS TanggalMacet,
'' AS KodeSebabMacet,
0 AS TunggakanPokok,
0 AS TunggakanBunga,
'' AS JumlahHariTunggakan,
0 AS FrekuensiTunggakan,
0 AS FrekuensiRestrukturisasi,
'1900-01-01' AS TanggalRestrukturisasiAwal,
'1900-01-01' AS TanggalRestrukturisasiAkhir,
'' AS KodeCaraRestrukturisasi,
'00' AS KodeKondisi,
'1900-01-01' AS TanggalKondisi,
dbo.getRegExOnly(CONVERT(VARCHAR,1) + CASE WHEN ISNULL(B.PREVCANUM,'') = '' THEN RIGHT(B.CANUMCDM,7) ELSE RIGHT(B.PREVCANUM,7) END + B.CUSTACNUM + D.TrxTypeID + E.FacilityCode + '-' + CONVERT(VARCHAR,1) + RIGHT(B.CANUMCDM,7) + B.CUSTACNUM + D.TrxTypeID + E.FacilityCode + ' ' + B.TYPETXN + '-' + B.TypeOfFacility, '[^0-9a-zA-Z_\ \@\#\$\%\^\&\*\(\)\{\}\[\]\<\>\~\-\-\`\''\"\.\,\:\;\/\?\!]') AS Keterangan,
'030' AS KodeKantorCabang,
'C' AS OperasiData
into #FacilityIBD
FROM [ERPLINKSERVER].MasterCustomer A
INNER JOIN ERP_T_FacilityMaster B ON A.CustomerID = B.custacnum
LEFT JOIN MasterSLIKDebiturBadanUsaha C ON 'CR' + A.CustomerID = C.CIF
INNER JOIN T_MasterTrxType D ON B.TYPETXN = D.TrxType
INNER JOIN T_MasterTypeFacility E ON B.TypeOfFacility = E.TypeOfFacility
LEFT JOIN #CURRENCY F ON F.G2CYCD = B.CCY
WHERE A.CustomerStatusID in (1,7,8) AND
(B.STATUSBMI = '5. Opened' OR (B.STATUSBMI = '6. Completion Notified' AND MONTH(B.TerminationDate) = MONTH(@PERIOD) AND YEAR(B.TerminationDate) = YEAR(@PERIOD))) AND B.TYPETXN='IBD' AND B.Flag in ('0','2') AND YEAR(B.CAEXPDT) > 2014
AND ISNULL(B.ApprovedBy, '') <> ''
AND B.[03C-17] <= @ENDOFMONTH
AND B.bulan = MONTH(@PERIOD) AND B.Tahun = YEAR(@PERIOD)
order by B.CUSTACNUM,B.CurCADate desc

----=============================================================FACILITY IBD===================================================================--
----==================================================================END===================================================================--

--CLEAR DATA
DELETE TrxSLIKKredit
WHERE Bulan = MONTH(@PERIOD)
AND Tahun = YEAR(@PERIOD);

INSERT INTO TrxSLIKKredit (
Bulan,
Tahun,
CustomerID,
CustomerName,
CANumber,
FlagDetail,
NomorRekeningFasilitas,
CIF,
KodeSifatKredit,
KodeJenisKredit,
KodeAkadPembiayaan,
NomorAkadAwal,
TanggalAkadAwal,
NomorAkadAkhir,
TanggalAkadAkhir,
BaruAtauPerpanjangan,
TanggalAwalKredit,
TanggalMulai,
TanggalJatuhTempo,
KodeKategoriDebitur,
KodeJenisPenggunaan,
KodeOrientasiPenggunaan,
KodeSektorEkonomi,
KodeDATI2,
NilaiProyek,
KodeValuta,
ProsentaseSukuBunga,
JenisSukuBunga,
KreditProgramPemerintah,
TakeOverDari,
SumberDana,
PlafonAwal,
Plafon,
RealisasiBulanBerjalan,
Denda,
BakiDebet,
NilaiDalamMataUangAsal,
KodeKolektibilitas,
TanggalMacet,
KodeSebabMacet,
TunggakanPokok,
TunggakanBunga,
JumlahHariTunggakan,
FrekuensiTunggakan,
FrekuensiRestrukturisasi,
TanggalRestrukturisasiAwal,
TanggalRestrukturisasiAkhir,
KodeCaraRestrukturisasi,
KodeKondisi,
TanggalKondisi,
Keterangan,
KodeKantorCabang,
OperasiData
)
--Kredit dengan Status Opened (Baki Debet boleh kosong)
SELECT 
A.Bulan, 
A.Tahun, 
RIGHT(A.CIF, 6),
A.CustomerName,
A.CANumber,
A.FlagDetail, 
A.NomorRekeningFasilitas, 
A.CIF, 
A.KodeSifatKredit, 
A.KodeJenisKredit, 
A.KodeAkadPembiayaan, 
A.NomorAkadAwal, 
A.TanggalAkadAwal, 
A.NomorAkadAkhir, 
A.TanggalAkadAkhir, 
A.BaruAtauPerpanjangan, 
A.TanggalAwalKredit, 
A.TanggalMulai, 
A.TanggalJatuhTempo, 
A.KodeKategoriDebitur, 
A.KodeJenisPenggunaan, 
A.KodeOrientasiPenggunaan, 
A.KodeSektorEkonomi, 
A.KodeDATI2, 
A.NilaiProyek, 
A.KodeValuta, 
A.ProsentaseSukuBunga, 
A.JenisSukuBunga, 
A.KreditProgramPemerintah, 
A.TakeOverDari, 
A.SumberDana, 
A.PlafonAwal, 
A.Plafon, 
ISNULL(C.Amount,'0') AS RealisasiBulanBerjalan, 
ROUND(A.Denda * D.G2SPRT, 0), 
ISNULL(B.Amount,'0') AS BakiDebet, 
ROUND(ISNULL(B.OriginalAmount,'0'),0) AS NilaiDalamMataUangAsal, 
A.KodeKolektibilitas, 
A.TanggalMacet, 
A.KodeSebabMacet, 
A.TunggakanPokok, 
A.TunggakanBunga, 
A.JumlahHariTunggakan, 
A.FrekuensiTunggakan, 
A.FrekuensiRestrukturisasi, 
A.TanggalRestrukturisasiAwal, 
A.TanggalRestrukturisasiAkhir, 
A.KodeCaraRestrukturisasi, 
A.KodeKondisi, 
A.TanggalKondisi, 
A.Keterangan, 
A.KodeKantorCabang, 
A.OperasiData
FROM #Facility A 
LEFT JOIN #SumOfBakiDebet B ON A.NomorAkadAwal = B.NoAkadAwal AND A.CustomerID = B.CustomerID AND A.NomorRekeningFasilitas = B.NomorRekeningFasilitas 
LEFT JOIN #SumOfRealisasi C ON A.NomorAkadAwal = C.NoAkadAwal AND A.CustomerID = C.CustomerID AND A.NomorRekeningFasilitas = C.NomorRekeningFasilitas 
LEFT JOIN #CURRENCY D ON d.G2CYCD = A.KodeValuta
WHERE A.StatusBMI = '5. Opened' AND A.RowNo = 1 

UNION

--Kredit dengan Status Completion Notified dan expiry date = bulan pelaporan dan Baki Debet > 0
SELECT
A.Bulan,
A.Tahun,
RIGHT(A.CIF, 6),
A.CustomerName,
A.CANumber,
A.FlagDetail,
A.NomorRekeningFasilitas,
A.CIF,
A.KodeSifatKredit,
A.KodeJenisKredit,
A.KodeAkadPembiayaan,
A.NomorAkadAwal,
A.TanggalAkadAwal,
A.NomorAkadAkhir,
A.TanggalAkadAkhir,
A.BaruAtauPerpanjangan,
A.TanggalAwalKredit,
A.TanggalMulai,
A.TanggalJatuhTempo,
A.KodeKategoriDebitur,
A.KodeJenisPenggunaan,
A.KodeOrientasiPenggunaan,
A.KodeSektorEkonomi,
A.KodeDATI2,
A.NilaiProyek,
A.KodeValuta,
A.ProsentaseSukuBunga,
A.JenisSukuBunga,
A.KreditProgramPemerintah,
A.TakeOverDari,
A.SumberDana,
A.PlafonAwal,
A.Plafon,
ISNULL(C.Amount,'0') AS RealisasiBulanBerjalan,
ROUND(A.Denda * D.G2SPRT, 0),
ISNULL(B.Amount,'0') AS BakiDebet,
ROUND(ISNULL(B.OriginalAmount,'0'), 0) AS NilaiDalamMataUangAsal,
A.KodeKolektibilitas,
A.TanggalMacet,
A.KodeSebabMacet,
A.TunggakanPokok,
A.TunggakanBunga,
A.JumlahHariTunggakan,
A.FrekuensiTunggakan,
A.FrekuensiRestrukturisasi,
A.TanggalRestrukturisasiAwal,
A.TanggalRestrukturisasiAkhir,
A.KodeCaraRestrukturisasi,
A.KodeKondisi,
A.TanggalKondisi,
A.Keterangan,
A.KodeKantorCabang,
A.OperasiData
FROM #Facility A
LEFT JOIN #SumOfBakiDebet B ON A.NomorAkadAwal = B.NoAkadAwal AND A.CustomerID = B.CustomerID AND A.NomorRekeningFasilitas = B.NomorRekeningFasilitas
LEFT JOIN #SumOfRealisasi C ON A.NomorAkadAwal = C.NoAkadAwal AND A.CustomerID = C.CustomerID AND A.NomorRekeningFasilitas = C.NomorRekeningFasilitas
LEFT JOIN #CURRENCY D ON d.G2CYCD = A.KodeValuta
WHERE A.StatusBMI = '6. Completion Notified' AND MONTH(ExpiryDate) = MONTH(@PERIOD) AND YEAR(ExpiryDate) = YEAR(@PERIOD) AND A.RowNo = 1 AND ISNULL(B.Amount,'0') > 0

UNION

--Kredit dengan Status Completion Notified dan bulan dari expiry date < bulan pelaporan dan Baki Debet > 0
SELECT
A.Bulan,
A.Tahun,
RIGHT(A.CIF, 6),
A.CustomerName,
A.CANumber,
A.FlagDetail,
A.NomorRekeningFasilitas,
A.CIF,
A.KodeSifatKredit,
A.KodeJenisKredit,
A.KodeAkadPembiayaan,
A.NomorAkadAwal,
A.TanggalAkadAwal,
A.NomorAkadAkhir,
A.TanggalAkadAkhir,
A.BaruAtauPerpanjangan,
A.TanggalAwalKredit,
A.TanggalMulai,
A.TanggalJatuhTempo,
A.KodeKategoriDebitur,
A.KodeJenisPenggunaan,
A.KodeOrientasiPenggunaan,
A.KodeSektorEkonomi,
A.KodeDATI2,
A.NilaiProyek,
A.KodeValuta,
A.ProsentaseSukuBunga,
A.JenisSukuBunga,
A.KreditProgramPemerintah,
A.TakeOverDari,
A.SumberDana,
A.PlafonAwal,
A.Plafon,
ISNULL(C.Amount,'0') AS RealisasiBulanBerjalan,
ROUND(A.Denda * D.G2SPRT, 0),
ISNULL(B.Amount,'0') AS BakiDebet,
ROUND(ISNULL(B.OriginalAmount,'0'),0) AS NilaiDalamMataUangAsal,
A.KodeKolektibilitas,
A.TanggalMacet,
A.KodeSebabMacet,
A.TunggakanPokok,
A.TunggakanBunga,
A.JumlahHariTunggakan,
A.FrekuensiTunggakan,
A.FrekuensiRestrukturisasi,
A.TanggalRestrukturisasiAwal,
A.TanggalRestrukturisasiAkhir,
A.KodeCaraRestrukturisasi,
A.KodeKondisi,
A.TanggalKondisi,
A.Keterangan,
A.KodeKantorCabang,
A.OperasiData
FROM #Facility A
INNER JOIN #SumOfBakiDebet B ON A.NomorAkadAwal = B.NoAkadAwal AND A.CustomerID = B.CustomerID AND B.Amount > 0 AND A.NomorRekeningFasilitas = B.NomorRekeningFasilitas
LEFT JOIN #SumOfRealisasi C ON A.NomorAkadAwal = C.NoAkadAwal AND A.CustomerID = C.CustomerID AND A.NomorRekeningFasilitas = C.NomorRekeningFasilitas
LEFT JOIN #CURRENCY D ON d.G2CYCD = A.KodeValuta
WHERE A.StatusBMI = '6. Completion Notified' AND DATEDIFF(MONTH, ExpiryDate, @PERIOD) > 0 AND A.RowNo = 1 AND ISNULL(B.Amount,'0') > 0

UNION

--Kredit IBD dengan Status Opened (Baki Debet boleh kosong)
SELECT 
A.Bulan, 
A.Tahun, 
RIGHT(A.CIF, 6),
A.CustomerName,
A.CANumber,
A.FlagDetail, 
A.NomorRekeningFasilitas, 
A.CIF, 
A.KodeSifatKredit, 
A.KodeJenisKredit, 
A.KodeAkadPembiayaan, 
A.NomorAkadAwal, 
A.TanggalAkadAwal, 
A.NomorAkadAkhir, 
A.TanggalAkadAkhir, 
A.BaruAtauPerpanjangan, 
A.TanggalAwalKredit, 
A.TanggalMulai, 
A.TanggalJatuhTempo, 
A.KodeKategoriDebitur, 
A.KodeJenisPenggunaan, 
A.KodeOrientasiPenggunaan, 
A.KodeSektorEkonomi, 
A.KodeDATI2, 
A.NilaiProyek, 
A.KodeValuta, 
ISNULL(B.SukuBunga, '0') AS ProsentaseSukuBunga, 
A.JenisSukuBunga, 
A.KreditProgramPemerintah, 
A.TakeOverDari, 
A.SumberDana, 
A.PlafonAwal, 
A.Plafon, 
0 AS RealisasiBulanBerjalan, 
0 AS Denda, 
ISNULL(B.Amount,'0') AS BakiDebet, 
ROUND(ISNULL(B.OriginalAmount,'0'),0) AS NilaiDalamMataUangAsal, 
A.KodeKolektibilitas, 
A.TanggalMacet, 
A.KodeSebabMacet, 
A.TunggakanPokok, 
A.TunggakanBunga, 
A.JumlahHariTunggakan, 
A.FrekuensiTunggakan, 
A.FrekuensiRestrukturisasi, 
A.TanggalRestrukturisasiAwal, 
A.TanggalRestrukturisasiAkhir, 
A.KodeCaraRestrukturisasi, 
A.KodeKondisi, 
A.TanggalKondisi, 
A.Keterangan, 
A.KodeKantorCabang, 
A.OperasiData
FROM #FacilityIBD A 
LEFT JOIN #SumOfBakiDebetTR B ON A.CustomerID = B.CustomerID 
LEFT JOIN #CURRENCY D ON d.G2CYCD = A.KodeValuta
WHERE A.StatusBMI = '5. Opened' AND A.RowNo = 1 

UNION

--Kredit IBD dengan Status Completion Notified dan expiry date = bulan pelaporan dan Baki Debet > 0
SELECT 
A.Bulan, 
A.Tahun, 
RIGHT(A.CIF, 6),
A.CustomerName,
A.CANumber,
A.FlagDetail, 
A.NomorRekeningFasilitas, 
A.CIF, 
A.KodeSifatKredit, 
A.KodeJenisKredit, 
A.KodeAkadPembiayaan, 
A.NomorAkadAwal, 
A.TanggalAkadAwal, 
A.NomorAkadAkhir, 
A.TanggalAkadAkhir, 
A.BaruAtauPerpanjangan, 
A.TanggalAwalKredit, 
A.TanggalMulai, 
A.TanggalJatuhTempo, 
A.KodeKategoriDebitur, 
A.KodeJenisPenggunaan, 
A.KodeOrientasiPenggunaan, 
A.KodeSektorEkonomi, 
A.KodeDATI2, 
A.NilaiProyek, 
A.KodeValuta, 
ISNULL(B.SukuBunga, '0') AS ProsentaseSukuBunga, 
A.JenisSukuBunga, 
A.KreditProgramPemerintah, 
A.TakeOverDari, 
A.SumberDana, 
A.PlafonAwal, 
A.Plafon, 
0 AS RealisasiBulanBerjalan, 
0 AS Denda, 
ISNULL(B.Amount,'0') AS BakiDebet, 
ROUND(ISNULL(B.OriginalAmount,'0'),0) AS NilaiDalamMataUangAsal, 
A.KodeKolektibilitas, 
A.TanggalMacet, 
A.KodeSebabMacet, 
A.TunggakanPokok, 
A.TunggakanBunga, 
A.JumlahHariTunggakan, 
A.FrekuensiTunggakan, 
A.FrekuensiRestrukturisasi, 
A.TanggalRestrukturisasiAwal, 
A.TanggalRestrukturisasiAkhir, 
A.KodeCaraRestrukturisasi, 
A.KodeKondisi, 
A.TanggalKondisi, 
A.Keterangan, 
A.KodeKantorCabang, 
A.OperasiData
FROM #FacilityIBD A 
LEFT JOIN #SumOfBakiDebetTR B ON A.CustomerID = B.CustomerID 
LEFT JOIN #CURRENCY D ON d.G2CYCD = A.KodeValuta
WHERE A.StatusBMI = '6. Completion Notified' AND MONTH(ExpiryDate) = MONTH(@PERIOD) AND YEAR(ExpiryDate) = YEAR(@PERIOD) AND A.RowNo = 1 AND ISNULL(B.Amount,'0') > 0 

UNION

--Kredit IBD dengan Status Completion Notified dan bulan dari expiry date < bulan pelaporan dan Baki Debet > 0
SELECT 
A.Bulan, 
A.Tahun, 
RIGHT(A.CIF, 6),
A.CustomerName,
A.CANumber,
A.FlagDetail, 
A.NomorRekeningFasilitas, 
A.CIF, 
A.KodeSifatKredit, 
A.KodeJenisKredit, 
A.KodeAkadPembiayaan, 
A.NomorAkadAwal, 
A.TanggalAkadAwal, 
A.NomorAkadAkhir, 
A.TanggalAkadAkhir, 
A.BaruAtauPerpanjangan, 
A.TanggalAwalKredit, 
A.TanggalMulai, 
A.TanggalJatuhTempo, 
A.KodeKategoriDebitur, 
A.KodeJenisPenggunaan, 
A.KodeOrientasiPenggunaan, 
A.KodeSektorEkonomi, 
A.KodeDATI2, 
A.NilaiProyek, 
A.KodeValuta, 
ISNULL(B.SukuBunga, '0') AS ProsentaseSukuBunga, 
A.JenisSukuBunga, 
A.KreditProgramPemerintah, 
A.TakeOverDari, 
A.SumberDana, 
A.PlafonAwal, 
A.Plafon, 
0 AS RealisasiBulanBerjalan, 
0 AS Denda, 
ISNULL(B.Amount,'0') AS BakiDebet, 
ROUND(ISNULL(B.OriginalAmount,'0'),0) AS NilaiDalamMataUangAsal, 
A.KodeKolektibilitas, 
A.TanggalMacet, 
A.KodeSebabMacet, 
A.TunggakanPokok, 
A.TunggakanBunga, 
A.JumlahHariTunggakan, 
A.FrekuensiTunggakan, 
A.FrekuensiRestrukturisasi, 
A.TanggalRestrukturisasiAwal, 
A.TanggalRestrukturisasiAkhir, 
A.KodeCaraRestrukturisasi, 
A.KodeKondisi, 
A.TanggalKondisi, 
A.Keterangan, 
A.KodeKantorCabang, 
A.OperasiData
FROM #FacilityIBD A 
LEFT JOIN #SumOfBakiDebetTR B ON A.CustomerID = B.CustomerID 
LEFT JOIN #CURRENCY D ON d.G2CYCD = A.KodeValuta
WHERE A.StatusBMI = '6. Completion Notified' AND DATEDIFF(MONTH, ExpiryDate, @PERIOD) > 0 AND A.RowNo = 1 AND ISNULL(B.Amount,'0') > 0

--Get and Add the Amount of Previous CA's Baki Debet 
--0913 = TR Transactions
UPDATE A SET A.BakiDebet = A.BakiDebet + C.Amount, NilaiDalamMataUangAsal = A.NilaiDalamMataUangAsal + ROUND(ISNULL(C.OriginalAmount,'0'),0)
FROM TrxSLIKKredit A
INNER JOIN #FACILITY B ON A.NomorRekeningFasilitas = B.NomorRekeningFasilitas
INNER JOIN #SumOfBakiDebet C ON '1' + RIGHT(B.PREVCANUM,7) + RIGHT(A.NomorRekeningFasilitas,10) = C.NomorRekeningFasilitas
WHERE RIGHT(A.NomorRekeningFasilitas,4) <> '0913' and ISNULL(B.PREVCANUM,'') <> '' AND ISNULL(RIGHT(B.PREVCANUM,7) ,'') <> ISNULL(SUBSTRING(B.NomorRekeningFasilitas,2,7),'')
AND A.Bulan = MONTH(@PERIOD) and A.Tahun = YEAR(@PERIOD)

--0913 = TR Transactions
--Get and Add the Amount of Previous CA's Realisasi 
UPDATE A SET RealisasiBulanBerjalan = a.RealisasiBulanBerjalan + C.Amount
FROM TrxSLIKKredit A
INNER JOIN #FACILITY B ON A.NomorRekeningFasilitas = B.NomorRekeningFasilitas
INNER JOIN #SumOfRealisasi C ON '1' + RIGHT(B.PREVCANUM,7) + RIGHT(A.NomorRekeningFasilitas,10) = C.NomorRekeningFasilitas
WHERE RIGHT(A.NomorRekeningFasilitas,4) <> '0913' and ISNULL(B.PREVCANUM,'') <> '' AND ISNULL(RIGHT(B.PREVCANUM,7) ,'') <> ISNULL(SUBSTRING(B.NomorRekeningFasilitas,2,7),'')
AND A.Bulan = MONTH(@PERIOD) and A.Tahun = YEAR(@PERIOD)

UPDATE A 
SET A.OperasiData = 'U' 
FROM TrxSLIKKredit A 
INNER JOIN TrxSLIKKredit B 
ON A.NomorRekeningFasilitas = B.NomorRekeningFasilitas 
WHERE A.Bulan = MONTH(@PERIOD) AND A.Tahun = YEAR(@PERIOD) AND 
B.Bulan = MONTH(@PREVDATE) AND B.Tahun = YEAR(@PREVDATE)

UPDATE A 
SET A.OperasiData = 'U' 
FROM TrxSLIKKredit A 
INNER JOIN TrxSLIKKredit B 
ON A.NomorRekeningFasilitas = B.NomorRekeningFasilitas 
WHERE A.Bulan = MONTH(@PERIOD) AND A.Tahun = YEAR(@PERIOD) AND 
B.Bulan = MONTH(@PREVDATE) AND B.Tahun = YEAR(@PREVDATE)

INSERT INTO TrxSLIKKredit
SELECT MONTH(@PERIOD), YEAR(@PERIOD), CustomerID, CustomerName, CANumber, FlagDetail, NomorRekeningFasilitas, CIF,
       KodeSifatKredit, KodeJenisKredit, KodeAkadPembiayaan, NomorAkadAwal, TanggalAkadAwal,
       NomorAkadAkhir, TanggalAkadAkhir, BaruAtauPerpanjangan, TanggalAwalKredit, TanggalMulai,
       TanggalJatuhTempo, KodeKategoriDebitur, KodeJenisPenggunaan, KodeOrientasiPenggunaan, KodeSektorEkonomi,
       KodeDATI2, NilaiProyek, KodeValuta, ProsentaseSukuBunga, JenisSukuBunga,
       KreditProgramPemerintah, TakeOverDari, SumberDana, PlafonAwal, 0,
       0, Denda, 0, 0, 1,
       TanggalMacet, KodeSebabMacet, TunggakanPokok, TunggakanBunga, JumlahHariTunggakan,
       FrekuensiTunggakan, FrekuensiRestrukturisasi, TanggalRestrukturisasiAwal, TanggalRestrukturisasiAkhir, KodeCaraRestrukturisasi,
       '02', @PERIOD, Keterangan, KodeKantorCabang, 'U',
       NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL
FROM TrxSLIKKredit
WHERE bulan = MONTH(@PREVDATE) AND tahun = YEAR(@PREVDATE) AND KodeKondisi = '00' AND Flag <> '4' AND
NomorRekeningFasilitas NOT IN (SELECT NomorRekeningFasilitas
                            FROM TrxSLIKKredit
                            WHERE bulan = MONTH(@PERIOD) AND tahun = YEAR(@PERIOD))

UPDATE A 
SET A.KodeKondisi = '02' 
FROM TrxSLIKKredit A 
INNER JOIN #FACILITY B ON A.NomorRekeningFasilitas = B.NomorRekeningFasilitas
WHERE A.Bulan = MONTH(@PERIOD) AND A.Tahun = YEAR(@PERIOD) AND 
MONTH(B.TerminationDate) = MONTH(@PERIOD) AND YEAR(B.TerminationDate) = YEAR(@PERIOD) 

UPDATE A
SET OperasiData = 'D'
FROM TrxSLIKPenjamin A
INNER JOIN TrxSLIKKredit B ON B.NomorRekeningFasilitas = A.NomorRekeningFasilitas
WHERE A.Bulan = MONTH(@PERIOD) AND A.Tahun = YEAR(@PERIOD) AND
B.Bulan = MONTH(@PERIOD) AND B.Tahun = YEAR(@PERIOD) AND B.KodeKondisi = '02'

UPDATE A SET CIF = 'CR' + B.DefaultCustomerID
from TrxSLIKKredit A
INNER JOIN MasterSLIKDefaultCustomer B
ON A.CIF = 'CR' + B.CustomerID
where A.bulan = MONTH(@PERIOD) AND A.Tahun = YEAR(@PERIOD)

UPDATE TrxSLIKKredit SET NilaiDalamMataUangAsal = 0
WHERE bulan = MONTH(@PERIOD) AND Tahun = YEAR(@PERIOD) AND KodeValuta = 'IDR'

UPDATE TrxSLIKKredit SET Flag = 0
WHERE bulan = MONTH(@PERIOD) AND Tahun = YEAR(@PERIOD) AND ISNULL(flag,'') = '' 
