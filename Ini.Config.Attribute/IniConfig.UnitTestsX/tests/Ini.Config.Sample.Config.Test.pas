unit Ini.Config.Sample.Config.Test;

interface

{$M+}

uses
  DUnitX.TestFramework,
  Spring.Mocking,
  Ini.Config,
  Ini.Config.Sample.Config,
  Ini.Config.Sample.Settings;

type
  [TestFixture]
  TTestConfigImpl = class
  private
    FSut: IConfig;
    FMockSampleSettings: ISampleSettings;
    FMockSettingHandler: Mock<ISettingHandler>;
  public
    [Setup]
    procedure SetUp();

    [TearDown]
    procedure TearDown();
  published
    [Test]
    procedure Test_Get_SqlMonitor();

    procedure Test_Get_BackupPath();

    [Test]
    procedure Test_Get_IsInternal();

    [Test]
    procedure Test_Get_Client();

    [Test]
    procedure Test_Get_Licence();


    [Test]
    procedure Test_Get_DatabaseServer();

    [Test]
    procedure Test_Get_DatabasePort();

    [Test]
    procedure Test_Get_DatabaseAlias();
  end;

{$M-}

implementation

uses
  System.Net.URLCLient,
  System.SysUtils;

{ **************************************************************************** }

{ TTestConfigImpl }

procedure TTestConfigImpl.SetUp;
begin
  FMockSettingHandler := Mock<ISettingHandler>.Create;
  FMockSettingHandler.Setup.Returns('4712').When.ReadString('System', 'Client', '');
  FMockSettingHandler.Setup.Returns('Name, Plz Ort').When.ReadString('System', 'Licence', '');
  FMockSettingHandler.Setup.Returns('SERVER/3051').When.ReadString('System', 'Server', 'localhost/3050');
  FMockSettingHandler.Setup.Returns('ALIAS').When.ReadString('System', 'Alias', '');
  FMockSettingHandler.Setup.Returns('').When.ReadString('System', 'BackupPath', '..\Backup');
  FMockSettingHandler.Setup.Returns('False').When.ReadString('System', 'SqlMonitor', '');

  FMockSampleSettings := TSampleSettings.Create;
  FMockSampleSettings.Handler := FMockSettingHandler;
  FMockSampleSettings.Load;

  FSut := TConfigImpl.Create(FMockSampleSettings);
end;

procedure TTestConfigImpl.TearDown;
begin
  FSut := nil;
  FMockSampleSettings := nil;
end;

procedure TTestConfigImpl.Test_Get_SqlMonitor();
begin
  Assert.IsFalse(FSut.SqlMonitor)
end;

procedure TTestConfigImpl.Test_Get_BackupPath;
begin
  Assert.IsTrue(FSut.BackupPath.EndsWith('\Backup'));
end;

procedure TTestConfigImpl.Test_Get_IsInternal;
begin
  Assert.IsFalse(FSut.IsInternal);
end;

procedure TTestConfigImpl.Test_Get_Client;
begin
  Assert.AreEqual(4712, FSut.Client);
end;

procedure TTestConfigImpl.Test_Get_Licence;
begin
  Assert.AreEqual('Name, Plz Ort', FSut.Licence);
end;

procedure TTestConfigImpl.Test_Get_DatabaseServer;
begin
  Assert.AreEqual('SERVER', FSut.DatabaseServer);
end;

procedure TTestConfigImpl.Test_Get_DatabasePort;
begin
  Assert.AreEqual(3051, FSut.DatabasePort);
end;

procedure TTestConfigImpl.Test_Get_DatabaseAlias;
begin
  Assert.AreEqual('Sample', FSut.DatabaseAlias);
end;

initialization
  TDUnitX.RegisterTestFixture(TTestConfigImpl);

end.
