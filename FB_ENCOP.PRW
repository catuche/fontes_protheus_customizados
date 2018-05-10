#include "rwmake.ch"
#Include "TOPCONN.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณBK_ENCOP  บAutor  ณRicardo Rotta       บ Data ณ  01/19/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina de Encerramento de OP                                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function FB_ENCOP

Local aSay    := {}
Local aButton := {}
Local nOpc    := 0
Local cTitulo := "Encerramento das Ordens de Producao"
Local cDesc1  := "Este programa tem como objetivo encerrar as Ordens de Producao"
Local cDesc2  := "Especifico - Fiabesa"

Private cPerg := "FB_ENCOP"

AjustaSx1(cPerg)
Pergunte(cPerg,.F.)

aAdd( aSay, cDesc1 )
aAdd( aSay, cDesc2 )

aAdd( aButton, { 5, .T., {|| Pergunte(cPerg,.T. )    }} )
aAdd( aButton, { 1, .T., {|| nOpc := 1, FechaBatch() }} )
aAdd( aButton, { 2, .T., {|| FechaBatch()            }} )

FormBatch( cTitulo, aSay, aButton )

If nOpc <> 1
	Return Nil
Endif

Processa( {|lEnd| RunProc(@lEnd)}, "Aguarde...","Executando rotina.", .T. )
Processa( {|lEnd| Ref_Emp(@lEnd)}, "Aguarde...","Finalizando rotina.", .T. )

Return Nil


/////////////////////////////////////
Static Function RunProc()
/////////////////////////////////////
Local _cQuery:= Nil
Local _nRegView:= i:= 0
Local _cOP:= _cData:= _cProd:= ' '
Local _nQtdPerda:= _nQtd:= _nQtdS:= _nReg:= 0
Local _nCust1:= _nCust2:= _nCust3:= 0
Local _nCusF1:= _nCusF2:= _nCusF3:= 0
Local aDelete:= {}
Local _aArea := GetArea()
Local aButtons:={}
Local lRetorno := .f.
Local bFilTro:={|| Wrb->(DbSetFilter({|| WRB->OP==Trb->OP },"Wrb->OP==Trb->OP") ) }
Local bOk    :={|| lRetorno:=.T.,oDlg:End()  }
Local bCancel:={|| lRetorno:=.F.,oDlg:End()  }
Local cMarca      := GetMark()
Local cConcat
Private lInverte  := .F.

aStru   := {}
aCampos := {}
aAdd(aStru,{"TRB_OK" ,"C",2,0})
aAdd(aStru,{"OP" ,"C",13,0})
aAdd(aStru,{"EMISSAO" ,"D",08,0})
aAdd(aStru,{"PRODUTO","C",15,0})
aAdd(aStru,{"DESCR","C",30,0})
aAdd(aStru,{"UM","C",2,0})
aAdd(aStru,{"QTDEOP","N",Tamsx3("D3_QUANT")[1],Tamsx3("D3_QUANT")[2]})
aAdd(aStru,{"QTDE","N",Tamsx3("D3_QUANT")[1],Tamsx3("D3_QUANT")[2]})
aAdd(aStru,{"NREGD3" ,"N",10,0})
aAdd(aStru,{"TABELA","C",3,0})

AADD(aCampos,{"TRB_OK","","Marca","@!"})
AADD(aCampos,{"OP","","Ordem de Producao","@!"})
AADD(aCampos,{"EMISSAO","","Emissao","@!"})
AADD(aCampos,{"PRODUTO","","Produto","@!"})
AADD(aCampos,{"DESCR","","Descricao","@!"})
AADD(aCampos,{"UM","","Unidade","@!"})
AADD(aCampos,{"QTDEOP" ,,"Quant. OP" ,AvSx3("D3_QUANT",6)})
AADD(aCampos,{"QTDE" ,,"Produzido"  ,AvSx3("D3_QUANT",6)})

cNometrb := CriaTrab(aStru)
USE &cNometrb ALIAS TRB NEW EXCLUSIVE
//cNometrb:=E_CriaTrab(,aStru,"TRB")
IndRegua("TRB",cNometrb+OrdBagExt(),"OP")

cursorwait()

aStruTrb := {}

AADD(aStruTrb,{"OP" ,"C",13,0})
AADD(aStruTrb,{"DDATA" ,"D",8,0})
AADD(aStruTrb,{"QUANT","N",Tamsx3("D3_QUANT")[1],Tamsx3("D3_QUANT")[2]})
aAdd(aStruTrb,{"UM","C",2,0})

aCpoTrb:={}
AADD(aCpoTrb,{"DDATA" ,,"Dt Producao","@!"})
AADD(aCpoTrb,{"QUANT"   ,,"Quantidade",AvSx3("D3_QUANT",6)})
AADD(aCpoTrb,{"UM" ,,"Unidade","@!"})

cNomeWrb := CriaTrab(aStrutrb)
USE &cNomeWrb ALIAS WRB NEW EXCLUSIVE
IndRegua("Wrb",cNomeWrb+OrdBagExt(),"OP")

If Upper(TcGetDb()) $ "ORACLE,POSTGRES,DB2,INFORMIX"
	cConcat := "||"
Else
	cConcat	:= "+"
Endif 

cQuery := "DELETE " + RetSqlName("SD3")
cQuery := cQuery + " WHERE D3_FILIAL  = '"+xFilial("SD3")+"' "
cQuery += " And D3_ESTORNO = 'S' "
cQuery += " And D3_EMISSAO >= '"+DtoS(MV_PAR03)+"' "
cQuery += " And D3_EMISSAO <= '"+DtoS(MV_PAR04)+"' "
cQuery += " And D3_OP      >= '"+MV_PAR01+"' "
cQuery += " And D3_OP      <= '"+MV_PAR02+"' "
TCSQLExec(cQuery)  // Excluir os registros estornados, pois o execauto nao deixa encerrar uma OP se a mesma estiver estornada!

_cQuery := " SELECT D3_COD PRODUTO,D3_OP OP,D3_EMISSAO EMISSAO,D3_QUANT QUANT,SD3.R_E_C_N_O_ RECNORE, 'SD3' TAB"
_cQuery += " From "+RetSqlName('SD3')+" SD3"
_cQuery += " Where D3_FILIAL = '"+xFilial('SD3')+"'"
_cQuery += " And SD3.D_E_L_E_T_ = ' '"
_cQuery += " And D3_ESTORNO = ' ' "
_cQuery += " And D3_EMISSAO >= '"+DtoS(MV_PAR03)+"' "
_cQuery += " And D3_EMISSAO <= '"+DtoS(MV_PAR04)+"' "
_cQuery += " And D3_OP      >= '"+MV_PAR01+"' "
_cQuery += " And D3_OP      <= '"+MV_PAR02+"' "
_cQuery += " And D3_OP      <> ' ' "
_cQuery += " And D3_TIPO    >= '"+MV_PAR05+"' "
_cQuery += " And D3_TIPO    <= '"+MV_PAR06+"' "
_cQuery += " And D3_GRUPO   >= '"+MV_PAR07+"' "
_cQuery += " And D3_GRUPO   <= '"+MV_PAR08+"' "
_cQuery += " And D3_CF = 'PR0' "
_cQuery += " Order By 2,3 "
_cQuery := ChangeQuery(_cQuery)
TCQUERY _cQuery NEW ALIAS "TRD3"
dbSelectArea("TRD3")
dbGoTop()
While ! Eof()
	_cOP  := TRD3->OP
	_cTab := TRD3->TAB
	_nUltApon := 0
	_nQtdPrd  := 0
	While !Eof() .and. _cOP  == TRD3->OP
		_nUltApon := TRD3->RECNORE  // Guardo o registro do ultimo apontamento para encerrar a OP
		If TRD3->TAB == "SD3"
			_nQtdPrd  += TRD3->QUANT
		Endif
		_dEmissao := Stod(TRD3->EMISSAO)
		dbSelectArea("WRB")
		RecLock("WRB",.T.)
		Replace OP with _cOP,;
				DDATA with Stod(TRD3->EMISSAO),;
				QUANT with TRD3->QUANT,;
				UM with Posicione("SB1",1,xFilial("SB1")+TRD3->PRODUTO,"B1_UM")
		MsUnLock()
		dbSelectArea("TRD3")
		dbSkip()
	End
	dbSelectArea("SD3")
	dbGoto(_nUltApon)
	dbSelectArea("SC2")
	dbSetOrder(1)
	If dbSeek(xFilial("SC2")+_cOP)
		If Empty(SC2->C2_DATRF) .and. _nUltApon > 0  // Se nao estiver encerrada, encerro
			dbSelectArea("TRB")
			RecLock("TRB",.T.)
			Replace OP with _cOP,;
					PRODUTO with SC2->C2_PRODUTO,;
					DESCR with Posicione("SB1",1,xFilial("SB1")+SC2->C2_PRODUTO,"B1_DESC"),;
					EMISSAO with SC2->C2_EMISSAO,;
					QTDEOP with SC2->C2_QUANT,;
					QTDE with _nQtdPrd,;
					UM with Posicione("SB1",1,xFilial("SB1")+SC2->C2_PRODUTO,"B1_UM"),;
					NREGD3 with _nUltApon,;
					TABELA with _cTab
			MsUnLock()
		Endif
	Endif
	dbSelectArea("TRD3")
End
dbSelectArea("TRB")
dbGotop()
If !Eof() .and. !Bof()
	oMainWnd:ReadClientCoors()
	WRB->(DbGoTop())
	Trb->(DbGoTop())
	_cMarca := GetMark()
	Define MsDialog oDlg Title "OPs a serem Encerradas"  From oMainWnd:nTop-75,oMainWnd:nLeft-35 TO oMainWnd:nBottom-90,oMainWnd:nRight-55 Of oMainWnd Pixel
	oMark := MsSelect():New("TRB","TRB_OK",,aCampos,@lInverte,@_cMarca,{40,1,160,(oDlg:nClientWidth-4)/2})
	oMark:oBrowse:bChange:={|| Eval(bFilTro),Wrb->(DbGoTop()),oBrwTrb:oBrowse:Default(),oBrwTrb:oBrowse:Refresh()}
	oMark:bAval := { || PQ_MARCA(@_cMarca,oMark) }

	oBrwTrb:=MsSelect():New("WRB","","",aCpoTrb,@lInverte,@_cMarca,{165,1,(oDlg:nClientHeight-80)/2,(oDlg:nClientWidth-4)/2})
	Activate MsDialog oDlg On Init (EnchoiceBar(oDlg,bOk,bCancel,,aButtons)) Centered
	If lRetorno
		PQ_ENC01()
	Endif
Else
	Alert("Nao encontrado OPs para encerrar neste periodo")
Endif
dbSelectArea("TRB")
dbCloseArea()
dbSelectArea("WRB")
dbCloseArea()
dbSelectArea("TRD3")
dbCloseArea()
dbSelectArea("SC2")
Return

*-------------------------------------------------------------------------------------------------------------------
Static Function PQ_ENC01
*-------------------------------------------------------------------------------------------------------------------
Local _aArea := GetArea()
Local _nUltApon := 0
Private aVetor := {}
Private lMsErroAuto := .F.
dbSelectArea("TRB")
dbGotop()
While !Eof()
	If TRB->TRB_OK == _cMarca
		_nUltApon := TRB->NREGD3
		If TRB->TABELA == "SD3"
			dbSelectArea("SD3")
			dbGoto(_nUltApon)
			dbSelectArea("SD3")
			_dApont := SD3->D3_EMISSAO
			_dUltDt := LastDay(_dApont)
			RecLock("SD3",.F.)
			Replace D3_EMISSAO with _dUltDt
			MsUnLock()
			aVetor:={	{"D3_OP", SD3->D3_OP ,NIL},;
						{"D3_FILIAL"    ,xFilial("SD3"),NIL},;
						{"D3_DOC",SD3->D3_DOC,NIL},;
						{"D3_TM",SD3->D3_TM,NIL},;
						{"D3_COD",SD3->D3_COD,NIL},;
						{"D3_EMISSAO",SD3->D3_EMISSAO,NIL},;
						{"D3_NUMSEQ",SD3->D3_NUMSEQ,NIL},;
						{"D3_QUANT",SD3->D3_QUANT,NIL}}
			MsgRun("Encerrando OPs...","Aguarde...",{|| MSExecAuto({|x,y| mata250(x,y)},aVetor,6)})  // Encerrando OPs
			If lMsErroAuto
				Alert("Inconsistencia no Encerramento da Ordem de Producao")
				MostraErro()
			Endif
			dbSelectArea("SD3")
			dbGoto(_nUltApon)
			RecLock("SD3",.F.)
			Replace D3_EMISSAO with _dApont
			MsUnLock()
			u_Atu_Emp("1", SD3->D3_OP)
		Else
			dbSelectArea("SC2")
			dbGoto(_nUltApon)
			RecLock("SC2",.F.)
			Replace C2_DATRF with dDataBase
			MsUnLock()
			dbSelectArea("SB2")
			dbSetOrder(1)
			If dbSeek(xFilial()+SC2->(C2_PRODUTO+C2_LOCAL))
				RecLock("SB2",.F.)
				Replace B2_SALPEDI with B2_SALPEDI - SC2->C2_QUANT
				MsUnLock()
			Endif
			u_Atu_Emp("2",SC2->(C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD))
		Endif
	Endif
	dbSelectArea("TRB")
	dbSkip()
End
RestArea(_aArea)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPQ_ENCOP  บAutor  ณMicrosiga           บ Data ณ  03/14/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function Atu_Emp(_cParam,_cOPEmp)

Local _aArea := GetArea()
Local aTravas	:= {}
Local lConsVenc	:= GetMV('MV_LOTVENC')=='S'
Local _lContinua := .t.
If _cParam == "1"
	dbSelectArea("SF5")
	dbSeek(xFilial("SF5")+SD3->D3_TM)
	If F5_ATUEMP == "S"  // Executar apenas quando for "N" pois se for "S" o padrao ja executa
		_lContinua := .F.
	Endif
Endif
If _lContinua
	dbSelectArea("SD4")
	dbSetOrder(2)
	dbSeek(xFilial("SD4")+_cOPEmp)
	While !EOF() .And. D4_FILIAL+D4_OP==xFilial("SD4")+_cOPEmp
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Atualiza arq. de saldos  B2_QEMP                                  ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		GravaEmp(	SD4->D4_COD,;
					SD4->D4_LOCAL,;
					SD4->D4_QUANT,;
					SD4->D4_QTSEGUM,;
					SD4->D4_LOTECTL,;
					SD4->D4_NUMLOTE,;
					NIL,;
					NIL,;
					SD4->D4_OP,;
					SD4->D4_TRT,;
					NIL,;
					NIL,;
					"SC2",;
					NIL,;
					SD4->D4_DATA,;
					@aTravas,;
					.T.,;
					NIL,;
					.T.,;
					.T.,;
					lConsVenc,;
					NIL,;
					NIL,;
					.T.)
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Remove travas dos registros utilizados                  ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		MaDesTrava(aTravas)
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Atualiza quantidade do SD4                              ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		RecLock("SD4",.F.)
		If SD4->(FieldPos("D4_SLDEMP")) > 0 .And. SD4->(FieldPos("D4_SLDEMP2")) > 0
			SD4->D4_SLDEMP	:= SD4->D4_QUANT
			SD4->D4_SLDEMP2	:= SD4->D4_QTSEGUM
		Endif
		Replace D4_QUANT	With 0
		Replace D4_QTSEGUM	With 0
		MsUnlock()
		dbSkip()
	End
EndIf
RestArea(_aArea)
Return
*------------------------------------------------------
Static Function PQ_MARCA(_cMarca,oMark)
*------------------------------------------------------
Local _aArea := GetArea()
local lMarca := Iif( TRB->TRB_OK <> _cMarca, .T., .F.)
local nRecno := TRB->( Recno() )
Local _lCont := .t.
Local _dApont, _dUltDt
If TRB->( ! EoF() )
	If TRB->TABELA == "SD3"
		_nRegD3 := TRB->NREGD3
		dbSelectArea("SD3")
		dbGoto(_nRegD3)
		_dApont := SD3->D3_EMISSAO
		_dUltDt := LastDay(_dApont)
		_cQuery := " SELECT D3_COD,D3_OP,D3_EMISSAO, SD3.R_E_C_N_O_ From "+RetSqlName('SD3')+" SD3"
		_cQuery += " Where D3_FILIAL = '"+xFilial('SD3')+"'"
		_cQuery += " And SD3.D_E_L_E_T_ = ' '"
		_cQuery += " And D3_ESTORNO = ' ' "
		_cQuery += " And D3_EMISSAO > '"+Dtos(_dUltDt)+"' "
		_cQuery += " And D3_OP      = '"+SD3->D3_OP+"' "
		_cQuery += " And D3_CF <> 'PR0' "
		_cQuery += " Order By D3_OP,D3_EMISSAO "
		_cQuery := ChangeQuery(_cQuery)
		TCQUERY _cQuery NEW ALIAS "D3RE"
		dbSelectArea("D3RE")
		dbGoTop()
/*
		If !Eof()
			Alert("A OP numero "+SD3->D3_OP+" nao podera ser encerrada, pois existem requisicoes em meses posterior a ultima producao")
			_lCont := .f.
		Endif
*/
		dbSelectArea("D3RE")
		dbCloseArea()
		If _lCont
			_cQuery := " SELECT D3_COD,D3_OP,D3_EMISSAO, SD3.R_E_C_N_O_ From "+RetSqlName('SD3')+" SD3"
			_cQuery += " Where D3_FILIAL = '"+xFilial('SD3')+"'"
			_cQuery += " And SD3.D_E_L_E_T_ = ' '"
			_cQuery += " And D3_ESTORNO = ' ' "
			_cQuery += " And D3_EMISSAO <= '"+Dtos(_dUltDt)+"' "
			_cQuery += " And D3_OP      = '"+SD3->D3_OP+"' "
			_cQuery += " And D3_CF LIKE 'RE%' "
			_cQuery += " Order By D3_OP,D3_EMISSAO "
			_cQuery := ChangeQuery(_cQuery)
			TCQUERY _cQuery NEW ALIAS "D3RE"
			dbSelectArea("D3RE")
			dbGoTop()
/*
			If Eof()
				Alert("A OP numero "+SD3->D3_OP+" nao podera ser encerrada, pois NAO existem requisicoes para esta producao")
				_lCont := .f.
			Endif
*/
			dbSelectArea("D3RE")
			dbCloseArea()
		Endif
	Endif
	If _lCont
		dbSelectArea("TRB")
		RecLock( "TRB", .F. )
		TRB->TRB_OK := iif( lMarca, _cMarca, "  " )
		TRB->( MsUnlock() )
		oMark:oBrowse:Refresh(.T.)
	Endif
endif
RestArea(_aArea)
Return( .T. )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFB_ENCOP  บAutor  ณMicrosiga           บ Data ณ  08/14/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function Ref_Emp()

Local _cQuery, _nRet

_cQuery := "UPDATE " + RetSqlName("SD4") + " SET D4_QUANT = 0"
_cQuery += " FROM " + RetSqlName("SD4") + " SD4, " + RetSqlName("SC2") + " SC2"
_cQuery += " WHERE D4_QUANT <> 0"
_cQuery += " AND D4_FILIAL+D4_OP = C2_FILIAL+C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD"
_cQuery += " AND SD4.D_E_L_E_T_ = ' '"
_cQuery += " AND SC2.D_E_L_E_T_ = ' '"
_cQuery += " AND C2_DATRF <> '        '"
_nRet := TCSQLExec(_cQuery)
If _nRet <> 0
	_cError := TCSQLError()
	Return
Endif

_cQuery := "UPDATE " + RetSqlName("SD4") + " SET D4_QUANT = 0"
_cQuery += " FROM " + RetSqlName("SD4") + " SD4"
_cQuery += " WHERE SD4.D_E_L_E_T_ = ' '"
_cQuery += " AND D4_FILIAL+D4_OP NOT IN (SELECT C2_FILIAL+C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD FROM " + RetSqlName("SC2") + " SC2" + " WHERE SC2.D_E_L_E_T_ = ' ')"
_nRet := TCSQLExec(_cQuery)
If _nRet <> 0
	_cError := TCSQLError()
	Return
Endif

_cQuery := "SELECT D4_FILIAL, D4_COD,D4_LOCAL,SUM(D4_QUANT) QUANT INTO SD4SUM "
_cQuery += " FROM " + RetSqlName("SD4") + " SD4, " + RetSqlName("SC2") + " SC2"
_cQuery += " WHERE D4_QUANT > 0"
_cQuery += " AND SD4.D_E_L_E_T_ = ' '"
_cQuery += " AND D4_FILIAL+D4_OP = C2_FILIAL+C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD"
_cQuery += " AND C2_TPOP <> 'P'"
_cQuery += " AND SC2.D_E_L_E_T_ = ' '"
_cQuery += " GROUP BY D4_FILIAL, D4_COD,D4_LOCAL"
_nRet := TCSQLExec(_cQuery)
If _nRet <> 0
	_cError := TCSQLError()
	Return
Endif

_cQuery := "UPDATE " + RetSqlName("SB2") + " SET B2_QEMP = 0"
_cQuery += " WHERE " + RetSqlName("SB2") + ".D_E_L_E_T_ = ' '"
_cQuery += " AND B2_FILIAL+B2_COD+B2_LOCAL NOT IN (SELECT D4_FILIAL+D4_COD+D4_LOCAL FROM SD4SUM)"
_nRet := TCSQLExec(_cQuery)
If _nRet <> 0
	_cError := TCSQLError()
	Return
Endif

_cQuery := "UPDATE " + RetSqlName("SB2") + " SET B2_QEMP = QUANT "
_cQuery += " FROM SD4SUM, " + RetSqlName("SB2") + " SB2"
_cQuery += " WHERE D4_COD = B2_COD "
_cQuery += " AND D4_LOCAL = B2_LOCAL"
_cQuery += " AND B2_FILIAL = D4_FILIAL"
_cQuery += " AND SB2.D_E_L_E_T_ = ' '"
_nRet := TCSQLExec(_cQuery)
If _nRet <> 0
	_cError := TCSQLError()
	Return
Endif

_nRet := TCSQLExec("DROP TABLE SD4SUM")
If _nRet <> 0
	_cError := TCSQLError()
	Return
Endif

Return

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

aAdd(aRegs,{cPerg,"01","Da OP           ?","","","mv_ch1","C",13,00,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SC2"})
aAdd(aRegs,{cPerg,"02","Ate OP          ?","","","mv_ch2","C",13,00,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SC2"})
Aadd(aRegs,{cPerg,"03","Da Data         ?","Da Emissao           ?","Da Emissao          ?","mv_ch3","D",08,0,0,"G","","mv_par03"," "," "," ","",""," "," "," ","","","","","","","","","","","","","","","","",""," ","",""})
Aadd(aRegs,{cPerg,"04","Ate Data        ?","Ate Emissao          ?","Ate Emissao         ?","mv_ch4","D",08,0,0,"G","","mv_par04"," "," "," ","",""," "," "," ","","","","","","","","","","","","","","","","",""," ","",""})
aAdd(aRegs,{cPerg,"05","Do Tipo         ?","","","mv_ch5","C",02,00,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","02"})
aAdd(aRegs,{cPerg,"06","Ate Tipo        ?","","","mv_ch6","C",02,00,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","02"})
aAdd(aRegs,{cPerg,"07","Do Grupo        ?","","","mv_ch7","C",04,00,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","SBM"})
aAdd(aRegs,{cPerg,"08","Ate Grupo       ?","","","mv_ch8","C",04,00,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","SBM"})

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