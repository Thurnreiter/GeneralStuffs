unit Test.Kadane;

interface

uses
  System.SysUtils,
  System.Diagnostics,
  DUnitX.TestFramework,
  MaximumSubarrayProblem;

type
  [TestFixture]
  TTestMaxSubArr = class(TObject)
  private
    type
      TTestData = record
        Value: TArray<Integer>;
        Return: Integer;
        StartIdx: Integer;
        EndIdx: Integer;
      end;

    const
      TestData: array[0..3] of TTestData =
        ((Value: [-2, -5, 6, -2, -3, 1, 5, -6]; Return: 7; StartIdx: 2; EndIdx: 6),
         (Value: [1, 5, -1, 0, 10]; Return: 15; StartIdx: 2; EndIdx: 6),
         (Value: [-2, -3, 4, -1, -2, 1, 5, -3]; Return: 7; StartIdx: 2; EndIdx: 6),
         (Value: [1, 2, -5, 4, 3, 8, 5]; Return: 20; StartIdx: 3; EndIdx: 6));
  private
    FInnerFile: string;
    FWatch: TStopwatch;
    procedure ExecuteTestcase(const AMethodname: string; AAction: TFunc<TArray<Integer>, Integer>);
  public
    [SetupFixture]
    procedure SetupFixture;

    [Setup]
    procedure Setup;

    [Test]
    [RepeatTest(2)]
    procedure TestFormula();

    [Test]
    procedure TestFormulaStartEndIndex1();

    [Test]
    procedure TestFormulaStartEndIndex2();
  end;

implementation

uses
  System.IOUtils;

procedure TTestMaxSubArr.SetupFixture;
begin
  FInnerFile := TPath.Combine(TDirectory.GetCurrentDirectory, 'StopwatchResult.txt');
  TFile.AppendAllText(FInnerFile, '----------------------------------------');
end;

procedure TTestMaxSubArr.Setup;
begin
  FWatch := TStopwatch.Create;
end;

procedure TTestMaxSubArr.ExecuteTestcase(const AMethodname: string; AAction: TFunc<TArray<Integer>, Integer>);
var
  Idx: Integer;
  Actual: Integer;
begin
  for Idx := 0 to 2 do
  begin
    FWatch.Reset;
    FWatch.Start;
    Actual := AAction(TestData[Idx].Value);
    FWatch.Stop;

    TFile.AppendAllText(FInnerFile,
      Format('%s%-32.32s Maximum contiguous sum is: %4.4s - Correct %4.4s - Ticks: %4.4s',
        [sLineBreak,
         AMethodname,
         Actual.ToString,
         TestData[Idx].Return.ToString,
         FWatch.ElapsedTicks.ToString]));

    Assert.AreEqual(TestData[Idx].Return, Actual);
  end;
  TFile.AppendAllText(FInnerFile, sLineBreak);
end;

procedure TTestMaxSubArr.TestFormula;
begin
  ExecuteTestcase('Formula',
    function(AArray: TArray<Integer>): Integer
    begin
      Result := TMaximumSubarray.Formula(AArray);
    end);
end;

procedure TTestMaxSubArr.TestFormulaStartEndIndex1;
var
  Actual: Integer;
  ActualStart: Integer;
  ActualEnd: Integer;
begin
  ActualStart := 0;
  ActualEnd := 0;

  Actual := TMaximumSubarray.Formula(TestData[2].Value, ActualStart, ActualEnd);

  Assert.AreEqual(TestData[2].Return, Actual);
  Assert.AreEqual(2, ActualStart);
  Assert.AreEqual(6, ActualEnd);
end;

procedure TTestMaxSubArr.TestFormulaStartEndIndex2;
var
  Actual: Integer;
  ActualStart: Integer;
  ActualEnd: Integer;
begin
  ActualStart := 0;
  ActualEnd := 0;

  Actual := TMaximumSubarray.Formula(TestData[3].Value, ActualStart, ActualEnd);

  Assert.AreEqual(TestData[3].Return, Actual);
  Assert.AreEqual(3, ActualStart);
  Assert.AreEqual(6, ActualEnd);
end;

initialization
  TDUnitX.RegisterTestFixture(TTestMaxSubArr);

end.
