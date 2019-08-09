unit Nathan.Factory;

interface

uses
  System.Generics.Collections,
  System.SysUtils,
  System.Rtti;

{$M+}

type
  IDummy = interface
    ['{E78A70A7-92FD-42A0-A65A-9A0767D5216A}']
    procedure Dosomething();
  end;

  TThurnreiterDummy = class(TInterfacedObject, IDummy)
  public
    procedure DoSomething();
  end;

  TNathanFactory = class abstract
  strict private
    class var FListOfRegClasses: TDictionary<string, TClass>;
  private
    class constructor Create();
    class destructor Destroy();
  public
    class procedure RegisteringClass(const AClassname: string; AClass: TClass); static;

    class function GetInstance(const AClassname: string): IDummy; static;
  end;

{$M-}

implementation

{ TThurnreiterDummy }

procedure TThurnreiterDummy.DoSomething();
begin
  Writeln('TThurnreiterDummy.DoSomething()');
end;

{ TNathanFactory }

class constructor TNathanFactory.Create();
begin
  FListOfRegClasses := TDictionary<string, TClass>.Create;
end;

class destructor TNathanFactory.Destroy();
begin
  FListOfRegClasses.Free;
end;

class procedure TNathanFactory.RegisteringClass(const AClassname: string; AClass: TClass);
begin
  if (not Supports(AClass, IDummy)) then
    raise ENotSupportedException.CreateFmt('Class %s not registered, not implmentation found.', [AClass.ClassName]);

  FListOfRegClasses.AddOrSetValue(AClassname.ToLower, AClass);
end;

class function TNathanFactory.GetInstance(const AClassname: string): IDummy;
var
  TheClass: TClass;
  TheInstance: TObject;
  dummy: IDummy;
  Value: TValue;
  RCtx: TRttiContext;
  AType: TRttiType;
  RMethod: TRttiMethod;
  RParam: TRttiParameter;
  ConstructorParams: TList<TValue>;
begin
  if not FListOfRegClasses.TryGetValue(AClassname.ToLower, TheClass) then
    Exit(nil);

  RCtx := TRttiContext.Create;
  try
    AType := RCtx.GetType(TheClass);
    for RMethod in AType.GetMethods do
    begin
      if RMethod.IsConstructor then
      begin
        ConstructorParams := TList<TValue>.Create;
        try
          for RParam in RMethod.GetParameters do
          begin
            TValue.Make(0, RParam.ParamType.Handle, Value);
            ConstructorParams.Add(Value);
          end;

          TheInstance := RMethod.Invoke(TheClass, ConstructorParams.ToArray).AsObject;
          Supports(TheInstance, IDummy, dummy);
          Result := dummy;
        finally
          ConstructorParams.Free;
        end;

        Break;
      end;
    end;
  finally
    RCtx.Free;
  end;
end;

initialization
  TNathanFactory.RegisteringClass('Thurnreiter', TThurnreiterDummy);

end.
