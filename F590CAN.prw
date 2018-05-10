#include 'protheus.ch'
#include 'parmtype.ch'

/*/{Protheus.doc} F590CAN
Ponto de entrada após o cancelamento do Borderô
@author raphael.neves
@since 02/03/2018
@version 6
@return ${return}, ${return_description}

@type function
/*/

User function F590CAN()

	Local cTipo := ParamIxb[1]
	Local cNumBor := ParamIxb[2]

	//Rotina para liberação ou bloqueio do borderô
	U_LIBBORD(cNumBor,.T.)

Return