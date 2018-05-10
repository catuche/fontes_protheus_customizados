#include "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FINMI002  ºAutor  ³Thiago Comelli      º Data ³  24/01/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de entrada utilizado para passar o codigo de barras  º±±
±±º          ³ dos titulos selecionados em um bordero de pagamentos       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MP8 - FINANCEIRO                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function F240TBOR()

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
	//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
	//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
	//³ Incluido pelo assistente de conversao do AP6 IDE                    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	SetPrvt("LinDig,CODBAR,CODDSP,NOSSON,vValor")

	cLinDig := Space(47)

	DbSelectArea("SE2")
	If SE2->E2_tipo # "TX"

		CodBar := se2->e2_codbar
		vValor := se2->e2_saldo

		@ 000,000 TO 190,332 DIALOG oDlg1 TITLE "Entrada de Codigo de Barras do Titulo"

		@ 005,010 SAY "Titulo"
		@ 005,045 SAY se2->e2_prefixo+" "+se2->e2_num+" "+se2->e2_parcela+" "+se2->e2_tipo

		@ 015,010 SAY "Fornecedor"
		@ 015,045 SAY se2->e2_nomfor

		@ 025,010 SAY "Valor R$"
		@ 025,045 GET vValor SIZE 80,47 picture "@e 9,999,999.99"

		@ 040,010 SAY "Linha Digitável"
		@ 051,010 GET cLinDig SIZE 148,47  Valid NaoVazio() .and. ConvBar(cLinDig)

		@ 065,010 SAY "Codigo de Barras"
		@ 075,010 GET CodBar SIZE 148,47  Valid NaoVazio()
		@ 085,131 BMPBUTTON TYPE 01 ACTION GravaBar()

		ACTIVATE DIALOG oDlg1 CENTER

	EndIf

	RecLock("SEA",.F.)
	Replace EA_XBLOQ With "S"
	SEA->(MsUnlock())

	RecLock("SE2",.F.)
	Replace E2_XBLOQ With "S"
	SE2->(MsUnlock())

Return(nil)

*****************************************************************************

Static Function ConvBar(cLinDig)

	cBanco      := Substr(cLindig,1,3)
	cMoeda      := Substr(cLindig,4,1)
	cCampoLivre := Substr(cLindig,5,27)
	cDigVer     := Substr(cLinDig,33,1)
	cFator      := Substr(cLinDig,34,14)
	cFatBarra   := Substr(cCampoLivre,1,5)+Substr(cCampoLivre,7,10)+Substr(cCampoLivre,18,10)

	cBloco1 := Substr(cLindig,1,11)
	cBloco2 := Substr(cLindig,13,11)
	cBloco3 := Substr(cLindig,25,11)
	cBloco4 := Substr(cLindig,37,11)

	IF Substr(cLindig,1,1) == "8"
	   	Codbar := cBloco1 + cBloco2 + cBloco3 + cBloco4
	Else
		CodBar  := cBanco+cMoeda+cDigVer+cFator+cFatbarra
	Endif

Return

*****************************************************************************

Static Function GravaBar()

	if alltrim(CodBar) == "0" .or. alltrim(CodBar) == "" .or. Len(alltrim(CodBar)) < 5
		if sa2->(dbseek(xFilial("SA2")+se2->e2_fornece+se2->e2_loja))
			// Abrir tela para cadastro
			TelaBco()
		endif
	endif

	DbSelectArea("SE2")

	nValBar := Val(SubStr(CodBar,10,10))/100

	IF nValBar == vValor
		RecLock("SE2",.f.)

		IF Len(ALLTRIM(CodBar)) # 44

			cStr := CodBar

			// Se o Tamanho do String for menor que 44, completa com zeros até 47 dígitos. Isso é
			// necessário para Bloquetos que NÂO têm o vencimento e/ou o valor informados na LD.
			cStr := IF(LEN(cStr)<44,cStr+REPL("0",47-LEN(cStr)),cStr)

			IF Len(ALLTRIM(CodBar)) == 47
				//      Cod Banco         Cod Moeda        Digito Cod Barra   Fator Venc         Valor               |->   Campo livre tirando os 3 Digitos Verificadores  <-|
				cStr := SUBSTR(cStr,1,3)+SUBSTR(cStr,4,1)+SUBSTR(cStr,33,1)+SUBSTR(cStr,34,4)+SUBSTR(cStr,38,10)+SUBSTR(cStr,5,5)+SUBSTR(cStr,11,10)+SUBSTR(cStr,22,10)
			ENDIF

			se2->e2_codbar  := cStr

		else
			se2->e2_codbar  := CodBar //Grava Cod barras no SE2
		endif

		if Round(vValor,2) < Round(se2->e2_valor,2) // Atualiza Campo de desconto caso o valor seja alterado
			se2->e2_descont  := se2->e2_valor - vValor
			se2->e2_saldo    := se2->e2_valor - se2->e2_descont
		elseif Round(vValor,2) > Round(se2->e2_valor,2) // Atualiza Campo de Multa, caso o valor seja alterado
			se2->e2_acresc    := vValor - se2->e2_valor
			se2->e2_saldo    := se2->e2_valor + se2->e2_acresc
		endif

		/*
		if Round(se2->e2_descont,2) == Round(se2->e2_valor,2)  // Se o valor do desconto for igual o valor do titulo (Desconto total), baixa o titulo com a data atual.
			se2->e2_baixa  := ddatabase
			se2->e2_movimen:= ddatabase
		endif
		*/

		MsUnlock()

		Close(oDlg1)
	Else
		MsgAlert("Valor do boleto diferente do valor do título!")
	Endif
Return

**********************************************************************************************

Static Function TelaBco()

	DbSelectArea("SA2")
	dbseek(xFilial("SA2")+se2->e2_fornece+se2->e2_loja)


	cBanco  := sa2->a2_banco
	cAg     := SubStr(sa2->a2_agencia,1,4)
	cAgDig  := sa2->A2_DVAGE
	cConta  := sa2->a2_numcon
	cCcDig  := sa2->A2_DVCTA

	@ 000,000 TO 210,310 DIALOG oDlg2 TITLE "Cadastro da C/C do Fornecedor"

	@ 005,005 SAY "Banco"

	@ 017,005 SAY "Cod.Banco"
	@ 017,035 GET cBanco SIZE 17,50

	@ 029,005 SAY "Agencia"
	@ 029,035 GET cAg    SIZE 20,50

	@ 041,005 SAY "Dig Agencia"
	@ 041,035 GET cAgDig    SIZE 17,50

	@ 053,005 SAY "C/Corrente"
	@ 053,035 GET cConta SIZE 50,50

	@ 065,005 SAY "Dig C/Corrente"
	@ 065,035 GET cCcDig SIZE 50,50

	@ 077,085 BMPBUTTON TYPE 01 ACTION GravaFor()
	@ 077,120 BMPBUTTON TYPE 02 ACTION Close(oDlg2)

	ACTIVATE DIALOG oDlg2 CENTER

Return

*********************************************************************************************

Static Function GravaFor()

	RecLock("SA2",.f.)

	sa2->a2_banco   := cBanco
	sa2->a2_agencia := cAg
	sa2->a2_numcon  := cConta
	sa2->A2_DVCTA   := cCcDig
	sa2->A2_DVAGE   := cAgDig

	MsUnlock()

	Close(oDlg2)

Return

*********************************************************************************************
