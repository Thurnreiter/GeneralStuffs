unit Ini.Config.Sample.VI;

interface

uses
  System.Generics.Collections,
  System.Rtti,
  System.TypInfo,
  Ini.Config,
  Ini.Config.Sample.Settings;

{$REGION 'Links'}
  //  http://docwiki.embarcadero.com/Libraries/Tokyo/de/System.Rtti.TVirtualInterface
  //  http://docwiki.embarcadero.com/CodeExamples/Tokyo/en/Rtti.TVirtualInterface_(Delphi)
  //  http://www.nickhodges.com/post/TVirtualInterface-Interfaces-without-an-Implementing-Class.aspx
  //  http://www.nickhodges.com/post/TVirtualInterface-A-Truly-Dynamic-and-Even-Useful-Example.aspx
  //  https://stackoverflow.com/questions/39151187/how-get-ownership-property-of-method-trttimethod-in-tvirtualinterface-tvirtua
  //  https://groups.google.com/forum/#!topic/spring4d/6Su_OqYXXnA
  //  robstechcorner.blogspot.com/2009/09/tvalue-in-depth.html
  //  https://tondrej.blogspot.com/2016/09/no-runtime-type-information-on.html
  //  https://greatisprogramming.com/delphicb/propintf/
  //  http://programmingmindstream.blogspot.com/2017/02/1347-tvirtualinterface.html
  //  https://stackoverflow.com/questions/49375338/how-to-implement-a-tvirtualinterface-thats-returns-a-custom-type
  //  https://stackoverflow.com/questions/16048832/in-delphi-xe3-how-can-i-cast-a-tvirtualinterface-object-to-its-interface-using
  //  https://www.delphipraxis.net/157067-rtti-property-setvalue.html
{$ENDREGION}

{$M+}

type
  ISampleSettingsEx = interface(IInvokable)
    ['{4A000D4D-573E-4D1D-A171-B74338DD9C0A}']
    [Setting('System', 'ConfigAddress', '1')]
    function GetConfigAddress: string;
    procedure SetConfigAddress(const value: string);

    [Setting('System', 'Client', '2')]
    function GetClient(): Integer;
    procedure SetClient(value: Integer);

    [Setting('System', 'Server', '3')]
    function GetServer(): string;
    procedure SetServer(const value: string);

    [Setting('System', 'Alias', '4')]
    function GetAlias(): string;
    procedure SetAlias(const value: string);

    procedure Load;
    procedure Save;

    property ConfigAddress: string read GetConfigAddress write SetConfigAddress;
    property Client: Integer read GetClient write SetClient;
    property Server: string read GetServer write SetServer;
    property Alias: string read GetAlias write SetAlias;
  end;


//  TSimplestVirtualInterface = class(TVirtualInterface)
//  public
//    constructor Create(PIID: PTypeInfo);
//    procedure DoInvoke(Method: TRttiMethod; const Args: TArray<TValue>; out Result: TValue);
//  end;

  TVirtualInterfaceEx<T: IInvokable> =  class(TVirtualInterface)
  protected
    procedure DoInvoke(Method: TRttiMethod; const Args: TArray<TValue>; out Result: TValue);
    procedure DoInvokeImpl(Method: TRttiMethod; const Args: TArray<TValue>; out Result: TValue); virtual; abstract;
  public
    constructor Create;
    function InternalInterface: T;
  end;

  TSettingsVIEx = class(TVirtualInterfaceEx<ISampleSettingsEx>)
  strict private
    FData: TDictionary<string, TValue>;
  protected
    procedure DoInvokeImpl(Method: TRttiMethod;  const Args: TArray<TValue>; out Result: TValue); override;
  public
    constructor Create();
    destructor Destroy; override;
  end;



  VIService = record
    class function Starting(): ISampleSettingsEx; static;
  end;

{$M-}

implementation

uses
  System.SysUtils;

{ **************************************************************************** }

{ TSimplestVirtualInterface }

//constructor TSimplestVirtualInterface.Create(PIID: PTypeInfo);
//begin
//  inherited Create(PIID, DoInvoke);
//end;
//
//procedure TSimplestVirtualInterface.DoInvoke(Method: TRttiMethod; const Args: TArray<TValue>; out Result: TValue);
//var
//  Arg: TValue;
//  ArgType, ArgName: string;
//  TempKind: TTypeKind;
//  RProp: TRttiProperty;
//begin
//  for RProp in Method.Parent.GetDeclaredProperties do
//  begin
//    ArgName := RProp.Name;
//  end;
//
//  //  WriteLn('You called a method on an interface');
//  //  Write('1. You called the [', Method.Name, '] method ');
//  if Length(Args) > 1 then
//  begin
//    //  Writeln('and it has "', Length(Args) - 1,'" parameters:');
//    for Arg in Args do
//    begin
//      TempKind := Arg.Kind;
//      if (TempKind <> tkInterface) then
//      begin
//        ArgName := Arg.ToString;
//        ArgType := Arg.TypeInfo.Name;
//        //  Writeln('  - "' + ArgName + '"', ' which is of the type ', ArgType);
//      end;
//    end;
//  end
//  else
//    //Writeln('and it has no parameters.')
//    ;
//end;

{ **************************************************************************** }

{ TVirtualInterfaceEx<T> }

constructor TVirtualInterfaceEx<T>.Create;
begin
  inherited Create(TypeInfo(T), DoInvoke);
end;

procedure TVirtualInterfaceEx<T>.DoInvoke(Method: TRttiMethod; const Args: TArray<TValue>; out Result: TValue);
begin
  DoInvokeImpl(Method, Args, Result);
end;

function TVirtualInterfaceEx<T>.InternalInterface: T;
var
  pInfo : PTypeInfo;
begin
  pInfo := TypeInfo(T);
  if QueryInterface(GetTypeData(pInfo).Guid, Result) <> 0 then
    raise Exception.CreateFmt('Failed to cast %s to its interface ', [string(pInfo.Name)]);
end;

{ **************************************************************************** }

{ TActuallyUsefulEx }

constructor TSettingsVIEx.Create();
begin
  inherited;
  FData := TDictionary<string, TValue>.Create;
end;

destructor TSettingsVIEx.Destroy();
begin
  FData.Free;
  inherited;
end;

procedure TSettingsVIEx.DoInvokeImpl(Method: TRttiMethod; const Args: TArray<TValue>; out Result: TValue);
var
  Return: string;
  LValue: TValue;
  LAttr: TCustomAttribute;
  LSetAttrib: SettingAttribute;
begin
  //  inherited;
  if Method.Name.StartsWith('Get') then
  begin
    FData.TryGetValue(Method.Name.Substring(3), Result);

    if Result.IsEmpty then
    begin
      for LAttr in Method.GetAttributes do
      begin
        if LAttr is SettingAttribute then
        begin
          LSetAttrib := SettingAttribute(LAttr);
          TValue.Make(@Result, Result.TypeInfo, Result);
          case Method.ReturnType.TypeKind of
            tkWChar,
            tkLString,
            tkWString,
            tkString,
            tkChar,
            tkUString: Result := LSetAttrib.DefaultValue;

            tkInteger,
            tkInt64: Result := LSetAttrib.DefaultValue.ToInteger(); //TValue.From<Integer>(2);

            tkFloat: Result := LSetAttrib.DefaultValue.ToDouble;
          end;

          Break;
        end;

        FData.TryGetValue(Method.Name.Substring(3), Result);
      end;
    end;
  end
  else
  if Method.Name.StartsWith('Set') then
  begin
    FData.AddOrSetValue(Method.Name.Substring(3), Args[1]);
  end;
end;

{ **************************************************************************** }

{ VIService }

class function VIService.Starting(): ISampleSettingsEx;
begin
  //  Result := TSimplestVirtualInterface.Create(TypeInfo(ISampleSettingsEx)) as ISampleSettingsEx;
  Result := TSettingsVIEx.Create as ISampleSettingsEx;

  if Result.Client = 4711 then
    Result.Client := 4710;

  Result.Server := '[::1]';
  Result.Alias := 'Alias';
end;

end.
