#include 'protheus.ch'
#include 'parmtype.ch'

/*/{Protheus.doc} F590IOK
Ponto de entrada antes da inclus�o do t�tulo no border�

Aplica��o:
Validar se continua ou n�o para bloquear novamente o border�

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
		IF !MsgYesNo("Ao incluir � necess�rio reaprovar todo o border�. Deseja continuar? ")
			lRet := .F.
		Endif
	Endif

return lRet