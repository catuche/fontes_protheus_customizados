#Include "rwmake.ch"
#Include "TbiConn.ch"
#Include "TopConn.ch"
#Include "Protheus.ch"
#include "fileio.ch"

/*======================================================================
== Programa  ³MARHOT01  ºAutor  ³TOTVS NE         º Data ³  17/08/15  ==
==--------------------------------------------------------------------==
== Descrição ³Integração Protheus (Contabilidade).  			      ==
==           ³                                                        ==
==--------------------------------------------------------------------==
== Uso       ³Contabilidade                                           ==
==--------------------------------------------------------------------==
========================================================================*/
User Function MARHOT01
	//Private cPerg := "PRMPT02"
	Private oLeTxt
	
	//CriaPerg(cPerg)
	
	@ 200,01 TO 380,380 DIALOG oLeTxt TITLE OemToAnsi("Integração Protheus (Contabilidade)")
	@ 02,02 Say " Esta rotina irá importar arquivos .txt, com os lançamentos contabéis,"
	@ 03,02 Say " para o Protheus - Contabilidade."
	
	//@ 70,098 BmpButton Type 05 Action Pergunte(cPerg,.T.)
	@ 70,128 BmpButton Type 01 Action fnExecuta()
	@ 70,158 BmpButton Type 02 Action Close(oLeTxt)
	Activate Dialog oLeTxt Centered
Return

/*================================================
--  Função: Executar integração RM x Protheus   --
--          Contabilidade.                      --
==================================================*/
Static Function fnExecuta()
	Processa({|| ExecBlock("JOBMAR01",.F.,.F.,{"01","X"}) }, "Integração Contabilidade PROTHEUS")
Return

/*
========================================================================
== Programa  ³JOBPRMPT02  ºAutor  ³TOTVS NE         º Data ³ 17/09/14 ==
==--------------------------------------------------------------------==
== Descrição ³Rotina de integração RM x Protheus. (Contabilidade)     ==
==           ³                                                        ==
==--------------------------------------------------------------------==
== Uso       ³Financeiro                                              ==
==--------------------------------------------------------------------==
========================================================================*/
User Function JOBMAR01(_cEmp)
	Local cQuery      := ""
	Local nQtReg      := 0
	Local nQtLido     := 0
	Local nQtGrav     := 0
	Local nPer        := 0
	Local nSeq        := 0
	Local nVlDeb      := 0
	Local nVlCre      := 0
	Local aCampos     := {}
	Local dSistema    := dDataBase
	Local cMV_ATUSAL  := GetMv("MV_ATUSAL")
	Local cMV_CONTSB  := GetMv("MV_CONTSB")
	Local cMV_CONTBAT := GetMv("MV_CONTBAT")
	Local cMV_NUMLIN  := GetMv("MV_NUMLIN")
	Local bGrvCT2     := .T.
	Local cTexto	  := ""
	
	PutMv("MV_ATUSAL","N")
	PutMv("MV_CONTSB","S")
	PutMv("MV_CONTBAT","S")
	PutMv("MV_NUMLIN",99999)
	
	// --- Variaveis de Contabilização
	Private cLote        := "008890"
	Private cPadrao      := ""                 // Código de Lançamento Padrao criado para contabilização dos rateios da CTK
	Private lDigita      := .F.                // Mostra lancamentos contábeis. Se via schedule = .F.
	Private lContabiliza := .T.
	Private nTotal       := 0
	Private nLinha       := 0
	Private lCabecalho   := .T.
	//Private cEmpOri      := IIf(ValType(_cEmp)=="U",ParamIxb[1], _cEmp[1])  // Se via schedule - Empresa
	//Private cFilOri      := IIf(ValType(_cEmp)=="U",cFilAnt, _cEmp[2])      // Se via schedule - Filial"01"
	Private nHdlPrv
	Private cArquivo	
	
	cDiret	:= cGetFile('Arquivo TXT|*.txt','Todos os Drives',0,'C:\',.T.,GETF_LOCALHARD+GETF_NETWORKDRIVE,.F.) 
	nHandle := FT_FUse(cDiret)
	
	If nHandle == -1
		MsgAlert("Erro de abertura. Código: " + STR(FERROR()))
		Return
	EndIf
	
	aAdd(aCampos,{"LP"   ,"C",03,0})
	aAdd(aCampos,{"DTLAN","D",08,0})
	aAdd(aCampos,{"DEBIT","C",20,0})
	aAdd(aCampos,{"CREDI","C",20,0})
	aAdd(aCampos,{"CCD"  ,"C",09,0})
	aAdd(aCampos,{"CCC"  ,"C",09,0})
	aAdd(aCampos,{"ICD"  ,"C",09,0})
	aAdd(aCampos,{"ICC"  ,"C",09,0})
	aAdd(aCampos,{"VALOR","N",13,2})
	aAdd(aCampos,{"HIST" ,"C",200,0})
	
	cNomeArq := CriaTrab(aCampos)
	cChave   := ""
	cArqNtx  := CriaTrab(Nil,.f.)
	
	If Select("TRP") > 0
		TRP->(DbCloseArea())
	EndIf
	
	dbUseArea(.T.,,cNomeArq,"TRP",.F.,)
	//IndRegua("TRP",cArqNtx ,cChave ,,,"Organizando Arquivo.... ")
	//dbClearIndex()
	//dbSetIndex(cArqNtx  + OrdBagExt())
	
	ProcessMessages()
	
	nQtReg := FT_FLastRec()
	
	ProcRegua(nQtReg)
	
	While !FT_FEOF()
		nQtLido++		
		nPer := (nQtLido / nQtReg) * 100
		IncProc("Lendo o Registro: " + Alltrim(Str(nQtLido)) + " de: " + Alltrim(Str(nQtReg)) + " (" + Alltrim(Str(nPer,6,2)) + "%)") //-- Incremeta Termometro
		
		cTexto := FT_FReadLn()
		RecLock("TRP",.T.)
		Replace TRP->LP	   With SubStr(cTexto,1,3 )  
		Replace TRP->DTLAN With CToD(SubStr(cTexto,4,10))
		Replace TRP->DEBIT With SubStr(cTexto,14,20)
		Replace TRP->CREDI With SubStr(cTexto,34,20)
		Replace TRP->CCD   With SubStr(cTexto,54,9 )
		Replace TRP->CCC   With SubStr(cTexto,63,9 )
		Replace TRP->ICD   With SubStr(cTexto,72,9 )
		Replace TRP->ICC   With SubStr(cTexto,81,9 )
		Replace TRP->VALOR With Val(StrZero(Val(SubStr(cTexto,90,13)),13)+"."+StrZero(Val(SubStr(cTexto,103,2)),2))
		Replace TRP->HIST  With SubStr(cTexto,105,200)
		MsUnlock()
		FT_FSKIP()
	EndDo
	
	If TRP->(Eof())
		bGrvCT2 := .F.
	EndIf
	
	
	
	dbSelectArea("TRP")
	TRP->(dbGoTop())
	
	dLancto := TRP->DTLAN
	
	ProcRegua(nQtReg)
	
	nPer := 0
	While !TRP->(Eof())
		nQtGrav++		
		nPer := (nQtGrav / nQtReg) * 100
		IncProc("Gravando o Registro: " + Alltrim(Str(nQtGrav)) + " de: " + Alltrim(Str(nQtReg)) + " (" + Alltrim(Str(nPer,6,2)) + "%)") //-- Incremeta Termometro
		
		ProcessMessages()
		
		If dLancto <> TRP->DTLAN
			fnGrvCT2()
			dLancto := TRP->DTLAN
		EndIf
		
		// ---- Pegar o lançamento padrão
		cPadrao := TRP->LP
		
		LoteCont("GPE")
		
		If lContabiliza		
			If lCabecalho
				nHdlPrv := HeadProva(cLote,"MHFIN",Substr(cUsuario,7,6),@cArquivo)
				lCabecalho := .F.
			EndIf
			nTotal += DetProva(nHdlPrv,cPadrao,"MHFIN",cLote,nLinha)
			nLinha++
		EndIf
		
		TRP->(dbSkip())
	EndDo
	
	If bGrvCT2
		Processa({|| fnGrvCT2()}, "Gravando dados contabil.")
		FT_FUSE()
	EndIf
	
	TRP->(dbCloseArea())
	Close(oLeTxt)
	
	// ---- Retornar os parametros
	PutMv("MV_ATUSAL",cMV_ATUSAL)
	PutMv("MV_CONTSB",cMV_CONTSB)
	PutMv("MV_CONTBAT",cMV_CONTBAT)
	PutMv("MV_NUMLIN",cMV_NUMLIN)
	
	// ---- Retornar data sistema
	//  dDataBase := dSistema
Return

/*-----------------------------------------------
--  Função: Gravando dados na Contabilidade.   --
--                                             --
-------------------------------------------------*/
Static Function fnGrvCT2()
	RodaProva(nHdlPrv,nTotal)
	cA100Incl(cArquivo,nHdlPrv,3,cLote,lDigita,.F.,.T.,dLancto)
	//  cA100Incl(cArquivo,nHdlPrv,3,cLote,lDigita,.F.)
Return

/*-----------------------------
--  Função: Criar Pergunta   --
--                           --
-------------------------------*/
Static Function CriaPerg(cPerg)
	Local _sAlias := Alias()
	Local aRegs   := {}
	Local i
	Local j
	
	dbSelectArea("SX1")
	dbSetOrder(1)
	cPerg := PADR(cPerg,10)
	
	// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
	aAdd(aRegs,{cPerg,"01","Coligada    ?","","","mv_ch1","N",01,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"02","Numero Lote ?","","","mv_ch2","N",06,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"03","Operação    ?","","","mv_ch3","N",01,0,0,"C","","mv_par03","Contab. Lote","Contab. Lote","Contab. Lote","","",;
		"Excluir Lote","Excluir Lote","Excluir Lote","","","","","","","","","","","","","","","","","","","","",""})
	
	For i:=1 to Len(aRegs)
		If !dbSeek(cPerg+aRegs[i,2])
			RecLock("SX1",.T.)
			For j:=1 to Len(aRegs[i])
				If j <= Len(aRegs[i])
					FieldPut(j,aRegs[i,j])
				EndIf
			Next
			MsUnlock()
		EndIf
	Next
	
	dbSelectArea(_sAlias)
Return
