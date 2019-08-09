unit Test.Sample1;

interface

uses
  DUnitX.TestFramework;

type
  /// <summary>
  ///   Second one option, push scenario over write method. Start from source.
  ///   Second two option, pull scenario over read method. Start from sink...
  ///   Third scenario is mixed between push and pull. We start by any filter between source and sink...
  /// </summary>
  [TestFixture]
  TTestPipesAndFilters1 = class(TObject)
  public
    [Test]
    procedure Test_Pipeline;

    [Test]
    procedure Test_Pipeline_Shorter;
  end;

implementation

uses
  PipesAndFiltersSample1;

procedure TTestPipesAndFilters1.Test_Pipeline;
var
  Actual: string;
  Pipeline: IBasePipe<string>;
begin
  Pipeline := TBasePipe<string>.Create;
  Actual := Pipeline
    .Register(TStringUpperFilter.Create)
    .Register(TStringLowerFilter.Create)
    .Register(TStringDotsFilter.Create)
    .Register(TStringAddBeginFilter.Create('BEGIN => '))
    .Register(TStringAddEndFilter.Create(' <= END'))
    .Process('HeLLo...');

  Assert.AreEqual('BEGIN => hello <= END', Actual);
end;

procedure TTestPipesAndFilters1.Test_Pipeline_Shorter;
var
  Actual: string;
  //  Pipeline: IBasePipe<string>;
begin
  Actual := TBasePipe<string>
    .Create
    .Register(TStringUpperFilter.Create)
    .Register(TStringLowerFilter.Create)
    .Register(TStringDotsFilter.Create)
    .Register(TStringAddBeginFilter.Create('BEGIN => '))
    .Register(TStringAddEndFilter.Create(' <= END'))
    .Process('HeLLo...');

  Assert.AreEqual('BEGIN => hello <= END', Actual);
end;

initialization
  TDUnitX.RegisterTestFixture(TTestPipesAndFilters1);

end.

