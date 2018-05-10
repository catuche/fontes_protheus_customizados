#include 'protheus.ch'
#include 'parmtype.ch'

/*/{Protheus.doc} F590CAN
Ponto de entrada ap�s o cancelamento do Border�
@author raphael.neves
@since 02/03/2018
@version 6
@return ${return}, ${return_description}

@type function
/*/

User function F590CAN()

	Local cTipo := ParamIxb[1]
	Local cNumBor := ParamIxb[2]

	//Rotina para libera��o ou bloqueio do border�
	U_LIBBORD(cNumBor,.T.)

Return