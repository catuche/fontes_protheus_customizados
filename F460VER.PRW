#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 06/10/03
#include "Protheus.ch"

User Function F460VER()        // incluido pelo assistente de conversao do AP6 IDE em 06/10/03

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP6 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local _x := 0
Local _nHdll := 0

SetPrvt("CSAVALIA,CSAVIND,CCOR,NOPC,CVALOR")

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ FINR460 ³ Autor ³  Cesar Monteiro       ³ Data ³ 08/01/99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Ponto de Entrada para Impressao de Verso do Cheque        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Clientes Microsiga.                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
cSavAlia := Alias()              // Salva Alias
cSavInd  := IndexOrd()           // Salva Indices

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Tratamento das Notas Fiscais Canceladas                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

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
