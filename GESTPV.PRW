#include "rwmake.ch"
#Include "TOPCONN.ch"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGESTPV    บAutor  ณMicrosiga           บ Data ณ  01/31/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function GESTPV

Local aSay    := {}
Local aButton := {}
Local nOpc    := 0
Local cTitulo := "Geracao de Estoque por PV"
Local cDesc1  := "Este programa tem como objetivo gerar estoque"
Local cDesc2  := "Especifico"

Private cPerg := "GR_ESTOQ"

AjustaSx1(cPerg)
Pergunte(cPerg,.F.)

aAdd( aSay, cDesc1 )
aAdd( aSay, cDesc2 )

aAdd( aButton, { 5, .T., {|| Pergunte(cPerg,.T. )    }} )
aAdd( aButton, { 1, .T., {|| nOpc := 1, FechaBatch() }} )
aAdd( aButton, { 2, .T., {|| FechaBatch()            }} )

FormBatch( cTitulo, aSay, aButton )

If nOpc <> 1
	Return Nil
Endif

Processa( {|lEnd| RunProc(@lEnd)}, "Aguarde...","Executando rotina.", .T. )

Return Nil


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGESTPV    บAutor  ณMicrosiga           บ Data ณ  01/31/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function RunProc

//mv_par01	Do PV
//mv_par02  Ate PV
//mv_par03	Do Produto
//mv_par04	Ate Produto
//mv_par05	Lote Estoq.

Local _aTotItem	:= {}
Local _nLote    := mv_par05
Local _aArea := GetArea()
Local _cTM   := "100"
dbSelectArea("SC6")
cAliasNew := CriaTrab(NIL,.F.)

cQuery := "SELECT C6_PRODUTO, C6_LOCAL, SUM(C6_QTDVEN) C6_QTDVEN "
cQuery += " FROM "+RetSqlName("SC6")+" SC6, "+RetSqlName("SF4")+" SF4 "
cQuery += " WHERE SC6.C6_FILIAL='"+xFilial("SC6")+"' AND "
cQuery += " SC6.C6_NUM >= '"+mv_par01+"' AND "
cQuery += " SC6.C6_NUM <= '"+mv_par02+"' AND "
cQuery += " SC6.C6_PRODUTO >= '" + mv_par03 + "' AND "
cQuery += " Sc6.C6_PRODUTO <= '" + mv_par04 + "' AND "
cQuery += " SC6.D_E_L_E_T_ = ' ' AND "
cQuery += " SC6.C6_TES = SF4.F4_CODIGO AND "
cQuery += " SF4.F4_ESTOQUE = 'S' AND "
cQuery += " SF4.D_E_L_E_T_ = ' ' "
cQuery += " GROUP BY C6_PRODUTO, C6_LOCAL"
cQuery += " ORDER BY C6_PRODUTO, C6_LOCAL"
cQuery := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasNew,.T.,.T.)
aEval(SC6->(dbStruct()), {|x| If(x[2] <> "C", TcSetField(cAliasNew,x[1],x[2],x[3],x[4]),Nil)})
dbSelectArea(cAliasNew)
While (cAliasNew)->( !Eof())
	_cCod := (cAliasNew)->C6_PRODUTO
	_nQuant := (cAliasNew)->C6_QTDVEN
	_cLocal := (cAliasNew)->C6_LOCAL
	_nIntLot := INT(_nQuant / _nLote)
	_nMult   := _nIntLot * _nLote
	_nResto  := _nQuant - _nMult
	If _nResto > 0
		_nIntLot++
	Endif
	For I:=1 to _nIntLot
		If I == _nIntLot
			_nQtde := _nResto
		Else
			_nQtde := _nLote
		Endif
		_aItem:={}
		_aItem:={	{"D3_COD"       ,_cCod  ,nil},;
					{"D3_LOCAL"     ,_cLocal  ,nil},;
					{"D3_QUANT"		,ROUND(_nQtde,TAMSX3("D3_QUANT")[2])  ,NIL}}
		Aadd(_aTotItem,_aItem)
		dbSkip()
	Next

	If Len(_aTotItem) > 0
		lMsErroAuto := .F.
		cDocumento := NextNumero("SD3",2,"D3_DOC",.T.)
		cCCusto := " "
		_aCab 	:={	{"D3_DOC"       ,cDocumento       ,nil},;
					{"D3_TM"		,_cTM             ,NIL},;
					{"D3_EMISSAO"   ,dDataBase        ,nil}}
		dbSelectArea("SD3")
		MSExecAuto({|x,y,z| MATA241(x,y,z)},_aCab,_aTotItem,3)  // Gera os registros no SD3
		If lMsErroAuto
			Mostraerro()
		Endif
	Endif
	dbSelectArea(cAliasNew)
	dbSkip()
End
dbSelectArea(cAliasNew)
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
Local _sAlias := Alias()
Local aRegs := {}
Local i,j
*
dbSelectArea("SX1")
dbSetOrder(1)
cPerg := PADR(cPerg,10)
*
aAdd(aRegs,{cPerg,"01","Do Pedido   ?","","","mv_ch1","C",06,00,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"02","Ate Pedido  ?","","","mv_ch2","C",06,00,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"03","Do Produto  ?","","","mv_ch3","C",15,00,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"04","Ate Produto ?","","","mv_ch4","C",15,00,0,"G","","MV_PAR04","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"05","Lote Estoque?","","","mv_ch5","N",06,00,0,"G","","MV_PAR05","","","","","","","","","","","","","","","","","","","","","","","","",""})
*
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
Return