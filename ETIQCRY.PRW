/*    
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ /ETIQ01  ³       Por: Pedro Augusto Cardoso        07/01/08³±±
±±³Descricao ³ Rotina especifica para a geracao de temporario p/ a emissao³±±
±±³          ³ do relatorio ETIQ01.RPT,                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
*/
#include "rwmake.ch"
User Function ETIQCRY()
Local _aRegs
Local _cRelatorio	:= "ETQFIA"
Local _cArquivo		:= GetMV("MV_CRYSTAL")+_cRelatorio+".RPT" //MESMO PARAMETRO PARA OS 3 TIPOS DE ETIQUETA
Local _nVias     	:= 0       
Local _nQuant     	:= 0       

Processa( {|| CriaTMP(_cRelatorio) },"Selecionando Registros")	

Return

Static Function CriaTMP(_cRelatorio)

	/*
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
	±±³Observacao³CALLCRYS(<creport>,<cparam>,<copcoes>) onde                 ³±±
	±±³sintaxe da³<creport>= Nome do relatorio Crystal,localizado no diretorio³±±
	±±³funcao    ³          apontado por MV_CRYSTAL, sem a extensão e path.   ³±±
	±±³CallCrys()³<cparam>= Parƒmetros passados para o Crystal, em vez de usar³±±
	±±³          ³          o SX1, separados por vírgula ou ponto e vírgula.  ³±±
	±±³          ³<copcoes>= Conjunto de opções para nao mostrar a tela da    ³±±
	±±³          ³           SetPrint, composta por x;y;z;w, onde             ³±±
	±±³          ³                         x = vídeo(1) ou impressora(3)      ³±±
	±±³          ³                         y = Atualiza(0) ou não(1) os dados ³±±
	±±³          ³                         z = Número de cópias               ³±±
	±±³          ³                         w = Título do repo                 ³±±
	±±³          ³                                                            ³±±
	±±³          ³x:="3;0;1;Etiqueta 01"                                      ³±±
	±±³          ³CALLCRYS("etiq01","00001,ZZZZZZ",x)                         ³±±
	±±³ Uso      ³ Especifico Geraldiscos                                     ³±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
	*/
    x:="1;0;1;Etiqueta"                                     
	CallCrys("ETQFIA",,x)
Return