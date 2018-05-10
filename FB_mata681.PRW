#include "Protheus.ch" 
#Include "FBMATA681.CH"
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "TOPCONN.CH"
#DEFINE ENTER Chr(10)+Chr(13)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFun…o    ณA681Incluiณ Autor ณ Rodrigo de A. Sartorio ณ Data ณ 07/01/97 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณ Programa de inclusao do movimento de estoque                ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณSintaxe   ณ Void A680Inclui(cExp1,nExp1,nExp2)                          ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณParametrosณ cExp1 = Alias do Arquivo                                    ณฑฑ
ฑฑณ          ณ nExp1 = Numero do registro                                  ณฑฑ
ฑฑณ          ณ cExp1 = Opcao escolhida                                     ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณUso       ณ MATA681                                                     ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function FB681Inclui(cAlias,nReg,nOpc)
Local nOpca		 := 0
Local lEncerraOP :=.F.
Local lMt681Inc  := Existblock("MT681INC")
Local lMt681AInc := Existblock("MT681AIN")
Local lMt681But  := Existblock("MT681BUT")
Local lMt681Can  := Existblock("MT681CAN")
Local aChkBaixaC := Nil
Local aButtons   := {}
Local aUsrBut    := {}
Local lGeraD3Pro := .F.
Local aAreaSD3   := {}
Local aAreaSH6   := {}
Local aPedidos   := {}
Local nX		   := 0
Local cDocSD3    := ""
Local cOpAtual   := ' '
Local cOperAtual := ' '
Local cSeqAtual  := ' '

Local nPercPrM   := 0
Local aDigLot    := {}
Local lDISTMOV   := SuperGetMV("MV_DISTMOV",.F.,.F.)
Local cQipMat	 := GetNewPar("MV_QIPMAT","N")
Local nPrapont   := GetNewPar("MV_PRAPONT",2)  // padrใo default 2
Local lEncerOp   := SuperGetMV("MV_ACDOPPT",.F.,.F.)
Local lMVpar     := IsInCallStack("ACDV023") .or. IsInCallStack("ACDV025") .or. IsInCallStack("ACDA080")
Local lImpEtiq   := SuperGetMV("FB_IMPETIQ",.F.,.F.)
Local _cLocNCF   := Alltrim(SuperGetMV("FB_LOCNCF",.F.,"02"))
Local _lNConf	 := .F.
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
Local aYesFields:= {"D5_PRODUTO","D5_LOCAL","D5_QUANT","D5_LOTECTL","D5_NUMLOTE", "D5_XDESCRI", "D5_QTSEGUM", "D5_DTVALID", "D5_OP"}
Local cTudoOk := "u_FB_CriaMOD() .and. u_FB_A680Est() .and. u_FBIniPeso() .and. A680TudoOk()"
//Local bOk     := &("{|| "+cTudoOk+"}")
Local lF3     := .F.
Local lVirtual:= .F.
Local _nModo       := GD_UPDATE // GD_DELETE+GD_UPDATE
Local cLinhaOk     := "AllwaysTrue"
Local cCampoOk     := "AllwaysTrue"
Local cApagaOk     := "u_FBAp681()"
Local cApagaNOk		:= "AllwaysFalse"
Local cIniCpos     := ""
Local cSuperApagar := ""
Local nFreeze      := nil
Local nMax         := 999999
Local aAlter       := {} // {"D5_NUMLOTE","D5_QUANT"}
Local _cTMPr0 := GETMV("MV_TMPAD")
Local bCampo := { |nCPO| Field(nCPO)}
Local _cTMREQ := PadR(SuperGetMV("MV_XREQAUT",.F.,"510"),Len(SF5->F5_CODIGO))
Local _lAtuEmp := Posicione("SF5",1,xFilial("SF5")+_cTMPr0,"F5_ATUEMP") == "S"
Local nUsado    := 0
Local aHeader   := {}
Local aCols     := {}
Local _cIdenti, nY
Local _cCampos := SuperGetMV("FB_TELAOP",.F.,"H6_OP/H6_PRODUTO/H6_OPERAC/H6_RECURSO/H6_FERRAM/H6_QTDPROD/H6_QTDPERD/H6_PT/H6_DTAPONT/H6_LOTECTL/H6_NUMLOTE/H6_DTVALID/H6_QTDPRO2/H6_XTURNO/H6_XTARA/H6_XDESC/H6_DSCREC/H6_XDESCTR/H6_LOCAL/H6_XPESOT/H6_XBLQTOL/H6_XTPPROD")
Local _aCampos := {}
Local nT := 1
Local _lAtuCp := .t.
Local oFolder
Local aTitles		:= {"PRODUCAO","RESIDUO"}
Local aPages		:= {"HEADER","HEADER"}
Local _cTipoAp	:= 1

// REFUGO
Local cSeek 	   := xFilial("SBC")+SBC->BC_XDOC
Local bWhile 	   := {|| SBC->(BC_FILIAL+BC_XDOC)}
Local bFor	 	   := {|| .T.}
Local nRecPos	   := 0
//Local aYesFields   := {"BC_PRODUTO", "BC_OP", "BC_RECURSO", "BC_QUANT"}
Local aYesFields:= {"BC_DATA","BC_OP","BC_PRODUTO", "BC_LOCORIG", "BC_TIPO","BC_MOTIVO","BC_QUANT","BC_LOTECTL","BC_NUMLOTE", "BC_DTVALID", "BC_RECURSO", "BC_OPERAC"}
Local _nModoRF     := 0 // GD_UPDATE+GD_INSERT+GD_DELETE
Local cLinhaOkRF   := "AllwaysTrue"
Local cTudoOkRF    := "AllwaysTrue"
Local cCampoOkRF   := "AllwaysTrue"
Local cApagaOkRF   := "AllwaysTrue"
Local cApagaNRF	   := "AllwaysFalse"
Local cIniCpoRF    := ""
Local cSpApagRF    := ""
Local nFreezeRF    := nil
Local nMaxRF       := 999999
Local aAlterRF     := {}
Local aHeadRF	   := {}
Private aColsRF	   := {}

Private oEnc01
Private _oEnc02
Private aTELA:=Nil,aGets:= Nil
PRIVATE nRegD3
PRIVATE aTrocaF3:={{"H6_OP","SC2"}}
PRIVATE lEnvCQProd := .F.
PRIVATE lUltOper:=Nil
Private cA240End   := CriaVar('DB_LOCALIZ')
Private cA240Est   := CriaVar('DB_ESTFIS')
PRIVATE cLocCQOrig := ""
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Impede Inclus”es com Data Inferior ou Igual a do Fechamento  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Private lModZero := .T.
//-- Variaveis utilizadas pela funcao wmsexedcf
Private aLibSDB    := {}
Private aWmsAviso  := {}
Private aTELA[0][0],aGETS[0]
Private cDocREQH6 := Replicate("0",TAMSX3("D3_DOC")[1])
Private _cFila    := ""
Private _lAptRF   := .F.
Public _aArrayRQ := {}

If dDataBase <= dDataFec
	Help (' ', 1, 'FECHTO')
	Return Nil
EndIf

aAcho := {}
dbSelectArea("SX3")
dbSetOrder(1)  //
dbSeek("SH6")
While !Eof() .And. (x3_arquivo == "SH6")
	If X3USO(x3_usado) .And. AllTrim(x3_campo) $ _cCampos
		AADD(aAcho,AllTrim(x3_campo))
	EndIf
	dbSkip()
End

//REFUGO
FillGetDados( 2 ,"SBC",2,cSeek,bWhile,bFor,/*aNoFields*/,aYesFields,,,,.T.,aHeadRF,aColsRF,,,)
nRecPos	:= GdFieldPos( "BC_REC_WT", AHeader )

nPProd := aScan( aHeadRF, { |x| Alltrim(x[2])=="BC_PRODUTO" } )
nPOP   := aScan( aHeadRF, { |x| Alltrim(x[2])=="BC_OP" } )
nPRec  := aScan( aHeadRF, { |x| Alltrim(x[2])=="BC_RECURSO" } )
nPQtd  := aScan( aHeadRF, { |x| Alltrim(x[2])=="BC_QUANT" } )
nPMot  := aScan( aHeadRF, { |x| Alltrim(x[2])=="BC_MOTIVO" } )
nPTip  := aScan( aHeadRF, { |x| Alltrim(x[2])=="BC_TIPO" } )
nPOperac  := aScan( aHeadRF, { |x| Alltrim(x[2])=="BC_OPERAC" } )

aAdd( aButtons, {,{|| OperacOP()},STR0019} )//"Opera็๕es da Ordem de Produ็ใo"
aAdd( aButtons, {,{|| u_Sel_Lote()},"Seleciona Lotes"} )//"Opera็๕es da Ordem de Produ็ใo"

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Ativa a tecla F4.                                            ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Set Key VK_F4 TO F680ShowOp()
Set Key VK_F7 TO u_Sel_Lote()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณMontagem da Variaveis de Memoria                      ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
dbSelectArea("SH6")
dbSetOrder(1)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Inicializa desta forma para criar uma nova instancia de variaveis private ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
RegToMemory( "SH6", .T., .F. )
RegToMemory( "SZ5", .T., .F. )
nOpcx := 3

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta o Array aHeader. Modo Antigo...                        ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

dbSelectArea("SX3")
dbSetOrder(1)
MsSeek("SD5")
While !Eof() .And. SX3->X3_ARQUIVO == "SD5"
	If X3Uso(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL .And. Alltrim(SX3->X3_CAMPO) $ "D5_PRODUTO/D5_LOCAL/D5_QUANT/D5_LOTECTL/D5_NUMLOTE/D5_XDESCRI/D5_QTSEGUM/D5_DTVALID/D5_OP/D5_SERIE"
		_cF3 		:= SX3->X3_F3
		_cVisual 	:= SX3->X3_VISUAL
		_cWhen 		:= SX3->X3_WHEN
		_cValid		:= SX3->X3_VALID
		If Alltrim(SX3->X3_CAMPO) == "D5_NUMLOTE"
			_cValid	:= "u_F_VldNumLt()"
		Endif
		If Alltrim(SX3->X3_CAMPO) == "D5_QUANT"
			_cValid	:= "u_F_VldQtd(M->D5_QUANT)"
		Endif
		Aadd(aHeader, {   AllTrim(X3Titulo()),;
		SX3->X3_CAMPO,;
		SX3->X3_PICTURE,;
		SX3->X3_TAMANHO,;
		SX3->X3_DECIMAL,;
		_cValid,;
		SX3->X3_USADO,;
		SX3->X3_TIPO,;
		_cF3,;
		SX3->X3_CONTEXT,;
		SX3->X3_CBOX,;
		SX3->X3_RELACAO,;
		_cWhen,;
		_cVisual } )
		nUsado++
	EndIf
	dbSelectArea("SX3")
	dbSkip()
EndDo

IF !EMPTY(aHeader)
	If nOpcx == 3
		Aadd( aCols, Array( Len( aHeader ) + 1 ) )
		For nA := 1 To Len(aHeader)
			If	aHeader[nA,10] != "V"
				aCols[Len( aCols ), nA] := CriaVar( aHeader[nA,2] )
			EndIf
		Next nA
		aCols[Len( aCols ),Len( aHeader ) + 1] :=.F.
	Endif
Endif

_cFila := u_FB_FilaImp()
If Empty(_cFila)
	Help(" ",1,"IMPRNES",,"Nใo encontrada impressora para essa esta็ใo de trabalho",4,,,,,,.F.)
	Return
Endif

dbSelectArea("SH6")

aObjects := {}

aInfo:={aSize[1],aSize[2],aSize[3],aSize[4],3,2}
/*
AAdd( aObjects, { 100, 100, .t., .t. } )
AAdd( aObjects, { 100, 100, .t., .f. } ) //Para los getdados inferiores
*/
Aadd( aObjects, { 100, 100, .T., .T. } )
Aadd( aObjects, { 315,  70, .T., .T. } )


aPosObj := MsObjSize(aInfo, aObjects)

ASHICalen(,,,.T.)
pergunte("MTA680",.F.)

DEFINE MSDIALOG oDlg TITLE cCadastro From aSize[7],00 To aSize[6],aSize[5] OF oMainWnd PIXEL

oFolder := TFolder():New( aPosObj[1,1],aPosObj[1,2],aTitles,aPages,oDlg,,,,.t.,.F.,aPosObj[2,4]-5, aPosObj[2,3])

oFolder:bSetOption := {|nAtu| Al_MudaEnc(nAtu,oFolder:nOption)}
oFolder:align:= CONTROL_ALIGN_ALLCLIENT
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Enchoice 01                                          ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
aPos:={}
dbSelectArea("SH6")
oEnc01:= MsMGet():New("SH6" ,nReg ,nOpc,,,,aAcho,aPosObj[1],,,,,cTudoOk ,oFolder:aDialogs[1], ,.F.)
//oEnc01:oBox:bChange   := {|| u_FB_IniVT("1")}
oEnc01:oBox:align:= CONTROL_ALIGN_ALLCLIENT
atela:={}
aGets:={}
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Enchoice 02                                          ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
dbSelectArea("SZ5")
oEnc02:=MsMGet():New("SZ5",nReg,nOpc,,,, ,aPosObj[1],     ,       ,        ,       ,         ,oFolder:aDialogs[2], ,.F.)
//oEnc02:oBox:bChange   := {|| u_FB_IniVT("3")}
oEnc02:oBox:align:= CONTROL_ALIGN_ALLCLIENT
aTela := aClone(oEnc02:aTela)
aGets := aClone(oEnc02:aGets)

dbSelectArea("SH6")
oGtd0 := MsNewGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3]-20,aPosObj[2,4],_nModo,cLinhaOk,cTudoOk,cIniCpos,aAlter,nFreeze,nMax,cCampoOk,cSuperApagar,cApagaOk,oFolder:aDialogs[1],aHeader,aCols)
oGtd2 := MsNewGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3]-50,aPosObj[2,4],_nModoRF,cLinhaOkRF,cTudoOkRF,cIniCpoRF,aAlterRF,nFreezeRF,nMaxRF,cCampoOkRF,cSpApagRF,cApagaOkRF,oFolder:aDialogs[2],aHeadRF,aColsRF)

ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{|| IIF(u_PesaTOk(oFolder, @_cTipoAp, oEnc01:aGets,oEnc01:aTela, oEnc02:aGets,oEnc02:aTela ,@nOpcA),oDlg:End(),"")},{||oDlg:End()},,aButtons)

If nOpca == 1
	If _cTipoAp == 2
		Private _lAptRF := .T.
		Private LA185BXEMP := .f.
		Private aItenSD3	:= {}
		dbSelectArea("SZ5")
		M->Z5_HORA := TIME()
		nOpca := AxIncluiAuto("SZ5",,)
		If __lSX8
			ConfirmSX8()
		Endif
		If Len(aColsRF) > 0 .and. !Empty(aColsRF[1,nPProd])
			Processa( {|lEnd| _lRet := u_Proc_RatRF(aColsRF)}, "Aguarde...","Processando Rateio", .T. )
			pergunte("MTA680",.F.)
		Endif
	Endif
	If _cTipoAp == 1
		Private _lAptRF := .F.
		Begin Transaction
		ASHICalen(,,,.T.)
		M->H6_PT := "P"
		dbSelectArea("SH6")
		If nOpca == 1
			nOpca := AxIncluiAuto(cAlias,,"A680AtuInc()")
			If SH6->H6_PT == "T"
				RecLock("SH6",.F.)
				Replace H6_PT with "P"
				MsUnLock()
			Endif
		Endif
		If nOpca == 1
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณ Envia p/func. de atualizacoes (SD3,SB2,SB3,SC2,..) ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
/*
			If A680GeraD3("MOD",SH6->H6_IDENT)
				A240Atu()
				lCriaHeader := .T.
				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณ Corrige identificacao errada da RE. ณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
				dbSelectArea("SD3")
				dbGoto(nRegD3)
				RecLock("SD3",.F.)
				Replace D3_CF With "RE1"
			EndIf
*/
			If lModZero
				_cIdenti := SH6->H6_IDENT
				If SH6->H6_QTDPROD > 0 .Or. SH6->H6_QTDPERD > 0
					//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
					//ณ Busco por componentes a serem baixados na operacao ณ
					//ณ apontada                                           ณ
					//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
					aBaixaSGF := u_F637BxComp(SH6->H6_PRODUTO, A680RotPad(), SH6->H6_OPERAC, SH6->H6_OP)
					//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
					//ณ Checa se existe amarracao operacao x componente e  ณ
					//ณ se ja foi baixado o saldo empenhado para nao atualiณ
					//ณ zar novamente saldo empenhado.                     ณ
					//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
					aChkBaixaC := A680CkCmpP(SH6->H6_PRODUTO,SH6->H6_OPERAC,SH6->H6_OP)
					//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
					//ณ Caso a perda nesta operacao seja total, verifica seณ
					//ณ deve encerrar a OP ou nao.                         ณ
					//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
					lEncerraOP:=.F.
					If SH6->H6_PT == "T" .And. QtdComp(SH6->H6_QTDPROD) == QtdComp(0) .And. QtdComp(SH6->H6_QTDPERD) > QtdComp(0)
						If lEncerOp .And. (IsInCallStack("ACDV025") .Or.  IsInCallStack("ACDV023") .or. IsInCallStack("ACDA080")) .And. SH6->(B681ACDPT(H6_OP,H6_PRODUTO,H6_OPERAC))
							lEncerraOP := lEncerOp
						ElseIf l681Auto
							lEncerraOP:= .F.
						ElseIf !A680UltOper()
							
							dbSelectArea("SC2")
							SC2->(dbSetOrder(1))
							SC2->(dbSeek(xFilial("SC2")+SH6->H6_OP))
							
							If SH6->H6_QTDPERD >= (SC2->C2_QUANT - SC2->C2_QUJE)
								lEncerraOP:= Aviso(STR0007,STR0008,{STR0009,STR0010}) == 1 //"Aten็ใo"###"Este apontamento indica PERDA TOTAL da OP. Encerra produ็ใo da OP nessa opera็ใo?"###"Sim"###"Nao"
							Else
								
								nOpAtual   := SH6->H6_OP
								nOperAtual := SH6->H6_OPERAC
								nSeqAtual  := SH6->H6_SEQ
								lExistBoa  := .F.
								nSomaBoa   := 0
								
								aAreaSH6  := SH6->(GetArea())
								
								SH6->(dbclosearea())
								
								dbSelectArea("SH6")
								dbSetOrder(1)
								dbGotop()
								dbSeek(xFilial("SH6")+nOpAtual)
								
								While !Eof() .And. SH6->H6_FILIAL + SH6->H6_OP == xFilial("SH6") + nOpAtual
									If SH6->H6_FILIAL + SH6->H6_OP == xFilial("SH6") + nOpAtual .And. SH6->H6_OPERAC + SH6->H6_SEQ = nOperAtual + nSeqAtual
										If SH6->H6_QTDPROD > 0
											lExistBoa := .T.
											nSomaBoa += SH6->H6_QTDPROD
											Exit
										EndIf
									EndIf
									dbSkip()
								EndDO
								
								If ((!lExistBoa) .Or. ((SC2->C2_QUANT-nSomaBoa) = (SC2->C2_QUANT - SC2->C2_QUJE)))
									lEncerraOP:= Aviso(STR0007,STR0008,{STR0009,STR0010}) == 1 //"Aten็ใo"###"Este apontamento indica PERDA TOTAL da OP. Encerra produ็ใo da OP nessa opera็ใo?"###"Sim"###"Nao"
								EndIf
								
								SH6->(dbclosearea())
								
								dbSelectArea("SH6")
								dbSetOrder(1)
								dbGotop()
								
								RestArea(aAreaSH6)
							EndIf
						Else
							nOpAtual   := SH6->H6_OP
							nOperAtual := SH6->H6_OPERAC
							nSeqAtual  := SH6->H6_SEQ
							lExistBoa  := .F.
							
							aAreaSH6  := SH6->(GetArea())
							
							SH6->(dbclosearea())
							
							dbSelectArea("SH6")
							dbSetOrder(1)
							dbGotop()
							dbSeek(xFilial("SH6")+nOpAtual)
							
							While !Eof() .And. SH6->H6_FILIAL + SH6->H6_OP == xFilial("SH6") + nOpAtual
								If SH6->H6_FILIAL + SH6->H6_OP == xFilial("SH6") + nOpAtual .And. SH6->H6_OPERAC + SH6->H6_SEQ = nOperAtual + nSeqAtual
									If SH6->H6_QTDPROD > 0
										lExistBoa := .T.
										Exit
									EndIf
								EndIf
								dbSkip()
							EndDO
							
							If !lExistBoa
								lEncerraOP:= Aviso(STR0007,STR0008,{STR0009,STR0010}) == 1 //"Aten็ใo"###"Este apontamento indica PERDA TOTAL da OP. Encerra produ็ใo da OP nessa opera็ใo?"###"Sim"###"Nao"
							EndIf
							
							SH6->(dbclosearea())
							
							dbSelectArea("SH6")
							dbSetOrder(1)
							dbGotop()
							
							RestArea(aAreaSH6)
						EndIf
					EndIf
					
					SC2->(dbSetOrder(1))
					If SC2->(dbSeek(xFilial("SC2")+Alltrim(SH6->H6_OP)))
						nPercPrM := (SH6->H6_QTMAIOR / SC2->C2_QUANT)
					EndIf
					
					If If(!(lUltOper==Nil),lUltOper,A680UltOper()) .Or. lEncerraOP
						lGeraD3Pro := .T.
						
						A680GeraD3("PR0",SH6->H6_IDENT,lEncerraOP)
						If lSavePerda
							lSavePerda := A680GrPerd(lGeraD3Pro,@aPerda,@aHdPerda,SH6->H6_IDENT)
						EndIf
						If SH6->H6_PT == "T"
							aChkBaixaC := NIL
						EndIf
						A250Atu(cAlias,SH6->H6_IDENT,@aPedidos,,,,IIF(!Empty(aBaixaSGF) .And. !lPerdInf,SH6->H6_QTDPERD,),,,,,aChkBaixaC,,,nPercPrM,lEncerraOP)
					ElseIf aBaixaSGF # Nil
						If lSavePerda
							lSavePerda := A680GrPerd(lGeraD3Pro,@aPerda,@aHdPerda)
						EndIf
						cDocSD3 := CriaVar("D3_DOC")
						A250Atu(cAlias, SH6->H6_IDENT,,,aBaixaSGF, SH6->H6_QTDPROD, SH6->H6_QTDPERD, SH6->H6_OP, If(Empty(cDocSD3),SC2->C2_NUM,cDocSD3), SH6->H6_DTAPONT, SH6->H6_PT, aChkBaixaC,,,nPercPrM)
					Endif
					If lGeraD3Pro .and. !_lAtuEmp .and. _cIdenti == SD3->D3_IDENT .and. TYPE("_aArrayRQ") == "A" .and. Len(_aArrayRQ) > 0
						_cNumSeq := SD3->D3_NUMSEQ
						dbSelectArea("SD3")
						_aAreaD3 := GetArea()
						For nY := 1 to Len(_aArrayRQ)
							dbSelectArea("SD3")
							dbGoto(_aArrayRQ[nY])
							_cNumSeqD3 := SD3->D3_NUMSEQ
							RecLock("SD3",.F.)
							Replace D3_CF with "RE1",;
									D3_NUMSEQ with _cNumSeq,;
									D3_IDENT  with _cIdenti
							MsUnLock()
							If Rastro(SD3->D3_COD)
								dbSelectArea("SD5")
								dbSetOrder(3)
								If dbSeek(xFilial()+_cNumSeqD3+SD3->(D3_COD+D3_LOCAL+D3_LOTECTL+D3_NUMLOTE))
									RecLock("SD5",.F.)
									Replace D5_NUMSEQ with _cNumSeq
									MsUnLock()
								Endif
							Endif
						Next
						RestArea(_aAreaD3)
					Endif
					
					//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
					//ณ Abre uma tela que permito ao usuแrio endere็ar os produtos  ณ
					//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
					If Localiza(SH6->H6_PRODUTO) .And. lDISTMOV
						aADD(aDigLot,{	'0001',;
						SD3->D3_COD,;
						SD3->D3_LOCAL,;
						SD3->D3_LOTECTL,;
						SD3->D3_NUMLOTE,;
						SD3->D3_DTVALID,;
						SD3->D3_QUANT,;
						SD3->D3_NUMSEQ,;
						SD3->D3_DOC,;
						SerieNfId("SD1",5,"D1_SERIE"),;
						CriaVar("D1_FORNECE"),;
						CriaVar("D1_LOJA"),;
						.F.	 })
						A103DigEnd(aDigLot)
					EndIf
					
					//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
					//ณ Caso tenha liberado pedidos atraves da producao,   ณ
					//ณ atualiza campo no SC5                              ณ
					//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
					If Len(aPedidos) > 0
						MaLiberOk(aPedidos)
					EndIf
					A250Nutri(SH6->H6_OP)
					If lSavePerda
						If lGeraD3Pro
							aAreaSD3 := SD3->(GetArea())
							dbSelectArea("SD3")
							dbSetOrder(1)
							dbSeek(xFilial("SD3")+SH6->H6_OP+SH6->H6_PRODUTO)
							While SD3->(!EOF()) .And. xFilial("SD3")+SH6->(H6_OP+H6_PRODUTO) == SD3->(D3_FILIAL+D3_OP+D3_COD)
								If SD3->D3_IDENT == SH6->H6_IDENT .And. SD3->D3_CF == "PR0" .And. SD3->D3_ESTORNO <> "S"
									GravaSBC(SH6->H6_OP,SH6->H6_OPERAC,SH6->H6_RECURSO,"MATA680",SD3->D3_NUMSEQ,SH6->H6_IDENT)
									Exit
								EndIf
								SD3->(dbSkip())
							EndDo
							RestArea(aAreaSD3)
						Else
							GravaSBC(SH6->H6_OP,SH6->H6_OPERAC,SH6->H6_RECURSO,"MATA680",,SH6->H6_IDENT)
						EndIf
						aPerda:={}
						aHdPerda:={}
						lSavePerda:=.F.
					EndIf
				Endif
				
				//Michele - QIP -- Altera็ใo
				If A680UltOper() .Or. lEncerraOP
					SB1->(dbSetOrder(1))
					SB1->(MsSeek(xFilial("SB1") + SH6->H6_PRODUTO))
					If IntQIP(SH6->H6_PRODUTO,"2")
						SH6->H6_VERIFI := Iif (SH6->H6_LOCAL = GetMV('MV_CQ'),1,2)
						QIPAtualiza("SH6",1)
					EndIf
				EndIf
			Endif
			//-- Integrado ao wms devera avaliar as regras para convocacao do servico e disponibilizar os
			//-- registros do SDB para convocacao, ou exibir as mensagens de erro WMS caso necessแrio
			If IntDL()
				WmsExeDCF('2')
			EndIf
		Endif
		End Transaction
	Else
	Endif
Else
	_aIniVar := {}
	If _cTipoAp == 2
		RollBackSx8()
	Endif
EndIf

If nOpca == 1 .and. _cTipoAp == 1
	If SH6->H6_PT == "T"
		//Remove lock aplicado na A680TudoOk
		UnLockByName("ENCOP"+SH6->(H6_OP+H6_OPERAC),.T.,.T.,.T.)
	EndIf
	
	If lImpEtiq

		If SH6->H6_LOCAL == _cLocNCF
			_lNConf := .t.
		Endif
		If !Empty(_cFila)
			If CB5SetImp(_cFila,.T.)
				If Substr(SH6->H6_PRODUTO,1,2) == "04"
					u_FB_Etiq(SH6->H6_PRODUTO, SH6->H6_DTAPONT, SH6->H6_XTURNO, SH6->H6_LOTECTL, SH6->H6_NUMLOTE, SH6->H6_QTDPROD, SH6->H6_XTARA, SH6->H6_QTDPRO2, SH6->H6_OP, _cFila, SH6->H6_RECURSO, _lNConf,1,SH6->H6_HORAFIN)
				Else
					u_FB_Etiq1(SH6->H6_PRODUTO, SH6->H6_DTAPONT, SH6->H6_XTURNO, SH6->H6_LOTECTL, SH6->H6_NUMLOTE, SH6->H6_QTDPROD, SH6->H6_XTARA, SH6->H6_QTDPRO2, SH6->H6_OP, _cFila, SH6->H6_RECURSO, _lNConf,1,SH6->H6_HORAFIN, "ID"+SH6->H6_IDENT)
				Endif
			Endif
		Endif
	Endif
	If !Empty(SH6->H6_NUMLOTE)
		If Posicione("SB1",1,xFilial("SB1")+SH6->H6_PRODUTO,"B1_TIPO") == "04"
			MsgInfo( OemToAnsi( "Sequencial: " + SH6->H6_NUMLOTE ) , "Identifica็ใo da Bobina" )
		Else
			MsgInfo( OemToAnsi( "Bobina N๚mero: " + SH6->H6_NUMLOTE ) , "Identifica็ใo da Bobina" )
		Endif
	Endif
	
	If valtype(_aIniVar) == 'A'
		_aIniVar := {}
		If MsgYesNo("Deseja continuar com essa OP ?","Dados da Tela")
			While Len(_cCampos) > 3
				_nPosic := AT("/",_cCampos)
				If _nPosic > 0
					aadd(_aCampos,Substr(_cCampos,1,_nPosic-1))
					_cCampos := Substr(_cCampos,_nPosic+1)
				Else
					aadd(_aCampos,Alltrim(Substr(_cCampos,1)))
					_cCampos := ""
				Endif
			End
			For nT:=1 to Len(_aCampos)
				If _aCampos[nT] == "H6_XDESCTR"
					aadd(_aIniVar,{"M->"+_aCampos[nT], Posicione("SZ0",1,xFilial("SZ0")+M->H6_XTARA,"Z0_DESCRI")})
				ElseIf _aCampos[nT] == "H6_DSCREC"
					aadd(_aIniVar,{"M->"+_aCampos[nT], POSICIONE("SH1",1,XFILIAL("SH1")+M->H6_RECURSO,"H1_DESCRI")})
				ElseIf _aCampos[nT] == "H6_XBLQTOL"
					aadd(_aIniVar,{"M->"+_aCampos[nT], " "})
				Else
					aadd(_aIniVar,{"M->"+_aCampos[nT], M->&(_aCampos[nt])})
				Endif
			Next
		Endif
	Endif
EndIf

aPerda:={}
aHdPerda:={}
lSavePerda:=.F.

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Finaliza a gravacao dos lancamentos do SIGAPCO            ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
PcoFinLan("000152")

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFB_MATA681บAutor  ณMicrosiga           บ Data ณ  10/16/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function FB_IniVT(_cParam)

If _cParam == "3"
	M->H6_OP := "zzzz"
Else
	M->H6_OP := CriaVar("H6_OP",.F.)
Endif
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFB_MATA681บAutor  ณMicrosiga           บ Data ณ  04/18/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function PesaTOk(oFolder, _cTipoAp, aGets1,aTela1,aGets2,aTela2,nOpcA)

Local _lRet := .F.
Local _lContiOP := .f.
Local _cTipoAp := oFolder:nOption
nOpcA := 0

If _cTipoAp == 1
	If Obrigatorio(aGets1,aTela1)
		_lRet := u_FB_CriaMOD()
		If _lRet
			_lRet := u_FB_A680Est()
		Endif
		If _lRet
			_lRet := u_FBIniPeso(@_lContiOP)
			If _lContiOP
				_lRet := .f.
			Endif
		Endif
		If _lRet
			M->H6_PT := "P"
			_lRet := A680TudoOk()
		Endif
		If _lRet
			nOpcA := 1
		Endif
	Endif
Else
	If Obrigatorio(aGets2,aTela2)
		_lRet := .t.
		nOpcA := 1
	Endif
Endif	
Return(_lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFB_MATA681บAutor  ณMicrosiga           บ Data ณ  01/06/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function FB681_Lote(_aEmp,_cRot)

Local _aArea   := GetArea()
Local _aAreaB1 := SB1->(GetArea())
Local _aAreaD4 := SD4->(GetArea())
Local cBxProp  :=GetMv("MV_BXPROP")
Local cReqAut  :=A250ReqAut(GetMv("MV_REQAUT"))
Local _cOP
Local _cCodPro
Local _nQtde
Local _lOPPAI := .F.
Local nPosCod
Local nPosLoc
Local nPosQtd
Local nPosLot
Local nPosSub
Local nPosDsc
Local nPosSeg
Local nPosDt
Local nPosOP
Local nPosTRT
Local _nQtdOP
Local _cUM
Local nIndice := 1
Local _nQtdReq := 0, nG := 1, nRR := 1
Local _lConfEmp := .T.
Local _aArray := {}
Local _cTipoProd := CriaVar("B1_TIPO",.F.)
Local _cGrupProd := CriaVar("B1_GRUPO",.F.)
Default _cRot := "A"

If _cRot == "A"
	_cOP     := M->H6_OP
	_cCodPro:= M->H6_PRODUTO
	_nQtde  := M->H6_QTDPROD
	_cTipoProd := Posicione("SB1",1,xFilial("SB1")+_cCodPro,"B1_TIPO")
	_cGrupProd := Posicione("SB1",1,xFilial("SB1")+_cCodPro,"B1_GRUPO")
	_lOPPAI  := _cTipoProd $ "04/06" .or. _cGrupProd == "0340"
	nPosCod := aScan( oGtd0:aHeader, { |x| Alltrim(x[2])=="D5_PRODUTO" } )
	nPosLoc := aScan( oGtd0:aHeader, { |x| Alltrim(x[2])=="D5_LOCAL" } )
	nPosQtd := aScan( oGtd0:aHeader, { |x| Alltrim(x[2])=="D5_QUANT" } )
	nPosLot := aScan( oGtd0:aHeader, { |x| Alltrim(x[2])=="D5_LOTECTL" } )
	nPosSub := aScan( oGtd0:aHeader, { |x| Alltrim(x[2])=="D5_NUMLOTE" } )
	nPosDsc := aScan( oGtd0:aHeader, { |x| Alltrim(x[2])=="D5_XDESCRI" } )
	nPosSeg := aScan( oGtd0:aHeader, { |x| Alltrim(x[2])=="D5_QTSEGUM" } )
	nPosDt  := aScan( oGtd0:aHeader, { |x| Alltrim(x[2])=="D5_DTVALID" } )
	nPosOP  := aScan( oGtd0:aHeader, { |x| Alltrim(x[2])=="D5_OP" } )
	nPosTRT := aScan( oGtd0:aHeader, { |x| Alltrim(x[2])=="D5_SERIE" } )
	_nQtdOP := Posicione("SC2",1,xFilial("SC2")+_cOP,"C2_QUANT")
	_cUM    := Posicione("SB1",1,xFilial("SB1")+_cCodPro,"B1_UM")
Endif
For nRR:=1 to Len(_aEmp)
	_lOPPAI  := _cTipoProd $ "04/06" .or. _cGrupProd == "0340"
	_cProdEmp := _aEmp[nRR,1]
	_cLocEmp  := _aEmp[nRR,2]
	_nQtdPropor := _aEmp[nRR,3]
	_cTRT     := _aEmp[nRR,7]
	_lLote    := Posicione("SB1",1,xFIlial("SB1")+_cProdEmp,"B1_RASTRO") == "L"
	_lSBLote  := Posicione("SB1",1,xFIlial("SB1")+_cProdEmp,"B1_RASTRO") == "S"
	If _cRot == "A"	
		Aadd( _aArray, Array( Len( oGtd0:aHeader ) + 1 ) )
		For nA := 1 To Len(oGtd0:aHeader)
			If	oGtd0:aHeader[nA,10] != "V" 
				_aArray[Len( _aArray ), nA] := CriaVar( oGtd0:aHeader[nA,2] )
			EndIf
		Next nA
		_aArray[Len(_aArray),Len( oGtd0:aHeader ) + 1] :=.F.
    Endif

	If _cGrupProd == "0340" .and. Posicione("SB1",1,xFilial("SB1")+_cProdEmp,"B1_GRUPO") $ "0320/0330/0331"
		_lOPPAI := .F.
	Endif

	If _lLote .or. (_lSBLote .and. _lOPPAI)
		_lAptRF  := .T.  // Retorna a Segunda unidade de Medida
		aSldLote := SldPorLote(_cProdEmp,_cLocEmp,_nQtdPropor,/*SD4->D4_QTSEGUM*/,/*SD4->D4_LOTECTL*/,/*SD4->D4_NUMLOTE*/,NIL,NIL,NIL,.F.,_cLocEmp,NIL,NIL,.F.,dDatabase)
				  //ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				  //ณ Parametros do array aSldLote[]:              | 
				  //| aSldLote[nX,1] - Lote de Controle            |
				  //| aSldLote[nX,2] - Sub-Lote                    | 
				  //| aSldLote[nX,3] - Localizacao                 | 
				  //| aSldLote[nX,4] - Numero de Serie             |
				  //| aSldLote[nX,5] - Quantidade                  |
				  //| aSldLote[nX,6] - Quantidade 2aUM             |
				  //| aSldLote[nX,7] - Data de Validade            |
				  //ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		_nSldLote := 0			
		_lAptRF  := .F.
		If !Empty(aSldLote)
			For nJ:=1 to Len(aSldLote)
				_nSldLote+=aSldLote[nJ,5]
			Next
			If _nSldLote < _nQtdPropor  // Saldo do lote menor que necessario
				aSldLote := {}
			Endif
		Endif
		If _cRot == "A"
			If Len(aSldLote) > 0
				For nG:=1 to Len(aSldLote)
					If nG > 1
						Aadd( _aArray, Array( Len( oGtd0:aHeader ) + 1 ) )
						For nA := 1 To Len(oGtd0:aHeader)
							If	oGtd0:aHeader[nA,10] != "V" 
								_aArray[Len( _aArray ), nA] := CriaVar( oGtd0:aHeader[nA,2] )
							EndIf
						Next nA
						_aArray[Len(_aArray),Len( oGtd0:aHeader ) + 1] :=.F.
					Endif
					_aArray[Len(_aArray),nPosQtd] := aSldLote[nG,5]
					_aArray[Len(_aArray),nPosSeg] := aSldLote[nG,6]
					_aArray[Len(_aArray),nPosLot] := aSldLote[nG,1]
					_aArray[Len(_aArray),nPosSub] := aSldLote[nG,2]
					_aArray[Len(_aArray),nPosCod] := _cProdEmp
					_aArray[Len(_aArray),nPosDsc] := Posicione("SB1",1,xFIlial("SB1")+_cProdEmp,"B1_DESC")
					_aArray[Len(_aArray),nPosLoc] := _cLocEmp
					_aArray[Len(_aArray),nPosOP]  := _cOP
					_aArray[Len(_aArray),nPosTRT]  := _cTRT
				Next
			Else
				_aArray[Len(_aArray),nPosCod] := _cProdEmp
				_aArray[Len(_aArray),nPosDsc] := Posicione("SB1",1,xFIlial("SB1")+_cProdEmp,"B1_DESC")
				_aArray[Len(_aArray),nPosLoc] := _cLocEmp
				_aArray[Len(_aArray),nPosOP]  := _cOP
				_aArray[Len(_aArray),nPosQtd] := _nQtdPropor
				_aArray[Len(_aArray),nPosTRT]  := _cTRT
				nQuant2UM := ConvUm(_cProdEmp,_nQtdPropor,0,2)
				_aArray[Len(_aArray),nPosSeg] := nQuant2UM
			Endif
		Else
        	aadd(_aArray,{_cProdEmp, _cLocEmp, aSldLote, 0, 0})
		Endif
	Else
		If _cRot == "A"
			_aArray[Len(_aArray),nPosCod] := _cProdEmp
			_aArray[Len(_aArray),nPosDsc] := Posicione("SB1",1,xFIlial("SB1")+_cProdEmp,"B1_DESC")
			_aArray[Len(_aArray),nPosLoc] := _cLocEmp
			_aArray[Len(_aArray),nPosOP]  := _cOP
			_aArray[Len(_aArray),nPosQtd] := _nQtdPropor
			_aArray[Len(_aArray),nPosTRT] := _cTRT
			nQuant2UM := ConvUm(_cProdEmp,_nQtdPropor,0,2)
			_aArray[Len(_aArray),nPosSeg] := nQuant2UM
		Else
        	aadd(_aArray,{_cProdEmp, _cLocEmp, {}, _nQtdPropor, ConvUm(_cProdEmp,_nQtdPropor,0,2) })
		Endif
	Endif
Next

RestArea(_aAreaB1)
RestArea(_aAreaD4)
RestArea(_aArea)
Return(_aArray)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFB_MATA681บAutor  ณMicrosiga           บ Data ณ  10/16/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function Proc_RatRF(aColsRF)

Local _aArea := GetArea()
Local _lRet  := .t.
Local aItens := {}
Local aCab
Local _dData := dDataBase
Local nT	:=1
Local _cTMReq	:= PadR(SuperGetMV("MV_XREQPER",.F.,"515"),Len(SF5->F5_CODIGO))
Local _cTMPrd	:= PadR(SuperGetMV("MV_XAPTPER",.F.,"015"),Len(SF5->F5_CODIGO))
Local _cOPAcols, _cCodAcol
Local _nQtdAcol := 0
Local aCompBxa := {}
Local _aEmp := {}
Local _aEmpOri := {}
Local _cLog := ""
Local _aArray := {}, _aItem := {}, _aTotItem := {}, _aOPRat := {}, aOP := {}
Local nPosComp, nPosCp, _cTimeFIM, _cMinFim, _cHrFim, _cAjMin, _cHrINI, _cTLimeINI, _cRecurso
Local _nQtd2 := 0
Local _nTotRat := 0

Private l680Auto := .T.
Private l680:=.F.,l681:=.T.

aSort( aColsRF,,, { |x,y| x[nPOP] < y[nPOP] } )

// Nesse FOR aglutino todos os insumos em comum na variavel aCompBxa, para avaliar posteriormente se todos os insumos possuem saldos em estoque para serem requisitados

For nT:=1 to Len(aColsRF)
	_cOPAcols := aColsRF[nT,nPOP]
	_cCodAcol := aColsRF[nT,nPProd]
	_cRecurso := aColsRF[nT,nPRec]
	_cOperac  := aColsRF[nT,nPOperac]
	_nQtdAcol := 0
	While nT <= Len(aColsRF) .and. _cOPAcols == aColsRF[nT,nPOP]
		_nQtdAcol+= aColsRF[nT,nPQtd]
		nT++
	End
	nT--
	dbSelectArea("SC2")
	dbSetOrder(1)
	If dbSeek(xFilial()+_cOPAcols)
		_aEmp   := Calc_EMP(_cOPAcols, "R", _nQtdAcol)
		_nTotRat+=_nQtdAcol
		//aadd(_aEmp,{_cProdEmp, _cLocEmp, _nQtdPropor, _cLote, _cNumLote, _dDtValid, _cTRT})
		If Len(_aEmp) > 0
			aadd(_aEmpOri,{_cOPAcols, _nQtdAcol, _cRecurso, _aEmp, _cOperac})
			For nX:=1 to Len(_aEmp)
				If !Rastro(_aEmp[nX,1])
					nPosComp := aScan (aCompBxa, {|aX| aX[1]+aX[2] == _aEmp[nX,1]+_aEmp[nX,2]})
					If nPosComp == 0
						aadd(aCompBxa,{_aEmp[nX,1], _aEmp[nX,2], _aEmp[nX,3]})
					Else
						aCompBxa[nPosComp,3] += _aEmp[nX,3]
					Endif
				Endif
			Next
		Else
			aadd(_aEmpOri,{_cOPAcols, _nQtdAcol, _cRecurso, {}, _cOperac})
		Endif
	Endif
Next
For nT:=1 to Len(aCompBxa)
	dbSelectArea("SB2")
	dbSetOrder(1)
	MsSeek(xFilial("SB2")+aCompBxa[nT,1]+aCompBxa[nT,2])
	_nSaldo := SaldoMov(Nil,Nil,Nil,.F.,Nil,Nil,Nil,dDataBase)
	If _nSaldo < aCompBxa[nT,3]
		If Empty(_cLog)
			_cLog := "Sem Saldo no estoque"  + ENTER
		Endif
		_cLog += "Produto: " + aCompBxa[nT,1] + " - " + Alltrim(Posicione("SB1",1,xFilial("SB1")+aCompBxa[nT,1],"B1_DESC")) + " Faltam: " + Alltrim(Transform(aCompBxa[nT,3] - _nSaldo,"@E 9,999,999.9999")) + ENTER
	Endif
Next

If Empty(_cLog)	// Gerar as requisi็๕es por OP
	
	If Len(_aEmpOri) > 0
		
		Begin Transaction
		
		For nT:=1 to Len(_aEmpOri)
			_aEmp := _aEmpOri[nT,4]

			If Len(_aEmp) > 0  // Existem insumos a serem Baixados
				
				_aArray := u_FB681_Lote(_aEmp,"R")
				//aadd(_aArray,{_cProdEmp, _cLocEmp, aSldLote, 0, 0})
				
				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณ Parametros do array aSldLote[]:              |
				//| aSldLote[nX,1] - Lote de Controle            |
				//| aSldLote[nX,2] - Sub-Lote                    |
				//| aSldLote[nX,3] - Localizacao                 |
				//| aSldLote[nX,4] - Numero de Serie             |
				//| aSldLote[nX,5] - Quantidade                  |
				//| aSldLote[nX,6] - Quantidade 2aUM             |
				//| aSldLote[nX,7] - Data de Validade            |
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
				If Len(_aArray) > 0
					_aTotItem := {}
					For nJ:=1 to Len(_aArray)
						_aItem:={}
						If Len(_aArray[nJ,3]) > 0
							For nX:=1 to Len(_aArray[nJ,3])
								If _aArray[nJ,3,nX,5] > 0
									_aItem:={	{"D3_COD"       ,_aArray[nJ,1]			  ,nil},;
									{"D3_LOCAL"     ,_aArray[nJ,2]			  ,nil},;
									{"D3_QUANT"		,_aArray[nJ,3,nX,5]		  ,NIL},;
									{"D3_QTSEGUM"	,_aArray[nJ,3,nX,6]		  ,NIL},;
									{"D3_OP"		,_aEmpOri[nT,1]			  ,NIL},;
									{"D3_LOTECTL"	,_aArray[nJ,3,nX,1]		  ,NIL},;
									{"D3_NUMLOTE"	,_aArray[nJ,3,nX,2]		  ,NIL},;
									{"D3_DTVALID"	,_aArray[nJ,3,nX,7]		  ,NIL}}
								Endif
							Next
						Else
							If _aArray[nJ,4] > 0
								_aItem:={	{"D3_COD"       ,_aArray[nJ,1]			  ,nil},;
								{"D3_LOCAL"     ,_aArray[nJ,2]			  ,nil},;
								{"D3_QUANT"		,_aArray[nJ,4]			  ,NIL},;
								{"D3_QTSEGUM"	,_aArray[nJ,5]			  ,NIL},;
								{"D3_OP"		,_aEmpOri[nT,1]			  ,NIL}}
							Endif
						Endif
						If Len(_aItem) > 0
							Aadd(_aTotItem,_aItem)
						Endif
					Next
					If Len(_aTotItem) > 0
						lMsErroAuto := .F.
						cDocREQH6 := NextNumero("SD3",2,"D3_DOC",.T.)
						cCCusto := " "
						_aCab 	:={	{"D3_DOC"       ,cDocREQH6	      ,nil},;
									{"D3_TM"		,_cTMReq          ,NIL},;
									{"D3_EMISSAO"   ,dDataBase        ,nil}}
						dbSelectArea("SD3")
						
						MSExecAuto({|x,y,z| MATA241(x,y,z)},_aCab,_aTotItem,3)  // Gera os registros no SD3
						If lMsErroAuto
							Mostraerro()
							_lRet := .F.
							Exit
						Endif
					Endif
				Endif
			Endif
			If _lRet
				aVetor := {}
				_cTimeFIM := Time()
				_cMinFim  := Substr(_cTimeFIM,4,2)
				_cHrFim  := Substr(_cTimeFIM,1,2)
				_cHrINI  := _cHrFim
				_cAjMin := Val(_cMinFim) - 1
				If _cAjMin < 0
					_cAjMin := 59
					_cHrINI  := StrZero(Val(_cHrFim) - 1,2)
				Endif
				_cTLimeINI := _cHrINI +":"+Strzero(_cAjMin,2)
				lMsErroAuto := .F.
				M->H6_RECURSO := _aEmpOri[nT,3]
				M->H6_DATAFIN := _dData
				M->H6_HORAFIN := _cTimeFIM
				M->H6_DATAINI := _dData
				M->H6_HORAINI := _cTLimeINI
				_cTimeTOT := A680Calc()
				_dDataProd := _dData
				If _cTimeFIM >= "00:00" .and. _cTimeFIM <= "05:40"
					_dDataProd := _dData - 1
				Endif				
				dbSelectArea("SC2")
				dbSetOrder(1)
				dbSeek(xFilial()+_aEmpOri[nT,1])
				dbSelectArea("SB1")
				dbSetOrder(1)
				dbSeek(xFilial()+SC2->C2_PRODUTO)
				_nQtd2 := ConvUm(SC2->C2_PRODUTO,_aEmpOri[nT,2],0,2)
				aOP  := {	{"H6_FILIAL"  , xFilial("SH6") 		, Nil}, ;
							{"H6_OP"      , _aEmpOri[nT,1]	, Nil}, ;
							{"H6_PRODUTO" , SC2->C2_PRODUTO	, Nil}, ;
							{"H6_LOCAL"   , SC2->C2_LOCAL	, Nil}, ;
							{"H6_OPERAC"  , _aEmpOri[nT,5]	, Nil}, ;
							{"H6_RECURSO" , _aEmpOri[nT,3]	, Nil}, ;
							{"H6_DATAINI" , _dData		  	, Nil}, ;
							{"H6_HORAINI" , _cTLimeINI	  	, Nil}, ;
							{"H6_DATAFIN" , _dData			, Nil}, ;
							{"H6_HORAFIN" , _cTimeFIM	 	, Nil}, ;
							{"H6_TEMPO"   , _cTimeTOT	 	, Nil}, ;
							{"H6_QTDPROD" , _aEmpOri[nT,2]	, Nil}, ;
							{"H6_QTDPRO2" , _nQtd2			, Nil}, ;
							{"H6_QTDPERD" , 0				, Nil}, ;
							{"H6_PT"      , "P"             , Nil}, ;
							{"H6_XDOCSBC" , SZ5->Z5_DOC     , Nil}, ;
							{"H6_DTAPONT" , _dData		  	, Nil}, ;
							{"H6_XDTTURN" , _dData		  	, Nil}, ;
							{"H6_DTVALID" , _dData			, Nil}, ;
							{"H6_OPERADO" , Substr(cUsuario,7,15)	, Nil}}
				MSExecAuto({|x,y| Mata681(x,y)}, aOP, 3) // Inclusao
				
				If lMsErroAuto
					Alert("Erro ao apontar OP, processo abortado!")
					MostraErro()
					_lRet  := .F.
					Exit
				Endif
			Endif
		Next
		If !_lRet
			DisarmTransaction()
			dbSelectArea("SZ5")
			RecLock("SZ5",.F.)
			dbDelete()
			MsUnLock()
			RestArea(_aArea)
			Return
		Else
			If !Empty(_cFila)
				If CB5SetImp(_cFila,.T.)
					u_FB_Etiq1(SZ5->Z5_CODREF, SZ5->Z5_DATA, SZ5->Z5_TURNO, " ", " ", SZ5->Z5_QTDREF, SZ5->Z5_TARA, 0, " ", _cFila, " ", .F., 1, SZ5->Z5_HORA,  "RS"+SZ5->Z5_DOC)
				Endif
			Endif
		Endif
		End Transaction
	Endif
Else
	DEFINE MSDIALOG oDlg1 TITLE "Falta de Estoque" From 3,0 to 340,717 PIXEL
	@ 5,5 GET oMemo  VAR _cLog MEMO SIZE 350,145 OF oDlg1 PIXEL
	oMemo:bRClicked := {||AllwaysTrue()}
	//		oMemo:oFont:=oFont
	DEFINE SBUTTON  FROM 153,115 TYPE 1 ACTION (_lRet:=.t.,oDlg1:End()) ENABLE OF oDlg1 PIXEL
	DEFINE SBUTTON  FROM 153,175 TYPE 2 ACTION oDlg1:End() ENABLE OF oDlg1 PIXEL
	ACTIVATE MSDIALOG oDlg1 CENTER
Endif
RestArea(_aArea)
Return(_lRet)



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFB_MATA681บAutor  ณMicrosiga           บ Data ณ  03/09/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function Calc_EMP(_cOP, cParam, _nQtdAcol)

Local _aArea := GetArea()
Local nIndice := 1
Local _cProdEmp := CriaVar("D4_COD")
Local _nQtdEmp  := CriaVar("D4_QTDEORI")
Local _cLocEmp  := CriaVar("D4_LOCAL")
Local _cLote	:= CriaVar("D4_LOTECTL")
Local _cNumLote := CriaVar("D4_NUMLOTE")
Local _dDtValid := CriaVar("D4_DTVALID")
Local _cTRT		:= CriaVar("D4_TRT")
Local _lOPPAI   := .t. // Posicione("SB1",1,xFilial("SB1")+M->H6_PRODUTO,"B1_TIPO") == "04"
Local _nQtdPropor := 0
Local _aEmp := {}
Default cParam := "1"

dbSelectArea("SC2")
dbSetOrder(1)
dbSeek(xFilial()+_cOP)
If cParam == "R"
	nIndice := _nQtdAcol / SC2->C2_QUANT
Else
	nIndice := (M->H6_QTDPROD + M->H6_QTDPERD) / SC2->C2_QUANT
Endif
dbSelectArea("SD4")
dbSetOrder(2)
dbSeek(xFilial()+_cOP)

If nIndice > 1 .and. nIndice < 1.1
	nIndice := 1
Endif

While !Eof() .and. xFilial("SD4")+Alltrim(_cOP) == SD4->(D4_FILIAL+Alltrim(D4_OP))
	_cProdEmp := SD4->D4_COD
	_nQtdEmp  := SD4->D4_QTDEORI
	_cLocEmp  := SD4->D4_LOCAL
	_cTRT	  := SD4->D4_TRT
	If cParam == "R"
		If Rastro(_cProdEmp,"S")
			dbSkip()
			Loop
		Endif
	Endif
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Nao baixa se quantidade empenhada for negativa ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If IsProdMod(SD4->D4_COD)
		dbSkip()
		Loop
	EndIf
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Baixa apenas o saldo quando for ficar negativa ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	_nQtdPropor := Round(SD4->D4_QTDEORI*nIndice,TAMSX3("D4_QUANT")[2])
	If cParam == "1"
		SB1->(dbSetOrder(1))
		SB1->(dbSeek(xFilial("SB1")+_cProdEmp))
		If Rastro(_cProdEmp,"S") .and. !_lOPPAI
			_nQtdPropor := 0
		Endif
	Endif
	_nPos := Ascan(_aEmp,{|x| x[1]+x[2]+x[4]+x[5]+x[7] == _cProdEmp+_cLocEmp+_cLote+_cNumLote+_cTRT })
	If _nPos == 0 
		aadd(_aEmp,{_cProdEmp, _cLocEmp, _nQtdPropor, _cLote, _cNumLote, _dDtValid, _cTRT})
	Else
		_aEmp[_nPos,3] += _nQtdPropor
	Endif
	dbSelectArea("SD4")
	dbSkip()
End
Return(_aEmp)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFB_MATA681บAutor  ณMicrosiga           บ Data ณ  01/11/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function Sel_Lote

Local cTitulo:= "Dados da Bobina Utilizada"
Local _nPosProd,_nPosLocal
Local _cProduto,_cLocal, _cDesc, nT, _nPosSB
Local aSize := MsAdvSize()
Local _nSLb1,_nSLb2
Local aVetor := {}
Local lMark  := .F.
Local oOk    := LoadBitmap( GetResources(), "CHECKED" )   //CHECKED    //LBOK  //LBTIK
Local oNo    := LoadBitmap( GetResources(), "UNCHECKED" ) //UNCHECKED  //LBNO
Local _aArea := getarea()
Local nPosCod := aScan( oGtd0:aHeader, { |x| Alltrim(x[2])=="D5_PRODUTO" } )
Local nPosDes := aScan( oGtd0:aHeader, { |x| Alltrim(x[2])=="D5_XDESCRI" } )
Local nPosLoc := aScan( oGtd0:aHeader, { |x| Alltrim(x[2])=="D5_LOCAL" } )
Local nPosQtd := aScan( oGtd0:aHeader, { |x| Alltrim(x[2])=="D5_QUANT" } )
Local nPosSB  := aScan( oGtd0:aHeader, { |x| Alltrim(x[2])=="D5_NUMLOTE" } )
Local _lSbLote := Posicione("SB1",1,xFilial("SB1")+oGtd0:acols[oGtd0:nAT,nPosCod],"B1_RASTRO") == "S"
Local a1stRow := {}
Local aSubLote := {}
Local _nQtdBob  := 0
Local _cOP  := M->H6_OP
Local _cCod := M->H6_PRODUTO
Local _cDescop := M->H6_XDESC
Local _nQtdOP  := M->H6_QTDPROD
Local _cProduto := oGtd0:acols[oGtd0:nAT,nPosCod]
Local _cLocal   := oGtd0:acols[oGtd0:nAT,nPosLoc]
Local _cDesc    := oGtd0:acols[oGtd0:nAT,nPosDes]
Local _nQtdEmp  := oGtd0:acols[oGtd0:nAT,nPosQtd]
Local _cNumLote := oGtd0:acols[oGtd0:nAT,nPosSB]
If _lSbLote .and. Empty(_cNumLote)
	If Len(oGtd0:acols) > 0 .and. !Empty(_cProduto)
		For nT:=1 to Len(oGtd0:acols)
			If !Empty(oGtd0:acols[nT,nPosSB]) .and. oGtd0:acols[nT,nPosCod] == _cProduto .and. !oGtd0:acols[nT,Len(oGtd0:aHeader)+1]
				aadd(aSubLote,{oGtd0:acols[nT,nPosSB], oGtd0:acols[nT,nPosQtd]})
			Endif
		Next
		dbselectarea("SB8")
		dbsetorder(1)
		dbseek(xFilial() + _cProduto + _cLocal)
		while !eof() .and. B8_FILIAL + B8_PRODUTO + B8_LOCAL == xFilial("SB8") + _cProduto + _cLocal
			If SB8->(B8_SALDO-B8_EMPENHO) > 0
				_nPosSB := aScan (aSubLote, {|aX| aX[1] == SB8->B8_NUMLOTE})
				If _nPosSB > 0
					aadd(aVetor,{.T.,B8_LOTECTL, B8_NUMLOTE, B8_SALDO-B8_EMPENHO,B8_SALDO2-B8_EMPENH2,aSubLote[_nPosSB,2] , SB8->B8_DTVALID})
					_nQtdBob+= aSubLote[_nPosSB,2]
				Else
					aadd(aVetor,{lMark,B8_LOTECTL, B8_NUMLOTE, B8_SALDO-B8_EMPENHO,B8_SALDO2-B8_EMPENH2,0, SB8->B8_DTVALID})
				Endif
			endif
			dbskip()
		enddo
		
		if len(aVetor) == 0
			msgalert("Nao ha lotes com saldo para este produto")
			restarea(_aArea)
			return
		endif
		
		DEFINE MSDIALOG oDlgSel TITLE cTitulo FROM aSize[7],0 TO aSize[6],aSize[5] PIXEL OF oMainWnd PIXEL
		oDlgSel:lMaximized := .T.

		oSize := FwDefSize():New(.T.,,,oDlgSel)
	
		oSize:lLateral := .F.
		oSize:lProp	   := .T. // Proporcional
	
		oSize:AddObject( "1STROW" ,  100, 100, .T., .T. ) // Totalmente dimensionavel
		
		oSize:aMargins := { 3, 3, 3, 3 } // Espaco ao lado dos objetos 0, entre eles 3 
	
		oSize:Process() // Dispara os calculos		

		a1stRow :=	{oSize:GetDimension("1STROW","LININI"),;
					oSize:GetDimension("1STROW","COLINI"),;
					oSize:GetDimension("1STROW","XSIZE"),;
					oSize:GetDimension("1STROW","YSIZE")}

		@ 003, 004 TO 028,a1stRow[3]-60 LABEL "Dados da Ordem de Producao" OF oDlgSel  PIXEL
		@ 013, 010 SAY "OP:" OF oDlgSel PIXEL
		@ 012, 025 GET oOP VAR _cOP When .f. SIZE 040,10 OF oDlgSel PIXEL
		
		@ 013, 075 SAY "Produto:" OF oDlgSel PIXEL
		@ 012, 100 GET oProd VAR _cCod  When .f. SIZE 040,10 OF oDlgSel PIXEL
		@ 012, 140 GET oDesc VAR _cDescop When .f. SIZE 200,10 OF oDlgSel PIXEL

		@ 013, 350 SAY "Peso da Balan็a:" OF oDlgSel PIXEL
		@ 012, 400 GET oQtdOP VAR _nQtdOP Picture "@E 999,999.99"  When .f. SIZE 60,10 OF oDlgSel PIXEL
		
		@ 030, 004 TO 075,a1stRow[3]-60 LABEL "Dados da Bobina" OF oDlgSel  PIXEL

		@40,10  SAY "Produto:" SIZE 070,10 PIXEL OF oDlgSel
		@40,50  GET oProd VAR _cProduto when .f. SIZE 040,10 PIXEL OF oDlgSel
		@40,100 GET oDesc VAR _cDesc    when .f. SIZE 170,10 PIXEL OF oDlgSel		

		@ 040, 290 SAY "Peso Teorico Necessแrio:" OF oDlgSel PIXEL
		@ 039, 360 GET oQtdEmp VAR _nQtdEmp Picture "@E 999,999.99"  When .f. SIZE 60,10 OF oDlgSel PIXEL

		@ 060,10  SAY "SubLote:" SIZE 070,10 PIXEL OF oDlgSel
		@ 059,50  GET oNumLote VAR _cNumLote Valid(Vazio(_cNumLote) .or. LisNumLt("1",@_cNumLote, @_nQtdBob, @aVetor,NIL, _cOP)) SIZE 040,10 PIXEL OF oDlgSel

		@ 060, 290 SAY "Peso Total Informado:" OF oDlgSel PIXEL
		@ 059, 360 GET oQtdBob VAR _nQtdBob Picture "@E 999,999.99"  When .f. SIZE 60,10 OF oDlgSel PIXEL

		@ a1stRow[1]+50,a1stRow[2] LISTBOX oLbx FIELDS HEADER " ","Lote","SubLote","Saldo","Saldo 2aUM","Qtde Informada","Dt Validade" SIZE a1stRow[3]-60, a1stRow[4]-50 OF oDlgSel PIXEL ON dblClick(lote241(aVetor,oLbx:nAt, @_nQtdBob, _cOP))
		
		oLbx:SetArray( aVetor )
		
		oLbx:bLine := {|| {Iif(aVetor[oLbx:nAt,1],oOk,oNo),;
					aVetor[oLbx:nAt,2],;
					aVetor[oLbx:nAt,3],;
					trans(aVetor[oLbx:nAt,4],x3picture("B8_SALDO")),;
					trans(aVetor[oLbx:nAt,5],x3picture("B8_SALDO")),;
					aVetor[oLbx:nAt,6],;
					aVetor[oLbx:nAt,7]}}
		
		@ 30,a1stRow[3]-50 BUTTON "&Ok"       SIZE 36,16 PIXEL ACTION (if(valg241(aVetor, _nQtdEmp),oDlgSel:End(),""))
		@ 55,a1stRow[3]-50 BUTTON "&Cancelar" SIZE 36,16 PIXEL ACTION (oDlgSel:End())
		
		ACTIVATE MSDIALOG oDlgSel CENTER
	Endif
Endif
restarea(_aArea)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFB_MATA681บAutor  ณMicrosiga           บ Data ณ  08/12/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function LisNumLt(_cParam, _cNumLote, _nQtdBob, aVetor, nPosNum, _cOP)

Local _lRet  := .F.
Local _aListBox := oLbx:AARRAY
Local _nQtdInfo := 0
Local _lNBobinas := Posicione("SC2",1,xFilial("SC2")+_cOP,"C2_XVBOBIN") == "S"
Local _lContinua := .t.
Default nPosNum := aScan (_aListBox, {|aX| aX[3] == _cNumLote})

If _nQtdBob > 0 .and. !_lNBobinas
	_lContinua := .f.
	Help(" ",1,"MARKBOBINA",,"Nใo permitido utilizar mais de 1 Bobina",4,,,,,,.F.)
Endif
If _lContinua
	If nPosNum > 0
		If !oLbx:AARRAY[nPosNum,1]
			_nQtdInfo := oLbx:AARRAY[nPosNum,4]
		
			DEFINE MSDIALOG oDlgJus FROM 1,1 TO 10,48.5 OF oMainWnd STYLE DS_MODALFRAME TITLE "Confirma Quantidade Bobina"
			@ 0.5,0.5 SAY "Bobina:" OF oDlgJus  SIZE 30,15
			@ 0.5,6 GET oLote VAR _cNumLote When .f. OF oDlgJus  SIZE 060,15 FONT oDlgJus:oFont COLOR CLR_BLACK,CLR_HGRAY

			@ 2,0.5 SAY "Peso:" OF oDlgJus SIZE 50,15
			@ 2,6 GET oQtdeInf VAR _nQtdInfo OF oDlgJus Picture "@E 999,999.99" SIZE 060,15 FONT oDlgJus:oFont COLOR CLR_BLACK,CLR_HGRAY
			//Botใo Confirmar
			DEFINE SBUTTON FROM 52,155	TYPE 1 ACTION oDlgJus:End() ENABLE OF oDlgJus  
			oDlgJus:Activate( ,,, .T.,,, {|| oDlgJus:lEscClose := .F. } )
	
		//	oLbx:nAt := nPosNum
			oLbx:AARRAY[nPosNum,1] := .t.
			aVetor[nPosNum,6] := _nQtdInfo
			_nQtdBob+=_nQtdInfo
			oQtdBob:Refresh()
			oLbx:Refresh()
		Else
			Help(" ",1,"BOBJAMARC",,"SubLote jแ marcado",4,,,,,,.F.)
		Endif
	Else
		Help(" ",1,"LOTNEXIST",,"SubLote informado nใo encontrado",4,,,,,,.F.)
	Endif
Endif
_cNumLote := CriaVar("B8_NUMLOTE",.F.)
oNumLote:Refresh()
Return(_lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFB_MATA681บAutor  ณMicrosiga           บ Data ณ  01/11/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function LOTE241(aVetor,nPos, _nQtdBob, _cOP)

Local _nQtde := 0
Local _cNumLote := oLbx:AARRAY[nPos,3]
If !oLbx:AARRAY[nPos,1]								// Marquei
	LisNumLt("2",@_cNumLote, @_nQtdBob, @aVetor, nPos, _cOP)
Else												// Desmarquei
	oLbx:AARRAY[nPos,1] := .F.
	_nQtde := aVetor[nPos,6]
	aVetor[nPos,6] := 0
	_nQtdBob-=_nQtde
	oQtdBob:Refresh()
	oLbx:Refresh()
Endif
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFB_MATA681บAutor  ณMicrosiga           บ Data ณ  01/11/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function VALG241(aVetor, _nQtdEmp)
Local _nSoma:= 0, aVet, oldN:= oGtd0:nAT, _nQtdItem
Local _nPosEnder,_nPosQtde,_nPosLote
Local _cEndereco,_nQtde,_cLote
Local _lRet   := .t.
Local nPosQtd := aScan( oGtd0:aHeader, { |x| Alltrim(x[2])=="D5_QUANT" } )
Local nPosLot := aScan( oGtd0:aHeader, { |x| Alltrim(x[2])=="D5_LOTECTL" } )
Local nPosSub := aScan( oGtd0:aHeader, { |x| Alltrim(x[2])=="D5_NUMLOTE" } )
Local nPosDsc := aScan( oGtd0:aHeader, { |x| Alltrim(x[2])=="D5_XDESCRI" } )
Local nPosSeg := aScan( oGtd0:aHeader, { |x| Alltrim(x[2])=="D5_QTSEGUM" } )
Local nPosCod := aScan( oGtd0:aHeader, { |x| Alltrim(x[2])=="D5_PRODUTO" } )
Local nPosLoc := aScan( oGtd0:aHeader, { |x| Alltrim(x[2])=="D5_LOCAL" } )
Local nPosDt := aScan( oGtd0:aHeader, { |x| Alltrim(x[2])=="D5_DTVALID" } )
Local _nTolTeo := SuperGetMV("FB_TOLTEOR",.F.,10)
Local _cLocNCF	:= Alltrim(SuperGetMV("FB_LOCNCF",.F.,"02"))

_cProduto := oGtd0:acols[oGtd0:nAT,nPosCod]
_cLocal   := oGtd0:acols[oGtd0:nAT,nPosLoc]
_nQtSegum := oGtd0:acols[oGtd0:nAT,nPosSeg]

// soma a qtd dos lotes selecionados
for _i:= 1 to len(aVetor)
	_nSoma+= if(aVetor[_i,1],aVetor[_i,6],0)
next

_nDif := ABS(_nQtdEmp - _nSoma)
_nPerc := (_nDif / _nQtdEmp) * 100

If _nPerc > _nTolTeo
	If !MsgYesNo("A metragem informada ULTRAPASSOU OS " + Alltrim(Str(_nTolTeo)) +"% TOLERAVEL, confirma o lancamento? O saldo desse lan็amento ficarแ bloqueado","Bloqueio de Lancamento")
		_lRet := .f.
	Else
		M->H6_LOCAL := _cLocNCF
		_cLocalPrd  := _cLocNCF
	Endif
Endif

If _lRet
	If _lRet .and. !Empty(oGtd0:acols[oGtd0:nAT,nPosLot])
		Help(" ",1,"LTNVAZIO",,"Informar o Lote",4,,,,,,.F.)
		_lRet := .f.
	Endif
	If _lRet
		For _T:= 1 to len(oGtd0:acols)
			If oGtd0:acols[_T,nPosCod] == _cProduto
				oGtd0:acols[_T,Len(oGtd0:aHeader)+1] := .t.
			Endif
		Next
		for _i:= 1 to len(aVetor)
			if aVetor[_i,1]
				aadd(oGtd0:acols,Array(Len(oGtd0:aHeader)+1))
				For nT:=1 to Len(oGtd0:aHeader)
					oGtd0:acols[Len(oGtd0:acols),nT] := oGtd0:acols[oGtd0:nAT,nT]
				Next
				oGtd0:acols[Len(oGtd0:acols),nPosQtd] := aVetor[_i,6]
				oGtd0:acols[Len(oGtd0:acols),nPosLot] := aVetor[_i,2]
				oGtd0:acols[Len(oGtd0:acols),nPosSub] := aVetor[_i,3]
				If aVetor[_i,5] > 0 .and. aVetor[_i,6] > 0 .and. aVetor[_i,4] > 0
					_nProUM := aVetor[_i,4] / aVetor[_i,5]
					oGtd0:acols[Len(oGtd0:acols),nPosSeg] := Round(aVetor[_i,6] / _nProUM, TAMSX3("B2_QATU")[2])
				Endif
				oGtd0:acols[Len(oGtd0:acols),nPosDt]  := aVetor[_i,7]
				oGtd0:acols[Len(oGtd0:acols),Len(oGtd0:aHeader)+1] := .F.
			Endif
		Next
		_lRet := u_F_VldQtd(oGtd0:acols[oGtd0:nAT,nPosQtd])
		If !_lRet
			oGtd0:acols[oGtd0:nAT,nPosQtd] := 0
			oGtd0:acols[oGtd0:nAT,nPosLot] := CriaVar("D5_LOTECTL")
			oGtd0:acols[oGtd0:nAT,nPosSub] := CriaVar("D5_NUMLOTE")
			oGtd0:acols[oGtd0:nAT,nPosSeg] := 0
			oGtd0:acols[oGtd0:nAT,nPosDt]  := CriaVar("D5_DTVALID")
		Endif
	Endif
Endif
Return(_lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFB_MATA681บAutor  ณMicrosiga           บ Data ณ  01/14/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function FBAp681

Local _lRet 	:= .t.
Local nCodPos	:= GdFieldPos( "D5_PRODUTO"	, oGtd0:AHeader )
/*
If oGtd0:acols[oGtd0:oBrowse:nAt, len(oGtd0:acols[oGtd0:oBrowse:nAt])]
	If Posicione("SB1",1,xFilial("SB1")+oGtd0:acols[oGtd0:oBrowse:nAt,nCodPos],"B1_RASTRO") $ "L/S"
		_lRet := .f.
	Endif
Endif
*/
Return(_lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFB_MATA681บAutor  ณMicrosiga           บ Data ณ  02/02/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function F_VldNumLt

Local _aArea := GetArea()
Local _aAreaB8 := SB8->(GetArea())
Local _lRet := .t.
Local _cNumLote := M->D5_NUMLOTE
Local nPosQtd := aScan( oGtd0:aHeader, { |x| Alltrim(x[2])=="D5_QUANT" } )
Local nPosLot := aScan( oGtd0:aHeader, { |x| Alltrim(x[2])=="D5_LOTECTL" } )
Local nPosSub := aScan( oGtd0:aHeader, { |x| Alltrim(x[2])=="D5_NUMLOTE" } )
Local nPosDsc := aScan( oGtd0:aHeader, { |x| Alltrim(x[2])=="D5_XDESCRI" } )
Local nPosSeg := aScan( oGtd0:aHeader, { |x| Alltrim(x[2])=="D5_QTSEGUM" } )
Local nPosCod := aScan( oGtd0:aHeader, { |x| Alltrim(x[2])=="D5_PRODUTO" } )
Local nPosLoc := aScan( oGtd0:aHeader, { |x| Alltrim(x[2])=="D5_LOCAL" } )
Local nPosDt := aScan( oGtd0:aHeader, { |x| Alltrim(x[2])=="D5_DTVALID" } )
Local _lSbLote := Posicione("SB1",1,xFilial("SB1")+oGtd0:aCols[oGtd0:nAT,nPosCod],"B1_RASTRO") == "S"
If !Empty(_cNumLote)
	If _lSbLote
		dbSelectArea("SB8")
		dbSetOrder(2)
		If dbSeek(xFilial("SB8")+_cNumLote)
			If SB8->B8_LOCAL == oGtd0:aCols[oGtd0:nAT,nPosLoc]
				If SB8->B8_PRODUTO == oGtd0:aCols[oGtd0:nAT,nPosCod]
					If SB8->B8_SALDO - SB8->B8_EMPENHO > oGtd0:aCols[oGtd0:nAT,nPosQtd]
						oGtd0:aCols[oGtd0:nAT,nPosLot] := SB8->B8_LOTECTL
						oGtd0:aCols[oGtd0:nAT,nPosDt]  := SB8->B8_DTVALID
						If oGtd0:aCols[oGtd0:nAT,nPosQtd] == 0
							oGtd0:aCols[oGtd0:nAT,nPosQtd] := SB8->B8_SALDO - SB8->B8_EMPENHO
							oGtd0:aCols[oGtd0:nAT,nPosSeg] := SB8->B8_SALDO2 - SB8->B8_EMPENH2
						Else
							_nProUM := SB8->B8_SALDO / SB8->B8_SALDO2
							oGtd0:aCols[oGtd0:nAT,nPosSeg] := Round(oGtd0:aCols[oGtd0:nAT,nPosQtd] / _nProUM, TAMSX3("B2_QATU")[2])
						Endif
					Else
						Help(" ",1,"F_SLOTELC",,"Lote informado nใo possui saldo suficiente",4,,,,,,.F.)
						_lRet := .f.
					Endif
				Else
					Help(" ",1,"F_PDIF",,"Lote informado nใo corresponde ao produto",4,,,,,,.F.)
					_lRet := .f.
				Endif
			ElseIf SB8->B8_PRODUTO == oGtd0:aCols[oGtd0:nAT,nPosCod]
				Help(" ",1,"F_SLOTE",,"Saldo Bloqueado favor entrar em contato com o setor PCP",4,,,,,,.F.)
				_lRet := .f.
			Else
				Help(" ",1,"F_PDIF",,"Lote informado nใo esta disponivel na produ็ใo e nใo corresponde ao produto",4,,,,,,.F.)
				_lRet := .f.
			Endif
		Else
			Help(" ",1,"F_NLOTE",,"Lote nao Existe",4,,,,,,.F.)
			_lRet := .f.
		Endif
		If !_lRet
			oGtd0:aCols[oGtd0:nAT,nPosLot] := CriaVar("B8_LOTECTL")
			oGtd0:aCols[oGtd0:nAT,nPosDt]  := CriaVar("B8_DTVALID")
			M->D5_NUMLOTE := CriaVar("B8_NUMLOTE")
		Endif
	Else
		Help(" ",1,"F_CLOTE",,"Produto nao controla Sublote",4,,,,,,.F.)
		_lRet := .f.
	Endif
Endif
If _lRet
	_lRet := u_F_VldQtd(oGtd0:aCols[oGtd0:nAT,nPosQtd])
Endif

RestArea(_aAreaB8)
RestArea(_aArea)
Return(_lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFB_MATA681บAutor  ณMicrosiga           บ Data ณ  03/09/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function F_VldQtd(nQuant)

Local _aArea := GetArea()
Local _aAreaB8 := SB8->(GetArea())
Local _lRet := .t.
Local _aEmpOri := {}
Local _aEmpAjus := {}
Local nPosQtd := aScan( oGtd0:aHeader, { |x| Alltrim(x[2])=="D5_QUANT" } )
Local nPosLot := aScan( oGtd0:aHeader, { |x| Alltrim(x[2])=="D5_LOTECTL" } )
Local nPosSub := aScan( oGtd0:aHeader, { |x| Alltrim(x[2])=="D5_NUMLOTE" } )
Local nPosDsc := aScan( oGtd0:aHeader, { |x| Alltrim(x[2])=="D5_XDESCRI" } )
Local nPosSeg := aScan( oGtd0:aHeader, { |x| Alltrim(x[2])=="D5_QTSEGUM" } )
Local nPosCod := aScan( oGtd0:aHeader, { |x| Alltrim(x[2])=="D5_PRODUTO" } )
Local nPosLoc := aScan( oGtd0:aHeader, { |x| Alltrim(x[2])=="D5_LOCAL" } )
Local nPosDt := aScan( oGtd0:aHeader, { |x| Alltrim(x[2])=="D5_DTVALID" } )
Local _lSbLote := Posicione("SB1",1,xFilial("SB1")+oGtd0:aCols[oGtd0:nAT,nPosCod],"B1_RASTRO") == "S"
Local nSaldo := 0
Local nEmpenho := 0
Local lEmpPrev:= If(SuperGetMV("MV_QTDPREV")== "S",.T.,.F.)
Local lErrLote := .F.
Local _cOP := M->H6_OP
Local _cCodigo := oGtd0:acols[oGtd0:nAT,nPosCod]
Local _cLote	:= CriaVar("D4_LOTECTL")
Local _cNumLote := CriaVar("D4_NUMLOTE")
Local _dDtValid := CriaVar("D4_DTVALID")
Local _aArray   := {}
If _lSbLote
//	nQuant  := M->D5_QUANT
	_cSubLt := oGtd0:aCols[oGtd0:nAT,nPosSub]
	If nQuant > 0
		dbSelectArea("SB8")
		If Empty(_cSubLt)
			dbSetOrder(3)
			cSeekSB8:=xFilial("SB8")+_cCodigo+oGtd0:acols[oGtd0:nAT,nPosLoc]
			cComparaSB8:="B8_FILIAL+B8_PRODUTO+B8_LOCAL"
		Else
			dbSetOrder(2)
			cSeekSB8:=xFilial("SB8")+oGtd0:acols[oGtd0:nAT,nPosSub]
			cComparaSB8:="B8_FILIAL+B8_NUMLOTE"
		Endif
		If dbSeek(cSeekSB8)
			Do While !Eof() .And. cSeekSB8 == &(cComparaSB8)
				nSaldo  +=SB8SALDO(,,,,,lEmpPrev,,,.T.)
				nEmpenho+=SB8SALDO(.T.,,,,,lEmpPrev,,,.T.)+AvalQtdPre("SB8",1)
				dbSkip()
			EndDo
			If nSaldo - nEmpenho < nQuant
				lErrLote := .T.
			Endif
		Else
			lErrLote := .T.
		Endif
		If lErrLote
			Help(" ",1,"lErrLote",,"Sem saldo em estoque",4,,,,,,.F.)		
			_lRet := .f.
		Endif

/*Nใo serแ mais necessแrio recalcular os insumos, tudo sera pela estrutura
		If _lRet
			_aEmpOri := Calc_EMP(_cOP, "2")
			nTotEmp  := 0
			For nX:=1 to Len(_aEmpOri)
				If Posicione("SB1",1,xFilial("SB1")+_aEmpOri[nX,1],"B1_RASTRO") == "S"
					nTotEmp+=_aEmpOri[nX,3]
				Endif
			Next
			nProdArr := aScan( _aEmpOri, { |x| x[1]==_cCodigo } )
			_nQtdOri := _aEmpOri[nProdArr,3]
			If QtdComp(nQuant) <> QtdComp(_nQtdOri)
				_nDif := _nQtdOri - nQuant
				nTotComp := 0
				nTotSub  := nQuant
				aComp := {}
				For nH:=1 to Len(oGtd0:acols)
					If nH <> nProdArr
						If Posicione("SB1",1,xFilial("SB1")+oGtd0:aCols[nH,nPosCod],"B1_RASTRO") <> "S"
							nTotComp+=oGtd0:aCols[nH,nPosQtd]
						Else
							nTotSub+=oGtd0:aCols[nH,nPosQtd]
						Endif
					Endif
				Next
				If _nDif < 0
					If ABS(nTotSub) > nTotEmp
						Help(" ",1,"QTDNPERM",,"Saldo da Bobina a ser consumida maior ou igual a Bobina Gerada, informar a quantidade consumida",4,,,,,,.F.)
//						_lRet := .f.
					Endif
				Endif
				If _lRet
					For nH:=1 to Len(oGtd0:acols)
						If nH <> nProdArr
							If Posicione("SB1",1,xFilial("SB1")+oGtd0:aCols[nH,nPosCod],"B1_RASTRO") <> "S"
								nQtdAjust := Round(((_aEmpOri[nH,3] / nTotComp) * _nDif) + _aEmpOri[nH,3],TAMSX3("B2_QATU")[2])
								aadd(_aEmpAjus,{oGtd0:acols[nH,nPosCod], oGtd0:acols[nH,nPosLoc], nQtdAjust, _cLote, _cNumLote, _dDtValid})
							Endif
						Endif
					Next
					If !Empty(_aEmpAjus)
						_aArray := u_FB681_Lote(_aEmpAjus)
						For nH:=1 to Len(oGtd0:acols)
							nElem := Ascan(_aArray,{|x| x[1]+x[3] == oGtd0:acols[nH,nPosCod]+oGtd0:acols[nH,nPosLoc]})
							If nElem > 0
								If _aArray[nElem,nPosQtd] > 0
									oGtd0:acols[nH,nPosQtd] := _aArray[nElem,nPosQtd]
									oGtd0:acols[nH,nPosLot] := _aArray[nElem,nPosLot]
									oGtd0:acols[nH,nPosSub] := _aArray[nElem,nPosSub]
									oGtd0:acols[nH,nPosDt] := _aArray[nElem,nPosDt]
								Else
									oGtd0:acols[nH,nPosQtd] := 0
									oGtd0:acols[nH,nPosLot] := CriaVar("D5_LOTECTL")
									oGtd0:acols[nH,nPosSub] := CriaVar("D5_NUMLOTE")
									oGtd0:acols[nH,nPosDt] := CriaVar("D5_DTVALID")
								Endif
							Endif
						Next				
						oGtd0:oBrowse:Refresh()		
					Endif
				Endif
			Endif
		Endif
*/
	Endif
Else
	Help(" ",1,"INFNPERM",,"Informe a quantidade apenas no item Bobina",4,,,,,,.F.)
	_lRet := .f.
Endif
RestArea(_aAreaB8)
RestArea(_aArea)
Return(_lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFB_MATA681บAutor  ณMicrosiga           บ Data ณ  02/05/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function FB_CriaMOD

Local _cRecurso := M->H6_RECURSO
Local _aArea := GetArea()
Local _cCusto
Local bCampo := { |nCPO| Field(nCPO)}
Local I
Local _lRet := .t.
dbSelectArea("SH1")
dbSetOrder(1)
If dbSeek(xFilial()+_cRecurso)		
	dbSelectArea("SB1")
	cProdMod:=APrModRec(SH1->H1_CODIGO)
	If !dbSeek(xFilial("SB1")+cProdMod)
		_cCusto := Alltrim(SH1->H1_CCUSTO)
		_cCodMOD := "MOD" + _cCusto
		dbSelectArea("CTT")
		dbSetOrder(1)
		dbSeek(xFilial()+_cCusto)
		_cDescCC := Alltrim(CTT->CTT_DESC01)
		dbSelectArea("SB1")
		dbSetOrder(1)
		If !dbSeek(xFilial()+_cCodMOD)
			If dbSeek(xFilial()+"MOD")
				FOR I := 1 to FCount()
					M->&(EVAL(bCampo,I)) := FieldGet(I)
				Next I
				M->B1_COD  := _cCodMOD
				M->B1_DESC := "CC " + _cDescCC
				M->B1_CC   := _cCusto
				_nOpca := AxIncluiAuto("SB1")
			Else
				dbSelectArea("SB1")
				RecLock("SB1",.T.)
				Replace B1_FILIAL with xFilial("SB1"),;
						B1_COD with _cCodMOD,;
						B1_DESC with "CC " + _cDescCC,;
						B1_TIPO with "MO",;
						B1_LOCPAD with "MO",;
						B1_CC with _cCusto
				MsUnLock()
			Endif
		Endif
	Endif 
Endif
RestArea(_aArea)
Return(_lRet)
/*
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFun…o    ณA680Estoq ณ Autor ณ Marcos Bregantim      ณ Data ณ 28/09/94 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณ Programa que verifica a Qtd. em estoque dos empenhos da Op ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ Uso      ณ MATA680                                                    ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function FB_A680Est()
Local _aArea := GetArea()
Local cBxProp :=GetMv("MV_BXPROP")
Local cReqAut :=A250ReqAut(GetMv("MV_REQAUT"))
Local cEstNeg :=GetMV("MV_ESTNEG")
Local cLocProc:=GetMV("MV_LOCPROC")
Local aReqsOk :={},aErros:={},aSaldo:={}
Local cAlias  := Alias()
Local cApropri,cLocReq
Local cSeekSB8:= "",cComparaSB8:=""
Local lRet    := .T.,lErrLote := .F.
Local nOrdem,nRec,nOrdSB8,nRecSB8,nElem,nQtdUsada,nOpca
Local nSaldo  :=0,nEmpenho:=0
Local oDlg,oQual
Local ni, nT
Local lEmpPrev:= If(SuperGetMV("MV_QTDPREV")== "S",.T.,.F.)
Local nPosCod := aScan( oGtd0:aHeader, { |x| Alltrim(x[2])=="D5_PRODUTO" } )
Local nPosLoc := aScan( oGtd0:aHeader, { |x| Alltrim(x[2])=="D5_LOCAL" } )
Local nPosQtd := aScan( oGtd0:aHeader, { |x| Alltrim(x[2])=="D5_QUANT" } )
Local nPosLot := aScan( oGtd0:aHeader, { |x| Alltrim(x[2])=="D5_LOTECTL" } )
Local nPosSub := aScan( oGtd0:aHeader, { |x| Alltrim(x[2])=="D5_NUMLOTE" } )
Local nPosDsc := aScan( oGtd0:aHeader, { |x| Alltrim(x[2])=="D5_XDESCRI" } )
Local nPosSeg := aScan( oGtd0:aHeader, { |x| Alltrim(x[2])=="D5_QTSEGUM" } )
Local nPosDt  := aScan( oGtd0:aHeader, { |x| Alltrim(x[2])=="D5_DTVALID" } )
Local _nTamCod := TAMSX3("B1_COD")[1]
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Posiciona no arquivo de OP's                       ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
SC2-> ( dbSeek(xFilial("SC2")+M->H6_OP) )

If (M->H6_QTDPROD + M->H6_QTDPERD) > 0
	For nT:=1 to Len(oGtd0:acols)
		If oGtd0:acols[nT,Len(oGtd0:aHeader)+1]
			Loop
		Endif
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Baixa apenas o saldo quando for ficar negativa ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		nQuant := oGtd0:acols[nT,nPosQtd]
/*
		If nQuant == 0
			Help(" ",1,"QTDZER",,"Informar a quantidade a ser requisitada do produto: " + oGtd0:acols[nT,nPosCod],4,,,,,,.F.)
			lRet := .f.
			Exit
		Endif
*/
		If nQuant <= 0
			Loop
		Endif
		
		dbSelectArea("SB1")
		dbSetOrder(1)
		dbSeek(xFilial("SB1")+oGtd0:acols[nT,nPosCod])
		cLocReq := oGtd0:acols[nT,nPosLoc]
		dbSelectArea("SB2")
		dbSetOrder(1)
		dbSeek(xFilial("SB2")+oGtd0:acols[nT,nPosCod]+cLocReq)
		nElem := Ascan(aReqsOK,{|x| x[1] == oGtd0:acols[nT,nPosCod]+cLocReq})
		If nElem == 0
			nQtdUsada := 0
			AADD(aReqsOk,{oGtd0:acols[nT,nPosCod]+cLocReq,nQuant})
		Else
			nQtdUsada := aReqsOk[nElem,2]
			aReqsOk[nElem,2] += nQuant
		EndIf
		If Rastro(oGtd0:acols[nT,nPosCod])
			dbSelectArea("SB8")
			nOrdSB8 := IndexOrd()
			nRecSB8 := RecNo()
			If Empty(IF(Rastro(oGtd0:acols[nT,nPosCod],"S"),oGtd0:acols[nT,nPosSub],oGtd0:acols[nT,nPosLot]))
				lRet := .f.
				IF Rastro(oGtd0:acols[nT,nPosCod],"S")
					Help(" ",1,"SBLZER",,"Informar o numero do Sub-Lote do produto: " + oGtd0:acols[nT,nPosCod],4,,,,,,.F.)
					Exit
				Else
					nElem := Ascan(aSaldo,{|x| x[1] == SD4->D4_COD+cLocReq})
					If nElem == 0
						AADD(aSaldo,{oGtd0:acols[nT,nPosCod]+cLocReq,(SB2->B2_QATU - SB2->B2_QACLASS) - (nQuant + nQtdUsada)})
					Else
						aSaldo[nElem,2] -= nQuant
					EndIf
				Endif
			Else
				dbSelectArea("SB8")
				dbSetOrder(3)
				If Rastro(SD4->D4_COD,"S")
					cSeekSB8:=xFilial("SB8")+oGtd0:acols[nT,nPosCod]+cLocReq+oGtd0:acols[nT,nPosLot]+oGtd0:acols[nT,nPosSub]
					cComparaSB8:="B8_FILIAL+B8_PRODUTO+B8_LOCAL+B8_LOTECTL+B8_NUMLOTE"
				Else
					cSeekSB8:=xFilial("SB8")+oGtd0:acols[nT,nPosCod]+cLocReq+oGtd0:acols[nT,nPosLot]
					cComparaSB8:="B8_FILIAL+B8_PRODUTO+B8_LOCAL+B8_LOTECTL"
				EndIf
				If dbSeek(cSeekSB8)
					Do While !Eof() .And. cSeekSB8 == &(cComparaSB8)
						nSaldo+=SB8SALDO(,,,,,lEmpPrev,,,.T.)
						nEmpenho+=SB8SALDO(.T.,,,,,lEmpPrev,,,.T.)+AvalQtdPre("SB8",1)
						dbSkip()
					EndDo
					If nSaldo - nEmpenho < nQuant
						nElem := Ascan(aSaldo,{|x| x[1] == SD4->D4_COD+cLocReq})
						If nElem == 0
							AADD(aSaldo,{oGtd0:acols[nT,nPosCod]+cLocReq,(nSaldo - nEmpenho) - (nQuant + nQtdUsada)})
						Else
							aSaldo[nElem,2] -= nQuant
						EndIf
						lRet := .F.
					EndIf
				Else
					nElem := Ascan(aSaldo,{|x| x[1] == oGtd0:acols[nT,nPosCod]+cLocReq})
					If nElem == 0
						AADD(aSaldo,{oGtd0:acols[nT,nPosCod]+cLocReq,(nSaldo - nEmpenho) - (nQuant + nQtdUsada)})
					Else
						aSaldo[nElem,2] -= nQuant
					EndIf
					lRet := .F.
				EndIf
			EndIf
			dbSetOrder(nOrdSB8)
			dbGoto(nRecSB8)
			dbSelectArea("SD4")
		ElseIf (SB2->B2_QATU - SB2->B2_QACLASS) < (nQuant + nQtdUsada ) .And. cEstNeg == "N"
			lRet := .f.
			nElem := Ascan(aSaldo,{|x| x[1] == SD4->D4_COD+cLocReq})
			If nElem == 0
				AADD(aSaldo,{oGtd0:acols[nT,nPosCod]+cLocReq,(SB2->B2_QATU - SB2->B2_QACLASS) - (nQuant + nQtdUsada)})
			Else
				aSaldo[nElem,2] -= nQuant
			EndIf
		EndIf
	Next
EndIf
If !lRet .and. Len(aSaldo) > 0
	Help(" ",1,"MA240NEGAT")
	cCadastro:=OemToAnsi("Itens Sem Saldo")	//"Itens Sem Saldo"
	aErros := {}
	For ni := 1 to Len(aSaldo)
		_cCod := Substr(aSaldo[ni,1],1,_nTamCod)
		dbSelectArea("SB1")
		dbSetOrder(1)
		dbSeek(xFilial("SB1")+_cCod)		
		cDescr := Alltrim(SB1->B1_DESC)
		AADD(aErros,{Subs(aSaldo[ni,1],1,15),Subs(aSaldo[ni,1],16,2),Trans(aSaldo[ni , 2],PesqPictQT("B2_QATU")), cDescr})
	Next
	nOpca:= 0
	DEFINE MSDIALOG oDlg4 TITLE cCadastro From 9,0 To 25,80 OF oMainWnd

	@ 0,.7 LISTBOX oQual VAR cVar Fields HEADER OemToAnsi("Cขdigo"),OemToAnsi("Local"),OemToAnsi("Quantidade"),OemToAnsi("Descrio") SIZE 250,100	//"Cขdigo"###"Local"###"Quantidade"###"Descrio"
	oQual:SetArray(aErros)
	oQual:bLine := { || {aErros[oQual:nAT][1],aErros[oQual:nAT][2],aErros[oQual:nAT][3],aErros[oQual:nAT][4]}}

	DEFINE SBUTTON FROM 5   ,266  TYPE 1 ACTION (nOpca := 1,oDlg4:End()) ENABLE OF oDlg4
	DEFINE SBUTTON FROM 17.5,266  TYPE 2 ACTION oDlg4:End() ENABLE OF oDlg4

	ACTIVATE MSDIALOG oDlg4
	lRet := .F.
EndIf
RestArea(_aArea)
Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFB_MATA681บAutor  ณMicrosiga           บ Data ณ  02/21/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function Cap_Peso(_cAlias)

Local _aArea  := GetArea()
Local _cCampo := ReadVar()
Local _lRet   := .t.
Local _nBruto := 0
Local _nTara  := 0
Local _nQtUni := 0
Local _cOP    := IIF(_cAlias=="SH6",M->H6_OP,"zz")
Local _cProd  := IIF(_cAlias=="SH6",M->H6_PRODUTO, M->Z5_CODREF)
Local _cTara  := IIF(_cAlias=="SH6",M->H6_XTARA, M->Z5_TARA)
Local _cOper  := IIF(_cAlias=="SH6",M->H6_OPERADO, "")
Local _cRecur := IIF(_cAlias=="SH6",M->H6_RECURSO, "zz")
Local _aArray := {}
Local _aEmp   := {}
Local _lSegUM := Posicione("SB1",1,xFilial("SB1")+_cProd,"B1_SEGUM") == "KG"
Local _nTara  := Posicione("SZ0",1,xFilial("SZ0")+_cTara,"Z0_PESO")
Local _nConv   	:= Posicione("SB1",1,xFilial("SB1")+_cProd,"B1_XCONV")
Local _nTpConv  := Posicione("SB1",1,xFilial("SB1")+_cProd,"B1_TIPCONV")
Local _lContinua := .T.
Local _aRatOP   := {}
Local nRF		:=1
Local nPProd := aScan( oGtd2:aHeader, { |x| Alltrim(x[2])=="BC_PRODUTO" } )
Local nPOP   := aScan( oGtd2:aHeader, { |x| Alltrim(x[2])=="BC_OP" } )
Local nPQtd  := aScan( oGtd2:aHeader, { |x| Alltrim(x[2])=="BC_QUANT" } )
Local nPRec  := aScan( oGtd2:aHeader, { |x| Alltrim(x[2])=="BC_RECURSO" } )
Local nPDta  := aScan( oGtd2:aHeader, { |x| Alltrim(x[2])=="BC_DATA" } )
Local nPLoc  := aScan( oGtd2:aHeader, { |x| Alltrim(x[2])=="BC_LOCORIG" } )
Local nPTip  := aScan( oGtd2:aHeader, { |x| Alltrim(x[2])=="BC_TIPO" } )
Local nPMot  := aScan( oGtd2:aHeader, { |x| Alltrim(x[2])=="BC_MOTIVO" } )
Local nPOperac  := aScan( oGtd2:aHeader, { |x| Alltrim(x[2])=="BC_OPERAC" } )
Local nRecPos	:= GdFieldPos( "BC_REC_WT", oGtd2:aHeader )
Local nRecAli	:= GdFieldPos( "BC_ALI_WT", oGtd2:aHeader )
Local _aCtrab	:= {}
Local _cError   := ""
If Alltrim(_cCampo) == "M->H6_RECURSO"
	If !(Posicione("SB1",1,xFilial("SB1")+M->H6_PRODUTO,"B1_TIPO") == "04")
		_lContinua := .F.
	Endif
Endif
If _cAlias == "SZ5"
	_aCtrab := u_FBFilRec("1",_cProd,  ,  , @_cError)
	If Len(_aCtrab) == 0
		Help(" ",1,"NCTRABR",,"Nao encontrado amarracao do Tipo de Residuo com o Centro de Trabalho, verificar cadastro",4,,,,,,.F.)
		_lContinua := .F.
	Endif
Endif
If _lContinua
	If Empty(_cOP)
		Help(" ",1,"NINFOP",,"Informe a OP",4,,,,,,.F.)
		_lRet := .f.
	ElseIf Empty(_cTara)
		Help(" ",1,"NINFTARA",,"Informe o campo Tara",4,,,,,,.F.)
		_lRet := .f.
	ElseIf Empty(_cProd)
		Help(" ",1,"NINFPROD",,"Informe o codigo do produto",4,,,,,,.F.)
		_lRet := .f.
	ElseIf Empty(_cRecur)
		Help(" ",1,"NINFREC",,"Informe o campo Recurso",4,,,,,,.F.)
		_lRet := .f.
	Else
		u_Pg_Balanc(@_nBruto,_nTara)
		u_Ms_Peso(@_nBruto,_nTara, _lSegUM, @_nQtUni, _nConv, _nTpConv, _cProd, _cOP)
		_nBruto := _nBruto - _nTara
		If _nBruto > 0 .and. IIF(_lSegUM, _nQtUni > 0, .T.)
			dbSelectArea("SB1")
			dbSetOrder(1)
			dbSeek(xFilial()+_cProd)
			If _cAlias == "SZ5"
				If Len(_aCtrab) > 0
					M->Z5_QTDREF := _nBruto
					_aRatOP   := u_ProcessRF(M->Z5_DOC, _aCtrab, M->Z5_DATA, _nBruto, _cProd)
	//aadd(_aRatOP, {(cAliasH6)->H6_OP ,(cAliasH6)->H6_RECURSO , (cAliasH6)->H6_PRODUTO,  (cAliasH6)->H6_QTDPROD, 0, H6_OPERAC})
					oGtd2:aCols := {}
					If Len(_aRatOP) > 0
						For nRF:=1 to Len(_aRatOP)
							Aadd( oGtd2:aCols, Array( Len( oGtd2:aHeader ) + 1 ) )
							oGtd2:aCols[Len(oGtd2:aCols), nPProd] 	:= _aRatOP[nRF, 3]
							oGtd2:aCols[Len(oGtd2:aCols), nPOP] 	:= _aRatOP[nRF, 1]
							oGtd2:aCols[Len(oGtd2:aCols), nPQtd] 	:= _aRatOP[nRF, 5]
							oGtd2:aCols[Len(oGtd2:aCols), nPRec] 	:= _aRatOP[nRF, 2]
							oGtd2:aCols[Len(oGtd2:aCols), nPOperac]	:= _aRatOP[nRF, 6]
							oGtd2:aCols[Len(oGtd2:aCols), nPDta] 	:= dDataBase
							oGtd2:aCols[Len(oGtd2:aCols), nPLoc] 	:= Posicione("SC2",1,xFilial("SC2")+_aRatOP[nRF, 1],"C2_LOCAL")
							oGtd2:aCols[Len(oGtd2:aCols), nPTip] 	:= "R"
							oGtd2:aCols[Len(oGtd2:aCols), nPMot] 	:= "FM"
							oGtd2:aCols[Len(oGtd2:aCols), nRecPos] 	:= 0
							oGtd2:aCols[Len(oGtd2:aCols), nRecAli] 	:= "SBC"
							oGtd2:aCols[Len(oGtd2:aCols), Len(oGtd2:aHeader ) + 1 ] := .F.
						Next
						oGtd2:oBrowse:Refresh()
						aColsRF := Aclone(oGtd2:aCols)
					Else
						Aadd( oGtd2:aCols, Array( Len( oGtd2:aHeader ) + 1 ) )
						For nCntFor := 1 To Len( oGtd2:aHeader )
							If IsHeadRec(oGtd2:aHeader[nCntFor][2])
								oGtd2:aCols[Len(oGtd2:aCols)][nCntFor] := 0
							ElseIf IsHeadAlias(oGtd2:aHeader[nCntFor][2])
								oGtd2:aCols[Len(oGtd2:aCols)][nCntFor] := "SBC"
							Else
								oGtd2:aCols[Len(oGtd2:aCols)][nCntFor] := CriaVar(oGtd2:aHeader[nCntfor][2])
							EndIf
						Next nCntFor
						oGtd2:aCols[Len(oGtd2:aCols), Len(oGtd2:aHeader ) + 1 ] := .F.
						M->Z5_QTDREF := 0
						Help(" ",1,"NOPRAT",,"Nใo encontrado OP para realizar rateio",4,,,,,,.F.)
						_lRet := .f.
					Endif
				Else
					_lRet := .f.
				Endif
			Else
				If _lSegUM
					M->H6_QTDPRO2 := _nBruto
					M->H6_QTDPROD := _nQtUni
				Else
					M->H6_QTDPROD := _nBruto
					M->H6_QTDPRO2 := _nQtUni
				Endif
				If _nBruto > 0
					_aEmp   := Calc_EMP(_cOP)
					_aArray := u_FB681_Lote(_aEmp)
					oGtd0:aCols := _aArray
					oGtd0:oBrowse:Refresh()		
				Endif
				SC2->(dbSetOrder(1))
				SC2->(dbSeek(xFilial("SC2")+_cOP))
				_nSaldo := SC2->C2_QUJE
				If _nSaldo + _nBruto >= SC2->C2_QUANT
					M->H6_PT := "T"
				Else
					M->H6_PT := "P"
				Endif
			Endif
		Endif
	Endif
Endif
RestArea(_aArea)
Return(_lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFB_MATA681บAutor  ณMicrosiga           บ Data ณ  02/21/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFuncao para pegar o peso da balanca RS232                   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function Pg_Balanc(_nBruto,_nTara)

Local nHdll2 := 0
//"COM1:4800,n,8,1"
//Local nH       := fopenPort(cPorta,cSettings,2)

//Local cBaudRate:= "4800"
//Local cParity  := EvenParity
//Local cData    := "7"
//Local cStop    := One5StopBits // 1
//Local cTimeOut := "00500"
//Local cSettings:= cBaudRate+','+cParity+','+cData+','+cStop+','+cTimeOut

Local cPorta    := SuperGetMV("FB_BPORTA",.F.,"COM3")
Local cSettings := SuperGetMV("FB_BSETTI",.F.,"9600,E,7,1,00500")
Local cText := Space(200)

nHdll2 := fopenPort(cPorta,cSettings,2)

If nHdll2 == -1
	MsgAlert('Erro na comunica็ใo com balan็a!')
	Return
EndIf	

_nContador := 0
_cTara := "0"

NIReadPort(nHdll2,@cText)

If !Empty(cText)
	_nTara := Val(Stuff(cText,7,0,"."))
	If _nTara > 10000
		_nTara := 0
	Endif
	_nBruto := _nTara
Else
	_nTara := 0
	_nBruto := 0
Endif

FCLose(nHdll2)

Return({_nBruto,_nTara})

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFB_MATA681บAutor  ณMicrosiga           บ Data ณ  02/21/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Retorna o peso lido da balanca                             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function NIReadPort(nHdl,cString)

Local cByte:=cString
Local cStringTemp:=""
Local cDados, nByte
Local aPesos := {}
Local aNumVez := {}
Local nT := 1
Local lNumRep := .f.
Local _nCapt := 0
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณAguarda 1 segundo para conseguir lerณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Inkey(1)

cDados := Fread(nHdl,@cByte,Len(cByte))
/*
cByte := "0000000" + CHR(13) + chr(10)
cByte += "+0 002014000000" + CHR(13) + chr(10)
cByte += "z+0 002014000000" + CHR(13) + chr(10)
cByte += "z+0 002014000000" + CHR(13) + chr(10)
*/
If Empty(cByte)
	Return(aPesos)
EndIf   
   
For nT:=1 to Len(cByte)
   nByte := Substr(cByte,nT,1)
   If ASC(nByte) < 48 .or. ASC(nByte) > 57
   		If nByte == "+" .and. !Empty(cStringTemp)
   			_nCapt := Val(cStringTemp)
   			If _nCapt > 0
	   			aadd(aPesos,cStringTemp)
	   		Endif
   			cStringTemp:=""
	   	Endif
		Loop
	Endif
   cStringTemp +=nByte
End
If Len(aPesos) > 0
	aSort(aPesos)
	cString:=aPesos[Len(aPesos)]   // Retorna o ultimo peso
Endif
Return(aPesos)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFB_MATA681บAutor  ณMicrosiga           บ Data ณ  02/21/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function Ms_Peso(_nBruto,_nTara, _lSegUM, _nQtUni, _nConv, _nTpConv, _cProd, _cOpInf)

Local _nOpca   := "0"
Local _cTexto  := "Peso Balanca"
Local _cText2  := "Tara"
Local _cTipo   := Posicione("SB1",1,xFilial("SB1")+_cProd,"B1_TIPO")
Local _cText3  := "Quantidade"
Local oFont1   := TFont():New( "MS Sans Serif",0,-20,,.F.,0,,400,.F.,.F.,,,,,, )
Local _lNConv  := Substr(_cProd,1,4) == "0415"
Default _lSegUM := .f.
Default _cOpInf := M->H6_OP
If _lSegUM .or. _nConv > 0 .or. _lNConv
	oDlg4      := MSDialog():New( 088,092,350,600,"Captura Peso Balanca",,,.F.,,,,,,.T.,,,.T. )
	If _nConv > 0
		If _cTipo == "04"
			_cText3  := "Sacos"
		Else
			_cText3  := "Metragem/Un"
		Endif
	Endif
	If _lSegUM
		If _nTpConv == "M"
			_nTpConv := "D"
		Else
			_nTpConv := "M"
		Endif
	Endif
Else
	oDlg4      := MSDialog():New( 088,092,290,600,"Captura Peso Balanca",,,.F.,,,,,,.T.,,,.T. )
Endif
oSayA1     := TSay():New( 010,010,{||_ctexto},oDlg4,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,200,024)
oGetA2     := TGet():New( 010,080,{|u| If(PCount() > 0,_nBruto := u,_nBruto)},oDlg4,080,018,'@E 9,999.999',,CLR_BLACK,CLR_WHITE,oFont1,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","_nBruto",,)
If _lSegUM .or. _nConv > 0 .or. _lNConv
	oSayA3     := TSay():New( 040,010,{||_ctext3},oDlg4,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,200,024)
	oGetA4     := TGet():New( 040,080,{|u| If(PCount() > 0,_nQtUni := u,_nQtUni)},oDlg4,080,018,'@E 99,999.999',{|| .T. },CLR_BLACK,CLR_WHITE,oFont1,,,.T.,"",,/*bWhen*/,.F.,.F.,,.F.,.F.,"","_nQtUni",,)
	oSayAT     := TSay():New( 070,010,{||_ctext2},oDlg4,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,200,024)
	oGetAT     := TGet():New( 070,080,{|u| If(PCount() > 0,_nTara := u,_nTara)},oDlg4,080,018,'@E 9,999.999',,CLR_BLACK,CLR_WHITE,oFont1,,,.T.,"",,{|| .f. }/*bWhen*/,.F.,.F.,,.F.,.F.,"","_nTara",,)
	If _nConv > 0
		oBtnA1     := TButton():New( 100,010,"Confirma",oDlg4,{|| lValid := IIF(u_VldMetr(_cProd, _nBruto-_nTara, _nQtUni, _nConv, _nTpConv) .and. u_Vld_Toler(_cOpInf, _nBruto-_nTara),(oDlg4:End(),_nOpca := "1"),(_nOpca := "0",.F.) ) },050,015,,,,.T.,,"",,,,.F. )
	Else
		oBtnA1     := TButton():New( 100,010,"Confirma",oDlg4,{|| lValid := IIF(u_Vld_Toler(_cOpInf, _nBruto-_nTara),(oDlg4:End(),_nOpca := "1"),(_nOpca := "0",.F.) ) },050,015,,,,.T.,,"",,,,.F. )
	Endif
	oBtnA2     := TButton():New( 100,090,"Atualiza Peso",oDlg4,{|| u_Pg_Balanc(@_nBruto) },050,015,,,,.T.,,"",,,,.F. )
Else
	oSayAT     := TSay():New( 040,010,{||_ctext2},oDlg4,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,200,024)
	oGetAT     := TGet():New( 040,080,{|u| If(PCount() > 0,_nTara := u,_nTara)},oDlg4,080,018,'@E 9,999.999',,CLR_BLACK,CLR_WHITE,oFont1,,,.T.,"",,{|| .f. }/*bWhen*/,.F.,.F.,,.F.,.F.,"","_nTara",,)
	oBtnA1     := TButton():New( 070,010,"Confirma",oDlg4,{|| lValid := IIF(u_Vld_Toler(_cOpInf,_nBruto-_nTara),(oDlg4:End(),_nOpca := "1"),(_nOpca := "0",.F.) ) },050,015,,,,.T.,,"",,,,.F. )
	oBtnA2     := TButton():New( 070,090,"Atualiza Peso",oDlg4,{|| u_Pg_Balanc(@_nBruto) },050,015,,,,.T.,,"",,,,.F. )
Endif
oDlg4:Activate(,,,.T.)
If _nOpca == "0"
	_nBruto	:= 0
	_nQtUni := 0
Endif
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFAtuOPH6 1บAutor  Ricardo Rotta        บ Data ณ  03/07/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Valida็ใo no campo H6_OP para verificar se o acols esta    บฑฑ
ฑฑบ          ณ preenchido com os dados de outra OP, digitada anteriormenteบฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Fiabesa                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function FAtuOPH6

Local _lRet := .t.
Local _lVldAcols := IIF(TYPE("oGtd0:aHeader") <> "U",.t.,.f.)
Local _aArea := GetArea()
Local _cOPAtu := M->H6_OP
Local _cTara  := M->H6_XTARA
Local _cTipo  := Posicione("SB1",1,xFilial("SB1")+M->H6_PRODUTO,"B1_TIPO")
Local _cCampo := readvar()
Local nPosOP  := IIF(TYPE("oGtd0:aHeader") <> "U",aScan( oGtd0:aHeader, { |x| Alltrim(x[2])=="D5_OP" } ),0)
Local _cOPAnt := CriaVar("H6_OP",.F.)
If _lVldAcols
	If TYPE("oGtd0:aHeader") <> "U" .and. Len(oGtd0:aCols) > 0
		_cOPAnt := oGtd0:aCols[Len( oGtd0:aCols ), nPosOP]
	Endif
	If !Empty(_cOPAnt) .and. _cOPAtu <> _cOPAnt
		oGtd0:aCols := {}
		Aadd( oGtd0:aCols, Array( Len( oGtd0:aHeader ) + 1 ) )
		For nA := 1 To Len(oGtd0:aHeader)
			If	oGtd0:aHeader[nA,10] != "V" 
				oGtd0:aCols[Len( oGtd0:aCols ), nA] := CriaVar( oGtd0:aHeader[nA,2] )
			EndIf
		Next nA
		oGtd0:aCols[Len( oGtd0:aCols ),Len( oGtd0:aHeader ) + 1] :=.F.
		M->H6_XTARA   := CriaVar("H6_XTARA")
		M->H6_QTDPROD := 0
		M->H6_QTDPRO2 := 0		
	Endif
	If TYPE("oGtd0:aHeader") <> "U"
		oGtd0:oBrowse:Refresh()
	Endif
Endif
If _cTipo == "04" .and. !Empty(_cTara)
	u_Cap_Peso("SH6")
Endif
Return(_lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFB_MATA681บAutor  ณMicrosiga           บ Data ณ  03/23/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fun็ใo para trazer o turno da Fiabesa                      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Fiabesa                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function FBTurno

Local _cTurno := M->H6_XTURNO
Local _cTime  := Substr(time(),1,5)
If _cTime >= "05:41" .and. _cTime <= "14:00"
	_cTurno := "1"
ElseIf _cTime >= "14:01" .and. _cTime <= "22:19"
	_cTurno := "2"
Else
	_cTurno := "3"
Endif
Return(_cTurno)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFB_MATA681บAutor  ณMicrosiga           บ Data ณ  03/23/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fun็ใo para trazer o turno da Fiabesa                      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Fiabesa                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function FBDTTURN(_dData, _cTime)

Default _dData  := dDataBase
Default _cTime  := Substr(time(),1,5)
If _cTime >= "00:00" .and. _cTime <= "05:40"
	_dData := _dData - 1
Endif
Return(_dData)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFB_MATA681บAutor  ณMicrosiga           บ Data ณ  03/23/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Valida็ใo colocada no campo H6_RECURSO                     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function FBFilRec(_cParam,_cProd, _cTrab, _cRec, _cError)

Local _aArea := GetArea()
Local _lRet := .f.
Local _cRet	:= "@#.T.@#"
Local _cCodRec := ""
Local _cTpRes  := M->H6_XTPRESI
Local _cTipo := ""
Default _cProd := M->H6_PRODUTO
Default _cTrab := SH1->H1_CTRAB
Default _cRec  := SH1->H1_CODIGO
Default _cError := ""
Default _cParam := "1"

If _cParam == "1"		// Chamada via F3
	_cCampo := ReadVar()
	If Alltrim(_cCampo) == "M->Z5_TARA"
		_cProd := "0901"
		_cTpRes := M->Z5_XTPRESI
	Else
		_cTipo := Posicione("SB1",1,xFilial("SB1")+_cProd,"B1_TIPO")
	Endif
	If _cTipo == "04"
		_cRet := "@#"
		_cRet += "SH1->H1_CODIGO = '" + PadR(SuperGetMV("FB_RECPA",.F.,"90000"),Len(SH1->H1_CODIGO)) + "'"
		_cRet += "@#"
	Else
		If Substr(_cProd,1,4) == "0901"
			If !Empty(_cTpRes)
				_cRet := {}
				_cQuery := "SELECT DISTINCT Z3_CTRAB FROM " + RetSqlName("SZ3") + " SZ3 WHERE Z3_FILIAL = '" + xFilial("SZ3") + "' AND Z3_COD = '"+_cTpRes+"' AND SZ3.D_E_L_E_T_ = ' '"
				TCQUERY _cQuery NEW ALIAS "TRBFIL"
				dbSelectArea("TRBFIL")
				While !Eof()
					aadd(_cRet,TRBFIL->Z3_CTRAB)
					dbSkip()
				End
				dbSelectArea("TRBFIL")
				dbCloseArea()
			Endif
		Else
			If !Empty(M->H6_PRODUTO)
				_cQuery := "SELECT DISTINCT G2_CTRAB FROM " + RetSqlName("SG2") + " SG2 WHERE G2_FILIAL = '" + xFilial("SG2") + "' AND G2_PRODUTO = '"+_cProd+"' AND SG2.D_E_L_E_T_ = ' '"
				TCQUERY _cQuery NEW ALIAS "TRBFIL"
				dbSelectArea("TRBFIL")
				If !Eof() .and. !Bof()
					While !Eof()
						_cCodRec+= "SH1->H1_CTRAB = '" + TRBFIL->G2_CTRAB + "'"
						dbSkip()
						If !Eof()
							_cCodRec+=" .OR. " 
						Endif
					End
					_cRet := "@#"
					_cRet += _cCodRec
					_cRet += "@#"
				Endif
				dbSelectArea("TRBFIL")
				dbCloseArea()
			Endif
		Endif
	Endif
	_lRet := _cRet
Else
	If Posicione("SB1",1,xFilial("SB1")+_cProd,"B1_TIPO")== "04"
		If Alltrim(_cRec) == "90000"
			_lRet := .t.
		Else
			_cError := "01"
		Endif
	Else
		If Substr(_cProd,1,4) == "0901"
			If !Empty(M->H6_XTPRESI)
				dbSelectArea("SZ3")
				dbSetOrder(2)
				If dbSeek(xFilial()+M->H6_XTPRESI+_cTrab)
					_lRet := .t.
				Else
					_lRet := .f.
				Endif
			Else
				_lRet := .f.
				_cError := "04"
			Endif
		Else
			If !Empty(_cProd)
				dbSelectArea("SG2")
				dbOrderNickName("PRDCTB")
				If dbSeek(xFilial()+_cProd+_cTrab)
					_lRet := .t.
				Else
					_lRet := .f.
					_cError := "02"
				Endif
			Else
				_lRet := .f.
				_cError := "03"
			Endif
		Endif
	Endif
Endif
RestArea(_aArea)
Return(_lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFB_MATA681บAutor  ณMicrosiga           บ Data ณ  03/23/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Valida็ใo colocada no campo H6_RECURSO                     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function FBValRec

Local _aArea := GetArea()
Local _cProd := M->H6_PRODUTO
Local _cRec  := M->H6_RECURSO
Local _lRet  := .T.
Local _cTrab := Posicione("SH1",1,xFilial("SH1")+_cRec,"H1_CTRAB")
Local _cError := ""
If !Empty(_cRec)
	_lRet := u_FBFilRec("2",_cProd, _cTrab, _cRec, @_cError)
Endif
If !_lRet
	If _cError == "01"
		Help(" ",1,"F_VALREC1",,"Para Produto Acabado utilizar o recurso PRENSA",4,,,,,,.F.)
	ElseIf _cError == "02"
		Help(" ",1,"F_VALREC2",,"Recurso informado nao estแ cadastrado para esse produto",4,,,,,,.F.)
	ElseIf _cError == "03"
		Help(" ",1,"F_VALREC3",,"Informar primeiro o campo Produto",4,,,,,,.F.)
	Else
		Help(" ",1,"F_VALREC4",,"Informar primeiro o campo Tipo de Residuo",4,,,,,,.F.)
	Endif
Endif
RestArea(_aArea)
Return(_lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFB_MATA681บAutor  Ricardo Rotta        บ Data ณ  03/30/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo incluida no campo X3_WHEN de alguns campos do SH6    บฑฑ
ฑฑบ          ณpara habilitar/desabilitar o campo                          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function R681When()

Local _lRet := .t.
If _lRet
	If valtype(_aIniVar) == 'A' .and. Len(_aIniVar) > 0
		_lRet := .F.
	Endif
Endif
Return(_lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFB_MATA681บAutor  Ricardo Rotta        บ Data ณ  03/30/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo incluida no campo X3_WHEN de alguns campos do SH6    บฑฑ
ฑฑบ          ณpara habilitar/desabilitar o campo                          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function RWhenRC()

Local _lRet := .t.
Local _cTipo := Posicione("SB1",1,xFilial("SB1")+M->H6_PRODUTO,"B1_TIPO")

If _cTipo == "04"
	_lRet := .f.
Else
	If valtype(_aIniVar) == 'A' .and. Len(_aIniVar) > 0
		_lRet := .F.
	Endif
Endif
Return(_lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFB_MATA681บAutor  ณMicrosiga           บ Data ณ  03/30/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo tem o objetivo de ao clicar em salvar o sistema verificar
ฑฑบ          ณse os dados vem de OP anteriormente apontada se vem e nใo foi
ฑฑบ          ณinformado o peso o sistema abre a janela para informar, dessa forma agiliza o processo
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function FBIniPeso(_lContiOP)

Local _lRet := .t.
Local _nPosOP := 0
Local _cCodPro := ""
If valtype(_aIniVar) == 'A' .and. Len(_aIniVar) > 0 .and. Len(oGtd0:acols) = 1 .and. Empty(oGtd0:acols[1,1])
	_lRet := u_Cap_peso("SH6")
	_lContiOP := .t.
Endif
Return(_lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFB_MATA681บAutor  ณMicrosiga           บ Data ณ  06/02/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function Cad_Estac(_cEstacao)

Local _aArea := GetArea()
Local _cFila := CriaVar("CB5_CODIGO",.F.)
Local _nOpc := 0

DEFINE MSDIALOG _oDlg1 TITLE "Manutencao do cadastro de Estacao x Impressora" From 00,00 To 180,450 OF oMainWnd PIXEL

@ 12,10 SAY 'Estacao:' size 120,15 pixel 
@ 10,45 MSGET _cEstacao picture '@!' when .f. pixel
@ 27,10 SAY 'Impressora:' size 120,15 pixel
@ 25,45 MSGET _cFila F3 "CB5" picture '@!' when .t. pixel Valid(Vld_Imp(_cFila))

@ 60,010 BUTTON "&Ok"       SIZE 36,16 PIXEL ACTION (_nOpc:=1,_oDlg1:End())
@ 60,060 BUTTON "&Cancelar" SIZE 36,16 PIXEL ACTION (_cFila := CriaVar("CB5_CODIGO",.F.),_nOpc:=0,_oDlg1:End())
Activate dialog _oDlg1 center
if _nOpc==1 .and. !Empty(_cFila)
	dbSelectArea("SZ1")
	RecLock("SZ1",.T.)
	Replace Z1_FILIAL with xFilial("SZ1"),;
			Z1_ESTACAO with _cEstacao,;
			Z1_FILAIMP with _cFila
	MsUnLock()
Endif
RestArea(_aArea)
Return(_cFila)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFB_MATA681บAutor  ณMicrosiga           บ Data ณ  06/03/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function Vld_Imp(_cFila)

Local _lRet := .t.
If !Empty(_cFila)
	dbSelectArea("CB5")
	dbSetOrder(1)
	If !dbSeek(xFilial()+_cFila)
		Help(" ",1,"NENCTF",,"Impressora nใo encontrada no cadastro",4,,,,,,.F.)
		_lRet := .f.
	Endif
Endif
Return(_lRet)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFB_MATA681บAutor  ณMicrosiga           บ Data ณ  06/09/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFuncao colocada no incializador padrใo da Descricao H6_XDESCบฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Fiabesa                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function FBDESC(_cParam)

Local _cRet := ""   
Local _nPosDesc := 0
If Inclui
	If valtype(_aIniVar) == 'A' .and. Len(_aIniVar) > 0
		If _cParam == "0"
			_nPosDesc := aScan( _aIniVar, { |x| Alltrim(x[1])=="M->H6_XDESC" } )
			For nT:=1 to Len(_aIniVar)
				_lAtuCp := .t.
				If !(_aIniVar[nT,1] $ "M->H6_QTDPRO2/M->H6_QTDPROD")
					If _lAtuCp
						&(_aIniVar[nT,1]) := _aIniVar[nT,2]
					Endif
				Endif
			Next
		ElseIf _cParam == "1"
			_nPosDesc := aScan( _aIniVar, { |x| Alltrim(x[1])=="M->H6_DSCREC" } )
		ElseIf _cParam == "2"
			_nPosDesc := aScan( _aIniVar, { |x| Alltrim(x[1])=="M->H6_XDESCTR" } )
		Endif
		If _nPosDesc > 0
			_cRet := _aIniVar[_nPosDesc,2]
		Endif
	Endif
Endif
Return(_cRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFB_MATA681บAutor  ณMicrosiga           บ Data ณ  07/30/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function Vld_Toler(_cOPInf, _nApont)

Local _lRet     := .t.
Local _nToler   := IIF(_cOPInf=="zz",0,Posicione("SC2",1,xFilial("SC2")+_cOPInf,"C2_XTOLER"))
Local _nQtdOP   := IIF(_cOPInf=="zz",0,Posicione("SC2",1,xFilial("SC2")+_cOPInf,"C2_QUANT"))
Local _nQuje    := IIF(_cOPInf=="zz",0,Posicione("SC2",1,xFilial("SC2")+_cOPInf,"C2_QUJE"))
Local _nQtdPer  := IIF(_cOPInf=="zz",0,_nQtdOP * (1+(_nToler/100)))
If _cOPInf <> "zz" // Lancamento de Residuo
	If _nApont + _nQuje > _nQtdPer
		Help(" ",1,"OPTOLER",,"Quantidade informada supera a tolerancia de apontamento da OP, quantidade nใo permitida",4,,,,,,.F.)
		_lRet := .f.
	Endif
Endif
Return(_lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFuno    ณA680ShowOPณ Autor ณFernando Joly Siquini ณ Data ณ 30.12.98  ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescrio ณ Consulta OP atraves da tecla F4                            ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณSintaxe   ณ A680ShowOP(a,b,c)                                          ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณUso       ณ MATA680                                                    ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function F680ShowOp()
Local oDlg
Local nHdl      := GetFocus()
Local nOAT

Local nOpt1     := 0
Local aArray    := {}
Local cAlias    := Alias()
Local nOrder    := IndexOrd()
Local nRecno    := Recno()
Local cCampo    := ReadVar()
Local cPicture  := PesqPictQt('C2_QUANT',16)
Local nOrdSC2   := SC2->(IndexOrd())
Local lContinua	:= .T.
Local cQuery	:= ""
Local cAliasSC2 := "SC2"
Local nPosCod := aScan( oGtd0:aHeader, { |x| Alltrim(x[2])=="D5_PRODUTO" } )
Local _cCodigo

If !(cCampo=='M->H6_OP')
	lContinua := .F.
ElseIf Empty(M->H6_PRODUTO)
	Help(' ',1,'A680NAOPRO')
	lContinua := .F.
EndIf

If lContinua
	cAliasSC2	:= CriaTrab(NIL,.f.)
	cQuery		:= "SELECT SC2.C2_NUM,SC2.C2_ITEM,SC2.C2_SEQUEN,SC2.C2_ITEMGRD,SC2.C2_PRODUTO, "
	cQuery		+= "SC2.C2_QUANT, SC2.C2_QUJE, SC2.C2_PERDA, SC2.C2_DATRF FROM "
	cQuery		+= 	RetSqlName("SC2")+" SC2 "
	cQuery		+= "WHERE "
	cQuery		+= "SC2.C2_FILIAL = '"+xFilial("SC2")+"' And "
	cQuery		+= "SC2.C2_PRODUTO = '"+M->H6_PRODUTO+"' And "
	cQuery		+= "SC2.C2_DATRF = '"+Dtos(Ctod(""))+"' And "
	cQuery		+= "SC2.D_E_L_E_T_ = ' ' "
	cQuery		:= ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSC2,.T.,.T.)
	aEval(SC2->(dbStruct()), {|x| If(x[2] <> "C" .And. FieldPos(x[1]) > 0, TcSetField(cAliasSC2,x[1],x[2],x[3],x[4]),Nil)})

	While (cAliasSC2)->(!Eof())
		(cAliasSC2)->(aAdd(aArray,{C2_NUM,C2_ITEM,C2_SEQUEN,C2_ITEMGRD,C2_PRODUTO,Transform(aSC2Sld(cAliasSC2),cPicture)}))
		(cAliasSC2)->(DbSkip())
	EndDo
	(cAliasSC2)->(DbCloseArea())
	DbSelectArea(cAlias)

	If !Empty(aArray)
		DEFINE MSDIALOG oDlg TITLE OemToAnsi('OPs deste Produto') From 09,0 To 30,90 OF oMainWnd     //
		@ 0.5,  0 TO 10, 39.0 OF oDlg
		@ 1,.7 LISTBOX oQual VAR cVar Fields HEADER OemToAnsi('N๚mero'),OemToAnsi("Item"),OemToAnsi("Sequencia"),RetTitle("C2_ITEMGRD"),OemToAnsi("Produto"),OemToAnsi("Saldo") SIZE 300,120 ON DBLCLICK (nOpt1 := 1,oDlg:End())   //###'Item'###'Sequncia'###'Produto'###'Saldo'
		oQual:SetArray(aArray)
		oQual:bLine := { || {aArray[oQual:nAT][1],aArray[oQual:nAT][2],aArray[oQual:nAT][3],aArray[oQual:nAT][4],aArray[oQual:nAT][5],aArray[oQual:nAT][6]}}
		DEFINE SBUTTON FROM 10  ,315  TYPE 1 ACTION (nOpt1 := 1,oDlg:End()) ENABLE OF oDlg
		DEFINE SBUTTON FROM 22.5,315  TYPE 2 ACTION oDlg:End() ENABLE OF oDlg
		ACTIVATE MSDIALOG oDlg VALID (nOAT := oQual:nAT,.t.)
		If nOpt1 == 1
			M->H6_OP := aArray[nOAT][1]+aArray[nOAT][2]+aArray[nOAT][3]+aArray[nOAT][4]
			nEndereco := Ascan(aGets,{ |x| Subs(x,9,5) == 'H6_OP' } )
			If nEndereco > 0
				aTela[Val(Subs(aGets[nEndereco],1,2))][Val(Subs(aGets[nEndereco],3,1))*2] := M->H6_OP
			EndIf
		EndIf
		SetFocus(nHdl)
	Else
		Help(' ',1,'A250NAOOP')
	EndIf
EndIf
If !lContinua .and. Empty(cCampo) .and. Len(oGtd0:aCols) > 0
	_nLinha := oGtd0:nAT
	If _nLinha > 0 .and. !Empty(oGtd0:aCols[_nLinha,nPosCod])
		PRIVATE cPictQtd14 := PesqPict('SB8', 'B8_SALDO',   14)
		PRIVATE aTotal
		PRIVATE cCadastro  := OemToAnsi("Lote X Localiza็ใo")
		_cCodigo := oGtd0:aCols[_nLinha,nPosCod]
		SB1->(dbSetOrder(1))
		SB1->(dbSeek(xFilial("SB1")+_cCodigo))
		If SB1->B1_RASTRO $ " /N"
			MaViewSB2(_cCodigo)
		Else
			MC070Con()
		Endif
	Endif
Endif
dbSelectArea(cAlias)
dbSetOrder(nOrder)
dbGoTo(nRecno)
SC2->(dbSetOrder(nOrdSC2))
If lContinua
	CheckSx3("H6_OP")
EndIf

Return Nil
*----------------------------------------------------------------------------------------
Static Function Al_MudaEnc(nAtu,oFolder)
*----------------------------------------------------------------------------------------

If nAtu== 1
	dbSelectArea("SH6")
	oEnc01:oBox:align:= CONTROL_ALIGN_ALLCLIENT
	oEnc01:Refresh()
Else
	dbSelectArea("SZ5")
	oEnc02:oBox:align:= CONTROL_ALIGN_ALLCLIENT
	oEnc02:Refresh()
EndIf
Return Nil


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFB_MATA681บAutor  ณMicrosiga           บ Data ณ  12/20/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function FB_FilaImp

Local _cEstacao := GetComputerName()
Local _cFilaCP  := ""
dbSelectArea("SZ1")
dbSetOrder(1)
If !dbSeek(xFilial()+Alltrim(_cEstacao))
	Alert("Cadastrar a impressora relacionada a essa esta็ใo de trabalho, fa็a o cadastro na proxima tela")
	_cFilaCP := u_Cad_Estac(_cEstacao)
Else
	_cFilaCP := SZ1->Z1_FILAIMP
Endif
Return(_cFilaCP)



