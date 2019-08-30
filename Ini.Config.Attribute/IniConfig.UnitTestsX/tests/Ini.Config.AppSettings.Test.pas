unit Ini.Config.AppSettings.Test;

interface

{$M+}

uses
  DUnitX.TestFramework,

  Spring,
  Spring.Container,
  Spring.Container.Registration,
  Spring.Container.AutoMockExtension,
  Spring.Mocking,

  Ini.Config,
  Ini.Config.BaseTester,
  Ini.Config.AppSettings,
  Ini.Config.Handler.IniFiles;

type
  TMockFromAppSettings = class(TAppSettings)
  public
    [Setting('System', 'Next', 'Default')]
    NextProperty: string;
  end;


  TMockingSettingHandler = class(TSettingHandler)
  public
    function ReadString(const ASection, AKey, ADefaultValue: string): string; override;
    procedure WriteString(const ASection, AKey, AValue: string); override;
  end;

  TMockFromAppSettingsIoC = class(TAppSettings)
  public
    [Setting('System', 'IOC', 'Spring')]
    IocProperty: string;
  end;

  [TestFixture]
  TTestAppConfig = class(TTestBasetester)
  published
    [Test]
    procedure Test_Starting();

    [Test]
    procedure Test_WithoutIniFile_ValuesByDefault();

    [Test]
    procedure Test_FromAppSettings_WithoutIniFile_ValuesByDefault_WithoutAnyHandler();
  end;

  [TestFixture]
  TTestAppConfigIoC = class(TTestBasetester)
  private
    procedure RegisterStuff();
  published
    [Test]
    procedure Test_IoC_Starting();
  end;


{$M-}

implementation

{ **************************************************************************** }

{ TTestAppConfig }

procedure TTestAppConfig.Test_Starting();
var
  Actual: ISettings;
begin
  Actual := TAppSettings.Create;
  Assert.WillNotRaiseAny(
    procedure
    begin
      Actual.Load;
    end);
  Assert.AreEqual('Ini.Config.UnitTestsX.config', Actual.ConfigAddress);
end;

procedure TTestAppConfig.Test_WithoutIniFile_ValuesByDefault;
var
  Actual: ISettings;
begin
  TearDownFixture;

  Actual := TAppSettings.Create;
  Assert.WillNotRaiseAny(
    procedure
    begin
      Actual.Load;
    end);
  Assert.AreEqual('Ini.Config.UnitTestsX.config', Actual.ConfigAddress);
end;

procedure TTestAppConfig.Test_FromAppSettings_WithoutIniFile_ValuesByDefault_WithoutAnyHandler;
var
  Actual: string;
  InnerSettings: ISettings;
begin
  InnerSettings := TMockFromAppSettings.Create;
  Assert.WillNotRaiseAny(
    procedure
    begin
      InnerSettings.Load;
    end);

  Actual := TMockFromAppSettings(InnerSettings).NextProperty;
  Assert.AreEqual('Default', Actual);

  Assert.AreEqual('Ini.Config.UnitTestsX.config', InnerSettings.ConfigAddress);
end;

{ **************************************************************************** }

{ TMockingSettingHandler }

function TMockingSettingHandler.ReadString(const ASection, AKey, ADefaultValue: string): string;
begin
  Result := '1';
end;

procedure TMockingSettingHandler.WriteString(const ASection, AKey, AValue: string);
begin
  //...
end;

{ **************************************************************************** }

{ TTestAppConfigIoC }

procedure TTestAppConfigIoC.RegisterStuff;
begin
  //  So it works fin with normal ini reader...
  //  GlobalContainer.RegisterType<TIniSettingHandler>.DelegateTo(
  //    function: TIniSettingHandler
  //    begin
  //      Result := TIniSettingHandler.Create('');
  //    end);

  //  Now we use an own mocking object...
  //  GlobalContainer.RegisterType<ISettingHandler, TMockingSettingHandler>.DelegateTo(
  //    function: TMockingSettingHandler
  //    begin
  //      Result := TMockingSettingHandler.Create;
  //    end);

  //  Next step is using Mock<T> from spring...
  GlobalContainer.AddExtension<TAutoMockExtension>;

  GlobalContainer.RegisterType<ISettingHandler>.DelegateTo(
    function: ISettingHandler
    var
      ReturnMock: Mock<ISettingHandler>;
    begin
      ReturnMock := Mock<ISettingHandler>.Create;
      ReturnMock.Setup.Returns('Test').When.ReadString('System', 'IOC', 'Spring');
      Result := ReturnMock;
    end);


  //  Same, can uses this or this...
  //  GlobalContainer.RegisterType<ISettings, TMockFromAppSettingsIoC>.InjectProperty('Handler');
  GlobalContainer.RegisterType<TMockFromAppSettingsIoC>.Implements<ISettings>.InjectProperty('Handler');

  GlobalContainer.Build;
end;

procedure TTestAppConfigIoC.Test_IoC_Starting;
var
  Actual: string;
  InnerSettings: ISettings;
begin
  RegisterStuff();

  InnerSettings := GlobalContainer.Resolve<ISettings>;

  Assert.WillNotRaiseAny(
    procedure
    begin
      InnerSettings.Load;
    end);

  Actual := TMockFromAppSettingsIoC(InnerSettings).IoCProperty;

  //  Normal stuff...
  //  Assert.AreEqual('Spring', Actual);

  //  Mocking stuff. We don't really need it, because normally the default value is always read.
  Assert.AreEqual('Test', Actual);

  Assert.AreEqual('Ini.Config.UnitTestsX.config', InnerSettings.ConfigAddress);
end;

initialization
  TDUnitX.RegisterTestFixture(TTestAppConfig);
  TDUnitX.RegisterTestFixture(TTestAppConfigIoC);

end.
