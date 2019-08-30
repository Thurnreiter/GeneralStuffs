unit Ini.Config.Sample.Provider.Test;

interface

{$M+}

uses
  DUnitX.TestFramework,
  Spring.Mocking,
  Ini.Config,
  Ini.Config.BaseTester,
  Ini.Config.Sample.Settings,
  Ini.Config.Sample.Provider;

type
  TMockSettingHandler = class(TSettingHandler)
  private
    FHasCalled: Boolean;
  public
    function ReadString(const ASection, AKey, ADefaultValue: string): string; override;
    procedure WriteString(const ASection, AKey, AValue: string); override;

    property HasCalled: Boolean read FHasCalled write FHasCalled;
  end;


  [TestFixture]
  TTestSampleProvider = class(TTestBasetester)
  published
    [Test]
    procedure Test_Starting_IoC();

    [Test]
    procedure Test_UseConfigByIni();

    [Test]
    procedure Test_GetInstance();

    [Test]
    procedure Test_ConfigClass();

    [Test]
    procedure Test_ConfigFactory();
  end;

  [TestFixture]
  TTestSampleProviderDefault = class
  private
    const LocalSampleIni = TTestBasetester.LocalSampleIni;
  published
    [Test]
    procedure Test_WithoutIniFile_ValuesByDefault();

    [Test]
    procedure Test_WithMockHandler_IoC();
  end;

  [TestFixture]
  TTestSampleProviderOverIoc = class
  private
    FSut: IProviderSettings;
    FMockSampleSettings: ISampleSettings;
    FMockSettingHandler: Mock<ISettingHandler>;
  public
    [Setup]
    procedure SetUp();

    [TearDown]
    procedure TearDown();
  published
    [Test]
    procedure Test_WithMockingHandler();
  end;

{$M+}

implementation

uses
  System.SysUtils,
  Ini.Config.Sample.Config,
  Ini.Config.Sample.Provider.Alias;

{ **************************************************************************** }

{ TMockSettingHandler }

function TMockSettingHandler.ReadString(const ASection, AKey, ADefaultValue: string): string;
begin
  FHasCalled := True;
  Result := ADefaultValue;
end;

procedure TMockSettingHandler.WriteString(const ASection, AKey, AValue: string);
begin
  FHasCalled := True;
end;

{ **************************************************************************** }

{ TTestSampleProvider }

procedure TTestSampleProvider.Test_Starting_IoC;
var
  Provider: IProviderSettings;
  Actual: ISampleSettings;
begin
  Provider := TProviderSettings.Create(LocalSampleIni);
  Actual := Provider.Settings;
  Actual.Load;

  Assert.AreEqual(4711, Actual.Client);
  Assert.AreEqual('localhost/3052', Actual.DatabaseServer);
  Assert.AreEqual('DBNAME', Actual.DatabaseAlias);
end;


procedure TTestSampleProvider.Test_UseConfigByIni;
var
  ActualProvider: IProviderSettings;
  ActualConfig: IConfig;
begin
  ActualProvider := TProviderSettings.Create(LocalSampleIni);
  ActualConfig := ActualProvider.Config;

  Assert.AreEqual(4711, ActualConfig.Client);
  Assert.AreEqual('localhost', ActualConfig.DatabaseServer);
  Assert.AreEqual(3052, ActualConfig.DatabasePort);
  Assert.AreEqual('DBNAME', ActualConfig.DatabaseAlias);
  ActualProvider := nil;
end;

procedure TTestSampleProvider.Test_GetInstance;
begin
  Assert.AreEqual(4711, TConfig.GetInstance.Client);
  Assert.AreEqual('localhost', TConfig.GetInstance.DatabaseServer);
  Assert.AreEqual(3052, TConfig.GetInstance.DatabasePort);
  Assert.AreEqual('DBNAME', TConfig.GetInstance.DatabaseAlias);
end;


procedure TTestSampleProvider.Test_ConfigClass;
var
  Id: Integer;
  //  CF: ConfigFactory;
  //  punk: IInterface;
  //  Cfg: IConfig;
begin
  Id := 1;
  //  punk := TPasClass.Create as IInterface;
  //  Id := (punk as IConfig).MandantNr;

  //  Cfg := TConfigClass.Create;
  //  Id := Cfg.Client;
  //  Cfg := nil;
  //  Assert.AreEqual(1, Id);

  //  CF :=
  //    function: IConfig
  //    begin
  //      Result := (TProviderSettings.Create('.\Sample.ini') as IProviderSettings).Config;
  //    end;
  //
  //  Assert.AreEqual(4711, CF.Client);
  //  Assert.AreEqual('localhost', CF.DatabaseServer);

  Assert.AreEqual(1, Id);
end;

procedure TTestSampleProvider.Test_ConfigFactory;
var
  Config: ConfigFactory;
begin
  Config :=
    function: IConfig
    begin
      Result := TConfig.GetInstance;
    end;

  Assert.AreEqual(4711, Config.Client);
  Assert.AreEqual('localhost', Config.DatabaseServer);
  Assert.AreEqual(3052, Config.DatabasePort);
  Assert.AreEqual('dbname', Config.DatabaseAlias);
end;

{ **************************************************************************** }

{ TTestSampleProviderDefault }

procedure TTestSampleProviderDefault.Test_WithoutIniFile_ValuesByDefault;
var
  Provider: IProviderSettings;
  Actual: ISampleSettings;
begin
  //  TearDownFixture;
  Provider := TProviderSettings.Create(LocalSampleIni);
  Actual := Provider.Settings;
  Actual.Load;

  Assert.AreEqual(0, Actual.Client);
  Assert.AreEqual('localhost/3050', Actual.DatabaseServer);
  Assert.AreEqual('dbname', Actual.DatabaseAlias);
end;

procedure TTestSampleProviderDefault.Test_WithMockHandler_IoC;
var
  Provider: IProviderSettings;
  Actual: ISampleSettings;
  ActualFunc: TFunc<string, ISettingHandler>;
  ActualHandler: ISettingHandler;
begin
  //  TearDownFixture;
  ActualFunc :=
    function(AAddress: string): ISettingHandler
    begin
      Result := TMockSettingHandler.Create;
      ActualHandler := Result;
    end;

  Provider := TProviderSettings.Create(LocalSampleIni, ActualFunc);

  Actual := Provider.Settings;
  Actual.Load;

  Assert.IsTrue(TMockSettingHandler(ActualHandler).HasCalled);
  Assert.AreEqual(0, Actual.Client);
  Assert.AreEqual('localhost/3050', Actual.DatabaseServer);
  Assert.AreEqual('DBNAME', Actual.DatabaseAlias);
end;

{ **************************************************************************** }

{ TTestSampleProviderOverIoc }

procedure TTestSampleProviderOverIoc.SetUp;
begin
  FMockSettingHandler := Mock<ISettingHandler>.Create;
  FMockSettingHandler.Setup.Returns('4711').When.ReadString('System', 'Client', '');
  FMockSettingHandler.Setup.Returns('Thurnreiter, 8903 Birmensdorf').When.ReadString('System', 'Licence', '');
  FMockSettingHandler.Setup.Returns('SERVER').When.ReadString('System', 'Server', 'localhost/3050');
  FMockSettingHandler.Setup.Returns('DATABASEALIAS').When.ReadString('System', 'Alias', 'dbname');

  FSut := TProviderSettings.Create('.\Sample.ini',
    function(x: string): ISettingHandler
    begin
      Result := FMockSettingHandler;
    end);
end;

procedure TTestSampleProviderOverIoc.TearDown;
begin
  FSut := nil;
  FMockSampleSettings := nil;
end;

procedure TTestSampleProviderOverIoc.Test_WithMockingHandler;
begin
  Assert.AreEqual(4711, FSut.Config.Client);
  Assert.AreEqual('Thurnreiter, 8903 Birmensdorf', FSut.Config.Licence);
  Assert.AreEqual('SERVER', FSut.Config.DatabaseServer);
  Assert.AreEqual(3050, FSut.Config.DatabasePort);
  Assert.AreEqual('DATABASEALIAS', FSut.Config.DatabaseAlias);

  FMockSettingHandler.Reset;
  FMockSettingHandler.Setup.Returns('DBNAME').When.ReadString('System', 'Alias', 'DBNAME');
  Assert.AreEqual('DATABASEALIAS', FSut.Config.DatabaseAlias);
end;

initialization
  TDUnitX.RegisterTestFixture(TTestSampleProvider);
  TDUnitX.RegisterTestFixture(TTestSampleProviderDefault);
  TDUnitX.RegisterTestFixture(TTestSampleProviderOverIoc);

end.
