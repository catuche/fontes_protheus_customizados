#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MA330P3   ºAutor  ³Ricardo Rotta       º Data ³  23/01/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Ponto de entrada para atualizacao dos custos em partes da   ±±
±±º          ³ MOD                                                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ PQS                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MA330P3()

//{aCusto,lCstPart,aRegraCP,ACLONE(aRetPartes)}

Local _aArea := GetArea()
Local _aRateio:=Paramixb[4]
Local _aRegraCP := Paramixb[3]
Local _aCusto := Paramixb[1]
Local _lCstPart := Paramixb[2]
Local _dDataFech
Local _cCampo1  :="D3_CP"+Strzero(Len(_aRegraCP)+1,2,0)+"01"
Local cMoeda330C := SuperGetMv('MV_MOEDACM',.F.,"2345") 

_dDataFech := MV_PAR01
If !_lCstPart
	Return
Endif
If Substr(SD3->D3_COD,1,3) == "MOD"
	// Garante custos com valor
	// zero antes do calculo
	For _nI := 1 To len(Paramixb[4])
		Paramixb[4,_nI] := 0
	Next _nI
	_nCusto := _aCusto[1]
	_nAprop := 0
	_cMaior := "00"
	_nPerc  := 0
	DbSelectArea("PC1")
	DbSetOrder(1)
	If DbSeek(xFilial("PC1")+Dtos(_dDataFech)+Substr(SD3->D3_COD,4,12))
		_nTOTMOD := PC1->PC1_TOTAL
		While !Eof() .and. PC1->PC1_DTFECH == _dDataFech .and. Alltrim(Substr(SD3->D3_COD,4,12)) == Alltrim(PC1->PC1_CCUSTO)
			Paramixb[4,1+((Val(PC1->PC1_PARTE)-1)*5)] := Round(Paramixb[1,1] * (PC1->PC1_MOVIM/PC1->PC1_TOTAL),2)	// Moeda 1
			Paramixb[4,2+((Val(PC1->PC1_PARTE)-1)*5)] := Round(Paramixb[1,2] * (PC1->PC1_MOVIM/PC1->PC1_TOTAL),2)	// Moeda 2
			Paramixb[4,3+((Val(PC1->PC1_PARTE)-1)*5)] := Round(Paramixb[1,3] * (PC1->PC1_MOVIM/PC1->PC1_TOTAL),2)	// Moeda 3
			Paramixb[4,4+((Val(PC1->PC1_PARTE)-1)*5)] := Round(Paramixb[1,4] * (PC1->PC1_MOVIM/PC1->PC1_TOTAL),2)	// Moeda 4
			Paramixb[4,5+((Val(PC1->PC1_PARTE)-1)*5)] := Round(Paramixb[1,5] * (PC1->PC1_MOVIM/PC1->PC1_TOTAL),2)	// Moeda 5
			DbSkip()
		End
		For _nX := 1 To 5							// Trata as 5 moedas
			If _nx # 1 .And. !(Str(_nx,1,0) $ cMoeda330C)
               	Loop
			EndIf
			_cMoeda := Strzero(_nX,2)
			For _nI := 1 To len(Paramixb[4])/5   	// Trata todas as partes
				_cPart := Strzero(_nI,2)
				DbSelectArea("SD3")
				Reclock("SD3",.F.)
				_cCampo := "D3_CP"+_cPart+_cMoeda	// D3_CP+Parte+Moeda
				Replace &_cCampo with Paramixb[4,_nX+((_nI-1)*5)]
				MsUnLock()
			Next _nI
		Next _nX
		_aRateio := Paramixb[4]
	Endif
Endif
Return _aRateio