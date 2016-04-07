unit ContractsRegistration_Utils;

interface

uses
  SysUtils, Classes, DB, MemDS, DBAccess, Ora, idhashsha, IdHashMessageDigest, CRGrid;

const
  TYPE_DOC_PAYMENT = 0;
  TYPE_DOC_CONTRACT = 1;
  TYPE_DOC_CHANGE_SIM = 2;
  TYPE_DOC_CHANGE_PHONE_NUM = 3;
  TYPE_DOC_CHANGE_TARIFF = 4;
  TYPE_DOC_CONTRACT_CANCEL = 5;

  TYPE_DOC_PAYMENT_TXT = '������';
  TYPE_DOC_CONTRACT_TXT = '�������� ������ ������';
  TYPE_DOC_CHANGE_SIM_TXT = '��������� �� ����� ���-�����';
  TYPE_DOC_CHANGE_PHONE_NUM_TXT = '��������� � ����� ������ ��������';
  TYPE_DOC_CHANGE_TARIFF_TXT = '��������� �� ����� ��������� �����';
  TYPE_DOC_CONTRACT_CANCEL_TXT = '��������� �� ����������� ��������';

type
  TdmUtils = class(TDataModule)
    qDefaultCountry: TOraQuery;
    qDefaultregion: TOraQuery;
    qFreeValue: TOraStoredProc;
    qGetNextNum: TOraStoredProc;
    qDefaultFilial: TOraQuery;
    qContract: TOraQuery;
    qGetConstant: TOraStoredProc;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  function GetDefaultCountry : Variant;

  function GetDefaultRegion : Variant;

  // �������� ��������� ����� ��������
  function GetNextContractNum : String;
  // ���������� ����� �������� (���������� �� GetNextContractNum)
  procedure FreeContractNum(const pFreeNum : integer);

  // �������� ��� ������� �� ���������
//  function GetDefaultFilialId : Variant;

  // ������������� ����� ��������
  function FormatPhoneNumber(const Text: string) : string;

  // �� ���� ��������� �������� ����� �������� � ��� ��������
//  function FindPhoneAndAbonent(const pContractID: Variant;
//                               var pPhoneNumber : String; var pAbonentId : Variant) : boolean;

  // �� ������ �������� �������� ��� ��������
  function FindAbonentId(const pPhoneNumber : String;  const vContNum : Integer;
                         var pAbonentId : Variant) : boolean;

  //������ �������� �������� �� �� �� �����
  function GetConstantValue(const Name:string):string;

  //������ �������� ���������� �� �� �� �����
  function GetParamValue(const Name:string):string;

  //������ �������� �������� �� �� �� �����
  function GetVersionValue(const Name:string):double;

  //���-������� SHA-1
  function sha1(s: string): string;

    //���-������� MD5
  function md5_30(s: string): string;

  //����������/�������� ������� ������� �� ��� ������������
  procedure VisibleColumnByFieldName(pGrid: TCRDBGrid; pName: string; pVis: boolean);

  //�������� ����������� ������������ � ���. ����� � ����������� �� ������ ���.
  //������ ��������������� ��������� ��������� BAN
  function CheckBANByPhoneNumber(pPhone: String): boolean;

  //�������� ���
  function MainCheckDates(begin_date,end_date:TDate): boolean;

implementation

uses
  Dialogs, Variants, Main;

{$R *.dfm}

var
  dmUtils: TdmUtils;

function md5_30(s: string): string;
begin
Result := '';
  with TIdHashMessageDigest5.Create do
  try
    Result :=Copy(LowerCase(HashStringAsHex(s)),1,30);
  finally
    Free;
  end;
end;

function sha1(s: string): string;
begin
Result := '';
  with TIdHashsha1.Create do
  try
    Result :=LowerCase(HashStringAsHex(s));
  finally
    Free;
  end;
end;

function GetVersionValue(const Name:string):double;
var Itog: double;
    res: string;
begin
  try
    Itog:=0;
    res:=Name;
    Itog:=Itog + StrToInt(copy(res, 1, Pos('.', res) - 1)) * 1000;
    res:=copy(res, Pos('.', res) + 1);
    Itog:=Itog + StrToInt(copy(res, 1, Pos('.', res) - 1)) * 1;
    res:=copy(res, Pos('.', res) + 1);
    Itog:=Itog + StrToInt(copy(res, 1, Pos('.', res) - 1)) * 0.001;
    res:=copy(res, Pos('.', res) + 1);
    Itog:=Itog + StrToInt(res) * 0.000001;
  except
    Itog:=1008.018;
  end;
  Result:=Itog;
end;

function GetConstantValue(const Name:string):string;
var Index:integer;
    b:boolean;
    Itog:String;
begin
{  if not Assigned(dmUtils) then
    dmUtils := TdmUtils.Create(Nil);
  dmUtils.qGetConstant.ParamByName('CONSTANT_NAME').AsString:=Name;
  dmUtils.qGetConstant.ExecSQL;
  Result:=dmUtils.qGetConstant.ParamByName('RESULT').AsString;}
  index:=0;
  Itog:='';
  while (Index<MainForm.FConstantSettingsCount) and (Itog='') do
  begin
    if MainForm.FConstantSettings[Index].Name=Name then
      Itog:=MainForm.FConstantSettings[Index].Value;
    Inc(index);
  end;
  Result:=Itog;
end;

function GetParamValue(const Name:string):string;
var Index:integer;
    b:boolean;
    Itog:String;
begin
  index:=0;
  Itog:='';
  while (Index<MainForm.FParamSettingsCount) and (Itog='') do
  begin
    if MainForm.FParamSettings[Index].Name=Name then
      Itog:=MainForm.FParamSettings[Index].Value;
    Inc(index);
  end;
  Result:=Itog;
end;

function GetDefaultCountry : Variant;
begin
  if not Assigned(dmUtils) then
    dmUtils := TdmUtils.Create(Nil);

  Result := Null;
  try
    dmUtils.qDefaultCountry.Close;
    dmUtils.qDefaultCountry.Open;
    if dmUtils.qDefaultCountry.RecordCount > 0 then
      Result := dmUtils.qDefaultCountry.FieldByName('COUNTRY_ID').Value;
  except
    on e : exception do ; // ������� ������
  end;
end;

function GetDefaultRegion : Variant;
begin
  if not Assigned(dmUtils) then
    dmUtils := TdmUtils.Create(Nil);

  try
    dmUtils.qDefaultRegion.Close;
    dmUtils.qDefaultRegion.Open;
    if dmUtils.qDefaultRegion.RecordCount > 0 then
      Result := dmUtils.qDefaultRegion.FieldByName('REGION_ID').Value;
  except
    on e : exception do ; // ������� ������
  end;
end;

function GetNextContractNum : String;
begin
  Result := '';
  try
    dmUtils.qGetNextNum.ExecSql;
    Result := dmUtils.qGetNextNum.ParamByName('RESULT').AsString;
  except
    on e : exception do
      MessageDlg('������ ��� ��������� ���������� ������ ��������.', mtError, [mbOK], 0);
  end;
end;

procedure FreeContractNum(const pFreeNum : integer);
begin
  try
    dmUtils.qFreeValue.ParamByName('PCONTRACT_NUM').Value := pFreeNum;
    dmUtils.qFreeValue.ExecSql;
  except
    on e : exception do
      MessageDlg('������ ��� ������������ ������.', mtError, [mbOK], 0);
  end;
end;
{
function GetDefaultFilialId : Variant;
begin
  Result := Null;
  try
    dmUtils.qDefaultFilial.Close;
    dmUtils.qDefaultFilial.Open;
    if dmUtils.qDefaultFilial.RecordCount > 0 then
      Result := dmUtils.qDefaultFilial.FieldByName('FILIAL_ID').Value;
  except
    on e : exception do
      MessageDlg('������ ��� ��������� ���� �������.', mtError, [mbOK], 0);
  end;
end;
}

function FormatPhoneNumber(const Text: string) : string;
var
  L : integer;
  i : integer;
begin
  if Text <> '' then
  begin
    Result := Text;
    L := Length(Text);
    for i := 1 to L do
      if not (Text[i] in ['0'..'9', '+', '-', ' ']) then
        Exit;
    if L >= 6 then
    begin
      Insert(' ', Result, L-3);
//      Insert('-', Result, L-3);
    end;
    if L >= 10 then
    begin
//      Insert(') ', Result, L-6);
//      Insert(' (', Result, L-9);
      Insert('  ', Result, L-6);
      if L > 10 then
        Insert('  ', Result, L-9);
    end;
  end
  else
    Result := Text;
end;

{
function FindPhoneAndAbonent(const pContractID: Variant;
                               var pPhoneNumber : String; var pAbonentId : Variant) : boolean;
begin
  if not Assigned(dmUtils) then
    dmUtils := TdmUtils.Create(Nil);

  Result := False;
  try
    dmUtils.qContract.Close;
    dmUtils.qContract.ParamByName('CONTRACT_ID').Value := pContractID;
    dmUtils.qContract.ParamByName('PHONE_NUMBER').Value := Null;
    dmUtils.qContract.Open;
    if not dmUtils.qContract.IsEmpty then
    begin
      pPhoneNumber := dmUtils.qContract.FieldByName('PHONE_NUMBER_FEDERAL').AsString;
      pAbonentId := dmUtils.qContract.FieldByName('ABONENT_ID').Value;
      Result := True;
    end
  except
    on e : exception do
      MessageDlg('������ ��� ��������� ���������� ���������.'#13#10+e.Message, mtError, [mbOK], 0);
  end;
end;
}

function FindAbonentId(const pPhoneNumber : String;  const vContNum : Integer;
                         var pAbonentId : Variant) : boolean;
begin
  if not Assigned(dmUtils) then
    dmUtils := TdmUtils.Create(Nil);

  Result := False;
  try
    dmUtils.qContract.Close;
    dmUtils.qContract.ParamByName('CONTRACT_ID').Value := Null;
    dmUtils.qContract.ParamByName('PHONE_NUMBER').Value := pPhoneNumber;
    dmUtils.qContract.ParamByName('CONTRACT_NUM').Value := vContNum;
    dmUtils.qContract.Open;
    if not dmUtils.qContract.IsEmpty then
    begin
      pAbonentId := dmUtils.qContract.FieldByName('ABONENT_ID').Value;
      Result := True;
    end
    else pAbonentId:=0;
  except
    on e : exception do
      MessageDlg('������ ��� ����������� ���� ��������.'#13#10+e.Message, mtError, [mbOK], 0);
  end;
end;

//����������/�������� ������� ������� �� ��� ������������ (pVis = false - ������, pVis = true - ��������)
procedure VisibleColumnByFieldName(pGrid: TCRDBGrid; pName: string; pVis: boolean);
var i: integer;
begin
  for i := 0 to pGrid.Columns.Count - 1 do
    if pGrid.Columns[i].FieldName = pName then
    begin
      pGrid.Columns[i].Visible := pVis;
      break;
    end;
end;

//�������� ����������� ������������ � ���. ����� � ����������� �� ������ ���.
//������ ��������������� ��������� ��������� BAN
function CheckBANByPhoneNumber(pPhone: String): boolean;
begin
  Result := true;
end;

//�������� ���
function MainCheckDates(begin_date,end_date:TDate): boolean;
begin
  Result := false;
  if begin_date > end_date then begin
    MessageDlg('��������� ���� �� ����� ���� ������ �������� ����!', mtConfirmation, [mbOK], 0);
    exit;
  end;
  if begin_date > Now then begin
    MessageDlg('��������� ���� �� ����� ���� ������ ������� ����!', mtConfirmation, [mbOK], 0);
    exit;
  end;
  Result := true;
end;

end.

