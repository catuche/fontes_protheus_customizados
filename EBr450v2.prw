#INCLUDE "MATR450.CH"
#INCLUDE "PROTHEUS.CH"
/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ MATR450 ³ Autor ³ Flavio Luiz Vicco      ³ Data ³03/07/2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Relacao Consumo Real x Standard.                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAPCP                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ BOPS ³  Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Marcos V.   ³19/09/06³      ³Revisao Geral- Release 3 e Release 4      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function EBR450V2()
Local oReport

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Interface de impressao                                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oReport:= ReportDef()
oReport:PrintDialog()

Return Nil
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ ReportDef³Autor  ³Flavio Luiz Vicco      ³Data  ³03/07/2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Relacao Consumo Real x Standard.                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³(Nenhum)                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ oExpO1: Objeto do relatorio                                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ReportDef()
Local oReport 
Local oSection1 
Local oSection2
Local oSection3
Local oSection4
Local oCell
Local cTitle := OemToAnsi(STR0001) //"Consumo Real x Standard"

Private cPicD3C114 := PesqPict("SD3","D3_CUSTO1",14)
Private cPicD3C116 := PesqPict("SD3","D3_CUSTO1",16)
Private cPicD3C118 := PesqPict("SD3","D3_CUSTO1",18)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Criacao do componente de impressao                                      ³
//³                                                                        ³
//³TReport():New                                                           ³
//³ExpC1 : Nome do relatorio                                               ³
//³ExpC2 : Titulo                                                          ³
//³ExpC3 : Pergunte                                                        ³
//³ExpB4 : Bloco de codigo que sera executado na confirmacao da impressao  ³
//³ExpC5 : Descricao                                                       ³
//³                                                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oReport := TReport():New("MATR450",cTitle,"MTR451",{|oReport| ReportPrint(oReport,'SD3')},STR0001) //"Consumo Real x Standard"
oReport:SetLandscape()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Ajusta o Grupo de Pergunta                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
AjustaSX1()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01    // Listagem por Ordem de Producao ou Produto.    ³
//³ mv_par02    // Listagem Sintetica ou Analitica.              ³
//³ mv_par03    // De                                            ³
//³ mv_par04    // Ate                                           ³
//³ mv_par05    // Custo do Consumo Real 1...6 ( Moeda )         ³
//³ mv_par06    // Custo do Consumo Std  1...6                   ³
//³ mv_par07    // Movimentacao De                               ³
//³ mv_par08    // Movimentacao Ate                              ³
//³ mv_par09    // Calcular Pela Estrutura / Empenho             ³
//³ mv_par10    // Aglutina por Produto.                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Pergunte(oReport:uParam,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Criacao da secao utilizada pelo relatorio                               ³
//³                                                                        ³
//³TRSection():New                                                         ³
//³ExpO1 : Objeto TReport que a secao pertence                             ³
//³ExpC2 : Descricao da secao                                              ³
//³ExpA3 : Array com as tabelas utilizadas pela secao. A primeira tabela   ³
//³        sera considerada como principal para a secao.                   ³
//³ExpA4 : Array com as Ordens do relatorio                                ³
//³ExpL5 : Carrega campos do SX3 como celulas                              ³
//³        Default : False                                                 ³
//³ExpL6 : Carrega ordens do Sindex                                        ³
//³        Default : False                                                 ³
//³                                                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Criacao das celulas da secao do relatorio                               ³
//³                                                                        ³
//³TRCell():New                                                            ³
//³ExpO1 : Objeto TSection que a secao pertence                            ³
//³ExpC2 : Nome da celula do relatorio. O SX3 sera consultado              ³
//³ExpC3 : Nome da tabela de referencia da celula                          ³
//³ExpC4 : Titulo da celula                                                ³
//³        Default : X3Titulo()                                            ³
//³ExpC5 : Picture                                                         ³
//³        Default : X3_PICTURE                                            ³
//³ExpC6 : Tamanho                                                         ³
//³        Default : X3_TAMANHO                                            ³
//³ExpL7 : Informe se o tamanho esta em pixel                              ³
//³        Default : False                                                 ³
//³ExpB8 : Bloco de codigo para impressao.                                 ³
//³        Default : ExpC2                                                 ³
//³                                                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Section 1 - Total em Quantidade da OP / Produto              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oSection1:= TRSection():New(oReport,STR0045,{"SD3"},/*aOrdem*/) //"Saldo Inicial OP / Produto"
oSection1:SetHeaderSection(.F.) // Inibe Header

TRCell():New(oSection1,"CPROD",		"",STR0037	,/*Picture*/					,17 ,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"CDESC",		"",STR0038	,/*Picture*/					,If (TamSX3("D3_COD")[1]>15, 37, 25) ,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"CUMED",		"",STR0039	,/*Picture*/					, 2	,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"NQTDE",		"",STR0022	,PesqPict("SC2","C2_QUANT",15)	,15	,/*lPixel*/,/*{|| code-block de impressao }*/,,,"RIGHT")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Section 2 - Linha de Detalhe                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oSection2:= TRSection():New(oSection1,STR0044,{"SD3"},/*aOrdem*/) //"Itens de Movimentação Interna"
oSection2:SetHeaderPage(.T.)
oSection2:SetHeaderSection(.T.)  

TRCell():New(oSection2,"CPROD"		,"",STR0020	+CRLF+STR0037,/*Picture*/					,TamSX3("D3_COD")[1]+2,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,"CDESC"		,"",""		+CRLF+STR0038,/*Picture*/					,If (TamSX3("D3_COD")[1]>15, 22, 25),/*lPixel*/,/*{|| code-block de impressao }*/) //"M a t e r i a l"
TRCell():New(oSection2,"CUMED"		,"",""		+CRLF+STR0039,/*Picture*/					, 2	,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,"NQTDE"		,"",STR0021	+CRLF+STR0022,PesqPict("SD3","D3_QUANT",15),15	,/*lPixel*/,/*{|| code-block de impressao }*/,,,"RIGHT") //"Consumo"###"Quantidade"
TRCell():New(oSection2,"NCUSUNIT"	,"",STR0023	+CRLF+STR0024,cPicD3C114					,14	,/*lPixel*/,/*{|| code-block de impressao }*/,,,"RIGHT") //"Real"###"Custo Un."
TRCell():New(oSection2,"NVLTOT"		,"","" 		+CRLF+STR0025,cPicD3C116					,16	,/*lPixel*/,/*{|| code-block de impressao }*/,,,"RIGHT") //"Valor total"
TRCell():New(oSection2,"NQTDE2"		,"",STR0021	+CRLF+STR0022,PesqPict("SD3","D3_QUANT",15),15	,/*lPixel*/,/*{|| code-block de impressao }*/,,,"RIGHT") //"Consumo"###"Quantidade"
TRCell():New(oSection2,"NCUSUSTD"	,"",STR0026	+CRLF+STR0024,cPicD3C114					,14	,/*lPixel*/,/*{|| code-block de impressao }*/,,,"RIGHT") //"Standard"###"Custo Un."
TRCell():New(oSection2,"NVLTOT2"	,"",""   	+CRLF+STR0025,cPicD3C116					,16	,/*lPixel*/,/*{|| code-block de impressao }*/,,,"RIGHT") //"Valor Total"
TRCell():New(oSection2,"NQTDE3"		,"",STR0027	+CRLF+STR0040,PesqPict("SD3","D3_QUANT",15),15	,/*lPixel*/,/*{|| code-block de impressao }*/,,,"RIGHT") //"Variacao"###"Quantidade"
TRCell():New(oSection2,"NTOTALVAR"	,"",""    	+CRLF+STR0025,cPicD3C114					,14	,/*lPixel*/,/*{|| code-block de impressao }*/,,,"RIGHT") //"Valor Total"
TRCell():New(oSection2,"NSVALOR"	,"",""      +CRLF+STR0028,cPicD3C114					,14	,/*lPixel*/,/*{|| code-block de impressao }*/,,,"RIGHT") //"$Qdt."
TRCell():New(oSection2,"NSQUANT"	,"",""      +CRLF+STR0029,PesqPict("SD3","D3_QUANT",13),13	,/*lPixel*/,/*{|| code-block de impressao }*/,,,"RIGHT") //"$Valor"
TRCell():New(oSection2,"NPERC"		,"",""      +CRLF+"    %","9999.99"						, 7 ,/*lPixel*/,/*{|| code-block de impressao }*/,,,"RIGHT")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Section 3 - Linha de Totais                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oSection3:= TRSection():New(oSection2,STR0046,{"SD3"},/*aOrdem*/) //"Totais por OP / Produto"
oSection3:SetHeaderSection(.F.)
oSection3:SetNoFilter("SD3")

TRCell():New(oSection3,"CTOTAL"		,""	,STR0020+CRLF+STR0037	,/*Picture*/					,TamSX3("D3_COD")[1]+2,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection3,"CDESC"		,""	,""		+CRLF+STR0038	,/*Picture*/					,If (TamSX3("D3_COD")[1]>15, 22, 25) ,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection3,"CUMED"		,""	,""	  	+CRLF+STR0039	,/*Picture*/					, 2	,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection3,"NQTDE"		,""	,STR0021+CRLF+STR0022	,PesqPict("SD3","D3_QUANT",15)	,15	,/*lPixel*/,/*{|| code-block de impressao }*/,,,"RIGHT")//"Quantidade"
TRCell():New(oSection3,"NTOTREALOPU",""	,STR0023+CRLF+STR0024	,cPicD3C114						,14	,/*lPixel*/,/*{|| code-block de impressao }*/,,,"RIGHT")//"Custo un."
TRCell():New(oSection3,"NTOTREALOP"	,""	,"" 	+CRLF+STR0025	,cPicD3C116						,16	,/*lPixel*/,/*{|| code-block de impressao }*/,,,"RIGHT")//"Valor total"
TRCell():New(oSection3,"NQTDE2"		,""	,STR0021+CRLF+STR0022	,PesqPict("SD3","D3_QUANT",15)	,15	,/*lPixel*/,/*{|| code-block de impressao }*/,,,"RIGHT")//"Quantidade"
TRCell():New(oSection3,"NTOTSTDOPU",""	,STR0026+CRLF+STR0024	,cPicD3C114						,14	,/*lPixel*/,/*{|| code-block de impressao }*/,,,"RIGHT")//"Custo Un."
TRCell():New(oSection3,"NTOTSTDOP"	,""	,STR0025				,cPicD3C116						,16	,/*lPixel*/,/*{|| code-block de impressao }*/,,,"RIGHT")//"Valor Total"
TRCell():New(oSection3,"NQTDE3"		,""	,STR0022				,PesqPict("SD3","D3_QUANT",15)	,15	,/*lPixel*/,/*{|| code-block de impressao }*/,,,"RIGHT")//"Quantidade"
TRCell():New(oSection3,"NTOTVAROP"	,""	,STR0025				,cPicD3C116						,16	,/*lPixel*/,/*{|| code-block de impressao }*/,,,"RIGHT")//"Valor Total"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Section 4 - Resumo Geral                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oSection4:= TRSection():New(oReport,STR0047,{"SD3"},/*aOrdem*/) //"Resumo Aglutinado por Produto"
oSection4:SetHeaderPage(.T.)
oSection4:SetHeaderSection(.F.)
oSection4:SetNoFilter("SD3")

TRCell():New(oSection4,"CPROD"		,"",""     +CRLF+STR0037	,/*Picture*/					,TamSX3("D3_COD")[1]+2 ,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection4,"CDESC"		,"",""     +CRLF+STR0038	,/*Picture*/					,25 ,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection4,"CUMED"		,"",""						,/*Picture*/					, 2			,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection4,"NQTDE"		,"",STR0030+CRLF+STR0041	,PesqPict("SD3","D3_QUANT",16)	,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/,,,"RIGHT") //"Consumo Real"###"Quantidade"
TRCell():New(oSection4,"NVLTOT"		,"",""     +CRLF+STR0031	,cPicD3C118						,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/,,,"RIGHT") //"Valor"
TRCell():New(oSection4,"NQTDE2"		,"",STR0032+CRLF+STR0042	,PesqPict("SD3","D3_QUANT",16)	,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/,,,"RIGHT") //"Consumo Std."###"Quantidade"
TRCell():New(oSection4,"NVLTOT2"	,"",""     +CRLF+STR0031	,cPicD3C118						,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/,,,"RIGHT") //"Valor"
TRCell():New(oSection4,"NQTDE3"		,"",STR0027+CRLF+STR0043	,PesqPict("SD3","D3_QUANT",16)	,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/,,,"RIGHT") //"Variacao"###"Quantidade"
TRCell():New(oSection4,"NVLTOT3"	,"",""     +CRLF+STR0031	,cPicD3C118						,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/,,,"RIGHT") //"Valor"
TRCell():New(oSection4,"NPERCTOT"	,"",""     +CRLF+"    %"	,"9999.99"						,7			,/*lPixel*/,/*{|| code-block de impressao }*/,,,"RIGHT") // Percentual( % )

Return(oReport)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ReportPrin³ Autor ³Flavio Luiz Vicco      ³Data  ³03/07/2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Relacao Consumo Real x Standard.                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpO1: Objeto Report do Relatorio                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ReportPrint(oReport,cAliasSB1)
Local oSection1  := oReport:Section(1)
Local oSection2  := oReport:Section(1):Section(1)
Local oSection3  := oReport:Section(1):Section(1):Section(1)
Local oSection4  := oReport:Section(2)
Local cVazio1    := Space(Len(SD3->D3_OP))
Local aTam       := TamSX3("D3_CUSTO1")
Local cAnt       := ""
Local cOpAnt     := ""
Local nQuantG1   := 0
Local lOpConf    := .T.
Local aRecnoD4   := {}
Local cCondicao  := ""
Local nTotalVar  := 0
Local nQtdVar    := 0
Local nPercent   := 0
Local nCusStdOP  := nTotStdOP := nCusRealOP := nTotRealOP := nTotVarOP := 0
Local nCusUnit   := nCusUnitR := nCusUnitS  := nCusUStd   := 0
Local nSValor    := 0
Local nSQuant    := 0
Local nPosTrb1   := nPosTrb2  := nPosTrb3   := 0
Local nI		 := 0

Private cAliasNew  := "SD3"
Private nTamDecQtd := TamSX3("D3_QUANT")[2]
Private nTamIntCus := aTam[1]
Private nTamDecCus := aTam[2]
Private aLstTrb1   := {}
Private aLstTrb2   := {}
Private aLstTrb3   := {}
Private lQuery     := .F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Funcao utilizada para verificar a ultima versao dos fontes      ³
//³ SIGACUS.PRW, SIGACUSA.PRX e SIGACUSB.PRX, aplicados no rpo do   |
//| cliente, assim verificando a necessidade de uma atualizacao     |
//| nestes fontes. NAO REMOVER !!!							        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !(FindFunction("SIGACUS_V") .And. SIGACUS_V() >= 20050512)
	Final(STR0034 + " SIGACUS.PRW !!!") //"Atualizar patch do programa SIGACUS.PRW"
EndIf
If !(FindFunction("SIGACUSA_V") .And. SIGACUSA_V() >= 20050512)
	Final(STR0034 + " SIGACUSA.PRX !!!") //"Atualizar patch do programa SIGACUSA.PRX"
EndIf
If !(FindFunction("SIGACUSB_V") .And. SIGACUSB_V() >= 20050910)
	Final(STR0034 + " SIGACUSB.PRX !!!") //"Atualizar patch do programa SIGACUSB.PRX"
EndIf

dbSelectArea(cAliasNew)
dbSetOrder(6)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Filtragem do relatorio                                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
#IFDEF TOP
	lQuery    := .T.
	cAliasNew := GetNextAlias()
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Transforma parametros Range em expressao SQL                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	MakeSqlExpr(oReport:uParam)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Query do relatorio da secao 1                                       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oReport:Section(1):BeginQuery()	
	
	If mv_par01 == 1 // Por OP

		BeginSql Alias cAliasNew

		SELECT D3_FILIAL, D3_COD, D3_CF, D3_OP, D3_UM, SUM(D3_QUANT) D3_QUANT, SUM(D3_CUSTO1) D3_CUSTO1
		FROM  %table:SD3% SD3
		WHERE SD3.D3_FILIAL = %xFilial:SD3%
		AND SD3.D3_EMISSAO >= %Exp:DTOS(mv_par07)%
		AND SD3.D3_EMISSAO <= %Exp:DTOS(mv_par08)%
		AND SD3.D3_OP >= %Exp:mv_par03%
		AND SD3.D3_OP <= %Exp:mv_par04%
		AND (SD3.D3_CF LIKE 'PR%' OR SD3.D3_CF LIKE 'RE%' OR SD3.D3_CF LIKE 'DE%')
		AND SD3.D3_ESTORNO = ' '
		AND SD3.%NotDel%
		GROUP BY D3_FILIAL, D3_COD, D3_CF, D3_OP, D3_UM
	    ORDER BY D3_FILIAL, D3_COD, D3_CF, D3_OP, D3_UM
		EndSql
		
	Else
	
		BeginSql Alias cAliasNew

		SELECT D3_FILIAL, D3_COD, D3_CF, D3_OP, D3_UM, SUM(D3_QUANT) D3_QUANT, SUM(D3_CUSTO1) D3_CUSTO1
		FROM  %table:SD3% SD3
		WHERE SD3.D3_FILIAL = %xFilial:SD3%
		AND SD3.D3_EMISSAO >= %Exp:DTOS(mv_par07)%
		AND SD3.D3_EMISSAO <= %Exp:DTOS(mv_par08)%
		AND SD3.D3_COD >= %Exp:mv_par03%
		AND SD3.D3_COD <= %Exp:mv_par04%
		AND SD3.D3_CF LIKE 'PR%'
		AND SD3.D3_ESTORNO = ' '
		AND SD3.%NotDel%
		GROUP BY D3_FILIAL, D3_COD, D3_CF, D3_OP, D3_UM
		UNION
		SELECT D3_FILIAL, D3_COD, D3_CF, D3_OP, D3_UM, SUM(D3_QUANT) D3_QUANT, SUM(D3_CUSTO1) D3_CUSTO1
		FROM %table:SD3% SD3, %table:SC2% SC2
		WHERE SD3.D3_FILIAL = %xFilial:SD3%
		AND SD3.D3_EMISSAO >= %Exp:DTOS(mv_par07)%
		AND SD3.D3_EMISSAO <= %Exp:DTOS(mv_par08)%
		AND SD3.D3_ESTORNO = ' '
		AND SD3.D3_CF LIKE 'RE%'
		AND SD3.%NotDel%
		AND SC2.C2_FILIAL = %xFilial:SC2%
		AND SC2.C2_NUM+C2_ITEM+C2_SEQUEN = D3_OP
		AND SC2.C2_PRODUTO >= %Exp:mv_par03%
		AND SC2.C2_PRODUTO <= %Exp:mv_par04%
		AND SC2.%NotDel%
		GROUP BY D3_FILIAL, D3_COD, D3_CF, D3_OP, D3_UM
	    ORDER BY D3_FILIAL, D3_COD, D3_CF, D3_OP, D3_UM
		EndSql
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Metodo EndQuery ( Classe TRSection )                                    ³
	//³                                                                        ³
	//³Prepara o relatorio para executar o Embedded SQL.                       ³
	//³                                                                        ³
	//³ExpA1 : Array com os parametros do tipo Range                           ³
	//³                                                                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oReport:Section(1):EndQuery(/*Array com os parametros do tipo Range*/)

#ELSE

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Transforma parametros Range em expressao Advpl                          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	MakeAdvplExpr(oReport:uParam)
	cCondicao := " D3_FILIAL == '"+xFilial("SD3")+"' .And. "
	cCondicao += " D3_OP <>  '"+cVazio1+"' .And. "
	cCondicao += " D3_CF <> 'ER0' .And. D3_CF <> 'ER1' .And. "
	cCondicao += " DTOS(D3_EMISSAO)  >= '"+DTOS(mv_par07)+"' .And. "
	cCondicao += " DTOS(D3_EMISSAO)  <= '"+DTOS(mv_par08)+"' .And. "
	cCondicao += " D3_ESTORNO <>  'S' "
	oReport:Section(1):SetFilter(cCondicao,IndexKey())
#ENDIF

oReport:SetMeter(SD3->(RecCount()))

While !oReport:Cancel() .And. (cAliasNew)->(!Eof())

	oReport:IncMeter()

	If oReport:Cancel()
		Exit
	EndIf

	SC2->(dbSetOrder(1))
	SC2->(dbSeek(xFilial("SC2")+(cAliasNew)->D3_OP))

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Le requisicoes e devolucoes SD3 e grava no aLstTrb1 para gravacao do REAL ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If SubStr((cAliasNew)->D3_CF,2,1)$"E" .And. ( lQuery .Or. ( (cAliasNew)->(!Empty(D3_OP) ) ) )

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Ordem de Producao / Produto                                  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If mv_par01 == 1
			nPosTrb1 := aScan(aLstTrb1,{|x| x[2]+x[1]==(cAliasNew)->D3_OP+(cAliasNew)->D3_COD})
		Else  
			If mv_par10 == 1
				nPosTrb1 := aScan(aLstTrb1,{|x| x[7]+x[1]==SC2->C2_PRODUTO+(cAliasNew)->D3_COD})
			Else
				nPosTrb1 := aScan(aLstTrb1,{|x| x[7]+x[1]+x[2]==SC2->C2_PRODUTO+(cAliasNew)->D3_COD+SC2->(C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD)})
			EndIf
		EndIf

		If Empty(nPosTrb1)
			aAdd(aLstTrb1,{	(cAliasNew)->D3_COD,		;	  		//01 - PRODUTO
							(cAliasNew)->D3_OP,			; 			//02 - OP
							CriaVar("D3_NUMSEQ",.F.),	; 			//03 - NUMSEQ
							" ",				; 					//04 - TRT
							CriaVar("D3_CHAVE",.F.),	; 			//05 - CHAVE
							" ",						; 			//06 - EMISSAO
							SC2->C2_PRODUTO,			; 			//07 - PAI
							"",							;	 		//08 - FIXVAR
							R450Qtd("R",0,cAliasNew),	; 			//09 - QTDREAL
							0,							; 			//10 - QTDSTD
							0,							; 			//11 - QTDVAR
							0,							; 			//12 - CUSTOSTD
							R450Cus('R', mv_par05,,cAliasNew),;		//13 - CUSTOREAL
							0	})						  			//14 - CUSTOVAR
		Else
			aLstTrb1[nPosTrb1,03] := CriaVar("D3_NUMSEQ",.F.)			//03 - NUMSEQ
			aLstTrb1[nPosTrb1,04] := " "								//04 - TRT
			aLstTrb1[nPosTrb1,05] := CriaVar("D3_CHAVE",.F.)			//05 - CHAVE
			aLstTrb1[nPosTrb1,06] := " "								//06 - EMISSAO
			aLstTrb1[nPosTrb1,09] += R450Qtd("R",0,cAliasNew)		 	//09 - QTDREAL
			aLstTrb1[nPosTrb1,13] += R450Cus('R', mv_par05,,cAliasNew)	//13 - CUSTOREAL
		EndIf

	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Le producoes e gravar TRB. para gravacao do STANDARD         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If SubStr((cAliasNew)->D3_CF,1,2)$"PR"

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Considera filtro de Usuario                                  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !(SB1->(dbSeek(xFilial("SB1")+(cAliasNew)->D3_COD)))
			(cAliasNew)->(DbSkip())
			Loop
		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Lista por Ordem de Producao / Produto                        ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If mv_par01 == 1
			nPosTrb2 := aScan(aLstTrb2,{|x|x[2]==(cAliasNew)->D3_OP})
		Else
			nPosTrb2 := aScan(aLstTrb2,{|x|x[1]==(cAliasNew)->D3_COD})
		EndIf

		If Empty(nPosTrb2)
			aAdd(aLstTrb2,Array(4))
			nPosTrb2 := Len(aLstTrb2)
			aLstTrb2[nPosTrb2,4] := 0
		EndIf
		aLstTrb2[nPosTrb2,1] := (cAliasNew)->D3_COD
		aLstTrb2[nPosTrb2,2] := (cAliasNew)->D3_OP
		aLstTrb2[nPosTrb2,3] := (cAliasNew)->D3_UM
		aLstTrb2[nPosTrb2,4] += (cAliasNew)->D3_QUANT

		cProduto := (cAliasNew)->D3_COD

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Calcular pela Estrutura                                      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If mv_par09 == 1
			dbSelectArea("SG1")
			dbSetOrder(1)
			dbSeek(xFilial("SG1")+cProduto)
			While !Eof() .And. xFilial("SG1")+cProduto == G1_FILIAL + G1_COD
				If G1_INI > dDataBase .Or. G1_FIM < dDataBase
					dbSelectArea("SG1")
					dbSkip()
					Loop
				EndIf
				dbSelectArea("SB1")
				dbSeek(xFilial("SB1")+(cAliasNew)->D3_COD)
				If SG1->G1_FIXVAR == "F"
					nQuantG1 := SG1->G1_QUANT
					If (cAliasNew)->D3_PARCTOT == 'P'
						nQuantG1 := Round(nQuantG1*IIf(SC2->(C2_QUJE==C2_QUANT),1,SC2->(C2_QUJE/C2_QUANT)),nTamDecQtd)
					EndIf
				Else
					nQuantG1 := ExplEstr((cAliasNew)->D3_QUANT,,SC2->C2_OPC)
				EndIf

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Se Produto for FANTASMA gravar so os componentes.            ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If RetFldProd(SB1->B1_COD,"B1_FANTASM") == "S" // Projeto Implementeacao de campos MRP e FANTASM no SBZ
					R450Fant(nQuantG1 )
				Else
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Gravar Valores da Producao no array aLstTrb1                 ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					dbSelectArea("SB1")
					If dbSeek(xFilial("SB1")+SG1->G1_COMP)
						If mv_par01 == 1
							nPosTrb1 := aScan(aLstTrb1,{|x| x[2]+x[1]==(cAliasNew)->D3_OP+SG1->G1_COMP})
						Else
							If mv_par10 == 1
								nPosTrb1 := aScan(aLstTrb1,{|x| x[7]+x[1]==SC2->C2_PRODUTO+SG1->G1_COMP})
							Else
								nPosTrb1 := aScan(aLstTrb1,{|x| x[7]+x[1]+x[2]==SC2->C2_PRODUTO+SG1->G1_COMP+SC2->(C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD)})
							EndIf
						EndIf
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Valida Requesicoes de mesmo componente para a mesma estrutura ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						If !Empty(nPosTrb1) .And. !Empty(aLstTrb1[nPosTrb1,4])
							aRetSD3 := R450TRT("PR",nPosTrb1)
						Else
							aRetSD3 := {"",0,.F.}
						EndIf
						If Empty(nPosTrb1)
							aAdd(aLstTrb1,Array(14))
							nPosTrb1 := Len(aLstTrb1)
							aLstTrb1[nPosTrb1,01] := SG1->G1_COMP
							aLstTrb1[nPosTrb1,02] := (cAliasNew)->D3_OP
							aLstTrb1[nPosTrb1,09] := 0
							aLstTrb1[nPosTrb1,10] := 0
							aLstTrb1[nPosTrb1,11] := 0
							aLstTrb1[nPosTrb1,12] := 0
							aLstTrb1[nPosTrb1,13] := 0
							aLstTrb1[nPosTrb1,14] := 0
						EndIf
						aLstTrb1[nPosTrb1,04] := aRetSD3[1]
						aLstTrb1[nPosTrb1,07] := cProduto
						aLstTrb1[nPosTrb1,08] := SG1->G1_FIXVAR
						aLstTrb1[nPosTrb1,10] += Round(nQuantG1,nTamDecQtd)
						aLstTrb1[nPosTrb1,12] += R450Cus("S",mv_par06,Round(nQuantG1,nTamDecCus))

						If aRetSD3[3] .And. ! lQuery
							(cAliasNew)->( dbGoTo(aRetSD3[2]) )
						EndIf

					EndIf

				EndIf
				dbSelectArea("SG1")
				dbSkip()
			EndDo

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Calcular pelo Empenho                                        ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		Else
			dbSelectArea("SD4")
			dbSetOrder(2)
			dbSeek(xFilial("SD4")+(cAliasNew)->D3_OP)
			If (cAliasNew)->D3_OP # cOpAnt
				lOpConf:=.T.
			Else
				lOpConf:=.F.
			EndIf

			While SD4->(!Eof() .And. D4_FILIAL + D4_OP == xFilial("SD4")+(cAliasNew)->D3_OP ) .And. cOpAnt # (cAliasNew)->D3_OP .And. lOpConf

				If aScan(aRecnoD4, SD4->(RecNo())) > 0
					dbSkip()
					Loop
				EndIf

				aAdd(aRecnoD4, SD4->(RecNo()))

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Gravar Valores da Producao no array aLstTrb1                 ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				dbSelectArea("SB1")
				dbSeek(xFilial("SB1")+SD4->D4_COD)
				If mv_par01 == 1
					nPosTrb1 := aScan(aLstTrb1,{|x|x[2]+x[1]==(cAliasNew)->D3_OP+SD4->D4_COD})
				Else
					If mv_par10 == 1
						nPosTrb1 := aScan(aLstTrb1,{|x|x[7]+x[1]==SC2->C2_PRODUTO+SD4->D4_COD}) 
					Else
						nPosTrb1 := aScan(aLstTrb1,{|x| x[7]+x[1]+x[2]==SC2->C2_PRODUTO+SD4->D4_COD+SC2->(C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD)})
					EndIf
				EndIf

				If Empty(nPosTrb1)
					aAdd(aLstTrb1,Array(14))
					nPosTrb1 := Len(aLstTrb1)
					aLstTrb1[nPosTrb1,01] := SD4->D4_COD
					aLstTrb1[nPosTrb1,02] := (cAliasNew)->D3_OP
					aLstTrb1[nPosTrb1,09] := 0
					aLstTrb1[nPosTrb1,10] := 0
					aLstTrb1[nPosTrb1,11] := 0
					aLstTrb1[nPosTrb1,12] := 0
					aLstTrb1[nPosTrb1,13] := 0
					aLstTrb1[nPosTrb1,14] := 0
				EndIf
				aLstTrb1[nPosTrb1,07] := cProduto
				aLstTrb1[nPosTrb1,08] := ""
				If Empty(SD4->D4_QUANT)
					aLstTrb1[nPosTrb1,10] += Round(SD4->D4_QTDEORI*IIf(SC2->(C2_QUJE==C2_QUANT),1,SC2->(C2_QUJE/C2_QUANT)),nTamDecQtd)
				Else
					aLstTrb1[nPosTrb1,10] += Round((SD4->D4_QTDEORI-SD4->D4_QUANT),nTamDecQtd)
				EndIf
				aLstTrb1[nPosTrb1,12] +=  R450Cus("S",mv_par06,Round((SD4->D4_QTDEORI-SD4->D4_QUANT),nTamDecQtd))//aLstTrb1[nPosTrb1,10])



				dbSelectArea("SD4")
				dbSkip()
			EndDo
			cOpAnt := (cAliasNew)->D3_OP
		EndIf
		dbSelectArea(cAliasNew)
	EndIf
	(cAliasNew)->(dbSkip())
EndDo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Ordena por Ordem de Producao / Produto                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If mv_par01 == 1
	aLstTrb1 := ASort(aLstTrb1,,, { | x,y | x[2]+x[1] < y[2]+y[1] })
Else
	aLstTrb1 := ASort(aLstTrb1,,, { | x,y | x[7]+x[1] < y[7]+y[1] })
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicio da Impressao do array.                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oReport:SetTitle(oReport:Title()+IIF(mv_par01 == 1, STR0009,STR0010)) //" ( Por Ordem de Producao )"###" ( Por Produto )"
oReport:SetMeter(RecCount())
oSection1:Init()
oSection2:Init()
oSection3:Init()
nQuantOp := 0.00

For nI:=1 To Len(aLstTrb1)

	oReport:IncMeter()

	If oReport:Cancel()
		Exit
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Filtro por OP / Produto                                      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If mv_par01 == 1
		// Filtrar por OP
		If AllTrim(aLstTrb1[nI,2]) < AllTrim(mv_par03) .Or. AllTrim(aLstTrb1[nI,2]) > AllTrim(mv_par04)
           Loop
		EndIf
	Else
		// Filtrar por Produto Pai
		If aLstTrb1[nI,7] < mv_par03 .Or. aLstTrb1[nI,7] > mv_par04
			Loop	
		EndIf
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Impressao por OP e PRODUTO                               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If mv_par01 = 1
		nPosTrb2 := aScan(aLstTrb2,{|x| x[2]==aLstTrb1[nI,2]})
	Else
		nPosTrb2 := aScan(aLstTrb2,{|x| x[1]==aLstTrb1[nI,7]})	
	EndIf
	If Empty(nPosTrb2)
		Loop
	EndIf
	If mv_par02 == 1
		oSection1:Cell("CPROD"):SetValue(If(mv_par01=1,STR0036+aLstTrb2[nPosTrb2,2],STR0035)) //"OP: "###"PRODUTO:"
		oSection1:Cell("CDESC"):SetValue(aLstTrb2[nPosTrb2,1])
		oSection1:Cell("CUMED"):SetValue(aLstTrb2[nPosTrb2,3])
		oSection1:Cell("NQTDE"):SetValue(aLstTrb2[nPosTrb2,4])
		oSection1:PrintLine()
		oReport:PrintText(Posicione("SB1",1,xFilial("SB1")+aLstTrb2[nPosTrb2,1],"B1_DESC"))
		oReport:SkipLine() //-- Salta linha
		nQuantOp := aLstTrb2[nPosTrb2,4]
	EndIf
	nCusStdOP := nTotStdOP := nCusRealOP := nTotRealOP := nTotVarOP := 0
	nCusUnitR := nCusUnitS := 0

	cAnt 	  := IIf( mv_par01 == 1,aLstTrb1[nI,02],aLstTrb1[nI,07])

	While nI <= Len(aLstTrb1) .And. IIF( mv_par01 == 1,aLstTrb1[nI,2],aLstTrb1[nI,7]) == cAnt
		nTotalVar  := aLstTrb1[nI,13]-aLstTrb1[nI,12]  //	CUSTOREAL-CUSTOSTD
		nQtdVar    := aLstTrb1[nI,09]-aLstTrb1[nI,10]	//	QTDREAL-QTDSTD
		nPercent   := (nQtdVar/aLstTrb1[nI,10])*100	//	((QTDREAL-QTDSTD)/QTDSTD)*100
		nCusUnit   := IIf(Empty(aLstTrb1[nI,09]),aLstTrb1[nI,13],Round(aLstTrb1[nI,13]/aLstTrb1[nI,09],nTamDecCus))	//Round(CUSTOREAL/IIF(QTDREAL=0,1,QTDREAL),nTamDecCus)
		nCusUStd   := IIf(Empty(aLstTrb1[nI,10]),aLstTrb1[nI,12],Round(aLstTrb1[nI,12]/aLstTrb1[nI,10],nTamDecCus))	//Round(CUSTOSTD/IIF(QTDSTD=0,1,QTDSTD),nTamDecCus)
		nSValor    := Round(nCusUnit*nQtdVar,nTamDecCus)
		nSQuant    := Round(nTotalVar-nSValor,nTamDecCus)
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Posiciona na tabela de PRODUTOS                          ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		SB1->(DbSetOrder(1))
		SB1->(dbSeek(xFilial("SB1")+aLstTrb1[nI,01]))	
		If mv_par02 == 1 .And. (mv_par09 == 1 .Or. (QtdComp(aLstTrb1[nI,09],.T.) # QtdComp(0,.T.)))
			oSection2:Cell("CPROD"	):SetValue(aLstTrb1[nI,01])
			oSection2:Cell("CDESC"	):SetValue(SB1->B1_DESC)
			oSection2:Cell("CUMED"	):SetValue(SB1->B1_UM)

			oSection2:Cell("NQTDE"		):SetValue(aLstTrb1[nI,09])
			oSection2:Cell("NCUSUNIT"	):SetValue(nCusUnit)
			oSection2:Cell("NVLTOT"		):SetValue(aLstTrb1[nI,13])

			oSection2:Cell("NQTDE2"		):SetValue(aLstTrb1[nI,10])
			oSection2:Cell("NCUSUSTD"	):SetValue(nCusUStd)
			oSection2:Cell("NVLTOT2"	):SetValue(aLstTrb1[nI,12])

			oSection2:Cell("NQTDE3"		):SetValue(nQtdVar)
			oSection2:Cell("NTOTALVAR"	):SetValue(nTotalVar)
			oSection2:Cell("NSVALOR"	):SetValue(nSValor)
			oSection2:Cell("NSQUANT"	):SetValue(nSQuant)
			oSection2:Cell("NPERC"		):SetValue(nPercent)
			oSection2:PrintLine()
		EndIf
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Aglutinar Produto para Posterior Resumo.                 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nPosTrb3 := aScan(aLstTrb3,{|x|x[1]==aLstTrb1[nI,1]})
		If Empty(nPosTrb3)
			aAdd(aLstTrb3,{	aLstTrb1[nI,01],; //PRODUTO
							aLstTrb1[nI,09],; //QTDREAL
							aLstTrb1[nI,10],; //QTDSTD
							aLstTrb1[nI,13],; //CUSTOREAL
							aLstTrb1[nI,12],; //CUSTOSTD
							SB1->B1_DESC})    //DESCRICAO
		Else
			aLstTrb3[nPosTrb3,02] += aLstTrb1[nI,09] //QTDREAL
			aLstTrb3[nPosTrb3,03] += aLstTrb1[nI,10] //QTDSTD
			aLstTrb3[nPosTrb3,04] += aLstTrb1[nI,13] //CUSTOREAL
			aLstTrb3[nPosTrb3,05] += aLstTrb1[nI,12] //CUSTOSTD
		EndIf
		nCusUnitR  += nCusUnit
		nCusUnitS  += nCusUStd
		nTotRealOP += aLstTrb1[nI,13]
		nTotStdOP  += aLstTrb1[nI,12]
		nTotVarOP  += nTotalVar
		nI++
		If nI > Len(aLstTrb1) .Or. IIf( mv_par01 == 1,aLstTrb1[nI,2],aLstTrb1[nI,7]) # cAnt
			nI--
			Exit
		EndIf
	EndDo
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Impressao dos Totais por OP/Produto.                     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If mv_par02 == 1
		oReport:ThinLine() //-- Impressao de Linha Simples
		oSection3:Cell("CTOTAL"			):SetValue(STR0012+IIf(mv_par01==1,STR0013,STR0014)) //"Total "###"da OP:"###"do Produto:"
		oSection3:Cell("NTOTREALOPU"	):SetValue((nTotRealOP/nQuantOp))
		oSection3:Cell("NTOTREALOP"		):SetValue(nTotRealOP)
		oSection3:Cell("NTOTSTDOPU"		):SetValue((nTotStdOP/nQuantOp))
		oSection3:Cell("NTOTSTDOP"		):SetValue(nTotStdOP)
		oSection3:Cell("NTOTVAROP"		):SetValue(nTotVarOP)
		oSection3:PrintLine()
		oReport:ThinLine() //-- Impressao de Linha Simples
		oReport:SkipLine() //-- Salta linha
	EndIf
Next
oSection2:SetHeaderSection(.F.)
oSection4:SetHeaderSection(.T.)
oSection1:Finish()
oSection2:Finish()
oSection3:Finish()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impressao do Resumo Aglutinado por Produto.              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oReport:SetTitle(STR0015) //"V A R I A C A O   DE   U S O   E   C O N S U M O"
oReport:SetMeter(Len(aLstTrb1))
oReport:EndPage()
oSection4:Init()
aLstTrb3 := aSort(aLstTrb3,,, { | x,y | x[1] < y[1] })
For nI:=1 To Len(aLstTrb3)
	oReport:IncMeter()
	If oReport:Cancel()
		Exit
	EndIf
	oSection4:Cell("CPROD" 		):SetValue(aLstTrb3[nI,01])
	oSection4:Cell("CDESC" 		):SetValue(aLstTrb3[nI,06])
	oSection4:Cell("NQTDE" 		):SetValue(aLstTrb3[nI,02])
	oSection4:Cell("NVLTOT"		):SetValue(aLstTrb3[nI,04])
	oSection4:Cell("NQTDE2"		):SetValue(aLstTrb3[nI,03])
	oSection4:Cell("NVLTOT2"	):SetValue(aLstTrb3[nI,05])
	oSection4:Cell("NQTDE3"		):SetValue(Round(aLstTrb3[nI,02]-aLstTrb3[nI,03],nTamDecCus))
	oSection4:Cell("NVLTOT3"	):SetValue(Round(aLstTrb3[nI,04]-aLstTrb3[nI,05],nTamDecCus))
	oSection4:Cell("NPERCTOT"	):SetValue( (oSection4:Cell("NQTDE3"):GetValue() / aLstTrb3[nI,03]) * 100  )	
	oSection4:PrintLine()
	oReport:ThinLine() //-- Impressao de Linha Simples
Next
oSection4:Finish()
Return NIL


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ MATR450R3³ Autor ³ Erike Yuri da Silva   ³ Data ³14/03/2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Relacao Consumo Real x Standard.                           ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ MATR450(void)                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ BOPS ³  Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Marcos V.   ³19/09/06³      ³Revisao Geral- Release 3 e Release 4      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Descri‡…o ³ PLANO DE MELHORIA CONTINUA                     MATR450.PRX ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ITEM PMC  ³ Responsavel              ³ Data         |BOPS:             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³      01  ³Marcos V. Ferreira        ³ 15/08/2006   |00000104629       ³±±
±±³      02  ³Erike Yuri da Silva       ³ 29/05/2006   |00000100155       ³±±
±±³      03  ³Erike Yuri da Silva       ³ 17/05/2006   |00000099108       ³±±
±±³      04  ³Ricardo Berti             ³ 18/08/2006   |00000104995       ³±±
±±³      05  ³Erike Yuri da Silva       ³ 17/05/2006   |00000099108       ³±±
±±³      06  ³Marcos V. Ferreira        ³ 15/08/2006   |00000104629       ³±±
±±³      07  ³Flavio Luiz Vicco         ³ 30/06/2006   |00000101303       ³±±
±±³      08  ³Ricardo Berti             ³ 18/08/2006   |00000104995       ³±±
±±³      09  ³Erike Yuri da Silva       ³ 29/05/2006   |00000100155       ³±±
±±³      10  ³Flavio Luiz Vicco         ³ 30/06/2006   |00000101303       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/	
User Function ELR450R3()
Local wnrel
Local tamanho := "G"
Local titulo  := AllTrim(STR0001)	//"Consumo Real x Standard"
Local cDesc1  := STR0002			//"Este programa ira imprimir a relacao de "
Local cDesc2  := STR0003			//"Consumo Real x Standard.                "
Local cDesc3  := ""
Local cString := "SB1"
Local lRet	  := .T.

Private aReturn    := {OemToAnsi(STR0004), 1,OemToAnsi(STR0005), 1, 2, 1, "",1 }		//"Zebrado"###"Administracao"
Private cPerg      := "MTR451"
Private nLastKey   := 0 
Private nTamDecQtd := TamSX3("D3_QUANT")[2]
Private nTamDecCus := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Funcao utilizada para verificar a ultima versao dos fontes      ³
//³ SIGACUS.PRW, SIGACUSA.PRX e SIGACUSB.PRX, aplicados no rpo do   |
//| cliente, assim verificando a necessidade de uma atualizacao     |
//| nestes fontes. NAO REMOVER !!!							        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !(FindFunction("SIGACUS_V") .And. SIGACUS_V() >= 20050512)
	Aviso(STR0033,STR0034 + " SIGACUS.PRW !!!",{"Ok"}) //"Atualizar patch do programa SIGACUS.PRW"
	lRet := .F.
EndIf
If lRet .And. !(FindFunction("SIGACUSA_V") .And. SIGACUSA_V() >= 20050512)
	Aviso(STR0033,STR0034 + " SIGACUSA.PRX !!!",{"Ok"}) //"Atualizar patch do programa SIGACUSA.PRX"
	lRet := .F.
EndIf
If lRet .And. !(FindFunction("SIGACUSB_V") .And. SIGACUSB_V() >= 20050910)
	Aviso(STR0033,STR0034 + " SIGACUSB.PRX !!!",{"Ok"}) //"Atualizar patch do programa SIGACUSB.PRX"
	lRet := .F.
EndIf

If lRet
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Variaveis utilizadas para Impressao do Cabecalho e Rodape    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	li       := 80
	m_pag    := 1
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica as perguntas selecionadas                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	AjustaSX1()
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Variaveis utilizadas para parametros                         ³
	//³ mv_par01    // Listagem por Ordem de Producao ou Produto.    ³
	//³ mv_par02    // Listagem Sintetica ou Analitica.              ³
	//³ mv_par03    // De                                            ³
	//³ mv_par04    // Ate                                           ³
	//³ mv_par05    // Custo do Consumo Real 1...6 ( Moeda )         ³
	//³ mv_par06    // Custo do Consumo Std  1...6                   ³
	//³ mv_par07    // Movimentacao De                               ³
	//³ mv_par08    // Movimentacao Ate                              ³
	//³ mv_par09    // Calcular Pela Estrutura / Empenho             ³
	//³ mv_par10    // Aglutina por Produto.                         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Pergunte("MTR451",.F.)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Envia controle para a funcao SETPRINT                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	wnrel:="MATR450" //Nome Default do relatorio em Disco
	
	wnrel:=SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,"",.F.,Tamanho)
	
	If nLastKey = 27
		dbClearFilter()
	Else

		SetDefault(aReturn,cString)

		RptStatus({|lEnd| C450Imp(@lEnd,tamanho,titulo,wnRel,cString)},titulo)

	EndIf

EndIf
	
Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ C450IMP  ³ Autor ³ Rodrigo de A. Sartorio³ Data ³ 11.12.95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Chamada do Relatorio                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR450	  		                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function C450Imp(lEnd,tamanho,titulo,wnRel,cString)
Local cAnt       := ""
Local cbCont     := 0
Local aTam       := {}
Local nQuantG1   := 0
Local CbTxt      := Space(10)
Local nomeprog   := "MATR450"
Local cPicD3C114 := PesqPict("SD3","D3_CUSTO1",14)
Local cPicD3C116 := PesqPict("SD3","D3_CUSTO1",16)
Local cPicD3C118 := PesqPict("SD3","D3_CUSTO1",18)
Local aAreaD3    := SD3->(GetArea())
Local aRetSD3    := {} // Variavel que recebe conteudo de controle das validacoes das RE's Fantasma
Local cOpAnt     := ""
Local lOpConf    := .T.
Local aRecnoD4   := {}
Local cCondFiltr := ""
Local nPosTrb1   := 0
Local nPosTrb2   := 0
Local nPosTrb3   := 0
Local cabec1
Local cabec2
Local nI

Private aLstTrb1  := {}
Private aLstTrb2  := {}
Private aLstTrb3  := {}
Private lQuery    := .F.
Private cAliasNew := "SD3"

aTam        := TamSX3("D3_CUSTO1")
nTamIntCus  := aTam[1]
nTamDecCus  := aTam[2]
cCondFiltr  := aReturn[7]

If Empty(cCondFiltr)
	cCondFiltr := ".T."
EndIf

dbSelectArea("SB1")
dbClearFilter()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Corre SD3 para gerar registro de trabalho.	                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SD3")
dbSetOrder(6)

#IFDEF TOP
	If TcSrvType()<>"AS/400"
		lQuery    := .T.
		cAliasNew := CriaTrab(NIL,.F.)
		cQuery := "SELECT SD3.* ,R_E_C_N_O_ D3REC "
		cQuery += " FROM "+RetSqlName("SD3")+" SD3 "
		cQuery += " WHERE SD3.D3_FILIAL='"+xFilial("SD3")+"' AND "
		cQuery += " SD3.D3_OP <> '"+Space(Len(SD3->D3_OP))+"' AND "
		cQuery += " SD3.D3_CF <> 'ER0' AND SD3.D3_CF <> 'ER1' AND "
		cQuery += " SD3.D3_EMISSAO >= '" + DTOS(mv_par07) + "' AND "
		cQuery += " SD3.D3_EMISSAO <= '" + DTOS(mv_par08) + "' AND "
		cQuery += " SD3.D3_ESTORNO = ' ' AND "
		cQuery += " SD3.D_E_L_E_T_ = ' ' "
		cQuery += " ORDER BY "+SqlOrder(SD3->(IndexKey()))
		cQuery := ChangeQuery(cQuery)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasNew,.T.,.T.)
		aEval(SD3->(dbStruct()), {|x| If(x[2] <> "C", TcSetField(cAliasNew,x[1],x[2],x[3],x[4]),Nil)})
	EndIf
#ENDIF

SetRegua(SD3->(RecCount())) // Total de Elementos da regua

If !lQuery
	SD3->( dbSeek(xFilial("SD3")+DTOS(mv_par07), .T.) )
EndIf

While (cAliasNew)->( !Eof() .And. If(lQuery,.T.,D3_FILIAL == xFilial("SD3") .And. D3_EMISSAO <= mv_par08) )

	IncRegua()

	If !lQuery 
		If (cAliasNew)->D3_ESTORNO == "S" .Or. Empty( (cAliasNew)->D3_OP ) .Or. ;
			(cAliasNew)->D3_CF == 'ER0' .Or. (cAliasNew)->D3_CF == 'ER1'
			(cAliasNew)->(DbSkip())
			Loop
		EndIf	
	EndIf

	//-- Posiciona tabela SB1
	If SB1->(B1_FILIAL+B1_COD)#(xFilial("SB1")+(cAliasNew)->D3_COD)
		SB1->( dbSeek(xFilial("SB1")+(cAliasNew)->D3_COD) )
	EndIf

	//-- Posiciona tabela SC2
	If SC2->(C2_FILIAL+C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD)#(xFilial("SC2")+(cAliasNew)->D3_OP)
		SC2->( dbSeek(xFilial("SC2")+(cAliasNew)->D3_OP) )
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Le requisicoes e devolucoes SD3 e grava no Array aLstTrb1 para gravacao do REAL  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If SubStr((cAliasNew)->D3_CF,2,1)$"E" .And. IIf(lQuery,.T.,!Empty((cAliasNew)->D3_OP))

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Ordem de Producao / Produto                                  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If mv_par01 == 1
			nPosTrb1 := aScan(aLstTrb1,{|x| x[2]+x[1]==(cAliasNew)->D3_OP+(cAliasNew)->D3_COD})
		Else
			If mv_par10 == 1
				nPosTrb1 := aScan(aLstTrb1,{|x| x[7]+x[1]==SC2->C2_PRODUTO+(cAliasNew)->D3_COD})
			Else
				nPosTrb1 := aScan(aLstTrb1,{|x| x[7]+x[1]+x[2]==SC2->C2_PRODUTO+(cAliasNew)->D3_COD+SC2->(C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD)})
			EndIf
		EndIf

		If Empty(nPosTrb1)
			aAdd(aLstTrb1,{	(cAliasNew)->D3_COD,;						//01 - PRODUTO
							(cAliasNew)->D3_OP,	;	 					//02 - OP
							(cAliasNew)->D3_NUMSEQ,	; 					//03 - NUMSEQ
							R450TRT("RE"),;						 		//04 - TRT
							(cAliasNew)->D3_CHAVE,;		 				//05 - CHAVE
							(cAliasNew)->D3_EMISSAO,;					//06 - EMISSAO
							SC2->C2_PRODUTO,;			 				//07 - PAI
							"",	;							 			//08 - FIXVAR
							R450Qtd("R",0,cAliasNew),; 					//09 - QTDREAL
							0,;						 					//10 - QTDSTD
							0,;						 					//11 - QTDVAR
							0,;						 					//12 - CUSTOSTD
							R450Cus('R', mv_par05,,cAliasNew),;			//13 - CUSTOREAL
							0	})						  				//14 - CUSTOVAR
		Else
			aLstTrb1[nPosTrb1,03] := (cAliasNew)->D3_NUMSEQ 			// 03 - NUMSEQ
			aLstTrb1[nPosTrb1,04] := R450TRT("RE")			 			// 04 - TRT 
			aLstTrb1[nPosTrb1,05] := (cAliasNew)->D3_CHAVE				// 05 - CHAVE
			aLstTrb1[nPosTrb1,06] := (cAliasNew)->D3_EMISSAO			// 06 - EMISSAO	
			aLstTrb1[nPosTrb1,09] += R450Qtd("R",0,cAliasNew)         	// 09 - QTDREAL
			aLstTrb1[nPosTrb1,13] += R450Cus('R', mv_par05,,cAliasNew)	// 13 - CUSTOREAL
		EndIf
	
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Le producoes e grava aLstTrb2 para gravacao do STANDARD      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If SubStr((cAliasNew)->D3_CF,1,2)$"PR" 
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Considera filtro de Usuario                                  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !( SB1->( dbSeek(xFilial("SB1")+(cAliasNew)->D3_COD)  .And. &(cCondFiltr) ) )
			(cAliasNew)->(dbSkip())
			Loop
		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Lista por Ordem de Producao / Produto                        ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If mv_par01 == 1
			nPosTrb2 := aScan(aLstTrb2,{|x|x[2]==(cAliasNew)->D3_OP})
		Else
			nPosTrb2 := aScan(aLstTrb2,{|x|x[1]==(cAliasNew)->D3_COD})
		EndIf

		If Empty(nPosTrb2)
			aAdd(aLstTrb2,Array(4))
			nPosTrb2 := Len(aLstTrb2)
			aLstTrb2[nPosTrb2,4] := 0
		EndIf

		aLstTrb2[nPosTrb2,1] := (cAliasNew)->D3_COD
		aLstTrb2[nPosTrb2,2] := (cAliasNew)->D3_OP
		aLstTrb2[nPosTrb2,3] := (cAliasNew)->D3_UM
		aLstTrb2[nPosTrb2,4] += (cAliasNew)->D3_QUANT

		cProduto := (cAliasNew)->D3_COD

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Calcular pela Estrutura                                      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If mv_par09 == 1
			dbSelectArea("SG1")
			dbSetOrder(1)
			dbSeek(xFilial("SG1")+cProduto)
			While !Eof() .And. xFilial("SG1")+cProduto == G1_FILIAL + G1_COD
				If G1_INI > dDataBase .Or. G1_FIM < dDataBase
					dbSelectArea("SG1")
					dbSkip()
					Loop
				EndIf
				dbSelectArea("SB1")
				MsSeek(xFilial("SB1")+(cAliasNew)->D3_COD)
				If SG1->G1_FIXVAR == "F"
					nQuantG1 := SG1->G1_QUANT
					If (cAliasNew)->D3_PARCTOT == 'P'
						nQuantG1 := Round(nQuantG1*IIf(SC2->(C2_QUJE==C2_QUANT),1,SC2->(C2_QUJE/C2_QUANT)),nTamDecQtd)
					EndIf
				Else
					nQuantG1 := ExplEstr((cAliasNew)->D3_QUANT,,SC2->C2_OPC)
				EndIf

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Se Produto for FANTASMA gravar so os componentes.            ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If RetFldProd(SB1->B1_COD,"B1_FANTASM") == "S" // Projeto Implementeacao de campos MRP e FANTASM no SBZ
					R450Fant( nQuantG1 )
				Else
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Gravar Valores da Producao em TRB.                           ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					dbSelectArea("SB1")
					dbSeek(xFilial("SB1")+SG1->G1_COMP)
					If Found()
						If mv_par01 == 1
							nPosTrb1 := aScan(aLstTrb1,{|x| x[2]+x[1]==(cAliasNew)->D3_OP+SG1->G1_COMP})
						Else
							If mv_par10 == 1
								nPosTrb1 := aScan(aLstTrb1,{|x| x[7]+x[1]==SC2->C2_PRODUTO+SG1->G1_COMP})
							Else
								nPosTrb1 := aScan(aLstTrb1,{|x| x[7]+x[1]+x[2]==SC2->C2_PRODUTO+SG1->G1_COMP+SC2->(C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD)})
							EndIf
						EndIf

						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Valida Requesicoes do mesmo componente para a mesma estrutura ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						If !Empty(nPosTrb1) .And. !Empty(aLstTrb1[nPosTrb1,4])
							aRetSD3 := R450TRT("PR",nPosTrb1)
						Else
							aRetSD3 := {"",0,.F.}
						EndIf

						If Empty(nPosTrb1)
							aAdd(aLstTrb1,Array(14))
							nPosTrb1 := Len(aLstTrb1)
							aLstTrb1[nPosTrb1,01] := SG1->G1_COMP
							aLstTrb1[nPosTrb1,02] := (cAliasNew)->D3_OP
							aLstTrb1[nPosTrb1,09] := 0
							aLstTrb1[nPosTrb1,10] := 0
							aLstTrb1[nPosTrb1,11] := 0
							aLstTrb1[nPosTrb1,12] := 0
							aLstTrb1[nPosTrb1,13] := 0
							aLstTrb1[nPosTrb1,14] := 0
						EndIf
						aLstTrb1[nPosTrb1,04] := aRetSD3[1]
						aLstTrb1[nPosTrb1,07] := cProduto
						aLstTrb1[nPosTrb1,08] := SG1->G1_FIXVAR
						aLstTrb1[nPosTrb1,10] += Round(nQuantG1,nTamDecQtd)
						aLstTrb1[nPosTrb1,12] += R450Cus("S",mv_par06,Round(nQuantG1,nTamDecCus))

						If aRetSD3[3] .And. !lQuery
							(cAliasNew)->( dbGoTo(aRetSD3[2]) )
						EndIf

					EndIf

				EndIf

				dbSelectArea("SG1")
				dbSkip()
			EndDo
			
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Calcular pelo Empenho                                        ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		Else

			dbSelectArea("SD4")
			dbSetOrder(2)
			dbSeek(xFilial("SD4")+(cAliasNew)->D3_OP)
			If (cAliasNew)->D3_OP # cOpAnt
				lOpConf:=.T.
			Else
				lOpConf:=.F.
			EndIf

			While SD4->(!Eof() .And. D4_FILIAL + D4_OP == xFilial("SD4")+(cAliasNew)->D3_OP ) .And. cOpAnt # (cAliasNew)->D3_OP .And. lOpConf

				If aScan(aRecnoD4, SD4->(RecNo())) > 0
					dbSkip()
					Loop
				EndIf

				aAdd(aRecnoD4, SD4->(RecNo()))

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Gravar Valores da Producao em TRB.                           ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				dbSelectArea("SB1")
				dbSeek(xFilial("SB1")+SD4->D4_COD)
				If mv_par01 == 1
					nPosTrb1 := aScan(aLstTrb1,{|x|x[2]+x[1]==(cAliasNew)->D3_OP+SD4->D4_COD})
				Else
					If mv_par10 == 1
						nPosTrb1 := aScan(aLstTrb1,{|x|x[7]+x[1]==SC2->C2_PRODUTO+SD4->D4_COD}) 
					Else
						nPosTrb1 := aScan(aLstTrb1,{|x|x[7]+x[1]+x[2]==SC2->C2_PRODUTO+SD4->D4_COD+SC2->(C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD)})  
					EndIf   
				EndIf	
					
				If Empty(nPosTrb1)
					aAdd(aLstTrb1,Array(14))
					nPosTrb1 := Len(aLstTrb1)
					aLstTrb1[nPosTrb1,01] := SD4->D4_COD
					aLstTrb1[nPosTrb1,02] := (cAliasNew)->D3_OP
					aLstTrb1[nPosTrb1,09] := 0
					aLstTrb1[nPosTrb1,10] := 0
					aLstTrb1[nPosTrb1,11] := 0
					aLstTrb1[nPosTrb1,12] := 0
					aLstTrb1[nPosTrb1,13] := 0
					aLstTrb1[nPosTrb1,14] := 0
				EndIf
				aLstTrb1[nPosTrb1,07] := cProduto
				aLstTrb1[nPosTrb1,08] := ""

				If Empty(SD4->D4_QUANT)
					aLstTrb1[nPosTrb1,10] += Round(SD4->D4_QTDEORI*IIf(SC2->(C2_QUJE==C2_QUANT),1,SC2->(C2_QUJE/C2_QUANT)),nTamDecQtd)
				Else
					aLstTrb1[nPosTrb1,10] += Round((SD4->D4_QTDEORI-SD4->D4_QUANT),nTamDecQtd)
				EndIf
					aLstTrb1[nPosTrb1,12] += R450Cus("S",mv_par06, Round((SD4->D4_QTDEORI-SD4->D4_QUANT),nTamDecQtd))//aLstTrb1[nPosTrb1,10])
				
				dbSelectArea("SD4")
				dbSkip()
				
			EndDo
			cOpAnt := (cAliasNew)->D3_OP
		EndIf
		dbSelectArea(cAliasNew)
	EndIf

	dbSkip()

EndDo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta os Cabecalhos                                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cProduto := ""
cabec1   :=STR0007	//"CODIGO           M A T E R I A L                  |              C O N S U M O  R E A L              |           C O N S U M O  S T A N D A R D         |                          V A R I A C A O 	                      "
cabec2   :=STR0008	//"                 DESCRICAO                     UM |      QUANTIDADE      CUSTO UN.       VALOR TOTAL |      QUANTIDADE      CUSTO UN.       VALOR TOTAL |     QUANTIDADE     VALOR TOTAL          $QTD.    $VALOR         %  "
//                     123456789012345  12345678901234567890123456789 12    1234567890123  12345678901234    12345678901234    1234567890123  12345678901234    12345678901234   123456789012    12345678901234 12345678901234  123456789012 1234567
//                                                                         123456789012345                 1234567890123456   123456789012345                 1234567890123456  123456789012345                                1234567890123
//                               1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17         18       19        20        21        22
//                     01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
cabec3   := ""
titulo   += IIf( mv_par01 == 1, STR0009,STR0010 )		//" ( Por Ordem de Producao )"###" ( Por Produto )"

SetRegua(Len(aLstTrb1))		// Total de Elementos da regua

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Ordena por Ordem de Producao/Produto                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If mv_par01 == 1
	aLstTrb1 := ASort(aLstTrb1,,, { | x,y | x[2]+x[1] < y[2]+y[1] })
Else
	aLstTrb1 := ASort(aLstTrb1,,, { | x,y | x[7]+x[1] < y[7]+y[1] })
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicio da Impressao                                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nQuantOp := 0.00

For nI:=1 To Len(aLstTrb1)

	IncRegua()

	If lEnd
		@Prow()+1,001 PSAY STR0011		//"CANCELADO PELO OPERADOR"
		Exit
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Filtro por OP / Produto                                      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If mv_par01 == 1
		// Filtrar por OP
		If AllTrim(aLstTrb1[nI,2]) < AllTrim(mv_par03) .Or. AllTrim(aLstTrb1[nI,2]) > AllTrim(mv_par04)
           Loop
		EndIf
	Else
		// Filtrar por Produto Pai
		If aLstTrb1[nI,7] < mv_par03 .Or. aLstTrb1[nI,7] > mv_par04
			Loop	
		EndIf
	EndIf

	If li > 55 .And. mv_par02 == 1
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)
		li-= 2
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Impressao por OP e PRODUTO                               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If mv_par01 = 1
		nPosTrb2 := aScan(aLstTrb2,{|x| x[2]==aLstTrb1[nI,2]})
	Else
		nPosTrb2 := aScan(aLstTrb2,{|x| x[1]==aLstTrb1[nI,7]})	
	EndIf

	If Empty(nPosTrb2)
		Loop
	EndIf

	If mv_par02 == 1
		R450Linha(@li,.F.)
		li++
		@ li,000 PSAY If(mv_par01=1,STR0036+aLstTrb2[nPosTrb2,2],STR0035) //"OP: "###"PRODUTO:"
		@ li,017 PSAY Left(aLstTrb2[nPosTrb2,1],29)
		@ li,047 PSAY aLstTrb2[nPosTrb2,3]
		@ li,050 PSAY "|"
		@ li,052 PSAY aLstTrb2[nPosTrb2,4] PICTURE PesqPict("SC2","C2_QUANT",15)
		@ li,101 PSAY "|"
		@ li,152 PSAY "|"
		li++
		If mv_par01 == 2
			@ li,017 PSAY Substr(Posicione("SB1",1,xFilial("SB1")+PADR(aLstTrb2[nPosTrb2,1],15),"B1_DESC"),1,30)
		Endif
		@ li,050 PSAY "|"
		@ li,101 PSAY "|"
		@ li,152 PSAY "|"
		nQuantOp := aLstTrb2[nPosTrb2,4]
	EndIf

	nCusStdOP := nTotStdOP := nCusRealOP := nTotRealOP := nTotVarOP := 0
	nCusUnitR := nCusUnitS := 0
	cAnt := IIf( mv_par01 == 1,aLstTrb1[nI,02],aLstTrb1[nI,07])
	While nI <= Len(aLstTrb1) .And. IIf( mv_par01 == 1,aLstTrb1[nI,2],aLstTrb1[nI,7]) == cAnt

		If li > 58 .And. mv_par02 == 1
			cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)
		EndIf

		nTotalVar  := aLstTrb1[nI,13]-aLstTrb1[nI,12]  //CUSTOREAL-CUSTOSTD
		nQtdVar    := aLstTrb1[nI,09]-aLstTrb1[nI,10]	//QTDREAL-QTDSTD
		nPercent   := (nQtdVar/aLstTrb1[nI,10])*100	//((QTDREAL-QTDSTD)/QTDSTD)*100
		nCusUnit   := IIf(Empty(aLstTrb1[nI,09]),aLstTrb1[nI,13],Round(aLstTrb1[nI,13]/aLstTrb1[nI,09],nTamDecCus))	//Round(CUSTOREAL/IIF(QTDREAL=0,1,QTDREAL),nTamDecCus)
		nCusUStd   := IIf(Empty(aLstTrb1[nI,10]),aLstTrb1[nI,12],Round(aLstTrb1[nI,12]/aLstTrb1[nI,10],nTamDecCus))	//Round(CUSTOSTD/IIF(QTDSTD=0,1,QTDSTD),nTamDecCus)
		nSValor    := Round(nCusUnit*nQtdVar,nTamDecCus)
		nSQuant    := Round(nTotalVar-nSValor,nTamDecCus)

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Posiciona na tabela de PRODUTOS                          ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		SB1->(DbSetOrder(1))
		SB1->(dbSeek(xFilial("SB1")+aLstTrb1[nI,01]))	

		If mv_par02 == 1 .And. (mv_par09 == 1 .Or. (QtdComp(aLstTrb1[nI,09],.T.) # QtdComp(0,.T.)))
			li++
			@ li,000 PSAY aLstTrb1[nI,01]
			@ li,016 PSAY Pad(SB1->B1_DESC,29)
			@ li,047 PSAY SB1->B1_UM
			@ li,050 PSAY "|"
			@ li,052 PSAY aLstTrb1[nI,09]	PICTURE PesqPict("SD3","D3_QUANT",15)
			@ li,068 PSAY nCusUnit 			PICTURE cPicD3C114
			@ li,084 PSAY aLstTrb1[nI,13]	PICTURE cPicD3C116
			@ li,101 PSAY "|"
			@ li,103 PSAY aLstTrb1[nI,10]	PICTURE PesqPict("SD3","D3_QUANT",15)
			@ li,119 PSAY nCusUStd			PICTURE cPicD3C114
			@ li,135 PSAY aLstTrb1[nI,12]  	PICTURE cPicD3C116
			@ li,152 PSAY "|"
			@ li,153 PSAY nQtdVar		PICTURE PesqPict("SD3","D3_QUANT",15)
			@ li,167 PSAY nTotalVar 	PICTURE cPicD3C114
			@ li,181 PSAY nSValor		PICTURE cPicD3C114
			@ li,197 PSAY nSQuant		PICTURE PesqPict("SD3","D3_QUANT",13)
			@ li,211 PSAY nPercent		PICTURE "9999.99"
		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Aglutinar Produto para Posterior Resumo.                 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nPosTrb3 := aScan(aLstTrb3,{|x|x[1]==aLstTrb1[nI,1]})
		If Empty(nPosTrb3)
			aAdd(aLstTrb3,{	aLstTrb1[nI,01],; //PRODUTO
							aLstTrb1[nI,09],; //QTDREAL
							aLstTrb1[nI,10],; //QTDSTD
							aLstTrb1[nI,13],; //CUSTOREAL
							aLstTrb1[nI,12],; //CUSTOSTD
							SB1->B1_DESC})	   //DESCRICAO
		Else
			aLstTrb3[nPosTrb3,02] += aLstTrb1[nI,09] //QTDREAL
			aLstTrb3[nPosTrb3,03] += aLstTrb1[nI,10] //QTDSTD
			aLstTrb3[nPosTrb3,04] += aLstTrb1[nI,13] //CUSTOREAL
			aLstTrb3[nPosTrb3,05] += aLstTrb1[nI,12] //CUSTOSTD
		EndIf

		nCusUnitR  += nCusUnit
		nCusUnitS  += nCusUStd
		nTotRealOP += aLstTrb1[nI,13]
		nTotStdOP  += aLstTrb1[nI,12]
		nTotVarOP  += nTotalVar
		nI++
		If nI > Len(aLstTrb1) .Or. IIF( mv_par01 == 1,aLstTrb1[nI,2],aLstTrb1[nI,7]) # cAnt
			nI--
			Exit
		EndIf
	EndDo
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Impressao dos Totais por OP/Produto.                     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If mv_par02 == 1
		R450Linha(@li,.T.)
		li++
		@ li,000 PSAY STR0012 +IIF(mv_par01==1,STR0013,STR0014)		//"Total "###"da OP:"###"do Produto:"
		@ li,050 PSAY "|"
		@ li,066 PSAY (nTotRealOP/nQuantOp)	PICTURE cPicD3C116
		@ li,082 PSAY nTotRealOP	        PICTURE cPicD3C118
		@ li,101 PSAY "|"
		@ li,117 PSAY (nTotStdOP/nQuantOp)	PICTURE cPicD3C116
		@ li,133 PSAY nTotStdOP            	PICTURE cPicD3C118
		@ li,152 PSAY "|"
		@ li,164 PSAY nTotVarOP 	       	PICTURE cPicD3C118
		R450Linha(@li,.T.)
	EndIf
Next

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impressao do Resumo Aglutinado por Produto.              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
li := 80

titulo := STR0015		//"V A R I A C A O   DE   U S O   E   C O N S U M O"
cabec1 := ""
cabec2 := ""
cabec3 := ""
//cLinha := "|-----------------------------------------------------------|"
//cLinha += "|-------------------|------------------|--------------------|"
//cLinha += "|-------------------|------------------|--------------------|"
cLinha := __PrtThinLine()

SetRegua(Len(aLstTrb3))		// Total de Elementos da regua

aLstTrb3 := aSort(aLstTrb3,,, { | x,y | x[1] < y[1] })

For nI:=1 To Len(aLstTrb3)

	IncRegua()

	If lEnd
		@Prow()+1,001 PSAY STR0011		//"CANCELADO PELO OPERADOR"
		Exit
	EndIf

	If li > 58
		R450CabRes(titulo,cabec1,cabec2,nomeprog,tamanho)
	EndIf

	@ li,000 PSAY "|"
	@ li,003 PSAY aLstTrb3[nI,01]
	@ li,021 PSAY Pad(aLstTrb3[nI,06],29)
	@ li,056 PSAY "|"
	@ li,058 PSAY aLstTrb3[nI,02]	 PICTURE PesqPict("SD3","D3_QUANT",16)
	@ li,075 PSAY "|"
	@ li,077 PSAY aLstTrb3[nI,04]	 PICTURE cPicD3C118
	@ li,096 PSAY "|"
	@ li,098 PSAY aLstTrb3[nI,03]	 PICTURE PesqPict("SD3","D3_QUANT",16)
	@ li,115 PSAY "|"
	@ li,117 PSAY aLstTrb3[nI,05]	 PICTURE cPicD3C118
	@ li,136 PSAY "|"
	@ li,138 PSAY Round(aLstTrb3[nI,02]-aLstTrb3[nI,03],nTamDecCus) PICTURE PesqPict("SD3","D3_QUANT",16)
	@ li,155 PSAY "|"
	@ li,157 PSAY Round(aLstTrb3[nI,04]-aLstTrb3[nI,05],nTamDecCus)	 PICTURE cPicD3C118
	@ li,176 PSAY "|"
	@ li,188 PSAY (Round(aLstTrb3[nI,02]-aLstTrb3[nI,03],nTamDecCus) / aLstTrb3[nI,03]) * 100 PICTURE "9999.99" //-- Percentual 
	@ li,197 PSAY "|"	
	li++
	@ li,000 PSAY cLinha
	li++
Next

If li != 80
	roda(cbcont,cbtxt,"G")
EndIf

If aReturn[5] = 1
	Set Printer To
	dbCommitall()
	ourspool(wnrel)
EndIf

dbSelectArea("SB1")
RetIndex("SB1")
dbClearFilter()
dbSetOrder(1)

If lQuery
	dbSelectArea(cAliasNew)
	dbCloseArea()
	dbSelectArea("SD3")
EndIf

RestArea(aAreaD3)
MS_FLUSH()
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ R450Linha³ Autor ³ Jose Lucas            ³ Data ³ 21.09.93 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprimir caracteres barra e ifens como separadores.        ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ MATR450(void)                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
Static Function R450Linha(li,nImpTraco)
Local cLinha
li++
If nImpTraco
	//cLinha := "--------------------------------------------------|"
	//cLinha += "--------------------------------------------------|"
	//cLinha += "--------------------------------------------------|"
	//cLinha += "---------------------------------------------------"
	cLinha := __PrtThinLine()
Else
	cLinha := "                                                  |"
	cLinha += "                                                  |"
	cLinha += "                                                  |"
EndIf
@ li,000 PSAY cLinha
Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ R450CabRes³ Autor ³ Jose Lucas           ³ Data ³ 21.09.93 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Impressao do Cabecalho do Resumo.                          ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ R450CabRes(void)                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR450                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
Static Function R450CabRes(titulo,cabec1,cabec2,nomeprog,tamanho)
cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)
@ li,000 PSAY __PrtThinLine()
li++
@ li,000 PSAY STR0017		//"|                                                       |        C O N S U M O  R E A L         |    C O N S U M O  S T A N D A R D     |            V A R I A C A O            |"
li++
@ li,000 PSAY STR0018		//"|  CODIGO            DESCRICAO                          |---------------------------------------|---------------------------------------|---------------------------------------|"
li++
@ li,000 PSAY STR0019		//"|                                                       |      QUANTIDADE  |             VALOR  |      QUANTIDADE  |             VALOR  |      QUANTIDADE  |             VALOR  |"
li++
@ li,000 PSAY __PrtFatLine()
li++
Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ R450Cus   ³ Autor ³ Erike Yuri da Silva  ³ Data ³14/03/2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Retorna o Custo.                                           ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ ExpN1 := R450Cus(ExpC1,ExpN2,ExpN3)                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 := Tipo "S" para Standard e "R" para Real            ³±±
±±³          ³ ExpC1 := Tipo "S" para Standard e "R" para Real            ³±±
±±³          ³ ExpN2 := Indica a Moeda para obtencao do Custo             ³±±
±±³          ³ ExpN3 := Quantidade utilizada.                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR450                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±*/
Static Function R450Cus(cTipo,nMoeda,nQtd,cAliasSD3)

Local aAreaAnt  := GetArea()
Local nRet      := 0

Default cAliasSD3 := "SD3"
Default nQtd      := 0

If cTipo = "R" 	// Custo Real
	nRet := (cAliasSD3)->( &("D3_CUSTO"+ Str(nMoeda,1)) ) * IIf(SubStr((cAliasSD3)->D3_CF, 1, 1) == 'R', 1, -1)
Else  // Custo Standard
	dbSelectArea("SB1")
	nRet := (nQtd*xMoeda(RetFldProd(SB1->B1_COD,"B1_CUSTD"),Val(RetFldProd(SB1->B1_COD,"B1_MCUSTD")), nMoeda, RetFldProd(SB1->B1_COD,"B1_DATREF") ))
EndIf

RestArea(aAreaAnt)
Return (nRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ R450Fant  ³ Autor ³ Cesar Eduardo Valadao³ Data ³ 01.06.99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Retorna a Estrutura de Produto Fantasma                    ³±±
±±³          ³ Funcao Recursiva.                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ R450Fant(ExpN1)                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpN1 := Quantidade do Pai.                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR450                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
Static Function R450Fant(nQuantPai)
Local aAreaAnt  := GetArea()
Local aAreaSB1  := SB1->(GetArea())
Local aAreaSG1  := SG1->(GetArea())
Local cComponen := SG1->G1_COMP
Local nPosTrb1  := 0
Local nPosTrb2  := 0

dbSelectArea("SG1")
If dbSeek(xFilial("SG1")+cComponen, .F.)
	While !Eof() .And. G1_FILIAL+G1_COD == xFilial("SG1")+cComponen
		If G1_INI > dDataBase .Or. G1_FIM < dDataBase
			dbSkip()
			Loop
		EndIf
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Gravar Valores da Producao em TRB do componente.             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("SB1")
		If dbSeek(xFilial("SB1")+SG1->G1_COMP)
			If SG1->G1_FIXVAR == "F"
				nQuantG1 := SG1->G1_QUANT
			Else
				nQuantG1 := ExplEstr(nQuantPai,,SC2->C2_OPC)
			EndIf
			If mv_par01 == 1
				nPosTrb1 := aScan(aLstTrb1,{|x| x[2]+x[1]==(cAliasNew)->D3_OP+SG1->G1_COMP})
			Else
				If mv_par10 == 1
					nPosTrb1 := aScan(aLstTrb1,{|x| x[7]+x[1]==SC2->C2_PRODUTO+SG1->G1_COMP})
				Else
					nPosTrb1 := aScan(aLstTrb1,{|x| x[7]+x[1]+x[2]==SC2->C2_PRODUTO+SG1->G1_COMP+SC2->(C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD)})
				EndIf				
			EndIf

			If RetFldProd(SB1->B1_COD,"B1_FANTASM") == "S" // Projeto Implementeacao de campos MRP e FANTASM no SBZ
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Se Produto for FANTASMA gravar so os componentes.            ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				R450Fant(nQuantG1 )
			Else
				If !Empty(nPosTrb1) .And. !Empty(aLstTrb1[nPosTrb1,04])
					aRetSD3 := R450TRT("PR",nPosTrb1)
				Else
					aRetSD3 := {"",0,.F.}
				EndIF

				If Empty(nPosTrb1)
					aAdd(aLstTrb1,Array(14))
					nPosTrb1 := Len(aLstTrb1)
					aLstTrb1[nPosTrb1,01] := SG1->G1_COMP
					aLstTrb1[nPosTrb1,02] := (cAliasNew)->D3_OP
					aLstTrb1[nPosTrb1,09] := 0
					aLstTrb1[nPosTrb1,10] := 0
					aLstTrb1[nPosTrb1,12] := 0
					aLstTrb1[nPosTrb1,13] := 0
					aLstTrb1[nPosTrb1,14] := 0
				EndIf
				aLstTrb1[nPosTrb1,04] := aRetSD3[1]
				aLstTrb1[nPosTrb1,07] := cProduto
				aLstTrb1[nPosTrb1,08] := SG1->G1_FIXVAR
				aLstTrb1[nPosTrb1,10] += Round(nQuantG1,nTamDecQtd)
				aLstTrb1[nPosTrb1,12] += R450Cus("S",mv_par06,Round(nQuantG1,nTamDecCus))

				// Volta ao Registro Original do SD3
				If aRetSD3[3] .And. ! lQuery
					(cAliasNew)->( dbGoTo(aRetSD3[2]) )
				EndIf

			EndIf
		EndIf
		dbSelectArea("SG1")
		dbSkip()
	End
EndIf
RestArea(aAreaSB1)
RestArea(aAreaSG1)
RestArea(aAreaAnt)
Return(Nil)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³AjustaSX1 ³ Autor ³ Flavio Luiz Vicco     ³ Data ³30/06/2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Cria as perguntas necesarias para o programa                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function AjustaSx1()
PutSx1('MTR451','01' , 'Relacao por?', '¿Relacion por?', 'List by ?', ;
	'mv_ch1', 'N', 1, 0, 1, 'C', '', '', '', '', 'mv_par01','Ordem Producao' , 'Orden de Prod.','Product. Order', ;
	'', 'Produto', 'Producto', 'Product', '', '', '', '', '', '', '','', '', ;
	{'Impressao do relatório na sequencia do ', 'número da OP ou Por Produto ','do cadastro de movimentos internos (SD3)'}, ;
	{'Impresion del informe ordenado por Nume-','ro de OP o por Numero de Productos del ','archivo de Movimientos Internos (SD3).  '}, ;
	{'Print the report by Production Order or ','By Product Order number order of the    ', 'internal movements file (SD3).          '}, ;
	'')                                            //-- 36 - X1_HELP

PutSx1('MTR451','02' , 'Relacao ?', '¿Relacion?', 'Report ?', ;             //-- 05 - X1_PERENG
	'mv_ch2','N', 1, 0, 1, 'C', '', '', '', '', 'mv_par02', 'Analitica' , 'Analitica', 'Detailed', ;                             			//-- 19 - X1_DEFENG1
	'', 'Sintetica', 'Sintetica','Summarized', '','', '','','', '', '', '', '', ;                                           //-- 32 - X1_DEFENG5
	{'O relatório será impresso com conteudo  ', 'analitico ou sintetico a ser considerado', ' na filtragem do cadastro de movimentos ', 'internos (SD3).                         '}, ; //--      HelpPor3#3
	{'El informe ser impreso con contenido    ', 'analitico o sintetico a ser considerado ', 'en el filtro del archivo de Movimientos ', 'Internos (SD3).                         '}, ; //--      HelpEsp3#3
	{'The report will be printed with detaile-', 'dand summarized content to be considered', ' in the filtering of internal movements ', 'file (SD3).                             '}, ; //--      HelpEng3#3
	'')                                            //-- 36 - X1_HELP
PutSx1('MTR451', '03' , 'De ? ',	'¿De ?', 'From ?', ;             //-- 05 - X1_PERENG
	'mv_ch3', 'C', 	15, 0, 0, 'G', 	'', '', '', '', 'mv_par03', '' ,'', '', Space(15), 	'', ;                   		                 //-- 21 - X1_DEF02
	'', '', '', '', '', '', '', '', '', '', '', ;                                           //-- 32 - X1_DEFENG5
	{'De Ordem Produção ou Produto inicial a  ', 'ser considerado na filtragem do cadastro', 'de movimentos internos (SD3). Depende da', ' sua escolha na primeira pergunta.      '}, ; //--      HelpPor3#3
	{'De Orden Produccion o Producto inicial a', 'ser considerado en el filtro del archivo', ' de Movimientos Internos (SD3). Depende ', 'de su eleccion en la pregunta n§ 1.     '}, ; //--      HelpEsp3#3
	{'Production Order or Initial Product to  ', 'consider in filtering the internal move-', 'ments file (SD3). It depends on         ', 'yourchoice on question no. 1.           '}, ; //--      HelpEng3#3	
	'')                                            //-- 36 - X1_HELP

PutSx1('MTR451', '04' , 'Ate ?', '¿A ?', 'To ?', ;                                                            //-- 05 - X1_PERENG
	'mv_ch4', 'C', 15, 0, 0, 'G', '', '', '', '', 'mv_par04', '' , '', '', 'ZZZZZZZZZZZZZZZ','', ;           //-- 21 - X1_DEF02
	'', '', '', '', '', '', '',	'', '', '', '', ;                                                             //-- 32 - X1_DEFENG5
	{'De Ordem Produção ou Produto final a    ', 'ser considerado na filtragem do cadastro', 'de movimentos internos (SD3). Depende da', ' sua escolha na primeira pergunta.      '}, ; //--      HelpPor3#3
	{'De Orden Produccion o Producto final  a ', 'ser considerado en el filtro del archivo', ' de Movimientos Internos (SD3). Depende ', 'de su eleccion en la pregunta n§ 1.     '}, ; //--      HelpEsp3#3
	{'Production Order or Final Product to    ', 'consider in filtering the internal move-', 'ments file (SD3). It depends on         ', 'yourchoice on question no. 1.           '}, ; //--      HelpEng3#3	
	'')

PutSx1('MTR451', '05' , 'Custo Consumo Real ?', '¿Tipo de Costo Real?', 'Real Consumpt.Cost ?', ;             //-- 05 - X1_PERENG
	'mv_ch5', 'N', 1, 0, 1, 'C', '', '', '','', 'mv_par05', 'Moeda 1' , 'Moneda 1','Currency 1', '', ;       //-- 20 - X1_CNT01
	'Moeda 2', 'Moneda 2', 'Currency 2', 'Moeda 3', 'Moneda 3', 'Currency 3', ;                               //-- 26 - X1_DEFENG3
	'Moeda 4', 'Moneda 4', 'Currency 4', 'Moeda 5', 'Moneda 5', 'Currency 5', {}, {}, {},  '')               //-- 36 - X1_HELP

PutSx1('MTR451', '06' , 'Custo Consumo STD  ?', '¿Tipo de Costo STD ?', 'Standard Cost Type ?', ;             //-- 05 - X1_PERENG
	'mv_ch6', 'N', 1, 0, 1, 'C', '', '', '', '', 'mv_par06', 'Moeda 1' , 'Moneda 1', 'Currency 1', '', ;     //-- 20 - X1_CNT01
	'Moeda 2', 'Moneda 2', 'Currency 2', 'Moeda 3', 'Moneda 3', 'Currency 3', ;                               //-- 26 - X1_DEFENG3
	'Moeda 4', 'Moneda 4', 'Currency 4', 'Moeda 5', 'Moneda 5', 'Currency 5', ;
	{}, {}, {}, '')                                            //-- 36 - X1_HELP

PutSx1('MTR451', '07' , 'Data de ?', '¿De Fecha?', 'From Date ?', ;             //-- 05 - X1_PERENG
	'mv_ch7', 'D', 8, 0, 0, 'G', '', '', '', '', 'mv_par07', '' , '', '', '01/01/06', '', '', ;                  		                 //-- 22 - X1_DEFSPA2
	'', '', '', '', '', '', '', '', '', '', ;                                           //-- 32 - X1_DEFENG5
	{'Data de movimentação inicial a ser      ', 'considerada na filtragem do cadastro    ', 'de  movimentos internos (SD3).          '}, ; //--      HelpPor3#3
	{'Fecha de movimiento inicial a ser con-  ', 'siderado en el filtro del archivo de    ', 'Movimientos Internos (SD3).             '}, ; //--      HelpEsp3#3
	{'Initial transaction date to consider in ', 'filtering the internal movements file   ', '(SD3).                                  '}, ; //--      HelpEng3#3
	'')                                            //-- 36 - X1_HELP

PutSx1('MTR451', '08' , 'Data Ate ?', '¿A Fecha?','To Date ? ', ;             //-- 05 - X1_PERENG
	'mv_ch8', 'D', 	8,	0, 	0, 'G', '', '',	'', '', 'mv_par08', '' , '','', '31/12/49', '', ;                   		                 //-- 21 - X1_DEF02
	'', '',	'','', '', '', '', '', '', '', 	'', ;                                           //-- 32 - X1_DEFENG5
	{'Data de movimentação final a ser        ', 'considerada na filtragem do cadastro    ',  'de  movimentos internos (SD3).          '}, ; //--      HelpPor3#3
	{'Fecha de movimiento final a ser conside-', 'rado en el filtro del archivo de    ', 'Movimientos Internos (SD3).             '}, ; //--      HelpEsp3#3
	{'Final transaction date to consider in   ', 'filtering the internal movements file   ', '(SD3).                                  '}, ; //--      HelpEng3#3
	'')
PutSx1('MTR451', '09' , 'Calcular Pela ?', '¿Calcular por?', 'Calculate by ?', ;             //-- 05 - X1_PERENG
	'mv_ch9', 'N', 	1, 	0, 	1, 'C', '', '', '', '',	'mv_par09', ;                                   //-- 16 - X1_VAR01
	'Estrutura' , 'Estructura', 'Structure', '', 'Empenho', 'Reserva', 'Allocation', '', ;                                           //-- 24 - X1_DEF03
	'', '', '', '', '', '', '', '', ;                                           //-- 32 - X1_DEFENG5
	{'Opção do cálculo do custo pelo Cadastro ', 'sde Estrutura do Produto (SG1) ou pelo  ', 'Cadastro de Empenhos (SD4).             '}, ; //--      HelpPor3#3
	{'Opcion del calculo del costo por el     ', 'Archivo de Estructura del Producto (SG1)', 'o por el Archivo de Reservas (SD4).     '}, ; //--      HelpEsp3#3
	{'Option for cost calculation by the Pro- ', 'duct Structure File (SG1) or by the ', 'Allocations File (SD4).               '}, ; //--      HelpEng3#3
	'')                                            //-- 36 - X1_HELP

PutSx1('MTR451', '10' , 'Aglutina por Prod. ?', '¿Agrupa por Prodc ?', 'Group by Product ?', ;//-- 05 - X1_PERENG
	'mv_cha', 'N', 	1, 	0, 	2, 'C', '', '', '', '',	'mv_par10', ; //-- 16 - X1_VAR01
	'Sim' , 'Si', 'Yes', '', 'Nao', 'No', 'No', '', ; //-- 24 - X1_DEF03
	'', '', '', '', '', '', '', '', ;                 //-- 32 - X1_DEFENG5
	{'O relatório será impresso por produto ', 'com o total aglutinado a ser ', 'considerado na filtragem do cadastro de ','movimentos internos (SD3).'}, ; //--      HelpPor3#3
	{'El informe sera impreso por producto ', 'con el total aglutinado a ser consi-', 'derado en el filtro del archivo de ','Movimientos Internos (SD3).'}, ; //--      HelpEsp3#3
	{'The report will be printed by product ', 'with the grouped total to consider in ', 'filtering the internal movements file',' (SD3).'}, ; //--      HelpEng3#3
	'')                                            //-- 36 - X1_HELP
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ R450Qtd   ³ Autor ³ Fernando Joly Siquini³ Data ³03/05/2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Retorna a Quantidade                                       ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ ExpN1 := R450Qtd(ExpC1,ExpN2,ExpN3)                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 := Tipo "R" Qtde Real, "S" Qtde Standard             ³±±
±±³          ³ ExpN2 := Quantidade Standard                               ³±±
±±³          ³ ExpC3 := Alias da tabela SD3                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR450                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±*/
Static Function R450Qtd(cTipo,nQuant,cAliasSD3)

Local aAreaAnt   := GetArea()
Local nRet       := 0

Default cAliasSD3:= "SD3"

If cTipo = "R" // Quantidade Real
	nRet := (cAliasSD3)->D3_QUANT*IIf(SubStr((cAliasSD3)->D3_CF, 1, 1)=='R', 1, -1)
Else // Quantidade Standard
	nRet := nQuant
EndIf

RestArea(aAreaAnt)
Return (nRet)
