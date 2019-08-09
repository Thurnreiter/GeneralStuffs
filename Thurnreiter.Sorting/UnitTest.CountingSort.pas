unit UnitTest.CountingSort;

interface

//{$EXTENSION 'Hello.exe'}

uses
  System.SysUtils,
  System.Types,
  System.Diagnostics,
  DUnitX.TestFramework;

{$M+}

type
  [TestFixture]
  TTestRecordCountingSort = class(TObject)
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
    procedure Test_FirstWithCountingSort();

    [Test]
    procedure Test_1024OnceFirstWithCountingSort();

    [Test]
    procedure Test_WithClassicTArraySort();

    [Test]
    procedure Test_1024OnceWithClassicTArraySort();

    [Test]
    procedure Test_CountingSort_Random_255000();

    [Test]
    procedure Test_CountingSort_Random_255000_Compare();

    [Test]
    procedure Test_CountingSort_WithBiggerValuesAndShortCounts();

    [Test]
    procedure Test_CountingSort_WithBiggerValuesAndShortCounts_Compare();

    [Test]
    procedure Test_CountingSort_WithSmallArrayEveryElementAndShortCounts_Compare();

    [Test]
    procedure Test_CountingSort_Descending();

    [Test]
    procedure Test_FirstWithCountingSort_Generic();

    [Test]
    procedure Test_FirstWithCountingSort2();

    [Test]
    procedure Test_FirstWithCountingSort2_ForCheckDescription();
  end;

{$M-}

implementation

uses
  System.Math,
  System.Generics.Collections,
  Nathan.Sorting;

function TTestRecordCountingSort.RunningMeasure(ToRun: TProc<TIntegerDynArray>): Int64;
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

procedure TTestRecordCountingSort.SetUp();
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
      Assert.AreEqual(2, Check[0], 'Has to be 2');
      Assert.AreEqual(3, Check[1], 'Has to be 3');
      Assert.AreEqual(4, Check[2], 'Has to be 4');
      Assert.AreEqual(8, Check[3], 'Has to be 8');
      Assert.AreEqual(8, Check[4], 'Has to be 8');
      Assert.AreEqual(10, Check[5], 'Has to be 10');
    end;
end;

procedure TTestRecordCountingSort.Test_FirstWithCountingSort();
var
  Actual: Int64;
begin
  Actual := RunningMeasure(
    procedure(data: TIntegerDynArray)
    begin
      TSorting.CountingSort(data);
    end);

  Assert.IsTrue((Actual < 20), Actual.ToString);
end;

procedure TTestRecordCountingSort.Test_1024OnceFirstWithCountingSort();
var
  Idx: Integer;
  Actual: Int64;
begin
  Actual := 0;
  for Idx := 0 to 1023 do
  begin
    Actual := Actual + RunningMeasure(
      procedure(data: TIntegerDynArray)
      begin
        TSorting.CountingSort(data);
      end);
  end;

  Assert.IsTrue((Actual < 6500), 'Measure: ' + Actual.ToString);
end;

procedure TTestRecordCountingSort.Test_WithClassicTArraySort();
var
  Actual: Int64;
begin
  Actual := RunningMeasure(
    procedure(data: TIntegerDynArray)
    begin
      TArray.Sort<Integer>(data);
    end);

  Assert.IsTrue((Actual < 250), Actual.ToString);
end;

procedure TTestRecordCountingSort.Test_1024OnceWithClassicTArraySort();
var
  Idx: Integer;
  Actual: Int64;
begin
  Actual := 0;
  for Idx := 0 to 1023 do
  begin
    Actual := Actual + RunningMeasure(
      procedure(data: TIntegerDynArray)
      begin
        TArray.Sort<Integer>(data);
      end);
  end;

  Assert.IsTrue(Actual < 6000, '1024 running tests need: ' + Actual.ToString + ' Ticks.');
end;

procedure TTestRecordCountingSort.Test_CountingSort_Random_255000();
var
  Idx: Integer;
  ActualMeasure: Int64;
  Actual: TIntegerDynArray;
begin
  //  Arrange...
  Randomize;
  SetLength(Actual, 255000);
  for Idx := 0 to 255000 do
    Actual[Idx] := Random(100);

  //  Act...
  FTestStopWatch := TStopwatch.StartNew;
  TSorting.CountingSort(Actual);
  FTestStopWatch.Stop;
  ActualMeasure := FTestStopWatch.ElapsedTicks;

  //  Assert...
  Assert.IsTrue(Actual[Low(Actual)] < Actual[High(Actual)]);
  Assert.IsTrue((ActualMeasure < 20000), 'Test_CountingSort_Random_255000() needs: ' + ActualMeasure.ToString + ' Ticks.');
end;

procedure TTestRecordCountingSort.Test_CountingSort_Random_255000_Compare;
var
  ActualMeasureCS: Int64;
  ActualMeasureCL: Int64;
begin
  FInitBaseArrayFunc :=
    function(): TIntegerDynArray
    var
      Idx: Integer;
    begin
      Randomize;
      SetLength(Result, 255000);
      for Idx := 0 to 255000 do
        Result[Idx] := Random(100);
    end;

  FBaseArrayAsserts :=
    procedure(Check: TIntegerDynArray)
    begin
      //  Just only a simple test...
      Assert.IsTrue(Check[Low(Check)] < Check[High(Check)]);
    end;

  ActualMeasureCL := RunningMeasure(
    procedure(data: TIntegerDynArray)
    begin
      TArray.Sort<Integer>(data);
    end);

  ActualMeasureCS := RunningMeasure(
    procedure(data: TIntegerDynArray)
    begin
      TSorting.CountingSort(data);
    end);

  Assert.IsTrue((ActualMeasureCS < 15000), 'ActualMeasureCS: ' + ActualMeasureCS.ToString);
  Assert.IsTrue((ActualMeasureCL < 280000), 'ActualMeasureCL: ' + ActualMeasureCL.ToString);
end;

procedure TTestRecordCountingSort.Test_CountingSort_WithBiggerValuesAndShortCounts();
var
  ActualMeasure: Int64;
  Actual: TIntegerDynArray;
begin
  //  Arrange...
  SetLength(Actual, 12);
  Actual[00] := 28;
  Actual[01] := 10;
  Actual[02] := 72;
  Actual[03] := 19;
  Actual[04] := 3;
  Actual[05] := 4;
  Actual[06] := 7;
  Actual[07] := 1;
  Actual[08] := 1;
  Actual[09] := 0;
  Actual[10] := 32458;
  Actual[11] := 144;

  //  Act...
  FTestStopWatch := TStopwatch.StartNew;
  TSorting.CountingSort(Actual);
  FTestStopWatch.Stop;
  ActualMeasure := FTestStopWatch.ElapsedTicks;

  //  Assert...
  Assert.AreEqual(0, Actual[0]);
  Assert.AreEqual(1, Actual[1]);
  Assert.AreEqual(1, Actual[2]);
  Assert.AreEqual(3, Actual[3]);
  Assert.AreEqual(4, Actual[4]);
  Assert.AreEqual(7, Actual[5]);
  Assert.AreEqual(10, Actual[6]);
  Assert.AreEqual(19, Actual[7]);
  Assert.AreEqual(28, Actual[8]);
  Assert.AreEqual(72, Actual[9]);
  Assert.AreEqual(144, Actual[10]);
  Assert.AreEqual(32458, Actual[11]);
  Assert.IsTrue((ActualMeasure < 2500), ActualMeasure.ToString);
end;

procedure TTestRecordCountingSort.Test_CountingSort_WithBiggerValuesAndShortCounts_Compare();
var
  ActualMeasureCS: Int64;
  ActualMeasureCL: Int64;
begin
  FInitBaseArrayFunc :=
    function(): TIntegerDynArray
    begin
      SetLength(Result, 12);
      Result[00] := 28;
      Result[01] := 2568;
      Result[02] := 72;
      Result[03] := 19;
      Result[04] := 3;
      Result[05] := 853;
      Result[06] := 7;
      Result[07] := 1;
      Result[08] := 1;
      Result[09] := 0;
      Result[10] := 32458;
      Result[11] := 144;
    end;

  FBaseArrayAsserts :=
    procedure(Check: TIntegerDynArray)
    begin
      Assert.AreEqual(0, Check[0]);
      Assert.AreEqual(1, Check[1]);
      Assert.AreEqual(1, Check[2]);
      Assert.AreEqual(3, Check[3]);
      Assert.AreEqual(7, Check[4]);
      Assert.AreEqual(19, Check[5]);
      Assert.AreEqual(28, Check[6]);
      Assert.AreEqual(72, Check[7]);
      Assert.AreEqual(144, Check[8]);
      Assert.AreEqual(853, Check[9]);
      Assert.AreEqual(2568, Check[10]);
      Assert.AreEqual(32458, Check[11]);
    end;

  ActualMeasureCL := RunningMeasure(
    procedure(data: TIntegerDynArray)
    begin
      TArray.Sort<Integer>(data);
    end);

  ActualMeasureCS := RunningMeasure(
    procedure(data: TIntegerDynArray)
    begin
      TSorting.CountingSort(data);
    end);

  Assert.IsTrue((ActualMeasureCS < 2000), 'ActualMeasureCS: ' + ActualMeasureCS.ToString);
  Assert.IsTrue((ActualMeasureCL < 200), 'ActualMeasureCL: ' + ActualMeasureCL.ToString);
end;

procedure TTestRecordCountingSort.Test_CountingSort_WithSmallArrayEveryElementAndShortCounts_Compare;
var
  ActualMeasureCS: Int64;
  ActualMeasureCL: Int64;
begin
  FInitBaseArrayFunc :=
    function(): TIntegerDynArray
    begin
      SetLength(Result, 9);
      Result[00] := 3;
      Result[01] := 5;
      Result[02] := 7;
      Result[03] := 9;
      Result[04] := 1;
      Result[05] := 2;
      Result[06] := 4;
      Result[07] := 6;
      Result[08] := 8;
    end;

  FBaseArrayAsserts :=
    procedure(Check: TIntegerDynArray)
    begin
      Assert.AreEqual(1, Check[0]);
      Assert.AreEqual(2, Check[1]);
      Assert.AreEqual(3, Check[2]);
      Assert.AreEqual(4, Check[3]);
      Assert.AreEqual(5, Check[4]);
      Assert.AreEqual(6, Check[5]);
      Assert.AreEqual(7, Check[6]);
      Assert.AreEqual(8, Check[7]);
      Assert.AreEqual(9, Check[8]);
    end;

  ActualMeasureCL := RunningMeasure(
    procedure(data: TIntegerDynArray)
    begin
      TArray.Sort<Integer>(data);
    end);

  ActualMeasureCS := RunningMeasure(
    procedure(data: TIntegerDynArray)
    begin
      TSorting.CountingSort(data);
    end);

  Assert.IsTrue((ActualMeasureCS < 10), 'ActualMeasureCS: ' + ActualMeasureCS.ToString);
  Assert.IsTrue((ActualMeasureCL < 20), 'ActualMeasureCL: ' + ActualMeasureCL.ToString);
end;

procedure TTestRecordCountingSort.Test_CountingSort_Descending;
var
  Actual: Int64;
begin
  FBaseArrayAsserts :=
    procedure(Check: TIntegerDynArray)
    begin
      Assert.AreEqual(10, Check[0]);
      Assert.AreEqual(8, Check[1]);
      Assert.AreEqual(8, Check[2]);
      Assert.AreEqual(4, Check[3]);
      Assert.AreEqual(3, Check[4]);
      Assert.AreEqual(2, Check[5]);
    end;

  Actual := RunningMeasure(
    procedure(data: TIntegerDynArray)
    begin
      TSorting.CountingSort(data, False);
    end);

  Assert.IsTrue((Actual < 20), Actual.ToString);
end;

procedure TTestRecordCountingSort.Test_FirstWithCountingSort_Generic;
var
  Actual: TIntegerDynArray;
begin
  SetLength(Actual, 6);
  Actual[0] := 8;
  Actual[1] := 3;
  Actual[2] := 10;
  Actual[3] := 8;
  Actual[4] := 2;
  Actual[5] := 4;

  Actual := TSorting.CountingSort2(Actual);

  Assert.AreEqual(2, Actual[0]);
  Assert.AreEqual(3, Actual[1]);
  Assert.AreEqual(4, Actual[2]);
  Assert.AreEqual(8, Actual[3]);
  Assert.AreEqual(8, Actual[4]);
  Assert.AreEqual(10, Actual[5]);
end;

procedure TTestRecordCountingSort.Test_FirstWithCountingSort2;
var
  ActualMeasure: Int64;
  Actual: TIntegerDynArray;
begin
  FInitBaseArrayFunc :=
    function(): TIntegerDynArray
    begin
      SetLength(Result, 16);
      Result[00] := 2;
      Result[01] := 1;
      Result[02] := 4;
      Result[03] := 5;
      Result[04] := 7;
      Result[05] := 1;
      Result[06] := 1;
      Result[07] := 8;
      Result[08] := 9;
      Result[09] := 10;
      Result[10] := 11;
      Result[11] := 14;
      Result[12] := 15;
      Result[13] := 3;
      Result[14] := 2;
      Result[15] := 4;
    end;

  FBaseArrayAsserts :=
    procedure(Check: TIntegerDynArray)
    begin
      Assert.AreEqual(1, Check[00]);
      Assert.AreEqual(1, Check[01]);
      Assert.AreEqual(1, Check[02]);
      Assert.AreEqual(2, Check[03]);
      Assert.AreEqual(2, Check[04]);
      Assert.AreEqual(3, Check[05]);
      Assert.AreEqual(4, Check[06]);
      Assert.AreEqual(4, Check[07]);
      Assert.AreEqual(5, Check[08]);
      Assert.AreEqual(7, Check[09]);
      Assert.AreEqual(8, Check[10]);
      Assert.AreEqual(9, Check[11]);
      Assert.AreEqual(10, Check[12]);
      Assert.AreEqual(11, Check[13]);
      Assert.AreEqual(14, Check[14]);
      Assert.AreEqual(15, Check[15]);
    end;

  Actual := FInitBaseArrayFunc();
  FTestStopWatch := TStopwatch.StartNew;

//  Actual := TSorting.CountingSort2(Actual);
  TSorting.CountingSort(Actual);

  FTestStopWatch.Stop;
  ActualMeasure := FTestStopWatch.ElapsedTicks;
  FBaseArrayAsserts(Actual);

  Assert.IsTrue((ActualMeasure < 20), ActualMeasure.ToString);
end;

procedure TTestRecordCountingSort.Test_FirstWithCountingSort2_ForCheckDescription;
var
  ActualMeasure: Int64;
  Actual: TIntegerDynArray;
begin
  FInitBaseArrayFunc :=
    function(): TIntegerDynArray
    begin
      SetLength(Result, 5);
      Result[00] := 4;
      Result[01] := 2;
      Result[02] := 1;
      Result[03] := 5;
      Result[04] := 1;
    end;

  FBaseArrayAsserts :=
    procedure(Check: TIntegerDynArray)
    begin
      Assert.AreEqual(1, Check[00]);
      Assert.AreEqual(1, Check[01]);
      Assert.AreEqual(2, Check[02]);
      Assert.AreEqual(4, Check[03]);
      Assert.AreEqual(5, Check[04]);
    end;

  Actual := FInitBaseArrayFunc();
  FTestStopWatch := TStopwatch.StartNew;

  Actual := TSorting.CountingSort2(Actual);

  FTestStopWatch.Stop;
  ActualMeasure := FTestStopWatch.ElapsedTicks;
  FBaseArrayAsserts(Actual);

  Assert.IsTrue((ActualMeasure < 20), ActualMeasure.ToString);
end;

initialization
  TDUnitX.RegisterTestFixture(TTestRecordCountingSort);

end.
