#INCLUDE "PROTHEUS.CH"

/*
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Fun��o    �A680Altera� Autor � Rodrigo de A Sartorio  � Data � 05/06/03 ���
��������������������������������������������������������������������������Ĵ��
���Descri��o � Programa de apontamento de horas apos encerramento          ���
��������������������������������������������������������������������������Ĵ��
���Sintaxe   � Void A680Altera(cExp1,nExp1,nExp2)                          ���
��������������������������������������������������������������������������Ĵ��
���Parametros� cExp1 = Alias do Arquivo                                    ���
���          � nExp1 = Numero do registro                                  ���
���          � cExp1 = Opcao escolhida                                     ���
���          � cExp4 = Se e via coletor de dados                           ���
��������������������������������������������������������������������������Ĵ��
���Uso       � MATA680                                                     ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
������������������������������������������������������������������������������
*/
User Function FB680Alt(cAlias,nReg,nOpc,aCpos,lColetor)
	Local nOpca
	Local lEncerraOP	:= .F.
	Local lIntSFC		:= IntegraSFC() .And. !IsInCallStack("AUTO681")
	Local lContinua		:= .T.
	Local lIsLockSH8	:= .F.
	Local aButtons		:= {}
	Local aUsButtons	:= {}
	Local aCpos			:= {"H6_XTURNO","H6_RECURSO"}
	Local a680CPHR		:= nil
	Local nI			:= 0
	Local nX			:= 0
	
	PRIVATE lModZero:= .T.
	
	If lColetor == NIL
		lColetor := .F.
	EndIf
	
	PRIVATE nRegD3
	
	//--Abre semaforo para SH8
	If (lIsLockSH8 := IsLockSH8())
		lContinua := .F.
	EndIf
	
	//-- Impede alteracao de OP integrada ao Chao de Fabrica
	If lContinua .And. lIntSFC
		CYQ->(dbSetOrder(1))
		lContinua:= !CYQ->(dbSeek(xFilial("CYQ")+SH6->H6_OP))
		If !lContinua
			Aviso("Aten��o","Esta OP � movimentada somente atrav�s do m�dulo Ch�o de F�brica.",{"OK"})
		EndIf
	EndIf
	
	//��������������������������������������������������������������Ŀ
	//� Impede Inclus�es com Data Inferior ou Igual a do Fechamento  �
	//����������������������������������������������������������������
	If lContinua .And. dDataBase <= dDataFec
		Help (' ', 1, 'FECHTO')
		lContinua := .F.
	EndIf
	
	If lContinua
		nOpcA := AxAltera(cAlias,nReg,4,,aCpos,,,)	// "A012TudoOk(nOpc)"
	EndIf
Return