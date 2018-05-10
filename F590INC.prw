#include 'protheus.ch'
#include 'parmtype.ch'

/*/{Protheus.doc} F590INC
Ponto de entrada ap�s a inclus�o do border�
@author raphael.neves
@since 02/03/2018
@version 6
@return ${return}, ${return_description}

@type function
/*/

User function F590INC()
	Local cTipo := ParamIxb[1]
	Local cNumBor := ParamIxb[2]

	//Rotina para libera��o ou bloqueio do border�
	U_LIBBORD(cNumBor,.t.)

Return