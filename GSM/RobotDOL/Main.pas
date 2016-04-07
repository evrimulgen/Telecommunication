unit Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Grids, Vcl.DBGrids, CRGrid,
  Vcl.StdCtrls, Vcl.Buttons, Vcl.Menus, Vcl.ExtCtrls, ComObj, Data.DB, MemDS,
  VirtualTable, ACTIVEX, IdIOHandler, IdIOHandlerSocket, IdIOHandlerStack,
  IdSSL, IdSSLOpenSSL, IdBaseComponent, IdComponent, IdTCPConnection,
  IdTCPClient, IdHTTP, DOLBeline, Soap.InvokeRegistry, Soap.Rio,
  SOAPHTTPClient, Soap.SOAPHTTPTrans, XSBuiltIns, Data.Win.ADODB
    ,FlexCel.XlsAdapter,VCL.FlexCel.Core, BufStr, frxClass, FlexCel.Report
    ,Vcl.FileCtrl, ShellAPI, IniFiles;

type
  TMainFrm = class(TForm)
    p1: TPanel;
    pMainPanel: TPanel;
    dlgOpen1: TOpenDialog;
    qData: TVirtualTable;
    ds1: TDataSource;
    grp1: TGroupBox;
    grdLoadedContractList: TCRDBGrid;
    qSendedContract: TVirtualTable;
    ds2: TDataSource;
    IdHTTP1: TIdHTTP;
    IdSSLIOHandlerSocketOpenSSL1: TIdSSLIOHandlerSocketOpenSSL;
    b1: TBitBtn;
    HTTPRIO1: THTTPRIO;
    HTTPReqResp1: THTTPReqResp;
    con1: TADOConnection;
    qryInsertContract: TADOQuery;
    qDeleteContract: TADOQuery;
    qryGetContractID: TADOQuery;
    qryInserCustomer_INFO: TADOQuery;
    qryInsertDeleveryAddres: TADOQuery;
    qryInsertConnection: TADOQuery;
    qryInsertLOGPARAMS: TADOQuery;
    qryGetIMSI: TADOQuery;
    qryGetConnectionID: TADOQuery;
    qryInsertMobile: TADOQuery;
    qryInsertServices: TADOQuery;
    qryGetTP_Services: TADOQuery;
    qryGetMobilesID: TADOQuery;
    qDelete�ustomerInfo: TADOQuery;
    qDeleteDeleveryAddres: TADOQuery;
    qDeleteConnection: TADOQuery;
    qDeleteLOGPARAMS: TADOQuery;
    qDeleteMobile: TADOQuery;
    qDeleteServices: TADOQuery;
    p2: TPanel;
    btLoadExcel: TBitBtn;
    bSendContracts: TBitBtn;
    grp2: TGroupBox;
    lbl1: TLabel;
    lbl2: TLabel;
    lblLoadedDOL: TLabel;
    lblLoadedContract: TLabel;
    lbl4: TLabel;
    lblERROR_COUNT: TLabel;
    qDataERROR_TEXT: TStringField;
    qDataCONTRACT_NUM: TStringField;
    qDataCONTRACT_DAY: TStringField;
    qDataCONTRACT_MONTH: TStringField;
    qDataCONTRACT_YEAR: TStringField;
    qDataPERSON_SEX: TStringField;
    qDataPERSON_SURNAME: TStringField;
    qDataPERSON_NAME: TStringField;
    qDataPERSON_PATRONYMIC: TStringField;
    qDataDOCUM_SER: TStringField;
    qDataDOCUM_NUM: TStringField;
    qDataDOCUM_ISSUE: TStringField;
    qDataISSUE_DAY: TStringField;
    qDataISSUE_MONTH: TStringField;
    qDataISSUE_YEAR: TStringField;
    qDataBIRTH_DAY: TStringField;
    qDataBIRTH_MONTH: TStringField;
    qDataBIRTH_YEAR: TStringField;
    qDataCITY: TStringField;
    qDataSTREET_TYPE: TStringField;
    qDataSTREET_NAME: TStringField;
    qDataHOUSE: TStringField;
    qDataAPPARTMENT: TStringField;
    qDataPHONEINFO_PREFIX: TStringField;
    qDataPHONEINFO_NUMBER: TStringField;
    qDataPHONEINFO_FULL_NUMBER: TStringField;
    btnPrintContract: TBitBtn;
    qryPrintContracts: TADOQuery;
    qryServicesList: TADOQuery;
    grp3: TGroupBox;
    rb1: TRadioButton;
    rb2: TRadioButton;
    lbl3: TLabel;
    edt2: TEdit;
    edt3: TEdit;
    edt4: TEdit;
    lbl5: TLabel;
    qryContractListInterval: TADOQuery;
    qGetDocTypeID: TADOQuery;
    qDataDOCUM_NAME: TStringField;
    procedure btLoadExcelClick(Sender: TObject);
    function DoLoadDataFromExcel(const pFileName: String) : boolean;
    function DoOpenFile(const pFileName : String) : boolean;
    procedure DoLoadDataFromText(const pStr: String);
    procedure FillColumnNames(const pStr : String);
    function CheckNecessaryFields(var pErrorMessage : String) : boolean;
    function AddRowFromStr(const pStr : String) : boolean;
    function CurrentRowEmpty : boolean;
    procedure bSendContractsClick(Sender: TObject);
    procedure DoSendContracts;
    procedure DoLoadContractToDOL;
    procedure b1Click(Sender: TObject);
    function IdSSLIOHandlerSocketOpenSSL1VerifyPeer(Certificate: TIdX509;
      AOk: Boolean; ADepth, AError: Integer): Boolean;
    procedure HTTPRIO1AfterExecute(const MethodName: string;
      SOAPResponse: TStream);
    procedure HTTPRIO1HTTPWebNode1BeforePost(const HTTPReqResp: THTTPReqResp;
      Data: Pointer);
    procedure HTTPRIO1BeforeExecute(const MethodName: string;
      SOAPRequest: TStream);
    procedure Excel2TSV(const InStream: TStream;
                        //OutTexts: TPreProcessorResult;
                        OutTexts : TStringList;
                        const FileName : string;
                      //  const LoadingLog : IMTLoadingLog;
                        IsExcelFile : boolean = false
                        );
    procedure btnPrintContractClick(Sender: TObject);
    procedure edt3KeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);

  private
    procedure SetFieldTable;
    { Private declarations }
  public
    procedure PrintDOLContract(const pCODE : string; const pPrintDir : string);
    procedure ReadIniParams(var l_links_name, L_BILLPLANS_name
                          //, l_links_history:
                          :String);
    { Public declarations }
  end;

// ������ ������� �� ������������
{
'<?xml version="1.0" encoding="utf-8"?>'
+'<soap12:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap12="http://www.w3.org/2003/05/soap-envelope">'
 + '<soap12:Body>'
 +   '<ContractImport xmlns="http://beeline.ru/ws/dol/2006">'
 +     '<CONTRACT Status="' + pCONTRACT_STATUS + '" Code="' + pCONTRACT_CODE + '" DateCreate="' + pCONTRACT_DATECREATE + '" Comments="' + pCONTRACT_COMMENTS + '" ClientVer="' + pCONTRACT_CLIENTVER + '">'
 +       '<DEALER Code="' + pDEALER_CODE + '" PointCode="pDEALER_POINTCODE" />'
 +       '<ABS Code="' + pABS_CODE + '" Date="' + pABS_DATE + '" />'
 +       '<CUSTOMER SpheresId="' + pCUSTOMER_SPHERESID + '" Resident="' + pCUSTOMER_RESIDENT + '" Ratepayer="' + pCUSTOMER_RATEPAYER + '">'
 +         '<BANKPROPLIST>'
 +           '<BANKPROPSPRIM xsi:nil="true" />'
 +           '<BANKPROPSSEC xsi:nil="true" />'
 +           '<BANKPROPSSEC xsi:nil="true" />'
 +         '</BANKPROPLIST>'
 +         '<ADDRESS>'
 +           '<ZIP>' + pADDRESS_ZIP + '</ZIP>'
 +           '<COUNTRY>' + pADDRESS_COUNTRY + '</COUNTRY>'
 +           '<REGION>' + pADDRESS_REGION + '</REGION>'
 +           '<AREA>' + pADDRESS_AREA + '</AREA>'
 +           '<PLACE xsi:nil="true" />'
 +           '<STREET xsi:nil="true" />'
 +           '<HOUSE>' + pADDRESS_HOUSE + '</HOUSE>'
 +           '<BUILDING xsi:nil="true" />'
 +           '<ROOM xsi:nil="true" />'
 +         '</ADDRESS>'
 +       '</CUSTOMER>'
 +       '<CONTACT SexTypesId="' + pCONTACT_SEXTYPESID + '" EMail="string" Notes="string">'
 +         '<NAME>' + pCONTACT_NAME + '</NAME>'
 +         '<PHONE Prefix="' + pCONTACT_PHONE_PREFIX + '" Number="' + pCONTACT_PHONE_NUMBER + '" />'
 +         '<FAX Prefix="' + pCONTACT_FAX_PREFIX + '" Number="' + pCONTACT_FAX_NUMBER + '" />' // ����� ������
 +       '</CONTACT>'
 +       '<CONNECTIONS BillCyclesId="int" PaySystemsId="Prepaid">'
 +         '<CONNECTIONS ProductsId="int" PhoneOwner="int" IMSI="string" SimLock="int" SerNumber="string" CellNetsId="int">' //���� CONNECTIONS ������
 +           '<MOBILES xsi:nil="true" />'
 +         '</CONNECTIONS>'
 +         '<CONNECTIONS ProductsId="int" PhoneOwner="int" IMSI="string" SimLock="int" SerNumber="string" CellNetsId="int">'
 +           '<MOBILES xsi:nil="true" />'
 +         '</CONNECTIONS>'
 +       '</CONNECTIONS>'
 +       '<LOGPARAMS>' //�������������� ����
 +         '<LOGPARAM Comments="string" Value="boolean" />'
 +         '<LOGPARAM Comments="string" Value="boolean" />'
 +       '</LOGPARAMS>'
 +     '</CONTRACT>'
 +   '</ContractImport>'
 + '</soap12:Body>' +
 '</soap12:Envelope>';
}


const
vColumnCount = 26;
aColumnNames : array[1..vColumnCount] of String = (
  '��� ��������',
  '�����',
  '�����',
  '���',
  '���',
  '�������',
  '���',
  '��������',
  '��� ���������',
  '�����',
  '�����',
  '�����',
  '����� ������',
  '����� ������',
  '��� ������',
  '����� ��������',
  '����� ��������',
  '��� ��������',
  '�����',
  '�����',
  '�������� �����',
  '���',
  '��������',
  '������� �����������',
  '����� �����������',
  '����� ��������'
);

 // ����� ����� ������ ����� ��������� � �������� aColumnNames
  aFieldNames : array[1..vColumnCount] of String = (
  'CONTRACT_NUM',
  'CONTRACT_DAY',
  'CONTRACT_MONTH',
  'CONTRACT_YEAR',
  'PERSON_SEX',
  'PERSON_SURNAME',
  'PERSON_NAME',
  'PERSON_PATRONYMIC',
  'DOCUM_NAME',
  'DOCUM_SER',
  'DOCUM_NUM',
  'DOCUM_ISSUE',
  'ISSUE_DAY',
  'ISSUE_MONTH',
  'ISSUE_YEAR',
  'BIRTH_DAY',
  'BIRTH_MONTH',
  'BIRTH_YEAR',
  'CITY',
  'STREET_TYPE',
  'STREET_NAME',
  'HOUSE',
  'APPARTMENT',
  'PHONEINFO_PREFIX',
  'PHONEINFO_NUMBER',
  'PHONEINFO_FULL_NUMBER'
 );

  // ����, ������� ����������� ������ ���� � ����������� �����
  aNecessaryFieldsCount = 26;
  aNecessaryFields : array[1..aNecessaryFieldsCount] of String = (
  'CONTRACT_NUM',
  'CONTRACT_DAY',
  'CONTRACT_MONTH',
  'CONTRACT_YEAR',
  'PERSON_SEX',
  'PERSON_SURNAME',
  'PERSON_NAME',
  'PERSON_PATRONYMIC',
  'DOCUM_NAME',
  'DOCUM_SER',
  'DOCUM_NUM',
  'DOCUM_ISSUE',
  'ISSUE_DAY',
  'ISSUE_MONTH',
  'ISSUE_YEAR',
  'BIRTH_DAY',
  'BIRTH_MONTH',
  'BIRTH_YEAR',
  'CITY',
  'STREET_TYPE',
  'STREET_NAME',
  'HOUSE',
  'APPARTMENT',
  'PHONEINFO_PREFIX',
  'PHONEINFO_NUMBER',
  'PHONEINFO_FULL_NUMBER');

var
  MainFrm: TMainFrm;
  aColumnNumbers : array[1..vColumnCount] of Integer;
  FReadData : Boolean;

implementation

{$R *.dfm}

procedure TMainFrm.SetFieldTable;
var
  i : Integer;
begin
  i := 0;
  while i < qData.FieldCount do
  begin
     inc(i)//qSendedContract.FieldDefs.Assign(qData.FieldDefs);
  end;
  qSendedContract.FieldDefs.Assign(qData.FieldDefs);
end;

procedure TMainFrm.b1Click(Sender: TObject);

  function GetStretType(const pStretTypeName : string) : Integer;
  var
    vStretType : array [1..11] of string;
    type_ : Integer;
{ ���������� ����������� �� �������
    <RowIdNameShortName ShortName="��." Name="�����" Id="1"/>
    <RowIdNameShortName ShortName="��-�" Name="��������" Id="2"/>
    <RowIdNameShortName ShortName="���." Name="��������" Id="3"/>
    <RowIdNameShortName ShortName="�." Name="�����" Id="4"/>
    <RowIdNameShortName ShortName="���." Name="�����" Id="5"/>
    <RowIdNameShortName ShortName="��-�" Name="������" Id="6"/>
    <RowIdNameShortName ShortName="��." Name="�������" Id="7"/>
    <RowIdNameShortName ShortName="�-�" Name="�������" Id="8"/>
    <RowIdNameShortName ShortName="���." Name="����������" Id="9"/>
    <RowIdNameShortName ShortName="��-�" Name="�������" Id="10"/>
    <RowIdNameShortName ShortName="���." Name="�����" Id="11"/>
}
  begin
    Result := 0;  // ������ �� �����
    vStretType[1] := '�����';
    vStretType[2] := '��������';
    vStretType[3] := '��������';
    vStretType[4] := '�����';
    vStretType[5] := '�����';
    vStretType[6] := '������';
    vStretType[7] := '�������';
    vStretType[8] := '�������';
    vStretType[9] := '����������';
    vStretType[10] := '�������';
    vStretType[11] := '�����';
    for type_ := 1 to 11 do
      if vStretType[type_] = pStretTypeName then
        Result := type_;
  end;

var
  vHEAD : string;
  vSOAP_TEXT : string;
  vResp : TStream;
  Otvet : string;
  S : TStringList;
  str : TStringStream;
  i : integer;
  vPing : Ping;
  vContractImport : ContractImport;
  vContract : Contract;
  vDATE_CRETED : TXSDateTime;
  vDEALER : ContractDealerInfo;
  vCustomer : ContractCustomer;
  vPERSON : PersonInfo;
  vName : Name_;
  vADRESSES : AddressInfo;
  vPLACE : AddressPlace;
  vSTREET : AddressStreet;
  vAddressBuilding : AddressBuilding;
  vROOM : AddressRoom;
  vDELIVERYEMAIL : ContractDeliveryEmail;
  vConnection : Connection;
  vArray_Of_Connection : Array_Of_Connection;
  vContractConnection : ContractConnections;
  vSOAP_CLIENT : THTTPRIO;
  vMOBILES : Mobile;
begin
{ ����������� ����� Indy
    S := TStringList.Create;
    s.Add('<?xml version="1.0" encoding="utf-8"?>'
          +'<soap12:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap12="http://www.w3.org/2003/05/soap-envelope">'
          +'  <soap12:Body>'
          +'    <Ping xmlns="http://beeline.ru/ws/dol/2006" />'
          +'  </soap12:Body>'
          +'</soap12:Envelope>');

    str := TStringStream.Create;
//    str.Encoding := TEncoding.UTF8;
    s.SaveToStream(str, TEncoding.UTF8);
//    str.WriteString(s.Text);
    //str.Position := 3;

    IdHTTP1.Request.CustomHeaders.Clear;
    IdHTTP1.Request.Clear;
    IdHTTP1.Request.ContentType := 'application/soap+xml';
    IdHTTP1.Request.CharSet := '"utf-8"';
    IdHTTP1.Request.UserAgent := '';

    Otvet := IdHTTP1.Post('https://dealer.beeline.ru/dealer/WebService/DOL.asmx', str);
    edt1.Text :=  Otvet;
}
//  ShowMessage();
  {
  vSOAP_CLIENT := THTTPRIO.Create(self);
  vSOAP_CLIENT.HTTPWebNode.HandleWinInetError()
  with vSOAP_CLIENT.HTTPWebNode. do
  begin
    AllowCookies:= True;
    HandleRedirects:= False;
      IOHandler:= TIdSSLIOHandlerSocketOpenSSL.Create(SoapClient.HTTPWebNode.HttpClient);
    with TIdSSLIOHandlerSocketOpenSSL(IOHandler),SSLOptions do
    begin
      Method:= sslvSSLv3; // select SSL method
      CertFile:= 'C:\1\my2.pem'; // assign certificate
      KeyFile:= 'C:\1\my2.pem'; // assign private key
      RootCertFile:= 'C:\1\my2.pem';
      // select verification method for server certificate
      VerifyMode:= [sslvrfPeer, sslvrfFailIfNoPeerCert, sslvrfClientOnce];
      VerifyDepth:= 1;
      OnVerifyPeer:= IdSSLIOHandlerSocketOpenSSL1VerifyPeer;
    end;
  end;
  ;
  }

  //vPing := Ping.Create;
  //(HTTPRIO1 as DOLServiceSoap).Ping(vPing);
  vContractImport := ContractImport.Create;
  vContract := Contract.Create;
  vCONTRACT.Code := '300';
    vDATE_CRETED := TXSDateTime.Create;
    vDATE_CRETED.Year := qData.FieldByName('CONTRACT_YEAR').AsInteger;
    vDATE_CRETED.Month := qData.FieldByName('CONTRACT_MONTH').AsInteger;
    vDATE_CRETED.Day := qData.FieldByName('CONTRACT_DAY').AsInteger;
    vDATE_CRETED.Hour := 0;
    vDATE_CRETED.Minute := 0;
    vDATE_CRETED.Second := 0;
  vCONTRACT.DateCreate := vDATE_CRETED;
  // vContractImport.CONTRACT.Comments ;
  vCONTRACT.ClientVer := '1.1.1.1';

    // ��������� ������ ������
    vDEALER := ContractDealerInfo.Create;
    vDEALER.Code := '990';
    vDEALER.PointCode := '990013';
    vContract.DEALER := vDEALER;

    // ��������� ���� � ������� ��������
    vCustomer := ContractCustomer.Create;
      vPERSON := PersonInfo.Create;
      vPERSON.Type_ := 0; // ������� ����
      if Trim(qData.FieldByName('PERSON_SEX').AsString) = '�������' then
          vPERSON.SexTypesId := 0  // ������
      else
          vPERSON.SexTypesId := 1;

        // ��������� ���� � ������ ���������
        vName := Name_.Create;
        vName.First := Trim(qData.FieldByName('PERSON_NAME').AsString);
        vName.Last := Trim(qData.FieldByName('PERSON_SURNAME').AsString);
        vName.Second := Trim(qData.FieldByName('PERSON_PATRONYMIC').AsString);
        vPERSON.NAME_ := vName;
      vCustomer.PERSON := vPERSON;

      vADRESSES := AddressInfo.Create;

      vADRESSES.COUNTRY := '���������� ���������';
      // ��������� ���� �����
        vPLACE := AddressPlace.Create;
        vPLACE.Type_ := 1;
        vPLACE.Value := Trim(qData.FieldByName('CITY').AsString);
      vADRESSES.PLACE := vPLACE;
      // ��������� ���� �����
        vSTREET := AddressStreet.Create;
        vSTREET.Type_ := GetStretType(Trim(qData.FieldByName('STREET_TYPE').AsString));
        vSTREET.Value := Trim(qData.FieldByName('STREET_TYPE').AsString);
      vADRESSES.STREET := vSTREET;

      vADRESSES.HOUSE := Trim(qData.FieldByName('HOUSE').AsString);
        //  ��������� ���� building
        vAddressBuilding := AddressBuilding.Create;
        vAddressBuilding.Type_ := 1;
        vAddressBuilding.Value := '';
        vADRESSES.BUILDING := vAddressBuilding;

        vROOM := AddressRoom.Create;
        vROOM.Type_ := 1;
        vROOM.Value := qData.FieldByName('APPARTMENT').AsString;
      vADRESSES.ROOM := vROOM;

      vCustomer.ADDRESS := vADRESSES;

    vCustomer.SpheresId := -1; // <����� ������������> �� ��������� ��� ��� ����������� "12 - ������"
    vCustomer.Ratepayer := 1; //  <����������� ���> ��� � �������
    vCustomer.Resident_ := 1; //  <�������� ��> ��� � �������
    vContract.CUSTOMER := vCustomer;

    // ������ �� ���������
    vDELIVERYEMAIL := ContractDeliveryEmail.Create;
    //<DELIVERYEMAIL Notes="" Type="7"/>  ;
    vDELIVERYEMAIL.Notes :='';
    vDELIVERYEMAIL.Type_ := 7; // ��� � ������� ��� ������������ ������
    vContract.DELIVERYEMAIL := vDELIVERYEMAIL;

    // ����� ���������� �� ������������
    vContractConnection := ContractConnections.Create;
      // ���� �����������
      vConnection := Connection.Create;
      vConnection.ProductsId := -1;
      vConnection.PhoneOwner := 1;
      vConnection.IMSI := '';
      vConnection.SimLock := 0;
      vConnection.SerNumber := '';
      vConnection.CellNetsId := 2;
        vMOBILES := Mobile.Create;
        vMOBILES.ChannelTypesId := 1;
        vMOBILES.ChannelLensId := 0;
        vMOBILES.SNB := qData.FieldByName('PHONEINFO_PREFIX').AsString + qData.FieldByName('PHONEINFO_NUMBER').AsString;
        vMOBILES.BillPlansId := 3317;
        vMOBILES.BillPlanSclad := 0;
      vConnection.MOBILES := vMOBILES;

      SetLength(vArray_Of_Connection, 1);
      vArray_Of_Connection[0] := vConnection;

    vContractConnection.CONNECTIONS := vArray_Of_Connection;
    vContractConnection.BillCyclesId := 1; // ������
    vContractConnection.PaySystemsId := 3;
    //<MOBILES ChannelTypesId="1" ChannelLensId="0" SNB="9051121016" TransferSNB="9531100001" BillPlansId="4" Bill-PlanSclad="0">
    vContract.CONNECTIONS := vContractConnection;

  vContractImport.CONTRACT := vContract;
  //vContractImport.DataConext;
  s := TStringList.Create;


  //HTTPRIO1.HTTPWebNode.ClientCertificate.CertName;
  (HTTPRIO1 as DOLServiceSoap).ContractImport(vContractImport);
  //IdHTTP1.Post('http://dealer.beeline.ru/dealer/WebService/DOL.asmx',  );
//  edt1.Text := (HTTPRIO1 as DOLServiceSoap).Ping;
end;

procedure TMainFrm.bSendContractsClick(Sender: TObject);
begin
//  DoSendContracts;
  DoLoadContractToDOL;
  //  qry1.Parameters.ParamByName('pDATE_CREATED').Value := Date;
  //  qry1.ExecSQL;

end;


// ���������� ��� ������� l_links_<..> � l_links_history<..> . ��� �������� ����� ������� ����������
procedure TMainFrm.ReadIniParams(var l_links_name , L_BILLPLANS_name
                          //, l_links_history:
                          :String);
var
  Ini: TIniFile;
begin
  try
    try
      Ini := TIniFile.Create( ChangeFileExt( Application.ExeName, '.INI' ) ); // ParamStr(0)
    except on e: Exception  do
      MessageDlg('�� ������ ���� ' + ChangeFileExt( Application.ExeName, '.INI' ) + '! ' + E.Message, mtError, [mbOK], 0);
    end;

    try
      l_links_name := Ini.ReadString('TABLE', 'l_links_name', '');
      L_BILLPLANS_name := Ini.ReadString('TABLE', 'l_billplans_name', '');
      //l_links_history := Ini.ReadString('TABLE', 'l_links_history', '');
    finally
      Ini.Free;
    end;
  except
    on e : exception do// ������� ������
    begin
      l_links_name := '';
      L_BILLPLANS_name := '';
      //l_links_history := '';
      MessageDlg('��� ����������� ������� "������ ��": "l_links..", "L_BILLPLANS_name.."! ' + E.Message, mtError, [mbOK], 0);
    end;
  end;
end;

// ���������� ��� �������� �� ������
procedure TMainFrm.DoLoadContractToDOL;

  function GetStretType(const pStretTypeName : string) : Integer;
  var
    vStretType : array [1..11] of string;
    type_ : Integer;
{ ���������� ����������� �� �������
    <RowIdNameShortName ShortName="��." Name="�����" Id="1"/>
    <RowIdNameShortName ShortName="��-�" Name="��������" Id="2"/>
    <RowIdNameShortName ShortName="���." Name="��������" Id="3"/>
    <RowIdNameShortName ShortName="�." Name="�����" Id="4"/>
    <RowIdNameShortName ShortName="���." Name="�����" Id="5"/>
    <RowIdNameShortName ShortName="��-�" Name="������" Id="6"/>
    <RowIdNameShortName ShortName="��." Name="�������" Id="7"/>
    <RowIdNameShortName ShortName="�-�" Name="�������" Id="8"/>
    <RowIdNameShortName ShortName="���." Name="����������" Id="9"/>
    <RowIdNameShortName ShortName="��-�" Name="�������" Id="10"/>
    <RowIdNameShortName ShortName="���." Name="�����" Id="11"/>
}
  begin
    Result := 0;  // ������ �� �����
    vStretType[1] := '�����';
    vStretType[2] := '��������';
    vStretType[3] := '��������';
    vStretType[4] := '�����';
    vStretType[5] := '�����';
    vStretType[6] := '������';
    vStretType[7] := '�������';
    vStretType[8] := '�������';
    vStretType[9] := '����������';
    vStretType[10] := '�������';
    vStretType[11] := '�����';
    for type_ := 1 to 11 do
      if vStretType[type_] = pStretTypeName then
        Result := type_;
  end;

  procedure GetSimInfo(const pPHONE : string; var vIMSI : string; var vTARIFF_CODE : Integer);
  begin
    qryGetIMSI.Close;
    qryGetIMSI.Parameters.ParamByName('pPHONE').Value := pPHONE;
    qryGetIMSI.Open;
    vIMSI := Trim(qryGetIMSI.FieldByName('SerNum').AsString);
    vTARIFF_CODE := qryGetIMSI.FieldByName('tariff_code').AsInteger;
    qryGetIMSI.Close;
  end;

  // �� ������������ ������
  procedure WriteError(const pErrorText : string; var vErr_cnt : Integer); // ���������� ������� ���������� ������
  begin
    {qData.Edit;
    qData.FieldByName('ERROR_TEXT').Value := pErrorText;
    //qData.Post;
    Inc(vErr_cnt);
    }

  end;

  // �� ����������� L_DOCTYPES ���������� ��� ���������
  function GetDocumTypeID(const pDocumTypeName : string) : Integer;
  begin
    try
      qGetDocTypeID.Parameters.ParamByName('pDocTypeName').Value := pDocumTypeName;
      qGetDocTypeID.Open;
      if qGetDocTypeID.IsEmpty then
        Result := -1 // ������ �� �����
      else
        Result := qGetDocTypeID.FieldByName('ID').AsInteger;
      qGetDocTypeID.Close;
    except
      on e: Exception do
        MessageDlg('��� ����������� ���� ��������� �������� ������! ' + E.Message, mtInformation, [mbOK], 0);
    end;
  end;

var
  vERROR_MSG : string;
  pDATE_CREATED, pDocDate, pBirthday : string;//TDateTime;//string;//OleVariant;
  pDEALER_CODE, pPOINT_CODE : string;
  pCountry : string;
  pClientVersion, pContactFIO : string;
  pPaysystemsId, pBillcyclesId, pCustomerTypesId, pCustomerResident, pCustomerRatepayer, pCustomerSpheresId,
  pPlaceTypesId, pStreetTypesId, pBuildingTypesId, pRoomTypesId, pDeliveryTypesId, pContactSexTypesId,
  pAddOption, pIsTransferNumber, pCorpConnStartId, pCorpConnEndId, pDocTypesId :        integer;
  vCONTRACT_ID, pCellnetsId, pProductsId, pPhoneOwner, pSimLock : Integer;
  vCONECTION_ID , pMobilesID, pTARIFF_CODE: Integer;
  pIMSI  : string;
  vERR_CNT , // ������� ������
  vLOADED_CNT: Integer;       // ������� �����������
  err_list : TStringList;
  l_links_name , L_BILLPLANS_name: String ;// ������������ ������
begin
  try
    try
      vERR_CNT := 0;
      vLOADED_CNT := 0;
      // 1. �������� ������ �� �������
      pPOINT_CODE := '990013';
      pDEALER_CODE := '990';
      pClientVersion := '10.2.5.9';
      pPaysystemsId := 3;// ������� ������
      pBillcyclesId := -1;
      pCustomerTypesId := 0; // ��� ������� ����
      pCustomerResident := 1; //
      pCustomerRatepayer := 1; //
      pCustomerSpheresId := -1;
      pCountry := '���������� ���������';
      pPlaceTypesId := 1; // �����, ��� ����������� ������ (����� �����������/����������� �����)
      pBuildingTypesId := -1; //
      pRoomTypesId := 1; // ��������
      pDeliveryTypesId := 1; // �����, ��� ������� �������� ���������������
      pCorpConnStartId := -1;
      pCorpConnEndId := -1;

      pAddOption := 0;
      pIsTransferNumber := 0;
      err_list := TStringList.Create;

      ReadIniParams ( l_links_name , L_BILLPLANS_name );
      if ((l_links_name = '') or (L_BILLPLANS_name = '')) then
        begin
          MessageDlg('� ����� '+ ChangeFileExt( Application.ExeName, '.INI' ) + ' �� ������ ��� ��� ������: l_links_name, L_BILLPLANS_name! ', mtError, [mbOK], 0);
        end

      else
        begin
          qryGetIMSI.SQL.Text :=
            'Select l.SerNum, ' +
            ' (select b.id    ' +
            '    from ' + L_BILLPLANS_name + ' b ' +
            '   where b.code = l.SOC  ' +
            ' ) as tariff_code  ' +
            '  from ' + l_links_name + ' l ' +
            '  where l.snb = :pPHONE';
        end;

      qData.First;
      //qData.Last;
      //qData.Edit;
      while not qData.Eof do
      //if qdata.FieldByName('ERROR_TEXT').IsNull  then
      begin
        try
          // ��������� �������� � ������ ������
          err_list.Add('');

          // �������� ����� � �������� � ������ ������ ��������
          vERROR_MSG := '';
          vCONTRACT_ID := 0;
          pMobilesID := 0;
          pDocTypesId := -1; // �������� ��� ��������� ������� � ����������� ����������

          // ��������� ������� CONTRACTS. ���� ������ �� ���� �� ����� � ���� ��������� �� �������� ��������,
          // ����� �������� �� ��������� ������ � ����� ��������� �� ������.
          pDATE_CREATED := FormatDateTime( 'dd.mm.yyyy hh:mm:ss',
                                                      EncodeDate(qData.FieldByName('CONTRACT_YEAR').AsInteger,
                                                                 qData.FieldByName('CONTRACT_MONTH').AsInteger,
                                                                 qData.FieldByName('CONTRACT_DAY').AsInteger
                                                                )
                                                    + EncodeTime(14,0,0,0)
                                //                    )
                                            );
          pContactFIO := Trim(qData.FieldByName('PERSON_SURNAME').AsString) + ' ' + Copy(Trim(qData.FieldByName('PERSON_NAME').AsString), 1, 1 ) + '.'
                      + Copy(Trim(qData.FieldByName('PERSON_PATRONYMIC').AsString), 1, 1 ) + '.' ;
          pStreetTypesId := GetStretType(Trim(qData.FieldByName('STREET_TYPE').AsString));
          if Trim(qData.FieldByName('PERSON_SEX').AsString) = '�������' then
            pContactSexTypesId := 0
          else
            pContactSexTypesId := 1;

          // 2. ���������� ������ ��� ������ ������ � �������������� ������� �� DOL
          //qryInsertContract.Parameters.ParamByName('').Value := qData.FieldByName('').Value;
          qryInsertContract.Parameters.ParamByName('pDateCreate').Value         := pDATE_CREATED;//StrToDate(pDATE_CREATED); // ���� �������� �������� (��������� � �������) - ������ ������
          qryInsertContract.Parameters.ParamByName('pUserId').Value             := 1; // ������������ (2-�����)
          qryInsertContract.Parameters.ParamByName('pPointCode').Value          := pPOINT_CODE;
          qryInsertContract.Parameters.ParamByName('pCode').Value               := Trim(qData.FieldByName('CONTRACT_NUM').AsString);
          qryInsertContract.Parameters.ParamByName('pStatus').Value             := -3; // ����� ������ � ����� "������������"

          pDATE_CREATED :=  FormatDateTime( 'dd.mm.yyyy',
                                                  EncodeDate(qData.FieldByName('CONTRACT_YEAR').AsInteger,
                                                             qData.FieldByName('CONTRACT_MONTH').AsInteger,
                                                             qData.FieldByName('CONTRACT_DAY').AsInteger
                                                            )
                                          );
          //qryInsertContract.Parameters.ParamByName('pDate').Value               := Date;//pDATE_CREATED;//StrToDate(pDATE_CREATED); // ���� �������� �������� (���������� � ���������)
          qryInsertContract.Parameters.ParamByName('pDate').Value               := pDATE_CREATED;//StrToDate(pDATE_CREATED); // ���� �������� �������� (���������� � ���������) - ������� ������
          qryInsertContract.Parameters.ParamByName('pABSCode').Value            := '';
          //    qryInsertContract.Parameters.ParamByName('pABSDate').Value            := null;
          qryInsertContract.Parameters.ParamByName('pShortName').Value          := pContactFIO;// ��� � �������������
          //    qryInsertContract.Parameters.ParamByName('pComments').Value           := null;
          qryInsertContract.Parameters.ParamByName('pClientVersion').Value      := pClientVersion;
          qryInsertContract.Parameters.ParamByName('pPaysystemsId').Value       := pPaysystemsId; // ������� ������
          qryInsertContract.Parameters.ParamByName('pBillcyclesId').Value       := pBillcyclesId;
          qryInsertContract.Parameters.ParamByName('pCustomerTypesId').Value    := pCustomerTypesId;
          qryInsertContract.Parameters.ParamByName('pCustomerResident').Value   := pCustomerResident;
          qryInsertContract.Parameters.ParamByName('pCustomerRatepayer').Value  := pCustomerRatepayer;
          qryInsertContract.Parameters.ParamByName('pCustomerSpheresId').Value  := pCustomerSpheresId;
          //    qryInsertContract.Parameters.ParamByName('pZIP').Value                := null;
          qryInsertContract.Parameters.ParamByName('pCountry').Value            := pCountry;
          //    qryInsertContract.Parameters.ParamByName('pRegion').Value             := null;
          //    qryInsertContract.Parameters.ParamByName('pArea').Value               := null;

          qryInsertContract.Parameters.ParamByName('pPlaceTypesId').Value       := pPlaceTypesId; //qData.FieldByName('').Value;
          qryInsertContract.Parameters.ParamByName('pPlaceName').Value          := qData.FieldByName('CITY').Value;
          qryInsertContract.Parameters.ParamByName('pStreetTypesId').Value      := pStreetTypesId; //qData.FieldByName('').Value;
          qryInsertContract.Parameters.ParamByName('pStreetName').Value         := Trim(qData.FieldByName('STREET_NAME').AsString);
          qryInsertContract.Parameters.ParamByName('pHouse').Value              := Trim(qData.FieldByName('HOUSE').Value);
          qryInsertContract.Parameters.ParamByName('pBuildingTypesId').Value    := pBuildingTypesId;
          //    qryInsertContract.Parameters.ParamByName('pBuilding').Value           := null;
          qryInsertContract.Parameters.ParamByName('pRoomTypesId').Value        := pRoomTypesId;
          qryInsertContract.Parameters.ParamByName('pRoom').Value               := Trim(qData.FieldByName('APPARTMENT').AsString);
          qryInsertContract.Parameters.ParamByName('pDeliveryTypesId').Value    := pDeliveryTypesId;//
          //    qryInsertContract.Parameters.ParamByName('pDeliveryNotes').Value      := null;
          qryInsertContract.Parameters.ParamByName('pContactSexTypesId').Value  := pContactSexTypesId;
          qryInsertContract.Parameters.ParamByName('pContactFIO').Value         := Trim(pContactFIO);
          qryInsertContract.Parameters.ParamByName('pContactPhonePrefix').Value := Trim(qData.FieldByName('PHONEINFO_PREFIX').AsString);
          qryInsertContract.Parameters.ParamByName('pContactPhoneNumber').Value := Trim(qData.FieldByName('PHONEINFO_NUMBER').AsString);
          //    qryInsertContract.Parameters.ParamByName('pContactFaxPrefix').Value   := null;
          //    qryInsertContract.Parameters.ParamByName('pContactFaxNumber').Value   := null;
          //    qryInsertContract.Parameters.ParamByName('pContactEmail').Value       := null;
          //    qryInsertContract.Parameters.ParamByName('pContactNotes').Value       := null;
          //    qryInsertContract.Parameters.ParamByName('pBAN').Value                := null;
          //    qryInsertContract.Parameters.ParamByName('pCorpBillPlanId').Value     := null;
          qryInsertContract.Parameters.ParamByName('pCorpConnStartId').Value    := pCorpConnStartId;
          qryInsertContract.Parameters.ParamByName('pCorpConnEndId').Value      := pCorpConnEndId;
          qryInsertContract.Parameters.ParamByName('pPhone').Value              := Trim(qData.FieldByName('PHONEINFO_FULL_NUMBER').AsString);
          //    qryInsertContract.Parameters.ParamByName('pBEN').Value                := null;
          qryInsertContract.Parameters.ParamByName('pAddOption').Value          := pAddOption;
          qryInsertContract.Parameters.ParamByName('pIsTransferNumber').Value   := pIsTransferNumber;

          //pDATE_CREATED := DATE;
          qryInsertContract.ExecSQL;

          //�������� ID ������������ ��������� (�� ���������� �����, ����� ���������� ������������ �� ������ ������)
          qryGetContractID.Close;
          qryGetContractID.Parameters.ParamByName('pCode').Value := Trim(qData.FieldByName('CONTRACT_NUM').AsString);
          qryGetContractID.Parameters.ParamByName('pContactFIO').Value := Trim(pContactFIO);
          qryGetContractID.Parameters.ParamByName('pDate').Value := pDATE_CREATED;
          qryGetContractID.Open;
          vCONTRACT_ID := qryGetContractID.FieldByName('ID').Value;
          qryGetContractID.Close;

          // ���� ������ ���, �� ��������� � ������ ������ � ������� CUSTOMER_INFO
          try
            // ���������� ��� ���������
            pDocTypesId := GetDocumTypeID(Trim(qData.FieldByName('DOCUM_NAME').AsString));
            if (pDocTypesId < 0) then
              // ���� �� ����� � ����������� ��� ���������, �� ������� ����������
              raise Exception.Create('�� ��������� ��� ��������� "' + Trim(qData.FieldByName('DOCUM_NAME').AsString) + '"!');

            // ��������� ������� CUSTOMER_PERSON
            //qryInserCustomer_INFO.Parameters.ParamByName('').Value := ;
            qryInserCustomer_INFO.Parameters.ParamByName('pContractsId').Value := vCONTRACT_ID;
            qryInserCustomer_INFO.Parameters.ParamByName('pTypesId').Value := 0; // ������� ����
            //qryInserCustomer_INFO.Parameters.ParamByName('pINN').Value := qData.FieldByName('').Value;
            qryInserCustomer_INFO.Parameters.ParamByName('pSexTypesId').Value := pContactSexTypesId;
            qryInserCustomer_INFO.Parameters.ParamByName('pLastName').Value := Trim(qData.FieldByName('PERSON_SURNAME').AsString);
            qryInserCustomer_INFO.Parameters.ParamByName('pFirstName').Value := Trim(qData.FieldByName('PERSON_NAME').AsString);
            qryInserCustomer_INFO.Parameters.ParamByName('pSecondName').Value := Trim(qData.FieldByName('PERSON_PATRONYMIC').AsString);
            qryInserCustomer_INFO.Parameters.ParamByName('pDocTypesId').Value := pDocTypesId; // ��� ��������� - �������
            qryInserCustomer_INFO.Parameters.ParamByName('pDocSeria').Value :=
                  Copy(qData.FieldByName('DOCUM_SER').AsString, 1, 2) + ' ' + Copy(qData.FieldByName('DOCUM_SER').AsString, 3, 2); // ������ "00 00"
            qryInserCustomer_INFO.Parameters.ParamByName('pDocNumber').Value := Trim(qData.FieldByName('DOCUM_NUM').AsString);
            qryInserCustomer_INFO.Parameters.ParamByName('pDocGivenBy').Value := Trim(qData.FieldByName('DOCUM_ISSUE').AsString);
              pDocDate :=  FormatDateTime( 'dd.mm.yyyy',
                                                    EncodeDate(qData.FieldByName('ISSUE_YEAR').AsInteger,
                                                               qData.FieldByName('ISSUE_MONTH').AsInteger,
                                                               qData.FieldByName('ISSUE_DAY').AsInteger
                                                              )
                                            );
            qryInserCustomer_INFO.Parameters.ParamByName('pDocDate').Value := pDocDate;
              pBirthday := FormatDateTime( 'dd.mm.yyyy',
                                                    EncodeDate(qData.FieldByName('BIRTH_YEAR').AsInteger,
                                                               qData.FieldByName('BIRTH_MONTH').AsInteger,
                                                               qData.FieldByName('BIRTH_DAY').AsInteger
                                                              )
                                            );
            qryInserCustomer_INFO.Parameters.ParamByName('pBirthday').Value := pBirthday;
            qryInserCustomer_INFO.ExecSQL;

            try
              // ��������� ������� DELIVERYADDRESSES
              qryInsertDeleveryAddres.Close;
              //qryInsertDeleveryAddres.Parameters.ParamByName('').Value := ;
              qryInsertDeleveryAddres.Parameters.ParamByName('pContractsId').Value := vCONTRACT_ID;
              //qryInsertDeleveryAddres.Parameters.ParamByName('pZIP').Value := qData.FieldByName('').Value;
              qryInsertDeleveryAddres.Parameters.ParamByName('pCountry').Value := pCountry;
              //qryInsertDeleveryAddres.Parameters.ParamByName('pRegion').Value := qData.FieldByName('').Value;
              //qryInsertDeleveryAddres.Parameters.ParamByName('pArea').Value := qData.FieldByName('').Value;
              qryInsertDeleveryAddres.Parameters.ParamByName('pPlaceTypesId').Value := pPlaceTypesId;
              qryInsertDeleveryAddres.Parameters.ParamByName('pPlaceName').Value := Trim(qData.FieldByName('CITY').AsString);
              qryInsertDeleveryAddres.Parameters.ParamByName('pStreetTypesId').Value := pStreetTypesId;
              qryInsertDeleveryAddres.Parameters.ParamByName('pStreetName').Value := Trim(qData.FieldByName('STREET_NAME').AsString);
              qryInsertDeleveryAddres.Parameters.ParamByName('pHouse').Value := Trim(qData.FieldByName('HOUSE').AsString);
              qryInsertDeleveryAddres.Parameters.ParamByName('pBuildingTypesId').Value := pBuildingTypesId;
              //qryInsertDeleveryAddres.Parameters.ParamByName('pBuilding').Value := qData.FieldByName('').Value;
              qryInsertDeleveryAddres.Parameters.ParamByName('pRoomTypesId').Value := pRoomTypesId;
              qryInsertDeleveryAddres.Parameters.ParamByName('pRoom').Value := Trim(qData.FieldByName('APPARTMENT').AsString);
              qryInsertDeleveryAddres.ExecSQL;

              try
                // ���������  ������� CONNECTIONS
                pCellnetsId := 2; // ��� ���������� �����
                pProductsId := -1; // ������ ��
                pPhoneOwner := 1; // ����������� ������������ (0 - ������������ ����������, 1 - ����������� ������������ ��������)
                pSimLock := 0;  // ������� SIM-Lock
                qryInsertConnection.Parameters.ParamByName('pContractsId').Value := vCONTRACT_ID;
                qryInsertConnection.Parameters.ParamByName('pCellnetsId').Value := pCellnetsId;
                qryInsertConnection.Parameters.ParamByName('pProductsId').Value := pProductsId;
                qryInsertConnection.Parameters.ParamByName('pPhoneOwner').Value := pPhoneOwner;
                qryInsertConnection.Parameters.ParamByName('pSerNumberTA').Value := '';
                qryInsertConnection.Parameters.ParamByName('pSimLock').Value := pSimLock;

                GetSimInfo(qData.FieldByName('PHONEINFO_FULL_NUMBER').Value, pIMSI, pTARIFF_CODE);
                qryInsertConnection.Parameters.ParamByName('pIMSI').Value := pIMSI;
                qryInsertConnection.ExecSQL;

                //�������� ID ������������ �����������
                qryGetConnectionID.Close;
                qryGetConnectionID.Parameters.ParamByName('pContractsId').Value := vCONTRACT_ID;
                qryGetConnectionID.Open;
                vCONECTION_ID := qryGetConnectionID.FieldByName('ID').Value;
                qryGetConnectionID.Close;

                try
                  // ��������� ������� MOBILES ()
                  //qryInsertMobile.Parameters.ParamByName('').Value := ;
                  qryInsertMobile.Parameters.ParamByName('pConnectionsId').Value := vCONECTION_ID;
                  qryInsertMobile.Parameters.ParamByName('pChannelTypesId').Value := 1;
                  qryInsertMobile.Parameters.ParamByName('pChannelLensId').Value := 0;
                  qryInsertMobile.Parameters.ParamByName('pSNB').Value := Trim(qData.FieldByName('PHONEINFO_FULL_NUMBER').AsString);
                  qryInsertMobile.Parameters.ParamByName('pBillplansId').Value := pTARIFF_CODE;
                  qryInsertMobile.Parameters.ParamByName('pBillPlanSclad').Value := True;
                  //    qryInsertMobile.Parameters.ParamByName('pTransferSNB').Value := ;
                  //    qryInsertMobile.Parameters.ParamByName('pHLR').Value := ;
                  //    qryInsertMobile.Parameters.ParamByName('pOperator').Value := ;
                  //    qryInsertMobile.Parameters.ParamByName('pOperatorID').Value := ;
                  //    qryInsertMobile.Parameters.ParamByName('pRegion').Value := ;
                  qryInsertMobile.ExecSQL;

                  //�������� ID ������������ �������� MOBILESID
                  qryGetMobilesID.Close;
                  qryGetMobilesID.Parameters.ParamByName('pConnectionsId').Value := vCONECTION_ID;
                  qryGetMobilesID.Open;
                  pMobilesID := qryGetMobilesID.FieldByName('ID').Value;
                  qryGetMobilesID.Close;

                  try
                    // ��������� ������� SERVICES �� ��������� ����������� L_BPLANSERVICES, ��� ������� ������ ������� �������� �� ������� ��� �����������
                    qryGetTP_Services.Close;
                    qryGetTP_Services.Parameters.ParamByName('pBillPlansID').Value := pTARIFF_CODE;
                    qryGetTP_Services.Open;
                    qryGetTP_Services.First;
                    while not qryGetTP_Services.Eof do
                    begin
                      qryInsertServices.Parameters.ParamByName('pMobilesId').Value := pMobilesID;
                      qryInsertServices.Parameters.ParamByName('pServicesId').Value := qryGetTP_Services.FieldByName('ServicesId').Value;
                      qryInsertServices.ExecSQL;
                      qryGetTP_Services.Next;
                    end;

                    try
                      // ���������  ������� LOGPARAMS (2 ������, ��� ������� �������� �������� �� ������)
                      //qryInsertLOGPARAMS.Parameters.ParamByName('').Value := ;
                      qryInsertLOGPARAMS.Parameters.ParamByName('pContractsId').Value := vCONTRACT_ID;
                      qryInsertLOGPARAMS.Parameters.ParamByName('pLogParamId').Value  := 1;
                      qryInsertLOGPARAMS.ExecSQL;
                      qryInsertLOGPARAMS.Parameters.ParamByName('pContractsId').Value := vCONTRACT_ID;
                      qryInsertLOGPARAMS.Parameters.ParamByName('pLogParamId').Value  := 2;
                      qryInsertLOGPARAMS.ExecSQL;
                      // ���� ���� ����� ������ ������ �� ���� � �������� ��� ��������
                      inc(vLOADED_CNT);
                      lblLoadedDOL.Caption := IntToStr(vLOADED_CNT); // ����� ��� ���������� ����� �� �����������
                      err_list.Add('������� ���������');
                    except
                      on e7 : Exception do
                      begin
                        //WriteError('��� ��������� ������ ������������ (������� MOBILES)' + e7.Message + '!', vERR_CNT);
                        vERROR_MSG := vERROR_MSG + '��� ��������� ������ ������������ (������� MOBILES)' + e7.Message + '! ';
                        qDeleteLOGPARAMS.Parameters.ParamByName('pContractsId').Value := vCONTRACT_ID;
                        qDeleteLOGPARAMS.ExecSQL;
                        qDeleteServices.Parameters.ParamByName('pMobilesID').Value := pMobilesID;
                        qDeleteServices.ExecSQL;
                        qDeleteMobile.Parameters.ParamByName('ID').Value := pMobilesID;
                        qDeleteMobile.ExecSQL;
                        qDeleteConnection.Parameters.ParamByName('pContracstId').Value := vCONTRACT_ID;// ������� ��� ������ ��� ��������
                        qDeleteConnection.ExecSQL;
                        qDeleteDeleveryAddres.Parameters.ParamByName('').Value := vCONTRACT_ID;
                        qDeleteDeleveryAddres.ExecSQL;
                        qDelete�ustomerInfo.Parameters.ParamByName('pContractsID').Value := vCONTRACT_ID;
                        qDelete�ustomerInfo.ExecSQL;
                        qDeleteContract.Parameters.ParamByName('pContractsID').Value := vCONTRACT_ID;
                        qDeleteContract.ExecSQL;
                      end;
                    end;

                  except
                    on e6 : Exception do
                    begin
                      //WriteError('��� ��������� ������ ������������ (������� MOBILES)' + e6.Message + '!', vERR_CNT);
                      vERROR_MSG := vERROR_MSG + '��� ��������� ������ ������������ (������� MOBILES)' + e6.Message + '! ';
                      qDeleteServices.Parameters.ParamByName('pMobilesID').Value := pMobilesID;
                      qDeleteServices.ExecSQL;
                      qDeleteMobile.Parameters.ParamByName('ID').Value := pMobilesID;
                      qDeleteMobile.ExecSQL;
                      qDeleteConnection.Parameters.ParamByName('pContracstId').Value := vCONTRACT_ID;// ������� ��� ������ ��� ��������
                      qDeleteConnection.ExecSQL;
                      qDeleteDeleveryAddres.Parameters.ParamByName('').Value := vCONTRACT_ID;
                      qDeleteDeleveryAddres.ExecSQL;
                      qDelete�ustomerInfo.Parameters.ParamByName('pContractsID').Value := vCONTRACT_ID;
                      qDelete�ustomerInfo.ExecSQL;
                      qDeleteContract.Parameters.ParamByName('pContractsID').Value := vCONTRACT_ID;
                      qDeleteContract.ExecSQL;
                    end;
                  end;

                except
                  on e5 : Exception  do
                  begin
                    //WriteError('��� ��������� ������ ������������ (������� MOBILES)' + e5.Message + '!', vERR_CNT);
                    vERROR_MSG := vERROR_MSG + '��� ��������� ������ ������������ (������� MOBILES)' + e5.Message + '! ';
                    qDeleteMobile.Parameters.ParamByName('ID').Value := pMobilesID;
                    qDeleteMobile.ExecSQL;
                    qDeleteConnection.Parameters.ParamByName('pContracstId').Value := vCONTRACT_ID;// ������� ��� ������ ��� ��������
                    qDeleteConnection.ExecSQL;
                    qDeleteDeleveryAddres.Parameters.ParamByName('').Value := vCONTRACT_ID;
                    qDeleteDeleveryAddres.ExecSQL;
                    qDelete�ustomerInfo.Parameters.ParamByName('pContractsID').Value := vCONTRACT_ID;
                    qDelete�ustomerInfo.ExecSQL;
                    qDeleteContract.Parameters.ParamByName('pContractsID').Value := vCONTRACT_ID;
                    qDeleteContract.ExecSQL;
                  end;
                end;

              except
                on e4 : Exception do
                begin
                  //WriteError('��� ��������� ����������� (������� CONNECTIONS)' + e4.Message + '!', vERR_CNT);
                  vERROR_MSG := vERROR_MSG + '��� ��������� ����������� (������� CONNECTIONS)' + e4.Message + '! ' ;
                  qDeleteConnection.Parameters.ParamByName('pContracstId').Value := vCONTRACT_ID;// ������� ��� ������ ��� ��������
                  qDeleteConnection.ExecSQL;
                  qDeleteDeleveryAddres.Parameters.ParamByName('').Value := vCONTRACT_ID;
                  qDeleteDeleveryAddres.ExecSQL;
                  qDelete�ustomerInfo.Parameters.ParamByName('pContractsID').Value := vCONTRACT_ID;
                  qDelete�ustomerInfo.ExecSQL;
                  qDeleteContract.Parameters.ParamByName('pContractsID').Value := vCONTRACT_ID;
                  qDeleteContract.ExecSQL;
                end;
              end;

            except
              on e3 : Exception do
              begin
                //WriteError('��� ���������� ��������� ������ (������� DeleveryAddres) : ' + e3.Message + ' !', vERR_CNT);
                vERROR_MSG := vERROR_MSG + '��� ���������� ��������� ������ (������� DeleveryAddres) : ' + e3.Message + ' ! ';
                qDeleteDeleveryAddres.Parameters.ParamByName('').Value := vCONTRACT_ID;
                qDeleteDeleveryAddres.ExecSQL;
                qDelete�ustomerInfo.Parameters.ParamByName('pContractsID').Value := vCONTRACT_ID;
                qDelete�ustomerInfo.ExecSQL;
                qDeleteContract.Parameters.ParamByName('pContractsID').Value := vCONTRACT_ID;
                qDeleteContract.ExecSQL;
              end;
            end;


          except
            on e2 : Exception do
            begin
              //WriteError('��� ���������� ������ �������� (������� PERSON_INFO) �������� ������: '+ e2.Message + '!', vERR_CNT);
              vERROR_MSG := vERROR_MSG + '��� ���������� ������ �������� (������� PERSON_INFO) �������� ������: '+ e2.Message + '! ';
              qDelete�ustomerInfo.Parameters.ParamByName('pContractsID').Value := vCONTRACT_ID;
              qDelete�ustomerInfo.ExecSQL;
              qDeleteContract.Parameters.ParamByName('pContractsID').Value := vCONTRACT_ID;
              qDeleteContract.ExecSQL;
            end;
          end;

        except
          on e : Exception do
          begin
            //WriteError('��� ���������� ��������� (������� CONTRACT) �������� ������: '+ e.Message + '!', vERR_CNT);
            vERROR_MSG := vERROR_MSG + '��� ���������� ��������� (������� CONTRACT) �������� ������: '+ e.Message + '!';
            qDeleteContract.Parameters.ParamByName('pContractsID').Value := vCONTRACT_ID;
            qDeleteContract.ExecSQL;
          end;
        end;


        (*
        if qData.FieldByName('ERROR_TEXT').AsString = '' then // ���� �� ���� ������
        begin
          //qdata.Edit;
          qData.FieldByName('ERROR_TEXT').Value := '������� ���������';
        end;
        *)

        if vERROR_MSG = '' then // ���� �� ���� ������
          vERROR_MSG := '������� ���������'
        else
          Inc(vERR_CNT);

        err_list.Strings[qData.RecNo-1] := vERROR_MSG;
        //qData.Prior;
        qdata.Next;
      end;
      //else
        //qdata.Next;

      //qData.Post;
      // ����� �������� ��������� ���������� ������
      lblERROR_COUNT.Caption := IntToStr(vERR_CNT);
      lblLoadedDOL.Caption := IntToStr(vLOADED_CNT);

      try
        // ��������� ���� � ��������, ���� � �������� ������� ����� ������
        qData.Last;
        while not qData.Bof do
        if qData.FieldByName('ERROR_TEXT').IsNull then // ����� ���� �������������� � ������ �������. ����� �� �����������
        begin
          qData.Edit;
          qData.FieldByName('ERROR_TEXT').AsString := err_list.Strings[qData.RecNo-1];
          qData.Prior;
        end
        else
          qData.Prior;
      except
        on Er: Exception do
        begin
          MessageDlg('��� ������������ �������� ������ ��������� ������: '+ #10#13 + er.Message, mtError, [mbOK], 0);
        end;
      end;

    except
      on e0 : Exception  do
      begin
        lblERROR_COUNT.Caption := IntToStr(qData.RecordCount); // ������ ��� ����� �� �����������
        MessageDlg('��� ������� �������� ������ � DOL ��������� ������: '+ #10#13 + e0.Message, mtError, [mbOK], 0);
      end;
    end;
  finally
    if vERR_CNT = 0 then
      MessageDlg('�������� ������ DOL ���������! ��������� ' + IntToStr(vLOADED_CNT) + ' �������!', mtInformation, [mbOK], 0);
  end;
end;


// ���������� ��� �������� �� ������
procedure TMainFrm.DoSendContracts;

  // ��������� ����� SOAP ���������
  function GetSOAPText: string;
  var
    vTEXT : string;
    pCONTRACT_STATUS, pCONTRACT_CODE, pCONTRACT_COMMENTS, pCONTRACT_CLIENTVER, pCONTRACT_DATECREATE : string;
    //pCONTRACT_DATECREATE : TDate;
    pDEALER_CODE, pDEALER_POINTCODE : string;
    pABS_CODE, pABS_DATE : string;
    pCUSTOMER_SPHERESID, pCUSTOMER_RESIDENT, pCUSTOMER_RATEPAYER : string;
    pADDRESS_COUNTRY, pADDRESS_PLACE, pADDRESS_REGION, pADDRESS_AREA, pADDRESS_STREET, pADDRESS_HOUSE, pADDRESS_ROOM: string;
    pCONTACT_SEXTYPESID : string;
    pCONTACT_NAME : string; // ���
    pCONTACT_PHONE_PREFIX, pCONTACT_PHONE_NUMBER : string;

  begin
    pCUSTOMER_SPHERESID := '0';
    pCUSTOMER_RESIDENT := '165'; //������� ��� ������ 3 ������ ���� ��� ������, ��, ���������� ���������
    pCUSTOMER_RATEPAYER := '1';
    pADDRESS_COUNTRY := '������';
    pADDRESS_PLACE := '������';

    pCONTRACT_STATUS := 'New';//'0'; // ������ � �������� (����������� ���������)
    pCONTRACT_CODE := qData.FieldByName('CONTRACT_NUM').AsString;
    pCONTRACT_DATECREATE := FormatDateTime( 'dd/mm/yyyy',
                                            EncodeDate(qData.FieldByName('CONTRACT_YEAR').AsInteger,
                                                       qData.FieldByName('CONTRACT_MONTH').AsInteger,
                                                       qData.FieldByName('CONTRACT_DAY').AsInteger
                                                      )
                                          );
    pCONTRACT_COMMENTS :='';
    pCONTRACT_CLIENTVER := '1.0.0.1';
    pDEALER_CODE := '990013';
    //pDEALER_POINTCODE := ;
    pABS_CODE := '';
    pABS_DATE := '';
    pADDRESS_STREET := qData.FieldByName('STREET_NAME').AsString;
    pADDRESS_HOUSE := qData.FieldByName('HOUSE').AsString;
    pADDRESS_ROOM := qData.FieldByName('APPARTMENT').AsString;
    if qData.FieldByName('PERSON_SEX').AsString = '�������' then
      pCONTACT_SEXTYPESID := '1'  // ������
    else
      pCONTACT_SEXTYPESID := '2';

    pCONTACT_NAME := qData.FieldByName('PERSON_SURNAME').AsString + ' ' + qData.FieldByName('PERSON_NAME').AsString
                  + ' ' + qData.FieldByName('PERSON_PATRONYMIC').AsString;
    pCONTACT_PHONE_PREFIX := qData.FieldByName('PHONEINFO_PREFIX').AsString;
    pCONTACT_PHONE_NUMBER := qData.FieldByName('PHONEINFO_NUMBER').AsString;

    try
      try
{        vTEXT := '<?xml version="1.0" encoding="utf-8"?>'
                +'<soap12:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap12="http://www.w3.org/2003/05/soap-envelope">'
                 + '<soap12:Body>'
                 +   '<ContractImport xmlns="http://beeline.ru/ws/dol/2006">'
                 +     '<CONTRACT Status="' + pCONTRACT_STATUS + '" Code="' + pCONTRACT_CODE + '" DateCreate="' + pCONTRACT_DATECREATE + '" Comments="' + pCONTRACT_COMMENTS + '" ClientVer="' + pCONTRACT_CLIENTVER + '">'
                 +       '<DEALER Code="' + pDEALER_CODE + '" PointCode="' +pDEALER_POINTCODE + '" />'
                 +       '<ABS Code="' + pABS_CODE + '" Date="' + pABS_DATE + '" />'
                 +       '<CUSTOMER SpheresId="' + pCUSTOMER_SPHERESID + '" Resident="' + pCUSTOMER_RESIDENT + '" Ratepayer="' + pCUSTOMER_RATEPAYER + '">'
                 +         '<BANKPROPLIST>'
                 +           '<BANKPROPSPRIM xsi:nil="true" />'
                 +           '<BANKPROPSSEC xsi:nil="true" />'
                 +           '<BANKPROPSSEC xsi:nil="true" />'
                 +         '</BANKPROPLIST>'
                 +         '<ADDRESS>'
                 //+           '<ZIP>' + pADDRESS_ZIP + '</ZIP>'     // ��������
                 +           '<ZIP xsi:nil="true" />'
                 +           '<COUNTRY>' + pADDRESS_COUNTRY + '</COUNTRY>'
                 //+           '<REGION>' + pADDRESS_REGION + '</REGION>'   ��������
                 //+           '<AREA>' + pADDRESS_AREA + '</AREA>' ��������
                 //+           '<PLACE xsi:nil="true" />'  // ��������
                 +           '<PLACE>' + pADDRESS_PLACE + '</PLACE>'
                 //+           '<STREET xsi:nil="true" />'
                 +           '<STREET>' + pADDRESS_STREET + '</STREET>'
                 +           '<HOUSE>' + pADDRESS_HOUSE + '</HOUSE>'
                 //+           '<BUILDING xsi:nil="true" />'  ��������
                 //+           '<BUILDING>' + pADDRESS_BUILDING + '</BUILDING>'
                 //+           '<ROOM xsi:nil="true" />' //��������
                 +           '<ROOM>' + pADDRESS_ROOM + '</ROOM>' //��������
                 +         '</ADDRESS>'
                 +       '</CUSTOMER>'
                 //+       '<CONTACT SexTypesId="' + pCONTACT_SEXTYPESID + '" EMail="string" Notes="string">' // ��������
                 +       '<CONTACT SexTypesId="' + pCONTACT_SEXTYPESID + '" EMail="string" Notes="string">'
                 +         '<NAME>' + pCONTACT_NAME + '</NAME>'
                 +         '<PHONE Prefix="' + pCONTACT_PHONE_PREFIX + '" Number="' + pCONTACT_PHONE_NUMBER + '" />'
                 //+         '<FAX Prefix="' + pCONTACT_FAX_PREFIX + '" Number="' + pCONTACT_FAX_NUMBER + '" />' // ����� ������
                 +       '</CONTACT>'
                 //+       '<CONNECTIONS BillCyclesId="int" PaySystemsId="Prepaid">' // ��������
                 +       '<CONNECTIONS BillCyclesId="1" PaySystemsId="Prepaid">'
                 //+         '<CONNECTIONS ProductsId="int" PhoneOwner="int" IMSI="string" SimLock="int" SerNumber="string" CellNetsId="2">' //���� CONNECTIONS ������
                 +         '<CONNECTIONS xsi:nil="true" />' //���� CONNECTIONS ������
                 +           '<MOBILES xsi:nil="true" />'
                 +         '</CONNECTIONS>'
//                 +         '<CONNECTIONS ProductsId="int" PhoneOwner="int" IMSI="string" SimLock="int" SerNumber="string" CellNetsId="int">'
//                 +           '<MOBILES xsi:nil="true" />'
//                 +         '</CONNECTIONS>'
                 +       '</CONNECTIONS>'
//                 +       '<LOGPARAMS>' //�������������� ����
//                 +         '<LOGPARAM Comments="string" Value="boolean" />'
//                 +         '<LOGPARAM Comments="string" Value="boolean" />'
//                 +       '</LOGPARAMS>'
                 +     '</CONTRACT>'
                 +   '</ContractImport>'
                 + '</soap12:Body>' +
                 '</soap12:Envelope>'
;
}
        vTEXT := '<?xml version="1.0" encoding="utf-8"?>'
                +'<soap12:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap12="http://www.w3.org/2003/05/soap-envelope">'
                 + '<soap12:Body>'
                 +   '<ContractImport xmlns="http://beeline.ru/ws/dol/2006">'
                 +     '<CONTRACT Status="' + pCONTRACT_STATUS + '" Code="' + pCONTRACT_CODE + '" DateCreate="' + pCONTRACT_DATECREATE + '" Comments="' + pCONTRACT_COMMENTS + '" ClientVer="' + pCONTRACT_CLIENTVER + '">'
                 +       '<DEALER Code="' + pDEALER_CODE + '" PointCode="' +pDEALER_POINTCODE + '" />'
                 +       '<ABS Code="' + pABS_CODE + '" Date="' + pABS_DATE + '" />'
                 +       '<CUSTOMER SpheresId="' + pCUSTOMER_SPHERESID + '" Resident="' + pCUSTOMER_RESIDENT + '" Ratepayer="' + pCUSTOMER_RATEPAYER + '">'
                 +         '<BANKPROPLIST>'
                 +           '<BANKPROPSPRIM xsi:nil="true" />'
                 +           '<BANKPROPSSEC xsi:nil="true" />'
                 +           '<BANKPROPSSEC xsi:nil="true" />'
                 +         '</BANKPROPLIST>'
                 +         '<ADDRESS>'
                 //+           '<ZIP>' + pADDRESS_ZIP + '</ZIP>'     // ��������
                 +           '<ZIP xsi:nil="true" />'
                 +           '<COUNTRY>' + pADDRESS_COUNTRY + '</COUNTRY>'
                 //+           '<REGION>' + pADDRESS_REGION + '</REGION>'   ��������
                 //+           '<AREA>' + pADDRESS_AREA + '</AREA>' ��������
                 //+           '<PLACE xsi:nil="true" />'  // ��������
                 +           '<PLACE>' + pADDRESS_PLACE + '</PLACE>'
                 //+           '<STREET xsi:nil="true" />'
                 +           '<STREET>' + pADDRESS_STREET + '</STREET>'
                 +           '<HOUSE>' + pADDRESS_HOUSE + '</HOUSE>'
                 //+           '<BUILDING xsi:nil="true" />'  ��������
                 //+           '<BUILDING>' + pADDRESS_BUILDING + '</BUILDING>'
                 //+           '<ROOM xsi:nil="true" />' //��������
                 +           '<ROOM>' + pADDRESS_ROOM + '</ROOM>' //��������
                 +         '</ADDRESS>'
                 +       '</CUSTOMER>'
                 //+       '<CONTACT SexTypesId="' + pCONTACT_SEXTYPESID + '" EMail="string" Notes="string">' // ��������
                 +       '<CONTACT SexTypesId="' + pCONTACT_SEXTYPESID + '" EMail="string" Notes="string">'
                 +         '<NAME>' + pCONTACT_NAME + '</NAME>'
                 +         '<PHONE Prefix="' + pCONTACT_PHONE_PREFIX + '" Number="' + pCONTACT_PHONE_NUMBER + '" />'
                 //+         '<FAX Prefix="' + pCONTACT_FAX_PREFIX + '" Number="' + pCONTACT_FAX_NUMBER + '" />' // ����� ������
                 +       '</CONTACT>'
                 //+       '<CONNECTIONS BillCyclesId="int" PaySystemsId="Prepaid">' // ��������
                 +       '<CONNECTIONS BillCyclesId="1" PaySystemsId="Prepaid">'
                 //+         '<CONNECTIONS ProductsId="int" PhoneOwner="int" IMSI="string" SimLock="int" SerNumber="string" CellNetsId="2">' //���� CONNECTIONS ������
                 +         '<CONNECTIONS xsi:nil="true" >' //���� CONNECTIONS ������
                 +           '<MOBILES xsi:nil="true" />'
                 +         '</CONNECTIONS>'
//                 +         '<CONNECTIONS ProductsId="int" PhoneOwner="int" IMSI="string" SimLock="int" SerNumber="string" CellNetsId="int">'
//                 +           '<MOBILES xsi:nil="true" />'
//                 +         '</CONNECTIONS>'
                 +       '</CONNECTIONS>'
//                 +       '<LOGPARAMS>' //�������������� ����
//                 +         '<LOGPARAM Comments="string" Value="boolean" />'
//                 +         '<LOGPARAM Comments="string" Value="boolean" />'
//                 +       '</LOGPARAMS>'
                 +     '</CONTRACT>'
                 +   '</ContractImport>'
                 + '</soap12:Body>' +
                 '</soap12:Envelope>'
;

        Result := vTEXT;
      except
        on E: Exception do
        begin
          qData.FieldByName('ERROR_TEXT').AsString := '�������� ������ ��� ������������ SOAP ���������! '+ e.Message;
          Result := 'Error';
        end;
      end;
    finally
      // SOAP ������ �����������
    end;
  end;

  // �������� HTTP ������ c SOAP ����������
  procedure SendSOAP(const pSOAP : string; vANSWER : string; vERROR_MSG : string);
  var
    S : TStringList;
    str : TStringStream;
  begin
    try
      try
        //��������� ����� � ������� ���������
        s := TStringList.Create;
        s.Add(pSOAP);
        str := TStringStream.Create;
        s.SaveToStream(str, TEncoding.UTF8);

        IdHTTP1.Request.CustomHeaders.Clear;
        IdHTTP1.Request.Clear;

        IdHTTP1.Request.ContentType := 'application/soap+xml';
        IdHTTP1.Request.CharSet := '"utf-8"';
        //IdHTTP1.Request.UserAgent := '';

        vAnswer := IdHTTP1.Post('https://dealer.beeline.ru/dealer/WebService/DOL.asmx', str);
      except
        on e : Exception  do
        begin
          //qData.FieldByName('ERROR_TEXT').AsString := '�������� ������ ��� �������� �������� � ������! '+ e.Message;
          vERROR_MSG := e.Message;
        end;
      end;
    finally
      // SOAP ����������
    end;
  end;

var
  vSOAP : string;
  vANSWER : string;
  vERROR_MSG : string;
  s : TStringList;
begin
  qData.First;
  while not qdata.Eof do
  begin
    // ������ �� ���������� ��������
    vANSWER := '';
    vERROR_MSG := '';

    // �������� ����� SOAP ��������� ��� ������� ������
    vSOAP := GetSOAPText;

    // ���� SOAP �������, ���������� ���
    if vSOAP <> 'Error' then
      begin
        SendSOAP(vSOAP, vANSWER, vERROR_MSG);
        s := TStringList.Create;
        s.Add(vSOAP);
        s.SaveToFile('C:\Users\TARIFER\Desktop\������� ������� ��� ��������\����� DOL\������\request.xml',TEncoding.UTF8);

        s.Clear;
        s.Add(vANSWER);
        s.SaveToFile('C:\Users\TARIFER\Desktop\������� ������� ��� ��������\����� DOL\������\answer.xml',TEncoding.UTF8);

        s.Destroy;
      end;

    // ���� �������� ������, �� ���������� ��
    if vERROR_MSG <> '' then
    begin
      qData.FieldByName('SOAP_RESPONSE').AsString := vAnswer;
      qData.FieldByName('ERROR_TEXT').AsString := '�������� ������ ��� �������� �������� � ������! '+ vERROR_MSG;
    end;

    qData.Next;
  end;
end;

procedure TMainFrm.edt3KeyPress(Sender: TObject; var Key: Char);
begin
  if not (key in ['-', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', char(ord(vk_delete)), char(ord(VK_BACK))]) then
  begin
    beep;
    key := #0;
  end;
end;

procedure TMainFrm.btLoadExcelClick(Sender: TObject);
begin
  if dlgOpen1.Execute(Handle) then
    DoOpenFile(dlgOpen1.FileName);
//  DoOpenFile('C:\Users\TARIFER\Desktop\������� ������� ��� ��������\����� DOL\������� (�����).xls');
  SetFieldTable;
  lblLoadedContract.Caption := IntToStr(qData.RecordCount);
end;


procedure TMainFrm.PrintDOLContract (const pCODE : string; const pPrintDir : string); // � �������� pContractID ���������� ����� ��������� - ���� CODE
var
  Report : TFlexCelReport;
  TemplateFileName, vEXEPath, vUnloadFileName: string;
  vSERVICE_LIST : string;
  vCONTRACT_NUM : string;
  vFILE_NAME : string;
begin
  try
    try
      Report := TFlexCelReport.Create(true);

      qryPrintContracts.Close;
      //qryPrintContracts.Parameters.ParamByName('pContractID').Value := pContractID;
      qryPrintContracts.Parameters.ParamByName('pCODE').Value := pCODE;
      qryPrintContracts.Open;

      vCONTRACT_NUM := '990-' + qryPrintContracts.FieldByName('POINTCODE').AsString +
                      '-' + qryPrintContracts.FieldByName('CODE').AsString;

      Report.SetValue('CONTRACT_NUM', vCONTRACT_NUM);
      Report.SetValue('CONTRACT_DATE',  qryPrintContracts.FieldByName('DATE').AsString);

      Report.SetValue('SPHERES_NAME',  qryPrintContracts.FieldByName('SPHERES_NAME').AsString);
      Report.SetValue('Resident',   '�������� ��');//qryPrintContracts.FieldByName('').AsString);
      Report.SetValue('Ratepayer',  '���������� ���'); //qryPrintContracts.FieldByName('').AsString);
      Report.SetValue('PATRONYMIC',   qryPrintContracts.FieldByName('PATRONYMIC').AsString);
      Report.SetValue('NAME',   qryPrintContracts.FieldByName('NAME').AsString);
      Report.SetValue('SURNAME',   qryPrintContracts.FieldByName('SURNAME').AsString);

      // ���������� ������
      Report.SetValue('DOCUM_NAME',   qryPrintContracts.FieldByName('DOCUM_NAME').AsString);
      Report.SetValue('DOC_SER',   qryPrintContracts.FieldByName('DOC_SER').AsString);
      Report.SetValue('DOC_NUM',   qryPrintContracts.FieldByName('DOC_NUM').AsString);
      Report.SetValue('DOC_ISSUE',   qryPrintContracts.FieldByName('DOC_ISSUE').AsString);
      Report.SetValue('DOC_DATE',   qryPrintContracts.FieldByName('DOC_DATE').AsString);
      //Report.SetValue('BIRTH_PLACE',   qryPrintContracts.FieldByName('BIRTH_PLACE').AsString);
      Report.SetValue('BIRTH_DATE',   qryPrintContracts.FieldByName('BIRTH_DATE').AsString);

      //�����
      Report.SetValue('ZIP',   qryPrintContracts.FieldByName('ZIP').AsString);
      Report.SetValue('COUNTRY',   qryPrintContracts.FieldByName('COUNTRY').AsString);
      Report.SetValue('AREA',   qryPrintContracts.FieldByName('AREA').AsString);
      Report.SetValue('REGION',   qryPrintContracts.FieldByName('REGION').AsString);
      Report.SetValue('PLACE_TYPES_NAME',   qryPrintContracts.FieldByName('PLACE_TYPES_NAME').AsString);
      Report.SetValue('PLACENAME',   qryPrintContracts.FieldByName('PLACENAME').AsString);
      Report.SetValue('STREET_TYPE_NAME',   qryPrintContracts.FieldByName('STREET_TYPE_NAME').AsString);
      Report.SetValue('STREETNAME',   qryPrintContracts.FieldByName('STREETNAME').AsString);
      //Report.SetValue('BUILDINGTYPESNAME',   qryPrintContracts.FieldByName('BUILDINGTYPESNAME').AsString);
      Report.SetValue('BUILDINGTYPESNAME',   '���');
      Report.SetValue('HOUSE',   qryPrintContracts.FieldByName('HOUSE').AsString);
      Report.SetValue('ROOM',   qryPrintContracts.FieldByName('ROOM').AsString);
      Report.SetValue('DELIVERY_TYPES_NAME',   qryPrintContracts.FieldByName('DELIVERY_TYPES_NAME').AsString);

      // ���������� ����
      Report.SetValue('FIO',   qryPrintContracts.FieldByName('FIO').AsString);
      //Report.SetValue('PHONE',   qryPrintContracts.FieldByName('').AsString);

      // ���� ������
      Report.SetValue('SIM_ID',   qryPrintContracts.FieldByName('SIM_ID').AsString);
      Report.SetValue('PHONE_pREFIX',   qryPrintContracts.FieldByName('PHONE_pREFIX').AsString);
      Report.SetValue('PHONE_NUMBER',   qryPrintContracts.FieldByName('PHONE_NUMBER').AsString);
//      Report.SetValue('chanel',  '');
      Report.SetValue('TARIFF_PLAN',   qryPrintContracts.FieldByName('TARIFF_PLAN').AsString);

      qryServicesList.Close;
      qryServicesList.Parameters.ParamByName('pContractID').Value := qryPrintContracts.FieldByName('ID').AsInteger ;
      qryServicesList.Open;
      vSERVICE_LIST := '';
      while NOT qryServicesList.Eof do
      begin
        vSERVICE_LIST := vSERVICE_LIST + qryServicesList.FieldByName('CODE').AsString + ', ' ;
        qryServicesList.Next;
      end;
      vSERVICE_LIST := Copy(vSERVICE_LIST, 1, Length(vSERVICE_LIST)-2); // �������� ��������� �������
      Report.SetValue('SERVICES', vSERVICE_LIST);

      vFILE_NAME := qryPrintContracts.FieldByName('POINTCODE').AsString + qryPrintContracts.FieldByName('CODE').AsString;
      qryPrintContracts.Close;

      vEXEPath := ExtractFilePath(Application.ExeName);
      //TemplateFileName := vEXEPath + 'AnalysPhoneBase.xlsx';
      TemplateFileName := vEXEPath + 'PrintReportDOLContract.xls';
      if not FileExists(TemplateFileName) then
        Raise Exception.Create('���� ������� "'+TemplateFileName+'" �� ����������');

//      vUnloadFileName := vEXEPath + Get_TemplateName(0); // ������� ��� ������������ �����
      vUnloadFileName := pPrintDir + '\'+vFILE_NAME+'.xls'; // ������� ��� ������������ �����
      Report.Run( TemplateFileName, vUnloadFileName );
      ShellExecute(0, 'print', PCHAR(vUnloadFileName), nil, nil, SW_SHOWNORMAL);
      try
        DeleteFile(vUnloadFileName);
      except
        on e2 : Exception  do
        begin
          MessageDlg('��������� ������ ��� �������� ���������� ����� ��� ������ �������� '+ vCONTRACT_NUM +'!. ����� ������, ������� ���� �������'#13#10 + e2.Message, mtError, [mbOK], 0);
        end;
      end;
    except
      on e : Exception  do
      begin
        MessageDlg('��������� ������ ��� �������� �������� �'+ vCONTRACT_NUM +' � Excel.'#13#10 + e.Message, mtError, [mbOK], 0);
      end;
    end;
  finally
    REPORT.Free;
  end;
end;

procedure TMainFrm.btnPrintContractClick(Sender: TObject);

  // � ��������� ���������� ����� �������, ��� ����������� �������� ����� ������  L_LINKS_NAME � L_BILLPLANS_NAME,
  // ����� ������� ����������� ����� ���������� DOL. ������� ����� �������� � INI �����.
  procedure UPDATE_SQL_TEXT;
  var
    l_links_name , L_BILLPLANS_name :String;
  begin
    ReadIniParams(l_links_name , L_BILLPLANS_name);
    qryPrintContracts.SQL.Text :=
      '    SELECT (SELECT L.NAME                        ' +
      '             FROM L_SPHERES L                ' +
      '             WHERE L.ID = C.CUSTOMERSPHERESID                ' +
      '           ) AS SPHERES_NAME                    ' +
      '          ,CP.LASTNAME AS SURNAME                      ' +
      '          ,CP.FIRSTNAME AS NAME                    ' +
      '          ,CP.SECONDNAME AS PATRONYMIC                    ' +
      '          ,DT.NAME AS DOCUM_NAME                    ' +
      '          ,CP.DOCSERIA AS DOC_SER                    ' +
      '          ,CP.DOCNUMBER AS DOC_NUM                    ' +
      '          ,CP.DOCGIVENBY AS DOC_ISSUE                    ' +
      '          ,CP.DOCDATE AS DOC_DATE                      ' +
      '          ,CP.BIRTHDAY AS BIRTH_DATE                      ' +
      '          ,C.POINTCODE, C.CODE, C.STATUS, C.DATE, C.ABSCODE, C.ABSDATE, C.COMMENTS, C.CLIENTVERSION, C.PAYSYSTEMSID, C.BILLCYCLESID                    ' +
      '          ,C.CUSTOMERTYPESID, C.CUSTOMERRESIDENT, C.CUSTOMERRATEPAYER, C.CUSTOMERSPHERESID                    ' +
      '          ,C.ZIP                    ' +
      '          ,C.COUNTRY                    ' +
      '          ,C.REGION                    ' +
      '          ,C.AREA                    ' +
      '          ,(select l.NAME                     ' +
      '               from L_PLACETYPES l                ' +
      '             where l.id = c.PLACETYPESID                ' +
      '           ) as PLACE_TYPES_NAME                    ' +
      '          ,C.PLACENAME                       ' +
      '          ,(SELECT L.NAME                    ' +
      '              FROM L_STREETTYPES L                    ' +
      '             WHERE L.ID = C.STREETTYPESID                ' +
      '          ) AS STREET_TYPE_NAME                    ' +
      '          ,C.STREETNAME                    ' +
      '          ,(select name                    ' +
      '              from l_BUILDINGTYPES l                ' +
      '             where l.id = c.BUILDINGTYPESID                ' +
      '           ) as BUILDINGTYPESNAME                    ' +
      '          ,C.HOUSE                    ' +
      '          ,C.BUILDING                    ' +
      '          ,C.ROOMTYPESID                    ' +
      '          ,C.ROOM                    ' +
      '          ,C.DELIVERYNOTES                    ' +
      '          ,(SELECT L.NAME                    ' +
      '              FROM L_DELIVERYTYPES L                    ' +
      '             WHERE C.DELIVERYTYPESID = L.ID                ' +
      '           ) AS DELIVERY_TYPES_NAME                    ' +
      '          ,C.CONTACTSEXTYPESID                    ' +
      '          ,C.CONTACTFIO AS FIO                    ' +
      '          ,C.CONTACTPHONEPREFIX AS PHONE_PREFIX                    ' +
      '          ,C.CONTACTPHONENUMBER AS PHONE_NUMBER                    ' +
      '          ,(SELECT l.SerNum                    ' +
      '              FROM ' + L_LINKS_NAME +' l                    ' +
      '             WHERE l.snb = c.Phone                ' +
      '          ) as SIM_ID                    ' +
      '          ,(select l.NAME+''[''+L.CODE +'']''                    ' +
      '              from ' + L_BILLPLANS_NAME + ' l                    ' +
      '                  ,MOBILES MOB            ' +
      '             where MOB.CONNECTIONSID = CON.ID                ' +
      '               AND MOB.BILLPLANSID = L.ID                ' +
      '          ) AS TARIFF_PLAN                    ' +
      '          ,C.CONTACTFAXPREFIX                    ' +
      '          ,C.CONTACTFAXNUMBER                    ' +
      '          ,C.CONTACTEMAIL                    ' +
      '          ,C.CONTACTNOTES                    ' +
      '          ,C.BAN                    ' +
      '          ,C.CORPBILLPLANID                    ' +
      '          ,C.CORPCONNSTARTID                    ' +
      '          ,C.CORPCONNENDID                    ' +
      '          ,C.BEN                    ' +
      '          ,C.ADDOPTION                    ' +
      '          ,c.id                    ' +
      '                      ,C.ISTRANSFERNUMBER                        ' +
      '    FROM CONTRACTS C                        ' +
      '        ,CUSTOMER_PERSON CP                    ' +
      '        ,L_DOCTYPES DT                    ' +
      '        ,CONNECTIONS CON                    ' +
      '    WHERE c.CODE = :PCODE                        ' +
      '      and  c.id = cp.contractsid                        ' +
      '      AND DT.ID = CP.DOCTYPESID                        ' +
      '      AND C.ID = CON.ContractsID                        '
      ;
  end;

var
  cr : TCursor;
  vStartNum, vEndNum : integer;
  vPrintDir : string;
  vEXEPath : string;
begin
  try
    cr := Screen.Cursor;
    Screen.Cursor := crHourGlass;
    try
      // ���� �� ������ ������� ��� ��������(����� 'PrintTemp' � �������� � exe-������), �� �������
      if not DirectoryExists('PrintTemp') then
        CreateDir('PrintTemp');

      vEXEPath := ExtractFilePath(Application.ExeName);
      vPrintDir := vEXEPath + 'PrintTemp';

      // ���� ������ ��������� �� ��������� ��������� �������
      if rb1.Checked then
      begin
        try
          vStartNum := StrToInt(edt3.Text);
          vEndNum := StrToInt(edt4.Text);
        except
          on e : Exception do
          begin
            MessageDlg('������� ���������� �������� ��������� ������� ���������� ��� ������.'#13#10 , mtWarning, [mbOK], 0);
            edt3.SetFocus;
            Exit;
          end;
        end;

        if ((vStartNum>0) and (vEndNum>0) and (vEndNum >= vStartNum)) then
        begin
          // ������ ��� qryContractListInterval ����� �������, � ����� � ���������� ������ ������ ��� ����������� DOL
          UPDATE_SQL_TEXT;

          qryContractListInterval.Close;
          qryContractListInterval.Parameters.ParamByName('pStartNum').Value := StrToInt(edt3.Text);
          qryContractListInterval.Parameters.ParamByName('pEndNum').Value := StrToInt(edt4.Text);
          qryContractListInterval.Open;

          while not qryContractListInterval.Eof do
          begin
            PrintDOLContract(qryContractListInterval.FieldByName('code').AsString, vPrintDir );
            qryContractListInterval.Next;
          end;

          qryContractListInterval.Close;
        end
        else
        begin
          MessageDlg('������� ���������� �������� ��������� ������� ���������� ��� ������.'#13#10 , mtWarning, [mbOK], 0);
        end;
      end

      // ���� ������� ������ ��� ����������� �� ����� �������
      else
      begin
        //  ��������� �� ���� ������� � � ���� ��� ������ ��� �������� - �������� �������
        qData.First;
        while not qData.Eof do
        begin      
          if qData.FieldByName('ERROR_TEXT').AsString = '������� ���������' then // ����� ���� �������������� � ������ �������. ����� �� �����������
          begin
            PrintDOLContract( qData.FieldByName('CONTRACT_NUM').AsString, vPrintDir);
          end;
          qData.Next;
        end;
      end;

    except
      on e : Exception  do
      begin
        MessageDlg('������ ��� ������ ��������.'#13#10 + e.Message, mtError, [mbOK], 0);
      end;
    end;
  finally
    Screen.Cursor := cr;
  end;
end;

function TMainFrm.DoOpenFile(const pFileName : String) : boolean;
begin
  Result := False;
  if not FileExists(pFileName) then
    MessageDlg('�� �������� ��������� ���� "'+pFileName+'". ���� �� ����������.', mtError, [mbOK], 0)
  else
  begin
    if DoLoadDataFromExcel(pFileName) then
    begin
      //FillDetails;
      //DoShowErrors;
      //qDetails.IndexFieldNames := 'NUM';
      grdLoadedContractList.Columns.Items[0].SortOrder := soAsc;
      grdLoadedContractList.Columns.Items[0].SortSequence := 1;
      //qDetails.First;
      // ���� ��������� ����� ���� � �����, �� �������� ����������
      lblLoadedDOL.Caption := '0';
      lblLoadedContract.Caption := '0';
      lblERROR_COUNT.Caption := '0';
      Result := True;
    end;
  end;
end;

{
procedure TLoadDataFrm.FillDetails;
var i : Integer;
    vRowName : String;
begin
  begin
    if not qDetails.Active then
      qDetails.Open
    else
    begin
       if qDetails.RecordCount > 0 then
         vRowName := qDetails.FieldByName('NAME').AsString;
    end;

    qDetails.DisableControls;
    try
      qDetails.First;
      while not qDetails.Eof do
        qDetails.Delete;

      if qData.Active then
      begin
        try
          //for i := 0 to qData.FieldCount-1 do
          for i := 0 to grData.Columns.Count-1 do
          begin
            //if qData.Fields[i].AsString <> '' then
            begin
              qDetails.Insert;
              qDetails.FieldByName('NUM').AsInteger := i+1;
              qDetails.FieldByName('NAME').Value := grData.Columns[i].Field.DisplayLabel;
              qDetails.FieldByName('VALUE').Value := grData.Columns[i].Field.AsString;
              qDetails.Post;
            end;
          end;
          if vRowName <> '' then
            qDetails.Locate('NAME', vRowName, [])
          else
            qDetails.First
        except
          on e : exception do
            MessageDlg('������.'#13#10+e.Message, mtError, [mbOK], 0);
        end;
      end;
    finally
      qDetails.EnableControls;
    end;
  end;
end;
}

procedure TMainFrm.Excel2TSV(const InStream: TStream;
  //OutTexts: TPreProcessorResult;
  OutTexts : TStringList;
  const FileName : string;
//  const LoadingLog : IMTLoadingLog;
  IsExcelFile : boolean = false
  );
const
  ExcelSignature = $CFD0;
var
  DataStr : string;
  s : String;
  TestData : Word;
  FormatFlag : Boolean;
  xlBook : TExcelFile;
  ARow, ACol : integer;
  ColCount : integer;
  RowCount : integer;
  PageIndex : integer;
  ResultBuf : TBufferedString;
  MergeCellRange : TXlsCellRange;
  f: TFlxFormat;
  SheetCount: Integer;
  FullRowCount: Integer;
  tmpIsExselFile: boolean;
begin
  InStream.Position := 0;
  tmpIsExselFile := False;
  if IsExcelFile then
    tmpIsExselFile := True
  else
    if SizeOf(TestData) = InStream.Read(TestData, SizeOf(TestData)) then
      if TestData = ExcelSignature then
        begin
          InStream.Position := 0;
          //if OleDocumentTypeIs(InStream, 'Workbook') then
          //  tmpIsExselFile := True;
          //�������, ����� �� �� ������� ����, ���� �� �� ���� excel
          xlBook := TXlsFile.Create(false);
          try
            try
              //xlBook.Open(InStream);
              xlBook.Open(InStream, TFileFormats.Automatic, ' ', 1, 1, nil, TEncoding.GetEncoding(1251), false);
              tmpIsExselFile := true;
            except on ex :EFlexCelXlsAdapterException do
              tmpIsExselFile := False;
            end;
          finally
            FreeAndNil(xlBook);
          end;
        end;

  if tmpIsExselFile then
    begin
      InStream.Position := 0;
      xlBook := TXlsFile.Create(false);
      try
        try
          //xlBook.Open(InStream);
          xlBook.Open(InStream, TFileFormats.Automatic, ' ', 1, 1, nil, TEncoding.GetEncoding(1251), false);
          FormatFlag := True;
        except
          FormatFlag := False;
        end;
        if FormatFlag then
          begin
            ResultBuf := TBufferedString.Create;
            try
              SheetCount := xlBook.SheetCount;
              for PageIndex := 0 to SheetCount-1 do
                begin
                  xlBook.ActiveSheet := PageIndex + 1; // 1-based
                  if xlBook.SheetVisible = TXlsSheetVisible(2) then
                    begin
                      ResultBuf.Append(xlBook.SheetName);
                      if FileName <> '' then
                        begin
                          ResultBuf.Append(' / ');
                          ResultBuf.Append(ExtractFileName(FileName));
                        end;
                      ResultBuf.Append(#13#10);
                      RowCount := xlBook.GetRowCount(xlBook.ActiveSheet);//�������� ���������� ������������ �����
                      for ARow := 1 to RowCount {TFlxConsts.Max_Rows} do // ��������� � 1, ������� ������ - ����� ��������
                        begin
//                          if LoadingLog <> nil then
//                            begin
//                              FullRowCount := SheetCount * 50;
//                              LoadingLog.SetLoadingPercent(FullRowCount, PageIndex*50+(ARow*50 div RowCount));
//                              if LoadingLog.Breaked then
//                                Break;
//                            end;
                          ColCount := xlBook.ColFromIndex(ARow, xlBook.ColCountInRow(ARow));
                          for ACol := 1 to ColCount do // ��������� � 1, ������� ������� - ������ �����
                            begin
                              // ���� ������ �� ����������� ��� ������ � �����������
                              MergeCellRange := xlBook.CellMergedBounds(ARow, ACol);
                              if (ACol = MergeCellRange.Left) and (ARow = MergeCellRange.Top) then
                              begin
                                f := xlBook.GetCellVisibleFormatDef(ARow, ACol);
                                if f.Format <> '' then
                                  s := xlBook.GetStringFromCell(ARow, ACol)
                                else
                                  begin
                                    s := (xlBook.GetCellValue(ARow, ACol)).ToString;
                                    if AnsiPos('E', s) > 0 then
                                      begin
                                        try
                                          s := Trim(s);
                                          s := FloatToStrF(xlBook.GetCellValue(ARow, ACol).AsNumber, ffFixed, StrToInt(Copy(s, AnsiPos('E', s) + 1, length (s) - (AnsiPos('E', s)))) + 3, 0);
                                        except
                                          s := (xlBook.GetCellValue(ARow, ACol)).ToString;
                                        end;
                                      end;

                                  end;
                                ResultBuf.Append(s);
                              end;
                              if ACol <> ColCount then
                                ResultBuf.Append(#9);
                            end;
                          ResultBuf.Append(#13#10);
                        end;
                    end;
//                  if LoadingLog <> nil then
//                    if LoadingLog.Breaked then
//                      Break;
                end;
              DataStr := ResultBuf.ToString;
                if DataStr <> '' then
                  OutTexts.Add(DataStr);
            finally
              FreeAndNil(ResultBuf);
            end;
          end;
      finally
        FreeAndNil(xlBook);
      end;
    end;
  InStream.Position := 0;
end;

function TMainFrm.DoLoadDataFromExcel(const pFileName: String) : boolean;
var StreamAdapter : TStreamAdapter;
    FileStream : TFileStream;
    //ExcelParser : OleVariant;
    //ParsedArray : OleVariant;
    ExcelStream : TStream;
    ParsedArray : TStringList;
    ExcelText : WideString;
    vOldCursor : TCursor;
begin
  Result := False;
  try
    FReadData := True;

    vOldCursor := Screen.Cursor;
    Screen.Cursor := crHourGlass;
    try
      FileStream := TFileStream.Create(pFileName, fmOpenRead);
    finally
      Screen.Cursor := vOldCursor;
    end;

    try
      StreamAdapter := TStreamAdapter.Create(FileStream, soReference);
      try
//        ExcelParser := CreateOleObject('TariferPreProcessor.PreProcessExcelFull');
        //Excel2TSV(ExcelParser);
        try
          ExcelStream := StreamAdapter.Stream;
          ParsedArray := TStringList.Create;
          Excel2TSV(ExcelStream, ParsedArray, '');
          try
            //if not VarIsArray(ParsedArray) then
            if ParsedArray.Count = 0 then
              MessageDlg('������������ ������ �����  "'+pFileName+'".', mtError, [mbOK], 0)
//            else if (VarArrayHighBound(ParsedArray, 1) - VarArrayLowBound(ParsedArray, 1)) < 0 then
//              MessageDlg('������������ ������ �����  "'+pFileName+'".', mtError, [mbOK], 0)
            else
            begin
              ExcelText := ParsedArray.Text;
              DoLoadDataFromText(ExcelText);
              //MessageDlg(ExcelText, mtError, [mbOK], 0)
              Result := True;
            end;
          finally
            //ParsedArray := Nil;
            //FreeAndNil(ParsedArray);
            ;
          end;
        finally
          //ExcelParser := Nil;
          //FreeAndNil(ExcelParser);
          ;
        end;
      finally
        //StreamAdapter := Nil;
        //FreeAndNil(StreamAdapter);
        //StreamAdapter.Free;
      end;
    finally
      FileStream.Free;
      FReadData := False;
    end;
  except
    on e : exception do
      MessageDlg('������ ��� �������� ����� "'+pFileName+'".'#13#10+e.Message, mtError, [mbOK], 0);
  end;
end;

procedure TMainFrm.DoLoadDataFromText(const pStr: String);
var vStringList : TStringList;
    vFindColumnNames : boolean;
    i : Integer;
    vCheckNecessaryFields : boolean;
    vErrorMessage : String;
    vOldCursor : TCursor;
    vTotalRows : Integer;
    vErrorRows : Integer;
begin
  vErrorRows := 0;
  vTotalRows := 0;

  vOldCursor := Screen.Cursor;
  Screen.Cursor := crHourGlass;
  try
    if qData.Active then
    begin
      qData.First;
      while not qData.Eof do
        qData.Delete;
    end;

    vFindColumnNames := False;
    vStringList := TStringList.Create();
    try
      vStringList.Text := pStr;
      for i := 0 to vStringList.Count-1 do
      begin
        // ���� �� ����� ������ � ������� �������, ���� � ����
        //    ���� ���� ��� �����, �� ���� ��� �������, �� ������������� ������ �������
        if not vFindColumnNames or (Pos(#9'�������'#9, vStringList[i]) > 0) then
        begin
          // ���� ���� ����� ������, ������ ������� ��� ������ � ������� �������
          if Pos(#9'�������'#9, vStringList[i]) > 0 then
          begin
            FillColumnNames(vStringList[i]);
            vCheckNecessaryFields := CheckNecessaryFields(vErrorMessage);
            if not vCheckNecessaryFields then
            begin
              MessageDlg(vErrorMessage, mtError, [mbOK], 0);
              vFindColumnNames := False;
            end
            else
              vFindColumnNames := True;
          end;
        end
        else // ���� ����� ������ � ������� �������
        begin
          if AddRowFromStr(vStringList[i]) then
          begin
            vTotalRows := vTotalRows + 1;
            //if qData.FieldByName('ERROR_TEXT').AsString <> '' then
            //  vErrorRows := vErrorRows + 1;
          end;
        end;
      end;
      if qData.Active then
        qData.First;
    finally
      vStringList.Free;
    end;
  finally
    Screen.Cursor := vOldCursor;
  end;
  if vTotalRows = 0 then
    MessageDlg('� �������� ����� �� ���������� �� ������ ���������.', mtError, [mbOK], 0)
  else
  begin
    if vErrorRows > 0 then
      MessageDlg('� �������� ����� ���������� '+IntToStr(vTotalRows)+' ����������,'#13#10+' �� ��� ���������� � �������� '+IntToStr(vErrorRows)+'.', mtWarning, [mbOK], 0)
    //else
    //  MessageDlg('� �������� ����� ���������� '+IntToStr(vTotalRows)+' ����������.'#13#10+' ������ �� ����������.', mtInformation, [mbOK], 0)
      ;
  end;
end;

// ��������� ������ ������� ������� aColumnNumbers
procedure TMainFrm.FillColumnNames(const pStr : String);
var vStringList : TStringList;
    i, j : Integer;
begin
  vStringList := TStringList.Create();
  try
    vStringList.Text := StringReplace(pStr, #9, #13#10,[rfReplaceAll, rfIgnoreCase]);
    for i := 0 to vStringList.Count-1 do
    begin
      for j := 1 to vColumnCount do
      begin
        if Trim(AnsiUpperCase(vStringList.Strings[i])) = Trim(AnsiUpperCase(aColumnNames[j])) then
        begin
          aColumnNumbers[j] := i;
        end;
      end;
    end;
  finally
    vStringList.Free;
  end;
end;

procedure TMainFrm.FormCreate(Sender: TObject);
begin
  rb2.Checked := True;
end;

procedure TMainFrm.HTTPRIO1AfterExecute(const MethodName: string;
  SOAPResponse: TStream);
var
  stl : TStringList;
  resp : string;
  i : integer;
begin
  stl := TStringList.Create;
  stl.LoadFromStream(SOAPResponse);
  i := 0;
  {//mmo1.Clear;
  while i < stl.Count do
  begin
    mmo1.Lines.Add(stl.Strings[i]);
    i := i + 1;
  end
  };
end;

procedure TMainFrm.HTTPRIO1BeforeExecute(const MethodName: string;
  SOAPRequest: TStream);
var
  stl : TStringList;
  resp : string;
  i : integer;
  v :string;
begin
  stl := TStringList.Create;
  //v := HTTPReqResp.SoapAction;
  stl.LoadFromStream(SOAPRequest);
  i := 0;
  //mmo1.Clear;
  {while i < stl.Count do
  begin
    mmo1.Lines.Add(stl.Strings[i]);
    i := i + 1;
  end;
  }
end;

procedure TMainFrm.HTTPRIO1HTTPWebNode1BeforePost(
  const HTTPReqResp: THTTPReqResp; Data: Pointer);
var
  stl : TStringList;
  resp : string;
  i : integer;
  v :string;
  h : THTTPReqResp;
begin
  stl := TStringList.Create;
  v := HTTPReqResp.SoapAction;
  v := HTTPRIO1.ToString;
  i := 0;
  {//mmo1.Clear;
  while i < stl.Count do
  begin
    mmo1.Lines.Add(stl.Strings[i]);
    i := i + 1;
  end;
  }
end;

function TMainFrm.IdSSLIOHandlerSocketOpenSSL1VerifyPeer(Certificate: TIdX509;
  AOk: Boolean; ADepth, AError: Integer): Boolean;
begin
  Result := True;
end;

// ���������, ���� �� ������������ ������� � ����������� �����
//   (������ ����������� ������� ������ ���� ��� ��������� � ������� aColumnNumbers)
function TMainFrm.CheckNecessaryFields(var pErrorMessage : String) : boolean;
  // ��� ������������� ���� � ������� aFieldNames
  function GetFieldIndex(const pFieldName : String) : Integer;
  var i : Integer;
  begin
    Result := 0;
    for i := 1 to vColumnCount do
    begin
      if aFieldNames[i] = pFieldName then
        Result := i;
    end;
  end;
var i, j : Integer;
begin
  pErrorMessage := '';
  for i := 1 to aNecessaryFieldsCount do
  begin
    // ��� ������������� ���� � ������� aFieldNames � aColumnNames
    j := GetFieldIndex(aNecessaryFields[i]);
    //
    if j < 1 then
      MessageDlg('���������� ������. ������������ ���� "'+aNecessaryFields[i]+'" �� ������� � ������ ����� ��� ��������.', mtError, [mbOK], 0)
    else if aColumnNumbers[j] < 1 then
      pErrorMessage := pErrorMessage + #13#10 + aColumnNames[j];
  end;
  Result := (pErrorMessage = '');
  if pErrorMessage <> '' then
  begin
    pErrorMessage := '������ ��������.'#13#10'� ����������� ����� ����������� ������������ ���� :'+ pErrorMessage+'.';
  end
end;

// �������� ������ � Dataset �� ������
function TMainFrm.AddRowFromStr(const pStr : String) : boolean;
var vStringList : TStringList;
    j : Integer;
    vErrorCount : Integer;
    vErrorStr : String;
begin
  Result := False;

  if not qData.Active then
    qData.Open;
  //qData.Insert;
  qData.Append;
  try
    vStringList := TStringList.Create();
    try
      vStringList.Text := StringReplace(pStr, #9, #13#10, [rfReplaceAll, rfIgnoreCase]);
      for j := 1 to vColumnCount do
      begin
        if (aColumnNumbers[j] > 0) and (aColumnNumbers[j] < vStringList.Count) then
        begin
          qData.FieldByName(aFieldNames[j]).Value := vStringList[aColumnNumbers[j]];
        end;
      end;
    finally
      vStringList.Free;
    end;
  finally
    // ������ ������ �� ���������
    if CurrentRowEmpty then
      qData.Cancel
    else
    begin
      // ��������� ���������������� ����
      //FillAdditionalFields;

      // ��������� �������� � ��������� ����
//      if not CheckCurrentDocum(vErrorCount, vErrorStr) then
//      begin
//        qData.FieldByName('ERROR_TEXT').AsString :=
//          '������ ('+IntToStr(vErrorCount)+') :'#13#10+ vErrorStr;
//      end;

      qData.Post;
      Result := True;
    end;
  end;
end;

// ������� ������ �� ���������
function TMainFrm.CurrentRowEmpty : boolean;
var vDataExists : boolean;
    i : Integer;
begin
  vDataExists := False;
  if qData.Active then
  begin
    for i := 0 to qData.FieldCount-1 do
      vDataExists := vDataExists or (VarToStr(qData.Fields[i].Value) <> '');
  end;
  Result := not vDataExists;
end;

end.
