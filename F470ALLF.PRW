#include 'protheus.ch'
#include 'parmtype.ch'

User function F470ALLF()

Local lRet := .T.

IF "CX" $ MV_PAR01
	lRet := .F.
Endif

Return lRet