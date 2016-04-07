unit RefFilials;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, TemplateFrm, ActnList, Menus, DB, MemDS, DBAccess, Ora, Grids,
  DBGrids, CRGrid, ComCtrls, ToolWin, ExtCtrls;

type
  TRefFilialsForm = class(TTemplateForm)
    procedure qMainBeforePost(DataSet: TDataSet);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

procedure TRefFilialsForm.qMainBeforePost(DataSet: TDataSet);
begin
  if DataSet.FieldByName('FILIAL_NAME').IsNull then
  begin
    MessageDlg('������������ ������ ���� ���������', mtError, [mbOK], 0);
    Abort;
  end;
  // ������ ����� ������ ��� ��� ��������� ������ ID
  inherited;
end;

end.
