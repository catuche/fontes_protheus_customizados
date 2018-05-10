#include "rwmake.ch"

///--------------------------------------------------------------------------\
//| Função: CONVLDT				Autor: DANIEL LIRA				Data: 22/06/2017 |
//|--------------------------------------------------------------------------|
//| Descrição: Função para Conversão da Representação Numérica do Código de  |
//|            Barras - Linha Digitável (LD) em Código de Barras (CB)        |
//|            De Tributo.                                                   |
//|            Para utilização dessa Função, deve-se criar um Gatilho para o |
//|            campo E2_X_CODBA, Conta Domínio: E2_X_CODBA, Tipo: Primário,  |
//|            Regra: EXECBLOCK("CONVLDT",.T.), Posiciona: Não.              |
//|                                                                          |
//|            Utilize também a Validação do Usuário para o Campo E2_CODBAR  |
//|            EXECBLOCK("CODBAR",.T.) para Validar a LD ou o CB.            |
//\--------------------------------------------------------------------------/
USER FUNCTION ConvLDT()
SETPRVT("cStr")

cStr := LTRIM(RTRIM(M->E2_X_CODBA))

IF VALTYPE(M->E2_X_CODBA) == NIL .OR. EMPTY(M->E2_X_CODBA)
	// Se o Campo está em Branco não Converte nada.
	cStr := "" 
ELSEIF !EMPTY(M->E2_X_CODBA).and.LEN(cStr) == 48
   cStr := SUBSTR(cStr,1,11)+SUBSTR(cStr,13,11)+SUBSTR(cStr,25,11)+SUBSTR(cStr,37,11) 
ELSEIF LEN(cStr) != 44  .and. LEN(cStr)!= 48
   Alert("****Atenção existe uma inconsistência na linha digitavel****") 
   cStr := ""

  
ENDIF    

RETURN(cStr)