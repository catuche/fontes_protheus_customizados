#INCLUDE "Protheus.ch"
#INCLUDE "TOPCONN.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณNOVO3     บ Autor ณ Ricardo Rotta      บ Data ณ  19/09/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Rotina de Separa็ใo dos SubLotes                           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6 IDE                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function FB_SEPARA

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Define Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local aCores := {}
Local cFiltro := .T.
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Define Array contendo as Rotinas a executar do programa      ณ
//ณ ----------- Elementos contidos por dimensao ------------     ณ
//ณ 1. Nome a aparecer no cabecalho                              ณ
//ณ 2. Nome da Rotina associada                                  ณ
//ณ 3. Usado pela rotina                                         ณ
//ณ 4. Tipo de Transao a ser efetuada                          ณ
//ณ    1 -Pesquisa e Posiciona em um Banco de Dados              ณ
//ณ    2 -Simplesmente Mostra os Campos                          ณ
//ณ    3 -Inclui registros no Bancos de Dados                    ณ
//ณ    4 -Altera o registro corrente                             ณ
//ณ    5 -Estorna registro selecionado gerando uma contra-partidaณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
PRIVATE aRotina := MenuDef()


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Define o cabecalho da tela de atualizacoes                   ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
PRIVATE cCadastro := OemToAnsi("Separa็ใo")
PRIVATE aTELA[0][0],aGETS[0]

aCores := FB_SEPCOR()
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Endereca a funcao de BROWSE                                  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
cFiltro := "DAK_XDTLIB <> '        ' AND DAK_BLQCAR NOT IN ('1') AND (DAK_JUNTOU='MANUAL' OR DAK_JUNTOU='ASSOCI' OR DAK_JUNTOU='JUNTOU')"
mBrowse(6,1,22,75,"DAK" ,,,,,,aCores,,,,,,,, cFiltro)
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFB_SEPARA บAutor  ณMicrosiga           บ Data ณ  09/19/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function FB_SEPCOR()
Local aCores := {}

AAdd(aCores,{"Empty(DAK->DAK_XSEPAR)"	,"BR_VERDE"})
AAdd(aCores,{"!Empty(DAK->DAK_XSEPAR)"	,"BR_VERMELHO"})

Return aCores
//-------------------------------------------------------------------
/*/{Protheus.doc} A275Legend()
			Esta fun็ใo ้ utilizada para exibi็ใo de legendas na MBrowse

@author TOTVS
@since 21/03/2014
@version 1.0

@return NIL

/*/
//-------------------------------------------------------------------
User Function FB_SEPLEG()
Local aLegenda := {}

AAdd(aLegenda,{"BR_VERDE"		, "Carga aguardando separa็ใo" }) // "Lote liberado"
AAdd(aLegenda,{"BR_VERMELHO"	, "Separa็ใo Finalizada" }) // "Lote bloqueado"

BrwLegenda(cCadastro,,aLegenda)
Return

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
Local aRotAdic  := {}
Private aRotina	:= {	{"Pesquisar","AxPesqui", 0 , 1,0,.F.},;	//"Pesquisar"
						{"Separar","u_FB_SEPA_A('1')"    , 0 , 7 ,0,nil},;
                      	{"Visualiza Carga" ,'Os200Visual', 0 , 7 ,0 ,Nil },;
						{"Liberar Faturamento","u_FB_SEPA_A('2')"   , 0 , 7 ,0,nil},;
						{"Estornar Separa็ใo","u_FB_SEPA_A('3')"   , 0 , 7 ,0,nil},;
						{"Legenda" ,"u_FB_SEPLege"       , 0 , 5 ,0,nil}}  //"Legenda"

Return (aRotina)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFB_SEPARA บAutor  ณMicrosiga           บ Data ณ  09/19/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function FB_SEPA_A(_cParam)

Local _aArea		:= GetArea()
Local oDlg
LOCAL cNomeWrb	    := ""
LOCAL oMark			:= NIL
LOCAL aStru			:= {} //Estrutura dos produtos da carga
LOCAL aPV			:= {} //Estrutura com os pedidos que relacionados ao produto
Local aStruTMP		:= {} //Estrutura com os lotes do produto
Local aBrowse		:= {}
LOCAL aObjects		:= {}
LOCAL aPosObj		:= {}
LOCAL aSize			:= {}
LOCAL aInfo			:= {}
Local aButtons		:={}
Local lRetorno		:= .F.
Local bOk    		:= {|| lRetorno:=.T.,oDlg:End()}
Local bCancel		:= {|| lRetorno:=.F.,oDlg:End()}
Local cMarca		:= GetMark()
Local nOpca			:= 0
Local _cPrograma	:= DAK->DAK_COD
Local _cSeqCar		:= DAK->DAK_SEQCAR
Local aCpoEnch		:= {}
Local aAlterEnch	:= {}
Local nModelo		:= 3   // Se for diferente de 1 desabilita execucao de gatilhos estrangeiros
Local lF3			:= .F. // Indica se a enchoice esta sendo criada em uma consulta F3 para utilizar variaveis de memoria
Local lMemoria		:= .T. // Indica se a enchoice utilizara variaveis de memoria ou os campos da tabela na edicao
Local lColumn		:= .F. // Indica se a apresentacao dos campos sera em forma de coluna
Local caTela		:= ""  // Nome da variavel tipo "private" que a enchoice utilizara no lugar da propriedade aTela
Local lNoFolder 	:= .F. // Indica se a enchoice nao ira utilizar as Pastas de Cadastro (SXA)
Local lProperty 	:= .T. // Indica se a enchoice nao utilizara as variaveis aTela e aGets, somente suas propriedades com os mesmos nomes
Local nOpcx 		:= 4
Local aSldLote 		:= {}
Local nQtdSelf		:= 0 //Quantidade selecionada
Local nBips			:= 0 //Quantidade de bips
Local cUltLote		:= "" //Ultimo lote bipado
Local lInverte		:= .F.
Local cTudoOk   	:= "AllwaysTrue"
Local nReg      	:= DAK->(RecNo())
Local _cLocal  		:= SuperGetMV("MV_XALMPRD",.F.,"02")
Local cAlias 		:= "TRBTMP"
Local oFont			:= TFont():New("Arial",,16,.T.)
Local cBarra		:= Space(TamSx3("C6_NUMLOTE")[1])
Local cMarcaW		:= GetMark()
Local bFilTPV		:= {|| TRBPV->(DbSetFilter({|| TRBPV->PV_PRODUTO==TRB->TB_PRODUTO },"TRBPV->PV_PRODUTO==TRB->TB_PRODUTO") ) }
Local bFilTTM		:= {|| TRBTMP->(DbSetFilter({|| TRBTMP->TMP_PRODUT==TRB->TB_PRODUTO },"TRBTMP->TMP_PRODUT==TRB->TB_PRODUTO") ) }
Local _lSldDisp		:= .T.
Local lSelLtNew		:= .T.
Local aLib			:= { .T.,.T.,.F.,.F. } //Libera sempre
Local _cProd 		:= ""
Local lUsaVenc		:= .F.
Local lInfoWms		:= .F.
Local _cTOk			:= ""

Aadd( aStru,{ "TB_OK"		, "C",1,0} )
Aadd( aStru,{ "TB_PRODUTO"	, "C",TamSX3("B1_COD")[1],0} )
Aadd( aStru,{ "TB_DESCPRO"	, "C",80,0} )
Aadd( aStru,{ "TB_LOCAL"	, "C",TamSX3("B1_LOCPAD")[1],0} )
Aadd( aStru,{ "TB_QTDPRG"	, "N",TamSX3("C9_QTDLIB")[1],TamSX3("C9_QTDLIB")[2]} )
Aadd( aStru,{ "TB_QTDCON"	, "N",TamSX3("C9_QTDLIB")[1],TamSX3("C9_QTDLIB")[2]} )


aCampos := {{"TB_PRODUTO","",OemToAnsi("Produto")},;
			{"TB_DESCPRO","",OemToAnsi("Descri็ใo")},;
			{"TB_QTDPRG" ,"",OemToAnsi("Programada")	 , PesqPict("SC9","C9_QTDLIB")},;
			{"TB_QTDCON" ,"",OemToAnsi("Separada")		 , PesqPict("SC9","C9_QTDLIB")},;
			{"TB_LOCAL"  ,"",OemToAnsi("Local")} }

cNomeWrb := CriaTrab(aStru)
USE &cNomeWrb ALIAS TRB NEW EXCLUSIVE
IndRegua("TRB",cNomeWrb+OrdBagExt(),"TB_PRODUTO")

Aadd( aPV,{ "PV_NUMPV"	, "C",TamSX3("C5_NUM")[1],0} )
Aadd( aPV,{ "PV_ITEMPV"	, "C",TamSX3("C6_ITEM")[1],0} )
Aadd( aPV,{ "PV_CLIENTE", "C",TamSX3("C5_CLIENTE")[1],0} )
Aadd( aPV,{ "PV_LOJA"	, "C",TamSX3("C5_LOJACLI")[1],0} )
Aadd( aPV,{ "PV_DESCCLI", "C",TamSX3("A1_NREDUZ")[1],0} )
Aadd( aPV,{ "PV_PRODUTO", "C",TamSX3("B1_COD")[1],0} )
Aadd( aPV,{ "PV_DESCPRO", "C",80,0} )
Aadd( aPV,{ "PV_LOCAL"	, "C",TamSX3("B1_LOCPAD")[1],0} )
Aadd( aPV,{ "PV_QTDPRG"	, "N",TamSX3("C9_QTDLIB")[1],TamSX3("C9_QTDLIB")[2]} )

aCpPv := {{"PV_NUMPV","",OemToAnsi("Pedido")},;
			{"PV_CLIENTE","",OemToAnsi("Cliente")},;
			{"PV_DESCCLI","",OemToAnsi("Nome Fantasia")},;
			{"PV_QTDPRG" ,"",OemToAnsi("Programada") , PesqPict("SC9","C9_QTDLIB")},;
			{"PV_LOJA","",OemToAnsi("Loja")},;
			{"PV_ITEMPV","",OemToAnsi("Item")} }

cNomeaPV := CriaTrab(aPV)
USE &cNomeaPV ALIAS TRBPV NEW EXCLUSIVE
IndRegua("TRBPV",cNomeaPV+OrdBagExt(),"PV_PRODUTO")

aadd(aStruTMP,{"TMP_OK","C",2,0})
aadd(aStruTMP,{"TMP_NUMLOT" ,"C",TamSx3("C6_NUMLOTE")[1],TamSx3("C6_NUMLOTE")[2]})
aadd(aStruTMP,{"TMP_PRODUT ","C",TamSx3("C6_PRODUTO")[1],TamSx3("C6_PRODUTO")[2]})
aadd(aStruTMP,{"TMP_DESC"   ,"C",TamSx3("B1_DESC")[1]   ,TamSx3("B1_DESC")[2]})
aadd(aStruTMP,{"TMP_LOTECT" ,"C",TamSx3("C6_LOTECTL")[1],TamSx3("C6_LOTECTL")[2]})
aadd(aStruTMP,{"TMP_LOCALI" ,"C",TamSx3("C6_LOCALIZ")[1],TamSx3("C6_LOCALIZ")[2]})
aadd(aStruTMP,{"TMP_QTDLIB" ,"N",TamSx3("C6_QTDLIB")[1] ,TamSx3("C6_QTDLIB")[2]})
aadd(aStruTMP,{"TMP_DTVALI" ,"D",TamSx3("C6_DTVALID")[1],TamSx3("C6_DTVALID")[2]})
Aadd(aStruTMP,{"TMP_LOCAL"	, "C",TamSX3("B1_LOCPAD")[1],0} )

aadd(aBrowse,{"TMP_OK",,""})
aadd(aBrowse,{"TMP_NUMLOT" ,,RetTitle("C6_NUMLOTE")})
aadd(aBrowse,{"TMP_PRODUT ",,RetTitle("C6_PRODUTO")})
aadd(aBrowse,{"TMP_DESC"   ,,RetTitle("B1_DESC")})
aadd(aBrowse,{"TMP_LOTECT" ,,RetTitle("C6_LOTECTL")})
aadd(aBrowse,{"TMP_QTDLIB" ,,"Saldo" , PesqPict("SC9","C9_QTDLIB")})
aadd(aBrowse,{"TMP_DTVALI" ,,RetTitle("C6_DTVALID")})
aadd(aBrowse,{"TMP_LOCALI" ,,RetTitle("C6_LOCALIZ")})
aadd(aBrowse,{"TMP_LOCAL" ,,RetTitle("C6_LOCAL")})

IF Select(cAlias) > 0
	(cAlias)->(DbCloseArea())
Endif

cArquivo := CriaTrab(aStruTMP,.T.)
dbUseArea(.T.,__localDriver,cArquivo,cAlias,.F.,.F.)
IndRegua(cAlias,cArquivo+OrdBagExt(),"TMP_PRODUT")

dbSelectArea("SC9")
dbSetOrder(5)
If dbSeek(xFilial()+_cPrograma+_cSeqCar)
	While !Eof() .and. xFilial("SC9")+_cPrograma+_cSeqCar == SC9->(C9_FILIAL+C9_CARGA+C9_SEQCAR)
		_cProd := SC9->C9_PRODUTO

		dbSelectArea("TRB")
		If dbSeek(SC9->C9_PRODUTO)
			RecLock("TRB",.F.)
		Else
			RecLock("TRB",.T.)
		Endif

		//Grava os dados dos produtos
		Replace TB_PRODUTO with SC9->C9_PRODUTO,;
				TB_DESCPRO with Posicione("SB1",1,xFilial("SB1")+SC9->C9_PRODUTO,"B1_DESC"),;
				TB_LOCAL   with SC9->C9_LOCAL,;
				TB_QTDPRG with TB_QTDPRG + SC9->C9_QTDLIB
		TRB->(MsUnLock())

		//Grava os pedidos de venda
		dbSelectArea("TRBPV")
		RecLock("TRBPV",.T.)
		Replace PV_NUMPV	with SC9->C9_PEDIDO
		Replace PV_ITEMPV	with SC9->C9_ITEM
		Replace PV_CLIENTE	with SC9->C9_CLIENTE
		Replace PV_LOJA		with SC9->C9_LOJA
		Replace PV_DESCCLI	with Posicione("SA1",1,xFilial("SA1")+SC9->C9_CLIENTE+SC9->C9_LOJA,"A1_NREDUZ")
		Replace PV_PRODUTO	with SC9->C9_PRODUTO
		Replace PV_DESCPRO	with Posicione("SB1",1,xFilial("SB1")+SC9->C9_PRODUTO,"B1_DESC")
		Replace PV_LOCAL	with SC9->C9_LOCAL
		Replace PV_QTDPRG	with SC9->C9_QTDLIB
		TRBPV->(MsUnLock())

		dbSelectArea("SC9")
		SC9->(dbSkip())
	EndDo
Endif

If _cParam == "1"
	dbSelectArea("TRB")
	TRB->(dbGotop())
	While TRB->(!Eof())
		_cProd  := TRB->TB_PRODUTO
		_cLocal := TRB->TB_LOCAL

		dbSelectArea("SB1")
		SB1->(dbSetOrder(1))
		SB1->(dbSeek(xFilial("SB1") + _cProd))
		IF Rastro(_cProd)
			aSldLote := {} //Limpa o Array
			lUsaVenc := SuperGetMv('MV_LOTVENC')=='S'
			lInfoWms := .F.

			dbSelectArea("SB2")
			SB2->(dbSetOrder(1))
			SB2->(dbSeek(xFilial("SB2") + _cProd + _cLocal ))

			//Retorna os lotes disponํveis para o produto
			aSldLote := SldPorLote(_cProd,_cLocal,SaldoSb2(nil,.F.),/*SD4->D4_QTSEGUM*/,/*SD4->D4_LOTECTL*/,/*SD4->D4_NUMLOTE*/,NIL,NIL,NIL,.F.,_cLocal,NIL,NIL,.F.,dDataBase)
			dbSelectArea(cAlias)

			For nX := 1 To Len(aSldLote)
				_lSldDisp := .T.
				_cTOk := " "

				dbSelectArea("ZC9")
				ZC9->(dbSetOrder(1))

				//Verifica se jแ tem separa็ใo para a carga, produto, local, lote e sublote
				If ZC9->(dbSeek(xFilial()+DAK->DAK_COD+DAK->DAK_SEQCAR+_cProd+_cLocal+aSldLote[nX][01]+aSldLote[nX][02]))
					_cTOk := cMarcaW
					dbSelectArea("TRB")
					If dbSeek(_cProd)
						RecLock("TRB",.F.)
						Replace TB_QTDCON with TB_QTDCON+SZ6->Z6_QUANT
						If QtdComp(TRB->TB_QTDPRG) <= QtdComp(TRB->TB_QTDCON)
							Replace TB_OK with 'S'
						Endif
						MsUnLock()
					Endif
				Else
					dbSelectArea("SZ6")
					SZ6->(dbSetOrder(2))
					// Verifica se o SubLote estแ disponivel
					If SZ6->(dbSeek(xFilial()+_cProd+_cLocal+aSldLote[nX][01]+aSldLote[nX][02]))
						_lSldDisp := .F.
					Endif
				Endif
				If _lSldDisp
					dbSelectArea("TRBTMP")
					RecLock(cAlias,.T.)
					(cAlias)->TMP_OK := _cTOk
					(cAlias)->TMP_PRODUT := _cProd
					(cAlias)->TMP_DESC   := Posicione("SB1",1,xFilial("SB1")+_cProd,"B1_DESC")
					(cAlias)->TMP_LOCAL	 := _cLocal
					(cAlias)->TMP_LOTECT := aSldLote[nX][01]
					(cAlias)->TMP_NUMLOT := aSldLote[nX][02]
					(cAlias)->TMP_LOCALI := aSldLote[nX][03]
					(cAlias)->TMP_QTDLIB := aSldLote[nX][05]
					(cAlias)->TMP_DTVALI := aSldLote[nX][07]
					(cAlias)->(MsUnLock())
				Endif
			Next nX
		Endif
		dbSelectArea("TRB")
		dbSkip()
	End
Else
	dbSelectArea("SZ6")
	dbSetOrder(1)
	dbSeek(xFilial()+DAK->DAK_COD+DAK->DAK_SEQCAR)
	While !Eof() .and. xFilial("SZ6")+DAK->DAK_COD+DAK->DAK_SEQCAR == SZ6->(Z6_FILIAL+Z6_CARGA+Z6_SEQCAR)
		dbSelectArea("TRBTMP")
		RecLock(cAlias,.T.)
		(cAlias)->TMP_PRODUT := SZ6->Z6_PRODUTO
		(cAlias)->TMP_DESC   := Posicione("SB1",1,xFilial("SB1")+SZ6->Z6_PRODUTO,"B1_DESC")
		(cAlias)->TMP_LOCAL	 := SZ6->Z6_LOCAL
		(cAlias)->TMP_LOTECT := SZ6->Z6_LOTECTL
		(cAlias)->TMP_NUMLOT := SZ6->Z6_NUMLOTE
		(cAlias)->TMP_QTDLIB := SZ6->Z6_QUANT
		(cAlias)->TMP_DTVALI := SZ6->Z6_DTVALID
		(cAlias)->(MsUnLock())
		dbSelectArea("SZ6")
		dbSkip()
	End
Endif

dbSelectArea(cAlias)
dbGotop()
If _cParam == "3"
	aAdd( aButtons, {,{|| u_EstSepEC()},"Estorna toda Separa็ใo"} )
Endif

dbSelectArea("TRB")
TRB->(dbGotop())
If !Eof() .and. !Bof()
	dbSelectArea("SX3")
	dbSetOrder(1)  //
	dbSeek("DAK")
	While !Eof() .And. (x3_arquivo == "DAK")
			AADD(aCpoEnch,AllTrim(x3_campo))
		dbSkip()
	End
	RegToMemory( "DAK", .F.,,,)
	aSize := MsAdvSize()
	aInfo := {aSize[1],aSize[2],aSize[3],aSize[4],3,3}
	Aadd(aObjects,{100,040,.T.,.F.,.F.}) // Indica dimensoes x e y e indica que redimensiona x e y e assume que retorno sera em linha final coluna final (.F.)
	Aadd(aObjects,{100,080,.T.,.F.,.F.}) // Indica dimensoes x e y e indica que redimensiona x e y e assume que retorno sera em linha final coluna final (.F.)
	Aadd(aObjects,{100,100,.T.,.T.,.F.}) // Indica dimensoes x e y e indica que redimensiona x e y
	aPosObj := MsObjSize(aInfo,aObjects)

	DEFINE FONT oBold2 NAME "Arial" SIZE 0, -15 BOLD  // Largura x Altura
	DEFINE FONT oBold  NAME "Arial" SIZE 0, -20 BOLD
	DEFINE MSDIALOG oDlg TITLE "Separa็ใo" OF oMainWnd PIXEL FROM aSize[7],0 TO aSize[6],aSize[5]

	If _cParam == "0"
		EnChoice( "DAK" ,nReg, nOpcx, , , ,aCpoEnch,{aPosObj[1,1],aPosObj[1,2],aPosObj[2,3], aPosObj[1,4]} ,aAlterEnch,nModelo,,, cTudoOk ,oDlg,lF3,lMemoria,lColumn,caTela,lNoFolder,lProperty)
	Else
		EnChoice( "DAK" ,nReg, nOpcx, , , ,aCpoEnch, {aPosObj[1,1],aPosObj[1,2],aPosObj[1,3], aPosObj[1,4]},aAlterEnch,nModelo,,, cTudoOk ,oDlg,lF3,lMemoria,lColumn,caTela,lNoFolder,lProperty)
	Endif

	oMark   := MsSelect():New("TRB"," ","TB_OK=='S'",aCampos,.F.,@cMarca,{aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4]-300})
	oMark:oBrowse:bChange:={|| Eval(bFilTPV),TRBPV->(DbGoTop()),oTRBPV:oBrowse:Default(),oTRBPV:oBrowse:Refresh(),Eval(bFilTTM),TRBTMP->(DbGoTop()),oMarkF:oBrowse:Default(),oMarkF:oBrowse:Refresh()}

	oTRBPV  := MsSelect():New("TRBPV",,,aCpPv,,,{aPosObj[2,1],aPosObj[2,4]-290,aPosObj[2,3],aPosObj[2,4]})

	If _cParam == "1"
		@ aPosObj[3,1],aPosObj[3,2] TO aPosObj[3,3],aPosObj[3,4] LABEL "" OF oDlg  PIXEL

		@ aPosObj[3,1]+010,010 SAY "C๓digo de Barras" FONT oFont SIZE 100, 7 OF oDlg PIXEL
		@ aPosObj[3,1]+010,070 MSGET oGet2 VAR cBarra	FONT oFont Picture "@!" Valid CodBarra(cAlias,cBarra, @nQtdSelf, @nBips, @cUltLote) .or. Vazio() SIZE 100, 7 OF oDlg PIXEL

		oMarkF := MsSelect():New(cAlias,"TMP_OK",Nil,aBrowse,@linverte,@cMarcaW,{aPosObj[3,1]+50,aPosObj[3,2],aPosObj[3,3],aPosObj[3,4]})
		oMarkF:bMark := {| | Marca(cMarcaW,@lInverte,@oDlg, @nQtdSelf, @nBips, @cUltLote, oMark)}
		oMarkF:oBrowse:bAllMark := {|| MarkAll (cAlias, cMarcaW, @oDlg, @nQtdSelf, @nBips, @cUltLote, oMark)}
		oMarkF:oBrowse:lHasMark   :=.T.
		oMarkF:oBrowse:lCanAllMark:=.T.
	Else
		oMarkF := MsSelect():New(cAlias,,Nil,aBrowse,.F.,Nil,{aPosObj[3,1],aPosObj[3,2],aPosObj[3,3],aPosObj[3,4]})
	Endif

	//oMarkF:bAVal := {|| .F.}

	Activate MsDialog oDlg On Init (EnchoiceBar(oDlg,bOk,bCancel,,aButtons)) Centered
	If lRetorno
		If _cParam == "1"
			dbSelectArea(cAlias)
			DBClearFilter()
			dbGotop()
			While !Eof()
				IF !Empty((cAlias)->TMP_OK)
					dbSelectArea("SZ6")
					dbSetOrder(1)
					If !dbSeek(xFilial()+DAK->DAK_COD+DAK->DAK_SEQCAR+(cAlias)->TMP_PRODUT+(cAlias)->TMP_LOCAL+(cAlias)->TMP_LOTECT+(cAlias)->TMP_NUMLOT)
						RecLock("SZ6",.T.)
						Replace Z6_FILIAL with xFilial("SZ6"),;
								Z6_PRODUTO with (cAlias)->TMP_PRODUT,;
								Z6_LOCAL with (cAlias)->TMP_LOCAL,;
								Z6_LOTECTL with (cAlias)->TMP_LOTECT,;
								Z6_DTVALID with (cAlias)->TMP_DTVALI,;
								Z6_NUMLOTE with (cAlias)->TMP_NUMLOT,;
								Z6_QUANT  with (cAlias)->TMP_QTDLIB,;
								Z6_CARGA  with DAK->DAK_COD,;
								Z6_SEQCAR with DAK->DAK_SEQCAR
						MsUnLock()
					Endif
				Else
					dbSelectArea("SZ6")
					dbSetOrder(1)
					If dbSeek(xFilial()+DAK->DAK_COD+DAK->DAK_SEQCAR+(cAlias)->TMP_PRODUT+(cAlias)->TMP_LOCAL+(cAlias)->TMP_LOTECT+(cAlias)->TMP_NUMLOT)
						RecLock("SZ6",.F.)
						dbDelete()
						MsUnLock()
					Endif
				Endif
				dbSelectArea(cAlias)
				dbSkip()
			End
		ElseIf _cParam == "2"

			dbSelectArea("SC9")
			cAliasC9 := CriaTrab(NIL,.F.)
			_cQuery := "SELECT C9_PEDIDO, C9_ITEM, C9_PRODUTO, C9_QTDLIB, C9_LOCAL, C9_SEQUEN, R_E_C_N_O_ RECNSC9 FROM " + RetSqlName("SC9")
			_cQuery += " WHERE C9_FILIAL = '" + xFilial("SC9") + "'"
			_cQuery += " AND C9_CARGA = '"+DAK->DAK_COD+"'"
			_cQuery += " AND C9_SEQCAR = '"+DAK->DAK_SEQCAR+"'"
			_cQuery += " AND C9_BLEST = '02'"
			_cQuery += " AND D_E_L_E_T_ = ' '"
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),cAliasC9,.T.,.T.)
			dbSelectArea(cAliasC9)
			While !Eof()
//				Begin Transaction
					_cPedido := (cAliasC9)->C9_PEDIDO
					_cItemPV := (cAliasC9)->C9_ITEM
					_cProd	 := (cAliasC9)->C9_PRODUTO
					_nQtdLib := (cAliasC9)->C9_QTDLIB
					_cLocal  := (cAliasC9)->C9_LOCAL
					_cSequen := (cAliasC9)->C9_SEQUEN

					_nRegSC9 := (cAliasC9)->RECNSC9
					dbSelectArea("SC5")
					SC5->(dbSetOrder(1))
					SC5->(dbSeek(xFilial("SC5") + _cPedido))

					dbSelectArea("SC6")
					SC6->(dbSetOrder(1))
					SC6->(dbSeek(xFilial("SC6") + _cPedido + _cItemPV + _cProd))

					DbSelectArea("SC9")
					SC9->(DbGoTo(_nRegSC9))

					dbSelectArea("SB1")
					SB1->(dbSetOrder(1))
					SB1->(dbSeek(xFilial("SB1")+_cProd))

					dbSelectArea("SB2")
					SB2->(dbSetOrder(1))
					SB2->(MsSeek(xFilial("SB2") + _cProd + _cLocal))

					//Verificar a quantidade selecionada por Produto
					nVlrCred := 0

					IF lSelLtNew
						nQtdNew := _nQtdLib
					Else
						nQtdNew := _nQtdLib
					Endif

					_cCarga  := SC9->C9_CARGA
					_cSeqcar := SC9->C9_SEQCAR
					_cSeqEnt := SC9->C9_SEQENT

					RecLock("SC9",.F.)
					Replace C9_CARGA  with "",;
							C9_SEQCAR with "",;
							C9_SEQENT with ""
					MsUnLock()

					SC9->(A460Estorna(/*lMata410*/,/*lAtuEmp*/,@nVlrCred))

					MaLibDoFat(SC6->(RecNo()),nQtdNew,aLib[1],aLib[2],aLib[3],aLib[4],.F.,.F.,/*aEmpenho*/,/*bBlock*/,/*aEmpPronto*/,/*lTrocaLot*/,/*lOkExpedicao*/,@nVlrCred,/*nQtdalib2*/)

					SC6->(MaLiberOk({SC9->C9_PEDIDO},.F.))

					dbSelectARea("SC9")
					dbSetOrder(1)
					dbSeek(xFilial()+_cPedido + _cItemPV + _cSequen)
					While !Eof() .and. xFilial("SC9")+_cPedido + _cItemPV == SC9->(C9_FILIAL+C9_PEDIDO+C9_ITEM)
						RecLock("SC9",.F.)
						Replace C9_CARGA  with _cCarga,;
								C9_SEQCAR with _cSeqcar,;
								C9_SEQENT with _cSeqEnt
						MsUnLock()
						dbSkip()
					End

//				End Transaction
				dbSelectArea(cAliasC9)
				dbSkip()
			End
			dbSelectArea(cAliasC9)
			dbCloseArea()
		Endif
	Endif
Endif
dbSelectArea("TRB")
dbCloseArea()
dbSelectArea("TRBPV")
dbCloseArea()
dbSelectArea(cAlias)
dbCloseArea()
RestArea(_aArea)
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFB_SEPARA บAutor  ณMicrosiga           บ Data ณ  12/26/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Marca(cMarcaW,lInverte,oDlg, nQtdSelf, nBips, cUltLote, oMark)

Local _nQtdLib := 0
If IsMark("TMP_OK",cMarcaW,lInverte)
	RecLock("TRBTMP",.F.)
	If !lInverte
		Replace TRBTMP->TMP_OK With cMarcaW
	Else
		Replace TRBTMP->TMP_OK With "  "
	Endif
	MsUnlock()
Else
	RecLock("TRBTMP",.F.)
	If !lInverte
		Replace TRBTMP->TMP_OK With "  "
	Else
		Replace TRBTMP->TMP_OK With cMarcaW
	Endif
	MsUnlock()
Endif

If !Empty(TRBTMP->TMP_OK)
	RecLock("TRB",.F.)
	Replace TB_QTDCON with TB_QTDCON + TRBTMP->TMP_QTDLIB
	If QtdComp(TRB->TB_QTDPRG) <= QtdComp(TRB->TB_QTDCON)
		Replace TB_OK with 'S'
	Endif
	MsUnLock()
Else
	RecLock("TRB",.F.)
	Replace TB_QTDCON with TB_QTDCON - TRBTMP->TMP_QTDLIB
	If QtdComp(TRB->TB_QTDPRG) > QtdComp(TRB->TB_QTDCON)
		Replace TB_OK with ' '
	Endif
	MsUnLock()
Endif
oMark:oBrowse:Refresh(.t.)
oDlg:Refresh()
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFB_SEPARA บAutor  ณMicrosiga           บ Data ณ  12/26/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function Codbarra(cAlias,cBarra, nQtdSelf, nBips, cUltLote)

Local lRet := .T.
Local lAchou := .F.

IF !Empty(oGet2:Buffer)
	DbSelectArea(cAlias)
	(cAlias)->(DbGoTop())

	While !(cAlias)->(Eof())
		//Verifica se o lote bipado estแ na tela
		IF cBarra = (cAlias)->TMP_NUMLOT
			lAchou := .T.

			IF (cAlias)->(IsMark("TMP_OK",ThisMark(),ThisInv()))
				MsgInfo("Lote jแ foi selecionado!")
			Else
				RecLock(cAlias,.F.)
				Replace TMP_OK With IIf((cAlias)->(IsMark("TMP_OK",ThisMark(),ThisInv())),"",ThisMark())

				nBips++
				cUltLote := cBarra

				nQtdSelf := IIf((cAlias)->(IsMark("TMP_OK",ThisMark(),ThisInv())),nQtdSelf+(cAlias)->TMP_QTDLIB,nQtdSelf-(cAlias)->TMP_QTDLIB)

				oQtdSelF:SetText(nQtdSelf)

				(cAlias)->(MsUnlock())
			Endif

			Exit
		EndIf

		(cAlias)->(DbSkip())
	EndDo
	DbSelectArea(cAlias)
	(cAlias)->(DbGoTop())

	oGet2:Buffer := Space(TamSx3("C6_NUMLOTE")[1])

	oMarkF:oBrowse:Refresh()

	oGet2:SetFocus()

	IF !lAchou
		MsgInfo("Lote: " + cBarra + " nใo encontrado!")
	Endif
EndIf
Return lRet
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
Static Function MarkAll (cAlias, cMarca, oDlg, nQtdSelf, nBips, cUltLote, oMark)
Local 	nReg	:=	(cAlias)->(RecNo ())
Local	lRet	:=	.T.
	//
(cAlias)->(DbGoTop ())
DbEval ({|| (RecLock (cAlias, .F.), (cAlias)->TMP_OK := Iif (Empty ((cAlias)->TMP_OK), cMarca, " "), MsUnLock ())})
(cAlias)->(DbGoto (nReg))
oDlg:Refresh ()
Return (lRet)
