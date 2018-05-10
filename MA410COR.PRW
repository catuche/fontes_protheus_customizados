#Include 'Protheus.ch'
#Include 'TopConn.ch'
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMA410COR   บAutor  ณTOTVS NORDESTE      บ Data ณ  05/02/15  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPonto de entrada para Regra da cor da legenda, para pedidos บฑฑ
ฑฑบ				faturados parcialmente			                          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณFaturamento		                                          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function MA410COR()
	Local aCores := {}
	
	//MsAguarde({||fnAtuSts()},"Atualizando pedidos","Aguarde...")
	fnAtuSts()
		
	AADD(aCores,{"Empty(C5_NOTA) .And. !Empty(C5_LIBEROK) .And. C5_XSTATUS=='F'","BR_VIOLETA"   ,"Bloqueio Financeiro"        })
	AADD(aCores,{"Empty(C5_NOTA) .And. Empty(C5_LIBEROK)  .And. C5_XSTATUS=='P'","BR_CINZA"     ,"Fat.Parcial e Nใo Lib.Comercial"})
	AADD(aCores,{"Empty(C5_NOTA) .And. !Empty(C5_LIBEROK) .And. C5_XSTATUS=='P'","BR_AZUL_CLARO","Fat.Parcial e Lib.Comercial"})
	
	For nX := 1 to Len(PARAMIXB)
		AADD(aCores,PARAMIXB[nX])
	Next nX		
	
Return aCores

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMA410COR   บAutor  ณTOTVS NORDESTE      บ Data ณ  05/02/15  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPonto de entrada para Regra da cor da legenda, para pedidos บฑฑ
ฑฑบ				faturados parcialmente			                          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณFaturamento		                                          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fnAtuSts 
						 						  
//Pedidos em aberto sem faturamentos parciais
cQuery:="UPDATE "+RetSqlName("SC5")+" "
cQuery+="SET C5_XSTATUS = ' ' "
cQuery+="WHERE C5_FILIAL+C5_NUM IN(SELECT C5_FILIAL+C5_NUM "
cQuery+="						  FROM "+RetSqlName("SC5")+" SC5,"+RetSqlName("SC6")+" SC6 "
cQuery+="						  WHERE SC5.D_E_L_E_T_ <> '*' "
cQuery+="						  AND SC6.D_E_L_E_T_ <> '*' "
cQuery+="						  AND C5_FILIAL = C6_FILIAL "
cQuery+="						  AND C5_NUM = C6_NUM "
cQuery+="						  AND C5_NOTA = '' "
cQuery+="						  GROUP BY C5_FILIAL,C5_NUM  "
cQuery+="						  HAVING SUM(C6_QTDENT) = 0 "
cQuery+="						  ) "

If (TCSQLExec(cQuery) < 0)
    MsgStop("TCSQLError() :" + TCSQLError())
EndIf

//Pedidos em aberto parciais
cQuery:="UPDATE "+RetSqlName("SC5")+" "
cQuery+="SET C5_XSTATUS = 'P' "
cQuery+="WHERE C5_FILIAL+C5_NUM IN(SELECT C5_FILIAL+C5_NUM "
cQuery+="						  FROM "+RetSqlName("SC5")+" SC5,"+RetSqlName("SC6")+" SC6 "
cQuery+="						  WHERE SC5.D_E_L_E_T_ <> '*' "
cQuery+="						  AND SC6.D_E_L_E_T_ <> '*' "
cQuery+="						  AND C5_FILIAL = C6_FILIAL "
cQuery+="						  AND C5_NUM = C6_NUM "
cQuery+="						  AND C5_NOTA = '' "
cQuery+="						  GROUP BY C5_FILIAL,C5_NUM "
cQuery+="						  HAVING SUM(C6_QTDENT) > 0 "
cQuery+="						  ) "
						  
If (TCSQLExec(cQuery) < 0)
    MsgStop("TCSQLError() :" + TCSQLError())
EndIf

//Pedidos em aberto com bloqueio de credito
cQuery := "UPDATE "+RetSqlName("SC5")+" "
cQuery += "SET C5_XSTATUS = 'F' "
cQuery += "WHERE C5_FILIAL+C5_NUM IN(SELECT C5_FILIAL+C5_NUM "
cQuery += "						  FROM "+RetSqlName("SC5")+" SC5,"+RetSqlName("SC6")+" SC6, "+RetSqlName("SC9")+" SC9 "
cQuery += "						  WHERE SC5.D_E_L_E_T_ <> '*' "
cQuery += "						  AND SC6.D_E_L_E_T_ <> '*' "
cQuery += "						  AND SC9.D_E_L_E_T_ <> '*' "
cQuery += "						  AND C6_FILIAL = C5_FILIAL "
cQuery += "						  AND C9_FILIAL = C5_FILIAL "
cQuery += "						  AND C6_NUM = C5_NUM "
cQuery += "						  AND C9_PEDIDO = C5_NUM "
cQuery += "						  AND C9_ITEM = C6_ITEM "
cQuery += "						  AND C5_NOTA = '' "
cQuery += "						  AND C9_NFISCAL = '' "
cQuery += "						  AND C9_BLCRED <> '' "
cQuery += "						  GROUP BY C5_FILIAL,C5_NUM	"					  
cQuery += "						  )"

If (TCSQLExec(cQuery) < 0)
    MsgStop("TCSQLError() :" + TCSQLError())
EndIf

Return