#INCLUDE "Protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �A140ALT   �Autor  �Ricardo Rotta       � Data �  12/05/16   ���
�������������������������������������������������������������������������͹��
���Desc.     �Ponto de entrada para validar a alteracao do pre-documento ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Fiabesa                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function A140ALT

Local _lRet := .t.
Local _cChave := SF1->(F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA)

dbSelectArea("DCX")
dbSetOrder(2)
If dbSeek(xFilial()+_cChave)
	_cNEmbarq := DCX->DCX_EMBARQ
	dbSelectArea("DCW")
	dbSetOrder(1)
	If dbSeek(xFilial()+_cNEmbarq)
		If DCW->DCW_SITEMB <> "1"
			MsgAlert("Iniciado conferencia fisica, para alterar primeiro exclua a conferencia", "ATENCAO")
			_lRet := .f.
		Endif
	Endif
Endif
Return(_lRet)