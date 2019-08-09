unit Nathan.Generic.Factory;

interface

uses
  System.Generics.Collections,
  System.SysUtils,
  System.TypInfo,
  System.Rtti;

{$M+}

type
  //  TThurnreiterFactory<T: iinterface> = class abstract
  TThurnreiterFactory<T: class> = class abstract
  strict private
    class var FMapClasses: TDictionary<string, TClass>;
  private
    class constructor Create();
    class destructor Destroy();
  public
    class procedure RegisteringClass(const AClassname: string); static;

    class function GetInstance(const AClassname: string): T; static;
  end;

{$M-}

implementation

{ TThurnreiterFactory<T> }

class constructor TThurnreiterFactory<T>.Create();
begin
  FMapClasses := TDictionary<string, TClass>.Create;
end;

class destructor TThurnreiterFactory<T>.Destroy();
begin
  FMapClasses.Free;
end;

class procedure TThurnreiterFactory<T>.RegisteringClass(const AClassname: string);
begin
//  if (not Supports(AClass, GetTypeData(TypeInfo(T))^.GUID)) then
//  if (not Supports(AClass, TypeInfo(T)) then
//    raise ENotSupportedException.CreateFmt('Class %s not registered, not implmentation found.', [AClass.ClassName]);

  FMapClasses.AddOrSetValue(AClassname.ToLower, T);
end;

class function TThurnreiterFactory<T>.GetInstance(const AClassname: string): T;
var
  ImplClass: TClass; //  IInterface;
  ImplInstance: TValue; // TObject;
  Value: TValue;
  RCtx: TRttiContext;
  AType: TRttiType;
  RMethod: TRttiMethod;
  RParam: TRttiParameter;
  ConstructorParams: TList<TValue>;
begin
  if not FMapClasses.TryGetValue(AClassname.ToLower, ImplClass) then
    Exit(T(nil));

  RCtx := TRttiContext.Create;
  try
    AType := RCtx.GetType(ImplClass);
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

          ImplInstance := RMethod.Invoke(ImplClass, ConstructorParams.ToArray);
          Result := ImplInstance.AsType<T>;
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

end.
