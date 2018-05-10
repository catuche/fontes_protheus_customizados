#include "rwmake.ch"
#include "topconn.ch
                 

User Function M030INC           
    Local _nOp     := PARAMIXB
	Local aAreaSA1 := SA1->(GetArea())
	Local aAreaCTD := CTD->(GetArea())
	Local _nSeq  := 0
	
	if _nOp <> 3
		DbSelectArea("CTD")                                	
		CTD->(DbSetOrder(1))
		
		If !(CTD->(DbSeek(xFilial("CTD")+"C"+SA1->A1_COD+SA1->A1_LOJA)))	                     
			RecLock("CTD",.T.)
			CTD->CTD_FILIAL	:= xFilial("CTD")
			CTD->CTD_ITEM  	:= "C"+SA1->A1_COD+SA1->A1_LOJA
			CTD->CTD_CLASSE	:= "2"
			CTD->CTD_DESC01	:= SA1->A1_NOME
			CTD->CTD_BLOQ	:= "2"
		   	CTD->CTD_DTEXIS := CTOD("01/01/1980")
		   	CTD->CTD_ITLP   := "C"+SA1->A1_COD+SA1->A1_LOJA
		   	SA1->A1_XITEMCC  := "C"+SA1->A1_COD+SA1->A1_LOJA
			CTD->(MsUnLock())	     
		EndIF
	endif
return


