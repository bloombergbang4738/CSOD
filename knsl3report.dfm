object TRepPower: TTRepPower
  Left = 378
  Top = 198
  Width = 1369
  Height = 601
  Caption = '�����'
  Color = clBtnFace
  Font.Charset = RUSSIAN_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Times New Roman'
  Font.Style = []
  FormStyle = fsMDIChild
  OldCreateOrder = False
  Position = poDefault
  Visible = True
  OnClose = OnCloseRep
  OnCreate = FormCreate
  OnResize = OnFormResize1
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 14
  object pcReport: TAdvOfficePager
    Left = 0
    Top = 33
    Width = 1361
    Height = 509
    AdvOfficePagerStyler = AdvOfficePagerOfficeStyler1
    Align = alClient
    ActivePage = tshCurrVals
    AntiAlias = aaNone
    ButtonSettings.CloseButtonPicture.Data = {
      424DA20400000000000036040000280000000900000009000000010008000000
      00006C000000C30E0000C30E00000001000000010000427B8400DEEFEF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0001000001010100000100
      0000000202000100020200000000000202020002020200000000010002020202
      0200010000000101000202020001010000000100020202020200010000000002
      0202000202020000000000020200010002020000000001000001010100000100
      0000}
    ButtonSettings.PageListButtonPicture.Data = {
      424DA20400000000000036040000280000000900000009000000010008000000
      00006C000000C30E0000C30E00000001000000010000427B8400DEEFEF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0001010101000101010100
      0000010101000200010101000000010100020202000101000000010002020202
      0200010000000002020200020202000000000002020001000202000000000100
      0001010100000100000001010101010101010100000001010101010101010100
      0000}
    ButtonSettings.ScrollButtonPrevPicture.Data = {
      424DA20400000000000036040000280000000900000009000000010008000000
      00006C000000C30E0000C30E00000001000000010000427B8400DEEFEF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0001010101000001010100
      0000010101000202000101000000010100020202000101000000010002020200
      0101010000000002020200010101010000000100020202000101010000000101
      0002020200010100000001010100020200010100000001010101000001010100
      0000}
    ButtonSettings.ScrollButtonNextPicture.Data = {
      424DA20400000000000036040000280000000900000009000000010008000000
      00006C000000C30E0000C30E00000001000000010000427B8400DEEFEF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0001010000010101010100
      0000010002020001010101000000010002020200010101000000010100020202
      0001010000000101010002020200010000000101000202020001010000000100
      0202020001010100000001000202000101010100000001010000010101010100
      0000}
    ButtonSettings.CloseButtonHint = 'Close'
    ButtonSettings.PageListButtonHint = 'Page List'
    ButtonSettings.ScrollButtonNextHint = 'Next'
    ButtonSettings.ScrollButtonPrevHint = 'Previous'
    CloseOnTabPosition = cpLeft
    Glow = False
    PageMargin = 0
    RotateTabLeftRight = False
    TabSettings.Alignment = taCenter
    TabSettings.LeftMargin = 0
    TabSettings.RightMargin = 0
    TabSettings.StartMargin = 0
    TabSettings.Spacing = 0
    TabSettings.WordWrap = True
    TabSettings.Shape = tsRightRamp
    TabSettings.Rounding = 0
    TabReorder = True
    ShowShortCutHints = False
    OnChange = pcReportChange
    OnResize = OnFormResize1
    TabOrder = 0
    TabStop = True
    NextPictureChanged = False
    PrevPictureChanged = False
    object AdvOfficePage1: TAdvOfficePage
      Left = 0
      Top = 26
      Width = 1361
      Height = 482
      Caption = '������'
      PageAppearance.BorderColor = 11841710
      PageAppearance.Color = 13616833
      PageAppearance.ColorTo = 12958644
      PageAppearance.ColorMirror = 12958644
      PageAppearance.ColorMirrorTo = 15527141
      PageAppearance.Gradient = ggVertical
      PageAppearance.GradientMirror = ggVertical
      TabAppearance.BorderColor = clNone
      TabAppearance.BorderColorHot = 9870494
      TabAppearance.BorderColorSelected = 14922381
      TabAppearance.BorderColorSelectedHot = 6343929
      TabAppearance.BorderColorDisabled = clNone
      TabAppearance.BorderColorDown = clNone
      TabAppearance.Color = clBtnFace
      TabAppearance.ColorTo = clWhite
      TabAppearance.ColorSelected = 15724269
      TabAppearance.ColorSelectedTo = 15724269
      TabAppearance.ColorDisabled = clWhite
      TabAppearance.ColorDisabledTo = clSilver
      TabAppearance.ColorHot = 5992568
      TabAppearance.ColorHotTo = 9803415
      TabAppearance.ColorMirror = clWhite
      TabAppearance.ColorMirrorTo = clWhite
      TabAppearance.ColorMirrorHot = 4413279
      TabAppearance.ColorMirrorHotTo = 1617645
      TabAppearance.ColorMirrorSelected = 13816526
      TabAppearance.ColorMirrorSelectedTo = 13816526
      TabAppearance.ColorMirrorDisabled = clWhite
      TabAppearance.ColorMirrorDisabledTo = clSilver
      TabAppearance.Font.Charset = DEFAULT_CHARSET
      TabAppearance.Font.Color = clWindowText
      TabAppearance.Font.Height = -11
      TabAppearance.Font.Name = 'Tahoma'
      TabAppearance.Font.Style = []
      TabAppearance.Gradient = ggVertical
      TabAppearance.GradientMirror = ggVertical
      TabAppearance.GradientHot = ggRadial
      TabAppearance.GradientMirrorHot = ggRadial
      TabAppearance.GradientSelected = ggVertical
      TabAppearance.GradientMirrorSelected = ggVertical
      TabAppearance.GradientDisabled = ggVertical
      TabAppearance.GradientMirrorDisabled = ggVertical
      TabAppearance.TextColor = clWhite
      TabAppearance.TextColorHot = clWhite
      TabAppearance.TextColorSelected = clBlack
      TabAppearance.TextColorDisabled = clGray
      TabAppearance.ShadowColor = clBlack
      TabAppearance.HighLightColor = 9803929
      TabAppearance.HighLightColorHot = 9803929
      TabAppearance.HighLightColorSelected = 6540536
      TabAppearance.HighLightColorSelectedHot = 12451839
      TabAppearance.HighLightColorDown = 16776144
      TabAppearance.BackGround.Color = 5460819
      TabAppearance.BackGround.ColorTo = 3815994
      TabAppearance.BackGround.Direction = gdVertical
    end
    object tshCurrVals: TAdvOfficePage
      Left = 0
      Top = 26
      Width = 1361
      Height = 482
      Caption = '������� ��������� ��������������'
      ImageIndex = 3
      PageAppearance.BorderColor = 11841710
      PageAppearance.Color = 13616833
      PageAppearance.ColorTo = 12958644
      PageAppearance.ColorMirror = 12958644
      PageAppearance.ColorMirrorTo = 15527141
      PageAppearance.Gradient = ggVertical
      PageAppearance.GradientMirror = ggVertical
      TabAppearance.BorderColor = clNone
      TabAppearance.BorderColorHot = 9870494
      TabAppearance.BorderColorSelected = 14922381
      TabAppearance.BorderColorSelectedHot = 6343929
      TabAppearance.BorderColorDisabled = clNone
      TabAppearance.BorderColorDown = clNone
      TabAppearance.Color = clBtnFace
      TabAppearance.ColorTo = clWhite
      TabAppearance.ColorSelected = 15724269
      TabAppearance.ColorSelectedTo = 15724269
      TabAppearance.ColorDisabled = clWhite
      TabAppearance.ColorDisabledTo = clSilver
      TabAppearance.ColorHot = 5992568
      TabAppearance.ColorHotTo = 9803415
      TabAppearance.ColorMirror = clWhite
      TabAppearance.ColorMirrorTo = clWhite
      TabAppearance.ColorMirrorHot = 4413279
      TabAppearance.ColorMirrorHotTo = 1617645
      TabAppearance.ColorMirrorSelected = 13816526
      TabAppearance.ColorMirrorSelectedTo = 13816526
      TabAppearance.ColorMirrorDisabled = clWhite
      TabAppearance.ColorMirrorDisabledTo = clSilver
      TabAppearance.Font.Charset = DEFAULT_CHARSET
      TabAppearance.Font.Color = clWindowText
      TabAppearance.Font.Height = -11
      TabAppearance.Font.Name = 'Tahoma'
      TabAppearance.Font.Style = []
      TabAppearance.Gradient = ggVertical
      TabAppearance.GradientMirror = ggVertical
      TabAppearance.GradientHot = ggRadial
      TabAppearance.GradientMirrorHot = ggRadial
      TabAppearance.GradientSelected = ggVertical
      TabAppearance.GradientMirrorSelected = ggVertical
      TabAppearance.GradientDisabled = ggVertical
      TabAppearance.GradientMirrorDisabled = ggVertical
      TabAppearance.TextColor = clWhite
      TabAppearance.TextColorHot = clWhite
      TabAppearance.TextColorSelected = clBlack
      TabAppearance.TextColorDisabled = clGray
      TabAppearance.ShadowColor = clBlack
      TabAppearance.HighLightColor = 9803929
      TabAppearance.HighLightColorHot = 9803929
      TabAppearance.HighLightColorSelected = 6540536
      TabAppearance.HighLightColorSelectedHot = 12451839
      TabAppearance.HighLightColorDown = 16776144
      TabAppearance.BackGround.Color = 5460819
      TabAppearance.BackGround.ColorTo = 3815994
      TabAppearance.BackGround.Direction = gdVertical
      object FsgStatistics: TAdvStringGrid
        Left = 2
        Top = 2
        Width = 1357
        Height = 466
        Cursor = crDefault
        Align = alClient
        DefaultRowHeight = 21
        RowCount = 5
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clAqua
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = []
        GridLineWidth = 0
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goDrawFocusSelected, goColSizing, goRowSelect]
        ParentFont = False
        ScrollBars = ssBoth
        TabOrder = 0
        GridLineColor = 15062992
        OnGetCellColor = FsgUsingGetCellColor
        ActiveCellFont.Charset = RUSSIAN_CHARSET
        ActiveCellFont.Color = clWindowText
        ActiveCellFont.Height = -11
        ActiveCellFont.Name = 'Times New Roman'
        ActiveCellFont.Style = [fsBold]
        ActiveCellColor = 10344697
        ActiveCellColorTo = 6210033
        Bands.Active = True
        Bands.PrimaryColor = 16445929
        CellNode.ShowTree = False
        ControlLook.FixedGradientFrom = 16250871
        ControlLook.FixedGradientTo = 14606046
        ControlLook.ControlStyle = csClassic
        EnhRowColMove = False
        Filter = <>
        FixedFont.Charset = RUSSIAN_CHARSET
        FixedFont.Color = clWindowText
        FixedFont.Height = -13
        FixedFont.Name = 'Tahoma'
        FixedFont.Style = [fsBold]
        FloatFormat = '%.2f'
        IntegralHeight = True
        PrintSettings.DateFormat = 'dd/mm/yyyy'
        PrintSettings.Font.Charset = DEFAULT_CHARSET
        PrintSettings.Font.Color = clWindowText
        PrintSettings.Font.Height = -11
        PrintSettings.Font.Name = 'MS Sans Serif'
        PrintSettings.Font.Style = []
        PrintSettings.FixedFont.Charset = DEFAULT_CHARSET
        PrintSettings.FixedFont.Color = clWindowText
        PrintSettings.FixedFont.Height = -11
        PrintSettings.FixedFont.Name = 'MS Sans Serif'
        PrintSettings.FixedFont.Style = []
        PrintSettings.HeaderFont.Charset = DEFAULT_CHARSET
        PrintSettings.HeaderFont.Color = clWindowText
        PrintSettings.HeaderFont.Height = -11
        PrintSettings.HeaderFont.Name = 'MS Sans Serif'
        PrintSettings.HeaderFont.Style = []
        PrintSettings.FooterFont.Charset = DEFAULT_CHARSET
        PrintSettings.FooterFont.Color = clWindowText
        PrintSettings.FooterFont.Height = -11
        PrintSettings.FooterFont.Name = 'MS Sans Serif'
        PrintSettings.FooterFont.Style = []
        PrintSettings.Borders = pbNoborder
        PrintSettings.Centered = False
        PrintSettings.PageNumSep = '/'
        RowIndicator.Data = {
          36040000424D3604000000000000360000002800000010000000100000000100
          20000000000000040000C40E0000C40E00000000000000000000FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF001F5C00FF1F5B00FF1F5C00FFFFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF001B6100FF156B06FF1D5F00FF205D00FFFFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00176301FF0D7910FF167510FF1B6001FF205D
          00FFFFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF001A6403FF057709FF097A0EFF157B16FF1A64
          03FF205B00FFFFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF001C6606FF0C861AFF007E0BFF068314FF1486
          1EFF186C0AFF1F5B00FF1F5D00FFFFFFFF00FFFFFF00FFFFFF001E5B00FF1F5D
          00FF1F5D00FF1F5D00FF1F5B00FF1F6C0DFF13952AFF008B17FF008A17FF038B
          1AFF129025FF177712FF1D5D00FF205D00FFFFFFFF00FFFFFF001D5C00FF0878
          0BFF058212FF058414FF058516FF0D9225FF079C2AFF009823FF009823FF0095
          20FF01931FFF0F982AFF17841DFF1C6102FF205C00FF1E5C00FF1C5C00FF078E
          1EFF009B24FF009F28FF00A32BFF00A42DFF00A42DFF00A52EFF00A42EFF00A1
          2CFF009E28FF009923FF0A9C2CFF148F25FF1A6A08FF1E5A00FF1B5C00FF2BA2
          42FF0DAA39FF05AA35FF01AD36FF00AF36FF00B037FF00B137FF00AF36FF00AD
          34FF00AA32FF01A630FF05A12DFF15A73BFF169127FF1C5B00FF195C00FF56BC
          6EFF39C86AFF32C766FF2FCB67FF29CA63FF23C65DFF23C65DFF23C55CFF25C3
          5BFF28C15AFF2CBE5BFF36C162FF229E39FF1A6707FFFFFFFF001A5B00FF3E9B
          45FF2FA748FF2AA645FF2AA746FF3BBE61FF4DDB85FF46D97FFF47D87EFF45D5
          7BFF48D57DFF50D581FF2C9D3EFF1B6002FFFFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF0028781BFF6CE8A0FF56E692FF56E390FF60E7
          99FF63DF93FF2C9135FF1A5900FFFFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF002B781DFF87F0B5FF6FEFA7FF7FF6B5FF6DDE
          97FF258124FFFFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF002D7B20FFAEF7CFFFADFED4FF70D28EFF1C70
          11FFFFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF002D7F23FFC5FFE3FF62BF77FF146303FFFFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF0020690DFF2E8F36FF155A00FFFFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00}
        ScrollWidth = 14
        SearchFooter.Color = 15921648
        SearchFooter.ColorTo = 13222589
        SearchFooter.FindNextCaption = 'Find &next'
        SearchFooter.FindPrevCaption = 'Find &previous'
        SearchFooter.Font.Charset = DEFAULT_CHARSET
        SearchFooter.Font.Color = clWindowText
        SearchFooter.Font.Height = -11
        SearchFooter.Font.Name = 'MS Sans Serif'
        SearchFooter.Font.Style = []
        SearchFooter.HighLightCaption = 'Highlight'
        SearchFooter.HintClose = 'Close'
        SearchFooter.HintFindNext = 'Find next occurence'
        SearchFooter.HintFindPrev = 'Find previous occurence'
        SearchFooter.HintHighlight = 'Highlight occurences'
        SearchFooter.MatchCaseCaption = 'Match case'
        SelectionColor = 6210033
        WordWrap = False
        ColWidths = (
          64
          64
          65
          64
          64)
        RowHeights = (
          21
          21
          21
          21
          21)
      end
    end
    object tshOptions: TAdvOfficePage
      Left = 0
      Top = 26
      Width = 1361
      Height = 482
      Caption = '��������� �������'
      ImageIndex = 5
      PageAppearance.BorderColor = 11841710
      PageAppearance.Color = 13616833
      PageAppearance.ColorTo = 12958644
      PageAppearance.ColorMirror = 12958644
      PageAppearance.ColorMirrorTo = 15527141
      PageAppearance.Gradient = ggVertical
      PageAppearance.GradientMirror = ggVertical
      TabAppearance.BorderColor = clNone
      TabAppearance.BorderColorHot = 9870494
      TabAppearance.BorderColorSelected = 14922381
      TabAppearance.BorderColorSelectedHot = 6343929
      TabAppearance.BorderColorDisabled = clNone
      TabAppearance.BorderColorDown = clNone
      TabAppearance.Color = clBtnFace
      TabAppearance.ColorTo = clWhite
      TabAppearance.ColorSelected = 15724269
      TabAppearance.ColorSelectedTo = 15724269
      TabAppearance.ColorDisabled = clWhite
      TabAppearance.ColorDisabledTo = clSilver
      TabAppearance.ColorHot = 5992568
      TabAppearance.ColorHotTo = 9803415
      TabAppearance.ColorMirror = clWhite
      TabAppearance.ColorMirrorTo = clWhite
      TabAppearance.ColorMirrorHot = 4413279
      TabAppearance.ColorMirrorHotTo = 1617645
      TabAppearance.ColorMirrorSelected = 13816526
      TabAppearance.ColorMirrorSelectedTo = 13816526
      TabAppearance.ColorMirrorDisabled = clWhite
      TabAppearance.ColorMirrorDisabledTo = clSilver
      TabAppearance.Font.Charset = DEFAULT_CHARSET
      TabAppearance.Font.Color = clWindowText
      TabAppearance.Font.Height = -11
      TabAppearance.Font.Name = 'Tahoma'
      TabAppearance.Font.Style = []
      TabAppearance.Gradient = ggVertical
      TabAppearance.GradientMirror = ggVertical
      TabAppearance.GradientHot = ggRadial
      TabAppearance.GradientMirrorHot = ggRadial
      TabAppearance.GradientSelected = ggVertical
      TabAppearance.GradientMirrorSelected = ggVertical
      TabAppearance.GradientDisabled = ggVertical
      TabAppearance.GradientMirrorDisabled = ggVertical
      TabAppearance.TextColor = clWhite
      TabAppearance.TextColorHot = clWhite
      TabAppearance.TextColorSelected = clBlack
      TabAppearance.TextColorDisabled = clGray
      TabAppearance.ShadowColor = clBlack
      TabAppearance.HighLightColor = 9803929
      TabAppearance.HighLightColorHot = 9803929
      TabAppearance.HighLightColorSelected = 6540536
      TabAppearance.HighLightColorSelectedHot = 12451839
      TabAppearance.HighLightColorDown = 16776144
      TabAppearance.BackGround.Color = 5460819
      TabAppearance.BackGround.ColorTo = 3815994
      TabAppearance.BackGround.Direction = gdVertical
      object Label1: TLabel
        Left = 24
        Top = 17
        Width = 108
        Height = 14
        Caption = '�������� �����������'
      end
      object Label9: TLabel
        Left = 24
        Top = 61
        Width = 70
        Height = 14
        Caption = '�������, ����'
      end
      object Label13: TLabel
        Left = 24
        Top = 104
        Width = 111
        Height = 14
        Caption = '������������ �������'
      end
      object Label2: TLabel
        Left = 24
        Top = 154
        Width = 82
        Height = 14
        Caption = '������� �������'
      end
      object Label12: TLabel
        Left = 24
        Top = 201
        Width = 79
        Height = 14
        Caption = '������ �������'
      end
      object Label11: TLabel
        Left = 376
        Top = 17
        Width = 79
        Height = 14
        Caption = '����� ��������'
      end
      object Label10: TLabel
        Left = 376
        Top = 59
        Width = 31
        Height = 14
        Caption = 'E-mail'
      end
      object Label14: TLabel
        Left = 376
        Top = 106
        Width = 29
        Height = 14
        Caption = '�����'
      end
      object Label3: TLabel
        Left = 376
        Top = 152
        Width = 81
        Height = 14
        Caption = '������� �������'
      end
      object Label4: TLabel
        Left = 24
        Top = 252
        Width = 195
        Height = 14
        Caption = '��� ��������� � ��������� �����������'
      end
      object Label6: TLabel
        Left = 376
        Top = 252
        Width = 108
        Height = 14
        Caption = '��� ������� � �������'
      end
      object Shape1: TShape
        Left = 480
        Top = 215
        Width = 25
        Height = 25
        Brush.Color = clAqua
        OnMouseDown = Shape1MouseDown
      end
      object Label5: TLabel
        Left = 512
        Top = 223
        Width = 100
        Height = 14
        Caption = '��������� � �������'
      end
      object Shape2: TShape
        Left = 616
        Top = 215
        Width = 25
        Height = 25
        Brush.Color = clTeal
        OnMouseDown = Shape2MouseDown
      end
      object Label8: TLabel
        Left = 656
        Top = 223
        Width = 106
        Height = 14
        Alignment = taCenter
        Caption = '��������� � ��������'
      end
      object Label7: TLabel
        Left = 176
        Top = 60
        Width = 59
        Height = 14
        Caption = '��� �������'
      end
      object Edit1: TEdit
        Left = 24
        Top = 31
        Width = 337
        Height = 22
        TabOrder = 0
        Text = '��� "������������� - 2000"'
      end
      object Edit4: TEdit
        Left = 24
        Top = 76
        Width = 145
        Height = 22
        TabOrder = 1
      end
      object Edit8: TEdit
        Left = 24
        Top = 120
        Width = 337
        Height = 22
        TabOrder = 2
      end
      object Edit2: TEdit
        Left = 24
        Top = 169
        Width = 337
        Height = 22
        TabOrder = 3
        Text = '������������� �������������1___________________________'
      end
      object Edit7: TEdit
        Left = 24
        Top = 217
        Width = 337
        Height = 22
        TabOrder = 4
        Text = '������������� �������������2___________________________'
      end
      object Edit6: TEdit
        Left = 376
        Top = 30
        Width = 337
        Height = 22
        TabOrder = 5
      end
      object Edit5: TEdit
        Left = 376
        Top = 76
        Width = 337
        Height = 22
        TabOrder = 6
      end
      object Edit9: TEdit
        Left = 376
        Top = 122
        Width = 337
        Height = 22
        TabOrder = 7
      end
      object Edit3: TEdit
        Left = 376
        Top = 168
        Width = 337
        Height = 22
        TabOrder = 8
        Text = '������������� �����������_____________________________'
      end
      object cbIsReadZeroTar1: TCheckBox
        Left = 376
        Top = 215
        Width = 97
        Height = 17
        Caption = '������� �����'
        TabOrder = 9
      end
      object Edit10: TEdit
        Left = 24
        Top = 268
        Width = 337
        Height = 22
        TabOrder = 10
      end
      object Edit11: TEdit
        Left = 376
        Top = 268
        Width = 337
        Height = 22
        TabOrder = 11
      end
      object edm_strObjCode: TEdit
        Left = 176
        Top = 76
        Width = 185
        Height = 22
        TabOrder = 12
      end
    end
    object tshHomeBalanse: TAdvOfficePage
      Left = 0
      Top = 26
      Width = 1361
      Height = 482
      Caption = '������ �� ����'
      PageAppearance.BorderColor = 11841710
      PageAppearance.Color = 13616833
      PageAppearance.ColorTo = 12958644
      PageAppearance.ColorMirror = 12958644
      PageAppearance.ColorMirrorTo = 15527141
      PageAppearance.Gradient = ggVertical
      PageAppearance.GradientMirror = ggVertical
      TabAppearance.BorderColor = clNone
      TabAppearance.BorderColorHot = 9870494
      TabAppearance.BorderColorSelected = 14922381
      TabAppearance.BorderColorSelectedHot = 6343929
      TabAppearance.BorderColorDisabled = clNone
      TabAppearance.BorderColorDown = clNone
      TabAppearance.Color = clBtnFace
      TabAppearance.ColorTo = clWhite
      TabAppearance.ColorSelected = 15724269
      TabAppearance.ColorSelectedTo = 15724269
      TabAppearance.ColorDisabled = clWhite
      TabAppearance.ColorDisabledTo = clSilver
      TabAppearance.ColorHot = 5992568
      TabAppearance.ColorHotTo = 9803415
      TabAppearance.ColorMirror = clWhite
      TabAppearance.ColorMirrorTo = clWhite
      TabAppearance.ColorMirrorHot = 4413279
      TabAppearance.ColorMirrorHotTo = 1617645
      TabAppearance.ColorMirrorSelected = 13816526
      TabAppearance.ColorMirrorSelectedTo = 13816526
      TabAppearance.ColorMirrorDisabled = clWhite
      TabAppearance.ColorMirrorDisabledTo = clSilver
      TabAppearance.Font.Charset = DEFAULT_CHARSET
      TabAppearance.Font.Color = clWindowText
      TabAppearance.Font.Height = -11
      TabAppearance.Font.Name = 'Tahoma'
      TabAppearance.Font.Style = []
      TabAppearance.Gradient = ggVertical
      TabAppearance.GradientMirror = ggVertical
      TabAppearance.GradientHot = ggRadial
      TabAppearance.GradientMirrorHot = ggRadial
      TabAppearance.GradientSelected = ggVertical
      TabAppearance.GradientMirrorSelected = ggVertical
      TabAppearance.GradientDisabled = ggVertical
      TabAppearance.GradientMirrorDisabled = ggVertical
      TabAppearance.TextColor = clWhite
      TabAppearance.TextColorHot = clWhite
      TabAppearance.TextColorSelected = clBlack
      TabAppearance.TextColorDisabled = clGray
      TabAppearance.ShadowColor = clBlack
      TabAppearance.HighLightColor = 9803929
      TabAppearance.HighLightColorHot = 9803929
      TabAppearance.HighLightColorSelected = 6540536
      TabAppearance.HighLightColorSelectedHot = 12451839
      TabAppearance.HighLightColorDown = 16776144
      TabAppearance.BackGround.Color = 5460819
      TabAppearance.BackGround.ColorTo = 3815994
      TabAppearance.BackGround.Direction = gdVertical
      object sgHomeBalanse: TAdvStringGrid
        Left = 2
        Top = 2
        Width = 1357
        Height = 478
        Cursor = crDefault
        Align = alClient
        DefaultRowHeight = 21
        RowCount = 5
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clAqua
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = []
        GridLineWidth = 0
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goColSizing, goRowSelect]
        ParentFont = False
        PopupMenu = pmTechYchetMTZ
        ScrollBars = ssBoth
        TabOrder = 0
        GridLineColor = 15062992
        OnGetCellColor = FsgUsingGetCellColor
        ActiveCellFont.Charset = RUSSIAN_CHARSET
        ActiveCellFont.Color = clWindowText
        ActiveCellFont.Height = -11
        ActiveCellFont.Name = 'Times New Roman'
        ActiveCellFont.Style = [fsBold]
        ActiveCellColor = 10344697
        ActiveCellColorTo = 6210033
        Bands.Active = True
        Bands.PrimaryColor = 16445929
        CellNode.ShowTree = False
        ControlLook.FixedGradientFrom = 16250871
        ControlLook.FixedGradientTo = 14606046
        ControlLook.ControlStyle = csClassic
        EnhRowColMove = False
        Filter = <>
        FixedFont.Charset = RUSSIAN_CHARSET
        FixedFont.Color = clWindowText
        FixedFont.Height = -13
        FixedFont.Name = 'Tahoma'
        FixedFont.Style = [fsBold]
        FloatFormat = '%.2f'
        PrintSettings.DateFormat = 'dd/mm/yyyy'
        PrintSettings.Font.Charset = DEFAULT_CHARSET
        PrintSettings.Font.Color = clWindowText
        PrintSettings.Font.Height = -11
        PrintSettings.Font.Name = 'MS Sans Serif'
        PrintSettings.Font.Style = []
        PrintSettings.FixedFont.Charset = DEFAULT_CHARSET
        PrintSettings.FixedFont.Color = clWindowText
        PrintSettings.FixedFont.Height = -11
        PrintSettings.FixedFont.Name = 'MS Sans Serif'
        PrintSettings.FixedFont.Style = []
        PrintSettings.HeaderFont.Charset = DEFAULT_CHARSET
        PrintSettings.HeaderFont.Color = clWindowText
        PrintSettings.HeaderFont.Height = -11
        PrintSettings.HeaderFont.Name = 'MS Sans Serif'
        PrintSettings.HeaderFont.Style = []
        PrintSettings.FooterFont.Charset = DEFAULT_CHARSET
        PrintSettings.FooterFont.Color = clWindowText
        PrintSettings.FooterFont.Height = -11
        PrintSettings.FooterFont.Name = 'MS Sans Serif'
        PrintSettings.FooterFont.Style = []
        PrintSettings.Borders = pbNoborder
        PrintSettings.Centered = False
        PrintSettings.PageNumSep = '/'
        RowIndicator.Data = {
          36040000424D3604000000000000360000002800000010000000100000000100
          20000000000000040000C40E0000C40E00000000000000000000FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF001F5C00FF1F5B00FF1F5C00FFFFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF001B6100FF156B06FF1D5F00FF205D00FFFFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00176301FF0D7910FF167510FF1B6001FF205D
          00FFFFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF001A6403FF057709FF097A0EFF157B16FF1A64
          03FF205B00FFFFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF001C6606FF0C861AFF007E0BFF068314FF1486
          1EFF186C0AFF1F5B00FF1F5D00FFFFFFFF00FFFFFF00FFFFFF001E5B00FF1F5D
          00FF1F5D00FF1F5D00FF1F5B00FF1F6C0DFF13952AFF008B17FF008A17FF038B
          1AFF129025FF177712FF1D5D00FF205D00FFFFFFFF00FFFFFF001D5C00FF0878
          0BFF058212FF058414FF058516FF0D9225FF079C2AFF009823FF009823FF0095
          20FF01931FFF0F982AFF17841DFF1C6102FF205C00FF1E5C00FF1C5C00FF078E
          1EFF009B24FF009F28FF00A32BFF00A42DFF00A42DFF00A52EFF00A42EFF00A1
          2CFF009E28FF009923FF0A9C2CFF148F25FF1A6A08FF1E5A00FF1B5C00FF2BA2
          42FF0DAA39FF05AA35FF01AD36FF00AF36FF00B037FF00B137FF00AF36FF00AD
          34FF00AA32FF01A630FF05A12DFF15A73BFF169127FF1C5B00FF195C00FF56BC
          6EFF39C86AFF32C766FF2FCB67FF29CA63FF23C65DFF23C65DFF23C55CFF25C3
          5BFF28C15AFF2CBE5BFF36C162FF229E39FF1A6707FFFFFFFF001A5B00FF3E9B
          45FF2FA748FF2AA645FF2AA746FF3BBE61FF4DDB85FF46D97FFF47D87EFF45D5
          7BFF48D57DFF50D581FF2C9D3EFF1B6002FFFFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF0028781BFF6CE8A0FF56E692FF56E390FF60E7
          99FF63DF93FF2C9135FF1A5900FFFFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF002B781DFF87F0B5FF6FEFA7FF7FF6B5FF6DDE
          97FF258124FFFFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF002D7B20FFAEF7CFFFADFED4FF70D28EFF1C70
          11FFFFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF002D7F23FFC5FFE3FF62BF77FF146303FFFFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF0020690DFF2E8F36FF155A00FFFFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00}
        ScrollWidth = 14
        SearchFooter.Color = 15921648
        SearchFooter.ColorTo = 13222589
        SearchFooter.FindNextCaption = 'Find &next'
        SearchFooter.FindPrevCaption = 'Find &previous'
        SearchFooter.Font.Charset = DEFAULT_CHARSET
        SearchFooter.Font.Color = clWindowText
        SearchFooter.Font.Height = -11
        SearchFooter.Font.Name = 'MS Sans Serif'
        SearchFooter.Font.Style = []
        SearchFooter.HighLightCaption = 'Highlight'
        SearchFooter.HintClose = 'Close'
        SearchFooter.HintFindNext = 'Find next occurence'
        SearchFooter.HintFindPrev = 'Find previous occurence'
        SearchFooter.HintHighlight = 'Highlight occurences'
        SearchFooter.MatchCaseCaption = 'Match case'
        SelectionColor = 6210033
        WordWrap = False
        ColWidths = (
          64
          266
          125
          125
          122)
        RowHeights = (
          21
          21
          21
          21
          21)
      end
    end
    object tshAnalisBalansObj: TAdvOfficePage
      Left = 0
      Top = 26
      Width = 1361
      Height = 482
      Caption = '������ ������� ����������� �� �������'
      PageAppearance.BorderColor = 11841710
      PageAppearance.Color = 13616833
      PageAppearance.ColorTo = 12958644
      PageAppearance.ColorMirror = 12958644
      PageAppearance.ColorMirrorTo = 15527141
      PageAppearance.Gradient = ggVertical
      PageAppearance.GradientMirror = ggVertical
      TabAppearance.BorderColor = clNone
      TabAppearance.BorderColorHot = 9870494
      TabAppearance.BorderColorSelected = 14922381
      TabAppearance.BorderColorSelectedHot = 6343929
      TabAppearance.BorderColorDisabled = clNone
      TabAppearance.BorderColorDown = clNone
      TabAppearance.Color = clBtnFace
      TabAppearance.ColorTo = clWhite
      TabAppearance.ColorSelected = 15724269
      TabAppearance.ColorSelectedTo = 15724269
      TabAppearance.ColorDisabled = clWhite
      TabAppearance.ColorDisabledTo = clSilver
      TabAppearance.ColorHot = 5992568
      TabAppearance.ColorHotTo = 9803415
      TabAppearance.ColorMirror = clWhite
      TabAppearance.ColorMirrorTo = clWhite
      TabAppearance.ColorMirrorHot = 4413279
      TabAppearance.ColorMirrorHotTo = 1617645
      TabAppearance.ColorMirrorSelected = 13816526
      TabAppearance.ColorMirrorSelectedTo = 13816526
      TabAppearance.ColorMirrorDisabled = clWhite
      TabAppearance.ColorMirrorDisabledTo = clSilver
      TabAppearance.Font.Charset = DEFAULT_CHARSET
      TabAppearance.Font.Color = clWindowText
      TabAppearance.Font.Height = -11
      TabAppearance.Font.Name = 'Tahoma'
      TabAppearance.Font.Style = []
      TabAppearance.Gradient = ggVertical
      TabAppearance.GradientMirror = ggVertical
      TabAppearance.GradientHot = ggRadial
      TabAppearance.GradientMirrorHot = ggRadial
      TabAppearance.GradientSelected = ggVertical
      TabAppearance.GradientMirrorSelected = ggVertical
      TabAppearance.GradientDisabled = ggVertical
      TabAppearance.GradientMirrorDisabled = ggVertical
      TabAppearance.TextColor = clWhite
      TabAppearance.TextColorHot = clWhite
      TabAppearance.TextColorSelected = clBlack
      TabAppearance.TextColorDisabled = clGray
      TabAppearance.ShadowColor = clBlack
      TabAppearance.HighLightColor = 9803929
      TabAppearance.HighLightColorHot = 9803929
      TabAppearance.HighLightColorSelected = 6540536
      TabAppearance.HighLightColorSelectedHot = 12451839
      TabAppearance.HighLightColorDown = 16776144
      TabAppearance.BackGround.Color = 5460819
      TabAppearance.BackGround.ColorTo = 3815994
      TabAppearance.BackGround.Direction = gdVertical
      object AdvOfficeRadioGroup1: TAdvOfficeRadioGroup
        Left = 32
        Top = 48
        Width = 249
        Height = 80
        Version = '1.1.1.4'
        Caption = '����� �������'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentCtl3D = True
        ParentFont = False
        TabOrder = 0
        Ellipsis = False
        ItemIndex = 0
        Items.Strings = (
          '������ �������'
          '������ ������� �� �������')
      end
    end
    object tshErrorMeterRegion: TAdvOfficePage
      Left = 0
      Top = 26
      Width = 1361
      Height = 482
      Caption = '����� � ������������ ��������� �� ����� ������'
      PageAppearance.BorderColor = 11841710
      PageAppearance.Color = 13616833
      PageAppearance.ColorTo = 12958644
      PageAppearance.ColorMirror = 12958644
      PageAppearance.ColorMirrorTo = 15527141
      PageAppearance.Gradient = ggVertical
      PageAppearance.GradientMirror = ggVertical
      TabAppearance.BorderColor = clNone
      TabAppearance.BorderColorHot = 9870494
      TabAppearance.BorderColorSelected = 14922381
      TabAppearance.BorderColorSelectedHot = 6343929
      TabAppearance.BorderColorDisabled = clNone
      TabAppearance.BorderColorDown = clNone
      TabAppearance.Color = clBtnFace
      TabAppearance.ColorTo = clWhite
      TabAppearance.ColorSelected = 15724269
      TabAppearance.ColorSelectedTo = 15724269
      TabAppearance.ColorDisabled = clWhite
      TabAppearance.ColorDisabledTo = clSilver
      TabAppearance.ColorHot = 5992568
      TabAppearance.ColorHotTo = 9803415
      TabAppearance.ColorMirror = clWhite
      TabAppearance.ColorMirrorTo = clWhite
      TabAppearance.ColorMirrorHot = 4413279
      TabAppearance.ColorMirrorHotTo = 1617645
      TabAppearance.ColorMirrorSelected = 13816526
      TabAppearance.ColorMirrorSelectedTo = 13816526
      TabAppearance.ColorMirrorDisabled = clWhite
      TabAppearance.ColorMirrorDisabledTo = clSilver
      TabAppearance.Font.Charset = DEFAULT_CHARSET
      TabAppearance.Font.Color = clWindowText
      TabAppearance.Font.Height = -11
      TabAppearance.Font.Name = 'Tahoma'
      TabAppearance.Font.Style = []
      TabAppearance.Gradient = ggVertical
      TabAppearance.GradientMirror = ggVertical
      TabAppearance.GradientHot = ggRadial
      TabAppearance.GradientMirrorHot = ggRadial
      TabAppearance.GradientSelected = ggVertical
      TabAppearance.GradientMirrorSelected = ggVertical
      TabAppearance.GradientDisabled = ggVertical
      TabAppearance.GradientMirrorDisabled = ggVertical
      TabAppearance.TextColor = clWhite
      TabAppearance.TextColorHot = clWhite
      TabAppearance.TextColorSelected = clBlack
      TabAppearance.TextColorDisabled = clGray
      TabAppearance.ShadowColor = clBlack
      TabAppearance.HighLightColor = 9803929
      TabAppearance.HighLightColorHot = 9803929
      TabAppearance.HighLightColorSelected = 6540536
      TabAppearance.HighLightColorSelectedHot = 12451839
      TabAppearance.HighLightColorDown = 16776144
      TabAppearance.BackGround.Color = 5460819
      TabAppearance.BackGround.ColorTo = 3815994
      TabAppearance.BackGround.Direction = gdVertical
      object RTFLabel4: TRTFLabel
        Left = 16
        Top = 32
        Width = 225
        Height = 17
        RichText = 
          '{\rtf1\ansi\deff0{\fonttbl{\f0\fnil\fcharset204{\*\fname Arial;}' +
          'Arial CYR;}{\f1\fnil\fcharset0 Bell MT;}{\f2\fnil Arial;}}'#13#10'\vie' +
          'wkind4\uc1\pard\lang1049\f0\fs20\'#39'cf\'#39'f0\'#39'ee\'#39'e3\'#39'f0\'#39'e5\'#39'f1\'#39'f1' +
          '\f1  \f0\'#39'f4\'#39'ee\'#39'f0\'#39'ec\'#39'e8\'#39'f0\'#39'ee\'#39'e2\'#39'e0\'#39'ed\'#39'e8\'#39'ff\f1  \f0' +
          '\'#39'ee\'#39'f2\'#39'f7\'#39'e5\'#39'f2\'#39'e0\f1 :\f2\fs16 '#13#10'\par }'#13#10#0
        WordWrap = False
        Version = '1.3.0.0'
      end
      object AdvProgress3: TAdvProgress
        Left = 16
        Top = 64
        Width = 233
        Height = 17
        Min = 0
        Max = 100
        TabOrder = 0
        BarColor = clHighlight
        BkColor = clWindow
        Version = '1.2.0.0'
      end
    end
    object tshErrorReportDay: TAdvOfficePage
      Left = 0
      Top = 26
      Width = 1361
      Height = 482
      Caption = '����� �� ������� ������ ��������� �� ����'
      PageAppearance.BorderColor = 11841710
      PageAppearance.Color = 13616833
      PageAppearance.ColorTo = 12958644
      PageAppearance.ColorMirror = 12958644
      PageAppearance.ColorMirrorTo = 15527141
      PageAppearance.Gradient = ggVertical
      PageAppearance.GradientMirror = ggVertical
      TabAppearance.BorderColor = clNone
      TabAppearance.BorderColorHot = 9870494
      TabAppearance.BorderColorSelected = 14922381
      TabAppearance.BorderColorSelectedHot = 6343929
      TabAppearance.BorderColorDisabled = clNone
      TabAppearance.BorderColorDown = clNone
      TabAppearance.Color = clBtnFace
      TabAppearance.ColorTo = clWhite
      TabAppearance.ColorSelected = 15724269
      TabAppearance.ColorSelectedTo = 15724269
      TabAppearance.ColorDisabled = clWhite
      TabAppearance.ColorDisabledTo = clSilver
      TabAppearance.ColorHot = 5992568
      TabAppearance.ColorHotTo = 9803415
      TabAppearance.ColorMirror = clWhite
      TabAppearance.ColorMirrorTo = clWhite
      TabAppearance.ColorMirrorHot = 4413279
      TabAppearance.ColorMirrorHotTo = 1617645
      TabAppearance.ColorMirrorSelected = 13816526
      TabAppearance.ColorMirrorSelectedTo = 13816526
      TabAppearance.ColorMirrorDisabled = clWhite
      TabAppearance.ColorMirrorDisabledTo = clSilver
      TabAppearance.Font.Charset = DEFAULT_CHARSET
      TabAppearance.Font.Color = clWindowText
      TabAppearance.Font.Height = -11
      TabAppearance.Font.Name = 'Tahoma'
      TabAppearance.Font.Style = []
      TabAppearance.Gradient = ggVertical
      TabAppearance.GradientMirror = ggVertical
      TabAppearance.GradientHot = ggRadial
      TabAppearance.GradientMirrorHot = ggRadial
      TabAppearance.GradientSelected = ggVertical
      TabAppearance.GradientMirrorSelected = ggVertical
      TabAppearance.GradientDisabled = ggVertical
      TabAppearance.GradientMirrorDisabled = ggVertical
      TabAppearance.TextColor = clWhite
      TabAppearance.TextColorHot = clWhite
      TabAppearance.TextColorSelected = clBlack
      TabAppearance.TextColorDisabled = clGray
      TabAppearance.ShadowColor = clBlack
      TabAppearance.HighLightColor = 9803929
      TabAppearance.HighLightColorHot = 9803929
      TabAppearance.HighLightColorSelected = 6540536
      TabAppearance.HighLightColorSelectedHot = 12451839
      TabAppearance.HighLightColorDown = 16776144
      TabAppearance.BackGround.Color = 5460819
      TabAppearance.BackGround.ColorTo = 3815994
      TabAppearance.BackGround.Direction = gdVertical
      object RTFLabel1: TRTFLabel
        Left = 16
        Top = 16
        Width = 105
        Height = 17
        RichText = 
          '{\rtf1\ansi\ansicpg1251\deff0{\fonttbl{\f0\fnil\fcharset204 Aria' +
          'l CYR;}{\f1\fnil\fcharset0 Bodoni MT;}{\f2\fnil Arial;}}'#13#10'\viewk' +
          'ind4\uc1\pard\lang1049\f0\fs20\'#39'c2\'#39'fb\'#39'e1\'#39'e5\'#39'f0\'#39'e8\'#39'f2\'#39'e5\f' +
          '1  \f0\'#39'e4\'#39'e0\'#39'f2\'#39'f3\f1\fs16 :\f2 '#13#10'\par }'#13#10#0
        WordWrap = False
        Version = '1.3.0.0'
      end
      object RTFLabel2: TRTFLabel
        Left = 16
        Top = 80
        Width = 257
        Height = 17
        RichText = 
          '{\rtf1\ansi\ansicpg1251\deff0{\fonttbl{\f0\fnil\fcharset204{\*\f' +
          'name Arial;}Arial CYR;}{\f1\fnil\fcharset0 Bodoni MT;}{\f2\fnil ' +
          'Arial;}}'#13#10'\viewkind4\uc1\pard\lang1049\f0\fs20\'#39'cf\'#39'f0\'#39'ee\'#39'e3\'#39 +
          'f0\'#39'e5\'#39'f1\'#39'f1 \'#39'f4\'#39'ee\'#39'f0\'#39'ec\'#39'e8\'#39'f0\'#39'ee\'#39'e2\'#39'e0\'#39'ed\'#39'e8\'#39'ff\' +
          'f1  \f0\'#39'ee\'#39'f2\'#39'f7\'#39'e5\'#39'f2\'#39'e0\f1\fs16 :\f2 '#13#10'\par }'#13#10#0
        WordWrap = False
        Version = '1.3.0.0'
      end
      object DateTimePicker_Err: TDateTimePicker
        Left = 16
        Top = 34
        Width = 89
        Height = 21
        CalAlignment = dtaLeft
        Date = 40427.5278374537
        Time = 40427.5278374537
        DateFormat = dfShort
        DateMode = dmComboBox
        Kind = dtkDate
        ParseInput = False
        TabOrder = 0
        OnChange = dtBeginChange
      end
      object AdvProgress1: TAdvProgress
        Left = 16
        Top = 112
        Width = 257
        Height = 17
        Min = 0
        Max = 100
        TabOrder = 1
        BarColor = clHighlight
        BkColor = clWindow
        Version = '1.2.0.0'
      end
    end
    object RTFLabel3: TRTFLabel
      Left = 16
      Top = 80
      Width = 257
      Height = 17
      RichText = 
        '{\rtf1\ansi\ansicpg1251\deff0{\fonttbl{\f0\fnil\fcharset204{\*\f' +
        'name Arial;}Arial CYR;}{\f1\fnil\fcharset0 Bodoni MT;}{\f2\fnil ' +
        'Arial;}}'#13#10'\viewkind4\uc1\pard\lang1049\f0\fs20\'#39'cf\'#39'f0\'#39'ee\'#39'e3\'#39 +
        'f0\'#39'e5\'#39'f1\'#39'f1 \'#39'f4\'#39'ee\'#39'f0\'#39'ec\'#39'e8\'#39'f0\'#39'ee\'#39'e2\'#39'e0\'#39'ed\'#39'e8\'#39'ff\' +
        'f1  \f0\'#39'ee\'#39'f2\'#39'f7\'#39'e5\'#39'f2\'#39'e0\f1\fs16 :\f2 '#13#10'\par }'#13#10#0
      WordWrap = False
      Version = '1.3.0.0'
    end
    object AdvProgress2: TAdvProgress
      Left = 16
      Top = 80
      Width = 150
      Height = 17
      Min = 0
      Max = 100
      TabOrder = 6
      BarColor = clHighlight
      BkColor = clWindow
      Version = '1.2.0.0'
    end
  end
  object AdvPanel1: TAdvPanel
    Left = 0
    Top = 542
    Width = 1361
    Height = 25
    Align = alBottom
    BevelOuter = bvNone
    Color = 13616833
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 7485192
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    UseDockManager = True
    Version = '1.7.9.0'
    BorderColor = 16765615
    Caption.Color = 12105910
    Caption.ColorTo = 10526878
    Caption.Font.Charset = DEFAULT_CHARSET
    Caption.Font.Color = clWhite
    Caption.Font.Height = -11
    Caption.Font.Name = 'MS Sans Serif'
    Caption.Font.Style = []
    Caption.GradientDirection = gdVertical
    Caption.Indent = 2
    Caption.ShadeLight = 255
    CollapsColor = clHighlight
    CollapsDelay = 0
    ColorTo = 12958644
    ColorMirror = 12958644
    ColorMirrorTo = 15527141
    ShadowColor = clBlack
    ShadowOffset = 0
    StatusBar.BorderStyle = bsSingle
    StatusBar.Font.Charset = DEFAULT_CHARSET
    StatusBar.Font.Color = clWhite
    StatusBar.Font.Height = -11
    StatusBar.Font.Name = 'Tahoma'
    StatusBar.Font.Style = []
    StatusBar.Color = 10592158
    StatusBar.ColorTo = 5459275
    StatusBar.GradientDirection = gdVertical
    Styler = ReportPanelStyler
    FullHeight = 0
    object BalanceLabel1: TLabel
      Left = 848
      Top = 6
      Width = 53
      Height = 13
      Caption = '������: � '
      Visible = False
    end
    object BalanceLabel2: TLabel
      Left = 1272
      Top = 6
      Width = 12
      Height = 13
      Caption = '��'
      Visible = False
    end
    object cb_Precision: TComboBox
      Left = 7
      Top = 3
      Width = 122
      Height = 21
      Cursor = crHandPoint
      Style = csDropDownList
      Anchors = [akLeft, akTop, akBottom]
      DropDownCount = 6
      ItemHeight = 13
      TabOrder = 11
      Visible = False
      Items.Strings = (
        '�� �����'
        '1'
        '2'
        '3'
        '4'
        '5')
    end
    object cbTarifRp: TComboBox
      Left = 16
      Top = 2
      Width = 145
      Height = 22
      Style = csDropDownList
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Times New Roman'
      Font.Style = []
      ItemHeight = 14
      ParentFont = False
      TabOrder = 0
      OnChange = pcReportChange
      Items.Strings = (
        '����� �� ������'
        '����� �� �����������')
    end
    object cbKindRP: TComboBox
      Left = 72
      Top = 2
      Width = 257
      Height = 22
      Style = csDropDownList
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Times New Roman'
      Font.Style = []
      ItemHeight = 14
      ParentFont = False
      TabOrder = 1
      OnChange = cbKindRPChange
      Items.Strings = (
        '��� ������'
        '����� �����')
    end
    object cbGroup: TComboBox
      Left = 264
      Top = 2
      Width = 215
      Height = 22
      Style = csDropDownList
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Times New Roman'
      Font.Style = []
      ItemHeight = 14
      ParentFont = False
      TabOrder = 2
      OnChange = cbGroupChange
    end
    object cbYear: TComboBox
      Left = 496
      Top = 2
      Width = 89
      Height = 22
      Style = csDropDownList
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Times New Roman'
      Font.Style = []
      ItemHeight = 14
      ParentFont = False
      TabOrder = 3
      OnChange = cbYearChange
      Items.Strings = (
        '2010'
        '2011'
        '2012')
    end
    object dtEnd: TDateTimePicker
      Left = 592
      Top = 2
      Width = 89
      Height = 22
      CalAlignment = dtaLeft
      Date = 40427.527884838
      Time = 40427.527884838
      DateFormat = dfShort
      DateMode = dmComboBox
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Times New Roman'
      Font.Style = []
      Kind = dtkDate
      ParseInput = False
      ParentFont = False
      TabOrder = 4
      OnChange = dtEndChange
    end
    object cbKindEnerg: TComboBox
      Left = 696
      Top = 2
      Width = 145
      Height = 22
      Style = csDropDownList
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Times New Roman'
      Font.Style = []
      ItemHeight = 14
      ParentFont = False
      TabOrder = 5
      OnChange = cbKindEnergChange
      Items.Strings = (
        '�������� ����������� �������'
        '�������� ���������� �������'
        '���������� ����������� �������'
        '���������� ���������� �������')
    end
    object cbMonth: TComboBox
      Left = 456
      Top = 2
      Width = 89
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 6
      OnChange = cbMonthChange
      Items.Strings = (
        '������'
        '�������'
        '����'
        '������'
        '���'
        '����'
        '����'
        '������'
        '��������'
        '�������'
        '������'
        '�������')
    end
    object dtBegin: TDateTimePicker
      Left = 592
      Top = 2
      Width = 89
      Height = 21
      CalAlignment = dtaLeft
      Date = 40427.5278374537
      Time = 40427.5278374537
      DateFormat = dfShort
      DateMode = dmComboBox
      Kind = dtkDate
      ParseInput = False
      TabOrder = 7
      OnChange = dtBeginChange
    end
    object cb_AP: TAdvOfficeCheckBox
      Left = 8
      Top = 0
      Width = 41
      Height = 20
      Alignment = taLeftJustify
      Caption = 'A+'
      ReturnIsTab = False
      State = cbChecked
      TabOrder = 8
      OnClick = cb_APClick
      Version = '1.1.1.4'
      Checked = True
    end
    object cb_AM: TAdvOfficeCheckBox
      Left = 49
      Top = 0
      Width = 41
      Height = 20
      Alignment = taLeftJustify
      Caption = 'A-'
      ReturnIsTab = False
      State = cbChecked
      TabOrder = 9
      OnClick = cb_AMClick
      Version = '1.1.1.4'
      Checked = True
    end
    object cb_RP: TAdvOfficeCheckBox
      Left = 89
      Top = 0
      Width = 41
      Height = 20
      Alignment = taLeftJustify
      Caption = 'R+'
      ReturnIsTab = False
      State = cbChecked
      TabOrder = 10
      OnClick = cb_RPClick
      Version = '1.1.1.4'
      Checked = True
    end
    object cbVectorTime: TComboBox
      Left = 168
      Top = 3
      Width = 89
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 12
      Visible = False
    end
    object cb_WithKT: TCheckBox
      Left = 258
      Top = 5
      Width = 190
      Height = 17
      Caption = '� ������ ������������� �������������'
      TabOrder = 13
    end
    object cb_RM: TAdvOfficeCheckBox
      Left = 128
      Top = 0
      Width = 41
      Height = 20
      Alignment = taLeftJustify
      Caption = 'R-'
      ReturnIsTab = False
      State = cbChecked
      TabOrder = 14
      OnClick = cb_RMClick
      Version = '1.1.1.4'
      Checked = True
    end
    object ProgressBar1: TAdvProgress
      Left = 0
      Top = 0
      Width = 129
      Height = 25
      Min = 0
      Max = 100
      TabOrder = 15
      Visible = False
      BarColor = clHighlight
      BkColor = clWindow
      Version = '1.2.0.0'
    end
    object BalanceCheckBox: TCheckBox
      Left = 232
      Top = 3
      Width = 209
      Height = 18
      Caption = '����������� �� �������� �����'
      TabOrder = 16
      OnClick = BalanceCheckBoxClick
    end
    object BalanseDateTimePicker1: TDateTimePicker
      Left = 864
      Top = 2
      Width = 105
      Height = 21
      CalAlignment = dtaLeft
      Date = 43629.5212867014
      Time = 43629.5212867014
      DateFormat = dfShort
      DateMode = dmComboBox
      Kind = dtkDate
      ParseInput = False
      TabOrder = 17
    end
    object BalanseDateTimePicker2: TDateTimePicker
      Left = 992
      Top = 2
      Width = 105
      Height = 21
      CalAlignment = dtaLeft
      Date = 43629.5217500347
      Time = 43629.5217500347
      DateFormat = dfShort
      DateMode = dmComboBox
      Kind = dtkDate
      ParseInput = False
      TabOrder = 18
    end
  end
  object AdvPanel2: TAdvPanel
    Left = 0
    Top = 0
    Width = 1361
    Height = 33
    Align = alTop
    BevelOuter = bvNone
    Color = 13616833
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 7485192
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    UseDockManager = True
    Version = '1.7.9.0'
    BorderColor = 16765615
    Caption.Color = 12105910
    Caption.ColorTo = 10526878
    Caption.Font.Charset = DEFAULT_CHARSET
    Caption.Font.Color = clWhite
    Caption.Font.Height = -11
    Caption.Font.Name = 'MS Sans Serif'
    Caption.Font.Style = []
    Caption.GradientDirection = gdVertical
    Caption.Indent = 2
    Caption.ShadeLight = 255
    CollapsColor = clHighlight
    CollapsDelay = 0
    ColorTo = 12958644
    ColorMirror = 12958644
    ColorMirrorTo = 15527141
    ShadowColor = clBlack
    ShadowOffset = 0
    StatusBar.BorderStyle = bsSingle
    StatusBar.Font.Charset = DEFAULT_CHARSET
    StatusBar.Font.Color = clWhite
    StatusBar.Font.Height = -11
    StatusBar.Font.Name = 'Tahoma'
    StatusBar.Font.Style = []
    StatusBar.Color = 10592158
    StatusBar.ColorTo = 5459275
    StatusBar.GradientDirection = gdVertical
    Styler = ReportPanelStyler
    FullHeight = 0
    object v_lblCaption: TLabel
      Left = 104
      Top = 8
      Width = 4
      Height = 19
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clTeal
      Font.Height = -16
      Font.Name = 'Times New Roman'
      Font.Style = [fsItalic]
      ParentFont = False
      Transparent = True
    end
    object lb_L2KoncPassw: TLabel
      Left = 103
      Top = 6
      Width = 55
      Height = 19
      Caption = '������:'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Times New Roman'
      Font.Style = []
      ParentFont = False
      Transparent = True
    end
    object AdvToolBar1: TAdvToolBar
      Left = -1
      Top = -1
      Width = 112
      Height = 32
      AllowFloating = True
      CaptionFont.Charset = DEFAULT_CHARSET
      CaptionFont.Color = clWindowText
      CaptionFont.Height = -11
      CaptionFont.Name = 'MS Sans Serif'
      CaptionFont.Style = []
      CaptionAlignment = taCenter
      CompactImageIndex = -1
      DockableTo = []
      TextAutoOptionMenu = 'Add or Remove Buttons'
      TextOptionMenu = 'Options'
      ToolBarStyler = AdvToolBarOfficeStyler1
      ParentStyler = False
      Images = imgDataView
      ParentOptionPicture = True
      ParentShowHint = False
      ToolBarIndex = -1
      object tbShowReport: TAdvToolBarButton
        Left = 2
        Top = 2
        Width = 24
        Height = 28
        Hint = '������� �����'
        Appearance.CaptionFont.Charset = DEFAULT_CHARSET
        Appearance.CaptionFont.Color = clWindowText
        Appearance.CaptionFont.Height = -11
        Appearance.CaptionFont.Name = 'Tahoma'
        Appearance.CaptionFont.Style = []
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ImageIndex = 2
        ParentFont = False
        Position = daTop
        Version = '3.1.6.0'
        OnClick = tbShowReportClick
      end
      object tbSave: TAdvToolBarButton
        Left = 50
        Top = 2
        Width = 24
        Height = 28
        Hint = '���������'
        Appearance.CaptionFont.Charset = DEFAULT_CHARSET
        Appearance.CaptionFont.Color = clWindowText
        Appearance.CaptionFont.Height = -11
        Appearance.CaptionFont.Name = 'Tahoma'
        Appearance.CaptionFont.Style = []
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ImageIndex = 1
        ParentFont = False
        Position = daTop
        Version = '3.1.6.0'
      end
      object tbInExcel: TAdvToolBarButton
        Left = 74
        Top = 2
        Width = 24
        Height = 28
        Hint = '������������ � Excel'
        Appearance.CaptionFont.Charset = DEFAULT_CHARSET
        Appearance.CaptionFont.Color = clWindowText
        Appearance.CaptionFont.Height = -11
        Appearance.CaptionFont.Name = 'Tahoma'
        Appearance.CaptionFont.Style = []
        Caption = 'c'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ImageIndex = 3
        ParentFont = False
        Position = daTop
        Version = '3.1.6.0'
        OnClick = ToolButtonXlReport
      end
      object tbShowReport2: TAdvToolBarButton
        Left = 26
        Top = 2
        Width = 24
        Height = 28
        Appearance.CaptionFont.Charset = DEFAULT_CHARSET
        Appearance.CaptionFont.Color = clWindowText
        Appearance.CaptionFont.Height = -11
        Appearance.CaptionFont.Name = 'Tahoma'
        Appearance.CaptionFont.Style = []
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ImageIndex = 4
        ParentFont = False
        Position = daTop
        Version = '3.1.6.0'
        OnClick = tbShowReport2Click
      end
    end
    object edFilter: TEdit
      Left = 163
      Top = 6
      Width = 166
      Height = 21
      TabOrder = 1
      OnChange = edFilterChange
    end
  end
  object imgDataView: TImageList
    Left = 722
    Top = 306
    Bitmap = {
      494C010105000900040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000003000000001002000000000000030
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF009C9C9C008484
      8400848484008484840084848400848484008484840084848400848484008484
      8400848484008C8C8C00E7E7E700000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000F7F7F700CECECE00E7E7
      E700DEDEDE00DEDEDE00DEDEDE00DEDEDE00DEDEDE00DEDEDE00DEDEDE00DEDE
      DE00DEDEDE00DEDEDE00C6C6C600000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000F7F7F700D6D6D600FFF7
      EF00F7EFE700D6D6D600D6D6D600EFEFEF00D6D6D600DEDEDE00D6D6D600D6D6
      D600D6D6D600D6D6D600C6C6C600000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000F7F7F700D6D6D600FFF7
      EF00F7EFE700D6D6D600FFFFFF00FFFFFF00FFFFFF00FFFFFF00F7F7F700A5D6
      A50053D5420045D03900948C7B00EFEFEF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000F7F7F700D6D6D600FFF7
      EF00F7EFE700EFEFEF00FFFFFF00FFFFFF00CECECE00D6D6D600CEF7D30031D6
      34003AD639002AD629003DD03400948C84000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000F7F7F700D6D6D600FFF7
      EF00EFEFE700EFEFEF00FFFFFF00DEDEDE00D6D6D600D6D6D60065EF630031D6
      34008FE78C00B5F7B60031D634004ACE4D000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000F7F7F700D6D6D600FFF7
      EF00F7EFE700CECECE00FFFFFF00EFEFEF00D6D6D600D6D6D6008CFF8F0042E7
      4500B5F7B600B5F7B60042E7450052D655000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000F7F7F700DEDEDE00FFF7
      F700F7EFE700CECECE00EFEFEF00EFEFEF00DEDEDE00DEDEDE00FFFFF70094D0
      560042E7450042E745009CD25400CEC6C6000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000F7F7F700E7E7E700FFFF
      F700F7EFEF00EFEFEF00F7F7F700FFFFFF00E7E7E700E7E7E700E7E7E700FFFF
      F700B8FFB500B0F7AD00BDB5B500FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000F7F7F700E7E7E700FFFF
      F700F7F7EF00E7E7E700E7E7E700EFEFEF00F7F7F700F7F7F700FFFFFF00EFEF
      EF00EFEFEF00EFEFEF00C6C6C600000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000F7F7F700E7E7E700FFFF
      FF00F7F7EF00EFEFEF00EFEFEF00EFEFEF00E7E7E700DEDEDE00DEDEDE00E7E7
      E700E7E7E700E7E7E700CECECE00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000F7F7F700E7E7E700FFFF
      FF00F7F7EF00EFEFEF00EFEFEF00EFEFEF00EFEFEF00EFEFEF0052F7550052F7
      55009CD2540073B57400FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000F7F7F700E7E7E700FFFF
      FF00F7EFEF00EFEFEF00EFEFEF00EFEFEF00EFEFEF00EFEFEF0063FF6A0064FF
      630073B57400FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000F7F7F700E7E7E700FFFF
      FF00EFEFE700EFEFEF00EFEFEF00EFEFEF00EFEFEF00EFEFEF00B8FFB5008CB5
      9100FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000F7F7F700E7E7E700E7E7
      E700EFEFEF00EFEFEF00EFEFEF00EFEFEF00EFEFEF00EFEFEF0097BD9400FFFF
      FF0000000000FFFFFF00FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF00F7F7
      F700F7F7F700F7F7F700F7F7F700F7F7F700F7F7F700F7F7F700FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000008080800000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF00FFF7F700FFF7F700FFF7F700FFFFFF00F7F7EF00C6D6
      BD00C6D6BD00FFFFFF00000000000000000000000000FFFFFF009C9C9C008484
      8400848484008484840084848400848484008484840084848400848484008484
      8400848484008C8C8C00E7E7E700000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000F9F9
      F900E9E9E900E9E9E900F9F9F9000000000000000000DEE7E700F7B55A00A573
      3900211810000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      F700EFDED600E7C6BD00DEB5A500D6AD9400DEAD9400DEBDB5009CA57B000094
      210000941800FFFFFF00000000000000000000000000F7F7F700CECECE00E7E7
      E700DEDEDE00DEDEDE00DEDEDE00DEDEDE00DEDEDE00DEDEDE00DEDEDE00DEDE
      DE00DEDEDE00DEDEDE00C6C6C60000000000FBFBFB00E9E9E900E9E9E900E9E9
      E900E9E9E900E9E9E900E9E9E900C9C9C900BDBDBD00BDBDBD00BDBDBD00B7B7
      B70011843C0012863E00EFEFEF000000000000000000D6DEDE00F7C69C00FFD6
      AD00FFD69C00FFBD6B00AD7B3900292110000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000F7EFEF00E7D6
      CE00E79C6B00FFCE9C00FFDEBD00FFE7CE00FFDEC600FFD6AD00AD94420000A5
      290000A52900FFFFFF00FFFFFF000000000000000000F7F7F700D6D6D600FFF7
      EF00F7EFE700D6D6D600D6D6D600EFEFEF00D6D6D600DEDEDE00D6D6D600D6D6
      D600D6D6D600D6D6D600C6C6C60000000000E9E9E900B67E0E00B47B0900B47B
      0900B47B0900B47B0900B67B0800007E340057CE820059CD83005DD2870056C9
      810050C57C000D813900E3E3E3000000000000000000D6D6DE00EFBD8C00EFBD
      8C00EFBD8C00D6B58C00B57B5A00B5947300FFC67300BD8C4200312110000000
      00000000000000000000000000000000000000000000FFF7EF00EFDED600F79C
      4A00FFCEA500FFD6B500FFE7CE00FFEFDE00089C290010A5310010AD390000B5
      390000B53900089C29001094290063AD630000000000F7F7F700D6D6D600FFF7
      EF00F7EFE700D6D6D600FFFFFF00FFFFFF00FFFFFF00FFFFFF00F7F7F700D6BD
      A500DE8C4200D6843900948C7B00EFEFEF00E9E9E90000000000E6D6B000E7D7
      B100E7D7B100E7D7B100E7D7B100EFDAB50000782A004DC27D004CBE7B0046BB
      770005823A0013874000178A42000000000008080800D6D6DE00EFC68C00EFC6
      8C00EFBD8C00CEAD8400FFB57B00FFBD7B00FFA56300AD6B3900B5946B00FFCE
      8400C68C4A00392910000000000000000000FFFFFF00F7EFEF00E7842900FFB5
      7B00FFB57B00FFCEA500FFDEBD00FFE7CE00E7D6B50000D6520000CE4A0000C6
      4A0000BD420000B5390010B542000000000000000000F7F7F700D6D6D600FFF7
      EF00F7EFE700EFEFEF00FFFFFF00FFFFFF00CECECE00D6D6D600F7E7CE00D684
      3100D6843900D67B2900D6843100948C8400E9E9E90000000000E8D8B400E8D9
      B500E8D9B500E8D9B500E8D9B500EADAB600FFE4C50043B679003CB17100077F
      3400DE851500F9F9F900000000000000000018181800D6D6D600F7C68400EFC6
      8C00EFC68C00CEAD7B00FFDE9C00FFF7B500FFE79C00FFBD7300EF843900EFC6
      9C00F7CEA500FFD6AD00BD94630000000000FFFFFF00D69C7B00FF944200FF94
      3900FFBD8C00FFC69C00FFD6AD00FFDEBD00FFD6BD00ADB5730042EF8C0042E7
      840042DE84005AE79400F7F7EF000000000000000000F7F7F700D6D6D600FFF7
      EF00EFEFE700EFEFEF00FFFFFF00DEDEDE00D6D6D600D6D6D600EFA56300D684
      3100E7B58C00F7D6B500D6843100CE8C4A00E9E9E90000000000E6D6AF00E6D6
      AF00E6D6AF00E6D6AF00E7D7B000FEE0BF002EA66B0030A56A000079280033A7
      6C0037AB7200C9C9C900000000000000000021212100D6D6DE00F7C68400EFC6
      8400EFC68C00D6AD7B00FFFFCE0094521000AD7B3900FFFFB500F7AD6B00FFAD
      0000E7BD9400EFBD9400B58C63000000000000000000D66B1800E77B2900EF84
      3100FFC69C00FFBD8C00FFC69C00FFCEA500FFD6B500FFD6BD008CC684007BF7
      AD0073F7AD00AD732100D6A57B000000000000000000F7F7F700D6D6D600FFF7
      EF00F7EFE700CECECE00FFFFFF00EFEFEF00D6D6D600D6D6D600FFC68C00E794
      4200F7D6B500F7D6B500E7944200D6945200E9E9E90000000000F8F4EA00F8F5
      EA00F8F5EA00F8F5EA00FBF6EC00007521000078260000742000FFFCF5000074
      20000080340012883F00000000000000000029292900DEDEDE00EFBD7B00EFC6
      8400EFC68400D6AD7B00FFDEA500945218009452100084390000FFCE7B00DEB5
      8400F7A52100EFC69400B59463000000000000000000D6631000D66B1800E773
      2100FFE7CE00FFCEAD00FFDEC600FFEFDE00FFF7E700FFEFE700FFE7D600ADEF
      C6009CB56B00CE631000C66318000000000000000000F7F7F700DEDEDE00FFF7
      F700F7EFE700CECECE00EFEFEF00EFEFEF00DEDEDE00DEDEDE00FFFFF700EFA5
      5200E7944200E7944200F7A55200CEC6C600E9E9E90000000000F6F1E300F6F1
      E300F6F1E300F6F1E300F6F1E300F9F3E500FAF3E600F9F3E500F6F1E300F9F3
      E600BC7B070000000000000000000000000042424200E7E7EF00DEAD6B00EFC6
      7B00EFC68400D6AD7300F7BD8400FFE7AD00F7EFCE00EFDEAD00FFC67B00CE94
      8C00FF4A0000EFC69400BD94630000000000EFEFEF00DE731800EF944A00F794
      4A00FFEFE700FFDEC600FFD6B500FFDEBD00FFE7D600FFF7EF00FFF7EF00FFE7
      CE00FFCE9C00CE631000CE6308000000000000000000F7F7F700E7E7E700FFFF
      F700F7EFEF00EFEFEF00F7F7F700FFFFFF00E7E7E700E7E7E700E7E7E700FFFF
      F700FFD6B500F7CEAD00BDB5B500FFFFFF00E9E9E90000000000F4EEDD00F4EE
      DD00F4EEDD00F4EEDD00F4EEDD00F4EEDD00F4EEDD00F4EEDD00F4EEDD00F4EE
      DD00B47A08000000000000000000000000004A4A4A00EFEFEF00C69C6B00EFB5
      7B00EFBD7B00D6AD7300D68C6300FFB57B00FFBD8400FFB57300BD7B4A00FF84
      1800E7522100F7C68C00BD94630000000000F7F7F700F79C4A00FF943900F7B5
      8400FFD6AD00FFD6B500FFD6AD00FFDEBD00FFE7D600FFEFE700FFEFDE00FFD6
      B500FFA56300D66B1000C65A08000000000000000000F7F7F700E7E7E700FFFF
      F700F7F7EF00E7E7E700E7E7E700EFEFEF00F7F7F700F7F7F700FFFFFF00EFEF
      EF00EFEFEF00EFEFEF00C6C6C60000000000E9E9E90000000000F3EBD600F3EB
      D700F3EBD700F3EBD700F3EBD700F3EBD700F3EBD700F3EBD700F3EBD700F3EB
      D700B47B08000000000000000000000000005A5A5A00EFEFEF00EFEFEF00DEDE
      D600C69C7300DE9C6300CE9C63004231210042291800AD6B3900B5632900F7CE
      8C00F7C68400EFC68400C69463000000000000000000FF8C3900FFAD6B00FFCE
      A500FFCEA500FFF7EF00FFD6AD00FFD6AD00FFDEBD00FFDEC600FFDEBD00FFC6
      9C00FFB57B00E77B2900B57342000000000000000000F7F7F700E7E7E700FFFF
      FF00F7F7EF00EFEFEF00EFEFEF00EFEFEF00E7E7E700DEDEDE00DEDEDE00E7E7
      E700E7E7E700E7E7E700CECECE0000000000E9E9E90000000000F1E8D000F1E8
      D100F1E8D100F1E8D100F1E8D100F1E8D100F1E8D100F1E8D100F1E8D100F1E8
      D000B47B08000000000000000000000000006B6B6B00EFEFEF00EFEFEF00EFEF
      EF00EFEFEF00EFF7F700DED6CE00CEA57300F7BD7B00CE9C63007B634200F7BD
      7B00EFC67B00EFC68400DEA56B000000000000000000D68C4A00FFCEA500FFDE
      C600FFD6AD00FFE7CE00FFD6B500FFCEAD00FFCEA500FFCEAD00FFC69C00FFB5
      7300FFC69400F78C3900E7E7DE000000000000000000F7F7F700E7E7E700FFFF
      FF00F7F7EF00EFEFEF00EFEFEF00EFEFEF00EFEFEF00EFEFEF00F7A55200F7A5
      5200F7A55200B5947300FFFFFF0000000000E9E9E90000000000EFE4CA00EFE4
      CB00EFE4CB00EFE4CB00EFE4CB00EFE4CB00EEE3C900EEE3C800EEE3C900EEE2
      C800B47B08000000000000000000000000006B6B6B00EFEFEF00EFEFEF00EFEF
      EF00EFEFEF00EFEFEF00EFEFEF00EFEFEF00EFEFF700CE9C6B00E7A56B00E7AD
      6B00EFB57300EFB57300E7B56B000000000000000000FFFFFF00FFBD8C00FFF7
      EF00FFD6B500FFD6B500FFFFFF00FFDEC600FFCEA500FFC69400FFBD8400FFBD
      8400FFC69C00DE7B3100000000000000000000000000F7F7F700E7E7E700FFFF
      FF00F7EFEF00EFEFEF00EFEFEF00EFEFEF00EFEFEF00EFEFEF00FFB56300FFAD
      6300B5947300FFFFFF000000000000000000E9E9E90000000000EDE1C400EDE1
      C500EDE1C500EDE1C500EDE1C500EDE1C40000000000AE6F0000AE700000AC6D
      0000B57D0C00000000000000000000000000000000006B6B6B00D6D6D600FFFF
      FF00EFEFEF00EFEFEF00F7F7F700F7F7F700EFEFEF00CEBDAD00CE8C5A00DE94
      5A00DE9C6300DEA56B00DE9C5A00000000000000000000000000E7EFCE00FFE7
      D600FFE7D600FFD6B500FFEFDE00FFFFF700FFC69C00FFC69400FFBD8400FFE7
      D600FF94420000000000000000000000000000000000F7F7F700E7E7E700FFFF
      FF00EFEFE700EFEFEF00EFEFEF00EFEFEF00EFEFEF00EFEFEF00FFD6B500B5A5
      8C00FFFFFF00000000000000000000000000E9E9E90000000000EBDEBE00EBDE
      BF00EBDEBF00EBDEBF00EBDEBF00EBDEBE0000000000FDFDFB00F0E6CD00EAD8
      B700FBFBFB000000000000000000000000000000000000000000000000000000
      0000101010008C8C8C001010100000000000101010009C9C9C00FFFFFF00E7E7
      DE00C69C7300CE844A00D68C520000000000000000000000000000000000E7EF
      DE00FFCEA500FFE7D600FFD6B500FFCEAD00FFE7D600FFCE9C00FFE7CE00EF9C
      5A000000000000000000000000000000000000000000F7F7F700E7E7E700E7E7
      E700EFEFEF00EFEFEF00EFEFEF00EFEFEF00EFEFEF00EFEFEF00BDA59400FFFF
      FF0000000000FFFFFF00FFFFFF0000000000E9E9E90000000000E8D9B700E9DA
      B700E9DAB700E9DAB700E9DAB700E8D9B70000000000F3ECDA00E9D7B400FBFB
      FB00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000808
      080094949400DEDEE70000000000000000000000000000000000000000000000
      000000000000D6CEBD00D6A57B00E7AD7B00DEA57300CEAD8400F7FFF7000000
      0000000000000000000000000000000000000000000000000000FFFFFF00F7F7
      F700F7F7F700F7F7F700F7F7F700F7F7F700F7F7F700F7F7F700FFFFFF000000
      000000000000000000000000000000000000F3F3F30000000000000000000000
      00000000000000000000000000000000000000000000EBDBBC00FDFDFD000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000300000000100010000000000800100000000000000000000
      000000000000000000000000FFFFFF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000080010000000000008001000000000000
      8001000000000000800000000000000080000000000000008000000000000000
      8000000000000000800000000000000080000000000000008001000000000000
      8001000000000000800100000000000080030000000000008007000000000000
      8009000000000000C01F0000000000000FFFF8038001FFE100FFE00380010001
      003FC00180010001000380008000400100010001800040030001000180004003
      0001800180004003000180018000400700010001800040070001000180014007
      0001800180014007000180018001400700018003800340878001C00780074087
      F101E00F8009408FFFE1F81FC01F7F9F00000000000000000000000000000000
      000000000000}
  end
  object ColorDialog1: TColorDialog
    Ctl3D = True
    Left = 778
    Top = 304
  end
  object ImageListRep1: TImageList
    Left = 736
    Top = 346
    Bitmap = {
      494C01010E001300040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000005000000001002000000000000050
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000D5904EFFD594
      56FFD59657FFD59657FFD59657FFD59657FFD59657FFD59657FFD59657FFD595
      57FFD59354FFF3EAE1FF00000000000000000000000000000000D5904EFFD594
      56FFD59657FFD59657FFD59657FFD59657FFD59657FFD59657FFD59657FFD595
      57FFD59354FFF3EAE1FF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000DEA365FFD2A1
      6BFFD1A26CFFDAA971FFDEAC73FFE0AE74FFE0AE74FFE0AE74FFE0AE74FFE0AE
      74FFE0AA6FFFF3EBE2FF00000000000000000000000000000000DEA365FFD2A1
      6BFFD1A26CFFDAA971FFDEAC73FFE0AE74FFE0AE74FFE0AE74FFE0AE74FFE0AE
      74FFE0AA6FFFF3EBE2FF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000E5B278FF5552
      4FFF2C3B3EFF51A2B8FF718E8AFFBF9D73FFE7BE8BFFE8BF8CFFE8BF8CFFE8BF
      8CFFE8BA86FFF4ECE3FF00000000000000000000000000000000E5B278FF5552
      4FFF2C3B3EFF51A2B8FF718E8AFFBF9D73FFE7BE8BFFE8BF8CFFE8BF8CFFE8BF
      8CFFE8BA86FFF4ECE3FF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000ECC18EFFB0A5
      94FF5BC2DCFF57DAFFFF55D8FFFF726863FFC8AE89FFEFD0A4FFF0D0A5FFF0D0
      A5FFF0CC9EFFF4EDE4FF00000000000000000000000000000000ECC18EFFB0A5
      94FF5BC2DCFF57DAFFFF55D8FFFF726863FFC8AE89FFEFD0A4FFF0D0A5FFF0D0
      A5FFF0CC9EFFF4EDE4FF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000F3D1A1FFE1CE
      AEFF7BE6FFFF7EE9FFFF71E0FFFF102026FF6D635CFFD5C2A2FFF7E1BCFFF8E2
      BDFFF8DDB5FFF5EEE6FF00000000000000000000000000000000F3D1A1FFE1CE
      AEFF7BE6FFFF7EE9FFFF71E0FFFF102026FF6D635CFFD5C2A2FFF7E1BCFFF8E2
      BDFFF8DDB5FFF5EEE6FF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000F8DCB2FFFAE8
      CAFF83E6FEFF7DD9EEFF90F7FFFF5BE9FFFF0F2A33FF695F57FFE0D2B8FFFDEE
      D0FFFDE9C8FFF5EFE6FF00000000000000000000000000000000F8DCB2FFFAE8
      CAFF83E6FEFF7DD9EEFF90F7FFFF5BE9FFFF0F2A33FF695F57FFE0D2B8FFFDEE
      D0FFFDE9C8FFF5EFE6FF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000F9E2BBFFFFF3
      D7FFECE3CCFF5D5756FF5C8587FF95F8FFFF5EEBFFFF123945FF675F57FFE6DD
      C5FFFEEFD2FFF4EFE7FF00000000000000000000000000000000F9E2BBFFFFF3
      D7FFECE3CCFF5D5756FF5C8587FF95F8FFFF5EEBFFFF123945FF675F57FFE6DD
      C5FFFEEFD2FFF4EFE7FF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000F9E4C1FFFFF6
      DFFFFFF8E2FFF5F0DAFF6B6664FF4D6D6FFF98F8FFFF63EEFFFF154A5BFF5F5D
      56FFEDE2CAFFF3EDE6FF00000000000000000000000000000000F9E4C1FFFFF6
      DFFFFFF8E2FFF5F0DAFF6B6664FF4D6D6FFF98F8FFFF63EEFFFF154A5BFF5F5D
      56FFEDE2CAFFF3EDE6FF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000F9E6C6FFFFF9
      E5FFFFFBE9FFFFFBE9FFF9F6E4FF7F7A77FF3D5657FF9BF8FFFF98CFD5FF3B3B
      3BFFA6A0B3FFF2EDE6FF00000000000000000000000000000000F9E6C6FFFFF9
      E5FFFFFBE9FFFFFBE9FFF9F6E4FF7F7A77FF3D5657FF9BF8FFFF98CFD5FF3B3B
      3BFFA6A0B3FFF2EDE6FF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000F9E8CBFFFFFA
      EBFFFFFDEEFFFFFDEEFFFFFDEEFFFCFAECFF9E9B96FF828384FF979799FFA399
      CDFFA89FB9FFF0EBE6FF00000000000000000000000000000000F9E8CBFFFFFA
      EBFFFFFDEEFFFFFDEEFFFFFDEEFFFCFAECFF9E9B96FF828384FF979799FFA399
      CDFFA89FB9FFF0EBE6FF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000F9E9CEFFFFFB
      EFFFFFFEF3FFFFFEF3FFFFFEF3FFFFFEF3FFFDFCF1FFC4C1C1FF9179B7FF866A
      B4FFE1D8C8FFE9E3DBFFFEFEFEFF000000000000000000000000F9E9CEFFFFFB
      EFFFFFFEF3FFFFFEF3FFFFFEF3FFFFFEF3FFFDFCF1FFC4C1C1FF9179B7FF866A
      B4FFE1D8C8FFE9E3DBFFFEFEFEFF000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000F9E9D1FFFFFB
      F2FFFFFEF6FFFFFEF6FFFFFEF6FFFFFEF6FFFDFCF5FFEAE4D6FFCABEA5FFCCBE
      A6FFDDCDB6FFE5DFD5FFFEFEFEFF000000000000000000000000F9E9D1FFFFFB
      F2FFFFFEF6FFFFFEF6FFFFFEF6FFFFFEF6FFFDFCF5FFEAE4D6FFCABEA5FFCCBE
      A6FFDDCDB6FFE5DFD5FFFEFEFEFF000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000F9E9D4FFFFFB
      F5FFFFFDF9FFFFFDF9FFFFFDF9FFFFFDF9FFFCFAF5FFDED6C7FFF5CD9DFFD5B2
      7BFFC2A574FFF9F8F5FF00000000000000000000000000000000F9E9D4FFFFFB
      F5FFFFFDF9FFFFFDF9FFFFFDF9FFFFFDF9FFFCFAF5FFDED6C7FFF5CD9DFFD5B2
      7BFFC2A574FFF9F8F5FF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000F9E5D0FFFFF6
      EEFFFFF8F2FFFFF8F2FFFFF8F2FFFFF8F2FFFDF6EFFFE7DCCEFFFFE9CDFFD3B8
      88FFF4F2EEFFFEFEFEFF00000000000000000000000000000000F9E5D0FFFFF6
      EEFFFFF8F2FFFFF8F2FFFFF8F2FFFFF8F2FFFDF6EFFFE7DCCEFFFFE9CDFFD3B8
      88FFF4F2EEFFFEFEFEFF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000EBD8B9FFEDDC
      BFFFEEDEC3FFEEDEC3FFEEDEC3FFEEDEC3FFECDBC0FFE7D5B8FFD0B88EFFF6F5
      F1FFFEFEFEFF0000000000000000000000000000000000000000EBD8B9FFEDDC
      BFFFEEDEC3FFEEDEC3FFEEDEC3FFEEDEC3FFECDBC0FFE7D5B8FFD0B88EFFF6F5
      F1FFFEFEFEFF0000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FCFCFCFF9E9E9EFF8484
      84FF848484FF848484FF848484FF848484FF848484FF848484FF848484FF8484
      84FF848484FF888888FFE3E3E3FF0000000000000000FCFCFCFF9E9E9EFF8484
      84FF848484FF848484FF848484FF848484FF848484FF848484FF848484FF8484
      84FF848484FF888888FFE3E3E3FF000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FAF5EEFFF5DEC2FFF3C4
      89FFF8D5ABFFFEFEFDFF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000F3F3F3FFCFCFCFFFE6E3
      E1FFDAD9D9FFD8D8D8FFD8D8D8FFD8D8D8FFD8D8D8FFD8D8D8FFD8D8D8FFD8D8
      D8FFD8D8D8FFDDDDDDFFC3C3C3FF0000000000000000F3F3F3FFCFCFCFFFE3E3
      E3FFD9D9D9FFD8D8D8FFD8D8D8FFD8D8D8FFD8D8D8FFD8D8D8FFD8D8D8FFD8D8
      D8FFD8D8D8FFDDDDDDFFC3C3C3FF000000000000000000000000D5904EFFD594
      56FFD59657FFD59657FFD59657FFD59657FFDA934DFF7D460EFFB96D05FFDC8E
      0FFFDF8500FFEFC694FFFBE5CBFF000000000000000000000000000000000000
      0000F0F0F0FF8F958AFF617E4EFF5C873FFF587D38FF5F7150FFA0A3A3FFFBFB
      FBFF0000000000000000000000000000000000000000F3F3F3FFD2D1D1FFFEF5
      ECFFF1EBE4FFD3D3D3FFD4D4D4FFEDEDEDFFD7D7D7FFDADADAFFD3D3D3FFD3D3
      D3FFD3D3D3FFD6D6D6FFC1C1C1FF0000000000000000F3F3F3FFD1D1D1FFF3F3
      F3FFEAEAEAFFD3D3D3FFD3D3D3FFCFCFCFFFD3D3D3FFD3D3D3FFD3D3D3FFD3D3
      D3FFD3D3D3FFD6D6D6FFC1C1C1FF000000000000000000000000DDA364FFE0AC
      72FFE0AD74FFE0AD74FFE0AD74FFE0AD74FFBA6801FFC87000FFE89000FFE892
      00FFE89502FFE7A720FFE49D18FFFEFCFBFF0000000000000000ECECECFF4978
      2AFF55932CFF5F9E35FF66A63BFF69A93EFF64A032FF5A912BFF2B759AFF236F
      BBFF415973FFFCFCFCFF000000000000000000000000F3F3F3FFD1D1D1FFFEF5
      ECFFF1EBE4FFD1D1D1FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF4F4F4FFD7BF
      A6FFDB8E42FFD3863BFF94897CFFE9E9E9FF00000000F3F3F3FFD1D1D1FFF3F3
      F3FFEAEAEAFFD3D3D3FFD3D3D3FFAEAEAEFFD1D1D1FFD3D3D3FFD3D3D3FFD0B8
      B7FFC97773FFBD716DFF918786FFEBEBEBFF0000000000000000E5B278FFE8BD
      89FFE8BF8CFFE8BF8CFFE8BF8CFFE8BE8BFFE68E00FFE59300FFBF6E00FFE89C
      00FFE89E00FF985303FFC16A01FF0000000000000000CCCDCBFF407C18FF4A88
      22FF55932CFF5F9E35FF65A63BFF67A83CFF639F31FF59902AFF2B759AFF236D
      B8FF236AB7FF215F9EFFF9F9F9FF0000000000000000F3F3F3FFD1D1D0FFFEF5
      ECFFF0EAE4FFEFEFEFFFFFFFFFFFF9F9F9FFCECECEFFD3D3D3FFF7E4CFFFD684
      34FFD4873CFFD17F2FFFD28030FF958D83FF00000000F3F3F3FFD1D1D1FFF3F3
      F3FFE9E9E9FFD3D3D3FFD3D3D3FFC8C8C8FFCACACAFFD3D3D3FFD0BCBBFFC471
      6DFFBB6D69FFBC6F6BFFC0726EFF958D8DFF0000000000000000ECC18EFFF0CF
      A2FFF0D0A5FFF0D0A5FFF0D0A5FFF2C692FFE8A400FFC47700FF6D3200FFF3BD
      7DFFE8AF00FFE5A601FFC48517FFAB5F0EFFFEFEFEFF377210FF407C18FF4A88
      22FF72AD3EFF75C323FF55B503FF4BB001FF4FB101FF62BB0CFF43A4C3FF2A75
      BCFF226AB7FF2368ADFF345B7FFF0000000000000000F3F3F3FFD0D0D0FFFEF5
      ECFFEFE9E3FFE9E9E9FFFFFFFFFFDBDBDBFFD3D3D3FFD3D3D3FFEEA660FFD684
      34FFE7B788FFF0D0B1FFD68434FFCB8948FF00000000F3F3F3FFD0D0D0FFF3F3
      F3FFE8E8E8FFD3D3D3FFD3D3D3FFBBBBBBFFBEBEBEFFD3D3D3FFDD9491FFD59E
      9CFFCB8885FFC8827EFFCB8985FFBD7572FF0000000000000000F3D1A1FFF8E0
      BAFFF8E2BDFFF8E2BDFFF8E2BDFFF8E2BCFFEBAD19FFD39213FFC56D00FFF6B9
      69FFE8AD08FFE8AE00FFA77416FFE5B480FFCAD2C4FF377210FF548E24FF55C2
      09FF43BA03FF43BA03FF43BA03FF43BA03FF43BA03FF44BA04FF0B82F1FF0A82
      F1FF339DE4FF2267ADFF2467A5FFFDFDFDFF00000000F3F3F3FFD4D4D4FFFEF6
      EDFFF0EAE4FFC9C9C9FFFAFAFAFFEAEAEAFFD7D7D7FFD7D7D7FFF8C28EFFE492
      42FFF5D5B7FFF5D5B6FFE49242FFD19355FF00000000F3F3F3FFD4D4D4FFF4F4
      F4FFE9E9E9FFD7D7D7FFD7D7D7FFC9C9C9FFE3E3E3FFD7D7D7FFEAB2B0FFD898
      95FFD89794FFD79794FFEED1D0FFC4827EFF0000000000000000F8DCB2FFFDED
      CDFFFDEED0FFFDEED0FFFDEED0FFFDEED0FFF5BE66FFE8CB53FFCB9011FFC184
      15FFE8B219FFDE9E04FFB36100FFF8E8D5FFBACAAFFF4F8B1CFF3BC901FF3BC9
      02FF3BC902FF3BC902FF3BC902FF3BC902FF3BC901FF1893C3FF0F86F2FF0F86
      F2FF0F86F2FF2AA0F0FF2467A5FFFCFCFCFF00000000F3F3F3FFDADAD9FFFFF7
      F0FFF2ECE7FFC9C9C9FFEDEDEDFFECECECFFDEDEDEFFD8D8D8FFFEFAF5FFEEA0
      53FFE79545FFE79545FFF3A353FFC9C7C5FF00000000F3F3F3FFD9D9D9FFF6F6
      F6FFECECECFFDEDEDEFFDEDEDEFFDCDCDCFFE5E5E5FFDEDEDEFFDFDBDBFFD68A
      87FFCF7E7AFFCF7E7AFFE28C87FFCCCBCBFF0000000000000000F9E2BBFFFFF3
      D8FFFFF5DBFFFFF5DBFFFFF5DBFFFFF5DBFFFEE5C0FFEFBF5FFFE8CA4DFFE8BE
      30FFE8B217FFE8AD05FFEE9C23FF00000000ACC39CFF3BDB02FF32D901FF32D9
      01FF32D901FF32D901FF32D901FF32D901FF32D60CFF138BF3FF148CF3FF148C
      F3FF148CF3FF148CF3FF4198D1FFFCFCFCFF00000000F3F3F3FFE0E0E0FFFFF8
      F3FFF3EEEAFFE9E9E9FFF5F5F5FFF8F8F8FFE5E5E5FFE5E5E5FFE3E3E3FFFCF9
      F7FFF8D4B1FFF7CFA8FFB8B7B5FFFEFEFEFF00000000F3F3F3FFE0E0E0FFF7F7
      F7FFEDEDEDFFE5E5E5FFE2E2E2FFBABABAFFDADADAFFC0C0C0FFD4D4D4FFE5E3
      E3FFE7CBC9FFE8C4C2FFBAB9B9FFFEFEFEFF0000000000000000F9E4C1FFFFF6
      DFFFFFF8E2FFFFF8E2FFFFF8E2FFFFF8E2FFFFF8E2FFFFE7C4FFE9BE3CFFECAF
      21FFD18B11FFEBAF70FF0000000000000000AAC792FF2AE801FF2AE901FF2AE9
      01FF2AE901FF2AE901FF2AE901FF2AE901FF1CA3C0FF1891F4FF1891F4FF1891
      F4FF1891F4FF1891F4FF239BF5FFF7F7F7FF00000000F3F3F3FFE4E4E4FFFFFA
      F6FFF3F0EDFFE5E5E5FFE7E7E7FFEDEDEDFFF5F5F5FFF7F7F7FFFFFFFFFFE9E9
      E9FFEAEAEAFFEAEAEAFFC2C2C2FF0000000000000000F3F3F3FFE4E4E4FFF9F9
      F9FFEFEFEFFFB8B8B8FFA9A9A9FFCACACAFFC6C6C6FFC7C7C7FFD9D9D9FF9D9D
      9DFFB4B4B4FFEAEAEAFFC2C2C2FF000000000000000000000000F9E6C6FFFFF9
      E5FFFFFBE9FFFFFBE9FFFFFBE9FFFFFBE9FFFFFBE9FFFFFBE9FFFFFBE9FFFFF4
      DCFFFFF3DCFFF5EEE3FF0000000000000000BBFCA1FF23F600FF23F600FF23F6
      00FF22F700FF22F600FF2AEC08FF3CDA14FF1D96F5FF1D96F5FF1D96F5FF1D96
      F5FF1D96F5FF1D96F5FF1C96F5FFE3E2E2FF00000000F3F3F3FFE6E6E6FFFFFB
      F8FFF4F1EEFFEDEDEDFFEDEDEDFFEDEDEDFFE6E6E6FFDADADAFFDEDDDDFFE7E6
      E5FFE7E6E5FFE5E4E3FFCBCBCBFF0000000000000000F3F3F3FFE6E6E6FFFAFA
      FAFFF0F0F0FFE1E1E1FFE0E0E0FFDCDCDCFFCDCDCDFFD2D2D2FFC6C6C6FFADAB
      ABFFA8A7A7FFE2E1E1FFCBCBCBFF000000000000000000000000F9E8CBFFFFFA
      EBFFFFFDEEFFFFFDEEFFFFFDEEFFFFFDEEFFFFFDEEFFFEFCEEFFFEFCEEFFFEFC
      EEFFFEF7E4FFF3EEE6FF0000000000000000C0EAA9FF31910CFF3F7E18FF4B85
      23FF55932CFF5F9E35FF66A73BFFA75E57FF3792DDFF229CF6FF229CF6FF229C
      F6FF229CF6FF229CF6FF249EF7FFF0F0F0FF00000000F3F3F3FFE6E6E6FFFFFB
      F8FFF3F0EEFFEDEDEDFFEDEDEDFFEDEDEDFFEDEDEDFFEDEDEDFFF7A454FFF6A3
      53FFF6A353FFB19171FFF9F9F9FF0000000000000000F3F3F3FFE6E6E6FFFAFA
      FAFFEFEFEFFFEDEDEDFFEDEDEDFFEDEDEDFFEDEDEDFFEDEDEDFFF58B86FFF68A
      85FFF68A85FFAC8786FFF9F9F9FF000000000000000000000000F9E9CEFFFFFB
      EFFFFFFEF3FFFFFEF3FFFFFEF3FFFFFEF3FFFEFDF2FFFAF7EBFFF2EFE1FFF5F1
      E4FFF6EDDBFFEAE5DCFFFEFEFEFF00000000FCFDFBFF36710FFF407C18FF4A88
      22FF55932CFF5F9E35FF9E7257FFAD645EFFAB6560FF26A1F7FF27A1F7FF27A1
      F7FF27A1F7FF27A1F7FF5DBCF5FF0000000000000000F3F3F3FFE5E5E5FFFFFB
      F8FFF2EFEDFFEDEDEDFFEDEDEDFFEDEDEDFFEDEDEDFFEDEDEDFFFEB066FFFDAD
      60FFB49475FFF8F8F8FF000000000000000000000000F3F3F3FFE5E5E5FFFAFA
      FAFFEEEEEEFFEDEDEDFFEDEDEDFFEDEDEDFFEDEDEDFFEDEDEDFFFA9995FFFA94
      90FFAC8C8AFFF8F8F8FF00000000000000000000000000000000F9E9D1FFFFFB
      F2FFFFFEF6FFFFFEF6FFFFFEF6FFFFFEF6FFFDFCF5FFEAE4D6FFCABEA5FFCCBE
      A6FFDDCDB6FFE6E0D6FFFEFEFEFF00000000000000008EB469FF407C18FF4A88
      22FF55932CFF7F8C48FFB46D68FFB46D68FFB46D68FF888096FF2BA6F8FF2BA6
      F8FF2BA6F8FF2BA6F8FFCCCDCDFF0000000000000000F3F3F3FFE6E6E6FFFFFB
      F8FFEFEAE6FFEDEDEDFFEDEDEDFFEDEDEDFFEDEDEDFFEDEDEDFFFFD7B2FFB6A1
      8CFFF8F8F8FF00000000000000000000000000000000F3F3F3FFE6E6E6FFFAFA
      FAFFE9E9E9FFEDEDEDFFEDEDEDFFEDEDEDFFEDEDEDFFEDEDEDFFFFCCCAFFAE9C
      9BFFF8F8F8FF0000000000000000000000000000000000000000F9E9D4FFFFFB
      F5FFFFFDF9FFFFFDF9FFFFFDF9FFFFFDF9FFFCFAF5FFDED6C7FFF5CD9DFFD5B2
      7BFFC2A574FFF9F8F6FF000000000000000000000000FFFFFFFF7DAA58FF4A88
      22FF5E9131FFBB7670FFBB7670FFBB7670FFBB7670FFBB7670FF3CA6EDFF30AB
      F9FF31ABF9FFBDC6CAFF000000000000000000000000F7F7F7FFE4E4E4FFE6E6
      E6FFE9E9E9FFEAEAEAFFEAEAEAFFEAEAEAFFEAEAEAFFEAEAEAFFB8A695FFF8F8
      F8FF00000000FAFAFAFFFCFCFCFF0000000000000000F7F7F7FFE4E4E4FFE6E6
      E6FFE9E9E9FFEAEAEAFFEAEAEAFFEAEAEAFFEAEAEAFFEAEAEAFFAFA1A1FFF8F8
      F8FF00000000FAFAFAFFFCFCFCFF000000000000000000000000F9E5D0FFFFF6
      EEFFFFF8F2FFFFF8F2FFFFF8F2FFFFF8F2FFFDF6EFFFE7DCCEFFFFE9CDFFD3B8
      88FFF4F2EEFFFEFEFEFF0000000000000000000000000000000000000000EAF2
      E2FFC68983FFC17D78FFC17E78FFC17E78FFC17E78FFC17E78FFBE807CFF78CD
      FAFFF7F7F7FF0000000000000000000000000000000000000000FAFAFAFFF7F7
      F7FFF7F7F7FFF7F7F7FFF7F7F7FFF7F7F7FFF7F7F7FFF7F7F7FFFCFCFCFF0000
      0000000000000000000000000000000000000000000000000000FAFAFAFFF7F7
      F7FFF7F7F7FFF7F7F7FFF7F7F7FFF7F7F7FFF7F7F7FFF7F7F7FFFCFCFCFF0000
      0000000000000000000000000000000000000000000000000000EBD8B9FFEDDC
      BFFFEEDEC3FFEEDEC3FFEEDEC3FFEEDEC3FFECDBC0FFE7D5B8FFD0B88EFFF6F5
      F1FFFEFEFEFF0000000000000000000000000000000000000000000000000000
      0000FFFFFFFFFEFEFDFFF6F0EDFFF0DEDCFFEFE5E0FFFBFAF8FFFEFEFEFF0000
      000000000000000000000000000000000000AD734A00947B63007B7B7B007B7B
      7B007B7B7B008C7B6B009C7B5A00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000215A0000215A0000215A0000185A0000000000000000
      000000000000000000000000000000000000E7DEDE0000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00DEDED600CECE
      C600F7EFEF00FFFFFF000000000000000000A5734A00EF731800F7841800F784
      1800EF7B1800F7841800EF7B1800AD7342000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000D6944A00D694
      5200D6945200BD844A0063524200D6945200D6945200D6945200D6945200D694
      5200D6945200AD73290000000000000000000000000000000000000000000000
      000000000000185A00000873000010841800188C210000000000000000000000
      000000000000000000000000000000000000BDA59C00FFFFFF00000000000000
      000000000000000000000000000000000000C6BDB500BD9C7B00D6AD8400D6B5
      8C00BDA5840084847B00FFFFFF0000000000E7730800F7941000FFAD1800FFAD
      1800D67B4200FFAD1800FFA51800EF8410000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000DEA56300E7AD
      7300E7AD7300E7AD73008C6B5200BDF7FF00BDAD8C00DEAD7300E7AD7300E7AD
      7300E7AD6B00AD7331000000000000000000000000000000000000000000185A
      0000215A000018630000087B0800008C1800008C180010630000185A0000185A
      000000000000000000000000000000000000CEBDB500C6B5AD00000000000000
      0000000000000000000000000000CEC6BD00CEA57B00D6B58400DE392900DE39
      2900DEBD9400CE9C6B007B736B00FFFFFF00BD7B3900EF9C3100F7B54200DEAD
      9400DEE7E700F7AD4A00F7AD3900CE7B3100947363009473630084736B00847B
      7300B57B4A000000000000000000000000000000000000000000E7B57B00EFBD
      8C00EFBD8C00EFBD8C00E7BD8C008C949400ADEFFF0042525A00EFBD8C00EFBD
      8C00EFBD8400B57B390000000000000000000000000000000000185A0000215A
      0000007B1000089C290000942100009421000094210000942100319C42001063
      0000185A0000000000000000000000000000BDADA500C6B5AD00E7DED6000000
      00000000000000000000FFFFFF00BDAD8C00E7C69C00E7C6A500DE393100D608
      0000E7C69C00D6AD7300B5946B00D6D6D600A5733900DE944A00D68C520042AD
      E7004AB5EF00CE8C6300E7944200F78C1800FF8C1800FF8C1800EF841800F78C
      1800E7731800CE84310000000000000000000000000000000000EFC68C00F7CE
      A500F7D6A500F7D6A500F7D6A500D6BD94003939310073EFFF00425A6300EFCE
      A500F7CE9C00B584420000000000000000000000000000000000215A00000084
      1000009C2100009C210008A53100009C2900009C2900009C2900009C210031AD
      5200185A0000000000000000000000000000A58C8400BDADA500B59C8C006B18
      180000000000FFFFFF00E7E7E700E7E7DE00FFF7E700F7DEC600DE393100D608
      0000EFCEAD00E7BD8C00DEB58400948C8C0000000000181810003173B5005ABD
      F7005AC6F70031B5F700EF941800FFAD1800FFB52100E7B59400FFAD2100FFAD
      1800EF8C1000CE84310000000000000000000000000000000000F7D6A500FFE7
      BD00FFE7BD00FFE7BD00FFE7BD00FFE7BD00E7D6B5004242390073EFF700426B
      7300F7DEB500A5844A0000000000000000000000000000000000185A000000A5
      290000A5210031A54200088C180000A5310000AD3100296B100000A53100009C
      210021842100184A00000000000000000000FFF7F700845A5200945231009C63
      42006B080000A56B5200A57B6B00EFE7E700FFFFF700FFF7EF00DE393100D608
      0000F7DEC600EFCEA500DEC69C008C8C8C00000000001829310063B5FF0063C6
      FF005ABDF70039B5F700639CAD00F7AD4A00BD9C94009CBDD600E7A56B00F7AD
      4A00CE8439000000000000000000000000000000000000000000FFDEB500FFEF
      CE00FFEFD600FFEFD600FFEFD600FFEFD600FFEFD600F7E7CE0052524A0073DE
      EF00427384008C7B5A0000000000000000000000000000000000185A00005294
      4A005A9C5200185A00000894210000B5390000B53900215A000000AD310000AD
      3100108C2100000000000000000000000000FFFFFF0073210800AD7B63007B21
      0800730000006308000073210000C6C6BD00FFFFFF00FFFFFF00FFDEDE00DE4A
      4200FFF7EF00FFF7D600B5B59C00CECECE0000000000426B840018B5F70010C6
      FF0010C6FF0008D6FF0021E7FF0073A5A50039A5D60084A5A5008C737300C684
      4A00000000000000000000000000000000000000000000000000FFE7BD00FFF7
      DE00FFF7DE00FFF7DE00FFF7DE00FFF7DE00FFF7DE00FFF7DE00FFF7D6006363
      5A006BD6DE00528CA50094A5A50000000000000000000000000000000000185A
      0000215A00001863000000A5290000BD420000B5390000B5390000B5390010BD
      420018630000000000000000000000000000B58C7B0094523100945231008431
      08007B2100006B1000008C42290084635200EFEFE700FFFFFF00E7635A00D610
      0000FFFFFF00E7E7DE007B736B00FFFFFF00000000000873940008E7FF0008F7
      FF0008F7FF0008EFFF0018CEFF00299CF70052B5FF009CB5A500F7CE9C002929
      2100947352000000000000000000000000000000000000000000FFE7C600FFF7
      DE00FFFFE700FFFFE700FFFFE700FFFFE700FFFFE700FFFFE700FFFFE700FFF7
      E70063635A00CEDEDE008CADC600000000000000000000000000185A0000215A
      000000AD310000BD420000C6420000C6420000C6420000BD390039CE73001894
      290000000000000000000000000000000000B59484007B2910008C422900B58C
      73007B180000AD7B6300B58C7B009C634A008C736300C6C6BD00EFEFEF00F7F7
      F700CECEC600847B6B00F7F7F70000000000000000001894BD0063EFFF0042F7
      FF0042F7FF0063F7FF003194C60063B5F70073A5BD00D6BD9400F7DEB500EFCE
      A500DEAD73005A42180052423100000000000000000000000000FFE7C600FFFF
      E700FFFFEF00FFFFEF00FFFFEF00FFFFEF00FFFFEF00FFFFEF00FFFFEF00FFFF
      EF00FFF7DE00292929006B94AD00000000000000000000000000215A000021B5
      4A0031D6730018CE630018D6630000CE4A0000CE520039AD5200185A0000185A
      0000185A0000000000000000000000000000CEB5AD00A5735A00844221009452
      3100B5846B00BD948400AD846B00BD8C7B00AD7B630084422900632921005229
      2900C6BDBD00FFFFFF000000000000000000000000000000000029BDF70063CE
      FF0073D6FF0029B5EF00102939008CAD9C00FFE7C600FFE7CE00FFE7CE00FFDE
      C600F7DEB500EFCEA500B58C4A007B6B4A000000000000000000FFEFCE00FFFF
      EF00FFFFEF00FFFFEF00FFFFEF00FFFFEF00FFFFEF00FFFFEF00FFFFEF00FFFF
      EF00FFF7E700A58C630000000000000000000000000000000000185A00006BE7
      9C004ADE840042BD630008A5310008D65A0000DE5A0000000000107B1000187B
      100018731000184A000000000000000000000000000094523900AD7363009452
      31008C4A31009C634A00A56B52009C6B5200BD948400AD7B63009C5A42005200
      0000F7EFEF000000000000000000000000000000000000000000000000000000
      000000000000000000006394A500FFEFD600FFF7DE00FFEFDE00FFEFD600FFEF
      CE00FFE7CE00FFDEBD00EFCEA500181008000000000000000000FFEFCE00FFFF
      EF00FFFFF700FFFFF700FFFFF700FFFFF700FFFFF700FFF7EF00F7EFE700F7F7
      E700F7EFDE0084633100AD8C6300000000000000000000000000185A00007BEF
      AD006BEFA5000894180010AD390021E7730008E763002152000000DE5A0008D6
      5A0021AD420000000000000000000000000000000000FFFFFF0094523900A573
      5A00AD7B6300AD7B6300AD7B6B009C6B52009C634A00B58C7B00AD735A007321
      08007B7B7B00F7F7F70000000000000000000000000000000000000000000000
      00000000000000000000BDAD8C00FFF7EF00FFF7EF00FFF7E700FFEFDE00FFEF
      D600FFEFD600FFE7CE00F7D6B500211808000000000000000000FFEFD600FFFF
      F700FFFFF700FFFFF700FFFFF700FFFFF700FFFFF700EFE7D600CEBDA500CEBD
      A500DECEB5007B5A29009C8452000000000000000000000000000000000073EF
      A5007BEFB5008CF7BD0042EF8C004AEF940029E77B0010EF730000DE5A0021E7
      7300186B08000000000000000000000000000000000000000000FFFFFF009452
      3900A5735A00AD7B6300AD7B6300AD7B63009C634A00AD7B6300A5735A00945A
      4200BDBDBD007B7B7B00F7F7F700000000000000000000000000000000000000
      0000000000000000000000000000FFF7EF00FFFFF700FFF7E700FFF7E700FFF7
      DE00FFEFDE00FFEFD600F7DEB500846B52000000000000000000FFEFD600FFFF
      F700FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFF700DED6C600F7CE9C00D6B5
      7B00A57B31007B5A29000000000000000000000000000000000000000000105A
      0000ADFFD600B5F7CE009CF7BD0084F7B5007BEFAD0052EF94008CF7BD0029A5
      420000000000000000000000000000000000000000000000000000000000FFFF
      FF0073211000AD846B00C6A59400CEBDB50084848400E7DEDE0000000000D6D6
      D600F7F7F700CECECE00A5A5A500000000000000000000000000000000000000
      0000000000000000000000000000DEB58400FFFFF700FFFFF700FFFFEF00FFF7
      EF00FFF7E700FFE7CE00B5844A00000000000000000000000000FFE7D600FFF7
      EF00FFFFF700FFFFF700FFFFF700FFFFF700FFF7F700EFDECE00FFEFCE00CEA5
      6B00735A21009473420000000000000000000000000000000000000000000000
      000000000000219C310084EFAD00B5F7D600A5F7C6004AC66B00105A00000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000EFE7E700F7F7F700DEDEDE00ADADAD00000000000000
      0000CECECE00DEDEDE00F7F7F700000000000000000000000000000000000000
      000000000000000000000000000000000000E7C69C00E7BD9400FFEFD600FFE7
      CE00E7B58400BD94630000000000000000000000000000000000DEC68C00E7C6
      9400E7CE9C00E7CE9C00E7CE9C00E7CE9C00E7C69400DEBD8C00B58C4A007B63
      2900AD8C5A000000000000000000000000000000000000000000000000000000
      0000000000000000000042CE6B00E7FFF700CEFFF70000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000F7F7F700CECECE00FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000C67B1800DE7B0800E784
      0800EF840000DE84000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000A584630031292100423129003931
      2900181008007363520000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000004221100000000000000000000000
      0000000000000000000000000000000000000000000000000000D6944A00D694
      5200D6945200D6945200D6945200D6945200DE944A007B420800BD6B0000DE8C
      0800DE840000DE7B0000EF840000000000000000000000000000D6944A00D694
      5200D6945200D6945200D6945200D6945200C6B5A500EFD6CE00E78C6300E78C
      6300EFDED60094847B0052423100000000000000000000000000D6944A00D694
      5200D6945200D6945200D6945200D6945200D6945200D6945200D6945200D694
      5200D6945200AD73290000000000000000000000000000000000000000000000
      0000000000000000000052291800B55A3900D68C63006B2910008C5A39000000
      0000000000000000000000000000000000000000000000000000DEA56300E7AD
      7300E7AD7300E7AD7300E7AD7300E7AD7300BD6B0000CE730000EF940000EF94
      0000EF940000E7A52100E79C1800DE7B00000000000000000000DEA56300E7AD
      7300E7AD7300E7AD7300DEAD7300DECEBD00E77B5200F7F7F700EFF7F700E763
      2900E7520800E78C6300948C84008C6B5A000000000000000000DEA56300D6A5
      6B00D6A56B00DEAD7300DEAD7300E7AD7300E7AD7300E7AD7300E7AD7300E7AD
      7300E7AD6B00AD73310000000000000000000000000000000000000000000000
      000031180800D67B4A00E7AD7300E7AD7300E7AD7300E7AD7300DE8C52002910
      1000000000000000000000000000000000000000000000000000E7B57B00EFBD
      8C00EFBD8C00EFBD8C00EFBD8C00EFBD8C00E78C0000E7940000BD6B0000EF9C
      0000EF9C00009C520000C66B0000000000000000000000000000E7B57B00EFBD
      8C00EFBD8C00EFBD8C00DEB58400E7CEBD00EF6B1800F7F7EF00FF7B2100F77B
      2900F7732100EF6B1800EFDED600393129000000000000000000E7B57B005252
      4A002939390052A5BD00738C8C00BD9C7300E7BD8C00EFBD8C00EFBD8C00EFBD
      8C00EFBD8400B57B39000000000000000000000000000000000042211000D68C
      5A00F7C68C00F7C68C00F7C68C00F7C68C00EFBD8C008473DE004A4AFF00735A
      BD007B39180063424A0000000000000000000000000000000000EFC68C00F7CE
      A500F7D6A500F7D6A500F7D6A500F7C69400EFA50000C67300006B310000F7BD
      7B00EFAD0000E7A50000C6841000AD5A00000000000000000000EFC68C00F7CE
      A500F7D6A500F7D6A500E7CEAD00E78C4A00E79C6300FFFFFF00FF943900FF94
      3900DEB59C00F78C3100E7A57300423931000000000000000000EFC68C00B5A5
      94005AC6DE0052DEFF0052DEFF00736B6300CEAD8C00EFD6A500F7D6A500F7D6
      A500F7CE9C00B5844200000000000000000000000000C6522100FFDE9C00FFDE
      9C00FFDE9C00FFDE9C00E7D6940031E708002952CE005252FF004A4AFF000000
      EF00D6BDAD00F7BD7B0039181000000000000000000000000000F7D6A500FFE7
      BD00FFE7BD00FFE7BD00FFE7BD00FFE7BD00EFAD1800D6941000C66B0000F7BD
      6B00EFAD0800EFAD0000A5731000CE6B00000000000000000000F7D6A500FFE7
      BD00FFE7BD00FFE7BD00EFDEBD00E7945200FFAD4A00F7E7D600FFAD5200FFAD
      5200FFFFFF00DEBD9400EFA573004A4239000000000000000000F7D6A500E7CE
      AD007BE7FF007BEFFF0073E7FF00102121006B635A00D6C6A500F7E7BD00FFE7
      BD00FFDEB500BD8C4A00000000000000000000000000CE6B4200DEA57B00E7B5
      8C00F7D6A500F7B5520042BD290029E70000295ABD005252FF004A4AFF000000
      EF00B5737300D6946B00BD6B4200000000000000000000000000FFDEB500FFEF
      CE00FFEFD600FFEFD600FFEFD600FFEFD600F7BD6300EFCE5200CE941000C684
      1000EFB51800DE9C0000B5630000D67B08000000000000000000FFDEB500FFEF
      CE00FFEFD600FFEFD600F7E7C600CEB59C00FFB55A00FFD69C00FFBD7300FFBD
      6B00F7EFDE00F7B56300F7DECE00423129000000000000000000FFDEB500FFEF
      CE0084E7FF007BDEEF0094F7FF005AEFFF00082931006B5A5200E7D6BD00FFEF
      D600FFEFCE00BD8C5200000000000000000000000000CE734A00E7B59400E7B5
      9400D68C4A00F7AD4A004ABD290029E700002963B5005252FF007373FF000000
      EF00BD949400DEAD8400CE7B4A00000000000000000000000000FFE7BD00FFF7
      DE00FFF7DE00FFF7DE00FFF7DE00FFF7DE00FFE7C600EFBD5A00EFCE4A00EFBD
      3100EFB51000EFAD0000EF941000000000000000000000000000FFE7BD00FFF7
      DE00FFF7DE00FFF7DE00FFF7DE00F7EFE700EFA56300FFB55A00F7C68C00EFF7
      F700FFFFFF00E7A56B00CEC6BD00000000000000000000000000FFE7BD00FFF7
      D600EFE7CE005A5252005A84840094FFFF005AEFFF0010394200635A5200E7DE
      C600FFEFD600B58C5200000000000000000000000000CE7B5200E7BD9C00E7BD
      9C00D68C4A00F7AD4A0052BD290029E7000052BD73006B6BFF00A5A5F700736B
      DE00D6AD9C00E7B59400D67B5200000000000000000000000000FFE7C600FFF7
      DE00FFFFE700FFFFE700FFFFE700FFFFE700FFFFE700FFE7C600EFBD3900EFAD
      2100D68C1000DE7B080000000000000000000000000000000000FFE7C600FFF7
      DE00FFFFE700FFFFE700FFFFE700FFF7E700F7F7EF00D6B59C00E7A55A00E7A5
      5A00DEC6B500DED6CE00A5947B00000000000000000000000000FFE7C600FFF7
      DE00FFFFE700F7F7DE006B6363004A6B6B009CFFFF0063EFFF00104A5A005A5A
      5200EFE7CE00AD845200000000000000000000000000D6845A00EFCEB500EFCE
      B500D68C4A00F7AD4A0052BD290029E7000029D6210029AD0000E7C6A500E7C6
      A500E7C6A500E7C6A500D6846300000000000000000000000000FFE7C600FFFF
      E700FFFFEF00FFFFEF00FFFFEF00FFFFEF00FFFFEF00FFFFEF00FFFFEF00FFF7
      DE00FFF7DE00BD84390000000000000000000000000000000000FFE7C600FFFF
      E700FFFFEF00FFFFEF00FFFFEF00FFFFEF00FFFFEF00F7EFD600F7EFD600F7EF
      D600F7E7CE00A5845A0000000000000000000000000000000000FFE7C600FFFF
      E700FFFFEF00FFFFEF00FFF7E7007B7B7300395252009CFFFF009CCED6003939
      3900A5A5B500A5845200000000000000000000000000D68C6B00EFD6C600EFD6
      C600D68C5200F7AD4A005ABD290029E7000031DE210029AD0000EFCEBD00EFCE
      BD00EFCEBD00EFCEBD00D68C6B00000000000000000000000000FFEFCE00FFFF
      EF00FFFFEF00FFFFEF00FFFFEF00FFFFEF00FFFFEF00FFFFEF00FFFFEF00FFFF
      EF00FFF7E700AD8C520000000000000000000000000000000000FFEFCE00FFFF
      EF00FFFFEF00FFFFEF00FFFFEF00FFFFEF00FFFFEF00FFFFEF00FFFFEF00FFFF
      EF00FFF7E700AD8C630000000000000000000000000000000000FFEFCE00FFFF
      EF00FFFFEF00FFFFEF00FFFFEF00FFFFEF009C9C94008484840094949C00A59C
      CE00AD9CBD009C7B5200000000000000000000000000DE947300F7DED600F7DE
      D600D68C5200F7AD4A0084CE420031E7000031CE00005ACE3100F7DECE00F7DE
      CE00F7DECE00F7DECE00D68C6300000000000000000000000000FFEFCE00FFFF
      EF00FFFFF700FFFFF700FFFFF700FFFFF700FFFFF700FFF7EF00F7EFE700F7F7
      E700F7EFDE0084633100B5946300000000000000000000000000FFEFCE00FFFF
      EF00FFFFF700FFFFF700FFFFF700FFFFF700FFFFF700FFF7EF00F7EFE700F7F7
      E700F7EFDE0084633100B5946300000000000000000000000000FFEFCE00FFFF
      EF00FFFFF700FFFFF700FFFFF700FFFFF700FFFFF700C6C6C600947BB500846B
      B500E7DECE0084633100AD9463000000000000000000C6633900EFBDA500F7EF
      E700D6945A00F7AD4A00FFA51800C67B0800E7EFCE00F7E7DE00F7E7DE00F7E7
      DE00F7E7DE00EFBD9400D6846300000000000000000000000000FFEFD600FFFF
      F700FFFFF700FFFFF700FFFFF700FFFFF700FFFFF700EFE7D600CEBDA500CEBD
      A500DECEB5007B5A29009C845200000000000000000000000000FFEFD600FFFF
      F700FFFFF700FFFFF700FFFFF700FFFFF700FFFFF700EFE7D600CEBDA500CEBD
      A500DECEB5007B5A29009C845200000000000000000000000000FFEFD600FFFF
      F700FFFFF700FFFFF700FFFFF700FFFFF700FFFFF700EFE7D600CEBDA500CEBD
      A500DECEB5007B5A29009C7B520000000000000000000000000000000000C65A
      3100D68C5200F7AD4A00FFA51800C67B0000FFF7EF00FFF7EF00F7CEB500D673
      4200E7AD8C000000000000000000000000000000000000000000FFEFD600FFFF
      F700FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFF700DED6C600F7CE9C00D6B5
      7B00A57B31008463310000000000000000000000000000000000FFEFD600FFFF
      F700FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFF700DED6C600F7CE9C00D6B5
      7B00A57B31008463310000000000000000000000000000000000FFEFD600FFFF
      F700FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFF700DED6C600F7CE9C00D6B5
      7B00A57B31007B5A290000000000000000000000000000000000000000000000
      0000D68C4A00F7AD4A00F7A52100C67B0000D67B4A00D6946B00000000000000
      0000000000000000000000000000000000000000000000000000FFE7D600FFF7
      EF00FFFFF700FFFFF700FFFFF700FFFFF700FFF7EF00E7DECE00FFEFCE00CEAD
      6B00735A21009473420000000000000000000000000000000000FFE7D600FFF7
      EF00FFFFF700FFFFF700FFFFF700FFFFF700FFF7EF00E7DECE00FFEFCE00CEAD
      6B00735A21009473420000000000000000000000000000000000FFE7D600FFF7
      EF00FFFFF700FFFFF700FFFFF700FFFFF700FFF7EF00E7DECE00FFEFCE00CEAD
      6B00735A21009473420000000000000000000000000000000000000000000000
      0000E7A56B00DE8C3100EF941800F7AD42000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000DEC68C00E7C6
      9400E7CE9C00E7CE9C00E7CE9C00E7CE9C00E7C69400DEBD8C00B58C4A007B63
      2900AD8C5A000000000000000000000000000000000000000000DEC68C00E7C6
      9400E7CE9C00E7CE9C00E7CE9C00E7CE9C00E7C69400DEBD8C00B58C4A007B63
      2900AD8C5A000000000000000000000000000000000000000000DEC68C00E7C6
      9400E7CE9C00E7CE9C00E7CE9C00E7CE9C00E7C69400DEBD8C00B58C4A007B63
      2900AD8C5A000000000000000000000000000000000000000000000000000000
      00000000000000000000EFAD6300000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000500000000100010000000000800200000000000000000000
      000000000000000000000000FFFFFF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000FFFFFFFF00000000C003C00300000000
      C003C00300000000C003C00300000000C003C00300000000C003C00300000000
      C003C00300000000C003C00300000000C003C00300000000C003C00300000000
      C003C00300000000C001C00100000000C001C00100000000C003C00300000000
      C003C00300000000C007C0070000000080018001FF83FFFF80018001C001F00F
      80018001C000C00380008000C001800180008000C000000180008000C0000000
      80008000C000000080008000C001000080008000C003000080018001C0030000
      80018001C003000080018001C001000180038003C001800180078007C0038003
      80098009C003E007C01FC01FC007F01F01FFFFFFFC3F7F8300FFC003F87F3F01
      00FFC003E00F3E000007C003C0071C000003C003C00708008003C003C0030000
      8007C003C0070000800FC001E00700008007C001C00F00018001C001C0070003
      C000C003C0438007FC00C001C0078003FC00C001E007C001FE00C003E00FE021
      FE01C003F81FFC31FF03C007FC7FFE3FFF83FF03FFFFFF7FC001C001C003FC1F
      C000C000C003F00FC001C000C003C003C000C000C0038001C000C000C0038001
      C000C000C0038001C001C001C0038001C003C001C0038001C003C003C0038001
      C003C003C0038001C001C001C0018001C001C001C001E007C003C003C003F03F
      C003C003C003F0FFC007C007C007FDFF00000000000000000000000000000000
      000000000000}
  end
  object ReportPanelStyler: TAdvPanelStyler
    Tag = 0
    Settings.AnchorHint = False
    Settings.BevelInner = bvNone
    Settings.BevelOuter = bvNone
    Settings.BevelWidth = 1
    Settings.BorderColor = 16765615
    Settings.BorderShadow = False
    Settings.BorderStyle = bsNone
    Settings.BorderWidth = 0
    Settings.CanMove = False
    Settings.CanSize = False
    Settings.Caption.Color = 12105910
    Settings.Caption.ColorTo = 10526878
    Settings.Caption.Font.Charset = DEFAULT_CHARSET
    Settings.Caption.Font.Color = clWhite
    Settings.Caption.Font.Height = -11
    Settings.Caption.Font.Name = 'MS Sans Serif'
    Settings.Caption.Font.Style = []
    Settings.Caption.GradientDirection = gdVertical
    Settings.Caption.Indent = 2
    Settings.Caption.ShadeLight = 255
    Settings.Collaps = False
    Settings.CollapsColor = clHighlight
    Settings.CollapsDelay = 0
    Settings.CollapsSteps = 0
    Settings.Color = 13616833
    Settings.ColorTo = 12958644
    Settings.ColorMirror = 12958644
    Settings.ColorMirrorTo = 15527141
    Settings.Cursor = crDefault
    Settings.Font.Charset = DEFAULT_CHARSET
    Settings.Font.Color = 7485192
    Settings.Font.Height = -11
    Settings.Font.Name = 'MS Sans Serif'
    Settings.Font.Style = []
    Settings.FixedTop = False
    Settings.FixedLeft = False
    Settings.FixedHeight = False
    Settings.FixedWidth = False
    Settings.Height = 120
    Settings.Hover = False
    Settings.HoverColor = clNone
    Settings.HoverFontColor = clNone
    Settings.Indent = 0
    Settings.ShadowColor = clBlack
    Settings.ShadowOffset = 0
    Settings.ShowHint = False
    Settings.ShowMoveCursor = False
    Settings.StatusBar.BorderStyle = bsSingle
    Settings.StatusBar.Font.Charset = DEFAULT_CHARSET
    Settings.StatusBar.Font.Color = clWhite
    Settings.StatusBar.Font.Height = -11
    Settings.StatusBar.Font.Name = 'Tahoma'
    Settings.StatusBar.Font.Style = []
    Settings.StatusBar.Color = 10592158
    Settings.StatusBar.ColorTo = 5459275
    Settings.StatusBar.GradientDirection = gdVertical
    Settings.TextVAlign = tvaTop
    Settings.TopIndent = 0
    Settings.URLColor = clBlue
    Settings.Width = 0
    Style = psOffice2007Obsidian
    Left = 776
    Top = 336
  end
  object AdvToolBarOfficeStyler1: TAdvToolBarOfficeStyler
    Style = bsOffice2007Obsidian
    BackGroundDisplay = bdCenter
    BorderColor = 11841710
    BorderColorHot = 11841710
    ButtonAppearance.Color = 13627626
    ButtonAppearance.ColorTo = 9224369
    ButtonAppearance.ColorChecked = 9229823
    ButtonAppearance.ColorCheckedTo = 5812223
    ButtonAppearance.ColorDown = 5149182
    ButtonAppearance.ColorDownTo = 9556991
    ButtonAppearance.ColorHot = 13432063
    ButtonAppearance.ColorHotTo = 9556223
    ButtonAppearance.BorderDownColor = 3693887
    ButtonAppearance.BorderHotColor = 3693887
    ButtonAppearance.BorderCheckedColor = 3693887
    ButtonAppearance.CaptionFont.Charset = DEFAULT_CHARSET
    ButtonAppearance.CaptionFont.Color = clWindowText
    ButtonAppearance.CaptionFont.Height = -11
    ButtonAppearance.CaptionFont.Name = 'Tahoma'
    ButtonAppearance.CaptionFont.Style = []
    CaptionAppearance.CaptionColor = 12105910
    CaptionAppearance.CaptionColorTo = 10526878
    CaptionAppearance.CaptionBorderColor = clBlack
    CaptionAppearance.CaptionColorHot = 11184809
    CaptionAppearance.CaptionColorHotTo = 7237229
    CaptionFont.Charset = DEFAULT_CHARSET
    CaptionFont.Color = clWindowText
    CaptionFont.Height = -11
    CaptionFont.Name = 'Tahoma'
    CaptionFont.Style = []
    ContainerAppearance.LineColor = clBtnShadow
    ContainerAppearance.Line3D = True
    Color.Color = 12958644
    Color.ColorTo = 15527141
    Color.Direction = gdVertical
    Color.Mirror.Color = 14736343
    Color.Mirror.ColorTo = 13617090
    Color.Mirror.ColorMirror = 13024437
    Color.Mirror.ColorMirrorTo = 15000281
    ColorHot.Color = 15921390
    ColorHot.ColorTo = 16316662
    ColorHot.Direction = gdVertical
    ColorHot.Mirror.Color = 15789804
    ColorHot.Mirror.ColorTo = 15592168
    ColorHot.Mirror.ColorMirror = 15131103
    ColorHot.Mirror.ColorMirrorTo = 16185075
    CompactGlowButtonAppearance.BorderColor = 12631218
    CompactGlowButtonAppearance.BorderColorHot = 10079963
    CompactGlowButtonAppearance.BorderColorDown = 4548219
    CompactGlowButtonAppearance.BorderColorChecked = 4548219
    CompactGlowButtonAppearance.Color = 14671574
    CompactGlowButtonAppearance.ColorTo = 15000283
    CompactGlowButtonAppearance.ColorChecked = 11918331
    CompactGlowButtonAppearance.ColorCheckedTo = 7915518
    CompactGlowButtonAppearance.ColorDisabled = 15921906
    CompactGlowButtonAppearance.ColorDisabledTo = 15921906
    CompactGlowButtonAppearance.ColorDown = 7778289
    CompactGlowButtonAppearance.ColorDownTo = 4296947
    CompactGlowButtonAppearance.ColorHot = 15465983
    CompactGlowButtonAppearance.ColorHotTo = 11332863
    CompactGlowButtonAppearance.ColorMirror = 14144974
    CompactGlowButtonAppearance.ColorMirrorTo = 15197664
    CompactGlowButtonAppearance.ColorMirrorHot = 5888767
    CompactGlowButtonAppearance.ColorMirrorHotTo = 10807807
    CompactGlowButtonAppearance.ColorMirrorDown = 946929
    CompactGlowButtonAppearance.ColorMirrorDownTo = 5021693
    CompactGlowButtonAppearance.ColorMirrorChecked = 10480637
    CompactGlowButtonAppearance.ColorMirrorCheckedTo = 5682430
    CompactGlowButtonAppearance.ColorMirrorDisabled = 11974326
    CompactGlowButtonAppearance.ColorMirrorDisabledTo = 15921906
    CompactGlowButtonAppearance.GradientHot = ggVertical
    CompactGlowButtonAppearance.GradientMirrorHot = ggVertical
    CompactGlowButtonAppearance.GradientDown = ggVertical
    CompactGlowButtonAppearance.GradientMirrorDown = ggVertical
    CompactGlowButtonAppearance.GradientChecked = ggVertical
    DockColor.Color = 13616833
    DockColor.ColorTo = 12958644
    DockColor.Direction = gdHorizontal
    DockColor.Steps = 128
    DragGripStyle = dsNone
    FloatingWindowBorderColor = 11841710
    FloatingWindowBorderWidth = 1
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    GlowButtonAppearance.BorderColor = 12631218
    GlowButtonAppearance.BorderColorHot = 10079963
    GlowButtonAppearance.BorderColorDown = 4548219
    GlowButtonAppearance.BorderColorChecked = 4548219
    GlowButtonAppearance.Color = 14671574
    GlowButtonAppearance.ColorTo = 15000283
    GlowButtonAppearance.ColorChecked = 11918331
    GlowButtonAppearance.ColorCheckedTo = 7915518
    GlowButtonAppearance.ColorDisabled = 15921906
    GlowButtonAppearance.ColorDisabledTo = 15921906
    GlowButtonAppearance.ColorDown = 7778289
    GlowButtonAppearance.ColorDownTo = 4296947
    GlowButtonAppearance.ColorHot = 15465983
    GlowButtonAppearance.ColorHotTo = 11332863
    GlowButtonAppearance.ColorMirror = 14144974
    GlowButtonAppearance.ColorMirrorTo = 15197664
    GlowButtonAppearance.ColorMirrorHot = 5888767
    GlowButtonAppearance.ColorMirrorHotTo = 10807807
    GlowButtonAppearance.ColorMirrorDown = 946929
    GlowButtonAppearance.ColorMirrorDownTo = 5021693
    GlowButtonAppearance.ColorMirrorChecked = 10480637
    GlowButtonAppearance.ColorMirrorCheckedTo = 5682430
    GlowButtonAppearance.ColorMirrorDisabled = 11974326
    GlowButtonAppearance.ColorMirrorDisabledTo = 15921906
    GlowButtonAppearance.GradientHot = ggVertical
    GlowButtonAppearance.GradientMirrorHot = ggVertical
    GlowButtonAppearance.GradientDown = ggVertical
    GlowButtonAppearance.GradientMirrorDown = ggVertical
    GlowButtonAppearance.GradientChecked = ggVertical
    GroupAppearance.BorderColor = 8878963
    GroupAppearance.Color = 4413279
    GroupAppearance.ColorTo = 3620416
    GroupAppearance.ColorMirror = 4413279
    GroupAppearance.ColorMirrorTo = 1617645
    GroupAppearance.Font.Charset = DEFAULT_CHARSET
    GroupAppearance.Font.Color = clWindowText
    GroupAppearance.Font.Height = -11
    GroupAppearance.Font.Name = 'Tahoma'
    GroupAppearance.Font.Style = []
    GroupAppearance.Gradient = ggRadial
    GroupAppearance.GradientMirror = ggRadial
    GroupAppearance.TextColor = clWhite
    GroupAppearance.CaptionAppearance.CaptionColor = 12105910
    GroupAppearance.CaptionAppearance.CaptionColorTo = 10526878
    GroupAppearance.CaptionAppearance.CaptionColorHot = 11184809
    GroupAppearance.CaptionAppearance.CaptionColorHotTo = 7237229
    GroupAppearance.PageAppearance.BorderColor = 12763842
    GroupAppearance.PageAppearance.Color = 15530237
    GroupAppearance.PageAppearance.ColorTo = 16382457
    GroupAppearance.PageAppearance.ColorMirror = 16382457
    GroupAppearance.PageAppearance.ColorMirrorTo = 16382457
    GroupAppearance.PageAppearance.Gradient = ggVertical
    GroupAppearance.PageAppearance.GradientMirror = ggVertical
    GroupAppearance.PageAppearance.ShadowColor = clBlack
    GroupAppearance.PageAppearance.HighLightColor = 15526887
    GroupAppearance.TabAppearance.BorderColor = 10534860
    GroupAppearance.TabAppearance.BorderColorHot = 9870494
    GroupAppearance.TabAppearance.BorderColorSelected = 10534860
    GroupAppearance.TabAppearance.BorderColorSelectedHot = 10534860
    GroupAppearance.TabAppearance.BorderColorDisabled = clNone
    GroupAppearance.TabAppearance.BorderColorDown = clNone
    GroupAppearance.TabAppearance.Color = clBtnFace
    GroupAppearance.TabAppearance.ColorTo = clWhite
    GroupAppearance.TabAppearance.ColorSelected = 10412027
    GroupAppearance.TabAppearance.ColorSelectedTo = 12249340
    GroupAppearance.TabAppearance.ColorDisabled = clNone
    GroupAppearance.TabAppearance.ColorDisabledTo = clNone
    GroupAppearance.TabAppearance.ColorHot = 5992568
    GroupAppearance.TabAppearance.ColorHotTo = 9803415
    GroupAppearance.TabAppearance.ColorMirror = clWhite
    GroupAppearance.TabAppearance.ColorMirrorTo = clWhite
    GroupAppearance.TabAppearance.ColorMirrorHot = 4413279
    GroupAppearance.TabAppearance.ColorMirrorHotTo = 1617645
    GroupAppearance.TabAppearance.ColorMirrorSelected = 12249340
    GroupAppearance.TabAppearance.ColorMirrorSelectedTo = 13955581
    GroupAppearance.TabAppearance.ColorMirrorDisabled = clNone
    GroupAppearance.TabAppearance.ColorMirrorDisabledTo = clNone
    GroupAppearance.TabAppearance.Font.Charset = DEFAULT_CHARSET
    GroupAppearance.TabAppearance.Font.Color = clWindowText
    GroupAppearance.TabAppearance.Font.Height = -11
    GroupAppearance.TabAppearance.Font.Name = 'Tahoma'
    GroupAppearance.TabAppearance.Font.Style = []
    GroupAppearance.TabAppearance.Gradient = ggRadial
    GroupAppearance.TabAppearance.GradientMirror = ggRadial
    GroupAppearance.TabAppearance.GradientHot = ggVertical
    GroupAppearance.TabAppearance.GradientMirrorHot = ggVertical
    GroupAppearance.TabAppearance.GradientSelected = ggVertical
    GroupAppearance.TabAppearance.GradientMirrorSelected = ggVertical
    GroupAppearance.TabAppearance.GradientDisabled = ggVertical
    GroupAppearance.TabAppearance.GradientMirrorDisabled = ggVertical
    GroupAppearance.TabAppearance.TextColor = clWhite
    GroupAppearance.TabAppearance.TextColorHot = clWhite
    GroupAppearance.TabAppearance.TextColorSelected = 9126421
    GroupAppearance.TabAppearance.TextColorDisabled = clWhite
    GroupAppearance.TabAppearance.ShadowColor = clBlack
    GroupAppearance.TabAppearance.HighLightColor = 9803929
    GroupAppearance.TabAppearance.HighLightColorHot = 9803929
    GroupAppearance.TabAppearance.HighLightColorSelected = 6540536
    GroupAppearance.TabAppearance.HighLightColorSelectedHot = 12451839
    GroupAppearance.TabAppearance.HighLightColorDown = 16776144
    GroupAppearance.ToolBarAppearance.BorderColor = 13423059
    GroupAppearance.ToolBarAppearance.BorderColorHot = 13092807
    GroupAppearance.ToolBarAppearance.Color.Color = 15530237
    GroupAppearance.ToolBarAppearance.Color.ColorTo = 16382457
    GroupAppearance.ToolBarAppearance.Color.Direction = gdHorizontal
    GroupAppearance.ToolBarAppearance.ColorHot.Color = 15660277
    GroupAppearance.ToolBarAppearance.ColorHot.ColorTo = 16645114
    GroupAppearance.ToolBarAppearance.ColorHot.Direction = gdHorizontal
    PageAppearance.BorderColor = 11841710
    PageAppearance.Color = 14736343
    PageAppearance.ColorTo = 13617090
    PageAppearance.ColorMirror = 13024437
    PageAppearance.ColorMirrorTo = 15790311
    PageAppearance.Gradient = ggVertical
    PageAppearance.GradientMirror = ggVertical
    PageAppearance.ShadowColor = 5263440
    PageAppearance.HighLightColor = 15526887
    PagerCaption.BorderColor = clBlack
    PagerCaption.Color = 5392195
    PagerCaption.ColorTo = 4866108
    PagerCaption.ColorMirror = 3158063
    PagerCaption.ColorMirrorTo = 4079166
    PagerCaption.Gradient = ggVertical
    PagerCaption.GradientMirror = ggVertical
    PagerCaption.TextColor = clBlue
    PagerCaption.Font.Charset = DEFAULT_CHARSET
    PagerCaption.Font.Color = clWindowText
    PagerCaption.Font.Height = -11
    PagerCaption.Font.Name = 'Tahoma'
    PagerCaption.Font.Style = []
    QATAppearance.BorderColor = 2697513
    QATAppearance.Color = 8683131
    QATAppearance.ColorTo = 4671303
    QATAppearance.FullSizeBorderColor = 13552843
    QATAppearance.FullSizeColor = 9407882
    QATAppearance.FullSizeColorTo = 9407882
    RightHandleColor = 13289414
    RightHandleColorTo = 11841710
    RightHandleColorHot = 13891839
    RightHandleColorHotTo = 7782911
    RightHandleColorDown = 557032
    RightHandleColorDownTo = 8182519
    TabAppearance.BorderColor = clNone
    TabAppearance.BorderColorHot = 9870494
    TabAppearance.BorderColorSelected = 14922381
    TabAppearance.BorderColorSelectedHot = 6343929
    TabAppearance.BorderColorDisabled = clNone
    TabAppearance.BorderColorDown = clNone
    TabAppearance.Color = clBtnFace
    TabAppearance.ColorTo = clWhite
    TabAppearance.ColorSelected = 15724269
    TabAppearance.ColorSelectedTo = 15724269
    TabAppearance.ColorDisabled = clWhite
    TabAppearance.ColorDisabledTo = clSilver
    TabAppearance.ColorHot = 5992568
    TabAppearance.ColorHotTo = 9803415
    TabAppearance.ColorMirror = clWhite
    TabAppearance.ColorMirrorTo = clWhite
    TabAppearance.ColorMirrorHot = 4413279
    TabAppearance.ColorMirrorHotTo = 1617645
    TabAppearance.ColorMirrorSelected = 13816526
    TabAppearance.ColorMirrorSelectedTo = 13816526
    TabAppearance.ColorMirrorDisabled = clWhite
    TabAppearance.ColorMirrorDisabledTo = clSilver
    TabAppearance.Font.Charset = DEFAULT_CHARSET
    TabAppearance.Font.Color = clWindowText
    TabAppearance.Font.Height = -11
    TabAppearance.Font.Name = 'Tahoma'
    TabAppearance.Font.Style = []
    TabAppearance.Gradient = ggVertical
    TabAppearance.GradientMirror = ggVertical
    TabAppearance.GradientHot = ggRadial
    TabAppearance.GradientMirrorHot = ggRadial
    TabAppearance.GradientSelected = ggVertical
    TabAppearance.GradientMirrorSelected = ggVertical
    TabAppearance.GradientDisabled = ggVertical
    TabAppearance.GradientMirrorDisabled = ggVertical
    TabAppearance.TextColor = clWhite
    TabAppearance.TextColorHot = clWhite
    TabAppearance.TextColorSelected = clBlack
    TabAppearance.TextColorDisabled = clGray
    TabAppearance.ShadowColor = clBlack
    TabAppearance.HighLightColor = 9803929
    TabAppearance.HighLightColorHot = 9803929
    TabAppearance.HighLightColorSelected = 6540536
    TabAppearance.HighLightColorSelectedHot = 12451839
    TabAppearance.HighLightColorDown = 16776144
    TabAppearance.BackGround.Color = 5460819
    TabAppearance.BackGround.ColorTo = 3815994
    TabAppearance.BackGround.Direction = gdVertical
    Left = 777
    Top = 259
  end
  object AdvOfficePagerOfficeStyler1: TAdvOfficePagerOfficeStyler
    Style = psOffice2007Obsidian
    PageAppearance.BorderColor = 11841710
    PageAppearance.Color = 13616833
    PageAppearance.ColorTo = 12958644
    PageAppearance.ColorMirror = 12958644
    PageAppearance.ColorMirrorTo = 15527141
    PageAppearance.Gradient = ggVertical
    PageAppearance.GradientMirror = ggVertical
    TabAppearance.BorderColor = clNone
    TabAppearance.BorderColorHot = 9870494
    TabAppearance.BorderColorSelected = 14922381
    TabAppearance.BorderColorSelectedHot = 6343929
    TabAppearance.BorderColorDisabled = clNone
    TabAppearance.BorderColorDown = clNone
    TabAppearance.Color = clBtnFace
    TabAppearance.ColorTo = clWhite
    TabAppearance.ColorSelected = 15724269
    TabAppearance.ColorSelectedTo = 15724269
    TabAppearance.ColorDisabled = clWhite
    TabAppearance.ColorDisabledTo = clSilver
    TabAppearance.ColorHot = 5992568
    TabAppearance.ColorHotTo = 9803415
    TabAppearance.ColorMirror = clWhite
    TabAppearance.ColorMirrorTo = clWhite
    TabAppearance.ColorMirrorHot = 4413279
    TabAppearance.ColorMirrorHotTo = 1617645
    TabAppearance.ColorMirrorSelected = 13816526
    TabAppearance.ColorMirrorSelectedTo = 13816526
    TabAppearance.ColorMirrorDisabled = clWhite
    TabAppearance.ColorMirrorDisabledTo = clSilver
    TabAppearance.Font.Charset = DEFAULT_CHARSET
    TabAppearance.Font.Color = clWindowText
    TabAppearance.Font.Height = -11
    TabAppearance.Font.Name = 'Tahoma'
    TabAppearance.Font.Style = []
    TabAppearance.Gradient = ggVertical
    TabAppearance.GradientMirror = ggVertical
    TabAppearance.GradientHot = ggRadial
    TabAppearance.GradientMirrorHot = ggRadial
    TabAppearance.GradientSelected = ggVertical
    TabAppearance.GradientMirrorSelected = ggVertical
    TabAppearance.GradientDisabled = ggVertical
    TabAppearance.GradientMirrorDisabled = ggVertical
    TabAppearance.TextColor = clWhite
    TabAppearance.TextColorHot = clWhite
    TabAppearance.TextColorSelected = clBlack
    TabAppearance.TextColorDisabled = clGray
    TabAppearance.ShadowColor = clBlack
    TabAppearance.HighLightColor = 9803929
    TabAppearance.HighLightColorHot = 9803929
    TabAppearance.HighLightColorSelected = 6540536
    TabAppearance.HighLightColorSelectedHot = 12451839
    TabAppearance.HighLightColorDown = 16776144
    TabAppearance.BackGround.Color = 5460819
    TabAppearance.BackGround.ColorTo = 3815994
    TabAppearance.BackGround.Direction = gdVertical
    GlowButtonAppearance.BorderColor = 12631218
    GlowButtonAppearance.BorderColorHot = 10079963
    GlowButtonAppearance.BorderColorDown = 4548219
    GlowButtonAppearance.BorderColorChecked = 4548219
    GlowButtonAppearance.Color = 14671574
    GlowButtonAppearance.ColorTo = 15000283
    GlowButtonAppearance.ColorChecked = 11918331
    GlowButtonAppearance.ColorCheckedTo = 7915518
    GlowButtonAppearance.ColorDisabled = 15921906
    GlowButtonAppearance.ColorDisabledTo = 15921906
    GlowButtonAppearance.ColorDown = 7778289
    GlowButtonAppearance.ColorDownTo = 4296947
    GlowButtonAppearance.ColorHot = 15465983
    GlowButtonAppearance.ColorHotTo = 11332863
    GlowButtonAppearance.ColorMirror = 14144974
    GlowButtonAppearance.ColorMirrorTo = 15197664
    GlowButtonAppearance.ColorMirrorHot = 5888767
    GlowButtonAppearance.ColorMirrorHotTo = 10807807
    GlowButtonAppearance.ColorMirrorDown = 946929
    GlowButtonAppearance.ColorMirrorDownTo = 5021693
    GlowButtonAppearance.ColorMirrorChecked = 10480637
    GlowButtonAppearance.ColorMirrorCheckedTo = 5682430
    GlowButtonAppearance.ColorMirrorDisabled = 11974326
    GlowButtonAppearance.ColorMirrorDisabledTo = 15921906
    GlowButtonAppearance.GradientHot = ggVertical
    GlowButtonAppearance.GradientMirrorHot = ggVertical
    GlowButtonAppearance.GradientDown = ggVertical
    GlowButtonAppearance.GradientMirrorDown = ggVertical
    GlowButtonAppearance.GradientChecked = ggVertical
    Left = 513
    Top = 355
  end
  object ReportFormStyler1: TAdvFormStyler
    AutoThemeAdapt = True
    Style = tsOffice2007Obsidian
    Left = 769
    Top = 367
  end
  object pmTechYchetMTZ: TAdvPopupMenu
    Version = '2.5.2.4'
    Left = 138
    Top = 283
    object miCheckPins: TMenuItem
      Caption = '�������� ���'
    end
    object miUncheckPins: TMenuItem
      Caption = '������ ���������'
    end
  end
  object pmMaxPowerSaveData: TAdvPopupMenu
    Version = '2.5.2.4'
    Left = 202
    Top = 259
    object MenuItem1: TMenuItem
      Caption = '�������� ���'
    end
    object MenuItem2: TMenuItem
      Caption = '������ ���������'
    end
    object N1: TMenuItem
      Caption = '���������'
    end
  end
  object AdvMenuOfficeStyler1: TAdvMenuOfficeStyler
    AntiAlias = aaNone
    AutoThemeAdapt = True
    Style = osOffice2003Blue
    Background.Position = bpCenter
    Background.Color = 16185078
    Background.ColorTo = 16185078
    ButtonAppearance.DownColor = 5149182
    ButtonAppearance.DownColorTo = 9556991
    ButtonAppearance.HoverColor = 13432063
    ButtonAppearance.HoverColorTo = 9556223
    ButtonAppearance.DownBorderColor = clNavy
    ButtonAppearance.HoverBorderColor = clNavy
    ButtonAppearance.CaptionFont.Charset = DEFAULT_CHARSET
    ButtonAppearance.CaptionFont.Color = clWindowText
    ButtonAppearance.CaptionFont.Height = -11
    ButtonAppearance.CaptionFont.Name = 'Tahoma'
    ButtonAppearance.CaptionFont.Style = []
    IconBar.Color = 16773091
    IconBar.ColorTo = 14986631
    IconBar.CheckBorder = clNavy
    IconBar.RadioBorder = clNavy
    IconBar.SeparatorColor = 12961221
    SelectedItem.BorderColor = clNavy
    SelectedItem.Font.Charset = DEFAULT_CHARSET
    SelectedItem.Font.Color = clWindowText
    SelectedItem.Font.Height = -11
    SelectedItem.Font.Name = 'Tahoma'
    SelectedItem.Font.Style = []
    SelectedItem.NotesFont.Charset = DEFAULT_CHARSET
    SelectedItem.NotesFont.Color = clWindowText
    SelectedItem.NotesFont.Height = -8
    SelectedItem.NotesFont.Name = 'Tahoma'
    SelectedItem.NotesFont.Style = []
    SelectedItem.CheckBorder = clNavy
    SelectedItem.RadioBorder = clNavy
    RootItem.Color = 16105118
    RootItem.ColorTo = 16240050
    RootItem.Font.Charset = DEFAULT_CHARSET
    RootItem.Font.Color = clWindowText
    RootItem.Font.Height = -11
    RootItem.Font.Name = 'Tahoma'
    RootItem.Font.Style = []
    RootItem.SelectedColor = 16773091
    RootItem.SelectedColorTo = 15185299
    RootItem.SelectedBorderColor = 9841920
    RootItem.HoverColor = 13432063
    RootItem.HoverColorTo = 10147583
    Glyphs.SubMenu.Data = {
      5A000000424D5A000000000000003E0000002800000004000000070000000100
      0100000000001C0000000000000000000000020000000200000000000000FFFF
      FF0070000000300000001000000000000000100000003000000070000000}
    Glyphs.Check.Data = {
      7E000000424D7E000000000000003E0000002800000010000000100000000100
      010000000000400000000000000000000000020000000200000000000000FFFF
      FF00FFFF0000FFFF0000FFFF0000FFFF0000FDFF0000F8FF0000F07F0000F23F
      0000F71F0000FF8F0000FFCF0000FFEF0000FFFF0000FFFF0000FFFF0000FFFF
      0000}
    Glyphs.Radio.Data = {
      7E000000424D7E000000000000003E0000002800000010000000100000000100
      010000000000400000000000000000000000020000000200000000000000FFFF
      FF00FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FC3F0000F81F0000F81F
      0000F81F0000F81F0000FC3F0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF
      0000}
    SideBar.Font.Charset = DEFAULT_CHARSET
    SideBar.Font.Color = clWhite
    SideBar.Font.Height = -19
    SideBar.Font.Name = 'Tahoma'
    SideBar.Font.Style = [fsBold, fsItalic]
    SideBar.Image.Position = bpCenter
    SideBar.Background.Position = bpCenter
    SideBar.SplitterColorTo = clBlack
    Separator.Color = 13339754
    Separator.GradientType = gtBoth
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    NotesFont.Charset = DEFAULT_CHARSET
    NotesFont.Color = clGray
    NotesFont.Height = -8
    NotesFont.Name = 'Tahoma'
    NotesFont.Style = []
    MenuBorderColor = 9841920
    Left = 330
    Top = 307
  end
end
