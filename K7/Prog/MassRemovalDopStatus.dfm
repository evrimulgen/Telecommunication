object MassRemovalDopStatusForm: TMassRemovalDopStatusForm
  Left = 0
  Top = 0
  Caption = #1052#1072#1089#1089#1086#1074#1086#1077' '#1091#1076#1072#1083#1077#1085#1080#1077' '#1076#1086#1087'. '#1089#1090#1072#1090#1091#1089#1086#1074
  ClientHeight = 324
  ClientWidth = 1114
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
  object gGrid: TCRDBGrid
    Left = 0
    Top = 29
    Width = 1114
    Height = 203
    Align = alClient
    DataSource = dsMain
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
    ReadOnly = True
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    Columns = <
      item
        Expanded = False
        FieldName = 'PHONE_NUMBER'
        Title.Alignment = taCenter
        Title.Font.Charset = DEFAULT_CHARSET
        Title.Font.Color = clWindowText
        Title.Font.Height = -11
        Title.Font.Name = 'Tahoma'
        Title.Font.Style = [fsBold]
        Width = 124
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'CONTRACT_DATE'
        Title.Alignment = taCenter
        Title.Font.Charset = DEFAULT_CHARSET
        Title.Font.Color = clWindowText
        Title.Font.Height = -11
        Title.Font.Name = 'Tahoma'
        Title.Font.Style = [fsBold]
        Width = 101
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'STATUS_NAME'
        Title.Alignment = taCenter
        Title.Font.Charset = DEFAULT_CHARSET
        Title.Font.Color = clWindowText
        Title.Font.Height = -11
        Title.Font.Name = 'Tahoma'
        Title.Font.Style = [fsBold]
        Width = 150
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'DOP_STATUS_NAME'
        Title.Alignment = taCenter
        Title.Font.Charset = DEFAULT_CHARSET
        Title.Font.Color = clWindowText
        Title.Font.Height = -11
        Title.Font.Name = 'Tahoma'
        Title.Font.Style = [fsBold]
        Width = 200
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'NOTE'
        Title.Alignment = taCenter
        Title.Font.Charset = DEFAULT_CHARSET
        Title.Font.Color = clWindowText
        Title.Font.Height = -11
        Title.Font.Name = 'Tahoma'
        Title.Font.Style = [fsBold]
        Width = 500
        Visible = True
      end>
  end
  object panButton: TPanel
    Left = 0
    Top = 0
    Width = 1114
    Height = 29
    Align = alTop
    TabOrder = 1
    ExplicitWidth = 792
    object bLoadPhone: TBitBtn
      Left = 0
      Top = 0
      Width = 113
      Height = 29
      Action = aLoadPhone
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1085#1086#1084#1077#1088#1072
      TabOrder = 0
    end
    object bRemoveDopStatus: TBitBtn
      Left = 211
      Top = 0
      Width = 118
      Height = 29
      Action = aRemoveDopStatus
      Caption = #1057#1085#1103#1090#1100' '#1076#1086#1087'. '#1089#1090#1072#1090#1091#1089
      TabOrder = 1
    end
    object bInfo: TBitBtn
      Left = 329
      Top = 0
      Width = 167
      Height = 29
      Action = aViewInfo
      Caption = #1048#1085#1092#1086#1088#1084#1072#1094#1080#1103' '#1087#1086' '#1072#1073#1086#1085#1077#1085#1090#1091
      Glyph.Data = {
        36090000424D3609000000000000360000002800000018000000180000000100
        2000000000000009000000000000000000000000000000000000FF00FF00FF00
        FF00FBFBFB00F4F4F400EEEEEE00E8E8E800E5E5E500E0E0E000DEDEDE00DFDF
        DF00DFDFDF00DFDFDF00DEDEDE00DFDFDF00DEDEDE00DFDFDF00E1E1E100E6E6
        E600EAEAEA00EFEFEF00F5F5F500FDFDFD00FF00FF00FF00FF00FF00FF00FF00
        FF00E5E5E500C8C8C800BCBCBC00B3B1AB00ADA18800B09B7000B4996100B897
        5500BB974E00BC974A00BC974B00BB974F00B7975800B29A6700AF9E7D00AFAA
        A000AAB2B700BDBDBE00CBCBCB00EFEFEF00FF00FF00FF00FF00FF00FF00FF00
        FF00FFFFFE00E4DDD000C1AB7D00B38E3F00B68F3F00BA924200BD954500BF97
        4700C1984900C2994A00C1994A00C1984900BF974700BC954500B99242005B8D
        8F000189DE00A2C4D600FCFCFC00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00CBB58300AD873600B18B3A00B68E3F00B9924100BD954500C0984900C39A
        4A00C69C4C00C79D4D00C79D4E00C69C4C00C39A4B00C0984800BD9545005590
        9900008EE1005E8C8700BD9F5E00F1EBDE00FF00FF00FF00FF00FF00FF00FF00
        FF00BD9F5F00AF893800B48D3C00B8914100BC944400C0984800C49B4C00C89E
        4E00CBA05000CCA15100CCA15200CBA05000C89E4F00C49B4B00C0984700B894
        480087916B00B28D3D00AF893900C8AF7A00FF00FF00FF00FF00FF00FF00FF00
        FF00CDB78600B18A3A00B58E3E00BA924300BE964700C39A4B00C89E4F00CCA1
        5200CFA45500D1A55700D1A55700CFA45500CCA15200C89E4F00C39A4B006898
        91000198E7008A906600B18A3A00CAB27D00FF00FF00FF00FF00FF00FF00FF00
        FF00F1EADC00B48E3F00B78F3F00BB944400C0984700C59C4C00CAA05100CFA4
        5400D3A75700D5A95A00D5A95B00D3A75700CFA35500CAA05000C59C4B00659B
        9600009DEB004698A700B28C3D00E7DBC300FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00E2D3B200BC974B00BC944500C1984800C69C4C00CBA15200D0A5
        5500D5A95A00D9AD5D00D9AD5E00D5A95900D0A55600CBA15100C69C4C00AA99
        5C000CA1E20000A2ED0069B1C000FEFFFF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00ECE2CC00C7A66100C1994B00C69C4D00CBA05200D3AA
        5D00E5BF7900EFC98400EEC88300E4BD7700D2A95C00CBA05100C69C4D00C199
        4A009DA37A001BAEEE0001A7F1006FCDF700FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FBF8F300DCC69900C8A15400E5C17E00FDD7
        9800FBD59800EFD4A500EFD4A600FAD59900F0D59C0043ACC50079A38E00D6C1
        9200F7F5EE00DCF2FA000DB0F50001ACF400CEEFFD00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FBF4E800FBE0B500D9D5
        C500C3DAED00C4DDF300C4DDF300C3DAEE00ADCFD50008B3F7001BB7F200F9FC
        FD00FF00FF00FF00FF0033C1F80003B1F700B0E7FC00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FEFEFE00C7DF
        F400BAD8F100BAD8F100BAD8F100BAD8F100CCE8F80048C9FA0000B5F90056CF
        FC00B8EBFE007EDAFC0002B6F9001FBEF900E7F8FE00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00E2EE
        F900B5D5F000D0E4F500CFE4F500B6D6F000FBFDFE00E2F7FE0055CFFC0016BF
        FC0003BAFC000DBDFC0034C7FB00BCECFD00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00EEF5
        FB00D8E8F700DCEBF800DCEBF800D8E8F700F8FBFE00FF00FF00FEFFFF00D5F4
        FE00C0EEFE00C9F0FE00F6FCFF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FDFDFE00D3E6
        F600CEE3F500CEE3F500CEE3F500CEE3F500D5E7F600FEFEFF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00E7F1FA00C0DB
        F200C0DBF200C0DBF200C0DBF200C0DBF200C0DBF200E2E8EF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00B5CDE300B2D4
        F000B2D4F000B2D4F000B2D4F000B2D4F000B2D4F0008295A900FCFCFC00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00D3D7DE0093B7D800A5CC
        ED00A5CCED00A5CCED00A5CCED00A5CCED00A5CCED00667D9700BFC2C800FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF008E98AA0084ABD20097C3
        EA0097C3EA0097C3EA0097C3EA0097C3EA0092BCE4003E4E690081869300FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF006A778E005573980087B8
        E40089BBE8007DA8D3005E7B9F00526C8E003A4A66002B354C005F687800FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF0074809400314464004258
        7A006184AD0032405A002C384F002C384F002C384F002C384F00636B7C00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00C5C9D100334361002C39
        53002B354C002C3851002D3952002C3851002D3952002D3951009EA3AE00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00AAB1BB003843
        5A002B364D002D3A54002D3B55002D3A5400323F570080879600FCFCFC00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00E4E5
        E8009A9FAA0068728500616B7E0080899700CFD2D700FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00}
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
    end
    object bDeleteRecord: TBitBtn
      Left = 113
      Top = 0
      Width = 98
      Height = 29
      Action = aDeleteRecord
      Caption = #1059#1076#1072#1083#1080#1090#1100' '#1079#1072#1087#1080#1089#1100
      TabOrder = 3
    end
  end
  object mData: TMemo
    Left = 0
    Top = 232
    Width = 1114
    Height = 76
    Align = alBottom
    ScrollBars = ssVertical
    TabOrder = 2
    Visible = False
    ExplicitTop = 215
  end
  object ProgressBar: TProgressBar
    Left = 0
    Top = 308
    Width = 1114
    Height = 16
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Align = alBottom
    Step = 1
    TabOrder = 3
    ExplicitWidth = 928
  end
  object vtMain: TVirtualTable
    Options = [voPersistentData, voStored, voSkipUnSupportedFieldTypes]
    Left = 64
    Top = 136
    Data = {03000000000000000000}
    object vtMainPHONE_NUMBER: TStringField
      DisplayLabel = #1053#1086#1084#1077#1088
      FieldName = 'PHONE_NUMBER'
    end
    object vtMainCONTRACT_ID: TIntegerField
      FieldName = 'CONTRACT_ID'
    end
    object vtMainCONTRACT_DATE: TDateField
      DisplayLabel = #1044#1072#1090#1072' '#1082#1086#1085#1090#1088#1072#1082#1090#1072
      FieldName = 'CONTRACT_DATE'
    end
    object vtMainSTATUS_NAME: TStringField
      DisplayLabel = #1057#1090#1072#1090#1091#1089
      FieldName = 'STATUS_NAME'
      Size = 300
    end
    object vtMainDOP_STATUS_NAME: TStringField
      DisplayLabel = #1044#1086#1087'. '#1089#1090#1072#1090#1091#1089
      FieldName = 'DOP_STATUS_NAME'
      Size = 300
    end
    object vtMainNOTE: TStringField
      DisplayLabel = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
      DisplayWidth = 500
      FieldName = 'NOTE'
      Size = 500
    end
  end
  object dsMain: TDataSource
    DataSet = vtMain
    Left = 112
    Top = 136
  end
  object aList: TActionList
    Left = 16
    Top = 136
    object aLoadPhone: TAction
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1085#1086#1084#1077#1088#1072
      OnExecute = aLoadPhoneExecute
    end
    object aRemoveDopStatus: TAction
      Caption = #1057#1085#1103#1090#1100' '#1076#1086#1087'. '#1089#1090#1072#1090#1091#1089
      OnExecute = aRemoveDopStatusExecute
    end
    object aViewInfo: TAction
      Caption = #1048#1085#1092#1086#1088#1084#1072#1094#1080#1103' '#1087#1086' '#1072#1073#1086#1085#1077#1085#1090#1091
      OnExecute = aViewInfoExecute
    end
    object aDeleteRecord: TAction
      Caption = #1059#1076#1072#1083#1080#1090#1100' '#1079#1072#1087#1080#1089#1100
      OnExecute = aDeleteRecordExecute
    end
  end
  object dgOpen: TOpenDialog
    Filter = #1060#1072#1081#1083#1099' '#1076#1083#1103' '#1079#1072#1075#1088#1091#1079#1082#1080'|*.xls;*.csv;*.zip;*.xlsx'
    Left = 168
    Top = 136
  end
  object qContracts: TOraQuery
    SQL.Strings = (
      'SELECT '
      '  C.PHONE_NUMBER_FEDERAL,'
      '  C.CONTRACT_ID, '
      '  C.CONTRACT_DATE, '
      'C.DOP_STATUS, DS.DOP_STATUS_NAME '
      'FROM V_CONTRACTS C '
      
        'LEFT JOIN CONTRACT_DOP_STATUSES DS ON C.DOP_STATUS = DS.DOP_STAT' +
        'US_ID '
      'WHERE C.PHONE_NUMBER_FEDERAL = :pPHONE_NUMBER '
      'AND C.CONTRACT_CANCEL_DATE IS NULL')
    Left = 224
    Top = 136
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'pPHONE_NUMBER'
      end>
  end
  object qAccStatus: TOraQuery
    SQL.Strings = (
      'SELECT '
      '  DB.YEAR_MONTH, '
      '  DB.PHONE_NUMBER, '
      '  DB.STATUS_ID, '
      '  DB.PHONE_IS_ACTIVE, '
      '  ST.COMMENT_CLENT '
      'FROM DB_LOADER_ACCOUNT_PHONES DB '
      'LEFT JOIN BEELINE_STATUS_CODE ST ON DB.STATUS_ID = ST.STATUS_ID '
      'WHERE  DB.PHONE_NUMBER = :pPHONE_NUMBER '
      'AND DB.YEAR_MONTH = TO_NUMBER (TO_CHAR (SYSDATE, '#39'YYYYMM'#39'))')
    Left = 288
    Top = 136
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'pPHONE_NUMBER'
      end>
  end
  object qRemoveDopStatus: TOraQuery
    SQL.Strings = (
      'UPDATE CONTRACTS'
      'SET DOP_STATUS = null'
      'WHERE  PHONE_NUMBER_FEDERAL = :pPHONE_NUMBER'
      'AND CONTRACT_ID = :pCONTRACT_ID')
    Left = 368
    Top = 136
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'pPHONE_NUMBER'
      end
      item
        DataType = ftUnknown
        Name = 'pCONTRACT_ID'
      end>
  end
end