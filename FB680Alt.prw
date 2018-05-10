#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³A680Altera³ Autor ³ Rodrigo de A Sartorio  ³ Data ³ 05/06/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Programa de apontamento de horas apos encerramento          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Void A680Altera(cExp1,nExp1,nExp2)                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ cExp1 = Alias do Arquivo                                    ³±±
±±³          ³ nExp1 = Numero do registro                                  ³±±
±±³          ³ cExp1 = Opcao escolhida                                     ³±±
±±³          ³ cExp4 = Se e via coletor de dados                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ MATA680                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
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
			Aviso("Atenção","Esta OP é movimentada somente através do módulo Chão de Fábrica.",{"OK"})
		EndIf
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Impede Inclus”es com Data Inferior ou Igual a do Fechamento  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lContinua .And. dDataBase <= dDataFec
		Help (' ', 1, 'FECHTO')
		lContinua := .F.
	EndIf
	
	If lContinua
		nOpcA := AxAltera(cAlias,nReg,4,,aCpos,,,)	// "A012TudoOk(nOpc)"
	EndIf
Return