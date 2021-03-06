#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 06/10/03
#include "Protheus.ch"

User Function F460VER()        // incluido pelo assistente de conversao do AP6 IDE em 06/10/03

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP6 IDE                    �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

Local _x := 0
Local _nHdll := 0

SetPrvt("CSAVALIA,CSAVIND,CCOR,NOPC,CVALOR")

/*/
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇
굇旼컴컴컴컴컫컴컴컴컴컫컴컴컴컫컴컴컴컴컴컴컴컴컴컴컴컫컴컴컴쩡컴컴컴컴커굇
굇쿛rograma  � FINR460 � Autor �  Cesar Monteiro       � Data � 08/01/99 낢�
굇쳐컴컴컴컴컵컴컴컴컴컨컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컨컴컴컴좔컴컴컴컴캑굇
굇쿏escri뇚o � Ponto de Entrada para Impressao de Verso do Cheque        낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴캑굇
굇쿢so       � Especifico para Clientes Microsiga.                       낢�
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸굇
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽
/*/
cSavAlia := Alias()              // Salva Alias
cSavInd  := IndexOrd()           // Salva Indices

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Tratamento das Notas Fiscais Canceladas                                    �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸

_nHdll := PARAMIXB

_nHdll :=0 //alterado no dia 01/02/00
IF MsgYesNo("Imprime Verso do Cheque ? ")
    nOpc := 1
Else
    nOpc := 2
Endif

If nOpc==1

    //Buscar a relacao de Titulos do SE2 de acordo com o Numero do Cheque.
    _aSE2 := GetArea("SE2")
    _aTitulos := {}
    
    DbSelectArea("SE2")
    _cArq2   := CriaTrab(NIL,.F.)
	_cChave2 := "E2_FILIAL+E2_NUMBCO+E2_BCOPAG"
	IndRegua("SE2",_cArq2,_cChave2,,,"Selecionando Registros...")
	DbSeek(xFilial("SE2")+SEF->EF_NUM+SEF->EF_BANCO)
	While SE2->E2_NUMBCO == SEF->EF_NUM

          //E2_PREFIXO / E2_NUM / E2_PARCELA / E2_VALOR
	      aadd( _aTitulos , { SE2->E2_PREFIXO + " /  " + SE2->E2_NUM + " / " + SE2->E2_PARCELA + " /  " + str( SE2->E2_VALOR, 17, 2) } )
	      DbSkip()
	
	Enddo
	RestArea( _aSE2 )  

    cValor:= ALLTRIM(STR(SEF->EF_VALOR,17,2))

    MsWrite(_nHdll,"                    "+Replic(CHR(10)+CHR(13),5))
    MsWrite(_nHdll,"                    "+"ESTE CHEQUE DESTINA-SE A:"+CHR(10)+CHR(13))
    MsWrite(_nHdll,"                    "+SEF->EF_HIST+CHR(10)+CHR(13))
    MsWrite(_nHdll,"                    "+"NO VALOR DE R$ "+cValor+CHR(10)+CHR(13))
    MsWrite(_nHdll,"                    "+"A: "+SEF->EF_BENEF+Replic(CHR(10)+CHR(13),7))
    MsWrite(_nHdll,"                    "+Replic("_",42) +CHR(10)+CHR(13))
    MsWrite(_nHdll,"                    "+ALLTRIM(SUBSTR(SM0->M0_NOMECOM,1,40))+Replic(CHR(10)+CHR(13),2))
    MsWrite(_nHdll,CHR(12)+CHR(26))
    
    //Imprime relacao de titulos
    MsWrite(c,"                    "+Replic(CHR(10)+CHR(13),5))    
    MsWrite(_nHdll,"                    "+"REF. AOS TITULOS:"+CHR(10)+CHR(13))    
    For _x := 1 to Len( _aTitulos )
	    MsWrite(_nHdll, _aTitulos[ _x ] + CHR(10)+CHR(13) )
    Next
    MsWrite(_nHdll,CHR(12)+CHR(26))

Endif

dbSelectArea(cSavAlia)
dbSetOrder(cSavInd)

// Substituido pelo assistente de conversao do AP6 IDE em 06/10/03 ==> __Return(.T.)
Return(.T.)        // incluido pelo assistente de conversao do AP6 IDE em 06/10/03
