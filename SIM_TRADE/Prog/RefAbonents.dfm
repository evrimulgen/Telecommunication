inherited RefAbonentsForm: TRefAbonentsForm
  Left = 215
  Top = 154
  Width = 732
  Height = 352
  Caption = #1057#1087#1080#1089#1086#1082' '#1072#1073#1086#1085#1077#1085#1090#1086#1074
  KeyPreview = True
  Position = poScreenCenter
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 13
  inherited Panel1: TPanel
    Width = 716
    inherited ToolBar1: TToolBar
      Width = 716
    end
  end
  inherited Panel2: TPanel
    Top = 63
    Width = 716
    Height = 251
    inherited CRDBGrid1: TCRDBGrid
      Width = 714
      Height = 249
      Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit]
      ReadOnly = True
      Columns = <
        item
          Expanded = False
          FieldName = 'SURNAME'
          Title.Caption = #1060#1072#1084#1080#1083#1080#1103
          Title.Font.Charset = DEFAULT_CHARSET
          Title.Font.Color = clWindowText
          Title.Font.Height = -11
          Title.Font.Name = 'MS Sans Serif'
          Title.Font.Style = [fsBold]
          Width = 92
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'NAME'
          Title.Caption = #1048#1084#1103
          Title.Font.Charset = DEFAULT_CHARSET
          Title.Font.Color = clWindowText
          Title.Font.Height = -11
          Title.Font.Name = 'MS Sans Serif'
          Title.Font.Style = [fsBold]
          Width = 65
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'PATRONYMIC'
          Title.Caption = #1054#1090#1095#1077#1089#1090#1074#1086
          Title.Font.Charset = DEFAULT_CHARSET
          Title.Font.Color = clWindowText
          Title.Font.Height = -11
          Title.Font.Name = 'MS Sans Serif'
          Title.Font.Style = [fsBold]
          Width = 89
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'BDATE'
          Title.Caption = #1044'.'#1056'.'
          Title.Font.Charset = DEFAULT_CHARSET
          Title.Font.Color = clWindowText
          Title.Font.Height = -11
          Title.Font.Name = 'MS Sans Serif'
          Title.Font.Style = [fsBold]
          Width = 56
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'PASSPORT_SER'
          Title.Caption = #1057#1077#1088#1080#1103' '#1087#1072#1089#1087#1086#1088#1090#1072
          Title.Font.Charset = DEFAULT_CHARSET
          Title.Font.Color = clWindowText
          Title.Font.Height = -11
          Title.Font.Name = 'MS Sans Serif'
          Title.Font.Style = [fsBold]
          Width = 51
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'PASSPORT_NUM'
          Title.Caption = #8470' '#1087#1072#1089#1087#1086#1088#1090#1072
          Title.Font.Charset = DEFAULT_CHARSET
          Title.Font.Color = clWindowText
          Title.Font.Height = -11
          Title.Font.Name = 'MS Sans Serif'
          Title.Font.Style = [fsBold]
          Width = 49
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'PASSPORT_DATE'
          Title.Caption = #1044#1072#1090#1072' '#1074#1099#1076#1072#1095#1080' '#1087#1072#1089#1087#1086#1088#1090#1072
          Title.Font.Charset = DEFAULT_CHARSET
          Title.Font.Color = clWindowText
          Title.Font.Height = -11
          Title.Font.Name = 'MS Sans Serif'
          Title.Font.Style = [fsBold]
          Width = 50
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'PASSPORT_GET'
          Title.Caption = #1050#1077#1084' '#1074#1099#1076#1072#1085' '#1087#1072#1089#1087#1086#1088#1090
          Title.Font.Charset = DEFAULT_CHARSET
          Title.Font.Color = clWindowText
          Title.Font.Height = -11
          Title.Font.Name = 'MS Sans Serif'
          Title.Font.Style = [fsBold]
          Width = 71
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'CITIZEN_COUNTRY_NAME'
          Title.Caption = #1043#1088#1072#1078#1076#1072#1085#1089#1090#1074#1086
          Title.Font.Charset = DEFAULT_CHARSET
          Title.Font.Color = clWindowText
          Title.Font.Height = -11
          Title.Font.Name = 'MS Sans Serif'
          Title.Font.Style = [fsBold]
          Width = 71
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'COUNTRY_NAME'
          Title.Caption = #1057#1090#1088#1072#1085#1072' '#1087#1088#1086#1087#1080#1089#1082#1080
          Title.Font.Charset = DEFAULT_CHARSET
          Title.Font.Color = clWindowText
          Title.Font.Height = -11
          Title.Font.Name = 'MS Sans Serif'
          Title.Font.Style = [fsBold]
          Width = 86
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'REGION_NAME'
          Title.Caption = #1056#1077#1075#1080#1086#1085' '#1087#1088#1086#1087#1080#1089#1082#1080
          Title.Font.Charset = DEFAULT_CHARSET
          Title.Font.Color = clWindowText
          Title.Font.Height = -11
          Title.Font.Name = 'MS Sans Serif'
          Title.Font.Style = [fsBold]
          Width = 47
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'REGION_NAME2'
          Title.Caption = #1056#1077#1075#1080#1086#1085' '#1087#1088#1086#1087#1080#1089#1082#1080'...'
          Title.Font.Charset = DEFAULT_CHARSET
          Title.Font.Color = clWindowText
          Title.Font.Height = -11
          Title.Font.Name = 'MS Sans Serif'
          Title.Font.Style = [fsBold]
          Width = 47
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'CITY_NAME'
          Title.Caption = #1043#1086#1088#1086#1076' '#1087#1088#1086#1087#1080#1089#1082#1080
          Title.Font.Charset = DEFAULT_CHARSET
          Title.Font.Color = clWindowText
          Title.Font.Height = -11
          Title.Font.Name = 'MS Sans Serif'
          Title.Font.Style = [fsBold]
          Width = 47
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'STREET_NAME'
          Title.Caption = #1059#1083#1080#1094#1072' '#1087#1088#1086#1087#1080#1089#1082#1080
          Title.Font.Charset = DEFAULT_CHARSET
          Title.Font.Color = clWindowText
          Title.Font.Height = -11
          Title.Font.Name = 'MS Sans Serif'
          Title.Font.Style = [fsBold]
          Width = 47
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'KORPUS'
          Title.Caption = #1050#1086#1088#1087#1091#1089
          Title.Font.Charset = DEFAULT_CHARSET
          Title.Font.Color = clWindowText
          Title.Font.Height = -11
          Title.Font.Name = 'MS Sans Serif'
          Title.Font.Style = [fsBold]
          Width = 47
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'HOUSE'
          Title.Caption = #1044#1086#1084
          Title.Font.Charset = DEFAULT_CHARSET
          Title.Font.Color = clWindowText
          Title.Font.Height = -11
          Title.Font.Name = 'MS Sans Serif'
          Title.Font.Style = [fsBold]
          Width = 47
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'APARTMENT'
          Title.Caption = #1050#1074#1072#1088#1090#1080#1088#1072
          Title.Font.Charset = DEFAULT_CHARSET
          Title.Font.Color = clWindowText
          Title.Font.Height = -11
          Title.Font.Name = 'MS Sans Serif'
          Title.Font.Style = [fsBold]
          Width = 47
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'CONTACT_INFO'
          Title.Caption = #1050#1086#1085#1090#1072#1082#1090#1085#1072#1103' '#1080#1085#1092#1086#1088#1084#1072#1094#1080#1103
          Title.Font.Charset = DEFAULT_CHARSET
          Title.Font.Color = clWindowText
          Title.Font.Height = -11
          Title.Font.Name = 'MS Sans Serif'
          Title.Font.Style = [fsBold]
          Width = 47
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'CODE_WORD'
          Title.Caption = #1050#1086#1076#1086#1074#1086#1077' '#1089#1083#1086#1074#1086
          Title.Font.Charset = DEFAULT_CHARSET
          Title.Font.Color = clWindowText
          Title.Font.Height = -11
          Title.Font.Name = 'MS Sans Serif'
          Title.Font.Style = [fsBold]
          Width = 47
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'IS_VIP_NAME'
          Title.Caption = 'VIP'
          Title.Font.Charset = DEFAULT_CHARSET
          Title.Font.Color = clWindowText
          Title.Font.Height = -11
          Title.Font.Name = 'MS Sans Serif'
          Title.Font.Style = [fsBold]
          Width = 47
          Visible = True
        end>
    end
  end
  object pSearch: TPanel [2]
    Left = 0
    Top = 33
    Width = 716
    Height = 30
    Align = alTop
    TabOrder = 2
    Visible = False
    object Label1: TLabel
      Left = 11
      Top = 8
      Width = 165
      Height = 13
      AutoSize = False
      Caption = #1055#1086#1080#1089#1082' '#1072#1073#1086#1085#1077#1085#1090#1072' '#1087#1086' '#1060#1048#1054' :'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object eSearch: TMaskEdit
      Left = 176
      Top = 4
      Width = 130
      Height = 21
      CharCase = ecUpperCase
      TabOrder = 0
      OnChange = eSearchChange
      OnKeyDown = CRDBGrid1KeyDown
    end
    object ToolBar2: TToolBar
      Left = 313
      Top = -2
      Width = 160
      Height = 31
      Align = alNone
      ButtonHeight = 30
      ButtonWidth = 79
      Caption = 'ToolBar2'
      EdgeInner = esNone
      EdgeOuter = esNone
      Images = MainForm.ImageList24
      List = True
      ShowCaptions = True
      TabOrder = 1
      object ToolButton9: TToolButton
        Left = 0
        Top = 2
        Action = aSelect
      end
      object ToolButton10: TToolButton
        Left = 79
        Top = 2
        Action = aClose
      end
    end
  end
  inherited qMain: TOraQuery
    UpdatingTable = ''
    KeyFields = 'ABONENT_ID'
    SQLInsert.Strings = (
      'INSERT INTO ABONENTS'
      
        '  (ABONENT_ID, SURNAME, NAME, PATRONYMIC, BDATE, PASSPORT_SER, P' +
        'ASSPORT_NUM, PASSPORT_DATE, PASSPORT_GET, CITIZENSHIP, COUNTRY_I' +
        'D, REGION_ID, REGION_NAME, CITY_NAME, STREET_NAME, HOUSE, KORPUS' +
        ', APARTMENT, CONTACT_INFO, CODE_WORD, IS_VIP)'
      'VALUES'
      
        '  (:ABONENT_ID, :SURNAME, :NAME, :PATRONYMIC, :BDATE, :PASSPORT_' +
        'SER, :PASSPORT_NUM, :PASSPORT_DATE, :PASSPORT_GET, :CITIZENSHIP,' +
        ' :COUNTRY_ID, :REGION_ID, :REGION_NAME, :CITY_NAME, :STREET_NAME' +
        ', :HOUSE, :KORPUS, :APARTMENT, :CONTACT_INFO, :CODE_WORD, :IS_VI' +
        'P)'
      'RETURNING'
      
        '  ABONENT_ID, SURNAME, NAME, PATRONYMIC, BDATE, PASSPORT_SER, PA' +
        'SSPORT_NUM, PASSPORT_DATE, PASSPORT_GET, CITIZENSHIP, COUNTRY_ID' +
        ', REGION_ID, REGION_NAME, CITY_NAME, STREET_NAME, HOUSE, KORPUS,' +
        ' APARTMENT, CONTACT_INFO, CODE_WORD, IS_VIP'
      'INTO'
      
        '  :ABONENT_ID, :SURNAME, :NAME, :PATRONYMIC, :BDATE, :PASSPORT_S' +
        'ER, :PASSPORT_NUM, :PASSPORT_DATE, :PASSPORT_GET, :CITIZENSHIP, ' +
        ':COUNTRY_ID, :REGION_ID, :REGION_NAME, :CITY_NAME, :STREET_NAME,' +
        ' :HOUSE, :KORPUS, :APARTMENT, :CONTACT_INFO, :CODE_WORD, :IS_VIP')
    SQLDelete.Strings = (
      'DELETE FROM ABONENTS'
      'WHERE'
      '  ABONENT_ID = :Old_ABONENT_ID')
    SQLUpdate.Strings = (
      'UPDATE ABONENTS'
      'SET'
      
        '  ABONENT_ID = :ABONENT_ID, SURNAME = :SURNAME, NAME = :NAME, PA' +
        'TRONYMIC = :PATRONYMIC, BDATE = :BDATE, PASSPORT_SER = :PASSPORT' +
        '_SER, PASSPORT_NUM = :PASSPORT_NUM, PASSPORT_DATE = :PASSPORT_DA' +
        'TE, PASSPORT_GET = :PASSPORT_GET, CITIZENSHIP = :CITIZENSHIP, CO' +
        'UNTRY_ID = :COUNTRY_ID, REGION_ID = :REGION_ID, REGION_NAME = :R' +
        'EGION_NAME, CITY_NAME = :CITY_NAME, STREET_NAME = :STREET_NAME, ' +
        'HOUSE = :HOUSE, KORPUS = :KORPUS, APARTMENT = :APARTMENT, CONTAC' +
        'T_INFO = :CONTACT_INFO, CODE_WORD = :CODE_WORD, IS_VIP = :IS_VIP'
      'WHERE'
      '  ABONENT_ID = :Old_ABONENT_ID'
      'RETURNING'
      
        '  ABONENT_ID, SURNAME, NAME, PATRONYMIC, BDATE, PASSPORT_SER, PA' +
        'SSPORT_NUM, PASSPORT_DATE, PASSPORT_GET, CITIZENSHIP, COUNTRY_ID' +
        ', REGION_ID, REGION_NAME, CITY_NAME, STREET_NAME, HOUSE, KORPUS,' +
        ' APARTMENT, CONTACT_INFO, CODE_WORD, IS_VIP'
      'INTO'
      
        '  :ABONENT_ID, :SURNAME, :NAME, :PATRONYMIC, :BDATE, :PASSPORT_S' +
        'ER, :PASSPORT_NUM, :PASSPORT_DATE, :PASSPORT_GET, :CITIZENSHIP, ' +
        ':COUNTRY_ID, :REGION_ID, :REGION_NAME, :CITY_NAME, :STREET_NAME,' +
        ' :HOUSE, :KORPUS, :APARTMENT, :CONTACT_INFO, :CODE_WORD, :IS_VIP')
    SQLRefresh.Strings = (
      
        'SELECT ABONENT_ID, SURNAME, NAME, PATRONYMIC, BDATE, PASSPORT_SE' +
        'R, PASSPORT_NUM, PASSPORT_DATE, PASSPORT_GET, CITIZENSHIP, COUNT' +
        'RY_ID, REGION_ID, REGION_NAME, CITY_NAME, STREET_NAME, HOUSE, KO' +
        'RPUS, APARTMENT, CONTACT_INFO, CODE_WORD, IS_VIP FROM ABONENTS'
      'WHERE'
      '  ABONENT_ID = :ABONENT_ID')
    SQL.Strings = (
      'SELECT  A.SURNAME ||'#39' '#39'|| A.NAME || '#39' '#39' || A.PATRONYMIC AS FIO,'
      '        A.*'
      'FROM ABONENTS A')
    IndexFieldNames = 'SURNAME, NAME, PATRONYMIC, BDATE'
    AfterInsert = qMainAfterInsert
    object qMainABONENT_ID: TFloatField
      FieldName = 'ABONENT_ID'
      Required = True
    end
    object qMainSURNAME: TStringField
      FieldName = 'SURNAME'
      Required = True
      Size = 120
    end
    object qMainNAME: TStringField
      FieldName = 'NAME'
      Required = True
      Size = 120
    end
    object qMainPATRONYMIC: TStringField
      FieldName = 'PATRONYMIC'
      Size = 120
    end
    object qMainBDATE: TDateTimeField
      FieldName = 'BDATE'
    end
    object qMainPASSPORT_SER: TStringField
      FieldName = 'PASSPORT_SER'
      Size = 40
    end
    object qMainPASSPORT_NUM: TStringField
      FieldName = 'PASSPORT_NUM'
      Size = 40
    end
    object qMainPASSPORT_DATE: TDateTimeField
      FieldName = 'PASSPORT_DATE'
    end
    object qMainPASSPORT_GET: TStringField
      FieldName = 'PASSPORT_GET'
      Size = 200
    end
    object qMainCITIZENSHIP: TFloatField
      FieldName = 'CITIZENSHIP'
    end
    object qMainCOUNTRY_ID: TFloatField
      FieldName = 'COUNTRY_ID'
    end
    object qMainREGION_ID: TFloatField
      FieldName = 'REGION_ID'
    end
    object qMainREGION_NAME: TStringField
      FieldName = 'REGION_NAME'
      Size = 400
    end
    object qMainCITY_NAME: TStringField
      FieldName = 'CITY_NAME'
      Size = 120
    end
    object qMainSTREET_NAME: TStringField
      FieldName = 'STREET_NAME'
      Size = 120
    end
    object qMainHOUSE: TStringField
      FieldName = 'HOUSE'
      Size = 40
    end
    object qMainKORPUS: TStringField
      FieldName = 'KORPUS'
      Size = 40
    end
    object qMainAPARTMENT: TStringField
      FieldName = 'APARTMENT'
      Size = 40
    end
    object qMainCONTACT_INFO: TStringField
      FieldName = 'CONTACT_INFO'
      Size = 400
    end
    object qMainCODE_WORD: TStringField
      FieldName = 'CODE_WORD'
      Size = 200
    end
    object qMainIS_VIP: TIntegerField
      FieldName = 'IS_VIP'
    end
    object qMainCITIZEN_COUNTRY_NAME: TStringField
      FieldKind = fkLookup
      FieldName = 'CITIZEN_COUNTRY_NAME'
      LookupDataSet = qCountries_Citizen
      LookupKeyFields = 'COUNTRY_ID'
      LookupResultField = 'COUNTRY_NAME'
      KeyFields = 'CITIZENSHIP'
      Lookup = True
    end
    object qMainCOUNTRY_NAME: TStringField
      FieldKind = fkLookup
      FieldName = 'COUNTRY_NAME'
      LookupDataSet = qCountries
      LookupKeyFields = 'COUNTRY_ID'
      LookupResultField = 'COUNTRY_NAME'
      KeyFields = 'COUNTRY_ID'
      Lookup = True
    end
    object qMainREGION_NAME2: TStringField
      FieldKind = fkLookup
      FieldName = 'REGION_NAME2'
      LookupDataSet = qRegions
      LookupKeyFields = 'REGION_ID'
      LookupResultField = 'R.REGION_NAME||'#39'('#39'||C.COUNTRY_NAME||'#39')'#39
      KeyFields = 'REGION_ID'
      Lookup = True
    end
    object qMainIS_VIP_NAME: TStringField
      FieldKind = fkLookup
      FieldName = 'IS_VIP_NAME'
      LookupDataSet = qIsVIP
      LookupKeyFields = 'IS_VIP'
      LookupResultField = 'IS_VIP_NAME'
      KeyFields = 'IS_VIP'
      Lookup = True
    end
  end
  inherited PopupMenu1: TPopupMenu
    object N7: TMenuItem [5]
      Action = aSelect
    end
    object N8: TMenuItem [6]
      Action = aClose
    end
    object N9: TMenuItem [7]
      Caption = '-'
    end
  end
  inherited ActionList1: TActionList
    object aSelect: TAction
      Caption = #1042#1099#1073#1088#1072#1090#1100
      Enabled = False
      Hint = #1042#1099#1073#1088#1072#1090#1100' '#1090#1077#1082#1091#1097#1077#1075#1086' '#1072#1073#1086#1085#1077#1085#1090#1072
      ImageIndex = 7
      Visible = False
      OnExecute = aSelectExecute
    end
    object aClose: TAction
      Caption = #1054#1090#1084#1077#1085#1072
      Enabled = False
      Hint = #1054#1090#1084#1077#1085#1080#1090#1100' '#1074#1099#1073#1086#1088' '#1072#1073#1086#1085#1077#1085#1090#1072
      ImageIndex = 8
      Visible = False
      OnExecute = aCloseExecute
    end
  end
  inherited qGetNewId: TOraStoredProc
    StoredProcName = 'NEW_ABONENT_ID'
    SQL.Strings = (
      'begin'
      '  :RESULT := NEW_ABONENT_ID;'
      'end;')
    CommandStoredProcName = 'NEW_ABONENT_ID:0'
  end
  object qCountries_Citizen: TOraQuery
    SQL.Strings = (
      'SELECT * '
      'FROM COUNTRIES'
      'ORDER BY NVL(IS_DEFAULT, 0) DESC, COUNTRY_NAME')
    Left = 72
    Top = 57
  end
  object qCountries: TOraQuery
    SQL.Strings = (
      'SELECT * '
      'FROM COUNTRIES'
      'ORDER BY NVL(IS_DEFAULT, 0) DESC, COUNTRY_NAME')
    Left = 72
    Top = 105
  end
  object qRegions: TOraQuery
    SQL.Strings = (
      
        'SELECT R.REGION_ID, R.REGION_NAME || '#39' ('#39' || C.COUNTRY_NAME || '#39 +
        ')'#39','
      '  R.COUNTRY_ID'
      'FROM REGIONS R, COUNTRIES C'
      'WHERE R.COUNTRY_ID = C.COUNTRY_ID(+)'
      'ORDER BY NVL(C.IS_DEFAULT, 0) DESC, C.COUNTRY_NAME,'
      '  NVL(R.IS_DEFAULT, 0) DESC, R.REGION_NAME')
    Left = 72
    Top = 153
  end
  object qIsVIP: TOraQuery
    SQL.Strings = (
      'SELECT NULL IS_VIP, '#39#39' IS_VIP_NAME  FROM DUAL'
      'UNION ALL'
      'SELECT 1 IS_VIP, '#39#1044#1072#39' IS_VIP_NAME  FROM DUAL')
    Left = 72
    Top = 209
  end
  object tSearch: TTimer
    Enabled = False
    Interval = 300
    OnTimer = tSearchTimer
    Left = 208
    Top = 207
  end
end
