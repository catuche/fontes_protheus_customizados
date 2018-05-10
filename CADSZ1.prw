#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  CADSZ1     � Autor � Ricardo Rotta      � Data �  04/06/17   ���
�������������������������������������������������������������������������͹��
���Descricao � Relacao de Estacao x Local de Impressora Termica           ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Fiabesa                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function CADSZ1


//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Local cVldAlt := ".T." // Validacao para permitir a alteracao. Pode-se utilizar ExecBlock.
Local cVldExc := ".T." // Validacao para permitir a exclusao. Pode-se utilizar ExecBlock.

Private cString := "SZ1"

dbSelectArea("SZ1")
dbSetOrder(1)

AxCadastro(cString,"Cadastro de Estacao e Local de Impressao de Etiquetas",cVldExc,cVldAlt)

Return
