unit ReportMonitorAutoTurnInternet;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, main, Vcl.ActnList, Vcl.StdCtrls,
  Vcl.Buttons, Vcl.ExtCtrls, Vcl.ComCtrls, Data.DB, MemDS, DBAccess, Ora,
  Vcl.Grids, Vcl.DBGrids, CRGrid, Vcl.Menus, ShowUserStat, IntecExportGrid,
  Registry, ContractsRegistration_Utils, IniFiles;

type
  TSystemPath=(Desktop, StartMenu, Programs, Startup, Personal, winroot, winsys, AppData, Cache, TMP);
  Function GetSystemPath(SystemPath:TSystemPath):string;

type
  TReportMonitorAutoTurnInternetFrm = class(TForm)
    aList: TActionList;
    pMain: TPanel;
    PageControlMain: TPageControl;
    tsAlienOpts: TTabSheet;
    tsTurnAutoInternet: TTabSheet;
    pAlien: TPanel;
    pReq: TPanel;
    pDopInfo: TPanel;
    Splitter1: TSplitter;
    Splitter2: TSplitter;
    SplitterDop: TSplitter;
    pPCKG: TPanel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    gReport: TCRDBGrid;
    gTurnLog: TCRDBGrid;
    gStat: TCRDBGrid;
    qReport: TOraQuery;
    dsReport: TDataSource;
    qTurnLog: TOraQuery;
    dsTurnLog: TDataSource;
    qStat: TOraQuery;
    dsStat: TDataSource;
    gReq: TCRDBGrid;
    gRemains_PCKG: TCRDBGrid;
    qReportUpdate: TOraQuery;
    pTurnAutoConnectInet: TPanel;
    aViewHelp: TAction;
    pBtnAlien: TPanel;
    pTurnConnect: TPanel;
    pBtnPCKG: TPanel;
    pBtnReq: TPanel;
    pBtnStat: TPanel;
    pBtnTurnLog: TPanel;
    bRefreshAlien: TSpeedButton;
    aRefresh: TAction;
    aLoadInExcel: TAction;
    aShowUserStatInfo: TAction;
    bLoadInExcelAlien: TSpeedButton;
    pBtnTurnAutoConnectInet: TPanel;
    gTurnAutoConnectInet: TCRDBGrid;
    qTurnAutoConnectInet: TOraQuery;
    dsTurnAutoConnectInet: TDataSource;
    bRefreshPCKG: TSpeedButton;
    bLoadInExcelPCKG: TSpeedButton;
    bRefreshReq: TSpeedButton;
    bLoadInExcelReq: TSpeedButton;
    bRefreshStat: TSpeedButton;
    bLoadInExcelStat: TSpeedButton;
    bRefreshTurnLog: TSpeedButton;
    bLoadInExcelTurnLog: TSpeedButton;
    bRefreshTurnConnect: TSpeedButton;
    bLoadInExcelTurnConnect: TSpeedButton;
    bTreated: TSpeedButton;
    aTreated: TAction;
    bAddLogicAlien: TSpeedButton;
    aAddLogic: TAction;
    bStartCheckConnectPCKG: TSpeedButton;
    bStartCheckConnectPCKGAll: TSpeedButton;
    aStartCheckConnectPCKG: TAction;
    aStartCheckConnectPCKGAll: TAction;
    ProgressBar: TProgressBar;
    pStatConnect: TPanel;
    Splitter3: TSplitter;
    Label2: TLabel;
    bShowUserStatInfoAlien: TSpeedButton;
    bDetailInfoAlien: TSpeedButton;
    bShowUserStatInfoTurnCon: TSpeedButton;
    bDetailInfoTurnCon: TSpeedButton;
    aDetailInfoBtn: TAction;
    bViewHelp: TSpeedButton;
    bViewHelpAlien: TSpeedButton;
    aRefreshPCKG: TAction;
    aRefreshReq: TAction;
    aRefreshTurnLog: TAction;
    aRefreshStat: TAction;
    aLoadInExcelPCKG: TAction;
    aLoadInExcelReq: TAction;
    aLoadInExcelTurnLog: TAction;
    aLoadInExcelStat: TAction;
    spGprsCheckPhoneTariff: TOraStoredProc;
    bAddLogicTurn: TSpeedButton;
    qTariffCode: TOraQuery;
    qRemains_PCKG: TOraQuery;
    qReq: TOraQuery;
    dsRemains_PCKG: TDataSource;
    dsReq: TDataSource;
    tsSelectionOptions: TTabSheet;
    pBtnSelect: TPanel;
    pPhone: TPanel;
    mSelectOptions: TMemo;
    edtPhone: TEdit;
    bSelectOptions: TBitBtn;
    bViewHelpSelectOpt: TSpeedButton;
    aSelectOptions: TAction;
    qSelectionOpt: TOraQuery;
    qFile: TOraQuery;
    tsConfines: TTabSheet;
    gConfines: TCRDBGrid;
    tsDisconnect: TTabSheet;
    gDisconnect: TCRDBGrid;
    pBtnDisconnect: TPanel;
    bShowUserStatInfoConf: TSpeedButton;
    bRefreshConf: TSpeedButton;
    bLoadInExcelConf: TSpeedButton;
    bViewHelpConf: TSpeedButton;
    pBtnConfines: TPanel;
    bShowUserStatInfoDis: TSpeedButton;
    bRefreshDis: TSpeedButton;
    bLoadInExcelDis: TSpeedButton;
    bViewHelpDis: TSpeedButton;
    qConfines: TOraQuery;
    dsConfines: TDataSource;
    qDisconnect: TOraQuery;
    dsDisconnect: TDataSource;
    pStatusWorkJob: TPanel;
    lbState: TLabel;
    spAddLogic: TOraStoredProc;
    qWORK_J_GPRS_CHECK_FLOW_TURN_OFF: TOraQuery;
    lbTimeWork: TLabel;
    lbStatus: TLabel;
    tsErrorConnectPCKG: TTabSheet;
    gErrorConnectPCKG: TCRDBGrid;
    pBtnErrorConnectPCKG: TPanel;
    bShowUserStatInfoErr: TSpeedButton;
    bRefreshErr: TSpeedButton;
    bLoadInExcelErr: TSpeedButton;
    bViewHelpErr: TSpeedButton;
    qErrorConnectPCKG: TOraQuery;
    dsErrorConnectPCKG: TDataSource;
    bHandleErrorConnectPhone: TSpeedButton;
    aHandleErrorConnectPhone: TAction;
    spHandleErrorConnect: TOraStoredProc;
    aHandleErrorConnectAll: TAction;
    bHandleErrorConnectAll: TSpeedButton;
    prbErrConnectPCKG: TProgressBar;
    lbInfo: TLabel;
    lbStart: TLabel;
    lbNoStart: TLabel;
    lbWorked: TLabel;
    lbResNoError: TLabel;
    lbResError: TLabel;
    lbNoRes: TLabel;
    lbCountStream: TLabel;
    lbRepeat: TLabel;
    bTurnOffPhoneError: TSpeedButton;
    aTurnOffPhoneError: TAction;
    spTurnOffPhoneError: TOraStoredProc;
    qGPRS_TURN_OFF_PHN_ERR_LOG: TOraQuery;
    lbCountLog: TLabel;
    lbCountLogNoErr: TLabel;
    lbCountLogErr: TLabel;
    procedure aRefreshExecute(Sender: TObject);
    procedure aLoadInExcelExecute(Sender: TObject);
    procedure aShowUserStatInfoExecute(Sender: TObject);
    procedure qTurnLogBeforeOpen(DataSet: TDataSet);
    procedure qTurnLogAfterScroll(DataSet: TDataSet);
    procedure qReportAfterScroll(DataSet: TDataSet);
    procedure qStatBeforeOpen(DataSet: TDataSet);
    procedure gReportDblClick(Sender: TObject);
    procedure aViewHelpExecute(Sender: TObject);
    procedure aTreatedExecute(Sender: TObject);
    procedure aAddLogicExecute(Sender: TObject);
    procedure aStartCheckConnectPCKGExecute(Sender: TObject);
    procedure aStartCheckConnectPCKGAllExecute(Sender: TObject);
    procedure aDetailInfoBtnExecute(Sender: TObject);
    procedure qTurnAutoConnectInetAfterScroll(DataSet: TDataSet);
    procedure aRefreshPCKGExecute(Sender: TObject);
    procedure aRefreshReqExecute(Sender: TObject);
    procedure aRefreshTurnLogExecute(Sender: TObject);
    procedure aRefreshStatExecute(Sender: TObject);
    procedure aLoadInExcelPCKGExecute(Sender: TObject);
    procedure aLoadInExcelReqExecute(Sender: TObject);
    procedure aLoadInExcelTurnLogExecute(Sender: TObject);
    procedure aLoadInExcelStatExecute(Sender: TObject);
    procedure gTurnAutoConnectInetDblClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure PageControlMainChange(Sender: TObject);
    procedure qRemains_PCKGBeforeOpen(DataSet: TDataSet);
    procedure qReqBeforeOpen(DataSet: TDataSet);
    procedure aSelectOptionsExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure gConfinesDblClick(Sender: TObject);
    procedure gDisconnectDblClick(Sender: TObject);
    procedure gErrorConnectPCKGDblClick(Sender: TObject);
    procedure aHandleErrorConnectPhoneExecute(Sender: TObject);
    procedure aHandleErrorConnectAllExecute(Sender: TObject);
    procedure aTurnOffPhoneErrorExecute(Sender: TObject);
  private
    { Private declarations }
    PersonalPath : string; //���� ���������� ����� �������
    sFileName : string;    //��� ����� �������
    FVisDopInfoAlien,
    FVisDopInfoTurn : boolean;
  public
    { Public declarations }
    procedure RefreshDopInfo; //���������� ������ �������������� ����������
    procedure LoadDataInExcel(gGrid: TCRDBGrid; pNameTitle: string); //�������� ������ � excel
    procedure AddRecordInlogic(qS: TOraQuery; pTariff_Code: string); //���������� ������ � ������ ���������������
    procedure ShowDopInfo(pVis: boolean); //��������� �������/������ �������������� ����������
    function  VisDopInfo : boolean; //������� ����������� �������� ������ ���. ���������� � ����������� �� �������
    procedure RefreshDisconnectOpt; //���������� ������ ������� ������ ���������� ��������-�����
  end;

var
  ReportMonitorAutoTurnInternetFrm: TReportMonitorAutoTurnInternetFrm;

  procedure DoReportMonitorAutoTurnInternet;
  procedure ReadIniAny(const pFileName, Section, Param: String; var pValue: String);
  procedure WriteIniAny(const pFileName, Section, Param, pValue: String);

implementation

{$R *.dfm}

//���������� ���� ���������� ����� �������
//��������� � ����� Documents �� ����� C
Function GetSystemPath(SystemPath:TSystemPath):string;
var
  p:pchar;
  Reg: TRegistry;
begin
  Reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_CURRENT_USER;
    Reg.OpenKey('\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders', True);
    case SystemPath of
    Desktop:
      Result := Reg.ReadString('Desktop');
    StartMenu:
      Result := Reg.ReadString('Start Menu');
    Programs:
      Result := Reg.ReadString('Programs');
    Startup:
      Result := Reg.ReadString('Startup');
    Personal:
      Result := Reg.ReadString('Personal');
    AppData:
      Result := Reg.ReadString('AppData');
    Cache:
      Result := Reg.ReadString('Cache');
    Winroot:
      begin
        GetMem(p,255);
        GetWindowsDirectory(p,254);
        result := StrPas(p);
        Freemem(p);
      end;
    WinSys:
      begin
        GetMem(p,255);
        GetSystemDirectory(p,254);
        result := StrPas(p);
        Freemem(p);
      end;
    TMP:
      begin
        GetMem(p,255);
        GetTempPath(254,p);
        result := StrPas(p);
        Freemem(p);
      end;
    end;
  finally
    Reg.CloseKey;
    Reg.free;
  end;
  if (result<>'') and (result[length(result)]<>'\') then
    result:=result+'\';
end;

//���������� ����� � �� �����
procedure DoReportMonitorAutoTurnInternet;
var ReportFrm : TReportMonitorAutoTurnInternetFrm;
begin
  //������� �����
  ReportFrm := TReportMonitorAutoTurnInternetFrm.Create(Nil);
  try
    //��������� �������� ������
    ReportFrm.PageControlMain.ActivePage := ReportFrm.tsAlienOpts;
    //�������� ��� ����������
    ReportFrm.pDopInfo.Visible := false;
    ReportFrm.SplitterDop.Visible := false;
    //������� ������/������� ��� ���� ��� ������ �������, ��������� ��� ������ ���. ���� ������
    ReportFrm.FVisDopInfoAlien := false;
    ReportFrm.FVisDopInfoTurn := false;
    //�������� ������
    ReportFrm.qReport.Close;
    ReportFrm.qReport.Open;
    //���������� �����
    ReportFrm.ShowModal;
  finally
    //���������� �����
    ReportFrm.Free;
  end;
end;

//������� ����������� �������� ������ ���. ���������� � ����������� �� �������
function TReportMonitorAutoTurnInternetFrm.VisDopInfo : boolean;
begin
  Result := false;
  //� ����������� �� �������� ������
  if PageControlMain.ActivePage = tsAlienOpts then
    Result := FVisDopInfoAlien
  else
    if PageControlMain.ActivePage = tsTurnAutoInternet then
      Result := FVisDopInfoTurn
end;

//���������� ���. ���������� (���������)
procedure TReportMonitorAutoTurnInternetFrm.RefreshDopInfo;
begin
  //������������� �� ������� ������ ������ ���. ���� � ����������� �� �������
  if VisDopInfo then
  begin
    qReq.Close;
    qReq.Open;
    qTurnLog.Close;
    qTurnLog.Open;
    //�������� ������ �� �������� �������, ������ �������� �� rest_api
    //� ����� � ����, ����. �������� �� ������
    try
      qRemains_PCKG.Close;
      qRemains_PCKG.Open;
    except
      showmessage('������ ���������� �������� �� �������! ���������� �������� ������ �������!');
    end;
  end;
end;

//���������� ������ �������������� ����������
procedure TReportMonitorAutoTurnInternetFrm.qReportAfterScroll(
  DataSet: TDataSet);
begin
  RefreshDopInfo;
end;

//���������� ������ �������������� ����������
procedure TReportMonitorAutoTurnInternetFrm.qTurnAutoConnectInetAfterScroll(
  DataSet: TDataSet);
begin
  RefreshDopInfo;
end;

procedure TReportMonitorAutoTurnInternetFrm.RefreshDisconnectOpt;
var pStart, pNoStart, pWorked,
    pResNoError, pResError, pNoRes,
    i, pCountLogNoErr, pCountLogErr: integer;
    pTimeWork: string;
begin
  qDisconnect.Close;
  qDisconnect.Open;

  qWORK_J_GPRS_CHECK_FLOW_TURN_OFF.Close;
  qWORK_J_GPRS_CHECK_FLOW_TURN_OFF.Open;

  //��������� ������ �� ��������� ���������� ��������-�����
  lbStart.Caption := '��������� - ';
  lbNoStart.Caption := '�� ��������� - ';
  lbWorked.Caption := '����������� - ';
  lbResNoError.Caption := '��� ������ - ';
  lbResError.Caption := '� �������� - ';
  lbNoRes.Caption := '�� ����������� - ';
  lbTimeWork.Caption := '����. ����� ������: ';
  lbCountStream.Caption := '���������� ������� ���������: ';

  pStart := 0;
  pNoStart := 0;
  pWorked := 0;
  presNoError := 0;
  pResError := 0;
  pNoRes := 0;
  pTimeWork := '-';
  i := 1;
  //��������� �� ���� ������� ��������� ����������
  if not qWORK_J_GPRS_CHECK_FLOW_TURN_OFF.IsEmpty then
  begin
    qWORK_J_GPRS_CHECK_FLOW_TURN_OFF.First;
    while not (qWORK_J_GPRS_CHECK_FLOW_TURN_OFF.Eof) do
    begin
      //���������� ������ ������ ������� ����
      if (not qWORK_J_GPRS_CHECK_FLOW_TURN_OFF.FieldByName('LAST_START_DATE').IsNull) and
         (qWORK_J_GPRS_CHECK_FLOW_TURN_OFF.FieldByName('LAST_START_DATE').AsString = FormatDateTime('dd.mm.yyyy', now)) then
      begin
        //������ ������
        if qWORK_J_GPRS_CHECK_FLOW_TURN_OFF.FieldByName('STATE').AsString = 'DISABLED' then
          pNoStart := pNoStart + 1
        else
          //���� ������ � ������
          if qWORK_J_GPRS_CHECK_FLOW_TURN_OFF.FieldByName('STATE').AsString = 'RUNNING' then
            pStart := pStart + 1
          else
            //���� ������ �����������
            if qWORK_J_GPRS_CHECK_FLOW_TURN_OFF.FieldByName('STATE').AsString = 'SCHEDULED' then
            begin
              pWorked := pWorked + 1;
              pNoStart := pNoStart + 1;
            end;

        //���������� ��������� ���������� (� ������� ��� ���), �.�. ���� ���� ����������� ������, �� ������ �������
        if qWORK_J_GPRS_CHECK_FLOW_TURN_OFF.FieldByName('STATE').AsString <> 'RUNNING' then
        begin
          if qWORK_J_GPRS_CHECK_FLOW_TURN_OFF.FieldByName('STATUS').AsString = 'SUCCEEDED' then
            presNoError := presNoError + 1
          else
            pResError := pResError + 1;
        end;

        //������������ ����� ������
        if not qWORK_J_GPRS_CHECK_FLOW_TURN_OFF.FieldByName('LAST_RUN_DURATION').IsNull then
        begin
          if i = 1 then
            pTimeWork := qWORK_J_GPRS_CHECK_FLOW_TURN_OFF.FieldByName('LAST_RUN_DURATION').AsString
          else
            if pTimeWork < qWORK_J_GPRS_CHECK_FLOW_TURN_OFF.FieldByName('LAST_RUN_DURATION').AsString then
              pTimeWork := qWORK_J_GPRS_CHECK_FLOW_TURN_OFF.FieldByName('LAST_RUN_DURATION').AsString;
        end;
      end
      else
        begin
          pNoStart := pNoStart + 1;
          pNoRes := pNoRes + 1;
        end;

      //��������� ������
      qWORK_J_GPRS_CHECK_FLOW_TURN_OFF.Next;
    end;
  end
  else
    begin
      pNoStart := qWORK_J_GPRS_CHECK_FLOW_TURN_OFF.RecordCount;
      pNoRes := qWORK_J_GPRS_CHECK_FLOW_TURN_OFF.RecordCount;
      pTimeWork := '-';
    end;

  //��������� ����
  lbStart.Caption := lbStart.Caption + inttostr(pStart);
  lbNoStart.Caption := lbNoStart.Caption + inttostr(pNoStart);
  lbWorked.Caption := lbWorked.Caption + inttostr(pWorked);
  lbResNoError.Caption := lbResNoError.Caption + inttostr(pResNoError);
  lbResError.Caption := lbResError.Caption + inttostr(pResError);
  lbNoRes.Caption := lbNoRes.Caption + inttostr(pNoRes);
  lbTimeWork.Caption := lbTimeWork.Caption + pTimeWork;
  lbCountStream.Caption := lbCountStream.Caption + inttostr(qWORK_J_GPRS_CHECK_FLOW_TURN_OFF.RecordCount);


  //��������� ������ �� ��������� ���������� ���������� �����
  lbCountLog.Caption := '���������� ������� ������ - ';
  lbCountLogNoErr.Caption := '������ ������������ - ';
  lbCountLogErr.Caption := '������ - ';

  pCountLogNoErr := 0;
  pCountLogErr := 0;

  qGPRS_TURN_OFF_PHN_ERR_LOG.Close;
  qGPRS_TURN_OFF_PHN_ERR_LOG.Open;

  if not qGPRS_TURN_OFF_PHN_ERR_LOG.IsEmpty then
  begin
    qGPRS_TURN_OFF_PHN_ERR_LOG.First;
    while not (qGPRS_TURN_OFF_PHN_ERR_LOG.Eof) do
    begin
      if not qGPRS_TURN_OFF_PHN_ERR_LOG.FieldByName('DATE_END').IsNull then
        pCountLogNoErr := pCountLogNoErr +1
      else
        pCountLogErr := pCountLogErr + 1;

      //��������� ������
      qGPRS_TURN_OFF_PHN_ERR_LOG.Next;
    end;
  end;

  lbCountLog.Caption := lbCountLog.Caption + inttostr(qGPRS_TURN_OFF_PHN_ERR_LOG.RecordCount);
  lbCountLogNoErr.Caption := lbCountLogNoErr.Caption + inttostr(pCountLogNoErr);
  lbCountLogErr.Caption := lbCountLogErr.Caption + inttostr(pCountLogErr);
end;

//������������ ����� ��������
procedure TReportMonitorAutoTurnInternetFrm.PageControlMainChange(
  Sender: TObject);

  procedure HideDopInfo;
  begin
    //������������ ������� ����� �����.
    if (FVisDopInfoTurn) and (PageControlMain.ActivePage <> tsTurnAutoInternet) then
      pTurnAutoConnectInet.Align := alClient;
    //����������� ������� ������� �����
    if (FVisDopInfoAlien) and (PageControlMain.ActivePage <> tsAlienOpts) then
      pAlien.Align := alClient;

    pDopInfo.Align := alRight;
    SplitterDop.Align := alRight;
    pDopInfo.Visible := false;
    SplitterDop.Visible := false;
  end;

var vCount: integer;
    vVis: boolean;
begin
  //��� ����� ������� ���������� ����������� ������ ���. ���� �� ���������� ������� ���� ��� ������������
  //��� ����, ����� ��������� �������������� ����� ��� ���������� ������
  vCount := 0;
  vVis := false;
  //� ����������� �� �������� ������� ��������� ����������� ������
  if PageControlMain.ActivePage = tsAlienOpts then
  begin
    //��������� ������������ �� ������� �����
    //���� �� ������������, �� ���������� ���
    qReport.Close;
    qReport.Open;
    vCount := qReport.RecordCount;
    vVis := FVisDopInfoAlien;
  end
  else
    if PageControlMain.ActivePage = tsTurnAutoInternet then
    begin
      qTurnAutoConnectInet.Close;
      qTurnAutoConnectInet.Open;
      vCount := qTurnAutoConnectInet.RecordCount;
      vVis := FVisDopInfoTurn;
    end
    else
      if PageControlMain.ActivePage = tsConfines then
      begin
        //� ���� ����, ��� ��� ��������� ������ �� GPRS_U � ������������ ��������
        //������������ �������� ����� �� ���, ������ ����� � �����. ��������� ������
        if MessageDlg('��������� ������ � ������� � GPRS_U � ������������ �������� ������ �����-�� �����!'+#13+'���������� ��������� ������?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
        begin
          qConfines.Close;
          qConfines.Open;
        end;
      end
      else
        if PageControlMain.ActivePage = tsDisconnect then
        begin
          lbInfo.Caption := ' ������ ������� ��������� ���������� ��������-����� �� ' + FormatDateTime('dd.mm.yyyy', now);
          RefreshDisconnectOpt;
        end
        else
          if PageControlMain.ActivePage = tsErrorConnectPCKG then
          begin
            qErrorConnectPCKG.Close;
            qErrorConnectPCKG.Open;
          end;

  //�������� ������ ���. ���� �� ���������� ��������
  HideDopInfo;

  //���� ������� ������������
  if vVis then
  begin
    //��������� ���������� ������� � ����.
    //���� ������� ���, �� �������� ���. ����������. �.�. ���������� ������
    if vCount = 0 then
      ShowDopInfo(false)
    else
      ShowDopInfo(true);
  end;
end;

//��������/������ ��������� ����������
procedure TReportMonitorAutoTurnInternetFrm.aDetailInfoBtnExecute(
  Sender: TObject);
var vis: boolean;
begin
  //��������� ������� ������ � ����������� �� �������� �������
  if not VisDopInfo then
  begin
    vis := false;
    //���������� �������� �������
    if PageControlMain.ActivePage = tsAlienOpts then
    begin
      if qReport.RecordCount > 0 then
      begin
        vis := true;
        FVisDopInfoAlien := true;
      end;
    end
    else
      if PageControlMain.ActivePage = tsTurnAutoInternet then
        if qTurnAutoConnectInet.RecordCount > 0 then
        begin
          vis := true;
          FVisDopInfoTurn := true;
        end;

    if vis then
    begin
      RefreshDopInfo; //��������� ������ �� �������������� ����������
      ShowDopInfo(true);
      //RefreshDopInfo;
    end
    else
      showmessage('���������� ����� ��� ��������� ��������� ����������!');
  end
  else
    ShowDopInfo(false);
end;

//��������� ������ ����������� �� ���� ������� (������� - ������ ����������� �������� - �����)
procedure TReportMonitorAutoTurnInternetFrm.aHandleErrorConnectAllExecute(
  Sender: TObject);
var i: integer;
begin
  //��������� �� ���� ������� ����� � ���� �������� �����.
  if qErrorConnectPCKG.RecordCount > 0 then
  begin
    i := qErrorConnectPCKG.RecNo;
    qErrorConnectPCKG.DisableControls;

    prbErrConnectPCKG.Min := 0;
    prbErrConnectPCKG.Max := qErrorConnectPCKG.RecordCount;
    prbErrConnectPCKG.Position := prbErrConnectPCKG.Min;
    qErrorConnectPCKG.First;
    while not qErrorConnectPCKG.EOF do
    begin
      spHandleErrorConnect.ParamByName('PPHONE_NUMBER').AsString := qErrorConnectPCKG.FieldByName('phone').AsString;
      try
        spHandleErrorConnect.ExecProc;
      except
        null;
      end;
      prbErrConnectPCKG.Position := prbErrConnectPCKG.Position + 1;
      qErrorConnectPCKG.Next;
    end;
    //���������
    qErrorConnectPCKG.Close;
    qErrorConnectPCKG.Open;

    qErrorConnectPCKG.RecNo := i;
    qErrorConnectPCKG.EnableControls;
  end;
end;

//��������� ������ ����������� �� ����������� ������ (������� - ������ ����������� �������� - �����)
procedure TReportMonitorAutoTurnInternetFrm.aHandleErrorConnectPhoneExecute(
  Sender: TObject);
begin
  if qErrorConnectPCKG.RecordCount > 0 then
  begin
    try
      spHandleErrorConnect.ParamByName('PPHONE_NUMBER').AsString := qErrorConnectPCKG.FieldByName('phone').AsString;
      spHandleErrorConnect.ExecProc;
    except
      null;
    end;
    //���������
    qErrorConnectPCKG.Close;
    qErrorConnectPCKG.Open;
  end;
end;

//��������� �������/������ �������������� ����������
procedure TReportMonitorAutoTurnInternetFrm.ShowDopInfo(pVis: boolean);
var pnlDop: TPanel;
begin
  //���������� ������ �������� �������
  if PageControlMain.ActivePage = tsAlienOpts then
    pnlDop := pAlien
  else
    if PageControlMain.ActivePage = tsTurnAutoInternet then
      pnlDop := pTurnAutoConnectInet;

  //���������� �������� - ������/��������
  if pVis then
  begin
    pnlDop.Align := alLeft;
    pnlDop.Width := 400;
    if pnlDop.Name = pAlien.Name then
    begin
      pDopInfo.Parent := tsAlienOpts;
      SplitterDop.Parent := tsAlienOpts;
      FVisDopInfoAlien := true;
      bDetailInfoAlien.Hint := '������ ��������� ���������� �� ����������������';
    end
    else
      if pnlDop.Name = pTurnAutoConnectInet.Name then
      begin
        pDopInfo.Parent := tsTurnAutoInternet;
        SplitterDop.Parent := tsTurnAutoInternet;
        FVisDopInfoTurn := true;
        bDetailInfoTurnCon.Hint := '������ ��������� ���������� �� ����������������';
      end;

    SplitterDop.Align := alLeft;
    pDopInfo.Align := alClient;
    pDopInfo.Visible := true;
    SplitterDop.Visible := true;
  end
  else
    begin
      //���� ������ �� �������� �������, �� ������� ��
      if pDopInfo.Parent = PageControlMain.ActivePage then
      begin
        //���������� �� ��� ����� ������ ���. ����
        if pDopInfo.Parent.Name = tsAlienOpts.Name then
        begin
          pnlDop := pAlien;
          FVisDopInfoAlien := false;
          bDetailInfoAlien.Hint := '�������� ��������� ���������� �� ����������������';
        end
        else
          if pDopInfo.Parent.Name = tsTurnAutoInternet.Name then
          begin
            pnlDop := pTurnAutoConnectInet;
            FVisDopInfoTurn := false;
            bDetailInfoTurnCon.Hint := '�������� ��������� ���������� �� ����������������';
          end;

        pnlDop.Align := alClient;
        pDopInfo.Align := alRight;
        SplitterDop.Align := alRight;
        pDopInfo.Visible := false;
        SplitterDop.Visible := false;
      end;
    end;
end;

//��������� ������ �� �������
procedure TReportMonitorAutoTurnInternetFrm.aRefreshExecute(Sender: TObject);
begin
  //���������� �������� �������
  if PageControlMain.ActivePage = tsAlienOpts then
  begin
    qReport.Close;
    qReport.Open;
  end
  else
    if PageControlMain.ActivePage = tsTurnAutoInternet then
    begin
      qTurnAutoConnectInet.Close;
      qTurnAutoConnectInet.Open;
    end
    else
      if PageControlMain.ActivePage = tsConfines then
      begin
        qConfines.Close;
        qConfines.Open;
      end
      else
        if PageControlMain.ActivePage = tsDisconnect then
          RefreshDisconnectOpt
        else
          if PageControlMain.ActivePage = tsErrorConnectPCKG then
          begin
            qErrorConnectPCKG.Close;
            qErrorConnectPCKG.Open;
          end;
end;

//��������� ������ �� �������
procedure TReportMonitorAutoTurnInternetFrm.aRefreshPCKGExecute(
  Sender: TObject);
begin
  qRemains_PCKG.Close;
  qRemains_PCKG.Open;
end;

//��������� ������ �� ������� �� �����������
procedure TReportMonitorAutoTurnInternetFrm.aRefreshReqExecute(Sender: TObject);
begin
  qReq.Close;
  qReq.Open;
end;

//��������� ������� �����������
procedure TReportMonitorAutoTurnInternetFrm.aRefreshTurnLogExecute(
  Sender: TObject);
begin
  qTurnLog.Close;
  qTurnLog.Open;
end;

//��������� ���������� ������������� �������
procedure TReportMonitorAutoTurnInternetFrm.aRefreshStatExecute(
  Sender: TObject);
begin
  qstat.Close;
  qStat.Open;
end;

//�������� ������ � Excel
procedure TReportMonitorAutoTurnInternetFrm.aLoadInExcelExecute(
  Sender: TObject);
begin
  //���������� �������� �������
  if PageControlMain.ActivePage = tsAlienOpts then
    LoadDataInExcel(gReport, '����� ����������� ��������-�����')
  else
    if PageControlMain.ActivePage = tsTurnAutoInternet then
      LoadDataInExcel(gTurnAutoConnectInet, '������� ������� �� �������� ��������������� ��������-�����')
    else
      if PageControlMain.ActivePage = tsConfines then
        LoadDataInExcel(gConfines, '������ � GPRS_U � ������������ ��������')
      else
        if PageControlMain.ActivePage = tsDisconnect then
          LoadDataInExcel(gDisconnect, '������ ���������� ��������-�����')
        else
          if PageControlMain.ActivePage = tsErrorConnectPCKG then
            LoadDataInExcel(gErrorConnectPCKG, '������ ����������� ��������-�����');
end;

procedure TReportMonitorAutoTurnInternetFrm.aLoadInExcelPCKGExecute(
  Sender: TObject);
begin
  LoadDataInExcel(gRemains_PCKG, '������� �� �������');
end;

procedure TReportMonitorAutoTurnInternetFrm.aLoadInExcelReqExecute(
  Sender: TObject);
begin
  LoadDataInExcel(gReq, '������ ������ �� �����������/���������� �����');
end;

procedure TReportMonitorAutoTurnInternetFrm.aLoadInExcelStatExecute(
  Sender: TObject);
begin
  LoadDataInExcel(gTurnLog, '������� ��������������� ��������-�����');
end;

procedure TReportMonitorAutoTurnInternetFrm.aLoadInExcelTurnLogExecute(
  Sender: TObject);
begin
  LoadDataInExcel(gStat, '���������� ������������� ��������-�����');
end;

//�������� ������ � excel
procedure TReportMonitorAutoTurnInternetFrm.LoadDataInExcel(gGrid: TCRDBGrid; pNameTitle: string);
var cr : TCursor;
begin
  cr := Screen.Cursor;
  Screen.Cursor := crHourGlass;
  try
    ExportDBGridToExcel2(pNameTitle,'', gGrid, nil, False, True);
  finally
    Screen.Cursor := cr;
  end;
end;

//������� ������ ����� ����������� ������������
procedure TReportMonitorAutoTurnInternetFrm.aTreatedExecute(Sender: TObject);
var i: integer;
begin
  if qReport.RecordCount > 0 then
  begin
    i := qReport.RecNo;
    qReport.DisableControls;

    //��������� ���� ��������
    qReportUpdate.ParamByName('pIS_CHECKED').AsInteger := 1;
    qReportUpdate.ParamByName('p_phone').AsString := qReport.FieldByName('phone').AsString;
    qReportUpdate.ParamByName('pALIEN_CODE').AsString := qReport.FieldByName('ALIEN_CODE').AsString;
    qReportUpdate.ParamByName('pCURR_CODE').AsString := qReport.FieldByName('CURR_CODE').AsString;
    qReportUpdate.ExecSQL;

    qReport.RecNo := i;
    qReport.EnableControls;

    //��������� ������ �� �������������
    qReport.Close;
    qReport.Open;
  end;
end;

procedure TReportMonitorAutoTurnInternetFrm.aTurnOffPhoneErrorExecute(
  Sender: TObject);
begin
  //���� ����������.
  if MessageDlg('��������� �������� ���������� ��������-�����?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    try
      spTurnOffPhoneError.ExecProc;
    except
      null;
    end;

    //���������
    qDisconnect.Close;
    qDisconnect.Open;
  end;
end;

//���������� ����� ����� � ������ �����.
procedure TReportMonitorAutoTurnInternetFrm.aAddLogicExecute(Sender: TObject);
var i, vCount: integer;
    qS: TOraQuery;
    s: string;
begin
  vCount := 0;
  //���������� ��������-����� � ������ ��������������� ����� ������ ������
  //������� ����� ���������� ������� ������� �� ��� � ����������� � �� ������ �� ��������
  s:= '';
  if PageControlMain.ActivePage = tsAlienOpts then
  begin
    if qReport.RecordCount > 0 then
    begin
      s := qReport.FieldByName('ALIEN_CODE').AsString + ' �� ������ ' +  qReport.FieldByName('phone').AsString;
      vCount := qReport.RecordCount;
    end;
  end
  else
    if PageControlMain.ActivePage = tsTurnAutoInternet then
    begin
      if qTurnAutoConnectInet.RecordCount > 0 then
      begin
        //���������� �� �� ������
        qTariffCode.Close;
        qTariffCode.ParamByName('PHONE_NUMBER').AsString := qTurnAutoConnectInet.FieldByName('phone').AsString;
        qTariffCode.Open;
        s := qTariffCode.FieldByName('TARIFF_CODE').AsString + ' �� ������ ' +  qTurnAutoConnectInet.FieldByName('phone').AsString;
        vCount := qTurnAutoConnectInet.RecordCount;
      end;
    end;

  //���� � ����. ������� ������
  if vCount > 0 then
    if MessageDlg('�������� ' + s + ' � ������ ���������������?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    begin
      if PageControlMain.ActivePage = tsAlienOpts then
        AddRecordInlogic(qReport, qReport.FieldByName('ALIEN_CODE').AsString)
      else
        AddRecordInlogic(qTurnAutoConnectInet, qTariffCode.FieldByName('TARIFF_CODE').AsString);
    end;
end;

//���������� ������ � ������ ���������������
procedure TReportMonitorAutoTurnInternetFrm.AddRecordInlogic(qS: TOraQuery; pTariff_Code: string);
var i: integer;
begin
  i := qS.RecNo;
  qS.DisableControls;


  spAddLogic.ParamByName('p_phone').AsString := qS.FieldByName('phone').AsString;
  spAddLogic.ParamByName('p_tariff_code').AsString := pTariff_Code;
  spAddLogic.ExecProc;

  qS.Close;
  qS.Open;

  qS.RecNo := i;
  qS.EnableControls;
  ShowMessage(spAddLogic.ParamByName('RESULT').AsString);
end;

//������ ������ �� �������� ��������������� ��������-�����
procedure TReportMonitorAutoTurnInternetFrm.aStartCheckConnectPCKGExecute(
  Sender: TObject);
begin
  if qTurnAutoConnectInet.RecordCount > 0 then
  begin
    try
      spGprsCheckPhoneTariff.ParamByName('P_PHONE').AsString := qTurnAutoConnectInet.FieldByName('phone').AsString;
      spGprsCheckPhoneTariff.ExecProc;
    except
      null;
    end;
    //���������
    qTurnAutoConnectInet.Close;
    qTurnAutoConnectInet.Open;
  end;
end;

//������ ���� ������� �� �������� ��������������� ��������-�����
procedure TReportMonitorAutoTurnInternetFrm.aStartCheckConnectPCKGAllExecute(
  Sender: TObject);
var i: integer;
begin
  //��������� �� ���� ������� ����� � ���� �������� �����.
  if qTurnAutoConnectInet.RecordCount > 0 then
  begin
    i := qTurnAutoConnectInet.RecNo;
    qTurnAutoConnectInet.DisableControls;

    ProgressBar.Min := 0;
    ProgressBar.Max := qTurnAutoConnectInet.RecordCount;
    ProgressBar.Position := ProgressBar.Min;
    qTurnAutoConnectInet.First;
    while not qTurnAutoConnectInet.EOF do
    begin
      spGprsCheckPhoneTariff.ParamByName('P_PHONE').AsString := qTurnAutoConnectInet.FieldByName('phone').AsString;
      try
        spGprsCheckPhoneTariff.ExecProc;
      except
        null;
      end;
      ProgressBar.Position := ProgressBar.Position + 1;
      qTurnAutoConnectInet.Next;
    end;
    //���������
    qTurnAutoConnectInet.Close;
    qTurnAutoConnectInet.Open;

    qTurnAutoConnectInet.RecNo := i;
    qTurnAutoConnectInet.EnableControls;
  end;
end;

//�������
procedure TReportMonitorAutoTurnInternetFrm.aViewHelpExecute(Sender: TObject);
var h : HWND; // ������������� (����������)
    pDiv : integer; //����� ������ ������� �������
begin
  h := FindWindow('HH Parent','�������');
  if h = 0 then
  begin
    pDiv := 1;
    //���������� �������� �������
    if PageControlMain.ActivePage = tsErrorConnectPCKG then
      pDiv := 5
    else
      if PageControlMain.ActivePage = tsDisconnect then
        pDiv := 4
      else
        if PageControlMain.ActivePage = tsAlienOpts then
          pDiv := 2
        else
          if PageControlMain.ActivePage = tsTurnAutoInternet then
            pDiv := 3
          else
            if PageControlMain.ActivePage = tsSelectionOptions then
              pDiv := 1;

    WinExec(PAnsiChar(AnsiString('hh.exe - mapid ' + inttostr(pDiv) + ' ' + PersonalPath + sFileName)), SW_RESTORE);
  end
  else
  begin
    ShowWindow(h,SW_RESTORE);
    SetForegroundWindow(h);
  end;
end;

//��� �������� ����� ���������� ����� ������� ������� ���� ��� �������
procedure TReportMonitorAutoTurnInternetFrm.FormClose(Sender: TObject;
  var Action: TCloseAction);
var h: HWND;
begin
  h := FindWindow('HH Parent','�������');
  //������� ���� ���������� ����������
  if h <> 0 then
    SendMessage(h,WM_CLOSE,0,0);
end;

procedure ReadIniAny(const pFileName, Section, Param: String;
  var pValue: String);
var
  Ini: TIniFile;
begin
  try
    Ini := TIniFile.Create(ChangeFileExt(pFileName, '.INI'));
    try
      pValue := Ini.ReadString(Section, Param, '');
    finally
      Ini.Free;
    end;
  except // ������� ������
    pValue := '';
  end;
end;

procedure WriteIniAny(const pFileName, Section, Param, pValue: String);
var
  Ini: TIniFile;
begin
  try
    Ini := TIniFile.Create(ChangeFileExt(pFileName, '.INI'));
    try
      Ini.WriteString(Section, Param, pValue);
    finally
      Ini.Free;
    end;
  except // ������� ������
    ;
  end;
end;

procedure TReportMonitorAutoTurnInternetFrm.FormCreate(Sender: TObject);
var StrmSrc: TStream;
    StrmDst: TStream;
    sLoad: string;
begin
  //���������� ��������� "��������" �������
  //������ �� �������� ����� ������� �������� � ini �����
  //�������� ���� ������� chm
  qFile.Close;
  qFile.Open;

  if qFile.RecordCount > 0 then
  begin
    sFileName := 'Help.chm';
    PersonalPath := GetSystemPath(Personal);//���� �������� �����

    //���� ���� ������� �����������, �� ���������� ��� � ��������� ���� ����� ������ � ini �����
    if not FileExists(PersonalPath + sFileName) then
    begin
      WriteIniAny(Application.ExeName, 'HELP FILE', 'DATE_LAST_UPDATED', qFile.FieldByName('DATE_LAST_UPDATED').AsString);
      SaveBlobFile(PersonalPath, sFileName, qFile, qFile.FieldByName('FILE_CLB'));
    end
    else  //��������� �������� ����� �������
      begin
        //��������� ���� �� ini ����� � ���� ������
        ReadIniAny(Application.ExeName, 'HELP FILE', 'DATE_LAST_UPDATED', sLoad);
        if sLoad <> qFile.FieldByName('DATE_LAST_UPDATED').AsString then
          SaveBlobFile(PersonalPath, sFileName, qFile, qFile.FieldByName('FILE_CLB'));
      end;
  end;
end;

//������ ��������-�����
procedure TReportMonitorAutoTurnInternetFrm.aSelectOptionsExecute(
  Sender: TObject);
var i: integer;
    err: boolean;
begin
  //��������� ������������ ����� ������
  err := true;
  if Length(edtPhone.Text) = 10 then
  begin
    //��������� �� ��, ����� ��� ������� ���� �������
    for i := 1 to Length(edtPhone.Text) do
      if not (edtPhone.Text[i] in ['0'..'9']) then
        err := false;
  end
  else
    err := false;

  if err then
  begin
    //��������� �� ��, ����� �� ������ ��� ����� � ���������������� �������
    qTariffCode.Close;
    qTariffCode.ParamByName('PHONE_NUMBER').AsString := edtPhone.Text;
    qTariffCode.Open;

    if not qTariffCode.IsEmpty then
    begin
      qSelectionOpt.Close;
      qSelectionOpt.ParamByName('p_phone').AsString := edtPhone.Text;
      qSelectionOpt.Open;
      mSelectOptions.Clear;
      mSelectOptions.Text := qSelectionOpt.FieldByName('v_data').AsString;
    end
    else
      showmessage('�� ����� �������� ���� �� � ���������������� ��������-�����!');
  end
  else
    showmessage('����� ������ �� ���������!');
end;

//�������
procedure TReportMonitorAutoTurnInternetFrm.qRemains_PCKGBeforeOpen(
  DataSet: TDataSet);
begin
  if PageControlMain.ActivePage = tsAlienOpts then
  begin
    if qReport.RecordCount > 0 then
      qRemains_PCKG.ParamByName('p_phone').AsString:= qReport.FieldByName('phone').AsString;
  end
  else
    if PageControlMain.ActivePage = tsTurnAutoInternet then
    begin
      if qTurnAutoConnectInet.RecordCount > 0 then
        qRemains_PCKG.ParamByName('p_phone').AsString:= qTurnAutoConnectInet.FieldByName('phone').AsString;
    end;
end;

//���������� ������ �� �����./����.
procedure TReportMonitorAutoTurnInternetFrm.qReqBeforeOpen(DataSet: TDataSet);
begin
  //���������� �������� �������
  if PageControlMain.ActivePage = tsAlienOpts then
  begin
    if qReport.RecordCount > 0 then
      qReq.ParamByName('PHONE_NUMBER').AsString := qReport.FieldByName('phone').AsString;
  end
  else
    if PageControlMain.ActivePage = tsTurnAutoInternet then
    begin
      if qTurnAutoConnectInet.RecordCount > 0 then
        qReq.ParamByName('PHONE_NUMBER').AsString := qTurnAutoConnectInet.FieldByName('phone').AsString;
    end;

  qReq.ParamByName('RETARIF').AsInteger := 1;//��������� ����������
end;

//���������� ������� ���������������
procedure TReportMonitorAutoTurnInternetFrm.qTurnLogBeforeOpen(
  DataSet: TDataSet);
begin
  //���������� �������� �������
  if PageControlMain.ActivePage = tsAlienOpts then
  begin
    if qReport.RecordCount > 0 then
      qTurnLog.ParamByName('p_phone').AsString:= qReport.FieldByName('phone').AsString;
  end
  else
    if PageControlMain.ActivePage = tsTurnAutoInternet then
    begin
      if qTurnAutoConnectInet.RecordCount > 0 then
        qTurnLog.ParamByName('p_phone').AsString:= qTurnAutoConnectInet.FieldByName('phone').AsString;
    end;
end;

//��������� ���������� ���. �������
procedure TReportMonitorAutoTurnInternetFrm.qStatBeforeOpen(DataSet: TDataSet);
begin
  //���������� �������� �������
  if PageControlMain.ActivePage = tsAlienOpts then
  begin
    if qReport.RecordCount > 0 then
      qStat.ParamByName('p_phone').AsString:= qReport.FieldByName('phone').AsString;
  end
  else
    if PageControlMain.ActivePage = tsTurnAutoInternet then
    begin
      if qTurnAutoConnectInet.RecordCount > 0 then
        qStat.ParamByName('p_phone').AsString:= qTurnAutoConnectInet.FieldByName('phone').AsString;
    end;

  qStat.ParamByName('pturn_log_id').AsInteger:= qTurnLog.FieldByName('LOG_ID').AsInteger;
end;

//��� ������ ������� �����. ���������� ���������� ���. �������
procedure TReportMonitorAutoTurnInternetFrm.qTurnLogAfterScroll(
  DataSet: TDataSet);
begin
  qStat.Close;
  qStat.Open;
end;

//���������� �������� ��������
procedure TReportMonitorAutoTurnInternetFrm.aShowUserStatInfoExecute(
  Sender: TObject);
begin
  //���������� �������� �������
  if PageControlMain.ActivePage = tsAlienOpts then
  begin
    if qReport.Active and (qReport.RecordCount > 0) then
      ShowUserStatByPhoneNumber(qReport.FieldByName('PHONE').AsString, 0);
  end
  else
    if PageControlMain.ActivePage = tsTurnAutoInternet then
    begin
      if qTurnAutoConnectInet.Active and (qTurnAutoConnectInet.RecordCount > 0) then
        ShowUserStatByPhoneNumber(qTurnAutoConnectInet.FieldByName('PHONE').AsString, 0);
    end
    else
      if PageControlMain.ActivePage = tsConfines then
      begin
        if qConfines.Active and (qConfines.RecordCount > 0) then
          ShowUserStatByPhoneNumber(qConfines.FieldByName('PHONE').AsString, 0);
      end
      else
        if PageControlMain.ActivePage = tsDisconnect then
        begin
          if qDisconnect.Active and (qDisconnect.RecordCount > 0) then
            ShowUserStatByPhoneNumber(qDisconnect.FieldByName('PHONE').AsString, 0);
        end
        else
          if PageControlMain.ActivePage = tsErrorConnectPCKG then
          begin
            if qErrorConnectPCKG.Active and (qErrorConnectPCKG.RecordCount > 0) then
              ShowUserStatByPhoneNumber(qErrorConnectPCKG.FieldByName('PHONE').AsString, 0);
          end;
end;

//�� �������� ������ ����� �� ������ ����� �����. ��������� �������� ��������
procedure TReportMonitorAutoTurnInternetFrm.gConfinesDblClick(Sender: TObject);
begin
  aShowUserStatInfo.Execute;
end;

procedure TReportMonitorAutoTurnInternetFrm.gDisconnectDblClick(
  Sender: TObject);
begin
  aShowUserStatInfo.Execute;
end;

procedure TReportMonitorAutoTurnInternetFrm.gErrorConnectPCKGDblClick(
  Sender: TObject);
begin
  aShowUserStatInfo.Execute;
end;

procedure TReportMonitorAutoTurnInternetFrm.gReportDblClick(Sender: TObject);
var i: integer;
begin
  aShowUserStatInfo.Execute;
end;

//�� �������� ������ ����� �� ������ ������� �����. ��������� �������� ��������
procedure TReportMonitorAutoTurnInternetFrm.gTurnAutoConnectInetDblClick(
  Sender: TObject);
begin
  aShowUserStatInfo.Execute;
end;

end.
