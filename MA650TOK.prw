#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  MA650TOK   � Autor � Ricardo Rotta      � Data �  17/04/17   ���
�������������������������������������������������������������������������͹��
���Descricao � Ponto de entrada na geracao da OP, consiste a existencia do���
���          � roteiro de opera��o                                        ���
�������������������������������������������������������������������������͹��
���Uso       � Fiabesa                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function MA650TOK

Local _aArea   := GetArea()
Local _lRet	   := .t.
Local _cRotOpe := M->C2_ROTEIRO
Local _cProd   := M->C2_PRODUTO
Local lProces := SuperGetMV("MV_APS",.F.,"") == "TOTVS" .Or. lIntSFC .OR. SuperGetMV("MV_PCPATOR",.F.,.F.) == .T.
If FUNNAME() == "MATA650" .and. lProces
	dbSelectArea("SG2")
	dbSetOrder(1)
	If !dbSeek(xFilial()+_cProd+_cRotOpe)
		Help(" ",1,"F_NOPERACAO",,"Roteiro de Opera��o n�o existe para este produto, utilize um roteiro valido",4,,,,,,.F.)
		_lRet := .f.
	Endif
Endif
RestArea(_aArea)
Return(_lRet)