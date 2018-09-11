object AlfabetForm: TAlfabetForm
  Left = 0
  Top = 0
  HorzScrollBar.Visible = False
  VertScrollBar.Visible = False
  BorderStyle = bsNone
  BorderWidth = 4
  Caption = 'Alfabet'
  ClientHeight = 59
  ClientWidth = 471
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  KeyPreview = True
  OldCreateOrder = False
  PopupMode = pmExplicit
  PopupParent = Form2.Owner
  Position = poOwnerFormCenter
  OnClick = FormClick
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 0
    Top = 0
    Width = 471
    Height = 13
    Align = alTop
    Alignment = taCenter
    AutoSize = False
    Caption = 'click to close'
    Color = 15660535
    ParentColor = False
    Layout = tlCenter
    OnClick = FormClick
    ExplicitWidth = 537
  end
  object Greek: TLabel
    Left = 2
    Top = 16
    Width = 470
    Height = 18
    AutoSize = False
    Caption = #945' '#946' '#947' '#948' '#949' '#950' '#951' '#952' '#953' '#954' '#955' '#956' '#957' '#958' '#959' '#960' '#961' '#963' '#964' '#965' '#966' '#967' '#968' '#969
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
  end
  object Latin: TLabel
    Left = 0
    Top = 40
    Width = 477
    Height = 18
    AutoSize = False
    Caption = 'a b g d e z h q i k l m n c o p r s t u f x y w'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
  end
end
