#Include 'Protheus.ch'
/*
Função para preenchimento do campo C6_OPER,
com o conteudo do C5_XTPOPR.
*/
User Function FTPOPR()
	Local nX
	Local nPos := aScan(aHeader,{|x| Alltrim(x[2])=="C6_OPER" })
	 
	For nX := 1 to Len(aCols)
		aCols[nX][nPos] := M->C5_XTPOPR
	Next nX

	oGetDad:oBrowse:Refresh(.T.)

Return .T.

