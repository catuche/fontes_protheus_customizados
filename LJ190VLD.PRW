#Include "RwMake.ch"
#Include "TBIConn.ch"

/*/{Protheus.doc} LJ190VLD
Ponto de entrada na devolução do cheque

Aplicação: Estornar a baixa do cheque

@author raphael.neves
@since 02/03/2018
@version 6
@return ${return}, ${return_description}

@type function
/*/

User Function LJ190VLD()

	// Ponto de Entrada para estornar a Baixa do Cheque automaticamente pela rotina de devolução
	// E Caso esteja associado a algum borderô, excluir do borderô
	If SE1->E1_SALDO == 0
		Processa({|| CancChq()},"Estornando Cheque...")
		Return .T.
	Else
		MsgInfo("É necessário baixar o cheque antes de executar a devolução.")
		Return .F.
	Endif

Return

Static Function CancChq()

	Begin Transaction

		cHist    := "Canc. Baixa - Chq Dev."
		aTitulo := {}

		Aadd(aTitulo, {"E1_PREFIXO" , SE1->E1_PREFIXO    , nil})
		Aadd(aTitulo, {"E1_NUM"     , SE1->E1_NUM        , nil})
		Aadd(aTitulo, {"E1_PARCELA" , SE1->E1_PARCELA    , nil})
		Aadd(aTitulo, {"E1_TIPO"    , SE1->E1_TIPO       , nil})
		Aadd(aTitulo, {"E1_CLIENTE" , SE1->E1_CLIENTE    , nil})
		Aadd(aTitulo, {"E1_LOJA"    , SE1->E1_LOJA       , nil})
		Aadd(aTitulo, {"AUTHIST"    , cHist              , nil})

		lMsErroAuto := .F.

		MSExecAuto({|x,w| fina070(x,w)},aTitulo,5)

		If lMsErroAuto
			MostraErro()
			lRet := .F.

			DisarmTransaction()

			Return
		Endif

		IF !Empty(SE1->E1_NUMBOR)
			DbSelectArea("SEA")
			SEA->(DbSetOrder(2))
			IF SEA->(MsSeek(xFilial("SE1")+SE1->(E1_NUMBOR+"R"+E1_PREFIXO+E1_NUM+E1_PARCELA)))
				RecLock("SEA",.F.)
				SEA->(dbDelete())
				SEA->(MsUnlock())
			Endif
			SEA->(DbCloseArea())

			RecLock("SE1",.F.)
			Replace E1_NUMBOR  With Space(TamSx3("E1_NUMBOR")[1])
			Replace E1_DATABOR With CTOD("//")
			Replace E1_PORTADO With ""
			Replace E1_AGEDEP  With ""
			Replace E1_CONTA   With ""
			Replace E1_SITUACA With "0"
			Replace E1_NUMBCO  With ""
			SE1->(MsUnlock())
		EndIf

	End Transaction
Return