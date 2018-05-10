#INCLUDE "Protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFB_APONTRFบAutor  ณRicardo Rotta       บ Data ณ  10/05/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Tela de manutencao dos apontamentos de refugo              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function FB_APONTRF

Local lRet	  := .T.
//Local aCores  := { {"EMPTY(ZB7_STATUS)","BR_VERDE"},{"!EMPTY(ZB7_STATUS)","BR_VERMELHO"} }
Local cFiltro := ""

PRIVATE aRotina := MenuDef()
PRIVATE cCadastro := OemToAnsi("Apontamento de Refugo")

mBrowse( 6, 1,22,75,"SZ5")
//mBrowse( 6, 1,22,75,"ZB7",,,,,,aCores,,,,,,,,IIF(!Empty(cFiltro),cFiltro, NIL))

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFB_APONTRFบAutor  ณMicrosiga           บ Data ณ  10/05/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function APTRF_A(cAlias,nReg,nOpc)

Local _lRet		 := .t.
Local aCposEn    := Nil
Local aPosObj    := {}
Local aObjects   := {}
Local aSize      := MsAdvSize()
Local aAcho		 := {}
Local cTudoOk := "AllwaysTrue"
Local aButtons   := {}
Local nOpcA		 := 0
Local cNumDoc
Local nSaveSx8   := 0

Local cSeek 	:= xFilial("SBC")+SZ5->Z5_DOC
Local bWhile 	:= {|| SBC->(BC_FILIAL+BC_XDOC)}
Local bFor	 	:= {|| .T.}
Local nRecPos	:= 0
Local aYesFields:= {"BC_DATA","BC_OP","BC_PRODUTO", "BC_LOCORIG", "BC_TIPO","BC_MOTIVO","BC_QUANT","BC_LOTECTL","BC_NUMLOTE", "BC_DTVALID", "BC_RECURSO", "BC_OPERAC"}

Local _nModo       := 0 // GD_UPDATE+GD_INSERT+GD_DELETE
Local cLinhaOk     := "AllwaysTrue"
Local cCampoOk     := "AllwaysTrue"
Local cApagaOk     := "AllwaysTrue"
Local cApagaNOk	   := "AllwaysFalse"
Local cIniCpos     := ""
Local cSuperApagar := ""
Local nFreeze      := nil
Local nMax         := 999999
Local aAlter       := {}

Private aHeader := {}
Private aCols	:= {}
Private aColsRF	:= {}
Private Inclui := .F.
Private aTELA[0][0],aGETS[0]
Private _lAptRF := .T.
Private LA185BXEMP := .f.
Private aItenSD3	:= {}

_cEstacao := GetComputerName()
_cFila    := ""

dbSelectArea("SZ1")
dbSetOrder(1)
If !dbSeek(xFilial()+Alltrim(_cEstacao))
	Alert("Cadastrar a impressora relacionada a essa esta็ใo de trabalho, fa็a o cadastro na proxima tela")
	_cFila := u_Cad_Estac(_cEstacao)
Else
	_cFila := SZ1->Z1_FILAIMP
Endif
If Empty(_cFila)
	Help(" ",1,"IMPRNES",,"Nใo encontrada impressora para essa esta็ใo de trabalho",4,,,,,,.F.)
	Return
Endif

aAcho := {}
dbSelectArea("SX3")
dbSetOrder(1)  //
dbSeek("SZ5")
While !Eof() .And. (x3_arquivo == "SZ5")
	If X3USO(x3_usado)
		AADD(aAcho,AllTrim(x3_campo))
	EndIf
	dbSkip()
End

nOpcx := nOpc

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Inicializa desta forma para criar uma nova instancia de variaveis private ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If nOpcx <> 3
	RegToMemory("SZ5",.F., .F. )
Else
	Inclui := .T.
	RegToMemory( "SZ5", .T., .F. )
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
//	FillGetDados(nOPc,"SC6",1,cSeek,bWhile,{{bCond,bAction1,bAction2}},aNoFields,/*aYesFields*/,/*lOnlyYes*/,cQuery,/*bMontCols*/,.F.,/*aHeaderAux*/,aColsRF,{|| AfterCols(cArqQry) },/*bBeforeCols*/,/*bAfterHeader*/,"SC6")

FillGetDados(nOpc,"SBC",2,cSeek,bWhile,bFor,/*aNoFields*/,aYesFields,,,,nOpc==3)

nRecPos	:= GdFieldPos( "BC_REC_WT", AHeader )
aColsRF := Aclone(aCols)

nPProd := aScan( AHeader, { |x| Alltrim(x[2])=="BC_PRODUTO" } )
nPOP   := aScan( AHeader, { |x| Alltrim(x[2])=="BC_OP" } )
nPRec  := aScan( AHeader, { |x| Alltrim(x[2])=="BC_RECURSO" } )
nPQtd  := aScan( AHeader, { |x| Alltrim(x[2])=="BC_QUANT" } )
nPMot  := aScan( AHeader, { |x| Alltrim(x[2])=="BC_MOTIVO" } )
nPTip  := aScan( AHeader, { |x| Alltrim(x[2])=="BC_TIPO" } )
nPOperac  := aScan( AHeader, { |x| Alltrim(x[2])=="BC_OPERAC" } )

aObjects := {}

aInfo:={aSize[1],aSize[2],aSize[3],aSize[4],3,2}

AADD(aObjects,{100,070,.T.,.T.})
AADD(aObjects,{100,150,.T.,.F.})

aPosObj := MsObjSize(aInfo, aObjects)

DEFINE MSDIALOG oDlg TITLE cCadastro From aSize[7],00 To aSize[6],aSize[5] OF oMainWnd PIXEL

EnChoice( cAlias ,nReg, nOpcx, , , , aAcho, APOSOBJ[1],aCposEn, 3 ,,, cTudoOk)

oGtd2 := MsNewGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],_nModo,cLinhaOk,cTudoOk,cIniCpos,aAlter,nFreeze,nMax,cCampoOk,cSuperApagar,cApagaOk,,aHeader,aColsRF)

ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{||nOpcA := 1, If((nOpcx == 2 .or. nOpcx == 5) .or. (Obrigatorio(aGets,aTela)), oDlg:End(), nOpcA:=0)}, {||oDlg:End()} ,,aButtons)

If nOpcA == 1
	If nOpcx == 3
		If __lSX8
			ConfirmSX8()
		Endif
		dbSelectArea("SZ5")
		M->Z5_HORA := TIME()
		nOpca := AxIncluiAuto("SZ5",,)
		If Len(aColsRF) > 0 .and. !Empty(aColsRF[1,nPProd])
			Processa( {|lEnd| _lRet := u_Proc_RatRF(aColsRF)}, "Aguarde...","Processando Rateio", .T. )
		Endif
	ElseIf nOpcx == 4
		Processa( {|lEnd| _lRet := Prc_ExRat()}, "Aguarde...","Processando Exclusใo do Rateio", .T. )
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
ฑฑบPrograma  ณFB_APONTRFบAutor  ณMicrosiga           บ Data ณ  10/05/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function APONTRFB

Local _aArea := GetArea()
Local _cPerg := "FB_APONTRF"

AjustaSx1(_cPerg)
If Pergunte(_cPerg,.t.)
	Processa( {|lEnd| Ger_RatRF(@lEnd)}, "Aguarde...","Processando Rateio", .T. )
Endif
RestArea(_aArea)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFB_APONTRFบAutor  ณMicrosiga           บ Data ณ  10/05/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Ger_RatRF

Local _aArea := GetArea()
Local _cQuery
Local cAliasNew := CriaTrab(NIL,.F.)
Local _aRatOP   := {}
Local _cError   := ""
Local _aCtrab	:= {}
Local _lContinua := .T.
_cQuery := "SELECT * FROM " + RetSqlName("SZ5") + " SZ5"
_cQuery += " WHERE Z5_FILIAL = '" + xFilial("SZ5") + "'"
_cQuery += " AND Z5_DOC >= '" + mv_par01 + "'"
_cQuery += " AND Z5_DOC <= '" + mv_par02 + "'"
_cQuery += " AND Z5_DATA >= '" + DTOS(mv_par03) + "'"
_cQuery += " AND Z5_DATA <= '" + DTOS(mv_par04) + "'"
_cQuery += " AND SZ5.D_E_L_E_T_ = ' '"
_cQuery += " ORDER BY Z5_DATA"
dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),cAliasNew,.T.,.T.)
aEval(SZ5->(dbStruct()), {|x| If(x[2] <> "C", TcSetField(cAliasNew,x[1],x[2],x[3],x[4]),Nil)})
dbSelectArea(cAliasNew)
While !Eof()
	_cDoc	  := (cAliasNew)->Z5_DOC
	_cRecurso := (cAliasNew)->Z5_RECURSO
	_dData	  := (cAliasNew)->Z5_DATA
	_nQtdRef  := (cAliasNew)->Z5_QTDREF
	_cCodRef  := (cAliasNew)->Z5_CODREF
	_cOperado := (cAliasNew)->Z5_OPERADO
	_aCtrab := u_FBFilRec("1",_cCodRef,  ,  , @_cError)
	If Len(_aCtrab) == 0
		Help(" ",1,"NCTRABR",,"Nao encontrado amarracao do Tipo de Residuo com o Centro de Trabalho, verificar cadastro",4,,,,,,.F.)
		_lContinua := .F.
	Endif
	If _lContinua
		_aRatOP   := u_ProcessRF(_cDoc, _aCtrab, _dData, _nQtdRef, _cCodRef)
	Endif
	dbSelectArea(cAliasNew)
	dbSkip()
End
dbSelectArea(cAliasNew)
dbCloseArea()

RestArea(_aArea)
Return	



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFB_APONTRFบAutor  ณMicrosiga           บ Data ณ  10/16/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function ProcessRF(_cDoc, _aCtrab, _dData, _nQtdRef, _cCodRef)

Local _aArea := GetArea()
Local _cQuery
Local cAliasH6  := CriaTrab(NIL,.F.)
Local _aRatOP	:= {}
Local _cTrab    := ""
Local _dDtaIni  := FirstDay(_dData)
Local _dMesAnt  := FirstDay(_dDtaIni - 1)
Local dDataFec	:= MVUlmes()
Local _lOPMesAnt := .t.
Local _lContinua := .F.
Local _cCtrabPA  := "9XXXX"  // Tratamento para Prensa
Local _lTrabPA   := ascan(_aCtrab,_cCtrabPA) > 0
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Verificar data do ultimo fechamento em SX6.                  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

If dDataFec >= _dDtaIni
	Help ( " ", 1, "FECHTO" )
	Return
EndIf

If dDataFec >= _dMesAnt
	_lOPMesAnt := .F.
EndIf

If Len(_aCtrab) > 0
	_cTrab := "("
	For nH:=1 to Len(_aCtrab)
		_cTrab += "'" + _aCtrab[nH] + "'"
		If nH < Len(_aCtrab)
			_cTrab += ","
		Endif
	Next
	_cTrab += ")"
	_cQToler := "(C2_QUANT - C2_QUJE) / C2_QUANT > 0.3"
	If _lTrabPA
		_cQuery := "SELECT D3_OP H6_OP, D3_XRECURS H6_RECURSO, D3_COD H6_PRODUTO, SUM(D3_QUANT) H6_QTDPROD"
		_cQuery += " FROM " + RetSqlName("SD3") + " SD3, " + RetSqlName("SC2") + " SC2"
		_cQuery += " WHERE D3_FILIAL = '" + xFilial("SD3") + "'"
		_cQuery += " AND D3_EMISSAO >= '" + Dtos(_dDtaIni) + "'"
		_cQuery += " AND D3_EMISSAO <= '" + Dtos(_dData) + "'"
		_cQuery += " AND D3_CF = 'PR0'"
		_cQuery += " AND D3_TIPO = '04'"
		_cQuery += " AND SD3.D_E_L_E_T_ = ' '"
		_cQuery += " AND D3_OP = C2_NUM + C2_ITEM + C2_SEQUEN + C2_ITEMGRD"
		_cQuery += " AND C2_FILIAL = '" + xFilial("SC2") + "'"
		_cQuery += " AND C2_DATRF = '" + Space(08) + "'"
		_cQuery += " AND " + _cQToler
		_cQuery += " AND SC2.D_E_L_E_T_ = ' '"
		_cQuery += " GROUP BY D3_OP, D3_XRECURS, D3_COD"
		_cQuery += " ORDER BY D3_OP, D3_XRECURS, D3_COD"
    Else
		_cQuery := "SELECT H6_OP, H6_OPERAC, H6_RECURSO, H6_PRODUTO, SUM(H6_QTDPROD) H6_QTDPROD"
		_cQuery += " FROM " + RetSqlName("SH6") + " SH6, " + RetSqlName("SH1") + " SH1, " + RetSqlName("SC2") + " SC2"
		_cQuery += " WHERE H6_FILIAL = '" + xFilial("SH6") + "'"
		_cQuery += " AND H6_RECURSO = H1_CODIGO"
		_cQuery += " AND H6_DTAPONT >= '" + Dtos(_dDtaIni) + "'"
		_cQuery += " AND H6_DTAPONT <= '" + Dtos(_dData) + "'"
		_cQuery += " AND H6_XDOCSBC = ' '"
		_cQuery += " AND SH6.D_E_L_E_T_ = ' '"
		_cQuery += " AND H1_FILIAL = '" + xFilial("SH1") + "'"
		_cQuery += " AND H1_CTRAB IN " + _cTrab
		_cQuery += " AND SH1.D_E_L_E_T_ = ' '"
		_cQuery += " AND H6_OP = C2_NUM + C2_ITEM + C2_SEQUEN + C2_ITEMGRD"
		_cQuery += " AND C2_FILIAL = '" + xFilial("SC2") + "'"
		_cQuery += " AND C2_DATRF = '" + Space(08) + "'"
		_cQuery += " AND " + _cQToler
		_cQuery += " AND SC2.D_E_L_E_T_ = ' '"
		_cQuery += " GROUP BY H6_OP, H6_OPERAC, H6_RECURSO, H6_PRODUTO"
		_cQuery += " ORDER BY H6_OP, H6_OPERAC, H6_RECURSO, H6_PRODUTO"
	Endif
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),cAliasH6,.T.,.T.)
	If _lTrabPA
		aEval(SD3->(dbStruct()), {|x| If(x[2] <> "C", TcSetField(cAliasH6,x[1],x[2],x[3],x[4]),Nil)})
	Else
		aEval(SH6->(dbStruct()), {|x| If(x[2] <> "C", TcSetField(cAliasH6,x[1],x[2],x[3],x[4]),Nil)})
	Endif
	dbSelectArea(cAliasH6)
	If Eof()
		If _lOPMesAnt
			dbSelectArea(cAliasH6)
			dbCloseArea()
			If _lTrabPA
				_cQuery := "SELECT D3_OP H6_OP, D3_XRECURS H6_RECURSO, D3_COD H6_PRODUTO, SUM(D3_QUANT) H6_QTDPROD"
				_cQuery += " FROM " + RetSqlName("SD3") + " SD3, " + RetSqlName("SC2") + " SC2"
				_cQuery += " WHERE D3_FILIAL = '" + xFilial("SD3") + "'"
				_cQuery += " AND D3_EMISSAO >= '" + Dtos(_dMesAnt) + "'"
				_cQuery += " AND D3_EMISSAO <= '" + Dtos(_dData) + "'"
				_cQuery += " AND D3_CF = 'PR0'"
				_cQuery += " AND D3_TIPO = '04'"
				_cQuery += " AND SD3.D_E_L_E_T_ = ' '"
				_cQuery += " AND D3_OP = C2_NUM + C2_ITEM + C2_SEQUEN + C2_ITEMGRD"
				_cQuery += " AND C2_FILIAL = '" + xFilial("SC2") + "'"
				_cQuery += " AND C2_DATRF = '" + Space(08) + "'"
				_cQuery += " AND " + _cQToler
				_cQuery += " AND SC2.D_E_L_E_T_ = ' '"
				_cQuery += " GROUP BY D3_OP, D3_XRECURS, D3_COD"
				_cQuery += " ORDER BY D3_OP, D3_XRECURS, D3_COD"
			Else
				_cQuery := "SELECT H6_OP, H6_OPERAC, H6_RECURSO, H6_PRODUTO, SUM(H6_QTDPROD) H6_QTDPROD"
				_cQuery += " FROM " + RetSqlName("SH6") + " SH6, " + RetSqlName("SH1") + " SH1, " + RetSqlName("SC2") + " SC2"
				_cQuery += " WHERE H6_FILIAL = '" + xFilial("SH6") + "'"
				_cQuery += " AND H6_RECURSO = H1_CODIGO"
				_cQuery += " AND H6_DTAPONT >= '" + Dtos(_dMesAnt) + "'"
				_cQuery += " AND H6_DTAPONT <= '" + Dtos(_dData) + "'"
				_cQuery += " AND H6_XDOCSBC = ' '"
				_cQuery += " AND SH6.D_E_L_E_T_ = ' '"
				_cQuery += " AND H1_FILIAL = '" + xFilial("SH1") + "'"
				_cQuery += " AND H1_CTRAB IN " + _cTrab
				_cQuery += " AND SH1.D_E_L_E_T_ = ' '"
				_cQuery += " AND H6_OP = C2_NUM + C2_ITEM + C2_SEQUEN + C2_ITEMGRD"
				_cQuery += " AND C2_FILIAL = '" + xFilial("SC2") + "'"
				_cQuery += " AND C2_DATRF = '" + Space(08) + "'"
				_cQuery += " AND " + _cQToler
				_cQuery += " AND SC2.D_E_L_E_T_ = ' '"
				_cQuery += " GROUP BY H6_OP, H6_OPERAC, H6_RECURSO, H6_PRODUTO"
				_cQuery += " ORDER BY H6_OP, H6_OPERAC, H6_RECURSO, H6_PRODUTO"
			Endif
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),cAliasH6,.T.,.T.)
			If _lTrabPA
				aEval(SD3->(dbStruct()), {|x| If(x[2] <> "C", TcSetField(cAliasH6,x[1],x[2],x[3],x[4]),Nil)})
			Else
				aEval(SH6->(dbStruct()), {|x| If(x[2] <> "C", TcSetField(cAliasH6,x[1],x[2],x[3],x[4]),Nil)})
			Endif
			dbSelectArea(cAliasH6)
			If !Eof()
				_lContinua := .t.
			Endif
		Endif
	Else
		_lContinua := .t.
	Endif
    If _lContinua
		_aTOTRatOP	:= {}
		_aRatOP	:= {}
		_nTotRec := 0
		_nTotPerc := 0
		nPos:=3
		dbSelectArea(cAliasH6)
		While !Eof()
			aadd(_aTOTRatOP, {(cAliasH6)->H6_OP ,(cAliasH6)->H6_RECURSO , (cAliasH6)->H6_PRODUTO,  (cAliasH6)->H6_QTDPROD, 0, (cAliasH6)->H6_OPERAC})
			dbSkip()
		End
		aSort( _aTOTRatOP,,, { |x,y| x[4] > y[4] } )
		For nH:=1 to Len(_aTOTRatOP)
			_nTotRec+= _aTOTRatOP[nH,4]
			If nH >= 10
				Exit
			Endif
		Next
		For nH:=1 to Len(_aTOTRatOP)
			If nH==Len(_aTOTRatOP) .or. nH >= 10
				_nPerc := 1 - _nTotPerc
			Else
				_nPerc := Round(_aTOTRatOP[nH,4] / _nTotRec,7)
				_nTotPerc+=_nPerc
			Endif
			aadd(_aRatOP, {_aTOTRatOP[nH,1] ,_aTOTRatOP[nH,2] , _aTOTRatOP[nH,3],  _aTOTRatOP[nH,4], _nPerc, _aTOTRatOP[nH,6]})
			If nH >= 10
				Exit
			Endif
		Next
		_nTotRateio := 0
		_nRateio1   := 0
		For nT:=1 to Len(_aRatOP)
			If nT == Len(_aRatOP)
				_nRateio1 := Round(_nQtdRef - _nTotRateio,TAMSX3("H6_QTDPROD")[2])
				If _nRateio1 > 0
					_aRatOP[nT,5] := _nRateio1
				Endif
			Else
				_nRateio1 := Round(_nQtdRef * _aRatOP[nT,5], TAMSX3("H6_QTDPROD")[2])
				_aRatOP[nT,5] := _nRateio1
				_nTotRateio+= _nRateio1
			Endif
		Next
	Endif
	dbSelectArea(cAliasH6)
	dbCloseArea()
Endif
RestArea(_aArea)
Return(_aRatOP)
	
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
						{"Visualizar"	,"u_APTRF_A"	, 0, 2,0, nil},; //"Visualizar"
						{"Incluir"		,"u_APTRF_A"	, 0, 3,17,nil},; //"Incluir"
						{"Excluir"		,"u_APTRF_A"	, 0, 5,17,nil},; //"Excluir"
						{"Reimprimir Etiqueta","u_RETIQRF"	, 0, 5,17,nil},; //"Excluir"
						{"Gerar Rateio"	,"u_APONTRFB"	, 0, 7,17,nil} }

Return (aRotina)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAjustaSx1 บAutor  ณMicrosiga           บ Data ณ  01/19/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function AjustaSx1(cPerg)

Local _aArea := GetArea()
Local aRegs := {}
Local i,j

dbSelectArea("SX1")
dbSetOrder(1)
cPerg := PADR(cPerg,10)

aAdd(aRegs,{cPerg,"01","Do Documento    ?","","","mv_ch1","C",09,00,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"02","Ate Documento   ?","","","mv_ch2","C",09,00,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"03","Da Data Refugo  ?","Da Emissao           ?","Da Emissao          ?","mv_ch3","D",08,0,0,"G","","mv_par03"," "," "," ","",""," "," "," ","","","","","","","","","","","","","","","","",""," ","",""})
Aadd(aRegs,{cPerg,"04","Ate Data Refugo ?","Ate Emissao          ?","Ate Emissao         ?","mv_ch4","D",08,0,0,"G","","mv_par04"," "," "," ","",""," "," "," ","","","","","","","","","","","","","","","","",""," ","",""})
aAdd(aRegs,{cPerg,"05","Do Recurso      ?","","","mv_ch5","C",06,00,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","SH1"})
aAdd(aRegs,{cPerg,"06","Ate Recurso     ?","","","mv_ch6","C",06,00,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","SH1"})

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
RestArea(_aArea)
Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณNOVO5     บAutor  ณMicrosiga           บ Data ณ  03/03/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function RETIQRF

Local _aArea := GetArea()
Local _cEstacao := GetComputerName()
Local _cFila    := ""
Local _cLocNCF   := Alltrim(SuperGetMV("FB_LOCNCF",.F.,"02"))
Local _lNConf	 := .F.

dbSelectArea("SZ1")
dbSetOrder(1)
If !dbSeek(xFilial()+Alltrim(_cEstacao))
	Alert("Cadastrar a impressora relacionada a essa esta็ใo de trabalho, fa็a o cadastro na proxima tela")
	_cFila := u_Cad_Estac(_cEstacao)
Else
	_cFila := SZ1->Z1_FILAIMP
Endif
If Empty(_cFila)
	Help(" ",1,"IMPRNES",,"Nใo encontrada impressora para essa esta็ใo de trabalho",4,,,,,,.F.)
	Return
Endif
If !Empty(_cFila)
	If CB5SetImp(_cFila,.T.)
		u_FB_Etiq1(SZ5->Z5_CODREF, SZ5->Z5_DATA, SZ5->Z5_TURNO, " ", " ", SZ5->Z5_QTDREF, SZ5->Z5_TARA, 0, " ", _cFila, " ", .F., 1, SZ5->Z5_HORA,  "RS"+SZ5->Z5_DOC)
	Endif
Endif
RestArea(_aArea)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFB_APONTRFบAutor  ณMicrosiga           บ Data ณ  01/23/18   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Prc_ExRat

Local _lRet := .T.
Local _aArea := GetArea()
Local _cDocRat := SZ5->Z5_DOC
Local cAlias    := GetNextAlias()
Local aCabBC    := {}
Local aIteBC    := {}
Local aSH6 		:= {}
Local _cOP, _cRecurso, _cOperac
Local lSldBloq := .F.
Private lMSErroAuto := .F.
PRIVATE cCusMed := GetMv("MV_CUSMED")

cQuery := " SELECT R_E_C_N_O_ RECSBC "
cQuery +=   " FROM " + RetSqlName("SBC") + " SBC "
cQuery +=  " WHERE SBC.D_E_L_E_T_ = ' '"
cQuery +=    " AND SBC.BC_XDOC = '" + _cDocRat + "'"
cQuery := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)
dbSelectArea(cAlias)
While !Eof()
	lSldBloq := .F.
	_nRecno := (cAlias)->RECSBC
	dbSelectArea("SBC")
	dbGoto(_nRecno)
	_cOP      :=  SBC->BC_OP
	_cRecurso :=  SBC->BC_RECURSO
	_cOperac  :=  SBC->BC_OPERAC
	_cProdOri := SBC->BC_PRODUTO
	_cLocOri  := SBC->BC_LOCORIG
	_cProdDest := SBC->BC_CODDEST
	_cLocDest  := SBC->BC_LOCDEST
	_nQtdSBC   := SBC->BC_QUANT
	cNumSeq    := SBC->BC_NUMSEQ
	If !Empty(_cProdDest) .And. !SldBlqSB2(_cProdDest,_cLocDest)
		_lRet := .F.
		lSldBloq := .T.
	EndIf
	If BlqInvent(_cProdOri, _cLocOri )
		_lRet := .F.
		lSldBloq := .T.
	EndIf
	If !Empty(_cProdDest) .And. BlqInvent(_cProdDest,_cLocDest)
		_lRet := .F.
		lSldBloq := .T.
	EndIf
	//--> Somente ira estornar se NAO houver saldo bloqueado em nenhum produto
	If !lSldBloq
		dbSelectArea("SB2")
		dbSetOrder(1)
		If dbSeek(xFilial()+_cProdDest+_cLocDest)
			If QtdComp(SB2->B2_QATU) >= QtdComp(_nQtdSBC)
				dbSelectArea("SBC")
				EstornaSBC(_cOP,cNumSeq)
				aadd(aSH6, {_cOP, _cRecurso, _cOperac})
			Else
				_lRet := .F.
			Endif
		Endif
	EndIf
	dbSelectArea(cAlias)
	dbSkip()
End
dbSelectArea(cAlias)
dbCloseArea()
If Len(aSH6) > 0
	For nT:=1 to Len(aSH6)
		cQuery := " SELECT R_E_C_N_O_ RECSH6 "
		cQuery +=   " FROM " + RetSqlName("SH6") + " SH6 "
		cQuery +=  " WHERE SH6.D_E_L_E_T_ = ' '"
		cQuery +=    " AND SH6.H6_XDOCSBC = '" + _cDocRat + "'"
		cQuery +=    " AND SH6.H6_OP = '" + aSH6[nT,1] + "'"
		cQuery +=    " AND SH6.H6_RECURSO = '" + aSH6[nT,2] + "'"
		cQuery +=    " AND SH6.H6_OPERAC = '" + aSH6[nT,3] + "'"
		cQuery := ChangeQuery(cQuery)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)
		dbSelectArea(cAlias)
		While !Eof()
			nRegSH6 := (cAlias)->RECSH6
            dbSelectArea("SH6")
            SH6->(dbGoTo(nRegSH6))
            
            //Carrega array com todos os campos da SH6
            aSH6 := {}
            dbSelectArea("SX3")
            SX3->(dbSetOrder(1))
            If SX3->(dbSeek("SH6"))
               While !SX3->(Eof()) .And. AllTrim(SX3->X3_ARQUIVO) == "SH6"
                  If (X3USO(SX3->x3_usado) .And. SX3->X3_CONTEXT != "V") .Or. AllTrim(SX3->X3_CAMPO) == "H6_TIPO"
                     aAdd(aSH6,{AllTrim(SX3->X3_CAMPO),;
                                &("SH6->"+AllTrim(SX3->X3_CAMPO)),;
                                Nil})
                  EndIf
                  SX3->(dbSkip())
               End
            EndIf		

            // PE MATI681EXC
            If (ExistBlock('MATI681EXC'))
               aSH6Aux := aClone(aSH6)
               aAdd(aSH6Aux,{"IDESTORNO", nRegSH6, NIL})
               aRet := ExecBlock('MATI681EXC',.F.,.F.,aSH6Aux)
               If !aRet[1]
                  Return {.F., Iif(Empty(aRet[2]), "Nใo processado devido ao Ponto de Entrada MATI681EXC.", aRet[2] ) } //"Nใo processado devido ao Ponto de Entrada MATI681EXC."
               EndIf
               aSH6Aux := {}
            EndIf
            MSExecAuto({|x,y| mata681(x,y)},aSH6,5) // Estorno
            If lMsErroAuto
				Mostraerro()
				_lRet := .F.
//				Exit
			Endif
			dbSelectArea(cAlias)
			dbSkip()
		End
		dbSelectArea(cAlias)
		dbCloseArea()
	Next
Endif
If _lRet
	dbSelectArea("SZ5")
	RecLock("SZ5",.F.)
	dbDelete()
	MsUnLock()
Endif
dbSelectArea("SZ5")
Return