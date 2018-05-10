#INCLUDE "Protheus.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  CADRATINV  บ Autor ณ Ricardo Rotta      บ Data ณ  24/04/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Tela para manuten็ใo dos itens a serem rateados nas OPs    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6 IDE                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function CADRATINV

Local lRet	  := .T.
Local aCores  := { {"EMPTY(ZB7_STATUS)","BR_VERDE"},{"!EMPTY(ZB7_STATUS)","BR_VERMELHO"} }
Local cFiltro := ""

PRIVATE aRotina := MenuDef()
PRIVATE cCadastro := OemToAnsi("Digita็ใo do Inventแrio para ratear")

mBrowse( 6, 1,22,75,"ZB7",,,,,,aCores,,,,,,,,IIF(!Empty(cFiltro),cFiltro, NIL))

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCADRATINV บAutor  ณMicrosiga           บ Data ณ  04/24/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function CADRAT_A(cAlias,nReg,nOpc)

Local aCposEn    := Nil
Local aPosObj    := {}
Local aObjects   := {}
Local aSize      := MsAdvSize()
Local oGetDad
Local oDlg
Local nPos       := 0
Local nUsado     := 0
Local nCntFor    := 0
Local nOpcA      := 0
Local nPItem     := 0
Local nSaveSx8   := 0
Local cSeek  	 := Nil
Local cWhile 	 := Nil
Local aYesFields:= {"ZB7_COD","ZB7_DESC", "ZB7_LOCAL", "ZB7_QUANT","ZB7_QTSEGU","ZB7_LOTECT","ZB7_NUMLOT","ZB7_DTVALI", "ZB7_LOCALI"}
Local cTudoOk := "AllwaysTrue"
Local bOk     := &("{|| "+cTudoOk+"}")
Local lF3     := .F.
Local lVirtual:= .F.
Local _nModo       := GD_UPDATE+GD_INSERT+GD_DELETE
Local cLinhaOk     := "u_VldRatlOk()"
Local cCampoOk     := "AllwaysTrue"
Local cApagaOk     := "AllwaysTrue"
Local cApagaNOk		:= "AllwaysFalse"
Local cIniCpos     := ""
Local cSuperApagar := ""
Local nFreeze      := nil
Local nMax         := 999999
Local aAlter       := {"ZB7_COD","ZB7_QUANT","ZB7_QTSEGU","ZB7_LOTECT","ZB7_NUMLOT","ZB7_DTVALI", "ZB7_LOCALI"}
Local aButtons   := {}
Local nUsado    := 0
Local _cIdenti, nY
Local _cCampos := "ZB7_DOC/ZB7_DATA/ZB7_DTINI/ZB7_DTFIM"
Local _aCampos := {}
Local nT := 1
Local _lAtuCp := .t.
Local cSeek 	:= xFilial("ZB7")+ZB7->ZB7_DOC
Local bWhile 	:= {|| ZB7->(ZB7_FILIAL+ZB7_DOC)}
Local bFor	 	:= {|| .T.}
Local nRecPos	:= 0

Private aHeader := {}
Private aCols 	:= {}
PRIVATE nRegD3

Private aTELA[0][0],aGETS[0]

Set Key VK_F4 TO ShowF4()

aAcho := {}
dbSelectArea("SX3")
dbSetOrder(1)  //
dbSeek("ZB7")
While !Eof() .And. (x3_arquivo == "ZB7")
	If X3USO(x3_usado) .And. AllTrim(x3_campo) $ _cCampos
		AADD(aAcho,AllTrim(x3_campo))
	EndIf
	dbSkip()
End

aAdd( aButtons, {,{|| u_SelProdI()},"Seleciona Produto"} )

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณMontagem da Variaveis de Memoria                      ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
dbSelectArea("ZB7")
dbSetOrder(1)

nOpcx := nOpc

If nOpcx == 5
	If !Empty(ZB7->ZB7_STATUS)
		Help(" ",1,"F_AJUST",,"Inventario processado, nใo poderแ ser excluido.",4,,,,,,.F.)
		Return
	Endif
Endif

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Inicializa desta forma para criar uma nova instancia de variaveis private ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If nOpcx <> 3
	_nModo := IIf(nOpcx==4,_nModo,0)
	RegToMemory("ZB7",.F., .F. )
Else
	RegToMemory( "ZB7", .T., .F. )
Endif

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Montagem do aHeader e aCols                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณFillGetDados( nOpcx, cAlias, nOrder, cSeekKey, bSeekWhile, uSeekFor, aNoFields, aYesFields, lOnlyYes,       ณ
//ณ				  cQuery, bMountFile, lInclui )                                                                ณ
//ณnOpcx			- Opcao (inclusao, exclusao, etc).                                                         ณ
//ณcAlias		- Alias da tabela referente aos itens                                                          ณ
//ณnOrder		- Ordem do SINDEX                                                                              ณ
//ณcSeekKey		- Chave de pesquisa                                                                            ณ
//ณbSeekWhile	- Loop na tabela cAlias                                                                        ณ
//ณuSeekFor		- Valida cada registro da tabela cAlias (retornar .T. para considerar e .F. para desconsiderar ณ
//ณ				  o registro)                                                                                  ณ
//ณaNoFields	- Array com nome dos campos que serao excluidos na montagem do aHeader                         ณ
//ณaYesFields	- Array com nome dos campos que serao incluidos na montagem do aHeader                         ณ
//ณlOnlyYes		- Flag indicando se considera somente os campos declarados no aYesFields + campos do usuario   ณ
//ณcQuery		- Query para filtro da tabela cAlias (se for TOP e cQuery estiver preenchido, desconsidera     ณ
//ณ	           parametros cSeekKey e bSeekWhiele)                                                              ณ
//ณbMountFile	- Preenchimento do aCols pelo usuario (aHeader e aCols ja estarao criados)                     ณ
//ณlInclui		- Se inclusao passar .T. para qua aCols seja incializada com 1 linha em branco                 ณ
//ณaHeaderAux	-                                                                                              ณ
//ณaColsAux		-                                                                                              ณ
//ณbAfterCols	- Bloco executado apos inclusao de cada linha no aCols                                         ณ
//ณbBeforeCols	- Bloco executado antes da inclusao de cada linha no aCols                                     ณ
//ณbAfterHeader -                                                                                              ณ
//ณcAliasQry	- Alias para a Query                                                                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
//	FillGetDados(nOPc,"SC6",1,cSeek,bWhile,{{bCond,bAction1,bAction2}},aNoFields,/*aYesFields*/,/*lOnlyYes*/,cQuery,/*bMontCols*/,.F.,/*aHeaderAux*/,/*aColsAux*/,{|| AfterCols(cArqQry) },/*bBeforeCols*/,/*bAfterHeader*/,"SC6")

FillGetDados(nOpc,"ZB7",3,cSeek,bWhile,bFor,/*aNoFields*/,aYesFields,,,,nOpc==3)

nRecPos	:= GdFieldPos( "ZB7_REC_WT", AHeader )
aObjects := {}

aInfo:={aSize[1],aSize[2],aSize[3],aSize[4],3,2}

AADD(aObjects,{100,045,.T.,.F.})
AADD(aObjects,{100,100,.T.,.T.})
aPosObj := MsObjSize(aInfo, aObjects)

DEFINE MSDIALOG oDlg TITLE cCadastro From aSize[7],00 To aSize[6],aSize[5] OF oMainWnd PIXEL

EnChoice( cAlias ,nReg, nOpcx, , , , aAcho, APOSOBJ[1],aCposEn, 3 ,,, cTudoOk)

oGtd0 := MsNewGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],_nModo,cLinhaOk,cTudoOk,cIniCpos,aAlter,nFreeze,nMax,cCampoOk,cSuperApagar,cApagaOk,,aHeader,aCols)

ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{||nOpcA := 1,If(Obrigatorio(aGets,aTela),If(!oGtd0:TudoOk(),nOpcA := 0,oDlg:End()),nOpcA := 0)},    {||oDlg:End()},,aButtons)
If nOpca == 1
	If __lSX8 .and. nOpc == 3
		ConfirmSX8()
	Endif
	dbSelectArea("ZB7")
	If nOpc == 3 .or. nOpc == 4
		For nI:=1 to Len(oGtd0:aCols)
			If !oGtd0:aCols[nI][Len(aHeader)+1]
				If nRecPos > 0
					If oGtd0:aCols[nI][nRecPos] > 0  // Registro existe
						ZB7->(dbGoTo(oGtd0:aCols[nI][nRecPos]))
						RecLock("ZB7",.F.)
					Else
						RecLock("ZB7",.T.)
					Endif
					Replace ZB7_FILIAL with xFilial("ZB7")
					Replace ZB7_DOC    with M->ZB7_DOC
					Replace ZB7_DTINI  with M->ZB7_DTINI
					Replace ZB7_DTFIM  with M->ZB7_DTFIM
					Replace ZB7_DATA   with M->ZB7_DATA
					For nY = 1 to Len(aHeader)
						If aHeader[nY][10] # "V"
							cVar := Trim(aHeader[nY][2])
							Replace &cVar With oGtd0:aCols[nI][nY]
						Endif
					Next nY
					MsUnLock("ZB7")
				Endif
			Else
				If nOpc == 4
					If nRecPos > 0
						If oGtd0:aCols[nI][nRecPos] > 0  // Registro existe
							ZB7->(dbGoTo(oGtd0:aCols[nI][nRecPos]))
							RecLock("ZB7",.F.)
							dbDelete()
							MsUnLock()
						Endif
					Endif
				Endif
			Endif
		Next
	ElseIf nOpc == 5 // Excluir
		If MsgYesNo("Confirma a exclusใo de todo o Documento ?","Confirma Exclusใo")
			dbSelectArea("ZB7")
			dbSetOrder(3)
			dbSeek(xFilial()+M->ZB7_DOC)
			While !Eof() .and. xFilial("ZB7")+M->ZB7_DOC == ZB7->(ZB7_FILIAL+ZB7_DOC)
				RecLock("ZB7",.F.)
				dbDelete()
				MsUnLock()
				dbSkip()
			End
		Endif
	Endif
Else
	If __lSX8 .and. nOpc == 3
		RollBackSx8()
	Endif
Endif
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCADRATINV บAutor  ณMicrosiga           บ Data ณ  04/25/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function VldRatlOk(nLinha)

Local _lRet := .t.
Local _aArea	:= GetArea()
Local _aAreaB8	:= SB8->(GetArea())
Local _aAreaBF	:= SBF->(GetArea())
Local nCodPos	:= GdFieldPos( "ZB7_COD", oGtd0:AHeader )
Local nLocPos	:= GdFieldPos( "ZB7_LOCAL", oGtd0:AHeader )
Local nQtdPos	:= GdFieldPos( "ZB7_QUANT", oGtd0:AHeader )
Local nSegPos	:= GdFieldPos( "ZB7_QTSEGU", oGtd0:AHeader )
Local nLotPos	:= GdFieldPos( "ZB7_LOTECT", oGtd0:AHeader )
Local nNumPos	:= GdFieldPos( "ZB7_NUMLOT", oGtd0:AHeader )
Local nEndPos	:= GdFieldPos( "ZB7_LOCALI", oGtd0:AHeader )
Local nDesPos	:= GdFieldPos( "ZB7_DESC", oGtd0:AHeader )
Local nDtVPos	:= GdFieldPos( "ZB7_DTVALI", oGtd0:AHeader )
Local nAliPos	:= GdFieldPos( "ZB7_ALI_WT", oGtd0:AHeader )
Local nRecPos	:= GdFieldPos( "ZB7_REC_WT", oGtd0:AHeader )
Local cProdEst
Default nLinha  := n

cProdEst  := oGtd0:aCols[nLinha,nCodPos]

If !aCols[nLinha][Len(oGtd0:aHeader)+1]
	If Localiza(cProdEst)
		If Empty(oGtd0:aCols[nLinha,nEndPos])
			Help(" ",1,"F_RINFEND",,"Produto controla endere็o, informar o endere็o",4,,,,,,.F.)
			_lRet := .f.
		Endif
	Endif
	If _lRet .and. Rastro(cProdEst)
		If Empty(oGtd0:aCols[nLinha,nLotPos])
			Help(" ",1,"F_RINFLOT",,"Produto controla Lote, informar o Lote",4,,,,,,.F.)
			_lRet := .f.
		Endif
		If _lRet .and. Rastro(cProdEst,"S")
			If Empty(oGtd0:aCols[nLinha,nLotPos])
				Help(" ",1,"F_RINFSUB",,"Produto controla SubLote, informar o SubLote",4,,,,,,.F.)
				_lRet := .f.
			Endif
		Endif
		If _lRet .and. Rastro(cProdEst)
			dbSelectArea("SB8")
			dbSetOrder(3)
			If !dbSeek(xFilial()+cProdEst+oGtd0:aCols[nLinha,nLocPos]+oGtd0:aCols[nLinha,nLotPos]+oGtd0:aCols[nLinha,nNumPos])
				Help(" ",1,"F_RLTNEXI",,"Lote informado nใo movimentado para esse produto nesse almoxarifado",4,,,,,,.F.)
				_lRet := .f.
			Endif
		Endif
		If _lRet .and. Localiza(cProdEst)
			dbSelectArea("SBF")
			dbSetOrder(2)
			If !dbSeek(xFilial()+cProdEst+oGtd0:aCols[nLinha,nLocPos]+oGtd0:aCols[nLinha,nLotPos]+oGtd0:aCols[nLinha,nNumPos])
				Help(" ",1,"F_RENNEXI",,"Endereco informado nใo movimentado para esse produto nesse almoxarifado",4,,,,,,.F.)
				_lRet := .f.
			Endif
		Endif
	Endif
Endif
RestArea(_aAreaB8)
RestArea(_aAreaBF)
RestArea(_aArea)
Return(_lRet)
	
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCADRATINV บAutor  ณMicrosiga           บ Data ณ  04/24/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function SelProdI()

Local lOk      := .F.
Local oDlg
Local _aArea	:= GetArea()
Local cDesc    := Criavar("B1_DESC",.F.)
Local cDescAte := Criavar("B1_DESC",.F.)
Local cProdEst := Criavar("D3_COD",.F.)
Local cProdAte := Criavar("D3_COD",.F.)
Local _cLocal  := GETMV("MV_XALMPRD")
Local _nUltAcols := Len(oGtd0:aCols)
Local _dDataInv := M->ZB7_DTFIM
Local aVetor 	:= {}
Local nCodPos	:= GdFieldPos( "ZB7_COD", oGtd0:AHeader )
Local nLocPos	:= GdFieldPos( "ZB7_LOCAL", oGtd0:AHeader )
Local nQtdPos	:= GdFieldPos( "ZB7_QUANT", oGtd0:AHeader )
Local nSegPos	:= GdFieldPos( "ZB7_QTSEGU", oGtd0:AHeader )
Local nLotPos	:= GdFieldPos( "ZB7_LOTECT", oGtd0:AHeader )
Local nNumPos	:= GdFieldPos( "ZB7_NUMLOT", oGtd0:AHeader )
Local nEndPos	:= GdFieldPos( "ZB7_LOCALI", oGtd0:AHeader )
Local nDesPos	:= GdFieldPos( "ZB7_DESC", oGtd0:AHeader )
Local nDtVPos	:= GdFieldPos( "ZB7_DTVALI", oGtd0:AHeader )
Local nAliPos	:= GdFieldPos( "ZB7_ALI_WT", oGtd0:AHeader )
Local nRecPos	:= GdFieldPos( "ZB7_REC_WT", oGtd0:AHeader )
Local cPerg     := "CADRATINV"
Local aStru     := {}
Local aCampos	:= {}
Local aSaldo	:= {}
Local cMarcaW   := GetMark()
Local aSize		:= {}
Local aInfo		:= {}
Local aPosObj	:= {}
Local aObjects	:= {}
Local aButtons:={}
Local lRetorno := .F.
Local bOk    :={|| lRetorno:=.T.,oDlg:End()}
Local bCancel:={|| lRetorno:=.F.,oDlg:End()}
Private lInverte  := .F.

If Empty(_dDataInv)
	Help(" ",1,"F_DTINV",,"Informar o periodo final do inventario",4,,,,,,.F.)
	Return
Endif
MBPERG(cPerg)
If Pergunte(cPerg,.T.)

	aAdd(aStru,{"WRB_OK" 	,"C",2,0})
	aAdd(aStru,{"PRODUTO"	,"C",Tamsx3("D3_COD")[1],0})
	aAdd(aStru,{"DESCR"		,"C",50,0})
	aAdd(aStru,{"UNID"		,"C",Tamsx3("D3_UM")[1],0})
	aAdd(aStru,{"LOTE"		,"C",Tamsx3("B8_LOTECTL")[1],0})
	aAdd(aStru,{"SUBLOTE"	,"C",Tamsx3("B8_NUMLOTE")[1],0})
	aAdd(aStru,{"QUANT"		,"N",Tamsx3("D3_QUANT")[1],Tamsx3("D3_QUANT")[2]})
	aAdd(aStru,{"QTDSEG"	,"N",Tamsx3("D3_QTSEGUM")[1],Tamsx3("D3_QTSEGUM")[2]})
	aAdd(aStru,{"DTVALID"	,"D",08,0})


	aCampos:={}
	AADD(aCampos,{"WRB_OK","","Marca","@!"})
	AADD(aCampos,{"PRODUTO","","Produto","@!"})
	AADD(aCampos,{"DESCR","","Descricao","@!"})
	AADD(aCampos,{"UNID" ,,AvSx3("B1_UM",5)  ,AvSx3("B1_UM",6)})
	AADD(aCampos,{"LOTE","","Lote","@!"})
	AADD(aCampos,{"SUBLOTE","","SubLote","@!"})
	AADD(aCampos,{"QUANT" ,,AvSx3("D3_QUANT",5)  ,AvSx3("D3_QUANT",6)})
	AADD(aCampos,{"QTDSEG" ,,AvSx3("D3_QTSEGUM",5)  ,AvSx3("D3_QTSEGUM",6)})

	cNometrb := CriaTrab(aStru)
	USE &cNometrb ALIAS TRB NEW EXCLUSIVE
	IndRegua("TRB",cNometrb+OrdBagExt(),"PRODUTO+LOTE+SUBLOTE")
	cProdEst := mv_par01
	cProdAte := mv_par02
	_cTpIni  := mv_par03
	_cTpAte  := mv_par04
	_cGrIni  := mv_par05
	_cGrAte  := mv_par06
	_nSldMen := mv_par07
	_lZera   := mv_par08 == 2
	_cQuery := "SELECT B2_COD, B2_LOCAL, B2_QATU, B2_QTSEGUM FROM " + RetSqlName("SB2") + " SB2, " + RetSqlName("SB1") + " SB1 "
	_cQuery += "WHERE B2_FILIAL = '"+xFilial("SB2")+"'"
	_cQuery += " AND B2_COD >= '"+cProdEst+"'"
	_cQuery += " AND B2_COD <= '"+cProdAte+"'"
	_cQuery += " AND B2_LOCAL = '"+_cLocal+"'"
	_cQuery += " AND SB2.D_E_L_E_T_ = ' '"
	_cQuery += " AND B2_COD = B1_COD"
	_cQuery += " AND B1_TIPO >= '"+_cTpIni+"'"
	_cQuery += " AND B1_TIPO <= '"+_cTpAte+"'"
	_cQuery += " AND B1_GRUPO >= '"+_cGrIni+"'"
	_cQuery += " AND B1_GRUPO <= '"+_cGrAte+"'"
	_cQuery += " AND B1_FILIAL = '"+xFilial("SB1")+"'"
	_cQuery += " AND SB1.D_E_L_E_T_ = ' '"
	_cArqQry:= GetNextAlias()
	_cQuery := ChangeQuery(_cQuery)
	dbUseArea(.T.,"TOPCONN",TCGenQry(,,_cQuery),_cArqQry,.F.,.T.)
	dbSelectArea(_cArqQry)
	While !Eof()
		_cCodProd := (_cArqQry)->B2_COD
		_cLocal   := (_cArqQry)->B2_LOCAL
		If Rastro(_cCodProd) .Or. Localiza(_cCodProd)
			aSaldo := SldPorLote(_cCodProd ,_cLocal,99999999999999999999,99999999999999999999,NIL,NIL,NIL,NIL,NIL,.T., _cLocal,NIL,NIL,NIL,_dDataInv+1)
			For nT:=1 to Len(aSaldo)
				If aSaldo[nT,5] > 0
					If _nSldMen > 0 .and. aSaldo[nT,5] > _nSldMen
						Loop
					Endif
					dbSelectArea("SB8")
					dbSetOrder(3)
					dbSeek(xFilial()+_cCodProd+_cLocal+aSaldo[nT,1]+aSaldo[nT,2])
					_dValid := SB8->B8_DTVALID
					dbSelectArea("TRB")
					RecLock("TRB",.T.)
					Replace PRODUTO with _cCodProd,;
							DESCR with Posicione("SB1",1,xFilial("SB1")+_cCodProd,"B1_DESC"),;
							UNID with Posicione("SB1",1,xFilial("SB1")+_cCodProd,"B1_UM"),;
							LOTE with aSaldo[nT,1],;
							SUBLOTE with aSaldo[nT,2],;
							QUANT with aSaldo[nT,5],;
							QTDSEG with aSaldo[nT,6],;
							DTVALID with _dValid
					MsUnLock()
				Endif
			Next
		Else
			aSaldo := CalcEst(_cCodProd,_cLocal,_dDataInv+1)
			If aSaldo[1] > 0
				If _nSldMen > 0 .and. aSaldo[1] > _nSldMen
					dbSelectArea(_cArqQry)
					dbSkip()
					Loop
				Endif
				dbSelectArea("TRB")
				RecLock("TRB",.T.)
				Replace PRODUTO with _cCodProd,;
						DESCR with Posicione("SB1",1,xFilial("SB1")+_cCodProd,"B1_DESC"),;
						UNID with Posicione("SB1",1,xFilial("SB1")+_cCodProd,"B1_UM"),;
						QUANT with aSaldo[1],;
						QTDSEG with aSaldo[7]
				MsUnLock()
			Endif
		Endif
		dbSelectArea(_cArqQry)
		dbSkip()
	End

	dbSelectArea("TRB")
	dbGotop()
	If !Eof() .and. !Bof()
		aSize := MsAdvSize()
		aObjects := {}
		AAdd( aObjects, { 100, 100, .T., .t. } )
		aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
		aPosObj := MsObjSize( aInfo, aObjects )
		
		DEFINE MSDIALOG oDlg TITLE "Selecionar Itens para Inventario" FROM aSize[7],0 TO aSize[6],aSize[5] OF oMainWnd PIXEL

		oBrwTrb:=MsSelect():New("TRB","WRB_OK","",aCampos,@lInverte,@cMarcaW,{aPosObj[1,1],aPosObj[1,2],aPosObj[1,3],aPosObj[1,4]})
		oBrwTrb:oBrowse:lHasMark := .T.
		oBrwTrb:oBrowse:lCanAllMark:=.T.
		oBrwTrb:oBrowse:bAllMark := {|| MarkAll ("TRB", cMarcaW, @oDlg, @oBrwTrb)}
		
		Activate MsDialog oDlg On Init (EnchoiceBar(oDlg,bOk,bCancel,,aButtons)) Centered
	Endif
	If lRetorno
		dbSelectArea("TRB")
		dbGotop()
		While !Eof()
			If !Empty(WRB_OK)
				If !Empty(oGtd0:aCols[_nUltAcols,1])
					aadd(oGtd0:aCols,Array(Len(aHeader)+1))
					_nUltAcols := Len(oGtd0:aCols)
					oGtd0:aCols[_nUltAcols,Len(aHeader)+1] := .F.
				Endif
				oGtd0:aCols[Len(oGtd0:aCols)][nCodPos] := TRB->PRODUTO
				oGtd0:aCols[Len(oGtd0:aCols)][nDesPos] := Posicione("SB1",1,xFilial("SB1")+TRB->PRODUTO, "B1_DESC")
				oGtd0:aCols[Len(oGtd0:aCols)][nLocPos] := _cLocal
				If _lZera
					oGtd0:aCols[Len(oGtd0:aCols)][nQtdPos] := 0
					oGtd0:aCols[Len(oGtd0:aCols)][nSegPos] := 0
				Else
					oGtd0:aCols[Len(oGtd0:aCols)][nQtdPos] := TRB->QUANT
					oGtd0:aCols[Len(oGtd0:aCols)][nSegPos] := TRB->QTDSEG
				Endif
				oGtd0:aCols[Len(oGtd0:aCols)][nLotPos] := TRB->LOTE
				oGtd0:aCols[Len(oGtd0:aCols)][nNumPos] := TRB->SUBLOTE
				oGtd0:aCols[Len(oGtd0:aCols)][nDtVPos] := TRB->DTVALID
				If nAliPos > 0
					oGtd0:aCols[Len(oGtd0:aCols)][nAliPos] := "ZB7"
				Endif
				If nRecPos > 0
					oGtd0:aCols[Len(oGtd0:aCols)][nRecPos] := 0
				Endif
			Endif
			dbSelectArea("TRB")
			dbSkip()
		End
	Endif
	dbSelectArea("TRB")
	dbCloseArea()
	dbSelectArea(_cArqQry)
	dbCloseArea()
Endif
RestArea(_aArea)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCADRATINV บAutor  ณMicrosiga           บ Data ณ  04/24/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function VldProdRat(cProdEst, cDesc)

Local _lRet := .t.
If !Empty(cProdEst) .And. ExistCpo("SB1",cProdEst)
	cDesc := Posicione("SB1",1,xFilial("SB1")+cProdEst,"B1_DESC")
Else
	_lRet := .f.
Endif
Return(_lRet)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCADRATINV บAutor  ณMicrosiga           บ Data ณ  04/25/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function VldRastRT

Local _lRet := .t.
Local _aArea  := GetArea()
Local _aAreaB8  := SB8->(GetArea())
Local _cCampo := AllTrim(Upper(ReadVar()))
Local nCodPos	:= GdFieldPos( "ZB7_COD", oGtd0:AHeader )
Local nLocPos	:= GdFieldPos( "ZB7_LOCAL", oGtd0:AHeader )
Local nSubPos	:= GdFieldPos( "ZB7_NUMLOT", oGtd0:AHeader )
Local nLotPos	:= GdFieldPos( "ZB7_LOTECT", oGtd0:AHeader )
Local _cConteudo := &_cCampo

If !Empty(_cConteudo)
	If _cCampo $ 'M->ZB7_NUMLOT๚M->ZB7_LOTECT'
		If Rastro(oGtd0:aCols[n,nCodPos])
			If Rastro(oGtd0:aCols[n,nCodPos],"S")
				If _cCampo == 'M->ZB7_NUMLOT'
					dbSelectArea("SB8")
					dbSetOrder(2)
					If dbSeek(xFilial()+M->ZB7_NUMLOT)
						_lRet := .f.
						While !Eof() .and. xFilial("SB8")+M->ZB7_NUMLOT == SB8->(B8_FILIAL+B8_NUMLOTE)
							If SB8->B8_PRODUTO == oGtd0:aCols[n,nCodPos] .and. SB8->B8_LOCAL == oGtd0:aCols[n,nLocPos]
								_lRet := .t.
								Exit
							Endif
							dbSkip()
						End
						If !_lRet
							Help(" ",1,"F_RNUMNEX",,"SubLote informado nใo encontrado para esse produto nesse almoxarifado",4,,,,,,.F.)
						Endif
					Else
						Help(" ",1,"F_RNUMNEX",,"SubLote nใo existe",4,,,,,,.F.)
						_lRet := .f.
					Endif
					nAscan := aScan(oGtd0:aCols,{|x| x[nSubPos]==M->ZB7_NUMLOT})
					If nAscan > 0
						Help(" ",1,"F_RLOTINF",,"SubLote ja informado",4,,,,,,.F.)
						_lRet := .f.
					Endif
				Endif
			Else
				If _cCampo == 'M->ZB7_LOTECT'
					dbSelectArea("SB8")
					dbSetOrder(3)
					If !dbSeek(xFilial()+oGtd0:aCols[n,nCodPos]+oGtd0:aCols[n,nLocPos]+M->ZB7_LOTECT)
						Help(" ",1,"F_RLOTNEX",,"Lote informado nใo encontrado para esse produto nesse almoxarifado",4,,,,,,.F.)
						_lRet := .f.
					Endif
					nAscan := aScan(oGtd0:aCols,{|x| x[nCodPos]+x[nLocPos]+x[nLotPos]==oGtd0:aCols[n,nCodPos]+oGtd0:aCols[n,nLocPos]+M->ZB7_LOTECT})
					If nAscan > 0
						Help(" ",1,"F_RLOTINF",,"Lote ja informado",4,,,,,,.F.)
						_lRet := .f.
					Endif
				Endif
			Endif

		Else
			Help(" ",1,"F_RPRDNCT",,"Produto nใo controla Rastreabilidade",4,,,,,,.F.)
			_lRet := .f.
		Endif
	Endif
	If _cCampo $ 'M->ZB7_LOCALI'
		If Localiza(oGtd0:aCols[n,nCodPos])
			dbSelectArea("SBF")
			dbSetOrder(1)
			If !dbSeek(xFilial()+oGtd0:aCols[n,nLocPos]+M->ZB7_LOCALI+oGtd0:aCols[n,nCodPos])
				Help(" ",1,"F_RENDNEX",,"Endereco informado nใo encontrado para esse produto nesse almoxarifado",4,,,,,,.F.)
				_lRet := .f.
			Endif
		Else
			Help(" ",1,"F_RPRDNENCT",,"Produto nใo controla Endere็amento",4,,,,,,.F.)
			_lRet := .f.
		Endif
	Endif
Endif
RestArea(_aAreaB8)
RestArea(_aArea)
Return(_lRet)


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณPrograma  ณMenuDef   ณ Autor ณ Fabio Alves Silva     ณ Data ณ04/10/2006ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณ Utilizacao de menu Funcional                               ณฑฑ
ฑฑณ          ณ                                                            ณฑฑ
ฑฑณ          ณ                                                            ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณRetorno   ณArray com opcoes da rotina.                                 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณParametrosณParametros do array a Rotina:                               ณฑฑ
ฑฑณ          ณ1. Nome a aparecer no cabecalho                             ณฑฑ
ฑฑณ          ณ2. Nome da Rotina associada                                 ณฑฑ
ฑฑณ          ณ3. Reservado                                                ณฑฑ
ฑฑณ          ณ4. Tipo de Transao a ser efetuada:                        ณฑฑ
ฑฑณ          ณ    1 - Pesquisa e Posiciona em um Banco de Dados           ณฑฑ
ฑฑณ          ณ    2 - Simplesmente Mostra os Campos                       ณฑฑ
ฑฑณ          ณ    3 - Inclui registros no Bancos de Dados                 ณฑฑ
ฑฑณ          ณ    4 - Altera o registro corrente                          ณฑฑ
ฑฑณ          ณ    5 - Remove o registro corrente do Banco de Dados        ณฑฑ
ฑฑณ          ณ5. Nivel de acesso                                          ณฑฑ
ฑฑณ          ณ6. Habilita Menu Funcional                                  ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ   DATA   ณ Programador   ณManutencao efetuada                         ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ          ณ               ณ                                            ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function MenuDef()

Private aRotina	:= {	{"Pesquisar"	,"AxPesqui"  	, 0, 1,0, .F.},; //"Pesquisar"
{"Visualizar"	,"u_CADRAT_A"	, 0, 2,0, nil},; //"Visualizar"
{"Incluir"		,"u_CADRAT_A"	, 0, 3,17,nil},; //"Incluir"
{"Alterar"		,"u_CADRAT_A"	, 0, 4,17,nil},; //"Alterar"
{"Excluir"		,"u_CADRAT_A"	, 0, 5,17,nil} } //"Excluir"
Return (aRotina)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFun…o    ณ SHOWF4   ณ Autor ณ Rodrigo de A. Sartorioณ Data ณ 29/11/95 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณ Chamada da funcao F4LOTE                                   ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ Uso      ณ MATA270                                                    ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ShowF4()

Local nCodPos	:= GdFieldPos( "ZB7_COD", oGtd0:AHeader )
Local nLocPos	:= GdFieldPos( "ZB7_LOCAL", oGtd0:AHeader )

If AllTrim(Upper(ReadVar())) $ 'M->ZB7_NUMLOT๚M->ZB7_LOTECT'
	F4Lote(,,," ",oGtd0:aCols[n,nCodPos],oGtd0:aCols[n,nLocPos],.F.)
ElseIf AllTrim(Upper(ReadVar())) $ 'M->ZB7_LOCALI'
	F4Localiz(,,," ",oGtd0:aCols[n,nCodPos],oGtd0:aCols[n,nLocPos])
EndIf
Return NIL
/*
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFun…o    ณA270Conv  ณ Autor ณ Eveli Morasco         ณ Data ณ 11/03/92 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณ Calcula e inicializa a quantidade principal ou secundaria  ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ Uso      ณ MATA270                                                    ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function F270Conv()

Local nEndereco,nEnd1,nEnd2,nX
Local cQual,nQuant
Local nCodPos	:= GdFieldPos( "ZB7_COD", oGtd0:AHeader )
Local nQtdPos	:= GdFieldPos( "ZB7_QUANT", oGtd0:AHeader )
Local nSegPos	:= GdFieldPos( "ZB7_QTSEGU", oGtd0:AHeader )

cQual  := Subs(ReadVar(),4,Len(ReadVar()))
dbSelectArea("SB1")
dbSeek(xFilial("SB1")+oGtd0:aCols[n,nCodPos])
If cQual == "ZB7_QUANT"
	nQuant := oGtd0:aCols[n,nSegPos] := ConvUm(B1_COD,oGtd0:aCols[n,nQtdPos],oGtd0:aCols[n,nSegPos],2)
	nEndereco := nSegPos
Else
	nQuant := oGtd0:aCols[n,nQtdPos] := ConvUm(B1_COD,oGtd0:aCols[n,nQtdPos],oGtd0:aCols[n,nSegPos],1)
	nEndereco := nQtdPos
EndIf

If nEndereco > 0 .and. nQuant > 0
	oGtd0:aCols[n,nEndereco] := nQuant
EndIf
Return .T.


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCADRATINV บAutor  ณMicrosiga           บ Data ณ  06/02/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function MBPERG(cPerg)

Local i := 0
Local j := 0
_sAlias := Alias()
dbSelectArea("SX1")
dbSetOrder(1)
cPerg := PADR(cPerg,10)
aRegs:={}

AADD(aRegs,{cPerg,"01","Do Produto" 		,"","","mv_ch1","C",15,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SB1"})
AADD(aRegs,{cPerg,"02","Ate Produto"		,"","","mv_ch2","C",15,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SB1"})
AADD(aRegs,{cPerg,"03","Do Tipo"    		,"","","mv_ch3","C",02,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","02"})
AADD(aRegs,{cPerg,"04","Ate Tipo"   		,"","","mv_ch4","C",02,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","02"})
AADD(aRegs,{cPerg,"05","Do Grupo"   		,"","","mv_ch5","C",04,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","SBM"})
AADD(aRegs,{cPerg,"06","Ate Grupo"  		,"","","mv_ch6","C",04,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","SBM"})
AADD(aRegs,{cPerg,"07","Saldo Menor que"  	,"","","mv_ch7","N",04,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"08","Zerar Saldo ?"		,"","","mv_ch8","N",01,0,0,"C","","mv_par08","Nao","Nao","Nao","","","Sim","Sim","Sim","","","","","","","","","","","","","",""})

For i:=1 to Len(aRegs)
	If !dbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Endif
		Next
		MsUnlock()
	Endif
Next
Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณIMP_ETIQ  บAutor  ณMicrosiga           บ Data ณ  05/18/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function MarkAll (cAlias, cMarca, oDlg, oMark)
Local 	nReg	:=	(cAlias)->(RecNo ())
Local	lRet	:=	.T.
	//
(cAlias)->(DbGoTop ())
DbEval ({|| (RecLock (cAlias, .F.), (cAlias)->WRB_OK := Iif (Empty ((cAlias)->WRB_OK), cMarca, " "), MsUnLock ())})
(cAlias)->(DbGoto (nReg))
//oMark:oBrowse:Refresh()
oDlg:Refresh ()
Return (lRet) 