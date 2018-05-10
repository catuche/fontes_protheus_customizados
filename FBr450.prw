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
User Function FBR450()
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
Local oCell
Local cTitle := OemToAnsi("Analise de Custos por Apontamento")
Local cPerg  := "FBR450"
Private cPicD3C116 := PesqPict("SD3","D3_CUSTO1",16)
Private cPicQtC116 := PesqPict("SD3","D3_QUANT",18)

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
oReport := TReport():New("FBR450",cTitle,"FBR450",{|oReport| ReportPrint(oReport,'SD3')},"Analise de Custos por Apontamento")
oReport:SetLandscape()

//��������������������������������������������������������������Ŀ
//� Ajusta o Grupo de Pergunta                                   �
//����������������������������������������������������������������
AjustaSX1(cPerg)

//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros                         �
//� mv_par01    // Listagem por Ordem de Producao ou Produto.    �
//� mv_par02    // De                                            �
//� mv_par03    // Ate                                           �
//� mv_par04    // Movimentacao De                               �
//� mv_par05    // Movimentacao Ate                              �
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

TRCell():New(oSection1,"CPROD",		"",STR0037	,/*Picture*/					,20 ,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"CDESC",		"",STR0038	,/*Picture*/					,40 ,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"DEMISSAO",  "","Dt Movim.",/*Picture*/					,10,/*lPixel*/,/*{|| code-block de impressao }*/) //"M a t e r i a l"
TRCell():New(oSection1,"CTIPO",		"","Tipo"	,/*Picture*/					,15 ,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"NQTDE",		"","Quantidade"	,PesqPict("SD3","D3_QUANT",15)	,15	,/*lPixel*/,/*{|| code-block de impressao }*/,,,"RIGHT")
TRCell():New(oSection1,"CUMED",		"",STR0039	,/*Picture*/					, 2	,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"NCUSTNAC",		"","Nacional",cPicD3C116	,16	,/*lPixel*/,/*{|| code-block de impressao }*/,,,"RIGHT")
TRCell():New(oSection1,"NCUSTIMP",		"","Importado",cPicD3C116	,16	,/*lPixel*/,/*{|| code-block de impressao }*/,,,"RIGHT")
TRCell():New(oSection1,"NCUSTBNF",		"","Beneficiamento",cPicD3C116	,16	,/*lPixel*/,/*{|| code-block de impressao }*/,,,"RIGHT")
TRCell():New(oSection1,"NCUSTDIR",		"","Direta",cPicD3C116	,16	,/*lPixel*/,/*{|| code-block de impressao }*/,,,"RIGHT")
TRCell():New(oSection1,"NCUSTIND",		"","Indireta",cPicD3C116	,16	,/*lPixel*/,/*{|| code-block de impressao }*/,,,"RIGHT")
TRCell():New(oSection1,"NCUSDDIR",		"","Diretas",cPicD3C116	,16	,/*lPixel*/,/*{|| code-block de impressao }*/,,,"RIGHT")
TRCell():New(oSection1,"NCUSDIND",		"","Indiretas",cPicD3C116	,16	,/*lPixel*/,/*{|| code-block de impressao }*/,,,"RIGHT")
TRCell():New(oSection1,"NCUSTTOT",		"","Total",cPicD3C116	,16	,/*lPixel*/,/*{|| code-block de impressao }*/,,,"RIGHT")
TRCell():New(oSection1,"NCUSUNIT",      "","Unit�rio",cPicD3C116,16	,/*lPixel*/,/*{|| code-block de impressao }*/,,,"RIGHT") //"Real"###"Custo Un."

//TRCell():New(oSection1,"CPESO",		"","PESO"	,/*Picture*/					, 15,/*lPixel*/,/*{|| code-block de impressao }*/)

//��������������������������������������������������������������Ŀ
//� Section 2 - Linha de Detalhe                                 �
//����������������������������������������������������������������
oSection2:= TRSection():New(oSection1,STR0044,{"SD3"},/*aOrdem*/) //"Itens de Movimenta��o Interna"
oSection2:SetHeaderPage(.T.)
oSection2:SetHeaderSection(.T.)  

TRCell():New(oSection2,"CPROD"		,"",STR0020	+CRLF+STR0037,/*Picture*/					,20,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,"CDESC"		,"",""		+CRLF+STR0038,/*Picture*/					,40,/*lPixel*/,/*{|| code-block de impressao }*/) //"M a t e r i a l"
TRCell():New(oSection2,"DEMISSAO"	,"",""		+CRLF+"Dt Movim.",/*Picture*/				,10,/*lPixel*/,/*{|| code-block de impressao }*/) //"M a t e r i a l"
TRCell():New(oSection2,"CTIPO",		 "",""	+CRLF + "Tipo"	,/*Picture*/					,15 ,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,"NQTDE"		,"","" +CRLF +"Quantidade",PesqPict("SD3","D3_QUANT",15),15	,/*lPixel*/,/*{|| code-block de impressao }*/,,,"RIGHT") //"Consumo"###"Quantidade"
TRCell():New(oSection2,"CUMED"		,"",""		+CRLF+STR0039,/*Picture*/					, 2	,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,"NCUSTNAC",		"","Material"+CRLF+"Nacional",cPicD3C116	,16	,/*lPixel*/,/*{|| code-block de impressao }*/,,,"RIGHT")
TRCell():New(oSection2,"NCUSTIMP",		"","Material"+CRLF+"Importado",cPicD3C116	,16	,/*lPixel*/,/*{|| code-block de impressao }*/,,,"RIGHT")
TRCell():New(oSection2,"NCUSTBNF",		"",""+CRLF+"Beneficiamento",cPicD3C116	,16	,/*lPixel*/,/*{|| code-block de impressao }*/,,,"RIGHT")
TRCell():New(oSection2,"NCUSTDIR",		"","MAO DE OBRA"+CRLF+ "Direta",cPicD3C116	,16	,/*lPixel*/,/*{|| code-block de impressao }*/,,,"RIGHT")
TRCell():New(oSection2,"NCUSTIND",		"","MAO DE OBRA"+CRLF+"Indireta",cPicD3C116	,16	,/*lPixel*/,/*{|| code-block de impressao }*/,,,"RIGHT")
TRCell():New(oSection2,"NCUSDDIR",		"","DESPESAS"	+CRLF+ "Diretas",cPicD3C116	,16	,/*lPixel*/,/*{|| code-block de impressao }*/,,,"RIGHT")
TRCell():New(oSection2,"NCUSDIND",		"","DESPESAS"	+CRLF+"Indiretas",cPicD3C116	,16	,/*lPixel*/,/*{|| code-block de impressao }*/,,,"RIGHT")
TRCell():New(oSection2,"NCUSTTOT",		"",""	+CRLF+ "Total",cPicD3C116	,16	,/*lPixel*/,/*{|| code-block de impressao }*/,,,"RIGHT")
TRCell():New(oSection2,"NCUSUNIT",      "",""	+CRLF+"Unit�rio",cPicD3C116	,16 ,/*lPixel*/,/*{|| code-block de impressao }*/,,,"RIGHT")

//��������������������������������������������������������������Ŀ
//� Section 3 - Linha de Totais                                  �
//����������������������������������������������������������������
oSection3:= TRSection():New(oSection2,STR0046,{"SD3"},/*aOrdem*/) //"Totais por OP / Produto"
oSection3:SetHeaderSection(.F.)
oSection3:SetNoFilter("SD3")

TRCell():New(oSection3,"CPROD"		,""	,STR0020+CRLF+STR0037	,/*Picture*/					,20,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection3,"CDESC"		,""	,""		+CRLF+STR0038	,/*Picture*/					,40 ,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection3,"DEMISSAO"	,""	,""	  	+CRLF+STR0039	,/*Picture*/					,10	,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection3,"CTIPO",		 "",""	+CRLF + "Tipo"	,/*Picture*/						,15 ,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection3,"NQTDE"		,""	,"" +CRLF +"Quantidade"	,PesqPict("SD3","D3_QUANT",15)	,15	,/*lPixel*/,/*{|| code-block de impressao }*/,,,"RIGHT")//"Quantidade"
TRCell():New(oSection3,"CUMED"		,""	,""	  	+CRLF+STR0039	,/*Picture*/					,2	,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection3,"NTCUSTNAC",		"",""	+CRLF+"Nacional",cPicD3C116	,16	,/*lPixel*/,/*{|| code-block de impressao }*/,,,"RIGHT")
TRCell():New(oSection3,"NTCUSTIMP",		"",""	+CRLF+"Importado",cPicD3C116	,16	,/*lPixel*/,/*{|| code-block de impressao }*/,,,"RIGHT")
TRCell():New(oSection3,"NTCUSTBNF",		"",""	+CRLF+"Beneficiamento",cPicD3C116	,16	,/*lPixel*/,/*{|| code-block de impressao }*/,,,"RIGHT")
TRCell():New(oSection3,"NTCUSTDIR",		"",""	+CRLF+"Direta",cPicD3C116	,16	,/*lPixel*/,/*{|| code-block de impressao }*/,,,"RIGHT")
TRCell():New(oSection3,"NTCUSTIND",		"",""	+CRLF+"Indireta",cPicD3C116	,16	,/*lPixel*/,/*{|| code-block de impressao }*/,,,"RIGHT")
TRCell():New(oSection3,"NTCUSDDIR",		"",""	+CRLF+"Diretas",cPicD3C116	,16	,/*lPixel*/,/*{|| code-block de impressao }*/,,,"RIGHT")
TRCell():New(oSection3,"NTCUSDIND",		"",""	+CRLF+"Indiretas",cPicD3C116	,16	,/*lPixel*/,/*{|| code-block de impressao }*/,,,"RIGHT")
TRCell():New(oSection3,"NTCUSTTOT",		"",""	+CRLF+"Total",cPicD3C116	,16	,/*lPixel*/,/*{|| code-block de impressao }*/,,,"RIGHT")
TRCell():New(oSection3,"NTCUSUNIT",      "",""	+CRLF+"Unit�rio",cPicD3C116	,16 ,/*lPixel*/,/*{|| code-block de impressao }*/,,,"RIGHT")


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

		SELECT D3_FILIAL, D3_COD, D3_CF, D3_OP, D3_UM, D3_EMISSAO, SUM(D3_QUANT) D3_QUANT, SUM(D3_CUSTO1) D3_CUSTO1,
		SUM(D3_CP0101) D3_CP0101, SUM(D3_CP0201) D3_CP0201, SUM(D3_CP0301) D3_CP0301, SUM(D3_CP0401) D3_CP0401, SUM(D3_CP0501) D3_CP0501
		FROM  %table:SD3% SD3
		WHERE SD3.D3_FILIAL = %xFilial:SD3%
		AND SD3.D3_EMISSAO >= %Exp:DTOS(mv_par04)%
		AND SD3.D3_EMISSAO <= %Exp:DTOS(mv_par05)%
		AND SD3.D3_OP >= %Exp:mv_par02%
		AND SD3.D3_OP <= %Exp:mv_par03%
		AND (SD3.D3_CF LIKE 'PR%' OR SD3.D3_CF LIKE 'RE%' OR SD3.D3_CF LIKE 'DE%')
		AND SD3.D3_ESTORNO = ' '
		AND SD3.%NotDel%
		GROUP BY D3_FILIAL, D3_COD, D3_CF, D3_OP, D3_UM, D3_EMISSAO
	    ORDER BY D3_FILIAL, D3_COD, D3_CF, D3_OP, D3_UM, D3_EMISSAO
		EndSql
		
	Else
	
		BeginSql Alias cAliasNew

		SELECT D3_FILIAL, D3_COD, D3_CF, D3_OP, D3_UM, D3_EMISSAO, SUM(D3_QUANT) D3_QUANT, SUM(D3_CUSTO1) D3_CUSTO1,
		SUM(D3_CP0101) D3_CP0101, SUM(D3_CP0201) D3_CP0201, SUM(D3_CP0301) D3_CP0301, SUM(D3_CP0401) D3_CP0401, SUM(D3_CP0501) D3_CP0501
		FROM  %table:SD3% SD3
		WHERE SD3.D3_FILIAL = %xFilial:SD3%
		AND SD3.D3_EMISSAO >= %Exp:DTOS(mv_par04)%
		AND SD3.D3_EMISSAO <= %Exp:DTOS(mv_par05)%
		AND SD3.D3_COD >= %Exp:mv_par02%
		AND SD3.D3_COD <= %Exp:mv_par03%
		AND SD3.D3_CF LIKE 'PR%'
		AND SD3.D3_ESTORNO = ' '
		AND SD3.%NotDel%
		GROUP BY D3_FILIAL, D3_COD, D3_CF, D3_OP, D3_UM, D3_EMISSAO
		UNION
		SELECT D3_FILIAL, D3_COD, D3_CF, D3_OP, D3_UM, D3_EMISSAO, SUM(D3_QUANT) D3_QUANT, SUM(D3_CUSTO1) D3_CUSTO1
		FROM %table:SD3% SD3, %table:SC2% SC2
		WHERE SD3.D3_FILIAL = %xFilial:SD3%
		AND SD3.D3_EMISSAO >= %Exp:DTOS(mv_par04)%
		AND SD3.D3_EMISSAO <= %Exp:DTOS(mv_par05)%
		AND SD3.D3_ESTORNO = ' '
		AND (SD3.D3_CF LIKE 'RE%' OR SD3.D3_CF LIKE 'DE%')
		AND SD3.%NotDel%
		AND SC2.C2_FILIAL = %xFilial:SC2%
		AND SC2.C2_NUM+C2_ITEM+C2_SEQUEN = D3_OP
		AND SC2.C2_PRODUTO >= %Exp:mv_par02%
		AND SC2.C2_PRODUTO <= %Exp:mv_par03%
		AND SC2.%NotDel%
		GROUP BY D3_FILIAL, D3_COD, D3_CF, D3_OP, D3_UM, D3_EMISSAO
	    ORDER BY D3_FILIAL, D3_COD, D3_CF, D3_OP, D3_UM, D3_EMISSAO
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
			nPosTrb1 := aScan(aLstTrb1,{|x| x[2]+x[1]+Dtos(x[6])==(cAliasNew)->D3_OP+(cAliasNew)->D3_COD+Dtos((cAliasNew)->D3_EMISSAO)})
		Else  
			nPosTrb1 := aScan(aLstTrb1,{|x| x[7]+x[1]+x[2]==SC2->C2_PRODUTO+(cAliasNew)->D3_COD+SC2->(C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD)})
		EndIf

		If Empty(nPosTrb1)
			aAdd(aLstTrb1,{	(cAliasNew)->D3_COD,		;	  		//01 - PRODUTO
							(cAliasNew)->D3_OP,			; 			//02 - OP
							CriaVar("D3_NUMSEQ",.F.),	; 			//03 - NUMSEQ
							" ",				; 					//04 - TRT
							CriaVar("D3_CHAVE",.F.),	; 			//05 - CHAVE
							(cAliasNew)->D3_EMISSAO,	; 			//06 - EMISSAO
							SC2->C2_PRODUTO,			; 			//07 - PAI
							"",							;	 		//08 - FIXVAR
							R450Qtd("R",0,cAliasNew),	; 			//09 - QTDREAL
							0,							; 			//10 - QTDSTD
							0,							; 			//11 - QTDVAR
							0,							; 			//12 - CUSTOSTD
							R450Cus('R', "0",,cAliasNew),;			//13 - CUSTO1
							R450Cus('R', "1",,cAliasNew),;			//14 - MOD
							R450Cus('R', "2",,cAliasNew),;			//15 - MOI
							R450Cus('R', "3",,cAliasNew),;			//16 - DD
							R450Cus('R', "4",,cAliasNew),;			//17 - DI
							R450Cus('R', "5",,cAliasNew)})			//18 - CP0101
		Else
			aLstTrb1[nPosTrb1,09] += R450Qtd("R",0,cAliasNew)		 	//09 - QTDREAL
			aLstTrb1[nPosTrb1,13] += R450Cus('R',"0",,cAliasNew)			//13 - CUSTOREAL
			aLstTrb1[nPosTrb1,14] += R450Cus('R',"1",,cAliasNew)			//13 - CUSTOREAL
			aLstTrb1[nPosTrb1,15] += R450Cus('R',"2",,cAliasNew)			//13 - CUSTOREAL
			aLstTrb1[nPosTrb1,16] += R450Cus('R',"3",,cAliasNew)			//13 - CUSTOREAL
			aLstTrb1[nPosTrb1,17] += R450Cus('R',"4",,cAliasNew)			//13 - CUSTOREAL
			aLstTrb1[nPosTrb1,18] += R450Cus('R',"5",,cAliasNew)			//13 - CUSTOREAL
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
			nPosTrb2 := aScan(aLstTrb2,{|x|x[2]+Dtos(x[5])==(cAliasNew)->D3_OP+Dtos((cAliasNew)->D3_EMISSAO)})
		Else
			nPosTrb2 := aScan(aLstTrb2,{|x|x[1]==(cAliasNew)->D3_COD})
		EndIf

		If Empty(nPosTrb2)
			aAdd(aLstTrb2,Array(5))
			nPosTrb2 := Len(aLstTrb2)
			aLstTrb2[nPosTrb2,4] := 0
		EndIf
		aLstTrb2[nPosTrb2,1] := (cAliasNew)->D3_COD
		aLstTrb2[nPosTrb2,2] := (cAliasNew)->D3_OP
		aLstTrb2[nPosTrb2,3] := (cAliasNew)->D3_UM
		aLstTrb2[nPosTrb2,4] += (cAliasNew)->D3_QUANT
		aLstTrb2[nPosTrb2,5] := (cAliasNew)->D3_EMISSAO
		cProduto := (cAliasNew)->D3_COD

		dbSelectArea(cAliasNew)
	EndIf
	(cAliasNew)->(dbSkip())
EndDo

//��������������������������������������������������������������Ŀ
//� Ordena por Ordem de Producao / Produto                       �
//����������������������������������������������������������������
If mv_par01 == 1
	aLstTrb1 := ASort(aLstTrb1,,, { | x,y | x[2]+Dtos(x[6])+x[1] < y[2]+Dtos(y[6])+y[1] })
	aLstTrb2 := ASort(aLstTrb2,,, { | x,y | x[2]+Dtos(x[5])+x[1] < y[2]+Dtos(y[5])+y[1] })
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

	//����������������������������������������������������������Ŀ
	//� Impressao por OP e PRODUTO                               �
	//������������������������������������������������������������
	If mv_par01 = 1
		nPosTrb2 := aScan(aLstTrb2,{|x| x[2]+Dtos(x[5])==aLstTrb1[nI,2]+Dtos(aLstTrb1[nI,6])})
	Else
		nPosTrb2 := aScan(aLstTrb2,{|x| x[1]==aLstTrb1[nI,7]})	
	EndIf
	If Empty(nPosTrb2)
		Loop
	EndIf
//	_cPeso := Alltrim(Transform(SB1->B1_PESO * aLstTrb2[nPosTrb2,4], "@E 9,999,999.99")) + " KG"
	_cTipoPR := Alltrim(Posicione("SX5",1,xFilial("SX5")+"02"+SB1->B1_TIPO,"X5_DESCRI"))
	oSection1:Cell("CPROD"):SetValue(If(mv_par01=1,STR0036+aLstTrb2[nPosTrb2,2],STR0035)) //"OP: "###"PRODUTO:"
	oSection1:Cell("CDESC"):Disable()
	oSection1:Cell("CUMED"):Disable()
	oSection1:Cell("CTIPO"):Disable()
	oSection1:Cell("NQTDE"):Disable()
	oSection1:Cell("DEMISSAO"):Disable()
	oSection1:Cell("NCUSTNAC"):Disable()
	oSection1:Cell("NCUSTIMP"):Disable()
	oSection1:Cell("NCUSTBNF"):Disable()
	oSection1:Cell("NCUSTDIR"):Disable()
	oSection1:Cell("NCUSTIND"):Disable()
	oSection1:Cell("NCUSDDIR"):Disable()
	oSection1:Cell("NCUSDIND"):Disable()
	oSection1:Cell("NCUSTTOT"):Disable()
	oSection1:Cell("NCUSUNIT"):Disable()
	oSection1:PrintLine()
	nQuantOp := aLstTrb2[nPosTrb2,4]
	nCusStdOP := nTotStdOP := nCusRealOP := nTotRealOP := nTotVarOP := 0
	nCusUnitR := nCusUnitS := 0

	NTTCUSTNAC := 0
	NTTCUSTIMP := 0
	NTTCUSTBNF := 0
	NTTCUSTDIR := 0
	NTTCUSTIND := 0
	NTTCUSDDIR := 0
	NTTCUSDIND := 0
	NTTCUSTTOT := 0
	NTTCUSUNIT := 0
	nCusTot		:= 0
	cAnt 	  := IIf( mv_par01 == 1,aLstTrb1[nI,02],aLstTrb1[nI,07])
	oReport:SkipLine()
	While nI <= Len(aLstTrb1) .And. IIF( mv_par01 == 1,aLstTrb1[nI,2],aLstTrb1[nI,7]) == cAnt .and. Dtos(aLstTrb2[nPosTrb2,5]) == Dtos(aLstTrb1[nI,6])
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
		_cTipo := Alltrim(Posicione("SX5",1,xFilial("SX5")+"02"+SB1->B1_TIPO,"X5_DESCRI"))
		If ((QtdComp(aLstTrb1[nI,09],.T.) # QtdComp(0,.T.)))
			oSection2:Cell("CPROD"	):SetValue(aLstTrb1[nI,01])
			oSection2:Cell("CDESC"	):SetValue(SB1->B1_DESC)
			oSection2:Cell("CUMED"	):SetValue(SB1->B1_UM)
			oSection2:Cell("CTIPO"):SetValue(_cTipo)
			oSection2:Cell("NQTDE"		):SetValue(aLstTrb1[nI,09])
			oSection2:Cell("DEMISSAO"):SetValue(aLstTrb1[nI,6])
			oSection2:Cell("NCUSUNIT"	):SetValue(nCusUnit)
			If SB1->B1_TIPO == "01"
				oSection2:Cell("NCUSTNAC"):SetValue(aLstTrb1[nI,13])
				NTTCUSTNAC += aLstTrb1[nI,13]
			Else
				oSection2:Cell("NCUSTNAC"):SetValue(0)
			Endif
			oSection2:Cell("NCUSTIMP"):SetValue(0)
			oSection2:Cell("NCUSTBNF"):SetValue(0)				
			oSection2:Cell("NCUSTDIR"):SetValue(aLstTrb1[nI,14])
			oSection2:Cell("NCUSTIND"):SetValue(aLstTrb1[nI,17])
			oSection2:Cell("NCUSDDIR"):SetValue(aLstTrb1[nI,15])
			oSection2:Cell("NCUSDIND"):SetValue(aLstTrb1[nI,16])
			oSection2:Cell("NCUSTTOT"):SetValue(aLstTrb1[nI,13])
			_nDif := aLstTrb1[nI,13] - (aLstTrb1[nI,14] + aLstTrb1[nI,17] + aLstTrb1[nI,15] + aLstTrb1[nI,16])
			If _nDif > 0 .and. SB1->B1_TIPO <> "01"
				NTTCUSTNAC += _nDif
				oSection2:Cell("NCUSTNAC"):SetValue(_nDif)
			Endif
			oSection2:Cell("NCUSUNIT"):SetValue(ROUND(aLstTrb1[nI,13] / aLstTrb1[nI,09], TAMSX3("D3_CUSTO1")[2]))
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
		nCusTot    += aLstTrb1[nI,13]
		NTTCUSTDIR += aLstTrb1[nI,14]
		NTTCUSTIND += aLstTrb1[nI,17]
		NTTCUSDDIR += aLstTrb1[nI,15]
		NTTCUSDIND += aLstTrb1[nI,16]
		nI++
		If nI > Len(aLstTrb1) .Or. IIf( mv_par01 == 1,aLstTrb1[nI,2],aLstTrb1[nI,7]) # cAnt .or. Dtos(aLstTrb2[nPosTrb2,5]) <> Dtos(aLstTrb1[nI,6])
			nI--
			Exit
		EndIf
	EndDo
	//����������������������������������������������������������Ŀ
	//� Impressao dos Totais por OP/Produto.                     �
	//������������������������������������������������������������
//	oReport:ThinLine() //-- Impressao de Linha Simples
	oReport:SkipLine()
	oSection3:Cell("CPROD"):SetValue(aLstTrb2[nPosTrb2,1])
	oSection3:Cell("CDESC"):SetValue(Posicione("SB1",1,xFilial("SB1")+aLstTrb2[nPosTrb2,1],"B1_DESC"))
	oSection3:Cell("CUMED"):SetValue(Posicione("SB1",1,xFilial("SB1")+aLstTrb2[nPosTrb2,1],"B1_UM"))
	oSection3:Cell("DEMISSAO"):SetValue(aLstTrb2[nPosTrb2,5])
	oSection3:Cell("CTIPO"):SetValue(_cTipoPR)
	oSection3:Cell("NQTDE"):SetValue(aLstTrb2[nPosTrb2,4])
	oSection3:Cell("NTCUSTNAC"):SetValue(NTTCUSTNAC)
	oSection3:Cell("NTCUSTIMP"):SetValue(NTTCUSTIMP)
	oSection3:Cell("NTCUSTBNF"):SetValue(NTTCUSTBNF)				
	oSection3:Cell("NTCUSTDIR"):SetValue(NTTCUSTDIR)
	oSection3:Cell("NTCUSTIND"):SetValue(NTTCUSTIND)
	oSection3:Cell("NTCUSDDIR"):SetValue(NTTCUSDDIR)
	oSection3:Cell("NTCUSDIND"):SetValue(NTTCUSDIND)
	oSection3:Cell("NTCUSTTOT"):SetValue(nCusTot)
	oSection3:Cell("NTCUSUNIT"):SetValue(ROUND(nCusTot / aLstTrb2[nPosTrb2,4], TAMSX3("D3_CUSTO1")[2]))
	oSection3:PrintLine()
	oReport:ThinLine() //-- Impressao de Linha Simples
	oReport:SkipLine() //-- Salta linha
Next
oSection2:SetHeaderSection(.F.)
oSection1:Finish()
oSection2:Finish()
oSection3:Finish()

Return NIL

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
Static Function AjustaSx1(cPerg)

Local i := 0
Local j := 0
dbSelectArea("SX1")
dbSetOrder(1)
cPerg := PADR(cPerg,10)
aRegs:={}

AADD(aRegs,{cPerg,"01","Impressao Por     ?","","","mv_ch1","N",01,0,1,"C","","mv_par01","Ordem Producao" , "Ordem Producao" , "Ordem Producao","","", "Produto", "Produto"	, "Produto"	,"","",""		    ,"","","","",""		  ,"","","","",""		 ,"","","",""   ,"S"})
AADD(aRegs,{cPerg,"02","De                ?","","","mv_ch2","C",15,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"03","Ate               ?","","","mv_ch3","C",15,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"04","Da Data           ?","","","mv_ch4","D",08,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"05","Ate Data          ?","","","mv_ch5","D",08,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","",""})

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
Static Function R450Cus(cTipo,cParte,nQtd,cAliasSD3)

Local aAreaAnt  := GetArea()
Local nRet      := 0

Default cAliasSD3 := "SD3"
Default nQtd      := 0

If cTipo = "R" 	// Custo Real
	If cParte == "0"
		nRet := (cAliasSD3)->D3_CUSTO1 * IIf(SubStr((cAliasSD3)->D3_CF, 1, 1) == 'R', 1, -1)
	ElseIf cParte == "1"
		nRet := (cAliasSD3)->D3_CP0101 * IIf(SubStr((cAliasSD3)->D3_CF, 1, 1) == 'R', 1, -1)
	ElseIf cParte == "2"
		nRet := (cAliasSD3)->D3_CP0201 * IIf(SubStr((cAliasSD3)->D3_CF, 1, 1) == 'R', 1, -1)
	ElseIf cParte == "3"
		nRet := (cAliasSD3)->D3_CP0301 * IIf(SubStr((cAliasSD3)->D3_CF, 1, 1) == 'R', 1, -1)
	ElseIf cParte == "4"
		nRet := (cAliasSD3)->D3_CP0401 * IIf(SubStr((cAliasSD3)->D3_CF, 1, 1) == 'R', 1, -1)		
	ElseIf cParte == "5"
		nRet := (cAliasSD3)->D3_CP0501 * IIf(SubStr((cAliasSD3)->D3_CF, 1, 1) == 'R', 1, -1)
	Endif
Else  // Custo Standard
	dbSelectArea("SB1")
	nRet := (nQtd*xMoeda(RetFldProd(SB1->B1_COD,"B1_CUSTD"),Val(RetFldProd(SB1->B1_COD,"B1_MCUSTD")), nMoeda, RetFldProd(SB1->B1_COD,"B1_DATREF") ))
EndIf

RestArea(aAreaAnt)
Return (nRet)