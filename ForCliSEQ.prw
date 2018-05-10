#INCLUDE "PROTHEUS.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ForCliSEQ  º Autor ³ Ricardo Rotta      º Data ³  15/12/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Geracao do codigo do Fornecedor/Cliente                    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Protheus                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function ForCliSEQ()

Local _cCodigo
Local _cLoja
Local _lRet := .t.
Local _cCampo := readvar()
Local _cAlias := Alias()
Local _cConteudo := &(readvar())
Local _lSequenc := Alltrim(SuperGetMv('MV_XMODSEQ', .F., '1')) == "1"
Local _cTipo := M->A2_TIPO
If Inclui
	If _cAlias == "SA2"
		_cCodigo := Space(TamSX3("A2_COD")[1])
		_cLoja   := Space(TamSX3("A2_LOJA")[1])
		_cCNPJ   := Space(TamSX3("A2_CGC")[1])
		If _cCampo == "M->A2_XGRP"
			If _cConteudo == "N"
				If !Empty(_cTipo)
					If _lSequenc .or. _cTipo == "X"
						_cCodigo := GETSXENUM("SA2","A2_COD")
						_cLoja   := Soma1(Replicate("0",TamSX3("A2_LOJA")[1]))
					Else
						_cCodigo := Left(M->A2_CGC,8)
						_cLoja   := SUBSTR(M->A2_CGC,9,4)
					Endif
				Else
					Aviso("Atencao","Favor informar o campo <<Tipo>> ", {"Ok"})
					_lRet := .f.
				Endif
			Else
				M->A2_XCODGRP 	:= _cCNPJ
				M->A2_COD 		:= _cCodigo
				M->A2_LOJA 		:= _cLoja
			Endif
		ElseIf _cCampo == "M->A2_XGRPCGC"
			If M->A2_XGRP == "S"
				If !Empty(_cConteudo)
					dbSetOrder(3)
					If dbSeek(xFilial()+_cConteudo)
						_cCodigo := SA2->A2_COD
						If _lSequenc
							_cLoja   := SA2->A2_LOJA
							dbSetOrder(1)
							dbSeek(xFilial()+_cCodigo+_cLoja)
							While !Eof() .and. xFilial("SA2")+_cCodigo+_cLoja == SA2->(A2_FILIAL+A2_COD+A2_LOJA)
								_cLoja := Soma1(_cLoja)
								dbSeek(xFilial()+_cCodigo+_cLoja)
							End
						Else
							If _cCodigo == Left(M->A2_CGC,8)
								_cLoja   := SUBSTR(M->A2_CGC,9,4)
							Else
								_cLoja   := "G" + Soma1(Replicate("0",TamSX3("A2_LOJA")[1]-1))
								dbSetOrder(1)
								dbSeek(xFilial()+_cCodigo+_cLoja)
								While !Eof() .and. xFilial("SA2")+_cCodigo+_cLoja == SA2->(A2_FILIAL+A2_COD+A2_LOJA)
									_cLoja := Soma1(_cLoja)
									dbSeek(xFilial()+_cCodigo+_cLoja)
								End
							Endif
						Endif
					Else
						Aviso("Atencao","Codigo nao encontrado"+CRLF+"Informe o codigo do Fornecedor, ja cadastrado, que pertence ao mesmo grupo", {"Ok"})
						_lRet := .f.
					Endif
				Endif
			Endif
		Endif
		M->A2_COD := _cCodigo
		M->A2_LOJA := _cLoja
	Endif
Endif
Return(_lRet)