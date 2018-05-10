/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLMP_B2B8  บAutor  ณEveraldo Silva Galloบ Data ณ  18/02/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFuncao para ajustar o SB2, SBF, SB8                         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP - MACROPLAST                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

#include "Protheus.ch"
#Include "TopConn.ch"
//#include "Rwmake.ch"

User Function b2b8bf_v2()

aReturn    := {'Zebrado', 1,'Administrao', 2, 2, 1, '',1}
cbTxt      := ''
cDesc1     := 'O objetivo deste relatขrio  exibir detalhadamente todas as diferenas'
cDesc2     := 'de Saldo entre os arquivos SB2 x SB8 x SBF.'
cCabec1    := ''
cCabec2    := ''
cTitulo    := 'RELACAO DE DIFERENCAS SB2xSB8xSBF'
cString    := 'SB1'
cRodaTxt   := ''
cNomePrg   := 'ACTSALDO'
nTipo      := 18
nTamanho   := 'G'
nLastKey   := 0
nCntImpr   := 0
lAbortPrin := .F.
WnRel      := 'ACTSALDO'

cPerg		:= PADR("DIFSLD",LEN(SX1->X1_GRUPO))
_fCriaSx1()

//
// Funcao para criacao das perguntas.
//
//_fCriaSx1()

Pergunte(cPerg,.T.)
_acampos := {}
AADD(_aCampos,{ "CODIGO" ,"C",15,0 } )
AADD(_aCampos,{ "LOC"    ,"C",02,0 } )
AADD(_aCampos,{ "DESCRI" ,"C",30,0 } )
AADD(_aCampos,{ "QTd_SB2" ,"N",15,3 } )
AADD(_aCampos,{ "QTd_SB8" ,"N",15,3 } )
AADD(_aCampos,{ "QTd_SBF" ,"N",15,3 } )

cNomArq := CriaTrab(_aCampos)
dbUseArea( .T.,, cNomArq, "Trb", if(.F. .OR. .F., !.F., NIL), .F. )
IndRegua("TRB",cNomArq,"CODIGO+LOC",,,OemToAnsi("Selecionando Registros..."))

SB2->(DbSetOrder(1))
// B2_FILIAL+B2_COD+B2_LOCAL

SBF->(DbSetOrder(2))
// BF_FILIAL+BF_PRODUTO+BF_LOCAL+BF_LOTECTL+BF_NUMLOTE+BF_PRIOR+BF_LOCALIZ+BF_NUMSERI

SB8->(DbSetOrder(1))
//B8_FILIAL+B8_PRODUTO+B8_LOCAL+B8_LOTECTL+B8_NUMLOTE+DTOS(B8_DTVALID)

dbselectarea("SB2")

DBSEEK(XFILIAL("SB2")+MV_PAR01,.T.)

Do While SB2->b2_COD <= MV_PAR02 .AND. XFILIAL("SB2") == SB2->B2_FILIAL .AND. ! SB2->(Eof())
	
	IF SB2->B2_LOCAL # MV_PAR03 .OR. B2_QATU < 0  // NAO FAZ SALDOS NEGATIVOS..........
		DBSKIP()
		LOOP
	ENDIF
	
	
	DBSELECTAREA("SB1")
	DBSEEK(XFILIAL("SB1")+SB2->B2_COD)
	
	IF SB1->B1_TIPO < MV_PAR05 .OR. SB1->B1_TIPO > MV_PAR06 
		DBSELECTAREA("SB2")
		DBSKIP()
		LOOP
	ENDIF
	
	_lRastro := .f.
	_nsaldo_B8  := 0

	IF SB1->B1_RASTRO $ "SL"
		Dbselectarea("SB8")
		DBSEEK(XFILIAL("SB8")+SB2->B2_COD+SB2->B2_LOCAL,.T.)
		
		DO WHILE SB2->B2_COD + SB2->B2_LOCAL == B8_PRODUTO+B8_LOCAL .AND. !EOF()
			_nsaldo_B8 += B8_SALDO
			DbSkip()
		EndDo
		if sb2->b2_qatu # _nSaldo_B8 .or. mv_par07 = 2
			_lRastro := .t.
		endif
		
	ENDIF
	
	_lLocaliz := .f.     
	_nSaldo_Bf := 0

	IF SB1->B1_LOCALIZ = "S"
		
		DbSelectArea("SBF")
		SBF->(DbSetOrder(2))
		dbseek(xfilial("SBF")+SB2->B2_COD + SB2->B2_LOCAL)
		
		Do while SB2->B2_COD + SB2->B2_LOCAL == BF_PRODUTO+BF_LOCAL .and. !eof()
			_nSaldo_Bf +=  BF_QUANT
			dbskip()
		Enddo

		Dbselectarea("SDA")
	    dbSetOrder(1)
		DBSEEK(XFILIAL("SDA")+SB2->B2_COD + SB2->B2_LOCAL,.T.)
		
		DO WHILE SB2->B2_COD + SB2->B2_LOCAL == DA_PRODUTO+DA_LOCAL .AND. !EOF()
			_nSaldo_Bf += da_saldo
			DbSkip()
		EndDo

		if sb2->b2_qatu # _nSaldo_Bf .or. mv_par07 = 2
			_lLocaliz := .t.
		endif

	ENDIF
	
	if 	_lLocaliz .or. _lRastro
		
		dbselectarea("TRB")
		RECLOCK("TRB",.T.)
		CODIGO  := SB2->B2_COD
		LOC  	:= SB2->B2_LOCAL
		DESCRI  := SB1->B1_DESC
		QTd_SB2  := SB2->B2_QATU
		QTd_SB8  := _nSaldo_B8
		QTd_SBF  := _nSaldo_Bf
		MSUNLOCK()
		
	endif
	
	DBSELECTAREA("SB2")
	DBSKIP()

ENDDO

Private cCadastro := "Cadastro de Divergencias de Estoques"

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta um aRotina proprio                                            ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Private aRotina := { 	{"Alterar"      ,"u__act_est",0,4} }

Private cDelFunc := ".F." // Validacao para a exclusao. Pode-se utilizar ExecBlock

Private cString := "TRB"

dbSelectArea("TRB")
_aCampos	:= 		{ 	{"Codigo"	   			, 	"CODIGO"			, 	'C',15,00, "@!"	},;
						{"local" 	  			, 	"LOC"				, 	'C',02,00, "@!"},;
						{"Descricao do Produto" , 	"Descri"	   		, 	'C',35,00, "@!"},;
						{"Saldo em estoque"		, 	"qtd_sb2"	   		, 	'N',15,02, "@e 99,999,999.999"},;
						{"Saldo em Lotes" 		, 	"qtd_sb8"	   		, 	'N',15,02, "@e 99,999,999.999"},;
						{"Saldo em Enderecos"	, 	"qtd_sbf"			, 	'N',15,02, "@e 99,999,999.999"}}

dbSelectArea(cString)
mBrowse( 6,1,22,75,cString,_aCampos )


dbSelectArea("TRB")
dbCloseArea("TRB")

Return()

                            

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLMP_B2B8  บAutor  ณMicrosiga           บ Data ณ  07/06/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


Static Function _fCriaSx1()

DbSelectArea("SX1")
DbSetOrder(1)

If ! DbSeek(cPerg+"01",.t.)
	Reclock("SX1",.t.)
	SX1->X1_GRUPO   := cPerg
	SX1->X1_ORDEM   := "01"
	SX1->X1_PERGUNT := "Do Produto"
	SX1->X1_VARIAVL := "mv_ch1"
	SX1->X1_TIPO    := "C"
	SX1->X1_TAMANHO := 15
	SX1->X1_DECIMAL := 0
	SX1->X1_PRESEL  := 0
	SX1->X1_GSC     := "G"
	SX1->X1_VALID   := ""
	SX1->X1_VAR01   := "mv_par01"
	SX1->X1_DEF01   := ""
	SX1->X1_F3		 := "SB1"
	MsUnLock()
EndIf

If ! DbSeek(cPerg+"02",.t.)
	Reclock("SX1",.t.)
	SX1->X1_GRUPO   := cPerg
	SX1->X1_ORDEM   := "02"
	SX1->X1_PERGUNT := "Ate Produto"
	SX1->X1_VARIAVL := "mv_ch2"
	SX1->X1_TIPO    := "C"
	SX1->X1_TAMANHO := 15
	SX1->X1_DECIMAL := 0
	SX1->X1_PRESEL  := 0
	SX1->X1_GSC     := "G"
	SX1->X1_VALID   := ""
	SX1->X1_VAR01   := "mv_par02"
	SX1->X1_DEF01   := ""
	SX1->X1_F3		 := "SB1"
	MsUnLock()
EndIf

If ! DbSeek(cPerg+"03",.t.)
	Reclock("SX1",.t.)
	SX1->X1_GRUPO   := cPerg
	SX1->X1_ORDEM   := "03"
	SX1->X1_PERGUNT := "Local"
	SX1->X1_VARIAVL := "mv_ch3"
	SX1->X1_TIPO    := "C"
	SX1->X1_TAMANHO := 2
	SX1->X1_DECIMAL := 0
	SX1->X1_PRESEL  := 0
	SX1->X1_GSC     := "G"
	SX1->X1_VALID   := ""
	SX1->X1_VAR01   := "mv_par03"
	SX1->X1_DEF01   := ""
	MsUnLock()
EndIf

If ! DbSeek(cPerg+"04",.t.)
	Reclock("SX1",.t.)
	SX1->X1_GRUPO   := cPerg
	SX1->X1_ORDEM   := "04"
	SX1->X1_PERGUNT := "Acerta ??"
	SX1->X1_VARIAVL := "mv_ch4"
	SX1->X1_TIPO    := "N"
	SX1->X1_TAMANHO := 1
	SX1->X1_DECIMAL := 0
	SX1->X1_PRESEL  := 0
	SX1->X1_GSC     := "C"
	SX1->X1_VALID   := ""
	SX1->X1_VAR01   := "mv_par04"
	SX1->X1_DEF01   := "Sim"
	SX1->X1_DEF02   := "Nao"
	MsUnLock()
EndIf

If ! DbSeek(cPerg+"05",.t.)
	Reclock("SX1",.t.)
	SX1->X1_GRUPO   := cPerg
	SX1->X1_ORDEM   := "05"
	SX1->X1_PERGUNT := "Tipo de"
	SX1->X1_VARIAVL := "mv_ch5"
	SX1->X1_TIPO    := "C"
	SX1->X1_TAMANHO := 2
	SX1->X1_DECIMAL := 0
	SX1->X1_PRESEL  := 0
	SX1->X1_GSC     := "G"
	SX1->X1_VALID   := ""
	SX1->X1_VAR01   := "mv_par05"
	MsUnLock()
EndIf

If ! DbSeek(cPerg+"06",.t.)
	Reclock("SX1",.t.)
	SX1->X1_GRUPO   := cPerg
	SX1->X1_ORDEM   := "06"
	SX1->X1_PERGUNT := "Tipo ate"
	SX1->X1_VARIAVL := "mv_ch6"
	SX1->X1_TIPO    := "C"
	SX1->X1_TAMANHO := 2
	SX1->X1_DECIMAL := 0
	SX1->X1_PRESEL  := 0
	SX1->X1_GSC     := "G"
	SX1->X1_VALID   := ""
	SX1->X1_VAR01   := "mv_par06"
	MsUnLock()
EndIf

If ! DbSeek(cPerg+"07",.t.)
	Reclock("SX1",.t.)
	SX1->X1_GRUPO   := cPerg
	SX1->X1_ORDEM   := "07"
	SX1->X1_PERGUNT := "So c/ Diferenca ??"
	SX1->X1_VARIAVL := "mv_ch7"
	SX1->X1_TIPO    := "N"
	SX1->X1_TAMANHO := 1
	SX1->X1_DECIMAL := 0
	SX1->X1_PRESEL  := 0
	SX1->X1_GSC     := "C"
	SX1->X1_VALID   := ""
	SX1->X1_VAR01   := "mv_par07"
	SX1->X1_DEF01   := "Sim"
	SX1->X1_DEF02   := "Nao"
	MsUnLock()
EndIf

Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ_check_endบAutor  ณEveraldo Gallo      บ Data ณ  06/07/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function _act_est 

_aTab_B8 := {}

dbselectarea("SB1")
DBSEEK(XFILIAL("SB1")+TRB->CODIGO)

IF SB1->B1_RASTRO $ "SL"
		
	Dbselectarea("SB8")
	DBSEEK(XFILIAL("SB8")+TRB->CODIGO+TRB->LOC,.T.)
		
	DO WHILE TRB->CODIGO+TRB->LOC == B8_PRODUTO+B8_LOCAL .AND. !EOF()
		aadd(_aTab_B8,{B8_DTVALID,B8_LOTECTL,B8_NUMLOTE,B8_SALDO,B8_QTDORI,DTOS(B8_DATA),B8_SALDO,recno()})
		DbSkip()

	EndDo
	aadd(_aTab_B8,{,"TOTAL",,trb->qtd_Sb8,,,})

else

	aadd(_aTab_B8,{,"-----",,,,,})
	
Endif

_aTab_Bf := {}

_naEnder := 0

IF SB1->B1_LOCALIZ = "S"
		
	Dbselectarea("SBF")
	DBSEEK(XFILIAL("SBF")+TRB->CODIGO+TRB->LOC,.T.)
		
	DO WHILE TRB->CODIGO+TRB->LOC == BF_PRODUTO+BF_LOCAL .AND. !EOF()
		aadd(_aTab_Bf,{bf_localiz,BF_LOTECTL,BF_NUMLOTE,BF_QUANT,BF_QUANT,recno()})
		DbSkip()
	EndDo

	aadd(_aTab_Bf,{"TOTAL",,,trb->qtd_Sbf,,,})

	Dbselectarea("SDA")
    dbSetOrder(1)
	DBSEEK(XFILIAL("SDA")+TRB->CODIGO+TRB->LOC,.T.)
		
	DO WHILE TRB->CODIGO+TRB->LOC == DA_PRODUTO+DA_LOCAL .AND. !EOF()
		_naEnder += da_saldo
		DbSkip()
	EndDo

else

	aadd(_aTab_Bf,{"-----",,,})
	
Endif

_nTot_Lots := trb->qtd_Sb8
_nTot_Ends := trb->qtd_Sbf

DEFINE FONT oBold NAME "Arial" SIZE 0, -12 BOLD
DEFINE MSDIALOG oDlg FROM 000,000  TO 450,800 TITLE OemToAnsi("Posicao de Estoque") Of oMainWnd PIXEL

@ 004,002 SAY Alltrim(SB1->B1_COD)+ " - "+SB1->B1_DESC +  "   QT.EM ESTOQUE " + TRANSFORM(TRB->QTD_SB2,"@E 99,999,999.999")  Of oDlg PIXEL SIZE 245,009 FONT oBold
@ 013,004 To 13,397 Label "" of oDlg PIXEL

/// ***** BOX DE LOTES (SUPERIOR) *****

_atit_cab1:= 	{"Dt.Validade","Lote","Sub-lote","Saldo","Qtd.Original","Dt.Cr.Lote","Qtd apos o Acerto","Controle"}
_atam_cab1:= 	{45,45,45,45,45,45,45}
@ 017,002 SAY OemToAnsi("Lotes") of oDlg PIXEL COLOR CLR_HBLUE
oListBox2 := TWBrowse():New( 025,2,397,69,,_atit_cab1,_atam_cab1,oDlg,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
oListBox2:SetArray(_aTab_B8)
oListBox2:bLine := { || _aTab_B8[oListBox2:nAT]}
oListBox2:blDblClick := {|| Alin_qtd(1,oListBox2:nAT,7),oListBox2:refresh() }

/// ***** BOX DE ENDERECOS (INFERIOR) *****

_atit_cab2:= 	{"Endereco","Lote","Sub-Lote","Quantidade","Qtd apos o Acerto","Controle"}
_atam_cab2:= 	{55,55,55,55,55}
@ 117,002 SAY OemToAnsi("Enderecos") of oDlg PIXEL COLOR CLR_HBLUE
oListBox3 := TWBrowse():New( 125,2,397,69,,_atit_cab2,_atam_cab2, oDlg,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
oListBox3:SetArray(_aTab_Bf)
oListBox3:bLine := { || _aTab_Bf[oListBox3:nAT]}
oListBox3:blDblClick := {|| Alin_qtd(2,oListBox3:nAT,5),oListBox3:refresh() }
@ 196,200 SAY "TOTAL A ENDERECAR "+TRANSFORM( _naEnder,"@E 99,999,999.999") of oDlg PIXEL FONT oBold COLOR CLR_HRED

@ 008,250 BUTTON OemToAnsi("Novo Endereco") SIZE 045,015  FONT oDlg:oFont ACTION {|| _Cr_NewEnd(),oDlg:refresh() }  OF oDlg PIXEL
@ 008,300 BUTTON OemToAnsi("Ajustar") SIZE 045,015  FONT oDlg:oFont ACTION {|| AJUSTA_ARQ(),oDlg:End() }  OF oDlg PIXEL
@ 008,350 BUTTON OemToAnsi("Sair")    SIZE 045,015  FONT oDlg:oFont ACTION (oDlg:End())  OF oDlg PIXEL

ACTIVATE MSDIALOG oDlg CENTERED
DBSELECTAREA("SB1")

Return(.T.)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTEL_B2B8BFบAutor  ณMicrosiga           บ Data ณ  07/07/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


Static function Alin_qtd(_ntab,_nlin,_ncol)

if _ntab == 1
    if _aTab_B8[_nlin,2] = "TOTAL" .OR. _aTab_B8[_nlin,2] = "-----"
        RETURN()
     ENDIF
	_nNewQtd := _aTab_B8[_nlin,_ncol]
 else
    if _aTab_BF[_nlin,1] = "TOTAL" .OR. _aTab_BF[_nlin,1] = "-----"
        RETURN()
     ENDIF
	_nNewQtd := _aTab_Bf[_nlin,_ncol]
endif

DEFINE MSDIALOG oDlg1 FROM 000,000  TO 150,250 TITLE OemToAnsi("Informe a nova Quantidade") Of oMainWnd PIXEL
@ 1,1 Say "Nova Quantidade"   of odlg1
@ 2,1 get  _nNewQtd PICTURE "@E 99,999,999.999" SIZE 50,4 of odlg1
@ 5,15 BUTTON "Ok" SIZE 50,15 ACTION (oDlg1:End())
ACTIVATE DIALOG oDlg1 CENTER

if _ntab == 1
    _aTab_B8[_nlin,_ncol]:= _nNewQtd 
	_nTot_Lots := 0
    FOR _X:=1 TO LEN(_aTab_B8)-1
	    _nTot_Lots += _aTab_B8[_X,_ncol]
	NEXT _X
	 _aTab_B8[LEN(_aTab_B8),4]:= _nTot_Lots
 else
	_aTab_Bf[_nlin,_ncol]:= _nNewQtd 
	_nTot_Ends := 0
    FOR _X:=1 TO LEN(_aTab_BF)-1
	    _nTot_Ends += _aTab_Bf[_X,_ncol]
	NEXT _X
	 _aTab_BF[LEN(_aTab_BF),4]:= _nTot_Ends
endif

odlg:refresh()

return




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAJUSTA_ARQบAutor  ณMicrosiga           บ Data ณ  07/07/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function AJUSTA_ARQ

_llimpa :=.f. 

IF SB1->B1_RASTRO $ "SL"
	if 	_aTab_B8[len(_aTab_B8),4] # TRB->QTD_SB2 
        msgstop("Saldo Dos lotes nao Batem !!!!! Verifique")
		_llimpa :=.f. 
    else    
		_llimpa :=.t. 
		FOR A:=1 TO LEN(_aTab_B8)-1
			IF _aTab_B8[a,7] # _aTab_B8[a,4]
				DBSELECTAREA("SD5")
				RECLOCK("SD5",.T.)
				replace D5_FILIAL   WITH  XFILIAL('SD5')
				replace D5_PRODUTO  WITH  TRB->CODIGO
				replace D5_LOCAL    WITH  TRB->LOC
				replace D5_DATA     WITH  DDATABASE
				replace D5_DTVALID  WITH  _aTab_B8[a,1]
				replace D5_LOTECTL  WITH  _aTab_B8[a,2]
				replace D5_NUMLOTE  WITH  _aTab_B8[a,3]
				replace D5_DOC      WITH  "AC"+SUBSTR(DTOS(DDATABASE),5,4)
				if _aTab_B8[a,7] < _aTab_B8[a,4]
					replace D5_QUANT    WITH  _aTab_B8[a,4]-_aTab_B8[a,7]
					replace D5_ORIGLAN  WITH '999'
				else
					replace D5_QUANT    WITH  _aTab_B8[a,7]-_aTab_B8[a,4]
					replace D5_ORIGLAN  WITH '499'
				endif
				SD5->(MSUNLOCK())
								
				DBSELECTAREA("SB8")
				GOTO _aTab_B8[a,8]
				RECLOCK("SB8",.F.)
				B8_SALDO := _aTab_B8[a,7]
				SB8->(MsUnlock())
			ENDIF

		NEXT A
    endif
Endif


IF SB1->B1_LOCALIZ = "S"        

	if 	_aTab_Bf[len(_aTab_Bf),4] # TRB->QTD_SB2 
        msgstop("Saldo Dos Enderecos nao Batem !!!!! Verifique")
		_llimpa :=.f. 
    else    
		_llimpa :=.t. 
		FOR A:=1 TO LEN(_aTab_Bf)-1
			IF _aTab_Bf[a,5] # _aTab_Bf[a,4]
				_cProxNum	:= SDB->(ProxNum())
				DBSELECTAREA("SDB")
				RecLock("SDB",.t.)
				DB_FILIAL 	:=	xFilial("SDB")
				DB_ITEM		:= "0001"
				DB_PRODUTO	:= TRB->CODIGO
				DB_LOCAL	:= TRB->LOC
				DB_LOCALIZ	:= _aTab_Bf[a,1]
				DB_DOC		:= "AC"+SUBSTR(DTOS(DDATABASE),5,4)
				DB_ORIGEM	:= "SD3"
				DB_DATA		:= dDataBase
				DB_LOTECTL	:= _aTab_Bf[a,2]
				DB_NUMLOTE	:= _aTab_Bf[a,3]
				DB_NUMSEQ	:= _cProxNum
				DB_TIPO		:= "D"
				DB_ATIVID	:= "ZZZ"
                DB_ANOMAL   := "N"
				if _aTab_Bf[a,5] < _aTab_Bf[a,4]
					DB_TM		:= "999"
					DB_SERVIC	:= "999"
					DB_QUANT	:= _aTab_Bf[a,4] - _aTab_Bf[a,5]
				else
					DB_TM		:= "499"
					DB_SERVIC	:= "499"
					DB_QUANT	:= _aTab_Bf[a,5] - _aTab_Bf[a,4]
				endif
				SDB->(MsUnLock())
                
				if _aTab_BF[a,6] # 0				
					DBSELECTAREA("SBF")
					GOTO _aTab_BF[a,6]
					RecLock("SBF",.f.)
					SBF->BF_QUANT := _aTab_Bf[a,5]
					SBF->(MsUnLock())
				else
					RecLock("SBF",.t.)
					SBF->BF_FILIAL  := xFilial("SBF")
					SBF->BF_PRODUTO := TRB->CODIGO
					SBF->BF_LOCAL	 := TRB->LOC
					SBF->BF_LOTECTL	 := _aTab_Bf[a,2]
					SBF->BF_NUMLOTE	 := "       "
					SBF->BF_LOCALIZ	 := _aTab_Bf[a,1]
			        SBF->BF_PRIOR	 := "   "
					SBF->BF_QUANT    := _aTab_Bf[a,5]
					SBF->(MsUnLock())
				endif        
		
            endif
	        
		next a

	endif

Endif


if _llimpa 
   dbselectarea("TRB")        
   RecLock("TRB",.f.)
   DELETE
   SBF->(MsUnLock())
ENDIF



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ_Cr_NewEndบAutor  ณMicrosiga           บ Data ณ  08/07/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


Static Function _Cr_NewEnd


DEFINE MSDIALOG oDlg1 FROM 000,000  TO 250,350 TITLE OemToAnsi("Informe a nova Quantidade") Of oMainWnd PIXEL

_lcria :=.f.
_cNewLocal := space(2)
_cNewLote  := space(10)
_cNewEnder := space(15)

//@ 1,1 Say "Local"   		of odlg1
//@ 2,1 get  _cNewLocal PICTURE "@!" SIZE 30,4 of odlg1 

@ 1,1 Say "Novo Endereco"  	of odlg1
@ 2,1 get  _cNewEnder PICTURE "@!" SIZE 70,4 of odlg1  

@ 4,1 Say "Lote"     		of odlg1                                                      
@ 5,1 get  _cNewLote  PICTURE "@!"  SIZE 70,4 of odlg1 

@ 8 ,32 BUTTON "Cancela" SIZE 30,15 ACTION {|| oDlg1:End()}
@ 10,32 BUTTON "Ok"      SIZE 30,15 ACTION {|| _cria_loc() , oDlg1:End()}

ACTIVATE DIALOG oDlg1 CENTER

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ_cria_loc บAutor  ณMicrosiga           บ Data ณ  16/07/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function _cria_loc

dbselectarea("SBE")
dbsetorder(1)
dbseek(xfilial("SBE")+mv_par03+_cNewEnder)

If eof()
   
   msgstop("Locallizacao nao existe no armazem "+ mv_par03 +" !!!   Verifoque !!!")

else

	_npos := Ascan(_aTab_B8, {|x| Trim(x[2]) ==  Trim(_cNewLote)	}) 

   if _npos == 0                                              
   
	   msgstop("Lote nao exite para este produto !!!   Verifoque !!!") 
   
   else

	   _aTab_Bf[len(_aTab_Bf),1] := _cNewEnder
	   _aTab_Bf[len(_aTab_Bf),2] := _cNewLote
	   _aTab_Bf[len(_aTab_Bf),4] := 0
	   _aTab_Bf[len(_aTab_Bf),5] := 0
	   _aTab_Bf[len(_aTab_Bf),6] := 0
	   _nTot_Ends :=0             

	   FOR _X:=1 TO LEN(_aTab_BF)
	      _nTot_Ends += _aTab_Bf[_X,5]
	   NEXT _X

	   aadd(_aTab_Bf,{"TOTAL",,,_nTot_Ends,,,})
   endif   
endif