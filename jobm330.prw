#INCLUDE "TBICONN.CH" 
#INCLUDE "FILEIO.CH"
#INCLUDE "PROTHEUS.CH"

User Function jobm330

Local lCPParte := .F. //-- Define que não será processado o custo em partes
Local lBat := .T. //-- Define que a rotina será executada em Batch
Local aListaFil := {} //-- Carrega Lista com as Filiais a serem processadas
Local cCodFil := '' //-- Código da Filial a ser processada 
Local cNomFil := '' //-- Nome da Filial a ser processada
Local cCGC := '' //-- CGC da filial a ser processada
Local aParAuto := {} //-- Carrega a lista com os 21 parâmetros

// Seta job para nao consumir licensas
RpcSetType(3)
// Seta job para empresa filial desejadas
RpcSetEnv("01","020102",,,"EST",,{"AF9","SB1","SB2","SB3","SB8","SB9","SBD","SBF","SBJ","SBK","SC2","SC5","SC6","SD1","SD2","SD3","SD4","SD5","SD8","SDB","SDC","SF1","SF2","SF4","SF5","SG1","SI1","SI2","SI3","SI5","SI6","SI7","SM2","ZAX","SAH","SM0","STL"})

//PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01" MÓDULO "EST" TABLES "AF9","SB1","SB2","SB3","SB8","SB9","SBD","SBF","SBJ","SBK","SC2","SC5","SC6","SD1","SD2","SD3","SD4","SD5","SD8","SDB","SDC","SF1","SF2","SF4","SF5","SG1","SI1","SI2","SI3","SI5","SI6","SI7","SM2","ZAX","SAH","SM0","STL"

Conout("Início da execução do JOBM330")
//-- Adiciona filial a ser processada

_dUlMes := GetMV("MV_ULMES")
_dData  := LastDay(_dUlMes+1)

If LockByName("MATA33002",.F.,.F. )
		cUsuario := "totvs"
		aadd(aParAuto,_dData)		// 1
		aadd(aParAuto,2)			// 2
		aadd(aParAuto,2)			// 3
		aadd(aParAuto,1)			// 4
		aadd(aParAuto,0)			// 5
		aadd(aParAuto,2)			// 6
		aadd(aParAuto," ")			// 7
		aadd(aParAuto,"ZZ")			// 8
		aadd(aParAuto,2)			// 9
		aadd(aParAuto,3)			// 10
		aadd(aParAuto,2)			// 11
		aadd(aParAuto,3)			// 12
		aadd(aParAuto,2)			// 13
		aadd(aParAuto,3)			// 14
		aadd(aParAuto,1)			// 15
		aadd(aParAuto,1)			// 16
		aadd(aParAuto,1)			// 17
		aadd(aParAuto,1)			// 18
		aadd(aParAuto,2)			// 19
		aadd(aParAuto,2)	//1-Todas as filiais; 2-Filial Corrente; 3-Seleciona Filial
		aadd(aParAuto,2)
/*
MV_PAR01 = Data Limite Final
MV_PAR02 = Mostra lanctos. Contábeis
MV_PAR03 = Aglutina Lanctos Contábeis
MV_PAR04 = Atualizar Arq. de Movimentos
MV_PAR05 = % de aumento da MOD
MV_PAR06 = Centro de Custo
MV_PAR07 = Conta Contábil a inibir de
MV_PAR08 = Conta Contábil a inibir até
MV_PAR09 = Apagar estornos
MV_PAR010 = Gerar Lancto. Contábil
MV_PAR011 = Gerar estrutura pela Moviment
MV_PAR012 = Contabilização On-Line Por
MV_PAR013 = Calcula mão-de-Obra
MV_PAR014 = Método de apropriação
MV_PAR015 = Recalcula Nível de Estrut
MV_PAR016 = Mostra sequência de Cálculo
MV_PAR017 = Seq Processamento FIFO
MV_PAR018 = Mov Internos Valorizados
MV_PAR019 = Recálculo Custo transportes
MV_PAR020 = Cálculo de custos por
MV_PAR021 = Calcular Custo em Partes
*/

		MATA330(lBat,aListaFil,lCPParte, aParAuto)
		ConOut("Término da execução do JOBM330")
		UnLockByName("MATA33002",.F.,.F. )
Endif

Return