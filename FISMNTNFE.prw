#Include 'Protheus.ch'

User Function FISMNTNFE()
	
	Local aArea     := GetArea()
	Local nChave    := ParamIxb[1]
	Local nSF3Recno := 0
	Local nSF3Index := 0
	Local aNotas
	Local aXml      := {}
	Local aXml2
	Local nLastXml  := 0
	Local cCGCCLI   := ""
	Local cCGCREM   := ""
	Local cIdEnt    := StaticCall(SPEDNFE,GetIdEnt)
	Public cError     := ""
	
	//Não Executar para CTE
	IF !(FunName()$"SPEDCTE,TMSA200,TMSAE70,TMSA050")
		SF3->(DbSetOrder(5))
		If SF3->(MsSeek(xFilial("SF3")+nChave,.T.))
			nSF3Recno:= SF3->(RECNO())
			nSF3Index:= SF3->(IndexOrd())
			While !SF3->(Eof()) .And. AllTrim(SF3->(F3_SERIE+F3_NFISCAL))==nChave
				If (SubStr(SF3->F3_CFO,1,1)>="5" .Or. SF3->F3_FORMUL=="S")
					aNotas 	:= {}
					aXml2	:= {}
					aadd(aNotas,{})
					aadd(Atail(aNotas),.F.)
					aadd(Atail(aNotas),IIF(SF3->F3_CFO<"5","E","S"))
					aadd(Atail(aNotas),SF3->F3_ENTRADA)
					aadd(Atail(aNotas),SF3->F3_SERIE)
					aadd(Atail(aNotas),SF3->F3_NFISCAL)
					aadd(Atail(aNotas),SF3->F3_CLIEFOR)
					aadd(Atail(aNotas),SF3->F3_LOJA)
					aXml2 := GetXMLNFE(cIdEnt,aNotas,,)
							
					If ( Len(aXml2) > 0 )
						aAdd(aXml,aXml2[1])
					EndIf
							
					nLastXml := Len(aXml)
				Else
					nLastXml:= Len(aXml)
				EndIf
				SF3->(dbSkip())
			End
			SF3->(DBSETORDER(nSF3Index))
			SF3->(DBGOTO(nSF3Recno))
		EndIf
	
		//Nota de saida
		dbSelectArea("SF2")
		dbSetOrder(1)
		If SF2->(MsSeek(xFilial("SF2")+PadR(SUBSTR(nChave,4,Len(nChave)),TamSx3("F2_DOC")[1])+SUBSTR(nChave,1,3),.T.)) .And. nLastXml > 0 .And. !Empty(aXml)
			//Captura o CNPJ do Cliente
			cCGCCLI := POSICIONE("SA1",1,xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA,"A1_CGC")
			//Veririca se é CIF ou FOB para definir o CNPJ do Remetente
			cCGCREM := SM0->M0_CGC//IIF(SF2->F2_TPFRETE == "C",SM0->M0_CGC,cCGCCLI)
			
			If !Empty(aXML) .And. !Empty(aXml[nLastXml][2]) .And. !Empty(aXml[nLastXml][1])//( !Empty(aXml[nLastXml][1]) .OR. oXml:OWSERRO:OWSLOTENFE[nLastRet]:CCODRETNFE $ RetCodDene() )// Inserida verificação do protocolo , antes de gravar a Chave. Para nota denegada deve gravar a chave
				DbSelectArea("DE5")
				DE5->(DbSetOrder(1))
				If DE5->(MsSeek(xFilial("DE5")+cCGCREM+SF2->F2_DOC+SF2->F2_SERIE))
					RecLock("DE5",.F.)
						Replace DE5_NFEID  With SubStr(NfeIdSPED(aXML[nLastXml][2],"Id"),4)
					DE5->(MsUnlock())
				Endif 
			EndIf
		Endif
	Endif
		
	RestArea(aArea)

Return