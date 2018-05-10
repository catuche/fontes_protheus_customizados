#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³M261BCHOI ºAutor  ³Microsiga           º Data ³  02/17/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function M261BCHOI()
Local _aRet := {}
AAdd(_aRet,{"VERNOTA" ,{ || _fTransTr() },"Aglutina SubLotes"})

Return(_aRet)
*---------------------------------------------------------------------------------------------------
Static Function _fTransTr()
*---------------------------------------------------------------------------------------------------
Local _cArea   	:= GetArea()
Local lInverte := .F.
Local oDlg1                                     
Local _nOpca := 2
Local _lContinua := .f.
Local aSize     := {}
Local aInfo     := {}  
Local aObjects  := {}
Local aPosObj       := {} 
Local _cLoteDes := CriaVar("B8_LOTECTL",.F.)
Private cMarca := GetMark()
Private _cProduto := CriaVar("B1_COD",.F.)
Private _cLocal	  := CriaVar("B1_LOCPAD",.F.)

aSize	:= MsAdvSize(, .F., 400 )  
AAdd( aObjects, { 100, 100, .T., .T. } )
aInfo   := { aSize[1], aSize[2], aSize[3], aSize[4], 1, 1 }       
aPosObj	:= MsObjSize( aInfo, aObjects )

DEFINE MSDIALOG _oDlg TITLE "Informar Produto" FROM C(178),C(263) TO C(351),C(600) PIXEL

	// Cria Componentes Padroes do Sistema
	@ C(005),C(069) MsGet oProduto Var _cProduto F3 "SB1" Valid (Vazio(_cProduto) .or. ExistCpo("SB1", _cProduto)) Size C(060),C(009) COLOR CLR_BLACK PIXEL OF _oDlg
	@ C(006),C(011) Say "Produto"  Size C(050),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
	@ C(025),C(069) MsGet oLocal Var _cLocal F3 "NNR" Valid (Vazio(_cLocal) .or. ExistCpo("NNR", _cLocal)) Size C(030),C(009) COLOR CLR_BLACK PIXEL OF _oDlg
	@ C(026),C(012) Say "Almoxarifado" Size C(051),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
	@ C(060),C(045) BUTTON "Confirma"   SIZE 30,12 PIXEL OF _oDlg ACTION (_lContinua := .t.,_oDlg:End())
	@ C(060),C(099) BUTTON "Cancela" 	SIZE 30,12 PIXEL OF _oDlg ACTION _oDlg:End()

ACTIVATE MSDIALOG _oDlg CENTERED 

If !_lContinua .or. Empty(_cProduto) .or. Empty(_cLocal)
	Return
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define os campos do arquivo de trabalho com as disciplinas do professor  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aCampoTRB := {	{ "TRB_OK"    	, "C", 2,0},;
				{ "TRB_COD"		, "C", TamSX3("B2_COD")[1],0},;
				{ "TRB_DESC"	, "C", TamSX3("B1_DESC")[1],0},;
				{ "TRB_LOCAL"	, "C", TamSX3("B2_LOCAL")[1],0},;
				{ "TRB_LOTE"	, "C", TamSX3("B8_LOTECTL")[1],0},;
				{ "TRB_SBLOTE"	, "C", TamSX3("B8_NUMLOTE")[1],0},;
				{ "TRB_VALID"	, "D", TamSX3("B8_DTVALID")[1],0},;
				{ "TRB_QTDE"	, "N", TamSX3("B8_SALDO")[1],TamSX3("B8_SALDO")[2]},;
				{ "TRB_QTDE2"	, "N", TamSX3("B8_SALDO2")[1],TamSX3("B8_SALDO2")[2]}}
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria o Arquivo de Trabalho que tera as Outras Grades Curriculares.       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
_cArqTRB := CriaTrab(aCampoTRB,.T.)
dbUseArea(.T.,,_cArqTRB,"TRB",.F.)

_cQuery := ""
_cArqTMP := CriaTrab(nil,.f.)

_cQuery := "SELECT B8_PRODUTO CODIGO, B1_DESC DESCR, B8_LOCAL LOC, B8_NUMLOTE NUMLOTE, B8_LOTECTL LOTE, B8_DTVALID VALIDADE, SUM(B8_SALDO) SALDO, SUM(B8_SALDO2) SALDO2 "
_cQuery += "FROM "+RetSqlName("SB8")+" SB8, " +RetSqlName("SB1")+" SB1 "
_cQuery += "WHERE B8_FILIAL = '"+xFilial("SB8")+"' "
_cQuery += "AND B8_PRODUTO = '"+_cProduto+"' "
_cQuery += "AND B8_LOCAL = '"+_cLocal+"' "
_cQuery += "AND B8_SALDO > 0 "
_cQuery += "AND SB8.D_E_L_E_T_ = ' ' "
_cQuery += "AND B8_PRODUTO = B1_COD "
_cQuery += "AND SB1.D_E_L_E_T_ = ' ' "
_cQuery += "AND B1_RASTRO = 'S' "
_cQuery += "GROUP BY B8_PRODUTO, B1_DESC, B8_LOCAL, B8_NUMLOTE, B8_LOTECTL, B8_DTVALID "
_cQuery += "ORDER BY 1"
dbUseArea(.T.,"TOPCONN",TCGenQry(,,_cQuery),_cArqTMP,.t.,.t.)
TcSetField(_cArqTMP,"VALIDADE","D")

(_cArqTMP)->( DbGoTop() )
While (_cArqTMP)->( !Eof() )
	RecLock("TRB",.T.)
	TRB_OK	 := "  "
	TRB_COD	 := (_cArqTMP)->CODIGO
	TRB_DESC  := (_cArqTMP)->DESCR
	TRB_LOCAL := (_cArqTMP)->LOC
	TRB_LOTE  := (_cArqTMP)->LOTE
	TRB_SBLOTE  := (_cArqTMP)->NUMLOTE
	TRB_VALID := (_cArqTMP)->VALIDADE
	TRB_QTDE  := (_cArqTMP)->SALDO
	TRB_QTDE2  := (_cArqTMP)->SALDO2
	TRB->( MsUnlock() )
	(_cArqTMP)->( dbSkip() )
Enddo

//Apagando a query pois meu TRB já está carregado
(_cArqTMP)->( dbCloseArea() )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define as colunas que serão exibidas na MarkBrowse                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

aCpoBrw :=  {{"TRB_OK"		, , " "," "},;
			{ "TRB_COD" 	, , "Produto" 	, PesqPict("SB2", "B2_COD"		)},;
			{ "TRB_DESC" 	, , "Descrição" , PesqPict("SB1", "B1_DESC"		)},;
			{ "TRB_LOCAL" 	, , "Local" 	, PesqPict("SB2", "B2_LOCAL"	)},;
			{ "TRB_SBLOTE"	, , "SubLote"  	, PesqPict("SB8", "B8_NUMLOTE"	)},;
			{ "TRB_LOTE"	, , "Lote"   	, PesqPict("SB8", "B8_LOTECTL"	)},;
			{ "TRB_VALID" 	, , "Validade" 	, PesqPict("SB8", "B8_DTVALID"	)},;
			{ "TRB_QTDE" 	, , "Qtde 1o UM", PesqPict("SB8", "B8_SALDO"	)},;
			{ "TRB_QTDE2" 	, , "Qtde 2o UM", PesqPict("SB8", "B8_SALDO2"	)} }
			
//Posicionando no início do arquivo
TRB->( dbGoTop() )

DEFINE MSDIALOG oDlg1 TITLE "Posição SubLote" From 000,000 To 600,aSize[5]-300 OF oMainWnd PIXEL

oMark := MsSelect():New("TRB","TRB_OK",,aCpoBrw,@lInverte,@cMarca,{50,oDlg1:nLeft,oDlg1:nBottom,oDlg1:nRight},,)
oMark:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT // Somente Interface MDI
oMark:oBrowse:bAllMark := { || _f261Inverte(cMarca) }
oMark:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT

bOk1 := {|| If(_fVldBtn(cMarca), lVldAD := .t., lVldAD := .f. ) }
bOk2 := {|| _nOpca := 1,oDlg1:End()}
bOk3 := {|| MsgInfo("Nenhum produto foi selecionado!") }

ACTIVATE MSDIALOG oDlg1 ON INIT (EnchoiceBar(oDlg1,	{|| ( Eval(bOk1), If(lVldAd,Eval(bOk2),Eval(bOk3)) ) },{|| _nOpca := 2,oDlg1:End()},,)) CENTER

IF _nOpca == 1 // confirmou com itens selecionados    	
	TRB->(dbGoTop())
	While TRB->( !Eof() )
		IF TRB_OK <> cMarca
			TRB->( dbSkip() )
			Loop
		ENDIF
		_aHeader := aClone(aHeader)	
		// Se a primeira linha esta em branco remove a mesma do acols
		If Empty(aCols[1,Ascan(aHeader,{|x| Alltrim(x[2]) == "D3_COD"})])
			ADEL(aCols,1)
			ASIZE(aCols,Len(aCols)-1)
		EndIf
		
		// inicia produto no armazem destino, caso nao exista
		SB2->(dbSetOrder(1))
		If !SB2->(dbSeek(xFilial("SB2")+TRB->TRB_COD+_cLocal))
			CriaSb2(TRB->TRB_COD,_cLocal)
		EndIf

		// Adiciona item no acols
		AADD(aCols,Array(Len(aHeader)+1))
		If Len(aCols) == 1
			_cLoteDes := PADR("T" + Alltrim(TRB->TRB_LOTE), TAMSX3("B8_LOTECTL")[1])
		Endif
		// Preenche conteudo do acols
		For nx:=1 to Len(aHeader)
			cCampo:=Alltrim(aHeader[nx,2])
			If IsHeadRec(cCampo)
				aCols[Len(aCols)][nx] := 0
			ElseIf IsHeadAlias(cCampo)
				aCols[Len(aCols)][nx] := "SD3"
			ElseIf cCampo == "_cDestSub"
				aCols[Len(aCols)][nx] := "000000"
			Else
				aCols[Len(aCols)][nx] := CriaVar(cCampo,.F.)
			Endif
		Next nx
		aCOLS[Len(aCols)][Len(aHeader)+1] := .F.
		// Preenche campos especificos
        SB1->(dbSetOrder(1))
		SB1->(dbSeek(xFilial("SB1")+TRB->TRB_COD))

		GDFieldPut("D3_SEGUM",SB1->B1_SEGUM,Len(aCols))

		_nCodOri := Ascan(_aHeader,{|x| Alltrim(x[2]) == "D3_COD"})
		_aHeader[_nCodOri,2] := ""
		_nDesOri := Ascan(_aHeader,{|x| Alltrim(x[2]) == "D3_DESCRI"})
		_aHeader[_nDesOri,2] := ""
		_nUMOri  := Ascan(_aHeader,{|x| Alltrim(x[2]) == "D3_UM"})
		_aHeader[_nUMOri,2] := ""
		_nLocOri := Ascan(_aHeader,{|x| Alltrim(x[2]) == "D3_LOCAL"})		
		_aHeader[_nLocOri,2] := ""
		_nLotOri := Ascan(_aHeader,{|x| Alltrim(x[2]) == "D3_LOTECTL"})		
		_aHeader[_nLotOri,2] := ""
		_nVldOri := Ascan(_aHeader,{|x| Alltrim(x[2]) == "D3_DTVALID"})		
		_aHeader[_nVldOri,2] := ""
		
		aCols[Len(aCols),_nCodOri] := TRB->TRB_COD
		aCols[Len(aCols),_nDesOri] := SB1->B1_DESC
		aCols[Len(aCols),_nUMOri]  := SB1->B1_UM          
		aCols[Len(aCols),_nLocOri] := _cLocal	
		aCols[Len(aCols),_nLotOri] := TRB->TRB_LOTE
		aCols[Len(aCols),_nVldOri] := TRB->TRB_VALID
		GDFieldPut("D3_NUMLOTE",TRB->TRB_SBLOTE,Len(aCols))
		GDFieldPut("D3_QUANT",TRB->TRB_QTDE,Len(aCols))
		GDFieldPut("D3_QTSEGUM",TRB->TRB_QTDE2,Len(aCols))

		_nCodDes := Ascan(_aHeader,{|x| Alltrim(x[2]) == "D3_COD"})
		_nDesDes := Ascan(_aHeader,{|x| Alltrim(x[2]) == "D3_DESCRI"})
		_nUMDes  := Ascan(_aHeader,{|x| Alltrim(x[2]) == "D3_UM"})
		_nLocDes := Ascan(_aHeader,{|x| Alltrim(x[2]) == "D3_LOCAL"})		
		_nLotDes := Ascan(_aHeader,{|x| Alltrim(x[2]) == "D3_LOTECTL"})		
		_nVldOri := Ascan(_aHeader,{|x| Alltrim(x[2]) == "D3_DTVALID"})

		aCols[Len(aCols),_nCodDes] := TRB->TRB_COD
		aCols[Len(aCols),_nDesDes] := SB1->B1_DESC
		aCols[Len(aCols),_nUMDes]  := SB1->B1_UM          
		aCols[Len(aCols),_nLocDes] := _cLocal
		aCols[Len(aCols),_nLotDes] := _cLoteDes
		aCols[Len(aCols),_nVldOri] := TRB->TRB_VALID
		TRB->(dbSkip())
	Enddo
ENDIF

TRB->(dbCloseArea())
RestArea(_cArea)
Return()

Static Function _f261Inverte(cMarca)
_nRecno := TRB->(Recno())
TRB->(dbGoTop())
While TRB->( !Eof() )
	RecLock("TRB",.F.)
	IF TRB_OK == cMarca
		TRB->TRB_OK := "  "
	Else
		TRB->TRB_OK := cMarca
	Endif
	TRB->(MsUnlock())
	TRB->(dbSkip())
Enddo
TRB->(dbGoTo(_nRecno))
oMark:oBrowse:Refresh(.t.)
Return Nil

Static Function _fVldBtn(cMarca)
Local _lRet := .F.
_nRecno := TRB->(Recno())
TRB->(dbGoTop())
While TRB->( !Eof() )
	IF TRB_OK == cMarca
		_lRet := .T.
		Exit
	ENDIF
	TRB->(dbSkip())
Enddo
TRB->(dbGoTo(_nRecno))
Return(_lRet)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³   C()   ³ Autores ³ Norbert/Ernani/Mansano ³ Data ³10/05/2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao  ³ Funcao responsavel por manter o Layout independente da       ³±±
±±³           ³ resolucao horizontal do Monitor do Usuario.                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function C(nTam)                                                         
Local nHRes	:=	oMainWnd:nClientWidth	// Resolucao horizontal do monitor     
	If nHRes == 640	// Resolucao 640x480 (soh o Ocean e o Classic aceitam 640)  
		nTam *= 0.8                                                                
	ElseIf (nHRes == 798).Or.(nHRes == 800)	// Resolucao 800x600                
		nTam *= 1                                                                  
	Else	// Resolucao 1024x768 e acima                                           
		nTam *= 1.28                                                               
	EndIf                                                                         
                                                                                
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿                                               
	//³Tratamento para tema "Flat"³                                               
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ                                               
	If "MP8" $ oApp:cVersion                                                      
		If (Alltrim(GetTheme()) == "FLAT") .Or. SetMdiChild()                      
			nTam *= 0.90                                                            
		EndIf                                                                      
	EndIf                                                                         
Return Int(nTam)