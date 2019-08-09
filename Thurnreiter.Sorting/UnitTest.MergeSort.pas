unit UnitTest.MergeSort;

interface

uses
  System.SysUtils,
  System.Types,
  System.Diagnostics,
  DUnitX.TestFramework;

{$M+}

type
  [TestFixture]
  TTestRecordMergeSort = class(TObject)
  strict private
    FTestStopWatch: TStopWatch;
    FInitBaseArrayFunc: TFunc<TIntegerDynArray>;
    FBaseArrayAsserts: TProc<TIntegerDynArray>;
  private
    function RunningMeasure(ToRun: TProc<TIntegerDynArray>): Int64;
  public
    [Setup]
    procedure SetUp();
  public
    [Test]
    procedure Test_FirstWithMergeSort();

    [Test]
    procedure Test_MyMergeSort_WithSimpleSortedList();

    [Test]
    procedure Test_MyMergeSort_WithSimpleUnsortedList();

    [Test]
    procedure Test_MyMergeSort_WithBaseData();

    [Test]
    procedure Test_MyMergeSort_WithBaseData_ManyTimes;

    [Test]
    procedure Test_MyMergeSort_WithOddElements;

    [Test]
    procedure Test_Random_255000_Compare;
  end;

{$M-}

implementation

uses
  DUnitX.Timeout,
  Nathan.Sorting;

function TTestRecordMergeSort.RunningMeasure(ToRun: TProc<TIntegerDynArray>): Int64;
var
  Actual: TIntegerDynArray;
begin
  //  Arrange...
  Actual := FInitBaseArrayFunc();
  FTestStopWatch := TStopwatch.StartNew;

  //  Act...
  ToRun(Actual);

  //  Assert...
  FTestStopWatch.Stop;
  Result := FTestStopWatch.ElapsedTicks;
  FBaseArrayAsserts(Actual);
end;

procedure TTestRecordMergeSort.SetUp();
begin
  FInitBaseArrayFunc :=
    function(): TIntegerDynArray
    begin
      SetLength(Result, 6);
      Result[0] := 8;
      Result[1] := 3;
      Result[2] := 10;
      Result[3] := 8;
      Result[4] := 2;
      Result[5] := 4;
    end;

  FBaseArrayAsserts :=
    procedure(Check: TIntegerDynArray)
    begin
      Assert.AreEqual(2, Check[0]);
      Assert.AreEqual(3, Check[1]);
      Assert.AreEqual(4, Check[2]);
      Assert.AreEqual(8, Check[3]);
      Assert.AreEqual(8, Check[4]);
      Assert.AreEqual(10, Check[5]);
    end;
end;

procedure TTestRecordMergeSort.Test_FirstWithMergeSort();
var
  Actual: Int64;
begin
  Actual := RunningMeasure(
    procedure(data: TIntegerDynArray)
    begin
      TSorting.Mergesort3(0, High(data), data);
    end);

  Assert.IsTrue((Actual < 200), Actual.ToString);
end;

procedure TTestRecordMergeSort.Test_MyMergeSort_WithSimpleSortedList;
var
  Actual: Int64;
begin
  InitialiseTimeout(2000);
  FInitBaseArrayFunc :=
    function(): TIntegerDynArray
    begin
      SetLength(Result, 4);
      Result[0] := 3;
      Result[1] := 5;
      Result[2] := 10;
      Result[3] := 22;
    end;

  FBaseArrayAsserts :=
    procedure(Check: TIntegerDynArray)
    begin
      Assert.AreEqual(3, Check[0], 'Has to be 3');
      Assert.AreEqual(5, Check[1], 'Has to be 5');
      Assert.AreEqual(10, Check[2], 'Has to be 10');
      Assert.AreEqual(22, Check[3], 'Has to be 22');
    end;

  Actual := RunningMeasure(
    procedure(data: TIntegerDynArray)
    begin
      TSorting.Mergesort(Low(data), High(data), data);
    end);

  Assert.IsTrue((Actual < 30000), Actual.ToString);
end;

procedure TTestRecordMergeSort.Test_MyMergeSort_WithSimpleUnsortedList;
begin
  FInitBaseArrayFunc :=
    function(): TIntegerDynArray
    begin
      SetLength(Result, 4);
      Result[0] := 3;
      Result[1] := 10;
      Result[2] := 5;
      Result[3] := 22;
    end;

  FBaseArrayAsserts :=
    procedure(Check: TIntegerDynArray)
    begin
      Assert.AreEqual(3, Check[0]);
      Assert.AreEqual(5, Check[1]);
      Assert.AreEqual(10, Check[2]);
      Assert.AreEqual(22, Check[3]);
    end;

  RunningMeasure(
    procedure(data: TIntegerDynArray)
    begin
      TSorting.Mergesort(Low(data), High(data), data);
    end);
end;

procedure TTestRecordMergeSort.Test_MyMergeSort_WithBaseData;
begin
  FInitBaseArrayFunc :=
    function(): TIntegerDynArray
    begin
      SetLength(Result, 4);
      Result[0] := 8;
      Result[1] := 3;
      Result[2] := 10;
      Result[3] := 5;
    end;

  FBaseArrayAsserts :=
    procedure(Check: TIntegerDynArray)
    begin
      Assert.AreEqual(3, Check[0]);
      Assert.AreEqual(5, Check[1]);
      Assert.AreEqual(8, Check[2]);
      Assert.AreEqual(10, Check[3]);
    end;

  RunningMeasure(
      procedure(data: TIntegerDynArray)
      begin
        TSorting.Mergesort(Low(data), High(data), data);
      end);
end;

procedure TTestRecordMergeSort.Test_MyMergeSort_WithBaseData_ManyTimes;
var
  Idx: Integer;
  ActualMeasure: Int64;
  ActualMeasureMy: Int64;
begin
  ActualMeasure := 0;
  for Idx := 0 to 2500 do
  begin
    ActualMeasure := RunningMeasure(
    procedure(data: TIntegerDynArray)
      begin
        TSorting.Mergesort3(Low(data), High(data), data);
      end);
  end;

  ActualMeasureMy := 0;
  for Idx := 0 to 2500 do
  begin
    ActualMeasureMy := RunningMeasure(
      procedure(data: TIntegerDynArray)
      begin
        TSorting.Mergesort(Low(data), High(data), data);
      end);
  end;

  Assert.IsTrue((ActualMeasure < 200), ActualMeasure.ToString);
  Assert.IsTrue((ActualMeasureMY < 200), ActualMeasureMy.ToString);
end;

procedure TTestRecordMergeSort.Test_MyMergeSort_WithOddElements;
begin
  FInitBaseArrayFunc :=
    function(): TIntegerDynArray
    begin
      SetLength(Result, 7);
      Result[0] := 3;
      Result[1] := 9;
      Result[2] := 5;
      Result[3] := 1;
      Result[4] := 7;
      Result[5] := 0;
      Result[6] := 1;
    end;

  FBaseArrayAsserts :=
    procedure(Check: TIntegerDynArray)
    begin
      Assert.AreEqual(0, Check[0]);
      Assert.AreEqual(1, Check[1]);
      Assert.AreEqual(1, Check[2]);
      Assert.AreEqual(3, Check[3]);
      Assert.AreEqual(5, Check[4]);
      Assert.AreEqual(7, Check[5]);
      Assert.AreEqual(9, Check[6]);
    end;

  RunningMeasure(
      procedure(data: TIntegerDynArray)
      begin
        TSorting.Mergesort(Low(data), High(data), data);
      end);
end;

procedure TTestRecordMergeSort.Test_Random_255000_Compare;
var
  Idx: Integer;
  ActualMeasure: Int64;
  ActualMeasureMy: Int64;
begin
  FInitBaseArrayFunc :=
    function(): TIntegerDynArray
    var
      Idx: Integer;
    begin
      Randomize;
      SetLength(Result, 256000);
      for Idx := 0 to 256000 do
        Result[Idx] := Random(10000);
    end;

  FBaseArrayAsserts :=
    procedure(Check: TIntegerDynArray)
    begin
      Assert.IsTrue(Check[High(Check) - 1] <= Check[High(Check)]);
      Assert.IsTrue(Check[Low(Check)] < Check[High(Check)]);
    end;

  ActualMeasure := RunningMeasure(
  procedure(data: TIntegerDynArray)
    begin
      TSorting.Mergesort3(Low(data), High(data), data);
    end);

  ActualMeasureMy := RunningMeasure(
    procedure(data: TIntegerDynArray)
    begin
      TSorting.Mergesort(Low(data), High(data), data);
    end);

  Assert.IsTrue((ActualMeasure < 500000), 'ActualMeasure: ' + ActualMeasure.ToString);
  Assert.IsTrue((ActualMeasureMy < 400000), 'ActualMeasureMy: ' + ActualMeasure.ToString);
end;

initialization
  TDUnitX.RegisterTestFixture(TTestRecordMergeSort);

end.
