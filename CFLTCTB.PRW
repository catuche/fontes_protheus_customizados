#INCLUDE "PROTHEUS.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCFLTCTB   บAutor  ณMicrosiga           บ Data ณ  04/16/18   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function CFLTCTB

Local aSay    := {}
Local aButton := {}
Local nOpc    := 0
Local cTitulo := "Planilha Conferencia Integra็ใo Contabil"
Local cDesc1  := "Este programa tem como objetivo gerar planilha Excel"
Local cDesc2  := "relacionando com a tabela de Origem"
Local cDesc3  := "Especifico - Fiabesa"
Local _cPerg  := "CFLTCTB"

AjustaSX1(_cPerg)

Pergunte(_cPerg,.F.)


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Variaveis utilizadas para parametros                         ณ
//ณ mv_par01     // Data Inventario                              ณ
//ณ mv_par02     // Documento                                    ณ
//ณ mv_par03     // Contagens                                    ณ
//ณ mv_par04     // Almox. de                                    ณ
//ณ mv_par05     // Almox. ate                                   ณ
//ณ mv_par06     // Produto de                                   ณ
//ณ mv_par07     // Produto ate                                  ณ
//ณ mv_par08     // tipo de                                      ณ
//ณ mv_par09     // tipo ate                                     ณ
//ณ mv_par10     // grupo de                                     ณ
//ณ mv_par11     // grupo ate                                    ณ
//ณ mv_par12     // Imprime Saldo ? (Sim/Nao)        ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

aAdd( aSay, cDesc1 )
aAdd( aSay, cDesc2 )
aAdd( aSay, cDesc3 )

aAdd( aButton, { 5, .T., {|| Pergunte(_cPerg,.T. )    }} )
aAdd( aButton, { 1, .T., {|| nOpc := 1, FechaBatch() }} )
aAdd( aButton, { 2, .T., {|| FechaBatch()            }} )

FormBatch( cTitulo, aSay, aButton )

If nOpc <> 1
	Return Nil
Endif

Processa( {|lEnd| RunProc(@lEnd)}, "Aguarde...","Gerando Planilha", .T. )

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRELFATM   บAutor  ณMicrosiga           บ Data ณ  04/17/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function RunProc()

Local _aArea := GetArea()
Local _nX := 1
LOCAL cDirDocs   := MsDocPath()
Local cArquivo := CriaTrab(,.F.)
Local cPath		:= AllTrim(GetTempPath())
Local oExcelApp
Local oExcel
Local _aLista := {}
oExcel := FWMSEXCEL():New()
If !ApOleClient('MsExcel')
	MsgAlert('MsExcel nao instalado') //
	Return
EndIf

_cArqTMP := CriaTrab(nil,.f.)

_cQuery := "SELECT CT2_DATA, CT2_LOTE, CT2_SBLOTE, CT2_DOC, CT2_LINHA, CT2.R_E_C_N_O_ RECNOCT2, CV3_TABORI, CV3_VLR01, CV3_RECORI"
_cQuery += " FROM " + RetSqlName("CT2") + " CT2 LEFT JOIN " + RetSqlName("CV3") + " CV3 ON CV3.CV3_FILIAL = '" + xFilial("CV3") + "' AND CV3_DTSEQ = CT2_DTCV3 AND CV3_SEQUEN = CT2_SEQUEN AND CV3.D_E_L_E_T_ = ' '"
_cQuery += " AND CV3_RECDES = CT2.R_E_C_N_O_"
_cQuery += " WHERE CT2_FILIAL = '" + xFilial("CT2") + "'"
_cQuery += " AND CT2_DATA = '"+ Dtos(mv_par01) + "'"
_cQuery += " AND CT2_LOTE = '" + mv_par02 + "'"
_cQuery += " AND CT2_SBLOTE = '" + mv_par03 + "'"
_cQuery += " AND CT2_DOC = '" + mv_par04 + "'"
_cQuery += " AND CT2_MOEDLC = '01'"
_cQuery += " AND CT2_DC <> '4'"
_cQuery += " AND CT2.D_E_L_E_T_ = ' '"
_cQuery += " ORDER BY CT2_DATA, CT2_LOTE, CT2_SBLOTE, CT2_DOC, CT2_LINHA"
dbUseArea(.T.,"TOPCONN",TCGenQry(,,_cQuery),_cArqTMP,.t.,.t.) // Query para pegar os itens a serem processados que tiveram movimentos nesse periodo
dbSelectArea(_cArqTMP)
While !Eof()
	_nRecCT2 := (_cArqTMP)->RECNOCT2
	_dData   := Stod((_cArqTMP)->CT2_DATA)
	_cLote   := (_cArqTMP)->CT2_LOTE
	_cSubLote:= (_cArqTMP)->CT2_SBLOTE
	_cDoc	 := (_cArqTMP)->CT2_DOC
	_cLinha  := (_cArqTMP)->CT2_LINHA
	_lFirst  := .T.
	While !Eof() .and. Dtos(_dData)+_cLote+_cSubLote+_cDoc+_cLinha == (_cArqTMP)->(CT2_DATA+CT2_LOTE+CT2_SBLOTE+CT2_DOC+CT2_LINHA)
		_cTabOri := (_cArqTMP)->CV3_TABORI
		_nRecOri := Val((_cArqTMP)->CV3_RECORI)
		dbSelectArea("CT2")
		dbSetOrder(1)
		dbGoto(_nRecCT2)
		If CT2->CT2_MANUAL == "2" .and. !Empty(_cTabOri)
			dbSelectArea(_cTabOri)
			dbGoto(_nRecOri)
			If _lFirst
				If _cTabOri == "SD3"
					aadd(_aLista,{_cDoc, _cLinha, CT2->CT2_DEBITO, CT2->CT2_CREDIT, CT2->CT2_CCD, CT2->CT2_CCC, CT2->CT2_HIST, CT2->CT2_VALOR, SD3->D3_NUMSEQ,"Produto: "+ Alltrim(SD3->D3_COD) + " TM " + SD3->D3_TM + " CF " + SD3->D3_CF + IIF(!EMPTY(SD3->D3_OP), " OP " + SD3->D3_OP,""), SD3->D3_QUANT, SD3->D3_CUSTO1})
				ElseIf _cTabOri == "SD2"
					aadd(_aLista,{_cDoc, _cLinha, CT2->CT2_DEBITO, CT2->CT2_CREDIT, CT2->CT2_CCD, CT2->CT2_CCC, CT2->CT2_HIST, CT2->CT2_VALOR, SD2->D2_DOC + "/" + SD2->D2_SERIE,"Cliente: " + SD2->D2_CLIENTE + "/" + SD2->D2_LOJA + " Tipo NF " + SD2->D2_TIPO + " Produto: "+ Alltrim(SD2->D2_COD) + " TES " + SD2->D2_TES + " CFOP " + SD2->D2_CF, SD2->D2_QUANT, SD2->D2_CUSTO1})
				ElseIf _cTabOri == "SD1"
					aadd(_aLista,{_cDoc, _cLinha, CT2->CT2_DEBITO, CT2->CT2_CREDIT, CT2->CT2_CCD, CT2->CT2_CCC, CT2->CT2_HIST, CT2->CT2_VALOR, SD1->D1_DOC + "/" + SD1->D1_SERIE,"Cliente: " + SD1->D1_FORNECE + "/" + SD1->D1_LOJA + " Tipo NF " + SD1->D1_TIPO + " Produto: "+ Alltrim(SD1->D1_COD) + " TES " + SD1->D1_TES + " CFOP " + SD1->D1_CF, SD1->D1_QUANT, SD1->D1_CUSTO})
				Endif
				_lFirst  := .F.
			Else
				If _cTabOri == "SD3"
					aadd(_aLista,{"", "", "", "", "", "", "", 0, SD3->D3_NUMSEQ, "Produto: "+ Alltrim(SD3->D3_COD) + " TM " + SD3->D3_TM + " CF " + SD3->D3_CF + IIF(!EMPTY(SD3->D3_OP), " OP " + SD3->D3_OP,""), SD3->D3_QUANT, SD3->D3_CUSTO1})
				ElseIf _cTabOri == "SD2"
					aadd(_aLista,{"", "", "", "", "", "", "", 0, SD2->D2_DOC + "/" + SD2->D2_SERIE, "Cliente: " + SD2->D2_CLIENTE + "/" + SD2->D2_LOJA + " Tipo NF " + SD2->D2_TIPO + " Produto: "+ Alltrim(SD2->D2_COD) + " TES " + SD2->D2_TES + " CFOP " + SD2->D2_CF, SD2->D2_QUANT, SD2->D2_CUSTO1})
				ElseIf _cTabOri == "SD1"
					aadd(_aLista,{"", "", "", "", "", "", "", 0, SD1->D1_DOC + "/" + SD1->D1_SERIE, "Cliente: " + SD1->D1_FORNECE + "/" + SD1->D1_LOJA + " Tipo NF " + SD1->D1_TIPO + " Produto: "+ Alltrim(SD1->D1_COD) + " TES " + SD1->D1_TES + " CFOP " + SD1->D1_CF, SD1->D1_QUANT, SD1->D1_CUSTO})
				Endif
			Endif
		Else
			aadd(_aLista,{_cDoc, _cLinha, CT2->CT2_DEBITO, CT2->CT2_CREDIT, CT2->CT2_CCD, CT2->CT2_CCC, CT2->CT2_HIST, CT2->CT2_VALOR, " ","Lan็amento Manual", 0, 0})
		Endif
		dbSelectArea(_cArqTMP)
		dbSkip()
	End
End
If !Empty(_aLista)
	_cWorkSheet := "LOTE" + mv_par02
	oExcel:AddworkSheet(_cWorkSheet)
	oExcel:AddTable(_cWorkSheet,"LOTE")
					//cWorkSheet        	,cTable		,cColumm	,nAlign	,nFormat	,lTotal					
	oExcel:AddColumn(_cWorkSheet		,"LOTE"			,"Documento"	,1		,1			,.F.	)
	oExcel:AddColumn(_cWorkSheet		,"LOTE"			,"Linha"		,1		,1			,.F.	)
	oExcel:AddColumn(_cWorkSheet		,"LOTE"			,"Debito"		,1		,1			,.F.	)
	oExcel:AddColumn(_cWorkSheet		,"LOTE"			,"Credito"		,1		,1			,.F.	)
	oExcel:AddColumn(_cWorkSheet		,"LOTE"			,"CC Debito"	,1		,1			,.F.	)
	oExcel:AddColumn(_cWorkSheet		,"LOTE"			,"CC Credito"	,1		,1			,.F.	)
	oExcel:AddColumn(_cWorkSheet		,"LOTE"			,"Hist๓rico"	,1		,1			,.F.	)
	oExcel:AddColumn(_cWorkSheet		,"LOTE"			,"Valor"		,3		,2			,.F.	)
	oExcel:AddColumn(_cWorkSheet		,"LOTE"			,"Doc.Origem"	,1		,1			,.F.	)
	oExcel:AddColumn(_cWorkSheet		,"LOTE"			,"Descri็ใo"	,1		,1			,.F.	)
	oExcel:AddColumn(_cWorkSheet		,"LOTE"			,"Quantidade"	,3		,2			,.F.	)
	oExcel:AddColumn(_cWorkSheet		,"LOTE"			,"Custo"		,3		,2			,.F.	)
	For _nX:=1 to Len(_aLista)
		oExcel:AddRow(_cWorkSheet,"LOTE",{_aLista[_nX,1],_aLista[_nX,2],_aLista[_nX,3],_aLista[_nX,4],_aLista[_nX,5],_aLista[_nX,6],_aLista[_nX,7],_aLista[_nX,8],_aLista[_nX,9], _aLista[_nX,10],_aLista[_nX,11], _aLista[_nX,12] })
	Next
Endif
If !Empty(oExcel:aWorkSheet)
	oExcel:Activate()
	oExcel:GetXMLFile(cDirDocs+"\"+cArquivo)
	CpyS2T(cDirDocs+"\"+cArquivo,cPath)
	oExcelApp := MsExcel():New()
	oExcelApp:WorkBooks:Open(cPath+cArquivo) // Abre uma planilha
	oExcelApp:SetVisible(.T.)
	oExcelApp:Destroy()
Else
	MsgAlert("Nใo hแ valores para exporta็ใo.")
EndIf
dbSelectArea(_cArqTMP)
dbCloseArea()
RestArea(_aArea)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAjustaSx1 บAutor  ณMicrosiga           บ Data ณ  01/19/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function AjustaSx1(cPerg)

Local _aArea := GetArea()
Local aRegs := {}
Local i,j

dbSelectArea("SX1")
dbSetOrder(1)
cPerg := PADR(cPerg,10)

Aadd(aRegs,{cPerg,"01","Data Lancamento ?","Data Lancamento      ?","Data Lancamento     ?","mv_ch1","D",8,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","",""," ","",""})
Aadd(aRegs,{cPerg,"02","Lote            ?","Documento            ?","Documento           ?","mv_ch2","C",TAMSX3("CT2_LOTE")[1],0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","",""," ","",""})
Aadd(aRegs,{cPerg,"03","SubLote        ?","Do Armazem           ?","Do Armazem           ?","mv_ch3","C",TAMSX3("CT2_SBLOTE")[1],0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","",""," ","",""})
Aadd(aRegs,{cPerg,"04","Documento       ?","Do Armazem           ?","Do Armazem          ?","mv_ch4","C",TAMSX3("CT2_DOC")[1],0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","",""," ","",""})
For i:=1 to Len(aRegs)
	If !dbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Endif
		Next
		MsUnlock()
	Endif
Next      
RestArea(_aArea)
Return