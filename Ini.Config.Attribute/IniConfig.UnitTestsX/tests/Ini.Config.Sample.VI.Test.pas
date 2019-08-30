unit Ini.Config.Sample.VI.Test;

interface

{$M+}

uses
  DUnitX.TestFramework,
  Ini.Config.BaseTester;

type
  [TestFixture]
  TTestVIConfig = class(TTestBasetester)
  published
    [Test(False)]
    procedure Test_Starting();

//    [Test]
//    procedure Test_WithoutIniFile_ValuesByDefault();
  end;

{$M-}

implementation

uses
  Ini.Config,
  Ini.Config.Sample.VI,
  Ini.Config.Handler.Inifiles;

{ TTestVIConfig }

procedure TTestVIConfig.Test_Starting();
var
  Actual: ISampleSettingsEx;
begin
//  VIService.Starting();
//  VIService.InterfaceHelper();

  Actual := VIService.Starting();
  //Actual.Handler := TIniSettingHandler.Create(LocalSampleIni);
//  Actual.Load;
  Assert.AreEqual(4711, Actual.Client);
//  Assert.AreEqual('localhost/3052', Actual.Server);
//  Assert.AreEqual('DBNAME', Actual.Alias);
  Assert.IsTrue(1 = 1);
end;

//procedure TTestVIConfig.Test_WithoutIniFile_ValuesByDefault;
//var
//  Actual: ISampleSettings;
//begin
//  TearDownFixture;
//
//  Actual := TWSampleSettings.Create;
//  Actual.Handler := TIniSettingHandler.Create(LocalSSampleIni);
//  Actual.Load;
//  Assert.AreEqual(0, Actual.Mandant);
//  Assert.AreEqual('localhost/3050', Actual.Server);
//  Assert.AreEqual('', Actual.Alias);
//end;

initialization
  TDUnitX.RegisterTestFixture(TTestVIConfig);

end.
