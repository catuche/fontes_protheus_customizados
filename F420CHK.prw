#include 'protheus.ch'
#include 'parmtype.ch'

/*/{Protheus.doc} F420CHK
Ponto de Entrada no momento de geração do CNAB

Aplicação:
Verificar se tem algum borderô bloqueado para não permitir. Tabalha em conjunto com o F420CRP.

@author raphael.neves
@since 02/03/2018
@version 6
@return ${return}, ${return_description}

@type function
/*/

User function F420CHK()

	Local nTipo := 1

	MV_PAR30 := IIF(ValType(MV_PAR30) == "L",MV_PAR30,.F.)

	//Verifica se o título posicionado está bloqueado ou se algum título do borderô está
	IF SE2->E2_XBLOQ == "S" .or. MV_PAR30
		nTipo := 3
		MV_PAR30 := .T.
	Endif


Return nTipo