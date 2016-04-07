// ������ ������������ ��� ������������ ������������ ������
// (����������� ���������) � �����������.
//
// ��� ����������� ������������ ������������ ������������
// ������� <LINK RegisterHintEvent@TShowHintEvent@TControl, RegisterHintEvent><LINK RegisterHintEvent@TShowHintEvent@TControl, .>
//
// ��� �������� ������������������� ����������� �� ������
// �������� ������������ ������������ ������� <LINK UnregisterHintEvent@TControl, UnregisterHintEvent><LINK UnregisterHintEvent@TControl, .>
//
// <LINK UnregisterHintEvent@TControl>
unit Hints;
interface
uses Forms, Controls, AppEvnts;

// ������������ ���������� ����� ��� �������� ����������.
// 
// ���� � ������� ���������� ��������� ����, �� �������������
// ����� ������ ������������������ ����������.
// 
// ����� ������� ������������� ������ � ����������� �������
// ����� OnCreate.
// 
// ��� ������ ����������� ���������� ������������ <LINK UnregisterHintEvent@TControl, UnregisterHintEvent>.
//                                                                                                         
procedure RegisterHintEvent(HintEvent : TShowHintEvent;
  HintControl : TControl);

// �������� ����������� ����������� ����� ��� ��������
// ����������.
// 
// ����� ������� ������������� ������ � ����������� �������
// ����� OnDestroy.
// 
// ��. ����� <LINK RegisterHintEvent@TShowHintEvent@TControl, RegisterHintEvent>.
//
procedure UnregisterHintEvent(HintControl : TControl);

implementation

uses Classes;

type

// ��������� ������ ���������� �� ����������� �����.
THintEventInfo = class
    // ��������� �� �����, ������� �������� ������������ �������
// ����������� ���������.
HintEvent : TShowHintEvent;
    // ������ �� ������-TControl, ��� �������� ���������������
// ���������� ����������� ���������.
HintControl : TControl;
  end;

  // ��������� ������, ������� ������ ������ �������� ������������
  // ������.
  //
  // ������ �������������� ���������� Application.OnShowHint,
  // ������� ���� ���������� ������ �������������� ���-���� ��� �
  // ����������.
THintHandler = class
    // ������ ������������������ ������������.
ClientHandlersList : TList;

{ ���������� ������� �� ���������� }
FApplicationEvents : TApplicationEvents;
    // �����������
constructor Create;
    // ����������
destructor Destroy; override;

    { ���������� ��� Application.OnShowHint.
      
      
      
      �������� ����� � ����� ������������������� ����������� ���
      ����������� �������, �� ������� ��������� �����������
      ���������.
      
      
      
      ���� ���������� �� ���������, �� ���������� ����������
      ���������� Application.OnShowHint (���� �� ����).          }
procedure ShowHintHandler(var HintStr : string;
      var CanShow : Boolean;
      var HintInfo : THintInfo);
    // ������� ���������� ���������� ����������� ��������� ���
// ����������� �������.
// 
// 
// 
// ���� ������ �� ������, �� ������� ���������� <B>nil</B>.
function FindHandler(HintControl : TControl) : THintEventInfo;
  end;

var
  { ����������, ������� �������� ������ �� ������, ��������������
  ������� ����������� ���������.                                }
HintHandler : THintHandler;

constructor THintHandler.Create;
begin
  inherited Create;
  ClientHandlersList := TList.Create;
  FApplicationEvents := TApplicationEvents.Create(nil);
  FApplicationEvents.OnShowHint := ShowHintHandler;
end;

destructor THintHandler.Destroy;
begin
  ClientHandlersList.Free;
  FApplicationEvents.Free;
  inherited;
end;

procedure THintHandler.ShowHintHandler(var HintStr : string;
  var CanShow : Boolean;
  var HintInfo : THintInfo);
var
  i : integer;
  CurrentHintEventInfo : THintEventInfo;
begin
  for i := 0 to ClientHandlersList.Count - 1 do
  begin
    CurrentHintEventInfo := THintEventInfo(ClientHandlersList[i]);
    if HintInfo.HintControl = CurrentHintEventInfo.HintControl then
    begin
      begin
        CurrentHintEventInfo.HintEvent(HintStr, CanShow, HintInfo);
        // �������� ���������� ���������
        FApplicationEvents.CancelDispatch;
        Break;
      end;
    end;
  end;
end;

function THintHandler.FindHandler(HintControl : TControl) : THintEventInfo;
var
  CurrentHintEventInfo : THintEventInfo;
  i : integer;
begin
  Result := nil;
  for i := 0 to ClientHandlersList.Count - 1 do
  begin
    CurrentHintEventInfo := THintEventInfo(ClientHandlersList[i]);
    if CurrentHintEventInfo.HintControl = HintControl then
    begin
      Result := CurrentHintEventInfo;
      Break;
    end;
  end;
end;

procedure RegisterHintEvent(HintEvent : TShowHintEvent;
  HintControl : TControl);
var
  HintEventInfo : THintEventInfo;
begin
  if Assigned(HintHandler) then
  begin
    HintEventInfo := HintHandler.FindHandler(HintControl);
    if HintEventInfo = nil then
    begin
      HintEventInfo := THintEventInfo.Create;
      HintEventInfo.HintControl := HintControl;
      HintHandler.ClientHandlersList.Add(HintEventInfo);
    end;
    HintEventInfo.HintEvent := HintEvent;
  end;
end;

procedure UnregisterHintEvent(HintControl : TControl);
var
  HintEventInfo : THintEventInfo;
begin
  if Assigned(HintHandler) then
  begin
    HintEventInfo := HintHandler.FindHandler(HintControl);
    if HintEventInfo <> nil then
    begin
      HintHandler.ClientHandlersList.Delete(
        HintHandler.ClientHandlersList.IndexOf(HintEventInfo));
      HintEventInfo.Free;
    end;
  end;
end;

initialization
  HintHandler := THintHandler.Create;
finalization
  HintHandler.Free;
  HintHandler := nil;
end.

