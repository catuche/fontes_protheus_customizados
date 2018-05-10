#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'FWMVCDEF.CH'

#DEFINE DETALHE "Z3_ITEM/Z3_CTRAB/Z3_DSCTRAB/"

//-------------------------------------------------------------------
User Function CADSZ2()
Private oBrowse

//SFCValInt() // Verifica integração ligada

oBrowse := FWMBrowse():New()
oBrowse:SetAlias( 'SZ2' )
oBrowse:SetDescription( 'Tipos de Residuo' ) // 
oBrowse:Activate()

Return NIL

//-------------------------------------------------------------------
Static Function MenuDef()
    Local aRot := {}
     
    //Adicionando opções
    ADD OPTION aRot TITLE 'Visualizar' ACTION 'VIEWDEF.CADSZ2' OPERATION MODEL_OPERATION_VIEW   ACCESS 0 //OPERATION 1
    ADD OPTION aRot TITLE 'Incluir'    ACTION 'VIEWDEF.CADSZ2' OPERATION MODEL_OPERATION_INSERT ACCESS 0 //OPERATION 3
    ADD OPTION aRot TITLE 'Alterar'    ACTION 'VIEWDEF.CADSZ2' OPERATION MODEL_OPERATION_UPDATE ACCESS 0 //OPERATION 4
    ADD OPTION aRot TITLE 'Excluir'    ACTION 'VIEWDEF.CADSZ2' OPERATION MODEL_OPERATION_DELETE ACCESS 0 //OPERATION 5
 
Return aRot

//-------------------------------------------------------------------
Static Function ModelDef()
// Cria a estrutura a ser usada no Modelo de Dados
Local oModel        := Nil
Local oStPai   := FWFormStruct( 1, 'SZ2', /*lCampoUsado*/ ,/*lViewUsado*/ )
Local oStFilho := FWFormStruct( 1, 'SZ3',  { |cCampo| AllTrim( cCampo ) + '/' $ DETALHE } ,/*lViewUsado*/ )

Local aPAIRel       := {}

oModel := MPFormModel():New('CADSZ2M')

//oModel := MPFormModel():New('MATA311',,{|oModel|A311ActMod(oModel),MAT311PVld(oModel)}, {|oModel|MAT311Grv(oModel)})

oModel:AddFields('SZ2MASTER',/*cOwner*/,oStPai)
oModel:AddGrid('SZ3DETAIL','SZ2MASTER',oStFilho,{ |oModelGrid, nLine, cAction, cField| CADSZ2PRE(oModelGrid, nLine, cAction, cField) })

//Fazendo o relacionamento entre o Pai e Filho
aAdd(aPAIRel, {'Z3_FILIAL' , 'xFilial("SZ3")'} )
aAdd(aPAIRel, {'Z3_COD'    , 'Z2_CODIGO'})

oModel:SetRelation('SZ3DETAIL', aPAIRel, SZ3->(IndexKey(1))) //IndexKey -> quero a ordenação e depois filtrado

//Setando as descrições
oModel:SetDescription('Cadastro Tipo de Residuo')
oModel:GetModel('SZ2MASTER'):SetDescription('Tipos de Residuo')
oModel:GetModel('SZ3DETAIL'):SetDescription('Centro de Trabalho')

oModel:SetPrimaryKey({ 'Z2_FILIAL', 'Z2_CODIGO' })
oModel:GetModel('SZ3DETAIL'):SetUniqueLine({'Z3_CTRAB' })

oStPai:SetProperty( 'Z2_CODIGO' , MODEL_FIELD_WHEN, FWBuildFeature(STRUCT_FEATURE_WHEN, "INCLUI"))

oStFilho:SetProperty( 'Z3_ITEM'  ,MODEL_FIELD_INIT,{|o|Z3IncItem(o,'Z3_ITEM')})
oStFilho:SetProperty('Z3_DSCTRAB',MODEL_FIELD_INIT, FWBuildFeature(STRUCT_FEATURE_INIPAD, "If( !INCLUI,Posicione('SHB',1,xFilial('SHB')+SZ3->Z3_CTRAB,'HB_NOME'), '' )"))

Return oModel

//-------------------------------------------------------------------
Static Function ViewDef()

    Local oView     := Nil
    Local oModel    := FWLoadModel('CADSZ2')
	Local oStPai 	:= FWFormStruct( 2, 'SZ2' )
	Local oStFilho 	:= FWFormStruct( 2, 'SZ3' ,{ |cCampo| AllTrim( cCampo ) + '/' $ DETALHE } )
    //Criando a View
    oView := FWFormView():New()
    oView:SetModel(oModel)
     
    //Adicionando os campos do cabeçalho e o grid dos filhos
    oView:AddField('VIEW_SZ2',oStPai,'SZ2MASTER')
    oView:AddGrid('VIEW_DET',oStFilho,'SZ3DETAIL')
     
    //Setando o dimensionamento de tamanho
    oView:CreateHorizontalBox('CABEC',20)
    oView:CreateHorizontalBox('GRID',80)
     
    //Amarrando a view com as box
    oView:SetOwnerView('VIEW_SZ2','CABEC')
    oView:SetOwnerView('VIEW_DET','GRID')
     
    //Habilitando título
    oView:EnableTitleView('VIEW_SZ2','Tipos de Residuo')
    oView:EnableTitleView('VIEW_DET','Dados dos Ensaios')
Return oView

//--------------------------------------------------------------------------
Static Function Z3IncItem(oModel,cCampo)
Local cRet
	If oModel:Length() > 0 
//		oModel:GoLine( oModel:Length() )
		cRet := Soma1(oModel:GetValue(cCampo))
	Else
		cRet := '01' 
	EndIf	
Return cRet
//--------------------------------------------------------------------------

Static Function CADSZ2PRE( oModelGrid, nLinha, cAcao, cCampo )
Local lRet := .T.
Local oModel := oModelGrid:GetModel()
Local nOperation := oModel:GetOperation()
Local _cTrab  := oModelGrid:GetValue("Z3_CTRAB")
Local _cItem  := oModelGrid:GetValue("Z3_ITEM")
// Valida se pode ou não apagar uma linha do Grid
/*
If cAcao == 'DELETE' .AND. nOperation == MODEL_OPERATION_UPDATE
	lRet := .F.
	Help( ,, 'Help',, 'Não permitido apagar linhas na alteração.' +;
	CRLF + 'Você esta na linha ' + Alltrim( Str( nLinha ) ), 1, 0 )
EndIf

If cAcao == 'DELETE' .and. Empty(_cTrab)
	_cItem := StrZero(Val(_cItem)-1,2)
	oModelGrid:SetValue("Z3_ITEM",_cItem)
Endif
*/
Return lRet