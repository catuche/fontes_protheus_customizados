#Include 'Protheus.ch'

/*/{Protheus.doc} LIBCARGA
Fun��o para liberar a carga para faturamento. Trabalha em conjunto com o Ponto de Entrada M460QRY

Objetivo: Marcar flag em campo customizado (DAK_XLIBER).

@type function
@author raphael.neves
@since 03/02/2017
@version 1.0
@param nOpc, num�rico, (Descri��o do par�metro)
@return ${return}, ${return_description}
@example
(examples)
@see (links_or_references)
/*/

User Function LIBCARGA(nOpc)
	Local aArea := GetArea()
	
	IF nOpc == 1 //Libera��o de Carga
		If RecLock("DAK",.F.)
			//Replace DAK_XLIBER With 'S' //Comentado por Raphael Neves 06.06.2017
			Replace DAK_BLQCAR With ' ' 
			MsgInfo("Carga liberada!")
		Endif
	Else
		//Verifica se j� existe NF emitida com a carga
		DbSelectArea("SF2")
		SF2->(DbSetOrder(14))
		IF SF2->(MsSeek(xFilial("SF2") + DAK->DAK_COD + DAK->DAK_SEQCAR ))
			MsgAlert("N�o pode estornar a libera��o, pois carga j� foi faturada.","Aten��o")
		Else
			If RecLock("DAK",.F.)
				//Replace DAK_XLIBER With 'N'//Comentado por Raphael Neves 06.06.2017
				Replace DAK_BLQCAR With '1' 
				MsgInfo("Libera��o cancelada!")
			Endif
		EndIf
	Endif

	RestArea(aArea)
Return

