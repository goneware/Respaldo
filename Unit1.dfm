object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 327
  ClientWidth = 561
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 472
    Top = 24
    Width = 75
    Height = 25
    Caption = 'Lee CFDi'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 472
    Top = 72
    Width = 75
    Height = 25
    Caption = 'Salir'
    TabOrder = 1
    OnClick = Button2Click
  end
  object Memo1: TMemo
    Left = 0
    Top = 0
    Width = 441
    Height = 327
    Align = alLeft
    TabOrder = 2
  end
  object OpenDialog1: TOpenDialog
    Left = 352
    Top = 24
  end
end
