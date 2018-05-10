#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#INCLUDE "TCBROWSE.CH"

#DEFINE ENTER Chr(10)+Chr(13)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  FB_PRODPA  บ Autor ณ Ricardo Rotta      บ Data ณ  14/11/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Rotina de Apontamento de Producao dos PAs                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6 IDE                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function FB_PRODPA

Local cFilQuery	    := ""

PRIVATE lUsaSegUm	:= .t.
Private aNeed 		:= {}
Private lDelOpSC 	:= GetMV("MV_DELOPSC")== "S"
Private aRotAuto    := Nil
Private lPerdInf    := SuperGetMV("MV_PERDINF",.F.,.F.)
Private nFCICalc    := SuperGetMV("MV_FCICALC",.F.,0)
PRIVATE aCtbDia	    := {}                   
Private lExistePM   := .F. //Indica se existe produ็ใo a maior para permitir requisitar quando o empenho estiver zerado
Private lProc113    := .F.
Private aArray113  
Private lLoteACD := .F.

PRIVATE aRotina		:= MenuDef() // ALTERADO PARA SIGAGSP
PRIVATE cCadastro	:= OemtoAnsi("Manuten็ใo Apontamentos de Produ็ใo - Produto Acabado")
Private l240:=.F.,l250 :=.T.,l241:=.F.,l242:=.F.,l261:=.F.,l185:=.F.,l650:=.F.,l680:=.F.,l681:=.F.

Pergunte("MTA250",.F.)

cFilQuery := "D3_CF = 'PR0' AND D3_TIPO = '04' AND D3_ESTORNO = ' '"

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Endereca a funcao de BROWSE                                  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
mBrowse( 6, 1,22,75,"SD3",,,,,,,,,,,,,,IIF(!Empty(cFilQuery),cFilQuery, NIL),,,,)

dbSelectArea("SD3")
dbClearFilter()
dbSetOrder(1)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
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
ฑฑณ          ณ	  1 - Pesquisa e Posiciona em um Banco de Dados     	  ณฑฑ
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
Private aRotina	:= {	{"Pesquisar","AxPesqui"  	, 0 , 1,0,.F.},;   	//
						{"Visualizar","A250Visual"	, 0 , 2,0,Nil},;   	//
						{"Incluir","u_PRODPA_A()"	, 0 , 3,0,Nil},;   	//
						{"Reimpressao Etiqueta","u_FB_RIMPET('SD3')"  , 0 , 8, 0, NIL},;
						{"Estornar","u_FB_ESTPA()"	, 0 , 5,0,Nil}}


Return (aRotina)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFB_PRODPA บAutor  ณMicrosiga           บ Data ณ  11/28/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function FB_ESTPA

Private lProdAut := GetMv("MV_PRODAUT")
Private dDataFec:= MVUlmes()
Private L250AUTO	:= .F.
Private cCadastro := "Produ”es"
Private aAcho:={}
Private cCusMed 	:= GetMv("mv_CusMed")
Private l240Auto 	:= .F.
	
	AADD(aAcho,"D3_TM"		)
	AADD(aAcho,"D3_CF"		)
	AADD(aAcho,"D3_OP"		)
	AADD(aAcho,"D3_COD"		)
	AADD(aAcho,"D3_QUANT"	)
	AADD(aAcho,"D3_UM"		)
	If lUsaSegUm
		AADD(aAcho,"D3_QTSEGUM"	)
		AADD(aAcho,"D3_SEGUM"	)
	EndIf
	AADD(aAcho,"D3_PARCTOT"	)
	AADD(aAcho,"D3_LOCAL"	)
	AADD(aAcho,"D3_CC"		)
	AADD(aAcho,"D3_CONTA"	)
	AADD(aAcho,"D3_EMISSAO"	)
	AADD(aAcho,"D3_DOC"		)
	AADD(aAcho,"D3_PERDA"	)
	AADD(aAcho,"D3_DESCRI"	)

	AADD(aAcho,"D3_LOTECTL")
	AADD(aAcho,"D3_DTVALID")
	AADD(aAcho,"D3_POTENCI")
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Portaria CAT83   |
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If V240CAT83()
		aaDD(aAcho,"D3_CODLAN")
	EndIf

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Percentual FCI   |
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู	
	If nFCICalc == 1
		aaDD(aAcho,"D3_PERIMP")
	EndIf
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Trata campos  - Diario    		      ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If ( UsaSeqCor() ) 
		AADD(aAcho,"D3_NODIA")
	EndIf	
	
	If IntWms()
		AADD(aAcho, 'D3_SERVIC')
	EndIf

	dbSelectArea("SX3")
	dbSeek("SD3")
	While !EOF() .And. (X3_ARQUIVO == "SD3")
		If X3USO(X3_USADO) .And. cNivel >= X3_NIVEL .And. (ASCAN(aAcho,Trim(X3_CAMPO)) == 0) .And. X3_PROPRI == "U"
			AADD(aAcho,TRIM(X3_CAMPO))
		EndIf
		dbSkip()
	EndDo

dbSelectArea("SD3")

A250Estorn("SD3",SD3->(recno()),5)

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFB_PRODPA บAutor  ณMicrosiga           บ Data ณ  11/14/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function PRODPA_A

Local aSize    := MsAdvSize()
Local aObjects := {{100,100,.t.,.t.},{100,030,.t.,.t.},{100,020,.t.,.f.}}
Local aInfo    := {aSize[1],aSize[2],aSize[3],aSize[4],3,3}
Local aPosObj  := MsObjSize(aInfo,aObjects)
Local _nLinha  := 0
Local _lIniVar := .t.
Local _dData	:= dDataBase
Local _cOP  	:= CriaVar("D3_OP",.F.)
Local _cCodPro	:= Criavar("D3_COD",.F.)
Local _cNomPro	:= Criavar("B1_DESC",.F.)
Local _cCodTara := PadR(SuperGetMV("MV_XTARA",.F.,"002"),Len(SZ0->Z0_CODIGO))
Local _nTara	:= Criavar("Z0_PESO",.F.)
Local _nPeso	:= Criavar("D3_QTSEGUM",.F.)
Local _nQuant	:= Criavar("D3_QUANT",.F.)
Local _cTM		:= SuperGetMV("FB_TMPROD",.F.,"002")
Local _nQtdOP	:= 0
Local _nQuje	:= 0
Local _nSaldo	:= 0
Local nOpca := 1
Local _lpos := .T.
Local _cTurno	:= " "
Local _aTurno  	:= {"1-Turno 1","2-Turno 2","3-Turno 3"}
Local _cEstacao := GetComputerName()
Local _cFila    := ""
Local lTara     := .F.
dbSelectArea("SZ0")
dbSetOrder(1)
If dbSeek(xFilial()+_cCodTara)
	_nTara := SZ0->Z0_PESO
Else
	MsgAlert("Tara informada nใo cadastrada: " + _cCodTara, "ATENCAO")
	Return
Endif

dbSelectArea("SF5")
dbSetOrder(1)
If dbSeek(xFilial()+_cTM)
	If !(SF5->F5_TIPO == "P" .and. SF5->F5_ATUEMP == "S")
		MsgAlert("O TM para apontamento estแ configurado como : " + _cTM + " atraves do parametro FB_TMPROD, por้m o cadastro desse TM nใo corresponde a necessidade da opera็ใo", "ATENCAO")
		Return
	Endif
Else
	MsgAlert("O TM para apontamento estแ configurado como : " + _cTM + " atraves do parametro FB_TMPROD, por้m esse TM nใo estแ cadastrado", "ATENCAO")
	Return
Endif

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

DEFINE FONT oBoldinho NAME "Arial" SIZE 0, -10 BOLD
DEFINE FONT oBold NAME "Arial" SIZE 0, -20 BOLD
DEFINE FONT oGBold NAME "Arial" SIZE 20, -40 BOLD

While _lpos
	_dData	:= dDataBase
	_nLinha := 0
	_nPeso  := 0
	_nQuant := 0

	DEFINE MSDIALOG oDlg TITLE ":::... Apontamento Produ็ใo ...:::" From aSize[7],0 to aSize[6],aSize[5] of oMainWnd Pixel

	@ aPosObj[1][1]+_nLinha,C(010) SAY "Data"         SIZE 65, 20 FONT oBold COLOR CLR_BLACK,CLR_HGRAY PIXEL OF oDlg
	@ aPosObj[1][1]+_nLinha,C(200) SAY "Turno"        SIZE 65, 20 FONT oBold COLOR CLR_BLACK,CLR_HGRAY PIXEL OF oDlg
	@ aPosObj[1][1]+_nLinha,C(040) GET odData  VAR _dData  SIZE 70,15 When .F. PIXEL OF oDlg FONT oBold
	@ aPosObj[1][1]+_nLinha,C(240) COMBOBOX ocTurno VAR _cTurno ITEMS _aTurno SIZE 115, 65 FONT oBold PIXEL OF oDlg
	ocTurno:nAT := Val(u_FBTurno())
	_nLinha+=30

	@ aPosObj[1][1]+_nLinha,C(010) SAY "Ordem de Produ็ใo"        SIZE 100, 20 FONT oBold COLOR CLR_BLACK,CLR_HGRAY PIXEL OF oDlg
	@ aPosObj[1][1]+_nLinha,C(100) GET ocOP VAR _cOP Picture "@!" SIZE 90,15 FONT oBold PIXEL OF oDlg Valid FB_VlOP(_cOP, @_cCodPro, @_cNomPro, @_nQtdOP, @_nQuje, @_nSaldo)
	ocOP:cF3 := "SC2FPA"

	@ aPosObj[1][1]+_nLinha,C(200) SAY "Produto"        SIZE 65, 20 FONT oBold COLOR CLR_BLACK,CLR_HGRAY PIXEL OF oDlg
	@ aPosObj[1][1]+_nLinha,C(240) GET oCodPro VAR _cCodPro Picture "@!" SIZE 90,15 FONT oBold PIXEL OF oDlg
	oCodPro:cF3 := "SB1"

	_nLinha+=25

	@ aPosObj[1][1]+_nLinha,C(010) SAY oNomPro VAR _cNomPro FONT oGBold PIXEL OF oDlg SIZE 900,80 COLOR CLR_RED

	_nLinha+=30

	@ aPosObj[1][1]+_nLinha,C(010) SAY "Codigo Tara"        SIZE 100, 20 FONT oBold COLOR CLR_BLACK,CLR_HGRAY PIXEL OF oDlg
	@ aPosObj[1][1]+_nLinha,C(060) GET oCodTara VAR _cCodTara Picture "@!" When .F. SIZE 30,15 FONT oBold PIXEL OF oDlg

	@ aPosObj[1][1]+_nLinha,C(110) BUTTON "Captura Peso"	SIZE 50,20 FONT oBoldinho ACTION Cp_PesoPA(_cOP, _cCodPro, @_nPeso, @_nQuant, _nTara) OF oDlg PIXEL

	@ aPosObj[1][1]+_nLinha,C(180) SAY "Tara"        SIZE 65, 20 FONT oBold COLOR CLR_BLACK,CLR_HGRAY PIXEL OF oDlg
	@ aPosObj[1][1]+_nLinha,C(240) GET oTara VAR _nTara Picture PesqPictQt("Z0_PESO",TamSX3("Z0_PESO")[1]) When lTara SIZE 65,20 FONT oBold PIXEL OF oDlg
	
	_nLinTara := _nLinha

	_nLinha+=30

	@ aPosObj[1][1]+_nLinha,C(010) SAY "Peso"        SIZE 100, 20 FONT oBold COLOR CLR_BLACK,CLR_HGRAY PIXEL OF oDlg
	@ aPosObj[1][1]+_nLinha,C(060) GET oPeso VAR _nPeso Picture PesqPictQt("D3_QTSEGUM",TamSX3("D3_QTSEGUM")[1]) When .F. SIZE 90,15 FONT oBold PIXEL OF oDlg

	@ aPosObj[1][1]+_nLinha,C(180) SAY "Quantidade"        SIZE 65, 20 FONT oBold COLOR CLR_BLACK,CLR_HGRAY PIXEL OF oDlg
	@ aPosObj[1][1]+_nLinha,C(240) GET OQuant VAR _nQuant Picture PesqPictQt("D3_QUANT",TamSX3("D3_QUANT")[1]) When .F. SIZE 90,15 FONT oBold PIXEL OF oDlg

	@ 025, 004 TO aPosObj[1][1]+_nLinha+30,450 LABEL "Dados da Produ็ใo" OF oDlg  PIXEL

	_nLinha+= 58

	@ aPosObj[1][1]+_nLinha,C(010) SAY "Total OP:" SIZE 150, 20 FONT oBold COLOR CLR_HBLUE PIXEL OF oDlg
	@ aPosObj[1][1]+_nLinha,C(060) SAY oQtdOP VAR _nQtdOP Picture PesqPictQt("D3_QUANT",TamSX3("D3_QUANT")[1]) SIZE 85,15 FONT oBold  OF oDlg PIXEL COLOR CLR_RED
	
	@ aPosObj[1][1]+_nLinha,C(180) SAY "Apontado:" SIZE 150, 20 FONT oBold COLOR CLR_HBLUE PIXEL OF oDlg
	@ aPosObj[1][1]+_nLinha,C(240) SAY oQuje VAR _nQuje Picture PesqPictQt("D3_QUANT",TamSX3("D3_QUANT")[1]) SIZE 85,15 FONT oBold  OF oDlg PIXEL COLOR CLR_RED

	_nLinha+= 20
		
	@ aPosObj[1][1]+_nLinha,C(010) SAY "Saldo:" SIZE 150, 20 FONT oBold COLOR CLR_HBLUE PIXEL OF oDlg
	@ aPosObj[1][1]+_nLinha,C(060) SAY oSaldo VAR _nSaldo Picture PesqPictQt("D3_QUANT",TamSX3("D3_QUANT")[1]) SIZE 85,15 FONT oBold  OF oDlg PIXEL COLOR CLR_RED

	@ aPosObj[1][1]+_nLinha-40, 004 TO aPosObj[1][1]+_nLinha+20,450 LABEL "Resumo da Produ็ใo" OF oDlg  PIXEL
	
	@ aPosObj[3][1]-10,C(050) BUTTON "CONFIRMAR" SIZE 130,20 FONT oBold ACTION {|| ( IIF(GrvProd(_dData, _cOP, _cCodPro, _cCodTara, _nPeso, _nQuant, _cTurno, _cCodTara, _nTara, _cFila),oDlg:End(),""))} OF oDlg PIXEL
	@ aPosObj[3][1]-10,C(250) BUTTON "SAIR"		 SIZE 80,20 FONT oBold ACTION ( nOpca := 2, oDlg:End() ) OF oDlg PIXEL
//	@ aPosObj[1][1]+_nLinTara,C(340) CHECKBOX oChkTara VAR lTara PROMPT "Altera Tara" SIZE 50, 10 OF oDlg PIXEL // ON CLICK (AEval(aListaSD5, {|z| z[1] := If(z[1]==.T.,.F.,.T.)}), oQual:Refresh(.F.)) //"Inverte Selecao"

	ACTIVATE MSDIALOG oDlg CENTERED
	If nOpca == 2
		_lIniVar := .T.
		_lpos := .f.
		Exit
	Endif
End
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFB_PRODPA บAutor  ณMicrosiga           บ Data ณ  11/14/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function GrvProd(_dData, _cOP, _cCodPro, _cCodTara, _nPeso, _nQuant, _cTurno, _cCodTara, _nTara, _cFila)

Local _lRet := .t.
Local _aArea := GetArea()
Local aVetor    := {}
Local _cDoc     := "      "
Local _cTM		:= SuperGetMV("FB_TMPROD",.F.,"002")
Local nSaveSX8  := 0
Local _lSegUM  := Posicione("SB1",1,xFilial("SB1")+_cCodPro,"B1_SEGUM") == "KG"
Local _nQtd1UM := IIF(_lSegUM, _nQuant, _nPeso)
Local _nQtd2UM := IIF(_lSegUM, _nPeso, _nQuant)
Local _nMaior  := 0
Local _nConv   	:= Posicione("SB1",1,xFilial("SB1")+_cCodPro,"B1_XCONV")
Local _nTpConv  := Posicione("SB1",1,xFilial("SB1")+_cCodPro,"B1_TIPCONV")
Local _lNConv   := Substr(_cCodPro,1,4) == "0415"
Local _cHrProd  := Time()
Local _dDtTurno := u_FBDTTURN(_dData, _cHrProd)
Local _lAtuEmp   := Posicione("SF5",1,xFilial("SF5")+_cTM,"F5_ATUEMP") == "S"
Private _cNumRecD3 := 0
Private _cLocalPrd := CriaVar("B1_LOCPAD",.F.)

If Empty(_dData)
	MsgAlert("Informar Data do Apontamento" , "ATENCAO")
	_lRet := .f.
Endif

If _lRet .and. Empty(_cOP)
	MsgAlert("Informar o numero da OP" , "ATENCAO")
	_lRet := .f.
Endif

If _lRet .and. Empty(_cCodPro)
	MsgAlert("Informar o c๓digo do Produto" , "ATENCAO")
	_lRet := .f.
Endif

If _lRet .and. Empty(_cCodTara)
	MsgAlert("Informar a Tara" , "ATENCAO")
	_lRet := .f.
Endif

If _lRet .and. _nPeso <= 0
	MsgAlert("Informar o Peso" , "ATENCAO")
	_lRet := .f.
Endif

If _lRet .and. _nQuant <= 0
	MsgAlert("Informar a Quantidade" , "ATENCAO")
	_lRet := .f.
Endif
If _lRet
	_lRet := u_Vld_Toler(_cOP,_nQtd1UM)
Endif
If _lRet
	If _nConv > 0
		_lRet := u_VldMetr(_cCodPro, _nQtd1UM, _nQtd2UM, _nConv, _nTpConv)
	Else
		If !_lNConv
			MsgAlert("Nใo informado o fator de conversใo Fiabesa no Cadastro de Produto" , "ATENCAO Cadastre o Fator de Conversใo")
			_lRet := .f.
		Endif
	Endif
Endif	
If _lRet
	dbSelectArea("SC2")
	dbSetOrder(1)
	If dbSeek(xFilial("SC2")+_cOP)
//		If QtdComp(SC2->C2_QUANT) > QtdComp(SC2->C2_QUJE)
			If SC2->C2_QUJE > SC2->C2_QUANT
				_nMaior := 	_nQtd1UM
			Else
				_nMaior := (SC2->C2_QUJE + _nQtd1UM) - SC2->C2_QUANT
			Endif
			If _nMaior < 0
				_nMaior := 0
			Endif
			_nMaior := 0
			aVetor := {}
			lMsErroAuto := .F.
			If Empty(_cLocalPrd)
				_cLocalPrd := SC2->C2_LOCAL
			Endif
			SB2->(dbSetOrder(1))
			If !SB2->(dbSeek(xFilial("SB2")+SC2->C2_PRODUTO+_cLocalPrd))
				CriaSb2(SC2->C2_PRODUTO,_cLocalPrd)
			Endif
			dbSelectArea("SD4")
			dbSetOrder(2)
			dbSeek(xFilial()+_cOP)
			While !Eof() .and. xFilial("SD4")+_cOP == SD4->(D4_FILIAL+D4_OP)
				_nQtOP  := SC2->C2_QUANT
				_nQtEmp := SD4->D4_QTDEORI
				_nPropor := _nQtOP / _nQtEmp
				_nNecess := Round(_nQtd1UM / _nPropor, TAMSX3("D4_QUANT")[2])
				If SD4->D4_QUANT < _nNecess
					RecLock("SD4",.F.)
					Replace D4_QUANT with _nNecess
					MsUnLock()
				Endif
				dbSelectArea("SD4")
				dbSkip()
			End
			dbSelectArea("SD3")
			// Variavel que controla numeracao
			nSaveSX8 := GetSx8Len()
			_cDoc:= GETSXENUM("SD3","D3_DOC")
			aVetor:={	{"D3_OP"		,_cOP 				,NIL},;
						{"D3_DOC"		,_cDoc				,NIL},;
						{"D3_TM"		,_cTM				,NIL},;
						{"D3_UM"		,SC2->C2_UM			,NIL},;
						{"D3_COD"		,SC2->C2_PRODUTO	,NIL},;
						{"D3_LOCAL"		,_cLocalPrd			,NIL},;
						{"D3_CC"		,SC2->C2_CC			,NIL},;
						{"D3_LOTECTL"	,_cOP				,NIL},;
						{"D3_XTURNO"	,_cTurno			,NIL},;
						{"D3_XCTARA"	,_cCodTara			,NIL},;
						{"D3_XPTARA"	,_nTara				,NIL},;
						{"D3_HRPROD"	,_cHrProd			,NIL},;
						{"D3_XDTTURN"	,_dDtTurno			,NIL},;
						{"D3_PARCTOT"	,"P"				,NIL},;
						{"D3_EMISSAO"	,_dData				,NIL},;
						{"D3_QUANT"		,_nQtd1UM			,NIL},;
						{"D3_QTMAIOR"	,_nMaior			,NIL},;
						{"D3_QTSEGUM"	,_nQtd2UM			,NIL}}
			MsgRun("Aguarde gerando produ็ใo...","Apontamento Produ็ใo",{|| MSExecAuto({|x,y| mata250(x,y)},aVetor,3) }) //Inclusao
			If lMsErroAuto
				RollBAckSx8()
				Alert("Inconsistencia no Apontamento da Producao")
				MostraErro()
				_lRet := .f.
			Else
				// Confirma SX8
				While ( GetSx8Len() > nSaveSX8 )
					ConfirmSX8()
				Enddo
				If _cNumRecD3 > 0
					dbSelectArea("SD3")
					dbGoto(_cNumRecD3)
					If !Empty(_cFila)
						If CB5SetImp(_cFila,.T.)
							u_FB_Etiq(SD3->D3_COD, SD3->D3_EMISSAO, SD3->D3_XTURNO, SD3->D3_LOTECTL, SD3->D3_NUMLOTE, SD3->D3_QUANT, SD3->D3_XCTARA, SD3->D3_QTSEGUM, SD3->D3_OP, _cFila, PadR(SuperGetMV("FB_RECPA",.F.,"90000"),Len(SH1->H1_CODIGO)), .F., 1, SD3->D3_HRPROD)
						Endif
					Endif
					dbSelectArea("SC2")
					If dbSeek(xFilial("SC2")+_cOP) .and. !Empty(SC2->C2_DATRF)
						RecLock("SC2",.F.)
						Replace C2_DATRF with Ctod("  /  /  ")
						MsUnLock()
					Endif
					If _lAtuEmp
						FB_SegQtd(SD3->D3_NUMSEQ)
					Endif
					MsgInfo( OemToAnsi( "Sequencial: " + SD3->D3_NUMLOTE ) , "Identifica็ใo da Bobina" )
				Else
					MsgInfo( OemToAnsi( "Problema na gera็ใo do apontamento") , "Alerta na Identifica็ใo da Bobina" )
				Endif
			Endif
//		Endif
	Endif
Endif
RestArea(_aArea)
Return(_lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFB_PRODPA บAutor  ณMicrosiga           บ Data ณ  04/06/18   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function FB_SegQtd(_cNumSeq)

Local _aArea := GetArea()
Local _aAreaD3 := SD3->(GetArea())
Local _aAreaD5 := SD5->(GetArea())
Local _dEmissao	 := SD3->D3_EMISSAO
Local _nQtde1 := 0
Local _nQtde2 := 0
Local _nConv := 0
Local _aConv := {}
dbSelectArea("SD3")
dbSetOrder(6)
dbSeek(xFilial()+Dtos(_dEmissao)+_cNumSeq)
While !Eof() .and. xFilial("SD3")+Dtos(_dEmissao)+_cNumSeq == SD3->(D3_FILIAL+DTOS(D3_EMISSAO)+D3_NUMSEQ)
	If SD3->D3_CF == "RE1" .and. !IsProdMod(SD3->D3_COD)
		_nConv := Posicione("SB1",1,xFilial("SB1")+SD3->D3_COD,"B1_XCONV")
		If _nConv > 0 .and. Rastro(SD3->D3_COD)
			_nQtdeSeg := SD3->D3_QTSEGUM
			_nQtdePri := SD3->D3_QUANT
			_nQtde1 := 0
			_nQtde2 := 0
			_aConv  := {}
			dbSelectArea("SD5")
			dbSetOrder(3)
			dbSeek(xFilial()+_cNumSeq+SD3->D3_COD+SD3->D3_LOCAL)
			While !Eof() .and. xFilial("SD5")+_cNumSeq+SD3->D3_COD+SD3->D3_LOCAL == SD5->(D5_FILIAL+D5_NUMSEQ+D5_PRODUTO+D5_LOCAL)
				_cLotectl := SD5->D5_LOTECTL
				_cNumLote := SD5->D5_NUMLOTE
				cAliasTop := GetNextAlias()
				_cQuery := "SELECT D5_PRODUTO, D5_LOTECTL, D5_NUMLOTE,  SUM(D5_QUANT) D5_QUANT, SUM(D5_QTSEGUM) D5_QTSEGUM FROM " + RetSqlName("SD5")
				_cQuery += " WHERE D5_FILIAL = '" + xFilial("SD5") + "'"
				_cQuery += " AND D5_ORIGLAN < '500'"
				_cQuery += " AND D5_ESTORNO = ' '"
				_cQuery += " AND D_E_L_E_T_ = ' '"
				_cQuery += " AND D5_PRODUTO = '" + SD3->D3_COD + "'"
				_cQuery += " AND D5_LOTECTL = '" + _cLotectl + "'"
				_cQuery += " AND D5_NUMLOTE = '" + _cNumLote + "'"
				_cQuery += " GROUP BY D5_PRODUTO, D5_LOTECTL, D5_NUMLOTE"
				_cQuery += " ORDER BY D5_PRODUTO, D5_LOTECTL, D5_NUMLOTE"
				_cQuery := ChangeQuery(_cQuery)
				dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),cAliasTop,.T.,.T.)
				dbSelectArea(cAliasTop)
				While !EOF()
					_nQtde1 += (cAliasTop)->D5_QUANT
					_nQtde2 += (cAliasTop)->D5_QTSEGUM
					aadd(_aConv, {(cAliasTop)->D5_PRODUTO, (cAliasTop)->D5_LOTECTL, (cAliasTop)->D5_NUMLOTE, _nQtde1 / _nQtde2})
					dbSelectArea(cAliasTop)
					dbSkip()
				End
				dbSelectArea(cAliasTop)
				dbCloseArea()
				dbSelectArea("SD5")
				dbSkip()
			End
			If _nQtde2 > 0
	            _nConv := _nQtde1 / _nQtde2
	            _nQtdCalc2 := Round(_nQtdePri / _nConv, TAMSX3("D3_QTSEGUM")[2])
	            If QtdComp(_nQtdCalc2) <> QtdComp(_nQtdeSeg)
	            	dbSelectArea("SD3")
	            	RecLock("SD3",.F.)
	            	Replace D3_QTSEGUM with _nQtdCalc2
	            	MsUnLock()
	            	dbSelectArea("SB2")
	            	dbSetOrder(1)
	            	If dbSeek(xFilial()+SD3->D3_COD+SD3->D3_LOCAL)
	            		RecLock("SB2",.F.)
	            		Replace B2_QTSEGUM with B2_QTSEGUM + _nQtdeSeg - _nQtdCalc2
	            		MsUnLock()
	            	Endif
	            	For nJ:=1 to Len(_aConv)
						dbSelectArea("SD5")
						dbSetOrder(3)
						If dbSeek(xFilial()+_cNumSeq+SD3->D3_COD+SD3->D3_LOCAL+_aConv[nJ,2]+_aConv[nJ,3])
							RecLock("SD5",.F.)
							Replace D5_QTSEGUM with ROUND(D5_QUANT / _aConv[nJ,4], TAMSX3("D5_QTSEGUM")[2])
							MsUnLock()
						Endif
					Next
	            Endif
	  		Endif
	  	Endif
	Endif
	dbSelectArea("SD3")
	dbSkip()
End
RestArea(_aAreaD3)
RestArea(_aAreaD5)
RestArea(_aArea)
Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFB_PRODPA บAutor  ณMicrosiga           บ Data ณ  11/14/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function FB_VlOP(_cOP, _cCodPro, _cNomPro, _nQtdOP, _nQuje, _nSaldo)

Local _aArea := GetArea()
Local _lRet  := .t.
Local _lNConv
If !Empty(_cOP)
	dbSelectArea("SC2")
	dbSetOrder(1)
	If dbSeek(xFilial()+_cOP)
		If Empty(SC2->C2_DATRF)
			dbSelectArea("SB1")
			dbSetOrder(1)
			If dbSeek(xFilial()+SC2->C2_PRODUTO)
				If SB1->B1_TIPO == "04"
					_cCodPro := SC2->C2_PRODUTO
					_lNConv := Substr(_cCodPro,1,4) == "0415"
					_cNomPro := Alltrim(SB1->B1_DESC)
					_nQtdOP  := SC2->C2_QUANT
					_nQuje   := SC2->C2_QUJE
					_nSaldo  := _nQtdOP - _nQuje
					If SB1->B1_XCONV == 0
						If !_lNConv
							MsgAlert("Nใo informado o fator de conversใo Fiabesa no Cadastro de Produto" , "ATENCAO Cadastre o Fator de Conversใo")
							_lRet := .f.
						Endif
					Else
						oNomPro:Refresh()
						oQtdOP:Refresh()
						oQuje:Refresh()
						oSaldo:Refresh()
					Endif
				Else
					MsgAlert("Apontamento permitido apenas para Produto Acabado" , "ATENCAO")
					_lRet := .f.
				Endif
			Else
				MsgAlert("Produto nใo cadastrado: " + SC2->C2_PRODUTO, "ATENCAO")
				_lRet := .f.
			Endif
		Else
			MsgAlert("Ordem de Produ็ใo Encerrada", "ATENCAO")
			_lRet := .f.
		Endif
	Else
		MsgAlert("Ordem de Produ็ใo nใo encontrada", "ATENCAO")
		_lRet := .f.
	Endif
Endif
RestArea(_aArea)
Return(_lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFB_PRODPA บAutor  ณMicrosiga           บ Data ณ  11/20/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Cp_PesoPA(_cOP, _cProd, _nPeso, _nQuant, _nTara)

Local _aArea   := GetArea()
Local _lSegUM  := Posicione("SB1",1,xFilial("SB1")+_cProd,"B1_SEGUM") == "KG"
Local _lCtlUN  := Posicione("SB1",1,xFilial("SB1")+_cProd,"B1_SEGUM") == "UN"
Local _nConv   := Posicione("SB1",1,xFilial("SB1")+_cProd,"B1_XCONV")
Local _nTpConv := Posicione("SB1",1,xFilial("SB1")+_cProd,"B1_TIPCONV")
Local _nQtUni  := 0
Local _lRet    := .T.
Default _nTara := 0

If Empty(_cOP)
	Help(" ",1,"NINFOP",,"Informe a OP",4,,,,,,.F.)
	_lRet := .f.
Endif
If _lRet
	u_Pg_Balanc(@_nPeso,_nTara)
	u_Ms_Peso(@_nPeso,_nTara, _lSegUM, @_nQtUni, _nConv, _nTpConv, _cProd, _cOP)
	_nBruto := _nPeso - _nTara
	If _nBruto > 0 .and. IIF(_lSegUM, _nQtUni > 0, .T.)
		dbSelectArea("SB1")
		dbSetOrder(1)
		dbSeek(xFilial()+_cProd)
		_nPeso := _nBruto
		_nQuant := _nQtUni
		oPeso:Refresh()
		OQuant:Refresh()
	Endif
Endif
RestArea(_aArea)
Return(_lRet)
