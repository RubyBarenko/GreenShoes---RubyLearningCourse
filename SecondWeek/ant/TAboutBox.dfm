object AboutBox: TAboutBox
  Left = 329
  Top = 223
  Width = 370
  Height = 291
  BorderIcons = [biSystemMenu]
  Caption = 'About...'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label2: TLabel
    Left = 8
    Top = 184
    Width = 114
    Height = 13
    Caption = 'Author:   Danilo Benzatti'
  end
  object Bevel1: TBevel
    Left = 8
    Top = 216
    Width = 345
    Height = 9
    Shape = bsBottomLine
  end
  object Label1: TLabel
    Left = 8
    Top = 200
    Width = 155
    Height = 13
    Caption = 'Contact: danilo@quaternions.net'
  end
  object ButtonOK: TButton
    Left = 125
    Top = 232
    Width = 75
    Height = 25
    Caption = 'OK'
    TabOrder = 0
    OnClick = ButtonOKClick
  end
  object Memo1: TMemo
    Left = 8
    Top = 16
    Width = 345
    Height = 161
    Color = clScrollBar
    Lines.Strings = (
      
        'This is a sample program to demonstrate the Emergent Intelligenc' +
        'e of a '
      'colony of ants applied to graph search.'
      ''
      'How to use:'
      ''
      
        '[LeftClick]                                                  : C' +
        'reate new city'
      
        '[Ctrl] + [LeftClick] on to cities in sequence : Create route bet' +
        'wwen cities'
      
        '[RightClick]                                                : Se' +
        't city as the Nest'
      
        '[Ctrl] + [RightClick]                                     : Set ' +
        'city as food source'
      ''
      ''
      
        '                                                                ' +
        '                                       July, '
      '2002')
    ReadOnly = True
    TabOrder = 1
  end
end
