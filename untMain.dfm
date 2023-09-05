object frmMain: TfrmMain
  Left = 0
  Top = 0
  Caption = #26607#21147#20202#34920#32593#32476#36890#35759#27979#35797
  ClientHeight = 474
  ClientWidth = 733
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
    Top = 191
    Width = 48
    Height = 16
    Caption = #35299#26512#65306
  end
  object Label2: TLabel
    Left = 464
    Top = 284
    Width = 80
    Height = 16
    Caption = #26085#26399#26102#38388#65306
  end
  object lblDateTime: TLabel
    Left = 553
    Top = 284
    Width = 24
    Height = 16
    Caption = '---'
  end
  object lblMsgLen: TLabel
    Left = 553
    Top = 240
    Width = 8
    Height = 16
    Caption = '0'
  end
  object Label4: TLabel
    Left = 464
    Top = 240
    Width = 80
    Height = 16
    Caption = #23454#38469#38271#24230#65306
  end
  object lblMsgLen2: TLabel
    Left = 553
    Top = 262
    Width = 8
    Height = 16
    Caption = '0'
  end
  object Label5: TLabel
    Left = 464
    Top = 262
    Width = 80
    Height = 16
    Caption = #23450#20041#38271#24230#65306
  end
  object Label3: TLabel
    Left = 464
    Top = 306
    Width = 80
    Height = 16
    Caption = #20256' '#24863' '#22120#65306
  end
  object lblSensorCount: TLabel
    Left = 553
    Top = 306
    Width = 8
    Height = 16
    Caption = '0'
  end
  object Label6: TLabel
    Left = 464
    Top = 328
    Width = 80
    Height = 16
    Caption = #23567' '#25968' '#28857#65306
  end
  object lblDecimal: TLabel
    Left = 553
    Top = 328
    Width = 8
    Height = 16
    Caption = '0'
  end
  object Label7: TLabel
    Left = 464
    Top = 350
    Width = 96
    Height = 16
    Caption = #24635#37325#26080#23567#25968#65306
  end
  object lblGross: TLabel
    Left = 553
    Top = 350
    Width = 24
    Height = 16
    Caption = '---'
  end
  object Label8: TLabel
    Left = 464
    Top = 218
    Width = 80
    Height = 16
    Caption = #20202#34920#22320#22336#65306
  end
  object lblPeerIPPort: TLabel
    Left = 553
    Top = 218
    Width = 24
    Height = 16
    Caption = '---'
  end
  object edtIP: TLabeledEdit
    Left = 112
    Top = 8
    Width = 137
    Height = 24
    EditLabel.Width = 96
    EditLabel.Height = 24
    EditLabel.Caption = #26412#26426'('#25509#25910')IP'
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
    Left = 384
    Top = 8
    Width = 57
    Height = 24
    EditLabel.Width = 112
    EditLabel.Height = 24
    EditLabel.Caption = #26412#26426'('#25509#25910')'#31471#21475
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
    Left = 616
    Top = 68
    Width = 113
    Height = 41
    Caption = #24320#22987#30417#21548
    Enabled = False
    TabOrder = 5
    OnClick = btnListenClick
  end
  object btnSend: TButton
    Left = 616
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
    Width = 91
    Height = 17
    Caption = #25968#25454#24322#24120
    TabOrder = 7
  end
  object chkS2: TCheckBox
    Left = 574
    Top = 376
    Width = 80
    Height = 17
    Caption = #31204#36229#36733
    TabOrder = 8
  end
  object chkS3: TCheckBox
    Left = 464
    Top = 399
    Width = 80
    Height = 17
    Caption = #31204#31283#23450
    TabOrder = 9
  end
  object chkS4: TCheckBox
    Left = 574
    Top = 399
    Width = 91
    Height = 17
    Caption = #36890#35759#24322#24120
    TabOrder = 10
  end
  object chkChkOK: TCheckBox
    Left = 464
    Top = 422
    Width = 91
    Height = 17
    Caption = #26657#39564#30721'OK'
    TabOrder = 11
  end
  object GroupBox1: TGroupBox
    Left = 464
    Top = 115
    Width = 261
    Height = 70
    Caption = #20889#20202#34920
    TabOrder = 12
    object btnZero: TButton
      Left = 16
      Top = 24
      Width = 75
      Height = 33
      Caption = #32622#38646
      TabOrder = 0
      OnClick = btnZeroClick
    end
    object chkHighRate: TCheckBox
      Left = 128
      Top = 32
      Width = 97
      Height = 17
      Caption = #39640#21457#36865#36895#29575
      TabOrder = 1
      OnClick = chkHighRateClick
    end
  end
  object btnClear: TButton
    Left = 8
    Top = 440
    Width = 137
    Height = 25
    Caption = #28165#38500#26174#31034
    TabOrder = 13
    OnClick = btnClearClick
  end
  object udpClient: TIdUDPClient
    Port = 0
    Left = 352
    Top = 96
  end
end
