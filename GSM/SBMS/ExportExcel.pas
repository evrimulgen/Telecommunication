unit ExportExcel;
interface

uses DBGrids,Windows, Messages,SysUtils,VCL.FlexCel.Core, FlexCel.XlsAdapter,
Forms,FlexCel.Render, FlexCel.Pdf,ToolWin,IOUtils,  Ora, ADODB, ComObj, OleCtrls,
Variants, Classes, Graphics,Controls, StdCtrls,CRGrid,ShellAPI,dialogs;

  procedure Excel(ADOQuery: TADOQuery; DBGrid: TDBGrid; XLApp: Variant; ExpExcel: string);

implementation
uses DB, Math;

procedure Excel(ADOQuery: TADOQuery; DBGrid: TDBGrid; XLApp: Variant; ExpExcel: string);
var
// XLApp,
 Sheet,Colum:Variant;
 index,i,j:Integer;
begin
 XLApp:= CreateOleObject('Excel.Application');

 XLApp.Visible:=false;
 Try
  XLApp.Workbooks.open(ExpExcel);
 Except
  XLApp.Workbooks.Add(-4167);
 end;

 Colum:=XLApp.Workbooks[1].WorkSheets[1].Columns;
 Colum.Columns[1].ColumnWidth:=50;
 Colum.Columns[2].ColumnWidth:=20;
 Colum:=XLApp.Workbooks[1].WorkSheets[1].Rows;
 Colum.Rows[2].Font.Bold:=true;
 Colum.Rows[1].Font.Bold:=true;
 Colum.Rows[1].Font.Color:=clBlue;
 Colum.Rows[1].Font.Size:=12;
 Sheet:=XLApp.Workbooks[1].WorkSheets[1];
 //Sheet.Cells[1,1]:=IntToStr(DBGrid.SelectedRows.Count);
 //Sheet.Cells[1,2]:='���������';
 Sheet.Cells[2,1]:='���� ����';
 Sheet.Cells[2,2]:='���� �����';
 Sheet.Cells[2,3]:='���� ���';
 Sheet.Cells[2,4]:='���. ����';
 Sheet.Cells[2,5]:='�������';
 Sheet.Cells[2,6]:='���';
 Sheet.Cells[2,7]:='��������';
 Sheet.Cells[2,8]:='���� �������� (����)';
 Sheet.Cells[2,9]:='���� �������� (�����)';
 Sheet.Cells[2,10]:='���� �������� (���)';
 Sheet.Cells[2,11]:='��� �';
 Sheet.Cells[2,12]:='��� �';
 Sheet.Cells[2,13]:='�������';
 Sheet.Cells[2,14]:='� �����';
 Sheet.Cells[2,15]:='� �����';
 Sheet.Cells[2,16]:='� �����';
 Sheet.Cells[2,17]:='� ���� (����)';
 Sheet.Cells[2,18]:='� ���� (�����)';
 Sheet.Cells[2,19]:='� ���� (���)';
 Sheet.Cells[2,20]:='�����';
 Sheet.Cells[2,21]:='�����';
 Sheet.Cells[2,22]:='���';
 Sheet.Cells[2,23]:='������';
 Sheet.Cells[2,24]:='��������';
 Sheet.Cells[2,25]:='������� �';
 Sheet.Cells[2,26]:='������� �';
 Sheet.Cells[2,27]:='� ���';
 Sheet.Cells[2,28]:='������ ���';
 Sheet.Cells[2,29]:='���.�����';
 Sheet.Cells[2,30]:='����';
 Sheet.Cells[2,31]:='����� ���-�����';
 Sheet.Cells[2,32]:='���. ���';
 Sheet.Cells[2,33]:='���. �����';
 Sheet.Cells[2,34]:='Puk';
 Sheet.Cells[2,35]:='����� �������';
 Sheet.Cells[2,36]:='������';
 Sheet.Cells[2,37]:='������';
 Sheet.Cells[2,38]:='� � �';
 Sheet.Cells[2,39]:='� ��������';
 Sheet.Cells[2,40]:='����� ��������';

 if XLApp.ActiveSheet.UsedRange.Rows.Count=0
 then
  index:=3
 else
  index:= XLApp.ActiveSheet.UsedRange.Rows.Count+1;


 with DBGrid.DataSource.DataSet do
 begin
  begin
   for j := 1 to 40 do
    Sheet.Cells[index,j]:=ADOQuery.Fields.Fields[j-1].AsString;
  end;
    if ADOQuery.Fields.Fields[36].AsString='V'
    then
      begin
        Sheet.Cells[index,37]:=' +';
        Sheet.Cells[index,37].interior.colorindex:=4;
      end
    else
      if ADOQuery.Fields.Fields[36].AsString='E'
      then
        begin
          Sheet.Cells[index,37]:=' -';
          Sheet.Cells[index,37].interior.colorindex:=3;
        end
      else
        begin
          Sheet.Cells[index,37]:=' ?';
          Sheet.Cells[index,37].interior.colorindex:=37;
        end;
  end;
 XLApp.DisplayAlerts := False;
 XLApp.ActiveWorkbook.SaveAs(ExpExcel);
 XLApp.DisplayAlerts := True;
 XLApp.Workbooks.Close; //�������� ����� ������
 XLApp.Quit;  //�������� ������
 XLApp:=UnAssigned;
end;

end.
