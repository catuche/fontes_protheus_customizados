/*    
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � /ETIQ01  �       Por: Pedro Augusto Cardoso        07/01/08���
���Descricao � Rotina especifica para a geracao de temporario p/ a emissao���
���          � do relatorio ETIQ01.RPT,                                   ���
�������������������������������������������������������������������������Ĵ��
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
	�����������������������������������������������������������������������������
	���Observacao�CALLCRYS(<creport>,<cparam>,<copcoes>) onde                 ���
	���sintaxe da�<creport>= Nome do relatorio Crystal,localizado no diretorio���
	���funcao    �          apontado por MV_CRYSTAL, sem a extens�o e path.   ���
	���CallCrys()�<cparam>= Par�metros passados para o Crystal, em vez de usar���
	���          �          o SX1, separados por v�rgula ou ponto e v�rgula.  ���
	���          �<copcoes>= Conjunto de op��es para nao mostrar a tela da    ���
	���          �           SetPrint, composta por x;y;z;w, onde             ���
	���          �                         x = v�deo(1) ou impressora(3)      ���
	���          �                         y = Atualiza(0) ou n�o(1) os dados ���
	���          �                         z = N�mero de c�pias               ���
	���          �                         w = T�tulo do repo                 ���
	���          �                                                            ���
	���          �x:="3;0;1;Etiqueta 01"                                      ���
	���          �CALLCRYS("etiq01","00001,ZZZZZZ",x)                         ���
	��� Uso      � Especifico Geraldiscos                                     ���
	�����������������������������������������������������������������������������
	*/
    x:="1;0;1;Etiqueta"                                     
	CallCrys("ETQFIA",,x)
Return