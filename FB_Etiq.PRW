#INCLUDE "PROTHEUS.CH"
#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"   

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FB_ETIQ   ºAutor  ³Ricardo Rotta       º Data ³  03/05/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Etiqueta de producao                                       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Fiabesa                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function FB_Etiq(_cProd, _dData, _cturno, _cLote, _cSubLote, _nQtdPri, _cTara, _nQtdSeg, _cOP, _cFila, _cRecurso, _lNConf, _nEtiq, _cTime)

Local _nAjust := 0
Local nLarg  := 2
Local _aArea := GetArea()
Local _cDescPro := Alltrim(Posicione("SB1",1,xFilial("SB1")+_cProd,"B1_DESC"))
Local _nPesoL   := Alltrim(Posicione("SB1",1,xFilial("SB1")+_cProd,"B1_PESO"))
Local _cUM      := Alltrim(Posicione("SB1",1,xFilial("SB1")+_cProd,"B1_UM"))
Local _cUMSeg   := Alltrim(Posicione("SB1",1,xFilial("SB1")+_cProd,"B1_SEGUM"))
Local cPictQtd14 := PesqPict('SH6', 'H6_QTDPROD',   14)
Local _cMedida := ""
Local _cUnidPrim := _cUMSeg
Local _nPeso	:= _nQtdPri
Local _nQtdUN   := _nQtdSeg
Default _nEtiq := 1
Default _lNConf := .F.
Default _cTime := Time()
SB5->(dbSetOrder(1))
SB5->(dbSeek(xFilial("SB5")+_cProd))

If !Substr(_cProd,1,2) $ "02/05/04"
	_nEtiq := 2
Endif

If _cUMSeg == "KG"
	_cUnidPrim := _cUM
	_nPeso	:= _nQtdSeg
	_nQtdUN := _nQtdPri
Endif
If SB5->B5_COMPR > 0
	_cCompri := Alltrim(Str(SB5->B5_COMPR))
	_cLarg   := Alltrim(Str(SB5->B5_LARG))
	If !Empty(_cCompri)
		_cMedida := _cCompri + " x " + _cLarg
	Endif
Endif
For nJI:=1 to _nEtiq
	MSCBBEGIN(1,6)
	MSCBBOX(23-_nAjust,03,78-_nAjust,92)
	//		MSCBBOX(23-_nAjust,03,40-_nAjust,92)
	MSCBSAY(73-_nAjust,05,"FIABESA GUARARAPES S.A","R", "0","030,020")
	
	If !Empty(_cSubLote)
		MSCBSAY(73-_nAjust,50,"SUBLOTE","R", "0","030,020")
		MSCBSAY(73-_nAjust,62,_cSubLote,"R", "0","030,020")
	ElseIf !Empty(_cLote)
		MSCBSAY(73-_nAjust,50,"LOTE","R", "0","030,020")
		MSCBSAY(73-_nAjust,62,_cLote,"R", "0","030,020")
	Else
		MSCBSAY(73-_nAjust,50,"OP","R", "0","030,020")
		MSCBSAY(73-_nAjust,62,_cOP,"R", "0","030,020")
	Endif
	
	MSCBLineV(72-_nAjust,03,92)
	
	MSCBSAY(67-_nAjust,05,Substr(_cDescPro,1,60),"R", "0","035,025")
	MSCBLineV(66-_nAjust,03,92)
	
	MSCBSAY(61-_nAjust,05,"MEDIDAS","R", "0","030,020")
	MSCBSAY(61-_nAjust,17,_cMedida,"R", "0","030,020")
	MSCBSAY(61-_nAjust,57,"PROD:","R", "0","030,020")
	MSCBSAY(61-_nAjust,65,_cProd,"R", "0","030,020")
	MSCBLineH(60-_nAjust,56,66-_nAjust)
	MSCBLineV(60-_nAjust,03,92)
	
	MSCBSAY(55-_nAjust,05,"VALVULA","R", "0","030,020")
	MSCBLineV(54-_nAjust,03,92)
	
	MSCBSAY(49-_nAjust,05,"QTD","R", "0","030,020")
	MSCBSAY(49-_nAjust,12,Alltrim(Transform(_nQtdUN, cPictQtd14 )) + " " + _cUnidPrim,"R", "0","030,020")
	MSCBSAY(49-_nAjust,30,"PESO LIQ.(KG)","R", "0","030,020")
	MSCBSAY(49-_nAjust,46,Alltrim(Transform(_nPeso, cPictQtd14 )),"R", "0","030,020")
	MSCBSAY(49+_najust,60,DTOC(_dData),"R", "A","020,010")
	MSCBSAY(49+_najust,77,_cTime,"R", "A","020,010")
	MSCBLineH(48-_nAjust,29,54-_nAjust)
	MSCBLineH(48-_nAjust,59,54-_nAjust)
	MSCBLineV(48-_nAjust,03,92)
	If !Empty(_cSubLote)
		MSCBSAY(38-_nAjust,5,"LOTE","R", "0","030,020")
		MSCBSAY(38-_nAjust,14,_cLote,"R", "0","030,020")
		MSCBSAYBAR(34-_nAjust,40,Alltrim(_cSubLote),"R","MB02",12,.F.,.T.,.F.,,3,2)
	ElseIf !Empty(_cLote)
		MSCBSAY(38-_nAjust,5,"LOTE","R", "0","030,020")
		MSCBSAY(38-_nAjust,14,_cLote,"R", "0","030,020")
		MSCBSAYBAR(34-_nAjust,40,Alltrim(_cLote),"R","MB02",12,.F.,.T.,.F.,,3,2)
	Else
		MSCBSAY(38-_nAjust,5,"OP","R", "0","030,020")
		MSCBSAY(38-_nAjust,14,Alltrim(_cOP),"R", "0","030,020")
		MSCBSAYBAR(34-_nAjust,40,Alltrim(_cOP),"R","MB02",12,.F.,.T.,.F.,,3,2)
	Endif
	MSCBLineV(29-_nAjust,03,92)
	MSCBSAY(26-_nAjust,05,"VENDAS@FIABESA.COM.BR | WWW.FIABESA.COM.BR | +55 81 3117-2177 | RODOVIA BR-101 SUL KG 86,6 | PRAZERES","R", "0","020,010")
	MSCBSAY(24-_nAjust,05,"JAB DOS GUARARAPES | PE | CEP 54345-160","R", "0","020,010")
	MSCBEND()
Next
MSCBCLOSEPRINTER()
RestArea(_aArea)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FB_ETIQ   ºAutor  ³Microsiga           º Data ³  05/08/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function FB_Etiq1(_cProd, _dData, _cturno, _cLote, _cSubLote, _nPeso, _cTara, _nQtdSeg, _cOP, _cFila, _cRecurso, _lNConf, _nEtiq, _cTime, _cCodBar)

//Nem sempre o campo _nPeso é realmente o peso, precisa verificar o cadastro de produto para ver a unidade de medida

Local _nAjust   := 0
Local _aArea    := GetArea()
Local _cDescPro := Alltrim(Posicione("SB1",1,xFilial("SB1")+_cProd,"B1_DESC"))
Local _nPesoL   := Alltrim(Posicione("SB1",1,xFilial("SB1")+_cProd,"B1_PESO"))
Local _cUM      := Alltrim(Posicione("SB1",1,xFilial("SB1")+_cProd,"B1_UM"))
Local _cTipo    := Alltrim(Posicione("SB1",1,xFilial("SB1")+_cProd,"B1_TIPO"))
Local _cUMSeg   := Alltrim(Posicione("SB1",1,xFilial("SB1")+_cProd,"B1_SEGUM"))
Local _cDescRec := Posicione("SH1",1,xFilial("SH1")+_cRecurso,"H1_DESCRI")
Local _nLarg    := Posicione("SB5",1,xFilial("SB5")+_cProd,"B5_LARG")
Local _nM2      := _nLarg * _nQtdSeg / 100
Local _nTara    := Posicione("SZ0",1,xFilial("SZ0")+_cTara,"Z0_PESO")
Local cPictQtd14 := PesqPict('SH6', 'H6_QTDPROD',   14)
Local _cNomeFila:= Alltrim(Posicione("CB1",1,xFilial("CB1")+_cFila,"CB1_NOME"))
Local _nLarg	:= Posicione("SB5",1,xFilial("SB5")+_cProd,"B5_XLRGT")

If _cUMSeg == "KG"
	_nPesoOri := _nPeso
	_nPeso	  := _nQtdSeg
	_nQtdSeg  := _nPesoOri
Endif

Default _cTime := Time()
Default _lNConf := .F.
Default _nEtiq  := 1
Default _cCodBar := " "

If !Substr(_cProd,1,2) $ "02/05/04"
	_nEtiq := 2
Endif

For nJL:=1 to _nEtiq
	MSCBBEGIN(1,6)
	MSCBBOX(23-_nAjust,03,78-_nAjust,92)
	//		MSCBBOX(23-_nAjust,03,40-_nAjust,92)
	MSCBSAY(73-_nAjust,05,"FIABESA GUARARAPES S.A","R", "0","030,020")
	
	If !Empty(_cSubLote)
		MSCBSAY(73-_nAjust,50,"SUBLOTE","R", "0","030,020")
		MSCBSAY(73-_nAjust,62,_cSubLote,"R", "0","030,020")
	ElseIf !Empty(_cLote)
		MSCBSAY(73-_nAjust,53,"LOTE","R", "0","030,020")
		MSCBSAY(73-_nAjust,62,_cLote,"R", "0","030,020")
	ElseIf !Empty(_cOP)
		MSCBSAY(73-_nAjust,70,"OP","R", "0","030,020")
		MSCBSAY(73-_nAjust,75,_cOP,"R", "0","030,020")
	Else
		//	MSCBSAY(73-_nAjust,70,"DOC","R", "0","030,020")
		MSCBSAY(73-_nAjust,75,_cCodBar,"R", "0","030,020")
	Endif
	
	MSCBLineV(72-_nAjust,03,92)
	
	MSCBSAY(67-_nAjust,05,Substr(_cDescPro,1,60),"R", "0","035,025")
	MSCBSAY(67-_nAjust,70,"PROD:","R", "0","030,020")
	MSCBSAY(67-_nAjust,77,_cProd,"R", "0","030,020")
	
	MSCBLineV(66-_nAjust,03,92)
	
	MSCBSAY(61-_nAjust,05,"DATA REGISTRO","R", "0","030,020")
	MSCBSAY(61-_nAjust,24,DTOC(_dData),"R", "0","030,020")
	MSCBSAY(61-_nAjust,37,_cTime      ,"R", "0","030,020")
	MSCBSAY(61-_nAjust,70,"TURNO","R", "0","030,020")
	MSCBSAY(61-_nAjust,78,_cturno,"R", "0","030,020")
	MSCBLineH(60-_nAjust,68,72-_nAjust)
	MSCBLineV(60-_nAjust,03,92)
	
	//MSCBSAY(55-_nAjust,05,"OPERADOR","R", "0","030,020")
	//		MSCBSAY(55-_nAjust,18,_cNomeOpe,"R", "0","030,020")
	MSCBSAY(55-_nAjust,05,"MAQUINA","R", "0","030,020")
	MSCBSAY(55-_nAjust,16,_cDescRec,"R", "0","030,020")
	
	//MSCBLineH(54-_nAjust,36,60-_nAjust)
	MSCBLineV(54-_nAjust,03,92)
	
	MSCBSAY(49-_nAjust,05,"TARA (Kg)","R", "0","030,020")
	MSCBSAY(49-_nAjust,16,Alltrim(Transform(_nTara, cPictQtd14 )),"R", "0","030,020")
	MSCBSAY(49-_nAjust,50,"PESO LIQ.(KG)","R", "0","030,020")
	MSCBSAY(49-_nAjust,68,Alltrim(Transform(_nPeso, cPictQtd14 )),"R", "0","030,020")
	MSCBLineV(48-_nAjust,03,92)
	If _nQtdSeg > 0
		MSCBSAY(43-_nAjust,05,"Metros","R", "0","030,020")
		MSCBSAY(43-_nAjust,15,Alltrim(Transform(_nQtdSeg, cPictQtd14 )),"R", "0","030,020")
		If _nLarg > 0 .and. _cTipo == "03"
			MSCBSAY(43-_nAjust,50,"Metro Quadrado","R", "0","030,020")
			MSCBSAY(43-_nAjust,70,Alltrim(Transform(Round(_nQtdSeg * _nLarg/100,2), cPictQtd14 )),"R", "0","030,020")
		Endif
	Endif
	MSCBLineV(42-_nAjust,03,92)
	
	If !Empty(_cSubLote) .or. !Empty(_cLote)
		MSCBSAY(32-_nAjust,05,"LOTE","R", "0","030,020")
		MSCBSAY(32-_nAjust,12,_cLote,"R", "0","030,020")
	ElseIf !Empty(_cOP)
		MSCBSAY(32-_nAjust,05,"OP","R", "0","030,020")
		MSCBSAY(32-_nAjust,12,Alltrim(_cOP),"R", "0","030,020")
	Else
		//	MSCBSAY(32-_nAjust,05,"DOC","R", "0","030,020")
		MSCBSAY(32-_nAjust,05,Alltrim(_cCodBar),"R", "0","030,020")
	Endif
	If _lNConf
		MSCBSAY(32-_nAjust,40,"PRODUTO NAO CONFORME","R", "0","040,030")
	Else
		If !Empty(_cSubLote)
			MSCBSAYBAR(28-_nAjust,30,"SB"+Alltrim(_cSubLote),"R","MB02",12,.F.,.T.,.F.,,2.5,2)
		Else
			MSCBSAYBAR(28-_nAjust,30,Alltrim(_cCodBar),"R","MB02",12,.F.,.T.,.F.,,2.5,2)
		Endif
	Endif
	MSCBEND()
Next
MSCBCLOSEPRINTER()
RestArea(_aArea)
Return