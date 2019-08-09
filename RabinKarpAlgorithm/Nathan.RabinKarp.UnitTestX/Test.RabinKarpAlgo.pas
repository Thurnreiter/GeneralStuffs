unit Test.RabinKarpAlgo;

interface

{$M+}

uses
  System.Diagnostics,
  DUnitX.TestFramework,
  Nathan.RabinKarpAlgorithm;

type
  [TestFixture]
  TTestRabinKarpAlgo = class
  strict private
    FCut: IRabinKarpAlgorithm;
    procedure AssertExpectedReturns(AExpected: TArray<string>; AActual: TArray<Int64>);
  private
    const LongDummyText1 = 'Far far away, behind the word mountains, far from the '
      + 'countries Vokalia and Consonantia, there live the blind texts.';
    const LongDummyText2 = 'The European languages are members of the same family. '
      + 'Their separate existence is a myth. For science, music, sport, etc, Europe '
      + 'uses the same vocabulary. The languages only differ in their grammar, their '
      + 'pronunciation and their most common words. Everyone realizes why a new common '
      + 'language would be desirable: one could refuse to pay expensive translators. '
      + 'To achieve this, it would be necessary to have uniform grammar, pronunciation '
      + 'and more common words. If several languages coalesce, the grammar of the resulting '
      + 'language is more simple and regular than that of the individual languages. '
      + 'The new common language will be more';
  public
    [Setup]
    procedure Setup();

    [TearDown]
    procedure TearDown();

    [Test]
    [Ignore('Ignore this test')]
    procedure Test_HasNoMemoryLeaks;

    [Test]
    [TestCase('Search01', 'THIS IS A TEST TEXT,TEST,10')]
    [TestCase('Search02', 'yeminsajid,nsa,4')]
    [TestCase('Search04', '0123456abcde,abcde,7')]
    [TestCase('Search05', '012345678abcde,abcde,9')]
    [TestCase('Search06', '0123456785785758,abcde,-1')]
    [TestCase('Search07', '762130872508,1308,3')]
    [TestCase('Search08', '8130887508,1308,1')]
    [TestCase('Search10', '242412,12,4')]
    [TestCase('Search11', '0123456785785758,,-1')]
    [TestCase('Search12', ',12,-1')]
    [TestCase('Search13', 'Hello world,Hello,0')]
    [TestCase('Search14', 'Hello world,world,6')]
    procedure Test_SearchWithValues(const AValueText, AValuePattern: string; AExpectedReturn: Integer);

    [Test]
    [TestCase('MultiSearch01', 'AABAACAADAABAABA,AABA,0;9;12')]
    [TestCase('MultiSearch02', 'abracadabra,abr,0;7')]
    [TestCase('MultiSearch03', 'yeminsajidnsa,nsa,4;10')]
    procedure Test_SearchWithMultipleMatches(const AValueText, AValuePattern, AExpectedReturns: string);

    [Test]
    [TestCase('Multi01', LongDummyText1 + '|the|21;50;89;100', '|')]
    [TestCase('Multi02', '2458a667c3479|24;667|0;5', '|')]
    [TestCase('Multi03', '2458a667c3479|667|5', '|')]
    [TestCase('Multi04', LongDummyText1 + '|the;from|21;45;50;89;100', '|')]
    [TestCase('Multi05', LongDummyText1 + '|from|45', '|')]
    procedure Test_SearchWithMultiplePatternsAndMatches(const AValueText, AValuesPattern, AExpectedReturns: string);

    [Test]
    [TestCase('LongPatternSearch01', LongDummyText2 + '|pronunciation|206;424', '|')]
    procedure Test_SearchWithLongPatternElements(const AValueText, AValuePattern, AExpectedReturns: string);

    [Test]
    [TestCase('IgnoreCaseSearch01', LongDummyText2 + '|pronunciation|206;424', '|')]
    [TestCase('IgnoreCaseSearch02', LongDummyText2 + '|PRONUNCIATION|206;424', '|')]
    procedure Test_SearchIgnoreCase(const AValueText, AValuePattern, AExpectedReturns: string);

    [Test]
    [TestCase('Intrinsic09', 'yeminsajidnsa,nsa,4')]
    procedure Test_SearchWithIntrinsicFunc(const AValueText, AValuePattern: string; AExpectedReturn: Integer);
  end;

{$M-}

implementation

uses
  System.SysUtils;

procedure TTestRabinKarpAlgo.Setup();
begin
  FCut := nil;
end;

procedure TTestRabinKarpAlgo.TearDown();
begin
  FCut := nil;
end;

procedure TTestRabinKarpAlgo.AssertExpectedReturns(AExpected: TArray<string>; AActual: TArray<Int64>);
var
  Idx: Integer;
begin
  Assert.AreEqual(Length(AExpected), Length(AActual));
  for Idx := Low(AExpected) to High(AExpected) do
    Assert.AreEqual(AExpected[Idx].ToInt64, AActual[Idx]);
end;

procedure TTestRabinKarpAlgo.Test_HasNoMemoryLeaks;
begin
  //  Arrange...
  FCut := TRabinKarpAlgorithm.Create();

  //  Assert...
  Assert.IsNotNull(FCut);
end;

procedure TTestRabinKarpAlgo.Test_SearchIgnoreCase(const AValueText, AValuePattern, AExpectedReturns: string);
var
  LExpectedReturns: TArray<string>;
  ActualMatches: TArray<Int64>;
begin
  //  Arrange...
  FCut := TRabinKarpAlgorithm.Create();
  LExpectedReturns := AExpectedReturns.Split([';']);

  //  Act...
  ActualMatches := FCut
    .IgnoreCase(True)
    .Search([AValuePattern], AValueText);

  //  Assert...
  AssertExpectedReturns(LExpectedReturns, ActualMatches);
end;

procedure TTestRabinKarpAlgo.Test_SearchWithIntrinsicFunc(const AValueText, AValuePattern: string; AExpectedReturn: Integer);
var
  Diag: TStopwatch;
  Idx: Integer;
  Actual: Integer;
begin
  //  Arrange...
  Diag := TStopWatch.StartNew;

  //  Act...
  for Idx := 0 to 1000 do
    Actual := AValueText.IndexOf(AValuePattern);

  Diag.Stop;

  //  Assert...
  Assert.AreEqual(AExpectedReturn, Actual);
  Assert.IsTrue((Diag.ElapsedTicks < 100), Diag.ElapsedTicks.ToString);
end;

procedure TTestRabinKarpAlgo.Test_SearchWithLongPatternElements(const AValueText, AValuePattern, AExpectedReturns: string);
var
  LExpectedReturns: TArray<string>;
  ActualMatches: TArray<Int64>;
begin
  //  Arrange...
  FCut := TRabinKarpAlgorithm.Create();
  LExpectedReturns := AExpectedReturns.Split([';']);

  //  Act...
  ActualMatches := FCut.Search([AValuePattern], AValueText);

  //  Assert...
  AssertExpectedReturns(LExpectedReturns, ActualMatches);
end;

procedure TTestRabinKarpAlgo.Test_SearchWithMultipleMatches(const AValueText, AValuePattern, AExpectedReturns: string);
var
  LExpectedReturns: TArray<string>;
  ActualMatches: TArray<Int64>;
begin
  //  Arrange...
  FCut := TRabinKarpAlgorithm.Create();
  LExpectedReturns := AExpectedReturns.Split([';']);

  //  Act...
  ActualMatches := FCut.Search([AValuePattern], AValueText);

  //  Assert...
  AssertExpectedReturns(LExpectedReturns, ActualMatches);
end;

procedure TTestRabinKarpAlgo.Test_SearchWithMultiplePatternsAndMatches(const AValueText, AValuesPattern, AExpectedReturns: string);
var
  LExpectedReturns: TArray<string>;
  ActualMatches: TArray<Int64>;
begin
  //  Arrange...
  FCut := TRabinKarpAlgorithm.Create();
  LExpectedReturns := AExpectedReturns.Split([';']);

  //  Act...
  ActualMatches := FCut.Search(AValuesPattern.Split([';']), AValueText);

  //  Assert...
  AssertExpectedReturns(LExpectedReturns, ActualMatches);
end;

procedure TTestRabinKarpAlgo.Test_SearchWithValues;
var
  Idx: Integer;
  Actual: Int64;
begin
  //  Arrange...
  FCut := TRabinKarpAlgorithm.Create();

  //  Act...
  for Idx := 0 to 1000 do
    Actual := FCut.Search(AValuePattern, AValueText);

  //  Assert...
  Assert.AreEqual<Int64>(AExpectedReturn, Actual);
end;

initialization
  TDUnitX.RegisterTestFixture(TTestRabinKarpAlgo, 'RabinKarpAlgo');

end.
