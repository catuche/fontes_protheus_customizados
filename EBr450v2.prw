#INCLUDE "MATR450.CH"
#INCLUDE "PROTHEUS.CH"
/*/
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � MATR450 � Autor � Flavio Luiz Vicco      � Data �03/07/2006���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Relacao Consumo Real x Standard.                           ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � SIGAPCP                                                    ���
�������������������������������������������������������������������������Ĵ��
���         ATUALIZACOES SOFRIDAS DESDE A CONSTRU�AO INICIAL.             ���
�������������������������������������������������������������������������Ĵ��
���Programador � Data   � BOPS �  Motivo da Alteracao                     ���
�������������������������������������������������������������������������Ĵ��
���Marcos V.   �19/09/06�      �Revisao Geral- Release 3 e Release 4      ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function EBR450V2()
Local oReport

//������������������������������������������������������������������������Ŀ
//�Interface de impressao                                                  �
//��������������������������������������������������������������������������
oReport:= ReportDef()
oReport:PrintDialog()

Return Nil
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � ReportDef�Autor  �Flavio Luiz Vicco      �Data  �03/07/2006���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Relacao Consumo Real x Standard.                           ���
�������������������������������������������������������������������������Ĵ��
���Parametros�(Nenhum)                                                    ���
�������������������������������������������������������������������������Ĵ��
���Retorno   � oExpO1: Objeto do relatorio                                ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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

//������������������������������������������������������������������������Ŀ
//�Criacao do componente de impressao                                      �
//�                                                                        �
//�TReport():New                                                           �
//�ExpC1 : Nome do relatorio                                               �
//�ExpC2 : Titulo                                                          �
//�ExpC3 : Pergunte                                                        �
//�ExpB4 : Bloco de codigo que sera executado na confirmacao da impressao  �
//�ExpC5 : Descricao                                                       �
//�                                                                        �
//��������������������������������������������������������������������������
oReport := TReport():New("MATR450",cTitle,"MTR451",{|oReport| ReportPrint(oReport,'SD3')},STR0001) //"Consumo Real x Standard"
oReport:SetLandscape()

//��������������������������������������������������������������Ŀ
//� Ajusta o Grupo de Pergunta                                   �
//����������������������������������������������������������������
AjustaSX1()

//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros                         �
//� mv_par01    // Listagem por Ordem de Producao ou Produto.    �
//� mv_par02    // Listagem Sintetica ou Analitica.              �
//� mv_par03    // De                                            �
//� mv_par04    // Ate                                           �
//� mv_par05    // Custo do Consumo Real 1...6 ( Moeda )         �
//� mv_par06    // Custo do Consumo Std  1...6                   �
//� mv_par07    // Movimentacao De                               �
//� mv_par08    // Movimentacao Ate                              �
//� mv_par09    // Calcular Pela Estrutura / Empenho             �
//� mv_par10    // Aglutina por Produto.                         �
//����������������������������������������������������������������
Pergunte(oReport:uParam,.F.)

//������������������������������������������������������������������������Ŀ
//�Criacao da secao utilizada pelo relatorio                               �
//�                                                                        �
//�TRSection():New                                                         �
//�ExpO1 : Objeto TReport que a secao pertence                             �
//�ExpC2 : Descricao da secao                                              �
//�ExpA3 : Array com as tabelas utilizadas pela secao. A primeira tabela   �
//�        sera considerada como principal para a secao.                   �
//�ExpA4 : Array com as Ordens do relatorio                                �
//�ExpL5 : Carrega campos do SX3 como celulas                              �
//�        Default : False                                                 �
//�ExpL6 : Carrega ordens do Sindex                                        �
//�        Default : False                                                 �
//�                                                                        �
//��������������������������������������������������������������������������
//������������������������������������������������������������������������Ŀ
//�Criacao das celulas da secao do relatorio                               �
//�                                                                        �
//�TRCell():New                                                            �
//�ExpO1 : Objeto TSection que a secao pertence                            �
//�ExpC2 : Nome da celula do relatorio. O SX3 sera consultado              �
//�ExpC3 : Nome da tabela de referencia da celula                          �
//�ExpC4 : Titulo da celula                                                �
//�        Default : X3Titulo()                                            �
//�ExpC5 : Picture                                                         �
//�        Default : X3_PICTURE                                            �
//�ExpC6 : Tamanho                                                         �
//�        Default : X3_TAMANHO                                            �
//�ExpL7 : Informe se o tamanho esta em pixel                              �
//�        Default : False                                                 �
//�ExpB8 : Bloco de codigo para impressao.                                 �
//�        Default : ExpC2                                                 �
//�                                                                        �
//��������������������������������������������������������������������������

//��������������������������������������������������������������Ŀ
//� Section 1 - Total em Quantidade da OP / Produto              �
//����������������������������������������������������������������
oSection1:= TRSection():New(oReport,STR0045,{"SD3"},/*aOrdem*/) //"Saldo Inicial OP / Produto"
oSection1:SetHeaderSection(.F.) // Inibe Header

TRCell():New(oSection1,"CPROD",		"",STR0037	,/*Picture*/					,17 ,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"CDESC",		"",STR0038	,/*Picture*/					,If (TamSX3("D3_COD")[1]>15, 37, 25) ,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"CUMED",		"",STR0039	,/*Picture*/					, 2	,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"NQTDE",		"",STR0022	,PesqPict("SC2","C2_QUANT",15)	,15	,/*lPixel*/,/*{|| code-block de impressao }*/,,,"RIGHT")

//��������������������������������������������������������������Ŀ
//� Section 2 - Linha de Detalhe                                 �
//����������������������������������������������������������������
oSection2:= TRSection():New(oSection1,STR0044,{"SD3"},/*aOrdem*/) //"Itens de Movimenta��o Interna"
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

//��������������������������������������������������������������Ŀ
//� Section 3 - Linha de Totais                                  �
//����������������������������������������������������������������
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

//��������������������������������������������������������������Ŀ
//� Section 4 - Resumo Geral                                     �
//����������������������������������������������������������������
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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �ReportPrin� Autor �Flavio Luiz Vicco      �Data  �03/07/2006���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Relacao Consumo Real x Standard.                           ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �Nenhum                                                      ���
�������������������������������������������������������������������������Ĵ��
���Parametros�ExpO1: Objeto Report do Relatorio                           ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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

//�����������������������������������������������������������������Ŀ
//� Funcao utilizada para verificar a ultima versao dos fontes      �
//� SIGACUS.PRW, SIGACUSA.PRX e SIGACUSB.PRX, aplicados no rpo do   |
//| cliente, assim verificando a necessidade de uma atualizacao     |
//| nestes fontes. NAO REMOVER !!!							        �
//�������������������������������������������������������������������
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
//������������������������������������������������������������������������Ŀ
//�Filtragem do relatorio                                                  �
//��������������������������������������������������������������������������
#IFDEF TOP
	lQuery    := .T.
	cAliasNew := GetNextAlias()
	//��������������������������������������������������������������������Ŀ
	//�Transforma parametros Range em expressao SQL                        �
	//����������������������������������������������������������������������
	MakeSqlExpr(oReport:uParam)
	//��������������������������������������������������������������������Ŀ
	//�Query do relatorio da secao 1                                       �
	//����������������������������������������������������������������������
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

	//������������������������������������������������������������������������Ŀ
	//�Metodo EndQuery ( Classe TRSection )                                    �
	//�                                                                        �
	//�Prepara o relatorio para executar o Embedded SQL.                       �
	//�                                                                        �
	//�ExpA1 : Array com os parametros do tipo Range                           �
	//�                                                                        �
	//��������������������������������������������������������������������������
	oReport:Section(1):EndQuery(/*Array com os parametros do tipo Range*/)

#ELSE

	//������������������������������������������������������������������������Ŀ
	//�Transforma parametros Range em expressao Advpl                          �
	//��������������������������������������������������������������������������
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

	//���������������������������������������������������������������������������Ŀ
	//� Le requisicoes e devolucoes SD3 e grava no aLstTrb1 para gravacao do REAL �
	//�����������������������������������������������������������������������������
	If SubStr((cAliasNew)->D3_CF,2,1)$"E" .And. ( lQuery .Or. ( (cAliasNew)->(!Empty(D3_OP) ) ) )

		//��������������������������������������������������������������Ŀ
		//� Ordem de Producao / Produto                                  �
		//����������������������������������������������������������������
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

	//��������������������������������������������������������������Ŀ
	//� Le producoes e gravar TRB. para gravacao do STANDARD         �
	//����������������������������������������������������������������
	If SubStr((cAliasNew)->D3_CF,1,2)$"PR"

		//��������������������������������������������������������������Ŀ
		//� Considera filtro de Usuario                                  �
		//����������������������������������������������������������������
		If !(SB1->(dbSeek(xFilial("SB1")+(cAliasNew)->D3_COD)))
			(cAliasNew)->(DbSkip())
			Loop
		EndIf

		//��������������������������������������������������������������Ŀ
		//� Lista por Ordem de Producao / Produto                        �
		//����������������������������������������������������������������
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

		//��������������������������������������������������������������Ŀ
		//� Calcular pela Estrutura                                      �
		//����������������������������������������������������������������
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

				//��������������������������������������������������������������Ŀ
				//� Se Produto for FANTASMA gravar so os componentes.            �
				//����������������������������������������������������������������
				If RetFldProd(SB1->B1_COD,"B1_FANTASM") == "S" // Projeto Implementeacao de campos MRP e FANTASM no SBZ
					R450Fant(nQuantG1 )
				Else
					//��������������������������������������������������������������Ŀ
					//� Gravar Valores da Producao no array aLstTrb1                 �
					//����������������������������������������������������������������
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
						//���������������������������������������������������������������Ŀ
						//� Valida Requesicoes de mesmo componente para a mesma estrutura �
						//�����������������������������������������������������������������
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

		//��������������������������������������������������������������Ŀ
		//� Calcular pelo Empenho                                        �
		//����������������������������������������������������������������
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

				//��������������������������������������������������������������Ŀ
				//� Gravar Valores da Producao no array aLstTrb1                 �
				//����������������������������������������������������������������
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

//��������������������������������������������������������������Ŀ
//� Ordena por Ordem de Producao / Produto                       �
//����������������������������������������������������������������
If mv_par01 == 1
	aLstTrb1 := ASort(aLstTrb1,,, { | x,y | x[2]+x[1] < y[2]+y[1] })
Else
	aLstTrb1 := ASort(aLstTrb1,,, { | x,y | x[7]+x[1] < y[7]+y[1] })
EndIf

//��������������������������������������������������������������Ŀ
//� Inicio da Impressao do array.                                �
//����������������������������������������������������������������
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

	//��������������������������������������������������������������Ŀ
	//� Filtro por OP / Produto                                      �
	//����������������������������������������������������������������
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

	//����������������������������������������������������������Ŀ
	//� Impressao por OP e PRODUTO                               �
	//������������������������������������������������������������
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
		//����������������������������������������������������������Ŀ
		//� Posiciona na tabela de PRODUTOS                          �
		//������������������������������������������������������������
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
		//����������������������������������������������������������Ŀ
		//� Aglutinar Produto para Posterior Resumo.                 �
		//������������������������������������������������������������
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
	//����������������������������������������������������������Ŀ
	//� Impressao dos Totais por OP/Produto.                     �
	//������������������������������������������������������������
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
//����������������������������������������������������������Ŀ
//� Impressao do Resumo Aglutinado por Produto.              �
//������������������������������������������������������������
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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � MATR450R3� Autor � Erike Yuri da Silva   � Data �14/03/2006���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Relacao Consumo Real x Standard.                           ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe e � MATR450(void)                                              ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
�������������������������������������������������������������������������Ĵ��
���         ATUALIZACOES SOFRIDAS DESDE A CONSTRU�AO INICIAL.             ���
�������������������������������������������������������������������������Ĵ��
���Programador � Data   � BOPS �  Motivo da Alteracao                     ���
�������������������������������������������������������������������������Ĵ��
���Marcos V.   �19/09/06�      �Revisao Geral- Release 3 e Release 4      ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Descri��o � PLANO DE MELHORIA CONTINUA                     MATR450.PRX ���
�������������������������������������������������������������������������Ĵ��
���ITEM PMC  � Responsavel              � Data         |BOPS:             ���
�������������������������������������������������������������������������Ĵ��
���      01  �Marcos V. Ferreira        � 15/08/2006   |00000104629       ���
���      02  �Erike Yuri da Silva       � 29/05/2006   |00000100155       ���
���      03  �Erike Yuri da Silva       � 17/05/2006   |00000099108       ���
���      04  �Ricardo Berti             � 18/08/2006   |00000104995       ���
���      05  �Erike Yuri da Silva       � 17/05/2006   |00000099108       ���
���      06  �Marcos V. Ferreira        � 15/08/2006   |00000104629       ���
���      07  �Flavio Luiz Vicco         � 30/06/2006   |00000101303       ���
���      08  �Ricardo Berti             � 18/08/2006   |00000104995       ���
���      09  �Erike Yuri da Silva       � 29/05/2006   |00000100155       ���
���      10  �Flavio Luiz Vicco         � 30/06/2006   |00000101303       ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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

//�����������������������������������������������������������������Ŀ
//� Funcao utilizada para verificar a ultima versao dos fontes      �
//� SIGACUS.PRW, SIGACUSA.PRX e SIGACUSB.PRX, aplicados no rpo do   |
//| cliente, assim verificando a necessidade de uma atualizacao     |
//| nestes fontes. NAO REMOVER !!!							        �
//�������������������������������������������������������������������
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
	//��������������������������������������������������������������Ŀ
	//� Variaveis utilizadas para Impressao do Cabecalho e Rodape    �
	//����������������������������������������������������������������
	li       := 80
	m_pag    := 1
	
	//��������������������������������������������������������������Ŀ
	//� Verifica as perguntas selecionadas                           �
	//����������������������������������������������������������������
	AjustaSX1()
	
	//��������������������������������������������������������������Ŀ
	//� Variaveis utilizadas para parametros                         �
	//� mv_par01    // Listagem por Ordem de Producao ou Produto.    �
	//� mv_par02    // Listagem Sintetica ou Analitica.              �
	//� mv_par03    // De                                            �
	//� mv_par04    // Ate                                           �
	//� mv_par05    // Custo do Consumo Real 1...6 ( Moeda )         �
	//� mv_par06    // Custo do Consumo Std  1...6                   �
	//� mv_par07    // Movimentacao De                               �
	//� mv_par08    // Movimentacao Ate                              �
	//� mv_par09    // Calcular Pela Estrutura / Empenho             �
	//� mv_par10    // Aglutina por Produto.                         �
	//����������������������������������������������������������������
	Pergunte("MTR451",.F.)
	
	//��������������������������������������������������������������Ŀ
	//� Envia controle para a funcao SETPRINT                        �
	//����������������������������������������������������������������
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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun�ao    � C450IMP  � Autor � Rodrigo de A. Sartorio� Data � 11.12.95 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Chamada do Relatorio                                       ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATR450	  		                                          ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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

//��������������������������������������������������������������Ŀ
//� Corre SD3 para gerar registro de trabalho.	                 �
//����������������������������������������������������������������
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
	
	//����������������������������������������������������������������������������������Ŀ
	//� Le requisicoes e devolucoes SD3 e grava no Array aLstTrb1 para gravacao do REAL  �
	//������������������������������������������������������������������������������������
	If SubStr((cAliasNew)->D3_CF,2,1)$"E" .And. IIf(lQuery,.T.,!Empty((cAliasNew)->D3_OP))

		//��������������������������������������������������������������Ŀ
		//� Ordem de Producao / Produto                                  �
		//����������������������������������������������������������������
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
	
	//��������������������������������������������������������������Ŀ
	//� Le producoes e grava aLstTrb2 para gravacao do STANDARD      �
	//����������������������������������������������������������������
	If SubStr((cAliasNew)->D3_CF,1,2)$"PR" 
	
		//��������������������������������������������������������������Ŀ
		//� Considera filtro de Usuario                                  �
		//����������������������������������������������������������������
		If !( SB1->( dbSeek(xFilial("SB1")+(cAliasNew)->D3_COD)  .And. &(cCondFiltr) ) )
			(cAliasNew)->(dbSkip())
			Loop
		EndIf

		//��������������������������������������������������������������Ŀ
		//� Lista por Ordem de Producao / Produto                        �
		//����������������������������������������������������������������
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

		//��������������������������������������������������������������Ŀ
		//� Calcular pela Estrutura                                      �
		//����������������������������������������������������������������
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

				//��������������������������������������������������������������Ŀ
				//� Se Produto for FANTASMA gravar so os componentes.            �
				//����������������������������������������������������������������
				If RetFldProd(SB1->B1_COD,"B1_FANTASM") == "S" // Projeto Implementeacao de campos MRP e FANTASM no SBZ
					R450Fant( nQuantG1 )
				Else
					//��������������������������������������������������������������Ŀ
					//� Gravar Valores da Producao em TRB.                           �
					//����������������������������������������������������������������
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

						//���������������������������������������������������������������Ŀ
						//� Valida Requesicoes do mesmo componente para a mesma estrutura �
						//�����������������������������������������������������������������
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
			
		//��������������������������������������������������������������Ŀ
		//� Calcular pelo Empenho                                        �
		//����������������������������������������������������������������
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

				//��������������������������������������������������������������Ŀ
				//� Gravar Valores da Producao em TRB.                           �
				//����������������������������������������������������������������
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

//��������������������������������������������������������������Ŀ
//� Monta os Cabecalhos                                          �
//����������������������������������������������������������������
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

//��������������������������������������������������������������Ŀ
//� Ordena por Ordem de Producao/Produto                         �
//����������������������������������������������������������������
If mv_par01 == 1
	aLstTrb1 := ASort(aLstTrb1,,, { | x,y | x[2]+x[1] < y[2]+y[1] })
Else
	aLstTrb1 := ASort(aLstTrb1,,, { | x,y | x[7]+x[1] < y[7]+y[1] })
EndIf

//��������������������������������������������������������������Ŀ
//� Inicio da Impressao                                          �
//����������������������������������������������������������������
nQuantOp := 0.00

For nI:=1 To Len(aLstTrb1)

	IncRegua()

	If lEnd
		@Prow()+1,001 PSAY STR0011		//"CANCELADO PELO OPERADOR"
		Exit
	EndIf

	//��������������������������������������������������������������Ŀ
	//� Filtro por OP / Produto                                      �
	//����������������������������������������������������������������
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

	//����������������������������������������������������������Ŀ
	//� Impressao por OP e PRODUTO                               �
	//������������������������������������������������������������
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

		//����������������������������������������������������������Ŀ
		//� Posiciona na tabela de PRODUTOS                          �
		//������������������������������������������������������������
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

		//����������������������������������������������������������Ŀ
		//� Aglutinar Produto para Posterior Resumo.                 �
		//������������������������������������������������������������
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
	//����������������������������������������������������������Ŀ
	//� Impressao dos Totais por OP/Produto.                     �
	//������������������������������������������������������������
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

//����������������������������������������������������������Ŀ
//� Impressao do Resumo Aglutinado por Produto.              �
//������������������������������������������������������������
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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � R450Linha� Autor � Jose Lucas            � Data � 21.09.93 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Imprimir caracteres barra e ifens como separadores.        ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe e � MATR450(void)                                              ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � R450CabRes� Autor � Jose Lucas           � Data � 21.09.93 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Impressao do Cabecalho do Resumo.                          ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe e � R450CabRes(void)                                           ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATR450                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � R450Cus   � Autor � Erike Yuri da Silva  � Data �14/03/2006���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Retorna o Custo.                                           ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe e � ExpN1 := R450Cus(ExpC1,ExpN2,ExpN3)                        ���
�������������������������������������������������������������������������Ĵ��
���Parametros� ExpC1 := Tipo "S" para Standard e "R" para Real            ���
���          � ExpC1 := Tipo "S" para Standard e "R" para Real            ���
���          � ExpN2 := Indica a Moeda para obtencao do Custo             ���
���          � ExpN3 := Quantidade utilizada.                             ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATR450                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������*/
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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � R450Fant  � Autor � Cesar Eduardo Valadao� Data � 01.06.99 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Retorna a Estrutura de Produto Fantasma                    ���
���          � Funcao Recursiva.                                          ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe e � R450Fant(ExpN1)                                            ���
�������������������������������������������������������������������������Ĵ��
���Parametros� ExpN1 := Quantidade do Pai.                                ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATR450                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
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
		//��������������������������������������������������������������Ŀ
		//� Gravar Valores da Producao em TRB do componente.             �
		//����������������������������������������������������������������
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
				//��������������������������������������������������������������Ŀ
				//� Se Produto for FANTASMA gravar so os componentes.            �
				//����������������������������������������������������������������
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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �AjustaSX1 � Autor � Flavio Luiz Vicco     � Data �30/06/2006���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Cria as perguntas necesarias para o programa                ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �Nenhum                                                      ���
�������������������������������������������������������������������������Ĵ��
���Parametros�Nenhum                                                      ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function AjustaSx1()
PutSx1('MTR451','01' , 'Relacao por?', '�Relacion por?', 'List by ?', ;
	'mv_ch1', 'N', 1, 0, 1, 'C', '', '', '', '', 'mv_par01','Ordem Producao' , 'Orden de Prod.','Product. Order', ;
	'', 'Produto', 'Producto', 'Product', '', '', '', '', '', '', '','', '', ;
	{'Impressao do relat�rio na sequencia do ', 'n�mero da OP ou Por Produto ','do cadastro de movimentos internos (SD3)'}, ;
	{'Impresion del informe ordenado por Nume-','ro de OP o por Numero de Productos del ','archivo de Movimientos Internos (SD3).  '}, ;
	{'Print the report by Production Order or ','By Product Order number order of the    ', 'internal movements file (SD3).          '}, ;
	'')                                            //-- 36 - X1_HELP

PutSx1('MTR451','02' , 'Relacao ?', '�Relacion?', 'Report ?', ;             //-- 05 - X1_PERENG
	'mv_ch2','N', 1, 0, 1, 'C', '', '', '', '', 'mv_par02', 'Analitica' , 'Analitica', 'Detailed', ;                             			//-- 19 - X1_DEFENG1
	'', 'Sintetica', 'Sintetica','Summarized', '','', '','','', '', '', '', '', ;                                           //-- 32 - X1_DEFENG5
	{'O relat�rio ser� impresso com conteudo  ', 'analitico ou sintetico a ser considerado', ' na filtragem do cadastro de movimentos ', 'internos (SD3).                         '}, ; //--      HelpPor3#3
	{'El informe ser impreso con contenido    ', 'analitico o sintetico a ser considerado ', 'en el filtro del archivo de Movimientos ', 'Internos (SD3).                         '}, ; //--      HelpEsp3#3
	{'The report will be printed with detaile-', 'dand summarized content to be considered', ' in the filtering of internal movements ', 'file (SD3).                             '}, ; //--      HelpEng3#3
	'')                                            //-- 36 - X1_HELP
PutSx1('MTR451', '03' , 'De ? ',	'�De ?', 'From ?', ;             //-- 05 - X1_PERENG
	'mv_ch3', 'C', 	15, 0, 0, 'G', 	'', '', '', '', 'mv_par03', '' ,'', '', Space(15), 	'', ;                   		                 //-- 21 - X1_DEF02
	'', '', '', '', '', '', '', '', '', '', '', ;                                           //-- 32 - X1_DEFENG5
	{'De Ordem Produ��o ou Produto inicial a  ', 'ser considerado na filtragem do cadastro', 'de movimentos internos (SD3). Depende da', ' sua escolha na primeira pergunta.      '}, ; //--      HelpPor3#3
	{'De Orden Produccion o Producto inicial a', 'ser considerado en el filtro del archivo', ' de Movimientos Internos (SD3). Depende ', 'de su eleccion en la pregunta n� 1.     '}, ; //--      HelpEsp3#3
	{'Production Order or Initial Product to  ', 'consider in filtering the internal move-', 'ments file (SD3). It depends on         ', 'yourchoice on question no. 1.           '}, ; //--      HelpEng3#3	
	'')                                            //-- 36 - X1_HELP

PutSx1('MTR451', '04' , 'Ate ?', '�A ?', 'To ?', ;                                                            //-- 05 - X1_PERENG
	'mv_ch4', 'C', 15, 0, 0, 'G', '', '', '', '', 'mv_par04', '' , '', '', 'ZZZZZZZZZZZZZZZ','', ;           //-- 21 - X1_DEF02
	'', '', '', '', '', '', '',	'', '', '', '', ;                                                             //-- 32 - X1_DEFENG5
	{'De Ordem Produ��o ou Produto final a    ', 'ser considerado na filtragem do cadastro', 'de movimentos internos (SD3). Depende da', ' sua escolha na primeira pergunta.      '}, ; //--      HelpPor3#3
	{'De Orden Produccion o Producto final  a ', 'ser considerado en el filtro del archivo', ' de Movimientos Internos (SD3). Depende ', 'de su eleccion en la pregunta n� 1.     '}, ; //--      HelpEsp3#3
	{'Production Order or Final Product to    ', 'consider in filtering the internal move-', 'ments file (SD3). It depends on         ', 'yourchoice on question no. 1.           '}, ; //--      HelpEng3#3	
	'')

PutSx1('MTR451', '05' , 'Custo Consumo Real ?', '�Tipo de Costo Real?', 'Real Consumpt.Cost ?', ;             //-- 05 - X1_PERENG
	'mv_ch5', 'N', 1, 0, 1, 'C', '', '', '','', 'mv_par05', 'Moeda 1' , 'Moneda 1','Currency 1', '', ;       //-- 20 - X1_CNT01
	'Moeda 2', 'Moneda 2', 'Currency 2', 'Moeda 3', 'Moneda 3', 'Currency 3', ;                               //-- 26 - X1_DEFENG3
	'Moeda 4', 'Moneda 4', 'Currency 4', 'Moeda 5', 'Moneda 5', 'Currency 5', {}, {}, {},  '')               //-- 36 - X1_HELP

PutSx1('MTR451', '06' , 'Custo Consumo STD  ?', '�Tipo de Costo STD ?', 'Standard Cost Type ?', ;             //-- 05 - X1_PERENG
	'mv_ch6', 'N', 1, 0, 1, 'C', '', '', '', '', 'mv_par06', 'Moeda 1' , 'Moneda 1', 'Currency 1', '', ;     //-- 20 - X1_CNT01
	'Moeda 2', 'Moneda 2', 'Currency 2', 'Moeda 3', 'Moneda 3', 'Currency 3', ;                               //-- 26 - X1_DEFENG3
	'Moeda 4', 'Moneda 4', 'Currency 4', 'Moeda 5', 'Moneda 5', 'Currency 5', ;
	{}, {}, {}, '')                                            //-- 36 - X1_HELP

PutSx1('MTR451', '07' , 'Data de ?', '�De Fecha?', 'From Date ?', ;             //-- 05 - X1_PERENG
	'mv_ch7', 'D', 8, 0, 0, 'G', '', '', '', '', 'mv_par07', '' , '', '', '01/01/06', '', '', ;                  		                 //-- 22 - X1_DEFSPA2
	'', '', '', '', '', '', '', '', '', '', ;                                           //-- 32 - X1_DEFENG5
	{'Data de movimenta��o inicial a ser      ', 'considerada na filtragem do cadastro    ', 'de  movimentos internos (SD3).          '}, ; //--      HelpPor3#3
	{'Fecha de movimiento inicial a ser con-  ', 'siderado en el filtro del archivo de    ', 'Movimientos Internos (SD3).             '}, ; //--      HelpEsp3#3
	{'Initial transaction date to consider in ', 'filtering the internal movements file   ', '(SD3).                                  '}, ; //--      HelpEng3#3
	'')                                            //-- 36 - X1_HELP

PutSx1('MTR451', '08' , 'Data Ate ?', '�A Fecha?','To Date ? ', ;             //-- 05 - X1_PERENG
	'mv_ch8', 'D', 	8,	0, 	0, 'G', '', '',	'', '', 'mv_par08', '' , '','', '31/12/49', '', ;                   		                 //-- 21 - X1_DEF02
	'', '',	'','', '', '', '', '', '', '', 	'', ;                                           //-- 32 - X1_DEFENG5
	{'Data de movimenta��o final a ser        ', 'considerada na filtragem do cadastro    ',  'de  movimentos internos (SD3).          '}, ; //--      HelpPor3#3
	{'Fecha de movimiento final a ser conside-', 'rado en el filtro del archivo de    ', 'Movimientos Internos (SD3).             '}, ; //--      HelpEsp3#3
	{'Final transaction date to consider in   ', 'filtering the internal movements file   ', '(SD3).                                  '}, ; //--      HelpEng3#3
	'')
PutSx1('MTR451', '09' , 'Calcular Pela ?', '�Calcular por?', 'Calculate by ?', ;             //-- 05 - X1_PERENG
	'mv_ch9', 'N', 	1, 	0, 	1, 'C', '', '', '', '',	'mv_par09', ;                                   //-- 16 - X1_VAR01
	'Estrutura' , 'Estructura', 'Structure', '', 'Empenho', 'Reserva', 'Allocation', '', ;                                           //-- 24 - X1_DEF03
	'', '', '', '', '', '', '', '', ;                                           //-- 32 - X1_DEFENG5
	{'Op��o do c�lculo do custo pelo Cadastro ', 'sde Estrutura do Produto (SG1) ou pelo  ', 'Cadastro de Empenhos (SD4).             '}, ; //--      HelpPor3#3
	{'Opcion del calculo del costo por el     ', 'Archivo de Estructura del Producto (SG1)', 'o por el Archivo de Reservas (SD4).     '}, ; //--      HelpEsp3#3
	{'Option for cost calculation by the Pro- ', 'duct Structure File (SG1) or by the ', 'Allocations File (SD4).               '}, ; //--      HelpEng3#3
	'')                                            //-- 36 - X1_HELP

PutSx1('MTR451', '10' , 'Aglutina por Prod. ?', '�Agrupa por Prodc ?', 'Group by Product ?', ;//-- 05 - X1_PERENG
	'mv_cha', 'N', 	1, 	0, 	2, 'C', '', '', '', '',	'mv_par10', ; //-- 16 - X1_VAR01
	'Sim' , 'Si', 'Yes', '', 'Nao', 'No', 'No', '', ; //-- 24 - X1_DEF03
	'', '', '', '', '', '', '', '', ;                 //-- 32 - X1_DEFENG5
	{'O relat�rio ser� impresso por produto ', 'com o total aglutinado a ser ', 'considerado na filtragem do cadastro de ','movimentos internos (SD3).'}, ; //--      HelpPor3#3
	{'El informe sera impreso por producto ', 'con el total aglutinado a ser consi-', 'derado en el filtro del archivo de ','Movimientos Internos (SD3).'}, ; //--      HelpEsp3#3
	{'The report will be printed by product ', 'with the grouped total to consider in ', 'filtering the internal movements file',' (SD3).'}, ; //--      HelpEng3#3
	'')                                            //-- 36 - X1_HELP
Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � R450Qtd   � Autor � Fernando Joly Siquini� Data �03/05/2006���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Retorna a Quantidade                                       ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe e � ExpN1 := R450Qtd(ExpC1,ExpN2,ExpN3)                        ���
�������������������������������������������������������������������������Ĵ��
���Parametros� ExpC1 := Tipo "R" Qtde Real, "S" Qtde Standard             ���
���          � ExpN2 := Quantidade Standard                               ���
���          � ExpC3 := Alias da tabela SD3                               ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATR450                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������*/
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
