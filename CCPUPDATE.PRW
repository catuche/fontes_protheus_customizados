#include "protheus.ch"
#define CCP_LAST_UPDATED "10/03/2008-001"

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ UPDCCP   ³ Autor ³ ARNALDO RAYMUNDO JR.  ³ Data ³ 10/03/08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Executa as funcoes de atualizacao para custos em partes    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CCPUPDATE  - PARA EXECUCAO PELA TELA DE ABERTURA DO REMOTE ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ GENERICO - CUSTO EM PARTES                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

USER Function UPDCCP()
	CCPUPDATE() 
Return

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ CCPUPDATE³ Autor ³ ARNALDO RAYMUNDO JR.  ³ Data ³ 18/02/08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Executa as funcoes de atualizacao para interface PC-FACTORY³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CCPUPDATE  - PARA EXECUCAO PELA TELA DE ABERTURA DO REMOTE ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ INTEGRACAO PROTHEUS - PC_FACTORY                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

STATIC FUNCTION CCPUPDATE()

cArqEmp := "SigaMat.Emp"
nModulo		:= 44
__cInterNet := Nil

PRIVATE cMens := "Atencao !" + CRLF +; // //"Atencao !"
					"Esta rotina ira atualizar os dicionarios de dados" + CRLF +;
					"para a utilizacao do custo em Partes no Ambiente Protheus." + CRLF +;
					"Nao devem existir usuarios utilizando o sistema durante a atualizacao!"

PRIVATE cMessage
PRIVATE aArqUpd	 := {}
PRIVATE aREOPEN	 := {}
PRIVATE __lPyme  := .F.
PRIVATE __CUSERID:= "000000"

#IFDEF TOP
	TCInternal(5,'*OFF') //-- Desliga Refresh no Lock do Top
#ENDIF

Set Dele On

CCPOpenSm0()
DbGoTop()

lHistorico 	:= MsgYesNo("Deseja efetuar a atualizacao do Dicionario de Dados v." + CCP_LAST_UPDATED + "? "+ CRLF + cMens, "Atenção")
lEmpenho	:= .F.
lAtuMnu		:= .F.

DEFINE WINDOW oMainWnd FROM 0,0 TO 01,1 TITLE "Atualizacao do Dicionario"

ACTIVATE WINDOW oMainWnd ICONIZED;
ON INIT If(lHistorico,(Processa({|lEnd| CCPProc(@lEnd)},"Processando","Aguarde , processando preparacao dos arquivos",.F.) , oMainWnd:End()),oMainWnd:End())


Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ CCPPROC  ³ Autor ³ --------------------- ³ Data ³ 23/05/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao de processamento da gravacao dos arquivos           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ ATUALIZACAO SIGACCP                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CCPProc(lEnd)
Local cTexto   	:= ''
Local cFile    	:=""
Local cMask    	:= "Arquivos Texto (*.TXT) |*.txt|"
Local cCodigo  	:= "DM"
Local nRecno   	:= 0
Local nX       	:=0
Local nRecAtu   := 0
Local aAreaSM0	:= {}

Private MvParBox01 := 0
Private MvParBox02 := 0
Private MvParBox03 := 0
Private MvParBox04 := 0

Private aCCPParBox := {}
PUBLIC cFilAnt
PUBLIC CEMPANT
PUBLIC CUSERNAME := "Administrador"
IF !CCPPARBOX()
	RETURN .F.
ENDIF

ProcRegua(1)
IncProc("Verificando integridade dos dicionarios....")

OpenSm0Excl()
dbSelectArea("SM0")
dbGotop()

//While SM0->(!Eof())
	
	nRecAtu := SM0->(Recno())
	aAreaSM0 := SM0->(GetArea())
	
	RpcSetType(3)
	RpcSetEnv(SM0->M0_CODIGO, SM0->M0_CODFIL)
	RestArea(aAreaSM0)
	
	SM0->(dbGoto(nRecAtu))
	RpcClearEnv()
	OpenSm0Excl()
	
	SM0->(dbGoto(nRecAtu))
	SM0->(dbSkip())
	
	If SM0->(! Eof())
		nRecno := SM0->(Recno())
		SM0->(DbGoTo(nRecno))
	EndIf
	
//EndDo

dbSelectArea("SM0")
dbGotop()
//While SM0->(!Eof())
	
	aArqUpd := {}
	nRecAtu := SM0->(Recno())
	aAreaSM0 := SM0->(GetArea())
	
	RpcSetType(3)
	RpcSetEnv(SM0->M0_CODIGO, SM0->M0_CODFIL)
	
	cFilant := SM0->M0_CODFIL
	CEMPANT := SM0->M0_CODIGO
	RestArea(aAreaSM0)
	dbSelectArea("SM0")
	dbGoto(nRecAtu)
	
	cTexto += Replicate("-",128)+CRLF
	cTexto += "Empresa : "+SM0->M0_CODIGO+" Filial : "+SM0->M0_CODFIL+"-"+SM0->M0_NOME+CRLF
	ProcRegua(8)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Atualiza as perguntes de relatorios.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	IncProc("Analisando Perguntas de Relatorios...")
	cTexto += CCPAtuSX1()
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Atualiza o dicionario de arquivos.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	IncProc("Analisando Dicionario de Arquivos...")
	cTexto += CCPAtuSX2()
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Atualiza o dicionario de dados.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	IncProc("Analisando Dicionario de Dados...")
	cTexto += CCPAtuSX3()
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Atualiza os parametros.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	IncProc("Analisando Tabelas...")
	cTexto += CCPAtuSX5()
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Atualiza os parametros.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	IncProc("Analisando Parametros...")
	cTexto += CCPAtuSX6()
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Atualiza os gatilhos.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	IncProc("Analisando Gatilhos...")
	cTexto += CCPAtuSX7()
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Atualiza os folder's de cadastro.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	IncProc("Analisando Folder de Cadastro...")
	cTexto += CCPAtuSXA()
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Atualiza as consultas padroes.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	IncProc("Analisando Consultas Padroes...")
	cTexto += CCPAtuSXB()


	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Atualiza os folder's de cadastro.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	IncProc("Analisando Configuração de Schedule...")
	cTexto += CCPAtuSXD()

	__SetX31Mode(.F.)
	For nX := 1 To Len(aArqUpd)
		IncProc("Atualizando estruturas. Aguarde... ["+aArqUpd[nx]+"]")
		If Select(aArqUpd[nx])>0
			dbSelecTArea(aArqUpd[nx])
			dbCloseArea()
		EndIf
		X31UpdTable(aArqUpd[nx])
		If __GetX31Error()
			Alert(__GetX31Trace())
			Aviso("Atencao!",;
			"Ocorreu um erro desconhecido durante a atualizacao da tabela : "+;
			 aArqUpd[nx] +". Verifique a integridade do dicionario e da tabela.",;
			 {"Continuar"},2)
			cTexto += "Ocorreu um erro desconhecido durante a atualizacao da estrutura da tabela : "+aArqUpd[nx] +CRLF 
		EndIf
	Next nX
		
	dbSelectArea("SM0")
	dbGoto(nRecAtu)
	RpcClearEnv()
	OpenSm0Excl()
	
	dbSelectArea("SM0")
	dbGoto(nRecAtu)
	
	SM0->(dbSkip())
	
	If SM0->(! Eof())
		nRecno := SM0->(Recno())
		SM0->(DbGoTo(nRecno))
	EndIf
	
//EndDo

dbSelectArea("SM0")
dbGotop()
//While SM0->(!Eof())

	aArqUpd := {}
	nRecAtu := SM0->(Recno())
	aAreaSM0 := SM0->(GetArea())
	
	RpcSetType(3)
	RpcSetEnv(SM0->M0_CODIGO, SM0->M0_CODFIL)
	
	RestArea(aAreaSM0)
	dbSelectArea("SM0")
	dbGoto(nRecAtu)
	
	cTexto += Replicate("-",128)+CRLF
	cTexto += "Empresa : "+SM0->M0_CODIGO+" Filial : "+SM0->M0_CODFIL+"-"+SM0->M0_NOME+CRLF
	ProcRegua(8)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Atualiza os indices.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	ProcRegua(2)
	IncProc("Analisando Indices...")
	cTexto += CCPAtuSIX()

	__SetX31Mode(.F.)
	For nX := 1 To Len(aArqUpd)
		IncProc("Atualizando estruturas. Aguarde... ["+aArqUpd[nx]+"]")
		If Select(aArqUpd[nx])>0
			dbSelecTArea(aArqUpd[nx])
			dbCloseArea()
		EndIf
		X31UpdTable(aArqUpd[nx])
		If __GetX31Error()
			Alert(__GetX31Trace())
			Aviso("Atencao!",;
			"Ocorreu um erro desconhecido durante a atualizacao da tabela : "+;
			 aArqUpd[nx] +". Verifique a integridade do dicionario e da tabela.",;
			 {"Continuar"},2)
			cTexto += "Ocorreu um erro desconhecido durante a atualizacao da estrutura da tabela : "+aArqUpd[nx] +CRLF 
		EndIf
	Next nX
	
	dbSelectArea("SM0")
	dbGoto(nRecAtu)
	RpcClearEnv()
	OpenSm0Excl()
	
	dbSelectArea("SM0")
	dbGoto(nRecAtu)
	
	SM0->(dbSkip())
	
	If SM0->(! Eof())
		nRecno := SM0->(Recno())
		SM0->(DbGoTo(nRecno))
	EndIf

//EndDo

dbSelectArea("SM0")
dbGotop()
RpcSetEnv(SM0->M0_CODIGO, SM0->M0_CODFIL,,,,, { "AE1" })

cTexto := "Log da atualizacao "+CRLF+cTexto
__cFileLog := MemoWrite(Criatrab(,.f.)+".LOG",cTexto)
DEFINE FONT oFont NAME "Mono AS" SIZE 5,12   //6,15
DEFINE MSDIALOG oDlg TITLE "Atualizacao concluida." From 3,0 to 340,417 PIXEL
@ 5,5 GET oMemo  VAR cTexto MEMO SIZE 200,145 OF oDlg PIXEL
oMemo:bRClicked := {||AllwaysTrue()}
oMemo:oFont:=oFont

DEFINE SBUTTON  FROM 153,175 TYPE 1 ACTION oDlg:End() ENABLE OF oDlg PIXEL
DEFINE SBUTTON  FROM 153,145 TYPE 13 ACTION (cFile:=cGetFile(cMask,""),If(cFile="",.t.,MemoWrite(cFile,cTexto))) ENABLE OF oDlg PIXEL


ACTIVATE MSDIALOG oDlg CENTER


Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³CCPAtuSIX ³ Autor ³ --------------------- ³ Data ³ 23/05/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao de processamento da gravacao do SIX                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ ATUALIZACAO SIGACCP                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CCPAtuSIX()
//INDICE ORDEM CHAVE DESCRICAO DESCSPA DESCENG PROPRI F3 NICKNAME
Local cTexto := ''
Local lSIX   := .F.
Local lNew   := .F.
Local aSIX   := {}
Local aEstrut:= {}
Local i      := 0
Local j      := 0
Local cAlias := ''

If (cPaisLoc == "BRA")
	aEstrut:= {"INDICE","ORDEM","CHAVE","DESCRICAO","DESCSPA","DESCENG","PROPRI","F3","NICKNAME"}
Else
	aEstrut:= {"INDICE","ORDEM","CHAVE","DESCRICAO","DESCSPA","DESCENG","PROPRI","F3","NICKNAME"}
EndIf

DbSelectArea("SX3")
DbSetOrder(2)

/*
IF SX3->(DbSeek("C2_OPPCF"))
	Aadd(aSIX,{	"","","","","","","","",""})
ENDIF
*/

DbSelectArea("SX3")
DbSetOrder(1)

DbSelectArea("SIX")
ProcRegua(Len(aSIX))

dbSelectArea("SIX")
dbSetOrder(1)

For i:= 1 To Len(aSIX)
	If !Empty(aSIX[i,1])
		If !MsSeek(aSIX[i,1]+aSIX[i,2])
			lNew:= .T.
		Else
			lNew:= .F.
		EndIf
		
		If lNew .Or. !(UPPER(AllTrim(CHAVE))==UPPER(Alltrim(aSIX[i,3])))
			aAdd(aArqUpd,aSIX[i,1])
			lSIX := .T.

			If !(aSIX[i,1]$cAlias)
				cAlias += aSIX[i,1]+"/"
			EndIf
			
			RecLock("SIX",lNew)

			For j:=1 To Len(aSIX[i])
				If FieldPos(aEstrut[j])>0
					FieldPut(FieldPos(aEstrut[j]),aSIX[i,j])
				EndIf
			Next j
			dbCommit()
			MsUnLock()
		EndIf

		IncProc("Atualizando Indices...")
	EndIf
Next i

IncProc("Apagando Indices atualizados...")

cTabOk	:= ""
For i := 1 To Len(aArqUpd)
	
	If !(aArqUpd[i] $ cTabOk ) .And. SX2->( MsSeek( aArqUpd[i] ) )
		cTabOk	+=	aArqUpd[i]+"/"
		cArquivo := AllTrim(SX2->X2_PATH) + AllTrim(SX2->X2_ARQUIVO)
		// Abrindo as tabelas em modo Exclusivo
		If Select( aArqUpd[i]) > 0
			(aArqUpd[i])->( DbCloseArea() )
		EndIf
		ChkFile( aArqUpd[i],.T.,aArqUpd[i] )
		dbSelectArea(aArqUpd[i])
		X31IndErase(aArqUpd[i], cArquivo, __cRdd)
		DbCloseArea()
	EndIf

Next i

If lSIX
	cTexto += "Indices atualizados  : "+cAlias+CRLF
EndIf

Return cTexto

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³CCPAtuSX1 ³ Autor ³ --------------------- ³ Data ³ 23/05/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao de processamento da gravacao dos SX1                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ ATUALIZACAO SIGACCP                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CCPAtuSX1()
//				X1_GRUPO   X1_ORDEM   X1_PERGUNT X1_PERSPA X1_PERENG  X1_VARIAVL X1_TIPO    X1_TAMANHO X1_DECIMAL X1_PRESEL
//				X1_GSC     X1_VALID   X1_VAR01   X1_DEF01  X1_DEFSPA1 X1_DEFENG1 X1_CNT01   X1_VAR02   X1_DEF02
//				X1_DEFSPA2 X1_DEFENG2 X1_CNT02   X1_VAR03  X1_DEF03   X1_DEFSPA3 X1_DEFENG3 X1_CNT03   X1_VAR04   X1_DEF04
// 				X1_DEFSPA4 X1_DEFENG4 X1_CNT04   X1_VAR05  X1_DEF05   X1_DEFSPA5 X1_DEFENG5 X1_CNT05   X1_F3      X1_GRPSXG X1_PYME
Local aSX1   := {}
Local aEstrut:= {}
Local i      := 0
Local j      := 0
Local lSX1	 := .F.
Local cTexto := ''

If (cPaisLoc == "BRA")
	aEstrut:= { "X1_GRUPO"  ,"X1_ORDEM"  ,"X1_PERGUNT","X1_PERSPA","X1_PERENG" ,"X1_VARIAVL","X1_TIPO"   ,"X1_TAMANHO","X1_DECIMAL","X1_PRESEL",;
	"X1_GSC"    ,"X1_VALID"  ,"X1_VAR01"  ,"X1_DEF01" ,"X1_DEFSPA1","X1_DEFENG1","X1_CNT01"  ,"X1_VAR02"  ,"X1_DEF02"  ,;
	"X1_DEFSPA2","X1_DEFENG2","X1_CNT02"  ,"X1_VAR03" ,"X1_DEF03"  ,"X1_DEFSPA3","X1_DEFENG3","X1_CNT03"  ,"X1_VAR04"  ,"X1_DEF04",;
	"X1_DEFSPA4","X1_DEFENG4","X1_CNT04"  ,"X1_VAR05" ,"X1_DEF05"  ,"X1_DEFSPA5","X1_DEFENG5","X1_CNT05"  ,"X1_F3"     ,"X1_GRPSXG","X1_PYME"}
Else
	aEstrut:= { "X1_GRUPO"  ,"X1_ORDEM"  ,"X1_PERGUNT","X1_PERSPA","X1_PERENG" ,"X1_VARIAVL","X1_TIPO"   ,"X1_TAMANHO","X1_DECIMAL","X1_PRESEL",;
	"X1_GSC"    ,"X1_VALID"  ,"X1_VAR01"  ,"X1_DEF01" ,"X1_DEFSPA1","X1_DEFENG1","X1_CNT01"  ,"X1_VAR02"  ,"X1_DEF02"  ,;
	"X1_DEFSPA2","X1_DEFENG2","X1_CNT02"  ,"X1_VAR03" ,"X1_DEF03"  ,"X1_DEFSPA3","X1_DEFENG3","X1_CNT03"  ,"X1_VAR04"  ,"X1_DEF04",;
	"X1_DEFSPA4","X1_DEFENG4","X1_CNT04"  ,"X1_VAR05" ,"X1_DEF05"  ,"X1_DEFSPA5","X1_DEFENG5","X1_CNT05"  ,"X1_F3"     ,"X1_GRPSXG","X1_PYME"}
EndIf

//Exemplo:
// AADD(aSX1,{})

ProcRegua(Len(aSX1))

dbSelectArea("SX1")
dbSetOrder(1)
For i:= 1 To Len(aSX1)
	If !Empty(aSX1[i][1])
		If !MsSeek(aSX1[i,1]+aSX1[i,2])
			lSX1 := .T.
			RecLock("SX1",.T.)
			
			For j:=1 To Len(aSX1[i])
				If !Empty(FieldName(FieldPos(aEstrut[j])))
					FieldPut(FieldPos(aEstrut[j]),aSX1[i,j])
				EndIf
			Next j
			
			dbCommit()
			MsUnLock()
			IncProc("Atualizando Perguntas de Relatorios...")
		EndIf
	EndIf
Next i

If lSX1
	cTexto += "Incluidas novas perguntas no SX1."+CRLF
EndIf

Return cTexto

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³CCPAtuSX2 ³ Autor ³ --------------------- ³ Data ³ 23/05/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao de processamento da gravacao do SX2                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ ATUALIZACAO SIGACCP                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CCPAtuSX2()
//X2_CHAVE X2_PATH X2_ARQUIVOC,X2_NOME,X2_NOMESPAC X2_NOMEENGC X2_DELET X2_MODO X2_TTS X2_ROTINA
Local aSX2   := {}
Local aEstrut:= {}
Local i      := 0
Local j      := 0
Local cTexto := ''
Local lSX2	 := .F.
Local cAlias := ''
Local cPath
Local cNome

If (cPaisLoc == "BRA")
	aEstrut:= {"X2_CHAVE","X2_PATH","X2_ARQUIVO","X2_NOME","X2_NOMESPAC","X2_NOMEENGC","X2_DELET","X2_MODO","X2_TTS","X2_ROTINA"}
Else
	aEstrut:= {"X2_CHAVE","X2_PATH","X2_ARQUIVO","X2_NOME","X2_NOMESPA","X2_NOMEENG","X2_DELET","X2_MODO","X2_TTS","X2_ROTINA"}
EndIf

/*
AADD(aSX2, {"","","","","","",0,"","",""})
*/

ProcRegua(Len(aSX2))

dbSelectArea("SX2")
dbSetOrder(1)
MsSeek("AK1")
cPath := SX2->X2_PATH
cNome := Substr(SX2->X2_ARQUIVO,4,5)
cModo	:= SX2->X2_MODO

For i:= 1 To Len(aSX2)
	If !Empty(aSX2[i][1])
		If !MsSeek(aSX2[i,1])
			lSX2	:= .T.
			If !(aSX2[i,1]$cAlias)
				cAlias += aSX2[i,1]+"/"
			EndIf
			RecLock("SX2",.T.)
			For j:=1 To Len(aSX2[i])
				If FieldPos(aEstrut[j]) > 0
					FieldPut(FieldPos(aEstrut[j]),aSX2[i,j])
				EndIf
			Next j
			SX2->X2_PATH    := cPath
			SX2->X2_ARQUIVO := aSX2[i,1]+cNome
			SX2->X2_MODO    := cModo
			dbCommit()
			MsUnLock()
			IncProc("Atualizando Dicionario de Arquivos...")
		EndIf
	EndIf
Next i

If lSX2
	cTexto += "Incluidas novas perguntas no SX1."+cAlias+CRLF
EndIf

Return cTexto

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³CCPAtuSX3 ³ Autor ³ --------------------- ³ Data ³ 23/05/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao de processamento da gravacao do SX3                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ ATUALIZACAO SIGACCP                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CCPAtuSX3()
//	X3_ARQUIVO X3_ORDEM   X3_CAMPO   X3_TIPO    X3_TAMANHO X3_DECIMAL X3_TITULO  X3_TITSPA  X3_TITENG
//  X3_DESCRIC X3_DESCSPA X3_DESCENG X3_PICTURE X3_VALID   X3_USADO   X3_RELACAO X3_F3      X3_NIVEL
//  X3_RESERV  X3_CHECK   X3_TRIGGER X3_PROPRI  X3_BROWSE  X3_VISUAL  X3_CONTEXT X3_OBRIGAT X3_VLDUSER
//  X3_CBOX    X3_CBOXSPA X3_CBOXENG X3_PICTVAR X3_WHEN    X3_INIBRW  X3_GRPSXG  X3_FOLDER

Local aSX3   	:= {}
Local aEstrut	:= {}
Local i      	:= 0
Local j      	:= 0
Local lSX3	 	:= .F.
Local cTexto 	:= ''
Local cAlias 	:= ''
Local nX, nY
Local cSeqAtu	:= ""

aEstrut:= {	"X3_ARQUIVO","X3_ORDEM"  ,;
			"X3_CAMPO"  ,;
			"X3_TIPO"   ,"X3_TAMANHO","X3_DECIMAL",;
			"X3_TITULO" ,"X3_TITSPA" ,"X3_TITENG" ,;
			"X3_DESCRIC",;
			"X3_DESCSPA",;
			"X3_DESCENG",;
			"X3_PICTURE","X3_VALID"  ,;
			"X3_USADO"  ,;
			"X3_RELACAO","X3_F3","X3_NIVEL"  ,"X3_RESERV" ,"X3_CHECK"  ,"X3_TRIGGER",;
			"X3_PROPRI" ,"X3_BROWSE" ,"X3_VISUAL" ,"X3_CONTEXT","X3_OBRIGAT",;
			"X3_VLDUSER",;
			"X3_CBOX"   ,;
			"X3_CBOXSPA",;
			"X3_CBOXENG",;
			"X3_PICTVAR","X3_WHEN"   ,"X3_INIBRW" ,"X3_GRPSXG" ,"X3_FOLDER","X3_PYME"}

For nX := 1 to MvParBox01

	For nY := 1 to MvParBox02
	
		AADD(aSX3,	{"SB2","",;
					"B2_CP"+STRZERO(nX,2)+STRZERO(nY,2),;
					"N",MvParBox03,MvParBox04,;
					aCCPParBox[nX,1],aCCPParBox[nX,1],aCCPParBox[nX,1],;
					aCCPParBox[nX,2],aCCPParBox[nX,2],aCCPParBox[nX,2],;
					"@E 99,999,999,999.99","",;
					"€€€€€€€€€€€€€€€",;//X3_USADO
					"","",9,"şA","","",;
					"L","N","V","R","N",;
					"",;  //X3_VLDUSER
					"",;  //X3_CBOX
					"",;  //X3_CBOXSPA
					"",;  //X3_CBOXENG
					"","","","","","S"})

		AADD(aSX3,	{"SB2","",;
					"B2_CPF"+STRZERO(nX,2)+STRZERO(nY,2),;
					"N",MvParBox03,MvParBox04,;
					aCCPParBox[nX,1],aCCPParBox[nX,1],aCCPParBox[nX,1],;
					aCCPParBox[nX,2],aCCPParBox[nX,2],aCCPParBox[nX,2],;
					"@E 99,999,999,999.99","",;
					"€€€€€€€€€€€€€€€",;//X3_USADO
					"","",9,"şA","","",;
					"L","N","V","R","N",;
					"",;  //X3_VLDUSER
					"",;  //X3_CBOX
					"",;  //X3_CBOXSPA
					"",;  //X3_CBOXENG
					"","","","","","S"})
					
		AADD(aSX3,	{"SB6","",;
					"B6_CP"+STRZERO(nX,2)+STRZERO(nY,2),;
					"N",MvParBox03,MvParBox04,;
					aCCPParBox[nX,1],aCCPParBox[nX,1],aCCPParBox[nX,1],;
					aCCPParBox[nX,2],aCCPParBox[nX,2],aCCPParBox[nX,2],;
					"@E 99,999,999,999.99","",;
					"€€€€€€€€€€€€€€€",;//X3_USADO
					"","",9,"şA","","",;
					"L","N","V","R","N",;
					"",;  //X3_VLDUSER
					"",;  //X3_CBOX
					"",;  //X3_CBOXSPA
					"",;  //X3_CBOXENG
					"","","","","","S"})
					
		AADD(aSX3,	{"SB9","",;
					"B9_CP"+STRZERO(nX,2)+STRZERO(nY,2),;
					"N",MvParBox03,MvParBox04,;
					aCCPParBox[nX,1],aCCPParBox[nX,1],aCCPParBox[nX,1],;
					aCCPParBox[nX,2],aCCPParBox[nX,2],aCCPParBox[nX,2],;
					"@E 99,999,999,999.99","",;
					"€€€€€€€€€€€€€€€",;//X3_USADO
					"","",9,"şA","","",;
					"L","N","V","R","N",;
					"",;  //X3_VLDUSER
					"",;  //X3_CBOX
					"",;  //X3_CBOXSPA
					"",;  //X3_CBOXENG
					"","","","","","S"})
					
		AADD(aSX3,	{"SC2","",;
					"C2_CPF"+STRZERO(nX,2)+STRZERO(nY,2),;
					"N",MvParBox03,MvParBox04,;
					aCCPParBox[nX,1],aCCPParBox[nX,1],aCCPParBox[nX,1],;
					aCCPParBox[nX,2],aCCPParBox[nX,2],aCCPParBox[nX,2],;
					"@E 99,999,999,999.99","",;
					"€€€€€€€€€€€€€€€",;//X3_USADO
					"","",9,"şA","","",;
					"L","N","V","R","N",;
					"",;  //X3_VLDUSER
					"",;  //X3_CBOX
					"",;  //X3_CBOXSPA
					"",;  //X3_CBOXENG
					"","","","","","S"})
					
		AADD(aSX3,	{"SC2","",;
					"C2_CPI"+STRZERO(nX,2)+STRZERO(nY,2),;
					"N",MvParBox03,MvParBox04,;
					aCCPParBox[nX,1],aCCPParBox[nX,1],aCCPParBox[nX,1],;
					aCCPParBox[nX,2],aCCPParBox[nX,2],aCCPParBox[nX,2],;
					"@E 99,999,999,999.99","",;
					"€€€€€€€€€€€€€€€",;//X3_USADO
					"","",9,"şA","","",;
					"L","N","V","R","N",;
					"",;  //X3_VLDUSER
					"",;  //X3_CBOX
					"",;  //X3_CBOXSPA
					"",;  //X3_CBOXENG
					"","","","","","S"})
					
		AADD(aSX3,	{"SC2","",;
					"C2_APF"+STRZERO(nX,2)+STRZERO(nY,2),;
					"N",MvParBox03,MvParBox04,;
					aCCPParBox[nX,1],aCCPParBox[nX,1],aCCPParBox[nX,1],;
					aCCPParBox[nX,2],aCCPParBox[nX,2],aCCPParBox[nX,2],;
					"@E 99,999,999,999.99","",;
					"€€€€€€€€€€€€€€€",;//X3_USADO
					"","",9,"şA","","",;
					"L","N","V","R","N",;
					"",;  //X3_VLDUSER
					"",;  //X3_CBOX
					"",;  //X3_CBOXSPA
					"",;  //X3_CBOXENG
					"","","","","","S"})
					
		AADD(aSX3,	{"SC2","",;
					"C2_API"+STRZERO(nX,2)+STRZERO(nY,2),;
					"N",MvParBox03,MvParBox04,;
					aCCPParBox[nX,1],aCCPParBox[nX,1],aCCPParBox[nX,1],;
					aCCPParBox[nX,2],aCCPParBox[nX,2],aCCPParBox[nX,2],;
					"@E 99,999,999,999.99","",;
					"€€€€€€€€€€€€€€€",;//X3_USADO
					"","",9,"şA","","",;
					"L","N","V","R","N",;
					"",;  //X3_VLDUSER
					"",;  //X3_CBOX
					"",;  //X3_CBOXSPA
					"",;  //X3_CBOXENG
					"","","","","","S"})
					
		AADD(aSX3,	{"SD1","",;
					"D1_CP"+STRZERO(nX,2)+STRZERO(nY,2),;
					"N",MvParBox03,MvParBox04,;
					aCCPParBox[nX,1],aCCPParBox[nX,1],aCCPParBox[nX,1],;
					aCCPParBox[nX,2],aCCPParBox[nX,2],aCCPParBox[nX,2],;
					"@E 99,999,999,999.99","",;
					"€€€€€€€€€€€€€€€",;//X3_USADO
					"","",9,"şA","","",;
					"L","N","V","R","N",;
					"",;  //X3_VLDUSER
					"",;  //X3_CBOX
					"",;  //X3_CBOXSPA
					"",;  //X3_CBOXENG
					"","","","","","S"})
					
		AADD(aSX3,	{"SD2","",;
					"D2_CP"+STRZERO(nX,2)+STRZERO(nY,2),;
					"N",MvParBox03,MvParBox04,;
					aCCPParBox[nX,1],aCCPParBox[nX,1],aCCPParBox[nX,1],;
					aCCPParBox[nX,2],aCCPParBox[nX,2],aCCPParBox[nX,2],;
					"@E 99,999,999,999.99","",;
					"€€€€€€€€€€€€€€€",;//X3_USADO
					"","",9,"şA","","",;
					"L","N","V","R","N",;
					"",;  //X3_VLDUSER
					"",;  //X3_CBOX
					"",;  //X3_CBOXSPA
					"",;  //X3_CBOXENG
					"","","","","","S"})
					
		AADD(aSX3,	{"SD3","",;
					"D3_CP"+STRZERO(nX,2)+STRZERO(nY,2),;
					"N",MvParBox03,MvParBox04,;
					aCCPParBox[nX,1],aCCPParBox[nX,1],aCCPParBox[nX,1],;
					aCCPParBox[nX,2],aCCPParBox[nX,2],aCCPParBox[nX,2],;
					"@E 99,999,999,999.99","",;
					"€€€€€€€€€€€€€€€",;//X3_USADO
					"","",9,"şA","","",;
					"L","N","V","R","N",;
					"",;  //X3_VLDUSER
					"",;  //X3_CBOX
					"",;  //X3_CBOXSPA
					"",;  //X3_CBOXENG
					"","","","","","S"})																																																		
	Next nY
	
Next nX

ProcRegua(Len(aSX3))

dbSelectArea("SX3")

For i:= 1 To Len(aSX3)
	If !Empty(aSX3[i][1])
		SX3->(dbSetOrder(2))
		If !MsSeek(aSX3[i,3])
			lSX3	  := .T.
			If !(aSX3[i,1]$cAlias)
				cAlias += aSX3[i,1]+"/"
				aAdd(aArqUpd,aSX3[i,1])
			EndIf
			//Busco ultima ocorrencia do alias
			SX3->(dbSetOrder(1))
			SX3->(DbSeek(aSX3[i][1]+"zz",.T.))
			SX3->(dbSkip(-1))
			cSeqAtu := RETASC(SX3->X3_ORDEM,3,.F.) 
			cSeqAtu := SOMA1(cSeqAtu)

			RecLock("SX3",.T.)
			For j:=1 To Len(aSX3[i])
				If j == 2	//Ordem
					FieldPut(FieldPos(aEstrut[j]),UPPER(RETASC(cSeqAtu,2,.T.)))				
				ElseIf FieldPos(aEstrut[j])>0
					FieldPut(FieldPos(aEstrut[j]),aSX3[i,j])
				EndIf
			Next j
			dbCommit()
			MsUnLock()
			
			IncProc("Atualizando Dicionario de Dados...")
		EndIf
	EndIf
Next i

If lSX3
	cTexto := "Tabelas atualizadas : "+cAlias+CRLF
EndIf

Return cTexto

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³CCPAtuSX5 ³ Autor ³ --------------------- ³ Data ³ 23/05/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao de processamento da gravacao do SX5                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ ATUALIZACAO SIGACCP                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CCPAtuSX5()
//  "X5_FILIAL","X5_TABELA","X5_CHAVE","X5_DESCRI","X5_DESCSPA","X5_DESCENG"

Local aSX5   := {}
Local aEstrut:= {}
Local i      := 0
Local j      := 0
Local lSX5	 := .F.
Local cTexto := ""	

If (cPaisLoc == "BRA")
	aEstrut:= { "X5_FILIAL","X5_TABELA","X5_CHAVE","X5_DESCRI","X5_DESCSPA","X5_DESCENG"}
Else
	aEstrut:= { "X5_FILIAL","X5_TABELA","X5_CHAVE","X5_DESCRI","X5_DESCSPA","X5_DESCENG"}
EndIf

/*
AADD(aSX5,{"","","","","",""})
*/

ProcRegua(Len(aSX5))

dbSelectArea("SX5")
dbSetOrder(1)
For i:= 1 To Len(aSX5)
	If !Empty(aSX5[i][2])
		If !MsSeek(aSX5[i,1]+aSX5[i,2]+aSX5[i,3])
    		
    		lSX5 := .T.
			RecLock("SX5",.T.)
			
			For j:=1 To Len(aSX5[i])
				If !Empty(FieldName(FieldPos(aEstrut[j])))
					FieldPut(FieldPos(aEstrut[j]),aSX5[i,j])
				EndIf
			Next j
			
			dbCommit()
			MsUnLock()
			IncProc("Atualizando Tabelas...")
		EndIf
	EndIf
Next i

If lSX5
	cTexto := "Arquivo de tabelas (SX5) atualizado."+CRLF
EndIf

Return cTexto

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³CCPAtuSX6 ³ Autor ³ --------------------- ³ Data ³ 23/05/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao de processamento da gravacao do SX6                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ ATUALIZACAO SIGACCP                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CCPAtuSX6()
//  X6_FIL   X6_VAR     X6_TIPO    X6_DESCRIC X6_DSCSPA  X6_DSCENG  X6_DESC1 X6_DSCSPA1 X6_DSCENG1
//  X6_DESC2 X6_DSCSPA2 X6_DSCENG2 X6_CONTEUD X6_CONTSPA X6_CONTENG X6_PROPRI

Local aSX6   := {}
Local aEstrut:= {}
Local i      := 0
Local j      := 0
Local lSX6	 := .F.
Local cTexto := ''
Local cAlias := ''

If (cPaisLoc == "BRA")
	aEstrut:= { "X6_FIL","X6_VAR","X6_TIPO","X6_DESCRIC","X6_DSCSPA","X6_DSCENG","X6_DESC1","X6_DSCSPA1","X6_DSCENG1",;
	"X6_DESC2","X6_DSCSPA2","X6_DSCENG2","X6_CONTEUD","X6_CONTSPA","X6_CONTENG","X6_PROPRI"}
Else
	aEstrut:= { "X6_FIL","X6_VAR","X6_TIPO","X6_DESCRIC","X6_DSCSPA","X6_DSCENG","X6_DESC1","X6_DSCSPA1","X6_DSCENG1",;
	"X6_DESC2","X6_DSCSPA2","X6_DSCENG2","X6_CONTEUD","X6_CONTSPA","X6_CONTENG","X6_PROPRI"}
EndIf

//EXEMPLO
/*
AADD(aSX6,{"","","","","","","","","","","","","","","","U"})
*/

ProcRegua(Len(aSX6))

dbSelectArea("SX6")
dbSetOrder(1)
For i:= 1 To Len(aSX6)
	If !Empty(aSX6[i][2])
		If !MsSeek(aSX6[i,1]+aSX6[i,2])
			lSX6	:= .T.
			If !(aSX6[i,2]$cAlias)
				cAlias += aSX6[i,2]+"/"
			EndIf
			RecLock("SX6",.T.)
			For j:=1 To Len(aSX6[i])
				If !Empty(FieldName(FieldPos(aEstrut[j])))
					FieldPut(FieldPos(aEstrut[j]),aSX6[i,j])
				EndIf
			Next j
			
			dbCommit()
			MsUnLock()
			IncProc("Atualizando Parametros...")
		EndIf
	EndIf
Next i

If lSX6
	cTexto := "Incluidos novos parametros. Verifique as suas configuracoes e funcionalidades : "+cAlias+CRLF
EndIf

Return cTexto

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³CCPAtuSX7 ³ Autor ³ --------------------  ³ Data ³ 23/05/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao de processamento da gravacao do SX7                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ ATUALIZACAO SIGACCP                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CCPAtuSX7()
//  X7_CAMPO X7_SEQUENC X7_REGRA X7_CDOMIN X7_TIPO X7_SEEK X7_ALIAS X7_ORDEM X7_CHAVE X7_PROPRI X7_CONDIC

Local aSX7   := {}
Local aEstrut:= {}
Local i      := 0
Local j      := 0
Local cTexto := ''
Local cAlias := ''
Local lSX7	 := .F.

If (cPaisLoc == "BRA")
	aEstrut:= {"X7_CAMPO","X7_SEQUENC","X7_REGRA","X7_CDOMIN","X7_TIPO","X7_SEEK","X7_ALIAS","X7_ORDEM","X7_CHAVE","X7_PROPRI","X7_CONDIC"}
Else
	aEstrut:= {"X7_CAMPO","X7_SEQUENC","X7_REGRA","X7_CDOMIN","X7_TIPO","X7_SEEK","X7_ALIAS","X7_ORDEM","X7_CHAVE","X7_PROPRI","X7_CONDIC"}
EndIf

//Exemplo
//Aadd(aSX7,{"AJ8_PROJPM","001","SPACE(LEN(M->AJ8_EDTPMS))","AJ8_EDTPMS","P","","",0,"","S",""})

ProcRegua(Len(aSX7))

dbSelectArea("SX7")
dbSetOrder(1)
For i:= 1 To Len(aSX7)
	If !Empty(aSX7[i][1])
		If !MsSeek(aSX7[i,1]+aSX7[i,2])
			lSX7 := .T.
			If !(aSX7[i,1]$cAlias)
				cAlias += aSX7[i,1]+"/"
			EndIf
			RecLock("SX7",.T.)
			
			For j:=1 To Len(aSX7[i])
				If !Empty(FieldName(FieldPos(aEstrut[j])))
					FieldPut(FieldPos(aEstrut[j]),aSX7[i,j])
				EndIf
			Next j
			
			dbCommit()
			MsUnLock()
			IncProc("Atualizando Gatilhos...")
		EndIf
	EndIf
Next i

If lSX7
	cTexto := "Gatilhos atualizados : "+cAlias+CRLF
EndIf

Return cTexto

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³CCPAtuSXA ³ Autor ³ --------------------  ³ Data ³ 23/05/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao de processamento da gravacao do SXA                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ ATUALIZACAO SIGACCP                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CCPAtuSXA()
//"XA_ALIAS","XA_ORDEM","XA_DESCRIC","XA_DESCSPA","XA_DESCENG","XA_PROPRI"

Local aSXA   := {}
Local aEstrut:= {}
Local i      := 0
Local j      := 0
Local aSX3	 := {}
Local nX	 := 0
Local lSXA	 := .F.
Local cAlias := ''
Local cTexto := ""

If (cPaisLoc == "BRA")
	aEstrut:= {"XA_ALIAS","XA_ORDEM","XA_DESCRIC","XA_DESCSPA","XA_DESCENG","XA_PROPRI"}
Else
	aEstrut:= {"XA_ALIAS","XA_ORDEM","XA_DESCRIC","XA_DESCSPA","XA_DESCENG","XA_PROPRI"}
EndIf

/*EXEMPLO PARA ALTERAR PASTAS
aSXA:= 	{	{"AF1","3","Codigo Estruturado","Codigo Estruturado","Structured Number","S"},;
{"AF8","5","Codigo Estruturado","Codigo Estruturado","Structured Number","S"},;
{"AFF","2","Contratos","Contratos","Contratos","S"}	}
*/

ProcRegua(Len(aSXA))

dbSelectArea("SXA")
dbSetOrder(1)
For i:= 1 To Len(aSXA)
	If !Empty(aSXA[i][1])
		If !MsSeek(aSXA[i,1]+aSXA[i,2])
			lSXA := .T.
			
			If !(aSXA[i,1]$cAlias)
				cAlias += aSX7[i,1]+"/"
			EndIf
			
			RecLock("SXA",.T.)
			For j:=1 To Len(aSXA[i])
				If !Empty(FieldName(FieldPos(aEstrut[j])))
					FieldPut(FieldPos(aEstrut[j]),aSXA[i,j])
				EndIf
			Next j
			
			dbCommit()
			MsUnLock()
			IncProc("Atualizando Folder de Cadastro...")
		EndIf
	EndIf
Next i

aSX3 := {}

dbSelectArea("SX3")
dbSetOrder(2)
For nx := 1 to Len(aSX3)
	If MsSeek(aSX3[nx][1])
		RecLock("SX3",.F.)
		SX3->X3_FOLDER := aSX3[nx][2]
		MsUnlock()
	EndIf
Next

If lSXA
	cTexto := "Atualizado arquivos de folders (SXA)."+cAlias+CRLF
EndIf

Return cTexto

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³CCPAtuSXB ³ Autor ³ --------------------- ³ Data ³ 23/05/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao de processamento da gravacao do SXB                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ ATUALIZACAO SIGACCP                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CCPAtuSXB()
//  XB_ALIAS XB_TIPO XB_SEQ XB_COLUNA XB_DESCRI XB_DESCSPA XB_DESCENG XB_CONTEM

Local aSXB   := {}
Local aAjSXB := {}
Local aEstrut:= {}
Local i      := 0
Local j      := 0
Local cTexto := ''
Local cAlias := ''
Local lSXB   := .F.

If (cPaisLoc == "BRA")
	aEstrut:= {"XB_ALIAS","XB_TIPO","XB_SEQ","XB_COLUNA","XB_DESCRI","XB_DESCSPA","XB_DESCENG","XB_CONTEM"}
Else
	aEstrut:= {"XB_ALIAS","XB_TIPO","XB_SEQ","XB_COLUNA","XB_DESCRI","XB_DESCSPA","XB_DESCENG","XB_CONTEM"}
EndIf

/*
Para ajustar somente um campo
aAdd(aAjSXB, {"AL1","4","01","03",{"XB_CONTEM", "AL1_DESCRI"}})
*/

ProcRegua(Len(aSXB))

dbSelectArea("SXB")
dbSetOrder(1)
For i:= 1 To Len(aSXB)
	If !Empty(aSXB[i][1])
		If !MsSeek(Padr(aSXB[i,1], Len(SXB->XB_ALIAS))+aSXB[i,2]+aSXB[i,3]+aSXB[i,4])
			lSXB := .T.
			If !(aSXB[i,1]$cAlias)
				cAlias += aSXB[i,1]+"/"
			EndIf
			
			RecLock("SXB",.T.)
			
			For j:=1 To Len(aSXB[i])
				If !Empty(FieldName(FieldPos(aEstrut[j])))
					FieldPut(FieldPos(aEstrut[j]),aSXB[i,j])
				EndIf
			Next j
			
			dbCommit()
			MsUnLock()
			IncProc("Atualizando Consultas Padroes...")
		EndIf
	EndIf
Next i

dbSelectArea("SXB")
dbSetOrder(1)
For i:= 1 To Len(aAjSXB)
	If !Empty(aAjSXB[i][1])
		If MsSeek(PadR(aAjSXB[i,1], Len(SXB->XB_ALIAS))+aAjSXB[i,2]+aAjSXB[i,3]+aAjSXB[i,4])
			If Upper(AllTrim(FieldGet(FieldPos(aAjSXB[i,5,1])))) # Upper(AllTrim(aAjSXB[i,5,2]))
				lSXB := .T.
				If !(aAjSXB[i,1]$cAlias)
					cAlias += aAjSXB[i,1]+"/"
				EndIf
				RecLock("SXB",.F.)
				If !Empty(FieldName(FieldPos(aAjSXB[i,5,1])))
					FieldPut(FieldPos(aAjSXB[i,5,1]),aAjSXB[i,5,2])
				EndIf
				dbCommit()
				MsUnLock()
				IncProc("Atualizando Consultas Padroes...")
			EndIf
		EndIf
	EndIf
Next i

If lSXB
	cTexto := "Consultas Padroes Atualizadas : "+cAlias+CRLF
EndIf

Return cTexto

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³CCPAtuSXD ³ Autor ³ --------------------- ³ Data ³ 18/06/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao de processamento da gravacao do SXD                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ ATUALIZACAO SIGACCP                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CCPAtuSXD()
Local aSXD   := {}
Local aEstrut:= {}
Local i      := 0
Local j      := 0
Local cTexto := ''
Local cAlias := ''
Local lSXD   := .F.

aEstrut:= { "XD_TIPO","XD_FUNCAO","XD_PERGUNT","XD_ORDBRZ","XD_ORDSPA","XD_ORDENG",;
			"XD_PROPRI","XD_TITBRZ","XD_TITSPA","XD_TITENG","XD_DESCBRZ","XD_DESCSPA",;
			"XD_DESCSPE"}

ProcRegua(Len(aSXD))

dbSelectArea("SXD")
dbSetOrder(1) // FUNCAO
For i:= 1 To Len(aSXD)
	If !Empty(aSXD[i][1])
		If !MsSeek(Padr(aSXD[i,2], Len(SXD->XD_FUNCAO)))
			lSXD := .T.
			If !(aSXD[i,2]$cAlias)
				cAlias += aSXD[i,2]+"/"
			EndIf
			
			RecLock("SXD",.T.)
			
			For j:=1 To Len(aSXD[i])
				If !Empty(FieldName(FieldPos(aEstrut[j])))
					FieldPut(FieldPos(aEstrut[j]),aSXD[i,j])
				EndIf
			Next j
			
			dbCommit()
			MsUnLock()
			IncProc("Atualizando configuracao do Scheduler.")
		EndIf
	EndIf
Next i

If lSXD
	cTexto := "Configuracoes do Schedule atualizadas: "+cAlias+CRLF
EndIf

Return cTexto

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³CCPOpenSM0³ Autor ³ --------------------- ³ Data ³ 23/05/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Realiza abertura do SIGAMAT.EMP de forma exclusiva         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ ATUALIZACAO SIGACCP                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CCPOpenSM0()

Local nLoop := 0

For nLoop := 1 To 20
	dbUseArea(.T.,, "SIGAMAT.EMP", "SM0", .T., .F.)
	If !Empty(Select("SM0"))
		lOpen := .T.
		dbSetIndex("SIGAMAT.IND")
		Exit
	EndIf
	Sleep(500)
Next nLoop

If !lOpen
	Aviso( "Atencao!", "Nao foi possivel a abertura da tabela de empresas de forma exclusiva!" , {"Finalizar"}, 2)
EndIf

Return lOpen

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ XCCPRTX1  º Autor ³ ARNALDO R. JUNIOR  º Data ³  28/05/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Retorna quantas perguntas existe em um grupo no SX1         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
USER FUNCTION XCCPRTX1(cPerg)

Local aArea 	:= GetArea()
Local nQuantas 	:= 0

DbSelectArea("SX1")
DbSetOrder(1)
DbSeek(cPerg)
dbEval({|| nQuantas++ },,{||SX1->(!EOF()) .AND. SX1->X1_GRUPO == cPerg})

RestArea(aArea)
Return nQuantas


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PPI100PBOX º Autor ³ Cintia B. Gomes    º Data ³  01/02/2008 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ TELA DE PARAMETROS ESPECIFICOS DA ROTINA CUSTOMIZADA        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
STATIC FUNCTION CCPPARBOX()

LOCAL aParamBox := {}						// Array de parametros de acordo com a regra da ParamBox
LOCAL cTitulo	:= "Parametrizacao: Custo em Partes" 	// Titulo da janela de parametros
LOCAL aRet		:= {}						// Array que será passado por referencia e retornado com o conteudo de cada parametro
LOCAL bOk		:= {|| .T.}					// Bloco de codigo para validacao do OK da tela de parametros
LOCAL aButtons	:= {}						// Array contendo a regra para adicao de novos botoes (além do OK e Cancelar) // AADD(aButtons,{nType,bAction,cTexto})
LOCAL lCentered	:= .T.						// Se a tela será exibida centralizada, quando a mesma não estiver vinculada a outra janela
LOCAL nPosx		    						// Posicao inicial -> linha (Linha final: nPosX+274)
LOCAL nPosy									// Posicao inicial -> coluna (Coluna final: nPosY+445)
LOCAL cLoad		:= ""						// Nome do arquivo aonde as respostas do usuário serão salvas / lidas
LOCAL lCanSave	:= .F.						// Se as respostas para as perguntas podem ser salvas
LOCAL lUserSave := .F.						// Se o usuário pode salvar sua propria configuracao
LOCAL nX		:= 0
LOCAL lRet		:= .F.
PRIVATE CARQTAB := "SX1010"
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Perguntas para parametrizacao da rotina (PARAMBOX)          			³
//³ MVParBox01 - Nome da tabela     (F3: SZ4)		              			³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

AADD(aParamBox,{1,"Quantas partes:"	  ,99,"@E 99","AllwaysTrue()","" ,".T.",030,.T.})
AADD(aParamBox,{1,"Quantas moedas:"	  ,99,"@E 99","AllwaysTrue()","" ,".T.",030,.T.})
AADD(aParamBox,{1,"Tamanho:"	  	  ,99,"@E 99","AllwaysTrue()","" ,".T.",030,.T.})
AADD(aParamBox,{1,"Decimais:"	  	  ,99,"@E 99","AllwaysTrue()","" ,".T.",030,.T.})

lRet := ParamBox(aParamBox, cTitulo, aRet, bOk, aButtons, lCentered, nPosx, nPosy, /*oMainDlg*/ , cLoad, lCanSave, lUserSave)

IF lRet .AND. ValType(aRet) == "A" .AND. Len(aRet) == Len(aParamBox)
	For nX := 1 to Len(aParamBox)
		If aParamBox[nX][1] == 1
			&("MvParBox"+StrZero(nX,2)) := aRet[nX]
		ElseIf aParamBox[nX][1] == 2 .AND. ValType(aRet[nX]) == "C"
			&("MvParBox"+StrZero(nX,2)) := aScan(aParamBox[nX][4],{|x| Alltrim(x) == aRet[nX]})
		ElseIf aParamBox[nX][1] == 2 .AND. ValType(aRet[nX]) == "N"
			&("MvParBox"+StrZero(nX,2)) := aRet[nX]
		Endif	
	Next nX
ENDIF

IF lRet
    
	aParamBox := {}

	For nX := 1 to MvParBox01
		AADD(aParamBox,{1,"Label da Parte "+STRZERO(nX,2)+":",SPACE(10),"@!","AllwaysTrue()","" ,".T.",120,.T.})
		AADD(aParamBox,{1,"Descricao da Parte "+STRZERO(nX,2)+":",SPACE(40),"@!","AllwaysTrue()","" ,".T.",120,.T.})
	Next nX

	lRet := ParamBox(aParamBox, cTitulo, aRet, bOk, aButtons, lCentered, nPosx, nPosy, /*oMainDlg*/ , cLoad, lCanSave, lUserSave)

	IF lRet .AND. ValType(aRet) == "A" .AND. Len(aRet) == Len(aParamBox)
		For nX := 1 to Len(aParamBox) STEP 2
				AADD(aCCPParBox,{aRet[nX], aRet[nX+1]})
		Next nX
	ENDIF

ENDIF

RETURN lRet