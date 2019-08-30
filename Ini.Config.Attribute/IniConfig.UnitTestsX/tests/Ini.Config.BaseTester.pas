unit Ini.Config.BaseTester;

interface

{$M+}

uses
  DUnitX.TestFramework;

type
  [TestFixture]
  TTestBasetester = class(TObject)
  public
    const LocalSampleIni = '.\Sample.ini';
  public
    [SetupFixture]
    procedure SetupFixture;

    [TearDownFixture]
    procedure TearDownFixture;
  end;

{$M-}

implementation

uses
  System.SysUtils,
  System.IOUtils,
  System.Types,
  Nathan.Resources.ResourceManager;

{ TTestBasetester }

procedure TTestBasetester.SetupFixture;
begin
  ResourceManager.SaveToFile('Resource_SampleIni1', LocalSampleIni, RT_RCDATA);
end;

procedure TTestBasetester.TearDownFixture;
begin
  if TFile.Exists(LocalSampleIni) then
    TFile.Delete(LocalSampleIni);
end;

end.
