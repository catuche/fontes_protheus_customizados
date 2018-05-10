#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "REPORT.CH"
#include "rwmake.ch"

/*-------------------------------------------------------------------------------------------
Função: Matr110a()

Descrição: Esta rotina tem como objetivo imprimir os pedidos de compras com um layout
alternativo com o objeto TmsPrinter

---------------------------------------------------------------------------------------------*/

User Function FB_IRP(cNumNF, cSerie, cFornece, cLoja)

DEFAULT cNumPed		:= ""
Private _cAlias		:= GetNextAlias()
Private _cAlias1	:= GetNextAlias()
Private cEOL 		:= "CHR(13)+CHR(10)"
Private cPerg   	:= "FB_IRP" 		// Nome do grupo de perguntas

AjustaSX1()

If !Empty(cNumNF)
	Pergunte(cPerg,.F.)
	MV_PAR01 := cFornece
	MV_PAR02 := cFornece
	MV_PAR03 := cLoja
	MV_PAR04 := cLoja
	MV_PAR05 := cNumNF
	MV_PAR06 := cNumNF
	MV_PAR07 := cSerie
	MV_PAR08 := cSerie
	MV_PAR09 := CTOD("01/01/1900")
	MV_PAR10 := CTOD("31/12/2049")
ElseIf !Pergunte(cPerg,.T.)
	
	Return
Endif

If Empty(cEOL)
	cEOL := CHR(13)+CHR(10)
Else
	cEOL := Trim(cEOL)
	cEOL := &cEOL
Endif

//Monta arquivo de trabalho temporário
MsAguarde({||MontaQuery()},"Aguarde","Criando arquivos para impressão...")

//Verifica resultado da query

DbSelectArea(_cAlias)
DbGoTop()
If (_cAlias)->(Eof())
	MsgAlert("Relatório vazio! Verifique os parâmetros.","Atenção")
	(_cAlias)->(DbCloseArea())
Else
	Processa({|| Imprime() },"IRP - Informativo de Recebimento de Produto","Imprimindo...")
EndIf

Return

//********************************************************************************************
//                                          MONTA A PAGINA DE IMPRESSAO
//********************************************************************************************
Static Function Imprime()

Local _nCont 		:= 1
Local cPedidoAtu	:= ""
Local cPedidoAnt	:= ""
Local aAreaSM0	:= {}	 

Private cBitmap	:= ""
Private cStartPath:= GetSrvProfString("Startpath","")
Private oFont08
Private oFont09
Private oFont10
Private cPosi
Private nLin
Private _cEndEnt		:= ""
Private _cBairEnt		:= ""
Private _cCidEnt		:= ""
Private _cEstEnt		:= ""		
Private _cTel			:= ""

cBitmap := "LGRL"+SM0->M0_CODIGO+SM0->M0_CODFIL+".BMP" // Empresa+Filial
If !File( cBitmap )
	cBitmap := "LGRL"+SM0->M0_CODIGO+".BMP" // Empresa
EndIf

//Fontes a serem utilizadas no relatório
Private oFont08  	:= TFont():New( "Arial",,08,,.F.,,,,,.f.)
Private oFont08N 	:= TFont():New( "Arial",,08,,.T.,,,,,.f.)
Private oFont08I 	:= TFont():New( "Arial",,08,,.f.,,,,,.f.,.T.)
Private oFont09  	:= TFont():New( "Arial",,09,,.F.,,,,,.f.)
Private oFont09N 	:= TFont():New( "Arial",,09,,.T.,,,,,.f.)
Private oFontC9  	:= TFont():New( "Courier New",,09,,.F.,,,,,.f.)
Private oFontC9N 	:= TFont():New( "Courier New",,09,,.T.,,,,,.f.)
Private oFont10  	:= TFont():New( "Arial",,10,,.f.,,,,,.f.)
Private oFont10N 	:= TFont():New( "Arial",,10,,.T.,,,,,.f.)
Private oFont10I 	:= TFont():New( "Arial",,10,,.f.,,,,,.f.,.T.)
Private oFont11  	:= TFont():New( "Arial",,11,,.f.,,,,,.f.)
Private oFont11N 	:= TFont():New( "Arial",,11,,.T.,,,,,.f.)
Private oFont12N 	:= TFont():New( "Arial",,12,,.T.,,,,,.f.)
Private oFont12  	:= TFont():New( "Arial",,25,,.F.,,,,,.F.)
Private oFont12NS	:= TFont():New( "Arial",,12,,.T.,,,,,.T.)
Private oFont13N 	:= TFont():New( "Arial",,13,,.T.,,,,,.f.)
Private oFont17 	:= TFont():New( "Arial",,30,,.F.,,,,,.F.)
Private oFont17N 	:= TFont():New( "Arial",,30,,.T.,,,,,.F.)

//Start de impressão
Private oPrn:= TMSPrinter():New()

oPrn:SetLandScape()  // SetPortrait() - Formato retrato   SetLandscape() - Formato Paisagem

While (_cAlias)->(!Eof())
	nLin := 400
	oPrn:say(nLin,0300,"Produto: ", oFont17)		  									//item
	oPrn:say(nLin,0800,(_cAlias)->B1_DESC, oFont17N)
//	oPrn:say(nLin,0150,Transform((_cAlias)->C7_QUANT,"@R 999999"), oFont08)				//Quantidade
	nLin += 150
	oPrn:say(nLin,0300,"Fornecedor:",oFont17)
	nLin += 150
	oPrn:say(nLin,0300,"Quantidade",oFont17)
	nLin += 150
	oPrn:say(nLin,0300,"Lote",oFont17)												//unidade de medida
//	oPrn:say(nLin,3150,DTOC((_cAlias)->C7_DATPRF),oFont08)									//data de entrega
	nLin += 150
	oPrn:say(nLin,0300,"Nota Fiscal",oFont17)
	nLin += 150
	oPrn:say(nLin,0300,"Data de Recebimento",oFont17)
	nLin += 150
	oPrn:say(nLin,0300,"Status do Produto:",oFont17)
	nLin += 180
	oPrn:say(nLin,0250,"APROVADO",oFont17)
	oPrn:say(nLin,0900,"REPROVADO",oFont17)
	oPrn:say(nLin,1650,"APROVADO COM RESTRIÇÃO",oFont17)
	nLin += 150
	oPrn:say(nLin,0250,"Data Inspeção:",oFont12)	
	oPrn:say(nLin,0900,"Responsável:",oFont12)	
	oPrn:say(nLin,1800,"Ger./Sup. CQ:",oFont12)	
	nLin += 150
	oPrn:say(nLin,0250,"_____/_____/____",oFont12)
	oPrn:say(nLin,0900,"___________________",oFont12)
	oPrn:say(nLin,1800,"___________________",oFont12)
//	oPrn:line(1960,0075,1960,3425)    //Linha Horizontal Rodape Inferior
	oPrn :EndPage() 
	(_cAlias)->(dBskip())
EndDo

If(mv_par11 == 1)
  oPrn:Print()
Else
  oPrn:Preview() //Preview DO RELATORIO
EndIf

Return

//********************************************************************************************
// 										   		QUERY
//********************************************************************************************
Static Function MontaQuery

Local cQuery  

cQuery := "SELECT DISTINCT SD1.D1_DOC,SD1.D1_ITEM, SD1.D1_FORNECE, SD1.D1_LOJA ,SD1.D1_QUANT, SD1.D1_LOTECTL, SD1.D1_DTDIGIT,"
cQuery += " SA2.A2_COD, SA2.A2_NOME, SA2.A2_END, SA2.A2_BAIRRO, SA2.A2_EST, SA2.A2_MUN, SA2.A2_CEP,"
cQuery += " SA2.A2_CGC, SA2.A2_INSCR, SA2.A2_TEL, SA2.A2_FAX, SA2.A2_DDD, SB1.B1_DESC"
cQuery += " FROM "+RetSqlName('SD1')+" SD1 "
cQuery += " INNER JOIN "+RetSqlName('SA2')+" SA2 ON SA2.A2_FILIAL = '"+xFilial("SA2")+"' AND SD1.D1_FORNECE =  SA2.A2_COD AND SD1.D1_LOJA = SA2.A2_LOJA AND SA2.D_E_L_E_T_ <> '*' "
cQuery += " INNER JOIN "+RetSqlName('SB1')+" SB1 ON SB1.B1_FILIAL = '"+xFilial("SB1")+"' AND SD1.D1_COD =  SB1.B1_COD AND SB1.D_E_L_E_T_ <> '*' "
cQuery += " WHERE SD1.D1_FILIAL = '"+xFilial("SD1")+"' "
cQuery += "   AND SD1.D1_FORNECE BETWEEN '"+(MV_PAR01)+"' AND '"+(MV_PAR02)+"'
cQuery += "   AND SD1.D1_LOJA    BETWEEN '"+(MV_PAR03)+"' AND '"+(MV_PAR04)+"'
cQuery += "   AND SD1.D1_DOC     BETWEEN '"+(MV_PAR05)+"' AND '"+(MV_PAR06)+"'
cQuery += "   AND SD1.D1_SERIE   BETWEEN '"+(MV_PAR07)+"' AND '"+(MV_PAR08)+"'
cQuery += "   AND SD1.D1_DTDIGIT BETWEEN '"+Dtos(MV_PAR09)+"' AND '"+Dtos(MV_PAR10)+"'
cQuery += "   AND SD1.D_E_L_E_T_ <> '*' "

If Upper(TcGetDb()) $ "ORACLE.INFORMIX"
	cQuery += "   ORDER BY 1,2,3,4"
Else
	cQuery += "   ORDER BY SD1.D1_DOC,SD1.D1_ITEM, SD1.D1_FORNECE, SD1.D1_LOJA"
Endif

//Criar alias temporário
TCQUERY cQuery NEW ALIAS (_cAlias)

tCSetField((_cAlias), "D1_DTDIGIT", "D")

Return

//********************************************************************************************
// 										   		Grupo de perguntas
//********************************************************************************************
Static Function AjustaSX1()

Local i 		:= 0
Local aArea	:= GetArea()
Local nTamForn:= TamSX3("A2_COD")[1]
Local nTamLoja:= TamSX3("A2_LOJA")[1]
Local nTamNF:= TamSX3("D1_DOC")[1]
Local nTamSer:= TamSX3("D1_SERIE")[1]

dbSelectArea("SX1")
dbSetOrder(1)
cPerg := PADR("FB_IRP",10)
aRegs:={}

// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
AADD(aRegs,{cPerg,"01","Do Fornecedor ?"			,"¿De proveedor		 ?","From Supplier 	?"    ,"mv_ch1","C",nTamForn,0,0,"G","","mv_par01",""        	,""				,""         ,"","",""      ,""			,""			,"","",""       ,"","","","",""       ,"","","","",""        ,"","","","SA2","S"})
AADD(aRegs,{cPerg,"02","Até o Fornecedor ?"			,"¿A proveedor 		 ?","To Supplier		?","mv_ch2","C",nTamForn,0,0,"G","","mv_par02",""        	,""				,""         ,"","",""      ,""			,""			,"","",""       ,"","","","",""       ,"","","","",""        ,"","","","SA2","S"})
AADD(aRegs,{cPerg,"03","Da loja ?"					,"¿De Tienda		 ?","From Unit    	?"    ,"mv_ch3","C",nTamLoja,0,0,"G","","mv_par03",""        	,""				,""         ,"","",""      ,""			,""			,"","",""       ,"","","","",""       ,"","","","",""        ,"","","",""   ,"S"})
AADD(aRegs,{cPerg,"04","Até loja ?"					,"¿A Tienda 		 ?","To Unit         ?"   ,"mv_ch4","C",nTamLoja,0,0,"G","","mv_par04",""        	,""				,""         ,"","",""      ,""			,""			,"","",""       ,"","","","",""       ,"","","","",""        ,"","","",""   ,"S"})
AADD(aRegs,{cPerg,"05","Da NF     ?"				,"¿De Pedido		 ?","From Order 		?","mv_ch5","C",nTamNF,0,0,"G","","mv_par05",""        	,""				,""         ,"","",""      ,""			,""			,"","",""       ,"","","","",""       ,"","","","",""        ,"","","","","S"})
AADD(aRegs,{cPerg,"06","Até NF       ?"				,"¿A pedido			 ?","To Order 		?"    ,"mv_ch6","C",nTamNF,0,0,"G","","mv_par06",""        	,""				,""         ,"","",""      ,""			,""			,"","",""       ,"","","","",""       ,"","","","",""        ,"","","","","S"})
AADD(aRegs,{cPerg,"07","Da Serie  ?"				,"¿De Pedido		 ?","From Order 		?","mv_ch7","C",nTamSer,0,0,"G","","mv_par07",""        	,""				,""         ,"","",""      ,""			,""			,"","",""       ,"","","","",""       ,"","","","",""        ,"","","","","S"})
AADD(aRegs,{cPerg,"08","Até Serie    ?"				,"¿A pedido			 ?","To Order 		?"    ,"mv_ch8","C",nTamSer,0,0,"G","","mv_par08",""        	,""				,""         ,"","",""      ,""			,""			,"","",""       ,"","","","",""       ,"","","","",""        ,"","","","","S"})
AADD(aRegs,{cPerg,"09","Da Emissão ?"				,"¿De emision 		 ?","From Issue 		?","mv_ch9","D",08	    ,0,0,"G","","mv_par09",""        	,""				,""         ,"","",""      ,""		  	,""			,"","",""       ,"","","","",""       ,"","","","",""        ,"","","",""   ,"S"})
AADD(aRegs,{cPerg,"10","Até Emissão ?"				,"¿A emision 		 ?","To Issue 		?"    ,"mv_cha","D",08	    ,0,0,"G","","mv_par10",""        	,""				,""         ,"","",""      ,""   		,""		    ,"","",""       ,"","","","",""       ,"","","","",""        ,"","","",""   ,"S"})
AADD(aRegs,{cPerg,"11","Tipo de Impressão ?"		,"¿tipo de impresión?" ,"type of printing?"   ,"mv_chb","N",01	    ,0,1,"C","","mv_par11","Impressora" , "Impresora" , "Printer","","", "Tela", "Pantalla"	, "Screen"	,"","",""		    ,"","","","",""		  ,"","","","",""		 ,"","","",""   ,"S"})

For i:=1 to Len(aRegs)
	If !dbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
			X1_GRUPO  	:= aRegs[i,1]
			X1_ORDEM  	:= aRegs[i,2]
			X1_PERGUNT	:= aRegs[i,3]
			X1_PERSPA	:= aRegs[i,4]
			X1_PERENG	:= aRegs[i,5]
			X1_VARIAVL	:= aRegs[i,6]
			X1_TIPO  	:= aRegs[i,7]
			X1_TAMANHO	:= aRegs[i,8]
			X1_DECIMAL	:= aRegs[i,9]
			X1_PRESEL	:= aRegs[i,10]
			X1_GSC		:= aRegs[i,11]
			X1_VAR01	:= aRegs[i,13]
			X1_DEF01	:= aRegs[i,14]
			X1_DEFSPA1	:= aRegs[i,15]
			X1_DEFENG1	:= aRegs[i,16]
			X1_DEF02	:= aRegs[i,19]
			X1_DEFSPA2	:= aRegs[i,20]
			X1_DEFENG2	:= aRegs[i,21]
			X1_F3		:= aRegs[i,38]
			X1_PYME	:= aRegs[i,39]
		SX1->(MsUnlock())
	Endif
Next

RestArea(aArea)

Return
