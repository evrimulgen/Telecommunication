object ReportPhoneReBlockForm: TReportPhoneReBlockForm
  Left = 0
  Top = 0
  Caption = #1046#1091#1088#1085#1072#1083' '#1087#1077#1088#1077#1073#1083#1086#1082#1080#1088#1086#1074#1082#1080' '#1085#1086#1084#1077#1088#1086#1074' '#1085#1072' '#1089#1086#1093#1088#1072#1085#1077#1085#1080#1077
  ClientHeight = 500
  ClientWidth = 781
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -10
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 12
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 781
    Height = 33
    Align = alTop
    TabOrder = 0
    object BitBtn1: TBitBtn
      Left = 4
      Top = 1
      Width = 138
      Height = 27
      Action = aExcel
      Caption = #1042#1099#1075#1088#1091#1079#1080#1090#1100' '#1074' MS Excel'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
    end
    object BitBtn2: TBitBtn
      Left = 142
      Top = 1
      Width = 98
      Height = 27
      Action = aRefresh
      Caption = #1054#1073#1085#1086#1074#1080#1090#1100
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
    end
    object BitBtn3: TBitBtn
      Left = 240
      Top = 1
      Width = 102
      Height = 27
      Action = aShowUserStatInfo
      Caption = #1055#1086#1076#1088#1086#1073#1085#1086
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
    end
    object cbSearch: TCheckBox
      Left = 348
      Top = 6
      Width = 55
      Height = 16
      Caption = #1055#1086#1080#1089#1082
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 3
      OnClick = cbSearchClick
    end
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 33
    Width = 781
    Height = 467
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    ActivePage = tsReBlockQueue
    Align = alClient
    TabOrder = 1
    ExplicitTop = 26
    ExplicitHeight = 474
    object tsReBlock: TTabSheet
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = #1046#1091#1088#1085#1072#1083' '#1087#1077#1088#1077#1073#1083#1086#1082#1080#1088#1086#1074#1082#1080' '#1085#1072' '#1089#1086#1093#1088#1072#1085#1077#1085#1080#1077
      OnShow = tsReBlockShow
      ExplicitHeight = 447
      object ReBlockGrd: TCRDBGrid
        Left = 0
        Top = 0
        Width = 773
        Height = 440
        Align = alClient
        DataSource = dsReBlock
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'MS Sans Serif'
        TitleFont.Style = [fsBold]
        Columns = <
          item
            Expanded = False
            FieldName = 'LOGIN'
            Width = 88
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'PHONE_NUMBER'
            Width = 88
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'DATE_ACTIV'
            Width = 130
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'DATE_CREATED'
            Width = 130
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'TICKED_UNLOCK_ID'
            Width = 107
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'DATE_UNLOCK'
            Width = 130
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'TICKED_LOCK_ID'
            Width = 88
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'DATE_LOCK'
            Width = 130
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ERROR_STR'
            Width = 2104
            Visible = True
          end>
      end
    end
    object tsReBlockQueue: TTabSheet
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = #1054#1095#1077#1088#1077#1076#1100' '#1087#1077#1088#1077#1073#1083#1086#1082#1080#1088#1086#1074#1082#1080
      ImageIndex = 2
      OnShow = tsReBlockQueueShow
      ExplicitHeight = 447
      object ReBlockQueueGrid: TCRDBGrid
        Left = 0
        Top = 0
        Width = 773
        Height = 440
        Margins.Left = 2
        Margins.Top = 2
        Margins.Right = 2
        Margins.Bottom = 2
        Align = alClient
        DataSource = dsReBlockQueue
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -14
        TitleFont.Name = 'MS Sans Serif'
        TitleFont.Style = [fsBold]
        Columns = <
          item
            Expanded = False
            FieldName = 'LOGIN'
            Width = 88
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'PHONE_NUMBER'
            Width = 88
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'DATE_ACTIV'
            Width = 130
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'DATE_CREATED'
            Width = 130
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'TICKED_UNLOCK_ID'
            Width = 133
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'DATE_UNLOCK'
            Width = 130
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'TICKED_LOCK_ID'
            Width = 106
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'DATE_LOCK'
            Width = 130
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ERROR_STR'
            Width = 2804
            Visible = True
          end>
      end
    end
  end
  object ActionList1: TActionList
    Images = MainForm.ImageList24
    Left = 56
    Top = 72
    object aExcel: TAction
      Caption = #1042#1099#1075#1088#1091#1079#1080#1090#1100' '#1074' MS Excel'
      ImageIndex = 12
      OnExecute = aExcelExecute
    end
    object aRefresh: TAction
      Caption = #1054#1073#1085#1086#1074#1080#1090#1100
      ImageIndex = 9
      OnExecute = aRefreshExecute
    end
    object aShowUserStatInfo: TAction
      Caption = #1055#1086#1076#1088#1086#1073#1085#1086
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' '#1080#1085#1092#1086#1088#1084#1072#1094#1080#1080' '#1087#1086' '#1072#1073#1086#1085#1077#1085#1090#1091
      ImageIndex = 22
      ShortCut = 13
      OnExecute = aShowUserStatInfoExecute
    end
  end
  object qReBlock: TOraQuery
    SQL.Strings = (
      'SELECT QR.*,'
      '       AC.ACCOUNT_ID,'
      '       AC.LOGIN'
      '  FROM QUEUE_PHONE_REBLOCK_LOG QR,'
      '       BEELINE_TICKETS B,'
      '       ACCOUNTS AC'
      '  WHERE QR.TICKED_LOCK_ID = B.TICKET_ID(+)'
      '    AND B.ACCOUNT_ID = AC.ACCOUNT_ID(+)'
      '    AND ((:ACCOUNT_ID IS NULL)OR(B.ACCOUNT_ID=:ACCOUNT_ID)) '
      '  ORDER BY QR.QUEUE_PHONE_REBLOCK_ID DESC')
    FetchRows = 250
    Left = 48
    Top = 152
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'ACCOUNT_ID'
      end>
    object qReBlockLOGIN: TStringField
      Alignment = taCenter
      DisplayLabel = #1051'/'#1057
      DisplayWidth = 12
      FieldName = 'LOGIN'
      Size = 120
    end
    object qReBlockPHONE_NUMBER: TStringField
      Alignment = taCenter
      DisplayLabel = #1053#1086#1084#1077#1088
      DisplayWidth = 12
      FieldName = 'PHONE_NUMBER'
      Size = 40
    end
    object qReBlockDATE_ACTIV: TDateTimeField
      DisplayLabel = #1044#1072#1090#1072' '#1085#1072#1095#1072#1083#1072
      FieldName = 'DATE_ACTIV'
    end
    object qReBlockDATE_CREATED: TDateTimeField
      DisplayLabel = #1044#1072#1090#1072' '#1089#1086#1079#1076#1072#1085#1080#1103
      FieldName = 'DATE_CREATED'
    end
    object qReBlockTICKED_UNLOCK_ID: TStringField
      Alignment = taCenter
      DisplayLabel = #1047#1072#1087#1088#1086#1089' '#1088#1072#1079#1073#1083#1086#1082#1072
      DisplayWidth = 12
      FieldName = 'TICKED_UNLOCK_ID'
      Size = 60
    end
    object qReBlockDATE_UNLOCK: TDateTimeField
      DisplayLabel = #1044#1072#1090#1072' '#1088#1072#1079#1083#1086#1082#1072
      FieldName = 'DATE_UNLOCK'
    end
    object qReBlockTICKED_LOCK_ID: TStringField
      Alignment = taCenter
      DisplayLabel = #1047#1072#1087#1088#1086#1089' '#1073#1083#1086#1082#1072
      DisplayWidth = 12
      FieldName = 'TICKED_LOCK_ID'
      Size = 60
    end
    object qReBlockDATE_LOCK: TDateTimeField
      DisplayLabel = #1044#1072#1090#1072' '#1073#1083#1086#1082#1072
      FieldName = 'DATE_LOCK'
    end
    object qReBlockERROR_STR: TStringField
      DisplayLabel = #1048#1090#1086#1075
      DisplayWidth = 300
      FieldName = 'ERROR_STR'
      Size = 4000
    end
  end
  object dsReBlock: TDataSource
    DataSet = qReBlock
    Left = 88
    Top = 160
  end
  object qReBlockQueue: TOraQuery
    SQL.Strings = (
      'SELECT QR.*,'
      '       AC.ACCOUNT_ID,'
      '       AC.LOGIN'
      '  FROM QUEUE_PHONE_REBLOCK QR,'
      '       BEELINE_TICKETS B,'
      '       ACCOUNTS AC'
      '  WHERE QR.TICKED_LOCK_ID = B.TICKET_ID(+)'
      '    AND B.ACCOUNT_ID = AC.ACCOUNT_ID(+)'
      '    AND ((:ACCOUNT_ID IS NULL)OR(B.ACCOUNT_ID=:ACCOUNT_ID)) '
      '  ORDER BY QR.PHONE_NUMBER DESC')
    FetchRows = 500
    Left = 48
    Top = 216
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'ACCOUNT_ID'
      end>
    object qReBlockQueueLOGIN: TStringField
      Alignment = taCenter
      DisplayLabel = #1051'/'#1057
      DisplayWidth = 12
      FieldName = 'LOGIN'
      Size = 120
    end
    object qReBlockQueuePHONE_NUMBER: TStringField
      Alignment = taCenter
      DisplayLabel = #1053#1086#1084#1077#1088
      DisplayWidth = 12
      FieldName = 'PHONE_NUMBER'
      Size = 40
    end
    object qReBlockQueueDATE_ACTIV: TDateTimeField
      DisplayLabel = #1044#1072#1090#1072' '#1085#1072#1095#1072#1083#1072
      FieldName = 'DATE_ACTIV'
    end
    object qReBlockQueueDATE_CREATED: TDateTimeField
      DisplayLabel = #1058#1072#1076#1072' '#1089#1086#1079#1076#1072#1085#1080#1103
      FieldName = 'DATE_CREATED'
    end
    object qReBlockQueueTICKED_UNLOCK_ID: TStringField
      Alignment = taCenter
      DisplayLabel = #1047#1072#1087#1088#1086#1089' '#1088#1072#1079#1073#1083#1086#1082#1072
      DisplayWidth = 12
      FieldName = 'TICKED_UNLOCK_ID'
      Size = 60
    end
    object qReBlockQueueDATE_UNLOCK: TDateTimeField
      DisplayLabel = #1044#1072#1090#1072' '#1088#1072#1079#1073#1083#1086#1082#1072
      FieldName = 'DATE_UNLOCK'
    end
    object qReBlockQueueTICKED_LOCK_ID: TStringField
      Alignment = taCenter
      DisplayLabel = #1047#1072#1087#1088#1086#1089' '#1073#1083#1086#1082#1072
      DisplayWidth = 12
      FieldName = 'TICKED_LOCK_ID'
      Size = 60
    end
    object qReBlockQueueDATE_LOCK: TDateTimeField
      DisplayLabel = #1044#1072#1090#1072' '#1073#1083#1086#1082#1072
      FieldName = 'DATE_LOCK'
    end
    object qReBlockQueueERROR_STR: TStringField
      DisplayLabel = #1048#1090#1086#1075
      DisplayWidth = 400
      FieldName = 'ERROR_STR'
      Size = 4000
    end
  end
  object dsReBlockQueue: TDataSource
    DataSet = qReBlockQueue
    Left = 88
    Top = 224
  end
end