unit Ini.Config.Ini.Test;

interface

{$M+}

uses
  DUnitX.TestFramework,
  Ini.Config.BaseTester;

type
  [TestFixture]
  TTestConfigIni = class(TTestBasetester)
  published
    [Test]
    procedure Test_Reading();

    [Test]
    procedure Test_Reading_ByDefault();

    [Test]
    procedure Test_Constructor_With_Filename();

    [Test]
    procedure Test_Constructor_Without_Filename();

    [Test]
    procedure Test_Writing();

    [Test]
    procedure Test_Writing_Constructor_Without_Filename();
  end;

{$M-}

implementation

uses
  Ini.Config,
  Ini.Config.Handler.IniFiles;

{ TTestConfigIni }

procedure TTestConfigIni.Test_Reading;
var
  Actual: ISettingHandler;
  Return: string;
begin
  Actual := TIniSettingHandler.Create(LocalSampleIni);
  Return := Actual.ReadString('System', 'Licence', 'Default');

  Assert.IsNotNull(Actual);
  Assert.AreEqual('My Company', Return);
end;

procedure TTestConfigIni.Test_Reading_ByDefault();
var
  Actual: ISettingHandler;
  Return: string;
begin
  Actual := TIniSettingHandler.Create(LocalSampleIni);
  Return := Actual.ReadString('Hello', 'World', 'Default');

  Assert.IsNotNull(Actual);
  Assert.AreEqual('Default', Return);
end;

procedure TTestConfigIni.Test_Constructor_With_Filename;
begin
  Test_Reading_ByDefault();
end;

procedure TTestConfigIni.Test_Constructor_Without_Filename;
var
  Actual: ISettingHandler;
  Return: string;
begin
  Actual := TIniSettingHandler.Create('');
  Return := Actual.ReadString('Hello', 'World', 'Default');

  Assert.IsNotNull(Actual);
  Assert.AreEqual('Default', Return);
end;

procedure TTestConfigIni.Test_Writing;
var
  Actual: ISettingHandler;
  Return: string;
begin
  Actual := TIniSettingHandler.Create(LocalSampleIni);

  Return := Actual.ReadString('System', 'Licence', 'Default');
  Assert.AreEqual('My Company', Return);

  Actual.WriteString('System', 'Licence', 'Nathan');

  Return := Actual.ReadString('System', 'Licence', 'Default');
  Assert.AreEqual('Nathan', Return);
end;

procedure TTestConfigIni.Test_Writing_Constructor_Without_Filename;
var
  Actual: ISettingHandler;
  Return: string;
begin
  Actual := TIniSettingHandler.Create('');

  Return := Actual.ReadString('System', 'Licence', 'Default');
  Assert.AreEqual('Default', Return);

  Assert.WillRaise(procedure
    begin
      Actual.WriteString('System', 'Licence', 'Nathan');
    end);

  Return := Actual.ReadString('System', 'Licence', 'Default');
  Assert.AreEqual('Default', Return);
end;

initialization
  TDUnitX.RegisterTestFixture(TTestConfigIni);

end.
