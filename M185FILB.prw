#INCLUDE "Protheus.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  M185FILB   � Autor � Ricardo Rotta      � Data �  17/04/17   ���
�������������������������������������������������������������������������͹��
���Descricao � Filtro na tela da baixa da SA para mostrar apenas as Sas   ���
���          � que n�o s�o para OP                                        ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function M185FILB

Local cFilQuery := "CP_XLOCAL = '" + Space(TAMSX3("CP_XLOCAL")[1]) + "'"

Return(cFilQuery)