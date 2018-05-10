#include 'protheus.ch'
#include 'parmtype.ch'

User function FSBR001()

	oReport := ReportDef()
	oReport:PrintDialog()

Return

Static Function ReportDef()

	Local oReport
	Local oSintetico
	Local oAnalitico
	Local cAliasQry	:= "TMP"
	Local cPerg		:= "FSBR001"

	oReport := TReport():New("","Contas a Receber",cPerg, {|oReport| ReportPrint(oReport,cAliasQry,oSintetico,oAnalitico)},"Relat�rio para imprimir todos os t�tulos que ainda est�o em aberto")
	oReport:SetLandscape(.T.)

	Pergunte(oReport:uParam,.F.)

	oSintetico := TRSection():New(oReport,"",{"SF2","SD2"},/*{Array com as ordens do relat�rio}*/,/*Campos do SX3*/,/*Campos do SIX*/)
	oSintetico:SetTotalInLine(.F.)
	TRCell():New(oSintetico,"CNOTA"		,/*Tabela*/,RetTitle("D2_DOC")		,PesqPict("SD2","D2_DOC")		,TamSX3("D2_DOC")[1]	,/*lPixel*/,{|| cNota })


	oAnalitico := TRSection():New(oReport,"",{"SF2","SD2"},/*{Array com as ordens do relat�rio}*/,/*Campos do SX3*/,/*Campos do SIX*/)
	oAnalitico:SetTotalInLine(.F.)
	TRCell():New(oAnalitico,"CNOTA"		,/*Tabela*/,RetTitle("D2_DOC")		,PesqPict("SD2","D2_DOC")		,TamSX3("D2_DOC")[1]	,/*lPixel*/,{|| cNota })


Return (oReport)

Static Function ReportPrint(oReport,cAliasQry,oSintetico,oAnalitico)
	Local cQuery 	:= ""

	cQuery += " SELECT * FROM " + RetSqlName("SE2")
	cQuery += " WHERE D_E_L_E_T_ <> '*' AND "
Return