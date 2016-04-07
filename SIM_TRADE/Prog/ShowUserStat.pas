unit ShowUserStat;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, Grids, DBGrids, CRGrid, ExtCtrls, MemDS, DBAccess, Ora,
  StdCtrls, ActnList, DBCtrls, Mask, Main, Buttons, ComCtrls,
  EditAbonentFrame, VirtualTable, AddDeposite, sMaskEdit, sCustomComboEdit,
  sTooledit, math, IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient,
  IdExplicitTLSClientServerBase, IdMessageClient, IdSMTPBase, IdSMTP,
  IdMessage,IdCoderHeader,IdCoderMime, IdCoder, IdCoder3to4, IdAttachmentFile,
  Menus, sBitBtn, DateUtils,ReportReplaceSIM, sCheckBox,Web,ExportGridToExcelPDF,
WSlider, IdIOHandler, IdIOHandlerSocket, IdIOHandlerStack, IdSSL, IdSSLOpenSSL,
  dmShowUserStat;

type

 mySMTP = class(TThread)
     SMTP_FROMTXT,SMTP_SRV,SMTP_LOG,SMTP_PASS,SMTP_ATT_FILE,SMTP_ADDR,SMTP_TITLE,SMTP_BODY,SMTP_FROM:string;
     SMTP_PORT:word;
  private
    { Private declarations }
  protected
    procedure Execute; override;
  end;


  TShowUserStatForm = class(TForm)
    Panel1: TPanel;
    CRDBGrid1: TCRDBGrid;
    Splitter1: TSplitter;
    Panel2: TPanel;
    mDetailText: TMemo;
    Panel3: TPanel;
    Panel4: TPanel;
    ActionList1: TActionList;
    aSaveDetail: TAction;
    sdDetail: TSaveDialog;
    DBText1: TDBText;
    Label1: TLabel;
    Label12: TLabel;
    DBText12: TDBText;
    Panel5: TPanel;
    btnClose: TBitBtn;
    BitBtn1: TBitBtn;
    PageControl1: TPageControl;
    tsDetail: TTabSheet;
    tsAbonent: TTabSheet;
    EditAbonentFrame: TEditAbonentFrme;
    tsTariffs: TTabSheet;
    CRDBGrid2: TCRDBGrid;
    tsPayments: TTabSheet;
    Panel7: TPanel;
    gPayments: TCRDBGrid;
    tsBills: TTabSheet;
    CRDBGrid4: TCRDBGrid;
    tsOptions: TTabSheet;
    CRDBGrid5: TCRDBGrid;
    tsBalanceRows: TTabSheet;
    dbgDetail: TCRDBGrid;
    BitBtn2: TBitBtn;
    aOpenDetailInExcel: TAction;
    tsDeposit: TTabSheet;
    lDepositValue: TLabel;
    lDepositOper: TLabel;
    dbDepositOper: TCRDBGrid;
    btAddDeposit: TBitBtn;
    dbtDepositValue: TDBText;
    pPaymentsToolBar: TPanel;
    btnUsePayment: TButton;
    btnUnUsePayment: TButton;
    aLinkPayment: TAction;
    aUnlinkPayment: TAction;
    aAddPayment: TAction;
    btnAdd: TButton;
    tsDiscount: TTabSheet;
    dtpNewBeginDate: TDateTimePicker;
    dbtEndDate: TDBText;
    dbtBeginDate: TDBText;
    lBegin: TLabel;
    lEnd: TLabel;
    btSetDiscount: TBitBtn;
    lDate: TLabel;
    lLength: TLabel;
    cbDiscount: TCheckBox;
    eLength: TDBEdit;
    tsContractInfo: TTabSheet;
    Label18: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    DBText20: TDBText;
    DBMemo1: TDBMemo;
    btRefreshCI: TBitBtn;
    btPostComments: TBitBtn;
    Label22: TLabel;
    DBText21: TDBText;
    Panel9: TPanel;
    Ds: TBitBtn;
    SaveBtn: TBitBtn;
    IS_BS_CHECK: TCheckBox;
    lCreditInfo: TLabel;
    Label23: TLabel;
    DBText22: TDBText;
    pOptions: TPanel;
    cbPeriodsOpt: TComboBox;
    tsClientBills: TTabSheet;
    CRDBGridClientBills: TCRDBGrid;
    Panel10: TPanel;
    btBillClient: TBitBtn;
    PageControl2: TPageControl;
    tsPaymentsReal: TTabSheet;
    tsPaymentsPromised: TTabSheet;
    Panel11: TPanel;
    Panel12: TPanel;
    gPromisedPayments: TCRDBGrid;
    lPromisedSum: TLabel;
    lPromisedTime: TLabel;
    btAddPromisedPayment: TBitBtn;
    ePromisedSum: TEdit;
    PageControl3: TPageControl;
    tsOperatorBills: TTabSheet;
    sdePromisedDate: TsDateEdit;
    btDelPromisedPayment: TBitBtn;
    BitBtn3: TBitBtn;
    DBMemo2: TDBMemo;
    PageControl4: TPageControl;
    tsBillsOldFormat: TTabSheet;
    tsBillsNewFormat: TTabSheet;
    PageControl5: TPageControl;
    tsBillBeeline: TTabSheet;
    tsBillClientNew: TTabSheet;
    tsAbonPeriodList: TTabSheet;
    tsRouming: TTabSheet;
    pRouming: TPanel;
    btRouming: TBitBtn;
    pBillClientNew: TPanel;
    btBillClientNew: TBitBtn;
    pBillBeeline: TPanel;
    btBillBeeline: TBitBtn;
    pAbonPeriodList: TPanel;
    btAbonPeriodList: TBitBtn;
    grAbonPeriodList: TCRDBGrid;
    grRouming: TCRDBGrid;
    grBillBeeline: TCRDBGrid;
    grBillClientNew: TCRDBGrid;
    btRefreshOptionList: TBitBtn;
    BitBtn5: TBitBtn;
    Panel13: TPanel;
    BitBtn6: TBitBtn;
    btAddNoBlock: TBitBtn;
    cbDealers: TDBLookupComboBox;
    Label17: TLabel;
    Label31: TLabel;
    DBText19: TDBText;
    btSendMail: TBitBtn;
    edEmailAdress: TEdit;
    MainMenu1: TMainMenu;
    dtBegin: TDateTimePicker;
    dtEnd: TDateTimePicker;
    btAddFilter: TsBitBtn;
    cbFree: TCheckBox;
    lbBegindate: TLabel;
    lbEndDate: TLabel;
    IS_BILL_CHECK: TCheckBox;
    btUnload: TBitBtn;
    OpenDialog1: TOpenDialog;
    tsDopInfo: TTabSheet;
    blCaptionHLR: TLabel;
    lbHLR: TDBText;
    lbCaptionSIM: TLabel;
    lbSim: TDBText;
    EChangeSIM: TEdit;
    LChangeSIM: TLabel;
    BChangeSIM: TButton;
    BChangeSIMHist: TButton;
    DBEdit1: TDBEdit;
    cbEXCLUDE_DETAIL: TsCheckBox;
    cb_Hide_detail: TCheckBox;
    Panel8: TPanel;
    gPhoneStatuses: TCRDBGrid;
    Panel15: TPanel;
    Panel6: TPanel;
    Label13: TLabel;
    DBText13: TDBText;
    DB_TXT_NEW_TARIF_INFO: TDBText;
    LblState: TLabel;
    lTariffStatusText: TLabel;
    Label19: TLabel;
    DBText18: TDBText;
    lBlockInfo: TLabel;
    lCloseNumber: TLabel;
    Label25: TLabel;
    Label27: TLabel;
    Label24: TLabel;
    btInstalmentPayment: TBitBtn;
    cbDopStatus: TDBLookupComboBox;
    btPostDopStatus: TBitBtn;
    Panel14: TPanel;
    lBalanceGroup: TLabel;
    lBalance: TLabel;
    LblBalance: TLabel;
    lblBalanceGroup: TLabel;
    CBnewcab: TCheckBox;
    BtSetPassword: TButton;
    BtnSendBal: TButton;
    BtSendSms: TButton;
    UnBlockListBt: TButton;
    BlockListBt: TButton;
    BtUnBlock: TButton;
    BtBlock: TButton;
    pnlNewHB: TPanel;
    Label29: TLabel;
    Label30: TLabel;
    btSetHandBlockDateEnd: TBitBtn;
    emNewDateEnd: TMaskEdit;
    eNewNoticeHB: TEdit;
    eNewBlockHB: TEdit;
    eSetPassword: TEdit;
    BtSetPasswordOk: TButton;
    RGBlock: TRadioGroup;
    pnlShowHB: TPanel;
    dbtShowDateHB: TDBText;
    dbtShowBlockHB: TDBText;
    Label28: TLabel;
    dbtShowUserHB: TDBText;
    Label26: TLabel;
    dbtShowNoticeHB: TDBText;
    CbHandBlock: TCheckBox;
    ContractType: TLabel;
    BUnbilledCallsList: TButton;
    B_ecare: TButton;
    lCreditLimit: TLabel;
    lTGOptions: TLabel;
    DBLookupComboBox1: TDBLookupComboBox;
    btChangeOptionGroup: TButton;
    BitBtn_MN_Roaming: TBitBtn;
    Lb_MN_ROAMING: TLinkLabel;
    DBText15: TDBText;
    Label15: TLabel;
    PopupMenu1: TPopupMenu;
    B1: TMenuItem;
    MonthCalendar1: TMonthCalendar;
    lZayavkiAPI: TLabel;
    cbHideZeroCall: TCheckBox;
    btnExportPayments: TBitBtn;
    lblEveragePayments: TLabel;
    lblLabelEvPaym: TLabel;
    lblItogPaym: TLabel;
    lblItogPayment: TLabel;
    lblParamSMSDisab: TLabel;
    SetSmsDisableTime: TButton;
    spSMS: TShape;
    pnlAPI: TPanel;
    crgApiTickets: TCRDBGrid;
    dbgAPI_LOG: TCRDBGrid;
    lblAPI_LOG: TLabel;
    pmStatus: TPopupMenu;
    RemoveStatusMenu: TMenuItem;
    DpLogAPI: TsDateEdit;
    PopupMenuBalanceHistory: TPopupMenu;
    N1: TMenuItem;
    pCurrentOptions: TPanel;
    pOptionHistory: TPanel;
    CRDBGridOptionHistory: TCRDBGrid;
    SplitterOptions: TSplitter;
    btAPITurnOnServises: TBitBtn;
    lbContract: TLabel;
    Image1: TImage;
    pFrame: TPanel;
    gStatistic: TStringGrid;
    Panel16: TPanel;
    Panel17: TPanel;
    Panel18: TPanel;
    Panel19: TPanel;
    pTariffInfoButton: TPanel;
    pBalanceInfo: TPanel;
    pHandBlock: TPanel;
    Panel20: TPanel;
    cbDailyAbonPay: TCheckBox;
    cbDailyAbonPayBanned: TCheckBox;
    btBlockBySave: TButton;
    lbl_IS_COLLECTOR: TLabel;
    tsSummaryPhone: TTabSheet;
    gSummaryPhone: TCRDBGrid;
    tsRest: TTabSheet;
    gRest: TCRDBGrid;
    pRest: TPanel;
    btnaOpenDetailInExcel: TBitBtn;
    btRefresh: TBitBtn;
    bRefreshSIM: TButton;

    procedure dsPeriodsDataChange(Sender: TObject; Field: TField);
    procedure dsTariffInfoDataChange(Sender: TObject; Field: TField);
    procedure CRDBGrid4GetCellParams(Sender: TObject; Field: TField;
      AFont: TFont; var Background: TColor; State: TGridDrawState;
      StateEx: TGridDrawStateEx);
    procedure aOpenDetailInExcelExecute(Sender: TObject);
    procedure qPhoneStatusesPHONE_IS_ACTIVEGetText(Sender: TField;
      var Text: String; DisplayText: Boolean);
    procedure qPaymentsPAYMENT_STATUS_TEXTGetText(Sender: TField;
      var Text: String; DisplayText: Boolean);
    procedure qPaymentsCONTRACT_IDGetText(Sender: TField;
      var Text: String; DisplayText: Boolean);
    procedure BtBlockClick(Sender: TObject);
    procedure BtUnBlockClick(Sender: TObject);
    procedure BtSendSmsClick(Sender: TObject);
    procedure BlockListBtClick(Sender: TObject);
    procedure UnBlockListBtClick(Sender: TObject);

    procedure CbHandBlockExit(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtSetPasswordClick(Sender: TObject);
    procedure BtSetPasswordOkClick(Sender: TObject);
    procedure eSetPasswordKeyPress(Sender: TObject; var Key: Char);
    procedure btAddDepositClick(Sender: TObject);
    procedure tsDetailShow(Sender: TObject);
    procedure qPaymentsAfterOpen(DataSet: TDataSet);
    procedure aLinkPaymentExecute(Sender: TObject);
    procedure aUnlinkPaymentExecute(Sender: TObject);
    procedure aAddPaymentExecute(Sender: TObject);
    procedure cbDiscountClick(Sender: TObject);
    procedure btSetDiscountClick(Sender: TObject);
    procedure CbHandBlockClick(Sender: TObject);
    procedure btSetHandBlockDateEndClick(Sender: TObject);
    procedure spSetHandBlockEndDateAfterExecute(Sender: TObject;
      Result: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure DBMemo1Change(Sender: TObject);
    procedure btRefreshCIClick(Sender: TObject);
    procedure btPostCommentsClick(Sender: TObject);
    procedure CRDBGrid5CellClick(Column: TColumn);
    procedure DsClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure EditAbonentFramePASSPORT_SERChange(Sender: TObject);
    procedure EditAbonentFramePASSPORT_NUMChange(Sender: TObject);
    procedure EditAbonentFramePASSPORT_GETChange(Sender: TObject);
    procedure EditAbonentFramePASSPORT_DATEChange(Sender: TObject);
    procedure EditAbonentFrameCOUNTRY_IDClick(Sender: TObject);
    procedure EditAbonentFrameREGION_IDClick(Sender: TObject);
    procedure EditAbonentFrameSTREET_NAMEChange(Sender: TObject);
    procedure EditAbonentFrameCITY_NAMEChange(Sender: TObject);
    procedure EditAbonentFrameAPARTMENTChange(Sender: TObject);
    procedure EditAbonentFrameHOUSEChange(Sender: TObject);
    procedure EditAbonentFrameCODE_WORDChange(Sender: TObject);
    procedure EditAbonentFrameCONTACT_INFOChange(Sender: TObject);
    procedure EditAbonentFrameEMAILChange(Sender: TObject);
    procedure EditAbonentFrameKORPUSChange(Sender: TObject);
    procedure EditAbonentFrameSURNAMEChange(Sender: TObject);
    procedure EditAbonentFrameCITIZENSHIPClick(Sender: TObject);
    procedure EditAbonentFramePATRONYMICChange(Sender: TObject);
    procedure EditAbonentFrameNAMEChange(Sender: TObject);
    procedure EditAbonentFrameBDATEChange(Sender: TObject);
    procedure EditAbonentFrameIS_VIPClick(Sender: TObject);
    procedure EditAbonentFrameToolButton1Click(Sender: TObject);
    procedure SaveBtnClick(Sender: TObject);
    procedure IS_BS_CHECKClick(Sender: TObject);
    procedure tsContractInfoShow(Sender: TObject);
    procedure tsDepositShow(Sender: TObject);
    procedure tsOptionsShow(Sender: TObject);
    procedure tsDiscountShow(Sender: TObject);
    procedure tsTariffsShow(Sender: TObject);
    procedure CRDBGrid2CellClick(Column: TColumn);
    procedure BtnSendBalClick(Sender: TObject);
    procedure cbPeriodsOptChange(Sender: TObject);
    procedure btBillClientClick(Sender: TObject);
    procedure tsClientBillsShow(Sender: TObject);
    procedure tsPaymentsPromisedShow(Sender: TObject);
    procedure btAddPromisedPaymentClick(Sender: TObject);
    procedure tsOperatorBillsShow(Sender: TObject);
    procedure tsPaymentsRealShow(Sender: TObject);
    procedure tsBalanceRowsShow(Sender: TObject);
    procedure btDelPromisedPaymentClick(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure tsAbonPeriodListShow(Sender: TObject);
    procedure tsRoumingShow(Sender: TObject);
    procedure tsBillBeelineShow(Sender: TObject);
    procedure tsBillClientNewShow(Sender: TObject);
    procedure btBillBeelineClick(Sender: TObject);
    procedure btBillClientNewClick(Sender: TObject);
    procedure tsBillsNewFormatShow(Sender: TObject);
    procedure btAbonPeriodListClick(Sender: TObject);
    procedure btRoumingClick(Sender: TObject);
    procedure gPaymentsDblClick(Sender: TObject);
    procedure btRefreshOptionListClick(Sender: TObject);
    procedure BitBtn5Click(Sender: TObject);
    procedure btPostDopStatusClick(Sender: TObject);
    procedure BitBtn6Click(Sender: TObject);
    procedure cbDopStatusCloseUp(Sender: TObject);
    procedure LblBlueOff(Sender: TObject);
    procedure LblBalanceClick(Sender: TObject);
    procedure LblBlueOn(Sender: TObject);
    procedure eNewBlockHBKeyPress(Sender: TObject; var Key: Char);
    procedure eNewNoticeHBKeyPress(Sender: TObject; var Key: Char);
    procedure btAddNoBlockClick(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure btInstalmentPaymentClick(Sender: TObject);
    procedure aSaveDetailExecute(Sender: TObject);
    procedure btAddFilterClick(Sender: TObject);
    procedure IS_BILL_CHECKClick(Sender: TObject);
    procedure btUnloadClick(Sender: TObject);
    procedure tsDopInfoShow(Sender: TObject);
    procedure BChangeSIMClick(Sender: TObject);
    procedure DBMemo2Click(Sender: TObject);
    procedure LblStateClick(Sender: TObject);
    procedure BChangeSIMHistClick(Sender: TObject);
    procedure Label27Click(Sender: TObject);
    procedure cbEXCLUDE_DETAILValueChanged(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure cb_Hide_detailClick(Sender: TObject);
    procedure dsOptionsDataChange(Sender: TObject; Field: TField);
    procedure CRDBGrid2ColEnter(Sender: TObject);
    procedure BGet_api_servicesClick(Sender: TObject);
    procedure BUnbilledCallsListClick(Sender: TObject);
    procedure B_ecareClick(Sender: TObject);
    procedure btChangeOptionGroupClick(Sender: TObject);
    procedure BitBtn_MN_RoamingClick(Sender: TObject);
    procedure B1Click(Sender: TObject);
    procedure MonthCalendar1DblClick(Sender: TObject);
    procedure gPaymentsCellClick(Column: TColumn);
    procedure MonthCalendar1MouseLeave(Sender: TObject);
    procedure cbHideZeroCallClick(Sender: TObject);
    procedure btnExportPaymentsClick(Sender: TObject);
    procedure SetSmsDisableTimeClick(Sender: TObject);
    procedure dbgAPI_LOGDblClick(Sender: TObject);
    procedure lblAPI_LOGClick(Sender: TObject);
    procedure RemoveStatusMenuClick(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure Label1Click(Sender: TObject);
    procedure CRDBGrid2GetCellParams(Sender: TObject; Field: TField;
      AFont: TFont; var Background: TColor; State: TGridDrawState;
      StateEx: TGridDrawStateEx);
    procedure CRDBGridOptionHistoryGetCellParams(Sender: TObject; Field: TField;
      AFont: TFont; var Background: TColor; State: TGridDrawState;
      StateEx: TGridDrawStateEx);
    procedure CRDBGrid2DblClick(Sender: TObject);
    procedure btAPITurnOnServisesClick(Sender: TObject);
    procedure cbDailyAbonPayClick(Sender: TObject);
    procedure cbDailyAbonPayBannedClick(Sender: TObject);
    procedure btBlockBySaveClick(Sender: TObject);
    procedure RGBlockClick(Sender: TObject);
    procedure tsSummaryPhoneShow(Sender: TObject);
    procedure gSummaryPhoneCellClick(Column: TColumn);
    procedure gSummaryPhoneDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure qSummaryPhoneBeforeOpen(DataSet: TDataSet);
    procedure btnaOpenDetailInExcelClick(Sender: TObject);
    procedure btRefreshClick(Sender: TObject);
    procedure bRefreshSIMClick(Sender: TObject);
  private
    FYear : Integer;
    FMonth : Integer;
    FDetailText : String;
    FPhoneNumber: String;
    FContractID: Integer;
    FContractDate : TDateTime;
    FHandBlockChecked: Boolean;
    FManualPaymentManagement : Boolean;
    FFilialId: Variant;
    smstime:      TAwSlider;
    procedure LoadDetailText;
    procedure LoadBillDetailText;
    procedure PrepareDetail;
    procedure RefreshBalanceRows;
    function DecodeServiceType(const Code: String): String;
    function EditcbDailyAbonPayBanned : Boolean;
    procedure BlockPhone (StatusCode : String);
    procedure SetDataModuleSettings;
    procedure RefreshData (pPhone : string);
    procedure ExcelExport;
  public
    procedure Execute(const pPhoneNumber : String; const pContractID : Integer);
    function CheckDate:boolean;
    procedure AddFilter;
    function FindComponentEx(const Name: string): TComponent;
    procedure Send_mail_dop_status;
    procedure MN_ROAMING;
    procedure FillingStatistic;
  end;



  // �������� ���������� �������� �� ���� ���������
//  procedure ShowUserStatByContract(const pContractId : Variant);
  // �������� ���������� �������� �� ������ ��������
  procedure ShowUserStatByPhoneNumber(const pPhoneNumber : String; const vContractID : Integer; const PageName : String = '');

//  procedure DoShowUserStat(const pPhoneNumber : String; const pAbonentId : Variant);

implementation

{$R *.dfm}

uses ContractsRegistration_Utils, IntecExportGrid, CRStrUtils, SendSms,
  BlockList, UnBlockList, SelectContract, RegisterPayment, ShowBillDetails, ShowUserAlerts,
  DMUnit, PassWord, ShowUserTurnOnOffOption, StrUtils;

const
  PAYMENT_TYPE_LOADED = 2; // ����� �������� ������������� (�� V_FULL_BALANCE_PAYMENTS.PAYMENT_TYPE)

// ��� �� ������ ���������, ��� ������� ����� ����������� �������
// ��� �� �������� ������������ � CALC_BALANCE_ROWS2
const DAYS_PAYMENT_BEFORE_CONTRACT = 4;

//����� ������ � qHBDetails.SQL, � ������� ������������� ��������� ��� �������
const
  qHBDetailsStrTableNameNum = 23;
var
    cbexcept:integer=1;
    cbexcept1:integer=1;
    qexcept:TOraQuery;
    qexcept1:TOraQuery;
    old_date : string;   //19610
    vdop_status : string;   //19610
    FormatSQL:string;//�������������� ������ ��� ���_�����
    TableName:string;//��� �������  ��� ���������� ���_�����
    dmShowUserSt : TdmShowUserSt;

{ TShowUserStatForm }

procedure DoShowUserStat(const pPhoneNumber : String; const pContractId : Integer;
  const PageName : String = '');
var
  ShowUserStatForm: TShowUserStatForm;
  AdminPriv : boolean;
begin
  try
    dmShowUserSt := TdmShowUserSt.Create(nil);
    ShowUserStatForm := TShowUserStatForm.Create(nil);
    MainForm.CheckAdminPrivs(AdminPriv);
    if not(AdminPriv) then
    begin
      ShowUserStatForm.tsBillBeeline.Destroy;
      dmShowUserSt.qAbonPeriodListABON_MAIN_OLD.Destroy;
      if GetConstantValue('SERVER_NAME') = 'CORP_MOBILE' then
        ShowUserStatForm.CbHandBlock.Visible:=false;
    end;
    try
      if PageName = 'Payments' then
        ShowUserStatForm.PageControl1.ActivePage := ShowUserStatForm.tsPayments;
      dmShowUserSt.qContractID.Close;
      dmShowUserSt.qContractID.ParamByName('PHONE_NUMBER').AsString:=pPhoneNumber;
      dmShowUserSt.qContractID.Open;
      if dmShowUserSt.qContractID.IsEmpty then
      begin
        ShowMessage('��� ������� ������ �� ���������� ����������');
        ShowUserStatForm.Execute(pPhoneNumber, 0);
      end
      else begin
        if pContractId=0 then
          ShowUserStatForm.Execute(pPhoneNumber, dmShowUserSt.qContractID.FieldByName('CONTRACT_ID').AsInteger)
        else
          ShowUserStatForm.Execute(pPhoneNumber, pContractId);
      end;
    finally
      ShowUserStatForm.Free;
    end;
  finally
    FreeAndNil(dmShowUserSt);
  end;
end;

{
procedure ShowUserStatByContract(const pContractId : Variant);
var vPhoneNumber : String;
    vAbonentId : Variant;
begin
  if not FindPhoneAndAbonent(pContractID, vPhoneNumber, vAbonentId) then
    MessageDlg('��� �������� � ����� '+VarToStr(pContractID)+' �� ������ ����������� ����� ��������, ���������� ������.', mtError, [mbOK], 0)
  else
  begin
    // ���� ��� ���������, ������ ����� �������� ����������� ������ ���� ��������
    DoShowUserStat(vPhoneNumber, vAbonentId);
  end;
end;
}

procedure ShowUserStatByPhoneNumber(const pPhoneNumber : String;
  const vContractID : Integer;
  const PageName : String = '');
begin
  if pPhoneNumber = '' then
    MessageDlg('�� �������� �������� ���������� ��������. ��� �������� �� ���������., ���������� ������.', mtError, [mbOK], 0)
  else
    DoShowUserStat(pPhoneNumber,vContractID, PageName);
end;

procedure TShowUserStatForm.ExcelExport;
begin

end;

procedure TShowUserStatForm.Execute(const pPhoneNumber : String; const pContractID : Integer);
var IsAdmin: boolean;
    balance: double;
    atext: string;
    afontColor: integer;
begin
  // ��������� ����(����� ��� ���)
  MainForm.CheckAdminPrivs(IsAdmin);
  //
  eSetPassword.Hide;
  btSetPasswordOk.Hide;
  if GetConstantValue('SERVER_NAME')='CORP_MOBILE' then
    dmShowUserSt.qPeriods.SQL.Text := dmShowUserSt.qPeriodsCORP_MOBILE.SQL.Text;

  if (GetConstantValue('SERVER_NAME')='CORP_MOBILE') or (GetConstantValue('SERVER_NAME')='GSM_CORP') then
    BitBtn3.Visible:=true
  else BitBtn3.Visible:=false;
 // BitBtn5.Visible:=(GetConstantValue('SERVER_NAME')='CORP_MOBILE');
   if (GetConstantValue('SERVER_NAME')='CORP_MOBILE') or (GetConstantValue('SERVER_NAME')='GSM_CORP') then
    BitBtn5.Visible:=true
  else BitBtn5.Visible:=false;
  IS_BILL_CHECK.Visible:=(GetConstantValue('SERVER_NAME')='CORP_MOBILE');
  if GetConstantValue('ENABLE_INTERNET_KABINET') = '1' then
    btSetPassword.Show
  else
    btSetPassword.Hide;

  if GetConstantValue('ENABLE_BLOCK_BY_SAVE') = '1' then
    btBlockBySave.Visible := True
  else
    btBlockBySave.Visible := False;

  //�������
  dmShowUserSt.qContractInfo.ParamByName('CONTRACT_ID').AsInteger := pContractID;
  dmShowUserSt.qContractInfo.Open;
  try
    if dmShowUserSt.qContractInfo.IsEmpty then
    begin
      FContractDate := 0;
      FFilialId := Null;
    end
    else
    begin
      FContractDate := Trunc(dmShowUserSt.qContractInfo.FieldByName('CONTRACT_DATE').AsDateTime);
      FFilialId := dmShowUserSt.qContractInfo.FieldByName('FILIAL_ID').Value;
      if GetConstantValue('SERVER_NAME') = 'CORP_MOBILE' then
        if dmShowUserSt.qContractInfo.FieldByName('DISCONNECT_LIMIT').AsInteger = 0 then
          lCreditLimit.Visible:=false
        else
          lCreditLimit.Caption:= '��������� �����:    '
                + dmShowUserSt.qContractInfo.FieldByName('DISCONNECT_LIMIT').AsString + ' �.'
      else lCreditLimit.Visible:=false;
    end;
     //���������� ���������� �� �������� ������� ��� ���
    if (GetConstantValue('VARIABLE_SMS_TIME')='1')  then
    begin
      lblParamSMSDisab.Visible:=true;
      SetSmsDisableTime.Visible:=true;
          //�������� �������� ��� ������ ������� �������� ���
      smstime := TAwSlider.Create(Self);
      with smstime do
      begin
        SetBounds(665, 40, tsDopInfo.Width - 670, 50);
        Anchors := [akLeft, akTop]; // , akRight
        DecimalCount:=18;
        Filtered := False;
        try
          MinData := dmShowUserSt.qContractInfo.FieldByName('START_SMS_TIME').AsFloat;
          minFilter:= 0;
          MinValue := 0;
          MaxData := dmShowUserSt.qContractInfo.FieldByName('END_SMS_TIME').AsFloat;
          MaxFilter := 0.999305555560000000;
          MaxValue := 0.999305555560000000;
          Step := 0.041666666666666700;
        except
          ShowMessage('������ ��������� ������ qContractInfo!');
        end;
        ValueType := vtTime;
        ParentShowHint := False;
        ShowHint := False;
        Parent := tsDopInfo;
      end;
    end;
     Caption := Caption + ' ' + dmShowUserSt.qContractInfo.FieldByName('GROUP_NAME').AsString;

    //����������/�������� ����� �������� �� ������� ����� � ����������.
    //���������� ������ ��� GSM_CORP
    pFrame.Visible := false;
    if (GetConstantValue('SERVER_NAME') = 'GSM_CORP') then
    begin
      dmShowUserSt.qPrivateContract.ParamByName('pPHONE_NUMBER').AsString := pPhoneNumber;
      dmShowUserSt.qPrivateContract.Open;
      try
        if not dmShowUserSt.qPrivateContract.IsEmpty then
          if not dmShowUserSt.qPrivateContract.FieldByName('ACCOUNT_NUMBER').IsNull then
            if dmShowUserSt.qPrivateContract.FieldByName('ACCOUNT_NUMBER').AsString = '536917834' then
            begin
              lbContract.Caption := '�������:    ' + dmShowUserSt.qPrivateContract.FieldByName('ACCOUNT_NUMBER').AsString;
              pFrame.Width := lbContract.Width + 10;
              pFrame.Visible := true;
            end;
      finally
        dmShowUserSt.qPrivateContract.Close;
      end;
    end;
  finally
    dmShowUserSt.qContractInfo.Close;
  end;

  FManualPaymentManagement := (GetConstantValue('MANUAL_LINK_PAYMENTS_ENABLED') = '1');
  pPaymentsToolBar.Visible := FManualPaymentManagement;
  //
  Caption := Caption + ' ' + FormatPhoneNumber(pPhoneNumber);
  FPhoneNumber := pPhoneNumber;
  FContractID:=pContractID;
  //
  dmShowUserSt.qSelBalDate.ParamByName('PHONE_NUMBER').AsString := pPhoneNumber;
  dmShowUserSt.qSelBalDate.ParamByName('CONTRACT_ID').AsInteger := pContractID;
  dmShowUserSt.qSelBalDate.Open;
  //
  if pContractID=0 then
  begin
    SaveBtn.Enabled:=false;
    EditAbonentFrame.PrepareFrameByContractID('DISABLE', 0);
  end
  else
    EditAbonentFrame.PrepareFrameByContractID('EDIT', pContractID);

  Caption := Caption + ' ' +EditAbonentFrame.SURNAME.Text + ' '
                           + EditAbonentFrame.Name.Text  + ' '
                           + EditAbonentFrame.PATRONYMIC.Text
                ;
  //
   dmShowUserSt.qBlocked.ParamByName('phonenum').AsString := pPhoneNumber;
   dmShowUserSt.qBlocked.Open;
  //
  dmShowUserSt.qTariffInfo.ParamByName('PHONE_NUMBER').AsString := pPhoneNumber;
  if dmShowUserSt.qSelBalDate.FieldByName('contract_cancel_date').AsString='' then
    dmShowUserSt.qTariffInfo.ParamByName('pBALANCE_DATE').Clear
  else
    dmShowUserSt.qTariffInfo.ParamByName('pBALANCE_DATE').AsDateTime := dmShowUserSt.qSelBalDate.FieldByName('contract_cancel_date').AsDateTime;
  // �������� ���������� �
  //qTariffInfo.Open;
  //��������� ������
  if GetConstantValue('SHOW_CONTRACT_GROUPS') = '1' then
  begin
    dmShowUserSt.qBalanceGroup.ParamByName('PHONE_NUMBER').AsString := pPhoneNumber;
    dmShowUserSt.qBalanceGroup.ParamByName('CONTRACT_ID').AsInteger := pContractID;
    dmShowUserSt.qBalanceGroup.Open;
    if not dmShowUserSt.qBalanceGroup.FieldByName('group_balance').IsNull then
    begin
      Balance := dmShowUserSt.qBalanceGroup.FieldByName('group_balance').AsFloat;
      AText := FloatToStrF(Balance, ffNumber, 15, 2);
      if Balance  < 0 then
        AFontColor := clRed
      else
        AFontColor := clWindowText;
      lBalanceGroup.Caption:=atext;
      lBalanceGroup.Font.Color:=afontcolor;
      lBalanceGroup.Visible:=true;
      lblBalanceGroup.Visible:=true;
      lBalance.Top:=lBalance.Top-6;
      lBalance.Height:=lBalance.Height-5;
      lBalance.font.Height:=lBalance.font.Height+4;
      LblBalance.Top:=LblBalance.Top-10;
      //� ������� ��� ����������� �������� ������� ���
      //� ������ ����
      SetSmsDisableTime.Enabled:=false;
      smstime.Hint:='��� ��������� �������� ���������';
      smstime.ShowHint:=true;
      spSMS.Visible:=true;
      pnlNewHB.Enabled:=false;
      pnlShowHB.Hint:='������ ���� �������� � ���������� �������.';
      pnlShowHB.ShowHint:=true;
      CbHandBlock.Enabled:=false;
    end;

  end;
  //
  dmShowUserSt.qPassword.ParamByName('CONTRACT_ID').AsInteger:=pContractID;
  // �������
  dmShowUserSt.qPayments.ParamByName('PHONE_NUMBER').AsString := pPhoneNumber;
  //
  dmShowUserSt.qPhoneStatuses.ParamByName('PHONE_NUMBER').AsString := pPhoneNumber;
  dmShowUserSt.qPhoneStatuses.Open;
  //  ������ ��.
  dmShowUserSt.oqApiTickets.ParamByName('PHONE').AsString := pPhoneNumber;
  dmShowUserSt.oqApiTickets.Open;
  // ���� �������� ���
  dmShowUserSt.oqApi_log.ParamByName('PHONE').AsString := pPhoneNumber;
  //oqApi_log.Open;
  //
  if GetConstantValue('SHOW_OPERATOR_DISCOUNT') = '1' then
    tsDiscount.TabVisible:=true
  else
    tsDiscount.TabVisible:=false;
  //
  if GetConstantValue('SHOW_CONTRACT_INFO')='1' then
    tsContractInfo.TabVisible:=true
  else
    tsContractInfo.TabVisible:=false;
  if GetConstantValue('SHOW_DOP_PHONE_INFO')='1' then
    tsDopInfo.TabVisible:=true
  else
    tsDopInfo.TabVisible:=false;

  // ��������
  if (GetConstantValue('USE_DEPOSITES') = '1')and(pContractID>0) then
    tsDeposit.TabVisible:=true
  else
    tsDeposit.TabVisible:=false;

  //������ �� ������
  //tsSummaryPhone.TabVisible := IsAdmin;

  // ����������� �������, ���������� � tsBalanceRows.OnShow;
  //RefreshBalanceRows;
  //
  PageControl1.ActivePage:=tsTariffs;
  // ��������� �������
  PageControl2.ActivePage:=tsPaymentsReal;
  if ((GetConstantValue('USE_PROMISED_PAYMENTS') = '1')and IsAdmin) or
      ((GetConstantValue('USE_PROMISED_PAYMENTS') = '1') and (GetConstantValue('SERVER_NAME') = 'CORP_MOBILE')) then
  begin
    dmShowUserSt.qPrPayments.ParamByName('PHONE_NUMBER').AsString := FPhoneNumber;
    dmShowUserSt.spAddPrPayment.ParamByName('PPHONE_NUMBER').AsString := FPhoneNumber;
    dmShowUserSt.spDelPrPayment.ParamByName('PPHONE_NUMBER').AsString := FPhoneNumber;
    if (mainform.UserRightsType=2) or (mainform.UserRightsType=3) then
    begin
      btAddPromisedPayment.Enabled:=false;
    end;

  end
  else
    tsPaymentsPromised.Destroy;
  //  ����� (������ ������ �� 08.2012)
  dmShowUserSt.qBills.ParamByName('PHONE_NUMBER').AsString := FPhoneNumber;
  dmShowUserSt.qClientBills.ParamByName('PHONE_NUMBER').AsString := FPhoneNumber;
  //  ����� (����� ������ � 09.2012)
  dmShowUserSt.qBillBeeline.ParamByName('PHONE_NUMBER').AsString := FPhoneNumber;
  dmShowUserSt.qBillClientNew.ParamByName('PHONE_NUMBER').AsString := FPhoneNumber;
  dmShowUserSt.qRouming.ParamByName('PHONE_NUMBER').AsString := FPhoneNumber;
  dmShowUserSt.qAbonPeriodList.ParamByName('PHONE_NUMBER').AsString := FPhoneNumber;
  //
  if (GetConstantValue('AUTO_BLOCK_PHONE_NO_CONTRACTS') = '1')
      and (GetConstantValue('SERVER_NAME') = 'SIM_TRADE')
      and (FContractID = 0) then
    btAddNoBlock.Show
  else
    btAddNoBlock.Hide;
  //
  if (GetConstantValue('USE_INSTALLMENT_PAYMENT') = '1') and (FContractID <> 0) then
  begin
    dmShowUserSt.spCheckAlert.ParamByName('PCONTRACT_ID').AsInteger := FContractID;
    dmShowUserSt.spCheckAlert.ExecProc;
    if dmShowUserSt.spCheckAlert.ParamByName('RESULT').AsInteger = 1 then
      btInstalmentPayment.Show
    else
      btInstalmentPayment.Hide
  end
  else
    btInstalmentPayment.Hide;
  //
  PageControl1.ActivePage:=tsTariffs;
  PageControl3.ActivePage:=tsOperatorBills;
  PageControl4.ActivePage:=tsBillsNewFormat;
  PageControl5.ActivePage:=tsBillClientNew;
  //
  dmShowUserSt.qDailyAbonPayBanned.ParamByName('CONTRACT_ID').AsInteger:=FContractID;
  dmShowUserSt.qDailyAbonPay.ParamByName('PHONE_NUMBER').AsString:=FPhoneNumber;
  //
  try
    ShowModal;
  finally
    dmShowUserSt.qBalanceRows.Close;
    dmShowUserSt.qPhoneStatuses.Close;
    dmShowUserSt.qBills.Close;
    dmShowUserSt.qPayments.Close;
    dmShowUserSt.qTariffInfo.Close;
    dmShowUserSt.qBlocked.Close;
    dmShowUserSt.qOptions.Close;
    dmShowUserSt.qPeriods.Close;
    dmShowUserSt.qDeposit.Close;
    dmShowUserSt.qDepositOper.Close;
    dmShowUserSt.qDiscount.Close;
    dmShowUserSt.qHandBlockEndDate.Close;
    dmShowUserSt.qContractInfo.Close;
    dmShowUserSt.qContractInfo_DopStatus.Close;
    dmShowUserSt.qContractDopStatuses.Close;
    dmShowUserSt.qContractDealers.Close;
    dmShowUserSt.oqApiTickets.Close;
  end;
end;

procedure TShowUserStatForm.RefreshBalanceRows;
begin
  dmShowUserSt.qBalanceRows.Close;
  dmShowUserSt.spCalcBalanceRows.ParamByName('pPHONE_NUMBER').AsString := FPhoneNumber;
  dmShowUserSt.spCalcBalanceRows.ParamByName('pBALANCE_DATE').Value := dmShowUserSt.qSelBalDate.FieldByName('contract_cancel_date').Value;
  dmShowUserSt.spCalcBalanceRows.ExecSQL;
  dmShowUserSt.qBalanceRows.Open;
end;

procedure TShowUserStatForm.RefreshData(pPhone: string);
begin

end;

procedure TShowUserStatForm.RemoveStatusMenuClick(Sender: TObject);
var
  proc1:TOraStoredProc;
begin
  proc1:=TOraStoredProc.Create(self);
  proc1.StoredProcName:='DELETE_ACCOUNT_PHONE';
  proc1.PrepareSQL;
  proc1.ParamByName('PPHONE_NUMBER').AsString:=FPhoneNumber;
  proc1.Execute;
  showmessage(proc1.ParamByName('RESULT').AsString);
end;

procedure TShowUserStatForm.RGBlockClick(Sender: TObject);
begin
  if btBlockBySave.Visible then
    btBlockBySave.Enabled := RGBlock.ItemIndex = 2;
end;

procedure TShowUserStatForm.spSetHandBlockEndDateAfterExecute(Sender: TObject;
  Result: Boolean);
begin
  dmShowUserSt.qHandBlockEndDate.Close;
  dmShowUserSt.qHandBlockEndDate.Open;
  if (dmShowUserSt.qHandBlockEndDate.FieldByName('HAND_BLOCK').AsInteger=1)
    and(dmShowUserSt.qHandBlockEndDate.FieldByName('HAND_BLOCK_DATE_END').AsDateTime>=Date) then
    FHandBlockChecked:=true
  else
    FHandBlockChecked:=false;
  cbHandBlock.Checked:=FHandBlockChecked;
end;

procedure TShowUserStatForm.dsOptionsDataChange(Sender: TObject; Field: TField);
begin
//19610
 if CRDBGrid2.Col=5   then
  old_date:=CRDBGrid2.DataSource.DataSet.FieldByName('turn_off_date').AsString
  else  old_date:='';

end;

procedure TShowUserStatForm.dsPeriodsDataChange(Sender: TObject;
  Field: TField);
var
  d,AYear, AMonth,noload : Integer;
  stt:string;

begin
  noload:=0;
  AYear := dmShowUserSt.qPeriods.FieldByName('YEAR').AsInteger;
  AMonth := dmShowUserSt.qPeriods.FieldByName('MONTH').AsInteger;
  dtBegin.Date:=StrToDate('01.'+inttostr(AMonth)+'.'+inttostr(AYear));
  dtEnd.Date:=EndOfTheMonth(StrToDate('01.'+inttostr(AMonth)+'.'+inttostr(AYear)));
  if dtEnd.Date>date then
   dtEnd.Date:=date;

//  FPhoneNumber := qPeriods.FieldByName('PHONE_NUMBER').AsString;
  if (AYear <> FYear) or (FMonth <> AMonth) then
  begin
    FYear := AYear;
    FMonth := AMonth;
    if IS_BILL_CHECK.Checked then
    begin
      dmShowUserSt.dsDetail.Enabled:=false;
      dmShowUserSt.dsDetail.DataSet:= dmShowUserSt.vtDetailFile;
      dmShowUserSt.dsDetail.Enabled:=true;
      LoadBillDetailText;
      PrepareDetail;
    end
    else
    begin
      if (GetConstantValue('SERVER_NAME')='GSM_CORP') then
      begin
        dmShowUserSt.spHB_NO_LOAD.ParamByName('PPHONE_NUMBER').AsString := FPhoneNumber;
        dmShowUserSt.spHB_NO_LOAD.ExecProc;
        noload := dmShowUserSt.spHB_NO_LOAD.ParamByName('RESULT').AsInteger;
      end;
      if (GetConstantValue('DB_DETAILS')='0') or (noload > 0) then
      begin
        LoadDetailText;
        PrepareDetail;
      end
      else
      begin
        dmShowUserSt.spGetHBMonth.ParamByName('pYEAR').AsInteger := FYear;
        dmShowUserSt.spGetHBMonth.ParamByName('pMONTH').AsInteger := FMonth;
        dmShowUserSt.spGetHBMonth.ExecProc;
        if dmShowUserSt.spGetHBMonth.ParamByName('RESULT').AsInteger=0 then
        begin
          IS_BS_CHECK.Enabled:=true;
          dmShowUserSt.dsDetail.Enabled:=false;
          dmShowUserSt.dsDetail.DataSet:= dmShowUserSt.vtDetailFile;
          dmShowUserSt.dsDetail.Enabled:=true;
          LoadDetailText;
          PrepareDetail;
        end
        else
        begin
          IS_BS_CHECK.Enabled := false;
          dmShowUserSt.dsDetail.Enabled := false;
          dmShowUserSt.dsDetail.DataSet := dmShowUserSt.qHBDetails;
          dmShowUserSt.dsDetail.Enabled := true;
          stt:=inttostr(FMonth);
          if length(stt)=1 then
            stt:='0'+stt;
           {if (GetConstantValue('SERVER_NAME')='GSM_CORP') then
                  qHBDetails.SQL.Strings[20]:='  decode(c10.dbf_id,4339,null,to_char(nvl(c10.insert_date,(select hbf.load_edate from hot_billing_files hbf';}
          dmShowUserSt.qHBDetails.SQL.Strings[qHBDetailsStrTableNameNum]:=' from call_'+stt+'_'+inttostr(FYear)+' c10';
          dmShowUserSt.qHBDetails.ParamByName('SUBSCR').AsString := FPhoneNumber;
          dmShowUserSt.qHBDetails.Open;
        end;
      end;
    end;
   //��������� ������� ����������
   FillingStatistic;
  end;
end;

procedure TShowUserStatForm.Label1Click(Sender: TObject);
var
qBH:TOraQuery;
begin
//if not (GetConstantValue('SERVER_NAME')='CORP_MOBILE') then exit;  //������ ��� K7
 try
 qBH:=TOraQuery.Create(nil);
    with qBH do begin
     params.CreateParam(ftString,'p_phone',ptInput);
     params.ParamByName('p_phone').Value:=FPhoneNumber;
     sql.Add('select beeline_api_pckg.phone_report_data(to_number(:p_phone)) RD from dual');
  	 Execute;
     ShowMessage(FieldByName('RD').AsString);
    end;
 finally
 qbh:=nil;
 end;


end;

procedure TShowUserStatForm.Label27Click(Sender: TObject);
 procedure Pclose(sender:TObject);
  begin
  (sender as TForm).ModalResult:=mrOk;
  //sender.Destroy;
  end;
var
fList:TForm;
Mcloselsit:TMethod;
qBH:TOraQuery;
dsBH:TDataSource;
tBH:TDBGrid;

begin
if not (GetConstantValue('SERVER_NAME')='CORP_MOBILE') then exit;  //������ ��� K7
flist:=tform.Create(ShowBillDetailsForm);
    with flist do begin
    //  FormStyle:=fsMDIChild;
      BorderStyle:=bsSingle;
      Caption:='������� ����� ���. �������� �� ������ '+FPhoneNumber;
      Position:=poScreenCenter;
      Width:=450;
      Height:=350;
    end;
qBH:=TOraQuery.Create(flist);
    with qBH do begin
     params.CreateParam(ftString,'p_phone',ptInput);
     params.ParamByName('p_phone').Value:=FPhoneNumber;
     sql.Text:='select LO.PHONE_NUMBER, DS2.DOP_STATUS_NAME, DS1.DOP_STATUS_NAME, LO.USER_LAST_UPDATED, LO.DATE_LAST_UPDATED '+
     ' from LOG_DOP_STATUS LO, contract_dop_statuses ds1,  '+#13#10+
     ' contract_dop_statuses ds2 where LO.phone_number=:p_phone and  '+#13#10+
     ' LO.DOP_STATUS_ID_NEW=DS1.DOP_STATUS_ID(+) and  '+#13#10+
     ' LO.DOP_STATUS_ID_OLD=DS2.DOP_STATUS_ID(+)  '+#13#10+
     ' ORDER BY LO.DATE_LAST_UPDATED DESC';
    end;
dsBH:=TDataSource.Create(flist);
    with dsBH do begin
    DataSet:=qBH;
    Enabled:=true;
    end;
tBH:=TDBGrid.Create(flist);
    with tBH do begin
    parent:=fList;
    DataSource:=dsBH;
    align:=alClient;
    Visible:=true;
    Mcloselsit.Code:=@pclose;
    Mcloselsit.Data:=tBH.parent;
    ReadOnly:=true;
    OnDblClick:=TNotifyEvent(Mcloselsit);
    end;
try
qBH.open;
finally
  tbh.Columns.Items[0].Title.caption:='�����';
  tbh.Columns.Items[1].Title.caption:='������ ������';
  tbh.Columns.Items[2].Title.caption:='������ �����';
  tbh.Columns.Items[3].Title.caption:='������������';
  tbh.Columns.Items[4].Title.caption:='����';

  tbh.Columns.Items[0].Width:=80;
  tbh.Columns.Items[1].Width:=80;
  tbh.Columns.Items[2].Width:=80;
  tbh.Columns.Items[3].Width:=80;
  tbh.Columns.Items[4].Width:=80;


if not qbh.Eof then
begin
fList.ShowModal;

end
else
begin
 ShowMessage('��� ������.');flist.Destroy;
end;
end;
end;

procedure TShowUserStatForm.lblAPI_LOGClick(Sender: TObject);
begin
  if FormatSQL='' then
    FormatSQL := dmShowUserSt.oqApi_log.SQL.Text;
  if dmShowUserSt.oqApi_log.Active then
    dmShowUserSt.oqApi_log.Close;
  if trunc(DpLogAPI.Date)=trunc(now) then
    TableName := 'BEELINE_SOAP_API_LOG'
  else
    TableName:='ext_'+Format('%.2d', [dayof(DpLogAPI.Date)])+'_BEELINE_SOAP_API_LOG';
  dmShowUserSt.oqApi_log.SQL.Text:=Format(FormatSQL,[TableName]);
  dmShowUserSt.oqApi_log.Open;
end;

procedure TShowUserStatForm.LblBalanceClick(Sender: TObject);
  procedure Pclose(sender:TObject);
  begin
    (sender as TForm).ModalResult:=mrOk;
    //sender.Destroy;
  end;
var fList:TForm;
    Mcloselsit:TMethod;
    qBH:TOraQuery;
    dsBH:TDataSource;
    tBH:TDBGrid;
begin
  //if not ((GetConstantValue('SERVER_NAME')='CORP_MOBILE') OR (GetConstantValue('SERVER_NAME')='GSM_CORP')) then exit;  //������ ��� K7 � ���
  flist:=tform.Create(ShowBillDetailsForm);
  with flist do begin
    //  FormStyle:=fsMDIChild;
    BorderStyle:=bsSingle;
    Caption:='������� ������� �� ������ '+FPhoneNumber;
    Position:=poScreenCenter;
    Width:=450;
    Height:=350;
  end;
  qBH:=TOraQuery.Create(flist);
  with qBH do begin
    params.CreateParam(ftString,'p_phone',ptInput);
    params.ParamByName('p_phone').Value:=FPhoneNumber;
    sql.Add('select bh.start_time, bh.end_time, bh.last_update, bh.balance from iot_balance_history bh where bh.phone_number=:p_phone');
  end;
  dsBH:=TDataSource.Create(flist);
  with dsBH do begin
    DataSet:=qBH;
    Enabled:=true;
  end;
  tBH:=TDBGrid.Create(flist);
  with tBH do begin
    parent:=fList;
    DataSource:=dsBH;
    align:=alClient;
    Visible:=true;
    Mcloselsit.Code:=@pclose;
    Mcloselsit.Data:=tBH.parent;
    ReadOnly:=true;
    OnDblClick:=TNotifyEvent(Mcloselsit);
  end;
  try
    qBH.open;
  finally
    tbh.Columns.Items[0].Title.caption:='����������';
    tbh.Columns.Items[1].Title.caption:='���������';
    tbh.Columns.Items[2].Title.caption:='��������';
    tbh.Columns.Items[3].Title.caption:='������';
    if not qbh.Eof then
    begin
    fList.ShowModal;
    end else
    begin
      ShowMessage('��� ������.');
      flist.Destroy;
    end;
  end;
end;

procedure TShowUserStatForm.LblBlueOn(Sender: TObject);
begin
  (sender as TLabel).Font.Color:=clblue;
  //������ ��� K7
  if (GetConstantValue('SERVER_NAME')='CORP_MOBILE')
    then LblBalance.ShowHint:=TRUE;
end;

procedure TShowUserStatForm.LblStateClick(Sender: TObject);
var qBH:TOraQuery;
begin
//if not (GetConstantValue('SERVER_NAME')='CORP_MOBILE') then exit;  //������ ��� K7
  try
    qBH:=TOraQuery.Create(nil);
    with qBH do begin
      params.CreateParam(ftString,'p_phone',ptInput);
      params.ParamByName('p_phone').Value:=FPhoneNumber;
      sql.Add('select beeline_api_pckg.phone_status(to_number(:p_phone)) state from dual');
      Execute;
      ShowMessage(FieldByName('state').AsString);
    end;
  finally
    qbh:=nil;
  end;
end;

procedure TShowUserStatForm.LblBlueOff(Sender: TObject);
begin
  (sender as TLabel).font.color:=clblack;
end;

procedure TShowUserStatForm.LoadDetailText;
var DetailText : String;
begin
  if True then
  begin
    dmShowUserSt.spGetPhoneDetail.ParamByName('pYEAR').AsInteger := FYear;
    dmShowUserSt.spGetPhoneDetail.ParamByName('pMONTH').AsInteger := FMonth;
    dmShowUserSt.spGetPhoneDetail.ParamByName('pPHONE_NUMBER').AsString := FPhoneNumber;
    try
      dmShowUserSt.spGetPhoneDetail.ExecProc;
      DetailText := dmShowUserSt.spGetPhoneDetail.ParamByName('RESULT').AsString;
      FDetailText := DetailText;
    except
      on E : Exception do
      begin
        DetailText := '������ .'#13#10 + E.Message;
        FDetailText := '';
      end;
    end;
    mDetailText.Lines.Text := DetailText;
  end
  else
  begin // ��� ������� !!!
    mDetailText.Lines.LoadFromFile('D:\Work\MobileTariff\Lontana\trunk\2.txt');
    FDetailText := mDetailText.Lines.Text;
  end;
end;

procedure TShowUserStatForm.LoadBillDetailText;
var DetailText : String;
begin
  dmShowUserSt.spGetPhoneBillDetail.ParamByName('pYEAR').AsInteger := FYear;
  dmShowUserSt.spGetPhoneBillDetail.ParamByName('pMONTH').AsInteger := FMonth;
  dmShowUserSt.spGetPhoneBillDetail.ParamByName('pPHONE_NUMBER').AsString := FPhoneNumber;
  try
    dmShowUserSt.spGetPhoneBillDetail.ExecProc;
    DetailText := dmShowUserSt.spGetPhoneBillDetail.ParamByName('RESULT').AsString;
    FDetailText := DetailText;
  except
    on E : Exception do
    begin
      DetailText := '������ .'#13#10 + E.Message;
      FDetailText := '';
    end;
  end;
  mDetailText.Lines.Text := DetailText;
end;

procedure TShowUserStatForm.DBMemo1Change(Sender: TObject);
begin
  btPostComments.Enabled:=true;
end;

procedure TShowUserStatForm.DBMemo2Click(Sender: TObject);
 var
 qBH:TOraQuery;
 res:string;
begin
  try
  qBH:=TOraQuery.Create(nil);
    with qBH do begin
      params.CreateParam(ftString,'p_phone',ptInput);
      params.ParamByName('p_phone').Value:=FPhoneNumber;
      sql.Add('select t.account_id,acc.login from db_loader_account_phones t, accounts acc where acc.account_id=t.account_id and t.phone_number=:p_phone');
      Execute;
      res:=FieldByName('account_id').AsString+' - '+FieldByName('login').AsString;
    end;
  finally
    qbh:=nil;
  end;
  (Sender as TDBMemo).Hint:=res;
  (Sender as TDBMemo).ShowHint:=true;
end;

function TShowUserStatForm.DecodeServiceType(const Code : String) : String;
begin
  if not dmShowUserSt.qServiceCodes.Active then
    dmShowUserSt.qServiceCodes.Open;
  if dmShowUserSt.qServiceCodes.Locate('SERVICE_CODE', Code, []) then
    Result := dmShowUserSt.qServiceCodes.FieldByName('SERVICE_NAME').AsString
  else
    Result := Code;
end;

procedure TShowUserStatForm.DsClick(Sender: TObject);
var
  cr : TCursor;
  ACaption : String;
begin
  cr := Screen.Cursor;
  Screen.Cursor := crHourGlass;
  ACaption := '����������� ������� �� ������ ' + FPhoneNumber;
  try
    ExportDBGridToExcel(ACaption,'', CRDBGrid5, False, True);
  finally
    Screen.Cursor := cr;
  end;
end;

procedure TShowUserStatForm.PageControl1Change(Sender: TObject);
var s:string;
    I: Integer;
    sumpay:Double;
    kolMonths:integer;
begin
  dmShowUserSt.qContractInfo.Close;
  dmShowUserSt.qContractInfo.Open;

  if (Sender as TPageControl).ActivePage.Name='tsRest' then
    btRefreshClick(Self);

  if not (GetConstantValue('SERVER_NAME')='CORP_MOBILE') then
    exit;  //������ ��� K7

  if (Sender as TPageControl).ActivePage.Name='tsPayments' then
  begin
    try
      sumpay:=0;
      gPayments.DataSource.DataSet.First;
      for I := 0 To gPayments.DataSource.DataSet.RecordCount-1 do
      begin
        if (gPayments.DataSource.DataSet.FieldByName('PAYMENT_DATE').AsDateTime>=StrToDate(DBText20.Caption))
          AND not (gPayments.DataSource.DataSet.FieldByName('PAYMENT_NUMBER').IsNull) then
        sumpay:=sumpay+gPayments.DataSource.DataSet.FieldByName('PAYMENT_SUM').AsFloat;
        gPayments.DataSource.DataSet.Next;
      end;
      gPayments.DataSource.DataSet.First;
      kolMonths:=MonthsBetween(StrToDate(DBText20.Caption), Now);
      if kolMonths=0 then
        kolMonths:=kolMonths+1;
      lblEveragePayments.Caption:=FloatToStrF(sumpay/kolMonths,ffNumber,15,2);
      lblItogPaym.Caption:=FloatToStrF(sumpay,ffNumber,15,2);
    except
      lblEveragePayments.Caption:='????';
      lblItogPaym.Caption:='????';
    end;
  end;

  if (Sender as TPageControl).ActivePage.Name='tsDetail' then
  begin
    dmShowUserSt.RefreshDetailSum.ParamByName('SSUBSCR').AsString:=FPhoneNumber;
    dmShowUserSt.RefreshDetailSum.ParamByName('SMONTH').AsDate:=now;
    try
      dmShowUserSt.RefreshDetailSum.ExecProc;
    finally
      dmShowUserSt.RefreshDetailSum.ParamByName('SSUBSCR').Clear;
      dmShowUserSt.qPeriods.Refresh;
    end;
    qexcept1:=TOraQuery.Create(nil);
    with qexcept1 do
    begin
      SQL.Add('select t.TYPE_VISIBILITY from DETAIL_HIDE_PHONES t where t.phone_number='+FPhoneNumber);
      SQLInsert.Text:='insert into DETAIL_HIDE_PHONES(PHONE_NUMBER,TYPE_VISIBILITY) values ('+FPhoneNumber+',1)';
      SQLDelete.Text:='delete DETAIL_HIDE_PHONES where PHONE_NUMBER='+FPhoneNumber;
      //SQLUpdate.Text:='update DETAIL_HIDE_PHONES set TYPE_VISIBILITY=0 where phone_number='+FPhoneNumber+' and TYPE_VISIBILITY=1';
      SQLRefresh.Text:=SQL.Text;
      Execute;
      if (FieldByName('TYPE_VISIBILITY').AsInteger=1) and not (cb_Hide_detail.Checked) then
      begin
        cbexcept1:=-1;
        cb_Hide_detail.State:=cbChecked;
        dbgDetail.Visible:=false;
        btUnload.Visible:=false;
        BitBtn2.Visible:=false;
        btSendMail.Visible:=false;
        BUnbilledCallsList.Visible:=False;
      end
      else if (FieldByName('TYPE_VISIBILITY').AsInteger=0) and (cb_Hide_detail.Checked) then
      begin
        cbexcept1:=-1;
        cb_Hide_detail.State:=cbUnchecked;
        dbgDetail.Visible:=true;
        btUnload.Visible:=true;
        BitBtn2.Visible:=true;
        btSendMail.Visible:=true;
        BUnbilledCallsList.Visible:=True;
      end;
    end;
  end;

  if (Sender as TPageControl).ActivePage.Name='tsDopInfo' then
  begin
    DpLogAPI.MaxDate:= trunc(now);
    DpLogAPI.MinDate:=trunc(now)-DaysInMonth(now);
  end;
end;

procedure TShowUserStatForm.PrepareDetail;
var
  i : Integer;
  sl : TStringList;
  s : String;
  Line : String;
  CostNoVatStr: string;
  duration:double;
  Service_type:String;
begin
  try
    sl := TStringList.Create;
    dmShowUserSt.vtDetailFile.DisableControls;
    try
      sl.Text := FDetailText;
      if not dmShowUserSt.vtDetailFile.Active then
        dmShowUserSt.vtDetailFile.Open
      else
        dmShowUserSt.vtDetailFile.Clear;
      for i := 0 to sl.Count-1 do
      begin
        Line := sl[i];
        if GetTokenCount(Line) >= 11 then
        begin
          dmShowUserSt.vtDetailFile.Append;
          dmShowUserSt.vtDetailFile.FieldByName('SELF_NUMBER').AsString := Copy(GetToken(Line, 1), 1, 20);
          dmShowUserSt.vtDetailFile.FieldByName('SERVICE_DATE').AsDateTime := StrToDate(GetToken(Line, 2));
          dmShowUserSt.vtDetailFile.FieldByName('SERVICE_TIME').AsDateTime := StrToTime(GetToken(Line, 3));
          Service_type:=GetToken(Line, 4);
          dmShowUserSt.vtDetailFile.FieldByName('SERVICE_TYPE').AsString := DecodeServiceType(Service_type);
          s := GetToken(Line, 5);
          if s = '1' then
            s := '���������'
          else if s = '2' then
            s := '��������'
          else if s = '3' then
            s := '�������������'
          else
            s := '������������';
          dmShowUserSt.vtDetailFile.FieldByName('SERVICE_DIRECTION').AsString := s;
          dmShowUserSt.vtDetailFile.FieldByName('OTHER_NUMBER').AsString := Copy(GetToken(Line, 6), 1, 20);
          duration:=StrToFloat2(GetToken(Line, 7));
          dmShowUserSt.vtDetailFile.FieldByName('DURATION').AsFloat := duration;
          //��������� �� ����� ������������, ������ ��� ���� ������ - "������"
          if Service_type='C' then
            //������ ��� ������� �� ��������������
            if duration<=2 then
              dmShowUserSt.vtDetailFile.FieldByName('DURATION_MIN').AsInteger := 0
            else
              dmShowUserSt.vtDetailFile.FieldByName('DURATION_MIN').AsInteger := Ceil(duration/60);

          dmShowUserSt.vtDetailFile.FieldByName('SERVICE_COST').AsFloat := StrToFloat2(GetToken(Line, 8));
          if GetToken(Line, 9) = '1' then
            s := '��'
          else
            s := '';
          dmShowUserSt.vtDetailFile.FieldByName('IS_ROAMING').AsString := s;
          dmShowUserSt.vtDetailFile.FieldByName('ROAMING_ZONE').AsString := Copy(GetToken(Line, 10), 1, 50);
          dmShowUserSt.vtDetailFile.FieldByName('ADD_INFO').AsString := Copy(GetToken(Line, 11), 1, 100);
          dmShowUserSt.vtDetailFile.FieldByName('BASE_STATION_CODE').AsString := Copy(GetToken(Line, 12), 1, 10);
          // ��������� ��� ��� ���� �������, � ���� � ���, �� ������������
          CostNoVatStr := GetToken(Line, 13);
          if CostNoVATStr = '' then
            CostNoVatStr := FloatToStr(dmShowUserSt.vtDetailFile.FieldByName('SERVICE_COST').AsFloat / 1.18);
          dmShowUserSt.vtDetailFile.FieldByName('COST_NO_VAT').AsFloat := StrToFloat2(CostNoVatStr);
          s:=Copy(GetToken(Line, 14), 1, 50);
          if (s='') and (IS_BS_CHECK.Checked)  then
            if Copy(GetToken(Line, 12), 1, 10)<>'' then
            begin
              dmShowUserSt.qBaseZone.ParamByName('bzone').AsInteger := strtoint(Copy(GetToken(Line, 12), 1, 10));
              dmShowUserSt.qBaseZone.ExecSQL;
              s:= dmShowUserSt.qBaseZone.FieldByName('ZONE_NAME').AsString ;
  //            qBaseZone.Close;
            end;


          //
          dmShowUserSt.vtDetailFile.FieldByName('BS_PLACE').AsString := s;

          dmShowUserSt.vtDetailFile.Post;
        end;
      end;
      dmShowUserSt.vtDetailFile.First;
    finally
      dmShowUserSt.vtDetailFile.EnableControls;
      FreeAndNil(sl);
    end;
  except
    on E : Exception do
      ShowMessage('������ ��������� �����������. '+E.Message);
  end;
end;

procedure TShowUserStatForm.AddFilter;
begin
  if cbHideZeroCall.Checked then
  begin
    dmShowUserSt.vtDetailFile.Filter:='SERVICE_COST<>"0" AND SERVICE_DATE >=''' +FormatDateTime('DD.MM.YYYY',dtBegin.Date)+''' AND SERVICE_DATE <=''' +FormatDateTime('DD.MM.YYYY',dtEnd.Date)+'''';
    dmShowUserSt.vtDetailFile.Filtered:=true;
    dmShowUserSt.qHBDetails.Filter:='SERVICE_COST<>"0" AND SERVICE_DATE >=''' +FormatDateTime('DD.MM.YYYY',dtBegin.Date)+''' AND SERVICE_DATE <=''' +FormatDateTime('DD.MM.YYYY',dtEnd.Date)+'''';
    dmShowUserSt.qHBDetails.Filtered:=true;
  end
  else
  begin
    dmShowUserSt.vtDetailFile.Filter:='SERVICE_DATE >=''' +FormatDateTime('DD.MM.YYYY',dtBegin.Date)+''' AND SERVICE_DATE <=''' +FormatDateTime('DD.MM.YYYY',dtEnd.Date)+'''';
    dmShowUserSt.vtDetailFile.Filtered:=false;
    dmShowUserSt.qHBDetails.Filter:='SERVICE_DATE >=''' +FormatDateTime('DD.MM.YYYY',dtBegin.Date)+''' AND SERVICE_DATE <=''' +FormatDateTime('DD.MM.YYYY',dtEnd.Date)+'''';
    dmShowUserSt.qHBDetails.Filtered:=true;
  end;
 //vtDetailFile.Filter:='SERVICE_DATE >=''' +FormatDateTime('DD.MM.YYYY',dtBegin.Date)+''' AND SERVICE_DATE <=''' +FormatDateTime('DD.MM.YYYY',dtEnd.Date)+'''';
 //vtDetailFile.Filtered := True;
 //qHBDetails.Filter:='SERVICE_DATE >=''' +FormatDateTime('DD.MM.YYYY',dtBegin.Date)+''' AND SERVICE_DATE <=''' +FormatDateTime('DD.MM.YYYY',dtEnd.Date)+'''';
 //qHBDetails.Filtered := True;
end;

procedure TShowUserStatForm.aLinkPaymentExecute(Sender: TObject);
begin
  if FManualPaymentManagement then
  begin
    if dmShowUserSt.qPayments.IsEmpty then
      // Nothing
    else if FContractID = 0 then
      ShowMessage('������� �� ���������������, ���������� ����� ������.')
    else if dmShowUserSt.qPayments.FieldByName('PAYMENT_TYPE').AsInteger <> PAYMENT_TYPE_LOADED then
      ShowMessage('���� ����� ����� �������, �������� ��� ������.')
    else if (dmShowUserSt.qPayments.FieldByName('PAYMENT_DATE').AsDateTime >= FContractDate-DAYS_PAYMENT_BEFORE_CONTRACT)
    and (dmShowUserSt.qPayments.FieldByName('PAYMENT_DATE').AsDateTime <= dmShowUserSt.qContractInfo.FieldByName('CONTRACT_CANCEL_DATE').AsDateTime) then
      ShowMessage('����� ���� �������������, ���������� ��� �������� ������.')
     else if (dmShowUserSt.qPayments.FieldByName('PAYMENT_DATE').AsDateTime >= FContractDate-DAYS_PAYMENT_BEFORE_CONTRACT)
    and (dmShowUserSt.qPayments.FieldByName('PAYMENT_DATE').AsDateTime > dmShowUserSt.qContractInfo.FieldByName('CONTRACT_CANCEL_DATE').AsDateTime)
    then
//      ShowMessage('����� �������� ����� ���� �������� ���������, ���������� ��� ������. ��� ������������ ���������� �������� ���� �������� ���������.',mtInfo)
    MessageDlg('����� �������� ����� ���� �������� ���������, ���������� ��� ������. ��� ������������ ���������� �������� ���� ����������� ������ (���������� � ��������������).', mtWarning, [mbOk], 0)

    else if dmShowUserSt.qPayments.FieldByName('CONTRACT_ID').AsInteger = FContractID then
      ShowMessage('����� ��� ���������.')
    else if not dmShowUserSt.qPayments.FieldByName('CONTRACT_ID').IsNull
      and (IDYES <> Application.MessageBox('����� ��� ��������� � ������� ��������. ���������?', '������������', IDYES or IDNO)) then
      // Nothing
    else
    begin
      dmShowUserSt.qLinkPayment.ParamByName('PHONE_NUMBER').AsString := FPhoneNumber;
      if dmShowUserSt.qPayments.FieldByName('PAYMENT_NUMBER').IsNull then
       dmShowUserSt.qLinkPayment.ParamByName('PAYMENT_NUMBER').Value := null
      else
       dmShowUserSt.qLinkPayment.ParamByName('PAYMENT_NUMBER').AsString := dmShowUserSt.qPayments.FieldByName('PAYMENT_NUMBER').AsString;
      dmShowUserSt.qLinkPayment.ParamByName('PAYMENT_SUM').AsFloat := dmShowUserSt.qPayments.FieldByName('PAYMENT_SUM').AsFloat;
      dmShowUserSt.qLinkPayment.ParamByName('CONTRACT_ID').AsInteger := FContractID;
      dmShowUserSt.qLinkPayment.ExecSQL;
      dmShowUserSt.qPayments.Refresh;
      dmShowUserSt.qTariffInfo.Refresh;
      RefreshBalanceRows;
    end;
  end;
end;

procedure TShowUserStatForm.aUnlinkPaymentExecute(Sender: TObject);
begin
  if FManualPaymentManagement then
  begin
    if dmShowUserSt.qPayments.IsEmpty then
      // Nothing
    else if FContractID = 0 then
      ShowMessage('������� �� ���������������, ��������� ����� ������.')
    else if dmShowUserSt.qPayments.FieldByName('PAYMENT_TYPE').AsInteger <> PAYMENT_TYPE_LOADED then
      ShowMessage('����� ����� �������, ��������� ��� ������.')
    else if (dmShowUserSt.qPayments.FieldByName('PAYMENT_DATE').AsDateTime >= FContractDate-DAYS_PAYMENT_BEFORE_CONTRACT)
    and (dmShowUserSt.qPayments.FieldByName('PAYMENT_DATE').AsDateTime <= dmShowUserSt.qContractInfo.FieldByName('CONTRACT_CANCEL_DATE').AsDateTime) then
      ShowMessage('����� ���� �������������, ��������� ��� ������.')
    else if dmShowUserSt.qPayments.FieldByName('CONTRACT_ID').IsNull or (dmShowUserSt.qPayments.FieldByName('CONTRACT_ID').AsInteger <> FContractID) then
      ShowMessage('����� �� ��������� � ��������.')
      // Nothing (��� ���������)
    else
    begin
      dmShowUserSt.qLinkPayment.ParamByName('PHONE_NUMBER').AsString := FPhoneNumber;
      if dmShowUserSt.qPayments.FieldByName('PAYMENT_NUMBER').IsNull then
       dmShowUserSt.qLinkPayment.ParamByName('PAYMENT_NUMBER').Value := null
      else
       dmShowUserSt.qLinkPayment.ParamByName('PAYMENT_NUMBER').AsString := dmShowUserSt.qPayments.FieldByName('PAYMENT_NUMBER').AsString;
      dmShowUserSt.qLinkPayment.ParamByName('PAYMENT_SUM').AsFloat := dmShowUserSt.qPayments.FieldByName('PAYMENT_SUM').AsFloat;
      dmShowUserSt.qLinkPayment.ParamByName('CONTRACT_ID').Clear;
      dmShowUserSt.qLinkPayment.ExecSQL;
      dmShowUserSt.qPayments.Refresh;
      dmShowUserSt.qTariffInfo.Refresh;
      RefreshBalanceRows;
    end;
  end;
end;

procedure TShowUserStatForm.aAddPaymentExecute(Sender: TObject);
var
  RegisterPaymentForm : TRegisterPaymentForm;
begin
  if FManualPaymentManagement then
  begin
    RegisterPaymentForm := TRegisterPaymentForm.Create(nil);
    try
      // ���� �� ������, �� ��� ������ ������ ���� ��������� �� ������
      if FContractId = 0
        then    // ����� ��� ��������
        begin
          MainForm.CheckAdminPrivileges;
          if RegisterPaymentForm.PrepareFormNoContract('INSERT', FPhoneNumber, Null, FContractId) then
          begin
            RegisterPaymentForm.qReceivedPayments.FieldByName('FILIAL_ID').Value := FFilialId;
            if (mrOk = RegisterPaymentForm.ShowModal) then
            begin
              dmShowUserSt.qPayments.Refresh;
              dmShowUserSt.qTariffInfo.Refresh;
              RefreshBalanceRows;
            end;
          end
        end
        else    // ����� � ���������
          if RegisterPaymentForm.PrepareForm('INSERT', Null, FContractId) then
          begin
            RegisterPaymentForm.qReceivedPayments.FieldByName('FILIAL_ID').Value := FFilialId;
            if (mrOk = RegisterPaymentForm.ShowModal) then
            begin
              dmShowUserSt.qPayments.Refresh;
              dmShowUserSt.qTariffInfo.Refresh;
              RefreshBalanceRows;
            end;
          end;
    finally
      RegisterPaymentForm.Free;
    end;
  end;
end;

procedure TShowUserStatForm.dsTariffInfoDataChange(Sender: TObject;
  Field: TField);
var
  AText : String;
  AFontColor : TColor;
  Balance : Double;
  str:string;
  stri:integer;
  qContrClos:TORaQuery;
begin
  // ������
  if dmShowUserSt.qTariffInfo.EOF then
  begin
    AText := '��� ������';
    AFontColor := clWindowText;
  end
  else if dmShowUserSt.qTariffInfo.FieldByName('PHONE_IS_ACTIVE').AsInteger = 0 then
  begin
    AText := '����������';
    AFontColor := clRed;
  end
  else
  begin
    AText := '��������';
    AFontColor := clGreen;
  end;
  if not(dmShowUserSt.qTariffInfo.FieldByName('STATUS_CODE').IsNull) then
    AText:=AText + ' (' + dmShowUserSt.qTariffInfo.FieldByName('STATUS_CODE').AsString + ')';
  if not(dmShowUserSt.qTariffInfo.FieldByName('INFO_COLOR').IsNull) then
    case AnsiIndexStr(dmShowUserSt.qTariffInfo.FieldByName('INFO_COLOR').AsString,
                      ['Red', 'Green', 'Yellow', 'Purple']) of
      0: AFontColor:=clRed;
      1: AFontColor:=clGreen;
      2: AFontColor:=RGB(213,213,0); //clYellow; //������ ��������
      3: AFontColor:=clPurple;
      else AFontColor:=clBlack;
    end;
  lTariffStatusText.Caption := AText;
  lTariffStatusText.Font.Color := AFontColor;

  // ������
  if dmShowUserSt.qTariffInfo.EOF then
  begin
    AText := '???';
    AFontColor := clWindowText;
  end
  else
  begin
    Balance := dmShowUserSt.qTariffInfo.FieldByName('CURRENT_BALANCE').AsFloat;
    AText := FloatToStrF(Balance, ffNumber, 15, 2);
    if Balance  < 0 then
      AFontColor := clRed
    else
      AFontColor := clWindowText;
  end;
  lBalance.Caption := AText;
  lBalance.Font.Color := AFontColor;

  // ������
  if dmShowUserSt.qTariffInfo.EOF then
  begin
    AText := '��� ������';
    AFontColor := clWindowText;
  end
  else
    if dmShowUserSt.qTariffInfo.FieldByName('CONSERVATION').AsInteger = 1 then
    begin
      if dmShowUserSt.qTariffInfo.FieldByName('SYSTEM_BLOCK').AsInteger = 1 then
      begin
        AText := '�������������';
        AFontColor := clRed;
      end
      else begin
        AText := '�� ����������';
        afontColor := clGreen;
      end
    end
    else if dmShowUserSt.qBlocked.FieldByName('BLOCKED').AsInteger <> 0 then
    begin
      atext := '���������� �� �������������';
      afontColor := clRed;
    end
    else
    begin
      atext := '�� �� ����������';
      afontColor := clblack;
    end;
    lBlockInfo.Caption := atext;
    lBlockInfo.Font.Color := afontColor;

    // ��� ������������ ������� ���������� ������� ���������
    if ((dmShowUserSt.qTariffInfo.FieldByName('IS_COLLECTOR_BAN').AsInteger = 1) and (GetConstantValue('SHOW_FEATURE_PHONE_ISCOLLECTOR') = '1')) then
      lbl_IS_COLLECTOR.Visible := True
    else
      lbl_IS_COLLECTOR.Visible := False;

    // ������ ��������
    if dmShowUserSt.qTariffInfo.Eof then
      begin
        atext := '��� ������';
        afontColor := clWindowText;
        lCloseNumber.Visible := false;
      end
    else
    begin
      lCloseNumber.Visible := true;
      str := datetostr(Date);
      stri := strtoint(Copy(str, 7, 4) + Copy(str, 4, 2));
      if dmShowUserSt.qTariffInfo.FieldByName('YEAR_MONTH').AsInteger <> stri then
        atext := '����� ����������'
      else
      begin
        qContrClos := TOraQuery.Create(Self);
{          qContrClos.SQL.Text :=
            'Select  to_char(contract_date,''dd.mm.yyyy'') as pp, nvl(is_credit_contract,0) cc FROM v_contracts'
            + #13#10 + 'WHERE  CONTRACT_CANCEL_DATE is null' + #13#10 +
            'and (PHONE_NUMBER_FEDERAL=:phoneNumber  or  PHONE_NUMBER_CITY=substr(:phoneNumber,-7))';}
          //19610
        qContrClos.SQL.Text :=
          'Select  to_char(contract_date,''dd.mm.yyyy'') as pp, nvl(is_credit_contract,0) cc FROM v_contracts'
          + #13#10 + 'WHERE  CONTRACT_CANCEL_DATE is null' + #13#10 ;
          //19610  begin
        if dmShowUserSt.qTariffInfo.FieldByName('PHONE_NUMBER_TYPE').AsInteger=1 then
          qContrClos.SQL.Text:=qContrClos.SQL.Text+' and (PHONE_NUMBER_FEDERAL=:phoneNumber  or  PHONE_NUMBER_CITY=substr(:phoneNumber,-7))'
        else
          qContrClos.SQL.Text:=qContrClos.SQL.Text+' and PHONE_NUMBER_FEDERAL=:phoneNumber';
            //19610  end
        qContrClos.ParamByName('phoneNumber').AsString := FPhoneNumber;
        qContrClos.ExecSQL;
        if qContrClos.FieldByName('pp').IsNull then
          atext := '������� ����������'
        else
          with lCloseNumber do
          begin
            atext := '��������';
            Visible:=True;
            Font.Color:=clBlue;
          end;
        if qContrClos.FieldByName('cc').AsInteger > 0 then
        begin
          ContractType.Caption := '���������';
          ContractType.Visible := true;
        end
        else
          ContractType.Visible := false;
        FreeAndNil(qContrClos);
      end;
    end;
    lCloseNumber.Caption := atext;
end;

procedure TShowUserStatForm.EditAbonentFrameAPARTMENTChange(Sender: TObject);
begin
  EditAbonentFrame.DoChange(Sender);
end;

procedure TShowUserStatForm.EditAbonentFrameBDATEChange(Sender: TObject);
begin
  EditAbonentFrame.BDATEChange(Sender);
end;

procedure TShowUserStatForm.EditAbonentFrameCITIZENSHIPClick(Sender: TObject);
begin
  EditAbonentFrame.DoChange(Sender);
end;

procedure TShowUserStatForm.EditAbonentFrameCITY_NAMEChange(Sender: TObject);
begin
  EditAbonentFrame.DoChange(Sender);
end;

procedure TShowUserStatForm.EditAbonentFrameCODE_WORDChange(Sender: TObject);
begin
  EditAbonentFrame.DoChange(Sender);
end;


procedure TShowUserStatForm.EditAbonentFrameCONTACT_INFOChange
    (Sender: TObject);
begin
  EditAbonentFrame.DoChange(Sender);
end;


procedure TShowUserStatForm.EditAbonentFrameCOUNTRY_IDClick(Sender: TObject);
begin
  EditAbonentFrame.DoChange(Sender);
end;


procedure TShowUserStatForm.EditAbonentFrameEMAILChange(Sender: TObject);
begin
  EditAbonentFrame.DoChange(Sender);
end;

procedure TShowUserStatForm.EditAbonentFrameHOUSEChange(Sender: TObject);
begin
  EditAbonentFrame.DoChange(Sender);
end;

procedure TShowUserStatForm.EditAbonentFrameIS_VIPClick(Sender: TObject);
begin
  EditAbonentFrame.DoChange(Sender);
end;

procedure TShowUserStatForm.EditAbonentFrameKORPUSChange(Sender: TObject);
begin
  EditAbonentFrame.DoChange(Sender);
end;

procedure TShowUserStatForm.EditAbonentFrameNAMEChange(Sender: TObject);
begin
  EditAbonentFrame.DoChange(Sender);
end;

procedure TShowUserStatForm.EditAbonentFramePASSPORT_DATEChange(Sender: TObject);
begin
  EditAbonentFrame.BDATEChange(Sender);
end;

procedure TShowUserStatForm.EditAbonentFramePASSPORT_GETChange(Sender: TObject);
begin
  EditAbonentFrame.DoChange(Sender);
end;

procedure TShowUserStatForm.EditAbonentFramePASSPORT_NUMChange(Sender: TObject);
begin
  EditAbonentFrame.DoChange(Sender);
end;

procedure TShowUserStatForm.EditAbonentFramePASSPORT_SERChange(Sender: TObject);
begin
  EditAbonentFrame.DoChange(Sender);
end;

procedure TShowUserStatForm.EditAbonentFramePATRONYMICChange(Sender: TObject);
begin
  EditAbonentFrame.DoChange(Sender);
end;

procedure TShowUserStatForm.EditAbonentFrameREGION_IDClick(Sender: TObject);
begin
  EditAbonentFrame.DoChange(Sender);
end;

procedure TShowUserStatForm.EditAbonentFrameSTREET_NAMEChange(Sender: TObject);
begin
  EditAbonentFrame.DoChange(Sender);
end;

procedure TShowUserStatForm.EditAbonentFrameSURNAMEChange(Sender: TObject);
begin
  EditAbonentFrame.DoChange(Sender);
end;

procedure TShowUserStatForm.EditAbonentFrameToolButton1Click(Sender: TObject);
begin
  EditAbonentFrame.aFindAbonentExecute(Sender);
end;

function TShowUserStatForm.EditcbDailyAbonPayBanned: Boolean;
begin
  if GetConstantValue('SERVER_NAME')='GSM_CORP' then
    Result := (LowerCase(MainForm.FUser) = LowerCase('MATVEEVNS'))
        or (LowerCase(MainForm.FUser) = LowerCase('ADMIN'))
  else
    Result := True;
end;

procedure TShowUserStatForm.eNewBlockHBKeyPress(Sender: TObject; var Key: Char);
begin
 if not(((key>=#48)and(key<=#57))or(key=#45)or(key=#189)or(key=#46)or(key=#8)) then key:=#0;
end;

procedure TShowUserStatForm.eNewNoticeHBKeyPress(Sender: TObject;
  var Key: Char);
begin
 if not(((key>=#48)and(key<=#57))or(key=#45)or(key=#189)or(key=#46)or(key=#8)) then key:=#0;
end;

procedure TShowUserStatForm.eSetPasswordKeyPress(Sender: TObject;
  var Key: Char);
begin
  if ord(Key)=VK_RETURN then
    BtSetPasswordOk.Click;
end;

function TShowUserStatForm.CheckDate: boolean;
 var
  tempS:string;
begin
  result:=true;
  tempS:=Format('%s%.2d%s%s' ,['01.', dmShowUserSt.qPeriods.FieldByName('MONTH').AsInteger,'.', dmShowUserSt.qPeriods.FieldByName('YEAR').AsString]);
  if not((dtBegin.Date>=Strtodate(tempS)) and (dtBegin.Date<=EndOfTheMonth(Strtodate(tempS)))) then
  begin
  //and FormatDateTime('DD.MM.YYYY',dtBegin.Date)<=EndOfTheMonth(StrToDate('01.'+inttostr(AMonth)+'.'+inttostr(AYear))) then begin
    ShowMessage('������ �������� ��������� ����.');
    result:=false;
  end;
  if not((dtEnd.Date>=Strtodate(tempS)) and (dtEnd.Date<=EndOfTheMonth(Strtodate(tempS)))) then
  begin
  //and FormatDateTime('DD.MM.YYYY',dtBegin.Date)<=EndOfTheMonth(StrToDate('01.'+inttostr(AMonth)+'.'+inttostr(AYear))) then begin
    ShowMessage('������ �������� �������� ����.');
    result:=false;
  end;
end;

procedure TShowUserStatForm.CRDBGrid2CellClick(Column: TColumn);
var Line:string;
    YearMonth:Integer;
    vRecNo:integer;
begin
//  Line:=CRDBGrid2.Columns[0].Field.AsString;
//  qServiceVolumeCheck.Close;
//  qServiceVolumeCheck.ParamByName('opt_code').AsString := Line;
//  qServiceVolumeCheck.Open;
//  Line := datetostr(date);
//  if qServiceVolumeCheck.FieldByName('csr').AsInteger<>0 then
//  begin
//    YearMonth:=StrToInt(Copy(Line, Length(Line)-3,4))*100+StrToInt(Copy(Line, Length(Line)-6,2));
//    DoShowBillDetails(FPhoneNumber, YearMonth, CRDBGrid2.Columns[0].Field.AsString,'SERVICE');
//  end;
//
//  //19610
//   if CRDBGrid2.Col=5   then
//  old_date:=CRDBGrid2.SelectedField.AsString
//  else  old_date:='';
//
//     vRecNo:=qOptions.RecNo;
//
// if old_date<>'' then
//    begin
//      qOptions.Close;
//      qOptions.CachedUpdates:=true;
//      qOptions.ReadOnly:=False;
//      CRDBGrid2.ReadOnly:=False;
//      qOptions.Open;
//      qOptions.RecNo:=vRecNo;
//      CRDBGrid2.EditorMode:=True;
//      CRDBGrid2.Options:=CRDBGrid2.Options+[dgEditing];
//      qOptions.Edit;
//    end
//      else begin
//          qOptions.Close;
//          qOptions.CachedUpdates:=false;
//          qOptions.ReadOnly:=true;
//          CRDBGrid2.ReadOnly:=true;
//          qOptions.Open;
//          CRDBGrid2.Options:=CRDBGrid2.Options-[dgEditing];
//          CRDBGrid2.EditorMode:=False;
//            end;

end;

procedure TShowUserStatForm.CRDBGrid2ColEnter(Sender: TObject);
begin
 //19610
// if (old_date <> '') and (old_date<>CRDBGrid2.SelectedField.AsString) then begin
//MainForm.CheckAdminPrivileges;
//  qOptions.Post;
//  qOptions.ApplyUpdates;
//  qOptions.close;
//  qOptions.Open;
//end;
end;

procedure TShowUserStatForm.CRDBGrid2DblClick(Sender: TObject);
begin
  TurnOnOffOption(FPhoneNumber, 'D', dmShowUserSt.qOptions.FieldByName('OPTION_CODE').AsString );
  dmShowUserSt.qAPIOptionHistory.Close;
  dmShowUserSt.qAPIOptionHistory.Open;
end;

procedure TShowUserStatForm.CRDBGrid2GetCellParams(Sender: TObject;
  Field: TField; AFont: TFont; var Background: TColor; State: TGridDrawState;
  StateEx: TGridDrawStateEx);
begin
  if (dmShowUserSt.qOptions.FieldByName('TURN_OFF_DATE').IsNull) or (dmShowUserSt.qOptions.FieldByName('TURN_OFF_DATE').AsDateTime > Now) then
    AFont.Color := clBlack
  else
    AFont.Color := clGray;
end;

procedure TShowUserStatForm.CRDBGridOptionHistoryGetCellParams(Sender: TObject;
  Field: TField; AFont: TFont; var Background: TColor; State: TGridDrawState;
  StateEx: TGridDrawStateEx);
var Answer, Types: string;
begin
  Answer := dmShowUserSt.qAPIOptionHistory.FieldByName('ANSWER').AsString;
  Types := dmShowUserSt.qAPIOptionHistory.FieldByName('INCLUSION_TYPE').AsString;
  if Answer='���������' then
  begin
    if Types='�����������' then
      AFont.Color:= $004000
    else if Types='����������' then
      AFont.Color:=clMaroon
    else
      AFont.Color:=clRed
  end
  else
    if Answer='��������' then
      AFont.Color:=clRed
    else
      AFont.Color:=$404040;
end;

procedure TShowUserStatForm.CRDBGrid4GetCellParams(Sender: TObject;
  Field: TField; AFont: TFont; var Background: TColor;
  State: TGridDrawState; StateEx: TGridDrawStateEx);
begin
  if Field.FieldName = 'BILL_SUM' then
    AFont.Style := [fsBold];
end;

procedure TShowUserStatForm.CRDBGrid5CellClick(Column: TColumn);
var Line:string;
    YearMonth:Integer;
begin
  Line:=CRDBGrid5.Columns[3].Field.AsString;
  if Pos('����', Line)>0 then
  begin
    YearMonth:=StrToInt(Copy(Line, Length(Line)-3,4)+Copy(Line, Length(Line)-6,2));
    DoShowBillDetails(FPhoneNumber, YearMonth, CRDBGrid5.Columns[3].Field.AsString,'BILL');
  end;
end;

procedure TShowUserStatForm.dbgAPI_LOGDblClick(Sender: TObject);
  procedure Pclose(sender:TObject);
  begin
    (sender as TForm).ModalResult:=mrOk;
  //sender.Destroy;
  end;
var fList:TForm;
    Mcloselsit:TMethod;
    qBH:TOraQuery;
    dsBH:TDataSource;
    tBH:TDBMemo;
    q_num:integer;
begin
  if (not dmShowUserSt.oqApi_log.Active) or (dmShowUserSt.oqApi_log.RecordCount<1) then exit;
  //if GetConstantValue('')<>'1' then exit;
  flist:=tform.Create(self);
  with flist do
  begin
  //  FormStyle:=fsMDIChild;
    BorderStyle:=bsSingle;
    Caption:='�������� ���� ������\����� ��� (����������� � �����)';
    Position:=poScreenCenter;
    Width:=760;
    Height:=540;
  end;

  qBH:=TOraQuery.Create(flist);
  with qBH do
  begin
    /////////������ � ���
    sql.Clear;
    Params.Clear;
    Params.CreateParam(ftString,'q_num',ptInput);
    params.ParamByName('q_num').Value:= dmShowUserSt.oqApi_log.FieldByName('bsal_id').AsString;
    if TableName='BEELINE_SOAP_API_LOG' then
      sql.Add('select to_clob(''----������---- ''||chr(13)||soap_request||chr(13)||''----�����----''||chr(13))||t.soap_answer.getclobval() API_STR'+
              ' from '+TableName+' t '+
              ' where t.bsal_id=:q_num')
    else
      sql.Add('select to_clob(''----������---- ''||chr(13)||soap_request||chr(13)||''----�����----''||chr(13))||t.soap_answer API_STR'+
            ' from '+TableName+' t '+
            ' where t.bsal_id=:q_num');
  end;

  dsBH:=TDataSource.Create(flist);

  with dsBH do
  begin
    DataSet:=qBH;
    Enabled:=true;
  end;
  tBH:=TDBMemo.Create(flist);
  with tBH do
  begin
    parent:=fList;
    DataSource:=dsBH;
    DataField:='API_STR';
    align:=alClient;
    Visible:=true;
    Mcloselsit.Code:=@pclose;
    Mcloselsit.Data:=tBH.Parent;
    ReadOnly:=true;
    OnDblClick:=TNotifyEvent(Mcloselsit);
    Hint:='������� ����, ����� �������';
    ShowHint:=true;
  end;
  try
    qBH.open;
  finally
    tbh.SelectAll;
    tbh.CopyToClipboard;
  end;
  if not qbh.Eof then
    fList.ShowModal
  else
    ShowMessage('��� ������.');flist.Destroy;
end;

procedure TShowUserStatForm.aOpenDetailInExcelExecute(Sender: TObject);
var
  cr : TCursor;
  ACaption : String;
  ANameFile : string;
  grid : TCRDBGrid;
begin
  cr := Screen.Cursor;
  Screen.Cursor := crHourGlass;

  if PageControl1.ActivePage = tsRest then
  begin
    grid := gRest;
    ACaption := '������� ������� �� ������ ' + FPhoneNumber +
                ' �� ' + FormatDateTime('dd.mm.yyyy hh:nn:ss', Now);
    ANameFile := FPhoneNumber + '_Rest_' + FormatDateTime('ddmmyyyyhhnnss', Now);
  end
  else
  begin
    grid := dbgDetail;
    ACaption := '����������� �� ������ '
      + FPhoneNumber
      + ' �� '
      + dmShowUserSt.qPeriods.FieldByName('MONTH').AsString
      + ' - '
      + dmShowUserSt.qPeriods.FieldByName('YEAR').AsString;
    ANameFile:=FPhoneNumber+'_Detail_'+dmShowUserSt.qPeriods.FieldByName('YEAR').AsString+'_'
                +dmShowUserSt.qPeriods.FieldByName('MONTH').AsString+'_';
  end;
  try
  //  ExportDBGridToExcel(ACaption,ANameFile,
   //   dbgDetail, False, True);
    if (GetConstantValue('SERVER_NAME') = 'GSM_CORP') then
      ExportDBGridAndShow(ACaption, '', ANameFile, grid, True)
    else
      ExportDBGrid(ACaption, '', ANameFile, grid, True,True);
  finally
    Screen.Cursor := cr;
  end;
end;

procedure TShowUserStatForm.aSaveDetailExecute(Sender: TObject);
  var
  cr : TCursor;
  ACaption,ANote:string;
  ANameFile : string;
  Qlog_writer: TOraQuery;
  vPaymentSum :integer;
  vFillialId:integer;
  vRemark:string;
  tempStr:string;
//  VBODY : TStringList;
begin
//���������� � �������� Excel
  if CheckDate=false then exit;
  AddFilter;
  cr := Screen.Cursor;
  Screen.Cursor := crHourGlass;
  if IS_BILL_CHECK.Checked then
    ANote := ''
  else
    ANote := '*��������������� ���������� ����� ���������� �� ����������� �� �������� ����������� ������.';
  ACaption := '����������� �� ������ '
      + FPhoneNumber
      + ' �� '
      + dmShowUserSt.qPeriods.FieldByName('MONTH').AsString
      + ' - '
      + dmShowUserSt.qPeriods.FieldByName('YEAR').AsString;
    ANameFile:=FPhoneNumber+'_Detail_'+dmShowUserSt.qPeriods.FieldByName('YEAR').AsString+'_'+dmShowUserSt.qPeriods.FieldByName('MONTH').AsString+'_';
   try
    if FileExists(ANameFile+'.xltx') then
     DeleteFile(ANameFile+'.xltx');
   except
     ShowMessage('������ ��� �������� ����� '+ANameFile+'.xltx');
   end;

   try
    if FileExists(ExtractFilePath(Application.ExeName) + ANameFile+'.xls') then
     DeleteFile(ExtractFilePath(Application.ExeName) + ANameFile+'.xls');
   except
     ShowMessage(ExtractFilePath(Application.ExeName) + ANameFile+'.xls');
   end;
     //�������� � Excel
   try
     //ANameFile:=ExtractFilePath(Application.ExeName) + ANameFile;
     ANameFile:= ANameFile;
     //          ExportDBGridToExcel(ACaption,ANameFile,
     //          dbgDetail, False, True,true);
     ExportDBGrid(ACaption,ANote,ANameFile,
        dbgDetail, False,True);
   finally
      Screen.Cursor := cr;
   end;

  if FileExists(ANameFile+'.xltx') then
   RenameFile(ANameFile+'.xltx',ANameFile+'.xls');
  if FileExists(ANameFile+'.xlt') then
   RenameFile(ANameFile+'.xlt',ANameFile+'.xls');
//   VBODY :=TStringList.Create;
//   VBODY.Add(ANote);
  dmShowUserSt.GetSendMailParam.ParamByName('VPHONE_NUMBER').AsString := FPhoneNumber;
  dmShowUserSt.GetSendMailParam.ExecProc;
  //�������� � ����� �������� �����
  with mySMTP.Create(true) do
  begin
    SMTP_SRV:= dmShowUserSt.GetSendMailParam.ParamByName('VSMTP_SERVER').AsString;//GetParamValue('SMTP_HOST');
    SMTP_LOG:= dmShowUserSt.GetSendMailParam.ParamByName('VUSER_LOGIN').AsString;//GetParamValue('SMTP_USERNAME');
    SMTP_PASS:= dmShowUserSt.GetSendMailParam.ParamByName('VUSER_PASSWORD').AsString;//GetParamValue('SMTP_PASSWORD');
    SMTP_PORT:= dmShowUserSt.GetSendMailParam.ParamByName('VSMTP_PORT').AsWord;
    SMTP_FROM:= dmShowUserSt.GetSendMailParam.ParamByName('VSMTP_FROM').AsString;
    SMTP_ADDR:=edEmailAdress.Text;
    SMTP_TITLE:='����������� �� ������ '+FPhoneNumber;
    SMTP_FROMTXT:=GetParamValue('SMTP_FROMTEXT');
    SMTP_BODY :=ANote;
//      SMTP_BODY:=TStringList.Create;
//      SMTP_BODY.Add(ANote);
    SMTP_ATT_FILE:=ExtractFilePath(Application.ExeName) + ANameFile;
    Resume;
  end;
 //  FreeAndNil(VBODY);
  Qlog_writer:=TOraQuery.Create(self);
  with Qlog_writer do
  begin
    try
      sql.Clear;
      sql.Add ('insert into log_send_mail ');
      sql.Add('(year_month, phone_number, date_send, mail_subject,note)');
      sql.Add ('values(to_char(sysdate,''YYYYMM''),'+FPhoneNumber+', sysdate, '+'''����������� �� ������ '+FPhoneNumber+''','''+edEmailAdress.Text+'''||'' User:''||(user))');
      ExecSQL;
    except
      on e : exception do
        MessageDlg('������ ������� ������ � ������� ����������� �������� ���������(log_send_mail)', mtError, [mbOK], 0);
    end;
    if cbFree.Checked then
    begin
      sql.Clear;
      vPaymentSum:=(Trunc(dtEnd.Date)-Trunc(dtBegin.Date)+1)*strtoint(GetParamValue('MAIL_COST'))*-1;
      vRemark:='����������� '+DateToStr(dtBegin.Date)+'-'+DateToStr(dtEnd.Date)+' '+edEmailAdress.Text;
      tempStr := 'INSERT INTO RECEIVED_PAYMENTS (RECEIVED_PAYMENT_ID, PHONE_NUMBER, PAYMENT_SUM, PAYMENT_DATE_TIME, CONTRACT_ID, IS_CONTRACT_PAYMENT, FILIAL_ID, REMARK) values (';
      tempStr := tempStr + ' null, ' + #39 + FPhoneNumber + #39 + ','+inttostr(vPaymentSum)+', to_date(' + #39 + DateToStr(now) + #39 + ', ' + #39 + 'dd.mm.yyyy' + #39 + '), ' + IntToStr(FContractId) +
                  ', 0, ' + VarToStr(FFilialId) + ', ' + #39 + vRemark + #39 + ')';
      sql.Clear;
      sql.Add(tempStr);
      try
        ExecSQL;
      except
        on e : exception do
          MessageDlg('������ ������� ������ � ������� ������ ��������', mtError, [mbOK], 0);
      end;
    end;
    Destroy;
  end;
end;

procedure TShowUserStatForm.qPaymentsAfterOpen(DataSet: TDataSet);
var f : TField;
begin
  dmShowUserSt.qPayments.FieldByName('PAYMENT_REMARK').OnGetText := qPaymentsPAYMENT_STATUS_TEXTGetText;
  if FManualPaymentManagement then
  begin
    f := dmShowUserSt.qPayments.FindField('CONTRACT_ID');
    if f <> nil then
      f.OnGetText := qPaymentsCONTRACT_IDGetText;
  end
  else
    gPayments.Columns.Delete(4)
end;

procedure TShowUserStatForm.qPaymentsPAYMENT_STATUS_TEXTGetText(
  Sender: TField; var Text: String; DisplayText: Boolean);
begin
  if Sender.DataSet.Eof then
    Text := ''
  else if Sender.AsString = '' then
    Text := 'OK'
  else
    Text := Sender.AsString;
end;

procedure TShowUserStatForm.qPaymentsCONTRACT_IDGetText(
  Sender: TField; var Text: String; DisplayText: Boolean);
begin
  if FManualPaymentManagement then
  begin
    Text := '';
    if (FContractID <> 0) and (Sender.AsInteger = FContractID) then
      Text := '��'
    else
    begin
      if (dmShowUserSt.qPayments.FieldByName('PAYMENT_DATE').AsDateTime >= FContractDate-DAYS_PAYMENT_BEFORE_CONTRACT)
      and (dmShowUserSt.qPayments.FieldByName('PAYMENT_DATE').AsDateTime <= dmShowUserSt.qContractInfo.FieldByName('CONTRACT_CANCEL_DATE').AsDateTime) then
        Text := '��';
    end;
  end;
end;

procedure TShowUserStatForm.qPhoneStatusesPHONE_IS_ACTIVEGetText(
  Sender: TField; var Text: String; DisplayText: Boolean);
begin
  if Sender.AsInteger = 1 then
    Text := '�������'
  else
    Text := '����������';
end;

procedure TShowUserStatForm.qSummaryPhoneBeforeOpen(DataSet: TDataSet);
begin
  dmShowUserSt.qSummaryPhone.ParamByName('PHONE_NUMBER').AsString := FPhoneNumber;
end;

procedure TShowUserStatForm.tsAbonPeriodListShow(Sender: TObject);
begin
  dmShowUserSt.qAbonPeriodList.Close;
  dmShowUserSt.qAbonPeriodList.Open;
end;

procedure TShowUserStatForm.tsBalanceRowsShow(Sender: TObject);
var
adm_rights:boolean;
begin
  RefreshBalanceRows;
  //
  if (FContractID<>0)and(GetConstantValue('CREDIT_SYSTEM_ENABLE')='1') then
  begin
    dmShowUserSt.spGetCreditInfo.ParamByName('PCONTRACT_ID').AsInteger:=FContractID;
    dmShowUserSt.spGetCreditInfo.ExecSQL;
    lCreditInfo.Caption:= dmShowUserSt.spGetCreditInfo.ParamByName('RESULT').AsString;
  end
  else
    lCreditInfo.Hide;
  MainForm.CheckAdminPrivs(adm_rights);
  if (GetParamValue('CAN_EXCLUDE_DETAIL')='1') and adm_rights then
  begin
    //cbEXCLUDE_DETAIL.Visible:=true; -- ����� 1350
    qexcept:=TOraQuery.Create(nil);
    with qexcept do
    begin
      SQL.Add('select t.enable from BALANCE_VAR_EXCEPT t where t.phone_number='+FPhoneNumber+' and t.date_close is null');
      SQLInsert.Text:='insert into BALANCE_VAR_EXCEPT(phone_number,var_type,enable) values ('+FPhoneNumber+',1,1)';
      SQLUpdate.Text:='update BALANCE_VAR_EXCEPT set enable=0 where phone_number='+FPhoneNumber+' and enable=1';
      SQLRefresh.Text:=SQL.Text;
      Execute;

      if (FieldByName('enable').AsInteger=1) and not (cbEXCLUDE_DETAIL.Checked) then
      begin
        cbexcept:=-1;
        cbEXCLUDE_DETAIL.State:=cbChecked;
      end
      else
        if (FieldByName('enable').AsInteger=0) and (cbEXCLUDE_DETAIL.Checked) then
        begin
          cbexcept:=-1;
          cbEXCLUDE_DETAIL.State:=cbUnchecked;
        end;
    end;
  end;
end;

procedure TShowUserStatForm.tsBillBeelineShow(Sender: TObject);
begin
  dmShowUserSt.qBillBeeline.Close;
  dmShowUserSt.qBillBeeline.Open;
end;

procedure TShowUserStatForm.tsBillClientNewShow(Sender: TObject);
begin
  dmShowUserSt.qBillClientNew.Close;
  dmShowUserSt.qBillClientNew.Open;
end;

procedure TShowUserStatForm.tsBillsNewFormatShow(Sender: TObject);
begin
  dmShowUserSt.qBillBeeline.Close;
  dmShowUserSt.qBillBeeline.Open;
end;

procedure TShowUserStatForm.tsClientBillsShow(Sender: TObject);
begin
  dmShowUserSt.qClientBills.Close;
  dmShowUserSt.qClientBills.Open;
end;

procedure TShowUserStatForm.tsContractInfoShow(Sender: TObject);
var
  AdminPriv : boolean;
begin
  tsContractInfo.TabVisible:=true;
  dmShowUserSt.qContractInfo.Close;
  dmShowUserSt.qContractDealers.Close;
  btPostComments.Enabled:=false;
  if FContractID=0 then
  begin
    Label20.Hide;
    Label21.Hide;
    Label22.Hide;
    DBText20.Hide;
    DBText21.Hide;
    DBMemo1.Hide;
    Label17.Hide;
    cbDealers.Hide;
    btRefreshCI.Hide;
    btPostComments.Hide;
    dmShowUserSt.dsContractInfo.DataSet := dmShowUserSt.qAccountNumber;
    dmShowUserSt.qAccountNumber.ParamByName('PHONE_NUMBER').AsString:=FPhoneNumber;
    dmShowUserSt.qAccountNumber.Open;
  end
  else
  begin
    dmShowUserSt.qContractInfo.Open;
    if( GetConstantValue('SHOW_DEALERS') = '1' ) and
      ( GetConstantValue('SERVER_NAME') = 'CORP_MOBILE' ) then begin
      MainForm.CheckAdminPrivs(AdminPriv);
      if not(AdminPriv) then
        cbDealers.Enabled:=false;
      dmShowUserSt.qContractDealers.Open;
    end
    else
    begin
      Label17.Hide;
      cbDealers.Hide;
    end;
  end;
end;

procedure TShowUserStatForm.tsDepositShow(Sender: TObject);
begin
  dmShowUserSt.qDeposit.Close;
  dmShowUserSt.qDeposit.ParamByName('CONTRACT_ID').AsInteger:=FContractID;
  dmShowUserSt.qDeposit.Open;
  dmShowUserSt.qDepositOper.Close;
  dmShowUserSt.qDepositOper.ParamByName('CONTRACT_ID').AsInteger:=FContractID;
  dmShowUserSt.qDepositOper.Open;
  if (MainForm.UserRightsType=2) or (MainForm.UserRightsType=3) then
    btAddDeposit.Enabled:=false;
   //19610 - ���������� � �� ��������
  MN_ROAMING;

end;

procedure TShowUserStatForm.tsDetailShow(Sender: TObject);
begin
  if (GetConstantValue('SERVER_NAME')='CORP_MOBILE') and (MainForm.CheckUser = 'sandra') then
  begin
    cb_Hide_detail.Visible:=True;
    cb_Hide_detail.Enabled:=True;
  end;
  dmShowUserSt.qPeriods.ParamByName('PHONE_NUMBER').AsString:=FPhoneNumber;
  if (GetConstantValue('SERVER_NAME')='GSM_CORP') then
  begin
    dmShowUserSt.qPeriods.SQL.Text := dmShowUserSt.qPeriodsGSM_CORP.SQL.Text;
    dmShowUserSt.qPeriods.Close;
    dmShowUserSt.qPeriods.Open;
  end
  else
    dmShowUserSt.qPeriods.Open;
end;

procedure TShowUserStatForm.FillingStatistic;
var i, j: Integer;
    rec: boolean;
begin
  with gStatistic do
  begin
    //������� ����
    for i:=0 to RowCount do
      Rows[i].Clear;

    //��������� �������
    ColWidths[0] := 200;
    ColWidths[1] := 70;
    i:= -1;
    RowCount := 1;

    rec := false;
    if GetConstantValue('SERVER_NAME')='GSM_CORP' then
    begin
      inc(i);
      Cells[0, i] := '�����������';
      Cells[1, i] := dmShowUserSt.qPeriods.FieldByName('COST_CHNG').AsString;
      rec := true;
    end;

    if rec then
      RowCount := RowCount + 1;
    inc(i);
    if GetConstantValue('SERVER_NAME')='CORP_MOBILE' then
    begin
      Cells[0, i] := '�/�� ����� ���';
      Cells[1, i] := dmShowUserSt.qPeriods.FieldByName('ZEROCOST_OUTCOME_MINUTES').AsString;
      inc(i);
      RowCount := RowCount + 1;
      Cells[0, i] := '  - ��������';
      Cells[1, i] := dmShowUserSt.qPeriods.FieldByName('ZEROCOST_INBOX_MINUTES').AsString;
    end
    else
    begin
      Cells[0, i] := '�/������� �����';
      Cells[1, i] := dmShowUserSt.qPeriods.FieldByName('ZEROCOST_OUTCOME_MINUTES').AsString;
    end;

    inc(i);
    RowCount := RowCount + 4;
    Cells[0, i] := '  - �������';
    Cells[1, i] := dmShowUserSt.qPeriods.FieldByName('ZEROCOST_OUTCOME_COUNT').AsString;

    inc(i);
    if GetConstantValue('SERVER_NAME')='CORP_MOBILE' then
    begin
      Cells[0, i] := '������� ����� (�� ���.)';
      if not dmShowUserSt.qPeriods.FieldByName('CALLS_FULL_MINUTES').IsNull then
        Cells[1, i] := dmShowUserSt.qPeriods.FieldByName('CALLS_FULL_MINUTES').AsString
      else
        Cells[1, i] := '0';
      inc(i);
      RowCount := RowCount + 1;
      Cells[0, i] := '������� ����� (�� ���.)';
      Cells[1, i] := dmShowUserSt.qPeriods.FieldByName('CALLS_MINUTES').AsString;
    end
    else
    begin
      Cells[0, i] := '������� �����';
      Cells[1, i] := dmShowUserSt.qPeriods.FieldByName('CALLS_MINUTES').AsString;
    end;

    inc(i);
    Cells[0, i] := '  - �������';
    Cells[1, i] := dmShowUserSt.qPeriods.FieldByName('CALLS_COUNT').AsString;
    inc(i);
    Cells[0, i] := '  - ���������';
    Cells[1, i] := dmShowUserSt.qPeriods.FieldByName('CALLS_COST').AsString;

    if GetConstantValue('SERVER_NAME')='CORP_MOBILE' then
    begin
      RowCount := RowCount + 1;
      inc(i);
      Cells[0, i] := '���. �/������� SMS � MMS';
      if dmShowUserSt.qPeriods.FieldByName('SMS_MMS_FREE_COUNT').IsNull then
        Cells[1, i] := '0'
      else
        Cells[1, i] := dmShowUserSt.qPeriods.FieldByName('SMS_MMS_FREE_COUNT').AsString;
    end;

    RowCount := RowCount + 4;
    inc(i);
    if GetConstantValue('SERVER_NAME')='CORP_MOBILE' then
      Cells[0, i] := '������� SMS � MMS'
    else
      Cells[0, i] := 'SMS � MMS';
    Cells[1, i] := dmShowUserSt.qPeriods.FieldByName('SMS_MMS_COUNT').AsString;
    inc(i);
    Cells[0, i] := '  - ���������';
    Cells[1, i] := dmShowUserSt.qPeriods.FieldByName('SMS_MMS_COST').AsString;
    inc(i);
    Cells[0, i] := '��������, ��';
    Cells[1, i] := dmShowUserSt.qPeriods.FieldByName('INTERNET_MB').AsString;
    inc(i);
    Cells[0, i] := '  - ���������';
    Cells[1, i] := dmShowUserSt.qPeriods.FieldByName('INTERNET_COST').AsString;

    if GetConstantValue('SERVER_NAME')='CORP_MOBILE' then
    begin
      RowCount := RowCount + 3;
      inc(i);
      Cells[0, i] := 'Call Back �����';
      Cells[1, i] := dmShowUserSt.qPeriods.FieldByName('CALLBACKMINUTES').AsString;
      inc(i);
      Cells[0, i] := '  - �������';
      Cells[1, i] := dmShowUserSt.qPeriods.FieldByName('CALLBACKCOUNT').AsString;
      inc(i);
      Cells[0, i] := '  - ���������';
      Cells[1, i] := dmShowUserSt.qPeriods.FieldByName('CALLBACKCOST').AsString;
    end;

    RowCount := RowCount + 1;
    inc(i);
    Cells[0, i] := '������ ������';
    Cells[1, i] := dmShowUserSt.qPeriods.FieldByName('OTHER_COST').AsString;
  end;
end;

procedure TShowUserStatForm.tsDiscountShow(Sender: TObject);
begin
  dmShowUserSt.spSetDiscount.ParamByName('PPHONE_NUMBER').AsString := FPhoneNumber;
  dmShowUserSt.qDiscount.Close;
  dmShowUserSt.qDiscount.ParamByName('PHONE_NUMBER').AsString := FPhoneNumber;
  dmShowUserSt.qDiscount.Open;
  if dmShowUserSt.qDiscountIS_DISCOUNT_OPERATOR.AsInteger=1 then
    cbDiscount.Checked:=true
  else
    cbDiscount.Checked:=false;
end;

procedure TShowUserStatForm.tsDopInfoShow(Sender: TObject);
var
  AdminPriv : boolean;
begin
  dmShowUserSt.qDopPhoneInfo.ParamByName('PHONE_NUMBER').AsString:=FPhoneNumber;
  dmShowUserSt.qDopPhoneInfo.Open;
    //if( GetConstantValue('SHOW_DEALERS') = '1' )
    //MainForm.CheckAdminPrivs(AdminPriv);
    //if not(AdminPriv) then
  //����������/�������� ������ ���������� ������ ��� �����
  bRefreshSIM.Visible := (GetConstantValue('SERVER_NAME') = 'CORP_MOBILE');
end;

procedure TShowUserStatForm.tsOperatorBillsShow(Sender: TObject);
begin
  dmShowUserSt.qBills.Close;
  dmShowUserSt.qBills.Open;
end;

procedure TShowUserStatForm.tsOptionsShow(Sender: TObject);
var YearMonth:integer;
    vCheck,IsAdmin : Boolean;
begin
  dmShowUserSt.qOptionsPer.Close;
  dmShowUserSt.qOptions.Close;
  dmShowUserSt.qOptions.ParamByName('PHONE_NUMBER').AsString := FPhoneNumber;
  dmShowUserSt.qOptions.ParamByName('PHONE_NUMBER').AsString := FPhoneNumber;
  dmShowUserSt.qOptionsPer.ParamByName('PHONE_NUMBER').AsString:= FPhoneNumber;
  dmShowUserSt.qOptionsPer.Open;
  if cbPeriodsOpt.Items.Count=0 then
    while not dmShowUserSt.qOptionsPer.EOF do
      begin
        YearMonth:= dmShowUserSt.qOptionsPer.FieldByName('YEAR_MONTH').AsInteger;
        cbPeriodsOpt.Items.AddObject(InttoStr(YearMonth div 100)+' - '+InttoStr(YearMonth mod 100), Pointer(YearMonth));
        dmShowUserSt.qOptionsPer.Next;
      end;

  if cbPeriodsOpt.Items.Count > 0 then
    cbPeriodsOpt.ItemIndex := 0;
  cbPeriodsOptChange(Sender);
  dmShowUserSt.qOptions.Open;
  if GetConstantValue('USE_TARIFF_OPTION_GROUP') = '1' then
  begin
    dmShowUserSt.qContractInfo.Close;
    dmShowUserSt.qContractInfo.Open;
    MainForm.CheckAdminPrivs(vCheck);
    if not(vCheck) then
    begin
      DBLookupComboBox1.Enabled:=false;
      btChangeOptionGroup.Enabled:=false;
    end;
  end
  else
  begin
    lTGOptions.Hide;
    DBLookupComboBox1.Hide;
    btChangeOptionGroup.Hide;
  end;
  dmShowUserSt.qAPIOptionHistory.Close;
  dmShowUserSt.qAPIOptionHistory.ParamByName('PHONE_NUMBER').AsString := FPhoneNumber;
  MainForm.CheckAdminPrivs(IsAdmin);
  if IsAdmin then
    dmShowUserSt.qAPIOptionHistory.ParamByName('RETARIF').AsInteger := 1
  else
    dmShowUserSt.qAPIOptionHistory.ParamByName('RETARIF').AsInteger := 0;
  dmShowUserSt.qAPIOptionHistory.Open;
end;

procedure TShowUserStatForm.tsPaymentsPromisedShow(Sender: TObject);
begin
  dmShowUserSt.qPrPayments.Close;
  dmShowUserSt.qPrPayments.Open;
  sdePromisedDate.Date:=Date;
end;

procedure TShowUserStatForm.tsPaymentsRealShow(Sender: TObject);
begin
  dmShowUserSt.qPayments.Close;
  dmShowUserSt.qPayments.Open;
  if ((MainForm.UserRightsType=2) or
      ((MainForm.UserRightsType=3) and
        ((MainForm.Allow_account =-1) or ( MainForm.Allow_account=1)))) then
  begin
   btnAdd.Enabled:=false;
   btnUsePayment.Enabled:=false;
   btnUnUsePayment.Enabled:=false;
  end;
end;

procedure TShowUserStatForm.tsRoumingShow(Sender: TObject);
begin
  dmShowUserSt.qRouming.Close;
  dmShowUserSt.qRouming.Open;
end;

procedure TShowUserStatForm.tsSummaryPhoneShow(Sender: TObject);
var SQLTxt: string;
begin
  dmShowUserSt.qSummaryPhone.Close;
  dmShowUserSt.qSummaryPhone.Open;
end;

procedure TShowUserStatForm.tsTariffsShow(Sender: TObject);
var
  AdminPriv, ReadPriv, ROPriv: boolean;
begin
  //������ ����������
  pnlNewHB.Visible:=(GetConstantValue('HAND_BLOCK_IS_ROBOT_BLOCK')='1');
  pnlShowHB.Visible:=(GetConstantValue('HAND_BLOCK_IS_ROBOT_BLOCK')='1');
  if GetConstantValue('SERVER_NAME')='CORP_MOBILE' then
  begin
    cbHandBlock.Visible:=(GetConstantValue('HAND_BLOCK_IS_ROBOT_BLOCK')='1');
  end;
  if (FContractID<>0)and(GetConstantValue('HAND_BLOCK_IS_ROBOT_BLOCK')='1') then
  begin
    pnlNewHB.Hide;
    dmShowUserSt.qHandBlockEndDate.ParamByName('CONTRACT_ID').AsInteger:=FContractID;
    dmShowUserSt.spSetHandBlockEndDate.ParamByName('PCONTRACT_ID').AsInteger:=FContractID;
    dmShowUserSt.qHandBlockEndDate.Open;
    if (dmShowUserSt.qHandBlockEndDate.FieldByName('HAND_BLOCK').AsInteger=1)
     {( and(dmShowUserSt.qHandBlockEndDate.FieldByName('HAND_BLOCK_DATE_END').AsDateTime>Date)} then
      FHandBlockChecked:=true
    else
      FHandBlockChecked:=false;
    pnlShowHB.visible:=FHandBlockChecked;
    cbHandBlock.Checked:=FHandBlockChecked;
  end
  else
  begin
    dmShowUserSt.qHandBlockStart.Close;
    dmShowUserSt.qHandBlockStart.ParamByName('CONTRACT_ID').AsInteger :=FContractID;
    dmShowUserSt.qHandBlockStart.ParamByName('PHONE_NUMBER').AsString := FPhoneNumber;
    dmShowUserSt.qHandBlockStart.Open;
    if dmShowUserSt.qHandBlockStart.IsEmpty then
    begin
      CbHandBlock.Visible:=false;
      pnlNewHB.Visible:=false;
      pnlShowHB.Visible:=false;
    end
    else
    begin
      dmShowUserSt.qHandBlock.Close;
      dmShowUserSt.qHandBlock.SQL.Clear;
      dmShowUserSt.qHandBlock.SQL.Add('Select hand_block from v_contracts where Phone_Number_Federal='+FPhoneNumber+' and CONTRACT_ID='+VartoStr(FContractID));
      dmShowUserSt.qHandBlock.Prepare;
      dmShowUserSt.qHandBlock.Open;
      FHandBlockChecked := (dmShowUserSt.qHandBlock.FieldByName('hand_block').AsInteger <> 0);
      pnlNewHB.Hide;
      pnlShowHB.visible:=FHandBlockChecked;
      CbHandBlock.Checked := FHandBlockChecked;
    end;
    dmShowUserSt.qHandBlock.Close;
  end;
  dmShowUserSt.qTariffInfo.Close;
  dmShowUserSt.qTariffInfo.Open;
  if dmShowUserSt.qTariffInfo.FieldByName('NEW_CELL_PLAN_CODE').AsString<>'' then
    DB_TXT_NEW_TARIF_INFO.Visible:=true
  else DB_TXT_NEW_TARIF_INFO.Visible:=false;
  //���. ������
  dmShowUserSt.qContractInfo_DopStatus.Close;
  dmShowUserSt.qContractDopStatuses.close;
  btPostDopStatus.Enabled:=false;
  MainForm.CheckAdminPrivs(AdminPriv);
  MainForm.CheckROPrivs(ROPriv);
  if ( FContractID <> 0 ) and
     ( GetConstantValue('SHOW_CONTRACT_DOP_STATUS') = '1' ) and
     ( GetConstantValue('SERVER_NAME') = 'CORP_MOBILE' ) then
  begin
    dmShowUserSt.qContractInfo_DopStatus.ParamByName('CONTRACT_ID').AsInteger:=FContractID;
    dmShowUserSt.qContractInfo_DopStatus.Open;
    dmShowUserSt.qContractDopStatuses.Open;
    vdop_status := cbDopStatus.Text;  //19610
    if not(AdminPriv or ROPriv or (MainForm.UserRightsType=3)) then
     cbDopStatus.Enabled:=false;
  end
  else
  begin
    cbDopStatus.Hide;
    label27.Hide;
    btPostDopStatus.Hide;
  end;
  if GetConstantValue('CALC_ABON_PAYMENT_TO_MONTH_END') = '1' then
  begin
    dmShowUserSt.qDailyAbonPay.Close;
    dmShowUserSt.qDailyAbonPay.Open;
    cbDailyAbonPay.OnClick := nil;
    if dmShowUserSt.qDailyAbonPay.FieldByName('PHONE_NUMBER').AsString = FPhoneNumber then
    begin
      cbDailyAbonPay.Checked := true;
      if not (EditcbDailyAbonPayBanned) then
        cbDailyAbonPay.Enabled := False;
    end
    else
      cbDailyAbonPay.Checked := false;

    cbDailyAbonPay.OnClick := cbDailyAbonPayClick;

    dmShowUserSt.qDailyAbonPayBanned.Close;
    dmShowUserSt.qDailyAbonPayBanned.Open;

    if dmShowUserSt.qDailyAbonPayBanned.FieldByName('DAILY_ABON_BANNED').AsInteger = 1 then
    begin
      cbDailyAbonPayBanned.Checked := true;
      if not(EditcbDailyAbonPayBanned) then
        cbDailyAbonPayBanned.Enabled := false;
    end
    else
      cbDailyAbonPayBanned.Checked := false;
    {
    if cbDailyAbonPayBanned.Checked
        and not(EditcbDailyAbonPayBanned) then
    begin
      cbDailyAbonPay.Enabled:=false;
      cbDailyAbonPayBanned.Enabled:=false;
    end;
    }
  end;
  //��� K7-���� ������ ���������� �����, �� ������ �� ��������� ������ ��� �������
  if GetConstantValue('SERVER_NAME')='CORP_MOBILE' then
    if cbHandBlock.Visible then
      cbHandBlock.Enabled := AdminPriv;
end;

procedure TShowUserStatForm.BtBlockClick(Sender: TObject);
begin
  BlockPhone (GetParamValue('BEELINE_BLOCK_CODE_FOR_BLOCK'));
end;


procedure TShowUserStatForm.BtUnBlockClick(Sender: TObject);
var
  DetailText : String;
  buttonSelected : Integer;
begin
  if GetConstantValue('SHOW_CONTRACT_DOP_STATUS')='1' then
  begin
    if btPostDopStatus.Enabled then begin
      ShowMessage('������, �� �� ������� ���. ������!');
      exit;
    end;
    if dmShowUserSt.qContractInfo_DopStatus.FieldByName('DOP_STATUS').AsString<>'' then
    begin
      ShowMessage('������ �������������� ������� ��� ������� ���. �������!');
      exit;
    end;
  end;
  if dmShowUserSt.qBlocked.FieldByName('blocked').AsInteger<>0 then
    buttonSelected:=MessageDlg('������ ����� ������������ �� ���������� � �������������! �� ������������� ������ �������������� ������ ����� ��������?', mtWarning, mbOKCancel, 0)
  else
    buttonSelected:=MessageDlg('�� ������������� ������ �������������� ������ ����� ��������?', mtCustom, mbOKCancel, 0);
  if buttonSelected = mrCancel  then
    exit;
  if (RGBlock.Visible=true) and (Integer(RGBlock.Items.Objects[RGBlock.ItemIndex])=3) then
  begin
    dmShowUserSt.LoaderUnBlockPhoneNum2.ParamByName('pPHONE_NUMBER').AsString := FPhoneNumber;
    try
      dmShowUserSt.LoaderUnBlockPhoneNum2.ExecProc;
      DetailText := dmShowUserSt.LoaderUnBlockPhoneNum2.ParamByName('RESULT').AsString;
      FDetailText := DetailText;
    except
      on E : Exception do
      begin
        DetailText := '������ �������������.'#13#10 + E.Message;
      end;
    end;
    if DetailText=''  then
      ShowMessage('�������� ��������� �������')
    else
      MessageDlg(DetailText, mtWarning, [mbOk], 0);
  end
  else
  begin
    dmShowUserSt.LoaderUnBlockPhoneNum.ParamByName('pPHONE_NUMBER').AsString := FPhoneNumber;
    if (RGBlock.Visible=true) and (Integer(RGBlock.Items.Objects[RGBlock.ItemIndex])=2) then
      dmShowUserSt.LoaderUnBlockPhoneNum.ParamByName('PNEW_SITE_METHOD').AsInteger:=1
    else
      dmShowUserSt.LoaderUnBlockPhoneNum.ParamByName('PNEW_SITE_METHOD').Clear;
    try
      dmShowUserSt.LoaderUnBlockPhoneNum.ExecProc;
      DetailText := dmShowUserSt.LoaderUnBlockPhoneNum.ParamByName('RESULT').AsString;
      FDetailText := DetailText;
    except
      on E : Exception do
      begin
        DetailText := '������ �������������.'#13#10 + E.Message;
      end;
    end;
    if DetailText=''  then
      ShowMessage('�������� ��������� �������')
    else if (RGBlock.Visible=true) and (Integer(RGBlock.Items.Objects[RGBlock.ItemIndex])=2) then
      ShowMessage(DetailText)
    else
      MessageDlg(DetailText, mtWarning, [mbOk], 0);
  end;
end;

procedure TShowUserStatForm.BtnSendBalClick(Sender: TObject);
var
  DetailText : String;
  buttonSelected : Integer;
begin
  buttonSelected:=MessageDlg('�� ������������� ������ ��������� �������� ��� ��������� � ��� ��������?', mtCustom, mbOKCancel, 0);
  if buttonSelected = mrCancel then
    exit;
  dmShowUserSt.spSendSMSBal.ParamByName('PPHONE_NUMBER').AsString := FPhoneNumber;
  try
    dmShowUserSt.spSendSMSBal.ExecProc;
    DetailText := dmShowUserSt.spSendSMSBal.ParamByName('PERROR_MESSAGE').AsString;
    if DetailText<>'' then
      DetailText := '������ ��������.'#13#10 + DetailText;
  except
    on E : Exception do
    begin
      DetailText := '������ ��������.'#13#10 + E.Message;
    end;
  end;
  if DetailText='' then
    ShowMessage('��������� ����������.')
  else
    MessageDlg(DetailText, mtWarning, [mbOk], 0);
end;

procedure TShowUserStatForm.cbDailyAbonPayBannedClick(Sender: TObject);
begin
  if ((cbDailyAbonPayBanned.Checked)
      and (EditcbDailyAbonPayBanned))
      OR (cbDailyAbonPayBanned.Enabled) then
  begin
    dmShowUserSt.qDailyAbonPayBanned.Edit;
    if cbDailyAbonPayBanned.Checked then
      dmShowUserSt.qDailyAbonPayBanned.FieldByName('DAILY_ABON_BANNED').AsInteger := 1
    else
      dmShowUserSt.qDailyAbonPayBanned.FieldByName('DAILY_ABON_BANNED').AsInteger := 0;

    dmShowUserSt.qDailyAbonPayBanned.Post;
    if not(EditcbDailyAbonPayBanned) then
    begin
      cbDailyAbonPay.Enabled := false;
      cbDailyAbonPayBanned.Enabled:=false;
    end;
  end;
end;

procedure TShowUserStatForm.cbDailyAbonPayClick(Sender: TObject);
begin

  if (cbDailyAbonPay.Checked) then
  begin
    if (EditcbDailyAbonPayBanned) OR (cbDailyAbonPayBanned.Enabled) then
    begin
      dmShowUserSt.qDailyAbonPay.Insert;
      dmShowUserSt.qDailyAbonPay.FieldByName('PHONE_NUMBER').AsString := FPhoneNumber;
      dmShowUserSt.qDailyAbonPay.Post;
      if not EditcbDailyAbonPayBanned then
        cbDailyAbonPayBanned.Enabled := False;
    end;
  end
  else
  begin
    if cbDailyAbonPayBanned.Enabled then
      if not(dmShowUserSt.qDailyAbonPay.IsEmpty) then
        dmShowUserSt.qDailyAbonPay.Delete;
  end;

end;

procedure TShowUserStatForm.cbDiscountClick(Sender: TObject);
begin
  if cbDiscount.Checked then
  begin
    eLength.Show;
    lLength.Show;
    btSetDiscount.Show;
    dtpNewBeginDate.Show;
    dtpNewBeginDate.DateTime:= dmShowUserSt.qDiscountDISCOUNT_BEGIN_DATE.AsDateTime;
    lDate.Show;
  end
  else
  begin
    if dmShowUserSt.qDiscountIS_DISCOUNT_OPERATOR.AsInteger=1 then
    begin
      dmShowUserSt.spSetDiscount.ParamByName('PCHECK').AsInteger:=0;
      dmShowUserSt.spSetDiscount.ParamByName('PDISCOUNT_VALIDITY').Value:=null;
      dmShowUserSt.spSetDiscount.ParamByName('PDISCOUNT_BEGIN_DATE').Value:=null;
      dmShowUserSt.spSetDiscount.ExecSQL;
      dmShowUserSt.qDiscount.Close;
      dmShowUserSt.qDiscount.Open;
    end;
    eLength.Hide;
    lLength.Hide;
    btSetDiscount.Hide;
    dtpNewBeginDate.Hide;
    lDate.Hide;
  end;
  if cbDiscount.Checked then
    if dmShowUserSt.qDiscountDISCOUNT_END_DATE.AsDateTime<Date then
      cbDiscount.Font.Color:=clRed
    else
      cbDiscount.Font.Color:=clGreen
  else
    cbDiscount.Font.Color:=clWindowText;
end;

procedure TShowUserStatForm.cbDopStatusCloseUp(Sender: TObject);
begin
  btPostDopStatus.Enabled:=true;
end;

procedure TShowUserStatForm.cbEXCLUDE_DETAILValueChanged(Sender: TObject);
begin
  inc(cbexcept);
  if cbexcept=0 then
    exit;

  if cbEXCLUDE_DETAIL.Checked then
    with qexcept do
    begin
      Append;
      post;
    end
  else
    with qexcept do
    begin
      edit;
      post;
    end;
  qexcept.Refresh;
end;

procedure TShowUserStatForm.BtSendSmsClick(Sender: TObject);
 var
  RefFrm : TSendSmsFrm;
begin
  RefFrm := TSendSmsFrm.Create(Application);
  try
    RefFrm.FPhoneNumber:= FPhoneNumber;
    RefFrm.ShowModal;
  finally
    FreeAndNil(RefFrm);
  end;
end;

procedure TShowUserStatForm.btSetDiscountClick(Sender: TObject);
begin
  dmShowUserSt.spSetDiscount.ParamByName('PCHECK').AsInteger:=1;
  dmShowUserSt.spSetDiscount.ParamByName('PDISCOUNT_VALIDITY').AsInteger:= dmShowUserSt.qDiscountDISCOUNT_VALIDITY.AsInteger;
  dmShowUserSt.spSetDiscount.ParamByName('PDISCOUNT_BEGIN_DATE').AsDateTime:=dtpNewBeginDate.DateTime;
  dmShowUserSt.spSetDiscount.ExecSQL;
  dmShowUserSt.qDiscount.Close;
  dmShowUserSt.qDiscount.Open;
  if cbDiscount.Checked then
    if dmShowUserSt.qDiscountDISCOUNT_END_DATE.AsDateTime<Date then
      cbDiscount.Font.Color:=clRed
    else
      cbDiscount.Font.Color:=clGreen
  else
    cbDiscount.Font.Color:=clWindowText;
end;

procedure TShowUserStatForm.btSetHandBlockDateEndClick(Sender: TObject);
begin
  if (FContractID<>0)and(GetConstantValue('HAND_BLOCK_IS_ROBOT_BLOCK')='1') then
  begin
    if emNewDateEnd.Text = '  .  .  ' then begin
      MessageDlg('������� ���� ��������� ������ ����������!',mtError, [mbOK], 0);
      exit;
    end;
    dmShowUserSt.spSetHandBlockEndDate.ParamByName('PHAND_BLOCK_END_DATE').AsDateTime:=StrToDate(emNewDateEnd.Text);
    if eNewNoticeHB.Text <> '' then
      dmShowUserSt.spSetHandBlockEndDate.ParamByName('PBALANCE_NOTICE_HAND_BLOCK').AsInteger:=StrToInt(eNewNoticeHB.Text)
    else
      dmShowUserSt.spSetHandBlockEndDate.ParamByName('PBALANCE_NOTICE_HAND_BLOCK').Value:=Null;
    if eNewBlockHB.Text <> '' then
      dmShowUserSt.spSetHandBlockEndDate.ParamByName('PBALANCE_BLOCK_HAND_BLOCK').AsInteger:=StrToInt(eNewBlockHB.Text)
    else
      dmShowUserSt.spSetHandBlockEndDate.ParamByName('PBALANCE_BLOCK_HAND_BLOCK').Value:=Null;
    dmShowUserSt.spSetHandBlockEndDate.ExecSQL;
    pnlNewHB.Hide;
    pnlShowHB.Show;
  end;
end;

procedure TShowUserStatForm.BtSetPasswordClick(Sender: TObject);
begin
  if dmShowUserSt.qPassword.ParamByName('CONTRACT_ID').AsInteger=0 then
    ShowMessage('��� ������� ������ �� ���������� ��������.'+chr(10)+'������ ������ ����������.')
  else
  begin
    BtSetPasswordOk.Show;
    eSetPassword.Show;
    BtSetPassword.Hide;
    eSetPassword.Text:='';
    eSetPassword.SetFocus;
  end;
end;

procedure TShowUserStatForm.BtSetPasswordOkClick(Sender: TObject);
begin
  dmShowUserSt.qPassword.ParamByName('PASSWORD').AsString:=eSetPassword.Text;
  dmShowUserSt.qPassword.ExecSql;
  BtSetPasswordOk.Hide;
  eSetPassword.Hide;
  BtSetPassword.Show;
end;

procedure TShowUserStatForm.btChangeOptionGroupClick(Sender: TObject);
var vRes : Integer;
    vCheck: boolean;
begin
  MainForm.CheckAdminPrivs(vCheck);
  vRes := MessageDlg('������� ������ �����?', mtConfirmation, [mbYes, mbNo, mbCancel], 0);
  if (mrYes = vRes) and vCheck then
    if dmShowUserSt.qContractInfo.State in [dsInsert, dsEdit] then
      dmShowUserSt.qContractInfo.Post;
end;

procedure TShowUserStatForm.btDelPromisedPaymentClick(Sender: TObject);
var Itog: string;
    PromisedSum: double;
    PromisedDade: TDateTime;
begin
  Itog:='';
  try
    dmShowUserSt.spDelPrPayment.ExecProc;
    Itog:= dmShowUserSt.spDelPrPayment.ParamByName('RESULT').AsString;
  except
    Itog:='�� ������� ������� ��������� ������';
  end;
  ShowMessage(Itog);
  dmShowUserSt.qPrPayments.Close;
  dmShowUserSt.qPrPayments.Open;
end;

procedure TShowUserStatForm.btInstalmentPaymentClick(Sender: TObject);
var ReportFrm : TShowUserAlertForm;
begin
  ReportFrm:=TShowUserAlertForm.Create(Nil);
  try
    // �����
    ReportFrm.FContractID:=FContractId;
    ReportFrm.FPhoneNumber:=FPhoneNumber;
    ReportFrm.ShowModal;
  finally
    ReportFrm.Free;
  end;
end;

procedure TShowUserStatForm.btnaOpenDetailInExcelClick(Sender: TObject);
var
  cr : TCursor;
  ACaption : String;
  ANameFile : string;
begin
  cr := Screen.Cursor;
  Screen.Cursor := crHourGlass;
  ANameFile := '������� ������� �� ������ ' + FPhoneNumber;
  ACaption := ANameFile + ' �� ' + FormatDateTime('dd.mm.yyyy', Date);
  try
    ExportDBGridToExcel(ACaption, ANameFile, gRest, False, True);
  finally
    Screen.Cursor := cr;
  end;
end;

procedure TShowUserStatForm.btnCloseClick(Sender: TObject);
begin
 if FContractID<>0 then
   EditAbonentFrame.PrepareFrameByContractID('EDIT', FContractID);
end;

procedure TShowUserStatForm.btnExportPaymentsClick(Sender: TObject);
var
  cr : TCursor;
  ACaption : String;
begin
  cr := Screen.Cursor;
  Screen.Cursor := crHourGlass;
  ACaption := '�������  �� ������ '
      + FPhoneNumber;
  try
    ExportDBGridToExcel(ACaption,'',
      gPayments, False, True);
  finally
    Screen.Cursor := cr;
  end;
end;

procedure TShowUserStatForm.btPostCommentsClick(Sender: TObject);
begin
  dmShowUserSt.qContractInfo.Post;
  dmShowUserSt.qContractInfo.Close;
  dmShowUserSt.qContractInfo.Open;
end;

procedure TShowUserStatForm.btPostDopStatusClick(Sender: TObject);
begin
  Try
    dmShowUserSt.qContractInfo_DopStatus.Post;
    dmShowUserSt.qContractInfo_DopStatus.Close;
    dmShowUserSt.qContractInfo_DopStatus.Open;
    btPostDopStatus.Enabled:=false;
    Send_mail_dop_status;//19610 - �������� E-mail � ����� ���.�������
  Except
    MessageDlg('��������� �� �����������!',mtError, [mbOK], 0);
  End;
end;

procedure TShowUserStatForm.btRefreshCIClick(Sender: TObject);
begin
  dmShowUserSt.qContractInfo.Close;
  dmShowUserSt.qContractInfo.Open;
end;

procedure TShowUserStatForm.btRefreshClick(Sender: TObject);
begin
  dmShowUserSt.qRests.Close;
  dmShowUserSt.qRests.ParamByName('PHONE_NUMBER').Value := FPhoneNumber;
  dmShowUserSt.qRests.Open;
end;

procedure TShowUserStatForm.btRoumingClick(Sender: TObject);
var
  cr : TCursor;
  ACaption : String;
begin
  cr := Screen.Cursor;
  Screen.Cursor := crHourGlass;
  ACaption := '������� ����������� �������� �� ������ '
      + FPhoneNumber;
  try
    ExportDBGridToExcel(ACaption,'',
      grRouming, False, True);
  finally
    Screen.Cursor := cr;
  end;
end;

procedure TShowUserStatForm.SaveBtnClick(Sender: TObject);
begin
  EditAbonentFrame.SaveData('');
end;

procedure TShowUserStatForm.B1Click(Sender: TObject);
var
  AdminPriv : boolean;
begin
//MainForm.CheckAdminPrivs(AdminPriv);
  MainForm.CheckAdminPrivileges;

  if  (gPayments.Fields[6].AsString = '') then
  begin
    MonthCalendar1.Top:=ScreenToClient(Mouse.CursorPos).Y-gPayments.Top-20;
    MonthCalendar1.Visible:=true;
  end
  else
    MessageDlg('����� ������������� ������ ������� ��������! ������ ������������� �� �������� �����.',mtError, [mbOK], 0);
end;

procedure TShowUserStatForm.BChangeSIMClick(Sender: TObject);
Var buttonSelected:integer;
  DetailText : String;
begin
  buttonSelected:=MessageDlg('�� ������������� ������ �������� SIM �����?', mtCustom, mbOKCancel, 0);
  if buttonSelected = mrCancel then
    exit;
  dmShowUserSt.PReplaceSIM.ParamByName('pPHONE_NUMBER').AsString := FPhoneNumber;
  dmShowUserSt.PReplaceSIM.ParamByName('pICC').AsString := EChangeSIM.Text;
  try
    dmShowUserSt.PReplaceSIM.ExecProc;
    DetailText := dmShowUserSt.PReplaceSIM.ParamByName('RESULT').AsString;
  except
    on E : Exception do
    begin
      DetailText := '������ ����� SIM �����.'#13#10 + E.Message;
    end;
  end;

  if DetailText=''  then
  begin
    //ShowMessage('�������� ��������� �������');
    ShowMessage('������ �� ������ SIM ����� ���������');
    dmShowUserSt.qDopPhoneInfo.Close;
    dmShowUserSt.qDopPhoneInfo.Open;
  end
  else
    MessageDlg(DetailText, mtWarning, [mbOk], 0);

end;

procedure TShowUserStatForm.BChangeSIMHistClick(Sender: TObject);
VAr IsAdm:boolean;
begin
  MainForm.CheckAdminPrivs(IsAdm);
ExecuteRRS( FPhoneNumber,IsAdm);
end;

procedure TShowUserStatForm.BitBtn3Click(Sender: TObject);
  var
  AYear, AMonth,ARecNo : Integer;
   DetailText,stt : string;
begin
  AYear := dmShowUserSt.qPeriods.FieldByName('YEAR').AsInteger;
  AMonth := dmShowUserSt.qPeriods.FieldByName('MONTH').AsInteger;
  dmShowUserSt.spMsisdnRefresh.ParamByName('PLOADING_YEAR').AsInteger := AYear;
  dmShowUserSt.spMsisdnRefresh.ParamByName('PLOADING_MONTH').AsInteger := AMonth;
  dmShowUserSt.spMsisdnRefresh.ParamByName('PPHONE_NUMBER').AsString := FPhoneNumber;
  dmShowUserSt.spMsisdnRefresh.ExecProc;
  DetailText := dmShowUserSt.spMsisdnRefresh.ParamByName('PERROR').AsString;
  ARecNo:= dmShowUserSt.qPeriods.RecNo;
  dmShowUserSt.qPeriods.Close;
  dmShowUserSt.qPeriods.Open;
  ARecNo:= dmShowUserSt.qPeriods.MoveBy(ARecNo-1);
  FYear := dmShowUserSt.qPeriods.FieldByName('YEAR').AsInteger;
  FMonth := dmShowUserSt.qPeriods.FieldByName('MONTH').AsInteger;
  if (GetConstantValue('DB_DETAILS')='0') then
  begin
    LoadDetailText;
    PrepareDetail;
  end
  else
  begin
    dmShowUserSt.spGetHBMonth.ParamByName('pYEAR').AsInteger := FYear;
    dmShowUserSt.spGetHBMonth.ParamByName('pMONTH').AsInteger := FMonth;
    dmShowUserSt.spGetHBMonth.ExecProc;
    if dmShowUserSt.spGetHBMonth.ParamByName('RESULT').AsInteger=0 then
    begin
      dmShowUserSt.dsDetail.Enabled:=false;
      dmShowUserSt.dsDetail.DataSet:= dmShowUserSt.vtDetailFile;
      dmShowUserSt.dsDetail.Enabled:=true;
      LoadDetailText;
      PrepareDetail;
    end
    else
    begin
      dmShowUserSt.dsDetail.Enabled:=false;
      dmShowUserSt.dsDetail.DataSet:= dmShowUserSt.qHBDetails;
      dmShowUserSt.dsDetail.Enabled:=true;
      stt:=inttostr(FMonth);
      if length(stt)=1 then
        stt:='0'+stt;
     { if (GetConstantValue('SERVER_NAME')='GSM_CORP') then
              qHBDetails.SQL.Strings[20]:='  decode(c10.dbf_id,4339,null,to_char(nvl(c10.insert_date,(select hbf.load_edate from hot_billing_files hbf';}
      dmShowUserSt.qHBDetails.SQL.Strings[qHBDetailsStrTableNameNum]:=' from call_'+stt+'_'+inttostr(FYear)+' c10';
      dmShowUserSt.qHBDetails.ParamByName('SUBSCR').AsString := FPhoneNumber;
      dmShowUserSt.qHBDetails.Open;
    end;
  end;
 // LoadDetailText;
 // PrepareDetail;
  MessageDlg(DetailText, mtInformation, [mbOk], 0);
end;

procedure TShowUserStatForm.btRefreshOptionListClick(Sender: TObject);
var
 DetailText:string;
 YearMonth:integer;
begin
  btRefreshOptionList.enabled:=false;
  dmShowUserSt.qOptionsPer.Close;
  dmShowUserSt.qOptions.Close;
  dmShowUserSt.spLoadPhoneOptions.ParamByName('pPHONE_NUMBER').AsString := FPhoneNumber;
  dmShowUserSt.spLoadPhoneOptions.ExecProc;
  DetailText:= dmShowUserSt.spLoadPhoneOptions.ParamByName('PERROR').AsString;
  dmShowUserSt.qOptions.ParamByName('PHONE_NUMBER').AsString := FPhoneNumber;
  dmShowUserSt.qOptionsPer.ParamByName('PHONE_NUMBER').AsString:= FPhoneNumber;
  dmShowUserSt.qOptionsPer.Open;
  cbPeriodsOpt.Clear;
  while not dmShowUserSt.qOptionsPer.EOF do
  begin
    YearMonth:= dmShowUserSt.qOptionsPer.FieldByName('YEAR_MONTH').AsInteger;
    cbPeriodsOpt.Items.AddObject(InttoStr(YearMonth div 100)+' - '+InttoStr(YearMonth mod 100), Pointer(YearMonth));
    dmShowUserSt.qOptionsPer.Next;
  end;
  if cbPeriodsOpt.Items.Count > 0 then
    cbPeriodsOpt.ItemIndex := 0;
  cbPeriodsOptChange(Sender);
  btRefreshOptionList.enabled:=true;
  MessageDlg(DetailText, mtInformation, [mbOk], 0);
end;

procedure TShowUserStatForm.BitBtn5Click(Sender: TObject);
begin
  DoShowBillDetails(FPhoneNumber, FYear*100+FMonth, 'SMS/USSD','SMSUSSD');
end;

procedure TShowUserStatForm.BitBtn6Click(Sender: TObject);
var
  cr : TCursor;
  ACaption : String;
begin
  cr := Screen.Cursor;
  Screen.Cursor := crHourGlass;
  ACaption := '����������� ������ ������� �� ������ '
      + FPhoneNumber;
  try
    ExportDBGridToExcel(ACaption,'',
      CRDBGrid4, False, True);
  finally
    Screen.Cursor := cr;
  end;
end;

procedure TShowUserStatForm.BitBtn_MN_RoamingClick(Sender: TObject);
var SqlOra : TOraQuery;
 vMN_ROAMING : integer;
 sql_text, vMN_ROAMING_TEXT : string;
begin

  if dmShowUserSt.qContractInfo.FieldByName('MN_ROAMING').AsInteger=1 then
  begin
    vMN_ROAMING:=0;
    vMN_ROAMING_TEXT:='�� ������� ��������';
  end;

  if dmShowUserSt.qContractInfo.FieldByName('MN_ROAMING').AsInteger<> 1 then
  begin
    vMN_ROAMING:=1;
    vMN_ROAMING_TEXT:='�� ������� ��������';
  end;

  SqlOra:=TOraQuery.Create(nil);

  sql_text:='Update contracts set MN_ROAMING='+inttostr(vMN_ROAMING)+' where CONTRACT_ID='+InttoStr(FContractID);

  try
    SqlOra.Close;
    SqlOra.SQL.Add(sql_text);
    SqlOra.Prepare;
    SqlOra.ExecSql;

    if vMN_ROAMING=0 then
      MessageDlg(vMN_ROAMING_TEXT,mtInformation,[mbOK], 0)
    else
      MessageDlg(vMN_ROAMING_TEXT,mtInformation,[mbOK], 0);

  except
    on e : exception do
      MessageDlg('������ ������� ������ � ������� ���������� '+sql_text, mtError, [mbOK], 0);
  end;

  SqlOra:=TOraQuery.Create(nil);
      //    (GET_LOG_SOURCE_ID(''CONTRACTS_MN_ROAMING'')
  sql_text:='INSERT INTO MANY_LOGS (LOG_SOURCE_ID,PHONE_NUMBER,TEXT_MESSAGES,LOGIN_SESSION, DATE_ON )'+
           ' VALUES ( 11,'+FPhoneNumber+','''+vMN_ROAMING_TEXT+''','''+mainform.OraSession.Username+''', sysdate )';
 // sql_text:='INSERT INTO MANY_LOGS (LOG_SOURCE_ID,PHONE_NUMBER) VALUES (11,9689681650) ';
  try
    SqlOra.Close;
    SqlOra.SQL.Add(sql_text);
    SqlOra.Prepare;
    SqlOra.ExecSql;

  except
    on e : exception do
      MessageDlg(sql_text, mtError, [mbOK], 0);
  end;

// 19610 - ���������� � �� ��������
  MN_ROAMING;

end;

procedure TShowUserStatForm.btUnloadClick(Sender: TObject);
var OraStoredProc:TOraStoredProc;
begin
  if OpenDialog1.Execute then
  begin
    OraStoredProc := TOraStoredProc.Create(self);
    with OraStoredProc do
    begin
       StoredProcName := 'DOWNLOAD_BILL_BLOB';
       PrepareSQL;  // receive parameters
//          ParamByName('p_ID').AsInteger := 10;
      ParamByName('SFILENAME').AsString := ExtractFileName(OpenDialog1.FileName);
      ParamByName('BDATA').ParamType := ptInput;  // to transfer Lob data to Oracle
      ParamByName('BDATA').AsOraBlob.LoadFromFile(OpenDialog1.FileName);
      Execute;
    end;
    OraStoredProc.Free;
    //OraQuery1.ParamByName('SFILENAME').AsString:=OpenDialog1.FileName;
    //OraQuery1.ParamByName('SDATA').LoadFromFile(OpenDialog1.FileName,ftBlob) ;
    //OraStoredProc1.ParamByName('SFILENAME').AsString:=OpenDialog1.FileName;
    //OraStoredProc1.ParamByName('BDATA').LoadFromFile(OpenDialog1.FileName,ftBlob) ;
    //OraStoredProc1.ExecProc;
    //OraQuery1.ExecSQL;
    //mainform.OraSession.Commit;
  end;
end;

procedure TShowUserStatForm.BUnbilledCallsListClick(Sender: TObject);
  procedure Pclose(sender:TObject);
  begin
    (sender as TForm).ModalResult := mrOk;
  //sender.Destroy;
  end;
  procedure ToExcel(sender:TObject);
  var
    cr : TCursor;
    ACaption : String;
    ANameFile : string;
  begin
    cr := Screen.Cursor;
    Screen.Cursor := crHourGlass;
    ACaption := '����������� ����������� �� ������ '+(sender as TCRDBGrid).Hint;
    ANameFile:=(sender as TCRDBGrid).Hint+'_Detail_'+DateToStr(now);
    try
      ExportDBGridToExcel(ACaption,ANameFile,
        (sender as TCRDBGrid), False, True);
    finally
      Screen.Cursor := cr;
    end;
  end;


var
  fList : TForm;
  Mcloselsit , Mto_excel : TMethod;
  qBH : TOraQuery;
  dsBH : TDataSource;
  tBH : TCRDBGrid;
  q_num : integer;
  popMenu : TPopupMenu;
  NewItem : TMenuItem;


begin

  if GetConstantValue('SHOW_DETAIL_API')<>'1' then
    exit;
  flist := tform.Create(self);
  with flist do
  begin
    //  FormStyle:=fsMDIChild;
    BorderStyle := bsSingle;
    Caption := '����������� ����������� �� ������ '+FPhoneNumber;
    Position := poScreenCenter;
    Width := 760;
    Height := 540;
  end;

  qBH := TOraQuery.Create(flist);
  with qBH do
  begin
    sql.Clear;
    Params.Clear;
    params.CreateParam(ftString, 'q_num', ptInput);
    params.ParamByName('q_num').Value := FPhoneNumber;

     sql.Add('select ' +#13#10+
            ' callDate, ' +#13#10+
            '  callNumber, ' +#13#10+
            '  callToNumber, ' +#13#10+
            '  serviceName, ' +#13#10+
            '  callType, ' +#13#10+
            '  dataVolume, ' +#13#10+
            '  COST_STR_TO_NUMBER(callAmt) callAmt, ' +#13#10+
            '  callDuration '+#13#10+
            'from TABLE(GET_UNBILLED_CALLS_LIST_PIPE(:q_num))'
           );
  end;

  dsBH := TDataSource.Create(flist);
  with dsBH do
  begin
    DataSet := qBH;
    Enabled := true;
  end;

  tBH := TCRDBGrid.Create(flist);
  with tBH do
  begin
    parent := fList;
    DataSource := dsBH;
    align := alClient;
    Visible := true;
    Mcloselsit.Code := @pclose;
    Mcloselsit.Data := tBH.Parent;
    ReadOnly := true;
    OnDblClick := TNotifyEvent(Mcloselsit);
    Hint := FPhoneNumber;
  end;
  try
    qBH.open;
  finally
    with tbh.Columns do
    begin
      Items[0].Title.caption := '����\�����';
      Items[1].Title.caption := '��';
      Items[1].Width := 70;
      Items[2].Title.caption := '����';
      Items[2].Width := 70;
      Items[3].Title.caption := '������';
      Items[3].Width := 100;
      Items[4].Title.caption := '��� ������';
      Items[4].Width := 100;
      Items[5].Title.caption := '����� ������';
      Items[5].Width := 90;
      Items[6].Title.caption := '���������';
      Items[6].Width := 60;
      Items[7].Title.caption := '������������';
      Items[7].Width := 90;
    end;
    popMenu := TPopupMenu.Create(flist);
    Mto_excel.Code := @ToExcel;
    Mto_excel.Data := tBH;
    NewItem := TMenuItem.Create(popMenu);
    with NewItem do
    begin
      OnClick := TNotifyEvent(Mto_excel);
      Caption := '��������� � Excel';
    end;

    popMenu.Items.Add(NewItem);
    tBH.PopupMenu := popMenu;
    if not qbh.Eof then
    begin
      fList.ShowModal;
    end
    else
    begin
      ShowMessage('��� ������.');
      flist.Destroy;
    end;
  end;

end;

procedure TShowUserStatForm.B_ecareClick(Sender: TObject);
var
webform:TFormWeb;
begin
webform:=TFormWeb.Create(self);
  with webform do
  try
   Phone_n:=FPhoneNumber;
   activated:=False;
   checkNumber;
    if activated then
    begin
     ShowModal; ClosePage;
    end else
    ShowMessage('���� ����� �� ����� ���.������ ��� �����������.');
  finally
    FreeAndNil(webform);
  end;
end;

procedure TShowUserStatForm.BGet_api_servicesClick(Sender: TObject);
var qBH:TOraQuery;
begin
  try
    qBH:=TOraQuery.Create(nil);
    with qBH do begin
      params.CreateParam(ftString,'p_phone',ptInput);
      params.ParamByName('p_phone').Value:=FPhoneNumber;
      sql.Add('select beeline_api_pckg.phone_options (to_number(:p_phone)) state from dual');
      Execute;
      //ShowMessage(FieldByName('state').AsString);
    end;
  finally
    qbh:=nil;
  end;
  dmShowUserSt.qOptions.Close;
  dmShowUserSt.qOptions.Open;
  dmShowUserSt.qAPIOptionHistory.Close;
  dmShowUserSt.qAPIOptionHistory.Open;
end;

procedure TShowUserStatForm.btAddNoBlockClick(Sender: TObject);
var qTemp : TOraQuery ;
begin
  try
    qTemp:=TOraQuery.Create(self);
    qTemp.SQL.Clear;
    qTemp.SQL.Append('INSERT INTO PHONE_NUMBER_BLOCK_DENIED(PHONE_NUMBER)');
    qTemp.SQL.Append('  VALUES(' + FPhoneNumber + ')');
    qTemp.ExecSQL;
    qTemp.Free;
    Application.MessageBox(PChar('�������� � ������ �������� �������.'),
        '��������������', MB_OK+MB_ICONWARNING);
  except
    Application.MessageBox(PChar('������.'),
        '��������������', MB_OK+MB_ICONWARNING);
  end;
end;

procedure TShowUserStatForm.BlockListBtClick(Sender: TObject);
var
  RefFrm : TBlockListFrm;
begin
  RefFrm := TBlockListFrm.Create(Application);
  try
    RefFrm.Execute(FPhoneNumber, True);
  finally
    FreeAndNil(RefFrm);
  end;
end;

procedure TShowUserStatForm.BlockPhone(StatusCode: String);
var
  DetailText : String;
  buttonSelected : Integer;
begin
  if Trim (StatusCode) <> '' then
  begin

    if GetConstantValue('SHOW_CONTRACT_DOP_STATUS')='1' then
    begin
      if btPostDopStatus.Enabled then
      begin
        ShowMessage('������, �� �� ������� ���. ������!');
        exit;
      end;
      if dmShowUserSt.qContractInfo_DopStatus.FieldByName('DOP_STATUS').AsString='' then
      begin
        ShowMessage('������ ����������� ������� ��� ���������� ���. �������!');
        exit;
      end;
    end;

    buttonSelected := MessageDlg('�� ������������� ������ ������������� ������ ����� ��������?', mtCustom, mbOKCancel, 0);

    if buttonSelected = mrCancel then
      exit;
    if (RGBlock.Visible=true) and (Integer(RGBlock.Items.Objects[RGBlock.ItemIndex])=3) then
    begin
      dmShowUserSt.LoaderBlockPhoneNum2.ParamByName('pPHONE_NUMBER').AsString := FPhoneNumber;
      dmShowUserSt.LoaderBlockPhoneNum2.ParamByName('pCODE').AsString := StatusCode;
      try
        dmShowUserSt.LoaderBlockPhoneNum2.ExecProc;
        DetailText := dmShowUserSt.LoaderBlockPhoneNum2.ParamByName('RESULT').AsString;
        FDetailText := DetailText;
      except
        on E : Exception do
        begin
          DetailText := '������ ����������.'#13#10 + E.Message;
        end;
      end;
      if DetailText=''  then
        ShowMessage('�������� ��������� �������')
      else
        MessageDlg(DetailText, mtWarning, [mbOk], 0);
    end
    else
    begin
      dmShowUserSt.LoaderBlockPhoneNum.ParamByName('pPHONE_NUMBER').AsString := FPhoneNumber;
      if (RGBlock.Visible=true) and (Integer(RGBlock.Items.Objects[RGBlock.ItemIndex])=2) then
        dmShowUserSt.LoaderBlockPhoneNum.ParamByName('PNEW_SITE_METHOD').AsInteger:=1
      else
        dmShowUserSt.LoaderBlockPhoneNum.ParamByName('PNEW_SITE_METHOD').Clear;

      try
        dmShowUserSt.LoaderBlockPhoneNum.ExecProc;
        DetailText := dmShowUserSt.LoaderBlockPhoneNum.ParamByName('RESULT').AsString;
        FDetailText := DetailText;
      except
        on E : Exception do
        begin
          DetailText := '������ ����������.'#13#10 + E.Message;
        end;
      end;

      if DetailText=''  then
        ShowMessage('�������� ��������� �������')
      else if (RGBlock.Visible=true) and (Integer(RGBlock.Items.Objects[RGBlock.ItemIndex])=2) then
        ShowMessage(DetailText)
      else
        MessageDlg(DetailText, mtWarning, [mbOk], 0);
    end;
  end;
end;

procedure TShowUserStatForm.bRefreshSIMClick(Sender: TObject);
Var DetailText : String;
begin
  dmShowUserSt.PUpdateSIM.ParamByName('pPHONE_NUMBER').AsString := FPhoneNumber;
  try
    dmShowUserSt.PUpdateSIM.ExecProc;
    DetailText := dmShowUserSt.PUpdateSIM.ParamByName('RESULT').AsString;
  except
    on E : Exception do
    begin
      DetailText := '������ ���������� ������ SIM �����.'#13#10 + E.Message;
    end;
  end;

  if DetailText='OK!'  then
  begin
    ShowMessage('����� ��� ����� ��������!');
    dmShowUserSt.qDopPhoneInfo.Close;
    dmShowUserSt.qDopPhoneInfo.Open;
  end
  else
    MessageDlg(DetailText, mtWarning, [mbOk], 0);
end;

procedure TShowUserStatForm.btAbonPeriodListClick(Sender: TObject);
var
  cr : TCursor;
  ACaption : String;
begin
  cr := Screen.Cursor;
  Screen.Cursor := crHourGlass;
  ACaption := '������� ����������� ����������� ����� �� ������ '
      + FPhoneNumber;
  try
    ExportDBGridToExcel(ACaption,'',
      grAbonPeriodList, False, True);
  finally
    Screen.Cursor := cr;
  end;
end;

procedure TShowUserStatForm.btAddDepositClick(Sender: TObject);
var
  RefFrm : TAddDepositeFrm;
begin
  RefFrm:=TAddDepositeFrm.Create(Application);
  RefFrm.ContractID:=FContractID;
  RefFrm.mAddDepositNote.Text:='';
  RefFrm.ShowModal;
  dmShowUserSt.qDepositOper.Close;
  dmShowUserSt.qDepositOper.Open;
  dmShowUserSt.qDeposit.Close;
  dmShowUserSt.qDeposit.Open;
end;

procedure TShowUserStatForm.btAddFilterClick(Sender: TObject);
begin
 if not CheckDate then exit;
 AddFilter;
 //qHot
end;

procedure TShowUserStatForm.btAddPromisedPaymentClick(Sender: TObject);
var Itog: string;
    PromisedSum: double;
    PromisedDade: TDateTime;
    MaxSumVar: variant;
    MaxSum: real;
begin
  Itog:='';

  try
    PromisedSum:=StrToInt(ePromisedSum.Text);
  except
    ShowMessage('������� ��������� ����� �������');
    Exit;
  end;
  try
    PromisedDade:=sdePromisedDate.Date;
  except
    ShowMessage('������� ��������� ���� �������');
    Exit;
  end;

  MaxSumVar := GetMaxPROMISED_PAYMENT(mainform.OraSession.Username);
  if VarIsNull(MaxSumVar) then
    MaxSum := 0
  else
    MaxSum := MaxSumVar;

  dmShowUserSt.spAddPrPayment.ParamByName('PPAYMENT_SUM').AsFloat:=PromisedSum;
  dmShowUserSt.spAddPrPayment.ParamByName('PPAYMENT_DATE').AsDateTime:=PromisedDade;
  if ((MainForm.UserRightsType=3) and (UpperCase(mainform.OraSession.Username)<> UpperCase(GetParamValue('USER_TELETIE_EXCEPTION')))) then begin
    if (PromisedSum > MaxSum) then begin
     ShowMessage('����� ������� �� ����� ���� ������ ' + floattostr(MaxSum) + ' ������. ������� ��������: '+FloatToStrF(PromisedSum, ffNumber, 15, 2));
     Exit;
    end;
    if (Trunc(PromisedDade)<>Trunc((Now+4))) then begin
     ShowMessage('���� ����� ���� ������ '+DateToStr(Now+4)+'. ������� ���� - '+DateToStr(PromisedDade));
     Exit;
    end;

  end;

  if (MainForm.UserRightsType=2) then begin
    if (PromisedSum > MaxSum) then begin
     ShowMessage('����� ������� �� ����� ���� ������ ' + floattostr(MaxSum) + ' ������. ������� ��������: '+FloatToStrF(PromisedSum, ffNumber, 15, 2));
     Exit;
    end;
    if (Trunc(PromisedDade)>Trunc((Now+4))) then begin
     ShowMessage('���� ����� �� ���� ������ '+DateToStr(Now+4)+'. ������� ���� - '+DateToStr(PromisedDade));
     Exit;
    end;

  end;

  try
    dmShowUserSt.spAddPrPayment.ExecProc;
    Itog:= dmShowUserSt.spAddPrPayment.ParamByName('RESULT').AsString;
  except
    Itog:='�� ������� �������� ��������� ������';
  end;
  ShowMessage(Itog);
  dmShowUserSt.qPrPayments.Close;
  dmShowUserSt.qPrPayments.Open;
end;

procedure TShowUserStatForm.btAPITurnOnServisesClick(Sender: TObject);
begin
  TurnOnOffOption(FPhoneNumber, 'A', '');
  dmShowUserSt.qAPIOptionHistory.Close;
  dmShowUserSt.qAPIOptionHistory.Open;
end;

procedure TShowUserStatForm.btBillBeelineClick(Sender: TObject);
var
  cr : TCursor;
  ACaption : String;
begin
  cr := Screen.Cursor;
  Screen.Cursor := crHourGlass;
  ACaption := '��������� ����� ������� �� ������ '
      + FPhoneNumber;
  try
    ExportDBGridToExcel(ACaption,'',
      grBillBeeline, False, True);
  finally
    Screen.Cursor := cr;
  end;
end;

procedure TShowUserStatForm.btBillClientClick(Sender: TObject);
var
  cr : TCursor;
  ACaption : String;
begin
  cr := Screen.Cursor;
  Screen.Cursor := crHourGlass;
  ACaption := '����������� ������ �� ������ '
      + FPhoneNumber;
  try
    ExportDBGridToExcel(ACaption,'',
      CRDBGridClientBills, False, True);
  finally
    Screen.Cursor := cr;
  end;
end;

procedure TShowUserStatForm.btBillClientNewClick(Sender: TObject);
var
  cr : TCursor;
  ACaption : String;
begin
  cr := Screen.Cursor;
  Screen.Cursor := crHourGlass;
  ACaption := '��������� ����������� ������ ��� ������� �� ������ '
      + FPhoneNumber;
  try
    ExportDBGridToExcel(ACaption,'',
      grBillClientNew, False, True);
  finally
    Screen.Cursor := cr;
  end;
end;

procedure TShowUserStatForm.btBlockBySaveClick(Sender: TObject);
begin
  BlockPhone (GetParamValue('BEELINE_BLOCK_CODE_FOR_BLOCK_SAVE'));
end;

procedure TShowUserStatForm.UnBlockListBtClick(Sender: TObject);
var
  RefFrm : TUnBlockListFrm;
begin
  RefFrm := TUnBlockListFrm.Create(Application);
  try
    RefFrm.Execute(FPhoneNumber, True);
  finally
    FreeAndNil(RefFrm);
  end;
end;

procedure TShowUserStatForm.CbHandBlockClick(Sender: TObject);
begin
  if (FContractID<>0)and(GetConstantValue('HAND_BLOCK_IS_ROBOT_BLOCK')='1') then
    if cbHandBlock.Checked<>FHandBlockChecked then
    begin
      if cbHandBlock.Checked then
      begin
        pnlNewHB.Show;
        pnlShowHB.Hide;
      end
      else
      begin
        pnlNewHB.Hide;
        pnlShowHB.Hide;
        dmShowUserSt.spSetHandBlockEndDate.ParamByName('PHAND_BLOCK_END_DATE').Value:=null;
        dmShowUserSt.spSetHandBlockEndDate.ParamByName('PBALANCE_NOTICE_HAND_BLOCK').Value:=null;
        dmShowUserSt.spSetHandBlockEndDate.ParamByName('PBALANCE_BLOCK_HAND_BLOCK').Value:=null;
        dmShowUserSt.spSetHandBlockEndDate.ExecSQL;
      end;
    FHandBlockChecked:=cbHandBlock.Checked;
    end;
end;

procedure TShowUserStatForm.CbHandBlockExit(Sender: TObject);
begin
  if GetConstantValue('HAND_BLOCK_IS_ROBOT_BLOCK')<>'1' then
  begin
    dmShowUserSt.qSelBalDate.Close;
    dmShowUserSt.qHandBlock.SQL.Clear;
    dmShowUserSt.qSelBalDate.ParamByName('PHONE_NUMBER').AsString:=FPhoneNumber;
    dmShowUserSt.qSelBalDate.Open;
    if CbHandBlock.Visible and (CbHandBlock.Checked <> FHandBlockChecked) then
    begin
      if CbHandBlock.Checked then
      begin
        dmShowUserSt.qHandBlock.Close;
        dmShowUserSt.qHandBlock.SQL.Add('Update contracts set hand_block=1 where CONTRACT_ID='+InttoStr(FContractID)+' and (PHONE_NUMBER_CITY='+FPhoneNumber+' or PHONE_NUMBER_FEDERAL='+FPhoneNumber+')');
        dmShowUserSt.qHandBlock.Prepare;
        dmShowUserSt.qHandBlock.ExecSql;
      end
      else
      begin
        dmShowUserSt.qHandBlock.Close;
        dmShowUserSt.qHandBlock.SQL.Add('Update contracts set hand_block=0 where CONTRACT_ID='+InttoStr(FContractID)+' and (PHONE_NUMBER_CITY='+FPhoneNumber+' or PHONE_NUMBER_FEDERAL='+FPhoneNumber+')');
        dmShowUserSt.qHandBlock.Prepare;
        dmShowUserSt.qHandBlock.ExecSql;
      end;
      FHandBlockChecked := CbHandBlock.Checked;
    end;
  end;
end;

procedure TShowUserStatForm.cbHideZeroCallClick(Sender: TObject);
begin
  if cbHideZeroCall.Checked then
  begin
    dmShowUserSt.vtDetailFile.Filter:='SERVICE_COST<>"0"';
    dmShowUserSt.vtDetailFile.Filtered:=true;
    dmShowUserSt.qHBDetails.Filter:='SERVICE_COST<>"0"';
    dmShowUserSt.qHBDetails.Filtered:=true;
  end
  else
  begin
    dmShowUserSt.vtDetailFile.Filter:='';
    dmShowUserSt.vtDetailFile.Filtered:=false;
    dmShowUserSt.qHBDetails.Filter:='';
    dmShowUserSt.qHBDetails.Filtered:=false;
  end;
end;

procedure TShowUserStatForm.cbPeriodsOptChange(Sender: TObject);
begin
  if cbPeriodsOpt.Items.Count > 0 then
  begin
    dmShowUserSt.qOptions.ParamByName('YEAR_MONTH').AsInteger:=
      Integer(cbPeriodsOpt.Items.objects[cbPeriodsOpt.ItemIndex]);
    dmShowUserSt.qOptions.Close;
    dmShowUserSt.qOptions.Open;
  end;
end;

procedure TShowUserStatForm.cb_Hide_detailClick(Sender: TObject);
begin
  inc(cbexcept1);
  if cbexcept1=0 then
    exit;
  if cb_Hide_detail.Checked then
    with qexcept1 do
    begin
      Append;
      dbgDetail.Visible:=false;
      btUnload.Visible:=false;
      BitBtn2.Visible:=false;
      btSendMail.Visible:=false;
      BUnbilledCallsList.Visible:=False;
      post;
    end
  else
    with qexcept1 do
    begin
      delete;
      dbgDetail.Visible:=true;
      btUnload.Visible:=true;
      BitBtn2.Visible:=true;
      btSendMail.Visible:=true;
      BUnbilledCallsList.Visible:=true;
    end;
  qexcept1.Refresh;
end;

function TShowUserStatForm.FindComponentEx(const Name: string): TComponent;
var
   FormName: string;
   CompName: string;
   P: Integer;
   Found: Boolean;
   Form: TForm;
   I: Integer;
 begin
   // Split up in a valid form and a valid component name
  P := Pos('.', Name);
   if P = 0 then
   begin
     raise Exception.Create('No valid form name given');
   end;
   FormName := Copy(Name, 1, P - 1);
   CompName := Copy(Name, P + 1, High(Integer));
   Found    := False;
   // find the form
  for I := 0 to Screen.FormCount - 1 do
   begin
     Form := Screen.Forms[I];
     // case insensitive comparing
    if AnsiSameText(Form.Name, FormName) then
     begin
       Found := True;
       Break;
     end;
   end;
   if Found then
   begin
     for I := 0 to Form.ComponentCount - 1 do
     begin
       Result := Form.Components[I];
       if AnsiSameText(Result.Name, CompName) then Exit;
     end;
   end;
   Result := nil;
 end;
procedure TShowUserStatForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if FContractID<>0 then
    EditAbonentFrame.PrepareFrameByContractID('EDIT', FContractID);
  dmShowUserSt.qSelBalDate.Close;
  dmShowUserSt.qHandBlock.SQL.Clear;
  dmShowUserSt.qSelBalDate.ParamByName('PHONE_NUMBER').AsString:=FPhoneNumber;
  dmShowUserSt.qSelBalDate.Open;
  if CbHandBlock.Visible and (CbHandBlock.Checked <> FHandBlockChecked) then
  begin
    if CbHandBlock.Checked then
    begin
      dmShowUserSt.qHandBlock.Close;
      dmShowUserSt.qHandBlock.SQL.Add('Update contracts set hand_block=1 where CONTRACT_ID='+InttoStr(FContractID)+' and (PHONE_NUMBER_CITY='+FPhoneNumber+' or PHONE_NUMBER_FEDERAL='+FPhoneNumber+')');
      dmShowUserSt.qHandBlock.Prepare;
      dmShowUserSt.qHandBlock.ExecSql;
    end
    else
    begin
      dmShowUserSt.qHandBlock.Close;
      dmShowUserSt.qHandBlock.SQL.Add('Update contracts set hand_block=0 where CONTRACT_ID='+InttoStr(FContractID)+' and (PHONE_NUMBER_CITY='+FPhoneNumber+' or PHONE_NUMBER_FEDERAL='+FPhoneNumber+')');
      dmShowUserSt.qHandBlock.Prepare;
      dmShowUserSt.qHandBlock.ExecSql;
    end;
    FHandBlockChecked := CbHandBlock.Checked;
  end;
  FreeAndNil(qexcept);

end;

procedure TShowUserStatForm.FormCreate(Sender: TObject);
Var
  IsAdm:boolean;
begin
  SetDataModuleSettings;

  if GetConstantValue('USE_DETAIL_HIDE_PHONES')<>'1' then
    cb_Hide_detail.hide;

  if GetConstantValue('SERVER_NAME')<>'CORP_MOBILE' then
  begin
    //BGet_api_services.Visible:=False;
    dbgDetail.Columns[13].Visible := False;
    IS_BS_CHECK.Visible:=false;
    BtnSendBal.Visible:=false;
    CBnewcab.Visible:=false;
    CBnewcab.Checked:=false;
  end;

  if GetConstantValue('SHOW_DETAIL_API')<>'1' then
    BUnbilledCallsList.Visible:=False;


  if GetConstantValue('SHOW_SEND_MAIL_INFO_ABON')='1' then begin
    btSendMail.Visible:=true;
    btSendMail.Enabled:=true;
    edEmailAdress.Visible:=true;
    lbBegindate.Visible:=true;
    lbEndDate.Visible:=true;
    dtBegin.Visible:=true;
    dtEnd.Visible:=true;
    btAddFilter.Visible:=true;
    cbFree.Visible:=true;
  end;
  if GetConstantValue('USE_TYPE_PAYMENTS') <> '1' then begin
    gPayments.Columns[7].Visible:=false;
    gPayments.Columns[8].Visible:=false;
  end;

  if (GetConstantValue('BLOCK_TYPES_ENABLE')='1') then begin
    dmShowUserSt.qRGBlock.Open;
    dmShowUserSt.DsRGBlock.DataSet.First;
    while Not (dmShowUserSt.DsRGBlock.DataSet.Eof) do
    begin
      RGBlock.Items.AddObject(
      dmShowUserSt.qRGBlock.FieldByName('BLOCK_TYPE_NAME').AsString,
      TObject(dmShowUserSt.qRGBlock.FieldByName('BLOCK_TYPE_ID').AsInteger)
      );
      dmShowUserSt.DsRGBlock.DataSet.next;
    end;
    dmShowUserSt.qRGBlock.Close;
    RGBlock.ItemIndex:=1;
  end
  else RGBlock.Visible:=false;
  MainForm.CheckAdminPrivs(IsAdm);
  if (GetConstantValue('REPLACE_SIM_ENABLE')='0')
    or ((GetConstantValue('REPLACE_SIM_ADM_ENABLE')='1') and (NOT isadm)) then
  begin
    LChangeSIM.Visible:=false;
    EChangeSIM.Visible:=false;
    BChangeSIM.Visible:=false;
  end;
  if (GetConstantValue('SERVER_NAME')<>'CORP_MOBILE') or (not isadm) then
    B_ecare.Visible:=False;

  if GetConstantValue('CALC_ABON_PAYMENT_TO_MONTH_END') = '1' then
  begin
    cbDailyAbonPay.Show;
    cbDailyAbonPayBanned.Show;
    if IsAdm then
      cbDailyAbonPay.Enabled:=true
    else
      cbDailyAbonPay.Enabled:=false;
  end
  else
  begin
    cbDailyAbonPay.Hide;
    cbDailyAbonPayBanned.Hide;
  end;

  if GetConstantValue('SERVER_NAME') = 'SIM_TRADE' then
    tsRest.TabVisible := False;

end;

procedure TShowUserStatForm.FormShow(Sender: TObject);
var
i:integer;
C: TComponent;
begin
  with dm do
  begin
    qformaccess.Close;
    qformaccess.ParamByName('FORM_NAME').AsString:='ShowUserStatForm';
    qformaccess.ParamByName('USER_NAME').AsString:=mainform.OraSession.Username;
    qformaccess.ParamByName('RIGHTS_TYPE').AsInteger:=MainForm.UserRightsType;
    qformaccess.ParamByName('CHECK_ALLOW_ACCOUNT').AsInteger:=MainForm.Allow_account;
    qformaccess.execsql;
    for I := 0 to qFormAccess.RecordCount-1 do
    begin
      try
        C := FindComponentex('ShowUserStatForm.'+qformaccess.FieldByName('COMPONENT_NAME').AsString);
        if qformaccess.FieldByName('IS_ACTIVE').AsInteger=1 then
          TWinControl(C).Enabled:=true
        else
          TWinControl(C).Enabled:=false;
        if qformaccess.FieldByName('IS_VISIBLE').AsInteger=1 then
          TWinControl(C).Visible:=true
        else
          TWinControl(C).Visible:=false;
      except
       ShowMessage('������ ������ ���������� '+qformaccess.FieldByName('COMPONENT_NAME').AsString);
      end;
    end;
  end;
  //PageControl1.ActivePage:=tsTariffs;
end;

procedure TShowUserStatForm.gPaymentsCellClick(Column: TColumn);
begin
  MonthCalendar1.Visible:=false;
end;

procedure TShowUserStatForm.gPaymentsDblClick(Sender: TObject);
  // 25.10.2012 �. �. �������� ��������� �������
var
  FChangeContractForm : TRegisterPaymentForm;
  FReceivedPaymentID: String;
  AdminPriv : boolean;
  //ChangePaymentFrm: TChangePaymentFrm;     // -- ������ ������

begin
  //10.12 �. ��������� �������� - ������������ ����������� ������� ��� ��������� �����
  MainForm.CheckAdminPrivs(AdminPriv);
  //AdminPriv := false;  // �������� ��� �������
  if AdminPriv then
  begin
    if not (dmShowUserSt.qPaymentsRECEIVED_PAYMENT_ID.AsString = '') then
      begin
        FChangeContractForm := TRegisterPaymentForm.Create(nil);

        FChangeContractForm.TARIFF_ID.Enabled := False;
        FChangeContractForm.FILIAL_ID.Enabled := False;
        FChangeContractForm.PAYMENT_DATE_TIME.Enabled := False;

        try
          FChangeContractForm.PrepareForm('EDIT', dmShowUserSt.qPaymentsRECEIVED_PAYMENT_ID.AsString, Null);
          if (mrOk = FChangeContractForm.ShowModal) then
            dmShowUserSt.qPayments.Refresh;
        finally
          FChangeContractForm.Free;
        end;
      end
    else
      MessageDlg('����� ������������� ������ ������ �������!',mtError, [mbOK], 0);
  end;

end;

procedure TShowUserStatForm.gSummaryPhoneCellClick(Column: TColumn);
var Line:string;
    YearMonth:Integer;
begin
  Line:=gSummaryPhone.Columns[5].Field.AsString;
  if Pos('����', Line)>0 then
  begin
    YearMonth:=StrToInt(Copy(Line, Length(Line)-3,4)+Copy(Line, Length(Line)-6,2));
    DoShowBillDetails(FPhoneNumber, YearMonth, gSummaryPhone.Columns[5].Field.AsString,'BILL');
  end;
end;

procedure TShowUserStatForm.gSummaryPhoneDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
var Im1: TBitmap;
    BS: TStream;
begin
  if Column.FieldName = 'IMAGE_BMP' then
    if not dmShowUserSt.qSummaryPhone.FieldByName('IMAGE_BMP').IsNull then
    begin
      gSummaryPhone.Canvas.Brush.Color := clWhite;
      gSummaryPhone.Canvas.FillRect(Rect);

      Im1 := TBitmap.Create;//��������
      try
        Im1.Assign(TBLOBField(dmShowUserSt.qSummaryPhone.FieldByName('IMAGE_BMP')));
        gSummaryPhone.Canvas.Draw(round((Rect.Left+Rect.Right-Im1.Width)/2),Rect.Top,Im1);
      finally
        Im1.Free;
      end;
    end;
end;

procedure TShowUserStatForm.IS_BILL_CHECKClick(Sender: TObject);
var
  d,AYear, AMonth : Integer;
  stt:string;
begin
  if IS_BILL_CHECK.Checked then
  begin
    dmShowUserSt.dsDetail.Enabled:=false;
    dmShowUserSt.dsDetail.DataSet:= dmShowUserSt.vtDetailFile;
    dmShowUserSt.dsDetail.Enabled:=true;
    LoadBillDetailText;
    PrepareDetail;
  end
  else
    if (GetConstantValue('DB_DETAILS')='0') then
    begin
      LoadDetailText;
      PrepareDetail;
    end
    else
    begin
      dmShowUserSt.spGetHBMonth.ParamByName('pYEAR').AsInteger := FYear;
      dmShowUserSt.spGetHBMonth.ParamByName('pMONTH').AsInteger := FMonth;
      dmShowUserSt.spGetHBMonth.ExecProc;
      if dmShowUserSt.spGetHBMonth.ParamByName('RESULT').AsInteger=0 then
      begin
        IS_BS_CHECK.Enabled:=true;
        dmShowUserSt.dsDetail.Enabled:=false;
        dmShowUserSt.dsDetail.DataSet:= dmShowUserSt.vtDetailFile;
        dmShowUserSt.dsDetail.Enabled:=true;
        LoadDetailText;
        PrepareDetail;
      end
      else
      begin
        IS_BS_CHECK.Enabled:=false;
        dmShowUserSt.dsDetail.Enabled:=false;
        dmShowUserSt.dsDetail.DataSet:= dmShowUserSt.qHBDetails;
        dmShowUserSt.dsDetail.Enabled:=true;
        stt:=inttostr(FMonth);
        if length(stt)=1 then
          stt:='0'+stt;
        dmShowUserSt.qHBDetails.SQL.Strings[qHBDetailsStrTableNameNum]:=' from call_'+stt+'_'+inttostr(FYear)+' c10';
        dmShowUserSt.qHBDetails.ParamByName('SUBSCR').AsString := FPhoneNumber;
        dmShowUserSt.qHBDetails.Open;
      end;
    end;
end;


procedure TShowUserStatForm.IS_BS_CHECKClick(Sender: TObject);
begin
  PrepareDetail;
end;

{ mySMTP }

procedure mySMTP.Execute;
var
c:integer;
idsmtp1:TIdSMTP;
idMessage1:TIdMessage;
//IdSSLIOHandlerSocketOpenSSL:TIdSSLIOHandlerSocketOpenSSL;
begin
if SMTP_PORT<>25 then begin
 try
  {IdSSLIOHandlerSocketOpenSSL := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
  IdSSLIOHandlerSocketOpenSSL.Destination := SMTP_SRV+':'+IntToStr(SMTP_PORT);
  IdSSLIOHandlerSocketOpenSSL.Host := SMTP_SRV;
  IdSSLIOHandlerSocketOpenSSL.Port := SMTP_PORT;
  IdSSLIOHandlerSocketOpenSSL.DefaultPort := 0;
  IdSSLIOHandlerSocketOpenSSL.SSLOptions.Method := sslvTLSv1;
  IdSSLIOHandlerSocketOpenSSL.SSLOptions.Mode := sslmUnassigned;}
 except
   ShowMessage('������ �������� SSL!');
 end;
end;
 try
  idsmtp1:=TIdSMTP.Create();
 except
   ShowMessage('������ �������� TIdSMTP!');
 end;
 with idsmtp1 do begin
   Host := SMTP_SRV;
   Username :=SMTP_LOG;
   Password:=SMTP_PASS;
   Port:=SMTP_PORT;
   if SMTP_PORT<>25 then begin
     //IOHandler := IdSSLIOHandlerSocketOpenSSL;
     UseTLS := utUseExplicitTLS;
   end;
 end;
 try
  idMessage1:=TIdMessage.Create();
 except
   ShowMessage('������ �������� TIdMessage!');
 end;
 with idMessage1 do begin
 Date := Now;
 From.Text := SMTP_FROM;//SMTP_FROMTXT;
 Recipients.EMailAddresses := SMTP_ADDR;
 Subject := SMTP_TITLE;
 From.Name := SMTP_FROM;//'��������� �����';
 From.Address := SMTP_LOG;
 ContentTransferEncoding:='8bit';
 ContentType := 'multipart/mixed;';
 CharSet := 'Windows-1251';
 Body.Text := SMTP_BODY;
// Body :=SMTP_BODY;
 end;
 try
   TIdAttachmentFile.Create( idMessage1.MessageParts, SMTP_ATT_FILE+'.xls');
  except
    on e : exception do
  ShowMessage('������ �������� TIdAttachmentFile!'#13#10+e.Message);
 end;
  try
     try
     IdSMTP1.Connect;
        try
          IdSMTP1.Send(idMessage1);
          ShowMessage(SMTP_TITLE+': ����������!');
          try
           if FileExists(SMTP_ATT_FILE+'.xltx') then
            DeleteFile(SMTP_ATT_FILE+'.xltx');
          except
            ShowMessage('������ �������� '+SMTP_ATT_FILE+'.xltx!');
          end;
          try
           if FileExists(SMTP_ATT_FILE+'.xls') then
            DeleteFile(SMTP_ATT_FILE+'.xls');
           except
             ShowMessage('������ �������� '+SMTP_ATT_FILE+'.xls!');
           end;
        finally
          IdSMTP1.Disconnect;
        end;
  except
    on e : exception do
             Application.MessageBox(PChar('������. ��������� �� ����������!'#13#10+e.Message),
        '��������������', MB_OK+MB_ICONWARNING);
     end;
  finally
     //������� �� ������
      IdMessage1.Clear;
      idsmtp1.Destroy;
      idMessage1.Destroy;
      //if SMTP_PORT<>25 then
      //IdSSLIOHandlerSocketOpenSSL.Free;
//FreeAndNil(idMessage1);
  end;
end;


 procedure TShowUserStatForm.Send_mail_dop_status;
//19610
var
vSMTP_ADDR, vSMTP_TITLE, vS : String;
//c:integer;
idsmtp1:TIdSMTP;
idMessage1:TIdMessage;
SqlOra : TOraQuery;
f_Send :boolean;
f_Mess :boolean;
begin
        //19610
  f_Send:=false; // �������� ������
  f_Mess:=false; // ��������� �� �����: true - ������ �� ������������, � ��������� ��������� �� �����

   if (vDop_Status='')
   and (cbDopStatus.DataSource.DataSet.FieldByName('Dop_Status').AsInteger<>7)
   and (cbDopStatus.DataSource.DataSet.FieldByName('Dop_Status').AsInteger<>8)
   and (not cbDopStatus.DataSource.DataSet.FieldByName('Dop_Status').IsNull) then
   begin
    vS:=FPhoneNumber+' ������� ������������� �� ���������� ';
    vSMTP_TITLE:=MainForm.OraSession.Username+' : ����� ���.������� �� ������ '+FPhoneNumber;
    f_Send:=true;
    end;

    if cbDopStatus.DataSource.DataSet.FieldByName('Dop_Status').AsInteger=3 then
   begin
    //vS:=FPhoneNumber+' ������� ��������� ��� ������� ������ � ������������� �� ����������';
    vS:=FPhoneNumber+' �������, �������� ����� �� ������� ����� � �������� �������������';
    vSMTP_TITLE:=MainForm.OraSession.Username+' : ����� �� ������ '+FPhoneNumber;
    f_Send:=true;
    end;

    SqlOra:=TOraQuery.Create(nil);
        with SqlOra do
        begin
            sql.Text:='  select case when to_char(sysdate,''hh24:mm'') between ''09:00'' and ''21:00'' then 1   else 0 end as send_or_mess from dual';
            Execute;
            if FieldByName('send_or_mess').AsString='1' then f_Mess:=False
            else
            f_Mess:=True;

        end;

   if f_Mess=True then
   begin
   MessageBox(Handle, '"�� �������� ������������� �� ���������� ����� 0628!!!"',
               '��������!!!', mb_IconWarning);
   end;

    if (f_Send=True) and (f_Mess=false) then
    begin

    SqlOra:=TOraQuery.Create(nil);
        with SqlOra do
        begin
            sql.Text:='select mail_adress from report_mail_recipients  where type_report=''SEND_MAIL_DOP_STATUS'' ';
            Execute;
            vSMTP_ADDR:=FieldByName('mail_adress').AsString;
        end;


         if  vSMTP_ADDR<>'' then
         begin
         idsmtp1:=TIdSMTP.Create();

               with idsmtp1 do
               begin
                 Host := GetParamValue('SMTP_HOST');
                 Username :=GetParamValue('SMTP_USERNAME');
                 Password:=GetParamValue('SMTP_PASSWORD');
               end;

          idMessage1:=TIdMessage.Create();
               with idMessage1 do
               begin
                   Date := Now;
                   From.Text := GetParamValue('SMTP_FROMTEXT');
                   Recipients.EMailAddresses := vSMTP_ADDR;
                   Subject := vSMTP_TITLE;
                   Body.Text := vS;
                   From.Name := '��������� �����';
                   From.Address := GetParamValue('SMTP_USERNAME');
                   ContentTransferEncoding:='8bit';
                   ContentType := 'text/plain';
                   CharSet := 'Windows-1251';
               end;

         try
         IdSMTP1.Connect;
             try
              IdSMTP1.Send(idMessage1);
              finally
              IdSMTP1.Disconnect;
              ShowMessage(vSMTP_TITLE+': ����������!');
              //������� ���������� �� �������� � ������� �����������
              SqlOra:=TOraQuery.Create(self);
                    with SqlOra do
                    begin
                      try
                        sql.Clear;
                        sql.Add ('insert into log_send_mail ');
                        sql.Add('(year_month, phone_number, date_send, mail_subject,note)');
                        sql.Add (' values(to_char(sysdate,''YYYYMM''),'+FPhoneNumber+', sysdate, '''+vS+' �� ������ '+FPhoneNumber+''','''+vSMTP_ADDR+'''||'' User:''||(user))');
                        ExecSQL;
                      except
                        on e : exception do
                          MessageDlg('������ ������� ������ � ������� ����������� �������� ���������(log_send_mail)', mtError, [mbOK], 0);
                      end;
                    end;
                 end;

         finally
         //������� �� ������
          IdMessage1.Clear;
          idsmtp1.Destroy;
          idMessage1.Destroy;
         end;
        end;

     end;

 vDop_Status:=inttostr(cbDopStatus.DataSource.DataSet.FieldByName('Dop_Status').AsInteger);
 if vDop_Status='0' then vDop_Status:='';
 //ShowMessage(MainForm.OraSession.Username+': ����������!');

end;

procedure TShowUserStatForm.SetDataModuleSettings;
begin
  dmShowUserSt.dsTariffInfo.OnDataChange := dsTariffInfoDataChange;
  dmShowUserSt.dsPeriods.OnDataChange := dsPeriodsDataChange;
  dmShowUserSt.dsOptions.OnDataChange := dsOptionsDataChange;
  dmShowUserSt.qPayments.AfterOpen := qPaymentsAfterOpen;
  dmShowUserSt.qPhoneStatusesPHONE_IS_ACTIVE.OnGetText := qPhoneStatusesPHONE_IS_ACTIVEGetText;
  dmShowUserSt.spSetHandBlockEndDate.AfterExecute := spSetHandBlockEndDateAfterExecute;
  dmShowUserSt.qSummaryPhone.BeforeOpen := qSummaryPhoneBeforeOpen;
end;

procedure TShowUserStatForm.SetSmsDisableTimeClick(Sender: TObject);
 var
 Qsms_time: TOraQuery;
begin
 Qsms_time:=TOraQuery.Create(self);
    with Qsms_time do begin
    /////////������ � ���
     Params.CreateParam(ftString,'phone',ptInput);
     Params.CreateParam(ftString,'sms_dis_time',ptInput);
     params.ParamByName('phone').Value:=FPhoneNumber;
     params.ParamByName('sms_dis_time').AsString:=FloatToStrF(smstime.MinData,ffNumber,8,8)+';'+FloatToStrF(smstime.MaxData,ffNumber,8,8)+';';
     sql.add('update contracts t set t.paramdisable_sms=:sms_dis_time where t.phone_number_federal=:phone and '+
              ' not exists (select 1 from contract_cancels cc where cc.contract_id=t.contract_id)' );
       try
       ExecSQL;
       except
       ShowMessage('������ �� ����������.');
       end;
     Close;
     sql.Clear;
    end;
 FreeAndNil(Qsms_time);
end;

procedure TShowUserStatForm.MN_ROAMING;
begin
  dmShowUserSt.qContractInfo.Close;
  dmShowUserSt.qContractInfo.ParamByName('CONTRACT_ID').AsInteger:=FContractID;
  dmShowUserSt.qContractInfo.Open;

  if dmShowUserSt.qContractInfo.FieldByName('MN_ROAMING').AsInteger=1 then
  begin
    BitBtn_MN_Roaming.Caption:='��������� �� �������';
    LB_MN_Roaming.Caption:='�� �������: ��������';

  end
  else
  begin
    BitBtn_MN_Roaming.Caption:='��������� �� �������';
    LB_MN_Roaming.Caption:='�� �������: ��������';

  end;
end;


procedure TShowUserStatForm.MonthCalendar1DblClick(Sender: TObject);
var
  SqlOra : TOraQuery;
  sqltext : string;
begin

  if datetostr(MonthCalendar1.Date)<>gPayments.Fields[0].AsString then
  begin
    if (MonthCalendar1.Date<= dmShowUserSt.qContractInfo.FieldByName('CONTRACT_CANCEL_DATE').AsDateTime)
       and (MonthCalendar1.Date>= dmShowUserSt.qContractInfo.FieldByName('CONTRACT_DATE').AsDateTime) then
    begin

      SqlOra:=TOraQuery.Create(self);
      with SqlOra do
      begin
        try
          sql.Clear;
          sql.Add ('insert into many_logs ');
          sql.Add('(log_source_id, year_month, phone_number, date_on, text_messages,login_session)');
          sql.Add (' values(12, to_char(sysdate,''YYYYMM''),'+FPhoneNumber+', sysdate, ''��������� ���� ������� �'+gPayments.Fields[2].AsString+' � '+gPayments.Fields[0].AsString+' �� '+datetostr(MonthCalendar1.Date)+''','''+MainForm.OraSession.Username+''')');
          ExecSQL;
        except
          on e : exception do
            MessageDlg('������ ������� ������ � ������� ����������� (many_logs)', mtError, [mbOK], 0);
        end;

        try
          sql.Clear;
          sql.Add ('update db_loader_payments set PAYMENT_DATE=to_date('''+datetostr(MonthCalendar1.Date)+''',''dd.mm.yyyy'') where PHONE_NUMBER='+FPhoneNumber+' and ');
          sql.Add(' PAYMENT_DATE=to_date('''+gPayments.Fields[0].AsString+''',''dd.mm.yyyy'') and PAYMENT_SUM='+gPayments.Fields[1].AsString+' and PAYMENT_NUMBER='+gPayments.Fields[2].AsString);

         {sqltext:='update db_loader_payments set PAYMENT_DATE=to_date('''+datetostr(MonthCalendar1.Date)+''',''dd.mm.yyyy'') where PHONE_NUMBER='+FPhoneNumber+' and ';
         sqltext:=sqltext+' PAYMENT_DATE=to_date('''+gPayments.Fields[0].AsString+''',''dd.mm.yyyy'') and PAYMENT_SUM='+gPayments.Fields[1].AsString+' and PAYMENT_NUMBER='+gPayments.Fields[2].AsString;
         ShowMessage(sqltext); }

          ExecSQL;
        except
          on e : exception do
            MessageDlg('������ ��������� ������ � ������� ����.�������� (db_loader_payments)', mtError, [mbOK], 0);
        end;

      end;

      dmShowUserSt.qPayments.Refresh;
      MonthCalendar1.Visible:=false;
    end
    else
      MessageDlg('�������� ���� ���� ����� ��� ��������� �������� ���������. ��� ��������� ���� ������� ������ ����.', mtError, [mbOK], 0);

  end
  else
    MessageDlg('�������� ���� ���� ����� ���� �������. ��� ��������� ���� ������� ������ ����.', mtError, [mbOK], 0);

end;

procedure TShowUserStatForm.MonthCalendar1MouseLeave(Sender: TObject);
begin
  MonthCalendar1.Visible:=false;
end;

procedure TShowUserStatForm.N1Click(Sender: TObject);
  procedure Pclose(sender:TObject);
  begin
    (sender as TForm).ModalResult:=mrOk;
    //sender.Destroy;
  end;
var
  fList:TForm;
  Mcloselsit:TMethod;
  qBH:TOraQuery;
  dsBH:TDataSource;
  tBH:TDBGrid;

begin
  if not (GetConstantValue('SERVER_NAME')='CORP_MOBILE') then
    exit;  //������ ��� K7 � ���

  flist:=tform.Create(ShowBillDetailsForm);
  LblBalance.ShowHint:=TRUE;
  with flist do
  begin
  //  FormStyle:=fsMDIChild;
    BorderStyle:=bsSingle;
    Caption:='������� ������� � ������ �� ������ '+FPhoneNumber;
    Position:=poScreenCenter;
    Width:=650;
    Height:=450;
  end;

  qBH:=TOraQuery.Create(flist);
  with qBH do
  begin
    params.CreateParam(ftString,'p_phone',ptInput);
    params.ParamByName('p_phone').Value:=FPhoneNumber;
    sql.Add('select I.LAST_UPDATE, Q.NAME, I.BALANCE, I.DATE_CREATED' +#13#10+
      'from IOT_BALANCE_HISTORY_WITH_TYPE I, QCB_TYPES Q' +#13#10+
      'where I.UPDATE_TYPE=Q.QCB_ID and I.PHONE_NUMBER=:p_phone' +#13#10+
      'order by I.LAST_UPDATE');
  end;

  dsBH:=TDataSource.Create(flist);
  with dsBH do
  begin
    DataSet:=qBH;
    Enabled:=true;
  end;
  tBH:=TDBGrid.Create(flist);
  with tBH do
  begin
    parent:=fList;
    DataSource:=dsBH;
    align:=alClient;
    Visible:=true;
    Mcloselsit.Code:=@pclose;
    Mcloselsit.Data:=tBH.parent;
    ReadOnly:=true;
    OnDblClick:=TNotifyEvent(Mcloselsit);
  end;
  try
    qBH.open;
  finally
    tbh.Columns.Items[0].Title.caption:='��������';
    tbh.Columns.Items[1].Title.caption:='���';
    tbh.Columns.Items[2].Title.caption:='������';
    tbh.Columns.Items[3].Title.caption:='��������';
    if not qbh.Eof then
      fList.ShowModal
    else
    begin
      ShowMessage('��� ������.');
      flist.Destroy;
    end;
  end;
end;

end.


