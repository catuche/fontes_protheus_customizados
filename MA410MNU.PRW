#Include "RwMake.ch"

User Function MA410MNU()

aadd(aRotina,{'Imprime Pedido','U_XMATR730()', 0, 7, 0, NIL})

Return

User Function XMATR730()

	Pergunte("MTR730",.F.)

	MV_PAR01 := SC5->C5_NUM
	MV_PAR02 := SC5->C5_NUM

	MATR730()

Return