unit Ini.Config.Json.Test;

interface

{$M+}

uses
  DUnitX.TestFramework;

type
  [TestFixture]
  TTestConfigJson = class
  protected
    const LocalSampleJson = '.\Sample.json';
  public
    [SetupFixture]
    procedure SetupFixture;

    [TearDownFixture]
    procedure TearDownFixture;
  published
    [Test]
    procedure Test_Reading();

    [Test]
    procedure Test_Reading_Mandant();

    [Test]
    procedure Test_Reading_ByDefault();

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
  System.SysUtils,
  System.IOUtils,
  System.Types,
  Ini.Config,
  Ini.Config.Handler.Json,
  Nathan.Resources.ResourceManager;

{ TTestConfigJson }

procedure TTestConfigJson.SetupFixture;
begin
  ResourceManager.SaveToFile('Resource_Json', LocalSampleJson, RT_RCDATA);
end;

procedure TTestConfigJson.TearDownFixture;
begin
  if TFile.Exists(LocalSampleJson) then
    TFile.Delete(LocalSampleJson);
end;

procedure TTestConfigJson.Test_Reading;
var
  Actual: ISettingHandler;
  Return: string;
begin
  Actual := TJsonSettingHandler.Create(LocalSampleJson);
  Return := Actual.ReadString('System', 'Licence', 'Default');
  Assert.AreEqual('My Company', Return);
end;

procedure TTestConfigJson.Test_Reading_Mandant;
var
  Actual: ISettingHandler;
  Return: string;
begin
  Actual := TJsonSettingHandler.Create(LocalSampleJson);
  Return := Actual.ReadString('System', 'CLIENT', '0');
  Assert.AreEqual('4711', Return);
end;

procedure TTestConfigJson.Test_Reading_ByDefault();
var
  Actual: ISettingHandler;
  Return: string;
begin
  Actual := TJsonSettingHandler.Create(LocalSampleJson);
  Return := Actual.ReadString('Hello', 'World', 'Default');
  Assert.AreEqual('Default', Return);
end;

procedure TTestConfigJson.Test_Constructor_Without_Filename;
var
  Actual: ISettingHandler;
  Return: string;
begin
  Actual := TJsonSettingHandler.Create('');
  Return := Actual.ReadString('Hello', 'World', 'Default');
  Assert.AreEqual('Default', Return);
end;

procedure TTestConfigJson.Test_Writing;
var
  Actual: ISettingHandler;
  Return: string;
begin
  Actual := TJsonSettingHandler.Create(LocalSampleJson);

  Return := Actual.ReadString('System', 'Licence', 'Default');
  Assert.AreEqual('My Company', Return);

  Actual.WriteString('System', 'Licence', 'Nathan');

  Return := Actual.ReadString('System', 'Licence', 'Default');
  Assert.AreEqual('Nathan', Return);
end;

procedure TTestConfigJson.Test_Writing_Constructor_Without_Filename;
var
  Actual: ISettingHandler;
  Return: string;
begin
  Actual := TJsonSettingHandler.Create('');

  Return := Actual.ReadString('System', 'Licence', 'Default');
  Assert.AreEqual('Default', Return);

  Assert.WillNotRaise(procedure
    begin
      Actual.WriteString('System', 'Licence', 'Nathan');
    end);

  Return := Actual.ReadString('System', 'Licence', 'Default');
  Assert.AreEqual('Default', Return);
end;

initialization
  TDUnitX.RegisterTestFixture(TTestConfigJson);

end.
