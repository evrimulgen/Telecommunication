unit ReportLoadAccounts;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Grids, Vcl.DBGrids, CRGrid,
  Vcl.ExtCtrls, Vcl.ActnList, Data.DB, MemDS, DBAccess, Ora, Vcl.StdCtrls,
  Vcl.Buttons, IntecExportGrid, aceCheckComboBox;

type
  TReportLoadAccountsForm = class(TForm)
    Panel1: TPanel;
    gBills: TCRDBGrid;
    dsBills: TDataSource;
    qBills: TOraQuery;
    ActionList1: TActionList;
    lPeriod: TLabel;
    cbPeriod: TComboBox;
    btLoadInExcel: TBitBtn;
    btRefresh: TBitBtn;
    qPeriods: TOraQuery;
    aExcel: TAction;
    aRefresh: TAction;
    btCheckAll: TButton;
    btUnCheckAll: TButton;
    qAccounts: TOraQuery;
    qBillsACCOUNT_NUMBER: TFloatField;
    qBillsCOUNT_DETAIL_NONZERO_BILL: TFloatField;
    qBillsCOUNT_NONZERO_BILL_FROM_ACC: TFloatField;
    qBillsCOUNT_DETAIL_BILL: TFloatField;
    qBillsCOUNT_BILL_FROM_ACC: TFloatField;
    qBillsCOUNT_PHONES_ON_END_MONTH: TFloatField;
    qBillsDIF_BETWEEN_NONZERO_BILLS: TFloatField;
    qBillsDIF_BETWEEN_BILLS: TFloatField;
    qBillsQUERY_LOAD: TFloatField;
    qBillsLOGIN: TStringField;
    procedure cbPeriodChange(Sender: TObject);
    procedure aRefreshExecute(Sender: TObject);
    procedure aExcelExecute(Sender: TObject);
    procedure btCheckAllClick(Sender: TObject);
    procedure btUnCheckAllClick(Sender: TObject);
  private
    { Private declarations }
    chcbAccountList : TacCheckComboBox;
    procedure Init(Session : TOraSession);
    procedure SetItemsState (State : Boolean);
  public
    { Public declarations }
  end;

const
  MainSQLText = 'SELECT A.ACCOUNT_NUMBER,' + #13#10+
                '       V.COUNT_DETAIL_NONZERO_BILL, ' + #13#10+
                '       V.COUNT_NONZERO_BILL_FROM_ACC,' + #13#10+
                '       V.COUNT_DETAIL_BILL,' + #13#10+
                '       V.COUNT_BILL_FROM_ACC,' + #13#10+
                '       V.COUNT_PHONES_ON_END_MONTH,' + #13#10+
                '       V.DIF_BETWEEN_NONZERO_BILLS,' + #13#10+
                '       V.DIF_BETWEEN_BILLS,' + #13#10+
                '       V.QUERY_LOAD,' + #13#10+
                '       V.LOGIN' + #13#10+
                '  FROM V_COUNT_LOADED_BILLS v, ACCOUNTS a' + #13#10+
                ' WHERE V.ACCOUNT_ID = A.ACCOUNT_ID' + #13#10+
                '       AND V.YEAR_MONTH = :PYEAR_MONTH' + #13#10;


var
  ReportLoadAccountsForm: TReportLoadAccountsForm;

  procedure DoReportLoadAccounts(Session : TOraSession);

implementation

{$R *.dfm}

procedure DoReportLoadAccounts(Session : TOraSession);
var ReportFrm : TReportLoadAccountsForm;
begin
  ReportFrm:=TReportLoadAccountsForm.Create(Nil);
  try
    // �����
    ReportFrm.Init(Session);
    ReportFrm.ShowModal;
  finally
    ReportFrm.Free;
  end;
end;
{ TReportLoadAccountsForm }

procedure TReportLoadAccountsForm.aExcelExecute(Sender: TObject);
var cr : TCursor;
begin
  cr := Screen.Cursor;
  Screen.Cursor := crHourGlass;
  try
    ExportDBGridToExcel2('����� �� ����������� ������ �� ' + cbPeriod.Text,'',
        gBills, nil, False, True);
  finally
    Screen.Cursor := cr;
  end;
end;

procedure TReportLoadAccountsForm.aRefreshExecute(Sender: TObject);
var I : Integer;
    LAccID : Integer;
    LCheckItemCount : Integer;
    Item : TCheckListItem;
    LRes : string;
begin
  LCheckItemCount := 0;
  for I := 0 to chcbAccountList.Items.Count - 1 do
  begin
    Item := (chcbAccountList.Items.Items[i] as TCheckListItem);
    if Item.Checked then
    begin
      inc(LCheckItemCount);
      LAccID := Integer(Item.GetObject);
      LRes := LRes + IntToStr(LAccID) + ',';
    end;
  end;
  if LCheckItemCount = 0 then
  begin
    ShowMessage('�� ������ �� ���� ����!!!');
    chcbAccountList.SetFocus;
    Exit;
  end;
  LRes := Copy( LRes, 1, Length(LRes) - 1);
  qBills.Close;
  qBills.SQL.Text := MainSQLText;
  qBills.ParamByName('PYEAR_MONTH').AsInteger := Integer(cbPeriod.Items.Objects[cbPeriod.ItemIndex]);
  if LCheckItemCount <> chcbAccountList.Items.Count  then
    qBills.SQL.Add('   AND V.ACCOUNT_ID in (' + LRes + ')');

  qBills.Open;
end;

procedure TReportLoadAccountsForm.btCheckAllClick(Sender: TObject);
begin
  SetItemsState(True);
  chcbAccountList.Text := '��� �����';
end;

procedure TReportLoadAccountsForm.btUnCheckAllClick(Sender: TObject);
begin
  SetItemsState(False);
  chcbAccountList.Text := '';
end;

procedure TReportLoadAccountsForm.cbPeriodChange(Sender: TObject);
var Period : Integer;
begin
  if cbPeriod.ItemIndex >= 0 then
    Period := Integer(cbPeriod.Items.Objects[cbPeriod.ItemIndex])
  else
    Period := -1;
  qBills.ParamByName('PYEAR_MONTH').AsInteger := Period;
  //aRefresh.Execute;
end;

procedure TReportLoadAccountsForm.Init(Session : TOraSession);
var
  Item : TCheckListItem;
begin
  //������� CheckComboBox
  chcbAccountList := TacCheckComboBox.Create(nil);
  chcbAccountList.Align := alLeft;
  chcbAccountList.Height := Panel1.Height;
  chcbAccountList.Width := 200;
  chcbAccountList.Visible := True;
  chcbAccountList.Parent := Panel1;

  //������ ������ ��� ��������� �������
  qBills.Session := Session;
  qBills.Close;
  qBills.SQL.Text := MainSQLText;

  //������ ������ ��� �������� � ��������� ComboBox ����������
  qPeriods.Session := Session;
  qPeriods.Open;
  qPeriods.First;
  while not qPeriods.EOF do
  begin
    cbPeriod.Items.AddObject(qPeriods.FieldByName('YEAR_MONTH_NAME').AsString,
                             TObject(qPeriods.FieldByName('YEAR_MONTH').AsInteger));
    qPeriods.Next;
  end;
  qPeriods.Close;
  //����������� �������� ������� �� ��������� � ��������� �������� ��������� �������
  if cbPeriod.Items.Count > 0 then
    cbPeriod.ItemIndex := 0;

  //������ ������ ��� ������ � ��������� CheckComboBox ����������
  qAccounts.Session := Session;

  qAccounts.Open;
  qAccounts.First;
  while not qAccounts.Eof do
  begin
    Item := (chcbAccountList.Items.Add as TCheckListItem);
    Item.Caption := qAccounts.FieldByName('ACCOUNT_NUMBER').AsString;
    Item.AddObject(TObject(qAccounts.FieldByName('ACCOUNT_ID').AsInteger));
    qAccounts.Next;
  end;

  //�������� ��� ����� �� ���������
  btCheckAllClick(Self);
  //����������� �������� ��������� ��������� �������
  qBills.Open;
end;

procedure TReportLoadAccountsForm.SetItemsState(State: Boolean);
var
  i : Integer;
begin
  for i := 0 to chcbAccountList.Items.Count - 1 do
    TCheckListItem(chcbAccountList.Items.Items[i]).Checked := State;
end;

end.
