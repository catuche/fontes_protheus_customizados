#Include 'Protheus.ch'
#Include 'RwMake.ch'

/*/{Protheus.doc} FISENVNFE
Ponto de Entrada após a transmissão da NF

Objetivo: Gerar informações no TMS de forma automática para evitar o uso do EDI

@type function
@author TOTVS NE - Raphael Neves
@since 01/02/2017
@version 1.0
@return ${return}, ${return_description}
@example
(examples)
@see (links_or_references)
/*/

User Function FISENVNFE()

	Local aIdNfe 	:= PARAMIXB
	Local nX		:= 0
	Local nY		:= 0
	Local aArea		:= GetArea()
	Local cCGCCLI   := ""
	Local cCGCREM   := ""
	Local cCGCDEV   := ""
	Local cSerie    := ""
	Local cDoc      := ""
	Local aParam    := {}
	Local aDados    := {}
	Local cIdEnd    := ""
	Local aSerie    := Separa(GetMV("MV_ESPECIE"),";")
	Local cSerCTE	:= "" //001=CTE
	Local lTransf	:= .F.

	//Verifica qual a serie do CTE
	For nY := 1 to Len(aSerie)
		IF "CTE" $ aSerie[nY]
			cSerCTE := SubStr(aSerie[nY],1,At("=",aSerie[nY])-1)
		EndIf
	Next nY

	//Armazena o CNPJ da filial corrente
	cCGCREM := SM0->M0_CGC

	//Array contendo as NFs que foram transmitidas com sucesso
	If Len(aIdNfe) > 0
		For nX := 1 To Len(aIdNfe) //Verifica se houve erro na transmissão
			IF Len(aIdNfe[nX]) > 0
				For nY := 1 to Len(aIdNfe[nX])
					lTransf	:= .F.

					DbSelectArea("SF2")
					SF2->(DbSetOrder(1))

					//Captura documento e serie para se posicionar na SF2 e capturar as informações
					cSerie := SubsTr(Alltrim(aIdNfe[nX][nY]),1,TamSx3("F2_SERIE")[1])
					cDoc   := SubStr(Alltrim(aIdNfe[nX][nY]),TamSx3("F2_SERIE")[1]+1,TamSx3("F2_DOC")[1])

					If cSerie <> cSerCTE
						//Se posiciona na SF2 para captar as informações
						//Validação também serve para não gerar informações no TMS de NF Excluída
						IF SF2->(MsSeek(xFilial("SF2") + cDoc + cSerie ))
							IF SF2->F2_TPFRETE == "C" //Só envia para o TMS se for CIF

								//Captura o CNPJ do Cliente
								cCGCCLI := POSICIONE("SA1",1,xFilial("SA1")+SF2->F2_CLIENT+SF2->F2_LOJENT,"A1_CGC")

								//Verifica se o cliente é filial para não emitir TMS
								SM0->(DbGoTop())

								//Veririca se é CIF ou FOB para definir o CNPJ do Remetente
								cCGCDEV := IIF(SF2->F2_TPFRETE == "C",cCGCREM,cCGCCLI)

								//Verifica se o Cliente é Filial
								While !SM0->(Eof())
									IF cCGCCli == SM0->M0_CGC .and. SF2->F2_EST == 'PE' //Se cliente for Filial em Pernambuco
										lTransf := .T.
									EndIf
									SM0->(DbSkip())
								EndDo

								IF !lTransf

									//Verifica se já existe inforamção no TMS para não dar chave duplicada
									DbSelectArea("DE5")
									DE5->(DbSetOrder(1))
									If !DE5->(MsSeek(xFilial("DE5")+cCGCREM+SF2->F2_DOC+SF2->F2_SERIE))
										If RecLock("DE5",.T.)

											Replace DE5_FILIAL WITH xFilial("DE5")
											Replace DE5_DOC    WITH SF2->F2_DOC
											Replace DE5_SERIE  WITH SF2->F2_SERIE
											Replace DE5_EMINFC WITH SF2->F2_EMISSAO
											Replace DE5_VALOR  WITH SF2->F2_VALMERC
											Replace DE5_CODEMB WITH SF2->F2_ESPECI1
											Replace DE5_QTDVOL WITH SF2->F2_VOLUME1
											Replace DE5_PESO   WITH SF2->F2_PLIQUI
											Replace DE5_DTAEMB WITH dDataBase
											Replace DE5_CGCDES WITH cCGCCLI
											Replace DE5_CGCREM WITH cCGCREM
											Replace DE5_CGCDEV WITH cCGCDEV
											Replace DE5_TIPFRE WITH IIF(SF2->F2_TPFRETE == "C",'1','2')
											Replace DE5_SELORI WITH '2'
											Replace DE5_CODPRO WITH "TMS.000001"
											Replace DE5_CFOPNF WITH Posicione("SD2",3, xFilial("SD2") + SF2->F2_DOC + SF2->F2_SERIE + SF2->F2_CLIENTE + SF2->F2_LOJA ,"D2_CF") //Captura CFOP do primeiro item da NF
											Replace DE5_TIPTRA WITH '1'
											Replace DE5_STATUS WITH '1'
											Replace DE5_STAUTO WITH '0'
											Replace DE5_SERVIC WITH '019'
											Replace DE5_SERTMS WITH '3'
											Replace DE5_EDIAUT WITH '0'
											Replace DE5_EDILOT WITH '0'
											Replace DE5_EDIFRT WITH '0'


											DE5->(MsUnlock())
										Endif
									Endif
								Endif
							Endif
						Endif
					Endif
				Next nY
			EndIf
		Next nX
	EndIF

	RestArea(aArea)

Return