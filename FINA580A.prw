#include 'protheus.ch'
#include 'parmtype.ch'

User function FINA580A()
	Local aArray   := {}
	Local cFilPA   := ""
	Local cPrefixo := ""
	Local cNumero  := ""
	Local cParcela := ""
	Local cTipo    := ""
	Local cNaturez := ""
	Local cFornece := ""
	Local cLoja    := ""
	Local cEmissao := ""
	Local cVencto  := ""
	Local cVencRea := ""
	Local nValor   := ""
	//Local aAreaSE2 := SE2->(GetArea())

	Private cBancoAdt	:= ""
	Private cAgenciaAdt := ""
	Private cNumCon		:= ""
	Private cChequeAdt	:= ""
	Private cHistor		:= ""
	Private cBenef		:= ""

	Private lMsErroAuto := .F.

	//Begin Transaction

	IF "PAP" $ SE2->E2_TIPO
		cFilPA   := SE2->E2_FILIAL
		cPrefixo := SE2->E2_PREFIXO
		cNumero  := SE2->E2_NUM
		cParcela := SE2->E2_PARCELA
		cTipo    := "PA"
		cNaturez := SE2->E2_NATUREZ
		cFornece := SE2->E2_FORNECE
		cLoja    := SE2->E2_LOJA
		cEmissao := SE2->E2_EMISSAO
		cVencto  := SE2->E2_VENCTO
		cVencRea := SE2->E2_VENCREA
		nValor   := SE2->E2_VALOR

		aArray := {;
		{ "E2_FILIAL"   , SE2->E2_FILIAL			, NIL },;
		{ "E2_PREFIXO"  , SE2->E2_PREFIXO			, NIL },;
		{ "E2_NUM"      , SE2->E2_NUM				, NIL },;
		{ "E2_TIPO"     , "PAP"						, NIL },; //Pagamento Antecipado Provisório
		{ "E2_PARCELA"  , SE2->E2_PARCELA           , NIL },;
		{ "E2_FORNECE"  , SE2->E2_FORNECE			, NIL },;
		{ "E2_LOJA"		, SE2->E2_LOJA				, NIL } }

		MsExecAuto( { |x,y,z| FINA050(x,y,z)}, aArray,, 5)  // 3 - Inclusao, 4 - Alteração, 5 - Exclusão

		If lMsErroAuto
			MostraErro()
			DisarmTransaction()
			Return
		Else

			//Chama função para Escolher banco
			cBancoAdt	:= Space(3)
			cAgenciaAdt := Space(5)
			cNumCon		:= Space(10)
			cChequeAdt	:= Space(10)
			cHistor		:= Space(20)
			cBenef		:= Space(20)

			U_FTELAPAP(cNumero,1,.F.)

			aArray := {;
			{ "E2_FILIAL"   , cFilPa				, NIL },;
			{ "E2_PREFIXO"  , cPrefixo				, NIL },;
			{ "E2_NUM"      , cNumero				, NIL },;
			{ "E2_PARCELA"  , cParcela				, NIL },;
			{ "E2_TIPO"     , cTipo					, NIL },;
			{ "E2_NATUREZ"  , cNaturez				, NIL },;
			{ "E2_FORNECE"  , cFornece				, NIL },;
			{ "E2_LOJA"		, cLoja					, NIL },;
			{ "E2_EMISSAO"  , dDataBase				, NIL },;
			{ "E2_VENCTO"   , dDataBase				, NIL },;
			{ "E2_VENCREA"  , dDataBase				, NIL },;
			{ "E2_VALOR"    , nValor	         	, NIL },;
			{ "AUTBANCO"    , cBancoAdt             , NIL },;
			{ "AUTAGENCIA"  , cAgenciaAdt           , NIL },;
			{ "AUTCONTA"    , cNumCon	            , NIL }}

			IF MV_PAR05 == 1
				aAdd({"AUTCHEQUE",cChequeAdt,Nil})
			Endif

			MsExecAuto( { |x,y,z| FINA050(x,y,z)}, aArray,, 3)  // 3 - Inclusao, 4 - Alteração, 5 - Exclusão

			If lMsErroAuto
				MostraErro()
				DisarmTransaction()
				Return
			Else
				MsgInfo("PA gerada com sucesso.","Atenção")
				F580GrvFI2()
			EndIf
		Endif
	endif

//	End Transaction
	//RestArea(aAreaSE2)

Return

User Function FTELAPAP(cTitulo,nMoeda,lProvis)

	Local cPictHist
	LOCAL oBcoAdt
	LOCAL oChqAdt
	LOCAL bAction
	LOCAL lFA050PA 	:= ExistBlock("FA050PA")
	LOCAL nMoedAux	:= nMoeda

	//Ao substituir um PR por um PA nao permitir que a moeda do primeiro titulo seja substituida qdo fornecido o banco.
	Default lProvis := .F.

	cTitulo := If(cTitulo == Nil, "", cTitulo)

	dbSelectArea("SX3")
	dbSetOrder(2)
	dbSeek("EF_HIST")
	cPictHist := AllTrim(X3_PICTURE)

	pergunte("FIN050",.F.)

	While .T.
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Mostra Get do Banco de Entrada						 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nOpca := 0
		DEFINE MSDIALOG oDlg FROM 10, 5 TO 26, 60 TITLE OemToAnsi("Título: " + cTitulo) //
		@	.3,1 TO 07.3,26 OF oDlg
		// BANCO
		@	1.0,2 	Say OemToAnsi("Banco") //"Banco :         "

		If cPaisLoc == "BRA"
			@	1.0,8  	MSGET oBcoAdt 			VAR cBancoAdt F3 "SA6" 	Valid CarregaSa6(@cBancoAdt,,,,,,, @nMoedAux ) .And. FaPrNumChq(cBancoAdt,cAgenciaAdt,cNumCon,@oChqAdt,@cChequeAdt)
		Else
			@	1.0,8  	MSGET oBcoAdt 			VAR cBancoAdt F3 "SA6" 	Valid CarregaSa6(@cBancoAdt) .And. FaPrNumChq(cBancoAdt,cAgenciaAdt,cNumCon,@oChqAdt,@cChequeAdt)
		EndIf

		// AGENCIA
		@	2.0,2 	Say OemToAnsi("Agência") //"Agˆncia :       "
		@	2.0,8 	MSGET cAgenciaAdt 								Valid CarregaSa6(@cBancoAdt,@cAgenciaAdt) .And. FaPrNumChq(cBancoAdt,cAgenciaAdt,cNumCon,@oChqAdt,@cChequeAdt)
		// CONTA
		@	3.0,2 	Say OemToAnsi("Conta") //"Conta :         "
		@	3.0,8 	MSGET cNumCon 									Valid If(CarregaSa6(@cBancoAdt,@cAgenciaAdt,@cNumCon,,,.T.),FaPrNumChq(cBancoAdt,cAgenciaAdt,cNumCon,@oChqAdt,@cChequeAdt),oBcoAdt:SetFocus())
		// NUMERO CHEQUE
		@	4.0,2 	Say OemToAnsi("Num Cheque") // "N£m Cheque :   "
		@	4.0,8 	MSGET oChqAdt 			VAR cChequeAdt 			When (	mv_par05 == 1 .And. substr(cBancoAdt,1,2)!="CX" .And. !(cBancoAdt$GEtMV("MV_CARTEIR")) .And. cPaisLoc <> "EQU") ;
		Valid fa050Cheque(cBancoAdt,cAgenciaAdt,cNumCon,cChequeAdt,Iif(cPaisLoc $ "ARG",.F.,.T.))
		// HISTORICO
		@	5.0,2 	Say OemToAnsi("Historico") // "Historico :    "
		@	5.0,8 	MSGET cHistor		Picture cPictHist	SIZE 135, 10 OF oDlg
		// BENEFICIARIO
		@	6.0,2 	Say OemToAnsi("Beneficiario") // "Beneficiario : "
		@	6.0,8 	MSGET cBenef		Picture "@S40"		SIZE 135, 10 OF oDlg

		bAction := {||	nOpca:=1,;
		Iif(!Empty(cBancoAdt).And.;
		CarregaSa6(@cBancoAdt,@cAgenciaAdt,@cNumCon,,,.T.).And.;
		Iif(lFA050PA,;
		ExecBlock("FA050PA",.F.,.F.,{cBancoAdt,cAgenciaAdt,cNumCon,cChequeAdt,cHistor,cBenef}),;
		.T.),;
		oDlg:End(),;
		nOpca:=0)}

		DEFINE SBUTTON FROM 105,180.1 TYPE 1 ACTION ( Eval(bAction) ) ENABLE OF oDlg
		ACTIVATE MSDIALOG oDlg CENTERED
		IF nOpca != 0
			If nMoeda<>Nil .and. cPaisLoc != "BRA"
				nMoeda   := Max(IIf(Type("SA6->A6_MOEDAP")=="U",SA6->A6_MOEDA,If(SA6->A6_MOEDAP>0,SA6->A6_MOEDAP,SA6->A6_MOEDA)),1)
			Endif

			If cPaisLoc == "BRA" .And. !lProvis
				M->E2_MOEDA := nMoedAux
			EndIf

			Exit
		EndIf
	EndDo

Return .T.