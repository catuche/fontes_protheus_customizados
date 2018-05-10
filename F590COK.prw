#include 'protheus.ch'
#include 'parmtype.ch'

/*/{Protheus.doc} F590COK
Ponto de Entrada antes do cancelamento do t�tulo do Border�

Aplica��o:
Validar se continua ou n�o para bloquear novamente o border�

@author raphael.neves
@since 02/03/2018
@version 6
@return ${return}, ${return_description}

@type function
/*/

user function F590COK()
	Local cTipo := ParamIxb[1]
	Local cNumBor := ParamIxb[2]
	Local lRet := .T.

	IF "P" $ cTipo
		IF !MsgYesNo("Ao cancelar � necess�rio reaprovar todo o border�. Deseja continuar? ")
			lRet := .F.
		Endif
	Endif

return lRet