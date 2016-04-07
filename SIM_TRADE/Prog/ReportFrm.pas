unit ReportFrm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.Grids,
  Vcl.DBGrids, CRGrid, Vcl.ExtCtrls, Data.DB, MemDS, DBAccess, Ora, Vcl.ActnList;

type
  TReportForm = class(TForm)
    pButtons: TPanel;
    pGrid: TPanel;
    gReport: TCRDBGrid;
    btRefresh: TBitBtn;
    btLoadInExcel: TBitBtn;
    qReport: TOraQuery;
    dsReport: TDataSource;
    aList: TActionList;
    aRefresh: TAction;
    aLoadInExcel: TAction;
    procedure aRefreshExecute(Sender: TObject);
    procedure aLoadInExcelExecute(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ReportForm: TReportForm;

implementation

{$R *.dfm}

uses IntecExportGrid;

//�������� � Excel
procedure TReportForm.aRefreshExecute(Sender: TObject);
begin
  qReport.Close;
  qReport.Open;
end;

//��������� ������
procedure TReportForm.aLoadInExcelExecute(Sender: TObject);
begin
  //�������� � Excel
end;

end.
