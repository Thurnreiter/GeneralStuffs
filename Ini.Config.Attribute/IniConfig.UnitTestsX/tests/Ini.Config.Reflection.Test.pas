unit Ini.Config.Reflection.Test;

interface

{$M+}

uses
  DUnitX.TestFramework,
  Delphi.Mocks,
  Ini.Config,
  Ini.Config.BaseTester;

type
  TFakeSettings = class(TSettings)
  public
    [Setting('System', 'Any', 'Default')]
    AnyProperty: string;
  end;


  [TestFixture]
  TTestConfigRefelection = class(TTestBasetester)
  private
    function GetHandler(const ARet, ASec, AKey, AVal: string): TMock<ISettingHandler>;
  published
    [Test]
    procedure Test_Reading_ByValue();

    [Test]
    procedure Test_Reading_ByDefault();

    [Test]
    procedure Test_Wrting_ByValue();
  end;

{$M-}

implementation

uses
  System.SysUtils,
  System.IOUtils;

{ TTestConfigRefelection }

function TTestConfigRefelection.GetHandler(const ARet, ASec, AKey, AVal: string): TMock<ISettingHandler>;
begin
  Result := TMock<ISettingHandler>.Create;
  Result.Setup.WillReturn(ARet).When.ReadString(ASec, AKey, AVal);
end;

procedure TTestConfigRefelection.Test_Reading_ByValue;
var
  Cut: ISettings;
begin
  Cut := TFakeSettings.Create;
  TConfigReflection.Load(TFakeSettings(Cut), GetHandler('Nathan', 'System', 'Any', 'Default'));
  Assert.AreEqual('Nathan', TFakeSettings(Cut).AnyProperty);
end;

procedure TTestConfigRefelection.Test_Reading_ByDefault;
var
  Cut: ISettings;
begin
  Cut := TFakeSettings.Create;
  TConfigReflection.Load(TFakeSettings(Cut), GetHandler('Default', 'System', 'Any', 'Default'));
  Assert.AreEqual('Default', TFakeSettings(Cut).AnyProperty);
end;

procedure TTestConfigRefelection.Test_Wrting_ByValue;
var
  Cut: ISettings;
  MockHandler: TMock<ISettingHandler>;
begin
  MockHandler := TMock<ISettingHandler>.Create;
  MockHandler.Setup.Expect.Once.When.WriteString('System', 'Any', 'New Value');

  Cut := TFakeSettings.Create;
  TFakeSettings(Cut).AnyProperty := 'New Value';

  TConfigReflection.Save(TFakeSettings(Cut), MockHandler);

  MockHandler.VerifyAll();
end;

initialization
  TDUnitX.RegisterTestFixture(TTestConfigRefelection);

end.
