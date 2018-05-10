#INCLUDE "rwmake.ch"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGER_MOD   บAutor  ณMicrosiga           บ Data ณ  05/19/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function Ger_MOD

Local aSay    := {}
Local aButton := {}
Local nOpc    := 0
Local cTitulo
Local cDesc1
Local cDesc2
Local cDesc3

cTitulo := "Requisicao de MODs nas OPs"
cDesc1  := "Esta rotina ira gerar requisicoes de MODs para as producoes"
cDesc2  := "de acordo com as Producoes do mes"
cDesc3  := "Especifico - Fiabesa"
_cPerg := "VERMODPRD"
Gera_SX1(_cPerg)
Pergunte(_cPerg,.F.)

aAdd( aSay, cDesc1 )
aAdd( aSay, cDesc2 )
aAdd( aSay, cDesc3 )

aAdd( aButton, { 5, .T., {|| Pergunte(_cPerg,.T. )    }} )
aAdd( aButton, { 1, .T., {|| nOpc := 1, FechaBatch() }} )
aAdd( aButton, { 2, .T., {|| FechaBatch()            }} )

FormBatch( cTitulo, aSay, aButton )
	
If nOpc <> 1
	Return Nil
Endif

Processa( {|lEnd| Gera_Req(@lEnd,_cPerg)}, "Aguarde...","Gerando requisicoes...", .T. )

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGER_MOD   บAutor  ณMicrosiga           บ Data ณ  09/11/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function Gera_Req

Local _aArea := GetArea()
Local _dUlmes := GetMv("MV_ULMES")
Local _dIni := FirstDay(mv_par01)
Local _dFim := LastDay(mv_par02)
Local bCampo := { |nCPO| Field(nCPO)}

If _dIni <> mv_par01
	Alert("A data inicial deve ser primeiro dia do mes")
	Return
Endif
If _dFim <> mv_par02
	Alert("A data final deve ser o ultimo dia do mes")
	Return
Endif

If mv_par01 > _dUlmes
	
	_cQuery := "SELECT D3_IDENT, D3_CHAVE, D3_DOC, D3_NUMSEQ, D3_TM, D3_CF, D3_OP,D3_COD,D3_QUANT, D3_UM, D3_EMISSAO ,C2_PRODUTO,B1_DESC,B1_CC, C2_CC, C2_ROTEIRO "
	_cQuery += "FROM " + RetSqlName("SD3") + " SD3," +  RetSqlName("SC2") + " SC2," + RetSqlName("SB1") + " SB1"
	_cQuery += " WHERE SD3.D3_FILIAL = '" + xFilial("SD3") + "'"
	_cQuery += " AND SD3.D3_EMISSAO >= '" + Dtos(mv_par01) + "'"
	_cQuery += " AND SD3.D3_EMISSAO <= '" + Dtos(mv_par02) + "'"
	_cQuery += " AND SD3.D3_TM = '002'"
	_cQuery += " AND SD3.D3_ESTORNO = ' '"
//	_cQuery += " AND SD3.D3_COD IN ('MOI 350914','COD350953')"
	_cQuery += " AND SD3.D3_CF = 'PR0'"
	_cQuery += " AND SD3.D_E_L_E_T_ = ' '"
	_cQuery += " AND SD3.D3_OP = SC2.C2_NUM+SC2.C2_ITEM+SC2.C2_SEQUEN"
//	_cQuery += " AND SD3.D3_OP = '03058301001'"
  	_cQuery += " AND SC2.D_E_L_E_T_ = ' '"
	_cQuery += " AND SC2.C2_FILIAL = '" + xFilial("SC2") + "'"
	_cQuery += " AND SB1.B1_COD = SC2.C2_PRODUTO"
	_cQuery += " AND SB1.B1_FILIAL = '" + xFilial("SB1") + "'"
	_cQuery += " AND SB1.D_E_L_E_T_ = ' '"
	cQuery := ChangeQuery( _cQuery )
	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'TMP', .F., .T.)
	dbSelectArea("TMP")
	While !Eof()
		_cOP := TMP->D3_OP
		_cProd := TMP->C2_PRODUTO
		_nQuant := TMP->D3_QUANT
		_cUm    := TMP->D3_UM
		_cCCOP := TMP->C2_CC
		_cCC := TMP->B1_CC
		_dEmissao := Stod(TMP->D3_EMISSAO)
		_cDoc := TMP->D3_DOC
		_cNumSeq := TMP->D3_NUMSEQ
		_cTM := "999"
		_cCF := "RE1"
		_cIdent := TMP->D3_IDENT
		_cChave := "E0"
		_cCodMOD := PADR("MOD" + Alltrim(_cCCOP),15)
		_cRoteiro := TMP->C2_ROTEIRO
		If !Empty(_cRoteiro) .and. !Empty(_cCCOP)
			dbSelectArea("SG2")
			dbSetOrder(1)
			dbSeek(xFilial()+_cProd+_cRoteiro)
			If Found()
				dbSelectArea("SB1")
				dbSeek(xFilial()+_cCodMOD)
				If !Found()
					dbSeek(xFilial()+"MOD")
					If Found()
						FOR I := 1 to FCount()
							M->&(EVAL(bCampo,I)) := FieldGet(I)
						Next I
						M->B1_COD := _cCodMOD
						M->B1_DESC := "MAO DE OBRA CC " + Alltrim(_cCC)
						M->B1_CC  := Alltrim(_cCC)
						_nOpca := AxIncluiAuto("SB1")
					Endif
				Endif
					dbSelectArea("SB1")
					cProdMod:=_cCodMOD
					dbSeek(xFilial("SB1")+cProdMod)
					If Found()
						nQtdD3   := ROUND(FBCalcTemp(_cOP, _nQuant), TAMSX3("D3_QUANT")[2])
						dbSelectArea("SB1")
						dbSeek(xFilial()+_cCodMOD)
						dbSelectArea("SD3")
						dbSetOrder(3)
						dbSeek(xFilial()+_cCodMOD+SB1->B1_LOCPAD+_cNumSeq)
						If !Found()
							RecLock("SD3",.T.)
							Replace D3_FILIAL with xFilial("SD3"),;
									D3_OP with _cOP,;
									D3_COD with _cCodMOD,;
									D3_LOCAL with SB1->B1_LOCPAD,;
									D3_EMISSAO with _dEmissao,;
									D3_TM with _cTM,;
									D3_UM with SB1->B1_UM,;
									D3_CF with _cCF,;
									D3_QUANT with nQtdD3,;
									D3_GRUPO with SB1->B1_GRUPO,;
									D3_DOC with _cDoc,;
									D3_CC with SB1->B1_CC,;
									D3_NUMSEQ with _cNumSeq,;
									D3_TIPO with SB1->B1_TIPO,;
									D3_USUARIO with Substr(cUsuario,7,15),;
									D3_IDENT with _cIdent,;
									D3_CHAVE with _cChave
							MsUnLock()
						Else
							If QtdComp(SD3->D3_QUANT) <> QtdComp(nQtdD3)
								RecLock("SD3",.F.)
								Replace D3_QUANT with nQtdD3
								MsUnLock()
							Endif
						Endif
					Endif
			Endif
		Endif
		dbSelectArea("TMP")
		dbSkip()
	End
	dbSelectArea("TMP")
	dbCloseArea()
Else
	Alert("Mes fechado!")
Endif
RestArea(_aArea)
Return 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGera_SX1  บAutor  ณMicrosiga           บ Data ณ  07/05/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Gera_SX1(_cPerg)

Local cAlias  := Alias()
Local aRegs   := {}
Local nTamSX1 := Len(SX1->X1_GRUPO)
Local i,j

dbSelectArea("SX1")
SX1->(dbSetOrder(1))

cPerg := PADR(_cPerg,nTamSX1)

// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
aAdd(aRegs,{cPerg,"01","Da Data","Data Inventario","Data Inventario","mv_ch1","D",08                  ,00,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","",""}) //"Da Data de Entrega"###"Da Data de Entrega"###"Da Data de Entrega"
aAdd(aRegs,{cPerg,"02","Ate Data","Data Inventario","Data Inventario","mv_ch1","D",08                 ,00,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","",""}) //"Da Data de Entrega"###"Da Data de Entrega"###"Da Data de Entrega"

For i:=1 to Len(aRegs)
	If SX1->(!DbSeek(cPerg+aRegs[i,2]))
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			EndIf
		Next
		MsUnlock()
	EndIf
Next
DbSelectArea(cAlias)
Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMT680VAL  บAutor  ณMicrosiga           บ Data ณ  03/08/18   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function FBCalcTemp(_cOPApt, nQuant)

Local _aArea := GetArea()
Local _cProduto, _cRoteiro
Local _cCtrab := CriaTrab("H1_CTRAB",.F.)

PRIVATE cTipoTemp := GetMV("MV_TPHR") //Usada na A690HoraCt

		nLote := If(Empty(SG2->G2_LOTEPAD),1,SG2->G2_LOTEPAD)
		nTemp := If(Empty(SG2->G2_TEMPAD),1,SG2->G2_TEMPAD)
		nTemp := A690HoraCt(nTemp)
		nAux  := nQuant

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Se tempo minimo, arredonda a sobra para completar o tempo do lote ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		If SG2->G2_TPOPER == "4"
			nAux := nAux % nLote
			nAux := Int(nQuant) + If(Empty(nAux),0,nLote - nAux)
		EndIf

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Proporcionaliza conforme tempo padra / lote padrao		 ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		If !(SG2->G2_TPOPER $ "23")
			nTemp := nAux * (nTemp / nLote)
			nMObra := Posicione("SH1",1,xFilial("SH1")+SG2->G2_RECURSO,"H1_MAOOBRA")
			If !Empty(nMObra)
				nTemp := nTemp / nMObra
			EndIf
		EndIf
		nTempPos := A690HoraCt(If(Empty(SG2->G2_FORMSTP),SG2->G2_SETUP,Formula(SG2->G2_FORMSTP)))
RestArea(_aArea)
Return(nTemp)