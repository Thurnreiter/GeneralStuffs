unit Ini.Config.Sample.Provider.Alias;

interface

uses
  System.SysUtils,
  Ini.Config,
  Ini.Config.Sample.Config,
  Ini.Config.Sample.Provider;

{$M+}

type
  /// <summary>
  ///   Das Delegate <b>ConfigFactory</b> ist der zentrale Zugriffspunkt auf die Konfiguration im Sample.
  /// <example>
  ///   <code>
  ///   <para />var
  ///   <para />  Config: ConfigFactory;
  ///   <para />begin
  ///   <para />Config :=
  ///   <para />  function: IConfig
  ///   <para />  begin
  ///   <para />    Result := TConfig.GetInstance;
  ///   <para />  end;
  ///   <para />
  ///   <para />  if Config.MandantNr ...
  ///   </code>
  /// </example>
  /// </summary>
  /// <returns>Rückgabewert ist ein Interface <b>IConfig</b>.</returns>
  ConfigFactory = reference to function: IConfig;

  /// <summary>
  ///  Stellt praktisch eine Factory da, kapselt die Provider-Klasse
  ///  und gibt diese Thread Safe zurück.
  ///  Die <c>Config</c>-Klasse ist der zentrale Zugriffspunkt auf die
  ///  Konfiguration im Sample. Die Klasse ist statisch und threadsicher.
  ///  Im nächsten Schritt versuchen wir das GetInstance noch weg zu lassen.
  ///  http://docwiki.embarcadero.com/RADStudio/Tokyo/de/Interfaces_implementieren:_Delphi_und_C%2B%2B
  /// </summary>
  TConfig = class
  //  Config = class(TInterfacedObject, IConfig)
  //  strict private
  //    FConfigImpl: TConfigImpl;
  //  public
  //    property ConfigImpl: TConfigImpl read FConfigImpl implements IConfig;
  strict private
    class var FLock: TObject;
    class var FConfig: IConfig;
  public
    class function GetInstance(): IConfig; overload;
    class function GetInstance(ASettingFactory: TFunc<string, ISettingHandler>): IConfig; overload;

    class constructor Create();
    class destructor Destroy();
  end;


  //  In this case, TConfigImpl must inheriance from TAggregatedObject.
  //  Because TConfigClass will never destroyed, so long as FConfigImpl live.
  //  TConfigImpl = class(TAggregatedObject, IConfig)
  //  At the time, we have with this solution a memory leaks.
  TConfigClass = class(TInterfacedObject, IConfig)
    FConfigImpl: IConfig;
    function GetConfigImpl(): IConfig;
  public
    constructor Create();
    destructor Destroy; override;

    //  property ConfigImpl: IConfig read GetConfigImpl write FConfigImpl implements IConfig;
    property ConfigImpl: IConfig read GetConfigImpl implements IConfig;
  end;


{$M+}

implementation

{ **************************************************************************** }

{ Config }

class constructor TConfig.Create();
begin
  FLock := TObject.Create;
end;

class destructor TConfig.Destroy();
begin
  FLock.Free;
end;

class function TConfig.GetInstance(ASettingFactory: TFunc<string, ISettingHandler>): IConfig;
var
  Provider: IProviderSettings;
begin
  System.TMonitor.Enter(FLock);
  try
    Result := FConfig;
    if (not Assigned(Result)) then
    begin
      Provider := TProviderSettings.Create('.\Sample.ini', ASettingFactory);
      FConfig := Provider.Config;
      Result := FConfig;
    end;
  finally
    System.TMonitor.Exit(FLock);
  end;
end;

class function TConfig.GetInstance(): IConfig;
begin
  Result := GetInstance(nil);
end;

{ **************************************************************************** }

{ TConfigClass }

constructor TConfigClass.Create;
begin
  inherited Create;
  FConfigImpl := nil;
end;

destructor TConfigClass.Destroy;
begin
  FConfigImpl := nil;
  inherited;
end;

function TConfigClass.GetConfigImpl: IConfig;
var
  Provider: IProviderSettings;
begin
  if (not Assigned(FConfigImpl)) then
  begin
    Provider := TProviderSettings.Create('.\Sample.ini');
    FConfigImpl := Provider.Config;
  end;

  Result := FConfigImpl;
end;

end.
