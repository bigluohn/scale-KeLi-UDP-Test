object frmMain: TfrmMain
  Left = 0
  Top = 0
  Caption = #26607#21147#20202#34920#32593#32476#36890#35759#27979#35797
  ClientHeight = 441
  ClientWidth = 588
  Color = clBtnFace
  Font.Charset = GB2312_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = #23435#20307
  Font.Style = []
  OnClose = FormClose
  OnCreate = FormCreate
  TextHeight = 16
  object edtIP: TLabeledEdit
    Left = 80
    Top = 8
    Width = 137
    Height = 24
    EditLabel.Width = 64
    EditLabel.Height = 24
    EditLabel.Caption = #25509#25910#26041'IP'
    LabelPosition = lpLeft
    TabOrder = 0
    Text = '192.168.2.123'
  end
  object lst: TListBox
    Left = 8
    Top = 68
    Width = 433
    Height = 365
    TabOrder = 1
  end
  object edtPort: TLabeledEdit
    Left = 320
    Top = 8
    Width = 121
    Height = 24
    EditLabel.Width = 80
    EditLabel.Height = 24
    EditLabel.Caption = #25509#25910#26041#31471#21475
    LabelPosition = lpLeft
    TabOrder = 2
    Text = '2222'
  end
  object radFunc: TRadioGroup
    Left = 464
    Top = 8
    Width = 113
    Height = 97
    Caption = #21151#33021#36873#25321
    ItemIndex = 0
    Items.Strings = (
      #21457#36865
      #25509#25910)
    TabOrder = 3
    OnClick = radFuncClick
  end
  object edtSendText: TLabeledEdit
    Left = 80
    Top = 38
    Width = 361
    Height = 24
    EditLabel.Width = 64
    EditLabel.Height = 24
    EditLabel.Caption = #21457#36865#20869#23481
    LabelPosition = lpLeft
    TabOrder = 4
    Text = #25105#26159#21457#36865#20869#23481
  end
  object btnListen: TButton
    Left = 464
    Top = 158
    Width = 113
    Height = 41
    Caption = #24320#22987#30417#21548
    Enabled = False
    TabOrder = 5
    OnClick = btnListenClick
  end
  object btnSend: TButton
    Left = 464
    Top = 111
    Width = 113
    Height = 41
    Caption = #21457#36865
    TabOrder = 6
    OnClick = btnSendClick
  end
  object udpClient: TIdUDPClient
    Port = 0
    Left = 528
    Top = 240
  end
end
