object GreekSaveDialog: TGreekSaveDialog
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Save Greek File'
  ClientHeight = 149
  ClientWidth = 192
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
    Left = 32
    Top = 8
    Width = 129
    Height = 33
    AutoSize = False
    Caption = 'Create HTML or DAT'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object htmlbutton: TButton
    Left = 8
    Top = 73
    Width = 75
    Height = 25
    Caption = 'HTML'
    ModalResult = 7
    TabOrder = 0
    OnClick = htmlbuttonClick
  end
  object datbutton: TButton
    Left = 109
    Top = 72
    Width = 75
    Height = 25
    Caption = '.DAT'
    ModalResult = 6
    TabOrder = 1
    OnClick = datbuttonClick
  end
  object cancelbutton: TButton
    Left = 53
    Top = 104
    Width = 75
    Height = 25
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
    OnClick = cancelbuttonClick
  end
end
