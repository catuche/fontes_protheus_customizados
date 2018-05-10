#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  M410LIOK   � Autor � Ricardo Rotta      � Data �  18/08/17   ���
�������������������������������������������������������������������������͹��
���Descricao � Ponto de entrada na valida��o da linha do pedido de venda  ���
���          � Valida��o da 3o unidade de medida                          ���
�������������������������������������������������������������������������͹��
���Uso       � Fiabesa                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function M410LIOK

Local _lRet := .t.
Local nPTerc    := aScan(aHeader,{|x| AllTrim(x[2])=="C6_XTERCEI"})
Local nPUnVen  	:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_XUNVEN"})  // Unidade de Medida do PV
Local nPQtdVen  := aScan(aHeader,{|x| AllTrim(x[2])=="C6_QTDVEN"})
Local nPrcVen  	:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRCVEN"})
Local nPValor  	:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_VALOR"})
Local nPQtd3  	:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_XQTDV3"})
Local nPPrc3  	:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_XPRCV3"})
Local nPQtd2  	:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_UNSVEN"})
Local nPPrc2  	:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_XPRCV2"})
If aCols[n,nPUnVen] == "3"
	If aCols[n,nPQtd3] == 0 .or. aCols[n,nPPrc3] == 0
		Help(" ",1,"NTERCQ3",,"Os campos referente a Terceira Unidade n�o est�o preenchidos",4,,,,,,.F.)
		_lRet := .f.
	Endif
ElseIf aCols[n,nPUnVen] == "2"
	If aCols[n,nPQtd2] == 0 .or. aCols[n,nPPrc2] == 0
		Help(" ",1,"NTERCQ2",,"Os campos referente a Segunda Unidade n�o est�o preenchidos",4,,,,,,.F.)
		_lRet := .f.
	Endif
Endif
Return(_lRet)