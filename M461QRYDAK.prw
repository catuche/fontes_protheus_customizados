#Include 'Protheus.ch'

User Function M461QRYDAK()
	
	Local cQuery := ParamIxb[1]
	
	//cQuery += " AND DAK.DAK_XLIBER = 'S' "//Comentado por Raphael Neves 06.06.2017
	cQuery += " AND DAK.DAK_BLQCAR = ' ' "
	
Return cQuery

