program CNParser;

uses
  Forms,
  MainUnit in 'MainUnit.pas' {fmMain};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := '������ � ������ �������';
  Application.CreateForm(TfmMain, fmMain);
  Application.Run;
end.
