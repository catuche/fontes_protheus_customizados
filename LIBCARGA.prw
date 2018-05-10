#Include 'Protheus.ch'

/*/{Protheus.doc} LIBCARGA
Função para liberar a carga para faturamento. Trabalha em conjunto com o Ponto de Entrada M460QRY

Objetivo: Marcar flag em campo customizado (DAK_XLIBER).

@type function
@author raphael.neves
@since 03/02/2017
@version 1.0
@param nOpc, numérico, (Descrição do parâmetro)
@return ${return}, ${return_description}
@example
(examples)
@see (links_or_references)
/*/

User Function LIBCARGA(nOpc)
	Local aArea := GetArea()
	
	IF nOpc == 1 //Liberação de Carga
		If RecLock("DAK",.F.)
			//Replace DAK_XLIBER With 'S' //Comentado por Raphael Neves 06.06.2017
			Replace DAK_BLQCAR With ' ' 
			MsgInfo("Carga liberada!")
		Endif
	Else
		//Verifica se já existe NF emitida com a carga
		DbSelectArea("SF2")
		SF2->(DbSetOrder(14))
		IF SF2->(MsSeek(xFilial("SF2") + DAK->DAK_COD + DAK->DAK_SEQCAR ))
			MsgAlert("Não pode estornar a liberação, pois carga já foi faturada.","Atenção")
		Else
			If RecLock("DAK",.F.)
				//Replace DAK_XLIBER With 'N'//Comentado por Raphael Neves 06.06.2017
				Replace DAK_BLQCAR With '1' 
				MsgInfo("Liberação cancelada!")
			Endif
		EndIf
	Endif

	RestArea(aArea)
Return

