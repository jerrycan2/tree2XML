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
    ExplicitLeft = 112
    ExplicitTop = 352
    ExplicitWidth = 0
  end
  object ListButton: TButton
    Left = 43
    Top = 97
    Width = 270
    Height = 24
    Caption = 'Save XML for my site (no greek in it)'
    TabOrder = 3
    OnClick = ListButtonClick
  end
  object greekhtmlbutton: TButton
    Left = 43
    Top = 127
    Width = 270
    Height = 25
    Caption = 'save greek html'
    TabOrder = 4
  end
  object greekdatbutton: TButton
    Left = 43
    Top = 158
    Width = 270
    Height = 25
    Caption = 'save greek .dat'
    TabOrder = 5
  end
  object Button1: TButton
    Left = 43
    Top = 189
    Width = 270
    Height = 25
    Caption = 'save butler xml'
    TabOrder = 6
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 43
    Top = 36
    Width = 270
    Height = 25
    Caption = 'save standard XML'
    TabOrder = 7
  end
end
