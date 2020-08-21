// http://ins911.blogspot.com/2008/12/singletone-delphi.html
// http://cyber-code.ru/shablon-programmirovaniya-singleton-v-delphi/
// https://www.gunsmoker.ru/2011/04/blog-post.html

unit SingletonTemplate;

interface

type
  // ������� ����� ��� ��������, ����������� ������ "Singleton".
  // ��� ��������� ������� � ���������� ���������� ������� GetInstance.
  // ���� ��������� ��� �� ����������, �� �� ����� ������.
  // ����� - ���������� ������ �� ����� ��������� ���������.
  // ���������� ��������� ����� �������, ������ Free, �����
  // �� ����� ��������� ������������� ����� ����������� ����������.
  TSingleton = class(TObject)
  private
    class procedure RegisterInstance(aInstance: TSingleton);
    procedure UnRegisterInstance;
    class function FindInstance: TSingleton;
  protected
    // ������������� ����������� ������ � ���� ������������, � �� � GetInstance.
    // �� ������������� �������� ���� ����������� �� ������ protected
    constructor Create(_dummy: Integer = 0); virtual;
  public
    class function NewInstance: TObject; override;
    procedure BeforeDestruction; override;
    // ����� ������� � ����������
    constructor GetInstance;
  end;


implementation

uses
  System.Classes, System.Types, System.Contnrs;

var
  SingletonList: TObjectList;


{ TSingleton }

constructor TSingleton.Create(_dummy: Integer);
begin
  inherited Create;
end;

class procedure TSingleton.RegisterInstance(aInstance: TSingleton);
begin
  SingletonList.Add(aInstance);
end;

procedure TSingleton.UnRegisterInstance;
begin
  SingletonList.Extract(Self);
end;

class function TSingleton.FindInstance: TSingleton;
var
  i: integer;
begin
  Result := nil;
  for i := 0 to SingletonList.Count - 1 do
    if SingletonList[i].ClassType = Self then
    begin
      Result := TSingleton(SingletonList[i]);
      Break;
    end;
end;

class function TSingleton.NewInstance: TObject;
begin
  Result := FindInstance;
  if Result = nil then
  begin
    Result := inherited NewInstance;
    TSingleton(Result).Create;
    RegisterInstance(TSingleton(Result));
  end;
end;

procedure TSingleton.BeforeDestruction;
begin
  UnregisterInstance;
  inherited BeforeDestruction;
end;

constructor TSingleton.GetInstance;
begin
  inherited Create;
end;


initialization
  SingletonList := TObjectList.Create(True);

finalization
  SingletonList.Free;



end.
