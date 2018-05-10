#Include 'Protheus.ch'

/*/{Protheus.doc} M410STTS
Ponto de entrada executado após a Alteração, Inclusão, Cópia e exclusão.

Objetivo:

Gravar mensagens que irão para a nota em um campo MEMO, a fim de que o usuário possa ver
no pedido de venda

@type function
@author TOTVS NE - Raphael Neves
@since 16/02/2017
@version 1.0
@return ${return}, ${return_description}
@example
(examples)
@see (links_or_references)
/*/

User Function M410STTS()

	Local aAreaSC5  := SC5->(GetArea())
	Local cQuery := ""
	Local cTexto := ""
	Local cFormula := ""

	IF Inclui .or. Altera

		cQuery += " SELECT C6_TES FROM "+RetSqlName("SC6")
		cQuery += " WHERE D_E_L_E_T_ = ' ' "
		cQuery += " AND C6_FILIAL = '"+xFilial("SC6")+"' "
		cQuery += " AND C6_NUM = '"+SC5->C5_NUM+"' "
		cQuery += " GROUP BY C6_TES"

		cQuery := ChangeQuery(cQuery)

		IF Select("TMP") > 0
			TMP->(DbCloseArea())
		EndIF

		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TMP",.F.,.T.)

		DbSelectArea("TMP")
		TMP->(DbGoTop())

		While !TMP->(Eof())

			cFormula := Posicione("SF4",1,xFilial("SF4") + TMP->C6_TES , "F4_FORMULA")

			IF !Empty(cFormula)
				cTexto += Formula(cFormula) + CHR(10) + CHR(13)
			Endif

			TMP->(DbSkip())
		EndDo

		TMP->(DbCloseArea())

		IF !Empty(SC5->C5_MENPAD)
			cTexto += Formula(SC5->C5_MENPAD) + CHR(10) + CHR(13)
		Endif

		DbSelectArea("SA1")
		SA1->(DbSetOrder(1))
		SA1->(MsSeek(xFilial("SA1") + SC5->C5_CLIENTE + SC5->C5_LOJACLI ))

		IF !Empty(SA1->A1_MENSAGE)
			cTexto += Formula(SA1->A1_MENSAGE)
		EndIF

		If RecLock("SC5",.F.)
			Replace C5_XOBSNF With cTexto
			SC5->(MsUnlock())
		Endif
	Endif

	RestArea(aAreaSC5)

Return

