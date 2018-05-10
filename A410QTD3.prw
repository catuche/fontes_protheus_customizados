#INCLUDE "Protheus.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  A410QTD3   º Autor ³ AP6 IDE            º Data ³  17/08/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Tratamento para 3 unidade de medida no pedido de venda     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Fiabesa                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function A410QTD3

Local nTercUM	:= &(ReadVar())
Local nPProduto := aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRODUTO"})
Local nPItem	:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_ITEM"})
Local nPUM		:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_UM"})
Local nPQtdVen  := aScan(aHeader,{|x| AllTrim(x[2])=="C6_QTDVEN"})
Local nPUnsVen  := aScan(aHeader,{|x| AllTrim(x[2])=="C6_UNSVEN"})
Local nPTerc    := aScan(aHeader,{|x| AllTrim(x[2])=="C6_XTERCEI"})
Local nPTpConv  := aScan(aHeader,{|x| AllTrim(x[2])=="C6_XTPCONV"})
Local nQtdConv  := 0
Local lGrade    := MaGrade()
Local cProduto  := ""
Local cItem	    := ""
Local lRet	 	:= .T.

If ( nTercUM != cCampo )
	_cTerc   := aCols[n][nPTerc]
	cProduto := aCols[n][nPProduto]
	cItem	 := aCols[n][nPItem]
	_cUMOrig := aCols[n][nPTerc]
	_cUMDest := aCols[n][nPUM]
	_cCodConv:= aCols[n][nPTpConv]
	If !Empty(_cTerc)
		If ( lGrade )
			MatGrdPrrf(@cProduto)
		EndIf
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Posiciona no Item atual do Pedido de Venda                              ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("SC6")
		dbSetOrder(1)
		MsSeek(xFilial("SC6")+M->C5_NUM+cItem+cProduto)
		
		nQtdConv := u_ConvTercUM(_cCodConv, _cUMOrig, _cUMDest, M->C6_XQTDV3)  // Converte quantidade da 3o Unidade para a 1o Unidade
		
		If nQtdConv > 0
			
			lRet := A410MultT("C6_QTDVEN",nQtdConv)
		
			If lRet
				aCols[n,nPQtdVen] := nQtdConv
				aCols[n,nPUnsVen] := ConvUm(aCols[n,nPProduto],nQtdConv,aCols[n,nPUnsVen],2)
			
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Nao aceita qtde. inferior `a qtde ja' faturada               ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				SC6->(dbEval({|| lRet := If(aCols[n,nPQtdVen] < SC6->C6_QTDENT,.F.,lRet)},Nil,;
				{|| 	xFilial("SC6")	==	SC6->C6_FILIAL 	.And.;
				M->C5_NUM		==	SC6->C6_NUM			.And.;
				cItem				== SC6->C6_ITEM		.And.;
				cProduto			== SC6->C6_PRODUTO },Nil,Nil,.T.))
				If ( !lRet )
					Help(" ",1,"A410PEDJFT")
				EndIf
			Endif
		Else
			lRet := .f.
		Endif
	Else
		Help(" ",1,"UNID3",,"Informe a 3o unidade de medida, antes de informar a quantidade",4,,,,,,.F.)
		lRet := .f.
	Endif	
Else
	lRet := .T.
EndIf
Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³A410QTD3  ºAutor  ³Microsiga           º Data ³  08/18/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function ConvTercUM(_cCodConv, _cUMOrig, _cUMDest, _nQtdOrig)

Local _aArea 	:= GetArea()
Local _nQtdDest := 0
Local _nDec		:= TAMSX3("C6_XQTDV3")[2]
dbSelectArea("SZ4")
dbSetOrder(1)
If dbSeek(xFilial()+_cCodConv)
	If _cUMOrig+_cUMDest == SZ4->(Z4_UNORIG+Z4_UNDEST)
		_nFator := SZ4->Z4_CONV
		_cTpConv := SZ4->Z4_TIPCONV
		If _cTpConv == "M"
			_nQtdDest := Round(_nQtdOrig * _nFator, _nDec)
		Else
			_nQtdDest := Round(_nQtdOrig / _nFator, _nDec)
		Endif
	Else
		Help(" ",1,"UNID3N",,"Codigo de conversao não confere com as unidades de medidas usada no PV",4,,,,,,.F.)
		_nQtdDest := -1
	Endif
Endif
RestArea(_aArea)
Return(_nQtdDest)