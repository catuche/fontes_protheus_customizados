#INCLUDE "Protheus.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  IniCPOP    � Autor � Ricardo Rotta      � Data �  23/03/17   ���
�������������������������������������������������������������������������͹��
���Descricao � Fun��o utilizada no incializador padr�o do campo H6_OP     ���
���          � para trazer os dados da OP digitada anteriormente          ���
�������������������������������������������������������������������������͹��
���Uso       � Fiabesa                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function IniCPOP

Local _cCampos := Alltrim(SuperGetMV("FB_TELAOP",.F.,"H6_OP/H6_PRODUTO/H6_OPERAC/H6_RECURSO/H6_FERRAM/H6_QTDPROD/H6_QTDPERD/H6_PT/H6_DTAPONT/H6_LOTECTL/H6_NUMLOTE/H6_DTVALID/H6_OPERADO/H6_QTDPRO2/H6_XTURNO/H6_XTARA"))
Local _aCampos := {}
While Len(_cCampos) > 3
	_nPosic := AT("/",_cCampos)
	If _nPosic > 0
		aadd(_aCampos,Substr(_cCampos,1,_nPosic-1))
	Else
		aadd(_aCampos,Alltrim(Substr(_cCampos,1)))
	Endif
End
For nT:=1 to Len(_aCampos)



Return
