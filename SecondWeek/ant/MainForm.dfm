object MainWindow: TMainWindow
  Left = 221
  Top = 172
  Width = 696
  Height = 499
  Caption = 'Ant Colony Simulation'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  Menu = MainMenu1
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel1: TBevel
    Left = 152
    Top = 19
    Width = 529
    Height = 59
  end
  object GroupBoxAnt: TGroupBox
    Left = 8
    Top = 14
    Width = 140
    Height = 407
    TabOrder = 2
    object Bevel2: TBevel
      Left = 8
      Top = 344
      Width = 123
      Height = 9
      Shape = bsTopLine
    end
    object LabelEpoch: TLabel
      Left = 7
      Top = 136
      Width = 118
      Height = 49
      AutoSize = False
      Caption = 'Turn: -'
    end
    object Label1: TLabel
      Left = 8
      Top = 233
      Width = 102
      Height = 13
      Caption = 'Max. number of turns:'
    end
    object Label2: TLabel
      Left = 8
      Top = 288
      Width = 87
      Height = 13
      Caption = 'Food per turn rate:'
    end
    object Label3: TLabel
      Left = 30
      Top = 309
      Width = 8
      Height = 13
      Caption = 'in'
    end
    object Label4: TLabel
      Left = 101
      Top = 309
      Width = 23
      Height = 13
      Caption = 'turns'
    end
    object Restart: TButton
      Left = 32
      Top = 362
      Width = 75
      Height = 25
      Caption = 'Restart'
      TabOrder = 0
      OnClick = RestartMenuItemClick
    end
    object ScrollBoxMini: TScrollBox
      Left = 5
      Top = 24
      Width = 130
      Height = 97
      TabOrder = 1
      object ImagePreview: TImage
        Left = 0
        Top = 0
        Width = 126
        Height = 93
        Align = alClient
      end
    end
    object EditTurns: TEdit
      Left = 8
      Top = 249
      Width = 57
      Height = 21
      TabOrder = 2
      Text = '1000'
    end
    object EditRate: TEdit
      Left = 8
      Top = 304
      Width = 19
      Height = 21
      TabOrder = 3
      Text = '5'
    end
    object EditRange: TEdit
      Left = 43
      Top = 304
      Width = 53
      Height = 21
      TabOrder = 4
      Text = '100'
    end
  end
  object EditorScrollBox: TScrollBox
    Left = 152
    Top = 84
    Width = 529
    Height = 337
    TabOrder = 0
    object ImageEditor: TImage
      Left = 0
      Top = 0
      Width = 525
      Height = 333
      Align = alClient
      OnMouseDown = ImageEditorMouseDown
    end
  end
  object StatusBar: TStatusBar
    Left = 0
    Top = 434
    Width = 688
    Height = 19
    Panels = <>
    SimplePanel = False
  end
  object ButtonEvolute: TButton
    Left = 368
    Top = 40
    Width = 89
    Height = 25
    Caption = 'Start Simulation'
    TabOrder = 3
    OnClick = ButtonEvoluteClick
  end
  object MainMenu1: TMainMenu
    Left = 640
    Top = 88
    object FileMenuItem: TMenuItem
      Caption = '&Simulation'
      object OpenCivMenuItem: TMenuItem
        Caption = 'Load Environment...'
        OnClick = OpenCivMenuItemClick
      end
      object SaveCivMenuItem: TMenuItem
        Caption = 'Save Environment...'
        OnClick = SaveCivMenuItemClick
      end
      object N2: TMenuItem
        Caption = '-'
        Enabled = False
      end
      object AboutMenuItem: TMenuItem
        Caption = 'About...'
        OnClick = AboutMenuItemClick
      end
      object N1: TMenuItem
        Caption = '-'
        Enabled = False
      end
      object CloseMenuItem: TMenuItem
        Caption = 'Close'
        ShortCut = 32883
        OnClick = CloseMenuItemClick
      end
    end
    object CivMenuItem: TMenuItem
      Caption = '&Civilization'
      object EvoluteMenuItem: TMenuItem
        Caption = 'Start Simulation'
        ShortCut = 116
        OnClick = ButtonEvoluteClick
      end
      object RestartMenuItem: TMenuItem
        Caption = 'Restart'
        OnClick = RestartMenuItemClick
      end
    end
  end
  object OpenDialog: TOpenDialog
    DefaultExt = 'ant'
    Filter = 'Environment (*.ant)|*.ant'
    Options = [ofHideReadOnly, ofNoChangeDir, ofEnableSizing]
    Title = 'Loading Environment...'
    Left = 576
    Top = 88
  end
  object SaveDialog: TSaveDialog
    DefaultExt = 'ant'
    Filter = 'Environment (*.ant)|*.ant'
    Options = [ofHideReadOnly, ofNoChangeDir, ofEnableSizing]
    Title = 'Saving Environment...'
    Left = 608
    Top = 88
  end
end
