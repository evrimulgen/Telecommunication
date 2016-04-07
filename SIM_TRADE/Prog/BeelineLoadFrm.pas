unit BeelineLoadFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, DBCtrls, DB,Buttons, MemDS, DBAccess, Ora, ComCtrls,
  ActiveX, IntecExportGrid, StrUtils;

type
  TBeelineLoadForm = class(TForm)
    mData: TMemo;
    Panel1: TPanel;
    pAccountCaption: TPanel;
    lbAccount: TListBox;
    pPeriodCaption: TPanel;
    lbPeriods: TListBox;
    Panel4: TPanel;
    btnLoad: TButton;
    qAccounts: TOraQuery;
    pProgress: TProgressBar;
    dgOpen: TOpenDialog;
    BitBtn2: TBitBtn;
    dsContarct: TDataSource;
    qContract: TOraQuery;
    qGetNewId: TOraStoredProc;
    qContractCancel: TOraQuery;
    dsContractCancel: TDataSource;
    GroupBox2: TGroupBox;
    DSComboBox: TDBLookupComboBox;
    Label2: TLabel;
    qDopSt: TOraQuery;
    dsDopSt: TOraDataSource;
    BitBtn1: TBitBtn;
    qChangeDS: TOraQuery;
    pBlockUnblock: TPanel;
    rgBlockUnblock: TRadioGroup;
    Label1: TLabel;
    Label3: TLabel;
    procedure btnLoadClick(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    FHeaderLineIndex: Integer;
    countclosecontract:Integer;

  protected
    FAccountID : Integer;
    FAbonentID : Integer;
    FContractID : Integer;
    FAccountLogin : String;
    FLoadingYear, FLoadingMonth : Integer;

    function MakeStoredProcedure(const AText : String) : TOraStoredProc;
    function GetFloatData(const Value: string): Double;
    function GetIntegerData(const Value: string): Integer;


    function GetHeaderLine : String; virtual; abstract;
    function GetFormCaption : String; virtual; abstract;
    function IsSelectPeriodEnabled : Boolean; virtual;
    function IsSelectAccountEnabled : Boolean; virtual;
    //
    procedure DoBeforeLoad; virtual; abstract;
    procedure DoFormCreate; virtual; abstract;
    procedure DoLoad(var Line : String); virtual; abstract;
    procedure DoAfterLoad; virtual; abstract;
  public
     fFilialId : integer;
    procedure Execute;
  end;

 TBeelineLoadContractsForm = class(TBeelineLoadForm)

  private
    FLoadProc : TOraStoredProc;
  protected
    function GetHeaderLine : String; override;
    function GetFormCaption : String; override;
    function IsSelectPeriodEnabled : Boolean; override;
    function IsSelectAccountEnabled : Boolean; override;
    //
    procedure DoBeforeLoad; override;
    procedure DoFormCreate;  override;
    procedure DoLoad(var Line : String); override;
    procedure DoAfterLoad; override;
  end;

 TBeelineLoadBillForm = class(TBeelineLoadForm)
  private
    FLoadProc : TOraStoredProc;
  protected
    function GetHeaderLine : String; override;
    function GetFormCaption : String; override;
    function IsSelectPeriodEnabled : Boolean; override;
    function IsSelectAccountEnabled : Boolean; override;
    //
    procedure DoBeforeLoad; override;
    procedure DoFormCreate;  override;
    procedure DoLoad(var Line : String); override;
    procedure DoAfterLoad; override;
  end;

   TBeelineLoadMobiPayForm = class(TBeelineLoadForm)
  private
    FLoadProc : TOraStoredProc;
  protected
    function GetHeaderLine : String; override;
    function GetFormCaption : String; override;
    function IsSelectPeriodEnabled : Boolean; override;
    function IsSelectAccountEnabled : Boolean; override;
    //
    procedure DoBeforeLoad; override;
    procedure DoFormCreate;  override;
    procedure DoLoad(var Line : String); override;
    procedure DoAfterLoad; override;
  end;

   TBeelineLoadCloseForm = class(TBeelineLoadForm)
  private
    FLoadProc : TOraStoredProc;
  protected
    function GetHeaderLine : String; override;
    function GetFormCaption : String; override;
    function IsSelectPeriodEnabled : Boolean; override;
    function IsSelectAccountEnabled : Boolean; override;
    //
    procedure DoBeforeLoad; override;
    procedure DoFormCreate;  override;
    procedure DoLoad(var Line : String); override;
    procedure DoAfterLoad; override;
  end;

  TBeelineLoadPaymentsForm = class(TBeelineLoadForm)
  private
    FLoadProc : TOraStoredProc;
  protected
    function GetHeaderLine : String; override;
    function GetFormCaption : String; override;
    //
    procedure DoBeforeLoad; override;
    procedure DoFormCreate;  override;
    procedure DoLoad(var Line : String); override;
    procedure DoAfterLoad; override;
  end;

  TBeelineLoadStatusesForm = class(TBeelineLoadForm)
  private
    FLoadProc : TOraStoredProc;
  protected
    function GetHeaderLine : String; override;
    function GetFormCaption : String; override;
    //
    procedure DoBeforeLoad; override;
    procedure DoFormCreate;  override;
    procedure DoLoad(var Line : String); override;
    procedure DoAfterLoad; override;
  end;

  TBeelineCollectorStatesForm = class(TBeelineLoadForm)
  private
    FLoadProc : TOraStoredProc;
  protected
    function GetHeaderLine : String; override;
    function GetFormCaption : String; override;
    //
    procedure DoBeforeLoad; override;
    procedure DoFormCreate;  override;
    procedure DoLoad(var Line : String); override;
    procedure DoAfterLoad; override;
  end;
    TBeelineLoaderSettings = class(TBeelineLoadForm)
  private
    FLoadProc : TOraStoredProc;
  protected
    function GetHeaderLine : String; override;
    function GetFormCaption : String; override;
    //
    procedure DoBeforeLoad; override;
    procedure DoFormCreate;  override;
    procedure DoLoad(var Line : String); override;
    procedure DoAfterLoad; override;
  end;

  TBeelineLoadCostsForm = class(TBeelineLoadForm)
  private
    FLoadProc : TOraStoredProc;
  protected
    function GetHeaderLine : String; override;
    function GetFormCaption : String; override;
    function IsSelectPeriodEnabled : Boolean; override;
    //
    procedure DoBeforeLoad; override;
    procedure DoFormCreate;  override;
    procedure DoLoad(var Line : String); override;
    procedure DoAfterLoad; override;
  end;

  TBeelineLoadBSForm = class(TBeelineLoadForm)
  private
    FLoadProc : TOraStoredProc;
  protected
    function IsSelectPeriodEnabled : Boolean; override;
    function IsSelectAccountEnabled : Boolean; override;
    //
    procedure DoBeforeLoad; override;
    procedure DoFormCreate;  override;
    procedure DoLoad(var Line : String); override;
    procedure DoAfterLoad; override;

    function GetZoneName : String; virtual; abstract;
  end;

  TBeelineLoadBS_Msk_Form = class(TBeelineLoadBSForm)
  protected
    function GetFormCaption : String; override;
    function GetHeaderLine : String; override;
    function GetZoneName : String; override;
    procedure DoFormCreate;  override;
  end;

  TBeelineLoadBS_MO_Form = class(TBeelineLoadBSForm)
  protected
    function GetFormCaption : String; override;
    function GetHeaderLine : String; override;
    function GetZoneName : String; override;
    procedure DoFormCreate;  override;
  end;

   TBeelineLoadDopPhoneInfo = class(TBeelineLoadForm)
  private
    FLoadProc : TOraStoredProc;
  protected
    function GetHeaderLine : String; override;
    function GetFormCaption : String; override;
    function IsSelectPeriodEnabled : Boolean; override;
    function IsSelectAccountEnabled : Boolean; override;
    //
    procedure DoBeforeLoad; override;
    procedure DoFormCreate;  override;
    procedure DoLoad(var Line : String); override;
    procedure DoAfterLoad; override;

  end;

  TBeelineLoadBlockForm = class(TBeelineLoadForm)
  private
    FLoadProc : TOraStoredProc;
  protected
    function GetHeaderLine : String; override;
    function GetFormCaption : String; override;
    //
    procedure DoBeforeLoad; override;
    procedure DoFormCreate;  override;
    procedure DoLoad(var Line : String); override;
    procedure DoAfterLoad; override;
  end;

implementation
uses ComObj, Main, CRStrUtils, ContractsRegistration_Utils;
var
  PrNewFields: Boolean = false;

{$R *.dfm}

{TBeelineLoadBlockForm }
procedure TBeelineLoadBlockForm.DoFormCreate;
begin
    GroupBox2.Visible:=false;
    pBlockUnblock.visible:=true;
end;
function TBeelineLoadBlockForm.GetHeaderLine: String;
begin
  Result := '����� ��������	���� ����������';
end;

function TBeelineLoadBlockForm.GetFormCaption: String;
begin
   Result:='����������/�������������';
end;

procedure TBeelineLoadBlockForm.DoBeforeLoad;
begin
  // Nothing
end;

procedure TBeelineLoadBlockForm.DoLoad(var Line: String);
var
  PhoneNumber: string;
  vDateB: TDateTime;
  s:string;
  qAddQueue :TOraQuery;
begin
  if Trim(GetToken(Line, 2)) = '' then
  begin
    Line:=Line + #9 + '���� ����������/������������� �� ������!';
    Exit;
  end;
  try
    vDateB:=strtodate(Trim(GetToken(Line, 2)));
  except
    Line:=Line + #9 + '�������� ������ ���� ����������/�������������!';
    Exit;
  end;
  Try
    try
      qAddQueue:=TOraQuery.Create(self);
      PhoneNumber := Trim(GetToken(Line, 1));
      if (PhoneNumber <> '') and CharInSet(PhoneNumber[1], ['0'..'9']) then
      begin
        qAddQueue.SQL.Text:='SELECT * FROM QUEUE_LOAD_BLOCK_UNBLOCK WHERE phone_number = :phone_number AND type_action = :type_action AND dateb = :dateb AND success IS NULL';
        qAddQueue.ParamByName('phone_number').AsString := PhoneNumber;
        qAddQueue.ParamByName('type_action').AsInteger := rgBlockUnblock.ItemIndex;
        qAddQueue.ParamByName('dateb').AsDateTime := vDateB;
        qAddQueue.Open;
        if qAddQueue.RecordCount > 0 then
        begin
          Line:=Line + #9 + '��� ������� ������ ��� ���� ������� �� ������ ����!';
          Exit;
        end;
        qAddQueue.Close;
        qAddQueue.SQL.Text:='INSERT INTO QUEUE_LOAD_BLOCK_UNBLOCK (phone_number, type_action, dateb) VALUES (:phone_number, :type_action, :dateb)';
        qAddQueue.ParamByName('phone_number').AsString := PhoneNumber;
        qAddQueue.ParamByName('type_action').AsInteger := rgBlockUnblock.ItemIndex;
        qAddQueue.ParamByName('dateb').AsDateTime := vDateB;
        qAddQueue.ExecSQL;
        Line := Line + #9 + 'Ok!';
      end;
    finally
     FreeAndNil(qAddQueue);
    end;
  Except
    on e : exception do
      Line:=Line + #9 + '������ '+e.Message;
  End;

end;

procedure TBeelineLoadBlockForm.DoAfterLoad;
begin
  FreeAndNil(FLoadProc);
end;


{ TBeelineLoadForm }

procedure TBeelineLoadForm.BitBtn1Click(Sender: TObject);
var cr : TCursor;
begin
  cr := Screen.Cursor;
  Screen.Cursor := crHourGlass;
  try
    ExportStringsToExcel(mdata.Lines,GetFormCaption,#9);
  finally
    Screen.Cursor := cr;
  end;
end;



procedure TBeelineLoadForm.btnLoadClick(Sender: TObject);
var
  i: Integer;
  s :string;
  PeriodStamp: Integer;
  vStringList : TStringList;
begin
  if lbAccount.Items.Count > 0 then
  begin
    FAccountID := Integer(lbAccount.Items.Objects[lbAccount.ItemIndex]);
    FAccountLogin := lbAccount.Items[lbAccount.ItemIndex];
  end
  else
  begin
    FAccountID := -1;
    FAccountLogin := '';
  end;
  if IsSelectPeriodEnabled then
  begin
    PeriodStamp := Integer(lbPeriods.Items.Objects[lbPeriods.ItemIndex]);;
    FLoadingYear := PeriodStamp div 100;
    FLoadingMonth := PeriodStamp - FLoadingYear*100;
  end;
  Screen.Cursor := crSQLWait;
  try
    MainForm.OraSession.StartTransaction;
    DoBeforeLoad;
    pProgress.Max := mData.Lines.Count-1;
    vStringList := TStringList.Create;
    LockWindowUpdate(mData.Handle);
    for i := FHeaderLineIndex+1 to mData.Lines.Count-1 do
    begin
      pProgress.Position := i;
      pProgress.Update;
      Application.ProcessMessages;
      s := mData.Lines[i];
      DoLoad(s);
      vStringList.Add(s);
//      mData.Lines[i]:=s;
    end;
    mData.Lines := vStringList;
    vStringList.Free;
    LockWindowUpdate(0);
    DoAfterLoad;
    MainForm.OraSession.Commit;
    Screen.Cursor := crDefault;
    btnLoad.Enabled := False;
    ShowMessage('�������� ���������!');
  except
    Screen.Cursor := crDefault;
    MainForm.OraSession.Rollback;
    Raise;
  end;
end;


procedure TBeelineLoadForm.Execute;
var
  FileName: TFileName;
  fs : TFileStream;
  Parser: Variant;
  ParsedArray: Variant;
  ms: TBytesStream;
  VarBytes : Variant;
  TextData: String;
  I: Integer;
  ADate: TDateTime;
  StreamAdapter : TStreamAdapter;
  dd: Word;
  mm: Word;
  yy: Word;
  HeaderLine: string;
begin
  Caption := GetFormCaption;
  dgOpen.Title := Caption;
  if dgOpen.Execute then
  begin
    FileName := dgOpen.FileName;
    ms := TBytesStream.Create;
    try
      fs := TFileStream.Create(FileName, fmOpenRead or fmShareDenyNone);
      try
        ms.CopyFrom(fs, 0);
      finally
        FreeAndNil(fs);
      end;
      VarBytes := ms.Bytes;
    finally
      FreeAndNil(ms);
    end;
    try
      Parser := CreateOleObject('TariferPreProcessor.PreProcessor');
    except
      ShowMessage('����� ���������������� TariferPreProcessor.dll. �������� � ��������� ������:'#13#10'regsvr32 TariferPreProcessor.dll');
      VarClear(Parser);
    end;
    if not VarIsEmpty(Parser) then
    begin
    try
      ParsedArray := Parser.ProcessData(VarBytes);
    except
      VarClear(Parser);
      VarClear(ParsedArray);
      try
        fs := TFileStream.Create(FileName, fmOpenRead or fmShareDenyNone);
        Parser := CreateOleObject('TariferPreProcessor.PreProcessExcelFull');
        StreamAdapter := TStreamAdapter.Create(Fs, soReference);
        ParsedArray := Parser.ProcessData(StreamAdapter as IStream);
      finally
         FreeAndNil(fs);
      end;
    end;
      if VarIsArray(ParsedArray) and (VarArrayHighBound(ParsedArray, 1) >= 0) then
        TextData := ParsedArray[0]
      else
        TextData := '';
      mData.Lines.Text := TextData;
      if TextData = '' then
      begin
        btnLoad.Enabled := False;
        ShowMessage('���� �� �������� ����������. �������� �� ���������.');
      end
      else
      begin
        HeaderLine := GetHeaderLine;
        FHeaderLineIndex := mData.Lines.IndexOf(HeaderLine);
        if FHeaderLineIndex < 0 then
        begin
          btnLoad.Enabled := False;
          ShowMessage('������ ����� �� ������������� �������:'#13#10#13#10 + HeaderLine + #13#10#13#10'�������� �� ���������.');
        end
        else
        begin
          if IsSelectAccountEnabled then
          begin
            qAccounts.Open;
            try
              while not qAccounts.Eof do
              begin
                lbAccount.AddItem(
                  qAccounts.FieldByName('LOGIN').AsString,
                  Pointer(qAccounts.FieldByName('ACCOUNT_ID').AsInteger)
                  );
                qAccounts.Next;
              end;
            finally
              qAccounts.Close;
            end;
            if lbAccount.Items.Count > 0 then
              lbAccount.ItemIndex := 0;
            btnLoad.Enabled := (lbAccount.Items.Count > 0);
          end
          else
          begin
            pAccountCaption.Hide;
            lbAccount.Hide;
            btnLoad.Enabled := True;
          end;
          if IsSelectPeriodEnabled then
          begin
            for I := 0 to 11 do
            begin
              ADate := IncMonth(Date, -I);
              DecodeDate(ADate, yy, mm ,dd);
              lbPeriods.AddItem(FormatDateTime('YYYY, MM', ADate), Pointer(yy*100+mm));
            end;
            lbPeriods.ItemIndex := 0;
          end
          else
          begin
            pPeriodCaption.Hide;
            lbPeriods.Hide;
          end;
        end;
      end;
      ShowModal;
    end;
  end;
end;

procedure TBeelineLoadForm.FormCreate(Sender: TObject);
begin
  DoFormCreate;
end;

function TBeelineLoadForm.MakeStoredProcedure(
  const AText: String): TOraStoredProc;
begin
  Result := TOraStoredProc.Create(Self);
  Result.StoredProcName := AText;
//  Result.SQL.Text := AText;
  Result.Prepared := True;
end;

function TBeelineLoadForm.IsSelectPeriodEnabled: Boolean;
begin
  Result := True;
end;

{ TBeelineLoadPaymentsForm }

procedure TBeelineLoadPaymentsForm.DoAfterLoad;
var
  p: TOraStoredProc;
begin
  p := MakeStoredProcedure('DB_LOADER_PCKG.COMMIT_LOAD_PAYMENTS');
  try
    p.ParamByName('pYEAR').AsInteger := FLoadingYear;
    p.ParamByName('pMONTH').AsInteger := FLoadingMonth;
    p.ParamByName('pLOGIN').AsString := FAccountLogin;
    p.ExecSQL;
  finally
    FreeAndNil(p);
  end;
  FreeAndNil(FLoadProc);
end;

procedure TBeelineLoadPaymentsForm.DoBeforeLoad;
var
  p: TOraStoredProc;
begin
  p := MakeStoredProcedure('DB_LOADER_PCKG.START_LOAD_PAYMENTS');
  try
    p.ParamByName('pYEAR').AsInteger := FLoadingYear;
    p.ParamByName('pMONTH').AsInteger := FLoadingMonth;
    p.ParamByName('pLOGIN').AsString := FAccountLogin;
    p.ExecSQL;
  finally
    FreeAndNil(p);
  end;
end;

procedure TBeelineLoadPaymentsForm.DoLoad(var Line: String);
const
  digit: set of char = ['0'..'9'];
var
  PaymentDateStr : String;
  PaymentStatus: string;
  PaymentSum: Double;
  PaymentNumber_digit : string;
  PaymentNumber: string;
  PhoneNumber: string;
  i : integer;
begin
  PhoneNumber := GetToken(Line, 9);
  if PhoneNumber <> '' then
  begin
    PaymentDateStr := GetToken(Line, 1);
    if (PaymentDateStr <> '') then
      if CharInSet(PaymentDateStr[1], ['0'..'9']) then
      begin
        if FLoadProc = nil then
        begin
          FLoadProc := MakeStoredProcedure('DB_LOADER_PCKG.ADD_PAYMENT');
          FLoadProc.ParamByName('pYEAR').AsInteger := FLoadingYear;
          FLoadProc.ParamByName('pMONTH').AsInteger := FLoadingMonth;
          FLoadProc.ParamByName('pLOGIN').AsString := FAccountLogin;
        end;
        //
        FLoadProc.ParamByName('pPHONE_NUMBER').AsString := PhoneNumber;
        //
        FLoadProc.ParamByName('pPAYMENT_DATE').AsDateTime := EncodeDate(
          StrToInt(Copy(PaymentDateStr, 7, 4)),
          StrToInt(Copy(PaymentDateStr, 4, 2)),
          StrToInt(Copy(PaymentDateStr, 1, 2))
          );
        //
        PaymentStatus := GetToken(Line, 2);
        PaymentSum := GetFloatData(GetToken(Line, 3));
        if (PaymentStatus = '������ ��������')
            or (PaymentStatus = '������� ������� � ������� �������')
            or (PaymentStatus = '������ �������� �������')
        then
          PaymentStatus := '' // �� ��������� - �� � �������
        else if (PaymentStatus = '������ �������')
                or (PaymentStatus = '������� ������� �� ������� �������')
                or (PaymentStatus = '������� �������') then
          PaymentSum := -PaymentSum;// ����� ������ ���� ������� �������������!
        FLoadProc.ParamByName('pPAYMENT_SUM').AsFloat := PaymentSum;
        //
        PaymentNumber := GetToken(Line, 8);
        if Copy(PaymentNumber, Length(PaymentNumber)-2, 3) = ',00' then
            SetLength(PaymentNumber, Length(PaymentNumber)-3);

        //������� �� ������ ������� ��� �� �������� �������
        for i := 1 to Length(PaymentNumber) do
          if PaymentNumber[i] in digit then
            PaymentNumber_digit := PaymentNumber_digit + PaymentNumber[i];
        FLoadProc.ParamByName('pPAYMENT_NUMBER').AsString := PaymentNumber_digit;

        if PaymentStatus = '' then
        begin
          FLoadProc.ParamByName('pPAYMENT_VALID_FLAG').AsInteger := 1;
          FLoadProc.ParamByName('pPAYMENT_STATUS_TEXT').Clear;
        end
        else
        begin
          FLoadProc.ParamByName('pPAYMENT_VALID_FLAG').AsInteger := 0;
          FLoadProc.ParamByName('pPAYMENT_STATUS_TEXT').AsString := Copy(PaymentStatus, 1, 100);
        end;
        FLoadProc.ExecSQL;
      end;
  end;
end;

function TBeelineLoadPaymentsForm.GetFormCaption: String;
begin
  Result := '�������� ��������';
end;

function TBeelineLoadPaymentsForm.GetHeaderLine: String;
begin
  //Result := '���� �������	������ �������	����� � ������ �������	��������� � ������ �������	��� �������	����� � ������ ��������	��������� � ������ ��������	����� ���������� ��������� 	����� ��������';
  Result:='���� �������	������ �������	����� � ������ �������	��������� � ������ �������	��� �������	����� � ������ ��������	��������� � ������ ��������	����� ���������� ���������	����� ��������';
end;

{ TBeelineLoadStatusesForm }

procedure TBeelineLoadStatusesForm.DoAfterLoad;
var
  p: TOraStoredProc;
begin
  p := MakeStoredProcedure('DB_LOADER_PCKG.COMMIT_LOAD_ACCOUNT_PHONES');
  try
    p.ParamByName('pYEAR').AsInteger := FLoadingYear;
    p.ParamByName('pMONTH').AsInteger := FLoadingMonth;
    p.ParamByName('pLOGIN').AsString := FAccountLogin;
    p.ExecSQL;
  finally
    FreeAndNil(p);
  end;
  FreeAndNil(FLoadProc);
end;

procedure TBeelineLoadStatusesForm.DoBeforeLoad;
var
  p: TOraStoredProc;
begin
  p := MakeStoredProcedure('DB_LOADER_PCKG.START_LOAD_ACCOUNT_PHONES');
  try
    p.ParamByName('pYEAR').AsInteger := FLoadingYear;
    p.ParamByName('pMONTH').AsInteger := FLoadingMonth;
    p.ParamByName('pLOGIN').AsString := FAccountLogin;
    p.ExecSQL;
  finally
    FreeAndNil(p);
  end;
end;

procedure TBeelineLoadStatusesForm.DoLoad(var Line: String);
var
  PhoneNumber: string;
  StatusFlag: Integer;
  CellPlanDateStr: string;
begin
  PhoneNumber := Trim(GetToken(Line, 1));
  if (PhoneNumber <> '') and CharInSet(PhoneNumber[1], ['0'..'9']) then
  begin
    if FLoadProc = nil then
    begin
      FLoadProc := MakeStoredProcedure('DB_LOADER_PCKG.ADD_ACCOUNT_PHONE');
      FLoadProc.ParamByName('pYEAR').AsInteger := FLoadingYear;
      FLoadProc.ParamByName('pMONTH').AsInteger := FLoadingMonth;
      FLoadProc.ParamByName('pLOGIN').AsString := FAccountLogin;
    end;
    FLoadProc.ParamByName('pPHONE_NUMBER').AsString := PhoneNumber;
    //
    if AnsiLowerCase(Copy(GetToken(Line, 6), 1, 4)) = '����' then
      StatusFlag := 0
    else
      StatusFlag := 1;
    FLoadProc.ParamByName('pPHONE_IS_ACTIVE').AsInteger := StatusFlag;
    //
    FLoadProc.ParamByName('pCELL_PLAN_CODE').AsString := Trim(GetToken(Line, 3));
    FLoadProc.ParamByName('pNEW_CELL_PLAN_CODE').AsString := Trim(GetToken(Line, 4));
    //
    CellPlanDateStr := Trim(GetToken(Line, 5));
    if Length(CellPlanDateStr) = 10 then
      FLoadProc.ParamByName('pNEW_CELL_PLAN_DATE').AsDateTime := EncodeDate(
        StrToInt(Copy(CellPlanDateStr, 7, 4)),
        StrToInt(Copy(CellPlanDateStr, 4, 2)),
        StrToInt(Copy(CellPlanDateStr, 1, 2))
        )
    else
      FLoadProc.ParamByName('pNEW_CELL_PLAN_DATE').Clear;
    //
    FLoadProc.ParamByName('pORGANIZATION_ID').Clear;
    FLoadProc.ParamByName('pNEED_RESET_OPTIONS').Clear;
    FLoadProc.ExecSQL;
  end;
end;

function TBeelineLoadStatusesForm.GetFormCaption: String;
begin
  Result := '�������� ��������';
end;

function TBeelineLoadStatusesForm.GetHeaderLine: String;
begin
  Result := '����� ��������	���� ���������	������� �������� ����	������� �������� ����	���� ����� ��������� �����	������	���� ����� �������	������� ���������� ���������	����������';
end;

{ TBeelineLoadCostsForm }

procedure TBeelineLoadCostsForm.DoAfterLoad;
begin
  FreeAndNil(FLoadProc);
end;

function TBeelineLoadForm.GetFloatData(const Value: string): Double;
begin
  Result := StrToFloat(
    StringReplace(
      StringReplace(
        StringReplace(
          StringReplace(Value, '�', '', [rfReplaceAll]),
           ' ', '', [rfReplaceAll]),
         ',', DecimalSeparator, [rfReplaceAll]),
       '.', DecimalSeparator, [rfReplaceAll])
    );
end;

function TBeelineLoadForm.GetIntegerData(const Value: string): Integer;
begin
  Result := StrToInt(
    StringReplace(
      StringReplace(
        StringReplace(
          StringReplace(Value, '�', '', [rfReplaceAll]),
           ' ', '', [rfReplaceAll]),
         ',', DecimalSeparator, [rfReplaceAll]),
       '.', DecimalSeparator, [rfReplaceAll])
    );
end;

function TBeelineLoadForm.IsSelectAccountEnabled: Boolean;
begin
  Result := True;
end;

procedure TBeelineLoadCostsForm.DoBeforeLoad;
begin
  // Nothing
end;

procedure TBeelineLoadCostsForm.DoLoad(var Line: String);
const
  VAT = 1.18;
var
  PhoneNumber : String;
begin
  PhoneNumber := Trim(GetToken(Line, 3, ';'));
  if (PhoneNumber <> '') and CharInSet(PhoneNumber[1], ['0'..'9']) then
  begin
    if FLoadProc = nil then
    begin
      FLoadProc := MakeStoredProcedure('DB_LOADER_PCKG.SET_REPORT_DATA');
      FLoadProc.ParamByName('pDATE_LAST_UPDATE').AsDateTime := Now;
    end;
    FLoadProc.ParamByName('pPHONE_NUMBER').AsString := PhoneNumber;
    FLoadProc.ParamByName('pCURRENT_SUM').AsFloat := VAT * GetFloatData(GetToken(Line, 4, ';'));
    FLoadProc.ExecSQL;
  end;
end;

function TBeelineLoadCostsForm.GetFormCaption: String;
begin
  Result := '�������� ����������';
end;

function TBeelineLoadCostsForm.GetHeaderLine: String;
begin
  Result := '�������;������ ������;����� ��������;��������������� ��������� (��� ���)';
end;

function TBeelineLoadCostsForm.IsSelectPeriodEnabled: Boolean;
begin
  Result := False;
end;

function TBeelineLoadMobiPayForm.IsSelectPeriodEnabled: Boolean;
begin
  Result := False;
end;
{ TBeelineLoadBS_Msk_Form }

procedure TBeelineLoadBSForm.DoBeforeLoad;
begin
  FLoadProc := MakeStoredProcedure('BEELINE_BS_ZONE_CLEAR');
  FLoadProc.ParamByName('pZONE_NAME').AsString := GetZoneName;
  FLoadProc.Execute;
  FreeAndNil(FLoadProc);
  // Nothing
end;

procedure TBeelineLoadBSForm.DoAfterLoad;
begin
  FreeAndNil(FLoadProc);
end;

function TBeelineLoadBSForm.IsSelectAccountEnabled: Boolean;
begin
  Result := False;
end;

function TBeelineLoadMobiPayForm.IsSelectAccountEnabled: Boolean;
begin
  Result := False;
end;

procedure TBeelineLoadMobiPayForm.DoLoad(var Line: String);
var
  Sum: Integer;
  Phone: String;
begin
  Phone := GetToken(Line, 1, #9);
  Sum := StrToIntDef(GetToken(Line, 2, #9), -1);
  if Sum > 0 then
  begin
    if FLoadProc = nil then
    begin
      FLoadProc := MakeStoredProcedure('MOB_PAY_ADDF');
    end;
    FLoadProc.ParamByName('pPHONE').AsString := Phone;
    FLoadProc.ParamByName('pSUM').AsInteger := Sum;
    FLoadProc.ParamByName('pCHECK').AsInteger := 1;
    FLoadProc.ExecSQL;
    if FLoadProc.ParamByName('RESULT').AsInteger <> 0 then
      if  MessageDlg('��� �������� '+Phone+' ������� ������ �������� � �������� '+
      FLoadProc.ParamByName('RESULT').AsString+'�. �������� ����� ������� �� '+inttostr(sum)+'�.?', mtConfirmation, [mbYes,mbNO], 0) = mrYes
      then begin
        FLoadProc.ParamByName('pPHONE').AsString := Phone;
        FLoadProc.ParamByName('pSUM').AsInteger := Sum;
        FLoadProc.ParamByName('pCHECK').AsInteger := 0;
        FLoadProc.ExecSQL;
      end;
  end;
end;

procedure TBeelineLoadBSForm.DoLoad(var Line: String);
var
  BSCode: Integer;
begin
  BSCode := StrToIntDef(GetToken(Line, 1, #9), -1);
  if BSCode > 0 then
  begin
    if FLoadProc = nil then
    begin
      FLoadProc := MakeStoredProcedure('BEELINE_BS_ZONE_ADD_CODE');
      FLoadProc.ParamByName('pZONE_NAME').AsString := GetZoneName;
    end;
    FLoadProc.ParamByName('pBS_CODE').AsInteger := BSCode;
    FLoadProc.ExecSQL;
  end;
end;

function TBeelineLoadBSForm.IsSelectPeriodEnabled: Boolean;
begin
  Result := False;
end;

{ TBeelineLoadBS_Msk_Form }

function TBeelineLoadBS_Msk_Form.GetFormCaption: String;
begin
  Result := '���� ������� ������� ������';
end;

function TBeelineLoadBS_Msk_Form.GetHeaderLine: String;
begin
  Result := '����� �������� ����:� MOSCOW'#9#9#9#9#9#9#9;
end;

function TBeelineLoadBS_Msk_Form.GetZoneName: String;
begin
  Result := '������';
end;

{ TBeelineLoadBS_MO_Form }

function TBeelineLoadBS_MO_Form.GetFormCaption: String;
begin
  Result := '���� ������� ������� ���������� �������';
end;

function TBeelineLoadMobiPayForm.GetFormCaption: String;
begin
  Result := 'MobiPay';
end;

function TBeelineLoadMobiPayForm.GetHeaderLine: String;
begin
  Result := '�����	�����';
end;

function TBeelineLoadBS_MO_Form.GetHeaderLine: String;
begin
  Result := '����� �������� ����:� PODM'#9#9#9#9#9#9#9;
end;

function TBeelineLoadBillForm.GetFormCaption: String;
begin
  Result := '�������� ������';
end;

function TBeelineLoadBillForm.GetHeaderLine: String;
begin
  Result := '����� ��������	�������	������ ������	���� ������ �������	���� ��������� '+
  '�������	�������� ����	������������� ������	������������� ������	������� ������	'+
  'SMS / MMS	GPRS	������������� ������� ������� ����� (���������� ��������)	'+
  '������������� ������� SMS (���������� ��������)	������������� ������� GPRS '+
  '(���������� ��������)	���������� �� ������������� �������	������������ ������� '+
  '������� ����� (���������� ��������)	������������ ������� SMS (���������� ��������)'+
  '	������������ ������� GPRS (���������� ��������)	���������� �� ������������ �������	'+
  '����������� ����� �� ��������� �����	����������� ����� �� ���. ������	������	'+
  '������� ���������� (��������)	����	����� �� ������	������������ ���������� �� ����. '+
  '����� � �������	������������ �������� �� ��������	���	����� �� ������';
end;

function TBeelineLoadBillForm.IsSelectPeriodEnabled: Boolean;
begin
  Result := False;
end;

procedure TBeelineLoadBillForm.DoFormCreate;
begin
    GroupBox2.Visible:=false;
end;

procedure TBeelineLoadMobiPayForm.DoFormCreate;
begin
    GroupBox2.Visible:=false;
end;

procedure TBeelineLoadCloseForm.DoFormCreate;
begin
    GroupBox2.Visible:=false;
end;

procedure TBeelineLoadPaymentsForm.DoFormCreate;
begin
    GroupBox2.Visible:=false;
end;

procedure TBeelineLoadStatusesForm.DoFormCreate;
begin
    GroupBox2.Visible:=false;
end;

procedure TBeelineCollectorStatesForm.DoFormCreate;
begin
    GroupBox2.Visible:=false;
end;

procedure TBeelineLoaderSettings.DoFormCreate;
begin
    GroupBox2.Visible:=false;
end;

procedure TBeelineLoadCostsForm.DoFormCreate;
begin
    GroupBox2.Visible:=false;
end;

procedure TBeelineLoadBSForm.DoFormCreate;
begin
    GroupBox2.Visible:=false;
end;

procedure TBeelineLoadBS_Msk_Form.DoFormCreate;
begin
    GroupBox2.Visible:=false;
end;

procedure TBeelineLoadBS_MO_Form.DoFormCreate;
begin
    GroupBox2.Visible:=false;
end;

procedure TBeelineLoadDopPhoneInfo.DoFormCreate;
begin
    GroupBox2.Visible:=false;
end;


procedure TBeelineLoadContractsForm.DoFormCreate;
begin
    GroupBox2.Visible:=false;
end;


function TBeelineLoadContractsForm.GetFormCaption: String;
begin
  Result := '�������� ����������';
end;

function TBeelineLoadContractsForm.GetHeaderLine: String;
begin
{
  if GetConstantValue('LOAD_FIO_WHEN_LOAD_CONTRACTS')='1' then
    Result := '��������	��� ������	�����	�����	����� id	����� crm_id	�����	���� ������	���� ���������	���������	����	���������	������ ���������	�������	���	��������'
  else
    Result := '��������	��� ������	�����	�����	����� id	����� crm_id	�����	���� ������	���� ���������	���������	����	���������	������ ���������';

  // ����� ���� � excel-�����
  // (�������������: ������ "���� ������" �� "����� ��������")
  if (GetConstantValue('LOAD_NEW_WHEN_LOAD_CONTRACTS')='1') then
  begin
    PrNewFields:=true;
//  Result := '��������	��� ������	�����	�����	����� id	����� crm_id	�����	����� ��������	���� ���������	���������	����	���������	������ ���������	���� � ����������	��������� �����	��������� ������	�������	���	��������';
    Result := '��������	��� ������	�����	�����	����� MNP	����� id	����� crm_id	�����	����� ��������	���� ���������	���������	����	���������	������ ���������	���� � ����������	��������� �����	��������� ������	�������	���	��������';
  end;
}
Result := '���� ��������	�������	���	��������	���� ��������	�����	�����	���/���	����� ��������';
end;

function TBeelineLoadContractsForm.IsSelectPeriodEnabled: Boolean;
begin
  Result := False;
end;

procedure TBeelineLoadContractsForm.DoBeforeLoad;
var qAddAbonent:ToRaQuery;
vStringList : TStringList;
  p: TOraStoredProc;
begin
   FreeAndNil(FLoadProc);
end;

procedure TBeelineLoadMobiPayForm.DoBeforeLoad;
var qAddAbonent:ToRaQuery;
vStringList : TStringList;
  p: TOraStoredProc;
begin
   FreeAndNil(FLoadProc);
end;

procedure TBeelineLoadContractsForm.DoAfterLoad;
begin
  FreeAndNil(FLoadProc);
end;

function TBeelineLoadContractsForm.IsSelectAccountEnabled: Boolean;
begin
  Result := False;
end;

procedure TBeelineLoadContractsForm.DoLoad(var Line: String);
const
  min_tariff_START_BALANCE = -1;

var qAddAbonent, qTariffs : TORaQuery;
  vStringList : TStringList;
  p: TOraStoredProc;
  summ : real;
  cnt,contr: integer;
  time_temp1, time_temp2: TDateTime;
  tariff_START_BALANCE : Double;
begin

  if Line <> #9+#9+#9+#9+#9+#9+#9+#9+#9 then
  begin
      try
        qTariffs := ToRaQuery.Create(Self);
        qTariffs.SQL.Text := 'select * from tariffs tf where tf.tariff_name=:TARIFF_NAME';
          qTariffs.ParamByName('TARIFF_NAME').AsString := GetToken(Line, 7);
        qTariffs.ExecSQL;

        if qTariffs.FieldByName('TARIFF_ID').IsNull then
          Line := '������, ����� �� ������!' +#9 +Line
        else
        begin
          if (qTariffs.FieldByName('START_BALANCE').IsNull) OR (qTariffs.FieldByName('START_BALANCE').AsFloat = 0) then
            tariff_START_BALANCE := min_tariff_START_BALANCE
          else
            tariff_START_BALANCE := qTariffs.FieldByName('START_BALANCE').AsFloat;

          qAddAbonent := ToRaQuery.Create(Self);
          qAddAbonent.SQL.Text := 'Select  to_char(contract_date,''dd.mm.yyyy'') as pp FROM v_contracts'+#13#10+
              'WHERE  CONTRACT_CANCEL_DATE is null'+#13#10+
              'and (PHONE_NUMBER_FEDERAL=:phoneNumber  or  PHONE_NUMBER_CITY=substr(:phoneNumber,-7))';
          qAddAbonent.ParamByName('phoneNumber').AsString:= GetToken(Line, 6);
          qAddAbonent.ExecSQL;

          if qAddAbonent.FieldByName('pp').IsNull then
          begin
            qAddAbonent.Close;
            qAddAbonent.SQL.Text :='INSERT INTO ABONENTS'+#13#10+
            '(ABONENT_ID, SURNAME, NAME, PATRONYMIC, BDATE, PASSPORT_SER, PASSPORT_NUM, '+
            'PASSPORT_DATE, PASSPORT_GET, CITIZENSHIP, COUNTRY_ID, REGION_ID, REGION_NAME, CITY_NAME, STREET_NAME, HOUSE, KORPUS, APARTMENT, CONTACT_INFO, CODE_WORD, IS_VIP, EMAIL, DESCRIPTION)'+#13#10+
            'VALUES'+#13#10+
            '(:ABONENT_ID, :SURNAME, :NAME, :PATRONYMIC, :BDATE, :PASSPORT_SER, :PASSPORT_NUM,'+
            ' :PASSPORT_DATE, :PASSPORT_GET, :CITIZENSHIP, :COUNTRY_ID, :REGION_ID, :REGION_NAME, :CITY_NAME, :STREET_NAME, :HOUSE, :KORPUS, :APARTMENT, :CONTACT_INFO, :CODE_WORD, :IS_VIP, :EMAIL, :DESCRIPTION)'+#13#10+
            'RETURNING'+#13#10+
            'ABONENT_ID, SURNAME, NAME, PATRONYMIC, BDATE, PASSPORT_SER, PASSPORT_NUM, PASSPORT_DATE, PASSPORT_GET, CITIZENSHIP, COUNTRY_ID, REGION_ID, REGION_NAME, CITY_NAME, STREET_NAME, HOUSE, KORPUS, APARTMENT, CONTACT_INFO, CODE_WORD, IS_VIP, EMAIL, DESCRIPTION'+#13#10+
            'INTO'+#13#10+
            ':ABONENT_ID, :SURNAME, :NAME, :PATRONYMIC, :BDATE, :PASSPORT_SER, :PASSPORT_NUM,'+
            ' :PASSPORT_DATE, :PASSPORT_GET, :CITIZENSHIP, :COUNTRY_ID, :REGION_ID, :REGION_NAME, :CITY_NAME, :STREET_NAME, :HOUSE, :KORPUS, :APARTMENT, :CONTACT_INFO, :CODE_WORD, :IS_VIP, :EMAIL, :DESCRIPTION';

              qAddAbonent.ParamByName('ABONENT_ID').AsInteger := 0;

              if GetToken(Line, 2) <> '' then
                qAddAbonent.ParamByName('SURNAME').AsString := GetToken(Line, 2)
              else
              qAddAbonent.ParamByName('SURNAME').AsString := GetToken(Line, 6);
              if  GetToken(Line, 3) <> '' then
                qAddAbonent.ParamByName('NAME').AsString := GetToken(Line, 3)
              else
                qAddAbonent.ParamByName('NAME').AsString := GetToken(Line, 6);
              if GetToken(Line, 4) <> '' then
                qAddAbonent.ParamByName('PATRONYMIC').AsString := GetToken(Line, 4)
              else
                qAddAbonent.ParamByName('PATRONYMIC').AsString := GetToken(Line, 6);
              if GetToken(Line, 5) <> '' then
                qAddAbonent.ParamByName('BDATE').AsDate := StrToDate(GetToken(Line, 5));

              qAddAbonent.ExecSQL;
              FAbonentID := qAddAbonent.ParamByName('ABONENT_ID').Value;
              qAddAbonent.Close;

              qAddAbonent.SQL.Text :='INSERT INTO CONTRACTS'+#13#10+
            '(CONTRACT_ID, CONTRACT_NUM, CONTRACT_DATE, FILIAL_ID, OPERATOR_ID, '+
            'PHONE_NUMBER_FEDERAL, PHONE_NUMBER_CITY, PHONE_NUMBER_TYPE, TARIFF_ID,' +
            'SIM_NUMBER, SERVICE_ID, DISCONNECT_LIMIT, CONFIRMED, ABONENT_ID, RECEIVED_SUM,' +
            'START_BALANCE, GOLD_NUMBER_SUM, INSTALLMENT_PAYMENT_DATE,' +
            'INSTALLMENT_PAYMENT_SUM, INSTALLMENT_PAYMENT_MONTHS, DEALER_KOD, DOP_STATUS)'+#13#10+
            'VALUES'+#13#10+
            '(:CONTRACT_ID, :CONTRACT_NUM, :CONTRACT_DATE, :FILIAL_ID, :OPERATOR_ID, '+
            ':PHONE_NUMBER_FEDERAL, :PHONE_NUMBER_CITY, :PHONE_NUMBER_TYPE, :TARIFF_ID,' +
            ':SIM_NUMBER, :SERVICE_ID, :DISCONNECT_LIMIT, :CONFIRMED, :ABONENT_ID, :RECEIVED_SUM,' +
            ':START_BALANCE, :GOLD_NUMBER_SUM, :INSTALLMENT_PAYMENT_DATE,' +
            ':INSTALLMENT_PAYMENT_SUM, :INSTALLMENT_PAYMENT_MONTHS, :DEALER_KOD, :DOP_STATUS)';
              qAddAbonent.ParamByName('CONTRACT_ID').Value := 0;
              p := MakeStoredProcedure('GET_NEXT_CONTRACT_NUMBER');
              p.ExecSQL;
              qAddAbonent.ParamByName('CONTRACT_NUM').AsString := p.ParamByName('RESULT').AsString;
             //
              qAddAbonent.ParamByName('CONTRACT_DATE').AsDate := strtodate(GetToken(Line, 1));
            //
              qAddAbonent.ParamByName('OPERATOR_ID').Value := qTariffs.FieldByName('OPERATOR_ID').Value;
            //

              qAddAbonent.ParamByName('PHONE_NUMBER_FEDERAL').AsString := GetToken(Line, 6);
            //
            if qTariffs.FieldByName('PHONE_NUMBER_TYPE').AsInteger=1 then
              qAddAbonent.ParamByName('PHONE_NUMBER_CITY').AsString:= copy(GetToken(Line, 6),4,7);
            //
            qAddAbonent.ParamByName('PHONE_NUMBER_TYPE').AsInteger := qTariffs.FieldByName('PHONE_NUMBER_TYPE').AsInteger;
            //
            qAddAbonent.ParamByName('TARIFF_ID').Value := qTariffs.FieldByName('TARIFF_ID').Value;
            //
             qAddAbonent.ParamByName('ABONENT_ID').Value := FAbonentID;
            //
            qAddAbonent.ParamByName('FILIAL_ID').Value := 182;
            //

            summ := strtofloat(GetToken(Line, 9));

            if tariff_START_BALANCE <> min_tariff_START_BALANCE  then
              summ := tariff_START_BALANCE;

            qAddAbonent.ParamByName('RECEIVED_SUM').AsFloat:= summ;
            qAddAbonent.ParamByName('START_BALANCE').AsFloat := summ;

            qAddAbonent.ExecSQL;

             FreeAndNil(p);
             p := MakeStoredProcedure('GET_ABONENT_BALANCE_NO_AT');
             p.ParamByName('pPHONE_NUMBER').AsString := GetToken(Line, 6);
             p.ExecSQL;
            if p.ParamByName('RESULT').AsFloat<0 then
              Line := '� �������� ������������� ������!'+#9+Line
            else
              Line := 'Ok! '+Line;
          end
          else
            Line := '������, �������� � ����� ������� ��� ������� '+qAddAbonent.FieldByName('pp').AsString+'!'+#9+Line;

        end;
        FreeAndNil(qAddAbonent);
        FreeAndNil(qTariffs);
        FreeAndNil(p);

      except
        on e : exception do
          Line:='������ '+e.Message+#9+Line;
      end;
  end;
end;

procedure TBeelineLoadBillForm.DoBeforeLoad;
var
  p: TOraStoredProc;
begin
  p := MakeStoredProcedure('FIND_LOGIN_BY_ACCOUNT_ID');
  try
    p.ParamByName('pACCOUNT_ID').AsFloat := GetFloatData(GetToken(mData.Lines[FHeaderLineIndex+1], 2));
    p.ExecSQL;
    FAccountLogin:=p.ParamByName('RESULT').AsString;
    FLoadingYear:= StrToInt(Copy(GetToken(mData.Lines[FHeaderLineIndex+1], 4), 7, 4));
    FLoadingMonth:=StrToInt(Copy(GetToken(mData.Lines[FHeaderLineIndex+1], 4), 4, 2));
  finally
    FreeAndNil(p);
  end;
end;

procedure TBeelineLoadBillForm.DoAfterLoad;
begin
  FreeAndNil(FLoadProc);
end;

procedure TBeelineLoadMobiPayForm.DoAfterLoad;
begin
  FreeAndNil(FLoadProc);
end;

function TBeelineLoadBillForm.IsSelectAccountEnabled: Boolean;
begin
  Result := False;
end;

procedure TBeelineLoadBillForm.DoLoad(var Line: String);
const vat = 1.18;
begin
  if FLoadProc = nil then
    FLoadProc := MakeStoredProcedure('DB_LOADER_PCKG.SET_PHONE_BILL_DATA');

  FLoadProc.ParamByName('pYEAR').AsInteger := FLoadingYear;
  FLoadProc.ParamByName('pMONTH').AsInteger := FLoadingMonth;
  FLoadProc.ParamByName('pLOGIN').AsString := FAccountLogin;

  //
  FLoadProc.ParamByName('pPHONE_NUMBER').AsString := copy(GetToken(Line, 1),1,10);
  //
  FLoadProc.ParamByName('pDATE_BEGIN').AsDateTime := EncodeDate(
          StrToInt(Copy(GetToken(Line, 4), 7, 4)),
          StrToInt(Copy(GetToken(Line, 4), 4, 2)),
          StrToInt(Copy(GetToken(Line, 4), 1, 2))
          );
  //
  FLoadProc.ParamByName('pDATE_END').AsDateTime := EncodeDate(
          StrToInt(Copy(GetToken(Line, 5), 7, 4)),
          StrToInt(Copy(GetToken(Line, 5), 4, 2)),
          StrToInt(Copy(GetToken(Line, 5), 1, 2))
          );
  //
  FLoadProc.ParamByName('pTARIFF_CODE').AsString := GetToken(Line, 6);
  //
  FLoadProc.ParamByName('pBILL_SUM').AsFloat := VAT * GetFloatData(GetToken(Line, 25));
  //
  FLoadProc.ParamByName('pSUBSCRIBER_PAYMENT_MAIN').AsFloat := VAT * GetFloatData(GetToken(Line, 20));
  //
  FLoadProc.ParamByName('pSUBSCRIBER_PAYMENT_ADD').AsFloat := VAT * GetFloatData(GetToken(Line, 21));
  //
  FLoadProc.ParamByName('pSINGLE_PAYMENTS').AsFloat := VAT * GetFloatData(GetToken(Line, 23));
  //
  FLoadProc.ParamByName('pCALLS_LOCAL_COST').AsFloat := VAT * GetFloatData(GetToken(Line, 9));
  //
  FLoadProc.ParamByName('pCALLS_OTHER_CITY_COST').AsFloat := VAT * GetFloatData(GetToken(Line, 8));
  //
  FLoadProc.ParamByName('pCALLS_OTHER_COUNTRY_COST').AsFloat := VAT * GetFloatData(GetToken(Line, 7));
  //
  FLoadProc.ParamByName('pMESSAGES_COST').AsFloat := VAT * GetFloatData(GetToken(Line, 10));
  //
  FLoadProc.ParamByName('pINTERNET_COST').AsFloat := VAT * GetFloatData(GetToken(Line, 11));
  //
  FLoadProc.ParamByName('pOTHER_COUNTRY_ROAMING_COST').AsFloat := VAT * GetFloatData(GetToken(Line, 15));
  //
  FLoadProc.ParamByName('pNATIONAL_ROAMING_COST').AsFloat := VAT * GetFloatData(GetToken(Line, 19));
  //
  FLoadProc.ParamByName('pPENI_COST').AsFloat := VAT * GetFloatData(GetToken(Line, 24));
  //
  FLoadProc.ParamByName('pDISCOUNT_VALUE').AsFloat := VAT * GetFloatData(GetToken(Line, 22));
  //
  FLoadProc.ParamByName('pother_country_roaming_calls').AsFloat := VAT * GetFloatData(GetToken(Line, 12));
  //
  FLoadProc.ParamByName('pother_country_roaming_mes').AsFloat := VAT * GetFloatData(GetToken(Line, 13));
  //
  FLoadProc.ParamByName('pother_country_roaming_int').AsFloat := VAT * GetFloatData(GetToken(Line, 14));
  //
  FLoadProc.ParamByName('pnational_roaming_calls').AsFloat := VAT * GetFloatData(GetToken(Line, 16));
  //
  FLoadProc.ParamByName('pnational_roaming_messages').AsFloat := VAT * GetFloatData(GetToken(Line, 17));
  //
  FLoadProc.ParamByName('pnational_roaming_internet').AsFloat := VAT * GetFloatData(GetToken(Line, 18));

  FLoadProc.ExecSQL;
end;

function TBeelineLoadBS_MO_Form.GetZoneName: String;
begin
  Result := '���������� �������';
end;


procedure TBeelineLoadCloseForm.DoAfterLoad;
var
  p: TOraStoredProc;
begin
   if countclosecontract>0 then begin
     bitbtn2.Caption:='������� '+inttostr(countclosecontract)+' ����������';
     bitbtn2.Visible:=true;
//     GroupBox1.Visible:=true;
//     Label1.Visible:=true;
   end;

end;

procedure TBeelineLoadCloseForm.DoBeforeLoad;

begin
  countclosecontract:=0;
end;

procedure TBeelineLoadCloseForm.DoLoad(var Line: String);
var qAddAbonent,qTariffs:TORaQuery;
vStringList : TStringList;
  p: TOraStoredProc;
  summ : real;
begin

if length(GetToken(Line,1))=10 then begin
  qTariffs:=ToRaQuery.Create(Self);
  qTariffs.SQL.Text :='select vc.CONTRACT_ID,vc.CONTRACT_DATE,vc.CONTRACT_CHANGE_DATE,vc.CONTRACT_CANCEL_DATE,'+#13#10+
' nvl(dla.system_block,0) as system_block,nvl(dla.conservation,0) as conservation,nvl(dla.phone_is_active,0) as phone_is_active'+#13#10+
' from v_contracts vc, db_loader_account_phones dla'+#13#10+
' where dla.phone_number=vc.PHONE_NUMBER_FEDERAL'+#13#10+
' and dla.year_month=(select max(dla1.year_month) from db_loader_account_phones dla1'+#13#10+
' where dla1.phone_number=vc.PHONE_NUMBER_FEDERAL)'+#13#10+
' and vc.CONTRACT_DATE=(select max(vc1.CONTRACT_DATE) from v_contracts vc1'+#13#10+
' where vc1.PHONE_NUMBER_FEDERAL=vc.PHONE_NUMBER_FEDERAL)'+#13#10+
' and vc.PHONE_NUMBER_FEDERAL=:phone_num';
  qTariffs.ParamByName('PHONE_NUM').AsString:= GetToken(Line,1);
  qTariffs.ExecSQL;
  if qTariffs.FieldByName('CONTRACT_DATE').IsNull then
    Line:=Line+#9+'������! ����� �� ������!'
  else if qTariffs.FieldByName('PHONE_IS_ACTIVE').AsInteger=1 then
    Line:=Line+#9+'����� �������.'
      else if qTariffs.FieldByName('SYSTEM_BLOCK').AsInteger=1 then
      begin
        Line:=Line+#9+'����� ���������� �� ������������.'+#9+qTariffs.FieldByName('CONTRACT_DATE').AsString
        +#9+qTariffs.FieldByName('CONTRACT_CHANGE_DATE').AsString
        +#9+qTariffs.FieldByName('CONTRACT_ID').AsString;
        inc(countclosecontract);
      end
      else if not qTariffs.FieldByName('CONTRACT_CANCEL_DATE').IsNull then
        Line:=Line+#9+'�������� ��� ����������'
      else if qTariffs.FieldByName('CONSERVATION').AsInteger=1 then  begin
        Line:=Line+#9+'����� �� ����������.'+#9+qTariffs.FieldByName('CONTRACT_DATE').AsString
        +#9+qTariffs.FieldByName('CONTRACT_CHANGE_DATE').AsString
        +#9+qTariffs.FieldByName('CONTRACT_ID').AsString;
        inc(countclosecontract);
      end;
  FreeAndNil(qTariffs);
end
else Line:='';
end;

function TBeelineLoadCloseForm.GetFormCaption: String;
begin
  Result := '����������� ����������';
end;

function TBeelineLoadCloseForm.GetHeaderLine: String;
begin
  Result := '�����	���� �����������	�������	���������� �� ������� �����	����������� ������� �����';
end;

function TBeelineLoadCloseForm.IsSelectPeriodEnabled: Boolean;
begin
  Result := False;
end;

function TBeelineLoadCloseForm.IsSelectAccountEnabled: Boolean;
begin
  Result := False;
end;

procedure TBeelineLoadForm.BitBtn2Click(Sender: TObject);
  var vIsError : boolean;
   vStringList:tstringlist;
   i, ContractCancelTypeId:integer;
   s, pErrorMessage:string;
   qCancelTypes: TOraQuery;
begin
Screen.Cursor := crSQLWait;
  try
    MainForm.OraSession.StartTransaction;
    pProgress.Max := mData.Lines.Count-1;
    vStringList := TStringList.Create;
    LockWindowUpdate(mData.Handle);
    for i := 0 to mData.Lines.Count-1 do
    begin
      pProgress.Position := i;
      pProgress.Update;
      Application.ProcessMessages;
      s:=mData.Lines[i];
      if (s<>'') then  begin
       if ((GetToken(s, 6)='����� �� ����������.') or (GetToken(s, 6)='����� ���������� �� ������������.')) then  begin
        qContractCancel.Close;
        qContractCancel.ParamByName('CONTRACT_CANCEL_ID').Value := Null;
        qContractCancel.Open;
        qContractCancel.Insert;
        qContractCancel.FieldByName('CONTRACT_ID').Value := GetToken(s, 9);
        vIsError:=false;
        if GetToken(s, 2) = '' then
          begin
          vIsError := True;
          pErrorMessage := '���� ����������� �������� ������ ���� ���������';
          end
        else if strtodate(GetToken(s, 7)) > strtodate(GetToken(s, 2)) then
              begin
                vIsError := True;
                pErrorMessage := '���� ����������� �������� ������ ���� ������ ���� ���������� �������� ' + GetToken(s, 7);
              end
            else if ( GetToken(s, 8)<>'' ) and ( strtodate(GetToken(s, 8)) > strtodate(GetToken(s, 2)) ) then
              begin
                vIsError := True;
                pErrorMessage := '���� ����������� �������� �� ������ ���� ������ ���� ���������� ��������� �������� ' + GetToken(s, 8);
              end;
            //����� ������� �����������
        if (not vIsError) then
          Try
            qCancelTypes:=TOraQuery.Create(self);
            qCancelTypes.SQL.Text:='SELECT * FROM contract_cancel_types WHERE contract_cancel_type_name = :contract_cancel_type_name';
            qCancelTypes.ParamByName('contract_cancel_type_name').AsString:=GetToken(s, 3);
            qCancelTypes.Open;
            if qCancelTypes.RecordCount = 1 then
              ContractCancelTypeId:=qCancelTypes.FieldByName('contract_cancel_type_id').AsInteger
            else if qCancelTypes.RecordCount > 1 then
                 begin
                  vIsError := True;
                  pErrorMessage := '������� ��������� ������� � ������� ������ �����������';
                 end
                 else
                 begin
                  vIsError := True;
                  pErrorMessage := '������� ����������� ����������� � �������';
                 end;
           Finally
            qCancelTypes.Close;
            FreeAndNil(qCancelTypes);
          End;

        if (not vIsError) then begin
          try
            qContractCancel.FieldByName('FILIAL_ID').value:= 182;
            qGetNewId.ExecSQL;
            qContractCancel.FieldByName('CONTRACT_CANCEL_ID').AsInteger := qGetNewId.ParamByName('RESULT').AsInteger;
            qContractCancel.FieldByName('CONTRACT_CANCEL_DATE').AsDateTime := strtodate(GetToken(s, 2));
            if (GetToken(s, 4)<>'') and (GetToken(s, 4)<>'0') then
              qContractCancel.FieldByName('SUM_GET').AsInteger := StrToInt(GetToken(s, 4));
            if (GetToken(s, 5)<>'') and (GetToken(s, 5)<>'0') then
              qContractCancel.FieldByName('SUM_PUT').AsInteger := StrToInt(GetToken(s, 5));
            qContractCancel.FieldByName('CONTRACT_CANCEL_TYPE_ID').AsInteger := ContractCancelTypeId;
            qContractCancel.Post;
            s:=s+#9+'������� ����������.';
          except
            on e : exception do
            s:=s+#9+'���������� ��������� ��������� ����������� ��������. '+ e.Message;
          end;
        end
        else s:=s+#9+pErrorMessage;
       end
       else s:=s+#9+'��������.';
       vStringList.Add(s);
      end;
    end;
    mData.Lines:=vStringList;
    vStringList.Free;
    LockWindowUpdate(0);
    MainForm.OraSession.Commit;
    qContractCancel.Close;
    Screen.Cursor := crDefault;
    bitbtn2.Visible:=false;
//    Label1.Visible:=false;
    ShowMessage('����������� ���������!');
  except
    Screen.Cursor := crDefault;
    MainForm.OraSession.Rollback;
    Raise;
  end;

end;

{ TBeelineLoadDopPhoneInfo }

procedure TBeelineLoadDopPhoneInfo.DoAfterLoad;
begin

end;

procedure TBeelineLoadDopPhoneInfo.DoBeforeLoad;
  var qAddDopInfo:ToRaQuery;
begin
  qAddDopInfo:=ToRaQuery.Create(self);
  try
  //vLoadInstallment:=true;
   //qAddDopInfo.SQL.Text :='truncate table PHONES_DOP';
   qAddDopInfo.SQL.Text :='delete PHONES_DOP';

   qAddDopInfo.ExecSQL;
   FreeAndNil(qAddDopInfo);
  except
    on e : exception do
    MessageDlg('������ ������� ������� PHONES_DOP'#13#10+e.Message, mtError, [mbOK], 0);
  end;

   FreeAndNil(FLoadProc);
end;

procedure TBeelineLoadDopPhoneInfo.DoLoad(var Line: String);
  var qAddDopInfo:ToRaQuery;
begin
  qAddDopInfo:=ToRaQuery.Create(self);
  try
  //vLoadInstallment:=true;
    if GetConstantValue('SERVER_NAME')='CORP_MOBILE' then begin
      qAddDopInfo.SQL.Text :='INSERT INTO PHONES_DOP (BAN, DATE_CTN, DATETIME_SIM,HLR, NAME_BAN, PHONE_NUMBER,PHONE_NUMBER_TYPE, REASON, SIM, STATE, TP)'+#13+#10+
                          ' VALUES ( :BAN,:DATE_CTN,:DATETIME_SIM,:HLR,:NAME_BAN,:PHONE_NUMBER,:PHONE_NUMBER_TYPE,:REASON,:SIM,:STATE,:TP )';
      qAddDopInfo.ParamByName('PHONE_NUMBER').AsString  := GetToken(Line, 1,#59);
      qAddDopInfo.ParamByName('HLR').AsString  := GetToken(Line, 2,#59);
      if GetToken(Line, 3,#59)='�����������' then
       qAddDopInfo.ParamByName('PHONE_NUMBER_TYPE').AsInteger  := 0
      else
       qAddDopInfo.ParamByName('PHONE_NUMBER_TYPE').AsInteger  := 1;
      qAddDopInfo.ParamByName('BAN').AsString  := GetToken(Line, 4,#59);
      qAddDopInfo.ParamByName('STATE').AsString  := GetToken(Line, 5,#59);
      qAddDopInfo.ParamByName('REASON').AsString  := GetToken(Line, 6,#59);
      qAddDopInfo.ParamByName('DATE_CTN').AsDate  :=EncodeDate(
            StrToInt(Copy(GetToken(Line, 7,#59), 7, 4)),
            StrToInt(Copy(GetToken(Line, 7,#59), 4, 2)),
            StrToInt(Copy(GetToken(Line, 7,#59), 1, 2))
            );
      qAddDopInfo.ParamByName('TP').AsString  := GetToken(Line, 8,#59);
      qAddDopInfo.ParamByName('SIM').AsString  := GetToken(Line, 9,#59);
      qAddDopInfo.ParamByName('NAME_BAN').AsString  := GetToken(Line, 10,#59);
      qAddDopInfo.ParamByName('DATETIME_SIM').AsDate  :=EncodeDate(
            StrToInt(Copy(GetToken(Line, 11,#59), 7, 4)),
            StrToInt(Copy(GetToken(Line, 11,#59), 4, 2)),
            StrToInt(Copy(GetToken(Line, 11,#59), 1, 2))
            );
    end;
    if GetConstantValue('SERVER_NAME')='GSM_CORP' then begin
      qAddDopInfo.SQL.Text :='INSERT INTO PHONES_DOP (BAN, DATE_CTN, HLR, NAME_BAN, PHONE_NUMBER,PHONE_NUMBER_TYPE, REASON, SIM, STATE, TP)'+#13+#10+
                          ' VALUES ( :BAN,:DATE_CTN, :HLR,:NAME_BAN,:PHONE_NUMBER,:PHONE_NUMBER_TYPE,:REASON,:SIM,:STATE,:TP )';
      qAddDopInfo.ParamByName('PHONE_NUMBER').AsString  := GetToken(Line, 1,#59);
      qAddDopInfo.ParamByName('HLR').AsString  := GetToken(Line, 2,#59);
      qAddDopInfo.ParamByName('BAN').AsString  := GetToken(Line, 3,#59);
      qAddDopInfo.ParamByName('NAME_BAN').AsString  := GetToken(Line, 4,#59);
      qAddDopInfo.ParamByName('DATE_CTN').AsDate  :=EncodeDate(
            StrToInt(Copy(GetToken(Line, 5,#59), 7, 4)),
            StrToInt(Copy(GetToken(Line, 5,#59), 4, 2)),
            StrToInt(Copy(GetToken(Line, 5,#59), 1, 2))
            );
      qAddDopInfo.ParamByName('TP').AsString  := GetToken(Line, 6,#59);
      qAddDopInfo.ParamByName('SIM').AsString  := GetToken(Line, 7,#59);
    end;

{        if ( GetToken(Line, 14) <> '' )and
           ( GetConstantValue('LOAD_FIO_WHEN_LOAD_CONTRACTS')='1' ) then
          qAddDopInfo.ParamByName('SURNAME').AsString := GetToken(Line, 14)
        else
          qAddDopInfo.ParamByName('SURNAME').AsString := copy(GetToken(Line, 4),2,10);
          }
        qAddDopInfo.ExecSQL;
        FreeAndNil(qAddDopInfo);
  except
    on e : exception do
    Line:='������ '+e.Message+#9+Line;
    //      MessageDlg('������ ��� ���������� �������� "'+copy(GetToken(Line, 4),2,10)+'".'#13#10+, mtError, [mbOK], 0);
  end;

end;

function TBeelineLoadDopPhoneInfo.GetFormCaption: String;
begin
  Result := '�������� ���. ���������� �� �������';
end;

function TBeelineLoadDopPhoneInfo.GetHeaderLine: String;
begin
 if GetConstantValue('SERVER_NAME')='CORP_MOBILE' then
  Result := '������������� �����;HLR;���/���;��� ������� (BAN);������ ������;������� ����� �������;���� ������� CTN;��;���;�������� BAN;���� ��������� ���'
 else
  if GetConstantValue('SERVER_NAME')='GSM_CORP' then
   Result := '������������� �����;HLR;��� ������� (BAN);�������� BAN;���� ������� CTN;��� �������� �������-����� (��������� �����);�������� �����';
end;

function TBeelineLoadDopPhoneInfo.IsSelectAccountEnabled: Boolean;
begin
  Result := False;
end;

function TBeelineLoadDopPhoneInfo.IsSelectPeriodEnabled: Boolean;
begin
  Result := False;
end;



{ TBeelineLoaderSettings }

procedure TBeelineLoaderSettings.DoAfterLoad;
var
  p: TOraStoredProc;
begin
  p := MakeStoredProcedure('loader_call_pckg_n.post_collector_acc');
  try
    p.ExecSQL;
  finally
    FreeAndNil(p);
  end;
  FreeAndNil(FLoadProc);

end;

procedure TBeelineLoaderSettings.DoBeforeLoad;
var
  p: TOraStoredProc;
begin
  p := MakeStoredProcedure('loader_call_pckg_n.pre_collector_acc');
  try
    p.ExecSQL;
  finally
    FreeAndNil(p);
  end;
end;

procedure TBeelineLoaderSettings.DoLoad(var Line: String);
var
  PhoneNumber: string;
  StatusFlag: Integer;
  CellPlanDateStr: string;
begin
  PhoneNumber := Trim(GetToken(Line, 0));
  if (PhoneNumber <> '') and CharInSet(PhoneNumber[1], ['0'..'9']) then
  begin
    if FLoadProc = nil then
    begin
      FLoadProc := MakeStoredProcedure('loader_call_pckg_n.load_collector_acc');
       FLoadProc.ParamByName('paccount_id').AsInteger :=integer(lbAccount.Items.Objects[lbAccount.ItemIndex]);
    end;

    FLoadProc.ParamByName('pphone_number').AsString := PhoneNumber;
    FLoadProc.ParamByName('pban').AsInteger :=StrToInt64( Trim(GetToken(Line, 2)));
    //
    FLoadProc.ExecSQL;
  end;

end;

function TBeelineLoaderSettings.GetFormCaption: String;
begin
 Result:='�������� ����������� ������ ������������� ���������'
end;

function TBeelineLoaderSettings.GetHeaderLine: String;
begin
result:='������������� �����	��� ������� (BAN)	������� ����� �������	������ �������������� ������	���� ������� CTN	��� �������� �������-����� (��������� �����)';
end;

{ TBeelineCollectorStatesForm }

procedure TBeelineCollectorStatesForm.DoAfterLoad;
begin

end;

procedure TBeelineCollectorStatesForm.DoBeforeLoad;
begin

end;

procedure TBeelineCollectorStatesForm.DoLoad(var Line: String);
var
  PhoneNumber: string;
//  StatusFlag: Integer;
//  CellPlanDateStr: string;
begin
  PhoneNumber := Trim(GetToken(Line, 1));
  if (PhoneNumber <> '') and CharInSet(PhoneNumber[1], ['0'..'9']) then
  begin
    if FLoadProc = nil then
    begin
      FLoadProc := MakeStoredProcedure('loader_call_pckg_n.update_collector_state');
      FLoadProc.ParamByName('Paccount_id').AsInteger := integer(lbAccount.Items.Objects[lbAccount.ItemIndex]);
    end;
    FLoadProc.ParamByName('Pphone_number').AsString := PhoneNumber;
    FLoadProc.ParamByName('Pstate').AsString := Trim(GetToken(Line, 4));
    FLoadProc.ParamByName('Pplan_code').AsString := Trim(GetToken(Line, 6));
    FLoadProc.ParamByName('Pvalid_state').AsString := Trim(GetToken(Line, 3));
    //
//    CellPlanDateStr := Trim(GetToken(Line, 5));
//    if Length(CellPlanDateStr) = 10 then
//      FLoadProc.ParamByName('pNEW_CELL_PLAN_DATE').AsDateTime := EncodeDate(
//        StrToInt(Copy(CellPlanDateStr, 7, 4)),
//        StrToInt(Copy(CellPlanDateStr, 4, 2)),
//        StrToInt(Copy(CellPlanDateStr, 1, 2))
//        )
//    else
//      FLoadProc.ParamByName('pNEW_CELL_PLAN_DATE').Clear;
//    //
//    FLoadProc.ParamByName('pORGANIZATION_ID').Clear;
//    FLoadProc.ParamByName('pNEED_RESET_OPTIONS').Clear;
    FLoadProc.ExecSQL;
  end;

end;

function TBeelineCollectorStatesForm.GetFormCaption: String;
begin
   Result:='�������� �������� ������������� ���������'
end;

function TBeelineCollectorStatesForm.GetHeaderLine: String;
begin
result:='������������� �����	��� ������� (BAN)	������� ����� �������	������ �������������� ������	���� ������� CTN	��� �������� �������-����� (��������� �����)';
end;

end.
