unit Ini.Config.CCRIniFile.Test;

interface

{$M+}

uses
  DUnitX.TestFramework,
  Ini.Config;

type
  [TestFixture]
  TTestDummyConfigCCRIni = class
  private
    FCut: ISettingHandler;
  public
    [Setup]
    procedure SetUp();

    [TearDown]
    procedure TearDown();
  published
    [Test]
    procedure Test_Reading();

    [Test]
    procedure Test_Reading_ByDefault();

    [Test]
    procedure Test_Writing();
  end;

{$M-}

implementation

uses
  System.IOUtils,
  Ini.Config.Handler.CCR.PrefsIniFile;

{ TTestDummyConfigCCRIni }

procedure TTestDummyConfigCCRIni.SetUp;
begin
  FCut := TCCRSettingHandler.Create();
end;

procedure TTestDummyConfigCCRIni.TearDown;
begin
  FCut := nil;
end;

procedure TTestDummyConfigCCRIni.Test_Reading;
var
  Return: string;
begin
  Return := FCut.ReadString('System', 'Licence', 'Default');
  Assert.AreEqual('Default', Return);
end;

procedure TTestDummyConfigCCRIni.Test_Reading_ByDefault();
var
  Return: string;
begin
  Return := FCut.ReadString('Hello', 'World', 'Default');
  Assert.AreEqual('Default', Return);
end;

procedure TTestDummyConfigCCRIni.Test_Writing;
var
  Return: string;
begin
  FCut.WriteString('System', 'Alias', 'SAMPLE');
  Return := FCut.ReadString('System', 'Alias', 'Default');
  Assert.AreEqual('SAMPLE', Return);
end;

initialization
  TDUnitX.RegisterTestFixture(TTestDummyConfigCCRIni);

end.
