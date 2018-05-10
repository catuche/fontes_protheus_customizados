#Include 'Protheus.ch'

User Function FNFBS001()

Local lRet     := .T.
Local cProduto := ""
Local nPosProd := 0

cProduto := Alltrim(M->C6_PRODUTO)
nPosProd := Ascan(aHeader, {|x| AllTrim(x[2]) == "C6_PRODUTO"})

For i:=1 to len(aCols)
	If Alltrim(aCols[i][nPosProd]) == cProduto .and. N <> i
		MsgInfo("Produto "+cProduto+" repetido no item "+StrZero(i,TamSx3("C6_ITEM")[1])+"! ")
		Exit
	Endif
Next i

Return lRet

