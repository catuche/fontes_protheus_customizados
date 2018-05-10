#Include 'Protheus.ch'
#include 'TopConn.ch'

User Function FNFBS003()

	Local aArea		 := GetArea()
	Local aObjects   := {}
	Local aSize      := MsAdvSize( .F. )
	Local aPosObj    := {}
	Local aInfo      := {}
	Local nOpcA      := 0
	//Local cBarra	 := Space(TamSx3("C6_LOTECTL")[1] + TamSx3("C6_NUMLOTE")[1])
	Local cBarra	 := Space(TamSx3("C6_NUMLOTE")[1])
	Local aBrowse    := {}
	Local aStruTMP   := {}
	Local cArquivo   := ""
	Local nX
	Local aSldLote	 := {}
	Local nTpLiber   := 3 //Libera sempre
	Local aLib := {.T.,.T.,.F.,.F.} //Libera sempre
	Local cAlias := GetNextAlias()
	Local nCount := 0
	
	Local lUsaVenc
	Local lInfoWms
	Local lVldDtLote := SuperGetMV("MV_VLDLOTE",.F.,.T.)
	Local lLote      := (SuperGetMv("MV_SELPLOT",.F.,"2") == "1")
	
	Private oDlgF
	Private oMarkF
	Private oRadioF
	Private oQtdSelF
	Private oPesSelF
	
	Private nQtdSelf	 := 0
	Private nQtdALibF	 := 0
	Private lSelLtNew := SuperGetMv("MV_SELTNEW",.F.,.F.)
	
	aadd(aStruTMP,{"TMP_OK","C",2,0})
	aadd(aStruTMP,{"TMP_SEQITE" ,"C",4,0})
	aadd(aStruTMP,{"TMP_SEQUEN" ,"C",TamSx3("C9_SEQUEN")[1] ,TamSx3("C9_SEQUEN")[2]})
	aadd(aStruTMP,{"TMP_PEDIDO" ,"C",TamSx3("C6_NUM")[1]    ,TamSx3("C6_NUM")[2]})
	aadd(aStruTMP,{"TMP_ITEM"   ,"C",TamSx3("C6_ITEM")[1]   ,TamSx3("C6_ITEM")[2]})
	aadd(aStruTMP,{"TMP_PRODUT ","C",TamSx3("C6_PRODUTO")[1],TamSx3("C6_PRODUTO")[2]})
	aadd(aStruTMP,{"TMP_DESC"   ,"C",TamSx3("B1_DESC")[1]   ,TamSx3("B1_DESC")[2]})
	aadd(aStruTMP,{"TMP_LOTECT" ,"C",TamSx3("C6_LOTECTL")[1],TamSx3("C6_LOTECTL")[2]})
	aadd(aStruTMP,{"TMP_NUMLOT" ,"C",TamSx3("C6_NUMLOTE")[1],TamSx3("C6_NUMLOTE")[2]})
	aadd(aStruTMP,{"TMP_LOCALI" ,"C",TamSx3("C6_LOCALIZ")[1],TamSx3("C6_LOCALIZ")[2]})
	aadd(aStruTMP,{"TMP_POTENC" ,"N",TamSx3("C6_POTENCI")[1],TamSx3("C6_POTENCI")[2]})
	aadd(aStruTMP,{"TMP_NUMSER" ,"C",TamSx3("C6_NUMSERI")[1],TamSx3("C6_NUMSERI")[2]})
	
	If lSelLtNew
		aadd(aStruTMP,{"TMP_QTDSEL" ,"N",TamSx3("C6_QTDLIB")[1] ,TamSx3("C6_QTDLIB")[2]})
	Endif
	
	aadd(aStruTMP,{"TMP_QTDLIB" ,"N",TamSx3("C6_QTDLIB")[1] ,TamSx3("C6_QTDLIB")[2]})
	aadd(aStruTMP,{"TMP_DTVALI" ,"D",TamSx3("C6_DTVALID")[1],TamSx3("C6_DTVALID")[2]})
	aadd(aStruTMP,{"RECNOSC9"   ,"N",15,0})
	
	
	aadd(aBrowse,{"TMP_OK",,""})
	aadd(aBrowse,{"TMP_SEQITE" ,,"Item"})
	aadd(aBrowse,{"TMP_SEQUEN" ,,RetTitle("C9_SEQUEN")})
	aadd(aBrowse,{"TMP_PEDIDO" ,,RetTitle("C6_NUM")})
	aadd(aBrowse,{"TMP_ITEM"   ,,RetTitle("C6_ITEM")})
	aadd(aBrowse,{"TMP_PRODUT ",,RetTitle("C6_PRODUTO")})
	aadd(aBrowse,{"TMP_DESC"   ,,RetTitle("B1_DESC")})
	aadd(aBrowse,{"TMP_LOTECT" ,,RetTitle("C6_LOTECTL")})
	aadd(aBrowse,{"TMP_NUMLOT" ,,RetTitle("C6_NUMLOTE")})
	aadd(aBrowse,{"TMP_LOCALI" ,,RetTitle("C6_LOCALIZ")})
	aadd(aBrowse,{"TMP_POTENC" ,,RetTitle("C6_POTENCI")})
	aadd(aBrowse,{"TMP_NUMSER" ,,RetTitle("C6_NUMSERI")})
	
	If lSelLtNew
		aadd(aBrowse,{"TMP_QTDSEL" ,,"Qtd. Selecionada"})
	EndIf
	
	aadd(aBrowse,{"TMP_QTDLIB" ,,RetTitle("C6_QTDLIB")})
	aadd(aBrowse,{"TMP_DTVALI" ,,RetTitle("C6_DTVALID")})
	aadd(aBrowse,{"RECNOSC9"   ,, "RECNOSC9"})
	
	IF Select(cAlias) > 0
		(cAlias)->(DbCloseArea())
	Endif
	 
	cArquivo := CriaTrab(aStruTMP,.T.)
	dbUseArea(.T.,__localDriver,cArquivo,cAlias,.F.,.F.)
	
	cQuery := " SELECT *, R_E_C_N_O_ RECNOSC9 FROM " + RetSqlName("SC9")
	cQuery += " WHERE D_E_L_E_T_ = ' ' "
	cQuery += " AND C9_FILIAL = '"+xFilial("SC9")+"'"
	cQuery += " AND C9_PEDIDO = '"+SC9->C9_PEDIDO+"' "
	cQuery += " AND C9_BLCRED = ' ' AND C9_BLWMS = ' ' " //EXIBIR OS QUE NÃO POSSUEM BLOQUEIO DE CRÉDITO OU WMS
	cQuery += " ORDER BY C9_ITEM "
	
	cQuery := ChangeQuery(cQuery)
	
	TCQUERY cQuery NEW ALIAS "XSC9"
	
	DbSelectArea("XSC9")
	XSC9->(DbGoTop())
	nCount := 0
	
	While !XSC9->(Eof())
	
		dbSelectArea("SC5")
		SC5->(dbSetOrder(1))
		SC5->(dbSeek(xFilial("SC5")+XSC9->C9_PEDIDO))
	
		dbSelectArea("SC6")
		SC6->(dbSetOrder(1))
		SC6->(dbSeek(xFilial("SC6")+XSC9->C9_PEDIDO+XSC9->C9_ITEM+XSC9->C9_PRODUTO))
		
		DbSelectArea("SC9")
		SC9->(DbSetOrder(1))
		SC9->(MsSeek(xFilial("SC9") + XSC9->C9_PEDIDO + XSC9->C9_ITEM + XSC9->C9_SEQUEN + XSC9->C9_PRODUTO))
		
		dbSelectArea("SB1")
		SB1->(dbSetOrder(1))
		SB1->(dbSeek(xFilial("SB1")+XSC9->C9_PRODUTO))
		
		dbSelectArea("SB2")
		SB2->(dbSetOrder(1))
		SB2->(MsSeek(xFilial("SB2")+XSC9->C9_PRODUTO+XSC9->C9_LOCAL))
		
		nQtdALibf += SC9->C9_QTDLIB
		
		IF Rastro(XSC9->C9_PRODUTO)
			aSldLote := {} //Limpa o Array
			
			lUsaVenc   := IIf(!Empty(XSC9->C9_LOTECTL+XSC9->C9_NUMLOTE),.T.,(SuperGetMv('MV_LOTVENC')=='S'))
			lInfoWms   := (IntDL(XSC9->C9_PRODUTO) .And. !Empty(XSC9->C9_SERVIC))
			
			aAdd(aSldLote,SldPorLote(XSC9->C9_PRODUTO,XSC9->C9_LOCAL,SaldoSb2(nil,.F.),0,Iif(lLote,Nil,XSC9->C9_LOTECTL),Iif(lLote,Nil,XSC9->C9_NUMLOTE),SC6->C6_LOCALIZ,SC6->C6_NUMSERI,NIL,NIL,NIL,lUsaVenc,,,IIf(lVldDtLote,dDataBase,Nil),lInfoWms))
			
			For nX := 1 To Len(aSldLote[1])
				nCount++
				RecLock(cAlias,.T.)
				(cAlias)->TMP_OK := ""
				(cAlias)->TMP_SEQITE := StrZero(nCount,4)
				(cAlias)->TMP_SEQUEN := XSC9->C9_SEQUEN
				(cAlias)->TMP_PEDIDO := XSC9->C9_PEDIDO
				(cAlias)->TMP_ITEM   := XSC9->C9_ITEM
				(cAlias)->TMP_PRODUT := XSC9->C9_PRODUTO
				(cAlias)->TMP_DESC   := Posicione("SB1",1,xFilial("SB1")+XSC9->C9_PRODUTO,"B1_DESC")
				(cAlias)->TMP_LOTECT := IIF(ValType(aSldLote[1][nX][01])<>"U",aSldLote[1][nX][01],"")
				(cAlias)->TMP_NUMLOT := IIF(ValType(aSldLote[1][nX][02])<>"U",aSldLote[1][nX][02],"")
				(cAlias)->TMP_LOCALI := IIF(ValType(aSldLote[1][nX][03])<>"U",aSldLote[1][nX][03],"")
				(cAlias)->TMP_NUMSER := IIF(ValType(aSldLote[1][nX][04])<>"U",aSldLote[1][nX][04],"")
				IF lSelLtNew
					(cAlias)->TMP_QTDSEL := 0
				Endif
				(cAlias)->TMP_QTDLIB := IIF(ValType(aSldLote[1][nX][05])<>"U",aSldLote[1][nX][05],0)
				(cAlias)->TMP_POTENC := IIF(ValType(aSldLote[1][nX][12])<>"U",aSldLote[1][nX][12],0)
				(cAlias)->TMP_DTVALI := IIF(ValType(aSldLote[1][nX][07])<>"U",aSldLote[1][nX][07],CtoD("  /  /    "))
				(cAlias)->RECNOSC9   := XSC9->RECNOSC9
				(cAlias)->(MsUnLock())
			Next nX
			(cAlias)->(dbGotop())
		Endif
		XSC9->(DbSkip())
	EndDo
	XSC9->(DbCloseArea())
	
	aObjects := {}
	aadd( aObjects, { 100, 030, .T., .F. } )
	aadd( aObjects, { 100, 090, .T., .T. } )
	aInfo    := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 0, 0 }
	aPosObj  := MsObjSize( aInfo, aObjects, .T. )

	DEFINE MSDIALOG oDlgF FROM aSize[7], 000 TO aSize[6], aSize[5] TITLE "Escolha de Lotes" PIXEL //"Escolha de Lotes"
	DEFINE SBUTTON FROM aPosObj[1,1]+010,aPosObj[1,4]-070 TYPE 1 ACTION (nOpcA:=1,oDlgF:End()) ENABLE OF oDlgF
	DEFINE SBUTTON FROM aPosObj[1,1]+010,aPosObj[1,4]-035 TYPE 2 ACTION (nOpcA:=2,oDlgF:End()) ENABLE OF oDlgF
	@ aPosObj[1,1],aPosObj[1,2] TO aPosObj[1,3],aPosObj[1,4] LABEL "" OF oDlgF  PIXEL
	@ aPosObj[1,1]+010,010 SAY "Qtd. do Pedido"	SIZE 46, 7 OF oDlgF PIXEL //"Qtd.neste Item"
	@ aPosObj[1,1]+010,072 SAY nQtdALibf PICTURE PesqPictQt("C9_QTDLIB",10) SIZE 53, 7 OF oDlgF PIXEL
	//@ aPosObj[1,1]+010,062 MSGET oGet1 VAR nQtdALibf	Picture PesqPictQt("C9_QTDLIB",10) Valid Positivo() SIZE 53, 7 OF oDlgF PIXEL
	
	@ aPosObj[1,1]+010,120 SAY "Qtd.Selecionada" SIZE 46, 7 OF oDlgF PIXEL 		  //"Qtd.Selecionada"
	@ aPosObj[1,1]+010,160 SAY oQtdSelF	 VAR nQtdSelf Picture PesqPictQt("C9_QTDLIB",10) SIZE 53, 7 OF oDlgF PIXEL
	
	@ aPosObj[1,1]+010,200 SAY "Código de Barras" SIZE 100, 7 OF oDlgF PIXEL
	@ aPosObj[1,1]+010,260 MSGET oGet2 VAR cBarra	Picture "@!" Valid U_CodBarra(cAlias,cBarra) .or. Vazio() SIZE 100, 7 OF oDlgF PIXEL
	
	@ aPosObj[1,1]+040,010 RADIO oRadioF VAR nTpLiber 3D SIZE 100,011 PROMPT "Libera avaliando crédito e estoque","Libera avaliando somente estoque","Libera sempre" OF oDlgF PIXEL ;
		ON CLICK (If(oRadioF:nOption==1, aLib := {.T.,.T.,.T.,.T.}, If(oRadioF:nOption==2, aLib:={.T.,.T.,.F.,.T.}, aLib:={.T.,.T.,.F.,.F.})))
	
	//@ aPosObj[1,1]+010,120 SAY "Peso" SIZE 46, 7 OF oDlgF PIXEL 		  //"Peso"
	//@ aPosObj[1,1]+010,160 SAY oPesSelF	 VAR nPesSelf Picture PesqPictQt("C9_QTDLIB",10) SIZE 53, 7 OF oDlgF PIXEL
	
	oMarkF := MsSelect():New(cAlias,"TMP_OK",Nil,aBrowse,.F.,Nil,{aPosObj[2,1]+50,aPosObj[2,2],aPosObj[2,3]-3,aPosObj[2,4]})
	oMarkF:bAVal := {|| .F.}
	
	oMarkF:oBrowse:lHasMark    := .T.
	oMarkF:oBrowse:lCanAllmark := .F.
	
	ACTIVATE MSDIALOG oDlgF VALID U_VldOk()
	
	If nOpcA == 1
		
		(cAlias)->(DbGoTop())
		
		While !(cAlias)->(Eof())
		
			IF !Empty((cAlias)->TMP_OK)
			
				Begin Transaction
				
					dbSelectArea("SC5")
					SC5->(dbSetOrder(1))
					SC5->(dbSeek(xFilial("SC5") + (cAlias)->TMP_PEDIDO))
			
					dbSelectArea("SC6")
					SC6->(dbSetOrder(1))
					SC6->(dbSeek(xFilial("SC6") + (cAlias)->TMP_PEDIDO + (cAlias)->TMP_ITEM + (cAlias)->TMP_PRODUT))
				
					DbSelectArea("SC9")
//					SC9->(DbSetOrder(1))
//					SC9->(MsSeek(xFilial("SC9") + (cAlias)->TMP_PEDIDO + (cAlias)->TMP_ITEM + (cAlias)->TMP_SEQUEN + (cAlias)->TMP_PRODUT))
					SC9->(DbGoTo((cAlias)->RECNOSC9))
				
					dbSelectArea("SB1")
					SB1->(dbSetOrder(1))
					SB1->(dbSeek(xFilial("SB1")+(cAlias)->TMP_PRODUT))
					
					dbSelectArea("SB2")
					SB2->(dbSetOrder(1))
					SB2->(MsSeek(xFilial("SB2") + SC9->C9_PRODUTO + SC9->C9_LOCAL))
				
					//Verificar a quantidade selecionada por Produto
					nVlrCred := 0
					
					//cCarga  := SC9->C9_CARGA
					//cSeqEnt := SC9->C9_SEQENT
					
					IF lSelLtNew
						nQtdNew := (cAlias)->TMP_QTDSEL
					Else
						nQtdNew := (cAlias)->TMP_QTDLIB
					Endif
					
					_cCarga  := SC9->C9_CARGA
					_cSeqcar := SC9->C9_SEQCAR
					_cSeqEnt := SC9->C9_SEQENT
				
					SC9->(A460Estorna(/*lMata410*/,/*lAtuEmp*/,@nVlrCred))
					
					RecLock("SC6",.F.)
					SC6->C6_LOTECTL := (cAlias)->TMP_LOTECT
					SC6->C6_NUMLOTE := (cAlias)->TMP_NUMLOT
					
					//-- Grava o endereco somente quando NAO ha integracao com o wms
					If	!(IntDL(SC6->C6_PRODUTO) .And. !Empty(SC6->C6_SERVIC))
						SC6->C6_LOCALIZ := (cAlias)->TMP_LOCALI
					EndIf
					
					SC6->C6_NUMSERI := (cAlias)->TMP_NUMSER
					SC6->C6_DTVALID := (cAlias)->TMP_DTVALI
					SC6->(MsUnlock())
										
					MaLibDoFat(SC6->(RecNo()),nQtdNew,aLib[1],aLib[2],aLib[3],aLib[4],.F.,.F.,/*aEmpenho*/,/*bBlock*/,/*aEmpPronto*/,/*lTrocaLot*/,/*lOkExpedicao*/,@nVlrCred,/*nQtdalib2*/)
					//nQtdNew -= iif(lSelLtNew,(cAlias)->TMP_QTDSEL,(cAlias)->TMP_QTDLIB)
					
					RecLock("SC6",.F.)
						SC6->C6_LOTECTL := ''
						SC6->C6_NUMLOTE := ''
						SC6->C6_LOCALIZ := ''
						SC6->C6_NUMSERI := ''
						SC6->C6_DTVALID := Ctod('')
					SC6->(MsUnlock())
					
					SC6->(MaLiberOk({SC9->C9_PEDIDO},.F.))
				
				End Transaction
				
				
				RecLock("SC9",.F.)
					SC9->C9_CARGA  := _cCarga
					SC9->C9_SEQCAR := _cSeqcar
					SC9->C9_SEQENT := _cSeqEnt
				SC9->(MsUnlock())
				 
			Endif
				
			(cAlias)->(DbSkip())
		EndDo
			
	EndIf
	
	DbSelectArea(cAlias)
	(cAlias)->(dbCloseArea())
	FErase(cArquivo+GetDbExtension())
	
	RestArea(aArea)

Return nQtdSelf

User Function VldOk()
	Local lRet := .T.
	
	If !(nQtdSelf >= nQtdALibf) .and. nQtdSelf > 0
		IF MsgYesNo("Quantidade do Pedido de Venda maior que a separa. Deseja CONTINUAR? ")
			nQtdALibf := nQtdSelf
		Else
			lRet := .F.
		Endif
	Endif
	
Return lRet

User Function Codbarra(cAlias,cBarra)

	Local lRet := .T.
	Local lAchou := .F.
	
	IF !Empty(oGet2:Buffer)
		DbSelectArea(cAlias)
		(cAlias)->(DbGoTop())
		
		While !(cAlias)->(Eof())
			//Verifica se o lote bipado está na tela
			//IF cBarra = (cAlias)->TMP_LOTECT + (cAlias)->TMP_NUMLOT
			IF cBarra = (cAlias)->TMP_NUMLOT
				lAchou := .T.
				IF lSelLtNew
					MarkLote(cAlias,nQtdALibF,nQtdSelF)
				Else
					//lOk := nQtdSelf>nQtdALibf
					
					RecLock(cAlias,.F.)
					//Replace TMP_OK     With IIf((cAlias)->(IsMark("TMP_OK",ThisMark(),ThisInv())).Or.lOk,"",ThisMark())
					Replace TMP_OK     With IIf((cAlias)->(IsMark("TMP_OK",ThisMark(),ThisInv())),"",ThisMark())
					IF lSelLtNew
						//Replace TMP_QTDSEL With IIf((cAlias)->(IsMark("TMP_OK",ThisMark(),ThisInv())).Or.lOk,0,(cAlias)->TMP_QTDLIB)
						Replace TMP_QTDSEL With IIf((cAlias)->(IsMark("TMP_OK",ThisMark(),ThisInv())),0,(cAlias)->TMP_QTDLIB)
					Endif
					(cAlias)->(MsUnlock())
					
					//nQtdSelf := IIf(lOk,nQtdSelf,IIf((cAlias)->(IsMark("TMP_OK",ThisMark(),ThisInv())),nQtdSelf+(cAlias)->TMP_QTDLIB,nQtdSelf-(cAlias)->TMP_QTDLIB))
					nQtdSelf := IIf((cAlias)->(IsMark("TMP_OK",ThisMark(),ThisInv())),nQtdSelf+(cAlias)->TMP_QTDLIB,nQtdSelf-(cAlias)->TMP_QTDLIB)
					
					oQtdSelF:SetText(nQtdSelf)				
				EndIf
						
				Exit
			EndIf
			
			(cAlias)->(DbSkip())
		EndDo
		DbSelectArea(cAlias)
		(cAlias)->(DbGoTop())
			
		//IF !Empty(oGet2:Buffer)
		//oGet2:Buffer := Space(TamSx3("C6_LOTECTL")[1] + TamSx3("C6_NUMLOTE")[1])
		oGet2:Buffer := Space(TamSx3("C6_NUMLOTE")[1])
			
		//oGet2:Refresh()
		oMarkF:oBrowse:Refresh()		
		//Endif

		oGet2:SetFocus()

		IF !lAchou
			MsgInfo("Lote: " + cBarra + " não encontrado!")
		Endif
	

	EndIf
Return lRet

Static Function MarkLote(cAlias,nQtdALibF,nQtdSelF)
	//Local lOk     := nQtdSelF > nQtdALibF .And. !(cAlias)->(IsMark("TMP_OK",ThisMark(),ThisInv()))
	Local lOk := .T.
	Local nQtde   := 0
	Local oDlg
	Local lMarcou := .F.

	//(cAlias)->TMP_OK := If((cAlias)->(IsMark("TMP_OK",ThisMark(),ThisInv())) .Or. lOk,"",ThisMark())
	(cAlias)->TMP_OK := If((cAlias)->(IsMark("TMP_OK",ThisMark(),ThisInv())),"",ThisMark())
	//If !lOk
		If (cAlias)->TRB_OK == ThisMark()
			nQtde := Min((cAlias)->TMP_QTDLIB,nQtdALib - nQtdSel)
			oDlg := MSDialog():New(0,0,80,155,"Qtde Selecionada",,,,,,,,oMainWnd,.T.) //-- Qtde Selecionada
			TGet():Create(oDlg,{|u| If(PCount()>0,nQtde:= u,nQtde)},5,5,70,10,PesqPict("SC6","C6_QTDLIB"),{|| MarkVldQtd(cAlias,nQtdALibF,nQtdSelF,nQtde)},,,,,,.T.,,,,,,,,,,"nQtde")
			TButton():Create(oDlg,20,5,"OK",{|| lMarcou := .T.,oDlg:End()},70,10,,,,.T.)
			oDlg:Activate(,,,.T.)
		
			If lMarcou .And. nQtde > 0
				(cAlias)->TMP_QTDSEL := nQtde
				nQtdSelF += (cAlias)->TMP_QTDSEL
			Else
				(cAlias)->TMP_OK := ""
			EndIf
		Else
			nQtdSel -= (cAlias)->TMP_QTDSEL
			(cAlias)->TMP_QTDSEL := 0
		EndIf
	//EndIf
	oQtdSelF:SetText(nQtdSelF)

Return lOk

Static Function MarkVldQtd(cAlias,nQtdALibF,nQtdSelF,nQtde)
	Local lRet

	lRet := nQtde >= 0 .And.;					//-- Qtde deve ser positiva
	nQtde <= TRB->TRB_QTDLIB .And.; 	//-- Qtde deve ser menor ou igual ao saldo do lote
	nQtde <= nQtdALib - nQtdSel			//-- Qtde deve ser menor ou igual ao saldo a selecionar

	If !lRet
		Help(" ",1,"QTDNVLD",,"Quantidade inválida. A quantidade não pode ser maior que o saldo do lote/endereço ou saldo a selecionar.",1,1) //-- Quantidade inválida. A quantidade não pode ser maior que o saldo do lote/endereço ou saldo a selecionar.
	EndIf

Return lRet

