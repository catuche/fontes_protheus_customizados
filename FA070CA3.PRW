#Include "RwMake.ch"
#Include "TopConn.ch"

/*/{Protheus.doc} FA070CA3
Ponto de entrada no cancelamento da baixa

Aplica��o: Verificar se � cheque e n�o permitir cancelar a baixa manualmente.
Exigir que seja feita pela rotina de devolu��o

@author raphael.neves
@since 02/03/2018
@version 6
@return ${return}, ${return_description}

@type function
/*/

User Function FA070CA3()

	// Ponto de Entrada no Estorno da Baixa para verificar se � algum cheque para n�o permitir o estorno pelo padr�o
	aAreaSE5 := SE5->(GetArea())

	lRet := .T.
	//Verifica se � cheque e possui o campo de border� preenchido
	//Cheques originados pela customiza��o s� podem ser devolvidos pela Devolu��o de Cheques
	IF SE1->E1_TIPO == 'CH' .and. !(FunName() == "LOJA190")
		DbSelectArea("SEF")
		SEF->(DbSetOrder(3)) //Ordena pelo numero do t�tulo
		IF SEF->(MsSeek(xFilial("SEF")+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+SE1->E1_TIPO))
			MsgInfo("Cancelamento de cheque dever� ser realizado pela rotina 'Cheques Recebidos/Devolu��o de Cheque' ! ")
			lRet := .F.
		EndIf
	Endif


	RestArea(aAreaSE5)

Return lRet