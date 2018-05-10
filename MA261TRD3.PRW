#INCLUDE "Protheus.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NOVO5     º Autor ³ AP6 IDE            º Data ³  23/02/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Codigo gerado pelo AP6 IDE.                                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function MA261TRD3

Local _aArea  := GetArea()
Local _aRecD3 := ParamIxb[1]
Local nT      := 0
Local _aProdGer := {}
Local _lReimp := IIF(Type('lReimpTR') # 'U', lReimpTR, .F.)
Local _lContinua := .F.
If FunName() $ "FBMATA261" .OR. _lReimp  // Transferencia
	If !_lReimp
		_nPosSub := aScan(aHeader,{|x| AllTrim(x[2])=="_cDestSub"})
		If _nPosSub > 0 .and. !Empty(aCols[1][_nPosSub])
			_lContinua := .t.
		Endif
	Else
		_lContinua := .t.
	Endif
	If _lContinua .and. Len(_aRecD3) > 0
		For nT:=1 to Len(_aRecD3)
			For nR:=1 to Len(_aRecD3[nT])
				_nRegDE4 := _aRecD3[nT,nR]
				dbSelectArea("SD3")
				dbGoto(_nRegDE4)
				If SD3->D3_CF == "DE4"
					If !_lReimp
						RecLock("SD3",.F.)
						Replace D3_HRPROD with time()
						MsUnLock()
					Endif
					_cCodDest := SD3->D3_COD
					_cLocDest := SD3->D3_LOCAL
					_cLote    := SD3->D3_LOTECTL
					_cNumLote := SD3->D3_NUMLOTE
					_nQuant   := SD3->D3_QUANT
					_nQtdSeg  := SD3->D3_QTSEGUM
					_dEmiss   := SD3->D3_EMISSAO
					_cHora    := SD3->D3_HRPROD
					_cTipo    := SD3->D3_TIPO
					_nPos 	  := aScan(_aProdGer,{|x| x[1]+x[2]+x[3]+x[4] == _cCodDest+_cLocDest+_cLote+_cNumLote})
					If _nPos == 0
						aadd(_aProdGer, {_cCodDest, _cLocDest, _cLote, _cNumLote, _cHora, _nQuant, _nQtdSeg})
					Else
						_aProdGer[_nPos,6] += _nQuant
						_aProdGer[_nPos,7] += _nQtdSeg
					Endif
				Endif
			Next
		Next
		For nT:=1 to Len(_aProdGer)
			If !_lReimp
				If Substr(_aProdGer[nT,1],1,2) == "04"
					MsgInfo( OemToAnsi( "Sequencial: " + _cNumLote ) , "Identificação da Bobina" )
				Else
					MsgInfo( OemToAnsi( "Bobina Número: " + _cNumLote ) , "Identificação da Bobina" )
				Endif
			Endif
			Imp_Transf(_aProdGer[nT,1], _dEmiss, _aProdGer[nT,3], _aProdGer[nT,4], _aProdGer[nT,5], _aProdGer[nT,6], _aProdGer[nT,7])
		Next
	Endif
Endif
RestArea(_aArea)
Return

*---------------------------------------------------------------------------------------------------------------
Static Function Imp_Transf(_cCodDest, _dEmiss, _cLote, _cNumLote, _cHora, _nQuant, _nQtdSeg)
*---------------------------------------------------------------------------------------------------------------
Local _cFila := u_FB_FilaImp()
If !Empty(_cFila)
	If CB5SetImp(_cFila,.T.)
		If Substr(_cCodDest,1,2) == "04"
			u_FB_Etiq(_cCodDest, _dEmiss, " "    , _cLote, _cNumLote, _nQuant, " "    , _nQtdSeg, " " , _cFila, PadR(SuperGetMV("FB_RECPA",.F.,"90000"),Len(SH1->H1_CODIGO)),.F.,1,_cHora)
		Else
			u_FB_Etiq1(_cCodDest, _dEmiss, " ", _cLote, _cNumLote, _nQuant," ", _nQtdSeg, " ", _cFila, " ", .f.,1,_cHora, "AG"+_cNumLote)
		Endif
	Endif
Endif
Return
