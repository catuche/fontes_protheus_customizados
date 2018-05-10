#include 'protheus.ch'
#include 'parmtype.ch'

user function MA330CP()
 
LOCAL aRegraCP:={}
AADD(aRegraCP,"SB1->B1_TIPO == 'Z1'")   // MOD
AADD(aRegraCP,"SB1->B1_TIPO == 'Z2'")   // GGF
AADD(aRegraCP,"SB1->B1_TIPO == 'Z3'")   // OUTROS
AADD(aRegraCP,"SB1->B1_TIPO == 'Z4'")   // MOI
Return aRegraCP
	