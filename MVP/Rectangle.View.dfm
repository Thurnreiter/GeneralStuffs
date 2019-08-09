object FormRectangleView: TFormRectangleView
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Rectangle View'
  ClientHeight = 246
  ClientWidth = 225
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 64
    Top = 40
    Width = 33
    Height = 13
    Caption = 'Length'
  end
  object Label2: TLabel
    Left = 64
    Top = 80
    Width = 38
    Height = 13
    Caption = 'Breadth'
  end
  object LabelResult: TLabel
    Left = 56
    Top = 192
    Width = 30
    Height = 13
    Alignment = taCenter
    Caption = 'Result'
  end
  object EditLength: TEdit
    Left = 112
    Top = 37
    Width = 49
    Height = 21
    TabOrder = 0
    Text = '2'
  end
  object EditBreadth: TEdit
    Left = 112
    Top = 77
    Width = 49
    Height = 21
    TabOrder = 1
    Text = '4'
  end
  object Button1: TButton
    Left = 64
    Top = 128
    Width = 97
    Height = 25
    Caption = 'Calulate Area'
    TabOrder = 2
    OnClick = Button1Click
  end
end
