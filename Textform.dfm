object Form2: TForm2
  Left = 0
  Top = 0
  Caption = 'Text'
  ClientHeight = 286
  ClientWidth = 492
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  Menu = MainMenu1
  OldCreateOrder = False
  OnActivate = FormShow
  OnCreate = FormCreate
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 492
    Height = 21
    Align = alTop
    Caption = 'Panel1'
    TabOrder = 0
    object GoTranslate: TButton
      Left = 423
      Top = 2
      Width = 67
      Height = 21
      Caption = 'English'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      OnClick = GoTranslateClick
    end
    object GoWord: TButton
      Left = 281
      Top = 2
      Width = 75
      Height = 21
      Caption = 'Lookup'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      OnClick = GoWordClick
    end
    object GoLine: TButton
      Left = 356
      Top = 2
      Width = 66
      Height = 21
      Caption = 'Greek line'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      OnClick = GoLineClick
    end
    object LookupList: TComboBox
      Left = 0
      Top = 1
      Width = 275
      Height = 21
      TabOrder = 3
      Text = 'LookupList'
    end
  end
  object grid: TStringGrid
    Left = 0
    Top = 21
    Width = 492
    Height = 265
    Align = alClient
    ColCount = 3
    DefaultDrawing = False
    DoubleBuffered = False
    FixedCols = 0
    FixedRows = 0
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Lucida Sans Unicode'
    Font.Style = []
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goDrawFocusSelected, goEditing]
    ParentDoubleBuffered = False
    ParentFont = False
    ParentShowHint = False
    ScrollBars = ssVertical
    ShowHint = False
    TabOrder = 1
    StyleElements = []
    OnDrawCell = gridDrawCell
    OnKeyDown = gridKeyDown
    OnMouseUp = gridMouseUp
    OnSelectCell = gridSelectCell
  end
  object MainMenu1: TMainMenu
    Left = 336
    Top = 24
    object Alfabet1: TMenuItem
      Caption = 'Alfabet'
      object Show1: TMenuItem
        Caption = 'Show'
        OnClick = Show1Click
      end
    end
  end
end
