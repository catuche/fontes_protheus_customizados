#INCLUDE "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³EMP650    ºAutor  ³Microsiga           º Data ³  12/11/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function EMP650()

Local aArea    := GetArea()
Local _nPosLc  := aScan(aHeader,{|x| AllTrim(x[2])=="D4_LOCAL"})
Local _cLocal  := GETMV("MV_XALMPRD")
Local _cGrpPA := SuperGetMV("FB_PRDLCPA",.F.,"0411/0418")
Local _cGrpMP := SuperGetMV("FB_PRDLCMP",.F.,"0310/11;0320/11")
Local _nPosCP  := aScan(aHeader,{|x| AllTrim(x[2])=="G1_COMP"})
Local _cTipoP  := Posicione("SB1",1,xFilial("SB1")+SC2->C2_PRODUTO,"B1_GRUPO")
Local _nI:=1
Local _lGrpPA  := _cTipoP $ _cGrpPA
For	_nI := 1 To Len(aCols)
	_cLocal  := GETMV("MV_XALMPRD")
	If _cTipoP == "X107"  // Reciclado
		aCols[_nI][Len(aHeader)+1]:= .T.
	Else
		If !IsProdMOD(aCols[_nI][_nPosCP],.T.)
			If _lGrpPA
				_cGrupoMP  := Posicione("SB1",1,xFilial("SB1")+aCols[_nI][_nPosCP],"B1_GRUPO")
				If _cGrupoMP $ _cGrpMP
					nPosGrp := AT(_cGrupoMP,_cGrpMP)
					If nPosGrp > 0
						_cLocal := Substr(_cGrpMP,nPosGrp+5,2)
						dbSelectArea("NNR")
						dbSetOrder(1)
						If !dbSeek(xFilial()+_cLocal)
							_cLocal  := GETMV("MV_XALMPRD")
						Endif
					Endif
				Endif
			Endif
			aCols[_nI][_nPosLc]:= _cLocal
		Endif
	Endif
Next _nI
RestArea(aArea)
Return