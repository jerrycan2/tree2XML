object CompForm: TCompForm
  Left = 0
  Top = 0
  Caption = 'CompForm'
  ClientHeight = 411
  ClientWidth = 852
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object OldMemo: TMemo
    Left = 0
    Top = 33
    Width = 426
    Height = 378
    Align = alLeft
    Lines.Strings = (
      'OldMemo')
    TabOrder = 0
  end
  object NewMemo: TMemo
    Left = 432
    Top = 33
    Width = 420
    Height = 378
    Align = alRight
    Lines.Strings = (
      'NewMemo')
    TabOrder = 1
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 852
    Height = 33
    Align = alTop
    TabOrder = 2
    object SyncCheck: TCheckBox
      Left = 1
      Top = 1
      Width = 48
      Height = 31
      Align = alLeft
      Caption = 'Sync'
      Checked = True
      State = cbChecked
      TabOrder = 0
    end
  end
end
