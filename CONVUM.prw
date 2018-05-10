#INCLUDE "Protheus.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  CONVUM     º Autor ³ Ricardo Rotta      º Data ³  19/09/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Ponto de entrada na rotina de Conversão de Unidade de Medida±±
±±º          ³ Tratamento o PV para faturar na 2o unidade de medida       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Fiabesa                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function CONVUM
//		nValPe:=ExecBlock("CONVUM",.F.,.F.,{nQtd1,nQtd2,nUnid,nBack})
Static nToler1UM
Static nToler2UM

Local _nQtd1 := ParamIxb[1]
Local _nQtd2 := ParamIxb[2]
Local _nUnid := ParamIxb[3]
Local _nBack := ParamIxb[4]
Local _cCod	 := SB1->B1_COD
Local _nConv := SB1->B1_XCONV
Local nPosLoTCTL:= 12	//Lote de Controle
Local nPosNLOTE	:= 13	//Numero do Lote
Local nPosLOCOri:= 4	//Armazem Origem
Local nPosQTSEG	:= 17	//Quantidade na 2a. Unidade de Medida
Local _lContinua := .F.

nToler1UM := QtdComp(If(ValType(nToler1UM) == "N",nToler1UM,GetMV("MV_NTOL1UM")))
nToler2UM := QtdComp(If(ValType(nToler2UM) == "N",nToler2UM,GetMV("MV_NTOL2UM")))

If Funname() $ "FBMATA261/MATA240/MATA410"
	_lContinua := .T.
Endif

If Type("_lAptRF") == "L" .and. _lAptRF
	_lContinua := .T.
Endif

If Funname() == "MATA241" .and. !Empty(CTM) .and. CTM < "500"
	_lContinua := .T.
Endif

If _lContinua

	If (B1_CONV = 0 .and. _nConv > 0)
		If Funname() $ "FBMATA261/MATA240"
			If Funname() $ "FBMATA261"
				_cLocal   := aCols[n,nPosLOCOri]
				_cLoteCtl := aCols[n,nPosLoTCTL]
				_cNumLote := aCols[n,nPosNLOTE]
			Else
				_cLocal   := M->D3_LOCAL
				_cLoteCtl := M->D3_LOTECTL
				_cNumLote := M->D3_NUMLOTE
			Endif
			dbSelectArea("SB8")
			dbSetOrder(2)
			If dbSeek(xFilial()+_cNumLote+_cLoteCtl+_cCod+_cLocal)
				If SB8->B8_SALDO > 0
					If ( SB1->B1_TIPCONV != "D" )
						_nConv := (SB8->B8_SALDO2 / SB8->B8_SALDO)
					Else
						_nConv := (SB8->B8_SALDO / SB8->B8_SALDO2)
					Endif
				Else
					If ( SB1->B1_TIPCONV != "D" )
						_nConv := (_nQtd2 / _nQtd1)
					Else
						_nConv := (_nQtd1 / _nQtd2)
					Endif
				Endif
			Endif
		Endif
		If ( SB1->B1_TIPCONV != "D" )
			If ( _nUnid == 1 )
				_nBack := ROUND((_nQtd2 / _nConv), TAMSX3("B2_QATU")[2])
				If nToler1UM > QtdComp(0) .And. ABS(QtdComp(_nBack-_nQtd1)) <= nToler1UM
					_nBack:=_nQtd1
				EndIf
			Else
				_nBack := ROUND((_nQtd1 * _nConv), TAMSX3("B2_QATU")[2])
				If nToler2UM > QtdComp(0) .And. ABS(QtdComp(_nBack-_nQtd2)) <= nToler2UM
					_nBack:=_nQtd2
				EndIf
			EndIf
		Else
			If ( _nUnid == 1 )
				_nBack := ROUND((_nQtd2 * _nConv), TAMSX3("B2_QATU")[2])
				If nToler1UM > QtdComp(0) .And. ABS(QtdComp(_nBack-_nQtd1)) <= nToler1UM
					_nBack:=_nQtd1
				EndIf
			Else
				_nBack := ROUND((_nQtd1 / _nConv), TAMSX3("B2_QATU")[2])
				If nToler2UM > QtdComp(0) .And. ABS(QtdComp(_nBack-_nQtd2)) <= nToler2UM
					_nBack:=_nQtd2
				EndIf
			EndIf
		EndIf
	EndIf
Endif
Return(_nBack)