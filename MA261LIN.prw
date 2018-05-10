#INCLUDE "Protheus.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MA261LIN  � Autor � Ricardo Rotta      � Data �  07/03/18   ���
�������������������������������������������������������������������������͹��
���Descricao � Ponto de entrada na validacao da digita��o da transf. multip.�
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Fiabesa                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function MA261LIN

Local _lRet := .t.
Local _nPosSub, nH
If Funname() == "FBMATA261"
	_nPosSub := aScan(aHeader,{|x| AllTrim(x[2])=="_cDestSub"})
	If _nPosSub > 0
		For nH:=1 to Len(aCols)
			If !aCols[nH][Len(aHeader)+1]
				If Empty(aCols[nH,_nPosSub])
					Help(" ",1,"USUNTRF",,"Usuario sem permissao para incluir transferencia, permitido apenas Aglutinar SubLotes",4,,,,,,.F.)
					_lRet := .f.
					Exit
				Endif
			Endif
		Next
	Endif
Endif
Return(_lRet)