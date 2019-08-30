unit Ini.Config.Sample.Test;

interface

{$M+}

uses
  DUnitX.TestFramework,
  Spring.Mocking,
  Ini.Config,
  Ini.Config.Sample.Settings,
  Ini.Config.BaseTester;

type
  [TestFixture]
  TTestDummyConfig = class(TTestBasetester)
  published
    [Test]
    procedure Test_Starting();

    [Test]
    procedure Test_WithoutIniFile_ValuesByDefault();
  end;

  [TestFixture]
  TTestDummyConfigGet = class
  private
    FSut: ISampleSettings;
    FMockSettingHandler: Mock<ISettingHandler>;
  public
    [Setup]
    procedure SetUp();

    [TearDown]
    procedure TearDown();
  published
    [Test]
    procedure Test_Get_DatabaseAlias();

    [Test]
    procedure Test_Get_DatabaseServer();

    [Test]
    procedure Test_Get_BackupPath();

    [Test]
    procedure Test_Get_Client();

    [Test]
    procedure Test_Get_Licence();

    [Test]
    procedure Test_Get_SqlMonitor();
  end;

{$M-}

implementation

uses
  System.SysUtils,
  Ini.Config.Handler.Inifiles;

{ **************************************************************************** }

{ TTestDummyConfig }

procedure TTestDummyConfig.Test_Starting();
var
  Actual: ISampleSettings;
begin
  Actual := TSampleSettings.Create;
  Actual.Handler := TIniSettingHandler.Create(LocalSampleIni);
  Actual.Load;
  Assert.AreEqual(4711, Actual.Client);
  Assert.AreEqual('localhost/3052', Actual.DatabaseServer);
  Assert.AreEqual('dbname', Actual.DatabaseAlias);

  Assert.AreEqual('', Actual.BackupPath);
  Assert.AreEqual('dbname', Actual.DatabaseAlias);
  Assert.AreEqual('localhost/3052', Actual.DatabaseServer);
  Assert.AreEqual('My Company', Actual.Licence);
  Assert.AreEqual(4711, Actual.Client);
  Assert.IsFalse(Actual.SqlMonitor);
end;

procedure TTestDummyConfig.Test_WithoutIniFile_ValuesByDefault;
var
  Actual: ISampleSettings;
begin
  TearDownFixture;

  Actual := TSampleSettings.Create;
  Actual.Handler := TIniSettingHandler.Create(LocalSampleIni);
  Actual.Load;
  Assert.AreEqual(0, Actual.Client);
  Assert.AreEqual('localhost/3050', Actual.DatabaseServer);
  Assert.AreEqual('dbname', Actual.DatabaseAlias);
  Assert.AreEqual('..\Backup', Actual.BackupPath);
  Assert.AreEqual('dbname', Actual.DatabaseAlias);
  Assert.AreEqual('localhost/3050', Actual.DatabaseServer);
  Assert.AreEqual('', Actual.Licence);
  Assert.AreEqual(0, Actual.Client);
  Assert.IsFalse(Actual.SqlMonitor);
end;

{ **************************************************************************** }

{ TTestDummyConfigGet }

procedure TTestDummyConfigGet.SetUp;
begin
  FMockSettingHandler := Mock<ISettingHandler>.Create;
  FMockSettingHandler.Setup.Returns('2810').When.ReadString('System', 'Client', '');
  FMockSettingHandler.Setup.Returns('Name, Plz Ort').When.ReadString('System', 'Licence', '');
  FMockSettingHandler.Setup.Returns('SERVER/3051').When.ReadString('System', 'Server', 'localhost/3050');
  FMockSettingHandler.Setup.Returns('ALIAS').When.ReadString('System', 'Alias', '');
  FMockSettingHandler.Setup.Returns('C:\Does\Not\Exist').When.ReadString('System', 'BackupPath', '..\Backup');
  FMockSettingHandler.Setup.Returns('False').When.ReadString('System', 'SqlMonitor', '');

  FSut := TSampleSettings.Create;
  //  FSut.Handler := TIniSettingHandler.Create(LocalSampleIni);
  FSut.Handler := FMockSettingHandler;
  FSut.Load;
end;

procedure TTestDummyConfigGet.TearDown;
begin
  FSut := nil;
end;

procedure TTestDummyConfigGet.Test_Get_BackupPath;
begin
  Assert.AreEqual('C:\Does\Not\Exist', FSut.BackupPath);
end;

procedure TTestDummyConfigGet.Test_Get_DatabaseAlias;
begin
  Assert.AreEqual('', FSut.DatabaseAlias);
end;

procedure TTestDummyConfigGet.Test_Get_DatabaseServer;
begin
  Assert.AreEqual('SERVER/3051', FSut.DatabaseServer);
end;

procedure TTestDummyConfigGet.Test_Get_Licence;
begin
  Assert.AreEqual('Name, Plz Ort', FSut.Licence);
end;

procedure TTestDummyConfigGet.Test_Get_Client;
begin
  Assert.AreEqual(2810, FSut.Client, 1);
end;

procedure TTestDummyConfigGet.Test_Get_SqlMonitor();
begin
  Assert.IsFalse(FSut.SqlMonitor)
end;

initialization
  TDUnitX.RegisterTestFixture(TTestDummyConfig);
  TDUnitX.RegisterTestFixture(TTestDummyConfigGet);

end.
