#Include 'Protheus.ch'

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MA410LEG   �Autor  �TOTVS NORDESTE      � Data �  05/02/15  ���
�������������������������������������������������������������������������͹��
���Desc.     �Ponto de entrada para bot�o legenda, para pedidos 		  ���
���				faturados parcialmente			                          ���
�������������������������������������������������������������������������͹��
���Uso       �Faturamento		                                          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function MA410LEG
	Local aLegenda := PARAMIXB
	
	AADD(aLegenda,{"BR_VIOLETA","Bloqueio Financeiro"})
	AADD(aLegenda,{"BR_CINZA","Fat.Parcial e N�o Lib.Comercial"})
	AADD(aLegenda,{"BR_AZUL_CLARO","Fat.Parcial e Lib.Comercial"})
	
Return aLegenda