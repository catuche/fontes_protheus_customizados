#include 'protheus.ch'
#include 'parmtype.ch'

/*/{Protheus.doc} FA590AROT
Ponto de entrada para adicionar item ao menu da manutenção do borderô

@author raphael.neves
@since 02/03/2018
@version 6
@return ${return}, ${return_description}

@type function
/*/

User function FA590AROT()

	Local aRotina := ParamIxb[1]

	aAdd(aRotina,{"Liberar Borderô","U_LIBBORD(SEA->EA_NUMBOR,.F.)",0,5})

Return aRotina

User Function LIBBORD(cParam1,lManut)

	//	Local lReceber := ( Type("lRecTrue") != "U" )
	Local aAreaSEA := SEA->(GetArea())
	Local aAreaSE2 := SE2->(GetArea())
	//	Local aAreaSE1 := SE1->(GetArea())
	Local cNumBor  := cParam1

	Begin Transaction

		IF SEA->EA_XBLOQ == "S" .and. !lManut
			SEA->(DbSetOrder(1))
			SEA->(MsSeek(xFilial("SEA") + cNumBor))

			While SEA->EA_NUMBOR == cNumBor
				RecLock("SEA",.F.)
				Replace EA_XBLOQ With ""
				SEA->(MsUnlock())
				SEA->(DbSkip())
			EndDo

			//			IF !lReceber
			SE2->(DbSetOrder(15))
			SE2->(MsSeek(xFilial("SE2") + cNumBor))
			While SE2->E2_NUMBOR == cNumBor
				RecLock("SE2",.F.)
				Replace E2_XBLOQ With ""
				SE2->(MsUnlock())
				SE2->(DbSkip())
			EndDo
			MsgInfo("Borderô liberado!")
			//			EndIf
		Else
			SEA->(DbSetOrder(1))
			SEA->(MsSeek(xFilial("SEA") + cNumBor))

			While SEA->EA_NUMBOR == cNumBor
				RecLock("SEA",.F.)
				Replace EA_XBLOQ With "S"
				SEA->(MsUnlock())
				SEA->(DbSkip())
			EndDo

			//			IF !lReceber
			SE2->(DbSetOrder(15))
			SE2->(MsSeek(xFilial("SE2") + cNumBor))
			While SE2->E2_NUMBOR == cNumBor
				RecLock("SE2",.F.)
				Replace E2_XBLOQ With "S"
				SE2->(MsUnlock())
				SE2->(DbSkip())
			EndDo
			MsgInfo("Borderô bloqueado!")
		Endif

	End Transaction

	//	RestArea(aAreaSE1)
	RestArea(aAreaSE2)
	RestArea(aAreaSEA)

Return
