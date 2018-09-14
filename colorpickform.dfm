object Form3: TForm3
  Left = 0
  Top = 0
  BorderStyle = bsToolWindow
  Caption = 
    ' pick a foreground or backgroundcolor / change Hue, Saturation, ' +
    'Luminance'
  ClientHeight = 99
  ClientWidth = 699
  Color = 16311232
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object davColorBox1: TdavColorBox
    Left = 3
    Top = 50
    Width = 169
    Height = 49
    OnSelect = davColorBox1Select
    colordepth = cb64
    border = 4
  end
  object Label1: TLabel
    Left = 178
    Top = 78
    Width = 24
    Height = 13
    Caption = 'VAR:'
  end
  object Label4: TLabel
    Left = 242
    Top = 50
    Width = 14
    Height = 13
    Caption = 'to:'
  end
  object Label2: TLabel
    Left = 176
    Top = 50
    Width = 26
    Height = 13
    Caption = 'from:'
  end
  object Label3: TLabel
    Left = 298
    Top = 50
    Width = 16
    Height = 13
    Caption = '=>'
  end
  object HueBar: TTrackBar
    Left = 1
    Top = -1
    Width = 241
    Height = 29
    Max = 240
    TabOrder = 5
    OnChange = HueBarChange
  end
  object SatBar: TTrackBar
    Left = 231
    Top = -1
    Width = 243
    Height = 29
    Max = 240
    TabOrder = 0
    OnChange = SatBarChange
  end
  object HPanel1: TPanel
    Left = 318
    Top = 47
    Width = 32
    Height = 20
    ParentCustomHint = False
    BevelInner = bvLowered
    BevelKind = bkTile
    ParentBackground = False
    ParentShowHint = False
    ShowCaption = False
    ShowHint = False
    TabOrder = 1
    StyleElements = [seBorder]
    OnMouseDown = HPanel1MouseDown
  end
  object HPanel2: TPanel
    Left = 349
    Top = 47
    Width = 32
    Height = 20
    ParentCustomHint = False
    BevelInner = bvLowered
    BevelKind = bkTile
    ParentBackground = False
    ParentShowHint = False
    ShowCaption = False
    ShowHint = False
    TabOrder = 2
    StyleElements = [seBorder]
    OnMouseDown = HPanel1MouseDown
  end
  object HPanel3: TPanel
    Left = 380
    Top = 47
    Width = 32
    Height = 20
    ParentCustomHint = False
    BevelInner = bvLowered
    BevelKind = bkTile
    ParentBackground = False
    ParentShowHint = False
    ShowCaption = False
    ShowHint = False
    TabOrder = 3
    StyleElements = [seBorder]
    OnMouseDown = HPanel1MouseDown
  end
  object LumBar: TTrackBar
    Left = 460
    Top = -1
    Width = 242
    Height = 29
    Max = 240
    TabOrder = 6
    OnChange = LumBarChange
  end
  object HPanel4: TPanel
    Left = 411
    Top = 47
    Width = 32
    Height = 20
    ParentCustomHint = False
    BevelInner = bvLowered
    BevelKind = bkTile
    ParentBackground = False
    ParentShowHint = False
    ShowCaption = False
    ShowHint = False
    TabOrder = 7
    StyleElements = [seBorder]
    OnMouseDown = HPanel1MouseDown
  end
  object HPanel5: TPanel
    Left = 442
    Top = 47
    Width = 32
    Height = 20
    ParentCustomHint = False
    BevelInner = bvLowered
    BevelKind = bkTile
    ParentBackground = False
    ParentShowHint = False
    ShowCaption = False
    ShowHint = False
    TabOrder = 8
    StyleElements = [seBorder]
    OnMouseDown = HPanel1MouseDown
  end
  object SPanel1: TPanel
    Left = 474
    Top = 47
    Width = 32
    Height = 20
    ParentCustomHint = False
    BevelInner = bvLowered
    BevelKind = bkTile
    ParentBackground = False
    ParentShowHint = False
    ShowCaption = False
    ShowHint = False
    TabOrder = 9
    StyleElements = [seBorder]
    OnMouseDown = HPanel1MouseDown
  end
  object SPanel2: TPanel
    Left = 504
    Top = 47
    Width = 32
    Height = 20
    ParentCustomHint = False
    BevelInner = bvLowered
    BevelKind = bkTile
    ParentBackground = False
    ParentShowHint = False
    ShowCaption = False
    ShowHint = False
    TabOrder = 10
    StyleElements = [seBorder]
    OnMouseDown = HPanel1MouseDown
  end
  object SPanel3: TPanel
    Left = 537
    Top = 47
    Width = 32
    Height = 20
    ParentCustomHint = False
    BevelInner = bvLowered
    BevelKind = bkTile
    ParentBackground = False
    ParentShowHint = False
    ShowCaption = False
    ShowHint = False
    TabOrder = 11
    StyleElements = [seBorder]
    OnMouseDown = HPanel1MouseDown
  end
  object pickbtn: TBitBtn
    Left = 531
    Top = 74
    Width = 57
    Height = 22
    Caption = 'SET'
    TabOrder = 12
    OnClick = pickbtnClick
  end
  object RadioGroup1: TRadioGroup
    Left = 590
    Top = 73
    Width = 112
    Height = 21
    TabOrder = 13
  end
  object SetFG: TRadioButton
    Left = 594
    Top = 77
    Width = 32
    Height = 14
    Caption = 'FG'
    TabOrder = 14
  end
  object SetBG: TRadioButton
    Left = 626
    Top = 77
    Width = 34
    Height = 14
    Caption = 'BG'
    TabOrder = 15
  end
  object resetbtn: TBitBtn
    Left = 407
    Top = 74
    Width = 57
    Height = 22
    Caption = 'RESET'
    TabOrder = 16
    OnClick = resetbtnClick
  end
  object fetchbtn: TBitBtn
    Left = 350
    Top = 74
    Width = 57
    Height = 22
    Caption = 'FETCH'
    TabOrder = 17
    OnClick = fetchbtnClick
  end
  object SetBothBtn: TBitBtn
    Left = 464
    Top = 74
    Width = 57
    Height = 22
    Caption = 'SET BOTH'
    TabOrder = 18
    OnClick = SetBothBtnClick
  end
  object VarHue: TButton
    Left = 202
    Top = 74
    Width = 46
    Height = 22
    Caption = 'Hue'
    TabOrder = 19
    OnClick = VarHueClick
  end
  object VarSat: TButton
    Left = 249
    Top = 74
    Width = 46
    Height = 22
    Caption = 'Sat'
    TabOrder = 20
    OnClick = VarSatClick
  end
  object VarLum: TButton
    Left = 296
    Top = 74
    Width = 46
    Height = 22
    Caption = 'Lum'
    TabOrder = 21
    OnClick = VarLumClick
  end
  object Sresultbox: TPanel
    Left = 8
    Top = 22
    Width = 688
    Height = 22
    Alignment = taLeftJustify
    BevelInner = bvLowered
    BevelKind = bkTile
    Caption = 
      '                 Hue                                  Saturation' +
      '                             Luminance'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Lucida Sans Unicode'
    Font.Style = [fsBold]
    ParentBackground = False
    ParentFont = False
    TabOrder = 4
    StyleElements = [seBorder]
    OnClick = SresultboxClick
  end
  object FromPanel: TPanel
    Left = 201
    Top = 47
    Width = 32
    Height = 20
    ParentCustomHint = False
    BevelInner = bvLowered
    BevelKind = bkTile
    ParentBackground = False
    ParentShowHint = False
    ShowCaption = False
    ShowHint = False
    TabOrder = 22
    StyleElements = [seBorder]
    OnClick = FromPanelClick
  end
  object ToPanel: TPanel
    Left = 262
    Top = 48
    Width = 32
    Height = 20
    ParentCustomHint = False
    BevelInner = bvLowered
    BevelKind = bkTile
    ParentBackground = False
    ParentShowHint = False
    ShowCaption = False
    ShowHint = False
    TabOrder = 23
    StyleElements = [seBorder]
    OnClick = FromPanelClick
  end
  object HexEdit: TEdit
    Left = 584
    Top = 47
    Width = 112
    Height = 26
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 24
    Text = 'HexColor'
    OnKeyPress = HexEditKeyPress
  end
  object autoFG: TRadioButton
    Left = 660
    Top = 75
    Width = 113
    Height = 17
    Caption = 'auto'
    Checked = True
    TabOrder = 25
    TabStop = True
  end
end
