unit Ini.Config.Sample.Provider;

interface

uses
  System.SysUtils,
  Spring,
  Spring.Container,
  Spring.Container.Registration,
  Ini.Config,
  Ini.Config.Sample.Config,
  Ini.Config.Sample.Settings;

{$M+}

type
  IProviderSettings = interface
    ['{1AD5535F-29D9-4C70-9951-AE46E3F17E1C}']
    function GetConfigAddress: string;
    procedure SetConfigAddress(const value: string);

    function GetSettings(): ISampleSettings;
    procedure SetSettings(value: ISampleSettings);

    function GetConfig(): IConfig;
    procedure SetConfig(value: IConfig);

    procedure DoProcessing;

    property ConfigAddress: string read GetConfigAddress write SetConfigAddress;
    property Settings: ISampleSettings read GetSettings write SetSettings;
    property Config: IConfig read GetConfig write SetConfig;
  end;

  /// <summary>
  ///  Der Provider verbindet alles. Das Interface <b>ISampleSettings</b> benötigt eine
  ///  Implemenation vom <b>ISettingHandler</b> welcher die Daten, vom z.B. File bereitstellt.
  ///  <b>IConfig</b> benötigt <b>ISampleSettings</b> um Daten zu evaluieren und
  ///  bereitzustellen. Der IoC stellt in der Regel alles bereit. Nur das eigentliche
  ///  laden und speichern kann sich ändern, je nachdem von welcherQuelle die Einstellung
  ///  her kommen. (IConfig -> ISampleSetting -> ISettingHandler)
  /// </summary>
  TProviderSettings = class(TInterfacedObject, IProviderSettings)
  strict private
    FHasLoaded: Boolean;
    FConfigAddress: string;
    FSampleSettings: ISampleSettings;
    FSettingFactory: TFunc<string, ISettingHandler>;
    FContainer: TContainer;
    FConfig: IConfig;
  private
    function GetConfigAddress: string;
    procedure SetConfigAddress(const value: string);

    function GetSettings(): ISampleSettings;
    procedure SetSettings(value: ISampleSettings);

    function GetConfig(): IConfig;
    procedure SetConfig(value: IConfig);

    procedure RegisterTypes(const AContainer: TContainer);
  public
    /// <summary>Constructor from implementation of IProviderSettings</summary>
    /// <param name="AConfigAddress">Address of confiog file or anything else.</param>
    constructor Create(const AConfigAddress: string); overload;

    /// <summary>Constructor from implementation of IProviderSettings</summary>
    /// <param name="AConfigAddress">Address of confiog file or anything else.</param>
    /// <param name="ASettingFactory">Delegate of TFunc<string, ISettingHandler>.</param>
    ///  <code>
    ///  Provider := TProviderSettings.Create(
    ///    LocalSampleIni,
    ///    function(AAddress: string): ISettingHandler
    ///    begin
    ///      Result := TIniSettingHandler.Create(AAddress);
    ///    end);
    ///  </code>
    constructor Create(const AConfigAddress: string; ASettingFactory: TFunc<string, ISettingHandler>); overload;

    destructor Destroy(); override;

    /// <summary>
    ///   Register, initialize and build IoC-Stuff. It is not necessary to call the method directly.
    /// </summary>
    procedure DoProcessing();
  end;

{$M-}

implementation

uses
  Ini.Config.Handler.Inifiles;

{ **************************************************************************** }

{ TProviderSettings }

constructor TProviderSettings.Create(const AConfigAddress: string);
begin
  inherited Create();
  FHasLoaded := False;
  FContainer := TContainer.Create;
  FConfigAddress := AConfigAddress;
  FSettingFactory := nil;
end;

constructor TProviderSettings.Create(const AConfigAddress: string; ASettingFactory: TFunc<string, ISettingHandler>);
begin
  Create(AConfigAddress);
  FSettingFactory := ASettingFactory;
end;

destructor TProviderSettings.Destroy;
begin
  FContainer.Free;
  inherited;
end;

function TProviderSettings.GetConfig: IConfig;
begin
  if (not FHasLoaded) then
  begin
    DoProcessing;
    FSampleSettings.Load;
  end;

  Result := FConfig;
end;

function TProviderSettings.GetConfigAddress: string;
begin
  Result := FConfigAddress;
end;

function TProviderSettings.GetSettings: ISampleSettings;
begin
  if (not FHasLoaded) then
    DoProcessing;

  Result := FSampleSettings;
end;

procedure TProviderSettings.SetConfig(value: IConfig);
begin
  FConfig := value;
end;

procedure TProviderSettings.SetConfigAddress(const value: string);
begin
  FConfigAddress := Value;
end;

procedure TProviderSettings.SetSettings(value: ISampleSettings);
begin
  FSampleSettings := value;
end;

procedure TProviderSettings.RegisterTypes(const AContainer: TContainer);
begin
  AContainer.RegisterType<ISettingHandler>.DelegateTo(
    function: ISettingHandler
    begin
      if Assigned(FSettingFactory) then
        Result := FSettingFactory(FConfigAddress)
      else
        Result := TIniSettingHandler.Create(FConfigAddress);
    end);

  AContainer.RegisterType<TSampleSettings>.Implements<ISampleSettings>.InjectProperty('Handler');

  AContainer.RegisterType<IConfig>.DelegateTo(
    function: IConfig
    begin
      Result := TConfigImpl.Create(FSampleSettings);
    end);

  AContainer.Build;
end;

procedure TProviderSettings.DoProcessing();
begin
  RegisterTypes(FContainer);
  FSampleSettings := FContainer.Resolve<ISampleSettings>;
  FConfig := FContainer.Resolve<IConfig>;
  FHasLoaded := True;
end;

end.
