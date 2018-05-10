#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  M461AVAL   � Autor � Ricardo Rotta      � Data �  22/06/16   ���
�������������������������������������������������������������������������͹��
���Descricao � Filtro na geracao NF po carga                              ���
���          � Verifica a existencia de bloqueio no SC9                   ���
�������������������������������������������������������������������������͹��
���Uso       � SuperNova                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function M461AVAL

Local _aArea := GetArea()
Local _aAreaC9 := SC9->(GetArea())
Local lRet := ParamIxb[1]
Local _cCarga  := DAK->DAK_COD
Local _cLocCar := DAK->DAK_SEQCAR
If lRet
	dbSelectArea("SC9")
	dbSetOrder(5)
	dbSeek(xFilial()+_cCarga+_cLocCar)
	While !Eof() .and. xFilial()+_cCarga+_cLocCar == SC9->(C9_FILIAL+C9_CARGA+C9_SEQCAR)
		lRet := ( Empty(SC9->C9_BLEST) .And. Empty(SC9->C9_BLCRED) .And. SC9->C9_BLWMS$"05,06,07,  ") 
		If !lRet
			Exit
		Endif
		dbSkip()
	End
Endif
RestArea(_aAreaC9)
RestArea(_aArea)
Return(lRet)