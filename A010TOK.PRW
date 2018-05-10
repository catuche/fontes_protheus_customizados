#Include "Protheus.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³A010TOK     º Autor ³ GRACA            º Data ³  21/10/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Validações do usuário                                      º±±
±±º          ³ 1- bloquear na alteracao se o ´ivel do usuario >= a 7      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MATA121 (Pedido de Compras)                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function A010TOK()

Local a_Area    := GetArea()
Local _cNCM		:= AllTrim(M->B1_POSIPI)
Local _cTipo	:= AllTrim(M->B1_TIPO)
Local _lRet		:= .t.
If _cTipo == "19" 
	_lRet := .t.
Else
	If Empty(_cNCM)
		Help(" ",1,"NPOSIPI",,'Campo Pos. IPI/NCM da aba 02-Impostos, deve ser preenchido para este tipo de produto!',1 )
		_lRet := .F.
	Endif
Endif

If _lRet .and. M->B1_MSBLQL == '1'
	_lRet := VerMovF()
Endif
RestArea(a_Area)
Return _lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³A010TOK   ºAutor  ³Microsiga           º Data ³  04/05/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function VerMovF

Local _lRet := .t.
Local _aArea := GetArea()
Local cQuery
Local cAliasSC6 := "QRYSC6"
Local cAliasSD4 := "QRYSD4"
Local cAliasSC2 := "QRYSC2"

cQuery := "SELECT COUNT(*) RECSC6 "
cQuery += "FROM " + retSQLName("SC6") + " SC6 "
cQuery += "INNER JOIN  " + retSQLName("SC5") + " SC5 ON C5_FILIAL=C6_FILIAL AND C5_NUM = C6_NUM "
cQuery += "INNER JOIN  " + retSQLName("SB1") + " SB1 ON C6_PRODUTO = B1_COD "

cQuery += "WHERE	"
cQuery += "	    SC6.D_E_L_E_T_ = '' "
cQuery += "	AND SC5.D_E_L_E_T_ = '' "
cQuery += "	AND SB1.D_E_L_E_T_ = '' "
cQuery += "	AND C6_NOTA = ''
cQuery += "	AND C5_NOTA = ''
cQuery += "	AND B1_COD = '" + AllTrim (M->B1_COD) + "' "

cQuery := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSC6,.T.,.T.)

If (cAliasSC6)->RECSC6 > 0
	Help(" ",1,"PVABERTO",,"Produto com Pedido de Venda em Aberto.Portanto não poderá ser bloqueado!",1 )
	_lRet := .F.
EndIf
dbSelectArea(cAliasSC6)
dbCloseArea()

If _lRet
	cQuery := "SELECT COUNT(*) RECSD4 "
	cQuery += "FROM " + retSQLName("SD4") + " SD4 "
	cQuery += "WHERE	"
	cQuery += "	D4_FILIAL  = '" + xFilial("SD4") + "'"
	cQuery += "	AND SD4.D_E_L_E_T_ = '' "
	cQuery += "	AND D4_COD = '" + M->B1_COD + "' "
	cQuery += "	AND D4_QUANT > 0"

	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSD4,.T.,.T.)

	If (cAliasSD4)->RECSD4 > 0
		Help(" ",1,"EMABERTO",,"Produto empenhado em Ordem de Produção. Portanto não poderá ser bloqueado!",1 )
		_lRet := .F.
	EndIf
	dbSelectArea(cAliasSD4)
	dbCloseArea()
Endif
If _lRet
	cQuery := "SELECT COUNT(*) RECSC2 "
	cQuery += "FROM " + retSQLName("SC2") + " SC2 "
	cQuery += "WHERE	"
	cQuery += "	C2_FILIAL  = '" + xFilial("SC2") + "'"
	cQuery += "	AND SC2.D_E_L_E_T_ = '' "
	cQuery += "	AND C2_PRODUTO = '" + M->B1_COD + "' "
	cQuery += "	AND C2_DATRF = '        '"

	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSC2,.T.,.T.)

	If (cAliasSC2)->RECSC2 > 0
		Help(" ",1,"OPABERTO",,"Produto com Ordem de Produção em aberto. Portanto não poderá ser bloqueado!",1 )
		_lRet := .F.
	EndIf
	dbSelectArea(cAliasSC2)
	dbCloseArea()
Endif
RestArea(_aArea)
Return(_lRet)