#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMA330TRB  บ Autor ณ Ricardo Rotta      บ Data ณ  04/11/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Ponto de entrada apos montagem do arquivo temporario utilizado
ฑฑบ          ณ no calculo do custo medio                                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6 IDE                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function MA330TRB

Local _dData
Local _aArea := GetArea()
Local _dUlmes := GetMV("MV_ULMES")
Local _cFilOri := cFilAnt
Local _cFilAnt := {}  // Variavel Utilizada no MATA330 porem nao disponivel no ponto de entrada, criei portanto esta variavel para substituir a original
Local _lPart    := IIF(a330ParamZX[21]==1,.T.,.F.)
Local _lProd    := IIF(a330ParamZX[12]>=2,.T.,.F.)
Local lLanctoOn := IIf(a330ParamZX[10] == 1,.T.,.F.)
Local _dDtDe  := _dUlmes + 1
Local _dDtAt  := a330ParamZX[1]

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta data de referencia                                            ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

dbSelectArea("TRB")
_aAreaTr := GetArea()
dbSelectArea("SM0")
_aAreaM0 := GetArea()
Processa ({||ATPART_B(_dDtDe,_dDtAt)})  // Desabilitado por ainda nใo estar em produ็ใo a mudan็a referente o custo em partes
cFilAnt := _cFilOri
RestArea(_aArea)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ ATPART_B บ Autor ณ Wilson A. da Cruz  บ Data ณ  11/07/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Atualizacao arquivo custo em partes                        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Ripasa                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function ATPART_B(_dDtDe,_dDtAt)

Local _aArea := GetArea()
Local _aPart := {}
Local _dUlmes := Getmv("MV_ULMES")

If Select("TRBPART") <> 0
	DbSelectArea("TRBPART")
	DbCloseArea("TRBPART")
Endif

DbSelectArea("PC1")
cQuery1 := "DELETE " + RetSqlName("PC1")
cQuery1 += " WHERE PC1_FILIAL = '"+xFilial("PC1")+"' "
cQuery1 += " AND PC1_DTFECH = '"+Dtos(_dDtAt)+"'"
TCSQLEXEC(cQuery1)

If  Trim(TcGetDb()) = 'ORACLE'
	_cQuery := " CREATE TABLE I1MOV AS"
	_cQuery += " SELECT CT2_CCD CC, CT1_XPARTE PARTE, SUM(CT2_VALOR) AS VALOR"
Else
	_cQuery := " SELECT CT2_CCD CC, CT1_XPARTE PARTE, SUM(CT2_VALOR) AS VALOR"
	_cQuery += " INTO I1MOV"
Endif
_cQuery += " FROM "+RetSqlName("CT2") +" CT2, "+RetSqlName("CT1")+" CT1"
_cQuery += " WHERE CT2_FILIAL = '"+xFilial("CT2")+"' 
_cQuery += " AND CT2_DATA  BETWEEN '"+Dtos(_dDtDe)+"' AND '"+Dtos(_dDtAt)+"'"
_cQuery += " AND CT1_FILIAL = '"+xFilial("CT1")+"'"
_cQuery += " AND CT1_XPARTE <> ' '"
_cQuery += " AND CT2_DEBITO = CT1_CONTA"
_cQuery += " AND CT2_MOEDLC = '01'"
_cQuery += " AND CT1.D_E_L_E_T_ = ' ' AND CT2.D_E_L_E_T_ = ' '"
_cQuery += " GROUP BY CT2_CCD, CT1_XPARTE"

_cQuery += " UNION ALL"

_cQuery += " SELECT CT2_CCC CC, CT1_XPARTE PARTE, (-1) * SUM(CT2_VALOR) AS VALOR"
_cQuery += " FROM "+RetSqlName("CT2") +" CT2, "+RetSqlName("CT1")+" CT1"
_cQuery += " WHERE CT2_FILIAL = '"+xFilial("CT2")+"' 
_cQuery += " AND CT2_DATA  BETWEEN '"+Dtos(_dDtDe)+"' AND '"+Dtos(_dDtAt)+"'"
_cQuery += " AND CT1_FILIAL = '"+xFilial("CT1")+"'"
_cQuery += " AND CT1_XPARTE <> ' '"
_cQuery += " AND CT2_MOEDLC = '01'"
_cQuery += " AND CT2_CREDIT = CT1_CONTA"
_cQuery += " AND CT1.D_E_L_E_T_ = ' ' AND CT2.D_E_L_E_T_ = ' '"
_cQuery += " GROUP BY CT2_CCC, CT1_XPARTE"
_cRetSCI := TCSQLEXEC(_cQuery)
If _cRetSCI <> 0
	_cError := TCSQLError()
Else
	_cQuery := " SELECT CC,PARTE, SUM(VALOR) MOVIMEN FROM I1MOV"
	_cQuery += " GROUP BY CC,PARTE"
	_cQuery += " ORDER BY CC,PARTE"

	_cQuery := ChangeQuery(_cQuery)
	TCQUERY _cQuery NEW ALIAS "TRBPART"

	_cQuery2 := "DROP TABLE I1MOV"
	TCSQLEXEC(_cQuery2)

	_nTotal := 0
	_nParc  := 0

	// Salva percentuais das partes da MOD
	DbSelectArea("TRBPART")
	ProcRegua(RecCount())
	While !Eof()
		_cCC := TRBPART->CC
		While _cCC == TRBPART->CC
			_cparte := TRBPART->PARTE  // Centros de custos dos PIs
			_nTotal += TRBPART->MOVIMEN
			Aadd(_aPart,{TRBPART->CC,_cparte,TRBPART->MOVIMEN})
			TRBPART->(DbSkip())
		End
		
		For _nI := 1 to Len(_aPart)
			DbSelectArea("PC1")
			RecLock("PC1",.T.)
			PC1->PC1_FILIAL := xFilial("PC1")
			PC1->PC1_DTFECH := _dDtAt
			PC1->PC1_CCUSTO  := _aPart[_nI,1]
			PC1->PC1_PARTE  := _aPart[_nI,2]
			PC1->PC1_MOVIM  := _aPart[_nI,3]
			PC1->PC1_TOTAL  := _nTotal
			If _nI == Len(_aPart)
				PC1->PC1_PERC  := 100 - _nParc
			Else
				PC1->PC1_PERC  := Round((_aPart[_nI,3] / _nTotal)*100,2)
				_nParc += Round((_aPart[_nI,3]/_nTotal)*100,2)
			Endif
			
			DbSelectArea("PC1")
			PC1->(MsUnlock())
		Next _nI
	
		_nParc  := 0
		_nTotal := 0
		_aPart  := {}
		DbSelectArea("TRBPART")
		IncProc("Atualizando custos em partes ...")
		//	TRBPART->(DbSkip())
	End

	If Select("TRBPART") <> 0
		DbSelectArea("TRBPART")
		DbCloseArea("TRBPART")
	Endif

	If Select("PART") <> 0
		DbSelectArea("PART")
		DbCloseArea("PART")
	Endif

	_cQuery := " SELECT DISTINCT PC1_PARTE"
	_cQuery += " FROM "+RetSqlName("PC1") +" PC1 "
	_cQuery += " WHERE PC1_FILIAL = '"+xFilial("PC1")+"' "
	_cQuery += " AND PC1_DTFECH = '"+Dtos(_dDtAt)+"'"
	_cQuery := ChangeQuery(_cQuery)
	TCQUERY _cQuery NEW ALIAS "PART"
	dbSelectArea("PART")
	_cTxt := ""
	While !Eof()
		_cTxt += ",D3_CP"+PART->PC1_PARTE+"01 = 0 "
		dbSkip()
	End
	
	If Select("PART") <> 0
		DbSelectArea("PART")
		DbCloseArea("PART")
	Endif
	
	cQuery2 := "UPDATE " + RetSqlName("SD3") + " SET D3_CUSTO1 = 0 " + IIF(!Empty(_cTxt),_cTxt,"")
	cQuery2 += " WHERE D3_FILIAL = '"+xFilial("D3")+"' "
	cQuery2 += " AND D3_EMISSAO > '"+Dtos(_dUlmes)+"'"
	cQuery2 += " AND D3_EMISSAO <= '"+Dtos(_dDtAt)+"'"
	cQuery2 += " AND D3_COD LIKE 'MOD%'"
	_cRetSql := TCSQLEXEC(cQuery2)
	If _cRetSql <> 0
		_cError := TCSQLError()
	Endif
Endif
RestArea(_aArea)
Return