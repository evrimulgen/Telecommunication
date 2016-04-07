object ShowUserStatForm: TShowUserStatForm
  Left = 268
  Top = 314
  Caption = #1048#1085#1092'. '#1087#1086' '#1072#1073#1086#1085#1077#1085#1090#1091
  ClientHeight = 609
  ClientWidth = 1082
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  PopupMode = pmAuto
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel5: TPanel
    Left = 0
    Top = 568
    Width = 1082
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    DesignSize = (
      1082
      41)
    object btnClose: TBitBtn
      Left = 920
      Top = 4
      Width = 153
      Height = 29
      Anchors = [akTop, akRight]
      Cancel = True
      Caption = #1047#1072#1082#1088#1099#1090#1100
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Verdana'
      Font.Style = []
      Glyph.Data = {
        DE010000424DDE01000000000000760000002800000024000000120000000100
        0400000000006801000000000000000000001000000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        3333333333333333333333330000333333333333333333333333F33333333333
        00003333344333333333333333388F3333333333000033334224333333333333
        338338F3333333330000333422224333333333333833338F3333333300003342
        222224333333333383333338F3333333000034222A22224333333338F338F333
        8F33333300003222A3A2224333333338F3838F338F33333300003A2A333A2224
        33333338F83338F338F33333000033A33333A222433333338333338F338F3333
        0000333333333A222433333333333338F338F33300003333333333A222433333
        333333338F338F33000033333333333A222433333333333338F338F300003333
        33333333A222433333333333338F338F00003333333333333A22433333333333
        3338F38F000033333333333333A223333333333333338F830000333333333333
        333A333333333333333338330000333333333333333333333333333333333333
        0000}
      ModalResult = 2
      NumGlyphs = 2
      ParentFont = False
      TabOrder = 0
      OnClick = btnCloseClick
    end
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 1082
    Height = 568
    ActivePage = tsRest
    Align = alClient
    TabOrder = 1
    OnChange = PageControl1Change
    object tsAbonent: TTabSheet
      Caption = #1055#1072#1089#1087#1086#1088#1090#1085#1099#1077' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 1
      DesignSize = (
        1074
        540)
      inline EditAbonentFrame: TEditAbonentFrme
        Left = 8
        Top = 0
        Width = 561
        Height = 315
        TabOrder = 0
        ExplicitLeft = 8
        ExplicitWidth = 561
        ExplicitHeight = 315
        inherited Panel1: TPanel
          Width = 561
          ExplicitWidth = 561
          DesignSize = (
            561
            130)
          inherited Label1: TLabel
            Font.Height = -12
          end
          inherited Label2: TLabel
            Font.Height = -12
          end
          inherited Label3: TLabel
            Font.Height = -12
          end
          inherited Label4: TLabel
            Left = 328
            Font.Height = -12
            ExplicitLeft = 328
          end
          inherited Label20: TLabel
            Left = 329
            Anchors = [akTop, akRight]
            Font.Height = -12
            ExplicitLeft = 329
          end
          inherited Label22: TLabel
            Font.Height = -12
          end
          inherited SURNAME: TDBEdit
            Width = 208
            Height = 22
            Font.Height = -12
            OnChange = EditAbonentFrameSURNAMEChange
            ExplicitWidth = 208
            ExplicitHeight = 22
          end
          inherited NAME: TDBEdit
            Width = 208
            Height = 22
            Font.Height = -12
            OnChange = EditAbonentFrameNAMEChange
            ExplicitWidth = 208
            ExplicitHeight = 22
          end
          inherited PATRONYMIC: TDBEdit
            Width = 208
            Height = 22
            Font.Height = -12
            OnChange = EditAbonentFramePATRONYMICChange
            ExplicitWidth = 208
            ExplicitHeight = 22
          end
          inherited BDATE: TDBEdit
            Left = 415
            Top = -2
            Height = 22
            Font.Height = -12
            OnChange = EditAbonentFrameBDATEChange
            ExplicitLeft = 415
            ExplicitTop = -2
            ExplicitHeight = 22
          end
          inherited CITIZENSHIP: TDBLookupComboBox
            Left = 415
            Width = 134
            Height = 22
            Anchors = [akTop, akRight]
            Font.Height = -12
            OnClick = EditAbonentFrameCITIZENSHIPClick
            ExplicitLeft = 415
            ExplicitWidth = 134
            ExplicitHeight = 22
          end
          inherited IS_VIP: TCheckBox
            Left = 325
            Top = 49
            Font.Height = -12
            OnClick = EditAbonentFrameIS_VIPClick
            ExplicitLeft = 325
            ExplicitTop = 49
          end
          inherited ToolBar1: TToolBar
            Left = 422
            ExplicitLeft = 422
            inherited ToolButton1: TToolButton
              ExplicitWidth = 157
            end
          end
        end
        inherited pPassport: TPanel
          Width = 561
          ExplicitWidth = 561
          DesignSize = (
            561
            59)
          inherited Label6: TLabel
            Font.Height = -12
          end
          inherited Label8: TLabel
            Font.Height = -12
          end
          inherited Label7: TLabel
            Font.Height = -12
          end
          inherited Label18: TLabel
            Font.Height = -12
          end
          inherited Bevel1: TBevel
            Width = 577
            ExplicitWidth = 577
          end
          inherited Label5: TLabel
            Font.Height = -12
          end
          inherited PASSPORT_SER: TDBEdit
            Height = 22
            Font.Height = -12
            OnChange = EditAbonentFramePASSPORT_SERChange
            ExplicitHeight = 22
          end
          inherited PASSPORT_GET: TDBEdit
            Left = 322
            Width = 221
            Height = 22
            Font.Height = -12
            OnChange = EditAbonentFramePASSPORT_GETChange
            ExplicitLeft = 322
            ExplicitWidth = 221
            ExplicitHeight = 22
          end
          inherited PASSPORT_NUM: TDBEdit
            Left = 322
            Top = 11
            Width = 221
            Height = 22
            Font.Height = -12
            OnChange = EditAbonentFramePASSPORT_NUMChange
            ExplicitLeft = 322
            ExplicitTop = 11
            ExplicitWidth = 221
            ExplicitHeight = 22
          end
          inherited PASSPORT_DATE: TDBEdit
            Height = 22
            Font.Height = -12
            OnChange = EditAbonentFramePASSPORT_DATEChange
            ExplicitHeight = 22
          end
        end
        inherited GroupBox2: TPanel
          Width = 561
          ExplicitWidth = 561
          DesignSize = (
            561
            75)
          inherited Label9: TLabel
            Font.Height = -12
          end
          inherited Label10: TLabel
            Font.Height = -12
          end
          inherited Label11: TLabel
            Font.Height = -12
          end
          inherited Label12: TLabel
            Font.Height = -12
          end
          inherited Label13: TLabel
            Font.Height = -12
          end
          inherited Label14: TLabel
            Font.Height = -12
          end
          inherited Label15: TLabel
            Font.Height = -12
          end
          inherited Bevel2: TBevel
            Width = 577
            ExplicitWidth = 577
          end
          inherited Label19: TLabel
            Font.Height = -12
          end
          inherited COUNTRY_ID: TDBLookupComboBox
            Height = 22
            Font.Height = -12
            OnClick = EditAbonentFrameCOUNTRY_IDClick
            ExplicitHeight = 22
          end
          inherited REGION_ID: TDBLookupComboBox
            Left = 329
            Width = 221
            Height = 22
            Font.Height = -12
            OnClick = EditAbonentFrameREGION_IDClick
            ExplicitLeft = 329
            ExplicitWidth = 221
            ExplicitHeight = 22
          end
          inherited CITY_NAME: TDBEdit
            Height = 22
            Font.Height = -12
            OnChange = EditAbonentFrameCITY_NAMEChange
            ExplicitHeight = 22
          end
          inherited STREET_NAME: TDBEdit
            Width = 221
            Height = 22
            Font.Height = -12
            OnChange = EditAbonentFrameSTREET_NAMEChange
            ExplicitWidth = 221
            ExplicitHeight = 22
          end
          inherited HOUSE: TDBEdit
            Height = 22
            Font.Height = -12
            OnChange = EditAbonentFrameHOUSEChange
            ExplicitHeight = 22
          end
          inherited KORPUS: TDBEdit
            Height = 22
            Font.Height = -12
            OnChange = EditAbonentFrameKORPUSChange
            ExplicitHeight = 22
          end
          inherited APARTMENT: TDBEdit
            Width = 124
            Height = 22
            Font.Height = -12
            OnChange = EditAbonentFrameAPARTMENTChange
            ExplicitWidth = 124
            ExplicitHeight = 22
          end
        end
        inherited GroupBox3: TPanel
          Width = 561
          ExplicitWidth = 561
          DesignSize = (
            561
            50)
          inherited Label16: TLabel
            Font.Height = -12
          end
          inherited Label17: TLabel
            Font.Height = -12
          end
          inherited Bevel3: TBevel
            Width = 577
            ExplicitWidth = 577
          end
          inherited Label21: TLabel
            Font.Height = -12
          end
          inherited CONTACT_INFO: TDBEdit
            Width = 381
            Height = 22
            Font.Height = -12
            OnChange = EditAbonentFrameCONTACT_INFOChange
            ExplicitWidth = 381
            ExplicitHeight = 22
          end
          inherited CODE_WORD: TDBEdit
            Height = 22
            Font.Height = -12
            OnChange = EditAbonentFrameCODE_WORDChange
            ExplicitHeight = 22
          end
          inherited EMAIL: TDBEdit
            Width = 216
            Height = 22
            Font.Height = -12
            OnChange = EditAbonentFrameEMAILChange
            ExplicitWidth = 216
            ExplicitHeight = 22
          end
        end
        inherited qGetNewId: TOraStoredProc
          CommandStoredProcName = 'NEW_ABONENT_ID:0'
        end
      end
      object SaveBtn: TBitBtn
        Left = 619
        Top = 310
        Width = 153
        Height = 29
        Anchors = [akTop, akRight]
        Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Verdana'
        Font.Style = []
        Glyph.Data = {
          DE010000424DDE01000000000000760000002800000024000000120000000100
          0400000000006801000000000000000000001000000000000000000000000000
          80000080000000808000800000008000800080800000C0C0C000808080000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
          3333333333333333333333330000333333333333333333333333F33333333333
          00003333344333333333333333388F3333333333000033334224333333333333
          338338F3333333330000333422224333333333333833338F3333333300003342
          222224333333333383333338F3333333000034222A22224333333338F338F333
          8F33333300003222A3A2224333333338F3838F338F33333300003A2A333A2224
          33333338F83338F338F33333000033A33333A222433333338333338F338F3333
          0000333333333A222433333333333338F338F33300003333333333A222433333
          333333338F338F33000033333333333A222433333333333338F338F300003333
          33333333A222433333333333338F338F00003333333333333A22433333333333
          3338F38F000033333333333333A223333333333333338F830000333333333333
          333A333333333333333338330000333333333333333333333333333333333333
          0000}
        NumGlyphs = 2
        ParentFont = False
        TabOrder = 1
        OnClick = SaveBtnClick
      end
    end
    object tsSummaryPhone: TTabSheet
      Caption = #1057#1074#1086#1076#1082#1072' '#1087#1086' '#1085#1086#1084#1077#1088#1091
      ImageIndex = 11
      OnShow = tsSummaryPhoneShow
      object gSummaryPhone: TCRDBGrid
        Left = 0
        Top = 0
        Width = 1074
        Height = 540
        Align = alClient
        DataSource = dmShowUserSt.dsSummaryPhone
        Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
        ReadOnly = True
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'MS Sans Serif'
        TitleFont.Style = []
        OnCellClick = gSummaryPhoneCellClick
        OnDrawColumnCell = gSummaryPhoneDrawColumnCell
        Columns = <
          item
            Expanded = False
            FieldName = 'IMAGE_BMP'
            Title.Alignment = taCenter
            Title.Caption = '*'
            Width = 50
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'EVENT_DATE'
            Title.Alignment = taCenter
            Title.Caption = #1044#1072#1090#1072
            Title.Font.Charset = DEFAULT_CHARSET
            Title.Font.Color = clWindowText
            Title.Font.Height = -11
            Title.Font.Name = 'MS Sans Serif'
            Title.Font.Style = [fsBold]
            Width = 60
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'INCOME'
            Title.Alignment = taCenter
            Title.Caption = #1055#1088#1080#1093#1086#1076
            Title.Font.Charset = DEFAULT_CHARSET
            Title.Font.Color = clWindowText
            Title.Font.Height = -11
            Title.Font.Name = 'MS Sans Serif'
            Title.Font.Style = [fsBold]
            Width = 60
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'OUTCOME'
            Title.Alignment = taCenter
            Title.Caption = #1056#1072#1089#1093#1086#1076
            Title.Font.Charset = DEFAULT_CHARSET
            Title.Font.Color = clWindowText
            Title.Font.Height = -11
            Title.Font.Name = 'MS Sans Serif'
            Title.Font.Style = [fsBold]
            Width = 60
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'BALANCE'
            Title.Alignment = taCenter
            Title.Caption = #1041#1072#1083#1072#1085#1089
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
            FieldName = 'EVENT'
            Title.Alignment = taCenter
            Title.Caption = #1044#1077#1081#1089#1090#1074#1080#1077
            Title.Font.Charset = DEFAULT_CHARSET
            Title.Font.Color = clWindowText
            Title.Font.Height = -11
            Title.Font.Name = 'MS Sans Serif'
            Title.Font.Style = [fsBold]
            Width = 500
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'NOTE'
            Title.Alignment = taCenter
            Title.Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
            Title.Font.Charset = DEFAULT_CHARSET
            Title.Font.Color = clWindowText
            Title.Font.Height = -11
            Title.Font.Name = 'MS Sans Serif'
            Title.Font.Style = [fsBold]
            Width = 500
            Visible = True
          end>
      end
    end
    object tsTariffs: TTabSheet
      Caption = #1058#1072#1088#1080#1092' '#1080' '#1073#1083#1086#1082#1080#1088#1086#1074#1082#1080
      ImageIndex = 2
      OnShow = tsTariffsShow
      object Panel8: TPanel
        Left = 0
        Top = 233
        Width = 1074
        Height = 307
        Align = alClient
        BevelOuter = bvNone
        Caption = 'Panel8'
        TabOrder = 0
        object gPhoneStatuses: TCRDBGrid
          Left = 0
          Top = 0
          Width = 1074
          Height = 307
          OptionsEx = [dgeEnableSort, dgeLocalFilter, dgeLocalSorting]
          Align = alClient
          DataSource = dmShowUserSt.dsPhoneStatuses
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          ReadOnly = True
          TabOrder = 0
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -11
          TitleFont.Name = 'MS Sans Serif'
          TitleFont.Style = [fsBold]
          Columns = <
            item
              Expanded = False
              FieldName = 'BEGIN_DATE'
              Title.Caption = #1053#1072#1095#1072#1083#1086
              Width = 120
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'END_DATE'
              Title.Caption = #1054#1082#1086#1085#1095#1072#1085#1080#1077
              Width = 120
              Visible = True
            end
            item
              Alignment = taCenter
              Expanded = False
              FieldName = 'PHONE_IS_ACTIVE'
              Title.Caption = #1057#1090#1072#1090#1091#1089
              Width = 113
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'TARIFF_NAME'
              Title.Caption = #1058#1072#1088#1080#1092#1085#1099#1081' '#1087#1083#1072#1085
              Width = 341
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'DATE_LAST_UPDATED'
              Title.Caption = #1044#1072#1090#1072' '#1087#1086#1089#1083#1077#1076#1085#1077#1075#1086' '#1086#1073#1085#1086#1074#1083#1077#1085#1080#1103
              Width = 181
              Visible = True
            end>
        end
      end
      object Panel15: TPanel
        Left = 0
        Top = 0
        Width = 1074
        Height = 233
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 1
        object Panel6: TPanel
          Left = 0
          Top = 0
          Width = 680
          Height = 233
          Align = alClient
          BevelOuter = bvSpace
          TabOrder = 0
          object Image1: TImage
            Left = 10
            Top = 130
            Width = 46
            Height = 25
          end
          object Label13: TLabel
            Left = 54
            Top = 38
            Width = 127
            Height = 18
            Alignment = taRightJustify
            Caption = #1058#1072#1088#1080#1092#1085#1099#1081' '#1087#1083#1072#1085':'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Verdana'
            Font.Style = []
            ParentFont = False
          end
          object DBText13: TDBText
            Left = 200
            Top = 38
            Width = 79
            Height = 18
            AutoSize = True
            DataField = 'V_TARIFF'
            DataSource = dmShowUserSt.dsTariffInfo
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -16
            Font.Name = 'Verdana'
            Font.Style = []
            ParentFont = False
          end
          object DB_TXT_NEW_TARIF_INFO: TDBText
            Left = 295
            Top = 38
            Width = 222
            Height = 18
            AutoSize = True
            DataField = 'V_NEW_TARIF'
            DataSource = dmShowUserSt.dsTariffInfo
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clRed
            Font.Height = -16
            Font.Name = 'Verdana'
            Font.Style = []
            ParentFont = False
            Visible = False
          end
          object LblState: TLabel
            Left = 55
            Top = 10
            Width = 129
            Height = 18
            Alignment = taRightJustify
            Caption = #1057#1090#1072#1090#1091#1089' '#1090#1072#1088#1080#1092#1072':'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Verdana'
            Font.Style = [fsBold, fsItalic, fsUnderline]
            ParentFont = False
            OnClick = LblStateClick
            OnMouseEnter = LblBlueOn
            OnMouseLeave = LblBlueOff
          end
          object lTariffStatusText: TLabel
            Left = 200
            Top = 9
            Width = 70
            Height = 23
            Caption = #1057#1090#1072#1090#1091#1089
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -19
            Font.Name = 'Verdana'
            Font.Style = [fsBold]
            ParentFont = False
            PopupMenu = pmStatus
          end
          object Label19: TLabel
            Left = 63
            Top = 82
            Width = 121
            Height = 18
            Alignment = taRightJustify
            Caption = #1044#1072#1090#1072' '#1087#1088#1086#1074#1077#1088#1082#1080':'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Verdana'
            Font.Style = []
            ParentFont = False
          end
          object DBText18: TDBText
            Left = 200
            Top = 82
            Width = 79
            Height = 18
            AutoSize = True
            DataField = 'LAST_CHECK_DATE_TIME'
            DataSource = dmShowUserSt.dsTariffInfo
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -16
            Font.Name = 'Verdana'
            Font.Style = []
            ParentFont = False
          end
          object lBlockInfo: TLabel
            Left = 200
            Top = 152
            Width = 119
            Height = 23
            Caption = #1041#1083#1086#1082'.'#1080#1085#1092#1086
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -19
            Font.Name = 'Verdana'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object lCloseNumber: TLabel
            Left = 200
            Top = 176
            Width = 150
            Height = 23
            Caption = 'lCloseNumber'
            Color = clBtnFace
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clRed
            Font.Height = -19
            Font.Name = 'Verdana'
            Font.Style = [fsBold]
            ParentColor = False
            ParentFont = False
          end
          object Label25: TLabel
            Left = 45
            Top = 178
            Width = 136
            Height = 18
            Caption = #1057#1090#1072#1090#1091#1089' '#1076#1086#1075#1086#1074#1086#1088#1072':'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Verdana'
            Font.Style = []
            ParentFont = False
          end
          object Label27: TLabel
            Left = 86
            Top = 205
            Width = 103
            Height = 18
            Margins.Left = 2
            Margins.Top = 2
            Margins.Right = 2
            Margins.Bottom = 2
            Caption = #1044#1086#1087'. '#1089#1090#1072#1090#1091#1089':'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Verdana'
            Font.Style = [fsBold, fsItalic, fsUnderline]
            ParentFont = False
            OnClick = Label27Click
            OnMouseEnter = LblBlueOn
            OnMouseLeave = LblBlueOff
          end
          object Label24: TLabel
            Left = 62
            Top = 152
            Width = 119
            Height = 23
            Caption = #1041#1083#1086#1082'.'#1080#1085#1092#1086
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -19
            Font.Name = 'Verdana'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object ContractType: TLabel
            Left = 439
            Top = 9
            Width = 143
            Height = 23
            Alignment = taRightJustify
            Caption = 'ContractType'
            Color = clBtnFace
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clRed
            Font.Height = -19
            Font.Name = 'Verdana'
            Font.Style = [fsBold]
            ParentColor = False
            ParentFont = False
            Visible = False
          end
          object lCreditLimit: TLabel
            Left = 42
            Top = 106
            Width = 139
            Height = 18
            Hint = 'PhoneDisconnectionLimit'
            Caption = #1050#1088#1077#1076#1080#1090#1085#1099#1081' '#1083#1080#1084#1080#1090':'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clPurple
            Font.Height = -15
            Font.Name = 'Verdana'
            Font.Style = []
            ParentFont = False
          end
          object lbl_IS_COLLECTOR: TLabel
            Left = 376
            Top = 82
            Width = 95
            Height = 18
            Alignment = taRightJustify
            Caption = '('#1082#1086#1083#1083#1077#1082#1090#1086#1088')'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlue
            Font.Height = -15
            Font.Name = 'Verdana'
            Font.Style = []
            ParentFont = False
            Visible = False
          end
          object btInstalmentPayment: TBitBtn
            Left = 3
            Top = 2
            Width = 47
            Height = 45
            Margins.Left = 2
            Margins.Top = 2
            Margins.Right = 2
            Margins.Bottom = 2
            Glyph.Data = {
              361B0000424D361B000000000000360000002800000030000000300000000100
              180000000000001B000074120000741200000000000000000000FFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFAFBFD
              F3F6FBF3F6FBF3F6FBF3F6FBF3F6FBF3F6FBF3F6FCF3F6FCF3F6FCF3F6FCF3F6
              FCF3F6FCF3F6FCF3F6FCF3F6FCF3F6FCF3F6FCF3F6FCF3F6FCF3F6FCF3F6FCF3
              F6FCF3F6FCF3F6FCF3F6FCF3F6FCF3F6FCF3F6FCF3F6FCF3F6FBF3F6FBF3F6FB
              F3F6FBF3F6FBF3F6FBF3F6FBF3F6FBF3F6FBF3F6FBF3F5FBF3F5FBF3F5FBF6F8
              FCFEFEFFFFFFFFFFFFFFDCE5F4719DD65688CE567EC9567ECA5680CB5680CC56
              80CD5681CE5681CE5682CF5682D05682D15682D15682D15683D25683D25684D2
              5684D25684D25683D25684D25684D25683D25682D15682D15682D15682D05682
              CF5681CF5680CD5680CD567FCC567ECB567ECA567DC9567CC8567CC7567BC556
              7AC5567AC35678C25678C1567FC4608FCCBCCDE7FFFFFFFFFFFF94B4DF47A5E1
              016DE2005DD70264DC036BDF0371E20676E7097CE60D82E81286E7168AE81F8F
              E82391E82894E92E97E9359AE93C9DE9409EE947A2E94EA4E954A6E959A7E959
              A7E959A8E952A5E84CA3E845A1E8409EE73A9BE73398E62D95E72892E5228FE6
              1C8BE41686E31184E40E80E30A7BE10778E20474E10571E2046FDE0071E943AC
              F3709DD1FCFDFEFFFFFF91B6DF79C5F90051EF007AFB007CFF0080FF0084FF00
              8AFF008EFF0297FF059DFF0BA4FF0FAAFF18B3FF22BAFF29BFFF33C7FF3FCCFF
              4BD4FF57D7FF60DCFF6AE1FF71E3FF74E8FF71E3FF6AE1FF62DEFF57D9FF4DD6
              FF41CEFF37C8FF2EC3FF25BEFF1BB6FF15B0FF0EA9FF08A2FF039CFF0191FF00
              90FF0190FF008FFF008FFF0072FF8DE6FF7AA1D2FBFCFDFFFFFF9FBAE1208BE5
              0064F0006FEB0073F00075F6007AF8007BFD0081FF0187FF028BFF0792FF0896
              FF0D9BFF14A0FF17A5FF1EAAFF27AFFF2BB2FF36B8FF3AB9FF3FBEFF43BDFF43
              BFFF43BEFF3FBEFF3ABAFF36B6FF2BB2FF25ADFF1EAAFF17A4FF119FFF0B9AFF
              0896FF048FFF028BFF0085FF0082FF0084FF0081FF0081FF0080FF0087FF349C
              E088A7D4FFFFFFFFFFFFD9E1F1144CB2006EF10071F10070F00075F4007AF800
              7CFC0081FF0086FF028BFF0592FF0996FF0D9BFF12A0FF19A6FF1DA9FF23ADFF
              2BB1FF30B5FF37BAFF3BBCFF3FBCFF40BFFF3FBCFF3BBCFF37BAFF30B5FF2BB1
              FF23ADFF1DA9FF19A6FF12A0FF0D9BFF0996FF0592FF018AFF0187FF0187FF02
              86FF0087FF0085FF0295FF027CF40B3697CDD6EBFFFFFFFFFFFFFFFFFF7D95CE
              0251C50076FD006FEE0075F30077F7007BFC007FFF0084FF0389FF048EFF0795
              FF0B98FF0F9EFF12A1FF1AA7FF1EA9FF23ADFF28B2FF2EB3FF35B6FF29B5FF28
              B6FF33B8FF31B6FF2FB3FF28B0FF23ADFF1EABFF19A7FF14A1FF0F9EFF0B98FF
              0793FF048EFF0289FF0189FF0188FF0189FF0186FF0187FF00A4FF0239A26880
              BFFFFFFFFFFFFFFFFFFFFFFFFFE2E8F41E4EAD0883F50066F00071F00077F700
              79F9007DFE0081FF0086FF028BFF0590FF0896FF0B99FF0F9FFF12A3FF1AA5FF
              1DAAFF22AEFF23AEFF0095FF0799FF0BA0FF0094FF1AAAFF27AFFF21ADFF1DAA
              FF1AA5FF14A1FF0E9DFF0A99FF0896FF0590FF0189FF028AFF038BFF0089FF03
              89FF0288FF0198FF0780ED133695D7DEEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              90A4D41462BD15A8FF0062ED006CF40079F7007BFC007FFF0083FF0188FF038E
              FF0791FF0795FF0D99FF0F9DFF13A2FF18A4FF1CA8FF0082FFA2E3FFFFFFFFFF
              FFFFF3FCFF008CFF15A5FF1BA6FF17A5FF13A0FF0F9DFF0C99FF0997FF0691FF
              028AFF028BFF028CFF028AFF028AFF028CFF0189FF07ADFF04399E7A90C7FFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBEFF72B55AF30B2F713A3FB037BF200
              6AF40075F7007EFD0080FF0086FF0389FF028FFF0693FF0795FF0B9AFF0E9CFF
              16A2FF008DFF43BAFFFFFFFFFFFFFFFFFFFFFFFFFFB5E3FF0088FF16A2FF11A0
              FF0E9CFF0B99FF0997FF0691FF028CFF028BFF028BFF028BFF028BFF028BFF02
              89FF019EFF0B7FE41A3C9AE1E7F3FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFA3B3DB1459B728BEFF139EF31197F70076F7006FF8007DFE0081FF0085
              FF028BFF048DFF0692FF0894FF0A97FF129DFF007AFFB1E5FFFFFFFFFDFBFFFC
              FEFFFFFFFFFFFFFF0085FF0B9BFF0C99FF0A97FF0894FF0691FF028DFF0289FF
              028AFF028AFF028CFF028BFF028BFF0089FF0DAEFF04379C91A4D1FFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5F7FB3F60B33AACEF12A2FD17
              9DF317A3F8098CF80070F90078FD0082FF0085FF008AFF038CFF028FFF0592FF
              0D97FF007EFF5CBFFBFFFFFFFFFFFFFFFCFFFFFFFFDDEFF40078FF0B9BFF0894
              FF0692FF038FFF038CFF0088FF0187FF0189FF028BFF0289FF028BFF0188FF05
              A2FF1181E12B4AA2EDF0F8FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFB0BDDF1550AF37C7FF0C90F11699F518A3F7119EF90080FB0073
              FD007FFF0085FF0187FF028AFF038EFF048FFF0197FF0050EDF5F7E5FFFFFFFF
              FFFFFFFFF80067E6008EFF0992FF038FFF038EFF028AFF0186FF0185FF0187FF
              0188FF0289FF028CFF028DFF0089FF14B9FF0332979DAED6FFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFAFBFD4D6AB640A2E419
              A8FF1395F21498F5149DF715A4F90B93FB0079FD0076FF0082FF0086FF0187FF
              028BFF078EFF0099FF003DE4045FCB1479D00042DB0089FF0892FF038AFF028B
              FF0187FF0085FF0083FF0085FF0286FF0189FF0389FF028CFF0087FF0AABFF12
              76D53C5AABF6F8FBFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFC4CEE61247A556DEFF078EF0179AF3169AF5139AF714A1
              F913A2FA068AFC0074FD007CFF0083FF0084FF0087FF0082FF005FFF003EFF00
              3AFF0062FF007EFF018BFF0086FF0084FF0082FF007EFF0082FF0084FF0087FF
              0187FF0188FF028AFF008AFF1DBFFF033197B4C1E0FFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFCFDFE5F79BC3A
              8ACF2DBBFF0F91EF169AF31699F51398F8119BF815A2FB0D99FB007EFC0074FD
              007DFF007DFF006DFFE7F7FFDCF7FFD0F5FFE9F6FF1191FF0071FF0082FF007F
              FF007EFC007DFF0080FF0082FF0085FF0188FF0188FF0082FF0FB7FF1064C14D
              68B2F8F9FCFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFD0D8EC1642A15ED5FF0B93F11998F11698F21498
              F4139AF71097F7139BF813A2FB088FFA0077FB0055FC3AA7FDFFFFFFFFFFFFFF
              FFFFFFFFFFA1DDFE0058FE007FFC007BFB007AFA007DFD007FFF0081FF0084FF
              0286FF0187FF0090FF1FB4FF073097C2CDE6FFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7D
              90C8357CC63EC6FF0C8EEA1999F01698F31698F31399F61097F61097F7119EF9
              11A0F80062F61E8AF8FFFFFFFEFEFFFEFEFFFFFFFF7ECCFC0056F70079F80077
              F5007AFA007CFC007EFE0082FF0083FF0087FF007FFF15BCFF0E60BE6D83C0FE
              FEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFE3E8F4224BA56CD7FF1196F21896F01897
              EE1697F21598F21596F31296F41094F51399F70089F634A9F9FFFFFFFEFEFFFE
              FEFFFFFFFF7DCAFA004EF30076F30077F60079F9007BFB007FFD0080FF0083FF
              0083FF0091FF21B6FF13389CD7DEEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFF91A2D12A6ABA54D3FF0A88E61B97ED1896EE1894EF1595F01396F11294F2
              1395F4007DF03AA9F6FFFFFFFEFEFFFEFEFFFFFFFF7EC8FD0049EB0075F20076
              F50078F8007CFA007DFC007EFF0084FF007CFF1AC1FF0953B68195CAFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0F3F92E52AA74D7FD189EF21992
              E91A97EC1895ED1696EF1592EE1593EF1694F1007DEE3DA8F6FFFFFFFEFEFFFE
              FEFFFFFFFF79BFF60043E50077F30075F40079F7007AFB007CFC007FFF007EFF
              0293FF22B3FF1F44A2E7EBF5FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFA1AFD8225EB269E2FF0888E71E97EB1A95EB1894EA1893EC1592EB
              1893ED0079EC41AAF0FFFFFFFEFEFFFEFEFFFFFFFF85CCF80049E7006BF00074
              F30077F6007AF9007BFC0080FF0079FF20CBFF0A4EB192A4D1FFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5F7FB4160B170C5EE29AB
              F71592E81D96EC1A95EA1893E91792EC1891E9007AE844A8EFFFFFFFFEFEFFFE
              FEFFFFFFFF91D3F80072E9067EF1006BF20073F7007CF9007EFF007EFF069EFF
              25A9FA2E50A8EFF2F9FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFB6C1E01B53AD7AEAFF098AE72098EA1C96EA1A94EA1993EA
              1A94EB007DE748A9EEFFFFFFFEFEFFFEFEFFFFFFFF8DCEF70071ED0E97F50A91
              F8007AF90074FE0080FF007CFF28CFFF0547ADA6B4D9FFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFAFBFD4F6BB66FBD
              E835B2F91590E91F98EA1C95EB1B94E91C93E9007FE64CACEEFFFFFFFEFEFFFE
              FEFFFFFFFF8FD0F80075EE0E93F70C95F80B9BFB058FFF0076FF07A0FF23A7F7
              3E5CAEF4F6FBFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFC5CFE7174BA78CF3FF0989E72297E91E96E91D96E9
              1E94EA0080E44EABEFFFFFFFFEFEFFFEFEFFFFFFFF8FCFF90079F11194F70B95
              FA0997FD0E9EFF0597FF39D9FF0843A9B6C2E1FFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFEFF5F79
              BC62ABDD48C0FD128DE52398EA1F94E92095EA0081E44EADEFFFFFFFFEFEFFFE
              FEFFFFFFFF90D2F8007DF31297F80B98FB0C9AFF0494FF2CC5FF37A6EE4C69B4
              FBFCFDFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFD2DAEC1A4AA692F3FF1091E82298E82197E8
              2298E70082E355AEEDFFFFFFFEFEFFFEFEFFFFFFFF94D2FA0081F6129AFA0D9B
              FD0E9CFF099BFF54E9FF0C45AAC6CFE7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FF798DC65694D166D8FF0D89E32599E72497E70082E35FB6EFFFFFFFFFFFFFFF
              FFFFFFFFFFA8DEFD0083F6149FFC11A0FF0798FF40D6FF3094E3667EBFFEFEFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFDDE3F11E47A698EBFF1B9AEA2396E7
              2497E71E97E70082E4B9CFF2C9DAF3C5D7F3DBDDF01E93EC029BFD14A1FF129F
              FF14A7FF5BE4FF1349AED2DAECFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFF8799CD3D78C171DEFF118AE2289AE72499E9219DED0071E3006CE200
              6EE4006BE7069AF91BA4FC16A3FF0D9CFF47DCFF2584DB7489C5FFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFECEFF73359AF9AE5FE239EEB
              2397E5279CEC239DED2AA6F428A9F725AAFB23ABFC1CA4FB17A3FF17A7FF1BAE
              FF5DDFFF2553B1E2E7F3FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFA9B6DC2D68BC85E7FF0F8EE52AA0EC25A0F022A1F020A1F420
              A4F71EA5FA1AA6FE1DA9FF12A0FF53E1FF1F7AD595A6D3FFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF6F8FB4165B68BD6F8
              2DABF2249EEC29A3F027A4F323A5F620A6FA20A8FB1DA9FF1DAAFF22B2FF5BDF
              FF305EB5EEF1F8FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFBBC6E32962BB89EFFF1297EC2CA7F228A7F626A8F724
              A9FA22ABFE23AEFF17A4FF56E5FF1D73CEAAB8DCFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFAFBFD5171BD
              82CAF337BBFB25A4F12AAAF628ABFA26ACFB23AEFF24AEFF28B6FF5CD6FF416B
              BDF4F6FBFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFC7D0E8255FBA87EFFF19A1F52FAEF82CAEFA27
              AFFD2BB2FF1CA7FF5AE5FF2074D0B7C3E2FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              6984C570B6EB3CC6FF29ABF72DB3FC2CB4FF2CB2FF2CBAFF58D0FD577BC3FCFD
              FEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFD6DDEE2159B88CF8FF1AA8FB31B6FF33
              B8FF21ABFF62EBFF1F70CCC7D0E8FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFF7A92CC57A3E749D8FF2EB3FF34B6FF37C2FF51C8FC6989CAFEFEFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFE4E9F42B60BB7BEBFF2DB8FF2B
              B1FF69F1FF2671CAD8DEEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFF8DA1D34B9EE54EE3FF3DD4FF42B2F87D98D0FFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF2F4FA7199D067B5E659
              B0E66593CEEDF0F8FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFE5EDF7E3ECF6FFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF}
            TabOrder = 0
            OnClick = btInstalmentPaymentClick
          end
          object cbDopStatus: TDBLookupComboBox
            Left = 200
            Top = 204
            Width = 239
            Height = 24
            Margins.Left = 2
            Margins.Top = 2
            Margins.Right = 2
            Margins.Bottom = 2
            DataField = 'DOP_STATUS'
            DataSource = dmShowUserSt.dsContractInfo_DopStatus
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            KeyField = 'DOP_STATUS_ID'
            ListField = 'DOP_STATUS_NAME'
            ListSource = dmShowUserSt.dsContractDopStatuses
            ParentFont = False
            TabOrder = 1
            OnCloseUp = cbDopStatusCloseUp
          end
          object btPostDopStatus: TBitBtn
            Left = 443
            Top = 204
            Width = 64
            Height = 24
            Margins.Left = 2
            Margins.Top = 2
            Margins.Right = 2
            Margins.Bottom = 2
            Caption = #1055#1088#1080#1084#1077#1085#1080#1090#1100
            TabOrder = 2
            OnClick = btPostDopStatusClick
          end
          object pFrame: TPanel
            Left = 110
            Top = 127
            Width = 163
            Height = 25
            BevelOuter = bvNone
            Color = clRed
            ParentBackground = False
            TabOrder = 3
            object lbContract: TLabel
              Left = 5
              Top = 5
              Width = 67
              Height = 16
              Caption = #1044#1086#1075#1086#1074#1086#1088':'
              Color = clBtnFace
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'MS Sans Serif'
              Font.Style = [fsBold]
              ParentColor = False
              ParentFont = False
            end
          end
        end
        object Panel14: TPanel
          Left = 680
          Top = 0
          Width = 394
          Height = 233
          Align = alRight
          Alignment = taRightJustify
          BevelOuter = bvNone
          TabOrder = 1
          object Panel19: TPanel
            Left = 0
            Top = 0
            Width = 240
            Height = 233
            Margins.Left = 2
            Margins.Top = 2
            Margins.Right = 2
            Margins.Bottom = 2
            Align = alClient
            BevelOuter = bvNone
            TabOrder = 0
            object pBalanceInfo: TPanel
              Left = 0
              Top = 0
              Width = 240
              Height = 48
              Margins.Left = 2
              Margins.Top = 2
              Margins.Right = 2
              Margins.Bottom = 2
              Align = alTop
              BevelOuter = bvSpace
              TabOrder = 0
              object lBalance: TLabel
                Left = 142
                Top = 4
                Width = 78
                Height = 23
                Alignment = taRightJustify
                Caption = #1041#1072#1083#1072#1085#1089
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -19
                Font.Name = 'Verdana'
                Font.Style = [fsBold]
                ParentFont = False
              end
              object lblBalanceGroup: TLabel
                Left = 5
                Top = 26
                Width = 100
                Height = 14
                Caption = #1041#1072#1083#1072#1085#1089' '#1075#1088#1091#1087#1087#1099':'
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -12
                Font.Name = 'Verdana'
                Font.Style = []
                ParentFont = False
                Visible = False
              end
              object LblBalance: TLabel
                Left = 5
                Top = 9
                Width = 67
                Height = 18
                Hint = #1048#1089#1090#1086#1088#1080#1103' '#1073#1072#1083#1072#1085#1089#1086#1074' '#1089' '#1090#1080#1087#1072#1084#1080' '#1087#1086' '#1087#1088#1072#1074#1086#1081' '#1082#1085#1086#1087#1082#1077' '#1084#1099#1096#1080
                Alignment = taRightJustify
                Caption = #1041#1072#1083#1072#1085#1089':'
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -15
                Font.Name = 'Verdana'
                Font.Style = [fsBold, fsItalic, fsUnderline]
                ParentFont = False
                ParentShowHint = False
                PopupMenu = PopupMenuBalanceHistory
                ShowHint = False
                OnClick = LblBalanceClick
                OnMouseEnter = LblBlueOn
                OnMouseLeave = LblBlueOff
              end
              object lBalanceGroup: TLabel
                Left = 120
                Top = 26
                Width = 103
                Height = 14
                Alignment = taRightJustify
                Caption = #1041#1072#1083#1072#1085#1089' '#1075#1088#1091#1087#1087#1099
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -12
                Font.Name = 'Verdana'
                Font.Style = [fsBold]
                ParentFont = False
                Visible = False
              end
            end
            object pHandBlock: TPanel
              Left = 0
              Top = 133
              Width = 240
              Height = 100
              Margins.Left = 2
              Margins.Top = 2
              Margins.Right = 2
              Margins.Bottom = 2
              Align = alBottom
              BevelOuter = bvSpace
              TabOrder = 1
              object CbHandBlock: TCheckBox
                Left = 5
                Top = 5
                Width = 175
                Height = 17
                Caption = #1056#1091#1095#1085#1072#1103' '#1073#1083#1086#1082#1080#1088#1086#1074#1082#1072
                Font.Charset = RUSSIAN_CHARSET
                Font.Color = clWindowText
                Font.Height = -15
                Font.Name = 'Verdana'
                Font.Style = []
                ParentFont = False
                TabOrder = 0
                OnClick = CbHandBlockClick
                OnExit = CbHandBlockExit
              end
              object pnlNewHB: TPanel
                Left = 13
                Top = 24
                Width = 213
                Height = 70
                BevelOuter = bvNone
                TabOrder = 1
                object Label29: TLabel
                  Left = 2
                  Top = 28
                  Width = 128
                  Height = 13
                  Caption = #1041#1072#1083#1072#1085#1089' '#1087#1088#1077#1076#1091#1087#1088#1077#1078#1076#1077#1085#1080#1103':'
                end
                object Label30: TLabel
                  Left = 27
                  Top = 51
                  Width = 103
                  Height = 13
                  Caption = #1041#1072#1083#1072#1085#1089' '#1073#1083#1086#1082#1080#1088#1086#1074#1082#1080':'
                end
                object btSetHandBlockDateEnd: TBitBtn
                  Left = 77
                  Top = 5
                  Width = 36
                  Height = 21
                  Caption = #1054#1082
                  TabOrder = 0
                  OnClick = btSetHandBlockDateEndClick
                end
                object emNewDateEnd: TMaskEdit
                  Left = 5
                  Top = 5
                  Width = 53
                  Height = 21
                  EditMask = '!99/99/00;1;_'
                  MaxLength = 8
                  TabOrder = 1
                  Text = '  .  .  '
                end
                object eNewNoticeHB: TEdit
                  Left = 136
                  Top = 21
                  Width = 57
                  Height = 21
                  TabOrder = 2
                  OnKeyPress = eNewNoticeHBKeyPress
                end
                object eNewBlockHB: TEdit
                  Left = 136
                  Top = 46
                  Width = 57
                  Height = 21
                  TabOrder = 3
                  OnKeyPress = eNewBlockHBKeyPress
                end
              end
              object pnlShowHB: TPanel
                Left = 13
                Top = 24
                Width = 213
                Height = 70
                BevelOuter = bvNone
                TabOrder = 2
                object dbtShowDateHB: TDBText
                  Left = 5
                  Top = 2
                  Width = 172
                  Height = 21
                  DataField = 'HAND_BLOCK_DATE_END'
                  DataSource = dmShowUserSt.dsHandBlockDate
                end
                object dbtShowBlockHB: TDBText
                  Left = 139
                  Top = 53
                  Width = 68
                  Height = 17
                  DataField = 'BALANCE_BLOCK_HAND_BLOCK'
                  DataSource = dmShowUserSt.dsHandBlockDate
                end
                object Label28: TLabel
                  Left = 5
                  Top = 53
                  Width = 103
                  Height = 13
                  Caption = #1041#1072#1083#1072#1085#1089' '#1073#1083#1086#1082#1080#1088#1086#1074#1082#1080':'
                end
                object dbtShowUserHB: TDBText
                  Left = 5
                  Top = 20
                  Width = 355
                  Height = 21
                  DataField = 'USER_NAME'
                  DataSource = dmShowUserSt.dsHandBlockDate
                end
                object Label26: TLabel
                  Left = 5
                  Top = 36
                  Width = 128
                  Height = 13
                  Caption = #1041#1072#1083#1072#1085#1089' '#1087#1088#1077#1076#1091#1087#1088#1077#1078#1076#1077#1085#1080#1103':'
                end
                object dbtShowNoticeHB: TDBText
                  Left = 139
                  Top = 36
                  Width = 68
                  Height = 17
                  DataField = 'BALANCE_NOTICE_HAND_BLOCK'
                  DataSource = dmShowUserSt.dsHandBlockDate
                end
              end
            end
            object Panel20: TPanel
              Left = 0
              Top = 48
              Width = 240
              Height = 85
              Margins.Left = 2
              Margins.Top = 2
              Margins.Right = 2
              Margins.Bottom = 2
              Align = alClient
              BevelOuter = bvSpace
              TabOrder = 2
              object CBnewcab: TCheckBox
                Left = 33
                Top = 8
                Width = 171
                Height = 17
                Caption = #1041#1083#1086#1082'-'#1092#1091#1082#1094#1080#1080' '#13#10#1085#1086#1074#1086#1075#1086' '#1082#1072#1073#1080#1085#1077#1090#1072
                Checked = True
                State = cbChecked
                TabOrder = 0
              end
              object RGBlock: TRadioGroup
                Left = 1
                Top = 1
                Width = 238
                Height = 28
                Align = alTop
                BiDiMode = bdRightToLeftNoAlign
                Caption = #1041#1083#1086#1082' '#1092#1091#1085#1082#1094#1080#1080
                Columns = 3
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -9
                Font.Name = 'MS Sans Serif'
                Font.Style = []
                ParentBiDiMode = False
                ParentFont = False
                ParentShowHint = False
                ShowHint = True
                TabOrder = 1
                OnClick = RGBlockClick
              end
              object cbDailyAbonPay: TCheckBox
                Left = 5
                Top = 35
                Width = 178
                Height = 14
                Margins.Left = 2
                Margins.Top = 2
                Margins.Right = 2
                Margins.Bottom = 2
                Caption = #1055#1086#1089#1091#1090#1086#1095#1085#1072#1103' '#1072#1073#1086#1085'. '#1087#1083#1072#1090#1072
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -12
                Font.Name = 'MS Sans Serif'
                Font.Style = [fsBold]
                ParentFont = False
                TabOrder = 2
                OnClick = cbDailyAbonPayClick
              end
              object cbDailyAbonPayBanned: TCheckBox
                Left = 5
                Top = 54
                Width = 184
                Height = 13
                Margins.Left = 2
                Margins.Top = 2
                Margins.Right = 2
                Margins.Bottom = 2
                Caption = #1047#1072#1087#1088#1077#1090' '#1087#1086#1089#1091#1090'.'#1072#1073#1086#1085'.'#1087#1083#1072#1090#1099
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -12
                Font.Name = 'MS Sans Serif'
                Font.Style = [fsBold]
                ParentFont = False
                TabOrder = 3
                OnClick = cbDailyAbonPayBannedClick
              end
            end
          end
          object pTariffInfoButton: TPanel
            Left = 240
            Top = 0
            Width = 154
            Height = 233
            Margins.Left = 2
            Margins.Top = 2
            Margins.Right = 2
            Margins.Bottom = 2
            Align = alRight
            BevelOuter = bvSpace
            TabOrder = 1
            object BtBlock: TButton
              Left = 4
              Top = 4
              Width = 146
              Height = 25
              Caption = #1047#1072#1073#1083#1086#1082#1080#1088#1086#1074#1072#1090#1100
              TabOrder = 0
              OnClick = BtBlockClick
            end
            object BtUnBlock: TButton
              Left = 4
              Top = 32
              Width = 146
              Height = 25
              Caption = #1056#1072#1079#1073#1083#1086#1082#1080#1088#1086#1074#1072#1090#1100
              TabOrder = 1
              OnClick = BtUnBlockClick
            end
            object BlockListBt: TButton
              Left = 4
              Top = 59
              Width = 146
              Height = 25
              Caption = #1057#1087#1080#1089#1086#1082' '#1073#1083#1086#1082'. '#1085#1086#1084#1077#1088#1086#1074
              TabOrder = 2
              OnClick = BlockListBtClick
            end
            object BtnSendBal: TButton
              Left = 5
              Top = 143
              Width = 146
              Height = 25
              Caption = #1054#1090#1087#1088#1072#1074#1080#1090#1100' '#1073#1072#1083#1072#1085#1089
              TabOrder = 3
              OnClick = BtnSendBalClick
            end
            object BtSendSms: TButton
              Left = 5
              Top = 115
              Width = 146
              Height = 25
              Caption = #1054#1090#1087#1088#1072#1074#1080#1090#1100' '#1089#1084#1089
              TabOrder = 4
              OnClick = BtSendSmsClick
            end
            object BtSetPassword: TButton
              Left = 5
              Top = 170
              Width = 146
              Height = 25
              Caption = #1047#1072#1076#1072#1090#1100' '#1087#1072#1088#1086#1083#1100' '#1086#1090' '#1082#1072#1073#1080#1085#1077#1090#1072
              TabOrder = 5
              OnClick = BtSetPasswordClick
            end
            object BtSetPasswordOk: TButton
              Left = 116
              Top = 170
              Width = 34
              Height = 25
              Caption = #1054#1082
              TabOrder = 6
              Visible = False
              OnClick = BtSetPasswordOkClick
            end
            object UnBlockListBt: TButton
              Left = 5
              Top = 87
              Width = 146
              Height = 25
              Caption = #1057#1087#1080#1089#1086#1082' '#1088#1072#1079#1073#1083#1086#1082'. '#1085#1086#1084#1077#1088#1086#1074
              TabOrder = 7
              OnClick = UnBlockListBtClick
            end
            object eSetPassword: TEdit
              Left = 44
              Top = 170
              Width = 107
              Height = 24
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ParentFont = False
              TabOrder = 8
              Visible = False
              OnKeyPress = eSetPasswordKeyPress
            end
            object btBlockBySave: TButton
              Left = 5
              Top = 198
              Width = 146
              Height = 25
              Caption = #1047#1072#1073#1083#1086#1082#1080#1088#1086#1074#1072#1090#1100' ('#1087#1086' '#1089#1086#1093#1088'.)'
              TabOrder = 9
              OnClick = btBlockBySaveClick
            end
          end
        end
      end
    end
    object tsBalanceRows: TTabSheet
      Caption = #1056#1072#1089#1096#1080#1092#1088#1086#1074#1082#1072' '#1073#1072#1083#1072#1085#1089#1072
      ImageIndex = 6
      OnShow = tsBalanceRowsShow
      object CRDBGrid5: TCRDBGrid
        Left = 0
        Top = 40
        Width = 1074
        Height = 500
        OptionsEx = [dgeEnableSort, dgeLocalFilter, dgeLocalSorting]
        Align = alClient
        DataSource = dmShowUserSt.dsBalanceRows
        ReadOnly = True
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'MS Sans Serif'
        TitleFont.Style = []
        OnCellClick = CRDBGrid5CellClick
        Columns = <
          item
            Expanded = False
            FieldName = 'ROW_DATE'
            Title.Caption = #1044#1072#1090#1072
            Title.Font.Charset = DEFAULT_CHARSET
            Title.Font.Color = clWindowText
            Title.Font.Height = -11
            Title.Font.Name = 'MS Sans Serif'
            Title.Font.Style = [fsBold]
            Width = 76
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'COST_PLUS'
            Title.Caption = #1055#1086#1089#1090#1091#1087#1080#1083#1086
            Title.Font.Charset = DEFAULT_CHARSET
            Title.Font.Color = clWindowText
            Title.Font.Height = -11
            Title.Font.Name = 'MS Sans Serif'
            Title.Font.Style = [fsBold]
            Width = 78
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'COST_MINUS'
            Title.Caption = #1053#1072#1095#1080#1089#1083#1077#1085#1086
            Title.Font.Charset = DEFAULT_CHARSET
            Title.Font.Color = clWindowText
            Title.Font.Height = -11
            Title.Font.Name = 'MS Sans Serif'
            Title.Font.Style = [fsBold]
            Width = 72
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ROW_COMMENT'
            Title.Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
            Title.Font.Charset = DEFAULT_CHARSET
            Title.Font.Color = clWindowText
            Title.Font.Height = -11
            Title.Font.Name = 'MS Sans Serif'
            Title.Font.Style = [fsBold]
            Width = 513
            Visible = True
          end>
      end
      object Panel9: TPanel
        Left = 0
        Top = 0
        Width = 1074
        Height = 40
        Margins.Left = 2
        Margins.Top = 2
        Margins.Right = 2
        Margins.Bottom = 2
        Align = alTop
        TabOrder = 1
        object lCreditInfo: TLabel
          Left = 137
          Top = 7
          Width = 73
          Height = 20
          Margins.Left = 2
          Margins.Top = 2
          Margins.Right = 2
          Margins.Bottom = 2
          Caption = 'lCreditInfo'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clRed
          Font.Height = -16
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Ds: TBitBtn
          Left = 13
          Top = 7
          Width = 111
          Height = 21
          Margins.Left = 2
          Margins.Top = 2
          Margins.Right = 2
          Margins.Bottom = 2
          Caption = #1042#1099#1075#1088#1091#1079#1080#1090#1100
          TabOrder = 0
          OnClick = DsClick
        end
        object btAddNoBlock: TBitBtn
          Left = 788
          Top = 7
          Width = 111
          Height = 21
          Margins.Left = 2
          Margins.Top = 2
          Margins.Right = 2
          Margins.Bottom = 2
          Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1074' '#1080#1089#1082#1083
          TabOrder = 1
          OnClick = btAddNoBlockClick
        end
        object cbEXCLUDE_DETAIL: TsCheckBox
          Left = 584
          Top = 14
          Width = 204
          Height = 20
          Caption = #1048#1089#1082#1083#1102#1095#1080#1090#1100' '#1076#1077#1090#1072#1083#1080#1079#1072#1094#1080#1080' '#1080#1079' '#1073#1072#1083#1072#1085#1089#1072
          Enabled = False
          TabOrder = 2
          Visible = False
          OnClick = cbEXCLUDE_DETAILValueChanged
          SkinData.SkinSection = 'CHECKBOX'
          ImgChecked = 0
          ImgUnchecked = 0
        end
      end
    end
    object tsPayments: TTabSheet
      Caption = #1055#1083#1072#1090#1077#1078#1080
      ImageIndex = 3
      object PageControl2: TPageControl
        Left = 0
        Top = 0
        Width = 1074
        Height = 540
        Margins.Left = 2
        Margins.Top = 2
        Margins.Right = 2
        Margins.Bottom = 2
        ActivePage = tsPaymentsPromised
        Align = alClient
        TabOrder = 0
        object tsPaymentsReal: TTabSheet
          Margins.Left = 2
          Margins.Top = 2
          Margins.Right = 2
          Margins.Bottom = 2
          Caption = #1055#1083#1072#1090#1077#1078#1080' '#1086#1087#1077#1088#1072#1090#1086#1088#1072
          OnShow = tsPaymentsRealShow
          object Panel7: TPanel
            Left = 0
            Top = 0
            Width = 1066
            Height = 512
            Align = alClient
            BevelOuter = bvNone
            TabOrder = 0
            object gPayments: TCRDBGrid
              Left = 0
              Top = 41
              Width = 1066
              Height = 471
              OptionsEx = [dgeEnableSort, dgeLocalFilter, dgeLocalSorting]
              Align = alClient
              DataSource = dmShowUserSt.dsPayments
              PopupMenu = PopupMenu1
              TabOrder = 0
              TitleFont.Charset = DEFAULT_CHARSET
              TitleFont.Color = clWindowText
              TitleFont.Height = -11
              TitleFont.Name = 'MS Sans Serif'
              TitleFont.Style = []
              OnCellClick = gPaymentsCellClick
              OnDblClick = gPaymentsDblClick
              Columns = <
                item
                  Expanded = False
                  FieldName = 'PAYMENT_DATE'
                  Title.Alignment = taCenter
                  Title.Caption = #1044#1072#1090#1072
                  Title.Font.Charset = DEFAULT_CHARSET
                  Title.Font.Color = clWindowText
                  Title.Font.Height = -11
                  Title.Font.Name = 'MS Sans Serif'
                  Title.Font.Style = [fsBold]
                  Width = 100
                  Visible = True
                end
                item
                  Expanded = False
                  FieldName = 'PAYMENT_SUM'
                  Title.Alignment = taCenter
                  Title.Caption = #1057#1091#1084#1084#1072
                  Title.Font.Charset = DEFAULT_CHARSET
                  Title.Font.Color = clWindowText
                  Title.Font.Height = -11
                  Title.Font.Name = 'MS Sans Serif'
                  Title.Font.Style = [fsBold]
                  Width = 100
                  Visible = True
                end
                item
                  Expanded = False
                  FieldName = 'PAYMENT_NUMBER'
                  Title.Alignment = taCenter
                  Title.Caption = #1053#1086#1084#1077#1088' '#1087#1083#1072#1090#1077#1078#1072
                  Title.Font.Charset = DEFAULT_CHARSET
                  Title.Font.Color = clWindowText
                  Title.Font.Height = -11
                  Title.Font.Name = 'MS Sans Serif'
                  Title.Font.Style = [fsBold]
                  Width = 165
                  Visible = True
                end
                item
                  Expanded = False
                  FieldName = 'PAYMENT_REMARK'
                  Title.Alignment = taCenter
                  Title.Caption = #1057#1090#1072#1090#1091#1089
                  Title.Font.Charset = DEFAULT_CHARSET
                  Title.Font.Color = clWindowText
                  Title.Font.Height = -11
                  Title.Font.Name = 'MS Sans Serif'
                  Title.Font.Style = [fsBold]
                  Width = 200
                  Visible = True
                end
                item
                  Expanded = False
                  FieldName = 'PAYMENT_TYPE_NAME'
                  Title.Caption = #1058#1080#1087' '#1087#1083'.'
                  Title.Font.Charset = DEFAULT_CHARSET
                  Title.Font.Color = clWindowText
                  Title.Font.Height = -11
                  Title.Font.Name = 'MS Sans Serif'
                  Title.Font.Style = [fsBold]
                  Width = 50
                  Visible = True
                end
                item
                  ButtonStyle = cbsEllipsis
                  Expanded = False
                  FieldName = 'CONTRACT_ID'
                  Title.Alignment = taCenter
                  Title.Caption = #1055#1088#1080#1082#1088#1077#1087#1083#1105#1085
                  Title.Font.Charset = DEFAULT_CHARSET
                  Title.Font.Color = clWindowText
                  Title.Font.Height = -11
                  Title.Font.Name = 'MS Sans Serif'
                  Title.Font.Style = [fsBold]
                  Width = 53
                  Visible = True
                end
                item
                  ButtonStyle = cbsEllipsis
                  Expanded = False
                  FieldName = 'CREATED_DATE'
                  Title.Alignment = taCenter
                  Title.Caption = #1042#1088#1077#1084#1103' '#1087#1086#1089#1090#1091#1087#1083#1077#1085#1080#1103' '#1074' '#1058#1072#1088#1080#1092#1077#1088
                  Title.Font.Charset = DEFAULT_CHARSET
                  Title.Font.Color = clWindowText
                  Title.Font.Height = -11
                  Title.Font.Name = 'MS Sans Serif'
                  Title.Font.Style = [fsBold]
                  Width = 203
                  Visible = True
                end
                item
                  Expanded = False
                  FieldName = 'RECEIVED_PAYMENT_ID'
                  Width = -1
                  Visible = False
                end
                item
                  Expanded = False
                  FieldName = 'REVERSESCHET'
                  Title.Caption = #1050#1086#1084#1087'.'#1089#1095'.'
                  Title.Font.Charset = DEFAULT_CHARSET
                  Title.Font.Color = clWindowText
                  Title.Font.Height = -11
                  Title.Font.Name = 'MS Sans Serif'
                  Title.Font.Style = [fsBold]
                  Width = 15
                  Visible = True
                end>
            end
            object pPaymentsToolBar: TPanel
              Left = 0
              Top = 0
              Width = 1066
              Height = 41
              Align = alTop
              TabOrder = 1
              object lblEveragePayments: TLabel
                Left = 672
                Top = 0
                Width = 96
                Height = 13
                Caption = 'lblEveragePayments'
              end
              object lblLabelEvPaym: TLabel
                Left = 582
                Top = 0
                Width = 83
                Height = 13
                Caption = #1057#1088#1077#1076#1085#1080#1081' '#1087#1083#1072#1090#1105#1078
              end
              object lblItogPaym: TLabel
                Left = 672
                Top = 12
                Width = 96
                Height = 13
                Caption = 'lblEveragePayments'
              end
              object lblItogPayment: TLabel
                Left = 582
                Top = 12
                Width = 86
                Height = 13
                Caption = #1057#1091#1084#1084#1072' '#1087#1083#1072#1090#1077#1078#1077#1081
              end
              object btnUsePayment: TButton
                Left = 32
                Top = 8
                Width = 122
                Height = 25
                Action = aLinkPayment
                TabOrder = 0
              end
              object btnUnUsePayment: TButton
                Left = 160
                Top = 8
                Width = 129
                Height = 25
                Action = aUnlinkPayment
                TabOrder = 1
              end
              object btnAdd: TButton
                Left = 298
                Top = 8
                Width = 89
                Height = 25
                Action = aAddPayment
                TabOrder = 2
              end
              object btnExportPayments: TBitBtn
                Left = 392
                Top = 8
                Width = 111
                Height = 25
                Margins.Left = 2
                Margins.Top = 2
                Margins.Right = 2
                Margins.Bottom = 2
                Caption = #1042#1099#1075#1088#1091#1079#1080#1090#1100
                TabOrder = 3
                OnClick = btnExportPaymentsClick
              end
            end
            object MonthCalendar1: TMonthCalendar
              Left = 128
              Top = 64
              Width = 191
              Height = 160
              Date = 41584.472866898150000000
              TabOrder = 2
              TabStop = True
              Visible = False
              OnDblClick = MonthCalendar1DblClick
              OnMouseLeave = MonthCalendar1MouseLeave
            end
          end
        end
        object tsPaymentsPromised: TTabSheet
          Margins.Left = 2
          Margins.Top = 2
          Margins.Right = 2
          Margins.Bottom = 2
          Caption = #1054#1073#1077#1097#1072#1085#1085#1099#1077' '#1087#1083#1072#1090#1077#1078#1080
          ImageIndex = 1
          OnShow = tsPaymentsPromisedShow
          object Panel11: TPanel
            Left = 0
            Top = 0
            Width = 1066
            Height = 512
            Margins.Left = 2
            Margins.Top = 2
            Margins.Right = 2
            Margins.Bottom = 2
            Align = alClient
            Caption = 'Panel11'
            TabOrder = 0
            object Panel12: TPanel
              Left = 1
              Top = 1
              Width = 1064
              Height = 33
              Margins.Left = 2
              Margins.Top = 2
              Margins.Right = 2
              Margins.Bottom = 2
              Align = alTop
              TabOrder = 0
              object lPromisedSum: TLabel
                Left = 15
                Top = 7
                Width = 53
                Height = 16
                Margins.Left = 2
                Margins.Top = 2
                Margins.Right = 2
                Margins.Bottom = 2
                Caption = #1057#1091#1084#1084#1072':'
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -15
                Font.Name = 'MS Sans Serif'
                Font.Style = [fsBold]
                ParentFont = False
              end
              object lPromisedTime: TLabel
                Left = 150
                Top = 7
                Width = 35
                Height = 16
                Margins.Left = 2
                Margins.Top = 2
                Margins.Right = 2
                Margins.Bottom = 2
                Caption = #1044#1072#1090#1072':'
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -15
                Font.Name = 'MS Sans Serif'
                Font.Style = []
                ParentFont = False
              end
              object btAddPromisedPayment: TBitBtn
                Left = 288
                Top = 7
                Width = 83
                Height = 20
                Margins.Left = 2
                Margins.Top = 2
                Margins.Right = 2
                Margins.Bottom = 2
                Caption = #1044#1086#1073#1072#1074#1080#1090#1100
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -12
                Font.Name = 'MS Sans Serif'
                Font.Style = [fsBold]
                ParentFont = False
                TabOrder = 0
                OnClick = btAddPromisedPaymentClick
              end
              object ePromisedSum: TEdit
                Left = 76
                Top = 7
                Width = 58
                Height = 21
                Margins.Left = 2
                Margins.Top = 2
                Margins.Right = 2
                Margins.Bottom = 2
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -12
                Font.Name = 'MS Sans Serif'
                Font.Style = [fsBold]
                ParentFont = False
                TabOrder = 1
                Text = '0'
              end
              object sdePromisedDate: TsDateEdit
                Left = 194
                Top = 7
                Width = 90
                Height = 17
                Margins.Left = 2
                Margins.Top = 2
                Margins.Right = 2
                Margins.Bottom = 2
                AutoSize = False
                EditMask = '!99/99/9999;1; '
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -12
                Font.Name = 'MS Sans Serif'
                Font.Style = [fsBold]
                MaxLength = 10
                ParentFont = False
                TabOrder = 2
                Text = '  .  .    '
                BoundLabel.Indent = 0
                BoundLabel.Font.Charset = DEFAULT_CHARSET
                BoundLabel.Font.Color = clWindowText
                BoundLabel.Font.Height = -13
                BoundLabel.Font.Name = 'Tahoma'
                BoundLabel.Font.Style = []
                BoundLabel.Layout = sclLeft
                BoundLabel.MaxWidth = 0
                BoundLabel.UseSkinColor = True
                SkinData.SkinSection = 'EDIT'
                GlyphMode.Blend = 0
                GlyphMode.Grayed = False
              end
              object btDelPromisedPayment: TBitBtn
                Left = 376
                Top = 7
                Width = 184
                Height = 20
                Margins.Left = 2
                Margins.Top = 2
                Margins.Right = 2
                Margins.Bottom = 2
                Caption = #1054#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1090#1077#1082'. '#1086#1073'. '#1087#1083#1072#1090#1077#1078
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clRed
                Font.Height = -12
                Font.Name = 'MS Sans Serif'
                Font.Style = [fsBold]
                ParentFont = False
                TabOrder = 3
                OnClick = btDelPromisedPaymentClick
              end
            end
            object gPromisedPayments: TCRDBGrid
              Left = 1
              Top = 34
              Width = 1064
              Height = 477
              Margins.Left = 2
              Margins.Top = 2
              Margins.Right = 2
              Margins.Bottom = 2
              Align = alClient
              DataSource = dmShowUserSt.dsPrPayments
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -12
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ParentFont = False
              TabOrder = 1
              TitleFont.Charset = DEFAULT_CHARSET
              TitleFont.Color = clWindowText
              TitleFont.Height = -14
              TitleFont.Name = 'MS Sans Serif'
              TitleFont.Style = [fsBold]
            end
          end
        end
      end
    end
    object tsDeposit: TTabSheet
      Caption = #1044#1077#1087#1086#1079#1080#1090#1099
      ImageIndex = 7
      OnShow = tsDepositShow
      object lDepositValue: TLabel
        Left = 16
        Top = 19
        Width = 151
        Height = 18
        Caption = #1058#1077#1082#1091#1097#1080#1081' '#1076#1077#1087#1086#1079#1080#1090':'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Verdana'
        Font.Style = []
        ParentFont = False
      end
      object lDepositOper: TLabel
        Left = 16
        Top = 69
        Width = 75
        Height = 18
        Caption = #1048#1089#1090#1086#1088#1080#1103':'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Verdana'
        Font.Style = []
        ParentFont = False
      end
      object dbtDepositValue: TDBText
        Left = 175
        Top = 19
        Width = 65
        Height = 20
        DataField = 'CURRENT_DEPOSITE_VALUE'
        DataSource = dmShowUserSt.dsDeposit
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Verdana'
        Font.Style = []
        ParentFont = False
      end
      object dbDepositOper: TCRDBGrid
        Left = 16
        Top = 104
        Width = 859
        Height = 335
        DataSource = dmShowUserSt.dsDepositOper
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'MS Sans Serif'
        TitleFont.Style = []
        Columns = <
          item
            Expanded = False
            FieldName = 'OPERATION_DATE_TIME'
            Title.Caption = #1044#1072#1090#1072' '#1076#1077#1087#1086#1079#1080#1090#1072
            Title.Font.Charset = DEFAULT_CHARSET
            Title.Font.Color = clWindowText
            Title.Font.Height = -11
            Title.Font.Name = 'MS Sans Serif'
            Title.Font.Style = [fsBold]
            Width = 112
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'DEPOSITE_VALUE'
            Title.Caption = #1057#1091#1084#1084#1072' '#1076#1077#1087#1086#1079#1080#1090#1072
            Title.Font.Charset = DEFAULT_CHARSET
            Title.Font.Color = clWindowText
            Title.Font.Height = -11
            Title.Font.Name = 'MS Sans Serif'
            Title.Font.Style = [fsBold]
            Width = 109
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'OPERATOR_NAME'
            Title.Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100
            Title.Font.Charset = DEFAULT_CHARSET
            Title.Font.Color = clWindowText
            Title.Font.Height = -11
            Title.Font.Name = 'MS Sans Serif'
            Title.Font.Style = [fsBold]
            Width = 110
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'NOTE'
            Title.Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
            Title.Font.Charset = DEFAULT_CHARSET
            Title.Font.Color = clWindowText
            Title.Font.Height = -11
            Title.Font.Name = 'MS Sans Serif'
            Title.Font.Style = [fsBold]
            Width = 2404
            Visible = True
          end>
      end
      object btAddDeposit: TBitBtn
        Left = 97
        Top = 65
        Width = 224
        Height = 29
        Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1089#1091#1084#1084#1091' '#1076#1077#1087#1086#1079#1080#1090#1072
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Verdana'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        OnClick = btAddDepositClick
      end
      object BitBtn_MN_Roaming: TBitBtn
        Left = 599
        Top = 65
        Width = 211
        Height = 29
        Caption = 'BitBtn_MN_Roaming'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Verdana'
        Font.Style = []
        ParentFont = False
        TabOrder = 2
        OnClick = BitBtn_MN_RoamingClick
      end
      object Lb_MN_ROAMING: TLinkLabel
        Left = 376
        Top = 69
        Width = 217
        Height = 29
        AutoSize = False
        Caption = 'Lb_MN_ROAMING'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Verdana'
        Font.Style = []
        ParentFont = False
        TabOrder = 3
      end
    end
    object tsBills: TTabSheet
      Caption = #1057#1095#1077#1090#1072
      ImageIndex = 4
      object PageControl4: TPageControl
        Left = 0
        Top = 0
        Width = 1074
        Height = 540
        Margins.Left = 2
        Margins.Top = 2
        Margins.Right = 2
        Margins.Bottom = 2
        ActivePage = tsBillsNewFormat
        Align = alClient
        TabOrder = 0
        object tsBillsNewFormat: TTabSheet
          Margins.Left = 2
          Margins.Top = 2
          Margins.Right = 2
          Margins.Bottom = 2
          Caption = #1053#1086#1074#1099#1081' '#1092#1086#1088#1084#1072#1090'('#1089' '#1072#1074#1075#1091#1089#1090#1072' 2012)'
          ImageIndex = 1
          OnShow = tsBillsNewFormatShow
          object PageControl5: TPageControl
            Left = 0
            Top = 0
            Width = 1066
            Height = 512
            Margins.Left = 2
            Margins.Top = 2
            Margins.Right = 2
            Margins.Bottom = 2
            ActivePage = tsBillClientNew
            Align = alClient
            TabOrder = 0
            object tsBillBeeline: TTabSheet
              Margins.Left = 2
              Margins.Top = 2
              Margins.Right = 2
              Margins.Bottom = 2
              Caption = #1057#1095#1077#1090#1072' '#1041#1080#1083#1072#1081#1085#1072
              OnShow = tsBillBeelineShow
              object pBillBeeline: TPanel
                Left = 0
                Top = 0
                Width = 1058
                Height = 40
                Margins.Left = 2
                Margins.Top = 2
                Margins.Right = 2
                Margins.Bottom = 2
                Align = alTop
                TabOrder = 0
                object btBillBeeline: TBitBtn
                  Left = 13
                  Top = 7
                  Width = 111
                  Height = 21
                  Margins.Left = 2
                  Margins.Top = 2
                  Margins.Right = 2
                  Margins.Bottom = 2
                  Caption = #1042#1099#1075#1088#1091#1079#1080#1090#1100
                  TabOrder = 0
                  OnClick = btBillBeelineClick
                end
              end
              object grBillBeeline: TCRDBGrid
                Left = 0
                Top = 40
                Width = 1058
                Height = 444
                Margins.Left = 2
                Margins.Top = 2
                Margins.Right = 2
                Margins.Bottom = 2
                Align = alClient
                DataSource = dmShowUserSt.dsBillBeeline
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -12
                Font.Name = 'MS Sans Serif'
                Font.Style = []
                ParentFont = False
                TabOrder = 1
                TitleFont.Charset = DEFAULT_CHARSET
                TitleFont.Color = clWindowText
                TitleFont.Height = -14
                TitleFont.Name = 'MS Sans Serif'
                TitleFont.Style = [fsBold]
              end
            end
            object tsBillClientNew: TTabSheet
              Margins.Left = 2
              Margins.Top = 2
              Margins.Right = 2
              Margins.Bottom = 2
              Caption = #1057#1095#1077#1090#1072' '#1082#1083#1080#1077#1085#1090#1091
              ImageIndex = 1
              OnShow = tsBillClientNewShow
              object pBillClientNew: TPanel
                Left = 0
                Top = 0
                Width = 1058
                Height = 40
                Margins.Left = 2
                Margins.Top = 2
                Margins.Right = 2
                Margins.Bottom = 2
                Align = alTop
                TabOrder = 0
                object btBillClientNew: TBitBtn
                  Left = 13
                  Top = 7
                  Width = 111
                  Height = 21
                  Margins.Left = 2
                  Margins.Top = 2
                  Margins.Right = 2
                  Margins.Bottom = 2
                  Caption = #1042#1099#1075#1088#1091#1079#1080#1090#1100
                  TabOrder = 0
                  OnClick = btBillClientNewClick
                end
              end
              object grBillClientNew: TCRDBGrid
                Left = 0
                Top = 40
                Width = 1058
                Height = 444
                Margins.Left = 2
                Margins.Top = 2
                Margins.Right = 2
                Margins.Bottom = 2
                Align = alClient
                DataSource = dmShowUserSt.dsBillClientNew
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -12
                Font.Name = 'MS Sans Serif'
                Font.Style = []
                ParentFont = False
                TabOrder = 1
                TitleFont.Charset = DEFAULT_CHARSET
                TitleFont.Color = clWindowText
                TitleFont.Height = -14
                TitleFont.Name = 'MS Sans Serif'
                TitleFont.Style = [fsBold]
              end
            end
            object tsAbonPeriodList: TTabSheet
              Margins.Left = 2
              Margins.Top = 2
              Margins.Right = 2
              Margins.Bottom = 2
              Caption = #1055#1077#1088#1080#1086#1076#1099' '#1072#1073#1086#1085'. '#1072#1082#1090'.'
              ImageIndex = 2
              OnShow = tsAbonPeriodListShow
              object pAbonPeriodList: TPanel
                Left = 0
                Top = 0
                Width = 1058
                Height = 40
                Margins.Left = 2
                Margins.Top = 2
                Margins.Right = 2
                Margins.Bottom = 2
                Align = alTop
                TabOrder = 0
                object btAbonPeriodList: TBitBtn
                  Left = 13
                  Top = 7
                  Width = 111
                  Height = 21
                  Margins.Left = 2
                  Margins.Top = 2
                  Margins.Right = 2
                  Margins.Bottom = 2
                  Caption = #1042#1099#1075#1088#1091#1079#1080#1090#1100
                  TabOrder = 0
                  OnClick = btAbonPeriodListClick
                end
              end
              object grAbonPeriodList: TCRDBGrid
                Left = 0
                Top = 40
                Width = 1058
                Height = 444
                Margins.Left = 2
                Margins.Top = 2
                Margins.Right = 2
                Margins.Bottom = 2
                Align = alClient
                DataSource = dmShowUserSt.dsAbonPeriodList
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -12
                Font.Name = 'MS Sans Serif'
                Font.Style = []
                ParentFont = False
                TabOrder = 1
                TitleFont.Charset = DEFAULT_CHARSET
                TitleFont.Color = clWindowText
                TitleFont.Height = -14
                TitleFont.Name = 'MS Sans Serif'
                TitleFont.Style = [fsBold]
              end
            end
            object tsRouming: TTabSheet
              Margins.Left = 2
              Margins.Top = 2
              Margins.Right = 2
              Margins.Bottom = 2
              Caption = #1056#1086#1091#1084#1080#1085#1075
              ImageIndex = 3
              OnShow = tsRoumingShow
              object pRouming: TPanel
                Left = 0
                Top = 0
                Width = 1058
                Height = 40
                Margins.Left = 2
                Margins.Top = 2
                Margins.Right = 2
                Margins.Bottom = 2
                Align = alTop
                TabOrder = 0
                object btRouming: TBitBtn
                  Left = 13
                  Top = 7
                  Width = 111
                  Height = 21
                  Margins.Left = 2
                  Margins.Top = 2
                  Margins.Right = 2
                  Margins.Bottom = 2
                  Caption = #1042#1099#1075#1088#1091#1079#1080#1090#1100
                  TabOrder = 0
                  OnClick = btRoumingClick
                end
              end
              object grRouming: TCRDBGrid
                Left = 0
                Top = 40
                Width = 1058
                Height = 444
                Margins.Left = 2
                Margins.Top = 2
                Margins.Right = 2
                Margins.Bottom = 2
                Align = alClient
                DataSource = dmShowUserSt.dsRouming
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -12
                Font.Name = 'MS Sans Serif'
                Font.Style = []
                ParentFont = False
                TabOrder = 1
                TitleFont.Charset = DEFAULT_CHARSET
                TitleFont.Color = clWindowText
                TitleFont.Height = -14
                TitleFont.Name = 'MS Sans Serif'
                TitleFont.Style = [fsBold]
              end
            end
          end
        end
        object tsBillsOldFormat: TTabSheet
          Margins.Left = 2
          Margins.Top = 2
          Margins.Right = 2
          Margins.Bottom = 2
          Caption = #1057#1090#1072#1088#1099#1081' '#1092#1086#1088#1084#1072#1090'('#1076#1086' '#1080#1102#1083#1103' 2012)'
          object PageControl3: TPageControl
            Left = 0
            Top = 0
            Width = 1066
            Height = 512
            Margins.Left = 2
            Margins.Top = 2
            Margins.Right = 2
            Margins.Bottom = 2
            ActivePage = tsOperatorBills
            Align = alClient
            TabOrder = 0
            object tsOperatorBills: TTabSheet
              Margins.Left = 2
              Margins.Top = 2
              Margins.Right = 2
              Margins.Bottom = 2
              Caption = #1057#1095#1077#1090#1072' '#1086#1087#1077#1088#1072#1090#1086#1088#1072
              OnShow = tsOperatorBillsShow
              object CRDBGrid4: TCRDBGrid
                Left = 0
                Top = 40
                Width = 1058
                Height = 444
                OptionsEx = [dgeEnableSort, dgeLocalFilter, dgeLocalSorting]
                OnGetCellParams = CRDBGrid4GetCellParams
                Align = alClient
                DataSource = dmShowUserSt.dsBills
                ReadOnly = True
                TabOrder = 0
                TitleFont.Charset = DEFAULT_CHARSET
                TitleFont.Color = clWindowText
                TitleFont.Height = -11
                TitleFont.Name = 'MS Sans Serif'
                TitleFont.Style = []
                Columns = <
                  item
                    Expanded = False
                    FieldName = 'DATE_BEGIN'
                    Title.Caption = #1053#1072#1095#1072#1083#1086
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
                    FieldName = 'DATE_END'
                    Title.Caption = #1054#1082#1086#1085#1095#1072#1085#1080#1077
                    Title.Font.Charset = DEFAULT_CHARSET
                    Title.Font.Color = clWindowText
                    Title.Font.Height = -11
                    Title.Font.Name = 'MS Sans Serif'
                    Title.Font.Style = [fsBold]
                    Width = 72
                    Visible = True
                  end
                  item
                    Expanded = False
                    FieldName = 'BILL_SUM'
                    Font.Charset = DEFAULT_CHARSET
                    Font.Color = clWindowText
                    Font.Height = -11
                    Font.Name = 'MS Sans Serif'
                    Font.Style = [fsBold]
                    Title.Caption = #1057#1091#1084#1084#1072' '#1089#1095#1105#1090#1072
                    Title.Font.Charset = DEFAULT_CHARSET
                    Title.Font.Color = clWindowText
                    Title.Font.Height = -11
                    Title.Font.Name = 'MS Sans Serif'
                    Title.Font.Style = [fsBold]
                    Width = 82
                    Visible = True
                  end
                  item
                    Expanded = False
                    FieldName = 'SUBSCRIBER_PAYMENT_MAIN'
                    Title.Caption = #1040'/'#1087' '#1087#1086' '#1090#1072#1088#1080#1092#1091
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
                    FieldName = 'SUBSCRIBER_PAYMENT_ADD'
                    Title.Caption = #1040'/'#1087' '#1079#1072' '#1076#1086#1087'.'#1091#1089#1083#1091#1075#1080
                    Title.Font.Charset = DEFAULT_CHARSET
                    Title.Font.Color = clWindowText
                    Title.Font.Height = -11
                    Title.Font.Name = 'MS Sans Serif'
                    Title.Font.Style = [fsBold]
                    Width = 114
                    Visible = True
                  end
                  item
                    Expanded = False
                    FieldName = 'SINGLE_PAYMENTS'
                    Title.Caption = #1056#1072#1079#1086#1074#1099#1077' '#1087#1083#1072#1090'.'
                    Title.Font.Charset = DEFAULT_CHARSET
                    Title.Font.Color = clWindowText
                    Title.Font.Height = -11
                    Title.Font.Name = 'MS Sans Serif'
                    Title.Font.Style = [fsBold]
                    Width = 91
                    Visible = True
                  end
                  item
                    Expanded = False
                    FieldName = 'CALLS_LOCAL_COST'
                    Title.Caption = #1052#1077#1089#1090#1085#1099#1077' '#1079#1074#1086#1085#1082#1080
                    Title.Font.Charset = DEFAULT_CHARSET
                    Title.Font.Color = clWindowText
                    Title.Font.Height = -11
                    Title.Font.Name = 'MS Sans Serif'
                    Title.Font.Style = [fsBold]
                    Width = 82
                    Visible = True
                  end
                  item
                    Expanded = False
                    FieldName = 'CALLS_OTHER_CITY_COST'
                    Title.Caption = #1052#1077#1078#1075#1086#1088#1086#1076
                    Title.Font.Charset = DEFAULT_CHARSET
                    Title.Font.Color = clWindowText
                    Title.Font.Height = -11
                    Title.Font.Name = 'MS Sans Serif'
                    Title.Font.Style = [fsBold]
                    Width = 67
                    Visible = True
                  end
                  item
                    Expanded = False
                    FieldName = 'CALLS_OTHER_COUNTRY_COST'
                    Title.Caption = #1052'/'#1085#1072#1088#1086#1076#1085#1099#1077
                    Title.Font.Charset = DEFAULT_CHARSET
                    Title.Font.Color = clWindowText
                    Title.Font.Height = -11
                    Title.Font.Name = 'MS Sans Serif'
                    Title.Font.Style = [fsBold]
                    Width = 84
                    Visible = True
                  end
                  item
                    Expanded = False
                    FieldName = 'MESSAGES_COST'
                    Title.Caption = #1057#1086#1086#1073#1097#1077#1085#1080#1103
                    Title.Font.Charset = DEFAULT_CHARSET
                    Title.Font.Color = clWindowText
                    Title.Font.Height = -11
                    Title.Font.Name = 'MS Sans Serif'
                    Title.Font.Style = [fsBold]
                    Width = 76
                    Visible = True
                  end
                  item
                    Expanded = False
                    FieldName = 'INTERNET_COST'
                    Title.Caption = #1048#1085#1090#1077#1088#1085#1077#1090
                    Title.Font.Charset = DEFAULT_CHARSET
                    Title.Font.Color = clWindowText
                    Title.Font.Height = -11
                    Title.Font.Name = 'MS Sans Serif'
                    Title.Font.Style = [fsBold]
                    Width = 60
                    Visible = True
                  end
                  item
                    Expanded = False
                    FieldName = 'OTHER_COUNTRY_ROAMING_COST'
                    Title.Caption = #1052'/'#1085' '#1088#1086#1091#1084#1080#1085#1075
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
                    FieldName = 'OTHER_COUNTRY_ROAMING_CALLS'
                    Title.Alignment = taCenter
                    Title.Caption = #1052'/'#1085' '#1088'. '#1079#1074'.('#1087#1072#1088'.)'
                    Title.Font.Charset = DEFAULT_CHARSET
                    Title.Font.Color = clWindowText
                    Title.Font.Height = -12
                    Title.Font.Name = 'MS Sans Serif'
                    Title.Font.Style = [fsBold]
                    Width = 60
                    Visible = True
                  end
                  item
                    Expanded = False
                    FieldName = 'OTHER_COUNTRY_ROAMING_MESSAGES'
                    Title.Alignment = taCenter
                    Title.Caption = #1052'/'#1085' '#1088'. '#1057#1052#1057'.('#1087#1072#1088'.)'
                    Title.Font.Charset = DEFAULT_CHARSET
                    Title.Font.Color = clWindowText
                    Title.Font.Height = -12
                    Title.Font.Name = 'MS Sans Serif'
                    Title.Font.Style = [fsBold]
                    Width = 60
                    Visible = True
                  end
                  item
                    Expanded = False
                    FieldName = 'OTHER_COUNTRY_ROAMING_INTERNET'
                    Title.Alignment = taCenter
                    Title.Caption = #1052'/'#1085' '#1088'. '#1080#1085#1090'.('#1087#1072#1088'.)'
                    Title.Font.Charset = DEFAULT_CHARSET
                    Title.Font.Color = clWindowText
                    Title.Font.Height = -12
                    Title.Font.Name = 'MS Sans Serif'
                    Title.Font.Style = [fsBold]
                    Width = 60
                    Visible = True
                  end
                  item
                    Expanded = False
                    FieldName = 'NATIONAL_ROAMING_COST'
                    Title.Caption = #1053#1072#1094'. '#1088#1086#1091#1084#1080#1085#1075
                    Title.Font.Charset = DEFAULT_CHARSET
                    Title.Font.Color = clWindowText
                    Title.Font.Height = -11
                    Title.Font.Name = 'MS Sans Serif'
                    Title.Font.Style = [fsBold]
                    Width = 85
                    Visible = True
                  end
                  item
                    Expanded = False
                    FieldName = 'NATIONAL_ROAMING_CALLS'
                    Title.Alignment = taCenter
                    Title.Caption = #1053#1072#1094'.'#1088'. '#1079#1074'.('#1087#1072#1088'.)'
                    Title.Font.Charset = DEFAULT_CHARSET
                    Title.Font.Color = clWindowText
                    Title.Font.Height = -12
                    Title.Font.Name = 'MS Sans Serif'
                    Title.Font.Style = [fsBold]
                    Width = 60
                    Visible = True
                  end
                  item
                    Expanded = False
                    FieldName = 'NATIONAL_ROAMING_MESSAGES'
                    Title.Alignment = taCenter
                    Title.Caption = #1053#1072#1094'.'#1088'. '#1057#1052#1057'.('#1087#1072#1088'.)'
                    Title.Font.Charset = DEFAULT_CHARSET
                    Title.Font.Color = clWindowText
                    Title.Font.Height = -12
                    Title.Font.Name = 'MS Sans Serif'
                    Title.Font.Style = [fsBold]
                    Width = 60
                    Visible = True
                  end
                  item
                    Expanded = False
                    FieldName = 'NATIONAL_ROAMING_INTERNET'
                    Title.Alignment = taCenter
                    Title.Caption = #1053#1072#1094'.'#1088'. '#1080#1085#1090'.('#1087#1072#1088'.)'
                    Title.Font.Charset = DEFAULT_CHARSET
                    Title.Font.Color = clWindowText
                    Title.Font.Height = -12
                    Title.Font.Name = 'MS Sans Serif'
                    Title.Font.Style = [fsBold]
                    Width = 60
                    Visible = True
                  end
                  item
                    Expanded = False
                    FieldName = 'PENI_COST'
                    Title.Caption = #1064#1090#1088#1072#1092#1099
                    Title.Font.Charset = DEFAULT_CHARSET
                    Title.Font.Color = clWindowText
                    Title.Font.Height = -11
                    Title.Font.Name = 'MS Sans Serif'
                    Title.Font.Style = [fsBold]
                    Width = 60
                    Visible = True
                  end
                  item
                    Expanded = False
                    FieldName = 'DISCOUNT_VALUE'
                    Title.Caption = #1057#1082#1080#1076#1082#1072
                    Title.Font.Charset = DEFAULT_CHARSET
                    Title.Font.Color = clWindowText
                    Title.Font.Height = -11
                    Title.Font.Name = 'MS Sans Serif'
                    Title.Font.Style = [fsBold]
                    Width = 60
                    Visible = True
                  end
                  item
                    Expanded = False
                    FieldName = 'TARIFF_CODE'
                    Title.Alignment = taCenter
                    Title.Caption = #1050#1086#1076' '#1090#1072#1088#1080#1092#1072
                    Title.Font.Charset = DEFAULT_CHARSET
                    Title.Font.Color = clWindowText
                    Title.Font.Height = -11
                    Title.Font.Name = 'MS Sans Serif'
                    Title.Font.Style = [fsBold]
                    Width = 80
                    Visible = True
                  end>
              end
              object Panel13: TPanel
                Left = 0
                Top = 0
                Width = 1058
                Height = 40
                Margins.Left = 2
                Margins.Top = 2
                Margins.Right = 2
                Margins.Bottom = 2
                Align = alTop
                TabOrder = 1
                object BitBtn6: TBitBtn
                  Left = 13
                  Top = 7
                  Width = 111
                  Height = 21
                  Margins.Left = 2
                  Margins.Top = 2
                  Margins.Right = 2
                  Margins.Bottom = 2
                  Caption = #1042#1099#1075#1088#1091#1079#1080#1090#1100
                  TabOrder = 0
                  OnClick = BitBtn6Click
                end
              end
            end
            object tsClientBills: TTabSheet
              Margins.Left = 2
              Margins.Top = 2
              Margins.Right = 2
              Margins.Bottom = 2
              Caption = #1057#1095#1077#1090#1072' '#1082#1083#1080#1077#1085#1090#1072
              ImageIndex = 10
              OnShow = tsClientBillsShow
              object CRDBGridClientBills: TCRDBGrid
                Left = 0
                Top = 40
                Width = 1058
                Height = 444
                OptionsEx = [dgeEnableSort, dgeLocalFilter, dgeLocalSorting]
                OnGetCellParams = CRDBGrid4GetCellParams
                Align = alClient
                DataSource = dmShowUserSt.dsClientBills
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -12
                Font.Name = 'MS Sans Serif'
                Font.Style = []
                ParentFont = False
                ReadOnly = True
                TabOrder = 0
                TitleFont.Charset = DEFAULT_CHARSET
                TitleFont.Color = clWindowText
                TitleFont.Height = -14
                TitleFont.Name = 'MS Sans Serif'
                TitleFont.Style = [fsBold]
              end
              object Panel10: TPanel
                Left = 0
                Top = 0
                Width = 1058
                Height = 40
                Margins.Left = 2
                Margins.Top = 2
                Margins.Right = 2
                Margins.Bottom = 2
                Align = alTop
                TabOrder = 1
                object btBillClient: TBitBtn
                  Left = 13
                  Top = 7
                  Width = 111
                  Height = 21
                  Margins.Left = 2
                  Margins.Top = 2
                  Margins.Right = 2
                  Margins.Bottom = 2
                  Caption = #1042#1099#1075#1088#1091#1079#1080#1090#1100
                  TabOrder = 0
                  OnClick = btBillClientClick
                end
              end
            end
          end
        end
      end
    end
    object tsOptions: TTabSheet
      Caption = #1055#1086#1076#1082#1083#1102#1095#1077#1085#1085#1099#1077' '#1091#1089#1083#1091#1075#1080
      ImageIndex = 5
      OnShow = tsOptionsShow
      object SplitterOptions: TSplitter
        Left = 0
        Top = 254
        Width = 1074
        Height = 4
        Cursor = crVSplit
        Margins.Left = 2
        Margins.Top = 2
        Margins.Right = 2
        Margins.Bottom = 2
        Align = alTop
        ExplicitWidth = 960
      end
      object pCurrentOptions: TPanel
        Left = 0
        Top = 0
        Width = 1074
        Height = 254
        Margins.Left = 2
        Margins.Top = 2
        Margins.Right = 2
        Margins.Bottom = 2
        Align = alTop
        Caption = 'pCurrentOptions'
        TabOrder = 0
        object pOptions: TPanel
          Left = 1
          Top = 1
          Width = 1072
          Height = 53
          Margins.Left = 2
          Margins.Top = 2
          Margins.Right = 2
          Margins.Bottom = 2
          Align = alTop
          TabOrder = 0
          object lTGOptions: TLabel
            Left = 55
            Top = 31
            Width = 82
            Height = 13
            Margins.Left = 2
            Margins.Top = 2
            Margins.Right = 2
            Margins.Bottom = 2
            Alignment = taRightJustify
            Caption = #1043#1088#1091#1087#1087#1072' '#1091#1089#1083#1091#1075':'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = 'MS Sans Serif'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object cbPeriodsOpt: TComboBox
            Left = 7
            Top = 2
            Width = 130
            Height = 21
            Margins.Left = 2
            Margins.Top = 2
            Margins.Right = 2
            Margins.Bottom = 2
            DropDownCount = 25
            TabOrder = 0
            OnChange = cbPeriodsOptChange
          end
          object btRefreshOptionList: TBitBtn
            Left = 142
            Top = 0
            Width = 201
            Height = 25
            Caption = #1054#1073#1085#1086#1074#1080#1090#1100' '#1087#1086#1076#1082#1083#1102#1095#1077#1085#1085#1099#1077' '#1091#1089#1083#1091#1075#1080
            TabOrder = 1
            OnClick = BGet_api_servicesClick
          end
          object DBLookupComboBox1: TDBLookupComboBox
            Left = 141
            Top = 27
            Width = 201
            Height = 21
            Margins.Left = 2
            Margins.Top = 2
            Margins.Right = 2
            Margins.Bottom = 2
            DataField = 'OPTION_GROUP_NAME'
            DataSource = dmShowUserSt.dsContractInfo
            KeyField = 'OPTION_GROUP_ID'
            ListField = 'OPTION_GROUP_NAME'
            ListSource = dmShowUserSt.dsTGOption
            TabOrder = 2
          end
          object btChangeOptionGroup: TButton
            Left = 342
            Top = 27
            Width = 177
            Height = 21
            Caption = #1057#1084#1077#1085#1080#1090#1100' '#1075#1088#1091#1087#1087#1091' '#1091#1089#1083#1091#1075
            TabOrder = 3
            OnClick = btChangeOptionGroupClick
          end
          object btAPITurnOnServises: TBitBtn
            Left = 342
            Top = 0
            Width = 177
            Height = 25
            Caption = #1055#1086#1076#1082#1083#1102#1095#1080#1090#1100' '#1091#1089#1083#1091#1075#1091
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = 'MS Sans Serif'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 4
            OnClick = btAPITurnOnServisesClick
          end
        end
        object CRDBGrid2: TCRDBGrid
          Left = 1
          Top = 54
          Width = 1072
          Height = 199
          OptionsEx = [dgeEnableSort, dgeLocalFilter, dgeLocalSorting]
          OnGetCellParams = CRDBGrid2GetCellParams
          Align = alClient
          DataSource = dmShowUserSt.dsOptions
          TabOrder = 1
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -11
          TitleFont.Name = 'MS Sans Serif'
          TitleFont.Style = []
          OnCellClick = CRDBGrid2CellClick
          OnColEnter = CRDBGrid2ColEnter
          OnDblClick = CRDBGrid2DblClick
          Columns = <
            item
              Expanded = False
              FieldName = 'OPTION_CODE'
              Title.Caption = #1050#1086#1076
              Title.Font.Charset = DEFAULT_CHARSET
              Title.Font.Color = clWindowText
              Title.Font.Height = -11
              Title.Font.Name = 'MS Sans Serif'
              Title.Font.Style = [fsBold]
              Width = 93
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'OPTION_NAME'
              Title.Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
              Title.Font.Charset = DEFAULT_CHARSET
              Title.Font.Color = clWindowText
              Title.Font.Height = -11
              Title.Font.Name = 'MS Sans Serif'
              Title.Font.Style = [fsBold]
              Width = 208
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'OPTION_PARAMETERS'
              Title.Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1099
              Title.Font.Charset = DEFAULT_CHARSET
              Title.Font.Color = clWindowText
              Title.Font.Height = -11
              Title.Font.Name = 'MS Sans Serif'
              Title.Font.Style = [fsBold]
              Width = 143
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'TURN_ON_DATE'
              Title.Caption = #1042#1082#1083#1102#1095#1077#1085#1072
              Title.Font.Charset = DEFAULT_CHARSET
              Title.Font.Color = clWindowText
              Title.Font.Height = -11
              Title.Font.Name = 'MS Sans Serif'
              Title.Font.Style = [fsBold]
              Width = 80
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'TURN_OFF_DATE'
              Title.Caption = #1054#1090#1082#1083#1102#1095#1077#1085#1072
              Title.Font.Charset = DEFAULT_CHARSET
              Title.Font.Color = clWindowText
              Title.Font.Height = -11
              Title.Font.Name = 'MS Sans Serif'
              Title.Font.Style = [fsBold]
              Width = 80
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'LAST_CHECK_DATE_TIME'
              Title.Caption = #1055#1086#1089#1083'. '#1087#1088#1086#1074#1077#1088#1082#1072
              Title.Font.Charset = DEFAULT_CHARSET
              Title.Font.Color = clWindowText
              Title.Font.Height = -11
              Title.Font.Name = 'MS Sans Serif'
              Title.Font.Style = [fsBold]
              Width = 118
              Visible = True
            end>
        end
      end
      object pOptionHistory: TPanel
        Left = 0
        Top = 258
        Width = 1074
        Height = 282
        Margins.Left = 2
        Margins.Top = 2
        Margins.Right = 2
        Margins.Bottom = 2
        Align = alClient
        Caption = 'pOptionHistory'
        TabOrder = 1
        object CRDBGridOptionHistory: TCRDBGrid
          Left = 1
          Top = 1
          Width = 1072
          Height = 280
          Margins.Left = 2
          Margins.Top = 2
          Margins.Right = 2
          Margins.Bottom = 2
          OnGetCellParams = CRDBGridOptionHistoryGetCellParams
          Align = alClient
          DataSource = dmShowUserSt.dsAPIOptionHistory
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          ReadOnly = True
          TabOrder = 0
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -14
          TitleFont.Name = 'MS Sans Serif'
          TitleFont.Style = [fsBold]
        end
      end
    end
    object tsDetail: TTabSheet
      Caption = #1044#1077#1090#1072#1083#1080#1079#1072#1094#1080#1080
      OnShow = tsDetailShow
      object Splitter1: TSplitter
        Left = 0
        Top = 224
        Width = 1074
        Height = 3
        Cursor = crVSplit
        Align = alTop
        ExplicitWidth = 960
      end
      object Panel1: TPanel
        Left = 0
        Top = 0
        Width = 1074
        Height = 224
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 0
        object CRDBGrid1: TCRDBGrid
          Left = 0
          Top = 0
          Width = 313
          Height = 224
          OptionsEx = [dgeEnableSort, dgeLocalFilter, dgeLocalSorting]
          Align = alLeft
          DataSource = dmShowUserSt.dsPeriods
          ReadOnly = True
          TabOrder = 0
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -11
          TitleFont.Name = 'MS Sans Serif'
          TitleFont.Style = []
          Columns = <
            item
              Expanded = False
              FieldName = 'MONTH'
              Title.Caption = #1052#1077#1089#1103#1094
              Title.Font.Charset = DEFAULT_CHARSET
              Title.Font.Color = clWindowText
              Title.Font.Height = -11
              Title.Font.Name = 'MS Sans Serif'
              Title.Font.Style = [fsBold]
              Width = 60
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'YEAR'
              Title.Caption = #1043#1086#1076
              Title.Font.Charset = DEFAULT_CHARSET
              Title.Font.Color = clWindowText
              Title.Font.Height = -11
              Title.Font.Name = 'MS Sans Serif'
              Title.Font.Style = [fsBold]
              Width = 77
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'PHONE_NUMBER'
              Title.Caption = #1058#1077#1083#1077#1092#1086#1085
              Title.Font.Charset = DEFAULT_CHARSET
              Title.Font.Color = clWindowText
              Title.Font.Height = -11
              Title.Font.Name = 'MS Sans Serif'
              Title.Font.Style = [fsBold]
              Width = -1
              Visible = False
            end
            item
              Expanded = False
              FieldName = 'ESTIMATE_SUM'
              Title.Caption = #1057#1091#1084#1084#1072
              Title.Font.Charset = DEFAULT_CHARSET
              Title.Font.Color = clWindowText
              Title.Font.Height = -11
              Title.Font.Name = 'MS Sans Serif'
              Title.Font.Style = [fsBold]
              Width = 110
              Visible = True
            end>
        end
        object Panel4: TPanel
          Left = 313
          Top = 0
          Width = 761
          Height = 224
          Align = alClient
          BevelOuter = bvNone
          TabOrder = 1
          object Panel16: TPanel
            Left = 558
            Top = 0
            Width = 203
            Height = 224
            Align = alRight
            BevelOuter = bvNone
            TabOrder = 0
            object lbBegindate: TLabel
              Left = 9
              Top = 5
              Width = 64
              Height = 13
              Caption = #1044#1072#1090#1072' '#1085#1072#1095#1072#1083#1072
              Visible = False
            end
            object lbEndDate: TLabel
              Left = 7
              Top = 43
              Width = 82
              Height = 13
              Caption = #1044#1072#1090#1072' '#1086#1082#1086#1085#1095#1072#1085#1080#1103
              Visible = False
            end
            object dtBegin: TDateTimePicker
              Left = 7
              Top = 20
              Width = 138
              Height = 21
              Date = 41425.476410150460000000
              Time = 41425.476410150460000000
              TabOrder = 0
              Visible = False
            end
            object dtEnd: TDateTimePicker
              Left = 7
              Top = 58
              Width = 138
              Height = 21
              Date = 41425.476410150460000000
              Time = 41425.476410150460000000
              TabOrder = 1
              Visible = False
            end
            object btAddFilter: TsBitBtn
              Left = 7
              Top = 85
              Width = 138
              Height = 30
              Caption = #1055#1088#1080#1084#1077#1085#1080#1090#1100' '#1092#1080#1083#1100#1090#1088
              TabOrder = 2
              Visible = False
              OnClick = btAddFilterClick
              SkinData.SkinSection = 'BUTTON'
            end
            object cbFree: TCheckBox
              Left = 7
              Top = 121
              Width = 97
              Height = 17
              Caption = #1055#1083#1072#1090#1085#1086
              TabOrder = 3
              Visible = False
            end
            object edEmailAdress: TEdit
              Left = 8
              Top = 144
              Width = 137
              Height = 21
              TabOrder = 4
              Text = #1087#1086#1095#1090#1072'@'#1082#1083#1080#1077#1085#1090#1072'.ru'
              Visible = False
            end
          end
          object Panel17: TPanel
            Left = 0
            Top = 0
            Width = 558
            Height = 224
            Align = alClient
            BevelOuter = bvNone
            TabOrder = 1
            object gStatistic: TStringGrid
              Left = 0
              Top = 26
              Width = 558
              Height = 198
              Align = alClient
              ColCount = 2
              DefaultColWidth = 120
              FixedRows = 0
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -12
              Font.Name = 'MS Sans Serif'
              Font.Style = [fsBold]
              ParentFont = False
              TabOrder = 0
            end
            object Panel18: TPanel
              Left = 0
              Top = 0
              Width = 558
              Height = 26
              Align = alTop
              BevelOuter = bvNone
              TabOrder = 1
              object Label1: TLabel
                Left = 8
                Top = 5
                Width = 104
                Height = 18
                Alignment = taRightJustify
                Caption = #1053#1072#1095#1080#1089#1083#1077#1085#1086' :'
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -15
                Font.Name = 'Verdana'
                Font.Style = [fsBold, fsItalic, fsUnderline]
                ParentFont = False
                OnClick = Label1Click
                OnMouseEnter = LblBlueOn
                OnMouseLeave = LblBlueOff
              end
              object DBText1: TDBText
                Left = 118
                Top = 6
                Width = 77
                Height = 18
                Alignment = taRightJustify
                AutoSize = True
                DataField = 'ESTIMATE_SUM'
                DataSource = dmShowUserSt.dsPeriods
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -16
                Font.Name = 'Verdana'
                Font.Style = [fsBold]
                ParentFont = False
              end
              object DBText12: TDBText
                Left = 375
                Top = 6
                Width = 60
                Height = 14
                Alignment = taRightJustify
                AutoSize = True
                DataField = 'LAST_CHECK_DATE_TIME'
                DataSource = dmShowUserSt.dsPeriods
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -12
                Font.Name = 'Verdana'
                Font.Style = []
                ParentFont = False
              end
            end
          end
        end
      end
      object Panel3: TPanel
        Left = 0
        Top = 227
        Width = 1074
        Height = 67
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 1
        object Label12: TLabel
          Left = 8
          Top = 8
          Width = 71
          Height = 13
          Caption = #1044#1077#1090#1072#1083#1080#1079#1072#1094#1080#1103':'
        end
        object BitBtn1: TBitBtn
          Left = 737
          Top = 3
          Width = 145
          Height = 29
          Action = aSaveDetail
          Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1074' '#1092#1072#1081#1083
          Glyph.Data = {
            36040000424D3604000000000000360000002800000010000000100000000100
            2000000000000004000000000000000000000000000000000000FF00FF00CCCC
            CC00CCCCCC00CCCCCC00CCCCCC00CCCCCC00F7F7F700F7F7F700CCCCCC00CCCC
            CC00CCCCCC00CCCCCC00CCCCCC00CCCCCC00CCCCCC00FF00FF00C2A97500B782
            1800B6801400B37A0600D7CFD200D8CEC900CFCECD00C9BFAC00D9CFCE00D5CA
            C300D4CAC400D6CFD200B37A0600B6801400B7821800C2A97500B7821800F6CD
            8B00F2C67D00F0C17100FAF7FB00FFFFFF004C48480098939200FFFFFF00F7EF
            EA00F6EFEB00F9F6FA00F0C17100F2C67D00F6CD8B00B7821800B6811600F3CA
            8700EDBC6D00EBB76100F8F5F700FFFFFF004A454100948C8800FFFFFF00F1E8
            E000F0E7E000F7F4F700EBB76100EDBC6D00F3CA8700B6811600B6811600F1CB
            8900E9B76200E7B25700F9F8FB00FDF7F200877F79004A444100FEF7F200EEE3
            D800EDE2D900F8F7FB00E8B25700E9B76200F1CB8900B6811600B6811600F3CC
            8E00E8B25A00E7AE5100FCFFFF00ECE0D700F1E4DA00F1E5DA00EDE0D500EADD
            D300E9DED500FBFFFF00E7AE5100E8B25A00F3CC8E00B6811600B6811500F3CE
            9400E6AE5100E5AB4B00E6C9A400FFFFFF00FFFFFF00FFFFFF00FEFFFF00FDFF
            FF00FEFFFF00E6C9A400E5AC4B00E6AE5100F3CE9400B6811500B6811500F3D0
            9A00E5A84500E3A64000E2A13600E29E2F00E19D2D00E19D2C00E19D2C00E19D
            2D00E29E2F00E2A13600E3A64000E5A84500F3D09A00B6811500B6811400F4D4
            A000E1A13600F2DEB700FCFFFF00FBFFFD00FBFFFC00FBFFFD00FBFFFD00FBFF
            FD00FBFFFD00FBFFFF00F2DEB700E1A13600F4D4A000B6811400B6801400F6D8
            A700E09C2700FBFFFF00FCFBF300FCF9EF00FBF8EE00FCFAF000FCFAF000FBF9
            EE00F9F8ED00FAF9F100FAFEFE00E09B2700F6D8A700B6801400B6801400F8DC
            B000E0981C00FBFBF80079787B00A2A0A200FCF6EA0079787900A3A1A300A09F
            A100FAF4E9009D9DA000F9F9F600E0981C00F8DCB000B6801400B6811300FCE3
            BC009B610400FDFCF900FDF5E800FEF4E700FBF2E500FCF2E500FBF2E500FBF2
            E500FAF1E300F9F1E500FCFAF7009A610400FCE3BC00B6811300B6801200FEE9
            C60071410000FFFFFF0079797A007A7A7A00A2A1A1009F9F9F00F6ECDE007777
            7700A1A1A1009E9FA000FFFFFF0070410000FEE9C600B6801200B6801200FDEC
            D100DA860000FFFFFF00F1E5D800F2E5D800F2E5D700F0E3D600EFE2D500F1E4
            D700F1E4D600EFE3D600FFFFFF00DA860000FDECD100B6801200B7811500FFEC
            CD00FCE7C300FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00FFFFFF00FFFFFF00FFFFFF00FCE7C300FFECCD00B7811500DCC28F00B781
            1400B57E0F00B57C0B00B57C0900B57C0900B57C0900B57C0900B57C0900B57C
            0900B57C0900B57C0900B57C0B00B57E0F00B7811400DCC28F00}
          TabOrder = 0
        end
        object BitBtn2: TBitBtn
          Left = 85
          Top = 3
          Width = 146
          Height = 29
          Action = aOpenDetailInExcel
          Align = alCustom
          Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1074' '#1092#1072#1081#1083
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
            FF00FF00FF00FF00FF00535E54008694880046574900728574003C523F006E84
            710039533C0076907900506D54007D9A81003E5D420073927500325533006889
            67004C6A4D0089A08A00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00839185002F40320074877600435946006C866F004764
            4B00739077002E4D320069886D003A5C3E00698B6D00315634007EAA81002852
            2900698C6A00304E3100FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00445547007D907F00E2F8E500EFFFF200EDFFF100E7FF
            EB00EAFFEE00EAFFEE00E8FFED00E8FFED00E8FFED00E4FFEA00D7FFDA00E1FF
            E300315B32006F906E00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00738A74003B583E00ECFFED00D4F9D700E6FFEA00DDFF
            E200E4FFE900DEFFE400DFFFE500598A5E003A6B3F0062936500326735005B90
            5E0077A479002D532F00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF0040613E00608B5E00E1FFE000245E240065A268002666
            2B005C9E63001B5D220055975C0026692C00D8FFDB001F5D210058935900386D
            3B00214F2400658B6700FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00678B610040713900DFFFD80061A25D00145A1400569E
            5800337C38005EA965002E773300D3FFD60019621A0067AD67003B773B00D1FF
            D40078A67B00486E4A00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF003D5E310068955C00DAFFCD00306C260072B16B002D70
            2B00468C46001F651F00D8FFD600185C15005799510023641F005C965B00D8FF
            D9001E4B20006D927000FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00829F7800496F3F00DFFFD500E1FFD900255D2200528C
            51003A753B00DAFFDC002662260069A5680035713100669F6200265D2600E1FF
            E30069936A0035583600FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF003043300065816300EAFFEA00E2FFE500E3FFE9004574
            4D00D0FFDB002F603A005F8E68002C5B340065936800DFFFE000DFFFE000DCFF
            DD00365D370079997A00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF0070836E0055715300EAFFEA00E4FFE70025502B00E3FF
            EA002C5A36006E9C7800335F3A00618D660039653C00719E7300E3FFE500E4FF
            E5005D815D004C6A4D00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF0049643C0072976500E5FFD80033622A00E4FFDF003365
            2F0071A26E001F501C0063945E0044753D006D9D630037662E0076A27300DCFF
            DD0053745200627D6300FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF007A9B6F00395F2D00E2FFD90070A16900366832005E8F
            5B00366735006B9C6A00E4FFE0006596600038652C0065915C002C522800ECFF
            EA0058775800455F4700FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF0038573C00698E6C00E1FFE700305F390053805F004A76
            57005A866900D8FFE500E4FFEE00DDFFE400678E68002F542E0070916E00E9FF
            E9003F5A40007F968000FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF0083A48900284F2F00E3FFEB00E1FFEB00E1FFEE00D9FF
            E800DDFFED00E1FFEF00E4FFF000E5FFEC00EAFFEB00ECFFEA00EFFFED00E7FF
            E400768E7600364B3500FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF0034582C0077A17100265524006798660039683A00618F
            64003A663D006E986F00244C2200668D5F00426637005F8053003C5736008197
            7F004F644E007C8F7C00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF006A8962003F63370085AE8100244D2000557F5600436C
            460074987400375835007B9C77004A683F00708C610047623A0083997D004154
            3F007184710039493800FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
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
          TabOrder = 1
        end
        object IS_BS_CHECK: TCheckBox
          Left = 234
          Top = 10
          Width = 200
          Height = 17
          Align = alCustom
          Alignment = taLeftJustify
          Caption = #1055#1088#1086#1074#1077#1088#1082#1072' '#1087#1086' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1091' '#1041#1057
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 2
          OnClick = IS_BS_CHECKClick
        end
        object BitBtn3: TBitBtn
          Left = 440
          Top = 3
          Width = 219
          Height = 29
          Align = alCustom
          Caption = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1077#1090#1072#1083#1080#1079#1072#1094#1080#1102' '#1079#1072' '#1090#1077#1082'. '#1087#1077#1088#1080#1086#1076
          TabOrder = 3
          OnClick = BitBtn3Click
        end
        object BitBtn5: TBitBtn
          Left = 665
          Top = 3
          Width = 75
          Height = 29
          Caption = 'SMS/USSD'
          TabOrder = 4
          OnClick = BitBtn5Click
        end
        object btSendMail: TBitBtn
          Left = 746
          Top = 3
          Width = 145
          Height = 29
          Action = aSaveDetail
          Caption = #1054#1090#1087#1088#1072#1074#1080#1090#1100' '#1087#1086' '#1087#1086#1095#1090#1077
          TabOrder = 5
        end
        object IS_BILL_CHECK: TCheckBox
          Left = 85
          Top = 44
          Width = 146
          Height = 17
          Align = alCustom
          Alignment = taLeftJustify
          Caption = #1054#1090#1086#1073#1088#1072#1078#1072#1090#1100' '#1080#1079' '#1089#1095#1105#1090#1072
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 6
          OnClick = IS_BILL_CHECKClick
        end
        object btUnload: TBitBtn
          Left = 266
          Top = 32
          Width = 145
          Height = 29
          Hint = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1076#1077#1090#1072#1083#1080#1079#1072#1094#1080#1102' '#1074' '#1092#1072#1081#1083
          Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100
          Glyph.Data = {
            36040000424D3604000000000000360000002800000010000000100000000100
            2000000000000004000000000000000000000000000000000000FF00FF00CECE
            CE00CECECE00CECECE00CECECE00CECECE00F7F7F700F7F7F700CECECE00CECE
            CE00CECECE00CECECE00CECECE00CECECE00CECECE00FF00FF00C6AD7300B584
            1800B5841000B57B0000D6CED600DECECE00CECECE00CEBDAD00DECECE00D6CE
            C600D6CEC600D6CED600B57B0000B5841000B5841800C6AD7300B5841800F7CE
            8C00F7C67B00F7C67300FFF7FF00FFFFFF004A4A4A009C949400FFFFFF00F7EF
            EF00F7EFEF00FFF7FF00F7C67300F7C67B00F7CE8C00B5841800B5841000F7CE
            8400EFBD6B00EFB56300FFF7F700FFFFFF004A424200948C8C00FFFFFF00F7EF
            E700F7E7E700F7F7F700EFB56300EFBD6B00F7CE8400B5841000B5841000F7CE
            8C00EFB56300E7B55200FFFFFF00FFF7F700847B7B004A424200FFF7F700EFE7
            DE00EFE7DE00FFF7FF00EFB55200EFB56300F7CE8C00B5841000B5841000F7CE
            8C00EFB55A00E7AD5200FFFFFF00EFE7D600F7E7DE00F7E7DE00EFE7D600EFDE
            D600EFDED600FFFFFF00E7AD5200EFB55A00F7CE8C00B5841000B5841000F7CE
            9400E7AD5200E7AD4A00E7CEA500FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00FFFFFF00E7CEA500E7AD4A00E7AD5200F7CE9400B5841000B5841000F7D6
            9C00E7AD4200E7A54200E7A53100E79C2900E79C2900E79C2900E79C2900E79C
            2900E79C2900E7A53100E7A54200E7AD4200F7D69C00B5841000B5841000F7D6
            A500E7A53100F7DEB500FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00FFFFFF00FFFFFF00F7DEB500E7A53100F7D6A500B5841000B5841000F7DE
            A500E79C2100FFFFFF00FFFFF700FFFFEF00FFFFEF00FFFFF700FFFFF700FFFF
            EF00FFFFEF00FFFFF700FFFFFF00E79C2100F7DEA500B5841000B5841000FFDE
            B500E79C1800FFFFFF007B7B7B00A5A5A500FFF7EF007B7B7B00A5A5A500A59C
            A500FFF7EF009C9CA500FFFFF700E79C1800FFDEB500B5841000B5841000FFE7
            BD009C630000FFFFFF00FFF7EF00FFF7E700FFF7E700FFF7E700FFF7E700FFF7
            E700FFF7E700FFF7E700FFFFF7009C630000FFE7BD00B5841000B5841000FFEF
            C60073420000FFFFFF007B7B7B007B7B7B00A5A5A5009C9C9C00F7EFDE007373
            7300A5A5A5009C9CA500FFFFFF0073420000FFEFC600B5841000B5841000FFEF
            D600DE840000FFFFFF00F7E7DE00F7E7DE00F7E7D600F7E7D600EFE7D600F7E7
            D600F7E7D600EFE7D600FFFFFF00DE840000FFEFD600B5841000B5841000FFEF
            CE00FFE7C600FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00FFFFFF00FFFFFF00FFFFFF00FFE7C600FFEFCE00B5841000DEC68C00B584
            1000B57B0800B57B0800B57B0800B57B0800B57B0800B57B0800B57B0800B57B
            0800B57B0800B57B0800B57B0800B57B0800B5841000DEC68C00}
          TabOrder = 7
          OnClick = btUnloadClick
        end
        object cb_Hide_detail: TCheckBox
          Tag = 1
          Left = 615
          Top = 44
          Width = 125
          Height = 17
          Caption = #1057#1082#1088#1099#1090#1100' '#1076#1077#1090#1072#1083#1080#1079#1072#1094#1080#1080
          Enabled = False
          TabOrder = 8
          Visible = False
          OnClick = cb_Hide_detailClick
        end
        object BUnbilledCallsList: TButton
          Left = 746
          Top = 36
          Width = 145
          Height = 25
          Caption = #1047#1072#1087#1088#1086#1089#1080#1090#1100' '#1076#1077#1090#1072#1083'. '#1080#1079' '#1040#1055#1048' '
          TabOrder = 9
          OnClick = BUnbilledCallsListClick
        end
        object cbHideZeroCall: TCheckBox
          Tag = 1
          Left = 422
          Top = 44
          Width = 170
          Height = 17
          Caption = #1054#1090#1086#1073#1088#1072#1078#1072#1090#1100' '#1090#1086#1083#1100#1082#1086' '#1087#1083#1072#1090#1085#1099#1077
          TabOrder = 10
          OnClick = cbHideZeroCallClick
        end
      end
      object Panel2: TPanel
        Left = 0
        Top = 294
        Width = 1074
        Height = 246
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 2
        object dbgDetail: TCRDBGrid
          Left = 0
          Top = 0
          Width = 1074
          Height = 246
          OptionsEx = [dgeEnableSort, dgeLocalFilter, dgeLocalSorting]
          Align = alClient
          DataSource = dmShowUserSt.dsDetail
          ReadOnly = True
          TabOrder = 1
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -11
          TitleFont.Name = 'MS Sans Serif'
          TitleFont.Style = []
          Columns = <
            item
              Expanded = False
              FieldName = 'SELF_NUMBER'
              Title.Caption = #1057#1074#1086#1081' '#1085#1086#1084#1077#1088
              Title.Font.Charset = DEFAULT_CHARSET
              Title.Font.Color = clWindowText
              Title.Font.Height = -11
              Title.Font.Name = 'MS Sans Serif'
              Title.Font.Style = [fsBold]
              Width = 70
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'SERVICE_DATE'
              Title.Caption = #1044#1072#1090#1072
              Title.Font.Charset = DEFAULT_CHARSET
              Title.Font.Color = clWindowText
              Title.Font.Height = -11
              Title.Font.Name = 'MS Sans Serif'
              Title.Font.Style = [fsBold]
              Width = 66
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'SERVICE_TIME'
              Title.Caption = #1042#1088#1077#1084#1103
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
              FieldName = 'SERVICE_TYPE'
              Title.Caption = #1058#1080#1087' '#1091#1089#1083#1091#1075#1080
              Title.Font.Charset = DEFAULT_CHARSET
              Title.Font.Color = clWindowText
              Title.Font.Height = -11
              Title.Font.Name = 'MS Sans Serif'
              Title.Font.Style = [fsBold]
              Width = 107
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'SERVICE_DIRECTION'
              Title.Caption = #1053#1072#1087#1088#1072#1074#1083#1077#1085#1080#1077
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
              FieldName = 'OTHER_NUMBER'
              Title.Caption = #1057#1086#1073#1077#1089#1077#1076#1085#1080#1082
              Title.Font.Charset = DEFAULT_CHARSET
              Title.Font.Color = clWindowText
              Title.Font.Height = -11
              Title.Font.Name = 'MS Sans Serif'
              Title.Font.Style = [fsBold]
              Width = 93
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'DURATION'
              Title.Caption = #1044#1083#1080#1090#1077#1083#1100#1085#1086#1089#1090#1100
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
              FieldName = 'DURATION_MIN'
              Title.Caption = #1044#1083#1080#1090#1077#1083#1100#1085#1086#1089#1090#1100'('#1084#1080#1085')'
              Title.Font.Charset = DEFAULT_CHARSET
              Title.Font.Color = clWindowText
              Title.Font.Height = -11
              Title.Font.Name = 'MS Sans Serif'
              Title.Font.Style = [fsBold]
              Width = 120
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'SERVICE_COST'
              Title.Caption = #1057#1090#1086#1080#1084#1086#1089#1090#1100
              Title.Font.Charset = DEFAULT_CHARSET
              Title.Font.Color = clWindowText
              Title.Font.Height = -11
              Title.Font.Name = 'MS Sans Serif'
              Title.Font.Style = [fsBold]
              Width = 68
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'IS_ROAMING'
              Title.Caption = #1056#1086#1091#1084#1080#1085#1075
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
              FieldName = 'ROAMING_ZONE'
              Title.Caption = #1047#1086#1085#1072' '#1088#1086#1091#1084#1080#1085#1075#1072
              Title.Font.Charset = DEFAULT_CHARSET
              Title.Font.Color = clWindowText
              Title.Font.Height = -11
              Title.Font.Name = 'MS Sans Serif'
              Title.Font.Style = [fsBold]
              Width = 144
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'ADD_INFO'
              Title.Caption = #1044#1086#1087'.'#1080#1085#1092#1086#1088#1084#1072#1094#1080#1103
              Title.Font.Charset = DEFAULT_CHARSET
              Title.Font.Color = clWindowText
              Title.Font.Height = -11
              Title.Font.Name = 'MS Sans Serif'
              Title.Font.Style = [fsBold]
              Width = 193
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'BASE_STATION_CODE'
              Title.Caption = #1041#1072#1079#1086#1074#1072#1103' '#1089#1090#1072#1085#1094#1080#1103
              Title.Font.Charset = DEFAULT_CHARSET
              Title.Font.Color = clWindowText
              Title.Font.Height = -11
              Title.Font.Name = 'MS Sans Serif'
              Title.Font.Style = [fsBold]
              Width = 106
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'COST_NO_VAT'
              Title.Caption = #1057#1091#1084#1084#1072' '#1073#1077#1079' '#1053#1044#1057
              Title.Font.Charset = DEFAULT_CHARSET
              Title.Font.Color = clWindowText
              Title.Font.Height = -11
              Title.Font.Name = 'MS Sans Serif'
              Title.Font.Style = [fsBold]
              Width = 99
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'BS_PLACE'
              Title.Caption = #1047#1086#1085#1072' '#1041#1057
              Title.Font.Charset = DEFAULT_CHARSET
              Title.Font.Color = clWindowText
              Title.Font.Height = -11
              Title.Font.Name = 'MS Sans Serif'
              Title.Font.Style = [fsBold]
              Width = 304
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'INSERT_DATE'
              Title.Caption = #1044#1072#1090#1072' '#1079#1072#1075#1088#1091#1079#1082#1080
              Title.Font.Charset = DEFAULT_CHARSET
              Title.Font.Color = clWindowText
              Title.Font.Height = -11
              Title.Font.Name = 'MS Sans Serif'
              Title.Font.Style = [fsBold]
              Width = 60
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'SOURCE_FILE_NAME'
              Title.Caption = #1048#1089#1090#1086#1095#1085#1080#1082
              Title.Font.Charset = DEFAULT_CHARSET
              Title.Font.Color = clWindowText
              Title.Font.Height = -11
              Title.Font.Name = 'MS Sans Serif'
              Title.Font.Style = [fsBold]
              Width = 60
              Visible = True
            end>
        end
        object mDetailText: TMemo
          Left = 672
          Top = 40
          Width = 104
          Height = 203
          ScrollBars = ssBoth
          TabOrder = 0
          Visible = False
          WordWrap = False
        end
      end
    end
    object tsRest: TTabSheet
      Caption = #1054#1089#1090#1072#1090#1082#1080' '#1087#1086' '#1087#1072#1082#1077#1090#1072#1084
      ImageIndex = 12
      object gRest: TCRDBGrid
        Left = 0
        Top = 41
        Width = 1074
        Height = 499
        Align = alClient
        DataSource = dmShowUserSt.dsRests
        ReadOnly = True
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'MS Sans Serif'
        TitleFont.Style = []
        Columns = <
          item
            Expanded = False
            FieldName = 'REST_NAME'
            Title.Alignment = taCenter
            Title.Caption = #1055#1072#1082#1077#1090
            Title.Font.Charset = DEFAULT_CHARSET
            Title.Font.Color = clWindowText
            Title.Font.Height = -11
            Title.Font.Name = 'MS Sans Serif'
            Title.Font.Style = [fsBold]
            Width = 150
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'SOC_NAME'
            Title.Alignment = taCenter
            Title.Caption = #1059#1089#1083#1091#1075#1072
            Title.Font.Charset = DEFAULT_CHARSET
            Title.Font.Color = clWindowText
            Title.Font.Height = -11
            Title.Font.Name = 'MS Sans Serif'
            Title.Font.Style = [fsBold]
            Width = 150
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'SOC'
            Title.Alignment = taCenter
            Title.Caption = #1050#1086#1076' '#1091#1089#1083#1091#1075#1080' ('#1074' '#1041#1080#1083#1072#1081#1085#1077')'
            Title.Font.Charset = DEFAULT_CHARSET
            Title.Font.Color = clWindowText
            Title.Font.Height = -11
            Title.Font.Name = 'MS Sans Serif'
            Title.Font.Style = [fsBold]
            Width = 150
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'SPENT'
            Title.Alignment = taCenter
            Title.Caption = #1055#1086#1090#1088#1072#1095#1077#1085#1086
            Title.Font.Charset = DEFAULT_CHARSET
            Title.Font.Color = clWindowText
            Title.Font.Height = -11
            Title.Font.Name = 'MS Sans Serif'
            Title.Font.Style = [fsBold]
            Width = 67
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'CURR_VALUE'
            Title.Alignment = taCenter
            Title.Caption = #1054#1089#1090#1072#1090#1086#1082
            Title.Font.Charset = DEFAULT_CHARSET
            Title.Font.Color = clWindowText
            Title.Font.Height = -11
            Title.Font.Name = 'MS Sans Serif'
            Title.Font.Style = [fsBold]
            Width = 64
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'INITIAL_SIZE'
            Title.Alignment = taCenter
            Title.Caption = #1042#1089#1077#1075#1086
            Title.Font.Charset = DEFAULT_CHARSET
            Title.Font.Color = clWindowText
            Title.Font.Height = -11
            Title.Font.Name = 'MS Sans Serif'
            Title.Font.Style = [fsBold]
            Width = 64
            Visible = True
          end>
      end
      object pRest: TPanel
        Left = 0
        Top = 0
        Width = 1074
        Height = 41
        Align = alTop
        BevelOuter = bvNone
        ParentBackground = False
        TabOrder = 1
        object btnaOpenDetailInExcel: TBitBtn
          Left = 553
          Top = 0
          Width = 521
          Height = 41
          Action = aOpenDetailInExcel
          Align = alClient
          Caption = #1054#1090#1082#1088#1099#1090#1100' '#1074' Excel'
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
            FF00FF00FF00FF00FF00535E54008694880046574900728574003C523F006E84
            710039533C0076907900506D54007D9A81003E5D420073927500325533006889
            67004C6A4D0089A08A00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00839185002F40320074877600435946006C866F004764
            4B00739077002E4D320069886D003A5C3E00698B6D00315634007EAA81002852
            2900698C6A00304E3100FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00445547007D907F00E2F8E500EFFFF200EDFFF100E7FF
            EB00EAFFEE00EAFFEE00E8FFED00E8FFED00E8FFED00E4FFEA00D7FFDA00E1FF
            E300315B32006F906E00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00738A74003B583E00ECFFED00D4F9D700E6FFEA00DDFF
            E200E4FFE900DEFFE400DFFFE500598A5E003A6B3F0062936500326735005B90
            5E0077A479002D532F00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF0040613E00608B5E00E1FFE000245E240065A268002666
            2B005C9E63001B5D220055975C0026692C00D8FFDB001F5D210058935900386D
            3B00214F2400658B6700FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00678B610040713900DFFFD80061A25D00145A1400569E
            5800337C38005EA965002E773300D3FFD60019621A0067AD67003B773B00D1FF
            D40078A67B00486E4A00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF003D5E310068955C00DAFFCD00306C260072B16B002D70
            2B00468C46001F651F00D8FFD600185C15005799510023641F005C965B00D8FF
            D9001E4B20006D927000FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00829F7800496F3F00DFFFD500E1FFD900255D2200528C
            51003A753B00DAFFDC002662260069A5680035713100669F6200265D2600E1FF
            E30069936A0035583600FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF003043300065816300EAFFEA00E2FFE500E3FFE9004574
            4D00D0FFDB002F603A005F8E68002C5B340065936800DFFFE000DFFFE000DCFF
            DD00365D370079997A00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF0070836E0055715300EAFFEA00E4FFE70025502B00E3FF
            EA002C5A36006E9C7800335F3A00618D660039653C00719E7300E3FFE500E4FF
            E5005D815D004C6A4D00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF0049643C0072976500E5FFD80033622A00E4FFDF003365
            2F0071A26E001F501C0063945E0044753D006D9D630037662E0076A27300DCFF
            DD0053745200627D6300FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF007A9B6F00395F2D00E2FFD90070A16900366832005E8F
            5B00366735006B9C6A00E4FFE0006596600038652C0065915C002C522800ECFF
            EA0058775800455F4700FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF0038573C00698E6C00E1FFE700305F390053805F004A76
            57005A866900D8FFE500E4FFEE00DDFFE400678E68002F542E0070916E00E9FF
            E9003F5A40007F968000FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF0083A48900284F2F00E3FFEB00E1FFEB00E1FFEE00D9FF
            E800DDFFED00E1FFEF00E4FFF000E5FFEC00EAFFEB00ECFFEA00EFFFED00E7FF
            E400768E7600364B3500FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF0034582C0077A17100265524006798660039683A00618F
            64003A663D006E986F00244C2200668D5F00426637005F8053003C5736008197
            7F004F644E007C8F7C00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF006A8962003F63370085AE8100244D2000557F5600436C
            460074987400375835007B9C77004A683F00708C610047623A0083997D004154
            3F007184710039493800FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
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
          TabOrder = 0
        end
        object btRefresh: TBitBtn
          Left = 0
          Top = 0
          Width = 553
          Height = 41
          Align = alLeft
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
          TabOrder = 1
          OnClick = btRefreshClick
        end
      end
    end
    object tsDiscount: TTabSheet
      Caption = #1057#1082#1080#1076#1082#1072' '#1086#1087#1077#1088#1072#1090#1086#1088#1072
      ImageIndex = 8
      OnShow = tsDiscountShow
      object dbtEndDate: TDBText
        Left = 88
        Top = 92
        Width = 83
        Height = 16
        AutoSize = True
        DataField = 'DISCOUNT_END_DATE'
        DataSource = dmShowUserSt.dsDiscount
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object dbtBeginDate: TDBText
        Left = 88
        Top = 70
        Width = 96
        Height = 16
        AutoSize = True
        DataField = 'DISCOUNT_BEGIN_DATE'
        DataSource = dmShowUserSt.dsDiscount
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object lBegin: TLabel
        Left = 66
        Top = 70
        Width = 15
        Height = 16
        Caption = #1057':'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object lEnd: TLabel
        Left = 57
        Top = 92
        Width = 25
        Height = 16
        Caption = #1055#1086':'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object lDate: TLabel
        Left = 268
        Top = 70
        Width = 126
        Height = 16
        Caption = #1044#1072#1090#1072' '#1074#1082#1083#1102#1095#1077#1085#1080#1103':'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object lLength: TLabel
        Left = 280
        Top = 92
        Width = 114
        Height = 16
        Caption = #1057#1088#1086#1082' '#1076#1077#1081#1089#1090#1074#1080#1103':'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object dtpNewBeginDate: TDateTimePicker
        Left = 400
        Top = 65
        Width = 97
        Height = 21
        Date = 40834.475470636570000000
        Time = 40834.475470636570000000
        TabOrder = 0
      end
      object btSetDiscount: TBitBtn
        Left = 345
        Top = 35
        Width = 75
        Height = 25
        Caption = #1048#1079#1084#1077#1085#1080#1090#1100
        TabOrder = 1
        OnClick = btSetDiscountClick
      end
      object cbDiscount: TCheckBox
        Left = 40
        Top = 39
        Width = 161
        Height = 17
        Caption = #1057#1082#1080#1076#1082#1072' '#1086#1087#1077#1088#1072#1090#1086#1088#1072
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 2
        OnClick = cbDiscountClick
      end
      object eLength: TDBEdit
        Left = 400
        Top = 92
        Width = 97
        Height = 21
        DataField = 'DISCOUNT_VALIDITY'
        DataSource = dmShowUserSt.dsDiscount
        TabOrder = 3
      end
    end
    object tsContractInfo: TTabSheet
      Caption = #1044#1086#1075#1086#1074#1086#1088
      ImageIndex = 9
      OnShow = tsContractInfoShow
      object Label18: TLabel
        Left = 112
        Top = 32
        Width = 91
        Height = 23
        Alignment = taRightJustify
        Caption = #1044#1086#1075#1086#1074#1086#1088':'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -19
        Font.Name = 'Verdana'
        Font.Style = []
        ParentFont = False
      end
      object Label20: TLabel
        Left = 24
        Top = 61
        Width = 179
        Height = 23
        Alignment = taRightJustify
        Caption = #1044#1072#1090#1072' '#1079#1072#1082#1083#1102#1095#1077#1085#1080#1103':'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -19
        Font.Name = 'Verdana'
        Font.Style = []
        ParentFont = False
      end
      object Label21: TLabel
        Left = 80
        Top = 123
        Width = 123
        Height = 23
        Alignment = taRightJustify
        Caption = #1058#1080#1087' '#1086#1087#1083#1072#1090#1099':'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -19
        Font.Name = 'Verdana'
        Font.Style = []
        ParentFont = False
      end
      object DBText20: TDBText
        Left = 224
        Top = 61
        Width = 346
        Height = 23
        DataField = 'CONTRACT_DATE'
        DataSource = dmShowUserSt.dsContractInfo
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -19
        Font.Name = 'Verdana'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label22: TLabel
        Left = 74
        Top = 209
        Width = 129
        Height = 23
        Alignment = taRightJustify
        Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077':'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -19
        Font.Name = 'Verdana'
        Font.Style = []
        ParentFont = False
      end
      object DBText21: TDBText
        Left = 224
        Top = 123
        Width = 446
        Height = 25
        DataField = 'CONTRACT_TYPE'
        DataSource = dmShowUserSt.dsContractInfo
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -19
        Font.Name = 'Verdana'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label23: TLabel
        Left = 98
        Top = 3
        Width = 105
        Height = 23
        Alignment = taRightJustify
        Caption = #1050#1086#1084#1087#1072#1085#1080#1103':'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -19
        Font.Name = 'Verdana'
        Font.Style = []
        ParentFont = False
      end
      object DBText22: TDBText
        Left = 224
        Top = 3
        Width = 446
        Height = 22
        DataField = 'COMPANY_NAME'
        DataSource = dmShowUserSt.dsContractInfo
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -19
        Font.Name = 'Verdana'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label17: TLabel
        Left = 133
        Top = 151
        Width = 70
        Height = 23
        Caption = #1044#1080#1083#1077#1088':'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -19
        Font.Name = 'Verdana'
        Font.Style = []
        ParentFont = False
      end
      object Label31: TLabel
        Left = 94
        Top = 180
        Width = 109
        Height = 23
        Alignment = taRightJustify
        Caption = #1056#1072#1089#1089#1088#1086#1095#1082#1072':'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -19
        Font.Name = 'Verdana'
        Font.Style = []
        ParentFont = False
      end
      object DBText19: TDBText
        Left = 224
        Top = 183
        Width = 446
        Height = 20
        DataField = 'RASSROCHKA'
        DataSource = dmShowUserSt.dsContractInfo
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Verdana'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object DBText15: TDBText
        Left = 224
        Top = 90
        Width = 190
        Height = 25
        DataField = 'CONTRACT_CANCEL_DATE'
        DataSource = dmShowUserSt.dsContractInfo
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -19
        Font.Name = 'Verdana'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label15: TLabel
        Left = 24
        Top = 92
        Width = 179
        Height = 23
        Alignment = taRightJustify
        Caption = #1044#1072#1090#1072' '#1079#1072#1074#1077#1088#1096#1077#1085#1080#1103':'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -19
        Font.Name = 'Verdana'
        Font.Style = []
        ParentFont = False
      end
      object btRefreshCI: TBitBtn
        Left = 74
        Top = 245
        Width = 129
        Height = 24
        Caption = #1054#1073#1085#1086#1074#1080#1090#1100
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Verdana'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
        OnClick = btRefreshCIClick
      end
      object DBMemo1: TDBMemo
        Left = 224
        Top = 209
        Width = 446
        Height = 221
        DataField = 'COMMENTS'
        DataSource = dmShowUserSt.dsContractInfo
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Verdana'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        OnChange = DBMemo1Change
      end
      object btPostComments: TBitBtn
        Left = 74
        Top = 276
        Width = 129
        Height = 24
        Caption = #1055#1088#1080#1084#1077#1085#1080#1090#1100
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Verdana'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 2
        OnClick = btPostCommentsClick
      end
      object DBMemo2: TDBMemo
        Left = 224
        Top = 32
        Width = 446
        Height = 25
        TabStop = False
        BorderStyle = bsNone
        Color = clBtnFace
        Ctl3D = False
        DataField = 'ACCOUNT_NUMBER'
        DataSource = dmShowUserSt.dsContractInfo
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -19
        Font.Name = 'Verdana'
        Font.Style = [fsBold]
        ParentCtl3D = False
        ParentFont = False
        ReadOnly = True
        TabOrder = 3
        OnClick = DBMemo2Click
      end
      object cbDealers: TDBLookupComboBox
        Left = 224
        Top = 150
        Width = 257
        Height = 24
        DataField = 'DEALER_KOD'
        DataSource = dmShowUserSt.dsContractInfo
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        KeyField = 'DEALER_KOD'
        ListField = 'DEALER_NAME'
        ListSource = dmShowUserSt.dsContractDealers
        ParentFont = False
        TabOrder = 4
        OnCloseUp = DBMemo1Change
      end
    end
    object tsDopInfo: TTabSheet
      Caption = #1044#1086#1087'.'#1080#1085#1092#1086
      ImageIndex = 10
      OnShow = tsDopInfoShow
      DesignSize = (
        1074
        540)
      object blCaptionHLR: TLabel
        Left = 69
        Top = 6
        Width = 47
        Height = 23
        Alignment = taRightJustify
        Caption = 'HLR:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -19
        Font.Name = 'Verdana'
        Font.Style = []
        ParentFont = False
      end
      object lbHLR: TDBText
        Left = 122
        Top = 6
        Width = 446
        Height = 22
        DataField = 'HLR'
        DataSource = dmShowUserSt.dsDopPhoneInfo
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -19
        Font.Name = 'Verdana'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object lbCaptionSIM: TLabel
        Left = 60
        Top = 42
        Width = 56
        Height = 23
        Alignment = taRightJustify
        Caption = 'SIM:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -19
        Font.Name = 'Verdana'
        Font.Style = []
        ParentFont = False
      end
      object lbSim: TDBText
        Left = 192
        Top = 74
        Width = 446
        Height = 24
        DataField = 'SIM'
        DataSource = dmShowUserSt.dsDopPhoneInfo
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -19
        Font.Name = 'Verdana'
        Font.Style = [fsBold]
        ParentFont = False
        Visible = False
      end
      object LChangeSIM: TLabel
        Left = 3
        Top = 74
        Width = 113
        Height = 23
        Alignment = taRightJustify
        Caption = #1057#1084#1077#1085#1072' SIM:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -19
        Font.Name = 'Verdana'
        Font.Style = []
        ParentFont = False
      end
      object lZayavkiAPI: TLabel
        Left = 4
        Top = 159
        Width = 226
        Height = 18
        Caption = #1057#1087#1080#1089#1086#1082' '#1079#1072#1103#1074#1086#1082' '#1074' API '#1087#1086' '#1085#1086#1084#1077#1088#1091
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object lblParamSMSDisab: TLabel
        Left = 665
        Top = 12
        Width = 234
        Height = 13
        Caption = #1042#1088#1077#1084#1103' '#1074' '#1082#1086#1090#1086#1088#1086#1077' '#1084#1086#1078#1085#1086' '#1089#1083#1072#1090#1100' '#1089#1084#1089'-'#1088#1072#1089#1089#1099#1083#1082#1080':'
        Visible = False
      end
      object spSMS: TShape
        Left = 664
        Top = 32
        Width = 321
        Height = 73
        Brush.Style = bsDiagCross
        Pen.Color = clNone
        Pen.Style = psClear
        Pen.Width = 0
        Visible = False
      end
      object lblAPI_LOG: TLabel
        Left = 834
        Top = 159
        Width = 226
        Height = 18
        Anchors = [akTop]
        Caption = #1057#1087#1080#1089#1086#1082' '#1079#1072#1103#1074#1086#1082' '#1074' API '#1087#1086' '#1085#1086#1084#1077#1088#1091
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        OnClick = lblAPI_LOGClick
        OnMouseEnter = LblBlueOn
        OnMouseLeave = LblBlueOff
        ExplicitLeft = 732
      end
      object EChangeSIM: TEdit
        Left = 122
        Top = 72
        Width = 257
        Height = 32
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -19
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        MaxLength = 18
        ParentFont = False
        TabOrder = 0
        OnKeyPress = eNewBlockHBKeyPress
      end
      object BChangeSIM: TButton
        Left = 383
        Top = 72
        Width = 88
        Height = 32
        Caption = #1057#1084#1077#1085#1080#1090#1100
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -19
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        OnClick = BChangeSIMClick
      end
      object BChangeSIMHist: TButton
        Left = 473
        Top = 72
        Width = 89
        Height = 32
        Caption = #1048#1089#1090#1086#1088#1080#1103
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -19
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 2
        OnClick = BChangeSIMHistClick
      end
      object DBEdit1: TDBEdit
        Left = 122
        Top = 42
        Width = 417
        Height = 24
        BorderStyle = bsNone
        DataField = 'SIM'
        DataSource = dmShowUserSt.dsDopPhoneInfo
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -19
        Font.Name = 'Verdana'
        Font.Style = [fsBold]
        ParentColor = True
        ParentFont = False
        ReadOnly = True
        TabOrder = 3
      end
      object B_ecare: TButton
        Left = 8
        Top = 120
        Width = 137
        Height = 25
        Caption = #1053#1086#1074#1099#1081' '#1082#1072#1073#1080#1085#1077#1090' '#1041#1080#1083#1072#1081#1085
        TabOrder = 4
        OnClick = B_ecareClick
      end
      object SetSmsDisableTime: TButton
        Left = 792
        Top = 120
        Width = 187
        Height = 25
        Caption = #1055#1088#1080#1084#1077#1085#1080#1090#1100' '#1075#1088#1072#1092#1080#1082' '#1089#1084#1089'-'#1088#1072#1089#1089#1099#1083#1082#1080
        TabOrder = 5
        Visible = False
        OnClick = SetSmsDisableTimeClick
      end
      object pnlAPI: TPanel
        Left = 0
        Top = 209
        Width = 1074
        Height = 331
        Align = alBottom
        TabOrder = 6
        object crgApiTickets: TCRDBGrid
          Left = 1
          Top = 1
          Width = 726
          Height = 329
          Align = alClient
          DataSource = dmShowUserSt.dsApiTickets
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
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
              FieldName = 'TYPE_REQ'
              Title.Caption = #1058#1080#1087
              Width = 80
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'STATE_REQ'
              Title.Caption = #1057#1090#1072#1090#1091#1089
              Width = 80
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'COMMENTS'
              Title.Caption = #1055#1086#1076#1088#1086#1073#1085#1086
              Width = 180
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'USER_CREATED'
              Title.Caption = #1057#1086#1079#1076#1072#1090#1077#1083#1100
              Width = 70
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'DATE_CREATE'
              Title.Caption = #1044#1072#1090#1072' '#1089#1086#1079#1076#1072#1085#1080#1103
              Width = 100
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'DATE_UPDATE'
              Title.Caption = #1044#1072#1090#1072' '#1086#1073#1085#1086#1074#1083#1077#1085#1080#1103
              Width = 100
              Visible = True
            end>
        end
        object dbgAPI_LOG: TCRDBGrid
          Left = 727
          Top = 1
          Width = 346
          Height = 329
          Align = alRight
          DataSource = dmShowUserSt.dsApi_log
          TabOrder = 1
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -11
          TitleFont.Name = 'MS Sans Serif'
          TitleFont.Style = []
          OnDblClick = dbgAPI_LOGDblClick
          Columns = <
            item
              Expanded = False
              FieldName = 'INSERT_DATE'
              Title.Caption = #1042#1088#1077#1084#1103
              Title.Font.Charset = DEFAULT_CHARSET
              Title.Font.Color = clWindowText
              Title.Font.Height = -11
              Title.Font.Name = 'MS Sans Serif'
              Title.Font.Style = [fsBold]
              Width = 82
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'REQ_SOURCE'
              Title.Caption = #1044#1077#1090#1072#1083#1100#1085#1086#1089#1090#1100
              Title.Font.Charset = DEFAULT_CHARSET
              Title.Font.Color = clWindowText
              Title.Font.Height = -11
              Title.Font.Name = 'MS Sans Serif'
              Title.Font.Style = [fsBold]
              Width = 88
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'LOAD_TYPE'
              Title.Caption = #1058#1080#1087' '#1079#1072#1075#1088#1091#1079#1082#1080
              Title.Font.Charset = DEFAULT_CHARSET
              Title.Font.Color = clWindowText
              Title.Font.Height = -11
              Title.Font.Name = 'MS Sans Serif'
              Title.Font.Style = [fsBold]
              Width = 120
              Visible = True
            end>
        end
      end
      object DpLogAPI: TsDateEdit
        Left = 648
        Top = 160
        Width = 109
        Height = 21
        AutoSize = False
        EditMask = '!99/99/9999;1; '
        MaxLength = 10
        TabOrder = 7
        BoundLabel.Indent = 0
        BoundLabel.Font.Charset = DEFAULT_CHARSET
        BoundLabel.Font.Color = clWindowText
        BoundLabel.Font.Height = -11
        BoundLabel.Font.Name = 'Tahoma'
        BoundLabel.Font.Style = []
        BoundLabel.Layout = sclLeft
        BoundLabel.MaxWidth = 0
        BoundLabel.UseSkinColor = True
        SkinData.SkinSection = 'EDIT'
        GlyphMode.Blend = 0
        GlyphMode.Grayed = False
        DefaultToday = True
        DialogTitle = #1044#1072#1090#1072' '#1079#1072#1075#1088#1091#1079#1082#1080
        Weekends = []
      end
      object bRefreshSIM: TButton
        Left = 564
        Top = 72
        Width = 96
        Height = 32
        Caption = #1054#1073#1085#1086#1074#1080#1090#1100
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -19
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 8
        OnClick = bRefreshSIMClick
      end
    end
  end
  object ActionList1: TActionList
    Images = MainForm.ImageList16
    Left = 80
    Top = 97
    object aSaveDetail: TAction
      Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1074' '#1092#1072#1081#1083
      Hint = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1076#1077#1090#1072#1083#1080#1079#1072#1094#1080#1102' '#1074' '#1092#1072#1081#1083
      ImageIndex = 8
      Visible = False
      OnExecute = aSaveDetailExecute
    end
    object aOpenDetailInExcel: TAction
      Caption = #1054#1090#1082#1088#1099#1090#1100' '#1074' Excel'
      OnExecute = aOpenDetailInExcelExecute
    end
    object aLinkPayment: TAction
      Category = 'Payments'
      Caption = #1055#1088#1080#1082#1088#1077#1087#1080#1090#1100' '#1087#1083#1072#1090#1105#1078
      OnExecute = aLinkPaymentExecute
    end
    object aUnlinkPayment: TAction
      Category = 'Payments'
      Caption = #1054#1090#1082#1088#1077#1087#1080#1090#1100' '#1087#1083#1072#1090#1105#1078
      OnExecute = aUnlinkPaymentExecute
    end
    object aAddPayment: TAction
      Category = 'Payments'
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100'...'
      OnExecute = aAddPaymentExecute
    end
  end
  object sdDetail: TSaveDialog
    DefaultExt = 'txt'
    Filter = #1060#1072#1081#1083#1099' '#1076#1077#1090#1072#1083#1080#1079#1072#1094#1080#1103' (*.txt)|*.txt|'#1042#1089#1077' '#1092#1072#1081#1083#1099' (*.*)|*.*'
    Title = #1060#1072#1081#1083' '#1076#1077#1090#1072#1083#1080#1079#1072#1094#1080#1080
    Left = 160
    Top = 148
  end
  object MainMenu1: TMainMenu
    Left = 512
    Top = 608
  end
  object OpenDialog1: TOpenDialog
    Left = 160
    Top = 96
  end
  object PopupMenu1: TPopupMenu
    Images = MainForm.ImageList24
    Left = 592
    Top = 616
    object B1: TMenuItem
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1072#1090#1091' '#1087#1083#1072#1090#1077#1078#1072
      ImageIndex = 6
      OnClick = B1Click
    end
  end
  object pmStatus: TPopupMenu
    Left = 168
    Top = 288
    object RemoveStatusMenu: TMenuItem
      Caption = #1059#1076#1072#1083#1080#1090#1100' '#1089#1090#1072#1090#1091#1089
      OnClick = RemoveStatusMenuClick
    end
  end
  object PopupMenuBalanceHistory: TPopupMenu
    Left = 160
    Top = 208
    object N1: TMenuItem
      Caption = #1048#1089#1090#1086#1088#1080#1103' '#1073#1072#1083#1072#1085#1089#1086#1074' '#1087#1086' '#1074#1080#1076#1072#1084' '#1080#1079#1084#1077#1085#1077#1085#1080#1103
      OnClick = N1Click
    end
  end
end