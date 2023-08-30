object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 442
  ClientWidth = 628
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnClose = FormClose
  OnCreate = FormCreate
  TextHeight = 15
  object edtPort: TLabeledEdit
    Left = 539
    Top = 8
    Width = 81
    Height = 23
    EditLabel.Width = 26
    EditLabel.Height = 23
    EditLabel.Caption = #31471#21475
    LabelPosition = lpLeft
    TabOrder = 0
    Text = '2234'
  end
  object lst: TListBox
    Left = 8
    Top = 8
    Width = 497
    Height = 433
    ItemHeight = 15
    TabOrder = 1
  end
  object btnListen: TButton
    Left = 512
    Top = 40
    Width = 108
    Height = 25
    Caption = #24320#22987#30417#21548
    TabOrder = 2
    OnClick = btnListenClick
  end
end
