#include 'protheus.ch'
#include 'parmtype.ch'

/*/{Protheus.doc} F420CRP
Ponto de entrada ao final do processamento do CNAB
@author raphael.neves
@since 02/03/2018
@version 6
@return ${return}, ${return_description}

@type function
/*/

user function F420CRP()

	If MV_PAR30
		MsgAlert("Não é possível processar. Existe borderô bloqueado!")
	Endif

	MV_PAR30 := Nil

return