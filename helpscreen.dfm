object HelpForm: THelpForm
  Left = 0
  Top = 0
  Caption = 'Help & notes'
  ClientHeight = 755
  ClientWidth = 798
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 16
  object TabControl1: TTabControl
    Left = 0
    Top = 0
    Width = 798
    Height = 755
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Lucida Sans Unicode'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
    Tabs.Strings = (
      'help'
      'butlerview'
      'notes')
    TabIndex = 0
    OnChange = TabControl1Change
    object RichEdit1: TRichEdit
      Left = 4
      Top = 31
      Width = 790
      Height = 720
      Align = alClient
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Lucida Sans Unicode'
      Font.Style = [fsBold]
      Lines.Strings = (
        'RichEdit1')
      ParentFont = False
      PlainText = True
      ScrollBars = ssVertical
      TabOrder = 0
      Zoom = 100
      OnKeyUp = FormKeyUp
    end
  end
end
