unit Test.Sample2;

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
  TTestPipesAndFilters2 = class(TObject)
  public
    [Setup]
    procedure Setup;

    [TearDown]
    procedure TearDown;

    [Test]
    procedure Test_SecondOneOption_Push_Prop;

    [Test]
    procedure Test_SecondOneOption_Push_Constructor;

    [Test]
    procedure Test_SecondTwoOption_Pull_Prop;

    [Test]
    procedure Test_SecondTwoOption_Pull_Constructor;

    [Test]
    procedure Test_ThirdOption_Mixed_Prop;

    [Test]
    procedure Test_ThirdOption_Mixed_Constructor;
  end;

implementation

uses
  PipesAndFiltersSample2;

procedure TTestPipesAndFilters2.Setup;
begin
end;

procedure TTestPipesAndFilters2.TearDown;
begin
end;

procedure TTestPipesAndFilters2.Test_SecondOneOption_Push_Prop;
var
  Actual: string;
  PipesAndFilterDS: IPipesAndFilters<string>;
  PipesAndFilterUpper: IPipesAndFilters<string>;
  PipesAndFilterSink: IPipesAndFiltersSink<string>;
begin
  PipesAndFilterDS := TPipesAndFiltersSource.Create();
  PipesAndFilterUpper := TPipesAndFiltersUpper.Create();
  PipesAndFilterSink := TPipesAndFiltersSink.Create();

  PipesAndFilterDS.Filter := PipesAndFilterUpper;
  PipesAndFilterUpper.Filter := PipesAndFilterSink;

  PipesAndFilterDS.Write('Start Push =>'); //  Push scenario...
  Actual := PipesAndFilterSink.GetValue;
  Assert.AreEqual('Start Push => 1.Source  2.UPPER  3.Sink ', Actual);
end;

procedure TTestPipesAndFilters2.Test_SecondOneOption_Push_Constructor;
var
  Actual: string;
  PipesAndFilter: IPipesAndFilters<string>;
  PipesAndFilterSink: IPipesAndFiltersSink<string>;
begin
  PipesAndFilterSink := TPipesAndFiltersSink.Create(nil);
  PipesAndFilter := TPipesAndFiltersSource
    .Create(
      TPipesAndFiltersUpper
        .Create(PipesAndFilterSink)
    );

  PipesAndFilter.Write('Start Push =>'); //  Push scenario...
  Actual := PipesAndFilterSink.GetValue;
  Assert.AreEqual('Start Push => 1.Source  2.UPPER  3.Sink ', Actual);
end;

procedure TTestPipesAndFilters2.Test_SecondTwoOption_Pull_Prop;
var
  Actual: string;
  PipesAndFilterDS: IPipesAndFilters<string>;
  PipesAndFilterUpper: IPipesAndFilters<string>;
  PipesAndFilterSink: IPipesAndFiltersSink<string>;
begin
  PipesAndFilterDS := TPipesAndFiltersSource.Create();
  PipesAndFilterUpper := TPipesAndFiltersUpper.Create();
  PipesAndFilterSink := TPipesAndFiltersSink.Create();

  PipesAndFilterUpper.Filter := PipesAndFilterDS;
  PipesAndFilterSink.Filter := PipesAndFilterUpper;

  PipesAndFilterSink.Read('<= End Pull'); //  Pull scenario...
  Actual := PipesAndFilterSink.GetValue;
  Assert.AreEqual(' 3.Sink  2.UPPER  1.Source <= End Pull', Actual);
end;

procedure TTestPipesAndFilters2.Test_SecondTwoOption_Pull_Constructor;
var
  Actual: string;
  PipesAndFilterSink: IPipesAndFiltersSink<string>;
begin
  PipesAndFilterSink := TPipesAndFiltersSink
    .Create(
      TPipesAndFiltersUpper
        .Create(
          TPipesAndFiltersSource.Create(nil)));

  PipesAndFilterSink.Read('<= End Pull'); //  Pull scenario...
  Actual := PipesAndFilterSink.GetValue;
  Assert.AreEqual(' 3.Sink  2.UPPER  1.Source <= End Pull', Actual);
end;

procedure TTestPipesAndFilters2.Test_ThirdOption_Mixed_Prop;
var
  Actual: string;
  PipesAndFilterDS: IPipesAndFilters<string>;
  PipesAndFilterUpper: IPipesAndFilters<string>;
  PipesAndFilterSink: IPipesAndFiltersSink<string>;
begin
  PipesAndFilterDS := TPipesAndFiltersSource.Create();
  PipesAndFilterUpper := TPipesAndFiltersUpper.Create();
  PipesAndFilterSink := TPipesAndFiltersSink.Create();

  PipesAndFilterUpper.Filter := PipesAndFilterDS;
  PipesAndFilterSink.Filter := PipesAndFilterUpper;

  Actual := PipesAndFilterUpper.Read('<= Filter Start'); //  Pull scenario...
  Assert.AreEqual(' 2.UPPER  1.Source <= Filter Start', Actual);
  PipesAndFilterSink.Write(Actual); //  Push scenario...
  Actual := PipesAndFilterSink.GetValue;
  Assert.AreEqual(' 2.UPPER  1.Source <= Filter Start 3.Sink ', Actual);
end;

procedure TTestPipesAndFilters2.Test_ThirdOption_Mixed_Constructor;
var
  Actual: string;
  PipesAndFilterUpper: IPipesAndFilters<string>;
  PipesAndFilterSink: IPipesAndFiltersSink<string>;
begin
  PipesAndFilterUpper := TPipesAndFiltersUpper.Create(TPipesAndFiltersSource.Create(nil));
  PipesAndFilterSink := TPipesAndFiltersSink.Create(PipesAndFilterUpper);

  Actual := PipesAndFilterUpper.Read('<= Filter Start'); //  Pull scenario...
  Assert.AreEqual(' 2.UPPER  1.Source <= Filter Start', Actual);

  PipesAndFilterSink.Write(Actual); //  Push scenario...
  Actual := PipesAndFilterSink.GetValue;
  Assert.AreEqual(' 2.UPPER  1.Source <= Filter Start 3.Sink ', Actual);
end;

initialization
  TDUnitX.RegisterTestFixture(TTestPipesAndFilters2);

end.
