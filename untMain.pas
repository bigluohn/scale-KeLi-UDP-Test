{
 ������D2008-W��WD29-W��WD39-W������Э��(��֧��UDP)
1. ��Ҫ���Ǳ������ú��Ǳ���IP��UDP�˿ڣ�Ĭ��4097������Ҫ���ý��շ���IP�Ͷ˿ڣ�
2. �Ǳ���߻��Զ����ͣ�ÿ�뷢8֡���ݣ�
3. ���ڶ��ֽ����͵����ݣ���0x12345678������4���ֽڷ��ͣ�0x12, 0x34....��
4. ����֡��142���ֽڣ�
    0-6:       �̶�ΪASCII�ַ�: "STATE: "��ע���ֽ�6Ϊ�ո� 0x20;
    7-23:     ��ǰ���ں�ʱ�䣬�磺"23-02-30 14:34:59"
    24-25:   ����֡���ֽ�����24Ϊ00��25Ϊ0x8E
    26:        ��������������10��(0xA)
    27:        С����λ�ã���1
    28-39:   ����
    40:        ״̬λ��bit0: 0-������ȷ����λ��1-��λδȷ��(��ʱ���ܹ��������ݲ�׼)
                               bit1: 0-������ 1-����
                               bit2: 0-���ȶ���1-�ȶ�
                               bit3: 0-δȥƤ��1-ȥƤ
                               bit4: 0-������λ����1-����λ��
                               bit5: 0-����������Ч��1-������Ч���궨����ӹ������������Ч��
                               bit6: 0-������ͨѶ������1-ͨѶ�쳣
    41-43:    ����
    44-47:    ë�����룬�����������䰴�ֶ�ֵ�����������ë����ʾ����05.6���ֶ�ֵΪ2����ʱë����ʾ6
    48-51:    ë����ʾֵ���з�����������С����
    52-55:    Ƥ����ʾֵ��ͬ��
    56-59:    ������ʾֵ��ͬ��
    60:          ��ַΪ1�Ĵ�����״̬��0-��ͨѶ��1���������2������
    61-64:    ��ַΪ1�Ĵ��������룬������
    65-139:  2-16�Ŵ�����
    140-141: У����

У�����㷨��
int16u iSum = ��0-139�ֽڵ������ӣ���
У����1(��ַ140) = (iSum >> 8) & 0xFF;
У����2(��ַ141) = iSum & 0xFF;

�����Ǳ���ʾ0.0t
��������(16����)
53 54 41 54 45 3A 20 31 39 2D 30 39 2D 32 33 20 32 32 3A 30 37 3A 32 33 00 8E 01 01 00 00 00 00 00 00 00 00 00 00 00 00 34 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 02 99 D0 1E 47 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 07 C5
�Ǳ���ʾ382.2t
��������(16����)
53 54 41 54 45 3A 20 31 39 2D 30 39 2D 32 33 20 32 32 3A 30 38 3A 31 36 00 8E 01 01 00 00 00 00 00 00 00 00 00 00 00 00 24 00 00 00 3F DC 6E 45 EE 0E 00 00 00 00 00 00 EE 0E 00 00 02 00 B3 E4 47 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 0B 8E


1������ָ��: "KEYCOMMAND:ZERO"
2�����������ٶ����ã�"SPEEDCOMMAND:1"; //0:1��3�Σ�Ĭ�ϣ� ��1��1��10��(�汾ΪV15�����ϲ�֧��)
}
unit untMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs;

type
  TfrmMain = class(TForm)
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

end.