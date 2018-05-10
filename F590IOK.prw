#include 'protheus.ch'
#include 'parmtype.ch'

/*/{Protheus.doc} F590IOK
Ponto de entrada antes da inclusão do título no borderô

Aplicação:
Validar se continua ou não para bloquear novamente o borderô

@author raphael.neves
@since 02/03/2018
@version 6
@return ${return}, ${return_description}

@type function
/*/

user function F590IOK()
	Local cTipo := ParamIxb[1]
	Local cNumBor := ParamIxb[2]
	Local lRet := .T.

	IF "P" $ cTipo
		IF !MsgYesNo("Ao incluir é necessário reaprovar todo o borderô. Deseja continuar? ")
			lRet := .F.
		Endif
	Endif

return lRet