#INCLUDE "TOTVS.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  A650OPI    � Autor � AP6 IDE            � Data �  23/07/13   ���
�������������������������������������������������������������������������͹��
���Descricao � Ponto de entrada para retornar se gera ou nao OP para os   ���
���          � produtos intermediarios                                    ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function A650OPI

Local _aArea 	:= GetArea()
Local _nLinha 	:= Paramixb  // Numero da Linha do Acols
Local _lRet 	:= .T.  // Gera OP para PI
Local _cCodPI	:= aCols[_nLinha,nPosCod]
Local _cGrupo	:= Posicione("SB1",1,xFilial("SB1")+_cCodPI,"B1_GRUPO")
If FUNNAME() == "MATA681"
	_lRet := .f. // N�o gera OP
Endif
Return(_lRet)