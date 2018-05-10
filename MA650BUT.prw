#INCLUDE "PROTHEUS.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MA650BUT  �Autor  �Microsiga           � Data �  01/09/18   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MA650BUT

Local _aMenu := ParamIxb

aAdd(_aMenu,{"Altera Quantidade OP","u_AltQtdOP",0,7,NIL})

Return(_aMenu)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MA650BUT  �Autor  �Microsiga           � Data �  01/09/18   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function AltQtdOP

Local _aArea := GetArea()
Local _nQtdOri := SC2->C2_QUANT
Local _nQtdOP := SC2->C2_QUANT
Local _nQuje  := SC2->C2_QUJE
Local _cOP	  := SC2->(C2_NUM+C2_ITEM+C2_SEQUEN)
Local lOK	  := .f.
//---------------------------
//Monta a tela
//---------------------------
DEFINE MSDIALOG oDlg  FROM 000, 000  TO 180, 360 TITLE OemToAnsi("Altera��o da Quantidade da OP") PIXEL STYLE DS_MODALFRAME
cTexto := "Informe a quantidade da OP " + _cOP

@ 010, 015 SAY cTexto SIZE 160, 025 OF oDlg COLORS 0, 16777215 PIXEL

@ 020, 015 SAY OemToAnsi("Quantidade da OP")/*"Ganho de produ��o:"*/ SIZE 055, 015 OF oDlg COLORS 0, 16777215 PIXEL
@ 040, 015 SAY OemToAnsi("Quantidade Produzida")/*"Produ��o a maior:"*/  SIZE 055, 015 OF oDlg COLORS 0, 16777215 PIXEL

@ 020, 070 MSGET oQtdOP VAR _nQtdOP Picture PesqPict("SC2","C2_QUANT") Valid (Positivo(_nQtdOP)) SIZE 070, 010 OF oDlg PIXEL
@ 040, 070 MSGET oQuje VAR _nQuje Picture   PesqPict("SC2","C2_QUJE")  When .f. SIZE 070, 010 OF oDlg PIXEL

DEFINE SBUTTON FROM 075, 086 TYPE 01 OF oDlg ENABLE ACTION (lOK := .T.,oDlgTdOP(oDlg, lOk, _nQtdOP, _nQuje))
DEFINE SBUTTON FROM 075, 115 TYPE 02 OF oDlg ENABLE ACTION (lOK := .F.,oDlg:End())

oDlg:lEscClose := .F.
ACTIVATE MSDIALOG oDlg CENTERED
//---------------------------
lRet := lOk
if lRet
	dbSelectArea("SC2")
	RecLock("SC2",.F.)
	Replace C2_QUANT with _nQtdOP
	MsUnLock()
	dbSelectArea("SD4")
	dbSetOrder(2)
	dbSeek(xFilial()+_cOP)
	While !Eof() .and. xFilial("SD4")+ALLTRIM(_cOP) == SD4->(D4_FILIAL+ALLTRIM(D4_OP))
		_nEmpOri := SD4->D4_QTDEORI
		_nIndOri := _nQtdOP / _nQtdOri
		_nNewEmp := ROUND(_nEmpOri * _nIndOri, TAMSX3("D4_QTDEORI")[2])
		dbSelectArea("SD4")
		RecLock("SD4",.F.)
		Replace D4_QTDEORI with _nNewEmp
		MsUnLock()
		dbSkip()
	End
Endif
RestArea(_aArea)
Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �oDlgTdOK  � Autor � Everton M. Fernandes  � Data � 02.01.12 |��
�������������������������������������������������������������������������Ĵ��
���Descricao �Valida a tela de classifica��o de produ��o a maior		  ���
�������������������������������������������������������������������������Ĵ��
���Uso       �MATA250, MATA680 e MATA681                                  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function oDlgTdOP(oDlg, lOk, _nQtdOP, _nQuje)
Local lRet
if lOk       
	if _nQtdOP > _nQuje
		oDlg:End()
	else
		//A quantidade classificada � diferente do excedente da produ��o.
		Help(" ",1,"QTDOPJE",,"Quantidade da OP dever� ser maior que a produzida",4,,,,,,.F.)
	endif
endif

return lRet
