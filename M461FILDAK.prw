#Include 'Protheus.ch'

User Function M461FILDAK()

	Local cFiltro := ParamIxb[1]
	
	//cFiltro += " .and. DAK_XLIBER == 'S' " //Comentado por Raphael Neves 06.06.2017
	cFiltro += " .and. DAK_BLQCAR = ' ' "

Return cFiltro
