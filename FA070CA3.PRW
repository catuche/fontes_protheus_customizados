#Include "RwMake.ch"
#Include "TopConn.ch"

/*/{Protheus.doc} FA070CA3
Ponto de entrada no cancelamento da baixa

Aplicação: Verificar se é cheque e não permitir cancelar a baixa manualmente.
Exigir que seja feita pela rotina de devolução

@author raphael.neves
@since 02/03/2018
@version 6
@return ${return}, ${return_description}

@type function
/*/

User Function FA070CA3()

	// Ponto de Entrada no Estorno da Baixa para verificar se é algum cheque para não permitir o estorno pelo padrão
	aAreaSE5 := SE5->(GetArea())

	lRet := .T.
	//Verifica se é cheque e possui o campo de borderô preenchido
	//Cheques originados pela customização só podem ser devolvidos pela Devolução de Cheques
	IF SE1->E1_TIPO == 'CH' .and. !(FunName() == "LOJA190")
		DbSelectArea("SEF")
		SEF->(DbSetOrder(3)) //Ordena pelo numero do título
		IF SEF->(MsSeek(xFilial("SEF")+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+SE1->E1_TIPO))
			MsgInfo("Cancelamento de cheque deverá ser realizado pela rotina 'Cheques Recebidos/Devolução de Cheque' ! ")
			lRet := .F.
		EndIf
	Endif


	RestArea(aAreaSE5)

Return lRet