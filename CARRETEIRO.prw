#include "rwmake.ch"
#include "Protheus.ch"
#include "colors.ch"
#INCLUDE "MSOLE.CH"
#include "TOPCONN.CH"
#include "ap5mail.ch"
#DEFINE _OPC_cGETFILE ( GETF_RETDIRECTORY + GETF_LOCALFLOPPY + GETF_LOCALHARD + GETF_NETWORKDRIVE + GETF_SHAREAWARE )


/**********************************************************************************
Salvar o Folha de Ponto via .Dot
**********************************************************************************/

User Function CARRETEIRO()

	Local cTptCtc   := GetMV('MV_TPTCTC' ,,'')	//-- Verifica o parametro referente ao Tipo do Contrato de Carreteiro
	Local cUniao    := PadR( GetMV("MV_UNIAO",,""), Len(SA2->A2_COD) )		//-- Codigo para pagamento do Imposto de Renda
	Local cMunic    := PadR( GetMV("MV_MUNIC",,""), Len(SA2->A2_COD) )		//-- Codigo para Recolher o ISS
	Local cForINSS  := PadR( GetMV("MV_FORINSS",,""), Len(SA2->A2_COD) )	//-- Fornecedor padrao para Titulos de INSS
	Local cForSEST  := PadR( GetMV("MV_FORSEST",,""), Len(SA2->A2_COD) )	//-- Fornecedor padrao para Titulos de SEST
	Local aFornImp  := { {cUniao,''}, {cMunic,''}, {cForINSS,''}, {cForSEST,''} }
	Local nCount    := 0
	Local aTitSE2   := {}
	Local xI		:= 0
	Local cSeekSE2  := ''
	Local cFilCTC   := ''	//--Filial do Contr. Carreteiro
	Local cFilDbt   := ''	//--Filial de Debito do Contrato
	Local cPrefCTC  := ''	//--Prefixo do Contrato de carreteiro
	Local cCadOld   := cCadastro
	Local aArea     := GetArea()
	Local aAreaSE2  := SE2->( GetArea() )
	Local aAreaSA2  := SA2->( GetArea() )
	Local aAreaAnt  := GetArea()
	Local aAreaSDG  := SDG->( GetArea() )
	Local aAreaDT7  := DT7->( GetArea() )
	Local aArraySE2 := {}
	Local cSeek     := ''
	Local cChave    := ''
	Local cParcela  := StrZero(1, Len(SE2->E2_PARCELA))
	Local cPrefixo  := ''
	Local cFilDeb   := M->DTY_FILDEB          // Filial de Debito
	Local nOpca     := 0
	Local nCtn      := 0
	Local lFreteEmb := AliasIndic("DFI")
	Local cTipUso   := IIf(!lFreteEmb .Or. nModulo==43,"1","2")
	Local nFilAD    := Iif(cFilAnt == cFilDeb, 1 , 2)
	Local cPrefDeb  := ""

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³OBTEM OS DADOS DO TITULO PRINCIPAL E OS³
	//³DADOS DOS TITULOS DE IMPOSTOS          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	//--Verifica a filial do contrato de
	//--carreteiro X filial do titulo SE2:
	If Empty( FwFilial('SE2') )
		cFilCTC := xFilial('SE2')
	Else
		cFilCTC := M->DTY_FILORI
	EndIf

	//--Prefixo dos titulos:
	cPrefCTC := TMA250GerPrf( cFilAnt )

	cSeekSE2 := cFilCTC + M->(DTY_CODFOR + DTY_LOJFOR) + cPrefCTC + M->DTY_NUMCTC
	SE2->( DbSetOrder(6) ) //--E2_FILIAL+E2_FORNECE+E2_LOJA+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO
	If SE2->( DbSeeK( cSeekSE2 ) )

		//--Obtem a referencia dos titulos de impostos
		//--gerados a partir do titulo principal
		aFornImp[1,2] := SE2->E2_PARCIR
		aFornImp[2,2] := SE2->E2_PARCISS
		aFornImp[3,2] := SE2->E2_PARCINS
		aFornImp[4,2] := SE2->E2_PARCSES

		While !SE2->( Eof() ) .And.;
		SE2->(E2_FILIAL+E2_FORNECE+E2_LOJA+E2_PREFIXO+E2_NUM) == cSeekSE2
			//--Dados do titulo Principal
			AAdd(aTitSE2, {	;
			SE2->E2_FILIAL,;
			SE2->E2_PREFIXO,;
			SE2->E2_NUM,;
			SE2->E2_PARCELA,;
			SE2->E2_TIPO,;
			SE2->E2_FORNECE,;
			SE2->E2_LOJA,;
			DTOC(SE2->E2_EMISSAO),;
			TRANSFORM(SE2->E2_VALOR, PesqPict("SE2","E2_VALOR")),;
			DTOC(SE2->E2_VENCTO),;
			DTOC(SE2->E2_BAIXA) })

			SE2->( DbSkip() )
		End

		//--Titulos de Impostos (IR/ISS/INSS/SEST)
		//--Para localizar corretamente os titulos vinculados ao titulo
		//--principal, utilizamos os campos: E2_PARCIR, E2_PARCISS, E2_PARCINS
		//--E2_PARCSES.

		//--Exemplo:
		//--Quando utilizamos o SE2 compartilhado, ao gerar o contrato "000001" na filial
		//--"X", utilizando um fornecedor que gera os impostos (IR/INSS/ISS/SEST), os titulos
		//--de impostos ficarao -TODOS- com a parcela (E2_PARCELA) iguais a "01"
		//--Se gerarmos outro contrato, agora na filial "Y" com o mesmo numero ("000001")
		//--utilizando um fornecedor que tambem gera os impostos, os titulos ficarao com
		//--a parcela (E2_PARCELA) igual a "02".

		//--Isto porque a chave unica da tabela SE2 eh: E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA

		For nCount := 1 To Len( aFornImp )
			SE2->( DbSetOrder(6) ) //--E2_FILIAL+E2_FORNECE+E2_LOJA+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO
			If SE2->( DbSeek( cFilCTC + aFornImp[nCount,1] + Padr('00',Len(SE2->E2_LOJA)) + cPrefCTC + M->DTY_NUMCTC + aFornImp[nCount,2] ) )
				If aScan(aTitSE2,{|x|x[2]+x[3]+x[4]+x[5]+x[6]+x[7]+x[8]==SE2->(E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA)}) == 0
					AAdd(aTitSE2, {	;
					SE2->E2_FILIAL,;
					SE2->E2_PREFIXO,;
					SE2->E2_NUM,;
					SE2->E2_PARCELA,;
					SE2->E2_TIPO,;
					SE2->E2_FORNECE,;
					SE2->E2_LOJA,;
					DTOC(SE2->E2_EMISSAO),;
					TRANSFORM(SE2->E2_VALOR, PesqPict("SE2","E2_VALOR")),;
					DTOC(SE2->E2_VENCTO),;
					DTOC(SE2->E2_BAIXA) })
				EndIf
			EndIf
		Next

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³VERIFICA SE HOUVE A GERACAO DE TITULOS ³
		//³NA FILIAL DE DEBITO                    ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If Empty( cTptCtc ) .And. M->DTY_FILDEB <> cFilAnt
			cPrefDeb := TMA250GerPrf( M->DTY_FILDEB )
			cSeekSE2 := M->DTY_FILDEB + M->(DTY_CODFOR + DTY_LOJFOR) + cPrefDeb + M->DTY_NUMCTC

			SE2->( DbSetOrder(6) ) //--E2_FILIAL+E2_FORNECE+E2_LOJA+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO
			If SE2->( DbSeeK( cSeekSE2 ) )
				If aScan(aTitSE2,{|x|x[2]+x[3]+x[4]+x[5]+x[6]+x[7]+x[8]==SE2->(E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA)}) == 0
					//--Dados do titulo gerado contra o favorecido
					AAdd(aTitSE2, {	;
					SE2->E2_FILIAL,;
					SE2->E2_PREFIXO,;
					SE2->E2_NUM,;
					SE2->E2_PARCELA,;
					SE2->E2_TIPO,;
					SE2->E2_FORNECE,;
					SE2->E2_LOJA,;
					DTOC(SE2->E2_EMISSAO),;
					TRANSFORM(SE2->E2_VALOR, PesqPict("SE2","E2_VALOR")),;
					DTOC(SE2->E2_VENCTO),;
					DTOC(SE2->E2_BAIXA) })
				EndIf
			EndIf
		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³OBTEM OS DADOS DO TITULO GERADO CONTRA ³
		//³O FAVORECIDO (SE HOUVER)               ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !Empty( M->DTY_CODFAV ) .And. !Empty( M->DTY_LOJFAV )
			cSeekSE2 := M->(cFilCTC + DTY_CODFAV + DTY_LOJFAV) + cPrefCTC + M->DTY_NUMCTC
			SE2->( DbSetOrder(6) ) //--E2_FILIAL+E2_FORNECE+E2_LOJA+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO
			If SE2->( DbSeek( cSeekSE2 ) )
				While !SE2->( Eof() ) .And. SE2->(E2_FILIAL+E2_FORNECE+E2_LOJA+E2_PREFIXO+E2_NUM) == cSeekSE2
					If aScan(aTitSE2,{|x|x[2]+x[3]+x[4]+x[5]+x[6]+x[7]+x[8]==SE2->(E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA)}) == 0

						//--Dados do titulo gerado contra o favorecido
						AAdd(aTitSE2, {;
						SE2->E2_FILIAL,;
						SE2->E2_PREFIXO,;
						SE2->E2_NUM,;
						SE2->E2_PARCELA,;
						SE2->E2_TIPO,;
						M->DTY_CODFAV,;
						M->DTY_LOJFAV,;
						DTOC(SE2->E2_EMISSAO),;
						TRANSFORM(SE2->E2_VALOR, PesqPict("SE2","E2_VALOR")),;
						DTOC(SE2->E2_VENCTO),;
						DTOC(SE2->E2_BAIXA) })
					EndIf
					SE2->( DbSkip() )
				EndDo
			EndIf
		EndIf

		//		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//		//³OBTEM OS DADOS DOS TITULOS DE ADTO     ³
		//		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		//
		//		If M->DTY_ADIFRE > 0
		//			cSeekSE2 := xFilial('SE2') + Iif( !Empty( M->DTY_CODFAV ) .And. !Empty( M->DTY_LOJFAV ), M->(DTY_CODFAV+DTY_LOJFAV), M->(DTY_CODFOR+DTY_LOJFOR)) + cPrefCTC + M->DTY_VIAGEM
		//			SE2->( DbSetOrder(6) ) //--E2_FILIAL+E2_FORNECE+E2_LOJA+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO
		//			If SE2->( DbSeek( cSeekSE2 ) ) .And. SE2->E2_TIPO == Padr( "PA", Len( SE2->E2_TIPO ) )
		//				If aScan(aTitSE2,{|x|x[2]+x[3]+x[4]+x[5]+x[6]+x[7]+x[8]==SE2->(E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA)}) == 0
		//
		//					//--Dados do titulo gerado contra o favorecido
		//					AAdd(aTitSE2, {;
		//					SE2->E2_FILIAL,;
		//					SE2->E2_PREFIXO,;
		//					SE2->E2_NUM,;
		//					SE2->E2_PARCELA,;
		//					SE2->E2_TIPO,;
		//					SE2->E2_FORNECE,;
		//					SE2->E2_LOJA,;
		//					DTOC(SE2->E2_EMISSAO),;
		//					TRANSFORM(SE2->E2_VALOR, PesqPict("SE2","E2_VALOR")),;
		//					DTOC(SE2->E2_VENCTO),;
		//					DTOC(SE2->E2_BAIXA) })
		//				EndIf
		//			EndIf
		//		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³OBTEM OS DADOS DOS TITULOS NDF         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		//		cSeekSE2 := xFilial('SE2') + M->(DTY_CODFOR+DTY_LOJFOR) + cPrefCTC + M->DTY_VIAGEM
		//		SE2->( DbSetOrder(6) ) //--E2_FILIAL+E2_FORNECE+E2_LOJA+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO
		//		If SE2->( DbSeek( cSeekSE2 ) )
		//			While !SE2->( Eof() ) .And. SE2->(E2_FILIAL+E2_FORNECE+E2_LOJA+E2_PREFIXO+E2_NUM) == cSeekSE2
		//				If SE2->E2_TIPO == Padr( "NDF", Len( SE2->E2_TIPO ) )
		//					If aScan(aTitSE2,{|x|x[2]+x[3]+x[4]+x[5]+x[6]+x[7]+x[8]==SE2->(E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA)}) == 0
		//
		//						//--Dados do titulo gerado contra o favorecido
		//						AAdd(aTitSE2, {;
		//						SE2->E2_FILIAL,;
		//						SE2->E2_PREFIXO,;
		//						SE2->E2_NUM,;
		//						SE2->E2_PARCELA,;
		//						SE2->E2_TIPO,;
		//						SE2->E2_FORNECE,;
		//						SE2->E2_LOJA,;
		//						DTOC(SE2->E2_EMISSAO),;
		//						TRANSFORM(SE2->E2_VALOR, PesqPict("SE2","E2_VALOR")),;
		//						DTOC(SE2->E2_VENCTO),;
		//						DTOC(SE2->E2_BAIXA) })
		//					EndIf
		//				EndIf
		//				SE2->( DbSkip() )
		//			End
		//		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³MONTA DIALOG COM OS TITULOS VINCULADOS ³
		//³AO CONTRATO DO CARRETEIRO              ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If Len(aTitSE2) > 0
			MsgRun("Impressão do Recibo", "Aguarde...", ;
			{|| GeraDot(aTitSE2[1,1],;
			aTitSE2[1,2],;
			aTitSE2[1,3],;
			aTitSE2[1,4],;
			aTitSE2[1,5],;
			aTitSE2[1,6],;
			aTitSE2[1,7] )}  )
		Else
			Help('',1,'TMSA25019')
		EndIf
	Else
		Help('',1,'TMSA25019')
	EndIf

	//-- Retorna Teclas de Atalhos
	TMSKeyOn(aSetKey)
	cCadastro := cCadOld

	//--Restaura o ambiente
	RestArea( aArea )
	RestArea( aAreaSE2 )
	RestArea( aAreaSA2 )
	RestArea( aAreaSDG )
	RestArea( aAreaDT7 )


Return

Static Function GeraDot(cFilTit,cPrefTit,cNumtit,cParcTit,cTipTip,cFornTip,cLjTit)

	Local cRazao	:= ""
	Local cCNPJ		:= ""
	Local cInscM	:= ""
	Local cEndEmp	:= ""
	Local cCEPEmp	:= ""
	Local cMunEmp	:= ""
	Local cUFEmp	:= ""
	Local cContrato	:= ""
	Local cViagem	:= ""
	Local cVeiculo	:= ""
	Local cMotorista:= ""
	Local cCTE		:= ""
	Local cPrefixo	:= ""
	Local cDoc		:= ""
	Local cTipo		:= ""
	Local cParcela	:= ""
	Local dEmissao	:= ""
	Local dVencto	:= ""
	Local cBanco	:= ""
	Local cAgencia	:= ""
	Local cConta	:= ""
	Local cNomFor	:= ""
	Local cCNPJFor	:= ""
	Local cNomMot	:= ""
	Local cCNPJMot	:= ""
	Local cInscMot	:= ""
	Local cEndMot	:= ""
	Local cCEPMot	:= ""
	Local cMunMot	:= ""
	Local cUFMot	:= ""
	Local cEmailMot	:= ""
	Local cPis		:= ""
	Local nValor	:= 0
	Local nSest		:= 0
	Local nInss		:= 0
	Local nIrrf		:= 0
	Local nAdiant	:= 0
	Local nValLiq	:= 0
	Local nSaldo	:= 0

	Local nCount	:= 0

	Local cQuery    := ""

	Local aCTE		:= {}

	Local nI		:= 0

	Local cArquivo	:= ""
	Local oWord
	Local cNomeArq	:= ""
	Local cDiretorio:= ""
	Local lFile 	:= .F.
	Local nOpen
	Local aAreaSA2	:= SA2->(GetArea())
	Local aAreaSE2	:= SE2->(GetArea())
	Local aAreaDA4	:= DA4->(GetArea())
	Local lImprBaix := SuperGetMv("MV_XDOTBX",,.T.)
	Local lOk		:= .T.

	Local cDadosBco := ""
	//Diretório onde será salvo o arquivo
	cDiretorio := SuperGetMv("MV_XDIRDOT",,"C:\TEMP\")

	If Empty(cDiretorio)
		Return
	Endif

	IF !ExistDir(cDiretorio)
		If !MakeDir(cDiretorio)
			MsgAlert("Não foi possível criar o diretório " + cDiretorio)
			Return
		Endif
	Endif

	// Diretório e nome do arquivo Modelo DOT
	cArquivo := SuperGetMv("MV_XDOTCAR",,"\DIRDOT\RECIBOCARRETEIRO.DOT")

	lFile:= FILE(cArquivo)

	IF (lFile)
		//Select na SE2 para somar os valores

		cQuery := " SELECT * FROM " + RetSqlName("SE2")
		cQuery += " WHERE D_E_L_E_T_ = ' ' "
		cQuery += " AND E2_FILIAL    = '" + Alltrim(cFilTit)  +"' "
		cQuery += " AND E2_PREFIXO   = '" + Alltrim(cPrefTit) +"' "
		cQuery += " AND E2_NUM       = '" + Alltrim(cNumTit)  +"' "
		cQuery += " AND E2_TIPO      = '" + Alltrim(cTipTip)  +"' "
		cQuery += " AND E2_FORNECE   = '" + Alltrim(cFornTip) +"' "
		cQuery += " AND E2_LOJA      = '" + Alltrim(cLjTit)   +"' "

		cQuery := ChangeQuery(cQuery)

		IF Select("TMPSE2") > 0
			TMPSE2->(DbCloseArea())
		Endif

		dbUseArea(.T.,'TOPCONN', TCGenQry(,,cQuery), "TMPSE2",.F.,.T.)

		DbSelectArea("TMPSE2")
		TMPSE2->(DbGoTop())

		If TMPSE2->(Eof())
			MsgAlert("Título não encontrado!")

			Return
		Endif

		nCount := 1
		While !TMPSE2->(Eof())
			IF lImprBaix
				lOk := (TMPSE2->E2_SALDO == 0)
			Endif

			IF nCount == 1
				cPrefixo	:= TMPSE2->E2_PREFIXO
				cDoc		:= TMPSE2->E2_NUM
				cTipo		:= TMPSE2->E2_TIPO
				cParcela	:= ""
				dEmissao	:= DtoC(StoD(TMPSE2->E2_EMISSAO))
				dVencto		:= DtoC(StoD(TMPSE2->E2_VENCREA))
				cBanco		:= TMPSE2->E2_FORBCO
				cAgencia	:= TMPSE2->E2_FORAGE
				cConta		:= TMPSE2->E2_FORCTA

				cNomFor		:= Posicione("SA2",1,xFilial("SA2") + TMPSE2->E2_FORNECE + TMPSE2->E2_LOJA,"A2_NOME")
				cCNPJFor	:= Posicione("SA2",1,xFilial("SA2") + TMPSE2->E2_FORNECE + TMPSE2->E2_LOJA,"A2_CGC")


				IF Len(Alltrim(cCnpjFor)) > 11
					cCnpjFor := Transform(cCnpjFor,"@R 99.999.999/9999-99")
				Else
					cCnpjFor := Transform(cCnpjFor,"@R 999.999.999-99")
				Endif

				cDadosBco   := Alltrim(Posicione("SA2",1,xFilial("SA2") + TMPSE2->E2_FORNECE + TMPSE2->E2_LOJA,"A2_XDBCO"))

				nAdiant		:= TMPSE2->E2_VALOR

			Endif

			nValor		+= TMPSE2->E2_VLCRUZ
			nSest		+= TMPSE2->E2_SEST
			nInss		+= TMPSE2->E2_INSS
			nIrrf		+= TMPSE2->E2_IRRF
			nValLiq		+= TMPSE2->E2_VALOR
			nSaldo		+= TMPSE2->E2_VALOR


			nCount++
			TMPSE2->(DbSkip())
		EndDo

		IF lOk

			nValor		:= Transform(nValor,"@E 9,999,999,999.99")
			nSest		:= Transform(nSest,"@E 9,999,999,999.99")
			nInss		:= Transform(nInss,"@E 9,999,999,999.99")
			nIrrf		:= Transform(nIrrf,"@E 9,999,999,999.99")
			nValLiq		:= Transform(nValLiq,"@E 9,999,999,999.99")
			nSaldo		:= Transform(nSaldo - nAdiant,"@E 9,999,999,999.99")
			nAdiant		:= Transform(nAdiant,"@E 9,999,999,999.99")

			cRazao		:= SM0->M0_NOMECOM
			cCNPJ		:= Transform(SM0->M0_CGC,"@R 99.999.999/9999-99")
			cInscM		:= SM0->M0_INSCM
			cEndEmp		:= SM0->M0_ENDCOB
			cCEPEmp		:= Transform(SM0->M0_CEPCOB,"@R 99.999-999")
			cMunEmp		:= SM0->M0_CIDCOB
			cUFEmp		:= SM0->M0_ESTCOB

			cContrato	:= M->DTY_NUMCTC
			cViagem		:= M->DTY_VIAGEM
			cVeiculo	:= M->DTY_CODVEI
			cMotorista	:= M->DTY_CODMOT

			DbSelectArea("DUD")
			DUD->(DbSetOrder(2))
			IF DUD->(MsSeek(xFilial("DUD") + M->DTY_FILIAL + M->DTY_VIAGEM))
				While xFilial("DUD") +  M->DTY_FILIAL + M->DTY_VIAGEM == xFilial("DUD") + DUD->DUD_FILORI + DUD->DUD_VIAGEM
					DbSelectArea("DTC")
					DTC->(DbSetOrder(16))
					IF DTC->(MsSeek(xFilial("DTC") + DUD->DUD_DOC))
						While xFilial("DTC") + DUD->DUD_DOC == xFilial("DTC") + DTC->DTC_DOC
							aAdd(aCTE,{DTC->DTC_DOC,DTC->DTC_SERIE,POSICIONE("SA1",1,xFilial("SA1") + DTC->DTC_CLIDES + DTC->DTC_LOJDES, "A1_NOME"),DTC->DTC_NUMNFC,DTC->DTC_SERNFC,DTC->DTC_QTDVOL,DTC->DTC_PESO,DTC->DTC_VALOR})
							DTC->(DbSkip())
						EndDo
					Endif
					DUD->(DbSkip())
				EndDo
			Endif
			//                1         2         3         4         5         6         7         8         9         1         1         2         3
			//       123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012
			cCTE := "   CTE      SERIE           CLIENTE                           NOTA FISCAL  SERIE VOL   PESO      VALOR       " + CHR(13) + CHR(10)

			If Len(aCTE) > 0
//				OLE_SetDocumentVar(oWord,'nTOTCTE',cValToChar(Len(aCTE)))
				For nI := 1 To Len(aCTE)
//					OLE_SetDocumentVar(oWord,"cCTE"   +Alltrim(str(nI))  , aCTE[nI][1] )
//					OLE_SetDocumentVar(oWord,"cSerCTE"+Alltrim(str(nI))  , aCTE[nI][2] )
//					OLE_SetDocumentVar(oWord,"cCli"   +Alltrim(str(nI))  , aCTE[nI][3] )
//					OLE_SetDocumentVar(oWord,"cNF"    +Alltrim(str(nI))  , aCTE[nI][4] )
//					OLE_SetDocumentVar(oWord,"cSerNF" +Alltrim(str(nI))  , aCTE[nI][5] )
//					OLE_SetDocumentVar(oWord,"cVol"   +Alltrim(str(nI))  , aCTE[nI][6] )
//					OLE_SetDocumentVar(oWord,"cPeso"  +Alltrim(str(nI))  , aCTE[nI][7] )
//					OLE_SetDocumentVar(oWord,"cValor" +Alltrim(str(nI))  , Transform(aCTE[nI][8],"@E 9,999,999,999.99") )
					cCTE += aCTE[nI][1] + "    " + aCTE[nI][2] + "    " + SubStr(aCTE[nI][3],1,50) + "   " + aCTE[nI][4] + "    " + aCTE[nI][5] + "   " + cValToChar(aCTE[nI][6]) + "  " + cValToChar(aCTE[nI][7]) + "     " + Alltrim(Transform(aCTE[nI][8],"@E 9,999,999,999.99"))  + CHR(13) + CHR(10)
				Next nI

//				OLE_ExecuteMacro(oWord,"LISTACTE")
			Endif

			DbSelectArea("DA4")
			DA4->(DbSetOrder(1))
			DA4->(DbSeek(xFilial("DA4") + cMotorista))

			cForMot	:= DA4->DA4_FORNEC
			cLjMot	:= DA4->DA4_LOJA

			DbSelectArea("SA2")
			SA2->(DbSetOrder(1))
			SA2->(DbSeek(xFilial("SA2") + cForMot + cLjMot))

			cNomMot		:= SA2->A2_NOME
			cInscMot	:= SA2->A2_INSCRM
			cEndMot		:= SA2->A2_END
			cCEPMot		:= Transform(SA2->A2_CEP,"@R 99.999-999")
			cCNPJMot	:= SA2->A2_CGC

			IF Len(Alltrim(cCNPJMot)) > 11
				cCNPJMot := Transform(cCNPJMot,"@R 99.999.999/9999-99")
			Else
				cCNPJMot := Transform(cCNPJMot,"@R 999.999.999-99")
			Endif

			cMunMot		:= SA2->A2_MUN
			cUFMot		:= SA2->A2_EST
			cEmailMot	:= SA2->A2_EMAIL

			//Para Abrir o arquivo
			oWord := OLE_CreateLink('TMsOleWord97')
			nOpen := OLE_NewFile(oWord,cArquivo)

			OLE_SetProperty( oWord, oleWdVisible,   .f. )
			OLE_SetProperty( oWord, oleWdPrintBack, .t. )

			//Passa para o arquivo o valor das variáeis e diz quais variáveis do ".dot" vão receber

			OLE_SetDocumentVar(oWord,"cContrato"	,cContrato					)
			OLE_SetDocumentVar(oWord,"cViagem"	  	,cViagem					)
			OLE_SetDocumentVar(oWord,"cVeiculo"	  	,cVeiculo					)
			OLE_SetDocumentVar(oWord,"cBanco"	  	,cBanco						)
			OLE_SetDocumentVar(oWord,"cAgencia"	  	,cAgencia					)
			OLE_SetDocumentVar(oWord,"cConta"	  	,cConta						)

			OLE_SetDocumentVar(oWord,"cDadosBco"  	,cDadosBco					)

			OLE_SetDocumentVar(oWord,"cCTE"  		,cCTE						)

			OLE_SetDocumentVar(oWord,"cPrefio"	  	,cPrefixo					)
			OLE_SetDocumentVar(oWord,"cDoc"		  	,cDoc						)
			OLE_SetDocumentVar(oWord,"cTipo"	  	,cTipo						)
			OLE_SetDocumentVar(oWord,"cParcela"	  	,cParcela					)
			OLE_SetDocumentVar(oWord,"dEmissao"	  	,dEmissao					)
			OLE_SetDocumentVar(oWord,"dVencto"  	,dVencto					)

			OLE_SetDocumentVar(oWord,"cRazao"  		,cRazao						)
			OLE_SetDocumentVar(oWord,"cCNPJ"	  	,cCNPJ						)
			OLE_SetDocumentVar(oWord,"cInscM"  		,cInscM						)
			OLE_SetDocumentVar(oWord,"cEndEmp"  	,cEndEmp					)
			OLE_SetDocumentVar(oWord,"cCEPEmp"  	,cCEPEmp					)
			OLE_SetDocumentVar(oWord,"cMunEmp"	  	,cMunEmp					)
			OLE_SetDocumentVar(oWord,"cUFEmp"  		,cUFEmp						)

			OLE_SetDocumentVar(oWord,"cNomFor"  	,cNomFor					)
			OLE_SetDocumentVar(oWord,"cCNPJFor" 	,cCNPJFor					)

			OLE_SetDocumentVar(oWord,"cNomMot"  	,cNomMot					)
			OLE_SetDocumentVar(oWord,"cCNPJMot" 	,cCNPJMot					)
			OLE_SetDocumentVar(oWord,"cInscMot"	  	,cInscMot					)
			OLE_SetDocumentVar(oWord,"cEndMOt"	  	,cEndMot					)
			OLE_SetDocumentVar(oWord,"cCEPMot"	  	,cCEPMot					)
			OLE_SetDocumentVar(oWord,"cMunMot"	  	,cMunMot					)
			OLE_SetDocumentVar(oWord,"cUFMot"	  	,cUFMot						)
			OLE_SetDocumentVar(oWord,"cEmailMot"  	,cEmailMot					)
			OLE_SetDocumentVar(oWord,"cPis"	  		,cPis						)

			OLE_SetDocumentVar(oWord,"cVeiculo"	  	,cVeiculo					)
			OLE_SetDocumentVar(oWord,"nValor"	  	,nValor						)
			OLE_SetDocumentVar(oWord,"nSest"	  	,nSest						)

			OLE_SetDocumentVar(oWord,"nInss"	  	,nInss						)
			OLE_SetDocumentVar(oWord,"nIrrf"	  	,nIrrf						)
			OLE_SetDocumentVar(oWord,"nValliq"	  	,nValliq					)
			OLE_SetDocumentVar(oWord,"nAdiant"	  	,nAdiant					)
			OLE_SetDocumentVar(oWord,"nSaldo"	  	,nSaldo						)

			//Escreve no .Dot
			OLE_UpDateFields(oWord)

			//Diz o nome do arquivo que será salvo
			cNomeArq:="CARRETEIRO_"+cViagem

			//Salva o arquivo no formato .PDF (17) -- Para .DOC (0) )
			OLE_SaveAsFile(oWord,Alltrim(cDiretorio)+cNomeArq+".pdf",,,.f.,"17")

			OLE_CloseFile( oWord )
			OLE_CloseLink( oWord )

			MsgInfo("Arquivo salvo com sucesso: "+Alltrim(cDiretorio)+cNomeArq+".pdf")
		Else
			MsgAlert("Título não foi baixado!")
		Endif
	Else
		MsgAlert("Não existe modelo .dot")
	EndIF

	RestArea(aAreaSA2)
	RestArea(aAreaSE2)
	RestArea(aAreaDA4)

Return

