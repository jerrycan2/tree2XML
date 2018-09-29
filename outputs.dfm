object OutputForm: TOutputForm
  Left = 0
  Top = 0
  Caption = 'OutputForm'
  ClientHeight = 411
  ClientWidth = 611
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object ProgressBar1: TProgressBar
    Left = 32
    Top = 8
    Width = 150
    Height = 17
    TabOrder = 0
  end
  object SaveHtmlButton: TButton
    Left = 43
    Top = 66
    Width = 270
    Height = 25
    Hint = 'save tree + attributes as HTML'
    Caption = 'save HTML'
    Enabled = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clTeal
    Font.Height = -13
    Font.Name = 'Lucida Sans Unicode'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    OnClick = SaveHtmlButtonClick
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 392
    Width = 611
    Height = 19
    Panels = <
      item
        Width = 50
      end
      item
        Width = 50
      end>
  end
  object ListButton: TButton
    Left = 43
    Top = 97
    Width = 270
    Height = 24
    Caption = 'json create from tree'
    TabOrder = 3
    OnClick = ListButtonClick
  end
  object tempbutton: TButton
    Left = 43
    Top = 127
    Width = 270
    Height = 25
    Caption = 'convert'
    TabOrder = 4
    OnClick = tempbuttonClick
  end
  object greekdatbutton: TButton
    Left = 43
    Top = 158
    Width = 270
    Height = 25
    Caption = 'save greek .dat'
    Enabled = False
    TabOrder = 5
  end
  object Button1: TButton
    Left = 43
    Top = 189
    Width = 270
    Height = 25
    Caption = 'save butler xml'
    Enabled = False
    TabOrder = 6
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 43
    Top = 36
    Width = 270
    Height = 25
    Caption = 'save standard XML'
    Enabled = False
    TabOrder = 7
  end
  object Memo1: TMemo
    Left = 48
    Top = 224
    Width = 521
    Height = 169
    Lines.Strings = (
      'Memo1')
    ScrollBars = ssBoth
    TabOrder = 8
  end
end
