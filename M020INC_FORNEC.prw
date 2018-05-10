#include "rwmake.ch"
#include "topconn.ch
           

User Function M020INC
Local _nOp     := PARAMIXB
Local aAreaSA2 := SA2->(GetArea())
Local aAreaCTD := CTD->(GetArea())

DbSelectArea("CTD")
CTD->(DbSetOrder(1))
if _nOp <> 3
	If !(CTD->(DbSeek(xFilial("CTD")+"F"+SA2->A2_COD+SA2->A2_LOJA)))
		                 
		RecLock("CTD",.T.)
		CTD->CTD_FILIAL := xFilial("CTD") 
		CTD->CTD_ITEM	:= "F"+SA2->A2_COD+SA2->A2_LOJA
		CTD->CTD_CLASSE := "2"          
		CTD->CTD_DESC01 := SA2->A2_NOME
		CTD->CTD_BLOQ	:= "2"    
	   	CTD->CTD_DTEXIS := CTOD("01/01/1980")
	   	CTD->CTD_ITLP 	:= "F"+SA2->A2_COD+SA2->A2_LOJA
		SA2->A2_XITEMCC  := "F"+SA2->A2_COD+SA2->A2_LOJA
		CTD->(MsUnLock())          
	
	EndIF
endif	
RestArea(aAreaSA2)
RestArea(aAreaCTD)

Return(.T.)   