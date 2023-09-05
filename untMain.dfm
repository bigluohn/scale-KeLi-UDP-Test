object frmMain: TfrmMain
  Left = 0
  Top = 0
  Caption = #26607#21147#20202#34920#32593#32476#36890#35759#27979#35797
  ClientHeight = 444
  ClientWidth = 715
  Color = clBtnFace
  Font.Charset = GB2312_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = #23435#20307
  Font.Style = []
  OnClose = FormClose
  OnCreate = FormCreate
  TextHeight = 16
  object Label1: TLabel
    Left = 464
    Top = 128
    Width = 48
    Height = 16
    Caption = #35299#26512#65306
  end
  object Label2: TLabel
    Left = 464
    Top = 204
    Width = 80
    Height = 16
    Caption = #26085#26399#26102#38388#65306
  end
  object lblDateTime: TLabel
    Left = 553
    Top = 204
    Width = 24
    Height = 16
    Caption = '---'
  end
  object lblMsgLen: TLabel
    Left = 553
    Top = 160
    Width = 8
    Height = 16
    Caption = '0'
  end
  object Label4: TLabel
    Left = 464
    Top = 160
    Width = 80
    Height = 16
    Caption = #23454#38469#38271#24230#65306
  end
  object lblMsgLen2: TLabel
    Left = 553
    Top = 182
    Width = 8
    Height = 16
    Caption = '0'
  end
  object Label5: TLabel
    Left = 464
    Top = 182
    Width = 80
    Height = 16
    Caption = #23450#20041#38271#24230#65306
  end
  object Label3: TLabel
    Left = 464
    Top = 226
    Width = 80
    Height = 16
    Caption = #20256' '#24863' '#22120#65306
  end
  object lblSensorCount: TLabel
    Left = 553
    Top = 226
    Width = 8
    Height = 16
    Caption = '0'
  end
  object Label6: TLabel
    Left = 464
    Top = 248
    Width = 80
    Height = 16
    Caption = #23567' '#25968' '#28857#65306
  end
  object lblDecimal: TLabel
    Left = 553
    Top = 248
    Width = 8
    Height = 16
    Caption = '0'
  end
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
    Left = 592
    Top = 68
    Width = 113
    Height = 41
    Caption = #24320#22987#30417#21548
    Enabled = False
    TabOrder = 5
    OnClick = btnListenClick
  end
  object btnSend: TButton
    Left = 592
    Top = 21
    Width = 113
    Height = 41
    Caption = #21457#36865
    TabOrder = 6
    OnClick = btnSendClick
  end
  object chkS1: TCheckBox
    Left = 464
    Top = 376
    Width = 80
    Height = 17
    Caption = #25968#25454'OK'
    TabOrder = 7
  end
  object chkS2: TCheckBox
    Left = 550
    Top = 376
    Width = 80
    Height = 17
    Caption = #31204#36229#36733
    TabOrder = 8
  end
  object udpClient: TIdUDPClient
    Port = 0
    Left = 352
    Top = 96
  end
end
