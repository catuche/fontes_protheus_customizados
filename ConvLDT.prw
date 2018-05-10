#include "rwmake.ch"

///--------------------------------------------------------------------------\
//| Fun��o: CONVLDT				Autor: DANIEL LIRA				Data: 22/06/2017 |
//|--------------------------------------------------------------------------|
//| Descri��o: Fun��o para Convers�o da Representa��o Num�rica do C�digo de  |
//|            Barras - Linha Digit�vel (LD) em C�digo de Barras (CB)        |
//|            De Tributo.                                                   |
//|            Para utiliza��o dessa Fun��o, deve-se criar um Gatilho para o |
//|            campo E2_X_CODBA, Conta Dom�nio: E2_X_CODBA, Tipo: Prim�rio,  |
//|            Regra: EXECBLOCK("CONVLDT",.T.), Posiciona: N�o.              |
//|                                                                          |
//|            Utilize tamb�m a Valida��o do Usu�rio para o Campo E2_CODBAR  |
//|            EXECBLOCK("CODBAR",.T.) para Validar a LD ou o CB.            |
//\--------------------------------------------------------------------------/
USER FUNCTION ConvLDT()
SETPRVT("cStr")

cStr := LTRIM(RTRIM(M->E2_X_CODBA))

IF VALTYPE(M->E2_X_CODBA) == NIL .OR. EMPTY(M->E2_X_CODBA)
	// Se o Campo est� em Branco n�o Converte nada.
	cStr := "" 
ELSEIF !EMPTY(M->E2_X_CODBA).and.LEN(cStr) == 48
   cStr := SUBSTR(cStr,1,11)+SUBSTR(cStr,13,11)+SUBSTR(cStr,25,11)+SUBSTR(cStr,37,11) 
ELSEIF LEN(cStr) != 44  .and. LEN(cStr)!= 48
   Alert("****Aten��o existe uma inconsist�ncia na linha digitavel****") 
   cStr := ""

  
ENDIF    

RETURN(cStr)