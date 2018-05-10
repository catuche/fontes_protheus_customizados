#include "rwmake.ch"  
/*/
��������������������������������������������������������������������������� ���
������������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ���
���Programa  � ATUMOEDAS� Autor � Vitor Fattori      � Data �  13/04/2004  ���
��� MELHORADO E CORRIGIDO POR DANIEL LIRA TOTVS NE   � Data �  04/07/2016  ���
�������������������������������������������������������������������������͹���
���Descri��o � Programa para Atualizacao de qualquer  moeda                ���
���Descri��o � apos as cota��es do dia (normalmente apos as 17h30).        ���
�������������������������������������������������������������������������� ���
���Uso       		� Cadastro do JOB no ini. do Appserv:                     ���
���          		�   [OnStart]                                             ���
���             �   JOBS=ATUMOEDAS                                         ���
���             �   Refreshrate=43200 //12 em 12 horas                     ���
���             �   [ATUMOEDAS]                                            ���
���             �		MAIN=U_ATUMOEDAS()                                    ���
���             �		ENVIRONMENT= <banco>                                  ���
�������������������������������������������������������������������������� ���
�����������������������������������������������������������������������������
������������������������������������������������������������������������������
/*/

User Function ATUMOEDAS() 
Local cFile, cTexto, nLinhas, j, lAuto,jj := .F. 

If Select("SX2")==0                    // Testa se est� sendo rodado do menu
	RPCSetType( 3 )						//N�o consome licensa de uso
	RPCSETENV("01","01",,,,GetEnvServer(),{"SM2"})
	Qout("JOB - Atualizacao Cotacao Moedas...")
	lAuto := .T.
EndIf

For nPass := 6 to 0 step -1 
// Refaz dos ultimos 6 dias para o caso de algum dia a conexao ter falhado
	
	dDataRef := dDataBase - nPass

	If Dow(dDataRef) == 1    // Se for domingo
		cFile := DTOS(dDataRef - 2)+".csv"
	ElseIf Dow(dDataBase) == 7            // Se for s�bado
		cFile := DTOS(dDataRef - 1)+".csv"
	Else                                   // Se for dia normal
		cFile := DTOS(dDataRef)+".csv"
	EndIf
	
	cTexto  :=  HTTPGET('http://www4.bcb.gov.br/download/fechamento/'+cFile)
	nLinhas := MLCount(cTexto, 81)
	For j := 1 to nLinhas
	    jj:=.t.
		cLinha := Memoline(cTexto,81,j)
		cData  := Substr(cLinha,1,10)
		cCompra := StrTran(Substr(cLinha,22,14),",",".")
		cVenda  := StrTran(Substr(cLinha,18+15,14),",",".")
		If Subst(cLinha,12,3)=="220" // Dolar Americano
			DbSelectArea("SM2")
			DbSetOrder(1)
			
			dData := CTOD(cData)-1
			For m := 1 To 30 // projeta para 15 dias.
				dData++
				If DbSeek(DTOS(dData))
					Reclock("SM2",.F.)
				Else
					Reclock("SM2",.T.)
					Replace M2_DATA   With dData
				EndIf
				Replace M2_MOEDA2 With Val(cVenda)
				Replace M2_INFORM With "S"
				MsUnlock("SM2")
			Next
		EndIf

		If Subst(cLinha,12,3)=="978" // EURO
			DbSelectArea("SM2")
			DbSetOrder(1)
			
			dData := CTOD(cData)-1
			For m := 1 To 30 // projeta para 15 dias.
				dData++
				If DbSeek(DTOS(dData))
					Reclock("SM2",.F.)
				Else
					Reclock("SM2",.T.)
					Replace M2_DATA   With dData
				EndIf
				Replace M2_MOEDA3 With Val(cVenda)
				Replace M2_INFORM With "S"
				MsUnlock("SM2")
			Next
		EndIf
		
		If Subst(cLinha,12,3)=="470" // IENE
			DbSelectArea("SM2")
			DbSetOrder(1)
			
			dData := CTOD(cData)-1
			For m := 1 To 30 // projeta para 15 dias.
				dData++
				If DbSeek(DTOS(dData))
					Reclock("SM2",.F.)
				Else
					Reclock("SM2",.T.)
					Replace M2_DATA   With dData
				EndIf
				Replace M2_MOEDA4 With Val(cVenda)
				Replace M2_INFORM With "S"
				MsUnlock("SM2")
			Next
		EndIf
	Next
next
   
if jj
//  	Messagebox("Atualizacao efetuada com sucesso","OK", 0)
  	MSGBOX("Atualizacao efetuada com sucesso", ,"INFO")
else 
  	Alert("  Falha no processamento, verifique conexao com internet ou tente mais tarde !") 	
EndIf
  	
If lAuto
	RpcClearEnv()
	Qout("FIM - JOB - Atualizacao Cotacao Moedas.")
EndIf

Return

