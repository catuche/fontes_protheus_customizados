#Include "Protheus.Ch"
#include "topconn.ch"

//#define ENTER chr(13)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NOVO2     º Autor ³ AP6 IDE            º Data ³  22/06/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Codigo gerado pelo AP6 IDE.                                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function CADPC2

Local nModAtu := nModulo
Private cAlias1 := "PC2"
Private cFilSZ3 := ""
Private cCadastro := "Criterios de apropriacao GGFs"
Private aRotina := {}
Private LCT102AUTO := .F.

aAdd( aRotina, {"Pesquisar"  ,"AxPesqui"   , 0 , 1} )
aAdd( aRotina, {"Visualizar" ,'u_IncluiZF',0,2})
aAdd( aRotina, {"Incluir"    ,'u_IncluiZF',0,3})
aAdd( aRotina, {"Alterar"    ,'u_IncluiZF',0,4})
aAdd( aRotina, {"Excluir"    ,'u_IncluiZF',0,5,5})
aAdd( aRotina, {"Copiar Valor" ,'u_CopiaVL',0,5,5})
aAdd( aRotina, {"Percentual" ,'u_Rot_Ini("1")',0,5,5})
aAdd( aRotina, {"Gerar Rateio" ,'u_Rot_Ini("2")',0,5,5})
aAdd( aRotina, {"Excluir Rateio" ,'u_Rot_Ini("5")',0,5,5})
aAdd( aRotina, {"Blq Estoque" ,'u_Rot_Ini("3")',0,5,5})
aAdd( aRotina, {"Prox. Mes" ,'u_Rot_Ini("4")',0,5,5})
aAdd( aRotina, {"Copiar Criterio" ,'u_CopiaZF',0,5,5})
aAdd( aRotina, {"Legenda"        ,"U_RLegBrod",0,5})

aCores	:= {{'EMPTY(PC2_DTPERC) .AND. EMPTY(PC2_DTCONT)','DISABLE'},;
{'!EMPTY(PC2_DTPERC) .AND. EMPTY(PC2_DTCONT)','ENABLE'},;
{'!EMPTY(PC2_DTCONT)','BR_CINZA'}}

If nModulo == 4
	If !(cEmpAnt $ "09/99")
		Help("",1,"","NOEMP09","ROTINA DEVE SER EXECUTADA NO GRUPO DE EMPRESA 09",1,0) //"NÃO É POSSÍVEL EXECUTAR, FALTA"
		RETURN
	Else
		nModulo = 34
	Endif
Endif

If Empty(Posicione("SX3",1,cAlias1,"X3_ARQUIVO"))
	Help("",1,"","NOX3X2IX","NÃO É POSSÍVEL EXECUTAR, FALTA"+chr(13)+"X3, X2, IX E X7",1,0)
	RETURN
Endif

dbSelectArea(cAlias1)
dbSetOrder(1)
cFilSZ3 := xFilial(cAlias1)
dbGoTop()
mBrowse(,,,,"PC2",,,,,,aCores)
dbSelectArea("PC2")
dbSetOrder(1)
nModulo = nModAtu
Return
*----------------------------------------------------------
User Function CopiaZF
*----------------------------------------------------------
Local bCampo := { |nCPO| Field(nCPO)}
Local lRet := .t.
Local _aAreaPC2
dbSelectArea("PC2")
dbSetOrder(1)
_cChave := PC2->(PC2_CODIGO+PC2_MESANO)
_aAreaPC2 := GetArea()
dbSeek(xFilial())
While !Eof() .and. xFilial("PC2") == PC2_FILIAL
	_cCodigo := Soma1(PC2->PC2_CODIGO)
	dbSkip()
End
_cDesc   := Space(40)
oDlg2      := MSDialog():New( 106,291,307,635,"Dados do novo criterio",,,.F.,,,,,,.T.,,,.T. )
Codigo     := TSay():New( 020,014,{||"Codigo"}   ,oDlg2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
Descricao  := TSay():New( 040,014,{||"Descricao"},oDlg2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oGet1      := TGet():New( 020,046,bSetGet(_cCodigo),oDlg2,020,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,{|| .T.},,.F.,,.F.,.F.,"","",,)
oGet2      := TGet():New( 040,046,bSetGet(_cDesc),oDlg2,100,008,'',  ,CLR_BLACK,CLR_WHITE,,,,.T.,"",,{|| .T.},,.F.,,.F.,.F.,"","",,)
oBtnOK     := SButton():New( 064,032,1,{|| (lRet := .T.,oDlg2:End())},oDlg2,,"", )
oBtnCan    := SButton():New( 064,072,2,{|| (lRet := .F.,oDlg2:End())},oDlg2,,"", )
oDlg2:Activate(,,,.T.)
If lRet
	If !dbSeek(xFilial()+_cCodigo)
		dbSeek(xFilial()+_cChave)
		While !Eof() .and. PC2->PC2_CODIGO+PC2->PC2_MESANO == _cChave .AND. xFilial("PC2") == PC2_FILIAL
			_aAreaPC2 := GetArea()
			FOR I := 1 to FCount()
				M->&(EVAL(bCampo,I)) := FieldGet(I)
			Next I
			M->PC2_CODIGO := _cCodigo
			M->PC2_DESC   := _cDesc
			_nOpca := AxIncluiAuto("PC2")
			RestArea(_aAreaPC2)
			dbSkip()
		End
	Else
		Alert("Criterio nao pode ser criado, codigo ja existe!")
	Endif
Endif
Return
*----------------------------------------------------------
User Function CopiaVL
*----------------------------------------------------------
Local bCampo := { |nCPO| Field(nCPO)}
Local _cPer    := CriaVar("PC2_MESANO",.F.)
Local _cCodigo := CriaVar("PC2_CODIGO",.F.)
Local _cDescCop   := CriaVar("PC2_DESC",.F.)
Local lRet := .t.
Local _cMesAno :=	PC2->PC2_MESANO
Local _cCod :=	PC2->PC2_CODIGO
Local _cDesc:=	PC2->PC2_DESC
Local _cContaDe:=	PC2->PC2_CONTA
Local _cContaAt:=	PC2->PC2_CONTA2
Local _cContNDe := PC2->PC2_NCONT
Local _cContNAt := PC2->PC2_NCONT2
Local _cContaRt := PC2->PC2_CONTA3
Local _cContaDb := PC2->PC2_CONTAD
Local _cContaCr := PC2->PC2_CONTAC
Local _cCCOri   := PC2->PC2_CCORIG
Local _cFormula := PC2->PC2_FORMUL
Local _nQtdeT   := PC2->PC2_TOTAL
dbSelectArea("PC2")
dbSetOrder(1)
cValid		:= "Val_Codcp(_cPer,_cCodigo,@_cDescCop,_cCod)"
cBlKVld 	:= "{|| "+cValid+"}"

oDlg2      := MSDialog():New( 106,191,320,835,"Copiar Valores - Informe de qual codigo a copiar",,,.F.,,,,,,.T.,,,.T. )

@ 010,10 TO 080,160 LABEL "Copiar de" PIXEL OF oDlg2

Periodo    := TSay():New( 020,014,{||"Mes/Ano"},oDlg2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
Codigo     := TSay():New( 040,014,{||"Codigo"},oDlg2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
Descricao  := TSay():New( 060,014,{||"Descricao"},oDlg2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oGet1      := TGet():New( 020,046,bSetGet(_cPer),oDlg2,020,008,"@R 99/99",,CLR_BLACK,CLR_WHITE,,,,.T.,"",,{|| .T.},,.F.,,.F.,.F.,"","",,)
oGet2      := TGet():New( 040,046,bSetGet(_cCodigo),oDlg2,020,008,'',&(cBlkVld),CLR_BLACK,CLR_WHITE,,,,.T.,"",,{|| .T.},,.F.,,.F.,.F.,"","",,)
oGet3      := TGet():New( 060,046,bSetGet(_cDescCop),oDlg2,100,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,{|| .F.},,.F.,,.F.,.F.,"","",,)

@ 010,165 TO 080,320 LABEL "Para" PIXEL OF oDlg2

Periodo    := TSay():New( 020,170,{||"Mes/Ano"},oDlg2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
Codigo     := TSay():New( 040,170,{||"Codigo"},oDlg2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
Descricao  := TSay():New( 060,170,{||"Descricao"},oDlg2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oGet4      := TGet():New( 020,202,bSetGet(_cMesAno),oDlg2,020,008,"@R 99/99",,CLR_BLACK,CLR_WHITE,,,,.T.,"",,{|| .F.},,.F.,,.F.,.F.,"","",,)
oGet5      := TGet():New( 040,202,bSetGet(_cCod),oDlg2,020,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,{|| .F.},,.F.,,.F.,.F.,"","",,)
oGet6      := TGet():New( 060,202,bSetGet(_cDesc),oDlg2,100,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,{|| .F.},,.F.,,.F.,.F.,"","",,)

oBtnOK     := SButton():New( 094,092,1,{|| (lRet := .T.,oDlg2:End())},oDlg2,,"", )
oBtnCan    := SButton():New( 094,132,2,{|| (lRet := .F.,oDlg2:End())},oDlg2,,"", )
oDlg2:Activate(,,,.T.)
If lRet .and. _cCod <> _cCodigo
	dbSelectArea("PC2")
	dbSetOrder(1)
	If dbSeek(xFilial()+_cCodigo+_cPer)
		If dbSeek(xFilial()+_cCod+_cMesAno)
			While !Eof() .and. PC2->PC2_CODIGO+PC2->PC2_MESANO == _cCod+_cMesAno .AND. xFilial("PC2") == PC2_FILIAL
				RecLock("PC2",.F.)
				dbDelete()
				MsUnLock("PC2")
				dbSkip()
			End
			If dbSeek(xFilial()+_cCodigo+_cPer)
				While !Eof() .and. PC2->PC2_CODIGO+PC2->PC2_MESANO == _cCodigo+_cPer .AND. xFilial("PC2") == PC2_FILIAL
					_aAreaPC2 := GetArea()
					FOR I := 1 to FCount()
						M->&(EVAL(bCampo,I)) := FieldGet(I)
					Next I
					M->PC2_MESANO := _cMesAno
					M->PC2_CODIGO := _cCod
					M->PC2_DESC   := _cDesc
					M->PC2_CONTA:= _cContaDe
					M->PC2_CONTA2 := _cContaAt
					M->PC2_NCONT := _cContNDe
					M->PC2_NCONT2 := _cContNAt
					M->PC2_CONTA3 := _cContaRt
					M->PC2_CONTAD := _cContaDb
					M->PC2_CONTAC := _cContaCr
					M->PC2_CCORIG := _cCCOri
					M->PC2_FORMUL := _cFormula
					M->PC2_TOTAL := _nQtdeT
					_nOpca := AxIncluiAuto("PC2")
					RestArea(_aAreaPC2)
					dbSkip()
				End
			Endif
		Endif
	Endif
Endif
Return
*----------------------------------------------------------
User Function IncluiZF(cAlias1,nReg,nOpcX)
*----------------------------------------------------------
Local nOpcA     := 0
Local oDlg      := Nil
Local oGet      := Nil
Local _cMesFech := GetMV("MV_ULMES")
Private	_cMesAno  := CriaVar("PC2_MESANO",.f.)
Private	_cCod     := CriaVar("PC2_CODIGO",.F.)
Private	_cDesc    := CriaVar("PC2_DESC",.F.)
Private	_cContaDe := CriaVar("PC2_CONTA",.F.)
Private	_cContaAt := CriaVar("PC2_CONTA2",.F.)
Private	_cContNDe := CriaVar("PC2_NCONT",.F.)
Private	_cContNAt := CriaVar("PC2_NCONT2",.F.)
Private	_cContaDb := CriaVar("PC2_CONTAD",.F.)
Private	_cContaCr := CriaVar("PC2_CONTAC",.F.)
Private	_cContaRt := CriaVar("PC2_CONTA3",.F.)
Private	_cCCOri   := CriaVar("PC2_CCORIG",.F.)
Private	_cCCDes   := CriaVar("PC2_CCATE",.F.)
Private	_cFormula := CriaVar("PC2_FORMUL",.F.)
Private	_cDescCoDe:= CriaVar("PC2_DESCON",.F.)
Private	_cDescCoAt:= CriaVar("PC2_DESCO2",.F.)
Private	_cDescNDe := CriaVar("PC2_NDESCN",.F.)
Private	_cDescNAt := CriaVar("PC2_NDESC2",.F.)
Private	_cDescCoDb:= CriaVar("PC2_DESCOB",.F.)
Private	_cDescCoCr:= CriaVar("PC2_DESCOC",.F.)
Private	_cDescCoRt:= CriaVar("PC2_DESCRT",.F.)
Private	_cDesccc  := CriaVar("PC2_DESCCC",.F.)
Private	_cDesccd  := CriaVar("PC2_DESCAT",.F.)
Private	_cDesFor  := CriaVar("PC2_DESCFO",.F.)
Private	_nQtdeT   := CriaVar("PC2_TOTAL",.F.)
Private aHeader := {}
Private aCOLS   := {}
Private nUsado  := 0
Private _lAltera := .f.

dbSelectArea("SX3")
dbSeek(cAlias1)
While !EOF() .And. X3_ARQUIVO == cAlias1
	IF X3USO(X3_USADO) .AND. cNivel >= X3_NIVEL .and. Alltrim(SX3->X3_CAMPO) $ "PC2_ITEM/PC2_CCDEST/PC2_PERC/PC2_PESO/PC2_QTDE/PC2_DSCDES" // /PC2_QTDE2
		nUsado++
		AADD(aHeader,{ TRIM(X3Titulo()) ,;
		X3_CAMPO    ,;
		X3_PICTURE  ,;
		X3_TAMANHO  ,;
		X3_DECIMAL  ,;
		X3_VALID    ,;
		X3_USADO    ,;
		X3_TIPO     ,;
		X3_ARQUIVO  ,;
		X3_CONTEXT  })
	Endif
	dbSkip()
End
aAdd( aCOLS,Array(Len(aHeader)+1))
_nPosItem := aScan(aHeader,{|x|AllTrim(Upper(x[2]))=="PC2_ITEM"})
_nPosCCD  := aScan(aHeader,{|x|AllTrim(Upper(x[2]))=="PC2_CCDEST"})
_nPosPerc := aScan(aHeader,{|x|AllTrim(Upper(x[2]))=="PC2_PERC"})
_nPosPeso := aScan(aHeader,{|x|AllTrim(Upper(x[2]))=="PC2_PESO"})
_nPosQtde := aScan(aHeader,{|x|AllTrim(Upper(x[2]))=="PC2_QTDE"})
//_nPosQtd2 := aScan(aHeader,{|x|AllTrim(Upper(x[2]))=="PC2_QTDE2"})
_nPosDsc := aScan(aHeader,{|x|AllTrim(Upper(x[2]))=="PC2_DSCDES"})
If nOpcX <> 3
	If nOpcX <> 2 .and. !Empty(PC2->PC2_DTCONT)
		Alert("Rateio NAO pode ser alterado! Lancamentos contabeis ja foram gerados")
		Return
	Endif
	_cMesAno  := PC2->PC2_MESANO
	_cCod     := PC2->PC2_CODIGO
	_cContaDe := PC2->PC2_CONTA
	_cContaAt := PC2->PC2_CONTA2
	_cContNDe := PC2->PC2_NCONT
	_cContNAt := PC2->PC2_NCONT2
	_cContaRt := PC2->PC2_CONTA3
	_cContaDb := PC2->PC2_CONTAD
	_cContaCr := PC2->PC2_CONTAC
	_cDescCoDe  := Posicione("CT1",1,xFilial("CT1")+_cContaDe,"CT1_DESC01")
	_cDescCoAt  := Posicione("CT1",1,xFilial("CT1")+_cContaAt,"CT1_DESC01")
	_cDescNDe  := Posicione("CT1",1,xFilial("CT1")+_cContNDe,"CT1_DESC01")
	_cDescNAt  := Posicione("CT1",1,xFilial("CT1")+_cContNAt,"CT1_DESC01")
	_cDescCoDb  := Posicione("CT1",1,xFilial("CT1")+_cContaDb,"CT1_DESC01")
	_cDescCoCr  := Posicione("CT1",1,xFilial("CT1")+_cContaCr,"CT1_DESC01")
	_cDescCoRt  := Posicione("CT1",1,xFilial("CT1")+_cContaRt,"CT1_DESC01")
	_cCCOri   := PC2->PC2_CCORIG
	_cDesccc  := Posicione("SI3",1,xFilial("SI3")+_cCCOri,"I3_DESC")
	_cFormula := PC2->PC2_FORMUL
	_cDesFor  := Posicione("SM4",1,xFilial("SM4")+_cFormula,"M4_DESCR")
	_cData    := LastDay(Ctod("01/"+Substr(_cMesAno,1,2)+"/"+Substr(_cMesAno,3,2)))
	_nQtdeT   := PC2->PC2_TOTAL
	If nOpcX <> 2 .and. _cMesFech >= _cData
		Alert("Criterio nao podera ser alterado, pois o mes ja foi encerrado")
		Return
	Endif
	_cDesc    := Posicione("PC2",1,xFilial("PC2")+_cCod+_cMesAno,"PC2_DESC")
	dbSelectArea("PC2")
	dbSetOrder(1)
	dbSeek(xFilial()+_cCod+_cMesAno)
	While !Eof() .and. _cCod+_cMesAno == PC2->(PC2_CODIGO+PC2_MESANO) .AND. xFilial("PC2") == PC2_FILIAL
		aCols[Len(aCols),_nPosItem]   := PC2->PC2_ITEM
		aCols[Len(aCols),_nPosCCD]    := PC2->PC2_CCDEST
		aCols[Len(aCols),_nPosDsc]    := Posicione("SI3",1,xFilial("SI3")+PC2->PC2_CCDEST,"I3_DESC")
		aCols[Len(aCols),_nPosPerc]   := PC2->PC2_PERC
		aCols[Len(aCols),_nPosPeso]   := PC2->PC2_PESO
		aCols[Len(aCols),_nPosQtde]   := PC2->PC2_QTDE
		//		aCols[Len(aCols),_nPosQtd2]   := PC2->PC2_QTDE2
		aCOLS[Len(aCols)][nUsado+1] := .F.
		dbSkip()
		If !Eof() .and. _cCod+_cMesAno == PC2->(PC2_CODIGO+PC2_MESANO)
			aadd(aCols,Array(Len(aHeader)+1))
		Endif
	End
Else
	dbSelectArea("SX3")
	dbSeek(cAlias1)
	nUsado:=0
	While !EOF() .And. X3_ARQUIVO == cAlias1
		IF X3USO(X3_USADO) .AND. cNivel >= X3_NIVEL .and. Alltrim(SX3->X3_CAMPO) $ "PC2_ITEM/PC2_CCDEST/PC2_PERC/PC2_PESO/PC2_QTDE/PC2_DSCDES"
			nUsado++
			IF X3_TIPO == "C"
				If Trim(aHeader[nUsado][2]) == "PC2_ITEM"
					aCOLS[1][nUsado] := "001"
				Else
					aCOLS[1][nUsado] := SPACE(x3_tamanho)
				Endif
			ELSEIF X3_TIPO == "N"
				aCOLS[1][nUsado] := 0
			ELSEIF X3_TIPO == "D"
				aCOLS[1][nUsado] := dDataBase
			ELSEIF X3_TIPO == "M"
				aCOLS[1][nUsado] := CriaVar(AllTrim(X3_CAMPO))
			ELSE
				aCOLS[1][nUsado] := .F.
			Endif
			If X3_CONTEXT == "V"
				aCols[1][nUsado] := CriaVar(AllTrim(X3_CAMPO))
			Endif
		Endif
		dbSkip()
	End
	aCOLS[1][nUsado+1] := .F.
Endif

_aSize := MsAdvSize()
// Ajustes em _aSize, permitindo que opere bem em diversas resoluções, supondo que seja utilizado
// para dimensionar o dialog principal e um getdados na parte de baixo

aObjects := {}

aAdd(aObjects,{50 ,50 ,.T.,.F.})		// Definicoes para a Enchoice
aAdd(aObjects,{100,100,.T.,.F.})		// Definicoes para a Getdados
aAdd(aObjects,{100,100,.T.,.T.})

aInfo := { _aSize[ 1 ], _aSize[ 2 ], _aSize[ 3 ], _aSize[ 4 ], 3, 3 }
aPosObj := MsObjSize( aInfo, aObjects )

// DEFINE MSDIALOG _oDlg TITLE "Criterio de Apuracao GGFs" FROM C(0),C(0) TO C(631),C(767) PIXEL
//DEFINE MSDIALOG _oDlg TITLE  FROM C(0),C(0) TO C(631),C(767) PIXEL
                      
Define MsDialog _oDlg Title "Criterio de Apuracao GGFs" of oMainWnd pixel From _aSize[7],0 to _aSize[6],_aSize[5] of oMainWnd PIXEL

// Cria Componentes Padroes do Sistema

@ aPosObj[1,1],C(003) TO aPosObj[1,1] + 28,C(500) LABEL "Rateio" PIXEL OF _oDlg

_nLinha := 10

@ aPosObj[1,1]+_nLinha,C(028) MsGet oMesAno Var _cMesAno Size C(010),C(009) COLOR CLR_BLACK PIXEL OF _oDlg Picture "@R 99/99" When(IIF(nOpcX==3,.t.,.f.)) Valid CheckSX3('PC2_MESANO',_cMesAno)
@ aPosObj[1,1]+_nLinha,C(080) MsGet oCod Var _cCod Size C(010),C(009) COLOR CLR_BLACK PIXEL OF _oDlg When(IIF(nOpcX==3,.t.,.f.)) Valid(!Vazio() .and. Ver_Cod(_cMesAno,_cCod))
@ aPosObj[1,1]+_nLinha,C(130) MsGet oDesc Var _cDesc Size C(100),C(009) COLOR CLR_BLACK PIXEL OF _oDlg When(IIF(nOpcX==3 .or. nOpcX==4,.t.,.f.))
@ aPosObj[1,1]+_nLinha,C(255) MsGet oFormula Var _cFormula F3 "SM4" Size C(025),C(009) COLOR CLR_BLACK PIXEL OF _oDlg  Valid (Vazio() .or. (CheckSX3('PC2_FORMUL',_cFormula) .and. TrazDesc("SM4",_cFormula,@_cDesFor,"M4_FORMULA",oCDesFor))) When(IIF(nOpcX==3 .or. nOpcX==4,.t.,.f.))
@ aPosObj[1,1]+_nLinha,C(285) MsGet oCDesFor Var _cDesFor Size C(100),C(009) COLOR CLR_BLACK PIXEL OF _oDlg When .f.
@ aPosObj[1,1]+_nLinha,C(415) MsGet oQtdeT Var _nQtdeT Size C(060),C(009) COLOR CLR_BLACK PIXEL OF _oDlg Picture "@E 999,999,999.9999" When(IIF(nOpcX==3 .or. nOpcX==4,.t.,.f.))
_nLinha:=_nLinha+1
@ aPosObj[1,1]+_nLinha,C(013) Say "Mes" Size C(012),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
@ aPosObj[1,1]+_nLinha,C(060) Say "Codigo" Size C(018),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
@ aPosObj[1,1]+_nLinha,C(105) Say "Descricao" Size C(023),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
@ aPosObj[1,1]+_nLinha,C(235) Say "Formula" Size C(020),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
@ aPosObj[1,1]+_nLinha,C(390) Say "Quantidade" Size C(025),C(008) COLOR CLR_BLACK PIXEL OF _oDlg

_nLinha:=_nLinha+20

_nLinDes := _nLinha

@ aPosObj[1,1]+_nLinha,C(003) TO aPosObj[1,1]+_nLinha+70,C(215) LABEL "Origem Rateio" PIXEL OF _oDlg

_nLinha:=_nLinha+10

@ aPosObj[1,1]+_nLinha,C(041) MsGet oContaDe Var _cContaDe F3 "CT1" Size C(060),C(009) COLOR CLR_BLACK PIXEL OF _oDlg  Valid (Vazio() .or. (CheckSX3('PC2_CONTA',_cContaDe) .and. TrazDesc("CT1",_cContaDe,@_cDescCoDe,"CT1_DESC01",oDescCoDe))) When(IIF(nOpcX==3 .or. nOpcX==4,.t.,.f.))
@ aPosObj[1,1]+_nLinha,C(110) MsGet oDescCoDe Var _cDescCoDe Size C(100),C(009) COLOR CLR_BLACK PIXEL OF _oDlg When .f.
_nLinha:=_nLinha+1
@ aPosObj[1,1]+_nLinha,C(015) Say "Conta De" Size C(020),C(008) COLOR CLR_BLACK PIXEL OF _oDlg

_nLinha:=_nLinha+13
@ aPosObj[1,1]+_nLinha,C(041) MsGet oContaAt Var _cContaAt F3 "CT1" Size C(060),C(009) COLOR CLR_BLACK PIXEL OF _oDlg  Valid (Vazio() .or. (CheckSX3('PC2_CONTA',_cContaAt) .and. TrazDesc("CT1",_cContaAt,@_cDescCoAt,"CT1_DESC01",oDescCoAt))) When(IIF(nOpcX==3 .or. nOpcX==4,.t.,.f.))
@ aPosObj[1,1]+_nLinha,C(110) MsGet oDescCoAt Var _cDescCoAt Size C(100),C(009) COLOR CLR_BLACK PIXEL OF _oDlg When .f.
_nLinha:=_nLinha+1
@ aPosObj[1,1]+_nLinha,C(015) Say "Conta Ate" Size C(030),C(008) COLOR CLR_BLACK PIXEL OF _oDlg

_nLinha:=_nLinha+13
@ aPosObj[1,1]+_nLinha,C(041) MsGet oContaRt Var _cContaRt F3 "CT1" Size C(060),C(009) COLOR CLR_BLACK PIXEL OF _oDlg  Valid (Vazio() .or. (CheckSX3('PC2_CONTA',_cContaRt) .and. TrazDesc("CT1",_cContaRt,@_cDescCoRt,"CT1_DESC01",oDescCoRt))) When(IIF(nOpcX==3 .or. nOpcX==4,.t.,.f.))
@ aPosObj[1,1]+_nLinha,C(110) MsGet oDescCoRt Var _cDescCoRt Size C(100),C(009) COLOR CLR_BLACK PIXEL OF _oDlg When .f.
_nLinha:=_nLinha+1
@ aPosObj[1,1]+_nLinha,C(015) Say "Inclusive" Size C(030),C(008) COLOR CLR_BLACK PIXEL OF _oDlg

_nLinha:=_nLinha+13
@ aPosObj[1,1]+_nLinha,C(041) MsGet oCCOri Var _cCCOri F3 "SI3" Size C(060),C(009) COLOR CLR_BLACK PIXEL OF _oDlg Valid (Vazio() .or. (CheckSX3('PC2_CCORIG',_cCCOri) .and. TrazDesc("SI3",_cCCOri,@_cDesccc,"I3_DESC",oCDesccc)))  When(IIF(nOpcX==3 .or. nOpcX==4,.t.,.f.))
@ aPosObj[1,1]+_nLinha,C(110) MsGet oCDesccc Var _cDesccc Size C(100),C(009) COLOR CLR_BLACK PIXEL OF _oDlg When .f.
_nLinha:=_nLinha+1
@ aPosObj[1,1]+_nLinha,C(015) Say "Centro" Size C(030),C(008) COLOR CLR_BLACK PIXEL OF _oDlg

_nLinha:=_nLinha + 20

@ aPosObj[1,1]+_nLinha,C(003) TO aPosObj[1,1]+_nLinha+45,C(215) LABEL "Origem a restringir" PIXEL OF _oDlg
_nLinha:=_nLinha+10

@ aPosObj[1,1]+_nLinha,C(041) MsGet oContNDe Var _cContNDe F3 "CT1" Size C(060),C(009) COLOR CLR_BLACK PIXEL OF _oDlg  Valid (Vazio() .or. (CheckSX3('PC2_CONTA',_cContNDe) .and. TrazDesc("CT1",_cContNDe,@_cDescNDe,"CT1_DESC01",oDescNDe))) When(IIF(nOpcX==3 .or. nOpcX==4,.t.,.f.))
@ aPosObj[1,1]+_nLinha,C(110) MsGet oDescNDe Var _cDescNDe Size C(100),C(009) COLOR CLR_BLACK PIXEL OF _oDlg When .f.
_nLinha:=_nLinha+1
@ aPosObj[1,1]+_nLinha,C(015) Say "Conta De" Size C(020),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
_nLinha:=_nLinha+13
@ aPosObj[1,1]+_nLinha,C(041) MsGet oContNAt Var _cContNAt F3 "CT1" Size C(060),C(009) COLOR CLR_BLACK PIXEL OF _oDlg  Valid (Vazio() .or. (CheckSX3('PC2_CONTA',_cContNAt) .and. TrazDesc("CT1",_cContNAt,@_cDescNAt,"CT1_DESC01",oDescNAt))) When(IIF(nOpcX==3 .or. nOpcX==4,.t.,.f.))
@ aPosObj[1,1]+_nLinha,C(110) MsGet oDescNAt Var _cDescNAt Size C(100),C(009) COLOR CLR_BLACK PIXEL OF _oDlg When .f.
_nLinha:=_nLinha+1
@ aPosObj[1,1]+_nLinha,C(015) Say "Conta Ate" Size C(030),C(008) COLOR CLR_BLACK PIXEL OF _oDlg

_nLinha := _nLinDes

@ aPosObj[1,1]+_nLinha,C(220) TO aPosObj[1,1]+_nLinha+45,C(500) LABEL "Destino" PIXEL OF _oDlg

_nLinha:=_nLinha+10

@ aPosObj[1,1]+_nLinha,C(260) MsGet oContaDb Var _cContaDb F3 "CT1" Size C(060),C(009) COLOR CLR_BLACK PIXEL OF _oDlg  Valid (Vazio() .or. (CheckSX3('PC2_CONTA',_cContaDb) .and. TrazDesc("CT1",_cContaDb,@_cDescCoDb,"CT1_DESC01",oDescCoDb))) When(IIF(nOpcX==3 .or. nOpcX==4,.t.,.f.))
@ aPosObj[1,1]+_nLinha,C(330) MsGet oDescCoDb Var _cDescCoDb Size C(100),C(009) COLOR CLR_BLACK PIXEL OF _oDlg When .f.
_nLinha:=_nLinha+1

_nLinha:=_nLinha+1
@ aPosObj[1,1]+_nLinha,C(230) Say "Conta Debito" Size C(040),C(008) COLOR CLR_BLACK PIXEL OF _oDlg

_nLinha:=_nLinha+13

@ aPosObj[1,1]+_nLinha,C(260) MsGet oContaCr Var _cContaCr F3 "CT1" Size C(060),C(009) COLOR CLR_BLACK PIXEL OF _oDlg  Valid (Vazio() .or. (CheckSX3('PC2_CONTA',_cContaCr) .and. TrazDesc("CT1",_cContaCr,@_cDescCoCr,"CT1_DESC01",oDescCoCr))) When(IIF(nOpcX==3 .or. nOpcX==4,.t.,.f.))
@ aPosObj[1,1]+_nLinha,C(330) MsGet oDescCoCr Var _cDescCoCr Size C(100),C(009) COLOR CLR_BLACK PIXEL OF _oDlg When .f.

_nLinha:=_nLinha+1
@ aPosObj[1,1]+_nLinha,C(230) Say "Conta Credito" Size C(030),C(008) COLOR CLR_BLACK PIXEL OF _oDlg

oGet := MSGetDados():New(aPosObj[3,1],aPosObj[3,2],aPosObj[3,3],aPosObj[3,4],nOpcX,"u_LinOkZF()","u_TudOkZF()","+PC2_ITEM",.T.)
	
ACTIVATE MSDIALOG _oDlg ON INIT EnchoiceBar(_oDlg,{||nOpcA:=1,Iif(u_TudOkZF(),_oDlg:End(),nOpcA:=0)},{||_oDlg:End()})

If nOpcA == 1
	If nOpcx == 3 .or. nOpcx == 4
		Begin Transaction
		GravaZF(cAlias1)
		End Transaction
		dbSelectArea(cAlias1)
	ElseIf nOpcx == 5
		Begin Transaction
		dbSelectArea("PC2")
		dbSetOrder(1)
		dbSeek( xFilial() + _cCod + _cMesAno)
		While !Eof() .and. _cCod + _cMesAno == PC2->PC2_CODIGO+PC2->PC2_MESANO .AND. xFilial("PC2") == PC2_FILIAL
			RecLock("PC2",.F.)
			dbDelete()
			MsUnLock("PC2")
			dbSkip()
		End
		End Transaction
	Endif
Endif
dbSelectArea("PC2")
dbSetOrder(1)
Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³   C()   ³ Autores ³ Norbert/Ernani/Mansano ³ Data ³10/05/2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao  ³ Funcao responsavel por manter o Layout independente da       ³±±
±±³           ³ resolucao horizontal do Monitor do Usuario.                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function C(nTam)
Local nHRes	:=	oMainWnd:nClientWidth	// Resolucao horizontal do monitor
If nHRes == 640	// Resolucao 640x480 (soh o Ocean e o Classic aceitam 640)
	nTam *= 0.8
ElseIf (nHRes == 798).Or.(nHRes == 800)	// Resolucao 800x600
	nTam *= 1
Else	// Resolucao 1024x768 e acima
	nTam *= 1.28
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Tratamento para tema "Flat"³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If "MP8" $ oApp:cVersion
	If (Alltrim(GetTheme()) == "FLAT") .Or. SetMdiChild()
		nTam *= 0.90
	EndIf
EndIf
Return Int(nTam)
*-------------------------------------------------------------------
Static Function Ver_Cod(_cMesAno,_cCod)
*-------------------------------------------------------------------
Local _lRet := .t.
Local _aArea := GetArea()
dbSelectArea("PC2")
dbSetOrder(2)
If dbSeek(xFilial()+_cMesAno+_cCod)
	_lRet := .f.
	Alert("Codigo ja existe")
Endif
Return(_lRet)
*-------------------------------------------------------------------
User Function LinOkZF()
*-------------------------------------------------------------------
Local lRet := .T.
Local nY := 0
Local nI := 0
Local cMsg := ""

//+----------------------------------------------------
//| Verifica se o codigo esta em branco, se ok bloqueia
//+----------------------------------------------------
//| Se a linha nao estiver deletada.

If !aCols[n][Len(aHeader)+1]
	If Empty(aCols[n][_nPosCCD])
		cMsg := "Nao sera permitido linhas sem o centro de custo."
		Help("",1,"","Mod2LinOk",cMsg,1,0)
		lRet := .F.
	Endif
Endif

Return( lRet )
*-------------------------------------------------------------------
User Function TudOkZF()
*-------------------------------------------------------------------
Local lRet := .T.
Local nY := 0
Local nI := 0
Local cMsg := ""

//+----------------------------------------------------
//| Verifica se o codigo esta em branco, se ok bloqueia
//+----------------------------------------------------
//| Se a linha nao estiver deletada.
/*
If !aCols[n][nUsado+1]
If Empty(aCols[n][Mod2Pesq("Z3_CCUSTO")])
cMsg := "Nao sera permitido linhas sem o centro de custo."
Help("",1,"","Mod2LinOk",cMsg,1,0)
lRet := .F.
Endif
Endif
*/

If Empty(_cMesAno) .or. Empty(_cCod)
	Alert("Existem campo no cabecalho em Branco")
	_lRet := .f.
Endif
Return( lRet )
*--------------------------------------------------------------------
Static Function GravaZF(cAlias1)
*--------------------------------------------------------------------
Local lRet := .T.
Local nI := 0
Local nY := 0
Local cVar := ""
Local lOk := .T.
Local nDel := 0
Local cMsg := ""

dbSelectArea("PC2")
dbSetOrder(1)

For nI := 1 To Len(aCols)
	dbSeek( xFilial() + _cCod + _cMesAno + aCols[nI,_nPosItem] )
	
	If !aCols[nI][nUsado+1]
		If Found()
			RecLock(cAlias1,.F.)
		Else
			RecLock(cAlias1,.T.)
		Endif
		PC2->PC2_FILIAL := xFilial("PC2")
		PC2->PC2_MESANO := _cMesAno
		PC2->PC2_CODIGO := _cCod
		PC2->PC2_DESC   := _cDesc
		PC2->PC2_CONTA  := _cContaDe
		PC2->PC2_CONTA2 := _cContaAt
		PC2->PC2_NCONT  := _cContNDe
		PC2->PC2_NCONT2 := _cContNAt
		PC2->PC2_CONTA3 := _cContaRt
		PC2->PC2_CONTAD:= _cContaDb
		PC2->PC2_CONTAC:= _cContaCr
		PC2->PC2_CCORIG := _cCCOri
		PC2->PC2_FORMUL:= _cFormula
		PC2->PC2_TOTAL := _nQtdeT
		For nY = 1 to Len(aHeader)
			If aHeader[nY][10] # "V"
				cVar := Trim(aHeader[nY][2])
				Replace &cVar. With aCols[nI][nY]
			Endif
		Next nY
		MsUnLock("PC2")
	Else
		If !Found()
			Loop
		Endif
		//Fazer pesquisa para saber se o item poderar ser deletado e
		If lOk
			RecLock(cAlias1,.F.)
			dbDelete()
			MsUnLock(cAlias1)
		Else
			cMsg := "Nao foi possivel deletar o item "+aCols[nI][1]+", o mesmo possui amarracao"
			Help("",1,"","NAOPODE",cMsg,1,0)
		Endif
	Endif
Next nI
dbSelectArea("PC2")
dbSetOrder(1)
Return

*-----------------------------------------------------
Static Function TrazDesc(_cAlias,_cChave,_cDesc,_cCampo,oObjc)
*-----------------------------------------------------
Local _lRet := .t.
_cDesc := Posicione(_cAlias,1,xFilial(_cAlias)+_cChave,_cCampo)
oObjc:Refresh()
Return(_lRet)
*----------------------------------------------------------------
User Function Rot_Ini(_cparam)
*----------------------------------------------------------------
Local aSay    := {}
Local aButton := {}
Local nOpc    := 0
Local cTitulo
Local cDesc1
Local cDesc2
Local cDesc3

If _cParam == "1"
	cTitulo := "Calculo dos Percentuais de rateio e fechamento mensal"
	cDesc1  := "Esta rotina ira calcular os percentuais de rateio com base nas formulas"
	cDesc2  := "de acordo com as regras contabeis"
	cDesc3  := "Especifico - Vitamassa"
	_cPerg := "FECRAT"
ElseIf _cParam == "2"
	cTitulo := "Rotina de Rateio"
	cDesc1  := "Esta rotina ira gerar lancamentos contabeis"
	cDesc2  := "de acordo com as regras contabeis"
	cDesc3  := "Especifico - Vitamassa"
	_cPerg := "FECRAT"
ElseIf _cParam == "3"
	cTitulo := "Fechamento Estoque"
	cDesc1  := "Este procedimento ira encerrar as movimentacoes do estoque"
	cDesc2  := "do periodo informado no parametro"
	cDesc3  := "Especifico - Vitamassa"
	_cPerg := "ENCEST"
ElseIf _cParam == "4"
	cTitulo := "Geracao dos Criterios GGFs - Proximo Mes"
	cDesc1  := "Esta rotina ira gerar os criterios para o mes seguinte"
	cDesc2  := "baseado nos parametros a serem informados"
	cDesc3  := "Especifico - Vitamassa"
	_cPerg := "COPRAT"
ElseIf _cParam == "5"
	cTitulo := "Exclusao - Rotina de Rateio"
	cDesc1  := "Esta rotina ira excluir os lancamentos contabeis"
	cDesc2  := "gerados anteriormente de acordo com as regras contabeis"
	cDesc3  := "Especifico - Vitamassa"
	_cPerg := "FECRAT"
Endif

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
	If _cParam == "1"
		Processa( {|lEnd| Gera_Perc(@lEnd,_cPerg)}, "Aguarde...","Calculando Percentual...", .T. )
	ElseIf _cParam == "2"
		Processa( {|lEnd| Gera_Con(@lEnd,_cPerg)}, "Aguarde...","Gerando lancamentos contabeis....", .T. )
	ElseIf _cParam == "3"
		Processa( {|lEnd| FECH_EST(@lEnd,_cPerg)}, "Aguarde...","Fechando Estoque....", .T. )
	ElseIf _cParam == "4"
		Processa( {|lEnd| COP_RAT(@lEnd,_cPerg)}, "Aguarde...","Copiando criterios....", .T. )
	ElseIf _cParam == "5"
		Processa( {|lEnd| EXC_RAT(@lEnd,_cPerg)}, "Aguarde...","Excluindo lancamentos contabeis....", .T. )
	Endif
	Return Nil
	
*----------------------------------------------------------------
Static Function COP_RAT(lEnd,_cPerg)
*----------------------------------------------------------------
Local bCampo := { |nCPO| Field(nCPO)}
Pergunte(_cPerg,.f.)
dbSelectArea("PC2")
dbSetOrder(2)
If dbSeek(xFilial()+mv_par02)
	Alert("Periodo ja incluido")
	Return
Endif
If !(Substr(mv_par01,1,2) >= "01" .and. Substr(mv_par01,1,2) <= "13") .or. !(Substr(mv_par02,1,2) >= "01" .and. Substr(mv_par02,1,2) <= "13")
	Alert("Inconsistencia no mes informado")
	Return
Endif
If Substr(mv_par02,3,2) < Substr(mv_par01,3,2)
	Alert("Ano informado para geracao menor que o ano original!")
	Return
Endif
dbSelectArea("PC2")
dbSetOrder(2)
If dbSeek(xFilial()+mv_par01)
	While !Eof() .and. xFilial("PC2")+mv_par01 == PC2->PC2_FILIAL + PC2->PC2_MESANO .AND. xFilial("PC2") == PC2_FILIAL
		FOR I := 1 to FCount()
			M->&(EVAL(bCampo,I)) := FieldGet(I)
		Next I
		_nTamCHV := Len(PC2->PC2_CHVCTB)
		M->PC2_MESANO := mv_par02
		M->PC2_DTCONT := Ctod("  /  /  ")
		M->PC2_CHVCTB := Space(_nTamCHV)
		_aAreaPC2 := GetArea()
		_nOpca := AxIncluiAuto("PC2")
		RestArea(_aAreaPC2)
		dbSkip()
	End
	dbSelectArea("PC2")
	dbSetOrder(2)
	dbSeek(xFilial()+mv_par02)
Else
	Alert("Periodo origem nao encontrado")
Endif
Return
*----------------------------------------------------------------
Static Function FECH_EST(lEnd,_cPerg)
*----------------------------------------------------------------
Local _dUlmes := GETMV("MV_ULMES")
Local _aArea  := GetArea()
Pergunte(_cPerg,.f.)
If mv_par01 >= _dUlmes
	dbSelectArea("SX6")
	GetMv("MV_DBLQMOV")
	RecLock("SX6",.F.)
	Replace X6_CONTEUD With Dtoc(mv_par01)
	MsUnLock()
	Alert("Periodo fechado")
Else
	Alert("Periodo informado ja esta fechado")
Endif
Return
*----------------------------------------------------------------
Static Function Gera_Perc(lEnd,_cPerg)
*----------------------------------------------------------------
Local _aArea := GetArea()
Pergunte(_cPerg,.F.)
dbSelectArea("PC2")
dbSetOrder(2)
dbSeek(xFilial()+mv_par01+mv_par02,.t.)
While !Eof() .and. mv_par01 == PC2->PC2_MESANO .and. xFilial("PC2") == PC2->PC2_FILIAL .and. mv_par03 >= PC2->PC2_CODIGO
	_cCod  := PC2->PC2_CODIGO
	_cForm := PC2->PC2_FORMUL
	_ccDest := PC2->PC2_CCDEST
	_cAreaZF := GetArea()
	If Empty(_cForm) .or. Empty(_ccDest)
		dbSkip()
		Loop
	Endif
	If !Empty(PC2->PC2_DTCONT)
		Alert("Percentual NAO pode ser calculado! Lancamentos contabeis ja foram gerados")
		Return
	Endif
	_cProg := Alltrim(Posicione("SM4",1,xFilial("SM4")+_cForm,"M4_FORMULA"))
	_cProg := Substr(_cProg,2)
	_cProg := Substr(_cProg,1,Len(_cProg)-1)
	&_cProg
	RestArea(_cAreaZF)
	While !Eof() .and. mv_par01 == PC2->PC2_MESANO .and. xFilial("PC2") == PC2->PC2_FILIAL .and. _cCod == PC2->PC2_CODIGO
		RecLock("PC2",.F.)
		Replace PC2_DTPERC with dDataBase
		MsUnLock()
		dbSkip()
	End
End
RestArea(_aArea)
Return

*----------------------------------------------------------------
User Function UltDiaM()
*----------------------------------------------------------------
Local _cAno := Space(02)
Local _cMesAno := Space(04)
Local _ddata := Ctod("  /  /  ")
Local _cMesAno := Space(02)
_cPerg := "FECRAT"
Pergunte(_cPerg,.f.)
_cMesAno := mv_par01
_cAno := Substr(_cMesAno,3,2)
If Substr(_cMesAno,1,2) == "12"
	_dData := Ctod("31/12/"+_cAno)
Else
	_cMesSeq := Strzero(Val(Substr(_cMesAno,1,2))+1,2)
	_dDataSeq := Ctod("01/"+_cMesSeq+"/"+Substr(_cMesAno,3,2))
	_dData := _dDataSeq - 1  // Pegar o ultimo dia do mes
Endif
_cMesAno := Substr(Dtos(_dData),5,2) + Substr(Dtos(_dData),3,2)
Return({_dData,_cMesAno})

*----------------------------------------------------------------
Static Function Gera_Con(lEnd,_cPerg)
*----------------------------------------------------------------
Local _aArea := GetArea()
Local _lRet := .t.
Local _cContade,_cContaAt,_cCCOrig,_cMA, _cContaRt, _cForm, _ccDest
Local _cCod
Local _aArePC2, _cDtCtb
Pergunte(_cPerg,.F.)
dbSelectArea("PC2")
dbSetOrder(2)
dbSeek(xFilial()+mv_par01+mv_par02,.t.)
While !Eof() .and. mv_par01 == PC2->PC2_MESANO .and. xFilial("PC2") == PC2->PC2_FILIAL .and. mv_par03 >= PC2->PC2_CODIGO
	_lRet := .t.
	_cDtCtb := PC2->PC2_DTCONT
	If !Empty(_cDtCtb)
		dbSkip()
		Loop
	Endif
	_cCod := PC2->PC2_CODIGO
	_cContade := PC2->PC2_CONTA
	_cContaAt := PC2->PC2_CONTA2
	_cContNde := PC2->PC2_NCONT
	_cContNAt := PC2->PC2_NCONT2
	_cContaRt := PC2->PC2_CONTA3
	_cCCOrig  := PC2->PC2_CCORIG
	_cForm    := PC2->PC2_FORMUL
	_ccDest   := PC2->PC2_CCDEST
	_cMA      := "20" + Substr(PC2->PC2_MESANO,3,2) + Substr(PC2->PC2_MESANO,1,2)
	_cChvCTB  := ""
	_aArePC2  := GetArea()
	If !Empty(_cForm) .and. Empty(_ccDest)
		_cProg := Alltrim(Posicione("SM4",1,xFilial("SM4")+_cForm,"M4_FORMULA"))
		_cProg := Substr(_cProg,2)
		_cProg := Substr(_cProg,1,Len(_cProg)-1)
		_lRet := &_cProg
		If _lRet
			dDataLanc := Dtos(CT2->CT2_DATA)
			cLote     := CT2->CT2_LOTE
			cSubLote  := CT2->CT2_SBLOTE
			cDoc      := CT2->CT2_DOC
			_cChvCTB  := dDataLanc+cLote+cSubLote+cDoc
		Endif
	Else
		_nMov     := u_Calc_Con(_cContade,_cContaAt,_cCCOrig,_cMA,_cContaRt,_cContNde,_cContNAt)
		If _nMov <> 0
			_lRet := Gr_Lanc(_cCod,_cContade,_cContaAt,_cCCOrig,_cMA,_nMov)
		Endif
	Endif
	RestArea(_aArePC2)
	Pergunte(_cPerg,.F.)
	While !Eof() .and. mv_par01 == PC2->PC2_MESANO .and. xFilial("PC2") == PC2->PC2_FILIAL .and. _cCod == PC2->PC2_CODIGO
		dbSelectArea("PC2")
		If _lRet
			RecLock("PC2",.F.)
			Replace PC2_DTCONT with dDataBase
			If Empty(PC2->PC2_CHVCTB)
				Replace PC2_CHVCTB with _cChvCTB
			Endif
			MsUnLock()
		Endif
		dbSkip()
	End
End
Return
*-----------------------------------------------------------------------------
User Function Calc_Con(_cContade,_cContaAt,_cCCOrig,_cMA,_cContaRt,_cContNde,_cContNAt)
*-----------------------------------------------------------------------------
Local _aArea := GetArea()
Local _cMContab := GetMV("MV_MCONTAB")
Local _nMovimen := 0
Local nDebito := 0
Local nCredito := 0
If _cMContab == "CTB"
	If !Empty(_cCCOrig)
		If !Empty(_cContaAt) .and. Posicione("CT1",1,xFilial("CT1")+_cContaAt,"CT1_CLASSE") == "1"
			_cContaAt := Alltrim(_cContaAt) + "Z"
		Endif
		If !Empty(_cContaRt) .and. Posicione("CT1",1,xFilial("CT1")+_cContaRt,"CT1_CLASSE") == "1"
			_cContaRt := Alltrim(_cContaRt) + "Z"
		Endif
		cQuery := "SELECT SUM(CQ3_DEBITO) DEBITO, SUM(CQ3_CREDIT) CREDITO "
		cQuery += "FROM "+RetSqlName("CQ3")+" CQ3 "
		cQuery += "WHERE EXISTS(SELECT CT1_CONTA FROM "
		cQuery += RetSqlName("CT1")+ " WHERE CT1_FILIAL = '" + xFilial("CT1") + "' AND "
		cQuery += "CT1_CONTA = CQ3.CQ3_CONTA AND "
		cQuery += "D_E_L_E_T_ = ' ') AND "
		cQuery += "CQ3.CQ3_FILIAL ='"+xFilial("CQ3")+"' AND "
		cQuery += "CQ3.CQ3_CCUSTO = '" + _cCCOrig + "' AND "
		cQuery += "SUBSTRING(CQ3.CQ3_DATA,1,6) = '"+_cMA+"' AND "
		If !Empty(_cContaRt)
			cQuery += "((CQ3.CQ3_CONTA >= '"+_cContade+"' AND "
			cQuery += "CQ3.CQ3_CONTA <= '"+_cContaAt+"') OR CQ3.CQ3_CONTA = '"+_cContaRt+"') AND "
		Else
			cQuery += "CQ3.CQ3_CONTA >= '"+_cContade+"' AND "
			cQuery += "CQ3.CQ3_CONTA <= '"+_cContaAt+"' AND "
		Endif
		If !Empty(_cContNde) .or. !Empty(_cContNAt)
			_cQRestr := ""
			dbSelectArea("CT1")
			dbSetOrder(1)
			dbSeek(xFilial("CT1")+_cContNde,.t.)
			While !Eof() .and. _cContNAt >= CT1->CT1_CONTA
				If Empty(_cQRestr)
					_cQRestr += "(CQ3.CQ3_CONTA <> '"+CT1->CT1_CONTA+"'"
				Else
					_cQRestr += " AND CQ3.CQ3_CONTA <> '"+CT1->CT1_CONTA+"'"
				Endif
				dbSkip()
			End
			If !Empty(_cQRestr)
				_cQRestr += ") AND "
				cQuery   += _cQRestr
			Endif
		Endif
		cQuery += "CQ3.CQ3_MOEDA ='01' AND "
		cQuery += "CQ3.CQ3_TPSALD ='1' AND "
		cQuery += "CQ3.D_E_L_E_T_ = ' ' "
		cQuery := ChangeQuery(cQuery)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"SLDATU",.T.,.F.)
		_nMovimen := (SLDATU->DEBITO - SLDATU->CREDITO)
		dbSelectArea("SLDATU")
		dbCloseArea()
	Endif
Else
	Alert("Rotina criada para funcionar apenas no modulo da Contabilidade Gerencial")
	_nMovimen := 0
Endif
RestArea(_aArea)
Return(_nMovimen)
*---------------------------------------------------------------------------------------------------------
Static Function Gr_Lanc(_cCod,_cContade,_cContaAt,_cCCOrig,_cMA,_nMov)
*---------------------------------------------------------------------------------------------------------
Local _aArea := GetArea()
Local _cMesAno := Substr(_cMA,5,2)+Substr(_cMA,3,2)
Local _nTot := 0
Local _lRet := .t.
Local _cRotina := "RATEIO" + Alltrim(_cCod)
Local _cMContab := GetMV("MV_MCONTAB")
Local _cItemC := cFilAnt + "0"
Private _aCab		:= {}
Private _aItem		:= {}
Private _aTotItem	:= {}
Private _cLote
Private _cSeqDoc := "000001"
Private lMsErroAuto := .F.
dbSelectArea("SX5")
dbSeek(xFilial("SX5")+"09RAT")
_cLote:=PADR(IIF(Found(),Trim(X5Descri()),"RAT"),Len(CT2->CT2_LOTE))
_lInverte := .f.
_lInv := .f.
_cDay := Stod(_cMA+"01")
_dDtRef := LastDay( _cDay )
_dDataAtu := dDataBase
dbSelectArea("CT2")
dbSetOrder(1)
dbSeek(xFilial()+Dtos(_dDtRef)+_cLote+"001"+_cSeqDoc)
While !Eof() .and. xFilial("CT2")+Dtos(_dDtRef)+_cLote+"001"+_cSeqDoc == CT2->(CT2_FILIAL+Dtos(CT2_DATA)+CT2_LOTE+CT2_SBLOTE+CT2_DOC)
	_cSeqDoc := Soma1(_cSeqDoc)
	dbSeek(xFilial()+Dtos(_dDtRef)+_cLote+"001"+_cSeqDoc)
End
If _nMov < 0
	_lInverte := .t.
	_nMov := ABS(_nMov)
Endif
dDataBase := _dDtRef
dbSelectArea("PC2")
dbSetOrder(1)
dbSeek(xFilial()+_cCod+_cMesAno)
While !Eof() .and. _cCod== PC2->PC2_CODIGO .and. _cMesAno == PC2->PC2_MESANO .and. xFilial("PC2") == PC2->PC2_FILIAL
	_nPerc := PC2->PC2_PERC
	_cHist := Alltrim(PC2->PC2_DESC)
	_cForm := PC2->PC2_FORMUL
	_ccDest := PC2->PC2_CCDEST
	_cConta3 := PC2->PC2_CONTA3
	If _nPerc > 0 .and. _nMov > 0
		_lUltimo := .t.
		_nRegis := Recno()
		dbSkip()
		While !Eof() .and. _cCod== PC2->PC2_CODIGO .and. _cMesAno == PC2->PC2_MESANO .and. xFilial("PC2") == PC2->PC2_FILIAL
			If PC2->PC2_PERC > 0
				_lUltimo := .f.
				Exit
			Endif
			dbSkip()
		End
		dbgoTo(_nRegis)
		If !_lUltimo
			_nSaldo := Round(_nMov * _nPerc/100,2)
		Else
			_nSaldo := _nMov - _nTot
			If _nSaldo < 0 // valor rateado pequeno
				For IT:=1 to Len(_aTotItem)
					If _aTotItem[IT,2,2] == "1"
						If _aTotItem[IT,5,2] > ABS(_nSaldo)
							_aTotItem[IT,5,2] := _aTotItem[IT,5,2] - ABS(_nSaldo)
							_nSaldo := 0
							Exit
						Endif
					Endif
				Next
			Endif			
		Endif
		If _nSaldo = 0
			dbSelectArea("PC2")
			dbSkip()
			Loop
		Endif
		If Len(_aCab) == 0
			_cLinha	:= "00"
			If _cMContab <> "CTB"
				_aCab := {{"I2_DATA"	,_dDtRef	,NIL},;
				{"I2_LOTE"		,_cLote		,NIL},;
				{"I2_DOC"		,_cSeqDoc	,NIL}}
			Else
				_aCab := {{"CT2_DATA"	,_dDtRef	,NIL},;
							{"CLOTE"	,_cLote	,NIL},;
							{"CDOC"	,_cSeqDoc,NIL}}
			Endif
			If !Empty(_cConta3)
				_nSldCC := u_Calc_Con(_cConta3,_cConta3,_cCCOrig,_cMA,"")
				If _nSldCC < 0
					If _lInverte
						_lInv := .f.
					Else
						_lInv := .t.
					Endif
				Else
					If _lInverte
						_lInv := .t.
					Else
						_lInv := .f.
					Endif
				Endif
			Else
				_nSldCC := 0
			Endif
			If ABS(_nMov)-ABS(_nSldCC) > 0
				_cLinha   := Soma1(_cLinha,2)
				If !_lInverte
					If _cMContab <> "CTB"
						_aItem := {{"I2_LINHA"	,_cLinha	,NIL},;
						{"I2_DC"		,"C"		,NIL},;
						{"I2_CREDITO"	,PC2->PC2_CONTAC,NIL},;
						{"I2_VALOR"		,ABS(_nMov-_nSldCC)	,NIL},;
						{"I2_CCC"		,_cCCOrig		,NIL},;
						{"I2_MOEDAS"	,"SNNNN"		,NIL},;
						{"I2_DTVENC"	,_dDtRef		,NIL},;
						{"I2_ROTINA"	,_cRotina	,NIL},;
						{"I2_HIST"		,_cHist		,NIL}}
					Else
						_aItem := {{"CT2_LINHA"		,_cLinha	,NIL},;
						{"CT2_DC"		,"2"		,NIL},;
						{"CT2_CREDIT"	,PC2->PC2_CONTAC	,NIL},;
						{"CT2_MOEDAS"	,"SNNNN"	,NIL},;
						{"CT2_VALOR"	,ABS(_nMov-_nSldCC)	,NIL},;
						{"CT2_HIST"		,_cHist		,NIL},;
						{"CT2_CCC"		,_cCCOrig	,NIL},;
						{"CT2_ROTINA"	,_cRotina	,NIL},;
						{"CT2_DATA"	,_dDtRef	,NIL}}
					Endif
					Aadd(_aTotItem,_aItem)
				Else
					If _cMContab <> "CTB"
						_aItem := {{"I2_LINHA"	,_cLinha	,NIL},;
						{"I2_DC"		,"D"		,NIL},;
						{"I2_DEBITO"	,PC2->PC2_CONTAC,NIL},;
						{"I2_VALOR"		,ABS(_nMov-_nSldCC)	,NIL},;
						{"I2_CCD"		,_cCCOrig		,NIL},;
						{"I2_MOEDAS"	,"SNNNN"		,NIL},;
						{"I2_DTVENC"	,_dDtRef		,NIL},;
						{"I2_ROTINA"	,_cRotina	,NIL},;
						{"I2_HIST"		,_cHist		,NIL}}
					Else
						_aItem := {{"CT2_LINHA"		,_cLinha	,NIL},;
						{"CT2_DC"		,"1"		,NIL},;
						{"CT2_DEBITO"	,PC2->PC2_CONTAC	,NIL},;
						{"CT2_MOEDAS"	,"SNNNN"	,NIL},;
						{"CT2_VALOR"	,ABS(_nMov-_nSldCC)	,NIL},;
						{"CT2_HIST"		,_cHist		,NIL},;
						{"CT2_CCD"		,_cCCOrig	,NIL},;
						{"CT2_ROTINA"	,_cRotina	,NIL},;
						{"CT2_DATA"	,_dDtRef	,NIL}}
					Endif
					Aadd(_aTotItem,_aItem)
				Endif
			Endif
			If ABS(_nMov)-ABS(_nSldCC) < 0
				_cLinha   := Soma1(_cLinha,2)
				If _cMContab <> "CTB"
					_aItem := {{"I2_LINHA"	,_cLinha	,NIL},;
					{"I2_DC"		,"D"		,NIL},;
					{"I2_DEBITO"	,PC2->PC2_CONTAC,NIL},;
					{"I2_VALOR"		,ABS(_nSldCC-_nMov)	,NIL},;
					{"I2_CCD"		,_cCCOrig		,NIL},;
					{"I2_MOEDAS"	,"SNNNN"		,NIL},;
					{"I2_DTVENC"	,_dDtRef		,NIL},;
					{"I2_ROTINA"	,_cRotina	,NIL},;
					{"I2_HIST"		,_cHist		,NIL}}
				Else
					_aItem := {{"CT2_LINHA"		,_cLinha	,NIL},;
					{"CT2_DC"		,"1"		,NIL},;
					{"CT2_DEBITO"	,PC2->PC2_CONTAC	,NIL},;
					{"CT2_MOEDAS"	,"SNNNN"	,NIL},;
					{"CT2_VALOR"	,ABS(_nSldCC-_nMov)	,NIL},;
					{"CT2_HIST"		,_cHist		,NIL},;
					{"CT2_CCD"		,_cCCOrig	,NIL},;
					{"CT2_ROTINA"	,_cRotina	,NIL},;
					{"CT2_DATA"	,_dDtRef	,NIL}}
				Endif
				Aadd(_aTotItem,_aItem)
			Endif
			If _nSldCC > 0
				_cLinha   := Soma1(_cLinha,2)
				//jubirajara tratra inversao dos absorvidos
				if !_lInv
					If _cMContab <> "CTB"
						_aItem := {{"I2_LINHA"	,_cLinha	,NIL},;
						{"I2_DC"	,"C"		,NIL},;
						{"I2_CREDITO"	,_cConta3,NIL},;
						{"I2_VALOR"		,ABS(_nSldCC)	,NIL},;
						{"I2_CCC"		,_cCCOrig		,NIL},;
						{"I2_MOEDAS"	,"SNNNN"		,NIL},;
						{"I2_DTVENC"	,_dDtRef		,NIL},;
						{"I2_ROTINA"	,_cRotina	,NIL},;
						{"I2_HIST"		,_cHist		,NIL}}
					Else
						_aItem := {{"CT2_LINHA"		,_cLinha	,NIL},;
						{"CT2_DC"		,"2"		,NIL},;
						{"CT2_CREDIT"	,_cConta3	,NIL},;
						{"CT2_MOEDAS"	,"SNNNN"	,NIL},;
						{"CT2_VALOR"	,ABS(_nSldCC)	,NIL},;
						{"CT2_HIST"		,_cHist		,NIL},;
						{"CT2_CCC"		,_cCCOrig	,NIL},;
						{"CT2_ROTINA"	,_cRotina	,NIL},;
						{"CT2_DATA"	,_dDtRef	,NIL}}
					Endif
				ELSE
					If _cMContab <> "CTB"
						_aItem := {{"I2_LINHA"	,_cLinha	,NIL},;
						{"I2_DC"	,"D"		,NIL},;
						{"I2_DEBITO"	,_cConta3,NIL},;
						{"I2_VALOR"		,ABS(_nSldCC)	,NIL},;
						{"I2_CCD"		,_cCCOrig		,NIL},;
						{"I2_MOEDAS"	,"SNNNN"		,NIL},;
						{"I2_DTVENC"	,_dDtRef		,NIL},;
						{"I2_ROTINA"	,_cRotina	,NIL},;
						{"I2_HIST"		,_cHist		,NIL}}
					Else
						_aItem := {{"CT2_LINHA"		,_cLinha	,NIL},;
						{"CT2_DC"		,"1"		,NIL},;
						{"CT2_DEBITO"	,_cConta3	,NIL},;
						{"CT2_MOEDAS"	,"SNNNN"	,NIL},;
						{"CT2_VALOR"	,ABS(_nSldCC),NIL},;
						{"CT2_HIST"		,_cHist		,NIL},;
						{"CT2_CCD"		,_cCCOrig	,NIL},;
						{"CT2_ROTINA"	,_cRotina	,NIL},;
						{"CT2_DATA"	,_dDtRef	,NIL}}
					Endif
				ENDIF
				Aadd(_aTotItem,_aItem)
			ElseIf _nSldCC < 0
				_cLinha   := Soma1(_cLinha,2)
				//jubirajara tratra inversao dos absorvidos
/*
				if _lInv
					If _cMContab <> "CTB"
						_aItem := {{"I2_LINHA"	,_cLinha	,NIL},;
						{"I2_DC"	,"C"		,NIL},;
						{"I2_CREDITO"	,_cConta3,NIL},;
						{"I2_VALOR"		,ABS(_nSldCC)	,NIL},;
						{"I2_CCC"		,_cCCOrig		,NIL},;
						{"I2_MOEDAS"	,"SNNNN"		,NIL},;
						{"I2_DTVENC"	,_dDtRef		,NIL},;
						{"I2_ROTINA"	,_cRotina	,NIL},;
						{"I2_HIST"		,_cHist		,NIL}}
					Else
						_aItem := {{"CT2_LINHA"		,_cLinha	,NIL},;
						{"CT2_DC"		,"2"		,NIL},;
						{"CT2_CREDIT"	,_cConta3	,NIL},;
						{"CT2_MOEDAS"	,"SNNNN"	,NIL},;
						{"CT2_VALOR"	,ABS(_nSldCC)	,NIL},;
						{"CT2_HIST"		,_cHist		,NIL},;
						{"CT2_CCC"		,_cCCOrig	,NIL},;
						{"CT2_ROTINA"	,_cRotina	,NIL},;
						{"CT2_ITEMC"	,_cItemC	,NIL},;
						{"CT2_ITEMD"	,_cItemC	,NIL},;
						{"CT2_DATA"	,_dDtRef	,NIL}}
					Endif
				ELSE
*/
					If _cMContab <> "CTB"
						_aItem := {{"I2_LINHA"	,_cLinha	,NIL},;
						{"I2_DC"	,"D"		,NIL},;
						{"I2_DEBITO"	,_cConta3,NIL},;
						{"I2_VALOR"		,ABS(_nSldCC)	,NIL},;
						{"I2_CCD"		,_cCCOrig		,NIL},;
						{"I2_MOEDAS"	,"SNNNN"		,NIL},;
						{"I2_DTVENC"	,_dDtRef		,NIL},;
						{"I2_ROTINA"	,_cRotina	,NIL},;
						{"I2_HIST"		,_cHist		,NIL}}
					Else
						_aItem := {{"CT2_LINHA"		,_cLinha	,NIL},;
						{"CT2_DC"		,"1"		,NIL},;
						{"CT2_DEBITO"	,_cConta3	,NIL},;
						{"CT2_MOEDAS"	,"SNNNN"	,NIL},;
						{"CT2_VALOR"	,ABS(_nSldCC),NIL},;
						{"CT2_HIST"		,_cHist		,NIL},;
						{"CT2_CCD"		,_cCCOrig	,NIL},;
						{"CT2_ROTINA"	,_cRotina	,NIL},;
						{"CT2_DATA"	,_dDtRef	,NIL}}
					Endif
//				ENDIF
				Aadd(_aTotItem,_aItem)
			Endif
		Endif
		_cLinha   := Soma1(_cLinha,2)
		If !_lInverte
			If _cMContab <> "CTB"
				_aItem    := {{"I2_LINHA"	,_cLinha	,NIL},;
				{"I2_DC"		,"D"		,NIL},;
				{"I2_DEBITO"	,PC2->PC2_CONTAD,NIL},;
				{"I2_VALOR"		,_nSaldo		,NIL},;
				{"I2_CCD"		,PC2->PC2_CCDEST	,NIL},;
				{"I2_MOEDAS"	,"SNNNN"		,NIL},;
				{"I2_DTVENC"	,_dDtRef		,NIL},;
				{"I2_ROTINA"	,_cRotina	,NIL},;
				{"I2_HIST"		,_cHist		,NIL}}
			Else
				_aItem := {{"CT2_LINHA"		,_cLinha	,NIL},;
				{"CT2_DC"		,"1"		,NIL},;
				{"CT2_DEBITO"	,PC2->PC2_CONTAD	,NIL},;
				{"CT2_MOEDAS"	,"SNNNN"	,NIL},;
				{"CT2_VALOR"	,_nSaldo	,NIL},;
				{"CT2_HIST"		,_cHist		,NIL},;
				{"CT2_CCD"		,PC2->PC2_CCDEST	,NIL},;
				{"CT2_ROTINA"	,_cRotina	,NIL},;
				{"CT2_DATA"	,_dDtRef	,NIL}}
			Endif
			Aadd(_aTotItem,_aItem)
		Else
			If _cMContab <> "CTB"
				_aItem    := {{"I2_LINHA"	,_cLinha	,NIL},;
				{"I2_DC"		,"C"		,NIL},;
				{"I2_CREDITO"	,PC2->PC2_CONTAD,NIL},;
				{"I2_VALOR"		,_nSaldo		,NIL},;
				{"I2_CCC"		,PC2->PC2_CCDEST	,NIL},;
				{"I2_MOEDAS"	,"SNNNN"		,NIL},;
				{"I2_DTVENC"	,_dDtRef		,NIL},;
				{"I2_ROTINA"	,_cRotina	,NIL},;
				{"I2_HIST"		,_cHist		,NIL}}
			Else
				_aItem := {{"CT2_LINHA"		,_cLinha	,NIL},;
				{"CT2_DC"		,"2"		,NIL},;
				{"CT2_CREDIT"	,PC2->PC2_CONTAD	,NIL},;
				{"CT2_MOEDAS"	,"SNNNN"	,NIL},;
				{"CT2_VALOR"	,_nSaldo	,NIL},;
				{"CT2_HIST"		,_cHist		,NIL},;
				{"CT2_CCC"		,PC2->PC2_CCDEST	,NIL},;
				{"CT2_ROTINA"	,_cRotina	,NIL},;
				{"CT2_DATA"	,_dDtRef	,NIL}}
			Endif
			Aadd(_aTotItem,_aItem)
		Endif
		_nTot := _nTot + _nSaldo
	Endif
	dbSelectArea("PC2")
	dbSkip()
End
If Len(_aCab) > 0
	If _cMContab <> "CTB"
		MSExecAuto({|x,y,Z| Cona050(x,y,Z)},NIL,_aCab,_aTotItem)
	Else
		MsgRun("Gerando Lancamento Contabil...","Aguarde...",{|| MSExecAuto({|x,y,Z| CTBA102(x,y,Z)},_aCab,_aTotItem,3)})
		dDataLanc := Dtos(CT2->CT2_DATA)
		cLote     := CT2->CT2_LOTE
		cSubLote  := CT2->CT2_SBLOTE
		cDoc      := CT2->CT2_DOC
	Endif
	If lMsErroAuto
		MostraErro()
		_lRet := .f.
	Else
		dbSelectArea("PC2")
		dbSetOrder(1)
		dbSeek(xFilial()+_cCod+_cMesAno)
		While !Eof() .and. _cCod == PC2->PC2_CODIGO .and. _cMesAno == PC2->PC2_MESANO .and. xFilial("PC2") == PC2->PC2_FILIAL
			RecLock("PC2",.F.)
			Replace PC2_DTCONT with dDataBase,;
					PC2_CHVCTB with dDataLanc+cLote+cSubLote+cDoc
			MsUnLock()
			dbSkip()
		End
	Endif
Endif
dDataBase := _dDataAtu
RestArea(_aArea)
Return(_lRet)

*---------------------------------------------------------------------------------------------------------
User Function Rlegbrod()
*---------------------------------------------------------------------------------------------------------
BrwLegenda(cCadastro," Legenda ",{	{"ENABLE"   ,"Percentual calculado"},;
{"DISABLE"  ,"Percentual NAO calculado"},;
{"BR_CINZA" ,"Contabilizado"}})
Return
*---------------------------------------------------------------------------------------------------------
Static Function Val_Codcp(_cPer,_cCodigo,_cDescCop,_cCod)
*---------------------------------------------------------------------------------------------------------
Local _lRet := .t.
Local _aArea := GetArea()
If _cCodigo == _cCod
	Alert("Nao é permitido copiar valores do mesmo codigo")
	_lRet := .f.
Endif
If _lRet
	dbSelectArea("PC2")
	dbSetOrder(1)
	If dbSeek(xFilial()+_cCodigo+_cPer)
		_cDescCop := PC2->PC2_DESC
	Else
		Alert("Codigo invalido")
		_lRet := .f.
	Endif
Endif
RestArea(_aArea)
Return(_lRet)

*----------------------------------------------------------------
Static Function EXC_RAT(lEnd,_cPerg)
*----------------------------------------------------------------
Local _aArea := GetArea()
Local _lRet := .t.
Local _cContade,_cContaAt,_cCCOrig,_cMA, _cContaRt, _cForm, _ccDest
Local _cCod
Local _cMesAno
Local _aArePC2
Local _cDesc
Local _aData   := u_UltDiaM()
Local dDatFin  := _aData[1]
Local _cLotGer
Local _cItemC := cFilAnt + "0"

Private _aCab		:= {}
Private _aItem		:= {}
Private _aTotItem	:= {}
Private lMsErroAuto := .F.

If MsgYesNo("Confirma a exclusao dos lancamentos contabeis gerados?","Atencao!")	
	Pergunte(_cPerg,.F.)
	dbSelectArea("PC2")
	dbSetOrder(2)
	If dbSeek(xFilial()+mv_par01+mv_par02,.t.)
		While !Eof() .and. mv_par01 == PC2->PC2_MESANO .and. xFilial("PC2") == PC2->PC2_FILIAL .and. mv_par03 >= PC2->PC2_CODIGO
			If Empty(PC2->PC2_DTCONT)
				dbSkip()
				Loop
			Endif
			_cCod := PC2->PC2_CODIGO
			_cDesc := PC2->PC2_DESC
			_cMesAno := PC2->PC2_MESANO
			_cChavCtb := PC2->PC2_CHVCTB
			_lFlag := .f.
			dbSelectArea("CT2")
			dbSetOrder(1)
			If !Empty(_cChavCtb) .and. dbSeek(xFilial()+_cChavCtb)
				_nReg := CT2->(recno())
				dDataLanc := CT2->CT2_DATA
				cLote     := CT2->CT2_LOTE
				cSubLote  := CT2->CT2_SBLOTE
				cDoc      := CT2->CT2_DOC
				lSubLote  := Empty(cSubLote)
				cLoteSub 	:= GetMv("MV_SUBLOTE")
				Ctba102Cap("CT2",_nReg,5,'CTBA102',@dDataLanc,@cLote,@cSubLote,@cDoc)  // Chama funcao para confirmar exclusao do lancamento contabil
				dbSelectArea("CT2")
				dbSetOrder(1)
				If dbSeek(xFilial()+_cChavCtb)
					_lFlag := .f.
				Else
					_lFlag := .t.       // se não encontrou, foi excluido
				Endif
			Else
				_lFlag := .t. // Nao encontrou significa que pode tirar o flag do PC2
			Endif
			If _lFlag  // Se nao existir lancamento contabil limpar o Flag de contabilizacao
				dbSelectArea("CT2")
				cQuery := "UPDATE " + RetSqlName("PC2") + " SET PC2_DTCONT = '        ', PC2_CHVCTB = '"+Space(23)+"'"
				cQuery := cQuery + " WHERE PC2_FILIAL  = '"+xFilial("PC2")+"' AND "
				cQuery := cQuery + RetSQLName("PC2")+".D_E_L_E_T_ <> '*' AND "
				cQuery := cQuery + " PC2_CODIGO = '"+_cCod+"' AND"
				cQuery := cQuery + " PC2_MESANO = '"+_cMesAno+"'"
				TCSQLExec(cQuery)
			Endif
			Pergunte(_cPerg,.F.)   // Volta as perguntas originais
			dbSelectArea("PC2")
			While !Eof() .and. _cMesAno == PC2->PC2_MESANO .and. xFilial("PC2") == PC2->PC2_FILIAL .and. _cCod == PC2->PC2_CODIGO
				dbSkip()
			End
		End
	Endif
Endif
Return