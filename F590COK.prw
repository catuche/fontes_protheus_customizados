#include 'protheus.ch'
#include 'parmtype.ch'

/*/{Protheus.doc} F590COK
Ponto de Entrada antes do cancelamento do título do Borderô

Aplicação:
Validar se continua ou não para bloquear novamente o borderô

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
		IF !MsgYesNo("Ao cancelar é necessário reaprovar todo o borderô. Deseja continuar? ")
			lRet := .F.
		Endif
	Endif

return lRet