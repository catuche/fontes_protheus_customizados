#INCLUDE "FB_OMSA200.ch"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "msgraphi.ch"
#INCLUDE "APWIZARD.CH"
#INCLUDE "FWMVCDEF.CH"

#DEFINE CARGA_ENABLE 	1
#DEFINE CARGA_COD    	2
#DEFINE CARGA_DESC   	3
#DEFINE CARGA_PESO   	4
#DEFINE CARGA_VALOR  	5
#DEFINE CARGA_VOLUM  	6
#DEFINE CARGA_QTDLIB 	7
#DEFINE CARGA_PTOENT 	8
#DEFINE CARGA_VEIC   	9
#DEFINE CARGA_MOTOR  	10
#DEFINE CARGA_AJUD1  	11
#DEFINE CARGA_AJUD2  	12
#DEFINE CARGA_AJUD3  	13
#DEFINE CARGA_AJUD3  	14
#DEFINE CARGA_PESCIF 	15
#DEFINE CARGA_QTDCIF 	16
#DEFINE CARGA_VOLCIF 	17
#DEFINE CARGA_VALCIF 	18
#DEFINE CARGA_PESFOB 	19
#DEFINE CARGA_QTDFOB 	20
#DEFINE CARGA_VOLFOB 	21
#DEFINE CARGA_VALFOB 	22
#DEFINE CARGA_TRANSP	23
#DEFINE CARGA_TPOP      24
#DEFINE CARGA_CLFR      25

#DEFINE FRETE_COD     	1
#DEFINE FRETE_VAL     	2
#DEFINE FRETE_INSS    	3
#DEFINE FRETE_PEDAG   	4
#DEFINE FRETE_ADIANT  	5
#DEFINE FRETE_RATEIO  	6
#DEFINE FRETE_FREAUT  	7
#DEFINE FRETE_TABFRE  	8
#DEFINE FRETE_TIPTAB  	9

Static cVeiAnt  := ""
Static cTabAnt  := ""
Static nDelItem := 0
Static l200Auto := .F.
Static cCargaID := ""

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ OMSA200  ³ Rev.  ³ DL                    ³ Data ³ 19.07.2001³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Programa de Geracao de carga                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Void OMSA200(void)                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Generico                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ PROGRAMADOR  ³ DATA   ³ BOPS ³  MOTIVO DA ALTERACAO                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function FB_OMSA200(xAutoCab, xAutoItens,nOpc)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa vari veis utilizadas na criacao de Arquivos de Trabalho     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local aArea     := GetArea()
Local aCores    := {}
Local aIndDAK   := {}
Local aRetPE    := {}
Local cCondicao := ""
Local cRetPE    := ""
Local aCoresPE  := {}
Local aSetKey   := {} 
Local nI		:= 0

nOpc := If (nOpc == Nil,3,nOpc)
Private bFiltraBrw := {|| Nil}
Private cCadastro  := OemtoAnsi(STR0001) //"Montagem de Carga"
Private n := 1
Private aArrayCli  := {}
Private nIndice	  := 5
Private aRotAuto   := {}
Private aAutoItens := {}
Private xArrCarga := {}
Private aVisErr    := {}
Private lDisrmTran

l200Auto   := ValType(xAutoCab) == "A" .And. ValType(xAutoItens) == "A"
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Perguntas :                                                  ³
//³                                                              ³
//³ mv_par01  // Pedidos do Tipo (PalmTop / Manual / Ambos )     ³
//³ mv_par02  // Do Vendedor                                     ³
//³ mv_par03  // Ate o Vendedor                                  ³
//³ mv_par04  // Da Emissao                                      ³
//³ mv_par05  // Ate a Emissao                                   ³
//³ mv_par06  // Do Pedido                                       ³
//³ mv_par07  // Ate o Pedido                                    ³
//³ mv_par08  // Do Cliente                                      ³
//³ mv_par09  // Ate o Cliente                                   ³
//³ mv_par10  // Trazer Tudo Marcado ?                           ³
//³ mv_par11  // Do Pedido Palm-Top                              ³
//³ mv_par12  // Ate Pedido Palm-Top                             ³
//³ mv_par13  // Utiliza Restricoes                              ³
//³ mv_par14  // Considera Todo Dia Quantio as Restricoes        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

aRotina := MenuDef()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Ponto de entrada para a criacao de botoes de usuario                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ExistBlock( "OM200US" )
	aRetPE := ExecBlock( "OM200US", .F., .F.,aRotina)
	If ValType(aRetPE)=="A" .And. Len(aRetPE) > 0
		aRotina := aRetPE
 	EndIf
EndIf
DBSELECTAREA('SX1')
SX1->( DbSetOrder( 1 ) )
If SX1->(DBSeek( PadR("OMS200C",Len(SX1->X1_GRUPO),' ')))
	AAdd(aSetKey, { VK_F12 , { || Pergunte("OMS200C",.T.) } } )
	//-- Inicializa Teclas de Atalhos
	TmsKeyOn(aSetKey)
EndIf

If (AMIIn(5,39)) // SigaFat - SigaOms
	If ExistBlock("OM200CND")
		If ValType( aCoresPE := ExecBlock("OM200CND",.F.,.F.) ) == "A"
			For nI := 1 To Len(aCoresPE)
				AAdd(aCores,aCoresPE[nI])
			Next nI
		EndIf
	EndIf
	
	If (l200Auto)
		aRotAuto   := xAutoCab
		aAutoItens := aClone(xAutoItens)
		 
		MBrowseAuto(nOpc,AClone(aRotAuto),"DAK")
	Else
	
		If DAK->(FieldPos("DAK_BLQCAR")) > 0		
			AAdd(aCores,{"DAK_FEZNF == '2' .And. DAK_ACECAR == '2'.And.(DAK_BLQCAR == '2' .Or. DAK_BLQCAR == ' ') .And. (DAK_JUNTOU=='MANUAL'.Or.DAK_JUNTOU=='ASSOCI'.Or.DAK_JUNTOU=='JUNTOU')","ENABLE"})		//Totalmente em aberto
			AAdd(aCores,{"DAK_FEZNF == '1' .And. DAK_ACECAR == '2'.And.(DAK_BLQCAR == '2' .Or. DAK_BLQCAR == ' ') .And. (DAK_JUNTOU=='MANUAL'.Or.DAK_JUNTOU=='ASSOCI'.Or.DAK_JUNTOU=='JUNTOU')","BR_LARANJA"})	//Somente faturada e nao acertada
			AAdd(aCores,{"DAK_FEZNF == '1' .And. DAK_ACECAR == '1'.And.(DAK_BLQCAR == '2' .Or. DAK_BLQCAR == ' ') .And. (DAK_JUNTOU=='MANUAL'.Or.DAK_JUNTOU=='ASSOCI'.Or.DAK_JUNTOU=='JUNTOU')","DISABLE"})		//Faturada e acertada
			AAdd(aCores,{"                                              DAK_BLQCAR == '1'                         .And. (DAK_JUNTOU=='MANUAL'.Or.DAK_JUNTOU=='ASSOCI'.Or.DAK_JUNTOU=='JUNTOU')","BR_PRETO"})	//Bloqueada
		Else
			AAdd(aCores,{"DAK_FEZNF == '1' .And. DAK_ACECAR == '1'.And.(DAK_JUNTOU=='MANUAL'.Or.DAK_JUNTOU=='ASSOCI'.Or.DAK_JUNTOU=='JUNTOU')","DISABLE"})		//Faturada e acertada
			AAdd(aCores,{"DAK_FEZNF == '2' .And. DAK_ACECAR == '2'.And.(DAK_JUNTOU=='MANUAL'.Or.DAK_JUNTOU=='ASSOCI'.Or.DAK_JUNTOU=='JUNTOU')","ENABLE" })		//Totalmente em aberto
			AAdd(aCores,{"DAK_FEZNF == '1' .And. DAK_ACECAR == '2'.And.(DAK_JUNTOU=='MANUAL'.Or.DAK_JUNTOU=='ASSOCI'.Or.DAK_JUNTOU=='JUNTOU')","BR_LARANJA"})	//Somente faturada e nao acertada
		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Inclui Filial de / ate nos parametros OM341B                            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If Pergunte("OMS20A",.T.)
			cCondicao += " DAK_FILIAL='"+xFilial("DAK")+"' And "
			cCondicao += " DAK_COD >= '"+mv_par01+"' And DAK_COD <= '"+mv_par02+"' And "
			cCondicao += " DAK_DATA >= '"+Dtos(mv_par03)+"' And DAK_DATA <= '"+Dtos(mv_par04)+"' "
			If mv_par05 == 1
				cCondicao += " And DAK_FEZNF = '2' And DAK_ACECAR = '2' "
			ElseIf mv_par05 == 2
				cCondicao += " And DAK_FEZNF = '1' And DAK_ACECAR = '2' "
			ElseIf mv_par05 == 3
				cCondicao += " And DAK_FEZNF = '1' And DAK_ACECAR = '1' "
			EndIf
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Ponto de Entrada para inserir filtro de usuario                         ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If ExistBlock("OM200BRW")
				cRetPE := ExecBlock("OM200BRW",.F.,.F.)
				If ValTYpe(cRetPE)=="C"
					cCondicao += " And "+cRetPE
				EndIf
			EndIf
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Realiza a Filtragem                                                     ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
			Mbrowse(6,1,22,75,"DAK",,,,,,aCores,,,,,,,,cCondicao)
	
		EndIf
	Endif
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Restaura a integridade da rotina                                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	DbSelectArea("DAK")
	RetIndex("DAK")
	dbClearFilter()
	aEval(aIndDAK,{|x| Ferase(x[1]+OrdBagExt())})
	RestArea( aArea )
EndIf

Return( .T. )

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³OsA200Mont³ Autor ³DL                     ³ Data ³02.03.2001  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Rotina de interface da Montagem de Carga                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpC1: Alias do Arquivo                                       ³±±
±±³          ³ExpN2: Numero do Registro                                     ³±±
±±³          ³ExpN3: Opcao do aRotina                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Materiais/Distribuicao/Logistica                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Atualizacoes sofridas desde a Construcao Inicial.                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Programador  ³ Data   ³ BOPS ³  Motivo da Alteracao                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function FBA200Mont()
Local aSize       := MsAdvSize( .T. )
Local aPosObj1    := {}
Local aPosObj2    := {}
Local aPosObj3    := {}
Local aObjects    := {}
Local aArrayCarga := {}
Local aArrayRota  := {}
Local aArrayZona  := {}
Local aArraySetor := {}
Local aArrayMan   := {}
Local aLock       := {}
Local aArrayMod   := {}
Local aArrayTipo  := {}
Local aCampos     := {}
Local aCpoBrw     := {}
Local aRetPE      := {}
Local aButtonUsr  := {}

Local aButtons    := {	{ "RPMNEW"  , { || (OmsAbreCarga(@oEnable,@oDisable,@oMarked,@oNoMarked,@aArrayCarga,@nSaveSx8,@aHeaderAdt,@aColsAdt,@cDakTransp,@aArrayRota,@aArrayZona,@aArraySetor), aArrayFrt:=Array(9)) }, OemtoAnsi(STR0008),OemtoAnsi(STR0166) },; //"Abre Carga"
						{ "CARGASEQ", { || Os200VisCg(@aArrayCarga,@aArrayMan,@cHrStart,@dDtStart)}, OemtoAnsi(STR0009),OemtoAnsi(STR0167) },; //"Sequencia de Entrega"
						{ "CARGA"   , { || OmsTransp(@aArrayMan,@aArrayCarga,@oEnable,@oDisable,@oMarked,@oNoMarked,@cHrStart,@dDtStart,@aArrayFrt,@aHeaderFrt, @aColsFrt,@cGvCodOper, @cGvNoProc, @cGvPedComOp,@aHeaderAdt,@aColsAdt,"TRBPED",cMarca,@aFretReg,,cDakTransp )} , OemtoAnsi(STR0012),OemtoAnsi(STR0168) },; //"Associar Veiculo"
						{ "VENDEDOR", { || Os200VisCF()                        }, OemtoAnsi(STR0010), OemtoAnsi(STR0030)},; //"Visualizar Dados do Cliente"
						{ "PEDIDO"  , { || Os200VisPv()                        }, OemtoAnsi(STR0011), OemtoAnsi(STR0028)},; //"Visualizar Pedido"
						{ "PESQUISA", { || OmsPesqPed("TRBPED",aCampos,aCpoBrw)}, OemtoAnsi(STR0117), OemtoAnsi(STR0169) },; //"Pesquisa de pedidos"
						{ "GRAF3D"  , { || OmsVisGraph(@aArrayCarga,cMarca)    }, OemtoAnsi(STR0098), OemtoAnsi(STR0170)},; //"Graficos"
						{ "RELOAD"  , { || u_FBA200Refr(aCampos,cCarga,aArrayCarga,aArrayRota,aArrayZona,aArraySetor,aArrayMod,aArrayTipo,{oCargas,oRotas,oZonas,oSetores},@nSaveSx8,@aArrayMan,aArrayFrt,aArrayMan,{oAllMark}, @cDakTransp)},"Refresh","Refresh"}}
						

Local lAllMark    := .F.
Local nTipoOper   := OsVlEntCom()
Local nSaveSx8    := GetSx8Len()
Local cCarga      := GetSx8Num("DAK","DAK_COD")
Local cMarca      := GetMark()
Local cAlocPer    := SuperGetMv("MV_ALOCPER",.F.,"N")
Local cHrStart    := SuperGetMv("MV_CGSTART",.F.,"08:00")
Local dDtStart    := dDatabase
Local oEnable     := LoadBitmap( GetResources() ,"ENABLE"  )
Local oDisable    := LoadBitmap( GetResources() ,"DISABLE" )
Local oNoMarked   := LoadBitmap( GetResources() ,"LBNO"    )
Local oMarked     := LoadBitmap( GetResources() ,"LBOK"    )
Local oDlg
Local oProcess
Local oAllMark
Local nI          := 0
Local aHeadOrd    := {}
Local cAlias      := "TRBPED"
Local bBlockHead  := {||.T.}
Local aArrayFrt   := Array(9)
Local aColsFrt    := {}
Local aHeaderFrt  := {}
Local cGvCodOper  := ""
Local cGvNoProc   := ""
Local cGvPedComOp := ""
Local lFreteEmb   := .F.
Local aHeaderAdt  := {}
Local aColsAdt    := {}
Local aFretReg    := {}
Local aButtonBkp  := {}
Local cDakTransp  := Criavar("A4_COD",.F.)
Local cNTrans     := Criavar("A4_NREDUZ",.F.)
Local lDakTrp     := DAK->( FieldPos( "DAK_TRANSP" ) ) > 0
Local lTpOp       := DAK->( ColumnPos( "DAK_CDTPOP" ) ) > 0 .AND. DAK->( ColumnPos( "DAK_CDCLFR" ) ) > 0
Local cQrySC6     := ""
Local cSC6Alias   := ""

If DAK->( ColumnPos( "DAK_CDTPOP" ) ) > 0 .AND. DAK->( ColumnPos( "DAK_CDCLFR" ) ) > 0
	Private cDAKTpOp       := Criavar("DAK_CDTPOP",.F.) 
	Private cDAKClFr       := Criavar("DAK_CDCLFR",.F.)
Else
	Private cDAKTpOp       := "" 
	Private cDAKClFr       := ""
EndIf
Private lWmsPergEP := .T.

If lDakTrp
	Aadd(aButtons , { "TRANSP"   , { || Om200Trans(@aArrayMan,@cDakTransp,cNtrans,@aArrayCarga,oCargas)}, OemtoAnsi(STR0011),(STR0260)} ) //"Transp."
EndIf

If lTpOp
	aAdd(aButtons , { "TP_OPER." , { || Om200TpOper(@aArrayMan, @cDAKTpOp, @cDAKClFr, @aArrayCarga, oCargas)} , OemtoAnsi("Tipo Oper/ Class. Frete"),OemtoAnsi("Tipo Oper/ Class. Frete") })
EndIf

aArrayCli := {}

If Empty(cHrStart)
	cHrStart:="08:00"
EndIf
Pergunte("OMS200",.F.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Controle de botoes                                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ExistBlock("OS200BUT")
	aButtonUsr := ExecBlock("OS200BUT",.F.,.F.)
	If ValType(aButtonUsr)=="A" .And. Len(aButtonUsr) > 0
		For nI := 1 To Len(aButtonUsr)
			AAdd(aButtons,aClone(aButtonUsr[nI]))
		Next nI
	EndIf
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ PE - Deletar Elementos do aButtons                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ExistBlock("OS200DEA")
	aButtonBkp := aClone(aButtons)
	aButtons := ExecBlock("OS200DEA",.F.,.F.,{AButtons})
	If ValType(aButtons) != "A" .Or. Len(aButtons) <= 0
		aButtons := aClone(aButtonBkp)
	EndIf
EndIf

DbSelectArea("DAK")
DAK->(DbSetOrder(1))
dbClearFilter()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Traz janelas de perguntas e filtro para a montagem                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If	OmsFilTipo(@oMarked,@oNoMarked,aArrayMod,aArrayTipo)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Controle de botoes                                                     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If mv_par06 == 2
		AAdd(aButtons,{ "OMSDIVIDE",{ || u_FB200DivSC9("TRBPED",aArrayFrt,@aArrayMan,aFretReg,cMarca),oMark:oBrowse:Refresh()},STR0210,STR0209}) //"Divide item de pedido de venda liberado"###"Divide Item"
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Filtra pedidos e monta o mapa de cargas                                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If IsBlind()
		lEnd := OmsBuscaPed(@oEnable,@oDisable,@oMarked,@oNoMarked,@aCampos,cCarga,aArrayCarga,aArrayRota,aArrayZona,aArraySetor,aArrayMod,aArrayTipo,oProcess)
	Else
		oProcess := MsNewProcess():New({|lEnd| OmsBuscaPed(@oEnable,;
															@oDisable,;
															@oMarked,;
															@oNoMarked,;
															@aCampos,;
															cCarga,;
															aArrayCarga,;
															aArrayRota,;
															aArrayZona,;
															aArraySetor,;
															aArrayMod,;
															aArrayTipo,;
															oProcess)},"","",.F.)
		oProcess:Activate()
	Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se e por pedido ou item para alterar colunas na MsSelect      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	AAdd( aCpoBrw ,{"PED_MARCA"  , ,OemtoAnsi(" ")," "} )
	AAdd( aCpoBrw ,{"PED_ROTA"   , ,OemtoAnsi(STR0022)} ) //"Rota"
	AAdd( aCpoBrw ,{"PED_SEQROT" , ,OemtoAnsi(STR0027)} ) //"Entrega"
	AAdd( aCpoBrw ,{"PED_PEDIDO" , ,OemtoAnsi(STR0028)} ) //"Pedido"
	AAdd( aCpoBrw ,{"PED_ITEM"   , ,OemtoAnsi(STR0029)} ) //"Item"
	AAdd( aCpoBrw ,{"PED_SEQLIB" , ,OemtoAnsi(STR0116)} ) //"Seq. Liberacao"
	If	mv_par06 == 2
		AAdd( aCpoBrw ,{"PED_CODPRO" , ,OemtoAnsi(STR0013)} )//"Codigo"
		AAdd( aCpoBrw ,{"PED_DESPRO" , ,OemtoAnsi(STR0131)} )//"Produto"
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Inclui campo de filial origem caso o tipo de operacao use todas as filiais³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If	nTipoOper <> 1
		DbSelectArea("DAI")
		AAdd( aCpoBrw ,{"PED_FILORI" , ,RetTitle("DAI_FILIAL")} )
	EndIf
	AAdd( aCpoBrw ,{"PED_CODCLI" , ,OemtoAnsi(STR0030)} )//"Cliente"
	AAdd( aCpoBrw ,{"PED_LOJA"   , ,OemtoAnsi(STR0031)} )//"Loja"
	AAdd( aCpoBrw ,{"PED_NOME"   , ,OemtoAnsi(STR0032)} )//"Nome"
	AAdd( aCpoBrw ,{"PED_VALOR"  , ,OemtoAnsi(STR0016),"99999999."+Replicate("9",TamSx3("DAK_VALOR")[2])}  ) //"Valor"
	AAdd( aCpoBrw ,{"PED_VOLUM"  , ,OemtoAnsi(STR0034),"99999999."+Replicate("9",TamSx3("DAK_CAPVOL")[2])} ) //"Volume"
	AAdd( aCpoBrw ,{"PED_PESO"   , ,OemtoAnsi(STR0033),"99999999."+Replicate("9",TamSx3("DAK_PESO")[2])}   ) //"Qtde"
	AAdd( aCpoBrw ,{"PED_CARGA"  , ,OemtoAnsi(STR0014)} )//"Carga"
	AAdd( aCpoBrw ,{"PED_QTDLIB" , ,OemtoAnsi(STR0132)} )//"Quantidade"
	AAdd( aCpoBrw ,{"PED_EST"    , ,SA1->(RetTitle("A1_EST"))} ) //"Estado"
	AAdd( aCpoBrw ,{"PED_MUN"    , ,SA1->(RetTitle("A1_MUN"))} ) //"Municipio"
	AAdd( aCpoBrw ,{"PED_BAIRRO" , ,SA1->(RetTitle("A1_BAIRRO"))} ) //"Bairro"
	AAdd( aCpoBrw ,{"PED_CEP"    , ,SA1->(RetTitle("A1_CEP"))} ) //"CEP"
	AAdd( aCpoBrw ,{"PED_ENDCLI" , ,SA1->(RetTitle("A1_END"))} ) //"Endereço"

	If lFreteEmb
		AAdd( aCpoBrw ,{"PED_CDRDES" , ,SA1->(RetTitle("A1_CDRDES"))}  ) //"Codigo Regiao Destino"
		AAdd( aCpoBrw ,{"PED_TPFRET" , ,SC5->(RetTitle("C5_TPFRETE"))} ) //"Tipo Frete"
		AAdd( aCpoBrw ,{"PED_VALFRE" , ,RetTitle("DAI_VALFRE"),"99999999."+Replicate("9",TamSx3("DAI_VALFRE")[2])} ) //"Valor Frete"
		AAdd( aCpoBrw ,{"PED_FREAUT" , ,RetTitle("DAI_FREAUT"),"99999999."+Replicate("9",TamSx3("DAI_FREAUT")[2])} ) //"Valor Frete"
	EndIf

	If ExistBlock("DL200BRW")
		aRetPE := ExecBlock("DL200BRW",.F.,.F.,aCpoBrw)
		If ValType(aRetPE)=="A"
			aCpoBrw := aRetPE
		EndIf
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se e por pedido ou item para alterar a ordem na MsSelect      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If mv_par06 == 2
		aHeadOrd := {{3,3},{5,1},{8,5},{10,7},{18,8},{19,8}}
	Else
		aHeadOrd := {{3,3},{5,1},{8,7},{16,8},{17,8}}
	EndIf
	If ExistBlock("OM200ORD")
		aHeadOrd := ExecBlock("OM200ORD",.F.,.F.,aHeadOrd)
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Passo parametros para calculo da resolucao da tela                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aObjects := {}
	AAdd( aObjects ,{ 100 ,100 ,.T. ,.T. } )
	AAdd( aObjects ,{ 100 ,100 ,.T. ,.T. } )
	AAdd( aObjects ,{ 100 ,150 ,.T. ,.T. } )
	AAdd( aObjects ,{ 100 ,10  ,.T. ,.F. } )
	aInfo    := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 0, 0 }
	aPosObj1 := MsObjSize( aInfo, aObjects, .T. )
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Resolve as dimensoes dos objetos da parte esquerda da tela                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aObjects := {}
	AAdd( aObjects ,{ 100 ,100 ,.T. ,.T. ,.T. } )
	AAdd( aObjects ,{ 100 ,100 ,.T. ,.T. ,.T. } )
	aSize2 := aClone( aPosObj1[1] )
	aInfo    := { aSize2[ 2 ], aSize2[ 1 ], aSize2[ 4 ], aSize2[ 3 ], 3, 3  }
	aPosObj2 := MsObjSize( aInfo, aObjects, ,.T. )
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Resolve as dimensoes dos objetos da parte direita da tela                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aObjects := {}
	AAdd( aObjects ,{ 100 ,100 ,.T. ,.T. ,.T. } )
	AAdd( aObjects ,{ 100 ,100 ,.T. ,.T. ,.T. } )
	aSize3 := aClone( aPosObj1[2] )
	aInfo    := { aSize3[ 2 ], aSize3[ 1 ], aSize3[ 4 ], aSize3[ 3 ], 3, 3 }
	aPosObj3 := MsObjSize( aInfo, aObjects, ,.T. )
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Montagem da Interface                                                     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !l200Auto
		DEFINE MSDIALOG oDlg FROM aSize[7], 000 TO aSize[6], aSize[5] TITLE OemtoAnsi(STR0001) PIXEL //"Montagem de Carga"

		@ aPosObj2[1,1]+2,aPosObj2[1,2] Say OemtoAnsi(STR0074) OF oDlg PIXEL //"Cargas"
		@ aPosObj2[2,1]+2,aPosObj2[2,2] Say OemtoAnsi(STR0075) OF oDlg PIXEL //"Rotas"
		@ aPosObj3[1,1]+2,aPosObj3[1,2] Say OemtoAnsi(STR0076) OF oDlg PIXEL //"Zonas"
		@ aPosObj3[2,1]+2,aPosObj3[2,2] Say OemtoAnsi(STR0077) OF oDlg PIXEL //"Setores"
		@ aPosObj1[3,1]+2,aPosObj1[3,2] Say OemtoAnsi(STR0078) OF oDlg PIXEL //"Pedidos"

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Monta Listbox de Cargas                                             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		@ aPosObj2[1,1]+10,aPosObj2[1,2] LISTBOX oCargas VAR cVar ;
			Fields HEADER " ",;
			OemToAnsi(STR0013),; //"Codigo"
			OemtoAnsi(STR0014),; //"Carga"
			OemtoAnsi(STR0015),; //"Peso"
			OemtoAnsi(STR0016),; //"Valor"
			OemtoAnsi(STR0017),; //"Volume"
			OemtoAnsi(STR0246),; //"Qtde.1a.UM"
			OemtoAnsi(STR0018),; //"Ptos. Entrega"
			OemtoAnsi(STR0259),;  //"Transportadora"
			OemtoAnsi(STR0019),; //"Veiculo"
			OemtoAnsi(STR0069),; //"Motorista"
			OemtoAnsi(STR0092),; //"Ajudante 1"
			OemtoAnsi(STR0093),; //"Ajudante 2"
			OemtoAnsi(STR0094); //"Ajudante 3"
			SIZE aPosObj2[1,3],aPosObj2[1,4]-10 ;
			ON DBLCLICK (FBsTroca(0,;
			dDtStart,;
			cHrStart,;
			@aArrayCarga,;
			@aArrayRota,;
			@aArrayZona,;
			@aArraySetor,;
			@aArrayMan,;
			@aLock,;
			@oEnable,;
			@oDisable,;
			@oMarked,;
			@oNoMarked,;
			cMarca,;
			lAllMark,;
			,;
			aArrayFrt,;
			aFretReg,;
			aColsFrt,;
			aHeaderFrt,;
			aHeaderAdt,;
			aColsAdt,;
			cDakTransp,;
			cDAKTpOp,;
			cDAKClFr)) OF oDlg PIXEL
	
		If lFreteEmb
			AAdd( oCargas:aHeaders ,OemtoAnsi(STR0237) ) //"Peso CIF"
			AAdd( oCargas:aHeaders ,OemtoAnsi(STR0244) ) //"Qtde.CIF"
			AAdd( oCargas:aHeaders ,OemtoAnsi(STR0238) ) //"Volume CIF"
			AAdd( oCargas:aHeaders ,OemtoAnsi(STR0239) ) //"Valor CIF"
			AAdd( oCargas:aHeaders ,OemtoAnsi(STR0240) ) //"Peso FOB"
			AAdd( oCargas:aHeaders ,OemtoAnsi(STR0245) ) //"Qtde.FOB"
			AAdd( oCargas:aHeaders ,OemtoAnsi(STR0241) ) //"Volume FOB"
			AAdd( oCargas:aHeaders ,OemtoAnsi(STR0242) ) //"Valor FOB"
		EndIf
		oCargas:nFreeze := 1
		oCargas:SetArray(aArrayCarga)
		oCargas:bLine:={ ||{Iif(aArrayCarga[oCargas:nAT,CARGA_ENABLE],oEnable,oDisable),;
		aArrayCarga[oCargas:nAT,CARGA_COD],;
		aArrayCarga[oCargas:nAT,CARGA_DESC],;
		aArrayCarga[oCargas:nAT,CARGA_PESO],;
		aArrayCarga[oCargas:nAT,CARGA_VALOR],;
		aArrayCarga[oCargas:nAT,CARGA_VOLUM],;
		aArrayCarga[oCargas:nAT,CARGA_QTDLIB],;
		aArrayCarga[oCargas:nAT,CARGA_PTOENT],;
		aArrayCarga[oCargas:nAT,CARGA_TRANSP],;
		aArrayCarga[oCargas:nAT,CARGA_VEIC],;
		aArrayCarga[oCargas:nAT,CARGA_MOTOR],;
		aArrayCarga[oCargas:nAT,CARGA_AJUD1],;
		aArrayCarga[oCargas:nAT,CARGA_AJUD2],;
		aArrayCarga[oCargas:nAT,CARGA_AJUD3],;
		aArrayCarga[oCargas:nAT,CARGA_PESCIF],;
		aArrayCarga[oCargas:nAT,CARGA_QTDCIF],;
		aArrayCarga[oCargas:nAT,CARGA_VOLCIF],;
		aArrayCarga[oCargas:nAT,CARGA_VALCIF],;
		aArrayCarga[oCargas:nAT,CARGA_PESFOB],;
		aArrayCarga[oCargas:nAT,CARGA_QTDFOB],;
		aArrayCarga[oCargas:nAT,CARGA_VOLFOB],;
		aArrayCarga[oCargas:nAT,CARGA_VALFOB],;
		aArrayCarga[oCargas:nAT,CARGA_TPOP],;
		aArrayCarga[oCargas:nAT,CARGA_CLFR]}}
	Endif
		
	If !l200Auto
		//-- Ponto de entrada para adicionar campos na opcao Sequencia de Entrega.
		If	ExistBlock("OM200AD2")
			aRetCarga := ExecBlock("OM200AD2",.F.,.F.,{oCargas, oCargas:aArray, oCargas:aHeaders, oCargas:bLine, oEnable, oDisable})
			If	ValType(aRetCarga[1]) == "A" .And. ValType(aRetCarga[2]) == "A" .And. ValType(aRetCarga[3]) == "B"
				aArrayCarga			:= aRetCarga[1]
				oCargas:aHeaders	:= aRetCarga[2]
				oCargas:bLine		:= aRetCarga[3]
			EndIf
		EndIf

		oCargas:Refresh()
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Monta Listbox de Rotas                                              ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		@ aPosObj2[2,1]+10,aPosObj2[2,2] LISTBOX oRotas VAR cVar ;
			Fields HEADER " ",;
			" ",;
			OemToAnsi(STR0013),; //"Codigo"
			OemToAnsi(STR0020),; //"Descricao"
			OemToAnsi(STR0014); //"Carga"
			SIZE aPosObj2[2,3],aPosObj2[2,4]-10 ;
			ON DBLCLICK (FBsTroca(1,;
				dDtStart,;
				cHrStart,;
				@aArrayCarga,;
				@aArrayRota,;
				@aArrayZona,;
				@aArraySetor,;
				@aArrayMan,;
				@aLock,;
				@oEnable,;
				@oDisable,;
				@oMarked,;
				@oNoMarked,;
				cMarca,;
				lAllMark,;
				,;
				aArrayFrt,;
				aFretReg,;
				aColsFrt,;
				aHeaderFrt,;
				aHeaderAdt,;
				aColsAdt,;
				cDakTransp,;
				cDAKTpOp,;
				cDAKClFr)) OF oDlg PIXEL
	
		oRotas:nFreeze := 2
		oRotas:SetArray(aArrayRota)
		oRotas:bLine:={ ||{Iif(aArrayRota[oRotas:nAT,1],oEnable,oDisable),;
			Iif(aArrayRota[oRotas:nAT,2],oMarked,oNoMarked),;
						aArrayRota[oRotas:nAT,3],;
						aArrayRota[oRotas:nAT,4],;
						aArrayRota[oRotas:nAt,5]}}
		oRotas:cToolTip := OemToAnsi(STR0021) //"Duplo click para Habilitar/Desabilitar"
		oRotas:Refresh()
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Monta Listbox de Zonas                                              ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		@ aPosObj3[1,1]+10,aPosObj3[1,2] LISTBOX oZonas VAR cVar ;
			Fields HEADER " ",;
			" ",;
			OemtoAnsi(STR0022),; //"Rota"
			OemtoAnsi(STR0023),; //"Zona"
			OemToAnsi(STR0024),; //"Descricao da zona"
			OemToAnsi(STR0014);  //"Carga"
			SIZE aPosObj3[1,3],aPosObj3[1,4]-10 ;
			ON DBLCLICK (FBsTroca(2,;
			dDtStart,;
			cHrStart,;
			@aArrayCarga,;
			@aArrayRota,;
			@aArrayZona,;
			@aArraySetor,;
			@aArrayMan,;
			@aLock,;
			@oEnable,;
			@oDisable,;
			@oMarked,;
			@oNoMarked,;
			cMarca,;
			lAllMark,;
			,;
			aArrayFrt,;
			aFretReg,;
			aColsFrt,;
			aHeaderFrt,;
			aHeaderAdt,;
			aColsAdt,;
			cDakTransp,;
			cDAKTpOp,;
			cDAKClFr)) OF oDlg PIXEL
	
		oZonas:nFreeze := 2
		oZonas:SetArray(aArrayZona)
		oZonas:bLine:={ ||{Iif(aArrayZona[oZonas:nAT,1],oEnable,oDisable),;
			Iif(aArrayZona[oZonas:nAT,2],oMarked,oNoMarked),;
			aArrayZona[oZonas:nAT,3],;
			aArrayZona[oZonas:nAT,4],;
			aArrayZona[oZonas:nAT,5],;
			aArrayZona[oZonas:nAT,6]}}
		oZonas:cToolTip := OemToAnsi(STR0021) //"Duplo click para Habilitar/Desabilitar"
		oZonas:Refresh()
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Monta Listbox de Setor                                              ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		@ aPosObj3[2,1]+10,aPosObj3[2,2] LISTBOX oSetores VAR cVar ;
			Fields HEADER " ",;
			" ",;
			OemtoAnsi(STR0022),; //"Rota"
			OemtoAnsi(STR0023),; //"Zona"
			OemtoAnsi(STR0025),; //"Setor"
			OemToAnsi(STR0026),; //"Descricao do Setor"
			OemToAnsi(STR0014);  //"Carga"
			SIZE aPosObj3[2,3],aPosObj3[2,4]-10 ;
			ON DBLCLICK (FBsTroca(3,;
			dDtStart,;
			cHrStart,;
			@aArrayCarga,;
			@aArrayRota,;
			@aArrayZona,;
			@aArraySetor,;
			@aArrayMan,;
			@aLock,;
			@oEnable,;
			@oDisable,;
			@oMarked,;
			@oNoMarked,;
			cMarca,;
			lAllMark,;
			,;
			aArrayFrt,;
			aFretReg,;
			aColsFrt,;
			aHeaderFrt,;
			aHeaderAdt,;
			aColsAdt,;
			cDakTransp,;
			cDAKTpOp,;
			cDAKClFr)) OF oDlg PIXEL
	
		oSetores:nFreeze := 2
		oSetores:SetArray(aArraySetor)
		oSetores:bLine:={ ||{IIf(aArraySetor[oSetores:nAT,1],oEnable,oDisable),;
		Iif(aArraySetor[oSetores:nAT,2],oMarked,oNoMarked),;
		aArraySetor[oSetores:nAT,3],;
		aArraySetor[oSetores:nAT,4],;
		aArraySetor[oSetores:nAT,5],;
		aArraySetor[oSetores:nAT,6],;
		aArraySetor[oSetores:nAT,7]}}
		oSetores:cToolTip := OemToAnsi(STR0021) //"Duplo click para Habilitar/Desabilitar"
		oSetores:Refresh()
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Monta Listbox de Pedidos                                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	DbSelectArea("TRBPED")
	DbGoTop()
	
	Begin Transaction
	lDisrmTran := .T.
	
	If l200Auto 
	    aArrayMan := AClone(aAutoItens)
	    FBsTroca(4,dDtStart,cHrStart,aArrayCarga,aArrayRota,aArrayZona,aArraySetor,aArrayMan,aLock,@oEnable,@oDisable,@oMarked,@oNoMarked,cMarca,lAllMark,,aArrayFrt,aFretReg,aColsFrt,aHeaderFrt,aHeaderAdt,aColsAdt,cDakTransp, cDAKTpOp, cDAKClFr)
		
		cQrySC6 += " SELECT SUM(C6_VALOR) as C6_VALOR, SUM(C6_QTDVEN) as C6_QTDVEN FROM " + RetSqlName("SC6")
	   	cQrySC6 += " WHERE C6_NUM = '" + aArrayMan[1][5] + "' "
	   	cQrySC6 += " AND C6_FILIAL = '" + xFilial("SC6") + "' "
	   	cQrySC6 += " AND D_E_L_E_T_ = ' ' GROUP BY C6_NUM "
	   
	   	cQrySC6 := ChangeQuery( cQrySC6 ) 
	    
	   	cSC6Alias := GetNextAlias()
		
	   	dbUseArea( .T., "TOPCONN", TCGENQRY(,,ChangeQuery(cQrySC6)), cSC6Alias, .F., .T.)
		
	   	aArrayCarga[1][5]  := cValToChar((cSC6Alias)->C6_VALOR)
	   	aArrayCarga[1][7]  := cValToChar((cSC6Alias)->C6_QTDVEN)
	   
	   	(cSC6Alias)->(dbCloseArea())
	   
	    OmsCarrega(@oEnable,@oDisable,@oMarked,@oNoMarked,cMarca,@aArrayCarga,@aArrayRota,@aArrayZona,@aArraySetor,@aArrayMan,cHrStart,dDtStart,nSaveSx8,@aArrayFrt,@aHeaderFrt,@aColsFrt,cGvCodOper,cGvNoProc,cGvPedComOp,aHeaderAdt,aColsAdt,cDakTransp )
	       
	    nopca := 0
	Else 
		oMark :=MsSelect():New("TRBPED","PED_MARCA","PED_GERA == 'S'",aCpoBrw,.F.,@cMarca,{aPosObj1[3,1]+10,aPosObj1[3,2],aPosObj1[3,3]-3,aPosObj1[3,4]})
		
		If l200Auto
		   FBsTroca(4,dDtStart,cHrStart,aArrayCarga,aArrayRota,aArrayZona,aArraySetor,aArrayMan,aLock,@oEnable,@oDisable,@oMarked,@oNoMarked,cMarca,lAllMark,,aArrayFrt,aFretReg,aColsFrt,aHeaderFrt,aHeaderAdt,aColsAdt,cDakTransp, cDAKTpOp, cDAKClFr)
		Else
			oMark:bAval := {||FBsTroca(4,dDtStart,cHrStart,aArrayCarga,aArrayRota,aArrayZona,aArraySetor,aArrayMan,aLock,@oEnable,@oDisable,@oMarked,@oNoMarked,cMarca,lAllMark,,aArrayFrt,aFretReg,aColsFrt,aHeaderFrt,aHeaderAdt,aColsAdt,cDakTransp, cDAKTpOp, cDAKClFr)}
		Endif
		
		oMark:oBrowse:lhasMark    := .T.
		oMark:oBrowse:lCanAllmark := .T.
		oMark:oBrowse:bAllMark := {|| FBsTroca(4,dDtStart,cHrStart,aArrayCarga,aArrayRota,aArrayZona,aArraySetor,aArrayMan,aLock,@oEnable,@oDisable,@oMarked,@oNoMarked,cMarca,.F.,.T.,aArrayFrt,aFretReg,,,,,cDakTransp, cDAKTpOp, cDAKClFr)}
		bBlockHead := &("{|oBrw,nCol| OS200COrd(nCol,oBrw,aHeadOrd,cAlias),oMark:oBrowse:SetFocus(),oMark:oBrowse:Refresh()}")
		oMark:oBrowse:bHeaderClick:= bBlockHead
	
		If	cAlocPer == "S"
			OS200COrd(5,oMark:oBrowse,aHeadOrd,"TRBPED") //-- Ordem Pedido
		Else
			OS200COrd(3,oMark:oBrowse,aHeadOrd,"TRBPED") //-- Ordem Rota
		EndIf
	Endif
	
	If !l200Auto
		oMark:oBrowse:Refresh()
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica se  a montagem e por item para incluir checkbox            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		@ aPosObj1[3,3]+1,5 CheckBox oAllMark Var lAllMark Prompt OemtoAnsi(STR0062) Size 150,10 OF oDlg PIXEL //"Marca todos os itens do pedido selecionado"
		oAllMark:lVisibleControl := (mv_par06 == 2)

		ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar( oDlg, { || OmsCarrega(@oEnable,@oDisable,@oMarked,@oNoMarked,cMarca,@aArrayCarga,@aArrayRota,@aArrayZona,@aArraySetor,@aArrayMan,cHrStart,dDtStart,nSaveSx8,@aArrayFrt,@aHeaderFrt,@aColsFrt,cGvCodOper,cGvNoProc,cGvPedComOp,aHeaderAdt,aColsAdt,cDakTransp ) }, {||nopca := 0,oDlg:End()},,aButtons)
	Endif

	If lDisrmTran
		DisarmTransaction()
	EndIf
		
	End Transaction	

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Restaura a integridade da rotina                                    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	MsUnLockAll()
	If ( __lSx8 )
		RollBackSx8()
	EndIf
	//-- Ponto de entrada apos encerramento da rotina de montagem da carga.
	If ExistBlock("OM200ENC")
		ExecBlock("OM200ENC",.F.,.F.)
	EndIf
	
	If !l200Auto
		DbSelectArea("TRBPED")
		TRBPED->(DbCloseArea())
	Endif
	
	DbSelectArea("DAK")
	
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Restaura a integridade da rotina                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !l200Auto
	Eval(bFiltraBrw)
	DAK->(MsSeek(xFilial("DAK")))
	MbrChgLoop() //nao chama a tela de inclusao novamente
Endif

Return( .T. )

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³Os200VisCg³ Autor ³DL                     ³ Data ³02.03.2001  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Rotina de interface da visualizacao da carga                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpA1: Array da Carga                                         ³±±
±±³          ³ExpA2: Array dos Pedidos                                      ³±±
±±³          ³ExpC2: Hora de inicio da carga                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Materiais/Distribuicao/Logistica                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Atualizacoes sofridas desde a Construcao Inicial.                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Programador  ³ Data   ³ BOPS ³  Motivo da Alteracao                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function Os200VisCg(aArrayCarga,aArrayMan,cHrStart,dDtStart)

Local aArrayAnt  := aClone(aArrayMan)
Local aButtons   := {	{ "DOWN",       { || OmsTrocaSeq(@cHrStart,@dDtStart,cVeiculo,aArrayAnt,oPedMan,aObj,@lSeq,@cSeqAtual,@cSeqNova,1)},	STR0171, STR0127},; //"Sequencia anterior"
						{ "UP",         { || OmsTrocaSeq(@cHrStart,@dDtStart,cVeiculo,aArrayAnt,oPedMan,aObj,@lSeq,@cSeqAtual,@cSeqNova,2)},	STR0172, STR0128},; //"Sequencia posterior"
						{ "DESTINOS",   { || OmsTrocaSeq(@cHrStart,@dDtStart,cVeiculo,aArrayAnt,oPedMan,aObj,@lSeq,@cSeqAtual,@cSeqNova,3)},	STR0173, STR0129},; //"Mover para..."
						{ "CLOCK02",    { || u_FBsHrStart (@cHrStart,@dDtStart,cVeiculo,aArrayAnt,oPedMan,aObj,@lSeq,@cSeqAtual,@cSeqNova  )},	STR0174, STR0138},; //"Hora Inicial"###"Hr.Ini."
						{ "PESQUISA",   { || OmsVisRegra(aArrayAnt,oPedMan)},																	STR0175, STR0140},; //"Visualiza regra de entrega"
						{ "RELATORIO",  { || Oms200VLeg()}, OemtoAnsi(STR0007) }} //"Legenda"
Local aButtonUsr := {}
Local aObj       := {}
Local aSize      := MsAdvSize( .T. )
Local aPosObj1   := {}
Local aObjects   := {}
Local nSeqInc    := SuperGetMV("MV_OMSENTR",.F.,5)
Local nSequencia := 0
Local nOpcA      := 0
Local nC         := 0
Local nPosCarga  := Ascan(aArrayCarga,{|x| x[CARGA_ENABLE] == .T.})
Local cCarga     := ""
Local cVar       := ""
Local cSeqAtual  := ""
Local cSeqNova   := ""
Local cVeiculo   := ""

Local lSeq       := .F.

Local oDlgman
Local oPedMan
Local oSayNewSeq
Local oNewSeq
Local oSaySeqAtu
Local oSeqAtual
Local oMenu
Local oDown      := LoadBitmap( GetResources(), "TRIDOWN"  )
Local oUp        := LoadBitmap( GetResources(), "TRIUP"    )
Local oLiberado  := LoadBitmap( GetResources(), "PMSTASK4" )
Local oCalend    := LoadBitmap( GetResources(), "PMSTASK1" )
Local oHorario   := LoadBitmap( GetResources(), "PMSTASK2" )
Local oVeiculo   := LoadBitmap( GetResources(), "PMSTASK3" )
Local oSayCli
Local oSayEnd
Local oSayChP
Local oSayTmSrv
Local oSaySdP
Local oSayBai
Local oSayEst
Local oSayMun
Local oSayCep
Local aRetPE     := {}

//-- Verifica os pedidos marcados
If !Len( aArrayAnt ) == 0 .And. nPosCarga > 0
	//-- Permite incluir botoes
	If ExistBlock("OS200VSB")
		aButtonUsr := ExecBlock("OS200VSB",.F.,.F.)
		If ValType(aButtonUsr)=="A" .And. Len(aButtonUsr) > 0
			For nC := 1 To Len(aButtonUsr)
				AAdd(aButtons,aClone(aButtonUsr[nC]))
			Next nC
		EndIf
	EndIf
	//-- Obtem o numero da carga
	cCarga    := aArrayCarga[nPosCarga,CARGA_COD]
	cVeiculo  := aArrayCarga[nPosCarga,CARGA_VEIC]
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Dimensoes da matriz   ³
	//³[1]Ativo              ³
	//³[2]Marcado            ³
	//³[3]Rota               ³
	//³[4]Zona               ³
	//³[5]Setor              ³
	//³[6]Sequencia na Rota  ³
	//³[7]Pedido             ³
	//³[8]Item               ³
	//³[9]Cliente            ³
	//³[10Loja               ³
	//³[11]Nome              ³
	//³[12]Peso              ³
	//³[13]Carga             ³
	//³[14]Sequencia no Setor³
	//³[15]Sequencia final   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	//-- Renumera a sequencia de entrega considerando intervalo conforme parametro: MV_OMSENTR
	nSeqInc := IIF(nSeqInc > 0,nSeqInc,5)
	For nC := 1 to Len(aArrayAnt)
		nSequencia += nSeqInc
		aArrayAnt[nC,1] := StrZero(nSequencia,6)
	Next nC

	//-- Atualiza as horas de entrega
	FBs200Time(cHrStart,dDtStart,aArrayAnt,cVeiculo,12,6,7,2,3,4,14,15,16,17,18,19,20)

	//-- Montagem da Interface
	aObjects := {}
	AAdd( aObjects, { 100 ,100 ,.T. ,.T. ,.T.	} )
	AAdd( aObjects, { 100 ,50  ,.T. ,.F.     	} )

	aInfo    := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 0, 0 }
	aPosObj1 := MsObjSize( aInfo, aObjects)

	DEFINE MSDIALOG oDlgMan FROM aSize[7], 000 TO aSize[6],aSize[5] TITLE OemtoAnsi(STR0035+cCarga) OF oMainWnd PIXEL //"Sequencia da Carga "

	@ 013,233 TO 075,317 OF oDlgMan Pixel

	@ 017,(aSize[5]/2)-75 Say oSaySeqAtu Prompt OemToAnsi(STR0045) Size 50,10 OF oDlgMan Pixel //"Seq. Atual" //235
	@ 030,(aSize[5]/2)-75 MSGet oSeqAtual VAR cSeqAtual Picture "999999"  When .F. Size 30,10 OF oDlgMan Pixel //285

	@ 052,(aSize[5]/2)-75 Say oSayNewSeq Prompt OemToAnsi(STR0046) Size 50,10 OF oDlgMan Pixel //"Nova Seq."
	@ 065,(aSize[5]/2)-75 MSGet oNewSeq VAR cSeqNova Picture "999999"  Valid OmsVldSeq(cSeqNova,aArrayAnt[oPedMan:nAt,2]) When .T. Size 30,10 OF oDlgMan Pixel

	DEFINE SBUTTON oButton1 FROM 90,(aSize[5]/2)-75 TYPE 1 ACTION OmsTrocaSeq(cHrStart,dDtStart,cVeiculo,aArrayAnt,oPedMan,aObj,@lSeq,@cSeqAtual,@cSeqNova,5) ENABLE OF oDlgMan
	DEFINE SBUTTON oButton2 FROM 90,(aSize[5]/2)-45 TYPE 2 ACTION OmsTrocaSeq(cHrStart,dDtStart,cVeiculo,aArrayAnt,oPedMan,aObj,@lSeq,@cSeqAtual,@cSeqNova,4) ENABLE OF oDlgMan

	AAdd( aObj ,oSaySeqAtu )
	AAdd( aObj ,oSeqAtual  )
	AAdd( aObj ,oSayNewSeq )
	AAdd( aObj ,oNewSeq    )
	AAdd( aObj ,oButton1   )
	AAdd( aObj ,oButton2   )

	aEval(aObj,{|x| x:hide()})

	//-- ListBox dos pedido
	@ aPosObj1[1,1],aPosObj1[1,2] LISTBOX oPedMan VAR cVar Fields HEADER OemtoAnsi(" "),OemtoAnsi(" "),OemtoAnsi(" "),;
		OemtoAnsi(STR0036),; //"Sequencia"
		OemtoAnsi(STR0022),; //"Rota"
		OemtoAnsi(STR0028),; //"Pedido"
		OemtoAnsi(STR0150),; //"Data Chegada"
		OemtoAnsi(STR0133),; //"Chegada Prevista"
		OemtoAnsi(STR0134),; //"Time Service"
		OemtoAnsi(STR0151),; //"Data Saida"
		OemtoAnsi(STR0030),; //"Cliente"
		OemtoAnsi(STR0031),; //"Loja"
		OemToAnsi(STR0032),; //"Nome"
		OemToAnsi(STR0108),; //"Bairro"
		OemToAnsi(STR0109),; //"Cidade"
		OemToAnsi(STR0110) ; //"UF"
		SIZE aPosObj1[1,3],aPosObj1[1,4] OF oDlgMan PIXEL
	oPedMan:SetArray(aArrayAnt)

	oPedMan:bLine:={||{	Iif(aArrayAnt[oPedMan:nAT,18]==1,oLiberado,;
						Iif(aArrayAnt[oPedMan:nAT,18]==2,oVeiculo,;
						Iif(aArrayAnt[oPedMan:nAT,18]==3,oHorario,;
						Iif(aArrayAnt[oPedMan:nAT,18]==4,oCalend,oLiberado)))),;
						oDown, oUp,;
						aArrayAnt[oPedMan:nAT, 1],;
						aArrayAnt[oPedMan:nAT, 2],;
						aArrayAnt[oPedMan:nAT, 5],;
						aArrayAnt[oPedMan:nAT,19],;
						aArrayAnt[oPedMan:nAT,16],;
						aArrayAnt[oPedMan:nAT,17],;
						aArrayAnt[oPedMan:nAT,20],;
						aArrayAnt[oPedMan:nAT, 6],;
						aArrayAnt[oPedMan:nAT, 7],;
						aArrayAnt[oPedMan:nAT, 8],;
						aArrayAnt[oPedMan:nAT, 9],;
						aArrayAnt[oPedMan:nAT,10],;
						aArrayAnt[oPedMan:nAT,11],;
						aArrayAnt[oPedMan:nAT,21],;
						aArrayAnt[oPedMan:nAT,22],;
						aArrayAnt[oPedMan:nAT,23],;
						aArrayAnt[oPedMan:nAT,24]}}

	//-- Ponto de entrada para adicionar campos na opcao Sequencia de Entrega.
	If	ExistBlock("OM200ADC")
		aRetPE := ExecBlock("OM200ADC",.F.,.F.,{oPedMan:aArray, oPedMan:aHeaders, oPedMan:bLine, oLiberado, oCalend, oHorario, oVeiculo})
		If	ValType(aRetPE[1]) == "A" .And. ValType(aRetPE[2]) == "A" .And. ValType(aRetPE[3]) == "B"
			oPedMan:aArray		:= aRetPE[1]
			oPedMan:aHeaders	:= aRetPE[2]
			oPedMan:bLine		:= aRetPE[3]
		EndIf
	EndIf

	//-- Rodape da janela
	@ aPosObj1[2,1]+2, aPosObj1[2,2] TO aPosObj1[2,3], aPosObj1[2,4] LABEL OemToAnsi(STR0137) OF oDlgMan PIXEL //"Dados da Entrega"

	@ aPosObj1[2,1]+10,05  Say OemtoAnsi(STR0030)+":"	SIZE 040,08 OF oDlgMan PIXEL //"Cliente: "
	@ aPosObj1[2,1]+10,30  Say oSayCli Prompt ""		SIZE 300,08 OF oDlgMan PIXEL

	@ aPosObj1[2,1]+20,05  Say OemtoAnsi(STR0114)+":"	SIZE 060,08 OF oDlgMan PIXEL //"Endereco:"
	@ aPosObj1[2,1]+20,30  Say oSayEnd Prompt ""		SIZE 300,08 OF oDlgMan PIXEL

	@ aPosObj1[2,1]+20,170 Say OemtoAnsi(STR0108)+":"	SIZE 060,08 OF oDlgMan PIXEL //"Bairro"
	@ aPosObj1[2,1]+20,210 Say oSayBai Prompt ""		SIZE 300,08 OF oDlgMan PIXEL

	@ aPosObj1[2,1]+30,05  Say OemtoAnsi(STR0109)+":"	SIZE 060,08 OF oDlgMan PIXEL //"Cidade"
	@ aPosObj1[2,1]+30,30  Say oSayMun Prompt ""		SIZE 300,08 OF oDlgMan PIXEL

	@ aPosObj1[2,1]+30,90  Say OemtoAnsi(STR0110)+":"	SIZE 060,08 OF oDlgMan PIXEL //"Estado"
	@ aPosObj1[2,1]+30,120 Say oSayEst Prompt ""		SIZE 040,08 OF oDlgMan PIXEL

	@ aPosObj1[2,1]+30,170 Say OemtoAnsi(STR0136)+":"	SIZE 060,08 OF oDlgMan PIXEL //"Cep"
	@ aPosObj1[2,1]+30,210 Say oSayCep Prompt ""		SIZE 040,08 OF oDlgMan PIXEL

	@ aPosObj1[2,1]+40,05  Say OemtoAnsi(STR0133)+":"	SIZE 060,08 OF oDlgMan PIXEL //"Chegada Prevista:"
	@ aPosObj1[2,1]+40,50  Say oSayChP Prompt ""		SIZE 040,08 OF oDlgMan PIXEL

	@ aPosObj1[2,1]+40,90  Say OemtoAnsi(STR0134)+":"	SIZE 060,08 OF oDlgMan PIXEL //"Time Service:"
	@ aPosObj1[2,1]+40,125 Say oSayTmSrv Prompt ""		SIZE 040,08 OF oDlgMan PIXEL

	@ aPosObj1[2,1]+40,170 Say OemtoAnsi(STR0135)+":"	SIZE 060,08 OF oDlgMan PIXEL //"Saida Prevista"
	@ aPosObj1[2,1]+40,210 Say oSaySdP Prompt ""		SIZE 040,08 OF oDlgMan PIXEL

	oPedMan:bLDblClick := { |oObj,nCol|	IIF(nCol==2,OmsTrocaSeq(@cHrStart,@dDtStart,cVeiculo,aArrayAnt,oPedMan,aObj,@lSeq,@cSeqAtual,@cSeqNova,1),;
										IIF(nCol==3,OmsTrocaSeq(@cHrStart,@dDtStart,cVeiculo,aArrayAnt,oPedMan,aObj,@lSeq,@cSeqAtual,@cSeqNova,2),Nil)) }
	oPedMan:bChange  := {|| Oms200Msg(aArrayAnt,oPedMan,oSayCli,oSayEnd,oSayBai,oSayMun,oSayEst,oSayCep,oSayChP,oSayTmSrv,oSaySdP) }
	oPedMan:Refresh()

	//--                              EnchoiceBar(oDlg,bOk,bCancel,lMessageDel,aButtons,nReg,cAlias,lMashups,lImpCad,lPadrao,lHasOk)
	ACTIVATE MSDIALOG oDlgMan ON INIT EnchoiceBar( oDlgMan, { || nOpca := 1,oDlgMan:End()}, {||oDlgMan:End()},,aButtons,,,.F.,.F.,.F.,)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Atualizo o Array principal                                               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If nOpca == 1
		aArrayMan := aClone(aArrayAnt)
	EndIf
Else
	Help(" ",1,"OMSPEDMARK") //Nao existem pedidos marcados
EndIf

Return( .T. )

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³OmsVisRegra³ Autor ³DL                    ³ Data ³22.07.2002  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Rotina de visualizacao das regras de entrega do cliente       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpA1: Array com os dados dos clientes                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Materiais/Distribuicao/Logistica                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Atualizacoes sofridas desde a Construcao Inicial.                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Programador  ³ Data   ³ BOPS ³  Motivo da Alteracao                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function OmsVisRegra(aArrayAnt,oPedMan)

Local aArea     := GetArea()
Local aAreaSA1  := SA1->(GetArea())
Local lIncluiBk := INCLUI

INCLUI := .F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica se existe janela de entrega para o cliente ou grupo        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SA1->(DbSetOrder(1))
If SA1->(MsSeek(OsFilial("SA1",aArrayAnt[oPedMan:nAt][12])+aArrayAnt[oPedMan:nAt][6]+aArrayAnt[oPedMan:nAt][7] ))
	DAD->(DbSetOrder(2))
	If DAD->(MsSeek(xFilial("DAD")+Space(Len(SA1->A1_GRPVEN))+aArrayAnt[oPedMan:nAt][6]+aArrayAnt[oPedMan:nAt][7]))
		Oms120Mnt("DAD", DAD->(Recno()), 2)
	Else
		If DAD->(MsSeek(xFilial("DAD")+SA1->A1_GRPVEN+Space(Len(SA1->A1_COD))+Space(Len(SA1->A1_LOJA))))
			Oms120Mnt("DAD", DAD->(Recno()), 2)
		Else
			Help(" ",1,"OMS200REGR") //Não existem regras de entrega para este cliente.
		EndIf
	EndIf
EndIf

INCLUI := lIncluiBk

RestArea( aAreaSA1 )
RestArea( aArea    )

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³Oms200VLeg³ Autor ³ DL                    ³ Data ³23/01/2001³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo ³ Exibe a legenda dos status do pedido                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nil                                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function Oms200VLeg()
Local aLegenda := {	{ "PMSTASK4" ,OemToAnsi(STR0142) },; //"Entrega permitida"
					{ "PMSTASK1" ,OemToAnsi(STR0143) },; //"Restricao por calendario"
					{ "PMSTASK2" ,OemToAnsi(STR0144) },; //"Restricao por horario"
					{ "PMSTASK3" ,OemToAnsi(STR0145) } } //"Restricao por veiculo"
BrwLegenda(cCadastro, OemToAnsi(STR0146), aLegenda) //"Status"

Return( Nil )

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³OmsHrStart³ Autor ³DL                     ³ Data ³02.03.2001  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Rotina alteracao da hora de inicio da entrega                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpA1: Array da Carga                                         ³±±
±±³          ³ExpA2: Array dos Pedidos                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Materiais/Distribuicao/Logistica                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Atualizacoes sofridas desde a Construcao Inicial.                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Programador  ³ Data   ³ BOPS ³  Motivo da Alteracao                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function FBsHrStart(cHrStart,dDtStart,cVeiculo,aArrayAnt,oPedMan,aObj,lSeq,cSeqAtual,cSeqNova)

Local nOpca   := 0
Local cNewHr  := cHrStart
Local dNewDt  := dDtStart
Local cBitmap := "PROJETOAP"

DEFINE MSDIALOG oDlg TITLE OemtoAnsi(STR0139) From 0,0 To 120,280 OF oMainWnd PIXEL //"Hora Inicial da Entrega"

@ 0 , 0 BITMAP oBmp RESNAME cBitMap OF oDlg SIZE 48,488 NOBORDER WHEN .F. PIXEL

@ 005,055 Say OemtoAnsi(STR0138) OF oDlg PIXEL SIZE 45,10 //"Hora Inicial"
@ 005,088 MSGET cNewHr OF oDlg Valid OmsVldHr(cNewHr) PIXEL SIZE 34,10 Picture "99:99"

@ 020,055 Say OemtoAnsi(STR0070) Of oDlg PIXEL SIZE 45,10 //"Data"
@ 020,088 MSGET dNewDt OF oDlg Valid OmsVldHr(cNewHr) PIXEL SIZE 41,10

DEFINE SBUTTON FROM 045, 067 TYPE 1 ENABLE OF oDlg ACTION( nOpcA := 1,oDlg:End())
DEFINE SBUTTON FROM 045, 097 TYPE 2 ENABLE OF oDlg ACTION( oDlg:End())

ACTIVATE DIALOG oDlg Centered

If nOpca ==1
	cHrStart := cNewHr
	dDtStart := dNewDt
	OmsTrocaSeq(cHrStart,dDtStart,cVeiculo,aArrayAnt,oPedMan,aObj,.T.,cSeqAtual,cSeqNova,6)
EndIf

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³Oms200Msg ³ Autor ³DL                     ³ Data ³02.03.2001  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Rotina de mensagem do rodape da sequencia de carga            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpA1: Array da Carga                                         ³±±
±±³          ³ExpO2: Objeto do ListBox                                      ³±±
±±³          ³ExpO3: Objeto do Cliente                                      ³±±
±±³          ³ExpO4: Objeto do Endereco                                     ³±±
±±³          ³ExpO5: Objeto da chegada prevista                             ³±±
±±³          ³ExpO6: Objeto dO TIME SERVICE                                 ³±±
±±³          ³ExpO7: Objeto da SAIDA PREVISTA                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Materiais/Distribuicao/Logistica                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Atualizacoes sofridas desde a Construcao Inicial.                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Programador  ³ Data   ³ BOPS ³  Motivo da Alteracao                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function Oms200Msg(aArrayAnt,oPedMan,oSayCli,oSayEnd,oSayBai,oSayMun,oSayEst,oSayCep,oSayChP,oSayTmSrv,oSaySdP)

Local aArea    := GetArea()
Local aAreaSA1 := SA1->(GetArea())

DbSelectArea("SC5")
SC5->(DbSetOrder(1)) //C5_FILIAL+C5_NUM
MsSeek(OsFilial("SC5",aArrayAnt[oPedMan:nAt][12])+aArrayAnt[oPedMan:nAt][05])

If !SC5->C5_TIPO$'DB'
	SA1->(DbSetOrder(1)) //A1_FILIAL+A1_COD+A1_LOJA
	If SA1->(MsSeek(OsFilial("SA1",aArrayAnt[oPedMan:nAt][12])+aArrayAnt[oPedMan:nAt][6]+aArrayAnt[oPedMan:nAt][7]))
		oSayCli:SetText(aArrayAnt[oPedMan:nAt][6]+"-"+aArrayAnt[oPedMan:nAt][7]+"   "+SA1->A1_NOME)
		Do Case
		Case SuperGetMv("MV_ROTCEP",.F.,"1") == "1"
			oSayEnd:SetText(Alltrim(SA1->A1_END))
			oSayBai:SetText(SA1->A1_BAIRRO)
			oSayMun:SetText(SA1->A1_MUN)
			oSayEst:SetText(SA1->A1_EST)
			oSayCep:SetText(SA1->A1_CEP)
		Case SuperGetMv("MV_ROTCEP",.F.,"1") == "2"
			oSayEnd:SetText(IIf(Empty(Alltrim(SA1->A1_ENDENT)),Alltrim(SA1->A1_END),Alltrim(SA1->A1_ENDENT)))
			oSayBai:SetText(IIf(Empty(SA1->A1_BAIRROE),SA1->A1_BAIRRO,SA1->A1_BAIRROE))
			oSayMun:SetText(IIf(Empty(SA1->A1_MUNE),SA1->A1_MUN,SA1->A1_MUNE))
			oSayEst:SetText(IIf(Empty(SA1->A1_ESTE),SA1->A1_EST,SA1->A1_ESTE))
			oSayCep:SetText(IIf(Empty(SA1->A1_CEPE),SA1->A1_CEP,SA1->A1_CEPE))
		Case SuperGetMv("MV_ROTCEP",.F.,"1") == "3"
			oSayEnd:SetText(Alltrim(SA1->A1_ENDENT))
			oSayBai:SetText(SA1->A1_BAIRROE)
			oSayMun:SetText(SA1->A1_MUNE)
			oSayEst:SetText(SA1->A1_ESTE)
			oSayCep:SetText(SA1->A1_CEPE)
		EndCase
	EndIf
Else
	SA2->(DbSetOrder(1))
	If SA2->(MsSeek(OsFilial("SA2",aArrayAnt[oPedMan:nAt][12])+aArrayAnt[oPedMan:nAt][6]+aArrayAnt[oPedMan:nAt][7]))
		oSayCli:SetText(aArrayAnt[oPedMan:nAt][6]+"-"+aArrayAnt[oPedMan:nAt][7]+"   "+SA2->A2_NOME)
		oSayEnd:SetText(Alltrim(SA2->A2_END))
		oSayBai:SetText(SA2->A2_BAIRRO)
		oSayMun:SetText(SA2->A2_MUN)
		oSayEst:SetText(SA2->A2_EST)
		oSayCep:SetText(SA2->A2_CEP)
	EndIf
EndIf
oSayChP:SetText(aArrayAnt[oPedMan:nAt][16])
oSayTmSrv:SetText(aArrayAnt[oPedMan:nAt][17])
oSaySdP:SetText(IntToHora(HoraToInt(aArrayAnt[oPedMan:nAt][16],2)+HoraToInt(aArrayAnt[oPedMan:nAt][17],4),2))

RestArea( aAreaSA1 )
RestArea( aArea    )

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³Os200VisCF³ Autor ³DL                     ³ Data ³17.01.2001  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Rotina de interface da visualizacao de cliente/fornecedor     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Materiais/Distribuicao/Logistica                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Atualizacoes sofridas desde a Construcao Inicial.                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Programador  ³ Data   ³ BOPS ³  Motivo da Alteracao                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function FB200VisCF()

Local aArea     := GetArea()
Local aAreaSC5  := SC5->(GetArea())
Local aAreaSA1  := SA1->(GetArea())
Local aAreaSA2  := SA2->(GetArea())
Local cAliasArq := ""
Local cSavFil   := cFilAnt
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica a filial correta do Pedido de Venda                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If OsVlEntCom() <> 1
	cFilAnt := TRBPED->PED_FILORI
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica-se se o pedido eh para um cliente ou Fornecedor                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DbSelectArea("SC5")
SC5->(DbSetOrder(1))
If MsSeek(OsFilial("SC5",TRBPED->PED_FILORI)+TRBPED->PED_PEDIDO)
	If SC5->C5_TIPO == "B".Or. SC5->C5_TIPO == "D"
		cAliasArq := "SA2"
	Else
		cAliasArq := "SA1"
	EndIf
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Montagem da Interface                                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If !Empty(cAliasArq)

	DbSelectArea(cAliasArq)
	DbSetOrder(1)
	If MsSeek(OsFilial(cAliasArq,TRBPED->PED_FILORI)+TRBPED->PED_CODCLI+TRBPED->PED_LOJA)
		AxVisual(cAliasArq,Recno(),2)
	EndIf

EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Restaura a integridade da rotina                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cFilAnt := cSavFil
RestArea( aAreaSC5 )
RestArea( aAreaSA1 )
RestArea( aAreaSA2 )
RestArea( aArea    )

Return( .T. )

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³Os200VisPv³ Autor ³DL                     ³ Data ³17.01.2001  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Rotina de interface da visualizacao do Pedido de Venda        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Materiais/Distribuicao/Logistica                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Atualizacoes sofridas desde a Construcao Inicial.                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Programador  ³ Data   ³ BOPS ³  Motivo da Alteracao                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function Os200VisPv()
Local aArea   := GetArea()
Local cSavFil := cFilAnt
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica a filial correta do Pedido de Venda                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If	OsVlEntCom() <> 1
	cFilAnt := TRBPED->PED_FILORI
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Montagem da interface                                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DbSelectArea("SC5")
SC5->(DbSetOrder(1))
If	MsSeek(OsFilial("SC5",TRBPED->PED_FILORI)+TRBPED->PED_PEDIDO)
	A410Visual("SC5",Recno(),2)
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Carrega perguntas do OMSA200 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Pergunte("OMS200",.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Restaura a integridade da rotina                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cFilAnt := cSavFil
RestArea( aArea )

Return( .T. )

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³OmsTroca  ºAutor  ³DL                  º Data ³  12/26/00   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Marca e valida as amarracoes da geracao de carga           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³ nEscolha - Analisa o listbox escolhido                     º±±
±±º          ³ aArrayCarga - aArray de cargas passado por referencia      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP5                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function FBsTroca(nEscolha,dDtStart,cHrStart,aArrayCarga,aArrayRota,aArrayZona,aArraySetor,aArrayMan,aLock,oEnable,oDisable,oMarked,oNoMarked,cMarca,lPedMark,lAllMark,aArrayFrt,aFretReg,aColsFrt,aHeaderFrt,aHeaderAdt,aColsAdt,cDakTransp, cDAKTpOp, cDAKClFr)
Local aArea      := GetArea()
Local aAreaTRB   := TRBPED->(GetArea())
Local cCarga     := ""
Local lTroca     := .F.
Local nPosMan    := 0
Local cBusca     := ""
Local nPosCarga  := 0
Local cPictVal   := "99999999." + Replicate("9",TamSx3("DAK_VALOR")[2])
Local cPictVol   := "99999999." + Replicate("9",TamSx3("DAK_CAPVOL")[2])
Local cPictPeso  := "99999999." + Replicate("9",TamSx3("DAK_PESO")[2])
Local cPictQtde  := "99999999." + Replicate("9",TamSx3("C9_QTDLIB")[2])
Local aArrayPto  := {}
Local nPtoEntr   := 0
Local nPesoItem  := 0
Local nVolItem   := 0
Local nValorItem := 0
Local nQtdItem   := 0
Local nPesoCIF   := 0
Local nVolCIF    := 0
Local nValorCIF  := 0
Local nQtdCIF    := 0
Local nPesoFOB   := 0
Local nVolFOB    := 0
Local nValorFOB  := 0
Local nQtdFOB    := 0
Local nC0        := 0
Local nC1        := 0
Local nC2        := 0
Local nC3        := 0
Local lSomaCarga := .T.
Local lAbatCarga := .T.
Local lDelMan    := .F.
Local cAlocPer   := SuperGetMv("MV_ALOCPER",.F.,"N")
Local lFreteEmb  := .F.
Local cVeiculo   := ""
Local cSeekPed   := ""
Local cWhile     := "PED_ROTA+PED_ZONA+PED_SETOR"
Local cRota      := ""
Local cZona      := ""
Local cSetor     := ""
Local lMarca     := .T.
Local nOrder     := 4 //-- PED_ROTA+PED_ZONA+PED_SETOR+PED_FILORI+PED_FILORI+PED_PEDIDO
Local nMultiplic := 0
Local aPesqRota  := {}
Local aRetPE     := {}
Local lOM200MRC  := ExistBlock("OM200MRC")
Local cCpoCapac  := IIf(SuperGetmv("MV_OMSCAPA",.F.,"1")=="1","DA3_CAPACN","DA3_CAPACM")
Local nCapac     := 0
Local nPosRotAlt := 0

Default lAllMark  := .F.
Default aArrayFrt := Array(9)
Default aFretReg  := {}
Default cDakTransp:= Criavar("A4_COD",.F.)
If DAK->( ColumnPos( "DAK_CDTPOP" ) ) > 0 .AND. DAK->( ColumnPos( "DAK_CDCLFR" ) ) > 0
	Default cDAKTpOp  := Criavar("DAK_CDTPOP",.F.)
	Default cDAKClFr  := Criavar("DAK_CDCLFR",.F.)
Else
	Default cDAKTpOp  := ""
	Default cDAKClFr  := ""
EndIf


//-- Verifico se existe carga disponivel aberta
nPosCarga := Ascan(aArrayCarga,{|x| x[CARGA_ENABLE] == .T.})
If nPosCarga == 0
	Help(" ",1,"DLACGDISP") //Nao existe carga disponivel aberta
	Return
Else
	cCarga := aArrayCarga[nPosCarga,CARGA_COD]
	cVeiculo  := aArrayCarga[nPosCarga,CARGA_VEIC]
EndIf

If !l200Auto
	oRotas:lDisablePaint        := .T.
	oZonas:lDisablePaint        := .T.
	oSetores:lDisablePaint      := .T.
	oMark:oBrowse:lDisablePaint := .T.
Endif

If	nEscolha == 4
	//-- Verifico se o total da carga esta fechado com a capacidade do caminhao se parametro considerar restricoes
	If !Empty(cVeiculo)
		Pergunte("OMS200",.F.) //Parametro da Montagem de Cargas
		If	mv_par05 == 1 .And. TRBPED->PED_MARCA <> cMarca
			DA3->(DbSetOrder(1))
			If	DA3->(MsSeek(xFilial("DA3")+cVeiculo))
				nCapac := DA3->(FieldGet(FieldPos(cCpoCapac)))
				If	(Val(aArraycarga[oCargas:nAt,CARGA_PESO]) + TRBPED->PED_PESO > nCapac).Or.;
					(Val(aArrayCarga[oCargas:nAt,CARGA_VOLUM]) + TRBPED->PED_VOLUM > DA3->DA3_VOLMAX).Or.;
					(Val(aArrayCarga[oCargas:nAt,CARGA_PTOENT]) + 1 > DA3->DA3_LIMMAX)
					Help(" ",1,"OMSULTCARG") //Caminhao nao suporta carga montada
					oRotas:lDisablePaint        := .F.
					oZonas:lDisablePaint        := .F.
					oSetores:lDisablePaint      := .F.
					oMark:oBrowse:lDisablePaint := .F.
					Return (.F.)
				EndIf
			EndIf
		EndIf
	EndIf
	If	TRBPED->PED_GERA == "N" .And. Oms200Lock(TRBPED->PED_FILORI,TRBPED->PED_PEDIDO, aLock, (TRBPED->PED_MARCA <> cMarca),cMarca, nEscolha)
		cRota  := TRBPED->PED_ROTA
		cZona  := TRBPED->PED_ZONA
		cSetor := TRBPED->PED_SETOR
		RecLock("TRBPED",.F.)
		TRBPED->PED_MARCA  := Iif(TRBPED->PED_MARCA <> cMarca, cMarca, "  ")
		TRBPED->PED_CARGA  := Iif(TRBPED->PED_MARCA == cMarca, cCarga, "ZZZZZZ")
		If	lFreteEmb
			TRBPED->PED_VALFRE := Iif(TRBPED->PED_MARCA == cMarca,TRBPED->PED_VALFRE,0)
			TRBPED->PED_FREAUT := Iif(TRBPED->PED_MARCA == cMarca,TRBPED->PED_FREAUT,0)
		EndIf
		//-- Verifico se existe no array de sequencia e incluo ou excluo caso a opcao escolhida pelo usuario
		cBusca  := TRBPED->(PED_PEDIDO+PED_CODCLI+PED_LOJA+PED_FILORI)
		nPosMan := Ascan(aArrayMan,{|x| x[5]+x[6]+x[7]+x[12] == cBusca})

		//-- Verifico se o pedido foi marcado para inclusao no array de sequencia
		If (TRBPED->PED_MARCA == cMarca)
			If	cAlocPer == "S"
				//-- Buscar 1a. Rota disponivel.
				If (nC1 := aScan(aArraySetor,{|x| x[4]+x[5] == cZona+cSetor}))>0
					cRota := aArraySetor[nC1,3]
				EndIf
				TRBPED->PED_ROTA := cRota
			EndIf

            If l200Auto
               aArrayMan := AClone(aAutoItens)
               nPosMan := Len(aArrayMan)
            Else
				If nPosMan == 0 
					AAdd(aArrayMan,{TRBPED->PED_SEQROT,;
					TRBPED->PED_ROTA,;
					TRBPED->PED_ZONA,;
					TRBPED->PED_SETOR,;
					TRBPED->PED_PEDIDO,;
					TRBPED->PED_CODCLI,;
					TRBPED->PED_LOJA,;
					TRBPED->PED_NOME,;
					TRBPED->PED_BAIRRO,;
					TRBPED->PED_MUN,;
					TRBPED->PED_EST,;
					TRBPED->PED_FILORI,;
					TRBPED->PED_FILCLI,;
					0,;
					0,,,,,,;
					Iif(lFreteEmb,TRBPED->PED_CDRDES,),;
					Iif(lFreteEmb,SubStr(TRBPED->PED_TPFRET,1,1),),;
					Iif(lFreteEmb,TRBPED->PED_VALFRE,),;
					Iif(lFreteEmb,TRBPED->PED_FREAUT,),;
					0,;
					0,;
					TRBPED->PED_ENDCLI})
					nPosMan := Len(aArrayMan)
				EndIf
			EndIf
			//-- Se nao estiver pego apenas os valores do item marcado
			nPesoItem  := TRBPED->PED_PESO
			nValorItem := TRBPED->PED_VALOR
			nVolItem   := TRBPED->PED_VOLUM
			nQtdItem   := TRBPED->PED_QTDLIB
			If lFreteEmb
				If SubStr(TRBPED->PED_TPFRET,1,1) == "C"
					nPesoCIF  := TRBPED->PED_PESO
					nValorCIF := TRBPED->PED_VALOR
					nVolCIF   := TRBPED->PED_VOLUM
					nQtdCIF   := TRBPED->PED_QTDLIB
				ElseIf SubStr(TRBPED->PED_TPFRET,1,1) == "F"
					nPesoFOB  := TRBPED->PED_PESO
					nValorFOB := TRBPED->PED_VALOR
					nVolFOB   := TRBPED->PED_VOLUM
					nQtdFOB   := TRBPED->PED_QTDLIB
				EndIf
			EndIf
			//-- Procura e marca Rota --//
			If	(nC1:=aScan(aArrayRota,{|x|x[3] == cRota .And. x[1] .And. !x[2]}))>0
				aArrayRota[nC1,2] := .T.
			EndIf
			//-- Procura e marca Zona --//
			If	(nC1:=aScan(aArrayZona,{|x|x[3]+x[4] == cRota+cZona .And. x[1] .And. !x[2]}))>0
				aArrayZona[nC1,2] := .T.
			EndIf
			//-- Procura e marca Setor --//
			If	(nC1:=aScan(aArraySetor,{|x|x[3]+x[4]+x[5] == cRota+cZona+cSetor .And. x[1] .And. !x[2]}))>0
				aArraySetor[nC1,2] := .T.
			EndIf
			//-- Verifico se a montagem e por item e se esta ativo a marcacao de todos os itens do pedido automatica
			If lPedMark .Or. lAllMark
				If (mv_par06 == 2 .And. lPedMark)
					cPedido := TRBPED->(PED_FILORI+PED_PEDIDO)
				Else
					cPedido := ""
				EndIf
				TRBPED->(DbSetOrder(1)) //-- PED_FILORI+PED_PEDIDO+PED_ITEM+PED_SEQLIB+PED_CODCLI+PED_LOJA
				If TRBPED->(MsSeek(cPedido))
					While TRBPED->(!Eof() .And. (Empty(cPedido) .Or. PED_FILORI+PED_PEDIDO == cPedido))

						SC9->(DbSetOrder(1))
						SC9->(MsSeek(TRBPED->PED_FILORI+TRBPED->PED_PEDIDO+TRBPED->PED_ITEM+TRBPED->PED_SEQLIB))

						//-- Marco todos os itens se o flag estiver ativo
						If (TRBPED->PED_MARCA <> cMarca) .And. Empty(SC9->C9_CARGA)
							cRota  := TRBPED->PED_ROTA
							cZona  := TRBPED->PED_ZONA
							cSetor := TRBPED->PED_SETOR
							TRBPED->PED_MARCA := cMarca
							TRBPED->PED_CARGA := Iif(TRBPED->PED_MARCA == cMarca,cCarga,"ZZZZZZ")
							If	cAlocPer == "S"
								//-- Buscar 1a. Rota disponivel.
								If (nC1 := aScan(aArraySetor,{|x| x[4]+x[5] == cZona+cSetor}))>0
									cRota := aArraySetor[nC1,3]
								EndIf
								TRBPED->PED_ROTA := Iif(TRBPED->PED_MARCA == cMarca, cRota , Space(Len(DA8->DA8_COD)))
							EndIf

							//-- Verifico se existe no array de sequencia e incluo ou excluo caso a opcao escolhida pelo usuario
							cBusca  := TRBPED->(PED_PEDIDO+PED_CODCLI+PED_LOJA+PED_FILORI)
							nPosMan := Ascan(aArrayMan,{|x| x[5]+x[6]+x[7]+x[12] == cBusca})

							//-- Verifico se o pedido foi marcado para inclusao no array de sequencia
							If (TRBPED->PED_MARCA == cMarca)
								If	nPosMan == 0
									AAdd(aArrayMan,{TRBPED->PED_SEQROT,;
									TRBPED->PED_ROTA,;
									TRBPED->PED_ZONA,;
									TRBPED->PED_SETOR,;
									TRBPED->PED_PEDIDO,;
									TRBPED->PED_CODCLI,;
									TRBPED->PED_LOJA,;
									TRBPED->PED_NOME,;
									TRBPED->PED_BAIRRO,;
									TRBPED->PED_MUN,;
									TRBPED->PED_EST,;
									TRBPED->PED_FILORI,;
									TRBPED->PED_FILCLI,;
									0,;
									0,,,,,,;
									Iif(lFreteEmb,TRBPED->PED_CDRDES,),;
									Iif(lFreteEmb,SubStr(TRBPED->PED_TPFRET,1,1),),;
									Iif(lFreteEmb,TRBPED->PED_VALFRE,),;
									Iif(lFreteEmb,TRBPED->PED_FREAUT,),;
									0,;
									0,;
									TRBPED->PED_ENDCLI})
									nPosMan := Len(aArrayMan)
								EndIf
								//-- Se nao estiver pego apenas os valores do item marcado
								nPesoItem  += TRBPED->PED_PESO
								nValorItem += TRBPED->PED_VALOR
								nVolItem   += TRBPED->PED_VOLUM
								nQtdItem   += TRBPED->PED_QTDLIB
								If	lFreteEmb
									If	SubStr(TRBPED->PED_TPFRET,1,1) == "C"
										nPesoCIF  += TRBPED->PED_PESO
										nValorCIF += TRBPED->PED_VALOR
										nVolCIF   += TRBPED->PED_VOLUM
										nQtdCIF   += TRBPED->PED_QTDLIB
									ElseIf SubStr(TRBPED->PED_TPFRET,1,1) == "F"
										nPesoFOB  += TRBPED->PED_PESO
										nValorFOB += TRBPED->PED_VALOR
										nVolFOB   += TRBPED->PED_VOLUM
										nQtdFOB   += TRBPED->PED_QTDLIB
									EndIf
								EndIf
								cRota  := TRBPED->PED_ROTA
								cZona  := TRBPED->PED_ZONA
								cSetor := TRBPED->PED_SETOR
								//-- Procura e marca Rota --//
								If	(nC1:=aScan(aArrayRota,{|x|x[3] == cRota .And. x[1] .And. !x[2]}))>0
									aArrayRota[nC1,2] := .T.
								EndIf
								//-- Procura e marca Zona --//
								If	(nC1:=aScan(aArrayZona,{|x|x[3]+x[4] == cRota+cZona .And. x[1] .And. !x[2]}))>0
									aArrayZona[nC1,2] := .T.
								EndIf
								//-- Procura e marca Setor --//
								If	(nC1:=aScan(aArraySetor,{|x|x[3]+x[4]+x[5] == cRota+cZona+cSetor .And. x[1] .And. !x[2]}))>0
									aArraySetor[nC1,2] := .T.
								EndIf
							EndIf
						EndIf
						//--
						TRBPED->(DbSkip())
					EndDo
				EndIf
			EndIf
			//-- Atualizo no array de carga os dados de volume, peso, valor e ptos de entrega
			aArrayCarga[nPosCarga,CARGA_PESO]   := Transform(Val(aArrayCarga[nPosCarga,CARGA_PESO])   + nPesoItem ,cPictPeso)
			aArrayCarga[nPosCarga,CARGA_VALOR]  := Transform(Val(aArrayCarga[nPosCarga,CARGA_VALOR])  + nValorItem,cPictVal )
			aArrayCarga[nPosCarga,CARGA_VOLUM]  := Transform(Val(aArrayCarga[nPosCarga,CARGA_VOLUM])  + nVolItem  ,cPictVol )
			aArrayCarga[nPosCarga,CARGA_QTDLIB] := Transform(Val(aArrayCarga[nPosCarga,CARGA_QTDLIB]) + nQtdItem  ,cPictVol )
			aArrayCarga[nPosCarga,CARGA_PESCIF] := Transform(Val(aArrayCarga[nPosCarga,CARGA_PESCIF]) + nPesoCIF  ,cPictPeso)
			aArrayCarga[nPosCarga,CARGA_VALCIF] := Transform(Val(aArrayCarga[nPosCarga,CARGA_VALCIF]) + nValorCIF ,cPictVal )
			aArrayCarga[nPosCarga,CARGA_VOLCIF] := Transform(Val(aArrayCarga[nPosCarga,CARGA_VOLCIF]) + nVolCIF   ,cPictVol )
			aArrayCarga[nPosCarga,CARGA_QTDCIF] := Transform(Val(aArrayCarga[nPosCarga,CARGA_QTDCIF]) + nQtdCIF   ,cPictQtde)
			aArrayCarga[nPosCarga,CARGA_PESFOB] := Transform(Val(aArrayCarga[nPosCarga,CARGA_PESFOB]) + nPesoFOB  ,cPictPeso)
			aArrayCarga[nPosCarga,CARGA_VALFOB] := Transform(Val(aArrayCarga[nPosCarga,CARGA_VALFOB]) + nValorFOB ,cPictVal )
			aArrayCarga[nPosCarga,CARGA_VOLFOB] := Transform(Val(aArrayCarga[nPosCarga,CARGA_VOLFOB]) + nVolFOB   ,cPictVol )
			aArrayCarga[nPosCarga,CARGA_QTDFOB] := Transform(Val(aArrayCarga[nPosCarga,CARGA_QTDFOB]) + nQtdFOB   ,cPictQtde)


			aArrayMan[nPosMan][14] += nPesoItem
			aArrayMan[nPosMan][15] += nVolItem
			aArrayMan[nPosMan][25] += nValorItem
			aArrayMan[nPosMan][26] += nQtdItem

			//-- PE permite manipular pedidos de vendas, por exemplo, a sequencia de entrega.
			If	ExistBlock("OM200MRC")
				aRetPE := ExecBlock("OM200MRC",.F.,.F.,{aArrayMan,nPosMan})
				If	ValType(aRetPE)=="A"
					aArrayMan := aRetPE
				EndIf
			EndIf

		ElseIf(TRBPED->PED_MARCA <> cMarca)
			If	cAlocPer == "S"
				TRBPED->PED_ROTA := Space(Len(DA8->DA8_COD))
			EndIf
			//-- Se nao estiver pego apenas os valores do item marcado
			nPesoItem  := TRBPED->PED_PESO
			nValorItem := TRBPED->PED_VALOR
			nVolItem   := TRBPED->PED_VOLUM
			nQtdItem   := TRBPED->PED_QTDLIB
			If	lFreteEmb
				If	SubStr(TRBPED->PED_TPFRET,1,1) == "C"
					nPesoCIF  := TRBPED->PED_PESO
					nValorCIF := TRBPED->PED_VALOR
					nVolCIF   := TRBPED->PED_VOLUM
					nQtdCIF   := TRBPED->PED_QTDLIB
				ElseIf SubStr(TRBPED->PED_TPFRET,1,1) == "F"
					nPesoFOB  := TRBPED->PED_PESO
					nValorFOB := TRBPED->PED_VALOR
					nVolFOB   := TRBPED->PED_VOLUM
					nQtdFOB   := TRBPED->PED_QTDLIB
				EndIf
			EndIf
			//-- Pesquisa se existem Pedidos marcados para a Rota / Zona / Setor
			Oms200Rot(aArrayRota,aArrayZona,aArraySetor,cRota,cZona,cSetor,cMarca)
			//-- Verifico se a montagem e por item e se esta ativo a marcacao de todos os itens do pedido automatica
			If lPedMark .Or. lAllMark
				If (mv_par06 == 2 .And. lPedMark)
					cPedido := TRBPED->PED_FILORI+TRBPED->PED_PEDIDO
				Else
					cPedido := ""
				EndIf
				TRBPED->(DbSetOrder(1)) //-- PED_FILORI+PED_PEDIDO+PED_ITEM+PED_SEQLIB+PED_CODCLI+PED_LOJA
				If TRBPED->(MsSeek(cPedido))
					While TRBPED->(!Eof() .And. (Empty(cPedido) .Or. PED_FILORI+PED_PEDIDO == cPedido))
						//-- Marco todos os itens se o flag estiver ativo
						If (TRBPED->PED_MARCA == cMarca)
							cRota  := TRBPED->PED_ROTA
							cZona  := TRBPED->PED_ZONA
							cSetor := TRBPED->PED_SETOR
							TRBPED->PED_MARCA  := "  "
							TRBPED->PED_CARGA  := "ZZZZZZ"
							If	cAlocPer == "S"
								TRBPED->PED_ROTA := Space(Len(DA8->DA8_COD))
							EndIf
							nPesoItem  += TRBPED->PED_PESO
							nValorItem += TRBPED->PED_VALOR
							nVolItem   += TRBPED->PED_VOLUM
							nQtdItem   += TRBPED->PED_QTDLIB
							If	lFreteEmb
								If	SubStr(TRBPED->PED_TPFRET,1,1) == "C"
									nPesoCIF  += TRBPED->PED_PESO
									nValorCIF += TRBPED->PED_VALOR
									nVolCIF   += TRBPED->PED_VOLUM
									nQtdCIF   += TRBPED->PED_QTDLIB
								ElseIf SubStr(TRBPED->PED_TPFRET,1,1) == "F"
									nPesoFOB  += TRBPED->PED_PESO
									nValorFOB += TRBPED->PED_VALOR
									nVolFOB   += TRBPED->PED_VOLUM
									nQtdFOB   += TRBPED->PED_QTDLIB
								EndIf
							EndIf
							//-- Pesquisa se existem Pedidos marcados para a Rota / Zona / Setor
							Oms200Rot(aArrayRota,aArrayZona,aArraySetor,cRota,cZona,cSetor,cMarca)
						EndIf
						//--
						TRBPED->(DbSkip())
					EndDo
				EndIf
				lDelMan := .T.
				If lAllMark
					nPosMan := 0
				EndIf
			Else
				lDelMan := .T.
				cPedido := TRBPED->(PED_FILORI+PED_PEDIDO)
				TRBPED->(DbSetOrder(1))	 //-- PED_FILORI+PED_PEDIDO+PED_ITEM+PED_SEQLIB+PED_CODCLI+PED_LOJA
				If TRBPED->(MsSeek(cPedido))
					While TRBPED->(!Eof() .And. PED_FILORI+PED_PEDIDO == cPedido)
						If (TRBPED->PED_MARCA == cMarca)
							lDelMan := .F.
							Exit
						EndIf
						TRBPED->(DbSkip())
					EndDo
				EndIf
			EndIf
			//-- Atualizo no array de carga os dados de volume, peso, valor e ptos de entrega
			aArrayCarga[nPosCarga,CARGA_PESO]   := Transform(Val(aArrayCarga[nPosCarga,CARGA_PESO])   - nPesoItem ,cPictPeso)
			aArrayCarga[nPosCarga,CARGA_VALOR]  := Transform(Val(aArrayCarga[nPosCarga,CARGA_VALOR])  - nValorItem,cPictVal )
			aArrayCarga[nPosCarga,CARGA_VOLUM]  := Transform(Val(aArrayCarga[nPosCarga,CARGA_VOLUM])  - nVolItem,cPictVol   )
			aArrayCarga[nPosCarga,CARGA_QTDLIB] := Transform(Val(aArrayCarga[nPosCarga,CARGA_QTDLIB]) - nQtdItem,cPictVol   )
			aArrayCarga[nPosCarga,CARGA_PESCIF] := Transform(Val(aArrayCarga[nPosCarga,CARGA_PESCIF]) - nPesoCIF,cPictPeso  )
			aArrayCarga[nPosCarga,CARGA_QTDCIF] := Transform(Val(aArrayCarga[nPosCarga,CARGA_QTDCIF]) - nQtdCIF,cPictQtde   )
			aArrayCarga[nPosCarga,CARGA_VALCIF] := Transform(Val(aArrayCarga[nPosCarga,CARGA_VALCIF]) - nValorCIF,cPictVal  )
			aArrayCarga[nPosCarga,CARGA_VOLCIF] := Transform(Val(aArrayCarga[nPosCarga,CARGA_VOLCIF]) - nVolCIF,cPictVol    )
			aArrayCarga[nPosCarga,CARGA_PESFOB] := Transform(Val(aArrayCarga[nPosCarga,CARGA_PESFOB]) - nPesoFOB,cPictPeso  )
			aArrayCarga[nPosCarga,CARGA_QTDFOB] := Transform(Val(aArrayCarga[nPosCarga,CARGA_QTDFOB]) - nQtdFOB,cPictQtde   )
			aArrayCarga[nPosCarga,CARGA_VALFOB] := Transform(Val(aArrayCarga[nPosCarga,CARGA_VALFOB]) - nValorFOB,cPictVal  )
			aArrayCarga[nPosCarga,CARGA_VOLFOB] := Transform(Val(aArrayCarga[nPosCarga,CARGA_VOLFOB]) - nVolFOB,cPictVol    )

			If nPosMan > 0
				aArrayMan[nPosMan][14] -= nPesoItem
				aArrayMan[nPosMan][15] -= nVolItem
				aArrayMan[nPosMan][25] -= nValorItem
				aArrayMan[nPosMan][26] -= nQtdItem
			EndIf
			If lDelMan
				If nPosMan > 0
					aDel(aArrayMan,nPosMan)
					aSize(aArrayMan,Len(aArrayMan)-1)
				Else
					aArrayMan := {}
				EndIf
			EndIf
		EndIf
	EndIf
Else

	//-- Escolha da rota / Zona / Setor / Pedido de Vendas
	Do Case

		Case nEscolha == 1 //-- Rotas --//
			//-- Verifico o flag se esta habilitado ou se esta como rota inativa para deixar marcar para geracao
			aArrayRota[oRotas:nAt,2] := Iif((!aArrayRota[oRotas:nAt,2]) .And. (aArrayRota[oRotas:nAt,1]), .T., .F.)
			lMarca := aArrayRota[oRotas:nAt,2]
			cRota  := aArrayRota[oRotas:nAt,3]

			nC0 := aScan(aArrayZona,{|x|x[3] == cRota})
			For nC1 := nC0 To Len(aArrayZona)
				If (aArrayZona[nC1,3] == cRota)
					If (aArrayZona[nC1,1])
						aArrayZona[nC1,2] := lMarca
						cZona  := aArrayZona[nC1,4]
						//-- Procura primeiro setor desta rota + zona e (des)marca setores da zona --//
						nC2 := aScan(aArraySetor,{|x|x[3]+x[4] == cRota+cZona})
						For nC3 := nC2 To Len(aArraySetor)
							If (aArraySetor[nC3,3]+aArraySetor[nC3,4] == cRota+cZona)
								If	aArraySetor[nC3,1]
									aArraySetor[nC3,2] := lMarca
									AAdd(aPesqRota,{cRota, aArraySetor[nC3,4], aArraySetor[nC3,5]})
								EndIf
							EndIf
						Next nC3
					EndIf
				Else
					Exit
				EndIf
			Next nC1

		Case nEscolha == 2 //-- Zonas --//
			//--  Verifico o flag se esta habilitado ou se esta como rota inativa para deixar marcar para geracao
			aArrayZona[oZonas:nAt,2] := Iif((!aArrayZona[oZonas:nAt,2]) .And. (aArrayZona[oZonas:nAt,1]), .T., .F.)
			lMarca := aArrayZona[oZonas:nAt,2]
			cRota  := aArrayZona[oZonas:nAt,3]
			cZona  := aArrayZona[oZonas:nAt,4]
			//-- Procura e (des)marca Rota --//
			If lMarca
				If (nC1:=aScan(aArrayRota,{|x|x[3] == cRota .And. x[1] .And. !x[2]}))>0
					aArrayRota[nC1,2] := .T.
				EndIf
			Else
				If (nC1:=aScan(aArrayZona,{|x|x[3] == cRota .And. x[4] <> cZona .And. x[1] .And. x[2]}))==0
					If (nC1:=aScan(aArrayRota,{|x|x[3] == cRota .And. x[1] .And. x[2]}))>0
						aArrayRota[nC1,2] := .F.
					EndIf
				EndIf
			EndIf
			//-- Procura primeiro setor desta rota + zona e (des)marca Setores da Zona --//
			nC0 := aScan(aArraySetor,{|x|x[3]+x[4] == cRota+cZona})
			For nC1 := nC0 to Len(aArraySetor)
				If (aArraySetor[nC1,3]+aArraySetor[nC1,4] == cRota+cZona)
					If (aArraySetor[nC1,1])
						aArraySetor[nC1,2] := lMarca
						AAdd(aPesqRota,{cRota, cZona, aArraySetor[nC1,5]})
					EndIf
				EndIf
			Next nC1

		Case nEscolha == 3 //-- Setores --//
			//-- Verifico o flag se esta habilitado ou se esta como rota inativa para deixar marcar para geracao
			aArraySetor[oSetores:nAt,2] := Iif((!aArraySetor[oSetores:nAt,2]) .And. (aArraySetor[oSetores:nAt,1]), .T., .F.)
			cRota  := aArraySetor[oSetores:nAt,3]
			cZona  := aArraySetor[oSetores:nAt,4]
			cSetor := aArraySetor[oSetores:nAt,5]
			lMarca := aArraySetor[oSetores:nAt,2]
			AAdd(aPesqRota,{cRota, cZona, cSetor})
			//-- Procura e (des)marca Rota --//
			If	lMarca
				If	(nC1:=aScan(aArrayRota,{|x|x[3] == cRota .And. x[1] .And. !x[2]}))>0
					aArrayRota[nC1,2] := .T.
				EndIf
			Else
				If (nC1:=aScan(aArraySetor,{|x|x[3] == cRota .And. x[5] <> cSetor .And. x[1] .And. x[2]}))==0
					If (nC1:=aScan(aArrayRota,{|x|x[3] == cRota .And. x[1] .And. x[2]}))>0
						aArrayRota[nC1,2] := .F.
					EndIf
				EndIf
			EndIf
			//-- Procura e (des)marca Zona --//
			If	lMarca
				If	(nC1:=aScan(aArrayZona,{|x|x[3]+x[4] == cRota+cZona .And. x[1] .And. !x[2]}))>0
					aArrayZona[nC1,2] := .T.
				EndIf
			Else
				If (nC1:=aScan(aArraySetor,{|x|x[3]+x[4] == cRota+cZona .And. x[5] <> cSetor .And. x[1] .And. !x[2]}))==0
					If (nC1:=aScan(aArrayZona,{|x|x[3]+x[4] == cRota+cZona .And. x[1] .And. x[2]}))>0
						aArrayZona[nC1,2] := .F.
					EndIf
				EndIf
			EndIf
	EndCase

	//-- Se nEscolha < 4 - Selecionado Rota, Setor ou Zona.
	If	cAlocPer == "S"
		cWhile := "PED_ZONA+PED_SETOR"
		nOrder := 5		
		nIndice := 7 //--PED_CODCLI+PED_LOJA
	EndIf
	For nC1 := 1 to Len(aPesqRota)
		cSeekPed := Iif(cAlocPer == "S","",aPesqRota[nC1,1])+aPesqRota[nC1,2]+aPesqRota[nC1,3]
		DbSelectArea("TRBPED")
		If !TRBPED->(MsSeek(cSeekPed))
			TRBPED->(DbSetOrder(nIndice)) 	//--PED_CODCLI+PED_LOJA
			aSort(aArrayCli,,,{|x,y| x[3]+x[4]+x[5] < y[3]+y[4]+y[5]}) 
			nPosRotAlt := aScan(aArrayCli, {|x|x[3]+x[4]+x[5]=aPesqRota[nC1,1]+aPesqRota[nC1,2]+aPesqRota[nC1,3]})			
			While nPosRotAlt > 0 .And. aArrayCli[nPosRotAlt][3]+aArrayCli[nPosRotAlt][4]+aArrayCli[nPosRotAlt][5] == aPesqRota[nC1,1]+aPesqRota[nC1,2]+aPesqRota[nC1,3] 
				If TRBPED->(MsSeek(aArrayCli[nPosRotAlt][1]+aArrayCli[nPosRotAlt][2]))
					While TRBPED->(!Eof()) .And. TRBPED->(PED_CODCLI+PED_LOJA) == aArrayCli[nPosRotAlt][1]+aArrayCli[nPosRotAlt][2]
						If TRBPED->(PED_ZONA+PED_SETOR) <> aPesqRota[nC1,2]+aPesqRota[nC1,3] 
							RecLock("TRBPED",.F.)
							TRBPED->PED_ZONA := aPesqRota[nC1,2]
							TRBPED->PED_SETOR:= aPesqRota[nC1,3] 
							MsUnlock()
						EndIf
					   TRBPED->(DbSkip())					
					EndDo					
				EndIf				
				If nPosRotAlt < Len(aArrayCli) 
					nPosRotAlt++
				Else
					Exit					
				EndIf
			EndDo
			TRBPED->(DbSetOrder(nOrder))
			TRBPED->(MsSeek(cSeekPed))		
		EndIf

		While TRBPED->(!Eof() .And. &cWhile == cSeekPed)
			//-- Nao desmarcar pedido selecionados por outra Rota
			If	cAlocPer == "S" .And. !lMarca .And. TRBPED->PED_ROTA <> cRota
				TRBPED->(DbSkip())
				Loop
			EndIf

			//-- Verifico Flag do pedido
			If (TRBPED->PED_GERA == "N") .And. Oms200Lock(TRBPED->PED_FILORI,TRBPED->PED_PEDIDO, aLock, lMarca, cMarca, nEscolha)

				lSomaCarga := Iif(TRBPED->PED_MARCA == cMarca,.F.,.T.)
				lAbatCarga := Iif(TRBPED->PED_MARCA <> cMarca,.F.,.T.)

				RecLock("TRBPED",.F.)
				TRBPED->PED_MARCA := Iif(lMarca, cMarca, "  ")
				TRBPED->PED_CARGA := Iif(lMarca, cCarga, "ZZZZZZ")
				If	lFreteEmb
					TRBPED->PED_VALFRE := Iif(TRBPED->PED_MARCA == cMarca,TRBPED->PED_VALFRE,0)
					TRBPED->PED_FREAUT := Iif(TRBPED->PED_MARCA == cMarca,TRBPED->PED_FREAUT,0)
				EndIf
				If	cAlocPer == "S"
					TRBPED->PED_ROTA := Iif(lMarca, cRota, Space(Len(DA8->DA8_COD)))
				EndIf
				MsUnlock()

				//-- Verifico se existe no array de sequencia e incluo ou excluo caso a opcao escolhida pelo usuario
				cBusca  := TRBPED->(PED_PEDIDO+PED_CODCLI+PED_LOJA+PED_FILORI)
				nPosMan := Ascan(aArrayMan,{|x| x[5]+x[6]+x[7]+x[12] == cBusca})

				//-- Verifico se o pedido foi marcado para inclusao no array de sequencia
				If (TRBPED->PED_MARCA == cMarca)
					nMultiplic := 1
					If	nPosMan == 0
						AAdd(aArrayMan,{TRBPED->PED_SEQROT,;
						TRBPED->PED_ROTA,;
						TRBPED->PED_ZONA,;
						TRBPED->PED_SETOR,;
						TRBPED->PED_PEDIDO,;
						TRBPED->PED_CODCLI,;
						TRBPED->PED_LOJA,;
						TRBPED->PED_NOME,;
						TRBPED->PED_BAIRRO,;
						TRBPED->PED_MUN,;
						TRBPED->PED_EST,;
						TRBPED->PED_FILORI,;
						TRBPED->PED_FILCLI,;
						TRBPED->PED_PESO,;
						TRBPED->PED_VOLUM,,,,,,;
						Iif(lFreteEmb,TRBPED->PED_CDRDES,),;
						Iif(lFreteEmb,SubStr(TRBPED->PED_TPFRET,1,1),),;
						Iif(lFreteEmb,TRBPED->PED_VALFRE,),;
						Iif(lFreteEmb,TRBPED->PED_FREAUT,),;
						TRBPED->PED_VALOR,;
						TRBPED->PED_QTDLIB,;
						TRBPED->PED_ENDCLI})
					ElseIf lSomaCarga
						aArrayMan[nPosMan][14] += TRBPED->PED_PESO
						aArrayMan[nPosMan][15] += TRBPED->PED_VOLUM
						aArrayMan[nPosMan][26] += TRBPED->PED_QTDLIB
					EndIf

					//-- PE permite manipular pedidos de vendas, por exemplo, a sequencia de entrega.
					If	lOM200MRC
						aRetPE := ExecBlock("OM200MRC",.F.,.F.,{aArrayMan,nPosMan})
						If	ValType(aRetPE)=="A"
							aArrayMan := aRetPE
						EndIf
					EndIf

				ElseIf (TRBPED->PED_MARCA <> cMarca)
					nMultiplic := -1
					If nPosMan > 0
						aDel(aArrayMan,nPosMan)
						aSize(aArrayMan,Len(aArrayMan)-1)
					EndIf
				EndIf
				//-- Atualizo no array de carga os dados de volume, peso, valor e ptos de entrega
				If (lSomaCarga .And. nMultiplic==1) .Or. (lAbatCarga .And. nMultiplic==-1)
					aArrayCarga[nPosCarga,CARGA_PESO]   := Transform(Val(aArrayCarga[nPosCarga,CARGA_PESO])   + (nMultiplic * TRBPED->PED_PESO),  cPictPeso)
					aArrayCarga[nPosCarga,CARGA_VALOR]  := Transform(Val(aArrayCarga[nPosCarga,CARGA_VALOR])  + (nMultiplic * TRBPED->PED_VALOR), cPictVal)
					aArrayCarga[nPosCarga,CARGA_VOLUM]  := Transform(Val(aArrayCarga[nPosCarga,CARGA_VOLUM])  + (nMultiplic * TRBPED->PED_VOLUM), cPictVol)
					aArrayCarga[nPosCarga,CARGA_QTDLIB] := Transform(Val(aArrayCarga[nPosCarga,CARGA_QTDLIB]) + (nMultiplic * TRBPED->PED_QTDLIB),cPictQtde)
					If	lFreteEmb
						If	SubStr(TRBPED->PED_TPFRET,1,1) == "C"
							aArrayCarga[nPosCarga,CARGA_PESCIF] := Transform(Val(aArrayCarga[nPosCarga,CARGA_PESCIF]) + (nMultiplic * TRBPED->PED_PESO),  cPictPeso)
							aArrayCarga[nPosCarga,CARGA_VALCIF] := Transform(Val(aArrayCarga[nPosCarga,CARGA_VALCIF]) + (nMultiplic * TRBPED->PED_VALOR), cPictVal)
							aArrayCarga[nPosCarga,CARGA_VOLCIF] := Transform(Val(aArrayCarga[nPosCarga,CARGA_VOLCIF]) + (nMultiplic * TRBPED->PED_VOLUM), cPictVol)
							aArrayCarga[nPosCarga,CARGA_QTDCIF] := Transform(Val(aArrayCarga[nPosCarga,CARGA_QTDCIF]) + (nMultiplic * TRBPED->PED_QTDLIB),cPictQtde)
						ElseIf SubStr(TRBPED->PED_TPFRET,1,1) == "F"
							aArrayCarga[nPosCarga,CARGA_PESFOB] := Transform(Val(aArrayCarga[nPosCarga,CARGA_PESFOB]) + (nMultiplic * TRBPED->PED_PESO),  cPictPeso)
							aArrayCarga[nPosCarga,CARGA_VALFOB] := Transform(Val(aArrayCarga[nPosCarga,CARGA_VALFOB]) + (nMultiplic * TRBPED->PED_VALOR), cPictVal)
							aArrayCarga[nPosCarga,CARGA_VOLFOB] := Transform(Val(aArrayCarga[nPosCarga,CARGA_VOLFOB]) + (nMultiplic * TRBPED->PED_VOLUM), cPictVol)
							aArrayCarga[nPosCarga,CARGA_QTDFOB] := Transform(Val(aArrayCarga[nPosCarga,CARGA_QTDFOB]) + (nMultiplic * TRBPED->PED_QTDLIB),cPictQtde)
						EndIf
					EndIf
				EndIf
			EndIf
			TRBPED->(DbSkip())
		EndDo
	Next nC1
EndIf

If !Empty(aVisErr)
	TmsMsgErr(aVisErr)
	aVisErr := {}
EndIf

//-- Calculo sequencia de entrega
If GetNewPar("MV_SEQENT","1") == "1" //-- Sequencia + Rota + Pedido
	aArrayMan := aSort(aArrayMan,,,{|x,y| x[1]+x[2]+x[5] < y[1]+y[2]+y[5]})
Else //-- Rota + Sequencia + Pedido
	aArrayMan := aSort(aArrayMan,,,{|x,y| x[2]+x[1]+x[5] < y[2]+y[1]+y[5]})
EndIf

//-- Calculo janela de entregas dos clientes da carga
 FBs200Time(cHrStart,dDtStart,aArrayMan,aArrayCarga[nPosCarga,CARGA_VEIC],12,6,7,2,3,4,14,15,16,17,18,19,20)
//-- Retirado: Efetuado na confirmacao da montagem da carga.

//-- Calculo pontos de entrega
For nC1 := 1 to Len(aArrayMan)
	If (Ascan(aArrayPto,{|x| x[1]+x[2]+x[3] == aArrayMan[nC1,6]+aArrayMan[nC1,7]+aArrayMan[nC1,13]}) == 0)
		AAdd(aArrayPto, {aArrayMan[nC1,6],aArrayMan[nC1,7],aArrayMan[nC1,13]})
	EndIf
Next nC1
aArrayCarga[nPosCarga,CARGA_PTOENT] := StrZero(Len(aArrayPto),6)

//-- Recalculo do Frete
If lFreteEmb .And. aArrayFrt[1]<>Nil
	OmsTransp(@aArrayMan,@aArrayCarga,@oEnable,@oDisable,@oMarked,@oNoMarked,@cHrStart,@dDtStart,@aArrayFrt,@aHeaderFrt, @aColsFrt,, ,,@aHeaderAdt,@aColsAdt,"TRBPED",cMarca,@aFretReg,.T.)
	OmsFreCar(cVeiculo,@cVeiAnt,aArrayFrt[FRETE_TABFRE],@cTabAnt,@aArrayMan,@aArrayFrt,@aHeaderFrt, @aColsFrt,@aArrayFrt[FRETE_VAL],@aArrayFrt[FRETE_FREAUT],2,@aArrayFrt[FRETE_TIPTAB],@aFretReg,.F.)
EndIf

If aArrayFrt[FRETE_RATEIO] <> Nil
	OmsRatFre(cCarga,,If(Val(aArrayFrt[FRETE_RATEIO])==0,1,Val(aArrayFrt[FRETE_RATEIO])),aArrayFrt[FRETE_VAL],aArrayFrt[FRETE_FREAUT],@aArrayMan,"TRBPED",aFretReg,cMarca)
EndIf

//-- Posiciono no registro inicial do arquivo de trabalho
RestArea( aAreaTRB )
RestArea( aArea    )

If !l200Auto
	oRotas:lDisablePaint        := .F.
	oZonas:lDisablePaint        := .F.
	oSetores:lDisablePaint      := .F.
	oMark:oBrowse:lDisablePaint := .F.
	oCargas:Refresh()
	oRotas:Refresh()
	oZonas:Refresh()
	oSetores:Refresh()
	oMark:oBrowse:Refresh(.T.)
Endif

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³OmsCarregaºAutor  ³DL                  º Data ³  12/22/00   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Gera carregamento                                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³ aArrayCarga - Array  de cargas passado por referencia      º±±
±±º          ³ aArrayRota  - Array  de rotas  passado por referencia      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP5                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function OmsCarrega(oEnable,oDisable,oMarked,oNoMarked,cMarca,aArrayCarga,aArrayRota,aArrayZona,aArraySetor,aArrayMan,cHrStart,dDtStart,nSaveSx8,aArrayFrt,aHeaderFrt,aColsFrt,cGvCodOper,cGvNoProc,cGvPedComOp,aHeaderAdt,aColsAdt,cDakTransp)
Local aArrayGera := {}
Local aHoras     := {}
Local cCarga     := ""
Local cVeiculo   := ""
Local cMotorista := ""
Local cAjuda1    := ""
Local cAjuda2    := ""
Local cAjuda3    := ""
Local cRota      := ""
Local cEndereco  := ""
Local cEndPad    := ""
Local cCliente   := ""
Local cLoja      := ""
Local cQuery     := ""
Local cAliasSC9  := "SC9"
Local aAreaTRB   := TRBPED->(GetArea())
Local nPosRota   := 0
Local nPosZona   := 0
Local nPosSetor  := 0
Local nPosCarga  := Ascan(aArrayCarga,{|x| x[CARGA_ENABLE] == .T.})
Local nTipoOper  := OsVlEntCom()
Local lIntWms    := IntWms()
Local nZona      := 0
Local nSetor     := 0
Local nRota      := 0
Local nC         := 0
Local lProcSC9   := .T.
Local lProcessa  := .T.
Local lRetPE     := .T.
Local lEndeWMS   := .F.
Local lOms200Ok  := ExistBlock("OM200OK")
Local lOms200Fim := ExistBlock("OM200FIM")
Local lOS200PC9  := ExistBlock("OS200PC9")
Local lOM200CAR  := ExistBlock("OM200CAR")
Local cRetPE     := ""
Local cAlocPer   := SuperGetMv("MV_ALOCPER",.F.,"N")
Local cCpoCapac  := IIf(SuperGetmv("MV_OMSCAPA",.F.,"1")=="1","DA3_CAPACN","DA3_CAPACM")
Local nCapac     := 0
Local nRecSC9    := 0
Local cCplInt	 := SuperGetMv("MV_CPLINT",.F.,"2") 

Default cGvCodOper  := ""
Default cGvNoProc   := ""
Default cGvPedComOp := ""
Default cDakTransp	:= Criavar("A4_COD",.F.)

If	Len( aArrayMan ) == 0
	Help(" ",1,"OMSPEDMARK") //Não existem pedidos selecionados para a visualização
	lProcessa := .F.
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifico se existe carga disponivel aberta³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If	lProcessa
	If	nPosCarga == 0
		Help(" ",1,"DLACGDISP") //Nao existe carga disponivel aberta
		lProcessa := .F.
	EndIf
EndIf

If HasTemplate("DCLEST") .And. !Empty(SuperGetMv("MV_COMBUS")) .And. Empty(cDakTransp)
	Help(" ",1,"OBRIGATORIO",,"Campo Tranportadora Obrigatório",3,1) //
	lProcessa := .F.
EndIf

If	lProcessa
	cCarga     := aArrayCarga[nPosCarga,CARGA_COD]
	cVeiculo   := aArrayCarga[nPosCarga,CARGA_VEIC]
	cMotorista := aArrayCarga[nPosCarga,CARGA_MOTOR]
	cAjuda1    := aArrayCarga[nPosCarga,CARGA_AJUD1]
	cAjuda2    := aArrayCarga[nPosCarga,CARGA_AJUD2]
	cAjuda3    := aArrayCarga[nPosCarga,CARGA_AJUD3]
	
	If l200Auto
		xArrCarga := aClone(aArrayCarga)
	EndIf

	//-- Calculo janela de entregas dos clientes da carga
	FBs200Time(cHrStart,dDtStart,aArrayMan,aArrayCarga[nPosCarga,CARGA_VEIC],12,6,7,2,3,4,14,15,16,17,18,19,20)

	If !Empty(cVeiculo)
		aHoras := {	aArrayMan[1][19],;
					aArrayMan[1][16],;
					aArrayMan[Len(aArrayMan)][20],;
					IntToHora(HoraToInt(aArrayMan[Len(aArrayMan)][16],2)+HoraToInt(aArrayMan[Len(aArrayMan)][17],4),2) }
		If !OmsVeiDisp(cVeiculo,aHoras[1],aHoras[2],aHoras[3],aHoras[4])
			Help(" ",1,"OMSVEIEMP") //Veículo já empenhado em outra carga ou viagem.
			lProcessa := .F.
		EndIf
	EndIf
	//-- Verifico se o total da carga esta fechado com a capacidade do caminhao se parametro considerar restricoes
	If lProcessa .And. !Empty(cVeiculo)
		Pergunte("OMS200",.F.) //Parametro da Montagem de Cargas
		If	mv_par05 == 1
			DA3->(DbSetOrder(1))
			If	DA3->(MsSeek(xFilial("DA3")+cVeiculo))
				nCapac := DA3->(FieldGet(FieldPos(cCpoCapac)))
				If	(Val(aArraycarga[oCargas:nAt,CARGA_PESO])   > nCapac).Or.;
					(Val(aArrayCarga[oCargas:nAt,CARGA_VOLUM])  > DA3->DA3_VOLMAX).Or.;
					(Val(aArrayCarga[oCargas:nAt,CARGA_PTOENT]) > DA3->DA3_LIMMAX)
					Help(" ",1,"OMSULTCARG") //Caminhao nao suporta carga montada
					lProcessa := .F.
				EndIf
			EndIf
		EndIf
	EndIf
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifico o numero de rotas que existem na carga para³
//³a escolha de apenas uma caso haja mais do que uma   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If	lProcessa
	If !Oms200ARota(@aArrayMan)
		lProcessa := .F.
	EndIf
EndIf

If lProcessa
	If lIntWms
		If !Oms200EPad(@aArrayMan,@cEndereco,@lEndeWMS)
			lProcessa := .F.
		EndIf
	EndIf
EndIf

//-- Ponto de entrada antes da geracao da carga, permitindo ao usuario interferir na geracao da carga
If	lOms200Ok .And. lProcessa
	lRetPE := ExecBlock("OM200OK",.F.,.F.,{ aArrayMan, aArrayCarga, nPosCarga})
	lProcessa := If(ValType(lRetPE)=="L", lRetPE, lProcessa)
EndIf

//-- Se ok confirmo geracao da carga
If	lProcessa

	//Begin Transaction
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Prepara array para a funcao de geracao                            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		For nC := 1 to Len(aArrayMan)
			cAliasSC9 := "QRYSC9"
			cQuery := "SELECT SC9.*,SC9.R_E_C_N_O_ RECSC9 "
			cQuery += " FROM "
			cQuery += RetSqlName("SC9")+ " SC9 "
			cQuery += " WHERE "
			cQuery += "C9_FILIAL = '"+aArrayMan[nC,12]+"' AND "
			cQuery += "C9_PEDIDO = '"+aArrayMan[nC, 5]+"' AND "
				If !l200Auto
					cQuery += "C9_BLCRED = '"+Space(Len(SC9->C9_BLCRED))+"' AND "
				EndIf
				//Se vier do AGR, não inserir trecho na query
				If !l200Auto .AND. !(SuperGetMV("MV_AGRUBS",.F.,.F.))
					cQuery += "C9_BLEST  = '"+Space(Len(SC9->C9_BLEST)) +"' AND "
				EndIf
			cQuery += "C9_CARGA  = '"+Space(Len(SC9->C9_CARGA ))+"' AND "
			cQuery += "C9_SEQCAR = '"+Space(Len(SC9->C9_SEQCAR))+"' AND "
			cQuery += "SC9.D_E_L_E_T_ = ' ' "
			//-- PE para alterar query dos pedidos na Montagem da Carga
			If	lOM200CAR
				cRetPE := ExecBlock("OM200CAR",.F.,.F.,{ cQuery , 1 })
				cQuery := If(ValType(cRetPE)=="C", cRetPE, cQuery)
			EndIf
			cQuery := ChangeQuery(cQuery)
			DbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),cAliasSC9,.F.,.T.)

			While (cAliasSC9)->(!Eof())
				lProcSC9 := .T.
				nRecSC9 := (cAliasSC9)->RECSC9
				//-- Se for por item verifica se ele foi marcado para a geracao.
				If (mv_par06 == 2)
					If l200Auto
					    lProcSC9 := .T.
					Else
						If	lProcSC9
							TRBPED->(DbSetOrder(1))
							If	TRBPED->(MsSeek((cAliasSC9)->C9_FILIAL+(cAliasSC9)->C9_PEDIDO+(cAliasSC9)->C9_ITEM+(cAliasSC9)->C9_SEQUEN))
								If	TRBPED->PED_MARCA != cMarca
									lProcSC9 := .F.
								EndIf
							Else
								lProcSC9 := .F.
							EndIf
						EndIf
					Endif
				EndIf
				//-- Ponto de entrada para validar itens do Pedido de Venda
				If	lProcSC9 .And. lOS200PC9
					lRetPE   := ExecBlock("OS200PC9",.F.,.F.,{cAliasSC9})
					lProcSC9 := If(ValType(lRetPE)=="L", lRetPE, lProcSC9)
				EndIf
				//-- Gera array contendo os pedidos para inclusao na carga gerada
				If	lProcSC9
					If	nTipoOper == 3
						//-- Amarracao Codigo Cliente x Codigo Operador Logistico
						DCK->(DbSetOrder(2)) //DCK_FILIAL+DCK_CODCLI+DCK_LOJCLI
						If	DCK->(MsSeek(xFilial("DCK")+(cAliasSC9)->C9_CLIENTE+(cAliasSC9)->C9_LOJA))
							cCliente := DCK->DCK_CODOPL
							cLoja    := DCK->DCK_LOJOPL
						Else
							cCliente := (cAliasSC9)->C9_CLIENTE
							cLoja    := (cAliasSC9)->C9_LOJA
						EndIf
					Else
						cCliente := (cAliasSC9)->C9_CLIENTE
						cLoja    := (cAliasSC9)->C9_LOJA
					EndIf
					//-- Usa endereco padrao do pedido se sem endereco retornado (Oms200EPad).
					cEndPad := cEndereco
					If lIntWms
						If Empty(cEndPad)
							cEndPad := (cAliasSC9)->C9_ENDPAD
						EndIf
					EndIf
					AAdd(aArrayGera, {	aArrayMan[nC,1],;			//  1- Sequencia
										aArrayMan[nC,2],;			//  2- Rota
										aArrayMan[nC,3],;			//  3- Zona
										aArrayMan[nC,4],;			//  4- Setor
										(cAliasSC9)->C9_PEDIDO,;	//  5- Pedido
										(cAliasSC9)->C9_ITEM,;		//  6- Item
										cCliente,;					//  7- Cliente
										cLoja,;						//  8- Loja
										nRecSC9,;					//  9- Reg. SC9
										cEndPad,;					// 10- Endereco padrao
										(cAliasSC9)->C9_FILIAL,;	// 11- Filial Pedido
										aArrayMan[nC][13],;			// 12- Filial Cliente
										aArrayMan[nC][16],;			// 13- Hora chegada
										aArrayMan[nC][17],;			// 14- Time Service
										aArrayMan[nC][19],;			// 15- Data chegada
										aArrayMan[nC][20],;			// 16- Data saida
										aArrayMan[nC][23],;			// 17- Valor do Frete
										aArrayMan[nC][24] })		// 18- Frete Autonomo
				EndIf
				lProcSC9 := .T.
				DbSelectArea(cAliasSC9)
				DbSkip()
			EndDo
			DbSelectArea(cAliasSC9)
			DbCloseArea()
			DbSelectArea("SC9")
		Next nC

		If !l200Auto
            lProcessa := FBSA200IPG(3,cVeiculo,cMotorista,.F.,cCarga,Nil,aArrayMan[1][5],cDakTransp)
        EndIf

		If lProcessa
			//-- Gerar a carga baseado no array
			If IsBlind()
			     FBs200Carga(@aArrayGera,cCarga,Nil,cVeiculo,cMotorista,cAjuda1,cAjuda2,cAjuda3,cHrStart,dDtStart,nSaveSx8,aArrayFrt,aHeaderFrt,aColsFrt,,cGvCodOper,cGvNoProc,cGvPedComOp,aHeaderAdt,aColsAdt,cDakTransp,lEndeWMS) 
			Else
			     Processa({||FBs200Carga(@aArrayGera,cCarga,Nil,cVeiculo,cMotorista,cAjuda1,cAjuda2,cAjuda3,cHrStart,dDtStart,nSaveSx8,aArrayFrt,aHeaderFrt,aColsFrt,,cGvCodOper,cGvNoProc,cGvPedComOp,aHeaderAdt,aColsAdt,cDakTransp,lEndeWMS)})
         	EndIf
         	If !l200Auto
				//-- Integração Protheus x GFE (INCLUSAO)
				If !FBSA200IPG(3,,,.T.,,,,cDakTransp)
					DisarmTransaction()
					lProcessa := .F.
				EndIf
			EndIf
		EndIf

		If lProcessa
			//-- Atualiza flags de geracao na markbrowse
			aArrayCarga[nPosCarga,CARGA_ENABLE] := .F.

			For nRota := 1 to Len(aArrayRota)
				If (aArrayRota[nRota,2])
					aArrayRota[nRota,5] := cCarga
				EndIf
				aArrayRota[nRota,1] := .F.
				aArrayRota[nRota,2] := .F.
			Next nRota

			For nZona := 1 to Len(aArrayZona)
				If (aArrayZona[nZona,2])
					aArrayZona[nZona,6] := cCarga
				EndIf
				aArrayZona[nZona,1] := .F.
				aArrayZona[nZona,2] := .F.
			Next nZona

			For nSetor := 1 to Len(aArraySetor)
				If (aArraySetor[nSetor,2])
					aArraySetor[nSetor,7] := cCarga
				EndIf
				aArraySetor[nSetor,1] := .F.
				aArraySetor[nSetor,2] := .F.
			Next nSetor

			DbSelectArea("TRBPED")
			DbGoTop()
			While !Eof()
				//-- Desmarca pedidos selecionados para a carga
				If (TRBPED->PED_MARCA == cMarca)
					TRBPED->PED_GERA  := "S"
					TRBPED->PED_MARCA := "  "
					TRBPED->PED_CARGA := cCarga
				EndIf
				DbSkip()
			EndDo

			//-- Verifico o array de pedidos para ver se sobraram alguns pedidos das rotas para nao desbilitar
			DbSelectArea("TRBPED")
			DbGoTop()
			While !Eof()
				If TRBPED->PED_GERA == "N"
					If cAlocPer == "S"
						//-- Podem existir mais de uma Rota para um mesmo Setor e/ou Zona
						While (nPosSetor := Ascan(aArraySetor,{|x| x[4]+x[5] == TRBPED->PED_ZONA+TRBPED->PED_SETOR .And. x[1] == .F.}))>0
							aArraySetor[nPosSetor,1] := .T.
							If (nPosZona := Ascan(aArrayZona,{|x| x[3]+x[4] == aArraySetor[nPosSetor,3]+aArraySetor[nPosSetor,4] .And. x[1] == .F.}))>0
								aArrayZona[nPosZona,1] := .T.
								If (nPosRota := Ascan(aArrayRota,{|x| x[3] == aArraySetor[nPosSetor,3] .And. x[1] == .F.}))>0
									aArrayRota[nPosRota,1] := .T.
								EndIf
							EndIf
						EndDo
					Else
						If (nPosSetor := Ascan(aArraySetor,{|x| x[3]+x[4]+x[5] == TRBPED->PED_ROTA+TRBPED->PED_ZONA+TRBPED->PED_SETOR .And. x[1] == .F.}))>0
							aArraySetor[nPosSetor,1] := .T.
							If (nPosZona := Ascan(aArrayZona,{|x| x[3]+x[4] == TRBPED->PED_ROTA+TRBPED->PED_ZONA .And. x[1] == .F.}))>0
								aArrayZona[nPosZona,1] := .T.
								If (nPosRota := Ascan(aArrayRota,{|x| x[3] == TRBPED->PED_ROTA .And. x[1] == .F.}))>0
									aArrayRota[nPosRota,1] := .T.
								EndIf
							EndIf
						EndIf
					EndIf
				EndIf
				DbSkip()
			EndDo
		EndIf

	//End Transaction

	If lProcessa
		If lIntWms
			WmsAvalExe()
		EndIf
	EndIf
	
	If l200Auto .And. lProcessa .And. cCplInt == "1"
    	//-- Grava o numero da viagem do Cockpit na Carga
    	DbSelectArea("DK1")
		DK1->(DbSetOrder(2))
		If DK1->(MsSeek(xFilial("DK1") + DAI->DAI_FILIAL + DAI->DAI_PEDIDO))
			dbSelectArea("DAK") 
			RecLock("DAK", .F.)
			DAK->DAK_VIAROT := DK1->DK1_VIAGID
			MsUnLock()
			//--Grava o código da carga na viagem do CPL
			DbSelectArea("DK0")
		    DK0->(DbSetOrder(1))
			If DK0->(MsSeek(xFilial("DK0") + DK1->DK1_REGID + DK1->DK1_VIAGID))
				RecLock("DK0",.F.)
				DK0->DK0_CARGA	:= DAK->DAK_COD
				DK0->DK0_CARGER  := "1"
				MsUnLock()
			EndIf
			DK0->(dbCloseArea())
			dbCloseArea("DAK")
		EndIf
		DK1->(dbCloseArea()) 
    EndIf
	
	//-- Zero o array de sequencia na carga
	aArrayMan := {}
	RestArea( aAreaTRB )

	If !l200Auto
		oCargas:Refresh()
		oRotas:Refresh()
		oZonas:Refresh()
		oSetores:Refresh()
		oMark:oBrowse:Refresh()
	EndIf

	If lProcessa
		//-- Ponto de entrada no final do carregamento
		If lOms200Fim
			ExecBlock("OM200FIM",.F.,.F.)
		EndIf
	EndIf

EndIf

lDisrmTran := .F.

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Oms200CargaºAutor  ³DL                  º Data ³  01/17/01  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao de geracao de carga                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³ aArrayMan - Array contendo os pedidos que deve ser gerados º±±
±±º          ³             ja na sequencia de entrega                     º±±
±±º          ³             [1] - Sequencia                                º±±
±±º          ³             [2] - Rota                                     º±±
±±º          ³             [3] - Zona                                     º±±
±±º          ³             [4] - Setor                                    º±±
±±º          ³             [5] - Pedido                                   º±±
±±º          ³             [6] - Cliente                                  º±±
±±º          ³             [7] - Loja                                     º±±
±±º          ³ cCarga    - Numero da carga a ser gerada                   º±±
±±º          ³ cSeqCarga - Sequencia da carga                             º±±
±±º          ³ cVeiculo - Caminhao a ser gerado a carga                   º±±
±±º          ³ cMotorista- Motorista do veiculo                           º±±
±±º          ³ cAjuda1   - Ajudante 1                                     º±±
±±º          ³ cAjuda2   - Ajudante 2                                     º±±
±±º          ³ cAjuda3   - Ajudante 3                                     º±±
±±º          ³ cHrStart  - Hora de inicio de entrega                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP5                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function FBs200Carga(aArrayGera,cCarga,cSeqCar,cVeiculo,cMotorista,cAjuda1,cAjuda2,cAjuda3,cHrStart,dDtStart,nSaveSx8,aArrayFrt,aHeaderFrt,aColsFrt,aCargaAnt,cGvCodOper,cGvNoProc,cGvPedComOp,aHeaderAdt,aColsAdt,cDakTransp,lEndeWMS)

Local aArrayPto  := {}
Local aArraySeq  := {}
Local aRotas     := {}
Local cBusca     := ""
Local cMay       := ""

Local lGerou     := .F.
Local lOs200DAK  := ExistBlock("OS200DAK")
Local OS200Ger   := ExistBlock("OS200GER")

Local nPtoEntr   := 0
Local nSequencia := 0
Local nC         := 0
Local nSeqInc    := SuperGetMV("MV_OMSENTR" ,.F.,5)
Local lAlocVei   := SuperGetMv("MV_ALOCVEI",.F.,.T.)
//-- Variaveis utilizadas pela funcao wmsexedcf
Local nA         := 0

Local nCols      := 0
Local cIdent     := ""
Local lFreteEmb  := .F.
Local lContVei   := GetMV('MV_CONTVEI',,.F.) // Parametro para verificar se o sistema devera' controlar veiculo/motorista
Local aFieldValue:= {}
Local aStruModel := {}
Local cTransp    := ""
Local lIntGFE    := SuperGetMv("MV_INTGFE",,.F.)
Local lDakTrp    := DAK->( FieldPos( "DAK_TRANSP" ) ) > 0
Local lTpOp       := DAK->( ColumnPos( "DAK_CDTPOP" ) ) > 0 .AND. DAK->( ColumnPos( "DAK_CDCLFR" ) ) > 0
Local cDakTrp    := ""
Local lOMS200C   := .F.

Private cCgcTransp := ""

//--
Default cMotorista  := Criavar( "DA4_COD" ,.F. )
Default cAjuda1     := Criavar( "DAU_COD" ,.F. )
Default cAjuda2     := Criavar( "DAU_COD" ,.F. )
Default cAjuda3     := Criavar( "DAU_COD" ,.F. )
Default cSeqCar     := "01"
Default cHrStart    := "00:00"
Default dDtStart    := dDatabase
Default nSaveSX8    := 0
Default aArrayFrt   := Array(9)
Default aHeaderFrt  := {}
Default aColsFrt    := {}
Default aCargaAnt   := {}
Default cGvCodOper  := ""
Default cGvNoProc   := ""
Default cGvPedComOp := ""
Default aHeaderAdt  := {}
Default aColsAdt    := {}
Default cDakTransp  := Criavar("A4_COD",.F.)
Default lEndeWMS    := .F.

//-- Renumera a sequencia de entrega considerando intervalo conforme parametro: MV_OMSENTR
nSeqInc := IIF(nSeqInc > 0,nSeqInc,5)

If lDakTrp
	cDakTrp := Criavar( "DAK_TRANSP", .F.)
EndIf

SX1->( DbSetOrder( 1 ) )
If SX1->(DBSeek( PadR("OMS200C",Len(SX1->X1_GRUPO),' ')+"01"))
	lOMS200C := .T.
EndIf

aVisErr := {}
//-- Reordeno o array pois o usuario pode nao ter solicitado a visualizacao ordenada
For nC := 1 to Len(aArrayGera)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Calculo pontos de entrega³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If (Ascan(aArrayPto,{|x| x[1]+x[2]+x[3] == aArrayGera[nC,7]+aArrayGera[nC,8]+aArrayGera[nC,11]}) == 0)
		AAdd(aArrayPto, {aArrayGera[nC,7],aArrayGera[nC,8],aArrayGera[nC,11]})
	EndIf

	If (Ascan(aArraySeq,{|x| x[1]+x[2] == aArrayGera[nC,11]+aArrayGera[nC,5]}) == 0)
		nSequencia += nSeqInc
		AAdd(aArraySeq,{ aArrayGera[nC,11],aArrayGera[nC,5] })
	EndIf

	aArrayGera[nC,1] := StrZero(nSequencia,6)

Next nC

nPtoEntr := Len(aArrayPto)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifico se tenho um numero de carga pre-definido ou se ³
//³terei que gerar                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cCarga := Iif(cCarga == Nil, CriaVar("DAK_COD",.T.),cCarga)

DbSelectArea("DAK")
cMay := "DAK"+ Alltrim(xFilial("DAK"))
DAK->(DbSetOrder(1))
While ( DbSeek(xFilial("DAK")+cCarga) .or. !MayIUseCode(cMay+cCarga) )
	cCarga := Soma1(cCarga,Len(DAK->DAK_COD))
EndDo

ProcRegua(Len(aArrayGera))

// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
// ³ Gera o Arquivo DAK.                                         ³
// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If lFreteEmb
	cIdent := ProxIdVc()
EndIf

DbSelectArea("DAK")
RecLock("DAK",.T.)
DAK->DAK_COD    := cCarga
DAK->DAK_SEQCAR := cSeqCar
DAK->DAK_FILIAL := xFilial("DAK")
DAK->DAK_ROTEIR := If(Len(aArrayGera)>0,aArrayGera[Len(aArrayGera),2],"")
DAK->DAK_CAMINH := cVeiculo
DAK->DAK_MOTORI := cMotorista
DAK->DAK_AJUDA1 := cAjuda1
DAK->DAK_AJUDA2 := cAjuda2
DAK->DAK_AJUDA3 := cAjuda3
DAK->DAK_DATA   := dDtStart
DAK->DAK_HORA   := Time()
DAK->DAK_PESO   := 0
DAK->DAK_CAPVOL := 0
DAK->DAK_PTOENT := 0
DAK->DAK_VALOR  := 0
DAK->DAK_JUNTOU := "MANUAL"
DAK->DAK_FLGUNI := "2"
DAK->DAK_FEZNF  := "2"
DAK->DAK_ACECAR := "2"
DAK->DAK_ACEFIN := "2"
DAK->DAK_ACEVAS := "2"
DAK->DAK_HRSTAR := cHrStart
If lDakTrp
	DAK->DAK_TRANSP := cDakTransp
EndIf
If lFreteEmb
	DAK->DAK_IDENT  := cIdent
	/*
	DAK->DAK_CODOPE := cGvCodOper
	DAK->DAK_PRCTRA := cGvNoProc
	DAK->DAK_OPERPC := cGvPedComOp
	*/
EndIf
If lTpOp
	If !Empty(cDAKTpOp)
		DAK->DAK_CDTPOP := cDAKTpOp
	Else
		DAK->DAK_CDTPOP := SuperGetMv("MV_CDTPOP",.F.,"")
	EndIf	
	If !Empty(cDAKClFr)
		DAK->DAK_CDCLFR := cDAKClFr
	Else
		DAK->DAK_CDCLFR := SuperGetMv("MV_CDCLFR",.F.,"")
	EndIF
EndIf

MsUnlock()

DAK->(FkCommit())

//-- PE apos a geracao da carga
If	lOs200Dak
	ExecBlock("OS200DAK",.F.,.F.)
EndIf

// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
// ³ Gera o Arquivo DAI e atualizo os acumuladores do DAK        ³
// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For nSequencia := 1 to Len(aArrayGera)

	IncProc()

	aRotas := {}

	//Tratamento pois existe a possibilidade de nao existir o SC9
	If aArrayGera[nSequencia,9] > 0

		SC9->(DbGoTo(aArrayGera[nSequencia,9]))

		xCarga := SC9->C9_CARGA
		xSeqCar:= SC9->C9_SEQCAR

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Atualiza o SC9 com os dados da carga gerada                         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		DbSelectArea("SC9")
		Reclock("SC9",.F.)
		C9_CARGA   := cCarga
		C9_SEQCAR  := cSeqCar
		C9_SEQENT  := aArrayGera[nSequencia,1]
		If SC9->C9_STSERV != '3'
		   C9_ENDPAD  := aArrayGera[nSequencia,10]
		EndIf
		MsUnlock()
		
		If lOMS200C
			Pergunte("OMS200C",.F.)
			If mv_par01 == 1
				SC5->(DbSetOrder(1))
				If	SC5->(MsSeek(xFilial("SC5")+SC9->C9_PEDIDO)) .And. !Empty(cVeiculo)
					RecLock('SC5',.F.)
					SC5->C5_VEICULO := cVeiculo
					MsUnlock()
				Else				
					cVeiculo := SC5->C5_VEICULO							
				EndIf
			EndIf
		EndIf
	EndIf
//-- Avalia o SC9 para inclusao do DAI
//-- Array com os dados da roteirizacao
//   [01] Codigo da Rota
//   [02] Codigo da Zona
//   [03] Codigo do Setor
//   [04] Motorista
//   [05] Caminhao
//   [06] Ajudante 1
//   [07] Ajudante 2
//   [08] Ajudante 3
//   [09] Hora chegada
//   [10] Time Service
//   [11] Data chegada
//   [12] Data saida
//   [13] Hora de inicio de entrega
//   [14] Valor do Frete (DAI_VALFRE)*
//   [15] Frete Autonomo (DAI_FREAUT)*


	AAdd( aRotas ,aArrayGera[nSequencia,2]	)
	AAdd( aRotas ,aArrayGera[nSequencia,3]	)
	AAdd( aRotas ,aArrayGera[nSequencia,4]	)
	AAdd( aRotas ,cVeiculo					)
	AAdd( aRotas ,cMotorista				)
	AAdd( aRotas ,cAjuda1					)
	AAdd( aRotas ,cAjuda2					)
	AAdd( aRotas ,cAjuda3					)
	AAdd( aRotas ,aArrayGera[nSequencia,13]	)
	AAdd( aRotas ,aArrayGera[nSequencia,14]	)
	AAdd( aRotas ,aArrayGera[nSequencia,15]	)
	AAdd( aRotas ,aArrayGera[nSequencia,16]	)
	AAdd( aRotas ,cHrStart)
	If lFreteEmb
		AAdd( aRotas ,aArrayGera[nSequencia,17] )
		AAdd( aRotas ,aArrayGera[nSequencia,18] )
	EndIf
	lGerou := .T.

	If lFreteEmb
		If Len(aCargaAnt) > 0
			aCargaAnt[nSequencia][5] := cCarga
			aCargaAnt[nSequencia][6] := cSeqCar
			OSAvalDAI("DAI",5,aRotas,,aCargaAnt[nSequencia])
		Else
			//-- Inclui o item do SC9 na nova carga
			MaAvalSC9("SC9",7,,,,,,aRotas)
		EndIf
	Else
		//-- Inclui o item do SC9 na nova carga
		MaAvalSC9("SC9",7,,,,,,aRotas)
	EndIf
	//----------------------------------------------------------------------------------------------------------
	// Posicionamento no item do pedido de venda para buscar a TES informada e consistir atualização de estoque
	//----------------------------------------------------------------------------------------------------------
	dbSelectArea("SC6")
	If !(xFilial("SC6")==SC6->C6_FILIAL .And.;
			SC6->C6_NUM==SC9->C9_PEDIDO .And.;
			SC6->C6_ITEM==SC9->C9_ITEM .And.;
			SC6->C6_PRODUTO==SC9->C9_PRODUTO)
		dbSetOrder(1)
		MsSeek(xFilial("SC6")+SC9->(C9_PEDIDO+C9_ITEM+C9_PRODUTO))
	EndIf
	dbSelectArea("SF4")
	dbSetOrder(1)
	MsSeek(xFilial("SF4")+SC6->C6_TES)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Gera o Servico de WMS na montagem da Carga                          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If SF4->F4_ESTOQUE=="S" .And. IntWms(SC9->C9_PRODUTO) .And. !Empty(SC9->C9_SERVIC)
		SC5->(DbSetOrder(1))
		If SC5->(MsSeek(xFilial("SC5")+SC9->C9_PEDIDO))
			//-- 1=no Pedido;2=na Montagem da Carga;3=na Unitizacao da Carga
			If SC5->C5_GERAWMS == '2'
				WmsIntPed(SC9->(Recno()))
			ElseIf SC5->C5_GERAWMS == '1' .And. lEndeWMS
				WmsEndDCF(SC9->C9_ENDPAD,.F.)
			EndIf
		EndIf
	EndIf

	If lDakTrp .And. !Empty(cDakTransp)
		If SC5->(MsSeek(xFilial("SC5")+ aArrayGera [nSequencia,5]))
			RecLock('SC5',.F.)
			SC5->C5_TRANSP := cDakTransp
			MsUnlock()
		EndIf
	EndIf

Next nSequencia

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Grava os dados do Frete Embarcador.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If	lFreteEmb
	If Len(aHeaderFrt) > 0
		RecLock("DAS", .T.)
	 	DAS->DAS_FILIAL	:= xFilial('DAS')
		DAS->DAS_COD	:= aArrayFrt[FRETE_COD]
		DAS->DAS_SEQCAR	:= cSeqCar
		DAS->DAS_VALFRE	:= aArrayFrt[FRETE_VAL]
		DAS->DAS_INSRET	:= aArrayFrt[FRETE_INSS]
		DAS->DAS_VALPDG	:= aArrayFrt[FRETE_PEDAG]
		DAS->DAS_ADIFRE	:= aArrayFrt[FRETE_ADIANT]
		DAS->DAS_RATFRE	:= aArrayFrt[FRETE_RATEIO]
		DAS->DAS_FREAUT	:= aArrayFrt[FRETE_FREAUT]
		DAS->DAS_TABFRE	:= aArrayFrt[FRETE_TABFRE]
		DAS->DAS_TIPTAB	:= aArrayFrt[FRETE_TIPTAB]
		MsUnLock()

		For nCols := 1 To Len(aColsFrt)
			If !GdDeleted(nCols,aHeaderFrt,aColsFrt)
				If !Empty(aColsFrt[nCols,1]) //--Se estiver vazio nao gravo o DAT
					RecLock("DAT", .T.)
					DAT->DAT_FILIAL := xFilial('DAT')
					DAT->DAT_COD    := aArrayFrt[FRETE_COD]
					DAT->DAT_SEQCAR := cSeqCar
					For nA := 1 To Len(aHeaderFrt)
						If	aHeaderFrt[nA,10] != 'V'
							FieldPut(FieldPos(aHeaderFrt[nA,2]), aColsFrt[nCols,nA])
						EndIf
					Next nA
					MsUnLock()
				EndIf
			EndIf
		Next nCols

		If !Empty(aColsAdt)
			Oms200ASDG(3, aHeaderAdt, aColsAdt, cCarga, cSeqCar, cIdent, cVeiculo)
		EndIf

/*		For nCols := 1 To Len(aColsAdt)
			If !GdDeleted(nCols,aHeaderAdt,aColsAdt)
				RecLock("SDG", .T.)
				SDG->DG_FILIAL := xFilial('SDG')
				SDG->DG_IDENT  := cIdent
				SDG->DG_TIPUSO := '2'
				SDG->DG_CODVEI := cVeiculo
				For nA := 1 To Len(aHeaderAdt)
					If	aHeaderAdt[nA,10] != 'V'
						FieldPut(FieldPos(aHeaderAdt[nA,2]), aColsAdt[nCols,nA])
					EndIf
				Next nA
				MsUnLock()
			EndIf
 		Next nCols */
		OmsFretPV(cCarga,cSeqCar)
		If	lContVei
			//-- Altera Status de Veiculo para Reservado
			aAltStaDTU("2",cVeiculo,,,'2',cIdent)
			//-- Altera Status de Motorista para Reservado
			aAltStaDTO("2",cMotorista,,,'2',cIdent)
		EndIf
	EndIf
EndIf

// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
// ³ Reserva o veiculo                                           ³
// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If	lAlocVei
	If !Empty(cVeiculo)
		OsVAgenda(cCarga,cSeqCar,cVeiculo,1)
	EndIf
EndIf

If	lGerou
	While ( GetSx8Len() > nSaveSx8 )
		ConfirmSX8()
	EndDo
Else
	While ( GetSx8Len() > nSaveSx8 )
		RollBackSX8()
	EndDo
EndIf

//-- PE aCpos a geracao da carga e itens de carga
If	OS200Ger
	ExecBlock("OS200GER",.F.,.F.)
EndIf

If lIntGFE .And. FindFunction("MaEnvEAI")
	cTransp 	:= Posicione('SC5',1,xFilial('SC5')+Posicione("DAI",1,xFilial("DAI")+cCarga+cSeqCar,"DAI_PEDIDO"),'C5_TRANSP')
	cCgcTransp  := Posicione('SA4',1,xFilial('SA4')+cTransp,'A4_CGC')

	If !Empty(cTransp)
		aFieldValue := { { "DAK_CDTPOP", { || SuperGetMv("MV_CDTPOP",.F.,"")} },;
		                 { "DAK_CGCTRA", { || cCGCTransp                    } } }

		Aadd(aStruModel, { "DAK", "OMSA200_DAK", NIL, NIL, NIL, aFieldValue } )
		MaEnvEAI(,,3,"OMSA200",aStruModel)
	EndIf
ElseIf FindFunction("MaEnvEAI")
	Aadd(aStruModel, { "DAK", "OMSA200_DAK", NIL, NIL, NIL, aFieldValue } )
	MaEnvEAI(,,3,"OMSA200",aStruModel)
EndIf
Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³OmsAbreCargaºAutor  ³DL                  º Data ³ 12/26/00  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Abre Carga Disponivel                                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³ aArrayCarga - Array  de cargas passado por referencia      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP5                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function OmsAbreCarga(oEnable, oDisable, oMarked ,oNoMarked, aArrayCarga ,nSaveSx8, aHeaderAdt, aColsAdt, cDakTransp,aArrayRota,aArrayZona,aArraySetor)
Local cCarga    := ""
Local cPictVal  := "99999999." + Replicate("9",TamSx3("DAK_VALOR")[2])
Local cPictVol  := "99999999." + Replicate("9",TamSx3("DAK_CAPVOL")[2])
Local cPictPeso := "99999999." + Replicate("9",TamSx3("DAK_PESO")[2])
Local cPictQtde := "99999999." + Replicate("9",TamSx3("C9_QTDLIB")[2])
Local nC        := 0
Local lOpen     := .T.
Local bLineSav  := oCargas:bLine
Local bLinSRot  := oRotas:bLine
Local bLinSZon  := oZonas:bLine
Local bLinSSet  := oSetores:bLine 
Local _x 		  := 0

DEFAULT nSaveSX8   := 0
DEFAULT aHeaderAdt := {}
DEFAULT aColsAdt   := {}
DEFAULT cDakTransp := Criavar("A4_COD",.F.)
DEFAULT aArrayCarga  := {}
DEFAULT aArrayRota  := {}
DEFAULT aArrayZona  := {}
DEFAULT aArraySetor  := {}
If DAK->( ColumnPos( "DAK_CDTPOP" ) ) > 0 .AND. DAK->( ColumnPos( "DAK_CDCLFR" ) ) > 0
	Default cDAKTpOp  := Criavar("DAK_CDTPOP",.F.)
	Default cDAKClFr  := Criavar("DAK_CDCLFR",.F.)
Else
	Default cDAKTpOp  := ""
	Default cDAKClFr  := ""
EndIf


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifico se existem cargas abertas para geracao³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For nC := 1 to Len(aArrayCarga)
	If aArrayCarga[nC,CARGA_ENABLE]
		Help(" ",1,"OMSCGABERT") //Ja existem cargas abertas para geracao
		lOpen := .F.
	EndIf
Next nC

If lOpen
	//-- Limpa o conteudo do Array de adiantamento.
	aHeaderAdt	:= {}
	aColsAdt	:= {}

	nSaveSx8 := Getsx8Len()
	cCarga   := GetSX8Num("DAK","DAK_COD")
	
	cDakTransp := Criavar("A4_COD",.F.)
	cDAKTpOp   := Criavar("DAK_CDTPOP",.F.)
	cDAKClFr   := Criavar("DAK_CDCLFR",.F.)

	If Len(aArrayCarga) >= 1 .And. !Empty(aArrayCarga[1,CARGA_COD])
		AAdd(aArrayCarga,{.T.,;
		cCarga,;
		OemtoAnsi(STR0040)+cCarga,; //"CARGA"
		TransForm(0,cPictPeso),;
		TransForm(0,cPictVal),;
		TransForm(0,cPictVol),;
		TransForm(0,cPictQtde),;
		StrZero(0,6),;
		Space(7),;
		Space(Len(DA3->DA3_COD)),;
		Space(Len(DA4->DA4_COD)),;
		Space(Len(DAU->DAU_COD)),;
		Space(Len(DAU->DAU_COD)),;
		Space(Len(DAU->DAU_COD)),;
		TransForm(0,cPictPeso),;
		TransForm(0,cPictQtde),;
		TransForm(0,cPictVol),;
		TransForm(0,cPictVal),;
		TransForm(0,cPictPeso),;
		TransForm(0,cPictQtde),;
		TransForm(0,cPictVol),;
		TransForm(0,cPictVal),;
		Space(6),;
		Space(10),;
		Space(4)})
		//-- Ponto de entrada para adicionar campos na opcao Sequencia de Entrega.
		If	ExistBlock("OM200AD2")
			aRetCarga := ExecBlock("OM200AD2",.F.,.F.,{oCargas, aArrayCarga, oCargas:aHeaders, oCargas:bLine, oEnable, oDisable})
			If	ValType(aRetCarga[1]) == "A" .And. ValType(aRetCarga[2]) == "A" .And. ValType(aRetCarga[3]) == "B"
				aArrayCarga := aRetCarga[1]
				bLineSav    := aRetCarga[3]
			EndIf
		EndIf
		For _x := 1 To Len(aArrayRota)
			aArrayRota[_x,5] := cCarga
		Next
		For _x := 1 To Len(aArrayZona)
			aArrayZona[_x,6] := cCarga
		Next
		
		For _x := 1 To Len(aArraySetor)
			aArraySetor[_x,7] := cCarga
		Next
	Else
		aArrayCarga[1,CARGA_ENABLE] := .T.
		aArrayCarga[1,CARGA_COD]    := cCarga
		aArrayCarga[1,CARGA_DESC]   := OemtoAnsi(STR0040) + cCarga //"CARGA "
		aArrayCarga[1,CARGA_PESO]   := TransForm(0,cPictPeso)
		aArrayCarga[1,CARGA_VALOR]  := TransForm(0,cPictVal)
		aArrayCarga[1,CARGA_VOLUM]  := TransForm(0,cPictVol)
		aArrayCarga[1,CARGA_QTDLIB] := TransForm(0,cPictQtde)
		aArrayCarga[1,CARGA_PTOENT] := StrZero(0,6)
		aArrayCarga[1,CARGA_VEIC]   := Space(Len(DA3->DA3_COD))
		aArrayCarga[1,CARGA_MOTOR]  := Space(Len(DA4->DA4_COD))
		aArrayCarga[1,CARGA_AJUD1]  := Space(Len(DAU->DAU_COD))
		aArrayCarga[1,CARGA_AJUD2]  := Space(Len(DAU->DAU_COD))
		aArrayCarga[1,CARGA_AJUD3]  := Space(Len(DAU->DAU_COD))
		aArrayCarga[1,CARGA_PESCIF] := TransForm(0,cPictPeso)
		aArrayCarga[1,CARGA_QTDCIF] := TransForm(0,cPictQtde)
		aArrayCarga[1,CARGA_VOLCIF] := TransForm(0,cPictVol)
		aArrayCarga[1,CARGA_VALCIF] := TransForm(0,cPictVal)
		aArrayCarga[1,CARGA_PESFOB] := TransForm(0,cPictPeso)
		aArrayCarga[1,CARGA_QTDFOB] := TransForm(0,cPictQtde)
		aArrayCarga[1,CARGA_VOLFOB] := TransForm(0,cPictVol)
		aArrayCarga[1,CARGA_VALFOB] := TransForm(0,cPictVal)
		aArrayCarga[1,CARGA_TPOP]   := Space(Len(DAK->DAK_CDTPOP))
		aArrayCarga[1,CARGA_CLFR]   := Space(Len(DAK->DAK_CDCLFR))
	EndIf
EndIf

If !l200Auto
	oCargas:SetArray(aArrayCarga)
	oCargas:bLine := bLineSav
	oCargas:nAt   := Len(aArrayCarga)
	oCargas:Refresh()
	oRotas:SetArray(aArrayRota)
	oRotas:bLine := bLinSRot
	oRotas:nAt   := 1
	oRotas:Refresh()
	oZonas:SetArray(aArrayZona)
	oZonas:bLine := bLinSZon
	oZonas:nAt   := 1
	oZonas:Refresh()
	
	
	oSetores:SetArray(aArraySetor)
	oSetores:bLine := bLinSSet
	oSetores:nAt   := 1
	oSetores:Refresh()
Endif

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³OmsFilTipoºAutor  ³DL                  º Data ³  05/04/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Mastra janela inicial da montagem de carga para filtrar os  º±±
±±º          ³tipos de carga.                                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP5                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function OmsFilTipo(oMarked,oNoMarked,aArrayMod,aArrayTipo)
Local lRet    := .T.
Local cBitMap := ""
Local lDisable:= .F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Carrega perguntas do OMSA200 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Pergunte("OMS200",.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Busca modelos de carga e joga no array³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DbSelectArea("DB0")
DB0->(DbSetOrder(1))
DB0->(MsSeek(xFilial("DB0")))

While DB0->(!Eof() .And. DB0_FILIAL == xFilial("DB0"))
	AAdd(aArrayMod,{.F.,DB0->DB0_CODMOD,DB0->DB0_DESMOD,DB0->DB0_TIPCAR})
	DbSkip()
EndDo

If Len(aArrayMod) == 0
	AAdd(aArrayMod,{.F.,CriaVar("DB0_CODMOD",.F.),CriaVar("DB0_DESMOD",.F.),CriaVar("DB0_TIPCAR",.F.)})
	lDisable := .T.
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Busca tipos de carga e joga no array³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DbSelectArea("SX5")
SX5->(DbSetOrder(1))
MsSeek(xFilial("SX5")+"DU")

While !Eof() .And. X5_FILIAL+X5_TABELA == xFilial("SX5")+"DU"
	AAdd(aArrayTipo,{.F.,X5_CHAVE,X5Descri()})
	DbSkip()
EndDo

If Len(aArrayTipo) == 0
	AAdd(aArrayTipo,{.F.,Space(6),Space(30)})
EndIf

DEFINE FONT oFont NAME "Arial" SIZE 0, -11

cBitmap := "PROJETOAP"

If !l200Auto
	DEFINE MSDIALOG oDlg TITLE OemtoAnsi(STR0079) FROM 0,0 TO 300,620 OF oMainWnd PIXEL //"Tipos de Cargas"
	@ 0 , 0 BITMAP oBmp RESNAME cBitMap OF oDlg SIZE 48,488 NOBORDER WHEN .F. PIXEL
	@ 25,50 TO 26,500 OF oDlg Pixel
	@ 03, 50 SAY OemtoAnsi(STR0080) OF oDlg Pixel //"Esta rotina ira montar o mapa de Rotas, Zonas, Setores e Pedidos disponiveis"
	@ 10, 50 SAY OemtoAnsi(STR0081) OF oDlg Pixel //"para a montagem de carga de acordo com os parametros escolhidos pelo usuario."
	
	@ 28, 50 SAY OemtoAnsi(STR0082) OF oDlg Pixel //"Grupos de Carga"
	@ 28,180 SAY OemtoAnsi(STR0079) OF oDlg Pixel //"Tipos de Carga"
	
	@ 35,50 LISTBOX oModelo Var cModelo FIELDS HEADER " ",;
		OemToAnsi(STR0013),; //"Codigo"
		OemtoAnsi(STR0020) SIZE 125,85 ; //"Descricao"
		ON DBLCLICK (OmsTrocaTip(1,;
		@aArrayMod,;
		@aArrayTipo,;
		@oMarked,;
		@oNoMarked)) OF oDlg PIXEL
	
		oModelo:nFreeze := 0
		oModelo:SetArray(aArrayMod)
		oModelo:bHeaderClick:= {|oObj,nCol| If(nCol==1,FBsMarcaTip(1,@aArrayMod,@aArrayTipo,@oMarked,@oNoMarked),)}
		oModelo:bLine:={||{Iif(aArrayMod[oModelo:nAT,1],oMarked,oNoMarked),;
		aArrayMod[oModelo:nAT,2],;
		aArrayMod[oModelo:nAT,3]}}
	
	@ 35,180 LISTBOX oTipo Var cTipo FIELDS HEADER " ",;
		OemToAnsi(STR0013),; //"Codigo"
		OemtoAnsi(STR0020) SIZE 125,85 ; //"Descricao"
		ON DBLCLICK (OmsTrocaTip(2,;
		@aArrayMod,;
		@aArrayTipo,;
		@oMarked,;
		@oNoMarked)) OF oDlg PIXEL
	
		oTipo:nFreeze := 0
		oTipo:SetArray(aArrayTipo)
		oTipo:bHeaderClick:= {|oObj,nCol| If(nCol==1,FBsMarcaTip(2,@aArrayMod,@aArrayTipo,@oMarked,@oNoMarked),)}
		oTipo:bLine:={||{Iif(aArrayTipo[oTipo:nAT,1],oMarked,oNoMarked),;
		aArrayTipo[oTipo:nAT,2],;
		aArrayTipo[oTipo:nAT,3]}}
	
	If lDisable
		oTipo:Disable()
		oModelo:Disable()
	EndIf
	
	If l200Auto
		Return .T.
	EndIf
	
	DEFINE SBUTTON oBut1 FROM 130, 220 TYPE 5 ENABLE OF oDlg PIXEL ACTION Pergunte("OMS200",.T.)
	DEFINE SBUTTON oBut2 FROM 130, 250 TYPE 1 ENABLE OF oDlg PIXEL ACTION (oDlg:End())
	DEFINE SBUTTON oBut3 FROM 130, 280 TYPE 2 ENABLE OF oDlg PIXEL ACTION (lRet := .F.,oDlg:End())
	
	ACTIVATE MSDIALOG oDlg CENTERED
Endif

Return( lRet )

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³OmsTrocaTipºAutor  ³Microsiga           º Data ³  05/04/01  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Troca a marca no filtro de grupos de cargas                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP5                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function OmsTrocaTip(nOpcao,aArrayMod,aArrayTipo,oMarked,oNoMarked)
Local lMarca   := .T.
Local nPosTipo := 0
Local nCntFor  := 0

If nOpcao == 1
	oObjMark := Iif(aArrayMod[oModelo:nAt,1],.F.,.T.)
	aArrayMod[oModelo:nAt,1] := oObjMark
	nPosTipo := Ascan(aArrayTipo,{|x| Trim(x[2]) == Trim(aArrayMod[oModelo:nAt,4])})
	If nPosTipo > 0
		aArrayTipo[nPosTipo,1]   := oObjMark
	EndIf
Else
	oObjMark := Iif(aArrayTipo[oTipo:nAt,1],.F.,.T.)
	aArrayTipo[oTipo:nAt,1] := oObjMark
	For nCntFor := 1 to Len(aArrayMod)
		If Trim(aArrayMod[nCntFor,4]) == Trim(aArrayTipo[oTipo:nAt,2])
			aArrayMod[nCntFor,1] := oObjMark
		EndIf
	Next nCntFor
EndIf

oModelo:Refresh()
oTipo:Refresh()

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³OmsMarcaTipºAutor  ³VICCO               º Data ³  14/05/09  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Troca a marca no filtro de grupos de cargas                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP5                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function FBsMarcaTip(nOpcao,aArrayMod,aArrayTipo,oMarked,oNoMarked)
Local nCntFor := 0
Local lMarca  := Nil
If nOpcao == 1
	For nCntFor := 1 to Len(aArrayMod)
		If	(lMarca==Nil)
			lMarca := aArrayMod[nCntFor,1]
		EndIf
		If	aArrayMod[nCntFor,1] == lMarca
			oModelo:nAt := nCntFor
			OmsTrocaTip(1,@aArrayMod,@aArrayTipo,@oMarked,@oNoMarked)
		EndIf
	Next nCntFor
	oModelo:nAt := 1
Else
	For nCntFor := 1 to Len(aArrayTipo)
		If	(lMarca==Nil)
			lMarca := aArrayTipo[nCntFor,1]
		EndIf
		If	aArrayTipo[nCntFor,1]==lMarca
			oTipo:nAt := nCntFor
			OmsTrocaTip(2,@aArrayMod,@aArrayTipo,@oMarked,@oNoMarked)
		EndIf
	Next nCntFor
	oTipo:nAt := 1
EndIf
oModelo:Refresh()
oTipo:Refresh()

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³OmsBuscaPedºAutor  ³DL                  º Data ³  01/02/01  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Monta Pedidos nos arrays para marcacao                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³ aArrayCarga - Array  de cargas passado por referencia      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP5                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function OmsBuscaPed(oEnable,;
							oDisable,;
							oMarked,;
							oNoMarked,;
							aCampos,;
							cCarga,;
							aArrayCarga,;
							aArrayRota,;
							aArrayZona,;
							aArraySetor,;
							aArrayMod,;
							aArrayTipo,;
							oProcess,;
							oTempTable)
Local aRegDA7    := {}
Local cIndSc9    := ""
Local cCondicao  := ""
Local cKey       := ""
Local cCliente   := ""
Local cLoja      := ""
Local cQry       := ""
Local cCodRota   := CriaVar("DA8_COD",.F.)
Local cDescRota  := CriaVar("DA8_DESC",.F.)
Local cZona      := CriaVar("DA7_PERCUR",.F.)
Local cSetor     := CriaVar("DA7_ROTA",.F.)
Local cSequencia := Space(6)
Local cCpoPeso   := IIf(Getmv("MV_PESOCAR") == "L","B1_PESO","B1_PESBRU")
Local cPtoRefDA6 := ""
Local cPtoRefDA5 := ""
Local cSeqRota   := ""
Local cPictVal   := "99999999." + Replicate("9",TamSx3("DAK_VALOR")[2])
Local cPictVol   := "99999999." + Replicate("9",TamSx3("DAK_CAPVOL")[2])
Local cPictPeso  := "99999999." + Replicate("9",TamSx3("DAK_PESO")[2])
Local cPictQtde  := "99999999." + Replicate("9",TamSx3("C9_QTDLIB")[2])
Local cAlias     := ""
Local cAliasSB1  := ""
Local cAliasSC5  := ""
Local cAliasCli  := ""
Local cCpoNomCli := ""
Local cCpoBaiCli := ""
Local cCpoEndCli := ""
Local cCpoMunCli := ""
Local cCpoEstCli := ""
Local cCpoCepCli := ""
Local cArq       := ""
Local cFilBack   := cFilAnt
Local cSeekSb1   := ""
Local cRota      := ""
Local cTpFrete   := ""

Local bWhile     := {||}
Local lAchou     := .F.
Local lValido    := .F.
Local lTipCarga  := .T.
Local lLocalEnt  := SC5->(FieldPos("C5_CLIENT"))  > 0
Local lContinua  := .F.
Local lRetPE     := .F.
Local cRetPE     := ""
Local aRetPE     := {}
Local lLockSC5   := SuperGetMv("MV_CGLOCK",.F.,.F.)
Local lTransp    := SuperGetMv("MV_CGTRANS",.F.,.F.)
Local lRotAtv    := SuperGetMv("MV_ROTATV",.F.,"2") == "2"
Local cAlocPer   := SuperGetMv("MV_ALOCPER",.F.,"N")
Local nSeqInc    := SuperGetMV("MV_OMSENTR",.F.,5)
Local nIndSc9    := 0
Local nRecno     := 0
Local nPesoProd  := 0
Local nPosPedido := 0
Local nSequencia := 0
Local nValor     := 0
Local nCapVol    := 0
Local nQtdLib    := 0
Local nCapArm    := 0
Local nTipoOper  := OsVlEntCom()
Local nRegDA7    := 0
Local lFreteEmb  := .F.
Local nPosRota   := 0
Local lOM200DA7  := ExistBlock("OM200DA7")
Local lOM200PED  := ExistBlock("OM200PED") .AND. ExecBlock("OM200PED",.F.,.F.)
Local lOM200VLD  := ExistBlock("OM200VLD")
Local lOM200TPC  := ExistBlock("OM200TPC")
Local lOM200CLI  := ExistBlock("OM200CLI")
Local lOM200GRV  := ExistBlock("OM200GRV")
Local cDakTrp	 := ""
Local lPergOM20  := .F.
Local lParRota   := Om200VldSX1("OMS200", "MV_CHL")[1][1]
Local lParGrpCli := Om200VldSX1("OMS200", "MV_CHJ")[1][1]
Local cRotaAte   := ""
Local cRotaDe    := ""
Local cGrpCliDe  := ""
Local cGrpCliAte := ""
Local lAchouDA9  := .F.
Local cRotCep    := SuperGetMv("MV_ROTCEP",.F.,"1")


//-- Refresh: verificar se foi alterado parametro Aglutina por? Pedidos/Itens
If	Select("TRBPED")>0 .And. mv_par06==2 .And. aScan(aCampos,{|x|x[1]=="PED_CODPRO"})==0
	aCampos := {}
	DbSelectArea("TRBPED")
	DbCloseArea()
	DbSelectArea("DAK")
EndIf

//-- Criar TRB de Pedidos para uso na MsSelect
If	Select("TRBPED")==0 
	Os200CriaTrb(@aCampos,oTempTable)
Else
	DbSelectArea("TRBPED")
	dbGotop()
	While !Eof()
		RecLock("TRBPED",.f.)
		dbDelete()
		dbSkip()
	End
EndIf

If	TcSrvType() != "AS/400"
	cQry := "SELECT C9_FILIAL,C9_PRODUTO,C9_CLIENTE,C9_LOJA,C9_QTDLIB,C9_PRCVEN,"
	cQry += "C9_PEDIDO,C9_ITEM,C9_SEQUEN,C9_ENDPAD,SC9.R_E_C_N_O_ RECNO,"
	cQry += "B1_TIPCAR,SB1.R_E_C_N_O_ RECSB1,"
		If lParGrpCli
			cGrpCliDe  := Om200VldSX1("OMS200", "MV_CHJ")[1][2]
			cGrpCliAte := Om200VldSX1("OMS200", "MV_CHK")[1][2]
		EndIf

		If lParRota
			cRotaDe  := Om200VldSX1("OMS200", "MV_CHL")[1][2]
			cRotaAte := Om200VldSX1("OMS200", "MV_CHM")[1][2]
			If !Empty(cRotaDe) .And. !Empty(cRotaAte)
				cQry += " DA7.R_E_C_N_O_ RECDA7, DA9.R_E_C_N_O_ RECDA9, "
			EndIf
		EndIf
	cQry += "SC5.C5_LOJAENT,SC5.C5_TIPO,SC5.R_E_C_N_O_ RECSC5 "
	If	lLocalEnt
		cQry += ",SC5.C5_CLIENT"
	EndIf
	If	lFreteEmb
		cQry += ",SC5.C5_TPFRETE"
	EndIf
	cQry += " FROM "+RetSqlName('SC9')+" SC9, "
	cQry += RetSqlName('SC5')+" SC5, "
	cQry += RetSqlName('SC6')+" SC6, "
	cQry += RetSqlName('SB1')+" SB1 "

		If (lParGrpCli .And. !Empty(cGrpCliAte) .And. !Empty(cGrpCliDe)) .Or. (lParRota .And. !Empty(cRotaDe) .And. !Empty(cRotaAte))
			cQry += ", " + RetSqlName('SA1')+" SA1 "
		EndIf

		If lParRota .And. !Empty(cRotaDe) .And. !Empty(cRotaAte)
			cQry += ", " + RetSqlName('DA7')+" DA7, "
			cQry += RetSqlName('DA9')+" DA9 "
		EndIf
	cQry += " WHERE "
	If	nTipoOper == 1
		cQry += "C9_FILIAL ='"+xFilial("SC9")+"'"
	Else
		cQry += "C9_FILIAL >= '"+mv_par09+"' AND C9_FILIAL <= '"+mv_par10+"'"
	EndIf
	cQry += " AND C9_CARGA    = '"+Space(Len(SC9->C9_CARGA)) +"'"
	cQry += " AND C9_SEQCAR   = '"+Space(Len(SC9->C9_SEQCAR))+"'"
	cQry += " AND C9_PEDIDO  >= '"+mv_par01+"' AND C9_PEDIDO  <='"+mv_par02+"'"
	cQry += " AND C9_CLIENTE >= '"+mv_par03+"' AND C9_CLIENTE <='"+mv_par04+"'"
	cQry += " AND C9_LOJA    >= '"+mv_par13+"' AND C9_LOJA    <='"+mv_par14+"'"
	cQry += " AND C9_ENDPAD  >= '"+mv_par07+"' AND C9_ENDPAD  <='"+mv_par08+"'"
		If !Empty(mv_par11) .Or. !Empty(mv_par12)
			cQry += " AND C9_DATALIB >= '"+Dtos(mv_par11)+"'"
			cQry += " AND C9_DATALIB <= '"+Dtos(mv_par12)+"'"
		EndIf
	If ValType(mv_par17) == "N"
		cQry += " AND C9_LOCAL BETWEEN '"+mv_par18+ "' AND '"+mv_par19+"'"
	Else
		cQry += " AND C9_LOCAL BETWEEN '"+mv_par17+ "' AND '"+mv_par18+"'"	
	EndIf
	cQry += " AND C9_BLCRED   = '"+Space(Len(SC9->C9_BLCRED))+"'"
//	cQry += " AND C9_BLEST    = '"+Space(Len(SC9->C9_BLEST)) +"'"
	cQry += " AND C9_TPCARGA  = '1'"
	If SC6->(ColumnPos("C6_INTROT")) > 0 .And. !l200Auto
		cQry += " AND C6_INTROT	 <> '2'"
	EndIf
	cQry += " AND SC9.D_E_L_E_T_ = ' '"
	If	nTipoOper == 1
		cQry += " AND SB1.B1_FILIAL = '"+xFilial("SB1")+"'"
	Else
		cQry += " AND SB1.B1_FILIAL = " +OsFilQry("SB1","SC9.C9_FILIAL")
	EndIf
	cQry += " AND SB1.B1_COD = C9_PRODUTO"
	cQry += " AND SB1.D_E_L_E_T_ = ' '"
	cQry += " AND SC5.C5_FILIAL = SC9.C9_FILIAL"
	cQry += " AND SC5.C5_NUM = SC9.C9_PEDIDO"
	If !lTransp
		cQry += " AND SC5.C5_TRANSP = '"+Space(Len(SC5->C5_TRANSP))+"'"
	EndIf
	cQry += " AND SC5.D_E_L_E_T_ = ' '"
	cQry += " AND SC6.C6_FILIAL = SC9.C9_FILIAL"
	cQry += " AND SC6.C6_NUM = SC9.C9_PEDIDO"
	cQry += " AND SC6.C6_ITEM = SC9.C9_ITEM"
	cQry += " AND SC6.C6_PRODUTO = SC9.C9_PRODUTO"
	//-- Filtra data de entrega
	If mv_par06 = 1 //--Por pedido
		cQry += " AND SC5.C5_FECENT BETWEEN '" + DtoS(mv_par15) + "'"
		cQry += " AND '"+ DtoS(mv_par16) + "' "
	Else //--Por Item
		cQry += " AND SC6.C6_ENTREG BETWEEN '" + DtoS(mv_par15) + "'"
		cQry += " AND '"+ DtoS(mv_par16) + "' "			  
	EndIf
	cQry += " AND SC5.D_E_L_E_T_ = ' '"   
	cQry += " AND SC6.D_E_L_E_T_ = ' '"
	If	cPaisLoc <> "BRA"
		cQry += " AND C9_REMITO ='"+Space(Len(SC9->C9_REMITO))+"'"
		cQry += " AND SC5.C5_NUM    = SC9.C9_PEDIDO"
		cQry += " AND SC5.C5_DOCGER <> '3'"
	EndIf
	//PONTO DE FUNÇÃO PARA EXPEDIÇÃO AGROINDUSTRIA
		If FindFunction("OGX225H") .And. (SuperGetMV("MV_AGRUBS",.F.,.F.))
			cQry := OGX225H(lLocalEnt,lFreteEmb,nTipoOper,l200Auto,lTransp,cPaisLoc)
		EndIf
	//-- Filtro por grupo de clientes
		If lParGrpCli .And. !Empty(cGrpCliDe) .And. !Empty(cGrpCliAte)
			cQry += " AND A1_FILIAL = '"+xFilial("SA1")+"'"
			cQry += " AND A1_COD = C9_CLIENTE "
			cQry += " AND A1_LOJA = C9_LOJA "
			cQry += " AND A1_GRPVEN BETWEEN '" + Om200VldSX1("OMS200", "MV_CHJ")[1][2] + "' AND '" + Om200VldSX1("OMS200", "MV_CHK")[1][2] +"'"
			cQry += " AND SA1.D_E_L_E_T_ = ' '"
			lPergOM20 := .T.
		EndIf
		//-- Filtro por Rota
		If lParRota
			If !Empty(cRotaDe) .And. !Empty(cRotaAte)
				If !lPergOM20
					cQry += " AND A1_FILIAL = '"+xFilial("SA1")+"'"
					cQry += " AND A1_COD = C9_CLIENTE "
					cQry += " AND A1_LOJA = C9_LOJA "
					cQry += " AND SA1.D_E_L_E_T_ = ' '"
				EndIf

				cQry += " AND DA9_FILIAL = '" + xFilial("DA9") + "'"
				cQry += " AND DA7_FILIAL = '" + xFilial("DA7") + "'"
				If cRotCep == "2"
					cQry += " AND COALESCE((A1_CEPE, A1_CEP) BETWEEN DA7_CEPDE AND DA7_CEPATE "
				ElseIf cRotCep == "3"
					cQry += " AND (A1_CEPE BETWEEN DA7_CEPDE AND DA7_CEPATE "
				Else
					cQry += " AND (A1_CEP BETWEEN DA7_CEPDE AND DA7_CEPATE "
				EndIf
				cQry += " OR A1_COD = DA7_CLIENT AND A1_LOJA = DA7_LOJA )  "
				cQry += " AND DA9_PERCUR = DA7_PERCUR AND DA9_ROTA = DA7_ROTA  "
				cQry += " AND DA9_ROTEIR BETWEEN '" + cRotaDe  + "' AND '" + cRotaAte + "'"
				cQry += " AND DA9.D_E_L_E_T_ = ' '"
				cQry += " AND DA7.D_E_L_E_T_ = ' '"
			EndIf
		EndIf
	If	ExistBlock("OM200QRY")
		cRetPE := ExecBlock("OM200QRY",.F.,.F.,{ cQry , aArrayTipo,aArrayMod })
		cQry   := If(ValType(cRetPE)=="C", cRetPE, cQry)
	EndIf
	cQry += " ORDER BY C9_FILIAL,C9_CLIENTE,C9_LOJA,C9_PEDIDO,C9_ITEM"
	cQry := ChangeQuery(cQry)
	dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQry),"TRBSC9",.F.,.T.)

	cAlias    := "TRBSC9"
	cAliasSB1 := "TRBSC9"
	cAliasSC5 := "TRBSC9"
Else
	//-- Filtro pedidos liberados e com carga
	DbSelectArea("SC9")
	SC9->(DbSetOrder(2))
	cIndSC9 := CriaTrab(Nil,.F.)
	cKey := IndexKey()
	cCondicao := 'C9_CARGA+C9_SEQCAR+C9_BLCRED+C9_BLEST=="'+Space(Len(SC9->C9_CARGA)+Len(SC9->C9_SEQCAR)+Len(SC9->C9_BLCRED)+Len(SC9->C9_BLEST))+'".And.'
	cCondicao += 'C9_PEDIDO >= "'+mv_par01+'".And.C9_PEDIDO <="'+mv_par02+'".And.'
	cCondicao += 'C9_CLIENTE >= "'+mv_par03+'".And.C9_CLIENTE <="'+mv_par04+'".And.'
	cCondicao += 'C9_LOJA >= "'+mv_par13+'".And.C9_LOJA <="'+mv_par14+'".And.'
	cCondicao += 'C9_ENDPAD >= "'+mv_par07+'".And.C9_ENDPAD <="'+mv_par08+'".And.'
	If !Empty(mv_par11) .Or. !Empty(mv_par12)
		cCondicao += "Dtos(C9_DATALIB)>='"+Dtos(mv_par11)+"' .And."
		cCondicao += "Dtos(C9_DATALIB)<='"+Dtos(mv_par12)+"' .And."
	EndIf
	cCondicao += 'C9_TPCARGA="1"'
	If	cPaisLoc <> "BRA"
		cCondicao += " .And. Empty(C9_REMITO) "
	EndIf
	If	nTipoOper == 1
		cCondicao += '.And.C9_FILIAL="'+xFilial("SC9")+'"'
	Else
		cCondicao += '.And. C9_FILIAL >="'+mv_par09+'"'
		cCondicao += '.And. C9_FILIAL <="'+mv_par10+'"'
	EndIf
	If ExistBlock("OM200FIL")
		cRetPE := ExecBlock("OM200FIL",.F.,.F.)
		If ValTYpe(cRetPE)=="C"
			cCondicao += ".And."+cRetPE
		EndIf
	EndIf
	IndRegua("SC9",cIndSC9,cKey,,cCondicao,OemtoAnsi(STR0041)) //"Selecionando Registros ..."
	nIndSC9 := RetIndex("SC9")
	DbSetOrder(nIndSC9+1)

	cAlias    := "SC9"
	cAliasSB1 := "SB1"
	cAliasSC5 := "SC5"
EndIf

//-- Montagem do arquivo temporario de pedidos
cCliente := ""
cLoja    := ""
DbSelectArea(cAlias)
if ValType(oProcess) == 'O' .And. !IsBlind()
	oProcess:SetRegua1(LastRec())
Endif
dbgoTop() //IndRegua
While !Eof()
	if ValType(oProcess) == 'O' .And. !IsBlind()
		oProcess:IncRegua1(STR0041)
	Endif
	lContinua := .T.
	//-- Selecao dos registros
	//-- Verifica se o SC9 eh valido para este ponto de entrada
	If lOM200VLD
		If !ExecBlock("OM200VLD",.F.,.F.)
			lContinua := .F.
		EndIf
	EndIf

	//-- Posiciona Registros
	SB1->(MsGoto((cAlias)->RECSB1))
	SC5->(MsGoto((cAlias)->RECSC5))
	
	//-- Verifica os tipo de carga
	If	lContinua .And. !Empty((cAliasSB1)->B1_TIPCAR)
		nPosModelo := Ascan(aArrayMod,{|x| Trim(x[2]) == Trim((cAliasSB1)->B1_TIPCAR)})
		If	nPosModelo > 0
			If !aArrayMod[nPosModelo,1]
				lContinua := .F.
			EndIf
		EndIf
	Else
		nPosModelo := Ascan(aArrayMod,{|x| x[1] == .T.})
		If	nPosModelo > 0
			lContinua := .F.
		EndIf
	EndIf

	If lOM200TPC
		lRetPE    := ExecBlock("OM200TPC",.F.,.F.,{(cAlias)->C9_PRODUTO,(cAliasSB1)->B1_TIPCAR,lContinua,aArrayMod})
		lContinua := If(ValType(lRetPE)=="L", lRetPE, lContinua)
	EndIf

	If	lLockSC5 .And. lContinua
		If !SoftLock("SC5")
			Exit
		EndIf
	EndIf

	If	lContinua
		//-- Verifica os tipo de pedido e o codigo/loja do cliente/fornecedor
		cCliente   := Iif(lLocalEnt.And.!Empty((cAliasSC5)->C5_CLIENT), (cAliasSC5)->C5_CLIENT ,(cAlias)->C9_CLIENTE)
		cLoja      := Iif(lLocalEnt.And.!Empty((cAliasSC5)->C5_LOJAENT),(cAliasSC5)->C5_LOJAENT,(cAlias)->C9_LOJA)
		cAliasCli  := Iif( (cAliasSC5)->C5_TIPO $ "BD" ,"SA2"       ,"SA1"       )
		cCpoNomCli := Iif( (cAliasSC5)->C5_TIPO $ "BD" ,"A2_NOME"   ,"A1_NOME"   )
		cCpoEndCli := Iif( (cAliasSC5)->C5_TIPO $ "BD" ,"A2_END"    ,"A1_END"    ) 
		cCpoBaiCli := Iif( (cAliasSC5)->C5_TIPO $ "BD" ,"A2_BAIRRO" ,"A1_BAIRRO" )
		cCpoMunCli := Iif( (cAliasSC5)->C5_TIPO $ "BD" ,"A2_MUN"    ,"A1_MUN"    )
		cCpoEstCli := Iif( (cAliasSC5)->C5_TIPO $ "BD" ,"A2_EST"    ,"A1_EST"    )
		cCpoCepCli := Iif( (cAliasSC5)->C5_TIPO $ "BD" ,"A2_CEP"    ,"A1_CEP"    )
		cCpoCdrDes := Iif( (cAliasSC5)->C5_TIPO $ "BD" ,"A2_CDRDES" ,"A1_CDRDES" )
		//-- Ponto de entrada para alterar cliente/loja na montagem de carga usados na identificacao das rotas.
		If	lOM200CLI
			aRetPE := ExecBlock("OM200CLI",.F.,.F.,{(cAlias)->C9_FILIAL, (cAlias)->C9_PEDIDO,cCliente,cLoja})
			If	ValType(aRetPE)=="A"
				cCliente := aRetPE[1]
				cLoja    := aRetPE[2]
			EndIf
		EndIf
		//-- Verifica o codigo de referencia para o operador logistico - Amarracao Cod Cli X OL
		If	nTipoOper == 3
			DCK->(DbSetOrder(2)) //DCK_FILIAL+DCK_CODCLI+DCK_LOJCLI
			If	DCK->(MsSeek(xFilial("DCK")+(cAlias)->C9_CLIENTE+(cAlias)->C9_LOJA)) .And.;
				(cAlias)->C9_FILIAL != cFilAnt
				cCliente := DCK->DCK_CODOPL
				cLoja    := DCK->DCK_LOJOPL
			EndIf
		EndIf
		//-- Garanto a integridade do pedido no momento da montagem de carga com SoftLock
		DbSelectArea("SC9")
		DbGoTo((cAlias)->RECNO)

		//-- Inicializa as variaveis
		nPesoProd  := 0
		cCodRota   := Space(Len(DA8->DA8_COD))
		cDescRota  := OemToAnsi(STR0042) //"PEDIDOS SEM ROTA"
		cZona      := Space(Len(DA7->DA7_PERCUR))
		cSetor     := Space(Len(DA7->DA7_ROTA))
		cSeqRota   := Space(Len(DA9->DA9_SEQUEN))
		cSequencia := Space(Len(DA7->DA7_SEQUEN))
		lAchou     := .F.
		lValido    := .F.
		lTipCarga  := .T.
		If (nPosRota := aScan(aArrayCli, {|x|x[1]+x[2]=cCliente+cLoja}))>0 .AND. !lOM200PED
			cCodRota   := aArrayCli[nPosRota,3]
			cZona      := aArrayCli[nPosRota,4]
			cSetor     := aArrayCli[nPosRota,5]
			cSeqRota   := aArrayCli[nPosRota,6]
			cSequencia := aArrayCli[nPosRota,7]
			lValido    := .T.
		Else
			//-- Pesquisa o cliente/fornecedor em clientes por setor
			If !Empty(cRotaDe) .And. !Empty(cRotaAte)
				aRegDA7 := {}
				AAdd(aRegDA7,(cAlias)->RECDA7)
				If Empty((cAlias)->RECDA7)
					DbSelectArea("DA7")
					aRegDA7 := OmsHasDA7((cAlias)->C9_FILIAL,cCliente,cLoja,cAliasCli)
				EndIf
			Else
				DbSelectArea("DA7")
				aRegDA7 := OmsHasDA7((cAlias)->C9_FILIAL,cCliente,cLoja,cAliasCli)
			EndIf
			If	lOM200DA7
				aRetPE := ExecBlock("OM200DA7",.F.,.F.,{(cAlias)->C9_FILIAL,cCliente,cLoja,(cAlias)->C9_PEDIDO,aRegDA7})
				If	ValType(aRetPE)=="A"
					aRegDA7 := aRetPE
				EndIf
			EndIf

			If	Len(aRegDA7) > 0
				For nRegDA7 := 1 To Len(aRegDA7)
					DA7->(MsGoto(aRegDA7[nRegDA7]))
					cZona      := DA7->DA7_PERCUR
					cSetor     := DA7->DA7_ROTA
					cSequencia := DA7->DA7_SEQUEN
					//-- Pesquisa o cliente/fornecedor na zona/setor
					DA9->(DbSetOrder(2)) //DA9_FILIAL+DA9_ROTEIR+DA9_SEQUEN+DA9_PERCUR+DA9_ROTA
					If lParRota .And. !Empty(cRotaDe) .And. !Empty(cRotaAte) .And. !Empty((cAlias)->RECDA9)
						DA9->(MsGoto((cAlias)->RECDA9))
						lAchouDA9 := .T.
					Else
						lAchouDA9 := DA9->(MsSeek(xFilial("DA9")+cZona+cSetor))
					EndIf
					If lAchouDA9
						//-- Verifica se busca a primeira rota ativa
						While DA9->(!Eof()) .And. DA9->DA9_FILIAL == xFilial("DA9") .And.;
							DA9->DA9_PERCUR == cZona .And.;
							DA9->DA9_ROTA   == cSetor
							//-- Pesquisa a Rota
							DA8->(DbSetOrder(1)) //DA8_FILIAL+DA8_COD
							If	DA8->(MsSeek(xFilial("DA8")+DA9->DA9_ROTEIR))
								If	DA8->DA8_ATIVO == "1" .And. If(lRotAtv,.T.,IIf(!Empty(DA8->DA8_CODCAL),OmsDtEntr(DA8->DA8_CODCAL,dDataBase)==dDataBase,.T.))
									//-- Verifica os tipo de carga da rota se esta incluido
									lValido   := .T.
									lTipCarga := .T.
									If	DA8->(FieldPos("DA8_TIPCAR")) > 0 .And. !Empty(DA8->DA8_TIPCAR)
										nPosModelo := Ascan(aArrayTipo,{|x| Trim(x[2]) == Trim(DA8->DA8_TIPCAR)})
										If	nPosModelo > 0
											If !aArrayTipo[nPosModelo,1]
												lValido := .F.
											Else
												DB0->(DbSetOrder(1)) //DB0_FILIAL+DB0_CODMOD
												If	DB0->(MsSeek(xFilial("DB0")+(cAliasSB1)->B1_TIPCAR)) .And.;
													AllTrim(aArrayTipo[nPosModelo,2]) <> DB0->DB0_TIPCAR
													lTipCarga := .F.
												EndIf
											EndIf
										EndIf
									EndIf
								EndIf
							Else
								Exit //-- Nao localizou Rota
							EndIf
							//--
							If	lValido .And. lTipCarga
								lAchou   := .T.
								cCodRota := DA8->DA8_COD
								cDescRota:= DA8->DA8_DESC
								cSeqRota := DA9->DA9_SEQUEN
								//-- Pesquisa os Setores por Zona
								DbSelectArea("DA6")
								DA6->(DbSetOrder(1)) //DA6_FILIAL+DA6_PERCUR+DA6_ROTA
								If	MsSeek(xFilial("DA6")+cZona+cSetor)
									cPtoRefDA6 := DA6->DA6_REF
									//-- Pesquisa as Zonas
									DbSelectArea("DA5")
									DA5->(DbSetOrder(1))
									If	MsSeek(xFilial("DA5")+DA6->DA6_PERCUR)
										cPtoRefDA5 := DA5->DA5_DESC
									Else
										cPtoRefDA5 := ""
									EndIf
									If Ascan(aArrayRota, {|x| x[3] == cCodRota}) == 0 .And. lValido
										AAdd(aArrayRota, { .T.,.F.,cCodRota,cDescRota,Space(6)} )
									EndIf
									//-- Verifico se existe setor para pegar descricao e acrescento no array
									If Ascan(aArraySetor, {|x| x[3]+x[4]+x[5] == cCodRota+cZona+cSetor}) == 0 .And. lValido
										AAdd(aArraySetor, { .T.,.F.,cCodRota,cZona,cSetor,cPtoRefDA6,"      ",cSeqRota} )
										//-- Busco se ja existe a zona no array , caso nao exista,a mesma e incluida
										If Ascan(aArrayZona, {|x| x[3]+x[4] == cCodRota+cZona}) == 0
											AAdd(aArrayZona, { .T.,.F.,cCodRota,cZona,cPtoRefDA5,"      ",cSeqRota} )
										EndIf
									EndIf
								EndIf
								If aScan(aArrayCli, {|x|x[1]+x[2]+x[3]+x[4]+x[5]=cCliente+cLoja+cCodRota+cZona+cSetor}) = 0
									AAdd(aArrayCli, { cCliente, cLoja, cCodRota, cZona, cSetor, cSeqRota, cSequencia })
								EndIf
								//-- Se localizou uma Rota para este Cliente
								If	cAlocPer <> "S"
									Exit
								EndIf
							EndIf
							DA9->(DbSkip())
						EndDo						
					EndIf
					//-- Se localizou uma Rota para este Cliente / Produto / Tipo Carga
					If	lAchou .And. cAlocPer <> "S"
						Exit
					EndIf
				Next nRegDa7
			EndIf
			If !lAchou
				cCodRota   := Repl("9",Len(DA8->DA8_COD))
				cDescRota  := OemToAnsi(STR0043) //"PEDIDOS SEM ROTEIRIZACAO"
				cZona      := Repl("9",Len(DA7->DA7_PERCUR))
				cSetor     := Repl("9",Len(DA7->DA7_ROTA))
				cSeqRota   := Repl("9",Len(DA9->DA9_SEQUEN))
				cSequencia := Repl("9",Len(DA7->DA7_SEQUEN))
				lValido    := .T.
				If Ascan(aArrayRota, {|x| x[3] == cCodRota}) == 0
					AAdd(aArrayRota, {.T.,.F.,cCodRota,cDescRota,Space(6)} )
				EndIf
				If Ascan(aArrayZona, {|x| x[3]+x[4] == cCodRota+cZona}) == 0
					AAdd(aArrayZona, {.T.,.F.,cCodRota,cSetor,cDescRota,"      ",cSeqRota} )
				EndIf
				If Ascan(aArraySetor, {|x| x[3]+x[4]+x[5] == cCodRota+cZona+cSetor}) == 0
					AAdd(aArraySetor, {.T.,.F.,cCodRota,cZona,cSetor,cDescRota,"      ",cSeqRota} )
				EndIf
			EndIf
		EndIf
		//-- Verifico se consiste os dados do pedido e se a rota foi valida
		(cAliasCli)->(DbSetOrder(1))
		If	(cAliasCli)->(MsSeek(OsFilial(cAliasCli,(cAlias)->C9_FILIAL)+cCliente+cLoja)) .And. lValido
			Do Case
				Case cRotCep == "1"
					cCpoCepCli := Iif((cAliasSC5)->C5_TIPO $ "BD", "A2_CEP","A1_CEP")
				Case cRotCep == "2"
					cCpoCepCli := Iif((cAliasSC5)->C5_TIPO $ "BD", "A2_CEP",IIf(!Empty((cAliasCli)->(FieldGet(FieldPos("A1_CEPE")))),"A1_CEPE","A1_CEP"))
				Case cRotCep == "3"
					cCpoCepCli := Iif((cAliasSC5)->C5_TIPO $ "BD", "A2_CEP","A1_CEPE")
			EndCase
			//-- Calculo peso do item do pedido
			If FindFunction("OsPesoProd")
				nPesoProd := OsPesoProd((cAlias)->C9_PRODUTO)
			Else
				nPesoProd := SB1->(FieldGet(FieldPos(cCpoPeso)))
			EndIf
			nPesoProd := (nPesoProd*(cAlias)->C9_QTDLIB)
			nValor    := A410Arred(((cAlias)->C9_QTDLIB *(cAlias)->C9_PRCVEN),"DAK_VALOR")
			nCapArm   := OsPrCapArm((cAlias)->C9_PRODUTO,(cAlias)->C9_FILIAL)
			nCapVol   := (nCapArm  *(cAlias)->C9_QTDLIB)
			nQtdLib   := (cAlias)->C9_QTDLIB
			If	lFreteEmb
				cTpFrete:= If((cAliasSC5)->C5_TPFRETE=="C","CIF",If((cAliasSC5)->C5_TPFRETE=="F","FOB",""))
			EndIf
			//-- Se ja existe no array de pedido apenas incremento o peso
			If	mv_par06 == 1
				TRBPED->(DbSetOrder(1))
				If	TRBPED->(!MsSeek((cAlias)->C9_FILIAL+(cAlias)->C9_PEDIDO))
					RecLock("TRBPED",.T.)
					TRBPED->PED_GERA   := "N"
					TRBPED->PED_MARCA  := "  "
					TRBPED->PED_ROTA   := If(cAlocPer=="S",Space(Len(DA8->DA8_COD)),cCodRota)
					TRBPED->PED_ZONA   := cZona
					TRBPED->PED_SETOR  := cSetor
					TRBPED->PED_SEQROT := cSeqRota
					TRBPED->PED_PEDIDO := (cAlias)->C9_PEDIDO
					TRBPED->PED_ITEM   := (cAlias)->C9_ITEM
					TRBPED->PED_SEQLIB := (cAlias)->C9_SEQUEN
					If	mv_par06 == 2
						TRBPED->PED_CODPRO := SB1->B1_COD
						TRBPED->PED_DESPRO := SB1->B1_DESC
					EndIf
					//-- Verifca se trabalha com filiais sendo tipo 2 ou 3
					TRBPED->PED_FILORI := (cAlias)->C9_FILIAL
					TRBPED->PED_FILCLI := OsFilial("SA1",(cAlias)->C9_FILIAL)
					TRBPED->PED_CODCLI := cCliente
					TRBPED->PED_LOJA   := cLoja
					TRBPED->PED_NOME   := (cAliasCli)->(FieldGet(FieldPos(cCpoNomCli)))
					TRBPED->PED_PESO   := nPesoProd
					TRBPED->PED_CARGA  := "ZZZZZZ"
					TRBPED->PED_SEQSET := cSequencia
					TRBPED->PED_SEQORI := cSeqRota
					TRBPED->PED_VALOR  := nValor
					TRBPED->PED_VOLUM  := nCapVol
					TRBPED->PED_QTDLIB := nQtdLib
					TRBPED->PED_ENDPAD := Space(Len((cAlias)->C9_ENDPAD))
					TRBPED->PED_ENDCLI := (cAliasCli)->(FieldGet(FieldPos(cCpoEndCli)))
					TRBPED->PED_BAIRRO := (cAliasCli)->(FieldGet(FieldPos(cCpoBaiCli)))
					TRBPED->PED_MUN    := (cAliasCli)->(FieldGet(FieldPos(cCpoMunCli)))
					TRBPED->PED_EST    := (cAliasCli)->(FieldGet(FieldPos(cCpoEstCli)))
					TRBPED->PED_CEP    := (cAliasCli)->(FieldGet(FieldPos(cCpoCepCli)))
					If	lFreteEmb
						TRBPED->PED_CDRDES := (cAliasCli)->(FieldGet(FieldPos(cCpoCdrDes)))
						TRBPED->PED_TPFRET := cTpFrete
					EndIf
					MsUnlock()
				Else
					TRBPED->PED_PESO  += nPesoProd
					TRBPED->PED_VALOR += nValor
					TRBPED->PED_VOLUM += nCapVol
					TRBPED->PED_QTDLIB+= nQtdLib
				EndIf
			Else			
				TRBPED->(DbSetOrder(1))
					If	TRBPED->(!MsSeek((cAlias)->C9_FILIAL+(cAlias)->C9_PEDIDO+(cAlias)->C9_ITEM+(cAlias)->C9_SEQUEN))
					RecLock("TRBPED",.T.)
					TRBPED->PED_GERA   := "N"
					TRBPED->PED_MARCA  := "  "
					TRBPED->PED_ROTA   := If(cAlocPer=="S",Space(Len(DA8->DA8_COD)),cCodRota)
					TRBPED->PED_ZONA   := cZona
					TRBPED->PED_SETOR  := cSetor
					TRBPED->PED_SEQROT := cSeqRota
					TRBPED->PED_PEDIDO := (cAlias)->C9_PEDIDO
					TRBPED->PED_ITEM   := (cAlias)->C9_ITEM
					TRBPED->PED_SEQLIB := (cAlias)->C9_SEQUEN
					If	mv_par06 == 2
						TRBPED->PED_CODPRO := SB1->B1_COD
						TRBPED->PED_DESPRO := SB1->B1_DESC
					EndIf
					//-- Verifca se eh operador logistico e grava a filial solicitante
					TRBPED->PED_FILORI := (cAlias)->C9_FILIAL
					TRBPED->PED_FILCLI := OsFilial("SA1",(cAlias)->C9_FILIAL)
					TRBPED->PED_CODCLI := cCliente
					TRBPED->PED_LOJA   := cLoja
					TRBPED->PED_NOME   := (cAliasCli)->(FieldGet(FieldPos(cCpoNomCli)))
					TRBPED->PED_PESO   := nPesoProd
					TRBPED->PED_CARGA  := "ZZZZZZ"
					TRBPED->PED_SEQSET := cSequencia
					TRBPED->PED_SEQORI := cSeqRota
					TRBPED->PED_VALOR  := nValor
					TRBPED->PED_VOLUM  := nCapVol
					TRBPED->PED_QTDLIB := nQtdLib
					TRBPED->PED_ENDPAD := (cAlias)->C9_ENDPAD
					TRBPED->PED_ENDCLI := (cAliasCli)->(FieldGet(FieldPos(cCpoEndCli)))
					TRBPED->PED_BAIRRO := (cAliasCli)->(FieldGet(FieldPos(cCpoBaiCli)))
					TRBPED->PED_MUN    := (cAliasCli)->(FieldGet(FieldPos(cCpoMunCli)))
					TRBPED->PED_EST    := (cAliasCli)->(FieldGet(FieldPos(cCpoEstCli)))
					TRBPED->PED_CEP    := (cAliasCli)->(FieldGet(FieldPos(cCpoCepCli)))
					If	lFreteEmb
						TRBPED->PED_CDRDES := (cAliasCli)->(FieldGet(FieldPos(cCpoCdrDes)))
						TRBPED->PED_TPFRET := cTpFrete
					EndIf
					MsUnlock()
				EndIf
			EndIf
		EndIf
		If lOM200GRV
			ExecBlock("OM200GRV",.F.,.F.)
		EndIf
	EndIf
	DbSelectArea(cAlias)
	DbSkip()
EndDo
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Ordena por: Rota                              ³
//³            SeqRota                           ³
//³            Sequencia de clientes             ³
//³            Zona                              ³
//³            Setor                             ³
//³            Pedido                            ³
//³            Item                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DbSelectArea("TRBPED")
TRBPED->(DbSetOrder(2))

if ValType(oProcess) == 'O' .And. !IsBlind()
	oProcess:SetRegua2(TRBPED->(LastRec()))
Endif

DbGoTop()

//-- Renumera a sequencia de entrega considerando intervalo conforme parametro: MV_OMSENTR
nSeqInc    := IIF(nSeqInc > 0,nSeqInc,5)
nSequencia := nSeqInc
cRota      := TRBPED->PED_ROTA
cCliente   := TRBPED->PED_CODCLI
cLoja      := TRBPED->PED_LOJA
While !Eof()
	if ValType(oProcess) == 'O' .And. !IsBlind()
		oProcess:IncRegua2(OemtoAnsi(STR0111)) //"Roteirizando pedidos..."
	Endif
	If	TRBPED->PED_ROTA != cRota
		cRota      := TRBPED->PED_ROTA
		cCliente   := TRBPED->PED_CODCLI
		cLoja      := TRBPED->PED_LOJA
		nSequencia := nSeqInc
	EndIf
	If	TRBPED->PED_CODCLI != cCliente .Or. TRBPED->PED_LOJA != cLoja
		cCliente   := TRBPED->PED_CODCLI
		cLoja      := TRBPED->PED_LOJA
		nSequencia += nSeqInc
	EndIf
	RecLock("TRBPED",.F.)
	TRBPED->PED_SEQROT := StrZero(nSequencia,6)
	MsUnlock()
	DbSkip()
EndDo
If ExistBlock("OM200GR2")
	ExecBlock("OM200GR2",.F.,.F.,{"TRBPED"})
EndIf
//-- Ordeno o array de pedidos de acordo com a sequencia de geracao
TRBPED->(DbSetOrder(3))
//-- Adiciono no array de carga a inicial
		AAdd(aArrayCarga,{.T.,;
		cCarga,;
		OemtoAnsi(STR0040)+cCarga,; //"CARGA"
		TransForm(0,cPictPeso),;
		TransForm(0,cPictVal),;
		TransForm(0,cPictVol),;
		TransForm(0,cPictQtde),;
		StrZero(0,6),;
		Space(7),;
		Space(Len(DA3->DA3_COD)),;
		Space(Len(DA4->DA4_COD)),;
		Space(Len(DAU->DAU_COD)),;
		Space(Len(DAU->DAU_COD)),;
		Space(Len(DAU->DAU_COD)),;
		TransForm(0,cPictPeso),;
		TransForm(0,cPictQtde),;
		TransForm(0,cPictVol),;
		TransForm(0,cPictVal),;
		TransForm(0,cPictPeso),;
		TransForm(0,cPictQtde),;
		TransForm(0,cPictVol),;
		TransForm(0,cPictVal),;
		cDakTrp,;
		cDAKTpOp,;
		cDAKClFr})

//-- Verifico se existe algum em branco pois  nao e possivel criar uma dialog com array vazio
If	Len(aArrayRota) == 0
	AAdd(aArrayRota, {.T.,.F.,Space(6),Space(20),Space(6)})
EndIf
If	Len(aArrayZona) == 0
	AAdd(aArrayZona, {.T.,.F.,Space(6),Space(6),Space(20),Space(6)})
EndIf
If	Len(aArraySetor) == 0
	AAdd(aArraySetor, {.T.,.F.,Space(6),Space(6),Space(6),Space(20),Space(6)})
EndIf

//-- Ordena os browses de rota, zona e setor de acordo com a sequencia
aArrayRota  := aSort(aArrayRota,,,{|x,y| x[3] < y[3] })
aArrayZona  := aSort(aArrayZona,,,{|x,y| x[3]+x[7]+x[4] < y[3]+y[7]+y[4] })
aArraySetor := aSort(aArraySetor,,,{|x,y| x[3]+x[8]+x[4]+x[5] < y[3]+y[8]+y[4]+x[5] })

DbSelectArea("TRBSC9")
DbCloseArea()
DbSelectArea("SC9")

Return( .T. )

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³OmsTrocaSeq ºAutor  ³DL                  º Data ³  01/02/01 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Monta Pedidos nos arrays para marcacao                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³ ExpC1 - Horario inicial da carga                           º±±
±±º          ³ ExpA2 - Array da carga                                     º±±
±±º          ³ ExpA3 - Array da carga anterior para alteracao             º±±
±±º          ³ ExpO4 - Array com os objetos a dar refresh                 º±±
±±º          ³ ExpL5 - Se ira trocar a sequencia de entrega               º±±
±±º          ³ ExpC6 - Sequencia atual                                    º±±
±±º          ³ ExpC7 - Nova sequencia                                     º±±
±±º          ³ ExpN8 - Tipo de aplicacao ao registro                      º±±
±±º          ³         [1]-Move para baixo pela toolbar                   º±±
±±º          ³         [2]-Move para cima pela toolbar                    º±±
±±º          ³         [3]-Habilita a janela de mover para                º±±
±±º          ³         [4]-Cancela  a janela de mover para                º±±
±±º          ³         [6]-Confirma a janela de mover para                º±±
±±º          ³         [7]-Apenas troca o horario                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP5                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function OmsTrocaSeq(cHrStart,dDtStart,cVeiculo,aArrayAnt,oPedMan,aObj,lSeq,cSeqAtual,cSeqNova,nUpDown)
Local nSeqInc     := SuperGetMV("MV_OMSENTR",.F.,5)
Local nSequencia  := 0
Local nOpca       := 0
Local nPos        := oPedMan:nAt
Local nPosAnt     := 0
Local nC          := 0
Local oDown       := LoadBitmap( GetResources(), "TRIDOWN"  )
Local oUp         := LoadBitmap( GetResources(), "TRIUP"    )
Local oLiberado   := LoadBitmap( GetResources(), "PMSTASK4" )
Local oCalend     := LoadBitmap( GetResources(), "PMSTASK1" )
Local oHorario    := LoadBitmap( GetResources(), "PMSTASK2" )
Local oVeiculo    := LoadBitmap( GetResources(), "PMSTASK3" )
Local oDlgCarga

cSeqAtual   := aArrayAnt[oPedMan:nAt,1]

//-- Verifico se o pedido esta marcado para a geracao da carga disponivel

nPosAnt := nPos

Do Case

	//-- Move registro para baixo pelas setas da toolbar
	Case nUpDown == 1

		OmsTrocaSeq(cHrStart,dDtStart,cVeiculo,aArrayAnt,oPedMan,aObj,lSeq,cSeqAtual,cSeqNova,4)
		If	nPos <> Len(aArrayAnt)
			nPos++
		EndIf
		cSeqNova := StrZero(Val(aArrayAnt[nPos,1]),6)
		lSeq     := .T.

	//-- Move registro para cima pelas setas da toolbar
	Case nUpDown == 2

		OmsTrocaSeq(cHrStart,dDtStart,cVeiculo,aArrayAnt,oPedMan,aObj,lSeq,cSeqAtual,cSeqNova,4)
		If	nPos <> 1
			nPos--
		EndIf
		cSeqNova := StrZero(Val(aArrayAnt[nPos,1]),6)
		lSeq     := .T.

	//-- Habilita janela para digitacao de Mover para....
	Case nUpDown == 3

		If !lSeq
			cSeqNova    := Space(6)
			oPedMan:nRight -= 160
			aEval(aObj,{|x| x:show()})
			lSeq := .T.
		EndIf

	//-- Cancela janela de Mover para...
	Case nUpDown == 4

		If lSeq
			aEval(aObj,{|x| x:hide()})
			oPedMan:nRight += 160
			lSeq := .F.
		EndIf

	//-- Confirmacao da janela mover para...
	Case nUpDown == 5

		If lSeq
			aEval(aObj,{|x| x:hide()})
			oPedMan:nRight += 160
			lSeq := .T.
		EndIf

	Case nUpDown == 6
		lSeq := .F.

EndCase

If lSeq

	If !Empty(cSeqNova)
		aArrayAnt[oPedMan:nAt,1] := cSeqNova
		//--Ordena a Sequencia de entrega 
		aArrayAnt := aSort(aArrayAnt,,,{|x,y| x[1] < y[1]})		
		nSeqInc   := IIF(nSeqInc > 0,nSeqInc,5)
		For nC := 1 to Len(aArrayAnt)
			nSequencia += nSeqInc
			aArrayAnt[nC,1] := StrZero(nSequencia,6)
		Next nC
	EndIf

	If nUpDown == 1 .Or. nUpDown == 2 .Or. nUpDown == 5
		lSeq := .F.
	EndIf

EndIf

//-- Verifica se a opcao e de alguma alteracao
If nUpDown == 1 .Or. nUpDown == 2 .Or. nUpDown == 5 .Or. nUpDown == 6
	//-- Atualiza as horas de entrega
	FBs200Time(cHrStart,dDtStart,aArrayAnt,cVeiculo,12,6,7,2,3,4,14,15,16,17,18,19,20)
EndIf

//-- Da refresh no objeto da listbox
oPedMan:bLine:={||{	Iif(aArrayAnt[oPedMan:nAT,18]==1,oLiberado,;
					Iif(aArrayAnt[oPedMan:nAT,18]==2,oVeiculo,;
					Iif(aArrayAnt[oPedMan:nAT,18]==3,oHorario,;
					Iif(aArrayAnt[oPedMan:nAT,18]==4,oCalend,oLiberado)))),;
					oDown, oUp,;
					aArrayAnt[oPedMan:nAT,1],;
					aArrayAnt[oPedMan:nAT,2],;
					aArrayAnt[oPedMan:nAT,5],;
					aArrayAnt[oPedMan:nAT,19],;
					aArrayAnt[oPedMan:nAT,16],;
					aArrayAnt[oPedMan:nAT,17],;
					aArrayAnt[oPedMan:nAT,20],;
					aArrayAnt[oPedMan:nAT,6],;
					aArrayAnt[oPedMan:nAT,7],;
					aArrayAnt[oPedMan:nAT,8],;
					aArrayAnt[oPedMan:nAT,9],;
					aArrayAnt[oPedMan:nAT,10],;
					aArrayAnt[oPedMan:nAT,11],;
					aArrayAnt[oPedMan:nAT,21],;
					aArrayAnt[oPedMan:nAT,22],;
					aArrayAnt[oPedMan:nAT,23],;
					aArrayAnt[oPedMan:nAT,24]}}
oPedMan:nAt := nPos
oPedMan:Refresh()

Return( .T. )


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³OmsVldTranspºAutor  ³DL                 º Data ³  01/22/01  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Valida caminhao na associacao da carga                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP5Dl                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function FBsVldTransp(cVeiculo,cVeiAnt, cNomeCam, cPlaca,nCapacMax ,nLimMax ,nPeso,nVolume,nPtoEntr,cMotorista,cNomeMot,cAjuda1,cNomeAju1,cAjuda2,cNomeAju2,cAjuda3,cNomeAju3,aHoras,lContVei)
Local lRet      := .T.
Local lFreteEmb := .F.
Local aAreaDTU  := {}
Local aAreaDTO  := {}
Local nRatFre   := 1
Local cCpoCapac := IIf(SuperGetmv("MV_OMSCAPA",.F.,"1")=="1","DA3_CAPACN","DA3_CAPACM")
Local nCapac    := 0
Local cCplInt	  := SuperGetMv("MV_CPLINT",.F.,"2") 
Local lAssociaV := SuperGetmv("MV_CPLTVO",.F.,"1")
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifico se o parametro de considerar restricoes esta³
//³ativo  e consisto a capacidade do caminhao           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Default  cMotorista := ""
Default  cNomeMot   := ""
Default  cAjuda1    := ""
Default  cNomeAju1  := ""
Default  cAjuda2    := ""
Default  cNomeAju2  := ""
Default  cAjuda3    := ""
Default  cNomeAju3  := ""
Default  lContVei   := GetMV('MV_CONTVEI',,.F.) // Parametro para verificar se o sistema devera' controlar veiculo/motorista

If	!Empty(cVeiAnt) .And. cVeiAnt <> cVeiculo
	DbSelectArea("DA3")
	DA3->(DbSetOrder(1))
	If	MsSeek(xFilial("DA3")+cVeiAnt)
		MsUnlock()
	EndIf
EndIf
DbSelectArea("DA3")
DA3->(DbSetOrder(1))
If	MsSeek(xFilial("DA3")+cVeiculo)

     //Integração OMSxCPL
    If DAK->(ColumnPos("DAK_VIAROT")) > 0 .And. cCplInt == '1' .And. !l200Auto
	 	DbSelectArea("DK0")
		DK0->(DbSetOrder(2))
		If MsSeek(xFilial("DK0")+DAK->DAK_COD) 
			If DK0->DK0_TIPVEI <> DA3->DA3_TIPVEI 
				If lAssociaV == "1" //Impedir
					Help(" ",1,"OMS200ASSVEI")// O veículo deve ser do mesmo tipo informado pelo Cockpit Logístico. 
					lRet := .F.
				ElseIf lAssociaV == "2"
					If !(MsgYesNo("Confirma"," ")) 
						lRet := .F.
					EndIf 
				EndIf
		   	EndIf
	   	EndIf
     	MsUnlock("DK0")
    EndIf
     
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Verifica se o peso, o volume e os pontos de entrega ultrapassan os limites³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Pergunte("OMS200",.F.) //Parametro da Montagem de Cargas
	If	mv_par05 == 1 .And. lRet
		nCapac := DA3->(FieldGet(FieldPos(cCpoCapac)))
		If ((nPeso    > nCapac)           .Or. ;
			(nVolume  > DA3->DA3_VOLMAX)  .Or. ;
			(nPtoEntr > DA3->DA3_LIMMAX)) .And.;
			DA3->DA3_ATIVO == "1"
			Help(" ",1,"OMSULTCARG") //Caminhao nao suporta carga montada
			lRet := .F.
		ElseIf	DA3->DA3_ATIVO == "2"
			Help(" ",1,"OMSCAMINDS")  //Caminhao indisponivel
			lRet := .F.
		EndIf
	EndIf
	Pergunte("OMS20A",.F.) //Restaura Parametros da tela de Cargas
	
	If	lRet .And. (!Empty(cVeiAnt) .Or. IsIncallstack("Os200Assoc")) .And. cVeiAnt <> cVeiculo
		If !OmsVeiDisp(cVeiculo,aHoras[1],aHoras[2],aHoras[3],aHoras[4])
			Help(" ",1,"OMSVEIEMP") //Veículo já empenhado em outra carga ou viagem.
			lRet := .F.
		EndIf		
	EndIf
	If	lRet
		If !RecLock("DA3")
			lRet := .F.
		EndIf
	EndIf
	If	lRet
		If	lFreteEmb
			If	!Empty(cVeiAnt) .And. cVeiAnt <> cVeiculo .And. lContVei
				aAreaDTU := DTU->(GetArea())
				aAreaDTO := DTO->(GetArea())
				DTU->(DbSetOrder(2))
				DTO->(DbSetOrder(4))
				If	DTU->(DbSeek(xFilial('DTU')+cVeiculo+'2'))
					If	DTO->(DbSeek(xFilial('DTO')+DTU->DTU_NUMLIB))
						If	Empty(cMotorista) .Or. (cMotorista <> DA3->DA3_MOTORI)
							cMotorista := DTO->DTO_CODMOT
						EndIf
					EndIf
				ElseIf	DTU->(!EOF() .And. DTU_CODVEI==cVeiculo .And. DTU_STATUS $ '13')
					MsgAlert(STR0258) //'Veículo informado não está liberado!'
					lRet := .F.
				EndIf
				RestArea( aAreaDTU )
				RestArea( aAreaDTO )
			EndIf
			SA2->(DbSetOrder(1))
			If	SA2->(MsSeek(xFilial("SA2")+DA3->DA3_CODFOR+DA3->DA3_LOJFOR))
				SA4->(DbSetOrder(1))
				If	SA4->(MsSeek(xFilial("SA4")+SA2->A2_TRANSP))
					nRatFre := Val(SA4->A4_RATFRE)
				EndIf
			EndIf
			If	Empty(cMotorista) .Or. (cMotorista <> DA3->DA3_MOTORI)
				cMotorista := DA3->DA3_MOTORI
			EndIf
		Else
			If	Empty(cMotorista)
				cMotorista := DA3->DA3_MOTORI
			EndIf
		EndIf
		If	lRet
			cNomeCam   := DA3->DA3_DESC
			cPlaca     := DA3->DA3_PLACA
			nCapacMax  := DA3->DA3_CAPACM
			nLimMax    := DA3->DA3_LIMMAX
			If !Empty(cMotorista) 
				DA4->(DbSetOrder(1))
				If	DA4->(MsSeek(xFilial("DA4")+DA3->DA3_MOTORI)) 
					cMotorista	:= DA3->DA3_MOTORI
					cNomeMot 	:= DA4->DA4_NOME
					//-- 1o. Ajudante
					DAU->(DbSetOrder(1))
					If	DAU->(MsSeek(xFilial("DAU")+DA4->DA4_AJUDA1)) .AND. Empty(cAjuda1) 
						cAjuda1   := DAU->DAU_COD
						cNomeAju1 := DAU->DAU_NOME
					EndIf
					//-- 2o. Ajudante
					DAU->(DbSetOrder(1))
					If	DAU->(MsSeek(xFilial("DAU")+DA4->DA4_AJUDA2)) .AND. Empty(cAjuda2) 
						cAjuda2   := DAU->DAU_COD
						cNomeAju2 := DAU->DAU_NOME
					EndIf
					//-- 3o. Ajudante
					DAU->(DbSetOrder(1))
					If	DAU->(MsSeek(xFilial("DAU")+DA4->DA4_AJUDA3)) .AND. Empty(cAjuda3) 
						cAjuda3   := DAU->DAU_COD
						cNomeAju3 := DAU->DAU_NOME
					EndIf
				EndIf
			Else
			cAjuda1   := Criavar("DAU_COD",.F.)
			cAjuda2   := Criavar("DAU_COD",.F.)
			cAjuda3   := Criavar("DAU_COD",.F.)
			cNomeMot  := ""
			cNomeAju1 := ""
			cNomeAju2 := ""
			cNomeAju3 := "" 	
			EndIf
		EndIf
		oNomeCam:Refresh()
		oPlaca:Refresh()
		oCapacMax:Refresh()
		oLimMax:Refresh()
		oNomeMot:Refresh()
		If	lFreteEmb
			oRatFre:nAt := nRatFre
			oRatFre:Refresh()
		EndIf
	EndIf
	//-- Ponto de Entrada para validar o veiculo
	If lRet
		If ExistBlock("OM200VEI")
			lRetPE := ExecBlock("OM200VEI",.F.,.F.,{cVeiculo})
			lRet   := If(ValType(lRetPE)=="L", lRetPE, lRet)
		EndIf
	EndIf
ElseIf !Empty(cVeiculo)
	Help(" ",1,"REGNOIS")//Mensagem de registro nao relacionado
	lRet := .F.
ElseIf Empty(cVeiculo)	
	cNomeCam   := ""
	cPlaca     := ""
	nCapacMax  := ""
	nLimMax    := ""
	cMotorista := ""
	cNomeMot   := ""
	cAjuda1    := Criavar("DAU_COD",.F.)
	cAjuda2    := Criavar("DAU_COD",.F.)
	cAjuda3    := Criavar("DAU_COD",.F.)
	cNomeAju1  := ""
	cNomeAju2  := ""
	cNomeAju3  := "" 	
	oNomeCam:Refresh()
	oPlaca:Refresh()
	oCapacMax:Refresh()
	oLimMax:Refresh()
	oNomeMot:Refresh()
EndIf

Return( lRet )

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³OmsVldSeq ºAutor  ³DL                  º Data ³  01/05/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao Validacao da sequencia na carga se ja existe        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³ cSequencia := Sequencia digitada                           º±±
±±º          ³ cCarga     := Carga Disponivel para verificacao            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP5                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function OmsVldSeq(cSequencia,cRota,aArrayMan)
Local lRet := .T.
If	Ascan(aArrayMan,{|x| x[1]+x[2] == cSequencia+cRota}) > 0
	lRet := .F.
	Help(" ",1,"OMSSEQEXIS") //Sequencia ja existe na carga disponivel
EndIf

Return( lRet )


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Funcao   ³Os200ProcEst³ Autor ³ DL                  ³ Data ³ 19/01/2001 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descricao³ Efetivamente estorna as cargas indicadas                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Ap5Dl                                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function FB200ProcEst(cCarga,cDakTransp)
Local aArea     := GetArea()
Local aAreaSC9  := SC9->(GetArea())
Local nTpVlEnt  := OsVlEntCom()
Local nRegSC9   := 0
Local cFilPV    := ""
Local lOS200Est := ExistBlock("OS200EST")
Local lFreteEmb := .F.
Local lContinua := .T.
Local lDclNew 	:= SuperGetMv("MV_DCLNEW",.F.,.F.)
Local oMdl

Default cDakTransp := Criavar("A4_COD",.F.)

If FindFunction("MaEnvEAI")
	oMdl := MaEnvEAI(/*cEmpX*/, /*cFilX*/, /*nOpcx*/5, /*cMainModel*/"OMSA200", /*aStruModel*/, /*lHelp*/, /*lEnvia*/.F., /*lLoadModel*/, /*oMdl*/, /*cXml*/, /*cFunName*/)
EndIf

Begin Transaction

	If lOS200Est
		ExecBlock("OS200EST",.F.,.F.,{DAK->DAK_COD,DAK->DAK_SEQCAR})
	EndIf

	DbSelectArea("DAI")
	DAI->(DbSetOrder(1)) //--DAI_FILIAL+DAI_COD+DAI_SEQCAR+DAI_SEQUEN+DAI_PEDIDO
	DAI->(MsSeek(xFilial("DAI")+DAK->DAK_COD+DAK->DAK_SEQCAR))
	While DAI->(!Eof()) .And. xFilial("DAI") == DAI->DAI_FILIAL .And.;
		DAK->DAK_COD    == DAI->DAI_COD .And.;
		DAK->DAK_SEQCAR == DAI->DAI_SEQCAR

		cFilPv := IIf(nTpVlEnt<>1,DAI->DAI_FILPV,xFilial("SC9"))
		DbSelectArea("SC9")
		SC9->(DbSetOrder(5)) //-- C9_FILIAL+C9_CARGA+C9_SEQCAR+C9_SEQENT
		SC9->(MsSeek(OsFilial("SC9",cFilPv)+DAK->DAK_COD+DAK->DAK_SEQCAR))
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Limpa a carga do SC9                                          ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		While SC9->(!Eof()) .And. SC9->C9_FILIAL == cFilPv .And.;
				SC9->C9_CARGA  == DAK->DAK_COD .And.;
				SC9->C9_SEQCAR == DAK->DAK_SEQCAR

			//-- Guarda RecNo
			SC9->(DbSkip())
			nRegSC9 := SC9->(Recno())
			SC9->(DbSkip(-1))

			SC5->(dbSetOrder(1)) //C5_FILIAL+C5_NUM
			If SC5->(MsSeek(OsFilial("SC5",cFilPv)+SC9->C9_PEDIDO))
				// Exclui a Transportadora do pedido de venda
				If DAK->(FieldPos('DAK_TRANSP')) > 0
					If !Empty( DAK->DAK_TRANSP )
						RecLock('SC5',.F.)
						SC5->C5_TRANSP := ""
						MsUnlock()
					EndIf
				EndIf
			EndIf
			//Exclui a integração com o módulo WMS
			//-- 1=no Pedido;2=na Montagem da Carga;3=na Unitizacao da Carga
			If SC5->C5_GERAWMS <> "1" .And. IntWms(SC9->C9_PRODUTO) .And. !Empty(SC9->C9_SERVIC)
				WmsUndoPed(SC9->(Recno()))
			EndIf
			//-- 8.Estorno Mont.Carga
			MaAvalSC9("SC9",8)
			//-- Restaura RecNo
			SC9->(MsGoTo(nRegSC9))
		EndDo

		//--Exclui os Relacionamentos do Frete Embarcador
		If lFreteEmb
			OMDelFrt(DAK->DAK_COD,DAK->DAK_SEQCAR,DAK->DAK_IDENT,DAK->DAK_CAMINH,DAK->DAK_MOTORI)
		EndIf
		DbSelectArea("DAI")
		DAI->(DbSkip())
	EndDo

	//-- Template DCL-EST - Estorno de Cargas com Compartimentos/Lacres associados.
	If lDclNew
		DCLOS200ES(DAK->DAK_COD,DAK->DAK_SEQCAR)
	ElseIf ExistTemplate("OS200ES2")
		ExecTemplate("OS200ES2",.F.,.F.,{DAK->DAK_COD,DAK->DAK_SEQCAR})
	EndIf
	//-- PE executado no final do estorno da carga
	If ExistBlock("OS200ES2")
		ExecBlock("OS200ES2",.F.,.F.,{DAK->DAK_COD,DAK->DAK_SEQCAR})
	EndIf

	//-- Integração Protheus x GFE (EXCLUSAO)
	If !FBSA200IPG(5,,,.T.,,,,cDakTransp)
		DisarmTransaction()
		lContinua := .F.
	EndIf

End Transaction

If lContinua
	If FindFunction("MaEnvEAI")
		MaEnvEAI(/*cEmpX*/, /*cFilX*/, /*nOpcx*/5, /*cMainModel*/ "OMSA200", /*aStruModel*/, /*lHelp*/, /*lEnvia*/, /*lLoadModel*/.F., oMdl, /*cXml*/, /*cFunName*/)
	EndIf
EndIf

RestArea( aAreaSC9 )
RestArea( aArea    )

Return


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Os200ProcManºAutor  ³DL                 º Data ³  01/19/01  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Processamento da manipulacao da carga                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP5Dl                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function FB200ProcMan()

Local aRotas     := {}
Local nPosCar    := AScan( aHeader ,{|x|Alltrim(x[2])=="DAI_COD"   } )
Local nPosSeqCar := AScan( aHeader ,{|x|Alltrim(x[2])=="DAI_SEQCAR"} )
Local nPosSeq    := AScan( aHeader ,{|x|Alltrim(x[2])=="DAI_SEQUEN"} )
Local nPosPed    := AScan( aHeader ,{|x|Alltrim(x[2])=="DAI_PEDIDO"} )
Local nPosCli    := AScan( aHeader ,{|x|Alltrim(x[2])=="DAI_CLIENT"} )
Local nPosLoja   := AScan( aHeader ,{|x|Alltrim(x[2])=="DAI_LOJA"  } )
Local nPosRota   := AScan( aHeader ,{|x|Alltrim(x[2])=="DAI_ROTEIR"} )
Local nPosZona   := AScan( aHeader ,{|x|Alltrim(x[2])=="DAI_PERCUR"} )
Local nPosSetor  := AScan( aHeader ,{|x|Alltrim(x[2])=="DAI_ROTA"  } )
Local nPosTime   := AScan( aHeader ,{|x|Alltrim(x[2])=="DAI_CHEGAD"} )
Local nPosSrv    := AScan( aHeader ,{|x|Alltrim(x[2])=="DAI_TMSERV"} )
Local nPosDtC    := AScan( aHeader ,{|x|Alltrim(x[2])=="DAI_DTCHEG"} )
Local nPosDtS    := AScan( aHeader ,{|x|Alltrim(x[2])=="DAI_DTSAID"} )

Local nRegSC9    := 0
Local nUsado     := Len(aHeader)+1
Local nTpVlEnt   := OsVlEntCom()
Local nElem      := 0
Local lTransp	   := DAK->(FieldPos("DAK_TRANSP")) > 0

Local cCarOri    := M->DAK_COD
Local cSeqOri    := M->DAK_SEQCAR
Local cRota      := ""

Local lGravou    := .F.
Local lFreteEmb  := .F.

Local Carga      := ""
Local cSequencia := ""
Local cFilPv     := IIf(nTpVlEnt<>1,DAI->DAI_FILPV,xFilial("SC9"))

Local lNumProp   := SuperGetMv("MV_EMITMP",.F.,"0") == "1" .And. SuperGetMv("MV_INTGFE2",.F.,"2") == "1"
Local cCgcTransp := ""

//-- Grava no cabecalho da carga os horarios!
RecLock("DAK")
DAK->DAK_DATA   := M->DAK_DATA
DAK->DAK_HORA   := M->DAK_HORA
DAK->DAK_HRSTAR := M->DAK_HRSTAR
If lTransp
	DAK->DAK_TRANSP := M->DAK_TRANSP
EndIf
MsUnlock()

//-- Varre todas as linhas do aCols
aCols := aSort(aCols,,,{|x,y| x[nPosCar]+x[nPosSeqCar]+x[nPosSeq] < y[nPosCar]+y[nPosSeqCar]+y[nPosSeq]})
For nElem := 1 to Len(aCols)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Posiciona o item de carga correspondente a linha do aCols    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	DbSelectArea("DAI")
	DAI->(DbSetOrder(4)) //DAI_FILIAL+DAI_PEDIDO+DAI_COD+DAI_SEQCAR
	If MsSeek(xFilial("DAI")+aCols[nElem][nPosPed]+cCarOri+cSeqOri)
		
		If lTransp
			//Altera a Transportadora do Pedido
			If !Empty(M->DAK_TRANSP)
				DbSelectArea("SC5")
				SC5->(DbSetOrder(1))
				If SC5->(MsSeek(xFilial("SC5")+DAI->DAI_PEDIDO))
					If SC5->C5_TRANSP <> M->DAK_TRANSP
						RecLock('SC5',.F.)
						SC5->C5_TRANSP := M->DAK_TRANSP
						MsUnlock()
					EndIf
				EndIf
			EndIf
			//Altera a Transportadora do Romaneio
			If AliasIndic('GWN')				
				DbSelectArea("GWN")
				GWN->(DbSetOrder(1))
				If GWN->(MsSeek(xFilial("GWN")+M->DAK_COD+M->DAK_SEQCAR))
					If lNumProp
						cCgcTransp := Posicione('GU3',13,xFilial('GU3')+M->DAK_TRANSP,'GU3_CDEMIT')
					ELse
						cCgcTransp := Posicione('SA4',1,xFilial('SA4')+M->DAK_TRANSP,'A4_CGC')
					EndIf
						RecLock('GWN',.F.)
						GWN->GWN_CDTRP := cCgcTransp
						MsUnlock()
				EndIf
			EndIf
		EndIf			

		
		//-- Verifica se usa Operador Logistico: Entrega compartilhada (pedidos de outras filiais)
		cFilPv := IIf(nTpVlEnt<>1,DAI->DAI_FILPV,xFilial("SC9"))

		Do Case

		Case !aCols[nElem][nUsado] .And.( aCols[nElem][nPosSeq] <> DAI->DAI_SEQUEN )

			//-- Procura no SC9 o registro correspondente e atualiza a carga
			DbSelectArea("SC9")
			SC9->(DbSetOrder(5)) //C9_FILIAL+C9_CARGA+C9_SEQCAR+C9_SEQENT
			If MsSeek(OsFilial("SC9",cFilPv)+DAI->DAI_COD+DAI->DAI_SEQCAR+DAI->DAI_SEQUEN)
				While !Eof() .And.	SC9->(C9_FILIAL + C9_CARGA + C9_SEQCAR + C9_SEQENT) == ;
									OsFilial("SC9",cFilPv)+DAI->(DAI_COD + DAI_SEQCAR + DAI_SEQUEN)
					SC9->(DbSkip())
					nRegSC9 := SC9->(Recno())
					SC9->(DbSkip(-1))
					If DAI->DAI_PEDIDO == SC9->C9_PEDIDO
						RecLock("SC9")
						SC9->C9_SEQENT:= aCols[nElem][nPosSeq]
						MsUnlock()
						SF2->(DbSetOrder(1))//F2_FILIAL+F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA+F2_FORMUL+F2_TIPO
						If SF2->(MsSeek(xFilial("SF2")+SC9->C9_NFISCAL+SC9->C9_SERIENF+SC9->C9_CLIENTE+SC9->C9_LOJA)) .And. ;
							SF2->F2_SEQENT <> SC9->C9_SEQENT
							RecLock("SF2")
							SF2->F2_SEQENT := aCols[nElem][nPosSeq]
							MsUnlock()
						EndIf
					EndIf
					SC9->(MsGoto(nRegSC9))
				EndDo
			EndIf
			Reclock("DAI")
			DAI->DAI_SEQUEN := aCols[nElem,nPosSeq]
			If !Empty( nPosSrv )
				DAI->DAI_TMSERV := aCols[nElem,nPosSrv ]
			EndIf
			If !Empty( nPosTime )
				DAI->DAI_CHEGAD := aCols[nElem,nPosTime]
			EndIf
			If !Empty( nPosDtC )
				DAI->DAI_DTCHEG := aCols[nElem,nPosDtC ]
			EndIf
			If !Empty( nPosDtS )
				DAI->DAI_DTSAID := aCols[nElem,nPosDtS ]
			EndIf
			MsUnlock()

		//-- Verifica se houve alteracao do numero da carga
		Case !aCols[nElem][nUsado] .And. ( aCols[nElem][nPosCar   ] <> DAI->DAI_COD .Or. ;
											aCols[nElem][nPosSeqcar] <> DAI->DAI_SEQCAR )

			DbSelectArea("SC9")
			SC9->(DbSetOrder(1))
			If MsSeek(OsFilial("SC9",cFilPv)+aCols[nElem][nPosPed])
				While SC9->(!Eof()) .And. SC9->C9_FILIAL == OsFilial("SC9",cFilPv) .And.;
						SC9->C9_PEDIDO  == aCols[nElem][nPosPed]
					If SC9->C9_CARGA == cCarOri .And. SC9->C9_SEQCAR == cSeqOri
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³Exclui o SC9 da carga origem                                   ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						MaAvalSC9("SC9",8)
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³Atualiza SC9 com a nova carga                                  ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						Reclock("SC9",.F.)
						SC9->C9_CARGA  := aCols[nElem][nPosCar   ]
						SC9->C9_SEQCAR := aCols[nElem][nPosSeqCar]
						SC9->C9_SEQENT := OsSeqEnt(SC9->C9_CARGA,SC9->C9_SEQCAR,SC9->C9_PEDIDO)
						MsUnlock()
						//-- Array com os dados da roteirizacao
						//   [01] Codigo da Rota
						//   [02] Codigo da Zona
						//   [03] Codigo do Setor
						//   [04] Motorista
						//   [05] Caminhao
						//   [06] Ajudante 1
						//   [07] Ajudante 2
						//   [08] Ajudante 3
						//   [09] Hora chegada
						//   [10] Time Service
						//   [11] Data chegada
						//   [12] Data saida
						//   [13] Hora de inicio de entrega
						//   [14] Valor do Frete (DAI_VALFRE)*
						//   [15] Frete Autonomo (DAI_FREAUT)*
						AAdd( aRotas ,aCols[nElem,nPosRota ] )
						AAdd( aRotas ,aCols[nElem,nPosZona ] )
						AAdd( aRotas ,aCols[nElem,nPosSetor] )
						AAdd( aRotas ,"" )
						AAdd( aRotas ,"" )
						AAdd( aRotas ,"" )
						AAdd( aRotas ,"" )
						AAdd( aRotas ,"" )
						AAdd( aRotas ,aCols[nElem][nPosTime] )
						AAdd( aRotas ,aCols[nElem][nPosSrv ] )
						AAdd( aRotas ,aCols[nElem][nPosDtC ] )
						AAdd( aRotas ,aCols[nElem][nPosDtS ] )
						AAdd( aRotas ,"" )
						//-- Inclui o item do SC9 na nova carga
						MaAvalSC9("SC9",7,,,,,,aRotas)
					EndIf
					SC9->(DbSkip())
				EndDo
			EndIf

		//-- Verifica se o pedido corrente foi deletado da carga
		Case aCols[nElem][nUsado]

			SC5->(DbSetOrder(1))
			DbSelectArea("SC9")
			SC9->(DbSetOrder(1))
			If MsSeek(OsFilial("SC9",cFilPv)+aCols[nElem][nPosPed])
				While SC9->(!Eof()) .And. SC9->C9_FILIAL == OsFilial("SC9",cFilPv) .And.;
									SC9->C9_PEDIDO == aCols[nElem][nPosPed]
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Verifica se o item do SC9 pertence a carga selecionada³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If SC9->C9_CARGA == cCarOri .And. SC9->C9_SEQCAR == cSeqOri
						//-- Estornando a ordem de serviço do WMS
						If IntWms(SC9->C9_PRODUTO) .And. !Empty(SC9->C9_SERVIC) .And. ;
							SC5->(MsSeek(OsFilial("SC5",cFilPv)+SC9->C9_PEDIDO)) .And. SC5->C5_GERAWMS <> "1"
							WmsUndoPed(SC9->(Recno()))
						EndIf
						//-- 8.Estorno Mont.Carga
						MaAvalSC9("SC9",8)
					EndIf
					SC9->(DbSkip())
				EndDo
			EndIf

		OtherWise
			Reclock("DAI")
			DAI->DAI_SEQUEN := aCols[nElem,nPosSeq]
			If !Empty( nPosSrv )
				DAI->DAI_TMSERV := aCols[nElem,nPosSrv ]
			EndIf
			If !Empty( nPosTime )
				DAI->DAI_CHEGAD := aCols[nElem,nPosTime]
			EndIf
			If !Empty( nPosDtC )
				DAI->DAI_DTCHEG := aCols[nElem,nPosDtC ]
			EndIf
			If !Empty( nPosDtS )
				DAI->DAI_DTSAID := aCols[nElem,nPosDtS ]
			EndIf
			MsUnlock()

		EndCase

	EndIf

Next nElem

//-- Ponto de entrada apos gravacao da manutencao da carga.
If ExistBlock("OS200PM")
	ExecBlock("OS200PM",.F.,.F.)
EndIf

lGravou := .T.

Return( lGravou )

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Oms200ARotaºAutor  ³DL                  º Data ³  01/31/01  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Verifica se existe mais de uma rota  no range de pedidos   º±±
±±º          ³ e obriga o usuario a escolher apenas uma                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP5                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function Oms200ARota(aArrayMan)
Local oDlgRot
Local nOpca      := 0
Local nPosRota   := 0
Local nC         := 0
Local aArrayRt   := {}
Local cDescRota  := ""

For nC := 1 to Len(aArrayMan)
	If (Ascan(aArrayRt,{|x| x[1] == aArrayMan[nC,3]}) == 0)
		DA8->(DbSetOrder(1))
		If DA8->(MsSeek(xFilial("DA8")+aArrayMan[nC,2]))
			cDescRota:= DA8->DA8_DESC
		EndIf
		AAdd(aArrayRt, {aArrayMan[nC,3],cDescRota})
	EndIf
Next nC

aArrayRt := aSort(aArrayRt,,,{|x,y| x[1] < y[1]})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Se existir mais de uma rota monto checkbox para o usuario³
//³escolher apenas uma par associar                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Len(aArrayRt) > 1
	DEFINE MSDIALOG oDlgRot FROM 009, 000 TO 28,80 TITLE OemtoAnsi(STR0061) OF oMainWnd //"Composicao de Rotas na Carga"
	@ 015,005 LISTBOX oRt VAR cVar Fields HEADER OemtoAnsi(STR0022), ;
		OemtoAnsi(STR0020) SIZE 300,120 OF oDlgRot PIXEL //"Rota" ### "Descricao"
	oRt:SetArray(aArrayRt)
	oRt:bLine:={||{ aArrayRt[oRt:nAT,1], aArrayRt[oRt:nAT,2] }}
	oRt:Refresh()
	ACTIVATE MSDIALOG oDlgRot ON INIT EnchoiceBar(oDlgRot, {|| nOpca := 1,oDlgRot:End()}, {||oDlgRot:End()}) CENTERED
Else
	nOpca := 1
EndIf

Return( nOpca == 1 )

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Os200CriaTrbºAutor  ³DL                  º Data ³  02/13/01 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Cria arquivo temporarios para MsSelect da tela de montagem º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP5dl                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function Os200CriaTrb(aCampos,oTempTable)
Local cAlias    := ""
Local aRetPE    := {}
Local lFreteEmb := .F.
Local nTamCod   := TamSx3("B1_COD")[1]
Local cAlocPer  := SuperGetMv("MV_ALOCPER",.F.,"N")
Private oTempTable

nIndice := 5

AAdd( aCampos ,{"PED_MARCA"  ,"C" ,2 ,0} )
AAdd( aCampos ,{"PED_GERA"   ,"C" ,1 ,0} )
AAdd( aCampos ,{"PED_ROTA"   ,"C" ,6 ,0} )
AAdd( aCampos ,{"PED_ZONA"   ,"C" ,6 ,0} )
AAdd( aCampos ,{"PED_SETOR"  ,"C" ,6 ,0} )
AAdd( aCampos ,{"PED_SEQROT" ,"C" ,6 ,0} )
AAdd( aCampos ,{"PED_PEDIDO" ,"C" ,6 ,0} )
AAdd( aCampos ,{"PED_ITEM"   ,"C" ,2 ,0} )
AAdd( aCampos ,{"PED_SEQLIB" ,"C" ,2 ,0} )
If	mv_par06 == 2
	AAdd( aCampos ,{"PED_CODPRO" ,"C" ,nTamCod,0} )
	AAdd( aCampos ,{"PED_DESPRO" ,"C" ,TamSx3("B1_DESC")[1],0} )
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Cria o campo de filial de origem caso o tipo de operacao trabalhe com todas as filiais³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
AAdd( aCampos ,{"PED_FILORI" ,"C" ,FWGETTAMFILIAL			,0}							)
AAdd( aCampos ,{"PED_FILCLI" ,"C" ,FWGETTAMFILIAL			,0}							)
AAdd( aCampos ,{"PED_CODCLI" ,"C" ,TamSx3("A1_COD")[1]		,TamSx3("A1_COD")[2]}		)
AAdd( aCampos ,{"PED_LOJA"   ,"C" ,TamSx3("A1_LOJA")[1]	,TamSx3("A1_LOJA")[2]}		)
AAdd( aCampos ,{"PED_NOME"   ,"C" ,30						,0}							)
AAdd( aCampos ,{"PED_PESO"   ,"N" ,TamSx3("DAK_PESO")[1]	,TamSx3("DAK_PESO")[2]}		)
AAdd( aCampos ,{"PED_CARGA"  ,"C" ,6						,0}							)
AAdd( aCampos ,{"PED_SEQSET" ,"C" ,6						,0}							)
AAdd( aCampos ,{"PED_SEQORI" ,"C" ,6						,0}							)
AAdd( aCampos ,{"PED_VALOR"  ,"N" ,TamSx3("DAK_VALOR")[1]	,TamSx3("DAK_VALOR")[2]}	)
AAdd( aCampos ,{"PED_VOLUM"  ,"N" ,TamSx3("DAK_CAPVOL")[1]	,TamSx3("DAK_CAPVOL")[2]}	)
AAdd( aCampos ,{"PED_ENDPAD" ,"C" ,15						,0}							)
AAdd( aCampos ,{"PED_ENDCLI" ,"C" ,TamSx3("A1_END")[1]	    ,TamSx3("A1_END")[2]}		)
AAdd( aCampos ,{"PED_BAIRRO" ,"C" ,30						,0}							)
AAdd( aCampos ,{"PED_MUN"    ,"C" ,TamSx3("A1_MUN")[1]		,0}							)
AAdd( aCampos ,{"PED_EST"    ,"C" ,2						,0}							)
AAdd( aCampos ,{"PED_CEP"    ,"C" ,TamSx3("A1_CEP")[1]		,TamSx3("A1_CEP")[2]}		)
AAdd( aCampos ,{"PED_QTDLIB" ,"N" ,14						,2}							)
AAdd( aCampos ,{"TRANSP"	 ,"C" ,6						,0}							)
If	lFreteEmb
	AAdd( aCampos ,{"PED_CDRDES" ,"C" ,TamSx3("A1_CDRDES")[1]	,TamSx3("A1_CDRDES")[2]}	) //"Codigo Regiao Destino"
	AAdd( aCampos ,{"PED_TPFRET" ,"C" ,3						,0}							) //"Tipo Frete"
	AAdd( aCampos ,{"PED_VALFRE" ,"N" ,TamSx3("DAI_VALFRE")[1]	,TamSx3("DAI_VALFRE")[2]}	) //"Valor Frete"
	AAdd( aCampos ,{"PED_FREAUT" ,"N" ,TamSx3("DAI_FREAUT")[1]	,TamSx3("DAI_FREAUT")[2]}	) //"Frete Autonomo"
EndIf

If	ExistBlock("DL200TRB")
	aRetPE := ExecBlock("DL200TRB",.F.,.F.,aCampos)
	If	ValType(aRetPE)=="A"
		aCampos := aRetPE
	EndIf
EndIf

cAlias  := "TRBPED"

oTempTable := FWTemporaryTable():New( cAlias )
oTempTable:SetFields( aCampos )
oTempTable:AddIndex("01", {"PED_FILORI","PED_PEDIDO","PED_ITEM","PED_SEQLIB","PED_CODCLI","PED_LOJA"} )
oTempTable:AddIndex("02", {"PED_ROTA","PED_SEQORI","PED_SEQSET","PED_ZONA","PED_SETOR","PED_CEP","PED_FILORI","PED_PEDIDO","PED_ITEM"} )
oTempTable:AddIndex("03", {"PED_ROTA","PED_SEQROT","PED_FILORI","PED_PEDIDO"} )
oTempTable:AddIndex("04", {"PED_ROTA","PED_ZONA","PED_SETOR","PED_FILORI","PED_PEDIDO"} )

If	cAlocPer == "S" .And. mv_par06 <> 2
	oTempTable:AddIndex("05", {"PED_ZONA","PED_SETOR","PED_FILORI","PED_PEDIDO"} )
ElseIf mv_par06 == 2 
	oTempTable:AddIndex("05", {"PED_ZONA","PED_SETOR","PED_FILORI","PED_CODPRO","PED_PEDIDO","PED_ITEM","PED_SEQLIB","PED_CODCLI","PED_LOJA"} )
Else
	oTempTable:AddIndex("05", {"PED_ZONA","PED_SETOR","PED_FILORI","PED_PEDIDO","PED_ITEM","PED_SEQLIB","PED_CODCLI","PED_LOJA"} )
EndIf

If mv_par06 == 2
	oTempTable:AddIndex("06", {"PED_FILORI","PED_CODPRO","PED_PEDIDO","PED_ITEM","PED_SEQLIB","PED_CODCLI","PED_LOJA"} )
	nIndice++
Else
	oTempTable:AddIndex("06", {"PED_FILORI","PED_PEDIDO","PED_ITEM","PED_SEQLIB","PED_CODCLI","PED_LOJA","PED_MARCA"} )
	nIndice++
EndIf

oTempTable:AddIndex("07", {"PED_CODCLI","PED_LOJA"} )
nIndice++

oTempTable:AddIndex("08", {"PED_EST","PED_MUN","PED_CODCLI","PED_LOJA","PED_PEDIDO"} )
nIndice++

If	ExistBlock("DL200TR2")
	SA1->(ExecBlock("DL200TR2",.F.,.F.,{oTempTable }))
EndIf

oTempTable:Create()

Return


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³OSAgrCarga³ Autor ³ Eduardo Riera         ³ Data ³29.10.2001 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³Rotina de atualizacao do processo de agrupamento de cargas   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpA1: Array com as cargas de origem                         ³±±
±±³          ³       [1] Codigo da Carga                                   ³±±
±±³          ³       [2] Sequencia da Carga                                ³±±
±±³          ³ExpC2: Carga de Destino                                      ³±±
±±³          ³ExpC3: Sequencia da carga de Destino                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Esta rotina tem como objetivo atualizar os dados necessarios ³±±
±±³          ³para agrupar as cargas                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Distribuicao                                                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function FBAgrCarga(aOrigem,cCarga,cSeqCar, cCaminhDes)
Local aArea      := GetArea()
Local aCarga     := {}
Local aItens     := {}
Local aCliente   := {}
Local cQuery     := ""
Local cAliasDAI  := "DAI"
Local cAliasDAK  := ""
Local cCodCli    := ""
Local cLoja      := ""
Local cSeqAnt    := ""
Local cSeqProx   := ""
Local cFilPed    := ""
Local cPedido    := ""
Local cEndereco  := ""
Local nX         := 0
Local nY         := 0
Local nPeso      := 0
Local nPesoProd  := 0
Local nCapVol    := 0
Local nCapArm    := 0
Local nVlCarga   := 0
Local nRecSC9    := 0
Local nTipoOper  := OsVlEntCom()
Local nSeqTemp   := 0
Local nSequencia := 0
Local nSeqInc    := SuperGetMV("MV_OMSENTR",.F.,5)
Local lFreteEmb  := .F.
Local cFilPV     := ""
Local oMdl       := ""
Local lIntGFE    := SuperGetMv("MV_INTGFE",.F.,.F.)
Local cIntGFE2   := SuperGetMv("MV_INTGFE2",.F.,"2")
Local cIntCarga  := SuperGetMv("MV_GFEI12",.F.,"2")
Local cDakTransp := Criavar("A4_COD",.F.)
Local lDakTrp    := DAK->( FieldPos( "DAK_TRANSP" ) ) > 0
Local lIntWMS    := .F.
Local nCapac     := 0
Local lRet  	   := .T.
Local nVldRestr  := 0
Local lPesoTot   := .F.
Local lFezNF     := .F.

Default cCaminhDes := ""

//--

//Begin Transaction

	Pergunte("OMS200A",.F.)
	If Type("MV_PAR01") <> "N"
		nVldRestr := 2
	Else
		nVldRestr := MV_PAR01
	EndIf

	//Validação Restrição de Veiculos	
	If nVldRestr = 1 .And. !Empty(cCaminhDes)
		cAliasDAK := GetNextAlias()
		cQuery := "SELECT SUM(DAK_PESO) AS DAK_PESO, SUM(DAK_PTOENT) AS DAK_PTOENT, SUM(DAK_CAPVOL) AS DAK_VOL "
		cQuery += " FROM "+RetSqlName("DAK")+" DAK "
		cQuery += "WHERE DAK.DAK_FILIAL = '" + xFilial("DAK") + "'"
		cQuery += " AND  DAK.DAK_COD  = '" + cCarga + "'"
		cQuery += " AND  DAK.DAK_SEQCAR='" + cSeqCar + "'"
		
		For nX := 1 To Len(aOrigem)
			cQuery += " OR  DAK.DAK_COD  = '" + aOrigem[nX][1] + "'"
			cQuery += " AND DAK.DAK_SEQCAR='" + aOrigem[nX][2] + "'"
		Next nX
				
		cQuery += " AND DAK.D_E_L_E_T_=' ' "
		cQuery := ChangeQuery(cQuery)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasDAK,.T.,.T.)
		
		DA3->(DbSetOrder(1))
		If	DA3->(MsSeek(xFilial("DA3")+cCaminhDes))

			If (cAliasDAK)->DAK_PESO > DA3->DA3_CAPACN .Or. ;
				(cAliasDAK)->DAK_VOL > DA3->DA3_VOLMAX  .Or. ;
				(cAliasDAK)->DAK_PTOENT > DA3->DA3_LIMMAX
		
				Help(" ",1,"OMSULTCARG") //Caminhao nao suporta carga montada
				lRet := .F.
			EndIf
		EndIf
		
		(cAliasDAK)->(DbCloseArea())
		If !lRet
			Return(.F.)
		EndIf			
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Inicio do processamento das cargas                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	AAdd(aCarga,cCarga+cSeqCar)
	For nX := 1 To Len(aOrigem)
		AAdd(aCarga,aOrigem[nX][1]+aOrigem[nX][2])
	Next nX
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Atualiza os dados da carga de destino                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	DbSelectArea("DAK")
	DAK->(DbSetOrder(1)) //DAK_FILIAL+DAK_COD+DAK_SEQCAR
	For nX := 1 To Len(aOrigem)
		If MsSeek(xFilial("DAK")+aOrigem[nX][1]+aOrigem[nX][2]) .And. DAK->DAK_FEZNF = '2'
			lFezNF := .T.
		EndIf
	Next nX
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Atualiza os dados da carga de destino                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If	MsSeek(xFilial("DAK")+cCarga+cSeqCar)

		If lDakTrp
			cDakTransp := DAK->DAK_TRANSP
		EndIf
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Busca o endereco padrao da carga                             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cEndereco := FB200EndOri(cCarga,cSeqCar)
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Atualizo variaveis com os dados da carga origem              ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		RecLock("DAK")
		DAK->DAK_JUNTOU := "JUNTOU"
		DAK->DAK_PESO   := 0
		DAK->DAK_CAPVOL := 0
		DAK->DAK_VALOR  := 0
		DAK->DAK_PTOENT := 0

 		If lFezNF
 			DAK->DAK_FEZNF := '2'
 		EndIf
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Selecao dos itens das cargas para coloca-las em ordem        ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		For nX := 1 To 2
			DbSelectArea("DAI")
			DAI->(DbSetOrder(1)) //DAI_FILIAL+DAI_COD+DAI_SEQCAR+DAI_SEQUEN+DAI_PEDIDO
			If TcSrvType()<>"AS/400"
				cAliasDAI := "Oms200Proc"
				cQuery := "SELECT DAI.R_E_C_N_O_ DAIRECNO "
				cQuery += "FROM "+RetSqlName("DAI")+" DAI "
				cQuery += "WHERE DAI.DAI_FILIAL='"+xFilial("DAI")+"'"
				cQuery += " AND  DAI.DAI_COD   ='"+SubStr(aCarga[nX],1,6)+"'"
				cQuery += " AND  DAI.DAI_SEQCAR='"+SubStr(aCarga[nX],7)+"'"
				cQuery += " AND  DAI.D_E_L_E_T_=' ' "
				cQuery += "ORDER BY "+SqlOrder(DAI->(IndexKey()))
				cQuery := ChangeQuery(cQuery)
				dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasDAI,.T.,.T.)
			Else
				MsSeek(xFilial("DAI")+aCarga[nX])
			EndIf
			
			While (cAliasDAI)->(!Eof())
				DAI->(DbGoTo((cAliasDAI)->DAIRECNO))
				nSeqTemp++
				AAdd(aItens,{	DAI->DAI_COD,;
								DAI->DAI_SEQCAR,;
								StrZero(nSeqTemp,6),;
								DAI->DAI_CLIENT,;
								DAI->DAI_LOJA,;
								DAI->DAI_PEDIDO,;
								DAI->DAI_ROTEIR,;
								DAI->DAI_PERCUR,;
								DAI->DAI_ROTA,;
								DAI->(RecNo()),;
								If(nX==1," ","z"),;
								If(nTipoOper<>1,DAI->DAI_FILPV,xFilial("SC9")),;
								DAI->DAI_PEDIDO} )
				(cAliasDAI)->(DbSkip())
			EndDo
			DbSelectArea(cAliasDAI)
			DbCloseArea()
			DbSelectArea("DAI")
		Next nX
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Marca os pedidos repetidos para delecao                      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		For nX := 1 To Len(aItens)
			cPedido := aItens[nX][12]+aItens[nX][6]
			If aItens[nX][11] == " "
				While (nY := aScan(aItens,{|x| x[12]+x[6]==cPedido .And. x[11]=="z"})) > 0
					aItens[nY][6] := ""
				EndDo
			Else
				Exit
			EndIf
		Next nX
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Pedidos iguais devem permancer na mesma sequencia            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		For nX := 1 To Len(aItens)
			cFilPed := aItens[nX][12]
			cPedido := aItens[nX][13]
			If	aItens[nX][11] == " "
				nY := 0
				While (nY := aScan(aItens,{|x| x[12] == cFilPed .And. x[13]==cPedido .And. x[11]=="z"},nY+1)) > 0
					aItens[nY][3] := aItens[nX][3]
				EndDo
			Else
				Exit
			EndIf
		Next nX
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Clientes iguais deve permancer na mesma sequencia            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		For nX := 1 To Len(aItens)
			cFilPed := aItens[nX][12]
			cCodCli := aItens[nX][4]
			cLoja   := aItens[nX][5]
			If	aItens[nX][11] == " "
				nY := 0
				While (nY := aScan(aItens,{|x| x[12] == cFilPed .And. x[4]==cCodCli .And. x[5]==cLoja .And. x[11]=="z"},nY+1)) > 0
					aItens[nY][3] := aItens[nX][3]
				EndDo
			Else
				Exit
			EndIf
		Next nX
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Ordena os itens da carga                                     ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		aItens := aSort(aItens,,,{|x,y| x[2]+x[3]+X[13]+x[11] < y[2]+y[3]+y[13]+y[11] })
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Renumera a sequencia de entrega                              ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nSeqInc := IIF(nSeqInc > 0,nSeqInc,5)
		nSequencia += nSeqInc
		For nX := 1 To Len(aItens)
			cSeqAnt := aItens[nX][13]+aItens[nX][3]
			aItens[nX][3] := StrZero(nSequencia,6)
			If cSeqAnt <> aItens[Min(nX+1,Len(aItens))][13]+aItens[Min(nX+1,Len(aItens))][3]
				nSequencia += nSeqInc
			EndIf
		Next nX
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Atualiza os dados da nova carga                              ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		For nX := 1 To Len(aItens)
			nPeso    := 0
			nCapVol  := 0
			nVlCarga := 0
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Posiciona registros                                          ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			DbSelectArea("DAI")
			MsGoto(aItens[nX][10])
			cFilPv := IIf(nTipoOper<>1,DAI->DAI_FILPV,xFilial("SC9"))
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Procura no SC9 o registro correspondente e atualiza a carga  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			DbSelectArea("SC9")
			SC9->(DbSetOrder(5)) //-- C9_FILIAL+C9_CARGA+C9_SEQCAR+C9_SEQENT
			If SC9->(MsSeek(OsFilial("SC9",cFilPv)+DAI->DAI_COD+DAI->DAI_SEQCAR+DAI->DAI_SEQUEN))
				While !Eof() .And. SC9->C9_FILIAL == OsFilial("SC9",cFilPv) .And.;
						SC9->C9_CARGA  == DAI->DAI_COD    .And.;
						SC9->C9_SEQCAR == DAI->DAI_SEQCAR .And.;
						SC9->C9_SEQENT == DAI->DAI_SEQUEN
					//--
					SC9->(DbSkip())
					nRecSc9 := SC9->(Recno())
					SC9->(DbSkip(-1))
					//--
					If DAI->DAI_PEDIDO == SC9->C9_PEDIDO
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Apaga os Servicos de WMS a executar                          ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						lIntWMS := IntWms(SC9->C9_PRODUTO) .And. !Empty(SC9->C9_SERVIC)
						If lIntWMS
							If SC5->(MsSeek(xFilial("SC5")+SC9->C9_PEDIDO)) .And. SC5->C5_GERAWMS <> "1"
								WmsUndoPed(SC9->(Recno()))
							EndIf
						EndIf
						RecLock("SC9")
						SC9->C9_CARGA  := DAK->DAK_COD
						SC9->C9_SEQCAR := DAK->DAK_SEQCAR
						SC9->C9_SEQENT := aItens[nX][3]
						SC9->C9_ENDPAD := cEndereco
						MsUnlock()

						// Atualiza a transportadorad nos pedidos de venda
						If lDakTrp .And. !Empty(cDakTransp)
							SC5->(DbSetOrder(1))
							If SC5->(MsSeek(xFilial("SC5")+SC9->C9_PEDIDO))
								RecLock('SC5',.F.)
								SC5->C5_TRANSP := cDakTransp
								MsUnlock()
							EndIf
						 EndIf

						//----------------------------------------------------------------------------------------------------------
						// Posicionamento no item do pedido de venda para buscar a TES informada e consistir atualização de estoque
						//----------------------------------------------------------------------------------------------------------
						dbSelectArea("SC6")
						If !(xFilial("SC6")==SC6->C6_FILIAL .And.;
								SC6->C6_NUM==SC9->C9_PEDIDO .And.;
								SC6->C6_ITEM==SC9->C9_ITEM .And.;
								SC6->C6_PRODUTO==SC9->C9_PRODUTO)
							dbSetOrder(1)
							MsSeek(xFilial("SC6")+SC9->(C9_PEDIDO+C9_ITEM+C9_PRODUTO))
						EndIf
						dbSelectArea("SF4")
						dbSetOrder(1)
						MsSeek(xFilial("SF4")+SC6->C6_TES)
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Gera os Servicos com a nova Carga                            ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						If SF4->F4_ESTOQUE=="S" .And. lIntWMS .And. SC5->C5_GERAWMS == "2"
							WmsIntPed(SC9->(Recno()))
						EndIf

						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Pesquisa o Arquivo SF2 (Header da Nota Fiscal de Saida).     ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						If !Empty(SC9->C9_NFISCAL)
							DbSelectArea("SF2")
							SF2->(DbSetOrder(1)) //F2_FILIAL+F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA+F2_FORMUL+F2_TIPO
							If MsSeek(OsFilial("SF2",SC9->C9_FILIAL)+SC9->C9_NFISCAL+SC9->C9_SERIENF+SC9->C9_CLIENTE+SC9->C9_LOJA)
								RecLock("SF2", .F.)
								SF2->F2_CARGA  := DAK->DAK_COD
								SF2->F2_SEQCAR := DAK->DAK_SEQCAR
								MsUnlock()
								If FindFunction("MaEnvEAI")
									MaEnvEAI(,,4,"MATA461")
								EndIf
							EndIf
						EndIf
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Calcula os dados acumulados do DAI/DAK                       ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						DbSelectArea("SB1")
						SB1->(DbSetOrder(1))
						If	SB1->(MsSeek(OsFilial("SB1",SC9->C9_FILIAL)+SC9->C9_PRODUTO))
							//-- Calculo peso do item do pedido
							If FindFunction("OsPesoProd")
								nPesoProd := OsPesoProd(SC9->C9_PRODUTO)
							Else
								nPesoProd := SB1->(FieldGet(FieldPos(cCpoPeso)))
							EndIf
							nPeso    += (nPesoProd * SC9->C9_QTDLIB)
							nCapVol  += (OsPrCapArm(SB1->B1_COD,SC9->C9_FILIAL) * SC9->C9_QTDLIB)
							nVlCarga += A410Arred((SC9->C9_QTDLIB * SC9->C9_PRCVEN), "DAK_VALOR")
						EndIf
					EndIf
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Vai para o proximo registro do SC9                           ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					SC9->(MsGoto(nRecSc9))
				EndDo
			EndIf
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica se o pedido de venda ja possui um item vinculado    ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If Empty(aItens[nX][6])
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Estorna o item duplicado do DAI e posiciona no novo item     ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				DbSelectArea("DAI")
				Reclock("DAI")
				dbDelete()
				MsUnLock()

				DbSelectArea("DAI")
				DAI->(DbSetOrder(1))
				MsSeek(xFilial("DAI")+DAK->DAK_COD+DAK->DAK_SEQCAR+aItens[nX][3])

				nPeso	+= DAI->DAI_PESO
				lPesoTot := .T.
				nCapVol += DAI->DAI_CAPVOL
			EndIf
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Atualiza os dados do item da carga                           ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			Reclock("DAI")
			DAI->DAI_COD    := DAK->DAK_COD
			DAI->DAI_SEQCAR := DAK->DAK_SEQCAR
			DAI->DAI_SEQUEN := aItens[nX][3]
			DAI->DAI_CARORI := aItens[nX][1]
			DAI->DAI_PESO   := nPeso
			DAI->DAI_CAPVOL := nCapVol
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Atualiza os dados da carga                                   ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			nY := aScan(aCliente,DAI->DAI_CLIENT+DAI->DAI_LOJA)
			RecLock("DAK")			
			If lPesoTot
		    	DAK->DAK_PESO := nPeso
	   		Else
		    	DAK->DAK_PESO += nPeso
		   	EndIf
			DAK->DAK_CAPVOL += nCapVol
			DAK->DAK_VALOR  += nVlCarga
			DAK->DAK_PTOENT += If(nY>0,0,1)

			AAdd(aCliente,DAI->DAI_CLIENT+DAI->DAI_LOJA)

		Next nX

		For nX := 1 To Len(aOrigem)

			If	lFreteEmb
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Exclui as cargas de origem                                   ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				DbSelectArea("DAT")
				DAT->(DbSetOrder(1)) //-- DAT_FILIAL+DAT_COD+DAT_SEQCAR+DAT_CODPAS
				If	MsSeek(xFilial("DAT")+aOrigem[nX][1]+aOrigem[nX][2])
					While DAT->(!Eof() .And. DAT_FILIAL == xFilial("DAI") .And. DAT_COD+DAT_SEQCAR == aOrigem[nX][1]+aOrigem[nX][2])
						RecLock("DAT")
						dbDelete()
						MsUnlock()
						DAT->(DbSkip())
					EndDo
				EndIf

				DbSelectArea("DAS")
				DAS->(DbSetOrder(1)) //-- DAS_FILIAL+DAS_COD+DAS_SEQCAR
				If	MsSeek(xFilial("DAS")+aOrigem[nX][1]+aOrigem[nX][2])
					While DAS->(!Eof() .And. DAS_FILIAL == xFilial("DAI") .And. DAS_COD+DAS_SEQCAR == aOrigem[nX][1]+aOrigem[nX][2])
						RecLock("DAS")
						dbDelete()
						MsUnlock()
						DAS->(DbSkip())
					EndDo
				EndIf
			EndIf

			DbSelectArea("DAI")
			DAI->(DbSetOrder(1))
			If	MsSeek(xFilial("DAI")+aOrigem[nX][1]+aOrigem[nX][2])
				While DAI->(!Eof() .And. DAI_FILIAL == xFilial("DAI") .And. DAI_COD+DAI_SEQCAR == aOrigem[nX][1]+aOrigem[nX][2])
					RecLock("DAI")
					dbDelete()
					MsUnlock()
					DAI->(DbSkip())
				EndDo
			EndIf

			DbSelectArea("DAK")
			DAK->(DbSetOrder(1))
			If	MsSeek(xFilial("DAK")+aOrigem[nX][1]+aOrigem[nX][2])

				If FindFunction("MaEnvEAI")
					oMdl := MaEnvEAI(,,5,"OMSA200",,,.F.)
				EndIf

				RecLock("DAK")
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Retira a reserva do veiculo                                           ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If	SuperGetMv("MV_ALOCVEI",.F.,.T.)
					OsVAgenda(DAK->DAK_COD,DAK->DAK_SEQCAR,DAK->DAK_CAMINH,2)
				EndIf
				dbDelete()
				MsUnlock()
			EndIf

			//--Exclusão da carga integrada ao GFE na integração Direta
			If lIntGFE == .T. .And. cIntGFE2 $ "1" .And. cIntCarga == "1"
				FBSA200IPG(5,,,.T.,aOrigem[nX][1],aOrigem[nX][2],,cDakTransp)
			EndIf

		Next nX

	EndIf
	//--PE executado apos a aglutinacao de cargas
	If ExistBlock("OSAGRCAR")
		ExecBlock("OSAGRCAR",.F.,.F.,{aOrigem,cCarga,cSeqCar})
	EndIf

//End Transaction

//-- Executando as ordens de serviços geradas no WMS
If IntWms()
	WmsAvalExe()
EndIf

If !Empty(oMdl) .And. FindFunction("MaEnvEAI")
	MaEnvEAI(,,5,"OMSA200",,,,.F.,oMdl)
EndIf

RestArea( aArea )

Return( .T. )

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³Oms200VlCg³ Autor ³ Eduardo Riera         ³ Data ³29.10.2001 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³Validacao da rotina de agrupamento de cargas                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpC1: Carga de Origem                                       ³±±
±±³          ³ExpC2: Sequencia de Origem                                   ³±±
±±³          ³ExpC3: Carga de destino                                      ³±±
±±³          ³ExpC4: Sequencia de destino                                  ³±±
±±³          ³ExpD5: Data de Origem                                        ³±±
±±³          ³ExpC6: Roteiro de Destino                                    ³±±
±±³          ³ExpC7: Caminhao de Destino                                   ³±±
±±³          ³ExpC8: Motorista de Destino                                  ³±±
±±³          ³ExpD9: Data de Destino                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Esta rotina tem como objetivo validar os dados informados na ³±±
±±³          ³interface                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Distribuicao                                                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function Os200VldCg(cCodCarDes,cSeqCarDes,cCodCarOri,cSeqCarOri,dDatCarOri,cRoteirDes,cCaminhDes,cMotoriDes,dDatCarDes)

Local aArea     := GetArea()
Local aAreaDAK  := DAK->(GetArea())
Local aAreaSC9  := {}
Local cSeekSC9  := ""
Local lRet      := .T.
Local cStatOri  := ""
Local cStatDes  := ""
Local lFreteEmb := .F.
Local cCplInt   := SuperGetMv("MV_CPLINT",.F.,"2")  

cSeqCarDes := If(Empty(cSeqCarDes),DAK->DAK_SEQCAR,cSeqCarDes)

//Integração OMSxCPL			
If MsSeek(xFilial("DAK") + cCodCarDes + cSeqCarDes)
	If DAK->(ColumnPos("DAK_VIAROT")) > 0
		If !Empty(DAK_VIAROT) .And. cCplInt == '1'
			Help(" ",1,"OMS200AGRPCPL")//Carga gerada pela integração com o Cockpit Logístico, agrupamento não permitido.
			Return(.F.)
		EndIf
	EndIf
EndIf

DbSelectArea("DAK")
DAK->(DbSetOrder(1))
If MsSeek(xFilial("DAK")+cCodCarOri+cSeqCarOri)
	cStatOri := DAK->DAK_FEZNF
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Valida no cadastro de cargas o codigo de carga informado     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DbSelectArea("DAK")
DAK->(DbSetOrder(1))
If MsSeek(xFilial("DAK")+cCodCarDes+cSeqCarDes)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Verifica se existe o campo e se esta bloqueada                     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If OsBlqExec(DAK->DAK_COD,DAK->DAK_SEQCAR) .Or. (DAK->(FieldPos('DAK_BLQCAR'))>0 .And. DAK->DAK_BLQCAR == '1')  //Bloqueada
		Help(" ",1,"OMS200CGBL") //Carga bloqueada ou com serviço em execução.
		lRet := .F.
	EndIf

	// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	// ³ Verifica se o Acerto de Cargas realizado ou j  iniciado                ³
	// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lRet
		If DAK->DAK_ACECAR == "1"
			Help(" ",1,"OMS320JAAC") //Carga já encerrada.
			lRet := .F.
		Else
			cStatDes := DAK->DAK_FEZNF
		EndIf
	EndIf
Else
	Help(" ",1,"DS2602131") //A carga informada nÆo existe.
	lRet := .F.
EndIf

If lRet
	Do Case
		Case DAK->DAK_COD == cCodCarOri .And. !Empty(cSeqCarOri) .And. DAK->DAK_SEQCAR == cSeqCarOri
			Help(" ",1,"DS2602134") //O código da carga selecionada é o mesmo da carga atual.
			lRet := .F.
		Case !Empty(DAK->DAK_JUNTOU) .And. DAK->DAK_JUNTOU != "JUNTOU" .And. DAK->DAK_JUNTOU != "MANUAL" .And. DAK->DAK_JUNTOU != "ASSOCI"
			Help(" ",1,"DS2602135") //A carga informada já foi agregada a outra e encontra-se indisponível.
			lRet := .F.
		Case cStatOri != cStatDes .And. GetMV("MV_ASSCARG") == "N"
			Help(" ",1,"DS2602136") //???
			lRet := .F.
		Case IntWms()
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Nao permite agutinar Cargas Unitizadas quando utilizar WMS         ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If DAK->DAK_FLGUNI == '1'
				Aviso('OMSA20004', STR0206, {'Ok'}) //"A Carga Destino ja foi Unitizada. A aglutinacao so sera permitida apos o estorno desta Unitizacao."
				lRet := .F.
			Else
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Nao permite aglutinar Cargas quando utilizar WMS e o Servico jah tiver sido executado ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				aAreaSC9 := SC9->(GetArea())
				SC9->(DbSetOrder(5)) //-- C9_FILIAL+C9_CARGA+C9_SEQCAR+C9_SEQENT
				If	SC9->(MsSeek(cSeekSC9:=xFilial('SC9')+DAK->DAK_COD+DAK->DAK_SEQCAR, .F.))
					Do While !SC9->(Eof())	.And. cSeekSC9 == SC9->C9_FILIAL+SC9->C9_CARGA+SC9->C9_SEQCAR
						If IntWms(SC9->C9_PRODUTO) .And. !Empty(SC9->C9_SERVIC) .And. (SC9->C9_STSERV $'23')
							Aviso('OMSA20005', STR0207, {'Ok'}) //"A Carga Destino possui um servico de WMS executado. A aglutinacao so sera permitida apos o estorno deste Servico."
							lRet := .F.
							Exit
						EndIf
						SC9->(DbSkip())
					EndDo
				EndIf
				SC9->(DbSetOrder(aAreaSc9[2]))
				SC9->(DbGoTo(aAreaSc9[3]))
			EndIf
	EndCase
EndIf

If lRet .And. SuperGetMV("MV_DEL_PVL")==1
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Nao permite agutinar Cargas quando TOP, parametro MV_DEL_PVL igual a 1 e ja faturado ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aAreaSC9 := SC9->(GetArea())
	SC9->(DbSetOrder(5)) //-- C9_FILIAL+C9_CARGA+C9_SEQCAR+C9_SEQENT
	If !(SC9->(MsSeek(xFilial('SC9')+DAK->DAK_COD+DAK->DAK_SEQCAR,.F.)))
		Aviso('SIGAOMS',STR0212, {'Ok'}) //"Não localizada a liberação do pedido de venda. A carga está faturada e a liberação excluída. A aglutinação não será permitida."###", {'Ok'})
		lRet := .F.
	EndIf
	SC9->(DbSetOrder(aAreaSc9[2]))
	SC9->(DbGoTo(aAreaSc9[3]))
EndIf

If lRet .And. lFreteEmb
	DbSelectArea("DAT")
	DAT->(DbSetOrder(1))
	If MsSeek(xFilial("DAT")+DAK->DAK_COD+DAK->DAK_SEQCAR)
		While DAT->(!Eof()) .And. DAT->DAT_FILIAL == xFilial("DAI") .And. ;
			DAT->DAT_COD == DAK->DAK_COD .And. ;
			DAT->DAT_SEQCAR == DAK->DAK_SEQCAR
			If !Empty(DAT->DAT_CODPAS) .Or. !Empty(DAT->DAT_VALPAS)
				lRet := .F.
				Exit
			EndIf
			DAT->(DbSkip())
		EndDo
	EndIf

	If lRet
		DbSelectArea("DAS")
		DAS->(DbSetOrder(1))
		If MsSeek(xFilial("DAS")+DAK->DAK_COD+DAK->DAK_SEQCAR)
			While DAS->(!Eof()) .And. DAS->DAS_FILIAL == xFilial("DAI") .And. ;
				DAS->DAS_COD == DAK->DAK_COD .And. ;
				DAS->DAS_SEQCAR == DAK->DAK_SEQCAR
				If	!Empty(DAS->DAS_VALFRE) .Or. !Empty(DAS->DAS_INSRET) .Or. !Empty(DAS->DAS_VALPDG) .Or. !Empty(DAS->DAS_ADIFRE) .Or. !Empty(DAS->DAS_FREAUT) .Or.;
					!Empty(DAS->DAS_TABFRE) .Or. !Empty(DAS->DAS_TIPTAB)
					lRet := .F.
					Exit
				EndIf
				DAS->(DbSkip())
			EndDo
		EndIf
	EndIf

	If !lRet
		Aviso('SIGAOMS', STR0248, {'Ok'})//"Esta Carga possui informações de Frete. A aglutinação só será permitida após o estorno destas informações."
	EndIf
EndIf

If lRet
	cRoteirDes := DAK->DAK_ROTEIR
	cCaminhDes := DAK->DAK_CAMINH
	cMotoriDes := DAK->DAK_MOTORI
	dDatCarDes := DAK->DAK_DATA
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Executa ponto de entrada para validacao                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lRet .And. ExistBlock("OM200VCG")
	lRet := ExecBlock("OM200VCG",.F.,.F.,{cCodCarDes,cSeqCarDes,cCodCarOri,cSeqCarOri})
EndIf
DbSetOrder(1)
DbSelectArea("DAK")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Restaura a entrada da rotina                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RestArea( aAreaDAK )
RestArea( aArea    )

Return( lRet )


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Oms200ePadºAutor  ³DL                  º Data ³  06/01/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Busca enredeco padrao para os itens                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6                                                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º20/02/2015³ Alterado propósito do parametro MV_WMSEOMS, agora quando   º±±
±±º          ³ "N" considera o endereço da SC9, mesmo que seja diferente  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function Oms200ePad(aArrayMan,cEndereco,lEndeWMS)
Local cBusca    := ""
Local lEndereco := .T.
Local lServico  := .F.
Local lRet      := .T.
Local cMens1    := ""
Local cMens2    := ""
Local cMens3    := ""
Local cMens4    := ""
Local cMens5    := ""
Local lProcessa := .T.
Local cEstrut   := ""
Local nC        := 0
Local aRetPE    := {}
Local lPergWMS  := .T.
Local lGeraWMS  := .F.
Local lEndWms   := .F.
Local lWmsEOms  := SuperGetMV("MV_WMSEOMS", .F., "S") == "S"
Local cArmazem  := SC9->C9_LOCAL
Local cProduto  := SC9->C9_PRODUTO
Local cPedido   := SC9->C9_PEDIDO

If	lProcessa
	If lWmsEOms
		//-- Pego o primeiro endereco de um determinado pedido da carga
		cBusca := aArrayMan[1,12]+aArrayMan[1,5]
		DbSelectArea("SC9")
		SC9->(DbSetOrder(1))
		If	MsSeek(cBusca)
			cArmazem  := SC9->C9_LOCAL
			cProduto  := SC9->C9_PRODUTO
			cPedido   := SC9->C9_PEDIDO
			cEndereco := SC9->C9_ENDPAD
			cEstrut   := Posicione("SBE",1, xFilial("SBE")+SC9->C9_LOCAL+cEndereco,"BE_ESTFIS")
			lServico  := !Empty(SC9->C9_SERVIC) .Or. lServico
		EndIf

		// Se parametro MV_WMSEOMS igual a "N" SEMPRE pergunta endereco destino do WMS.
		// Como padrão (sem o parametro ou com MV_WMSEOMS = "S")
		// pergunta o endereco destino se nos pedidos houver enderecos diferentes definidos.
		For nC := 1 to Len(aArrayMan)
			cBusca := aArrayMan[nC,12]+aArrayMan[nC,5]
			// Verifico se existem mais de um endereco entre os itens
			// dos pedidos, se existirem, trago o endereco em branco
			// como sugestao, caso contrario, trago o proprio endereco
			DbSelectArea("SC9")
			SC9->(DbSetOrder(1))
			If	MsSeek(cBusca)
				While !Eof() .And. C9_FILIAL+C9_PEDIDO == cBusca
					lServico := !Empty(SC9->C9_SERVIC) .Or. lServico
					If	cEndereco <> SC9->C9_ENDPAD
						lEndereco := .F.
						Exit
					EndIf
					DbSelectArea("SC9")
					DbSkip()
				EndDo
			EndIf
			If !lEndereco
				Exit
			EndIf
		Next nC
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Se existirem enderecos diferentes trago o get em branco³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !lEndereco
		cEndereco := Space(Len(SC9->C9_ENDPAD))
		cEstrut   := Space(Len(SBE->BE_ESTFIS))
		cMens1 := OemtoAnsi(STR0084)
		cMens2 := OemtoAnsi(STR0085)
		cMens3 := OemtoAnsi(STR0086)
		cMens4 := OemtoAnsi(STR0087)
	Else
		cMens1 := OemtoAnsi(STR0084) //"De acordo com a integracao com o modulo de WMS e necessario a escolha de um endereco  "
		cMens2 := OemtoAnsi(STR0088) //"de destino comum para os pedidos. Nesta montagem de carga foi constatado o que todos os "
		cMens3 := OemtoAnsi(STR0089) //"pedidos selecionados deverao seguir para o endereco abaixo mencionado. Caso necessite,"
		cMens4 := OemtoAnsi(STR0090) //"indique um novo endereco ou se permanecer em branco o mesmo sera novamente solicitado na"
		cMens5 := OemtoAnsi(STR0091) //"rotina de Mapa de Separacao."
	EndIf

	//-- Permite a informacao do Endereco e da Estrutura de Origem via Ponto de Entrada
	If	ExistBlock('OMSA200E')
		//-- Retorno esperado do RDMAKE
		aRetPE := ExecBlock("OMSA200E", Nil, Nil, {cProduto, cPedido})
		If	ValType(aRetPE)=="A" .And. Len(aRetPE) >= 2
			lPergWMS   := .F.
			cEndereco  := aRetPE[1]
		EndIf
	EndIf
	If	lServico .And. lPergWMS .And. (Type('l250Auto') == 'U' .Or. (Type('l250Auto') == 'L' .And. !l250Auto));
		.And. Empty(cEndereco)
		SC5->(DbSetOrder(1))
		For nC := 1 To Len(aArrayMan)
			If SC5->(MsSeek(xFilial("SC5")+aArrayMan[nC,5]))
				//Verifica se gera OS WMS na montagem da carga
				lGeraWMS := SC5->C5_GERAWMS == '2'
			EndIf
			If !lGeraWMS
				//Verifica se existe OS pendente de execução para o pedido
				lEndWms := WmsChkDCF('SC9',,,,"1,2",,aArrayMan[nC,5],,,,,,,,,,,'4')
			EndIf
			If lGeraWMS .Or. lEndWms
				Exit
			EndIf
		Next
		//Se gera serviço WMS na montagem da carga ou
		//existe OS pendente de execução (no caso de gerar serviço WMS no pedido)
		//deve perguntar endereço destino
		If lGeraWMS .Or. lEndWms
			//-- Pergunta destino Serviço WMS
			lEndeWMS := DLPergEnd(@cEndereco,,.F.,'2',cArmazem)
			//-- Verifica se exite alguma ordem de serviço executada
			If lEndeWMS
				For nC := 1 To Len(aArrayMan)
					If WmsChkDCF('SC9',,,,'3',,aArrayMan[nC,5],,,,,,,,,,,'4')
						Exit
					EndIf
				Next
			EndIf
		EndIf
	EndIf
EndIf

Return lRet

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Os200MotorºAutor  ³DL                  º Data ³  06/01/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Verifica o motorista informado na associacao               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function FB200Motor(cMotorista,cNomeMot)
Local aAreaSav  := GetArea()
Local aAreaDAK  := DAK->(GetArea())
Local lRet      := .T.
Local lRetPE    := .T.
Local cAliasDAN := "DAN"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Busca nome do motorista padrao³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DA4->(DbSetOrder(1))
If !Empty(cMotorista)
	If DA4->(MsSeek(xFilial("DA4")+cMotorista))
		cNomeMot := DA4->DA4_NOME
		oNomeMot:Refresh()
		//-- Verifica se o motorista funcionario nao esta demitido ou afastado.
		If DA4->DA4_BLQMOT = "1" //Sim
			Help(" ",1,"REGBLOQ")
			lRet := .F.
		EndIf
	Else
		Help(" ",1,"REGNOIS")
		lRet := .F.
	EndIf
	Pergunte("OMS200",.F.) //Parametro da Montagem de Cargas
	If	lRet .And. mv_par05 == 1
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Verifica se o motorista esta disponivel para carga                        ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		DAN->(DbSetOrder(1)) //DAN_FILIAL+DAN_CODVEI+DAN_CODCAR+DAN_SEQCAR
		cAliasDAN := GetNextAlias()
		BeginSql Alias cAliasDAN
			SELECT 1
			FROM %Table:DAN% DAN, %Table:DAK% DAK, %Table:DA3% DA3
			WHERE	DAN_FILIAL = %xFilial:DAN% AND
					DAN.%notdel% AND
					DAN_CODCAR <> %exp:DAK->DAK_COD% AND
					DAN_SEQCAR <> %exp:DAK->DAK_SEQCAR% AND
					DAK_FILIAL = %xFilial:DAK% AND
					DAN_CODCAR = DAK_COD    AND
					DAN_SEQCAR = DAK_SEQCAR AND
					DAK_MOTORI = %exp:cMotorista% AND
					DAK.%notdel% AND
					DA3_FILIAL = %xFilial:DA3% AND
					DAK_CAMINH = DA3_COD AND
					DA3_STATUS = '3' AND
					DA3.%notdel%
					ORDER BY %Order:DAN%
		EndSql
		DbSelectArea(cAliasDAN)
		lRet := Eof()
		DbCloseArea()
		If	!lRet
			Aviso('SIGAOMS',STR0249, {'Ok'}) //"Motorista nao esta disponivel"
		EndIf
	EndIf
	Pergunte("OMS20A",.F.) //Restaura Parametros da tela de Cargas
Else
	cNomeMot := " "
EndIf

	//--PE na validação do motorista.
	If lRet
		If ExistBlock("OM200MOT")
			lRetPE := ExecBlock("OM200MOT",.F.,.F.)
			lRet   := If(ValType(lRetPE)=="L", lRetPE, lRet)
		EndIf
	EndIf

RestArea( aAreaDAK )
RestArea( aAreaSav )

Return( lRet )

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Oms200Aju ºAutor  ³DL                  º Data ³  07/05/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Busca ajudante e traz seu respectivo nome                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP5                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function FBs200Aju(cAjuda,cDescAju,aAjuda)
Local aAreaSav  := GetArea()
Local aAreaDAK  := DAK->(GetArea())
Local lRet      := .T.
Local cAliasDAN := "DAN"

Default aAjuda  := {}

If !Empty(cAjuda)
	DAU->(DbSetOrder(1))
	If DAU->(MsSeek(xFilial("DAU")+cAjuda))
		cDescAju := DAU->DAU_NOME
	Else
		Help(" ",1,"REGNOIS")
		lRet := .F.
	EndIf
	If	lRet .And. !Empty(aAjuda)
		If	aScan(aAjuda,cAjuda)>0
			Aviso('SIGAOMS',STR0250, {'Ok'}) //"Codigo ajudante ja informado"
			lRet := .F.
		EndIf
	EndIf
	Pergunte("OMS200",.F.) //Parametro da Montagem de Cargas
	If	lRet .And. mv_par05 == 1
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Verifica se o Ajudante esta disponivel para carga                         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		DAN->(DbSetOrder(1))
		cAliasDAN := GetNextAlias()
		BeginSql Alias cAliasDAN
			SELECT 1
			FROM %Table:DAN% DAN, %Table:DAK% DAK, %Table:DA3% DA3
			WHERE	 DAN_FILIAL = %xFilial:DAN% AND
					 DAN.%notdel% AND
					 DAN_CODCAR <> %exp:DAK->DAK_COD% AND
					 DAN_SEQCAR <> %exp:DAK->DAK_SEQCAR% AND
					 DAK_FILIAL = %xFilial:DAK% AND
					 DAN_CODCAR = DAK_COD    AND
					 DAN_SEQCAR = DAK_SEQCAR AND
					(DAK_AJUDA1 = %exp:cAjuda%  OR
					 DAK_AJUDA2 = %exp:cAjuda%  OR
					 DAK_AJUDA3 = %exp:cAjuda%) AND
					 DAK.%notdel% AND
					 DA3_FILIAL = %xFilial:DA3% AND
					 DAK_CAMINH = DA3_COD AND
					 DA3_STATUS = '3' AND
					 DA3.%notdel%
					ORDER BY %Order:DAN%
		EndSql
		DbSelectArea(cAliasDAN)
		lRet := Eof()
		DbCloseArea()
		If	!lRet
			Aviso('SIGAOMS',STR0251,{'Ok'}) //"Ajudante nao esta disponivel"
		EndIf
	EndIf
	Pergunte("OMS20A",.F.) //Restaura Parametros da tela de Cargas
Else
	cDescAju:=" "
EndIf

RestArea( aAreaDAK )
RestArea( aAreaSav )

Return( lRet )

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³OmsVisGraph ºAutor  ³DL                  º Data ³  07/05/01 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Busca endereco padrao e traz a descricao                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³aExp1 : Array das cargas                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP5                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function FBsVisGraph(aArrayCarga,cMarca)

Local nPosCarga  := Ascan(aArrayCarga,{|x| x[CARGA_ENABLE] == .T.})
Local nPerKg     := 0
Local nPerM3     := 0
Local nPerPto    := 0
Local nX         := 0
Local nValor     := 0
Local cVeiculo   := ""
Local oGraph
Local aSize      := MsAdvSize( .F. )
Local aPosObj    := {}
Local aObjects   := {}
Local aColors    := {}
Local nColor     := 1
Local aSeries    := {}
Local nPosSerie  := 0
Local nTrbRec    := TRBPED->(Recno())
Local oFont
Local aCbx       := {OemtoAnsi(STR0103),OemtoAnsi(STR0104),OemtoAnsi(STR0105),OemtoAnsi(STR0106),OemtoAnsi(STR0107)}
Local nModelo    := 1
Local cCbx       := ""

AAdd( aColors ,CLR_HBLUE     )
AAdd( aColors ,CLR_HGREEN    )
AAdd( aColors ,CLR_HCYAN     )
AAdd( aColors ,CLR_HRED      )
AAdd( aColors ,CLR_HMAGENTA  )
AAdd( aColors ,CLR_YELLOW    )
AAdd( aColors ,CLR_WHITE     )
AAdd( aColors ,CLR_BLACK     )
AAdd( aColors ,CLR_BLUE      )
AAdd( aColors ,CLR_GREEN     )
AAdd( aColors ,CLR_CYAN      )
AAdd( aColors ,CLR_RED       )
AAdd( aColors ,CLR_MAGENTA   )
AAdd( aColors ,CLR_BROWN     )
AAdd( aColors ,CLR_HGRAY     )
AAdd( aColors ,CLR_LIGHTGRAY )
AAdd( aColors ,CLR_GRAY      )

DEFINE MSDIALOG oDlg TITLE OemtoAnsi(STR0101)  FROM 09,0 TO 20,40 OF oMainWnd  //Dados do Grafico

@ 000, 0 BITMAP oBmp RESNAME "PROJETOAP" OF oDlg SIZE 30, 1000 NOBORDER WHEN .F. PIXEL ADJUST
@ 014, 35 MSCOMBOBOX oCbx VAR cCbx ITEMS aCbx SIZE 115, 65 OF oDlg PIXEL ON CHANGE nModelo := oCbx:nAt
DEFINE SBUTTON oBut1 FROM 062, 120 TYPE 1 ACTION (nOpca := 1, oDlg:End())  ENABLE OF oDlg

ACTIVATE MSDIALOG oDlg CENTERED

aSize := MsAdvSize()
AAdd( aObjects ,{ 100 ,020 ,.T. ,.F. } )
AAdd( aObjects ,{ 100 ,100 ,.T. ,.T., .T. } )
AAdd( aObjects ,{ 100 ,15  ,.T. ,.F. } )

aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 5, 5 }
aPosObj := MsObjSize( aInfo, aObjects,.T.)

DEFINE FONT oFontLbl SIZE 10,0 BOLD
DEFINE MSDIALOG oDlg FROM aSize[7],00 TO aSize[6],aSize[5] TITLE OemtoAnsi(STR0102) OF oMainWnd PIXEL //Grafico de Disposicao da carga

If nPosCarga > 0
	cVeiculo := aArrayCarga[nPosCarga,CARGA_VEIC]
EndIf

Do Case
Case nModelo == 1
	@ 10,10 Say OemtoAnsi(STR0103) OF oDlg PIXEL FONT oFontLbl //"Disposicao em Peso na carga"
Case nModelo == 2
	@ 10,10 Say OemtoAnsi(STR0104) OF oDlg PIXEL FONT oFontLbl	//"Disposicao em Volume na carga"
Case nModelo == 3
	@ 10,10 Say OemtoAnsi(STR0105) OF oDlg PIXEL FONT oFontLbl	//"Disposicao em Valor  na carga"
Case nModelo == 4
	@ 10,10 Say OemtoAnsi(STR0106) OF oDlg PIXEL FONT oFontLbl	//"Ocupacao do Veiculo em Peso"
Case nModelo == 5
	@ 10,10 Say OemtoAnsi(STR0107) OF oDlg PIXEL FONT oFontLbl	//"Ocupacao do Veiculo em Volume"
EndCase

@ aPosObj[2,1], aPosObj[2,2] MSGRAPHIC oGraph SIZE aPosObj[2,3], aPosObj[2,4] OF oDlg
oGraph:SetMargins( 5, 5, 5, 5 )
oGraph:SetGradient( GDBOTTOMTOP, CLR_HGRAY, CLR_WHITE )
nSerie := oGraph:CreateSerie( 10 )


If	nModelo == 4 .Or. nModelo == 5

	If !Empty(cVeiculo)
		DA3->(DbSetOrder(1))
		If DA3->(MsSeek(xFilial("DA3")+cVeiculo))
			nPerM3 := Val(aArrayCarga[nPosCarga,CARGA_VOLUM])
			nPerKg := Val(aArrayCarga[nPosCarga,CARGA_PESO])
			oGraph:Add(nSerie,Iif(nModelo == 4,nPerKg,nPerM3) ,Iif(nModelo == 4,OemtoAnsi(STR0106),OemtoAnsi(STR0107)),aColors[ 1 ]) //"OCUPACAO EM KG"###"OCUPACAO EM VOLUME"
			oGraph:Add(nSerie,Iif(nModelo == 4,DA3->DA3_CAPACN-nPerKg ,DA3->DA3_VOLMAX-nPerM3) ,OemtoAnsi(STR0115),aColors[ 5 ]) //"LIVRE"		EndIf
		EndIf
	EndIf

Else

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Crio o acumulado por produto para passar par as series³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	DbSelectArea("TRBPED")
	DbGoTop()
	While !Eof()

		If TRBPED->PED_MARCA == cMarca
			nPosSerie := Ascan(aSeries,{ |x| x[1] == Iif(mv_par06 == 1,TRBPED->PED_PEDIDO, AllTrim(TRBPED->PED_CODPRO) + ' - '+ Alltrim(TRBPED->PED_DESPRO))})
			If 	nPosSerie == 0
				AAdd(aSeries,{Iif(mv_par06 == 1,TRBPED->PED_PEDIDO,AllTrim(TRBPED->PED_CODPRO) + ' - '+ Alltrim(TRBPED->PED_DESPRO)),TRBPED->PED_PESO,TRBPED->PED_VOLUM,TRBPED->PED_VALOR})
			Else
				aSeries[nPosSerie][2] += TRBPED->PED_PESO
				aSeries[nPosSerie][3] += TRBPED->PED_VOLUM
				aSeries[nPosSerie][4] += TRBPED->PED_VALOR
			EndIf
		EndIf

		DbSkip()

	EndDo

	For nX := 1 to Len(aSeries)
		nValor := Iif(nModelo == 1,aSeries[nX][2],Iif(nModelo == 2,aSeries[nX][3],Iif(nModelo == 3,aSeries[nX][4],aSeries[nX][2])))
		If	nValor > 0
			oGraph:Add(nSerie,nValor,aSeries[nX][1],aColors[ nColor ])
			nColor++
			If	nColor >= 18
				nColor := 1
			EndIf
		EndIf
	Next nX

EndIf

oGraph:l3D := .T.

DEFINE SBUTTON FROM aPosObj[3,1],(aSize[5]/2)-33 TYPE 1 ACTION oDlg:End() ENABLE

ACTIVATE MSDIALOG oDlg

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Volta a posicionar no registro corrente do arquivo de trabalho³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

DbSelectArea("TRBPED")
DbGoTo(nTrbRec)

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Oms200VlEndºAutor ³DL                  º Data ³  07/05/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Busca endereco padrao e traz a descricao                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP5                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function FBs200VlEnd(cLocaliza,cDescEnd)

Local lRet := .T.

cDescEnd := SBE->BE_DESCRIC

Return( lRet )

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Oms200Rot ºAutor  ³DL                  º Data ³  08/23/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Faz consistencia nas marcacoes na montagem da carga         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametro ³ExpA1 - Array das rotas                                     º±±
±±º          ³ExpA2 - Array das Zonas                                     º±±
±±º          ³ExpA3 - Array dos Setores                                   º±±
±±º          ³ExpC4 - Rota corrente                                       º±±
±±º          ³ExpC5 - Zona corrente                                       º±±
±±º          ³ExpC6 - Setor corrente                                      º±±
±±º          ³ExpC7 - Marca                                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function Oms200Rot(aArrayRota,aArrayZona,aArraySetor,cRotaPed,cZonaPed,cSetorPed,cMarca)
Local aAreaTRB  := TRBPED->(GetArea())
Local nX        := 0
Local lDesSetor := .T.
Local lDesZona  := .F.
Local lDesRota  := .F.

DbSelectArea("TRBPED")
TRBPED->(DbSetOrder(4)) //-- PED_ROTA+PED_ZONA+PED_SETOR+PED_FILORI+PED_PEDIDO
If TRBPED->(MsSeek(cRotaPed+cZonaPed+cSetorPed))
	//-- Pesquisa se existem Pedidos marcados para a Rota / Zona / Setor
	While TRBPED->(!Eof() .And. PED_ROTA+TRBPED->PED_ZONA+TRBPED->PED_SETOR == cRotaPed+cZonaPed+cSetorPed)
		If TRBPED->PED_MARCA == cMarca
			lDesSetor := .F.
			Exit
		EndIf
		TRBPED->(DbSkip())
	EndDo
EndIf
//-- Nao encontrou Pedidos marcados para a Rota / Zona / Setor
If	lDesSetor
	If	(nX:=aScan(aArraySetor,{|x|x[3]+x[4]+x[5] == cRotaPed+cZonaPed+cSetorPed .And. x[1] .And. x[2]}))>0
		aArraySetor[nX,2] := .F.
		lDesZona := .T.
	EndIf
	//-- Procura e desmarca Zona --//
	If	lDesZona
		If (nX:=aScan(aArraySetor,{|x|x[3]+x[4] == cRotaPed+cZonaPed .And. x[1] .And. x[2]}))==0
			If (nX:=aScan(aArrayZona,{|x|x[3]+x[4] == cRotaPed+cZonaPed .And. x[1] .And. x[2]}))>0
				aArrayZona[nX,2] := .F.
				lDesRota := .T.
			EndIf
		EndIf
		//-- Procura e desmarca Rota --//
		If	lDesRota
			If (nX:=aScan(aArrayZona,{|x|x[3] == cRotaPed .And. x[1] .And. x[2]}))==0
				If (nX:=aScan(aArrayRota,{|x|x[3] == cRotaPed .And. x[1] .And. x[2]}))>0
					aArrayRota[nX,2] := .F.
				EndIf
			EndIf
		EndIf
	EndIf
EndIf
RestArea( aAreaTRB )

If !l200Auto
	oCargas:Refresh()
	oRotas:Refresh()
	oZonas:Refresh()
	oSetores:Refresh()
	oMark:oBrowse:Refresh()
Endif

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Funcao   ³D200VlCg2   ³Autor  ³ DL                  ³ Data ³ 02/07/1999 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Nome Orig.³ DFATA215                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o³ Valida a carga de destino selecionada                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ DFATA214                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function FB00VlCg2()
Local lRet     := .T.
Local aAreaSav := GetArea()
Local aAreaDAK := DAK->(GetArea())
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Valida no cadastro de cargas o codigo de carga informado     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DbSelectArea("DAK")
DAK->(DbSetOrder(1))
DAK->(MsSeek(xFilial("DAK")+M->DAI_COD))

If DAK->(Eof())
	Help(" ",1,"DS2602131") //A carga informada nÆo existe.
	lRet := .F.
ElseIf DAK->DAK_DATA <> M->DAK_DATA
	Help(" ",1,"DS2602132") //A data da carga informada difere da data da carga selecionada.
	lRet := .F.
ElseIf !Empty(DAK->DAK_JUNTOU) .And. DAK->DAK_JUNTOU != "JUNTOU" .And. DAK->DAK_JUNTOU != "MANUAL" .And. DAK->DAK_JUNTOU != "ASSOCI"
	Help(" ",1,"DS2602135") //A carga informada já foi agregada a outra e encontra-se indisponível.
	lRet := .F.
ElseIf GetMV("MV_MANCARG") == "N" .And. DAK->DAK_FEZNF == "1"
	//-- MV_MANCARG = S -> Permitir a Manipulacao ou Associacao de Pedidos a Cargas com faturamento ja iniciado (Especifico Distribuidores).
	Help(" ",1,"OMS200CFAT") //Esta carga já se encontra faturada.
	lRet := .F.
ElseIf DAK->DAK_ACECAR == "1"
	//-- Verifico se o Acerto de Cargas realizado ou j  iniciado (DAN)
	Help(" ",1,"DS2412133") //A carga selecionada nÆo pode sofrer alteraçÆo, pois já esta em fase de Acerto de Cargas.
	lRet := .F.
EndIf

//-- Reposiciona o registro original e retorna o resultado da val.
RestArea(aAreaDAK)
RestArea(aAreaSav)
Return( lRet )


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Funcao   ³Oms200PMot³ Autor ³ Octavio Moreira       ³ Data ³ 22/07/1999 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descricao³ Chamada do Processamento.                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ DFATA431                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function Oms200PMot(cCarga,cSeqCar,cVeiculo,cMotorista,cAjuda1,cAjuda2,cAjuda3,cVeiAnt,cCodOper,cNoProc,cPedComOp,cDakTransp)
Local aCargas   := {{cCarga,cSeqCar}}
Local aArea     := GetArea()
Local aAreaDAK  := DAK->(GetArea())
Local aAreaDAI  := DAI->(GetArea())
Local aAreaSF2  := SF2->(GetArea())
Local oTempTable:= ""
Local cPrxSeq   := ""
Local lAlocVei  := SuperGetMv("MV_ALOCVEI",.F.,.T.)
Local lOs200Mot := ExistBlock("OS200MOT")
Local lFreteEmb := .F.
Local lContVei  := GetMV("MV_CONTVEI",,.F.) // Parametro para verificar se o sistema devera' controlar veiculo/motorista
Local cCpoCapac := IIf(SuperGetmv("MV_OMSCAPA",.F.,"1")=="1","DA3_CAPACN","DA3_CAPACM")
Local nCapac    := 0
Local aRotas    := {}
Local cSeekSC9  := {}

Default cVeiAnt   := ""
Default cCodOper  := ""
Default cNoProc   := ""
Default cPedComOp := ""
Default cDakTransp:= Criavar("A4_COD",.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Regrava a carga atual com o codigo da carga de destino       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DbSelectArea("DA3")
DA3->(DbSetOrder(1))
If	DA3->(MsSeek(xFilial("DA3")+cVeiculo))
	nCapac := DA3->(FieldGet(FieldPos(cCpoCapac)))
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Retira o empenho do veiculo anterior ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If	lAlocVei .And. (cVeiAnt <> cVeiculo .And. !Empty(cVeiAnt))
		OsVAgenda(cCarga,cSeqCar,cVeiAnt,2)
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Pergunta a quebra de carga caso a carga ainda nao tenha sido faturada³
	//³e nao caiba no caminhao selecionado                                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Pergunte("OMS200", .F.)
	If ((DAK->DAK_PESO > nCapac) .Or. (DAK->DAK_CAPVOL > DA3->DA3_VOLMAX)) .And. DAK->DAK_FEZNF == "2" .And. MV_PAR05 == 1
		If	MsgYesNo(OemtoAnsi(STR0126)) //"Caminhao nao suporta a carga selecionada. Deseja dividir a carga em outra sequencia para que esta seja alocada em outro veiculo ?"

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Processa a diferenca de itens para a quebra de carga     ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			Processa({ ||Oms210Unt(aCargas,cVeiculo,@oTempTable,1,1,DA3->DA3_CAPACN,DA3->DA3_VOLMAX,.T.,.T.) })

			If	Select("TRB") > 0
				cPrxSeq := OsSeqCar(aCargas[1][1])
				DbSelectArea("TRB")
				DbGoTop()
				While !(Eof())

					SC9->(MsGoto(TRB->TRB_RECNO))

					//-- Exclui o item do SC9 da carga atual
					MaAvalSC9("SC9",8,,,,,,aRotas)

					Reclock("SC9",.F.)
					SC9->C9_CARGA  := aCargas[1][1]
					SC9->C9_SEQCAR := cPrxSeq
					SC9->C9_SEQENT := OsSeqEnt(SC9->C9_CARGA,SC9->C9_SEQCAR,SC9->C9_PEDIDO)
					MsUnlock()

					//-- Inclui o item do SC9 na nova carga
					MaAvalSC9("SC9",7,,,,,,aRotas)

					DbSelectArea("TRB")
					DbSkip()
				EndDo
				oTempTable:Delete()
			EndIf

		EndIf
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Empenha o veiculo                                                    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If	lAlocVei
		OsVAgenda(cCarga,cSeqCar,cVeiculo,1)
	EndIf

EndIf


DbSelectArea("DAK")
DAK->(DbSetOrder(1))
If DAK->(MsSeek(xFilial("DAK")+cCarga+cSeqCar))
	If lFreteEmb .And. lContVei
		If DAK->DAK_CAMINH != cVeiculo .And. !Empty(DAK->DAK_CAMINH)
			//-- Altera Status de Veiculo para Liberado
			aAltStaDTU("3",DAK->DAK_CAMINH,,,'2',DAK->DAK_IDENT)
		EndIf
		If DAK->DAK_MOTORI != cMotorista .And. !Empty(DAK->DAK_MOTORI)
			//-- Altera Status de Motorista para Liberado
			aAltStaDTO("3",DAK->DAK_MOTORI,,,'2',DAK->DAK_IDENT)
		EndIf
		//-- Altera Status de Veiculo para Reservado
		If DAK->DAK_CAMINH != cVeiculo   .And. !Empty(cVeiculo)
			aAltStaDTU("2",cVeiculo,,,'2',DAK->DAK_IDENT)
		EndIf
		If DAK->DAK_MOTORI != cMotorista .And. !Empty(cMotorista)
			//-- Altera Status de Motorista para Reservado
			aAltStaDTO("2",cMotorista,,,'2',DAK->DAK_IDENT)
		EndIf
	EndIf

	RecLock("DAK",.F.)
	DAK->DAK_CAMINH := cVeiculo
	DAK->DAK_MOTORI := cMotorista
	DAK->DAK_AJUDA1 := cAjuda1
	DAK->DAK_AJUDA2 := cAjuda2
	DAK->DAK_AJUDA3 := cAjuda3
	MsUnLock()

	SX1->( DbSetOrder( 1 ) )
	If SX1->(DBSeek( PadR("OMS200C",Len(SX1->X1_GRUPO),' ')+"01"))
		Pergunte("OMS200C",.F.)
		If mv_par01 == 1
			SC5->(DbSetOrder(1))
			SC9->(DbSetOrder(5))
			If SC9->(MsSeek(cSeekSC9 := xFilial('SC9')+DAK->DAK_COD+DAK->DAK_SEQCAR))
				While SC9->( !Eof() .And. SC9->C9_FILIAL+SC9->C9_CARGA+SC9->C9_SEQCAR == cSeekSC9 )
					If	SC5->(MsSeek(xFilial("SC5")+SC9->C9_PEDIDO))
						RecLock('SC5',.F.)
						SC5->C5_VEICULO := cVeiculo
						MsUnlock()
					EndIf
					SC9->(DBSkip())
				EndDo
			EndIf
		EndIf
	EndIf
	
	If	SF2->(FieldPos("F2_VEICUL1")) > 0 .And. DAI->(FieldPos("DAI_NFISCA")) > 0 .And. DAI->(FieldPos("DAI_SERIE")) > 0
		SF2->(DbSetOrder(1)) //F2_FILIAL+F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA+F2_FORMUL
		DAI->(DbSetOrder(1)) //DAI_FILIAL+DAI_COD+DAI_SEQCAR+DAI_SEQUEN+DAI_PEDIDO
		If	DAI->(DbSeek(xFilial("DAI")+DAK->DAK_COD+DAK->DAK_SEQCAR))
			While DAI->(!EOF() .And. DAI_FILIAL+DAI_COD+DAI_SEQCAR==xFilial("DAI")+DAK->DAK_COD+DAK->DAK_SEQCAR)
				If	SF2->(DbSeek(xFilial("SF2")+DAI->DAI_NFISCA+DAI->DAI_SERIE) .And. F2_VEICUL1 <> cVeiculo)
					RecLock("SF2",.F.)
					SF2->F2_VEICUL1 := cVeiculo
					MsUnlock()
				EndIf
				DAI->(DbSkip())
			EndDo
		EndIf
	EndIf
EndIf

If	lOs200Mot
	ExecBlock("OS200MOT",.F.,.F.)
EndIf

RestArea( aAreaSF2 )
RestArea( aAreaDAK )
RestArea( aAreaDAI )
RestArea( aArea    )

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³OmsPesqPed³ Autor ³ DL                    ³ Data ³08.08.2001 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³Pesquisa registro em um arquivo temporario                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpA1 : Array com a estrutura do TRB                         ³±±
±±³          ³ExpA2 : Array com os dados de exibicao do TRB                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Esta rotina tem como objetivo cancelar as movimentacoes      ³±±
±±³          ³feitas do cliente                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ APDL                                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function FBsPesqPed(cAliasTRB,aCampos,aCpoBrw)

Local aCpoLbl  := {}
Local aCpo     := {}

Local cCpoLbl  := ""
Local cCpo     := ""
Local xPesq    := Space(20)

Local nX       := 0
Local nTipo    := 1
Local nOpca    := 0
Local nRegTRB  := TRBPED->(Recno())

Local oDlg

For nX := 1 to Len(aCpoBrw)
	If !Empty(aCpoBrw[nX][3])
		AAdd(aCpoLbl,aCpoBrw[nX][3])
		AAdd(aCpo,aCpoBrw[nX][1])
	EndIf
Next nX

DEFINE MSDIALOG oDlg TITLE OemtoAnsi(STR0117)  FROM 09,0 TO 20,50 OF oMainWnd

@ 000, 0 BITMAP oBmp RESNAME "PROJETOAP" OF oDlg SIZE 30, 1000 NOBORDER WHEN .F. PIXEL ADJUST


@ 014,035 SAY OemtoAnsi(STR0118) OF oDlg PIXEL
@ 014,075 MSCOMBOBOX oCpo VAR cCpoLbl ITEMS aCpoLbl SIZE 55, 65 OF oDlg PIXEL ON CHANGE (nTipo := oCpo:nAt,OmsChgPict(nTipo,aCampos,aCpo,@xPesq,oPesq,@cCpo))

@ 028,035 SAY OemtoAnsi(STR0119) OF oDlg PIXEL
@ 028,075 MSGET oPesq VAR xPesq Picture "@!" SIZE 113, 10 OF oDlg PIXEL

DEFINE SBUTTON oBut1 FROM 062, 130 TYPE 1 ACTION ( nOpca := 1, oDlg:End() ) ENABLE OF oDlg
DEFINE SBUTTON oBut1 FROM 062, 160 TYPE 2 ACTION ( nOpca := 0, oDlg:End() ) ENABLE OF oDlg

ACTIVATE MSDIALOG oDlg CENTERED ON INIT OmsChgPict(nTipo, aCampos, aCpo, @xPesq, oPesq, @cCpo)

If nOpca == 1
	DbSelectArea(cAliasTRB)
	DbGoTop()

	While !Eof() .And. FieldGet(FieldPos(cCpo)) != xPesq
		(cAliasTRB)->(DbSkip())
	EndDo

	If (cAliasTRB)->(Eof())
		(cAliasTRB)->(MsGoto(nRegTRB))
	EndIf

	oMark:oBrowse:SetFocus()

EndIf

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³OmsChgPict³ Autor ³ DL                    ³ Data ³08.08.2001 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³Tratamento da pesquisa de arquivos temporarios               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpN1 : Posicao do campo no Array                            ³±±
±±³          ³ExpA2 : Array com a estrutura do arquivo                     ³±±
±±³          ³ExpA3 : Array com os campos e labels do arquivo              ³±±
±±³          ³ExpX4 : Variavel de pesquisa                                 ³±±
±±³          ³ExpN5 : Objeto da variavel de pesquisa                       ³±±
±±³          ³ExpC6 : Nome do campo por referencia para ser pesquisado     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Esta rotina tem como objetivo tratar a pesquisa a ser reali  ³±±
±±³          ³zada no arquivo temporario                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ APDL                                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function OmsChgPict(nTipo,aCampos,aCpo,xPesq,oPesq,cCpo)

Local nPosCpo := 0
Local cPict   := ""

nPosCpo := Ascan(aCampos,{|x| x[1] == Alltrim(aCpo[nTipo])})

If nPosCpo > 0

	cCpo  := aCampos[nPosCpo][1]

	Do Case
	Case aCampos[nPosCpo][2] == "N"
		xPesq := 0
		cPict := "@E 99,999,999.99"
	Case aCampos[nPosCpo][2] == "D"
		xPesq := dDataBase
		cPict := "@D"
	Case aCampos[nPosCpo][2] == "C"
		xPesq := Space(aCampos[nPosCpo][3])
		cPict := Replicate("!",aCampos[nPosCpo][3])
	EndCase
EndIf

oPesq:oGet:Picture := cPict
oPesq:Refresh()

Return


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³Oms200Lock³ Autor ³ DL                    ³ Data ³12.04.2002 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³Lock do registro do pedido                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpC1 - Filial de origem do pedido                           ³±±
±±³          ³ExpC2 - Pedido                                               ³±±
±±³          ³ExpA3 - Array par armezenamento dos pedidos                  ³±±
±±³          ³ExpL4 - .T. Marca o pedido / .F. Desmarca                    ³±±
±±³          ³ExpC5 - Marca da MsSelect                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpL1 - .T. Sucesso no Lock ou no Unlock                     ³±±
±±³          ³        .F. Nao realizou o lock ou Unlock                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Esta rotina tem como objetivo bloquear os registros dos pe-  ³±±
±±³          ³didos marcados no browse de cargas                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ APDL                                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function Oms200Lock(cFilOri,cPedido,aLock,lMarca,cMarca, nEscolha)

Local lRet     := .T.
Local lLock    := .T.
Local lLockSC5 := SuperGetMv("MV_CGLOCK",.F.,.F.)
Local aArea    := GetArea()
Local aAreaSC5 := SC5->(GetArea())
Local nRecTRB  := TRBPED->(Recno())
Local nPosPed  := 0

Default nEscolha := 0

If lLockSC5
	nPosPed := Ascan(aLock,{|x| x[1]+x[2] == cFilOri+cPedido})

	If lMarca
		If nPosPed  == 0
			DbSelectArea("SC5")
			SC5->(DbSetOrder(1))
			If MsSeek(cFilOri+cPedido)
				If SC5->(!MsRLock())
	    			 If AllTrim(Str(nEscolha)) = '4'
	    			 	 Help(' ', 1,'OMS200BLDC',, +" "+ STR0265,5,18)//-- Documento já está sendo usado por outra estação.
	    			 	 aVisErr := {}
	    			 Else
	    			 	 AaddMsgErr( {{STR0265 +  " "  + STR0028 + ": " + cPedido }}, @aVisErr)
	    			 EndIf
	    			 lRet := .F.
				ElseIf SoftLock("SC5")
					AAdd(aLock,{cFilOri,cPedido})
				EndIf
			EndIf
		EndIf
	Else
		If nPosPed > 0
			TRBPED->(DbSetOrder(1))
			If TRBPED->(MsSeek(cFilori+cPedido))
				While TRBPED->(!Eof()) .And. ( TRBPED->PED_FILORI+TRBPED->PED_PEDIDO == cFilOri+cPedido )
					If nRecTRB != TRBPED->(Recno())
						If TRBPED->PED_MARCA == cMarca
							lLock := .F.
						EndIf
					EndIf
					TRBPED->(DbSkip())
				EndDo
			EndIf

			If lLock
				DbSelectArea("SC5")
				SC5->(DbSetOrder(1))
				If MsSeek(cFilOri+cPedido)
					MsUnlock()
					aDel(aLock,nPosPed)
					aSize(aLock,Len(aLock)-1)
				EndIf
			EndIf
		EndIf
	EndIf

	TRBPED->(MsGoto(nRecTrb))

	If lRet
		SC9->(DbSetOrder(1))
		If SC9->(MsSeek(TRBPED->PED_FILORI+TRBPED->PED_PEDIDO+TRBPED->PED_ITEM+TRBPED->PED_SEQLIB)) .And. !Empty(SC9->C9_CARGA)
			lRet:= .F.
		EndIf
	EndIf

Else
	lRet := .T.
EndIf

RestArea( aAreaSC5 )
RestArea( aArea    )

Return( lRet )

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³Oms200Time³ Autor ³ DL                    ³ Data ³12.04.2002 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³Calcula hora de chegada no cliente                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³ExpC1 - Hora de inicio                                       ³±±
±±³          ³ExpD2 - Data de inicio                                       ³±±
±±³Parametros³ExpA3 - Array com os dados dos contendo e nao importando a   ³±±
±±³          ³        ordem pois a posicao sera passada nos outros parame- ³±±
±±³          ³        tros da funcao.                                      ³±±
±±³          ³      [1]-Filial                                             ³±±
±±³          ³      [2]-Rota                                               ³±±
±±³          ³      [3]-Zona                                               ³±±
±±³          ³      [4]-Setor                                              ³±±
±±³          ³      [5]-Cliente                                            ³±±
±±³          ³      [6]-Loja                                               ³±±
±±³          ³      [7]-Peso                                               ³±±
±±³          ³      [8]-Volume                                             ³±±
±±³          ³      [9]-Hora (a ser retornado pela funcao)                 ³±±
±±³          ³      [10]-Time Service (a ser retornado pela funcao)        ³±±
±±³          ³ExpC4 - Veiculo                                              ³±±
±±³          ³ExpN5 - Posicao da Filial de origem no array                 ³±±
±±³          ³ExpN6 - Posicao do cliente no array                          ³±±
±±³          ³ExpN7 - Posicao da Loja no array                             ³±±
±±³          ³ExpN8 - Posicao da Rota no Array                             ³±±
±±³          ³ExpN9 - Posicao da Zona no array                             ³±±
±±³          ³ExpN10 - Posicao do Setor no array                           ³±±
±±³          ³ExpN11 - Posicao da Peso no array                            ³±±
±±³          ³ExpN12-  Posicao do Volume no array                          ³±±
±±³          ³ExpN13 - Posicao da Hora no array  (retorno)                 ³±±
±±³          ³ExpN14 - Posicao do Time Service   (retorno)                 ³±±
±±³          ³ExpN15 - Posicao do retorno da janela (.T. ou .F.)           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpL1 - .T. Sucesso no Lock ou no Unlock                     ³±±
±±³          ³        .F. Nao realizou o lock ou Unlock                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Esta rotina tem como objetivo bloquear os registros dos pe-  ³±±
±±³          ³didos marcados no browse de cargas                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ APDL                                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function FBs200Time(cHrStart,dDtStart,aTime,cVeiculo,nPosFil,nPosCli,nPosLoja,nPosRota,nPosZona,nPosSetor,nPosPeso,nPosVol,nPosHora,nPosTime,nPosJan,nPosDtC,nPosDtS)

Local aRotas    := {}
Local cFilSA1   := ""
Local cRotaAnt  := ""
Local cZonaAnt  := ""
Local cSetorAnt := ""
Local cCliAnt   := ""
Local cLojaAnt  := ""
Local dDataIni  := dDtStart
Local nX        := 0
Local nTempo    := 0
Local nSetor    := 0
Local nZona     := 0
Local nRota     := 0
Local nIntHora  := 0
Local lNew      := .F.
Local lNSrvTime := .T.
Local lRet      := .T.
Local cTimSrv   := SuperGetMv("MV_CTIMSRV",.F.,"1")

DEFAULT nPosFil   := 1
DEFAULT nPosCli   := 2
DEFAULT nPosLoja  := 3
DEFAULT nPosRota  := 4
DEFAULT nPosZona  := 5
DEFAULT nPosSetor := 6
DEFAULT nPosPeso  := 7
DEFAULT nPosVol   := 8
DEFAULT nPosHora  := 9
DEFAULT nPosTime  := 10
DEFAULT nPosJan   := 0
DEFAULT cHrStart  := SuperGetMv("MV_CGSTART",.F.,"08:00")
DEFAULT dDtStart  := dDatabase

If Empty(cHrStart)
	cHrStart:="08:00"
EndIf

If l200Auto
	aArrayCarga := aClone(xArrCarga)
EndIf

If Len(aTime) > 0
	SA1->(DbSetOrder(1))
	cRotaAnt  := aTime[1][nPosRota]
	cZonaAnt  := aTime[1][nPosZona]
	cSetorAnt := aTime[1][nPosSetor]
	cCliAnt   := aTime[1][nPosCli]
	cLojaAnt  := aTime[1][nPosLoja]

	For nX := 1 to Len(aTime)

		nTempo := 0
		lNew   := .F.
		cFilSA1 := Iif(nPosFil == 0, xFilial("SA1"),OsFilial("SA1",aTime[nX][nPosFil]))
		SA1->(MsSeek(cFilSA1+aTime[nX][nPosCli]+aTime[nX][nPosLoja]))
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Inclui no array caso seja a primeira vez³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If Len(aRotas) == 0
			DA8->(DbSetOrder(1)) //DA8_FILIAL+DA8_COD
			If DA8->(MsSeek(xFilial("DA8")+aTime[nX][nPosRota]))
				nTempo += HoratoInt(DA8->DA8_TEMPO,4)
				AAdd(aRotas,{aTime[nX][nPosRota],aTime[nX][nPosZona],aTime[nX][nPosSetor],aTime[nX][nPosCli],aTime[nX][nPosLoja] })
			EndIf
		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Busca se existe troca de cliente no setor               ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nSetor := Ascan(aRotas,{|x| x[3] == aTime[nX][nPosSetor]})
		If nSetor > 0
			lNew := ( Ascan(aRotas,{|x| x[3]+x[4]+x[5] == aTime[nX][nPosSetor]+aTime[nX][nPosCli]+aTime[nX][nPosLoja] } ) == 0 )
			If lNew .Or. cSetorAnt+cCliAnt+cLojaAnt <> aTime[nX][nPosSetor]+aTime[nX][nPosCli]+aTime[nX][nPosLoja]
				DA6->(DbSetOrder(1)) //DA6_FILIAL+DA6_PERCUR+DA6_ROTA
				If DA6->(MsSeek(xFilial("DA6")+aTime[nX][nPosZona]+aTime[nX][nPosSetor]))
					nTempo += HoratoInt(DA6->DA6_TEMPO,4)
					If lNew
						AAdd(aRotas,{aTime[nX][nPosRota],aTime[nX][nPosZona],aTime[nX][nPosSetor],aTime[nX][nPosCli],aTime[nX][nPosLoja] })
					EndIf
				EndIf
			EndIf
		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Busca se existe troca de Setores nas zonas              ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nZona := Ascan(aRotas,{|x| x[2] == aTime[nX][nPosZona]})
		If nZona > 0
			lNew := ( Ascan(aRotas,{|x| x[2]+x[3] == aTime[nX][nPosZona]+aTime[nX][nPosSetor]}) == 0 )
			If lNew .Or. cZonaAnt+cSetorAnt <> aTime[nX][nPosZona]+aTime[nX][nPosSetor]
				DA5->(DbSetOrder(1)) //DA5_FILIAL+DA5_COD
				If DA5->(MsSeek(xFilial("DA5")+aTime[nX][nPosZona]))
					nTempo := HoratoInt(DA5->DA5_TEMPO,4)
					If lNew
						AAdd(aRotas,{aTime[nX][nPosRota],aTime[nX][nPosZona],aTime[nX][nPosSetor],aTime[nX][nPosCli],aTime[nX][nPosLoja] })
					EndIf
				EndIf
			EndIf
		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Busca se existe troca de zonas e setores na rota        ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nRota := Ascan(aRotas,{|x| x[1] == aTime[nX][nPosRota]})
		If nRota > 0
			lNew := ( Ascan(aRotas,{|x| x[1]+x[2]+x[3] == aTime[nX][nPosRota]+aTime[nX][nPosZona]+aTime[nX][nPosSetor]}) == 0 )
			If lNew .Or. cRotaAnt+cZonaAnt+cSetorAnt <> aTime[nX][nPosRota]+aTime[nX][nPosZona]+aTime[nX][nPosSetor]
				DA8->(DbSetOrder(1)) //DA8_FILIAL+DA8_COD
				If DA8->(MsSeek(xFilial("DA8")+aTime[nX][nPosRota]))
					nTempo += HoratoInt(DA8->DA8_TEMPO,4)
					If lNew
						AAdd(aRotas,{aTime[nX][nPosRota],aTime[nX][nPosZona],aTime[nX][nPosSetor],aTime[nX][nPosCli],aTime[nX][nPosLoja] })
					EndIf
				EndIf
			EndIf
		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Calcula hora de parada                                ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		aTime[nX][nPosDtC]  := dDataIni
		If nTempo > 0
			SomaDiaHor(@aTime[nX][nPosDtC],@cHrStart,nTempo)
		EndIf
		aTime[nX][nPosDtS]  := aTime[nX][nPosDtC]
		aTime[nX][nPosHora] := cHrStart
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Calcula time service                                  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If cTimSrv == "2" // Considera somente uma vez o TIME SERVICE para o mesmo cliente/loja do Pedido.
			If lNSrvTime .Or. cCliAnt+cLojaAnt <> aTime[nX][nPosCli]+aTime[nX][nPosLoja]
				aTime[nX][nPosTime] := OmsSrvTime(SA1->A1_GRPVEN,aTime[nX][nPosCli],aTime[nX][nPosLoja],aTime[nX][nPosPeso],aTime[nX][nPosVol])
				lNSrvTime := .F.
			Else
				aTime[nX][nPosTime] := "0000:00"
			EndIf
		Else // Considera o TIME SERVICE para o mesmo cliente/loja do Pedido.
			aTime[nX][nPosTime] := OmsSrvTime(SA1->A1_GRPVEN,aTime[nX][nPosCli],aTime[nX][nPosLoja],aTime[nX][nPosPeso],aTime[nX][nPosVol])
		EndIf

		If nPosJan <> 0
			aTime[nX][nPosJan] := OmsJanEntr(SA1->A1_GRPVEN,aTime[nX][nPosCli],aTime[nX][nPosLoja],aTime[nX][nPosHora],cVeiculo,aTime[nX][nPosDtC])
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Se houve aluguma restricao devolve .F. para verificacao   ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If aTime[nX][nPosJan] <> 1
				lRet := .F.
			EndIf
		EndIf
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Calcula proxima hora de parada incluindo time service ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nTempo := HoraToInt(aTime[nX][nPosTime],4)
		If nTempo > 0
			SomaDiaHor(@aTime[nX][nPosDtS],@cHrStart,nTempo)
		EndIf
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Atribui os Valores                                                ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dDataIni  := aTime[nX][nPosDtS]
		cRotaAnt  := aTime[nx][nPosRota]
		cZonaAnt  := aTime[nx][nPosZona]
		cSetorAnt := aTime[nx][nPosSetor]
		cCliAnt   := aTime[nx][nPosCli]
		cLojaAnt  := aTime[nx][nPosLoja]
	Next nX
EndIf

Return( lRet )

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³Oms200Seq ³ Autor ³ DL                    ³ Data ³12.04.2002 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³Reordena e recalcula horas no acols na manutencao de carga   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpL1 - .T.                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Esta rotina tem como objetivo ordenar o acols de acordo com  ³±±
±±³          ³o digitado para recalculo das horas de entrega               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ APDL                                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function FBs200Seq()

Local nPosSeq  := Ascan( aHeader ,{|x| Alltrim(x[2]) == "DAI_SEQUEN"} )
Local nPosFil  := Ascan( aHeader ,{|x| Alltrim(x[2]) == "DAI_FILPV"}  )
Local nPosCli  := Ascan( aHeader ,{|x| Alltrim(x[2]) == "DAI_CLIENT"} )
Local nPosLoja := Ascan( aHeader ,{|x| Alltrim(x[2]) == "DAI_LOJA"}   )
Local nPosRota := Ascan( aHeader ,{|x| Alltrim(x[2]) == "DAI_ROTEIR"} )
Local nPosZona := Ascan( aHeader ,{|x| Alltrim(x[2]) == "DAI_PERCUR"} )
Local nPosSetor:= Ascan( aHeader ,{|x| Alltrim(x[2]) == "DAI_ROTA"}   )
Local nPosPeso := Ascan( aHeader ,{|x| Alltrim(x[2]) == "DAI_PESO"}   )
Local nPosVol  := Ascan( aHeader ,{|x| Alltrim(x[2]) == "DAI_CAPVOL"} )
Local nPosHora := Ascan( aHeader ,{|x| Alltrim(x[2]) == "DAI_CHEGAD"} )
Local nPosTime := Ascan( aHeader ,{|x| Alltrim(x[2]) == "DAI_TMSERV"} )


aCols[n][nPosSeq] := M->DAI_SEQUEN
aCols := aSort(aCols,,,{|x,y| x[nPosSeq] < y[nPosSeq] })

FBs200Time(DAK->DAK_HRSTAR,DAK->DAK_DATA,aCols,nPosFil,nPosCli,nPosLoja,nPosRota,nPosZona,nPosSetor,nPosPeso,nPosVol,nPosHora,nPosTime)

oGetD:oBrowse:Refresh()

Return( .T. )


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³Os200CfgGnt³ Autor ³ Edson Maricate       ³ Data ³ 09-02-2001 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Exibe uma tela com as configuracoes de visualizacao do Gantt  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³Generico                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function FB200CfgGnt(cVersao,oDlg,aConfig,dIni,aGantt)
Local lRet      := .F.
Local aConfigBk := aClone(aConfig)
lRet := ParamBox({{3,	OemtoAnsi(STR0156),aConfig[1],{; //"Escala de tempo"
						OemtoAnsi(STR0157),; //"Diario"
						OemtoAnsi(STR0158),; //"Semanal"
						OemtoAnsi(STR0159),; //"Mensal"
						OemtoAnsi(STR0160),; //"Mensal (Zoom 30%)"
						OemtoAnsi(STR0161),; //"Bimestral"
						OemtoAnsi(STR0162)},60,,.F.}},; //"Melhor escala"
						OemtoAnsi(STR0163),aConfig,,,.F.,120,3) //"Configuracoes"
aConfigBk[1] := aConfig[1]
aConfig := aClone(aConfigBk)
Return( lRet )

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³Os200Visual³ Autor ³ DL                   ³ Data ³ 02/07/99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Visualizacao da carga pelo Gantt                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico APDL                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function FB200Visual(cAlias,nRec,nOpc)

Local aArea    := Getarea()
Local aAreaDAK := DAK->(GetArea())

DAK->(MsGoto(nRec))

OmsVisCg(cAlias,nRec,2)

RestArea( aAreaDAK )
RestArea( aArea    )

Return


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³Oms200EndOri³ Autor ³ DL                  ³ Data ³06.12.2004 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³Retorna o endereco padrao da carga                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpC1 - Cargal de origem do pedido                           ³±±
±±³          ³ExpC2 - Sequencia                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpC1 - Endereco padrao da carga                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Esta rotina tem como objetivo retornar o endereco padrao de  ³±±
±±³          ³uma determinada carga                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ APDL                                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function FB200EndOri(cCarga,cSeqCar)
Local aArea     := GetArea()
Local aAreaDAI  := DAI->(GetArea())
Local cFilPv    := ""
Local nTpVlEnt  := OsVlEntCom()
Local cEndereco := ""

DbSelectArea("DAI")
DAI->(DbSetOrder(1))
If	MsSeek(xFilial("DAI")+cCarga+cSeqCar)
	cFilPv := IIf(nTpVlEnt<>1,DAI->DAI_FILPV,xFilial("SC9"))
	DbSelectArea("SC9")
	SC9->(DbSetOrder(5)) //C9_FILIAL+C9_CARGA+C9_SEQCAR+C9_SEQENT
	If	MsSeek(OsFilial("SC9",cFilPv)+DAI->DAI_COD+DAI->DAI_SEQCAR+DAI->DAI_SEQUEN)
		cEndereco := SC9->C9_ENDPAD
	EndIf
EndIf

RestArea( aAreaDAI )
RestArea( aArea    )

Return( cEndereco )

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³Os200SeqMn   ³ Autor ³ DL                 ³ Data ³13/09/2005 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³Os200SeqMn(ExpN1)                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpN1 -> Array com os recnos da tabela DAI associados ao     ³±±
±±³          ³acols                                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ .T.                                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Altera a sequencia de carga a partir da rotina de manutencao ³±±
±±³          ³de carga                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ OMSA200                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function Os200SeqMn(aRecnoDAI,cHrStart,dDtStart)
Local aArea       := GetArea()
Local aArrayCarga := {}
Local aArrayMan   := {}

Local cCodCli     := ""
Local cLoja       := ""

Local nPosSequen  := GdFieldPos( "DAI_SEQUEN" )
Local nPosRota    := GdFieldPos( "DAI_ROTEIR" )
Local nPosZona    := GdFieldPos( "DAI_PERCUR" )
Local nPosSetor   := GdFieldPos( "DAI_ROTA"   )
Local nPosPedido  := GdFieldPos( "DAI_PEDIDO" )
Local nPosCodCli  := GdFieldPos( "DAI_CLIENT" )
Local nPosLoja    := GdFieldPos( "DAI_LOJA"   )
Local nPosPeso    := GdFieldPos( "DAI_PESO"   )
Local nPosVolume  := GdFieldPos( "DAI_CAPVOL" )
Local nPosTmServ  := GdFieldPos( "DAI_TMSERV" )
Local nPosChgPrev := GdFieldPos( "DAI_CHEGAD" )
Local nPosCarga   := GdFieldPos( "DAI_COD" )
Local nPosDtCheg  := GdFieldPos( "DAI_DTCHEG" )
Local nPosDtSaid  := GdFieldPos( "DAI_DTSAID" )
Local nPosData    := GdFieldPos( "DAI_DATA" )
Local nPosHora    := GdFieldPos( "DAI_HORA" )
Local nPosValFre  := GdFieldPos( "DAI_VALFRE" )
Local nPosFreAut  := GdFieldPos( "DAI_FREAUT" )
Local cPictVal    := "99999999." + Replicate("9",TamSx3("DAK_VALOR")[2])
Local cPictVol    := "99999999." + Replicate("9",TamSx3("DAK_CAPVOL")[2])
Local cPictPeso   := "99999999." + Replicate("9",TamSx3("DAK_PESO")[2])
Local cPictQtde   := "99999999." + Replicate("9",TamSx3("C9_QTDLIB")[2])

Local nLoop       := 0
Local lFreteEmb := .F.
Local nTpVlEnt  := OsVlEntCom()
Local cFilPV      := ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Constroi o aArraycarga                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
AAdd( aArrayCarga, Array(22) )

aArrayCarga[1,CARGA_ENABLE] := .T.
aArrayCarga[1,CARGA_COD]    := M->DAK_COD
aArrayCarga[1,CARGA_DESC]   := OemtoAnsi(STR0040) + M->DAK_COD //"CARGA "
aArrayCarga[1,CARGA_PESO]   := TransForm( M->DAK_PESO  , PesqPict("DAK", "DAK_PESO"  ) )
aArrayCarga[1,CARGA_VALOR]  := TransForm( M->DAK_VALOR , PesqPict("DAK", "DAK_VALOR" ) )
aArrayCarga[1,CARGA_VOLUM]  := TransForm( M->DAK_CAPVOL, PesqPict("DAK", "DAK_CAPVOL") )
aArrayCarga[1,CARGA_PTOENT] := StrZero( M->DAK_PTOENT,6)
aArrayCarga[1,CARGA_VEIC]   := M->DAK_CAMINH
aArrayCarga[1,CARGA_MOTOR]  := M->DAK_MOTORI
aArrayCarga[1,CARGA_AJUD1]  := M->DAK_AJUDA1
aArrayCarga[1,CARGA_AJUD2]  := M->DAK_AJUDA2
aArrayCarga[1,CARGA_AJUD3]  := M->DAK_AJUDA3
If lFreteEmb
//	aArrayCarga[1,CARGA_PESCIF] := TransForm( M->DAK_PESO  , PesqPict("DAK", "DAK_PESO") )
//	aArrayCarga[1,CARGA_QTDCIF] := TransForm( M->DAK_PESO  , PesqPict("DAK", "DAK_PESO") )
//	aArrayCarga[1,CARGA_VOLCIF] := TransForm( M->DAK_VALOR , PesqPict("DAK", "DAK_VALOR") )
//	aArrayCarga[1,CARGA_VALCIF] := TransForm( M->DAK_CAPVOL, PesqPict("DAK", "DAK_CAPVOL") )
//	aArrayCarga[1,CARGA_PESFOB] := TransForm( M->DAK_PESO  , PesqPict("DAK", "DAK_PESO"  ) )
//	aArrayCarga[1,CARGA_QTDFOB] := TransForm( M->DAK_PESO  , PesqPict("DAK", "DAK_PESO") )
//	aArrayCarga[1,CARGA_VOLFOB] := TransForm( M->DAK_VALOR , PesqPict("DAK", "DAK_VALOR" ) )
//	aArrayCarga[1,CARGA_VALFOB] := TransForm( M->DAK_CAPVOL, PesqPict("DAK", "DAK_CAPVOL") )
	aArrayCarga[nPosCarga,CARGA_PESCIF] := Transform(M->DAK_PESO,cPictPeso)
	aArrayCarga[nPosCarga,CARGA_VALCIF] := Transform(M->DAK_VALOR,cPictVal)
	aArrayCarga[nPosCarga,CARGA_VOLCIF] := Transform(M->DAK_CAPVOL,cPictVol)
//	aArrayCarga[nPosCarga,CARGA_QTDCIF] := Transform(  ,cPictQtde)
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Pesquisa o pedido de vendas                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

For nLoop := 1 to Len( aCols )

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Considera apenas os nao deletados e que nao tiveram o numero da carga alterado ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !aCols[ nLoop, Len( aHeader ) + 1 ] .And. aCols[ nLoop, nPosCarga ] == M->DAK_COD

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Posiciona no DAI referente ao ACOLS                                 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		DAI->( DbGoTo( aRecnoDAI[ nLoop ] ) )

		AAdd( aArrayMan, Array( 26 ) )

		nTam := Len( aArrayMan )

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Obtem os dados preferencialmente do ACOLS                           ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		aArrayMan[ nTam, 1 ] := If( Empty( nPosSequen ), DAI->DAI_SEQUEN, aCols[ nLoop,nPosSequen ] )
		aArrayMan[ nTam, 2 ] := If( Empty( nPosRota   ), DAI->DAI_ROTEIR, aCols[ nLoop,nPosRota   ] )
		aArrayMan[ nTam, 3 ] := If( Empty( nPosZona   ), DAI->DAI_PERCUR, aCols[ nLoop,nPosZona   ] )
		aArrayMan[ nTam, 4 ] := If( Empty( nPosSetor  ), DAI->DAI_ROTA  , aCols[ nLoop,nPosSetor  ] )
		aArrayMan[ nTam, 5 ] := If( Empty( nPosPedido ), DAI->DAI_PEDIDO, aCols[ nLoop,nPosPedido ] )

		cFilPv := IIf(nTpVlEnt<>1,DAI->DAI_FILPV,xFilial("SC5"))

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Pesquisa o pedido de vendas                                      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		SC5->(DbSetOrder(1))
		SC5->(DbSeek(cFilPv+aCols[nLoop,nPosPedido]))

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica se e cliente ou cliente de entrega                      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !Empty( SC5->C5_CLIENT ) .And. !Empty( SC5->C5_LOJAENT )
			cCodCli := SC5->C5_CLIENT
			cLoja   := SC5->C5_LOJAENT
		Else
			cCodCli := SC5->C5_CLIENTE
			cLoja   := SC5->C5_LOJACLI
		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica se e cliente ou fornecedor                              ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If SC5->C5_TIPO $ "DB"

			SA2->(DbSetOrder(1))
			If SA2->(MsSeek(xFilial("SA2")+cCodCli+cLoja))
				aArrayMan[ nTam, 6  ] := SA2->A2_COD
				aArrayMan[ nTam, 7  ] := SA2->A2_LOJA
				aArrayMan[ nTam, 8  ] := SA2->A2_NOME
				aArrayMan[ nTam, 9  ] := SA2->A2_BAIRRO
				aArrayMan[ nTam, 10 ] := SA2->A2_MUN
				aArrayMan[ nTam, 11 ] := SA2->A2_EST
				If lFreteEmb
					aArrayMan[ nTam, 21 ] := ""
				EndIf
			EndIf

		Else

			SA1->(DbSetOrder(1))
			If SA1->(MsSeek(xFilial("SA1")+cCodCli+cLoja))
				aArrayMan[ nTam, 6  ] := SA1->A1_COD
				aArrayMan[ nTam, 7  ] := SA1->A1_LOJA
				aArrayMan[ nTam, 8  ] := SA1->A1_NOME
				aArrayMan[ nTam, 9  ] := SA1->A1_BAIRRO
				aArrayMan[ nTam, 10 ] := SA1->A1_MUN
				aArrayMan[ nTam, 11 ] := SA1->A1_EST
				If lFreteEmb
					aArrayMan[ nTam, 21 ] := SA1->A1_CDRDES
				EndIf
			EndIf

		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Pesquisa a liberacao do pedido para localizar as filiais de origem  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		SC9->(DbSetOrder(5))
		SC9->(DbSeek(xFilial("SC9")+DAI->DAI_COD+DAI->DAI_SEQCAR+DAI->DAI_SEQUEN))

		aArrayMan[ nTam, 12 ] := SC9->C9_FILIAL
		aArrayMan[ nTam, 13 ] := OsFilial("SA1",SC9->C9_FILIAL)
		aArrayMan[ nTam, 14 ] := If( Empty( nPosPeso    ), DAI->DAI_PESO  , aCols[ nLoop,nPosPeso   ] )
		aArrayMan[ nTam, 15 ] := If( Empty( nPosVolume  ), DAI->DAI_CAPVOL, aCols[ nLoop,nPosVolume ] )
		aArrayMan[ nTam, 16 ] := If( Empty( nPosChgPrev ), DAI->DAI_CHEGAD, aCols[ nLoop,nPosChgPrev] )
		aArrayMan[ nTam, 17 ] := If( Empty( nPosTmServ  ), DAI->DAI_TMSERV, aCols[ nLoop,nPosTmServ ] )
		aArrayMan[ nTam, 19 ] := If( Empty( nPosDtCheg  ), DAI->DAI_DTCHEG, aCols[ nLoop,nPosDtCheg ] )
		aArrayMan[ nTam, 20 ] := If( Empty( nPosDtSaid  ), DAI->DAI_DTSAID, aCols[ nLoop,nPosDtSaid ] )

		If lFreteEmb
			aArrayMan[ nTam, 23 ] := If( Empty( nPosValFre  ), DAI->DAI_VALFRE, aCols[ nLoop,nPosValFre ] )
			aArrayMan[ nTam, 24 ] := If( Empty( nPosFreAut  ), DAI->DAI_FREAUT, aCols[ nLoop,nPosFreAut ] )
		EndIf

	EndIf

Next nLoop

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Ordena o aArrayMan por sequencia de entrega                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ASort( aArrayMan, , , { |x,y| y[1] > x[1] } )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Dispara a manipulacao da sequencia de entrega                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Os200VisCg(@aArrayCarga,@aArrayMan,@cHrStart,@dDtStart)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Aplica as alteracoes ao aCols                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

For nLoop := 1 to Len( aArrayMan )

	If !Empty( nLinha := AScan( aCols, { |x| x[nPosPedido] == aArrayMan[ nLoop, 5 ] .And. ;
		x[nPosLoja] == aArrayMan[ nLoop, 7 ] } ) )

		aCols[ nLinha, nPosSequen ] := aArrayMan[nLoop,1 ]
		aCols[ nLinha, nPosTmServ ] := aArrayMan[nLoop,17]
		aCols[ nLinha, nPosChgPrev] := aArrayMan[nLoop,16]

		If !Empty( nPosDtCheg )
			aCols[ nLinha, nPosDtCheg ] := aArrayMan[nLoop,19]
		EndIf

		If !Empty( nPosDtSaid )
			aCols[ nLinha, nPosDtSaid ] := aArrayMan[nLoop,20]
		EndIf

		If !Empty( nPosData )
			aCols[ nLinha, nPosData   ] := dDtStart
		EndIf

		If !Empty( nPosHora )
			aCols[ nLinha, nPosHora   ] := cHrStart
		EndIf

	EndIf

Next nLoop

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Aplica as alteracoes no cabecalho                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
M->DAK_DATA   := dDtStart
M->DAK_HORA   := cHrStart
M->DAK_HRSTAR := cHrStart

RestArea( aArea )

Return( Nil )

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ Os200TOk    ³ Autor ³ DL                 ³ Data ³17/11/2005 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Os200TOk()                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ .T.                                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Validacao na manutenção da carga.                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ OMSA200                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function FB200TOk()
Local lRet   := .T.
Local lRetPE := .T.
Local nAnt   := n
Local nX     := 0
//verifica se tentativa de excluir o pedido da carga, com servico de WMS jah executado
For nX:= 1 to Len(aCols)
	n:= nX // atualizando a variavel n da getdados.
	lRet := FB200DCF()
	If ! lRet
		Exit
	EndIf
Next nX
n:= nAnt
//--PE na validação da manutenção da carga.
If lRet .And. ExistBlock("OS200TOK")
	lRetPE := ExecBlock("OS200TOK",.F.,.F.)
	lRet   := If(ValType(lRetPE)=="L", lRetPE, lRet)
EndIf

Return( lRet )

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ Os200LOk    ³ Autor ³ Flavio Luiz Vicco  ³ Data ³21/11/2005 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ .T.                                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Validacao da linha na manutenção da carga.                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ OMSA200                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function FB200LOk()
Local lRet := .T.

//verifica se tentativa de excluir o pedido da carga, com servico de WMS jah executado
lRet := FB200DCF()

Return( lRet )

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ Os200DCF    ³ Autor ³ Alex Egydio        ³ Data ³31/10/2007 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ So permite retirar o item da carga se NAO houver o.s.wms    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function FB200DCF()
Local lRet := .T.
//-- So permite retirar o item da carga se NAO houver ordem de servico do WMS executada
If GDDeleted( n )
	lRet := WmsAvalDAK(GdFieldGet('DAI_COD',n),GdFieldGet('DAI_SEQCAR',n),GdFieldGet('DAI_SEQUEN',n),GdFieldGet('DAI_PEDIDO',n))
EndIf

Return( lRet )

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³OsA200Refr³ Autor ³Eduardo Riera          ³ Data ³02.01.2006  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Rotina de interface da Montagem de Carga                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpC1: Alias do Arquivo                                       ³±±
±±³          ³ExpN2: Numero do Registro                                     ³±±
±±³          ³ExpN3: Opcao do aRotina                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Materiais/Distribuicao/Logistica                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Atualizacoes sofridas desde a Construcao Inicial.                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Programador  ³ Data   ³ BOPS ³  Motivo da Alteracao                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function FBA200Refr(aCampos,cCarga,aArrayCarga,aArrayRota,aArrayZona,aArraySetor,aArrayMod,aArrayTipo,aObjetos,nSaveSx8,aArrayMan,aArrayFrt,aArrayMan,aObjPed,cDakTransp,cDAKTpOp,cDAKClFr)
Local oTempTable
Local oProcess
Local oEnable   := LoadBitmap( GetResources(), "ENABLE" )
Local oDisable  := LoadBitmap( GetResources(), "DISABLE" )
Local oNoMarked := LoadBitmap( GetResources(), "LBNO" )
Local oMarked   := LoadBitmap( GetResources(), "LBOK" )
Local aBack     := {aArrayCarga,aArrayRota,aArrayZona,aArraySetor,aArrayMod,aArrayTipo,aArrayFrt,aArrayMan}
Local nX        := 0
Local lHasOpen  := .F.

cDakTransp := Criavar("A4_COD",.F.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Traz janelas de perguntas e filtro para a montagem                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For nX := 1 to Len(aArrayCarga)
	If aArrayCarga[nX,CARGA_ENABLE]
		lHasOpen := .T.
	EndIf
Next nX
If !lHasOpen
	OmsAbreCarga(@oEnable,@oDisable,@oMarked,@oNoMarked,@aArrayCarga,@nSaveSx8)
EndIf
For nX := 1 to Len(aArrayCarga)
	If aArrayCarga[nX,CARGA_ENABLE]
		cCarga := aArrayCarga[nX,CARGA_COD]
	EndIf
Next nX
aArrayCarga := {}
aArrayRota  := {}
aArrayZona  := {}
aArraySetor := {}
aArrayMod   := {}
aArrayTipo  := {}
aArrayMan   := {}
aArrayCli 	:= {}
aArrayFrt   := Array(9)

If	OmsFilTipo(@oMarked,@oNoMarked,aArrayMod,aArrayTipo)
	For nX := 1 To Len(aObjetos)
		aObjetos[nX]:nAt := 1
	Next nX
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Filtra pedidos e monta o mapa de cargas                                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If IsBlind()
		lEnd := OmsBuscaPed(@oEnable,@oDisable,@oMarked,@oNoMarked,@aCampos,cCarga,aArrayCarga,aArrayRota,aArrayZona,aArraySetor,aArrayMod,aArrayTipo,oProcess,oTempTable)
	Else
		oProcess := MsNewProcess():New({|lEnd| OmsBuscaPed(@oEnable,;
															@oDisable,;
															@oMarked,;
															@oNoMarked,;
															@aCampos,;
															cCarga,;
															aArrayCarga,;
															aArrayRota,;
															aArrayZona,;
															aArraySetor,;
															aArrayMod,;
															aArrayTipo,;
															oProcess,oTempTable)},"","",.F.)
		oProcess:Activate()
	Endif
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Atualiza os objetos                                                    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aObjetos[1]:SetArray(aArrayCarga)
	aObjetos[1]:bLine := { ||{Iif(aArrayCarga[oCargas:nAT,CARGA_ENABLE],oEnable,oDisable),;
		aArrayCarga[oCargas:nAT,CARGA_COD],;
		aArrayCarga[oCargas:nAT,CARGA_DESC],;
		aArrayCarga[oCargas:nAT,CARGA_PESO],;
		aArrayCarga[oCargas:nAT,CARGA_VALOR],;
		aArrayCarga[oCargas:nAT,CARGA_VOLUM],;
		aArrayCarga[oCargas:nAT,CARGA_QTDLIB],;
		aArrayCarga[oCargas:nAT,CARGA_PTOENT],;
		aArrayCarga[oCargas:nAT,CARGA_TRANSP],;
		aArrayCarga[oCargas:nAT,CARGA_VEIC],;
		aArrayCarga[oCargas:nAT,CARGA_MOTOR],;
		aArrayCarga[oCargas:nAT,CARGA_AJUD1],;
		aArrayCarga[oCargas:nAT,CARGA_AJUD2],;
		aArrayCarga[oCargas:nAT,CARGA_AJUD3],;
		aArrayCarga[oCargas:nAT,CARGA_PESCIF],;
		aArrayCarga[oCargas:nAT,CARGA_QTDCIF],;
		aArrayCarga[oCargas:nAT,CARGA_VOLCIF],;
		aArrayCarga[oCargas:nAT,CARGA_VALCIF],;
		aArrayCarga[oCargas:nAT,CARGA_PESFOB],;
		aArrayCarga[oCargas:nAT,CARGA_QTDFOB],;
		aArrayCarga[oCargas:nAT,CARGA_VOLFOB],;
		aArrayCarga[oCargas:nAT,CARGA_VALFOB],;
		aArrayCarga[oCargas:nAT,CARGA_TPOP],;
		aArrayCarga[oCargas:nAT,CARGA_CLFR]}}		
	//-- Ponto de entrada para adicionar campos na opcao Sequencia de Entrega.
	If	ExistBlock("OM200AD2")
		aRetCarga := ExecBlock("OM200AD2",.F.,.F.,{aObjetos[1], aObjetos[1]:aArray, aObjetos[1]:aHeaders, aObjetos[1]:bLine, oEnable, oDisable})
		If	ValType(aRetCarga[1]) == "A" .And. ValType(aRetCarga[2]) == "A" .And. ValType(aRetCarga[3]) == "B"
			aArrayCarga			:= aRetCarga[1]
			aObjetos[1]:bLine	:= aRetCarga[3]
		EndIf
	EndIf
	aObjetos[1]:nAt := 1
	aObjetos[1]:Refresh()

	aObjetos[2]:SetArray(aArrayRota)
	aObjetos[2]:bLine:={ ||{Iif(aArrayRota[oRotas:nAT,1],oEnable,oDisable),;
		Iif(aArrayRota[oRotas:nAT,2],oMarked,oNoMarked),;
		aArrayRota[oRotas:nAT,3],;
		aArrayRota[oRotas:nAT,4],;
		aArrayRota[oRotas:nAt,5]}}
	aObjetos[2]:nAt := 1
	aObjetos[2]:Refresh()

	aObjetos[3]:SetArray(aArrayZona)
	aObjetos[3]:bLine:={ ||{Iif(aArrayZona[oZonas:nAT,1],oEnable,oDisable),;
		Iif(aArrayZona[oZonas:nAT,2],oMarked,oNoMarked),;
		aArrayZona[oZonas:nAT,3],;
		aArrayZona[oZonas:nAT,4],;
		aArrayZona[oZonas:nAT,5],;
		aArrayZona[oZonas:nAT,6]}}
	aObjetos[3]:nAt := 1
	aObjetos[3]:Refresh()

	aObjetos[4]:SetArray(aArraySetor)
	aObjetos[4]:bLine:={ ||{IIf(aArraySetor[oSetores:nAT,1],oEnable,oDisable),;
		Iif(aArraySetor[oSetores:nAT,2],oMarked,oNoMarked),;
		aArraySetor[oSetores:nAT,3],;
		aArraySetor[oSetores:nAT,4],;
		aArraySetor[oSetores:nAT,5],;
		aArraySetor[oSetores:nAT,6],;
		aArraySetor[oSetores:nAT,7]}}
	aObjetos[4]:nAt := 1
	aObjetos[4]:Refresh()

	aObjPed[1]:lVisibleControl := (mv_par06 == 2)
	aObjPed[1]:Refresh()

	DbSelectArea("TRBPED")
	DbGoTop()
	If	SuperGetMv("MV_OMSREFR",.F.,.F.)
		//-- Parametro para definir se botao Refresh devera gerar um nova carga.
		aArrayCarga:= aBack[1]
		aArrayFrt  := aBack[7]
		aArrayMan  := aBack[8]
	EndIf
Else
	aArrayCarga := aBack[1]
	aArrayRota  := aBack[2]
	aArrayZona  := aBack[3]
	aArraySetor := aBack[4]
	aArrayMod   := aBack[5]
	aArrayTipo  := aBack[6]
	aArrayFrt   := aBack[7]
	aArrayMan   := aBack[8]
EndIf

Return( .T. )

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³Os200DivSC9³ Autor ³Eduardo Riera         ³ Data ³03.02.2006  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Rotina quebra da quantidade do SC9.                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpC1: Alias com os itens do pedido de venda                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Materiais/Distribuicao/Logistica                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Atualizacoes sofridas desde a Construcao Inicial.                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Programador  ³ Data   ³ BOPS ³  Motivo da Alteracao                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function FB200DivSC9(cAliasTrb,aArrayFrt,aArrayMan,aFretReg,cMarca,nRecSC9,oObjMrk)
Local aArea      := GetArea()
Local aAreaSC5   := SC5->(GetArea())
Local aAreaSC6   := SC6->(GetArea())
Local aAreaSC9   := SC9->(GetArea())
Local aAreaSA1   := SA1->(GetArea())
Local aAreaSA2   := SA2->(GetArea())
Local aAreaSB1   := SB1->(GetArea())
Local aAreaTRB   := (cAliasTRB)->(GetArea())
Local aSaldos    := {}
Local aOldSC6    := Array(6)
Local aCopySC9   := {}
Local aCopySDC   := {}
Local nX         := 0
Local nQtdNew    := 0
Local nDif       := 0
Local nOpcA      := 0
Local nRetPE 	 := 0
Local nPesoProd  := 0
Local nPesoNew   := 0
Local nVolNew    := 0
Local nBaixa     := 0
Local nQuant     := 0
Local cCompSDC   := ""
Local cSeekSDC   := ""
Local cPedido    := ""
Local cItem      := ""
Local cCarga     := ""
Local cQrSC9     := ""
Local cOMSFilial := ""
Local cSequen    := ""
Local cProduto   := ""
Local cProdDesc  := ""
Local cBlWMS     := ""
Local cLiberOk   := ""
Local cBlock     := ""
Local bBlock     := {||.T.}
Local cCpoPeso   := IIf(SuperGetMV("MV_PESOCAR") == "L","B1_PESO","B1_PESBRU")
Local lSC9       := .F.
Local lFreteEmb  := .F.
Local oDlg
Local lOMS200DIV := ExistBlock("OMS200DIV")
Local lOM200SC9  := ExistBlock("OM200SC9")
Local lProcessa  := .T.
Local cIdDCF     := ""
Local cStServ    := ""
Local cBlqWms    := ""
Local lEstLib    := SuperGetMV("MV_OMSESTP",.F.,.T.) //Indica se estorna liberacao do pedido de vendas de uma carga ao dividir um item. Onde .T. (default) efetua o estorno.
Local bCampo := { |nCPO| SC9->(Field(nCPO))}

Default cAliasTRB := "SC9"
Default aArrayFrt := Array(9)
Default aFretReg  := {}
Default cMarca    := ""
Default nRecSC9   := 0
Private lbloqDCF  := .F. //Controla se exclui a OS no estorno da liberação

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Pesquisa o registro no SC9                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
lSC9 := cAliasTRB=="SC9"
If lSC9 .Or. (cAliasTRB)->(FieldPos("PED_CODPRO"))>0
	If lSC9
		If nRecSC9 > 0
			DbSelectArea("SC9")
			SC9->(MsGoto(nRecSC9))
		EndIf
		cPedido    := SC9->C9_PEDIDO
		cItem      := SC9->C9_ITEM
		cOMSFilial := SC9->C9_FILIAL
		cSequen    := SC9->C9_SEQUEN
		cProduto   := SC9->C9_PRODUTO
		cBlWMS     := SC9->C9_BLWMS
	Else
		cPedido    := (cAliasTRB)->PED_PEDIDO
		cItem      := (cAliasTRB)->PED_ITEM
		cCarga     := (cAliasTRB)->PED_CARGA
		cOMSFilial := (cAliasTRB)->PED_FILORI
		cSequen    := (cAliasTRB)->PED_SEQLIB
		cProduto   := (cAliasTRB)->PED_CODPRO
	EndIf
	DbSelectArea("SC9")
	SC9->(DbSetOrder(1))
	If	SC9->(MsSeek(OsFilial("SC9",cOMSFilial)+cPedido+cItem+cSequen+cProduto) .And. SoftLock("SC9"))
		DbSelectArea("SB1")
		SB1->(DbSetOrder(1))
		SB1->(MsSeek(xFilial("SB1") + SC9->C9_PRODUTO))

		DbSelectArea("SC5")
		SC5->(DbSetOrder(1))
		SC5->(MsSeek(OsFilial("SC5",cOMSFilial)+cPedido))

		DbSelectArea("SC6")
		SC6->(DbSetOrder(1))
		SC6->(MsSeek(OsFilial("SC6",cOMSFilial)+cPedido+cItem))

		If SC5->C5_TIPO$"BD"
			DbSelectArea("SA2")
			SA2->(DbSetOrder(1))
			SA2->(MsSeek(OsFilial("SA2",cOMSFilial)+SC5->C5_CLIENTE+SC5->C5_LOJACLI))
		Else
			DbSelectArea("SA1")
			SA1->(DbSetOrder(1))
			SA1->(MsSeek(OsFilial("SA1",cOMSFilial)+SC5->C5_CLIENTE+SC5->C5_LOJACLI))
		EndIf

		If !lSC9
			nQtdNew := SC9->C9_QTDLIB
			nVolNew := (cAliasTRB)->PED_VOLUM
			nPesoNew:= (cAliasTRB)->PED_PESO
		EndIf

		//-- Ponto de Entrada que permite sugerir quantidade para quebra
		If lOMS200DIV
			nRetPE := ExecBlock("OMS200DIV",.F.,.F.)
			If	ValType(nRetPE) == "N"
				nQtdNew := nRetPE
			EndIf
		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Montagem da tela para exibicao                                         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		DEFINE MSDIALOG oDlg FROM  158,001 TO 450,600 TITLE STR0211 PIXEL //"Divisão dos itens de pedido de venda liberado"
		@ 005,011 TO 045,295 LABEL "" OF oDlg  PIXEL
		@ 048,144 TO 144,295 LABEL "" OF oDlg  PIXEL
		@ 048,011 TO 087,138 LABEL "" OF oDlg  PIXEL

		@ 012,015 SAY RetTitle("C9_PEDIDO")			SIZE 23,7 OF oDlg PIXEL
		@ 012,044 SAY SC9->C9_PEDIDO				SIZE 26,7 OF oDlg PIXEL
		@ 012,149 SAY RetTitle("C9_ITEM")			SIZE 23,7 OF oDlg PIXEL
		@ 012,190 SAY SC9->C9_ITEM					SIZE 26,7 OF oDlg PIXEL
		//--
		@ 023,015 SAY RetTitle("C5_CLIENTE")		SIZE 23,7 OF oDlg PIXEL
		@ 023,044 SAY IIf(SC5->C5_TIPO$"BD",Substr(SA2->A2_NOME,1,35),Substr(SA1->A1_NOME,1,35))	SIZE 114,7 OF oDlg PIXEL
		//--
		cProdDesc := Substr(AllTrim(SB1->B1_COD)+" - "+SB1->B1_DESC,1,60)
		@ 034,015 SAY RetTitle("C6_PRODUTO")	SIZE 25,7 OF oDlg PIXEL
		@ 034,044 SAY cProdDesc					SIZE 90,7 OF oDlg PIXEL
		@ 034,149 SAY RetTitle("C6_LOCAL")		SIZE 27,7 OF oDlg PIXEL
		@ 034,190 SAY SC9->C9_LOCAL				SIZE 15,7 OF oDlg PIXEL
		//--
		@ 056,016 SAY RetTitle("C6_LOTECTL")	SIZE 38,7 OF oDlg PIXEL
		@ 056,072 SAY SC9->C9_LOTECTL			SIZE 27,7 OF oDlg PIXEL
		//--
		@ 067,016 SAY RetTitle("C6_NUMLOTE")	SIZE 37,7 OF oDlg PIXEL
		@ 067,072 SAY SC9->C9_NUMLOTE			SIZE 23,7 OF oDlg PIXEL
		//--
		@ 056,151 SAY RetTitle("C9_QTDLIB")		SIZE 53,7 OF oDlg PIXEL
		@ 056,203 GET oGet3 VAR SC9->C9_QTDLIB	PICTURE PesqPictQt("C6_QTDVEN",14) SIZE 53,7 OF oDlg PIXEL
		oGet3:lReadOnly := .T.
		@ 067,151 SAY OemtoAnsi(STR0252)		SIZE 46,7 OF oDlg PIXEL //"Qtd.p/Quebra"
		@ 067,203 MSGET nQtdNew					PICTURE PesqPictQt("C9_QTDLIB",14) Valid nQtdNew > 0 .And. nQtdNew < SC9->C9_QTDLIB .And. FB200VlDiv(nQtdNew,@nPesoNew,@nVolNew)SIZE 53,7 OF oDlg PIXEL
		@ 078,151 SAY OemtoAnsi(STR0034)		SIZE 53,7 OF oDlg PIXEL //"Volume"
		@ 078,203 MSGET oGet1 VAR nVolNew		PICTURE "99999999."+Replicate("9",TamSx3("DAK_CAPVOL")[2]) SIZE 53,7 OF oDlg PIXEL
		oGet1:lReadOnly := .T.
		@ 089,151 SAY OemtoAnsi(STR0033)		SIZE 53,7 OF oDlg PIXEL //"Peso"
		@ 089,203 MSGET oGet2 VAR nPesoNew		PICTURE "99999999."+Replicate("9",TamSx3("DAK_PESO")[2])   SIZE 53,7 OF oDlg PIXEL
		oGet2:lReadOnly := .T.
		DEFINE SBUTTON FROM 128,230 TYPE 1 ACTION (If(nQtdNew>0,Eval({||nOpca := 1,oDlg:End()}),Eval({||nOpca := 2,oDlg:End()}))) ENABLE OF oDlg
		DEFINE SBUTTON FROM 128,263 TYPE 2 ACTION oDlg:End() ENABLE OF oDlg

		ACTIVATE MSDIALOG oDlg CENTERED
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Processamento da divisao do item de pedido de venda liberado           ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If nOpcA == 1 .And. nQtdNew <> SC9->C9_QTDLIB
			//Validação para verificar se os serviços no WMS já estão em andamento
			lProcessa := WmsAvalDAK(/*cCarga*/,/*cSeqCar*/,/*cSeqEnt*/,SC9->C9_PEDIDO,SC9->C9_ITEM,SC9->C9_SEQUEN,1,(lEstLib .And. lSC9))
			If lProcessa
				If IntDL()
					AAdd( aSaldos		,{}						)
					AAdd( aSaldos[1]	,SC9->C9_LOTECTL		)
					AAdd( aSaldos[1]	,SC9->C9_NUMLOTE		)
					AAdd( aSaldos[1] ,SC9->C9_ENDPAD ) // SC6->C6_LOCALIZ - Por causa do WMS deve pegar o endereço da SC9
					AAdd( aSaldos[1]	,SC6->C6_NUMSERI		)
					AAdd( aSaldos[1]	,nQtdNew				)
					AAdd( aSaldos[1]	,SC9->C9_POTENCI		)
					AAdd( aSaldos[1]	,SC9->C9_DTVALID		)
					AAdd( aSaldos		,{}						)
					AAdd( aSaldos[2]	,SC9->C9_LOTECTL		)
					AAdd( aSaldos[2]	,SC9->C9_NUMLOTE		)
					AAdd( aSaldos[2] ,SC9->C9_ENDPAD ) // SC6->C6_LOCALIZ - Por causa do WMS deve pegar o endereço da SC9
					AAdd( aSaldos[2]	,SC6->C6_NUMSERI		)
					AAdd( aSaldos[2]	,SC9->C9_QTDLIB-nQtdNew	)
					AAdd( aSaldos[2]	,SC9->C9_POTENCI		)
					AAdd( aSaldos[2]	,SC9->C9_DTVALID		)
				Else
					AAdd( aSaldos		,{}						)
					AAdd( aSaldos[1]	,SC9->C9_LOTECTL		)
					AAdd( aSaldos[1]	,SC9->C9_NUMLOTE		)
					AAdd( aSaldos[1]	,SC6->C6_LOCALIZ		)
					AAdd( aSaldos[1]	,SC6->C6_NUMSERI		)
					AAdd( aSaldos[1]	,nQtdNew				)
					AAdd( aSaldos[1]	,SC9->C9_POTENCI		)
					AAdd( aSaldos[1]	,SC9->C9_DTVALID		)
					AAdd( aSaldos		,{}						)
					AAdd( aSaldos[2]	,SC9->C9_LOTECTL		)
					AAdd( aSaldos[2]	,SC9->C9_NUMLOTE		)
					AAdd( aSaldos[2]	,SC6->C6_LOCALIZ		)
					AAdd( aSaldos[2]	,SC6->C6_NUMSERI		)
					AAdd( aSaldos[2]	,SC9->C9_QTDLIB-nQtdNew	)
					AAdd( aSaldos[2]	,SC9->C9_POTENCI		)
					AAdd( aSaldos[2]	,SC9->C9_DTVALID		)
				EndIf					

				//Begin Transaction
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Trava registro para atualizacao do pedido de venda                     ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					RecLock("SC5")
					RecLock("SC6")
					RecLock("SC9")
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Divide o SC9 pela quantidades informadas                               ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If lSC9
						For nX := 1 To SC9->(FCount())
							Aadd(aCopySC9, SC9->(FieldGet(nX)))
						Next nX
						cCompSDC := "DC_FILIAL+DC_PRODUTO+DC_LOCAL+DC_ORIGEM+DC_PEDIDO+DC_ITEM+DC_SEQ+DC_LOTECTL+DC_NUMLOTE"
						cSeekSDC := xFilial("SDC")+SC9->(C9_PRODUTO+C9_LOCAL+"SC6"+C9_PEDIDO+C9_ITEM+C9_SEQUEN+C9_LOTECTL+C9_NUMLOTE)
						//-- Inclui uma nova Seq. no SC9 com DIFERENCA
						nDif := SC9->C9_QTDLIB - nQtdNew
						If nQtdNew > 0 .And. Len(aCopySC9) > 0
							//-- registro do SC9 com DIFERENCA da quantidade
							RecLock('SC9')
								Replace C9_QTDLIB  With nDif
								Replace C9_QTDLIB2 With ConvUM(SC9->C9_PRODUTO, nDif, 0, 2)
							MsUnlock()
							If lOM200SC9
								ExecBlock("OM200SC9",.F.,.F.)
							EndIf
							//-- Verifica a Sequencia de Liberacao do SC9
							cQrSC9 := "MANEXTSC9"
							cQuery := "SELECT MAX(C9_SEQUEN) SEQUEN "
							cQuery += "FROM "+RetSqlName("SC9")+" SC9 "
							cQuery += "WHERE C9_FILIAL='"+xFilial("SC9")+"' AND "
							cQuery += "C9_PEDIDO='"+SC9->C9_PEDIDO+"' AND "
							cQuery += "C9_ITEM  ='"+SC9->C9_ITEM  +"' AND "
							cQuery += "SC9.D_E_L_E_T_=' '"
							cQuery := ChangeQuery(cQuery)
							dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cQrSC9,.T.,.T.)
							If (cQrSC9)->(!Eof())
								cSequen := (cQrSC9)->SEQUEN
							EndIf
							(cQrSC9)->(dbCloseArea())
							//-- Novo registro do SC9 com nova quantidade e sequencia
							dbSelectArea("SC9")
							RecLock("SC9", .T.)
							For nX := 1 To Len(aCopySC9)
								FieldPut(nX, aCopySC9[nX])
							Next nX
							Replace C9_SEQUEN  With Soma1(cSequen,Len(SC9->C9_SEQUEN))
							Replace C9_QTDLIB  With nQtdNew
							Replace C9_QTDLIB2 With ConvUM(SC9->C9_PRODUTO, nQtdNew, 0, 2)
							Replace C9_BLWMS   With cBlWMS
							Replace C9_QTDRESE With nQtdNew
							MsUnlock()
							//-- registro do SDC com DIFERENCA da quantidade empenho
							nBaixa := 0
							nQuant := nQtdNew
							dbSelectArea("SDC")
							SDC->(dbSetOrder(1)) //DC_FILIAL+DC_PRODUTO+DC_LOCAL+DC_ORIGEM+DC_PEDIDO+DC_ITEM+DC_SEQ+DC_LOTECTL+DC_NUMLOTE+DC_LOCALIZ+DC_NUMSERI
							If SDC->(dbSeek(cSeekSDC))
								For nX := 1 To SDC->(FCount())
									Aadd(aCopySDC, SDC->(FieldGet(nX)))
								Next nX
								Do While !Eof() .And. &cCompSDC == cSeekSDC .And. nQuant > 0
									nBaixa := Min(nQuant,SDC->DC_QUANT)
									nQuant -= nBaixa
									RecLock("SDC",.F.)
									Replace DC_QUANT   With SDC->DC_QUANT - nBaixa
									Replace DC_QTSEGUM With ConvUM(SDC->DC_PRODUTO, SDC->DC_QUANT - nBaixa, 0, 2)
									MsUnLock()
									SDC->(dbSkip())
								EndDo
								//-- Novo registro do SDC com nova quantidade empenho
								If Len(aCopySDC) > 0
									dbSelectArea("SDC")
									RecLock("SDC", .T.)
									For nX := 1 To Len(aCopySDC)
										FieldPut(nX, aCopySDC[nX])
									Next nX
									Replace DC_TRT     With Soma1(cSequen,Len(SDC->DC_TRT))
									Replace DC_SEQ     With Soma1(cSequen,Len(SDC->DC_TRT))
									Replace DC_QUANT   With nQtdNew
									Replace DC_QTSEGUM With ConvUM(SDC->DC_PRODUTO, nQtdNew, 0, 2)
									MsUnlock()
								EndIf
							EndIf
							//-- Estorna a nova liberacao de pedido de venda.
							Os200TrbSC9(,,SC9->(Recno()))
							oObjMrk:Refresh()
							Os200EstSC9()
						EndIf
					Else
						lbloqDCF := .T. //Ao dividir um item do pedido de venda, não deve regerar a OS
						//-- Guarda as informações do WMS
						cIdDCF  := SC9->C9_IDDCF
						cStServ := SC9->C9_STSERV
						cBlqWms := SC9->C9_BLWMS
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Verifica o status do pedido quanto a liberacao                         ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						FOR I := 1 to FCount()
							M->&(EVAL(bCampo,I)) := FieldGet(I)
						Next I

//						cLiberOk := SC5->C5_LIBEROK
						RecLock("SC9",.F.)
						dbDelete()
						MsUnLock()
//						SC9->(a460Estorna())
						For nX := 1 To Len(aSaldos)
							M->C9_QTDLIB := aSaldos[nX][5]
							M->C9_QTDLIB2 := ConvUM(M->C9_PRODUTO, M->C9_QTDLIB, 0, 2)
							If nX > 1
								While .t.
									M->C9_SEQUEN := Soma1(M->C9_SEQUEN)
									SC9->(DbSetOrder(1))
									If !SC9->(dbSeek(xFilial("SC9")+M->C9_PEDIDO+M->C9_ITEM+M->C9_SEQUEN))
										Exit
									Endif
								End
							Endif
							_nOpca := AxIncluiAuto("SC9")
						Next nX

						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Retorna o status do pedido de venda quanto a liberacao                 ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//						RecLock("SC5")
//						SC5->C5_LIBEROK := cLiberOk

						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Atualiza o arquivo temporario com os novos itens criados               ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						DbSelectArea(cAliasTRB)
						For nX := 1 To FCount()
							AAdd(aCopySC9,FieldGet(nX))
						Next nX

						DbSelectArea("SC9")
						SC9->(DbSetOrder(1))
						DBSeek(OsFilial("SC9",cOMSFilial)+cPedido+cItem)

						While !Eof() .And. OsFilial("SC9",cOMSFilial) == SC9->C9_FILIAL .And.;
								cPedido == SC9->C9_PEDIDO .And.;
								cItem   == SC9->C9_ITEM

							If Empty(SC9->C9_BLCRED) .And. Empty(SC9->C9_CARGA)

								//-- Atualizando as informações do WMS
								RecLock("SC9",.F.)
								SC9->C9_IDDCF  := cIdDCF
								SC9->C9_STSERV := cStServ
								SC9->C9_BLWMS  := cBlqWms
								SC9->(MsUnLock())

								DbSelectArea("SB1")
								SB1->(DbSetOrder(1))
								MsSeek(xFilial("SB1")+SC9->C9_PRODUTO)

								DbSelectArea(cAliasTRB)
								DbSetOrder(1)
								If MsSeek(OsFilial("SC9",cOMSFilial)+SC9->C9_PEDIDO+SC9->C9_ITEM+SC9->C9_SEQUEN)
									RecLock(cAliasTRB,.F.)
								Else
									RecLock(cAliasTRB,.T.)
									For nX := 1 To FCount()
										FieldPut(nX,aCopySC9[nX])
									Next nX
								EndIf
								(cAliasTRB)->PED_SEQLIB := SC9->C9_SEQUEN
								If	(cAliasTRB)->(FieldPos("PED_QTDLIB"))>0
									(cAliasTRB)->PED_QTDLIB := SC9->C9_QTDLIB
								EndIf
								//-- Calculo peso do item do pedido
								If FindFunction("OsPesoProd")
									nPesoProd := OsPesoProd(SC9->C9_PRODUTO)
								Else
									nPesoProd := SB1->(FieldGet(FieldPos(cCpoPeso)))
								EndIf
								(cAliasTRB)->PED_PESO  := (nPesoProd * SC9->C9_QTDLIB)
								(cAliasTRB)->PED_VALOR := A410Arred(( SC9->C9_QTDLIB * SC9->C9_PRCVEN ),"DAK_VALOR")
								(cAliasTRB)->PED_VOLUM := OsPrCapArm(SC9->C9_PRODUTO,SC9->C9_FILIAL) * SC9->C9_QTDLIB
								If lFreteEmb
									(cAliasTRB)->PED_VALFRE:= 0
									(cAliasTRB)->PED_FREAUT:= 0
								EndIf
								MsUnLock()
							EndIf

							DbSelectArea("SC9")
							DbSkip()
						EndDo
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Deleta do arquivo temporario os itens as sequencias que foram perdidas ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						DbSelectArea(cAliasTRB)
						DbSetOrder(1)
						MsSeek(OsFilial("SC9",cOMSFilial)+cPedido+cItem)
						While !Eof() .And. OsFilial("SC9",cOMSFilial) == (cAliasTRB)->PED_FILORI .And.;
								cPedido == (cAliasTRB)->PED_PEDIDO .And.;
								cItem   == (cAliasTRB)->PED_ITEM

							DbSelectArea("SC9")
							SC9->(DbSetOrder(1))
							If !MsSeek(OsFilial("SC9",cOMSFilial)+(cAliasTRB)->PED_PEDIDO+(cAliasTRB)->PED_ITEM+(cAliasTRB)->PED_SEQLIB) .Or. !Empty(SC9->C9_BLCRED)
								RecLock(cAliasTRB,.F.)
								dbDelete()
								MsUnLock()
							EndIf

							DbSelectArea(cAliasTRB)
							DbSkip()
						EndDo
					EndIf	
					If Type("aArrayMan") <> "U"									
						aSize(aArrayMan,0)
					EndIf					
				//End Transaction
				//-- apos gravacao da divisao do item do pedido de vendas da carga.
				If lSC9 .And. ExistBlock("OM200DV9")
					ExecBlock("OM200DV9",.F.,.F.,{nRecSC9,nQtdNew})
				EndIf
			EndIf
		EndIf
	EndIf
EndIf

If !lSC9 .And. aArrayFrt[FRETE_RATEIO] <> Nil
	OmsRatFre(cCarga,,If(Val(aArrayFrt[FRETE_RATEIO])==0,1,Val(aArrayFrt[FRETE_RATEIO])),aArrayFrt[FRETE_VAL],aArrayFrt[FRETE_FREAUT],@aArrayMan,cAliasTRB,aFretReg,cMarca)
EndIf

RestArea( aAreaTRB )
RestArea( aAreaSB1 )
RestArea( aAreaSC9 )
RestArea( aAreaSC6 )
RestArea( aAreaSC5 )
RestArea( aAreaSA2 )
RestArea( aAreaSA1 )
RestArea( aArea    )

Return( .T. )

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³Os200VlDiv³ Autor ³Eduardo Riera          ³ Data ³03.02.2006  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Validacao da quantidade informada na rotina OS200DivSC9       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpN1: Quantidade Informada                                   ³±±
±±³          ³ExpN2: Peso do item                                           ³±±
±±³          ³ExpN3: Volume do item                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Materiais/Distribuicao/Logistica                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Atualizacoes sofridas desde a Construcao Inicial.                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Programador  ³ Data   ³ BOPS ³  Motivo da Alteracao                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function FB200VlDiv(nQtdNew,nPesoNew,nVolNew)

Local cCpoPeso  := IIf(SuperGetMV("MV_PESOCAR") == "L","B1_PESO","B1_PESBRU")
Local lOM200DIV := ExistBlock("OM200DIV")
Local lRet      := .T.
Local nPesoProd := 0

DbSelectArea("SB1")
SB1->(DbSetOrder(1))
MsSeek(xFilial("SB1")+SC9->C9_PRODUTO)
//-- Calculo peso do item do pedido
If FindFunction("OsPesoProd")
	nPesoProd := OsPesoProd(SC9->C9_PRODUTO)
Else
	nPesoProd := SB1->(FieldGet(FieldPos(cCpoPeso)))
EndIf

nPesoNew := nPesoProd * nQtdNew
nVolNew  := OsPrCapArm(SC9->C9_PRODUTO,SC9->C9_FILIAL) * nQtdNew

//-- Ponto de Entrada para validar a quantidade digitada pelo usuario
If lOM200DIV
	lRetPE := ExecBlock("OM200DIV",.F.,.F.,{nQtdNew})
	lRet   := If(ValType(lRetPE)=="L", lRetPE, lRet)
EndIf

Return( lRet )

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³OS200COrd ³ Autor ³Keber Dias Gomes       ³ Data ³05/06/2006  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Alteracao na ordem dos pedidos de venda.                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpN1: Coluna do browse                                       ³±±
±±³          ³ExpO2: Objeto browse                                          ³±±
±±³          ³ExpA3: Array de ordem [1]-Coluna [2]-Indice do arquivo        ³±±
±±³          ³ExpC4: Alias do arquivo                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Materiais/Distribuicao/Logistica                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Atualizacoes sofridas desde a Construcao Inicial.                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Programador  ³ Data   ³ BOPS ³  Motivo da Alteracao                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function OS200COrd(nCol,oBrw,aHeadOrd,cAlias)
Local nPosOrd := aScan(aHeadOrd,{|x| x[1] == nCol })
Local nx

If nPosOrd > 0
	DbSelectArea(cAlias)
	DbSetOrder(aHeadOrd[nPosOrd][2])
	DbGoTop()

	For nx := 1 to Len(aHeadOrd)
		cRes := If(nCol == aHeadOrd[nx,1],"COLDOWN","COLRIGHT")
		oBrw:SetHeaderImage(aHeadOrd[nx,1],cRes)
	Next
EndIf

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³MenuDef   ³ Autor ³ Marco Bianchi         ³ Data ³01/09/2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Utilizacao de menu Funcional                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Array com opcoes da rotina.                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Parametros do array a Rotina:                               ³±±
±±³          ³1. Nome a aparecer no cabecalho                             ³±±
±±³          ³2. Nome da Rotina associada                                 ³±±
±±³          ³3. Reservado                                                ³±±
±±³          ³4. Tipo de Transa‡„o a ser efetuada:                        ³±±
±±³          ³    1 - Pesquisa e Posiciona em um Banco de Dados           ³±±
±±³          ³    2 - Simplesmente Mostra os Campos                       ³±±
±±³          ³    3 - Inclui registros no Bancos de Dados                 ³±±
±±³          ³    4 - Altera o registro corrente                          ³±±
±±³          ³    5 - Remove o registro corrente do Banco de Dados        ³±±
±±³          ³5. Nivel de acesso                                          ³±±
±±³          ³6. Habilita Menu Funcional                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function MenuDef()
Local aSubRotina
Private aRotina := {}

If l200Auto
      aRotina :=  {;
                      {     OemtoAnsi(STR0004) ,'OsA200Mont'   , 0 ,3 ,0 ,Nil }; //"Carregamento" 
                  } //"Legenda"

Else
      aSubRotina := {;
                        {    OemtoAnsi(STR0001) ,'u_FBA200Mont' , 0 ,3 },; //"Montagem de Carga"
                        {    OemtoAnsi(STR0063) ,'OS200Junta'   , 0 ,4 },; //"Agrupa"
                        {    OemtoAnsi(STR0005) ,'Os200Manut'   , 0 ,4 },; //"Manutencao"
                        {    OemtoAnsi(STR0006) ,'Os200Estor'   , 0 ,4 },; //"Estorno"
                        {    OemtoAnsi(STR0012) ,'Os200Assoc'   , 0 ,4 },; //"Associar Veiculo"
                        {    OemtoAnsi(STR0120) ,'Os200Blq'     , 0 ,4 }; 
                    } //"Bloqueio"

      aRotina :=  {;
                       {    OemtoAnsi(STR0060) ,'PesqBrw'      , 0 ,1 ,0 ,.F. },; //"Pesquisar"
                       {    OemtoAnsi(STR0165) ,'Os200Visual'  , 0 ,2 ,0 ,Nil },; //"Visualizar"
                       {    OemtoAnsi(STR0003) ,'Os200Liber'   , 0 ,0 ,0 ,Nil },; //"Liberacao"
                       {    OemtoAnsi(STR0254) ,'MATA456'      , 0 ,0 ,0 ,Nil },; //"Liberacao Cred/Estoque"
                       {    OemtoAnsi(STR0004) ,aSubRotina     , 0 ,3 ,0 ,Nil },; //"Carregamento"
                       {    OemtoAnsi(STR0149) ,'Os200Gant'    , 0 ,4 ,0 ,Nil },; //"Bloqueio"
                       {    OemtoAnsi(STR0007) ,'Os200Leg'     , 0 ,3 ,0 ,.F. }; 
                   } //"Legenda"
EndIf

//-- TEMPLATE DCL-EST - Cargas x Compartimentos e Lacres
If SuperGetMv("MV_DCLNEW",.F.,.F.)
	aAdd(aRotina,{"LACRES","DCLVA04Alo",0,4,NIL})
ElseIf HasTemplate("DCLEST")
	aAdd(aRotina,{"LACRES","DCVA04Aloc",0,4,NIL})
EndIf

Return( aRotina )

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³Oms200Rec ³ Autor ³ Marco Bianchi         ³ Data ³27/12/2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao disparada para validar cada registro da tabela      ³±±
±±³          ³ DAI e adicionar recno no array aRecSF2 utilizado na grava- ³±±
±±³          ³ cao da tabela DAI.                                         ³±±
±±³          ³ Se retornar .T. considera o registro.                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Logico                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpA1: Array com numero dos registros da tabela DAI         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function Oms200Rec(aRecno)

AAdd(aRecno,DAI->(RecNo()))

Return( .T. )

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³Os200EstSC9ºAutor  ³Vicco - N3-DL       º Data ³  09/01/13  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Estorno as liberacoes de pedido de venda.                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function Os200EstSC9()
Local cAviso := ""
Local lOk    := .F.
Local lOM200EST := ExistBlock("OM200EST")
Local lEstLib   := SuperGetMV("MV_OMSESTP",.F.,.T.) //Indica se estorna liberacao do pedido de vendas de uma carga ao dividir um item. Onde .T. (default) efetua o estorno.
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Nao permitir a exclusao de todos os itens. Somente algums podem ser estor-³
//³nado devido ao vinculo com o DAI.                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DbSelectArea("TRB")
DbGoTop()
While !Eof()
	If !TRB->(IsMark("TRB_OK",ThisMark(),ThisInv()))
		lOk := .T.
		Exit
	EndIf
	DbSelectArea("TRB")
	DbSkip()
EndDo
If lOk
	If MsgYesNo(OemtoAnsi(STR0253),OemToAnsi(STR0054)) //"Confirma estorno dos itens selecionados? Os Pedidos de Vendas voltarao a ficar sem carga e aptos a serem utilizados em outras cargas."###"ATEN€AO"
		//Begin Transaction
			DbSelectArea("TRB")
			DbGoTop()
			While !Eof()
				If TRB->(IsMark("TRB_OK",ThisMark(),ThisInv()))
					lOk  := .T.
					DbSelectArea("SC9")
					MsGoto(TRB->TRB_RECNO)
					If (SC9->C9_BLEST == "10" .And. SC9->C9_BLCRED == "10") .OR. (SC9->C9_BLEST == "ZZ" .And. SC9->C9_BLCRED == "ZZ")
						Help(" ",1,"NFEMITIDA")
						lOk := .F.
					EndIf
					If lOk .And. !IsInCallStack("u_FB200DivSC9") // Já validou na função anterior
						lOk := WmsAvalDAK(/*cCarga*/,/*cSeqCar*/,/*cSeqEnt*/,SC9->C9_PEDIDO,SC9->C9_ITEM,SC9->C9_SEQUEN,1,lEstLib)
					EndIf
					If lOk
						If lOM200EST
							ExecBlock("OM200EST",.F.,.F.)
						EndIf
						If lEstLib
							//-- Estorna liberacao do pedido de vendas
							a460Estorna()
						Else
							//-- Estornando a ordem de serviço do WMS
							If IntWms(SC9->C9_PRODUTO) .And. !Empty(SC9->C9_SERVIC)  .And. SC5->C5_GERAWMS <> "1"
								WmsUndoPed(SC9->(Recno()))
							EndIf
							//-- 8.Estorno Mont.Carga
							MaAvalSC9("SC9",8)
						EndIf
					EndIf
				EndIf
				DbSelectArea("TRB")
				DbSkip()
			EndDo
		//End Transaction
	Else
		lOk := .F.
	EndIf
	If !lOk
		DisarmTransaction()
	EndIf
	Os200TrbSC9()
Else
	cAviso := STR0215 //"Para estornar todos os itens deste pedido, deve-se estornar o item da carga!"
EndIf
If	!Empty(cAviso)
	Aviso( STR0192, cAviso, { STR0194 }, 2 ) // "Atencao !"###"Ok"
EndIf
Return lOk

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³Os200TrbSC9ºAutor  ³Vicco - N3-DL       º Data ³  09/01/13  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Criar TRB de Pedidos para uso na MsSelect.                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function Os200TrbSC9(oTempTable,aBrowse,nRecMrk)
Local aStruTrb  := {}
Local cAliasSC9 := "SC9"
Local nPCarga   := aScan(aHeader,{|x| AllTrim(x[2]) == "DAI_COD"})
Local nPSeqCar  := aScan(aHeader,{|x| AllTrim(x[2]) == "DAI_SEQCAR"})
Local nPPedido  := aScan(aHeader,{|x| AllTrim(x[2]) == "DAI_PEDIDO"})
Local nPFilPv   := aScan(aHeader,{|x| AllTrim(x[2]) == "DAI_FILPV"})
Local nTpVlEnt  := OsVlEntCom()
Local cFilPv    := IIf(nTpVlEnt<>1,aCols[n][nPFilPv],xFilial("SC9"))

Default nRecMrk := 0


If Select("TRB") > 0
	DbSelectArea("TRB")
	TRB->(DbGoTop())
	While TRB->(!Eof())
		Reclock("TRB",.F.)
		TRB->(DbDelete())    
		TRB->(MsUnlock())
		TRB->(DbSkip())
	EndDo
Else
	//-- Define arquivo de trabalho
	AAdd( aStruTrb ,{"TRB_OK"     ,"C" ,2							,0}							)
	AAdd( aStruTrb ,{"TRB_ITEM"   ,"C" ,TamSx3("C9_ITEM")[1]    	,TamSx3("C9_ITEM")[2]}		)
	AAdd( aStruTrb ,{"TRB_SEQUEN" ,"C" ,TamSx3("C9_SEQUEN")[1]  	,TamSx3("C9_SEQUEN")[2]}	)
	AAdd( aStruTrb ,{"TRB_PRODUT" ,"C" ,TamSx3("C9_PRODUTO")[1] 	,TamSx3("C9_PRODUTO")[2]}	)
	AAdd( aStruTrb ,{"TRB_QTDLIB" ,"N" ,TamSx3("C9_QTDLIB")[1]  	,TamSx3("C9_QTDLIB")[2]}	)
	AAdd( aStruTrb ,{"TRB_LOTECT" ,"C" ,TamSx3("C9_LOTECTL")[1] 	,TamSx3("C9_LOTECTL")[2]}	)
	AAdd( aStruTrb ,{"TRB_NUMLOT" ,"C" ,TamSx3("C9_NUMLOTE")[1] 	,TamSx3("C9_NUMLOTE")[2]}	)
	AAdd( aStruTrb ,{"TRB_DTVALI" ,"D" ,TamSx3("C9_DTVALID")[1] 	,TamSx3("C9_DTVALID")[2]}	)
	AAdd( aStruTrb ,{"TRB_RECNO"  ,"N" ,17                       	,0}							)
	//-- Define Campos
	AAdd( aBrowse ,{"TRB_OK"      , ,""  }						)
	AAdd( aBrowse ,{"TRB_ITEM"    , ,RetTitle("C9_ITEM")}		)
	AAdd( aBrowse ,{"TRB_SEQUEN"  , ,RetTitle("C9_SEQUEN")}	)
	AAdd( aBrowse ,{"TRB_PRODUT"  , ,RetTitle("C9_PRODUTO")}	)
	AAdd( aBrowse ,{"TRB_QTDLIB"  , ,RetTitle("C9_QTDLIB")}	)
	AAdd( aBrowse ,{"TRB_LOTECT"  , ,RetTitle("C9_LOTECTL")}	)
	AAdd( aBrowse ,{"TRB_NUMLOT"  , ,RetTitle("C9_NUMLOTE")}	)
	AAdd( aBrowse ,{"TRB_DTVALI"  , ,RetTitle("C9_DTVALID")}	)
	
	oTempTable := FWTemporaryTable():New( "TRB" )
	oTempTable:SetFields( aStruTrb )
	oTempTable:AddIndex("indice1", {"TRB_ITEM","TRB_SEQUEN","TRB_PRODUT"} )
	oTempTable:Create()
EndIf

//-- Monta o arquivo de trabalho
DbSelectArea("SC9")
SC9->(DbSetOrder(5))

cAliasSC9 := "Os200DelSC9"
BeginSql Alias cAliasSC9
	column C9_DTVALID as Date
	SELECT C9_FILIAL,C9_CARGA,C9_SEQCAR,C9_PEDIDO,C9_ITEM,C9_SEQUEN,C9_PRODUTO,C9_QTDLIB,C9_LOTECTL,C9_NUMLOTE,C9_DTVALID,R_E_C_N_O_ SC9RECNO
	FROM %Table:SC9% SC9
	WHERE
	SC9.C9_FILIAL = %Exp:OsFilial("SC9",cFilPv)% AND
	SC9.C9_CARGA  = %Exp:aCols[n][nPCarga ]% AND
	SC9.C9_SEQCAR = %Exp:aCols[n][nPSeqCar]% AND
	SC9.C9_PEDIDO = %Exp:aCols[n][nPPedido]% AND
	SC9.%notdel%
	EndSql
	DbSelectArea(cAliasSC9)

While !Eof() .And. OsFilial("SC9",cFilPv) == (cAliasSC9)->C9_FILIAL .And.;
		aCols[n][nPCarga]  == (cAliasSC9)->C9_CARGA .And.;
		aCols[n][nPSeqCar] == (cAliasSC9)->C9_SEQCAR

	If aCols[n][nPPedido] == (cAliasSC9)->C9_PEDIDO
		RecLock("TRB",.T.)
		If nRecMrk > 0 .And. nRecMrk == (cAliasSC9)->SC9RECNO
			TRB->TRB_OK := ThisMark()
		Else
			TRB->TRB_OK := ""
		EndIf
		TRB->TRB_ITEM   := (cAliasSC9)->C9_ITEM
		TRB->TRB_SEQUEN := (cAliasSC9)->C9_SEQUEN
		TRB->TRB_PRODUT := (cAliasSC9)->C9_PRODUTO
		TRB->TRB_QTDLIB := (cAliasSC9)->C9_QTDLIB
		TRB->TRB_LOTECT := (cAliasSC9)->C9_LOTECTL
		TRB->TRB_NUMLOT := (cAliasSC9)->C9_NUMLOTE
		TRB->TRB_DTVALI := (cAliasSC9)->C9_DTVALID
		TRB->TRB_RECNO  := (cAliasSC9)->SC9RECNO
		MsUnLock()
	EndIf
	DbSelectArea(cAliasSC9)
	DbSkip()
EndDo

DbSelectArea(cAliasSC9)
DbCloseArea()
DbSelectArea("SC9")

TRB->(DbGoTop())
Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³Os200DelSC9³ Autor ³Eduardo Riera         ³ Data ³28.12.2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Estorno da liberação do item do pedido de venda vinculado ao³±±
±±³          ³item da carga.                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Retornar                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³OMSA200                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function Os200DelSC9()

Local aArea      := GetArea()
Local aBrowse    := {}
Local aObjects   := {}
Local aSize      := MsAdvSize( .F. )
Local aPosObj    := {}
Local aInfo      := {}
Local nOpcA      := 0
Local oTempSC9	 := NIL
Local nPCarga    := aScan(aHeader,{|x| AllTrim(x[2]) == "DAI_COD"})
Local nPSeqCar   := aScan(aHeader,{|x| AllTrim(x[2]) == "DAI_SEQCAR"})
Local nPSequen   := aScan(aHeader,{|x| AllTrim(x[2]) == "DAI_SEQUEN"})
Local nPPedido   := aScan(aHeader,{|x| AllTrim(x[2]) == "DAI_PEDIDO"})
Local oDlg
Local oMark

If nPCarga <> 0 .And. nPSeqCar <> 0 .And. nPSequen <> 0 .And. nPPedido <> 0
	Os200TrbSC9(@oTempSC9,aBrowse)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Passo parametros para calculo da resolucao da tela                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aObjects := {}
	AAdd( aObjects, { 100, 030, .T., .F. } )
	AAdd( aObjects, { 100, 090, .T., .T. } )
	aInfo    := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 0, 0 }
	aPosObj  := MsObjSize( aInfo, aObjects, .T. )

	DEFINE MSDIALOG oDlg FROM aSize[7], 000 TO aSize[6], aSize[5] TITLE OemToAnsi(STR0214) PIXEL//"Estorno do item do pedido"

	DEFINE SBUTTON FROM aPosObj[1,1]+010,aPosObj[1,4]-105 TYPE 11 ACTION (u_FB200DivSC9("SC9",,,,,TRB->TRB_RECNO,oMark:oBrowse)) ENABLE OF oDlg
	DEFINE SBUTTON FROM aPosObj[1,1]+010,aPosObj[1,4]-070 TYPE  3 ACTION (Os200EstSC9(),oMark:oBrowse:Refresh())	ENABLE OF oDlg
	DEFINE SBUTTON FROM aPosObj[1,1]+010,aPosObj[1,4]-035 TYPE  1 ACTION (nOpcA:=2,oDlg:End())	  				ENABLE OF oDlg
	@ aPosObj[1,1],aPosObj[1,2] TO aPosObj[1,3],aPosObj[1,4] LABEL "" OF oDlg  PIXEL
	@ aPosObj[1,1]+010,010 SAY RetTitle("C9_CARGA")                         SIZE 46, 7 OF oDlg PIXEL
	@ aPosObj[1,1]+010,072 SAY aCols[n][nPCarga]+"/"+aCols[n][nPSeqCar]    SIZE 53, 7 OF oDlg PIXEL

	@ aPosObj[1,1]+010,120 SAY RetTitle("C9_PEDIDO")	SIZE 46, 7 OF oDlg PIXEL
	@ aPosObj[1,1]+010,160 SAY aCols[n][nPPedido]		SIZE 53, 7 OF oDlg PIXEL

	oMark:=MsSelect():New("TRB","TRB_OK",Nil,aBrowse,.F.,Nil,{aPosObj[2,1]+3,aPosObj[2,2],aPosObj[2,3]-3,aPosObj[2,4]})
	oMark:oBrowse:lCanAllmark := .F.

	ACTIVATE MSDIALOG oDlg

	//-- Excluir arquivo temporario
	oTempSC9:Delete()
EndIf

RestArea( aArea )

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³OmsA200LOk³ Autor ³ Eduardo Vicente       ³ Data ³29.05.2007³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Validacao da linha de GetDados                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function FBsA200LOk()

Local lRet := .T.
Local nI

If !GDDeleted( n )
	lRet := MaCheckCols( aHeader, aCols, n )

	If lRet
		lRet := GDCheckKey( { 'DAT_CODPAS' }, 4 )
	EndIf

	If lRet .And. aCols[n][Ascan(aHeader,{|x| x[2] == 'DAT_VALPAS'})] == 0
		lRet := .F.
	EndIf

EndIf

Return( lRet )

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³OmsA200TOk³ Autor ³ Eduardo Vicente       ³ Data ³29.05.2007³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Validacao da GetDados                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function FBsA200TOk()

Local lRet := .T.

lRet := u_FBsA200LOk()

Return( lRet )

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³OmsA200Del³ Autor ³ Eduardo Vicente       ³ Data ³30.05.2007³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Valida a exclusao da linha da GetDados                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function FBsA200Del()

Local lRet := .T.

//Condicao para nao chamar o delOk duas vezes
If nDelItem == 1
	nDelItem := 0
	Return( .F. )
EndIf

nDelItem := 1

If DAK->DAK_FEZNF == '2' //- So altera os valores se nao gerou fatura.
	If aCols[n][Len(aCols[n])] == .F.
		nFrete -= aCols[n][Ascan(aHeader,{|x| x[2] == 'DAT_VALPAS'})]
	Else
		nFrete += aCols[n][Ascan(aHeader,{|x| x[2] == 'DAT_VALPAS'})]
	EndIf
EndIf
oFrete:Refresh()

Return( lRet )

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³OmsA200Vld³ Autor ³ Eduardo Vicente       ³ Data ³30.05.2007³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Efetua a soma do frete.                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function FBsA200Vld()

Local lRet := .T.

If ReadVar() == "M->DAT_VALPAS" .And. aCols[n][Len(aCols[n])] == .F.
	nFrete += ( M->DAT_VALPAS - aCols[n][Ascan(aHeader,{|x| x[2] == 'DAT_VALPAS'})] )
	oFrete:Refresh()
EndIf

Return( lRet )



/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³OMS200VerBaºAutor ³Fabricio Bernardo   º Data ³  12/15/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Validação de campo para zerar campos DG_AGENCIA e          º±±
±±º          ³ DG_NUMCON caso DG_BANCO esteja em branco.                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function FBS200VerBa()

If !(ExistCpo('SA6'))
		GDFIELDPUT('DG_BANCO','   ', n)
	If Empty(GdFieldGet('DG_BANCO',n))
		GDFIELDPUT('DG_BANCO'   ,'   '        , n)
		GDFIELDPUT('DG_AGENCIA' ,'     '      , n)
		GDFIELDPUT('DG_NUMCON'  ,'          ' , n)
		oGDados:oBrowse:Refresh(.T.)
		Return( .F. )
	EndIf
EndIf

Return( .T. )

//-------------------------------------
/*	Modelo de Dados
@author  	Jefferson Tomaz
@version 	P10 R1.4
@build		7.00.101202A
@since 		06/04/2011
@return 		oModel Objeto do Modelo*/
//-------------------------------------
Static Function ModelDef()

Local oModel   := Nil
Local oStruDAK := FwFormStruct(1,"DAK")
Local oStruDAI := FwFormStruct(1,"DAI")
Local lIntGFE  := SuperGetMv("MV_INTGFE",,.F.)
Local aAux     := {}

If lIntGFE

	oStruDAK:AddField( ;                      // Ord. Tipo Desc.
	"Cod.Tp.Op."                     , ;      // [01]  C   Titulo do campo
	"Cod.Tp.Op."                     , ;      // [02]  C   ToolTip do campo
	"DAK_CDTPOP"                     , ;      // [03]  C   Id do Field
	'C'                              , ;      // [04]  C   Tipo do campo
	10                               , ;      // [05]  N   Tamanho do campo
	0                                , ;      // [06]  N   Decimal do campo
	NIL                              , ;      // [07]  B   Code-block de validação do campo
	NIL                              , ;      // [08]  B   Code-block de validação When do campo
	NIL                              , ;      // [09]  A   Lista de valores permitido do campo
	NIL                              , ;      // [10]  L   Indica se o campo tem preenchimento obrigatório
	FwBuildFeature( STRUCT_FEATURE_INIPAD,'SuperGetMv("MV_CDTPOP",.F.,"")' ), ;   // [11]  B   Code-block de inicializacao do campo
	NIL                              , ;      // [12]  L   Indica se trata-se de um campo chave
	NIL                              , ;      // [13]  L   Indica se o campo pode receber valor em uma operação de update.
	.T.                              )        // [14]  L   Indica se o campo é virtual

	oStruDAK:AddField( ;                      // Ord. Tipo Desc.
	"CGC Transp"                     , ;      // [01]  C   Titulo do campo
	"CGC Transp"                     , ;      // [02]  C   ToolTip do campo
	"DAK_CGCTRA"                     , ;      // [03]  C   Id do Field
	'C'                              , ;      // [04]  C   Tipo do campo
	14                               , ;      // [05]  N   Tamanho do campo
	0                                , ;      // [06]  N   Decimal do campo
	NIL                              , ;      // [07]  B   Code-block de validação do campo
	NIL                              , ;      // [08]  B   Code-block de validação When do campo
	NIL                              , ;      // [09]  A   Lista de valores permitido do campo
	NIL                              , ;      // [10]  L   Indica se o campo tem preenchimento obrigatório
	NIL                              , ;      // [11]  B   Code-block de inicializacao do campo
	NIL                              , ;      // [12]  L   Indica se trata-se de um campo chave
	NIL                              , ;      // [13]  L   Indica se o campo pode receber valor em uma operação de update.
	NIL                              )        // [14]  L   Indica se o campo é virtual

	oStruDAK:AddField( ;                      // Ord. Tipo Desc.
	"Tipo Veic"                      , ;      // [01]  C   Titulo do campo
	"Tipo Veic"                      , ;      // [02]  C   ToolTip do campo
	"DAK_CDTPVC"                     , ;      // [03]  C   Id do Field
	'C'                              , ;      // [04]  C   Tipo do campo
	2                                , ;      // [05]  N   Tamanho do campo
	0                                , ;      // [06]  N   Decimal do campo
	NIL                              , ;      // [07]  B   Code-block de validação do campo
	NIL                              , ;      // [08]  B   Code-block de validação When do campo
	NIL                              , ;      // [09]  A   Lista de valores permitido do campo
	NIL                              , ;      // [10]  L   Indica se o campo tem preenchimento obrigatório
	FwBuildFeature( STRUCT_FEATURE_INIPAD,'Posicione("DA3",1,xFilial("DA3")+DAK->DAK_CAMINH,"DA3_TIPVEI")'), ;      // [11]  B   Code-block de inicializacao do campo
	NIL                              , ;      // [12]  L   Indica se trata-se de um campo chave
	NIL                              , ;      // [13]  L   Indica se o campo pode receber valor em uma operação de update.
    .T.                              )        // [14]  L   Indica se o campo é virtual         +

   	oStruDAK:AddField( ;                 // Ord. Tipo Desc.
	"Placa Vei"						, ;		// [01]  C   Titulo do campo
	"Placa Vei"						, ;		// [02]  C   ToolTip do campo
	"DAK_PLACA"					, ;		// [03]  C   Id do Field
	'C'										, ;		// [04]  C   Tipo do campo
    TamSX3("DA3_PLACA")[1]	, ;		// [05]  N   Tamanho do campo
	0										, ;		// [06]  N   Decimal do campo
	NIL									, ;		// [07]  B   Code-block de validação do campo
	NIL									, ;		// [08]  B   Code-block de validação When do campo
	NIL									, ;		// [09]  A   Lista de valores permitido do campo
	NIL									, ;		// [10]  L   Indica se o campo tem preenchimento obrigatório
	FwBuildFeature( STRUCT_FEATURE_INIPAD,'Posicione("DA3",1,xFilial("DA3")+DAK->DAK_CAMINH,"DA3_PLACA")'), ;      // [11]  B   Code-block de inicializacao do campo
	NIL									, ;		// [12]  L   Indica se trata-se de um campo chave
	NIL									, ;		// [13]  L   Indica se o campo pode receber valor em uma operação de update.
    .T.                              )				// [14]  L   Indica se o campo é virtual         +

    aAux := FwStruTrigger(;
	"DAK_CAMINH", ;                                                      // [01] Id do campo de origem
	"DAK_CDTPVC" , ;                                                   // [02] Id do campo de destino
	'Posicione("DA3",1,xFilial("DA3")+M->DAK_CAMINH,"DA3_TIPVEI")' )

	oStruDAK:AddTrigger( ;
	aAux[1], ;                                                      // [01] Id do campo de origem
	aAux[2], ;                                                      // [02] Id do campo de destino
	aAux[3], ;                                                      // [03] Bloco de codigo de validação da execução do gatilho
	aAux[4] )                                                       // [04] Bloco de codigo de execução do gatilho

	aAux := FwStruTrigger(;
	"DAK_CAMINH", ;							 // [01] Id do campo de origem
	"DAK_PLACA" , ;							 // [02] Id do campo de destino
	'Posicione("DA3",1,xFilial("DA3")+M->DAK_CAMINH,"DA3_PLACA")')

	oStruDAK:AddTrigger( ;
	aAux[1], ;										 // [01] Id do campo de origem
	aAux[2], ; 										 // [02] Id do campo de destino
	aAux[3], ; 										 // [03] Bloco de codigo de validação da execução do gatilho
	aAux[4] ) 										 // [04] Bloco de codigo de execução do gatilho

	oStruDAK:SetProperty( '*', MODEL_FIELD_VALID, FWBuildFeature( STRUCT_FEATURE_VALID, '.T.' ) )
	oStruDAK:SetProperty( '*'         , MODEL_FIELD_WHEN,  NIL )

	oStruDAI:SetProperty( '*'         , MODEL_FIELD_VALID, { || .T. } )
	oStruDAI:SetProperty( '*'         , MODEL_FIELD_WHEN,  NIL )

EndIf

oModel := MpFormModel():New("OMSA200",/*PREVAL*/,/*POSVAL*/,,/*BCANCEL*/)
oModel:AddFields("OMSA200_DAK",,oStruDAK,/*prevalid*/,,/*bCarga*/)
oModel:SetDescription(OemtoAnsi(STR0001)) //"Montagem de carga"
oModel:GetModel("OMSA200_DAK"):SetDescription(OemtoAnsi(STR0001)) //"Montagem de carga"
oModel:SetPrimaryKey({"DAK_COD","DAK_SEQCAR"})

oModel:AddGrid("OMSA200_DAI","OMSA200_DAK",oStruDAI,)
oModel:SetRelation("OMSA200_DAI",{ {"DAI_FILIAL","xFilial('DAI')"}, {"DAI_COD","DAK_COD"}, {"DAI_SEQCAR","DAK_SEQCAR"} },"DAI_FILIAL+DAI_COD+DAI_SEQCAR")

Return oModel
//-----------------------------------------------------
/*/	Valid após a confirmação de inclusão/alteração/exclusão
@author Felipe Machado de Oliveira
@version P11
@since 18/04/2013
/*/
//------------------------------------------------------
Static Function FBSA200IPG(nOperation,cVeiculo,cMotorista,lCommit,cCarga,cSeqCar,cPedido,cDakTransp)
Local lRet := .T.
Local lIntGFE := SuperGetMv("MV_INTGFE",.F.,.F.)
Local cIntGFE2 := SuperGetMv("MV_INTGFE2",.F.,"2")
Local cIntCarga := SuperGetMv("MV_GFEI12",.F.,"2")

Default cVeiculo 	:= ""
Default cMotorista 	:= ""
Default lCommit 	:= .T.
Default cCarga 		:= ""
Default cSeqCar 	:= "01"
Default cPedido 	:= ""
Default cDakTransp	:= Criavar("A4_COD",.F.)

If lIntGFE == .T. .And. cIntGFE2 $ "1" .And. cIntCarga == "1"
	If !InterGWN(nOperation,cVeiculo,cMotorista,lCommit,cCarga,cSeqCar,cPedido,cDakTransp)
		lRet := .F.
	EndIf
EndIf

Return lRet
//-----------------------------------------------------
/*/	Integra a tabela DAK(Protheus) com GWN(SIGAGFE) a cada registro novo
@author Felipe Machado de Oliveira
@version P11
@since 18/04/2013
/*/
//------------------------------------------------------
Static Function InterGWN(nOperation,cVeiculo,cMotorista,lCommit,cCarga,cSeqCar,cPedido,cDakTransp)
Local aAreaGWN := GWN->( GetArea() )
Local aAreaGU3 := GU3->( GetArea() )
Local lRet :=  .T.
Local oModelGWN := FWLoadModel("GFEA050")
Local nTpOpSetad
Local lPula := .F.
Local cMsg
Local cTransp := ""
Local cCgcTransp := ""
Local lNumProp := SuperGetMv("MV_EMITMP",.F.,"0") == "1" .And. SuperGetMv("MV_INTGFE2",.F.,"2") == "1"
Local cSeqMV := ""
Default cDakTransp := Criavar("A4_COD",.F.)

dbSelectArea("GWN")
GWN->( dbSetOrder(1) )
GWN->( dbSeek( xFilial("GWN")+IIF(Empty(cCarga),DAK->DAK_COD+DAK->DAK_SEQCAR,cCarga+cSeqCar) ) )
If !GWN->( Eof() ) .And. GWN->GWN_FILIAL == xFilial("GWN");
					 .And. AllTrim(GWN->GWN_NRROM) == AllTrim(IIF(Empty(cCarga),DAK->DAK_COD+DAK->DAK_SEQCAR,cCarga+cSeqCar))

	If nOperation == MODEL_OPERATION_INSERT
		oModelGWN:SetOperation( MODEL_OPERATION_UPDATE )
		nTpOpSetad := MODEL_OPERATION_UPDATE
	Else
		oModelGWN:SetOperation( nOperation )
	EndIf

Else
	If nOperation == MODEL_OPERATION_INSERT
		oModelGWN:SetOperation( MODEL_OPERATION_INSERT )
		nTpOpSetad := MODEL_OPERATION_INSERT
	Else
		If Empty(cCarga)
			lPula := .T.
		Else
			oModelGWN:SetOperation( MODEL_OPERATION_INSERT )
			nTpOpSetad := MODEL_OPERATION_INSERT

		EndIf
	EndIf
EndIf

If !lPula
	oModelGWN:Activate()

	If !oModelGWN:IsActive()
		cMsg := oModelGWN:GetErrorMessage()[6]
		lRet := .F.
	Else
		If nOperation <> MODEL_OPERATION_DELETE
			If nOperation == MODEL_OPERATION_INSERT .Or. ( nTpOpSetad == MODEL_OPERATION_INSERT .And. nOperation == MODEL_OPERATION_UPDATE )
				oModelGWN:SetValue( 'GFEA050_GWN', 'GWN_CDMTR'  , IIF(Empty(cCarga),DAK->DAK_MOTORI,SubStr(cMotorista,1,TamSx3("GWN_CDMTR")[1])) )
				oModelGWN:SetValue( 'GFEA050_GWN', 'GWN_CDTPVC' , Posicione("DA3",1,xFilial("DA3")+IIF(Empty(cCarga),DAK->DAK_CAMINH,cVeiculo),"DA3_TIPVEI") )
				oModelGWN:SetValue( 'GFEA050_GWN', 'GWN_PLACAD' , Posicione("DA3",1,xFilial("DA3")+IIF(Empty(cCarga),DAK->DAK_CAMINH,cVeiculo),"DA3_PLACA") )
				If nTpOpSetad <> MODEL_OPERATION_UPDATE
					oModelGWN:SetValue( 'GFEA050_GWN', 'GWN_FILIAL', IIF(Empty(cCarga),DAK->DAK_FILIAL,xFilial("DAK")) )
					oModelGWN:SetValue( 'GFEA050_GWN', 'GWN_NRROM ', IIF(Empty(cCarga),DAK->DAK_COD+DAK->DAK_SEQCAR,cCarga+cSeqCar) )
					oModelGWN:SetValue( 'GFEA050_GWN', 'GWN_ORI'   , "2" )
				EndIf

			   	If !Empty(cDakTransp)
					cTransp := cDakTransp
				Else
					If Select("TRBPED")>0
					   	cTransp := Posicione('SC5',1,xFilial('SC5')+IIF(Empty(cCarga),Posicione("DAI",1,xFilial("DAI")+DAK->DAK_COD+DAK->DAK_SEQCAR,"DAI_PEDIDO"),TRBPED->PED_PEDIDO),'C5_TRANSP')
					Else
					   	cTransp := Posicione('SC5',1,xFilial('SC5')+IIF(Empty(cCarga),Posicione("DAI",1,xFilial("DAI")+DAK->DAK_COD+DAK->DAK_SEQCAR,"DAI_PEDIDO"),cPedido),'C5_TRANSP')
					EndIf
				EndIf

				If lNumProp
					dbSelectArea("GU3")
					GU3->( dbSetOrder(13) )
					GU3->( dbSeek( xFilial("GU3")+cTransp ) )
					If !GU3->( EOF() ) .And. GU3->GU3_FILIAL == xFilial("GU3");
											.And. GU3->GU3_CDTERP == cTransp

						cCgcTransp := GU3->GU3_CDEMIT
					Else
						cCgcTransp := Posicione('SA4',1,xFilial('SA4')+cTransp,'A4_CGC')

						If !Empty(cCgcTransp)
							GU3->( dbSetOrder(11) )
							GU3->( dbSeek( xFilial("GU3")+cCgcTransp ) )
							While !GU3->( EOF() ) .And. GU3->GU3_FILIAL == xFilial("GU3");
													  .And. GU3->GU3_IDFED == cCgcTransp

								cCgcTransp := GU3->GU3_CDEMIT

								If GU3->GU3_IE == SA4->A4_INSEST .And. GU3->GU3_SIT == "1"
									cCgcTransp := GU3->GU3_CDEMIT
								EndIf

								GU3->( dbSkip() )
							EndDo
						EndIf
					EndIf
				Else
					cCgcTransp := Posicione('SA4',1,xFilial('SA4')+cTransp,'A4_CGC')
				EndIf
				If !Empty(cDAKTpOp)
					oModelGWN:SetValue( 'GFEA050_GWN', 'GWN_CDTPOP' , cDAKTpOp )
				Else
					oModelGWN:SetValue( 'GFEA050_GWN', 'GWN_CDTPOP' , SuperGetMv("MV_CDTPOP",.F.,"") )
				EndIf
				
				If !Empty(cDAKClFr)
					oModelGWN:SetValue( 'GFEA050_GWN', 'GWN_CDCLFR' , cDAKClFr )
				Else
					oModelGWN:SetValue( 'GFEA050_GWN', 'GWN_CDCLFR' , SuperGetMv("MV_CDCLFR",.F.,"") )
				EndIF
				oModelGWN:SetValue( 'GFEA050_GWN', 'GWN_CDTRP'  , cCGCTransp )
				oModelGWN:SetValue( 'GFEA050_GWN', 'GWN_DTIMPL' , IIF(Empty(cCarga),DAK->DAK_DATA,dDatabase) )
				oModelGWN:SetValue( 'GFEA050_GWN', 'GWN_HRIMPL' , SubStr(IIF(Empty(cCarga),DAK->DAK_HORA,Time()),1,5) )
			Else
			   oModelGWN:SetValue( 'GFEA050_GWN', 'GWN_CDMTR'  , cMotorista )
			   If !Empty(cVeiculo)
			      oModelGWN:LoadValue( 'GFEA050_GWN', 'GWN_CDTPVC' , Posicione("DA3",1,xFilial("DA3")+cVeiculo,"DA3_TIPVEI") )
			      oModelGWN:SetValue( 'GFEA050_GWN', 'GWN_PLACAD' , Posicione("DA3",1,xFilial("DA3")+cVeiculo,"DA3_PLACA") )
			   EndIf
			EndIf

		EndIf

		If oModelGWN:VldData()
			If lCommit
				oModelGWN:CommitData()
					// Integração Agroindustria - SIGAAGR  									                 
					If FindFunction("OGX225I") .And. (SuperGetMV("MV_AGRUBS",.F.,.F.))

						//Pegando a resposta do pergunte para passar como parametro.
						Pergunte("OMS200C",.F.)
						cSeqMV := mv_par03
						OGX225I(nOperation,cVeiculo,cMotorista,GWN->GWN_CDTRP,AllTrim(GWN->GWN_NRROM),IIF(Empty(cCarga),DAK->DAK_COD,cCarga),cSeqCar,mv_par02,cSeqMV)

						//Devolvendo a resposta ao pergunte padrão para não impactar em outras funções.
						Pergunte("OMS200",.F.)
					EndIf
			EndIf
		Else
				cMsg := STR0255+CRLF+CRLF+oModelGWN:GetErrorMessage()[6]//"Inconsistência com o Frete Embarcador (SIGAGFE): "##
				lRet := .F.
		EndIf
	EndIf

	oModelGWN:Deactivate()
EndIf

If !lRet
	Help( ,, STR0192,,cMsg, 1, 0 ) //"Atenção"
EndIf

RestArea( aAreaGWN )
RestArea( aAreaGU3 )

Return lRet

//-----------------------------------------------------
/*	
	Funcao Om200TpOper - Informa Tipo de Operação e Classificação de Frete
	@Author Gustavo Krug
	@Version P12
	@Since 03/10/2017
*/
//------------------------------------------------------
Static Function Om200TpOper(aArrayMan, cDAKTpOp, cDAKClFr, aArrayCarga, oCargas)

Local oTpOp
Local oClFr
Local aButtons := {}
Local nCarga

Private oDlg
Private INCLUI  := .F.	// (na Enchoice) .T. Traz registro para Inclusao / .F. Traz registro para Alteracao/Visualizacao

Default aArrayMan   := {}
Default cDAKTpOp    := Criavar("DAK_CDTPOP",.F.)
Default cDAKClFr    := Criavar("DAK_CDCLFR",.F.)
Default cTpOp 		:= ""
Default cClFr 		:= ""     
Default aArrayCarga := {}

DbSelectArea("DAK")
	
If Len(aArrayMan) > 0

	DEFINE FONT oBold  NAME "Arial" SIZE 0, -12  BOLD
	
	DEFINE MSDIALOG oDlg TITLE OemtoAnsi("Tipo Oper/ Class. Frete") FROM C(221),C(250) TO C(370),C(620) PIXEL // "Tipo Oper/ Class. Frete"

	@ C(033),C(006) Say ("Tipo Operação") + ":"	   Size C(055),C(008) COLOR CLR_BLUE  PIXEL OF oDlg FONT oBold //"Tipo Operação"
	@ C(031),C(045) MsGet oTpOp Var cDAKTpOp Valid ( Os200VdOp(cDAKTpOp, @cTpOp) ) F3 "GV4" Size C(040),C(009) COLOR CLR_BLACK OF oDlg PIXEL HASBUTTON 
	@ C(043),C(006) Say ("Class. Frete") +  ":"	   Size C(055),C(008) COLOR CLR_BLUE  PIXEL OF oDlg FONT oBold // Class. Frete
	@ C(045),C(045) MsGet oClFr Var cDAKClFr Valid ( Os200VdClF(cDAKClFr, @cClFr) ) F3 "GUB" Size C(040),C(009) COLOR CLR_BLACK OF oDlg PIXEL HASBUTTON 
	
	conout("Tela TpOper")
	
	ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg, {||oDlg:End()}, {||cDAKTpOp:=Criavar("DAK_CDTPOP",.F.),oDlg:End()},,aButtons)	
	
	nCarga := Len(aArrayCarga)
	aArrayCarga[nCarga,CARGA_TPOP] := cDAKTpOp
	aArrayCarga[nCarga,CARGA_CLFR] := cDAKClFr

Else
	Help(" ",1,"OMSPEDMARK") //Nao existem pedidos selecionados para a visualizacao
EndIf

dbCloseArea()	

Return

//-----------------------------------------------------
/*	Funcao Os200VdOp - Valida se Tipo de Operação 
    existe na tela de selecao
	@author Gustavo Krug
	@version P12
	@since 03/10/2017
*/
//------------------------------------------------------
Static Function Os200VdOp(cDAKTpOp, cTpOp)

Local aAreaGV4 := GV4->(GetArea())
Local lRet     := .T.

Default cDAKTpOp := Criavar("DAK_CDTPOP",.F.)
Default cTpOp    := ""

GV4->(DbSetOrder(1))

If GV4->(MsSeek(xFilial("GV4")+cDAKTpOp))
		cTpOp := DAK->DAK_CDTPOP
Else
	Help(" ",1,"REGNOIS")//Mensagem de registro nao relacionado
	lRet := .F.
EndIf

RestArea(aAreaGV4)
Return lRet

//-----------------------------------------------------
/*	Funcao Os200VdClF - Valida se Classificação de
    Frete existe na tela de selecao
	@author Gustavo Krug
	@version P12
	@since 03/10/2017
*/
//------------------------------------------------------
Static Function Os200VdClF(cDAKClFr, cClFr)

Local aAreaGUB := GUB->(GetArea())
Local lRet     := .T.

Default cDAKClFr := Criavar("DAK_CDCLFR",.F.)
Default cClFr    := ""

GUB->(DbSetOrder(1))

If GUB->(MsSeek(xFilial("GUB")+cDAKClFr))
		cClFr := DAK->DAK_CDCLFR
Else
	Help(" ",1,"REGNOIS")//Mensagem de registro nao relacionado
	lRet := .F.
EndIf

RestArea(aAreaGUB)
Return lRet

/*/	Funcao OM200TRANS - Informa Transportadora na Carga
@author Rafael Souza
@version P12
@since 27/09/2013
/*/
//------------------------------------------------------

Static Function Om200Trans(aArrayMan,cDakTransp,cNtrans,aArrayCarga,oCargas)

Local oTrans
Local onTrans
Local aButtons := {}
Local nCarga

Private oDlg
Private INCLUI  := .F.	// (na Enchoice) .T. Traz registro para Inclusao / .F. Traz registro para Alteracao/Visualizacao

Default aArrayMan   := {}
Default cDakTransp  := Criavar("A4_COD",.F.)
Default aArrayCarga := {}
Default cNtrans     := ""

If Len(aArrayMan) > 0
	If SA4->(FieldPos("A4_MSBLQL"))>0
		If !Empty(cDakTransp)
			SA4->(DbSetOrder(1))
			If SA4->(MsSeek(xFilial("SA4")+cDakTransp))
				If SA4->A4_MSBLQL <> '1'
					cNtrans := SA4->A4_NREDUZ
				Else
					Help(" ",1,"OMS200TPBL")//Transportadora Bloqueada.
					lRet := .F.
				EndIf
			EndIf
		EndIf
	Else
		If !Empty(cDakTransp)
			SA4->(DbSetOrder(1))
			If SA4->(MsSeek(xFilial("SA4")+cDakTransp))
				cNtrans := SA4->A4_NREDUZ
			EndIf
		EndIf
	EndIf
	DEFINE FONT oBold  NAME "Arial" SIZE 0, -12  BOLD

	DEFINE MSDIALOG oDlg TITLE OemtoAnsi(STR0259) FROM C(221),C(260) TO C(320),C(620) PIXEL // "Transportadora"

		@ C(033),C(006) Say (STR0259) + ":"	   Size C(055),C(008) COLOR CLR_BLUE  PIXEL OF oDlg FONT oBold //"Transportadora:"
		@ C(031),C(045) MsGet oTrans  Var cDakTransp  Picture "@!" Valid ( Os200NomTr(cDakTransp, @cNtrans) ) F3 "SA4" Size C(040),C(009) COLOR CLR_BLACK PIXEL OF oDlg
		@ C(031),C(090) MsGet onTrans Var cNtrans Size C(080),C(008) COLOR CLR_BLACK PIXEL OF oDlg  When .F.

	ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg, {||oDlg:End()}, {||cDakTransp:=Criavar("A4_COD",.F.),oDlg:End()},,aButtons)

	nCarga := Len(aArrayCarga)
	aArrayCarga[nCarga,CARGA_TRANSP] := cDakTransp

Else
	Help(" ",1,"OMSPEDMARK") //Nao existem pedidos selecionados para a visualizacao
EndIf

Return


//-----------------------------------------------------
/*/	Funcao Os200NomTr - Busca o nome da transportadora
//  na tela de selecao
@author Rafael Souza
@version P12
@since 25/10/2013
/*/
//------------------------------------------------------
Static Function Os200NomTr(cDakTransp,cNTrans)

Local aAreaSA4 := GetArea()
Local lRet     := .T.

Default cDakTransp := Criavar("A4_COD",.F.)
Default cNtrans    := ""

SA4->(DbSetOrder(1))
If SA4->(FieldPos("A4_MSBLQL"))>0
	If SA4->(MsSeek(xFilial("SA4")+cDakTransp))
		If SA4->A4_MSBLQL <> '1'
			cNtrans := SA4->A4_NREDUZ
		Else
			Help(" ",1,"OMS200TPBL")//Transportadora Bloqueada.
			lRet := .F.
		EndIf
	Else
		Help(" ",1,"REGNOIS")//Mensagem de registro nao relacionado
		lRet := .F.
	EndIf
Else
	If SA4->(MsSeek(xFilial("SA4")+cDakTransp))		
		cNtrans := SA4->A4_NREDUZ
	Else	
		Help(" ",1,"REGNOIS")//Mensagem de registro nao relacionado
		lRet := .F.
	EndIf
EndIf
RestArea( aAreaSA4 )

Return lRet
//-----------------------------------------------------
/*/	Funcao Om200VldSX1 - Retorna se Existe ou Nao determinado pergunte
@author Felipe Barbiere
@version P12
@since 20/10/2016
/*/
//------------------------------------------------------
Static Function Om200VldSX1(cPerg, cVariavel, lExiste)

Local aRet := {}

Default cPerg := ""
Default cVariavel := ""
Default lExiste := .F.

cPerg := Padr(cPerg,Len(SX1->X1_GRUPO),' ')

AAdd( aRet, { .F. , "" })
SX1->(dbSetOrder(1))
If SX1->(DBSeek(cPerg))
	While SX1->(!Eof() .And. SX1->X1_GRUPO == cPerg)
		If Upper(cVariavel) = AllTrim(Upper(SX1->X1_VARIAVL))
			aRet[1][1] := .T.
			aRet[1][2] := &(SX1->X1_VAR01)
			Exit
		EndIf
		SX1->(DbSkip())
	EndDo
EndIf

Return aRet
