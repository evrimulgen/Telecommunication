object ReportAPIRejectBlocksForm: TReportAPIRejectBlocksForm
  Left = 0
  Top = 0
  Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1086#1090#1082#1083#1086#1085#1077#1085#1085#1099#1084' '#1073#1083#1086#1082#1080#1088#1086#1074#1082#1072#1084'/'#1088#1072#1079#1073#1083#1086#1082#1080#1088#1086#1074#1082#1072#1084' '#1095#1077#1088#1077#1079' API'
  ClientHeight = 566
  ClientWidth = 1197
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 120
  TextHeight = 17
  object p1: TPanel
    Left = 0
    Top = 106
    Width = 1197
    Height = 460
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alClient
    Caption = 'p1'
    TabOrder = 0
  end
  object pFilter: TPanel
    Left = 0
    Top = 0
    Width = 1197
    Height = 106
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    object lbl1: TLabel
      Left = 21
      Top = 24
      Width = 172
      Height = 18
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = #1044#1072#1090#1072' '#1085#1072#1095#1072#1083#1072' '#1087#1077#1088#1080#1086#1076#1072':'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lbl2: TLabel
      Left = 21
      Top = 71
      Width = 163
      Height = 18
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = #1044#1072#1090#1072' '#1082#1086#1085#1094#1072' '#1087#1077#1088#1080#1086#1076#1072':'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lbl3: TLabel
      Left = 382
      Top = 24
      Width = 89
      Height = 18
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = #1058#1080#1087' '#1079#1072#1103#1074#1082#1080':'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lbl4: TLabel
      Left = 382
      Top = 71
      Width = 116
      Height = 18
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = #1057#1090#1072#1090#1091#1089' '#1079#1072#1103#1074#1082#1080':'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object dtDateBegin: TDateTimePicker
      Left = 207
      Top = 18
      Width = 126
      Height = 25
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Date = 41921.523304525460000000
      Time = 41921.523304525460000000
      TabOrder = 0
      OnChange = dtDateBeginChange
    end
    object dtDateEnd: TDateTimePicker
      Left = 207
      Top = 65
      Width = 126
      Height = 25
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Date = 41921.523304525460000000
      Time = 41921.523304525460000000
      TabOrder = 1
      OnChange = dtDateEndChange
    end
    object btRefresh: TBitBtn
      Left = 850
      Top = 14
      Width = 177
      Height = 38
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = #1054#1073#1085#1086#1074#1080#1090#1100
      Glyph.Data = {
        36090000424D3609000000000000360000002800000018000000180000000100
        2000000000000009000000000000000000000000000000000000FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00C69C8400BD733900C673
        3900C6733900C67B4200C6733900BD6B3100BD7B4A00BD9C8400FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00D6AD9C00BD6B3100C6844A00DE9C5A00DE9C
        5A00DE9C5200DE9C5200DE944A00DE8C4200D6843900C6733100BD734200B5AD
        A500BD9C8C00BD6B3100BD6B3100FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00D6AD9C00BD6B3900DEAD7300E7B57300E7AD7300DEAD
        6B00E7B57B00E7BD8C00E7BD8C00DEA56300D68C4200DE8C3900CE7B3100B563
        2900B5632900C66B1800BD5A1800B58C7300FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00DEBDAD00B5633100E7B57B00E7BD8400E7B57B00E7B58400DEAD
        7B00D6A56B00D6945A00DEA57300E7BD9400EFCEA500DEA56300D68C3900D684
        3100CE7B2100CE731800B55A1800B57B5200FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00B55A3100DEB58400E7BD8C00E7BD8400D6A56B00BD6B3900AD52
        2100BD7B5200CE9C7B00BD6B4200AD522100C6733900DEA56300D68C4200CE84
        2900CE7B2100CE7B1800B55A1800AD633900FF00FF00FF00FF00FF00FF00FF00
        FF00CE947B00CE946B00EFC69C00E7BD8C00CE946300AD5A2900C69C8400FF00
        FF00FF00FF00FF00FF00FF00FF00D6B5A500A54A1800CE7B3100D6843100CE84
        2900CE7B2100CE7B1800BD631800AD522100FF00FF00FF00FF00FF00FF00FF00
        FF00A5522900EFCEA500EFC69400CE946300AD5A2900BD9C8C00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00A5522100CE8C4A00D68C3900D6843100CE84
        2900CE7B2100CE7B1800C66B2100A54A1800FF00FF00FF00FF00FF00FF00FF00
        FF00B56B4200F7D6B500E7BD8C00C67B4A00A5633900FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00D6A59400BD734200F7E7CE00EFC69C00D6944200CE84
        2900CE7B2100CE7B1800C66B2100A54A1800BDADA500FF00FF00FF00FF00CEA5
        8C00CE9C7B00F7DEBD00D69C6B00B56B4200AD8C7B00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00B56B4A00A54A2100D69C6B00EFCEAD00DEAD
        7300CE842900CE7B1800CE732100A54A1800B5948C00FF00FF00FF00FF00CEA5
        9400CE947300F7DEC600D6945A00AD633900B59C8C00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00E7CEC600A55A3100A5522100D69C
        6300E7BD8400D6944200CE7B2100AD521000A57B6B00FF00FF00FF00FF00CEAD
        9C00C68C6B00F7E7CE00D69C6300AD633900AD8C8400FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00DEBDAD009C4A
        2100A5522100D6945200DEA56300B5631800A56B5200FF00FF00FF00FF00D6AD
        A500BD7B5A00FFF7E700DEA56B00C67B4A009C5A4200FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00CEA5940094391800AD521800B55A1800A5634A00FF00FF00FF00FF00FF00
        FF008C311800FFEFE700EFCEAD00D6844A008C311000ADA59C00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00C6948400A55A3900FF00FF00FF00FF00FF00FF00FF00
        FF00AD735A00D6AD8C00FFEFDE00DE9C6300C6844A0084311000AD9C9C00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00C6BDB500AD8C8400B5A5A500FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF008C391800FFF7EF00EFD6B500D6945200C6844A00842908009452
        4200A58C8400AD948C00A5847B008C422900842908009439100084210800A584
        7B00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00A5635200B57B5A00FFF7F700EFCEA500DE9C5A00CE844A00BD73
        39009C4A29009C4A21009C4A2100BD6B3100C67B3100B55A2100A55218008C39
        1800FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF009C523900BD846300FFF7E700F7E7CE00E7B58400DE9C
        5A00D6945200CE8C4A00D6944A00D6944A00D6944200D68C4200AD5A29008C39
        2100FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00AD6B520094392100DEBD9C00F7E7D600FFEF
        E700F7DEC600EFC69C00E7BD8400E7C69400DEAD7B00BD7B4A0084290800CEAD
        A500FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00D6BDB500944229007B1800009439
        1800B57B5200CE9C7B00BD845A00A55A310084290800A5634A00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00CEA5
        9C00B5847300AD735A00BD8C8400CEADA500FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00}
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
      OnClick = btRefreshClick
    end
    object dblkcbbTICKET_TYPES: TDBLookupComboBox
      Left = 502
      Top = 18
      Width = 273
      Height = 25
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      KeyField = 'TICKET_TYPE_ID'
      ListField = 'TICKET_TYPE_NAME'
      ListSource = dsTICKET_TYPES
      TabOrder = 3
    end
    object dblkcbbAnswerType: TDBLookupComboBox
      Left = 502
      Top = 65
      Width = 273
      Height = 25
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      KeyField = 'ANSWER_TYPE_ID'
      ListField = 'ANSWER_TYPE_NAME'
      ListSource = dsAnswerTypes
      TabOrder = 4
    end
    object btLoadInExcel: TBitBtn
      Left = 850
      Top = 60
      Width = 177
      Height = 38
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = #1042#1099#1075#1088#1091#1079#1080#1090#1100' '#1074' Excel'
      Glyph.Data = {
        36090000424D3609000000000000360000002800000018000000180000000100
        2000000000000009000000000000000000000000000000000000FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00525A520084948C0042524A0073847300395239006B84
        73003952390073947B00526B52007B9C8400395A420073947300315231006B8C
        63004A6B4A008CA58C00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00849484002942310073847300425A42006B846B004263
        4A0073947300294A31006B8C6B00395A39006B8C6B00315231007BAD84002952
        29006B8C6B00314A3100FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00425242007B947B00E7FFE700EFFFF700EFFFF700E7FF
        EF00EFFFEF00EFFFEF00EFFFEF00EFFFEF00EFFFEF00E7FFEF00D6FFDE00E7FF
        E700315A31006B946B00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00738C7300395A3900EFFFEF00D6FFD600E7FFEF00DEFF
        E700E7FFEF00DEFFE700DEFFE7005A8C5A00396B390063946300316331005A94
        5A0073A57B0029522900FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF0042633900638C5A00E7FFE700215A210063A56B002163
        29005A9C6300185A210052945A00216B2900DEFFDE00185A21005A945A00396B
        3900214A2100638C6300FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00638C630042733900DEFFDE0063A55A00105A1000529C
        5A00317B39005AAD630029733100D6FFD6001863180063AD630039733900D6FF
        D6007BA57B004A6B4A00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00395A31006B945A00DEFFCE00316B210073B56B002973
        2900428C420018631800DEFFD600185A1000529C5200216318005A945A00DEFF
        DE00184A21006B947300FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00849C7B004A6B3900DEFFD600E7FFDE00215A2100528C
        520039733900DEFFDE00216321006BA56B0031733100639C6300215A2100E7FF
        E7006B946B00315A3100FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF003142310063846300EFFFEF00E7FFE700E7FFEF004273
        4A00D6FFDE00296339005A8C6B00295A310063946B00DEFFE700DEFFE700DEFF
        DE00315A31007B9C7B00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF0073846B0052735200EFFFEF00E7FFE70021522900E7FF
        EF00295A31006B9C7B00315A3900638C630039633900739C7300E7FFE700E7FF
        E7005A845A004A6B4A00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF004A63390073946300E7FFDE0031632900E7FFDE003163
        290073A56B001852180063945A00427339006B9C63003163290073A57300DEFF
        DE0052735200637B6300FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF007B9C6B00395A2900E7FFDE0073A56B00316B31005A8C
        5A00316331006B9C6B00E7FFE700639463003963290063945A0029522900EFFF
        EF005A735A00425A4200FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00395239006B8C6B00E7FFE700315A390052845A004A73
        52005A846B00DEFFE700E7FFEF00DEFFE700638C6B002952290073946B00EFFF
        EF00395A42007B948400FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF0084A58C00294A2900E7FFEF00E7FFEF00E7FFEF00DEFF
        EF00DEFFEF00E7FFEF00E7FFF700E7FFEF00EFFFEF00EFFFEF00EFFFEF00E7FF
        E700738C7300314A3100FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00315A290073A5730021522100639C6300396B3900638C
        6300396339006B9C6B00214A2100638C5A00426331005A845200395231008494
        7B004A634A007B8C7B00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF006B8C63003963310084AD8400214A2100527B5200426B
        4200739C7300315A31007B9C73004A6B3900738C630042633900849C7B004252
        390073847300394A3900FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00}
      ParentShowHint = False
      ShowHint = True
      TabOrder = 5
      OnClick = btLoadInExcelClick
    end
  end
  object p2: TPanel
    Left = 0
    Top = 106
    Width = 1197
    Height = 460
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alClient
    Caption = 'p1'
    TabOrder = 2
    object gApiRejectBlocks: TCRDBGrid
      Left = 1
      Top = 1
      Width = 1195
      Height = 458
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alClient
      DataSource = dsReportAPIRejectBlocks
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -14
      TitleFont.Name = 'Tahoma'
      TitleFont.Style = []
      Columns = <
        item
          Expanded = False
          FieldName = 'TICKET_ID'
          Title.Caption = #1053#1086#1084#1077#1088' '#1079#1072#1103#1074#1082#1080
          Width = 90
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'BAN'
          Title.Caption = #8470' '#1089#1095#1077#1090#1072
          Width = 112
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'TICKET_TYPE_NAME'
          Title.Caption = #1058#1080#1087' '#1079#1072#1103#1074#1082#1080
          Width = 134
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'ANSWER_TYPE_NAME'
          Title.Caption = #1057#1090#1072#1090#1091#1089' '#1079#1072#1103#1074#1082#1080
          Width = 139
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'COMMENTS'
          Title.Caption = #1050#1086#1084#1084#1077#1085#1090#1072#1088#1080#1080' '#1082' '#1079#1072#1103#1074#1082#1077
          Width = 186
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'PHONE_NUMBER'
          Title.Caption = #1058#1077#1083#1077#1092#1086#1085
          Width = 108
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'DATE_CREATE'
          Title.Caption = #1044#1072#1090#1072' '#1079#1072#1103#1074#1082#1080
          Width = 118
          Visible = True
        end>
    end
  end
  object qReportAPIRejectBlocks: TOraQuery
    Session = MainForm.OraSession
    SQL.Strings = (
      'select BT.ACCOUNT_ID, '
      '       ANT.ANSWER_TYPE_ID,  '
      '       ANT.ANSWER_TYPE_NAME, '
      '       BT.BAN, '
      '       BT.COMMENTS, '
      '       BT.DATE_CREATE, '
      '       BT.DATE_UPDATE, '
      '       BT.PHONE_NUMBER, '
      '       BT.TICKET_ID, '
      '       BTT.TICKET_TYPE_ID, '
      '       BTT.TICKET_TYPE_NAME,  '
      '       BT.USER_CREATED '
      'from BEELINE_TICKETS bt'
      '    ,BEELINE_TICKET_TYPES btt'
      '    ,ANSWER_TYPES ant'
      'where TRUNC(bt.date_create) >= TRUNC(:pDate_Begin)'
      '  and TRUNC(bt.date_create) <= TRUNC(:pDate_End)'
      '  and BT.TICKET_TYPE = BTT.TICKET_TYPE_ID'
      '  and BT.ANSWER = ANT.ANSWER_TYPE_ID'
      
        '  AND ((bt.ANSWER = :pANSWER_TYPE_ID) OR (nvl(:pANSWER_TYPE_ID, ' +
        '-1) = -1))'
      
        '  AND ((BT.TICKET_TYPE = :pTICKET_TYPE_ID) OR (nvl(:pTICKET_TYPE' +
        '_ID, -1) = -1))')
    FetchRows = 250
    FetchAll = True
    Left = 176
    Top = 152
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'pDate_Begin'
      end
      item
        DataType = ftUnknown
        Name = 'pDate_End'
      end
      item
        DataType = ftUnknown
        Name = 'pANSWER_TYPE_ID'
      end
      item
        DataType = ftUnknown
        Name = 'pTICKET_TYPE_ID'
      end>
  end
  object dsReportAPIRejectBlocks: TDataSource
    DataSet = qReportAPIRejectBlocks
    Left = 176
    Top = 104
  end
  object dsTICKET_TYPES: TDataSource
    DataSet = qTICKET_TYPES
    OnDataChange = dsTICKET_TYPESDataChange
    Left = 344
    Top = 128
  end
  object qTICKET_TYPES: TOraQuery
    Session = MainForm.OraSession
    SQL.Strings = (
      'SELECT BTP.TICKET_TYPE_ID, BTP.TICKET_TYPE_NAME'
      'FROM BEELINE_TICKET_TYPES BTP'
      'UNION '
      'SELECT -1, '#39#1042#1089#1077' '#1090#1080#1087#1099' '#1079#1072#1103#1074#1086#1082#39' FROM DUAL')
    Left = 344
    Top = 176
  end
  object qAnswerTypes: TOraQuery
    Session = MainForm.OraSession
    SQL.Strings = (
      'SELECT ANT.ANSWER_TYPE_ID, ANT.ANSWER_TYPE_NAME'
      'FROM ANSWER_TYPES ANT'
      'UNION'
      'SELECT -1, '#39#1042#1089#1077' '#1089#1090#1072#1090#1091#1089#1099#39' FROM DUAL')
    Left = 448
    Top = 184
  end
  object dsAnswerTypes: TDataSource
    DataSet = qAnswerTypes
    OnDataChange = dsAnswerTypesDataChange
    Left = 448
    Top = 136
  end
end