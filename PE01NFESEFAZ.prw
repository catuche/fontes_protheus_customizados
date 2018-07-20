#include "protheus.ch"

/*/{Protheus.doc} PE01NFESEFAZ
Ponto de Entrada
@type function
@author raphael.neves
@since 07/02/2017
@version 1.0
@return ${return}, ${return_description}
@example
(examples)
@see (links_or_references)
/*/

User Function PE01NFESEFAZ()

	Local _aArea	:= GetArea()
	Local _aAreaSC6	:= SC6->(GetArea())
	Local _aAreaSD2	:= SD2->(GetArea())
	Local _aAreaSF1 := SF1->(GetArea())
	Local _aAreaSD1 := SD1->(GetArea())
	Local aProd     := PARAMIXB[1]
	Local cMensCli  := PARAMIXB[2]
	Local cMensFis  := PARAMIXB[3]
	Local aDest     := PARAMIXB[4]
	Local aNota     := PARAMIXB[5]
	Local aInfoItem := PARAMIXB[6]
	Local aDupl     := PARAMIXB[7]
	Local aTransp   := PARAMIXB[8]
	Local aEntrega  := PARAMIXB[9]
	Local aRetirada := PARAMIXB[10]
	Local aVeiculo  := PARAMIXB[11]
	Local aReboque  := PARAMIXB[12]
	Local aNfVincRur:= PARAMIXB[13]
	Local aEspVol	:= PARAMIXB[14]
	Local aNfVinc	:= PARAMIXB[15] //Adicionado por conta da nova versão do NFESEFAZ 26.12.2017
	Local aDetPag	:= PARAMIXB[16] //Adicionado por conta da nova versão do NFESEFAZ 02.03.2018
	Local aObsCont  := PARAMIXB[17] //Adicionado por conta da nova versão do NFESEFAZ 05.06.2018
	//*****************************
	//As variáveis de 18 a 26, não existem no padrão. Foram criadas para uma especificação da Fiabesa - Vem do Fonte NFESEFAZ
	Local aIPI		:= PARAMIXB[18]
	Local nBaseIPI	:= 0
	Local nQtdIPI	:= 0
	Local nValIPI	:= 0
	Local aICMS		:= PARAMIXB[19]
	Local nBaseICM	:= 0
	Local nQtdICM	:= 0
	Local nValICM	:= 0
	Local aICMSST	:= PARAMIXB[20]
	Local nBaseICMST:= 0
	Local nQtdICMST	:= 0
	Local nValICMST	:= 0
	Local aPIS		:= PARAMIXB[21]
	Local nBasePIS	:= 0
	Local nQtdPIS	:= 0
	Local nValPIS	:= 0
	Local aCOFINS	:= PARAMIXB[22]
	Local nBaseCOF	:= 0
	Local nQtdCOF	:= 0
	Local nValCOF	:= 0
	Local aPISST	:= PARAMIXB[23]
	Local nBasePISST:= 0
	Local nQtdPISST	:= 0
	Local nValPISST	:= 0
	Local aCOFINSST	:= PARAMIXB[24]
	Local nBaseCOFST:= 0
	Local nQtdCOFST	:= 0
	Local nValCOFST	:= 0
	Local aISS		:= PARAMIXB[25]
	Local nBaseISS	:= 0
	Local nTotISS	:= 0
	Local nValISS	:= 0
	Local aICMUFDest:= PARAMIXB[26]
	Local nBaseICMUF:= 0
	Local nValICMUF	:= 0
	//*****************************

	Local aRetorno      := {}
	Local cMsg          := ""
	Local i
	Local aAux			:= {}
	Local aAuxIPI		:= {}
	Local aAuxICM		:= {}
	Local aAuxICMST		:= {}
	Local aAuxPIS		:= {}
	Local aAuxCOF		:= {}
	Local aAuxPISST		:= {}
	Local aAuxCOFST		:= {}
	Local aAuxISS		:= {}
	Local aAuxICMUF		:= {}
	Local cLote			:= ""
	Local cProd			:= ""

	IF Alltrim(aNota[1]) <> "2"
		//Posições do aProd
		//aProd[1] -> Item
		//aProd[2] -> Código Produto
		//aProd[3] -> Código de Barras
		//aProd[4] -> Descrição do Produto
		//aProd[5] -> B1_POSIPI
		//aProd[6] -> B1_EX_NCM
		//aProd[7] -> CFOP
		//aProd[8] -> Unidade de Medida
		//aProd[9] -> Quantidade
		//aProd[10] -> Total
		//aProd[11] -> Se Unid. Medida da DIPI estiver preenchida, se não usa o B1_UM
		//aProd[12] -> Se o Fator de Conv. da DIPI estiver preenchido, converte a quantidade, senão usa o D2_QUANT
		//aProd[13] -> Valor do Frete
		//aProd[13] -> Valor do Seguro
		//aProd[15] -> D2_DESCON + D2_DESCICM + FT_DS43080
		//aProd[16] -> 0 - antes era o valor unitário que foi subistituído pelo calculo aProd[10]/aProd[9]
		//aProd[17] -> codigo ANP do combustivel
		//aProd[18] -> CODIF
		//aProd[19] -> Controle de Lote
		//aProd[20] -> Numero do Lote (SubLote
		//aProd[21] -> Outras despesas + PISST + COFINSST  (Inclusão do valor de PIS ST e COFINS ST na tag vOutros - NT 2011/004).E devolução com IPI. (Nota de compl.Ipi de uma devolução de compra(MV_IPIDEV=F) leva o IPI em voutros)
		//aProd[22] -> % Redução da Base de Cálculo
		//aProd[23] -> Cód. Situação Tributária
		//aProd[24] -> Tipo de agregação de valor ao total do documento
		//aProd[25] -> Informacoes adicionais do produto(B5_DESCNFE)
		//aProd[26] -> Desconto da Zona Franca
		//aProd[27] -> TES
		//aProd[28] -> Protocolo ou convenio ICMS (B5_PROTCON)
		//aProd[29] -> Desconto de ICMS
		//aProd[30] -> Total imposto carga tributária.
		//aProd[31] -> Desconto Zona Franca PIS
		//aProd[32] -> Desconto Zona Franca CONFINS
		//aProd[33] -> Percentual de ICMS
		//aProd[34] -> B1_TRIBMUN
		//aProd[35] -> Total carga tributária Federal
		//aProd[36] -> Total carga tributária Estadual
		//aProd[37] -> Total carga tributária Municipal
		//aProd[38] -> Código do Pedido
		//aProd[39] -> Item do Pedido
		//aProd[40] -> F4_GRPCST ou 999
		//aProd[41] -> B1_CEST
		//aProd[42] -> apenas na entrada é utilizado para montar a tag indPres=1 para nota de devolução de venda
		//aProd[43] -> FECP

		//Armazena a informação do primeiro item
		cProd := aProd[1][2]
		cBar  := aProd[1][3]
		cDesc := ""
		cDesc := Posicione("SBM",1,xFilial("SBM") + Posicione("SB1",1,xFilial("SB1") + cProd , "B1_GRUPO" ) , "BM_XDSCNF")
		IF Empty(cDesc)
			cDesc := aProd[1][4]
		Endif
		cPipi := aProd[1][5]
		cEncm := aProd[1][6]
		cCFOP := aProd[1][7]

		//------ Adicionado por Ricardo Rotta para tratamento da 3a unidade de medida - 05.09.2017

		dbSelectArea("SC6")
		SC6->(dbSetOrder(1))
		SC6->(dbSeek(xFilial("SC6")+aProd[1][38]+aProd[1][39]))
		_cUndVend := SC6->C6_XUNVEN
		If _cUndVend == '2'
			cUM   := SC6->C6_SEGUM
		ElseIf _cUndVend == '3'
			cUM   := SC6->C6_XTERCEI
		Else
			cUM   := aProd[1][8]
		Endif
		//-------
		cLote := ""
		nQtd  := 0
		nTot  := 0
		cUMIP := aProd[1][11]
		nVLIP := 0
		nVFre := 0
		nVSeg := 0
		cVDed := 0
		cVUni := aProd[1][16]
		cCANP := aProd[1][17]
		cCDIF := aProd[1][18]
		cLote := aProd[1][19]
		cSbLt := aProd[1][20]
		nODes := 0
		nRdBC := aProd[1][22]
		cCST  := aProd[1][23]
		cTpAg := aProd[1][24]
		cInfA := aProd[1][25]
		nDeZF := aProd[1][26]
		cTES  := aProd[1][27]
		cProt := aProd[1][28]
		nDeIc := 0
		nTimp := 0
		nDZFP := 0
		nDZFC := 0
		nPICM := aProd[1][33]
		cTrbM := aProd[1][34]
		nTFED := aProd[1][35]
		nTEST := aProd[1][36]
		nTMUN := aProd[1][37]
		cPEDI := aProd[1][38]
		cITPV := aProd[1][39]
		cGPCST := aProd[1][40]
		cCEST := aProd[1][41]
		cIndP := aProd[1][42]
		nValFECP := 0


		For i := 1 To Len(aProd)

			//------- Adicionado por Ricardo Rotta para tratamento da 3a unidade de medida - 05.09.2017
			dbSelectArea("SC6")
			SC6->(dbSetOrder(1))
			SC6->(dbSeek(xFilial()+aProd[i][38]+aProd[i][39]))
			_cUndVend := SC6->C6_XUNVEN
			_cCodCli  := SC6->C6_CLI
			_cLojaCli := SC6->C6_LOJA
			//-------


			IF cProd == aProd[i][2] .and. cLote == aProd[i][19]
				//------- Adicionado por Ricardo Rotta para tratamento da 3a unidade de medida - 05.09.2017
				If _cUndVend == '2'
					dbSelectArea("SD2")
					dbSetOrder(3)
					dbSeek(xFilial()+aNota[2]+aNota[1]+_cCodCli+_cLojaCli+aProd[i][2]+aInfoItem[i,4])
					nQtd  += SD2->D2_QTSEGUM
					cUM   := SC6->C6_SEGUM
					cUMIP := cUM
					nVLIP := nQtd
				ElseIf _cUndVend == '3'
					nQtdSC6 := SC6->C6_QTDVEN
					nQtd3   := SC6->C6_XQTDV3
					_nFator := nQtdSC6 / nQtd3
					nQtd  += ROUND((aProd[i][9] / _nFator), TAMSX3("C6_XQTDV3")[2])
					cUM   := SC6->C6_XTERCEI
					cUMIP := cUM
					nVLIP := nQtd
				Else
					nQtd  += aProd[i][9]
					cUM   := aProd[1][8]
					nVLIP := nQtd
				Endif
				//-------
				nTot  += aProd[i][10]
				nVFre += aProd[i][13]
				nVSeg += aProd[i][14]
				cVDed += aProd[i][15]
				nODes += aProd[i][21]
				nDeZF += aProd[i][26]
				nDeIc += aProd[i][29]
				nTimp += aProd[i][30]
				nDZFP += aProd[i][31]
				nDZFC += aProd[i][32]
				nValFECP += aProd[i][43]

				IF Len(aIPI) > 0
					IF Len(aIPI[i]) > 0
						nBaseIPI	+= aIPI[i][6]
						nQtdIPI		+= aIPI[i][7]
						nValIPI		+= aIPI[i][10]
					Endif
				Endif
				IF Len(aICMS) > 0
					IF Len(aICMS[i]) > 0
						nBaseICM	+= aICMS[i][5]
						nValICM		+= aICMS[i][7]
						nQtdICM		+= aICMS[i][9]
					Endif
				Endif
				IF Len(aICMSST) > 0
					IF Len(aICMSST[i]) > 0
						nBaseICMST	+= aICMSST[i][5]
						nValICMST	+= aICMSST[i][7]
						nQtdICMST	+= aICMSST[i][9]
					Endif
				Endif
				IF Len(aPIS) > 0
					IF Len(aPIS[i]) > 0
						nBasePIS	+= aPIS[i][2]
						nValPIS		+= aPIS[i][4]
						nQtdPIS		+= aPIS[i][5]
					Endif
				Endif
				IF Len(aCOFINS) > 0
					IF Len(aCOFINS[i]) > 0
						nBaseCOF	+= aCOFINS[i][2]
						nValCOF		+= aCOFINS[i][4]
						nQtdCOF		+= aCOFINS[i][5]
					Endif
				Endif
				IF Len(aPISST) > 0
					IF Len(aPISST[i]) > 0
						nBasePISST	+= aPISST[i][2]
						nValPISST	+= aPISST[i][4]
						nQtdPISST	+= aPISST[i][5]
					Endif
				Endif
				IF Len(aCOFINSST) > 0
					IF Len(aCOFINSST[i]) > 0
						nBaseCOFST	+= aCOFINSST[i][2]
						nValCOFST	+= aCOFINSST[i][4]
						nQtdCOFST	+= aCOFINSST[i][5]
					Endif
				Endif
				IF Len(aISS) > 0
					IF Len(aISS[i]) > 0
						nTotISS		+= aISS[i][1]
						nBaseISS	+= aISS[i][2]
						nValISS		+= aISS[i][3]
					Endif
				Endif
				IF Len(aICMUFDest) > 0
					IF Len(aICMUFDest[i]) > 0
						nBaseICMUF	+= aICMUFDest[i][1]
						nValICMUF	+= aICMUFDest[i][8]
					Endif
				Endif

			Else

				aadd(aAux,	{Len(aAux)+1,; //1
				cProd,; //2
				cBar ,; //3
				cDesc,; //4
				cPipi,; //5
				cEncm,; //6
				cCFOP,; //7
				cUM  ,; //8
				nQtd ,; //9
				nTot ,; //10
				cUMIP,; //11
				nVLIP,; //12
				nVFre,; //13
				nVSeg,; //14
				cVDed,; //15
				cVUni,; //16
				cCANP,; //17
				cCDIF,; //18
				cLote,; //19
				""   ,; //20
				nODes,; //21
				nRdBC,; //22
				cCST ,; //23
				cTpAg,; //24
				cInfA + IIF(!Empty(cLote)," Lote: " + cLote,""),; //25
				nDeZF,; //26
				cTES ,; //27
				cProt,; //28
				nDeIc,; //29
				nTimp,; //30
				nDZFP,;	//31
				nDZFC,;	//32
				nPICM,;	//33
				cTrbM,; //34
				nTFED,; //35
				nTEST,; //36
				nTMUN,; //37
				cPEDI,;	//38
				cITPV,;	//39
				cGPCST,;//40
				cCEST,; //41
				cIndP,; //42
				nValFECP,;//43
				})

				//Verifica se o valor dos impostos é maior que zero e adiciona no array de retorno

				IF nValIPI > 0
					aAdd(aAuxIPI,{aIPI[i-1][1],aIPI[i-1][2],aIPI[i-1][3],aIPI[i-1][4],aIPI[i-1][5],nBaseIPI,nQtdIPI,aIPI[i-1][8],aIPI[i-1][9],nValIPI,aIPI[i-1][11],aIPI[i-1][12]})
				Else
					aAdd(aAuxIPI,{})
				Endif
				IF nValICM > 0
					aAdd(aAuxICM,{aICMS[i-1][1],aICMS[i-1][2],aICMS[i-1][3],aICMS[i-1][4],nBaseICM,aICMS[i-1][6],nValICM,aICMS[i-1][8],nQtdICM,aICMS[i-1][10],aICMS[i-1][11],aICMS[i-1][12],aICMS[i-1][13],aICMS[i-1][14],aICMS[i-1][15]})
				Else
					aAdd(aAuxICM,{})
				Endif
				IF nValICMST > 0
					aAdd(aAuxICMST,{aICMSST[i-1][1],aICMSST[i-1][2],aICMSST[i-1][3],aICMSST[i-1][4],nBaseICMST,aICMSST[i-1][6],nValICMST,aICMSST[i-1][8],nQtdICMST,aICMSST[i-1][10],aICMSST[i-1][11],aICMSST[i-1][12]})
				Else
					aAdd(aAuxICMST,{})
				Endif
				IF nValPIS > 0
					aAdd(aAuxPIS,{aPIS[i-1][1],nBasePIS,aPIS[i-1][3],nValPIS,nQtdPIS,aPIS[i-1][6]})
				Else
					aAdd(aAuxPIS,{})
				Endif
				IF nValCOF > 0
					aAdd(aAuxCOF,{aCOFINS[i-1][1],nBaseCOF,aCOFINS[i-1][3],nValCOF,nQtdCOF,aCOFINS[i-1][6]})
				Else
					aAdd(aAuxCOF,{})
				Endif
				IF nValPISST > 0
					aAdd(aAuxPISST,{aPISST[i-1][1],nBasePISST,aPISST[i-1][3],nValPISST,nQtdPISST,aPISST[i-1][6]})
				Else
					aAdd(aAuxPISST,{})
				Endif
				IF nValCOFST > 0
					aAdd(aAuxCOFST,{aCOFINSST[i-1][1],nBaseCOFST,aCOFINSST[i-1][3],nValCOFST,nQtdCOFST,aCOFINSST[i-1][6]})
				Else
					aAdd(aAuxCOFST,{})
				Endif
				IF nValISS > 0
					aAdd(aAuxISS,{nTotISS,nBaseISS,nValISS,aISS[i-1][4],aISS[i-1][5]})
				Else
					aAdd(aAuxISS,{})
				Endif
				IF nValICMUF > 0
					aAdd(aAuxICMUF,{nBaseICMUF,aICMUFDest[i-1][2],aICMUFDest[i-1][3],aICMUFDest[i-1][4],aICMUFDest[i-1][5],aICMUFDest[i-1][6],aICMUFDest[i-1][7],nValICMUF})
				Else
					aAdd(aAuxICMUF,{})
				Endif


				//Limpa os dados das variáveis
				cProd := aProd[i][2]
				cBar  := aProd[i][3]
				cDesc := ""
				cDesc := Posicione("SBM",1,xFilial("SBM") + Posicione("SB1",1,xFilial("SB1") + cProd , "B1_GRUPO" ) , "BM_XDSCNF")//aProd[1][4]
				IF Empty(cDesc)
					cDesc := aProd[i][4]
				Endif
				cPipi := aProd[i][5]
				cEncm := aProd[i][6]
				cCFOP := aProd[i][7]

				//------ Adicionado por Ricardo Rotta para tratamento da 3a unidade de medida - 05.09.2017
				If _cUndVend == '2'
					dbSelectArea("SD2")
					dbSetOrder(3)
					dbSeek(xFilial()+aNota[2]+aNota[1]+_cCodCli+_cLojaCli+aProd[i][2]+aInfoItem[i,4])
					nQtd  := SD2->D2_QTSEGUM
					cUM   := SC6->C6_SEGUM
					cUMIP := cUM
					nVLIP := nQtd
				ElseIf _cUndVend == '3'
					nQtdSC6 := SC6->C6_QTDVEN
					nQtd3   := SC6->C6_XQTDV3
					_nFator := nQtdSC6 / nQtd3
					nQtd  := ROUND((aProd[i,9] / _nFator), TAMSX3("C6_XQTDV3")[2])
					cUM   := SC6->C6_XTERCEI
					cUMIP := cUM
					nVLIP := nQtd
				Else
					nQtd  := aProd[i][9]
					cUM   := aProd[1][8]
					nVLIP := nQtd
					cUMIP := aProd[i][11]
					nVLIP := aProd[i][12]
				Endif
				//------
				cLote := ""
				nTot  := aProd[i][10]
				nVFre := aProd[i][13]
				nVSeg := aProd[i][14]
				cVDed := aProd[i][15]
				cVUni := aProd[i][16]
				cCANP := aProd[i][17]
				cCDIF := aProd[i][18]
				cLote := aProd[i][19]
				cSbLt := aProd[i][20]
				nODes := aProd[i][21]
				nRdBC := aProd[i][22]
				cCST  := aProd[i][23]
				cTpAg := aProd[i][24]
				cInfA := aProd[i][25]
				nDeZF := aProd[i][26]
				cTES  := aProd[i][27]
				cProt := aProd[i][28]
				nDeIc := aProd[i][29]
				nTimp := aProd[i][30]
				nDZFP := aProd[i][31]
				nDZFC := aProd[i][32]
				nPICM := aProd[i][33]
				cTrbM := aProd[i][34]
				nTFED := aProd[i][35]
				nTEST := aProd[i][36]
				nTMUN := aProd[i][37]
				cPEDI := aProd[i][38]
				cITPV := aProd[i][39]
				cGPCST:= aProd[i][40]
				cCEST := aProd[i][41]
				cIndP := aProd[i][42]
				nValFECP := aProd[i][43]

				IF Len(aIPI) > 0
					IF Len(aIPI[i]) > 0
						nBaseIPI	:= aIPI[i][6]
						nQtdIPI		:= aIPI[i][7]
						nValIPI		:= aIPI[i][10]
					Endif
				Endif
				IF Len(aICMS) > 0
					IF Len(aICMS[i]) > 0
						nBaseICM	:= aICMS[i][5]
						nValICM		:= aICMS[i][7]
						nQtdICM		:= aICMS[i][9]
					Endif
				Endif
				IF Len(aICMSST) > 0
					IF Len(aICMSST[i]) > 0
						nBaseICMST	:= aICMSST[i][5]
						nQtdICMST	:= aICMSST[i][7]
						nValICMST	:= aICMSST[i][9]
					Endif
				Endif
				IF Len(aPIS) > 0
					IF Len(aPIS[i]) > 0
						nBasePIS	:= aPIS[i][2]
						nQtdPIS		:= aPIS[i][4]
						nValPIS		:= aPIS[i][5]
					Endif
				Endif
				IF Len(aCOFINS) > 0
					IF Len(aCOFINS[i]) > 0
						nBaseCOF	:= aCOFINS[i][2]
						nQtdCOF		:= aCOFINS[i][4]
						nValCOF		:= aCOFINS[i][5]
					Endif
				Endif
				IF Len(aPISST) > 0
					IF Len(aPISST[i]) > 0
						nBasePISST	:= aPISST[i][2]
						nQtdPISST	:= aPISST[i][4]
						nValPISST	:= aPISST[i][5]
					Endif
				Endif
				IF Len(aCOFINSST) > 0
					IF Len(aCOFINSST[i]) > 0
						nBaseCOFST	:= aCOFINSST[i][2]
						nQtdCOFST	:= aCOFINSST[i][4]
						nValCOFST	:= aCOFINSST[i][5]
					Endif
				Endif
				IF Len(aISS) > 0
					IF Len(aISS[i]) > 0
						nBaseISS	:= aISS[i][1]
						nQtdISS		:= aISS[i][2]
						nValISS		:= aISS[i][3]
					Endif
				Endif
				IF Len(aICMUFDest) > 0
					IF Len(aICMUFDest[i]) > 0
						nBaseICMUF	:= aICMUFDest[i][1]
						nValICMUF	:= aICMUFDest[i][8]
					Endif
				Endif
			EndIf
		Next i

		//Repete o ADD no final para adicionar a ultima comparação
		aadd(aAux,	{Len(aAux)+1,; //1
		cProd,; //2
		cBar ,; //3
		cDesc,; //4
		cPipi,; //5
		cEncm,; //6
		cCFOP,; //7
		cUM  ,; //8
		nQtd ,; //9
		nTot ,; //10
		cUMIP,; //11
		nVLIP,; //12
		nVFre,; //13
		nVSeg,; //14
		cVDed,; //15
		cVUni,; //16
		cCANP,; //17
		cCDIF,; //18
		cLote,; //19
		""   ,; //20
		nODes,; //21
		nRdBC,; //22
		cCST ,; //23
		cTpAg,; //24
		cInfA + IIF(!Empty(cLote)," Lote: " + cLote,""),; //25
		nDeZF,; //26
		cTES ,; //27
		cProt,; //28
		nDeIc,; //29
		nTimp,; //30
		nDZFP,;	//31
		nDZFC,;	//32
		nPICM,;	//33
		cTrbM,; //34
		nTFED,; //35
		nTEST,; //36
		nTMUN,; //37
		cPEDI,;	//38
		cITPV,;	//39
		cGPCST,;//40
		cCEST,; //41
		cIndP,; //42
		nValFECP,;//43
		})

		//Verifica se o valor dos impostos é maior que zero e adiciona no array de retorno
		IF nValIPI > 0
			aAdd(aAuxIPI,{aIPI[len(aIPI)][1],aIPI[len(aIPI)][2],aIPI[len(aIPI)][3],aIPI[len(aIPI)][4],aIPI[len(aIPI)][5],nBaseIPI,nQtdIPI,aIPI[len(aIPI)][8],aIPI[len(aIPI)][9],nValIPI,aIPI[len(aIPI)][11],aIPI[len(aIPI)][12]})
		Else
			aAdd(aAuxIPI,{})
		Endif
		IF nValICM > 0
			aAdd(aAuxICM,{aICMS[len(aICMS)][1],aICMS[len(aICMS)][2],aICMS[len(aICMS)][3],aICMS[len(aICMS)][4],nBaseICM,aICMS[len(aICMS)][6],nValICM,aICMS[len(aICMS)][8],nQtdICM,aICMS[len(aICMS)][10],aICMS[len(aICMS)][11],aICMS[len(aICMS)][12],aICMS[len(aICMS)][13],aICMS[len(aICMS)][14],aICMS[len(aICMS)][15]})
		Else
			aAdd(aAuxICM,{})
		Endif
		IF nValICMST > 0
			aAdd(aAuxICMST,{aICMSST[len(aICMSST)][1],aICMSST[len(aICMSST)][2],aICMSST[len(aICMSST)][3],aICMSST[len(aICMSST)][4],nBaseICMST,aICMSST[len(aICMSST)][6],nValICMST,aICMSST[len(aICMSST)][8],nQtdICMST,aICMSST[len(aICMSST)][10],aICMSST[len(aICMSST)][11],aICMSST[len(aICMSST)][12]})
		Else
			aAdd(aAuxICMST,{})
		Endif
		IF nValPIS > 0
			aAdd(aAuxPIS,{aPIS[len(aPIS)][1],nBasePIS,aPIS[len(aPIS)][3],nValPIS,nQtdPIS,aPIS[len(aPIS)][6]})
		Else
			aAdd(aAuxPIS,{})
		Endif
		IF nValCOF > 0
			aAdd(aAuxCOF,{aCOFINS[len(aCOFINS)][1],nBaseCOF,aCOFINS[len(aCOFINS)][3],nValCOF,nQtdCOF,aCOFINS[len(aCOFINS)][6]})
		Else
			aAdd(aAuxCOF,{})
		Endif
		IF nValPISST > 0
			aAdd(aAuxPISST,{aPISST[len(aPISST)][1],nBasePISST,aPISST[len(aPISST)][3],nValPISST,nQtdPISST,aPISST[len(aPISST)][6]})
		Else
			aAdd(aAuxPISST,{})
		Endif
		IF nValCOFST > 0
			aAdd(aAuxCOFST,{aCOFINSST[len(aCOFINSST)][1],nBaseCOFST,aCOFINSST[len(aCOFINSST)][3],nValCOFST,nQtdCOFST,aCOFINSST[len(aCOFINSST)][6]})
		Else
			aAdd(aAuxCOFST,{})
		Endif
		IF nValISS > 0
			aAdd(aAuxISS,{nTotISS,nBaseISS,nValISS,aISS[len(aISS)][4],aISS[len(aISS)][5]})
		Else
			aAdd(aAuxISS,{})
		Endif
		IF nValICMUF > 0
			aAdd(aAuxICMUF,{nBaseICMUF,aICMUFDest[len(aICMUFDest)][2],aICMUFDest[len(aICMUFDest)][3],aICMUFDest[len(aICMUFDest)][4],aICMUFDest[len(aICMUFDest)][5],aICMUFDest[len(aICMUFDest)][6],aICMUFDest[len(aICMUFDest)][7],nValICMUF})
		Else
			aAdd(aAuxICMUF,{})
		Endif

		//Altera as informações do aProd
		IF Len(aAux) > 0
			aProd := aClone(aAux)
		Endif
		IF Len(aAuxIPI) > 0
			aIPI := aClone(aAuxIPI)
		Endif
		IF Len(aAuxICM) > 0
			aICMS := aClone(aAuxICM)
		Endif
		IF Len(aAuxICMST) > 0
			aICMSST := aClone(aAuxICMST)
		Endif
		IF Len(aAuxPIS) > 0
			aPIS := aClone(aAuxPIS)
		Endif
		IF Len(aAuxCOF) > 0
			aCOFINS := aClone(aAuxCOF)
		Endif
		IF Len(aAuxPISST) > 0
			aPISST := aClone(aAuxPISST)
		Endif
		IF Len(aAuxCOFST) > 0
			aCOFINSST := aClone(aAuxCOFST)
		Endif
		IF Len(aAuxISS) > 0
			aISS := aClone(aAuxISS)
		Endif
		IF Len(aAuxICMUF) > 0
			aICMUFDest := aClone(aAuxICMUF)
		Endif
	Endif
	//O retorno deve ser exatamente nesta ordem e passando o conteúdo completo dos arrays
	//pois no rdmake nfesefaz é atribuido o retorno completo para as respectivas variáveis
	//Ordem:
	//      aRetorno[1] -> aProd
	//      aRetorno[2] -> cMensCli
	//      aRetorno[3] -> cMensFis
	//      aRetorno[4] -> aDest
	//      aRetorno[5] -> aNota
	//      aRetorno[6] -> aInfoItem
	//      aRetorno[7] -> aDupl
	//      aRetorno[8] -> aTransp
	//      aRetorno[9] -> aEntrega
	//      aRetorno[10] -> aRetirada
	//      aRetorno[11] -> aVeiculo
	//      aRetorno[12] -> aReboque
	//      aRetorno[13] -> aNfVincRur
	//      aRetorno[14] -> aEspVol
	//      aRetorno[15] -> aNfVinc -- Adicionado por Raphael 26.12.2017

	aadd(aRetorno,aProd)
	aadd(aRetorno,cMensCli)
	aadd(aRetorno,cMensFis)
	aadd(aRetorno,aDest)
	aadd(aRetorno,aNota)
	aadd(aRetorno,aInfoItem)
	aadd(aRetorno,aDupl)
	aadd(aRetorno,aTransp)
	aadd(aRetorno,aEntrega)
	aadd(aRetorno,aRetirada)
	aadd(aRetorno,aVeiculo)
	aadd(aRetorno,aReboque)
	aadd(aRetorno,aNfVincRur)
	aadd(aRetorno,aEspVol)
	aadd(aRetorno,aNfVinc)
	aadd(aRetorno,aDetPag)
	aadd(aRetorno,aObsCont)

	//************ Retorno não é padrão. Foi criado para a FIABESA - Vem do Fonte NFESEFAZ
	aadd(aRetorno,aIPI)
	aadd(aRetorno,aICMS)
	aadd(aRetorno,aICMSST)
	aadd(aRetorno,aPIS)
	aadd(aRetorno,aCOFINS)
	aadd(aRetorno,aPISST)
	aadd(aRetorno,aCOFINSST)
	aadd(aRetorno,aISS)
	aadd(aRetorno,aICMUFDest)

	RestArea(_aAreaSF1)
	RestArea(_aAreaSD1)
	RestArea(_aAreaSC6)
	RestArea(_aAreaSD2)
	RestArea(_aArea)
RETURN aRetorno