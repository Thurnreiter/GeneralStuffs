unit Test.System.Diagnostics;

interface

uses
  System.SysUtils,
  System.Diagnostics,
  DUnitX.TestFramework;

type
  [TestFixture]
  TSystemDiagnosticsTest = class(TObject)
  private
    procedure Dummy(MYProc: TProc; MYWatch: TProc<TStopWatch>);
  private const
    DiagnosticsMessageDurationTests = 'Test hat zu lange gedauert [Value: %d].';
  public
    [Test]
    procedure TestHelperAsASample;

    [Test]
    procedure TestWitoutHelperAsASample;

    [Test]
    procedure TestMeasureWithTestMethod;
  end;

implementation

uses
  System.Diagnostics.Measure;

procedure TSystemDiagnosticsTest.TestHelperAsASample;
begin
  TStopWatch.Measure(
    procedure()
    var
      Idx: Integer;
      ActualSB: TStringBuilder;
    begin
      //  Arrange...
      ActualSB := TStringBuilder.Create;
      try
        //  Act...
        for Idx := 0 to 1000000 do
          ActualSB.Append(Idx.ToString);

        //  Assert...
        Assert.AreEqual(5888897, ActualSB.Length);
      finally
        ActualSB.Free;
      end;
    end,
    procedure(Watch: TStopWatch)
    begin
      Assert.IsTrue((Watch.ElapsedTicks < 800000),
        Format(DiagnosticsMessageDurationTests, [Watch.ElapsedTicks]));
    end);
end;

procedure TSystemDiagnosticsTest.TestWitoutHelperAsASample;
var
  Watch: TStopWatch;

  Idx: Integer;
  ActualSB: TStringBuilder;
begin
  Watch := TStopWatch.Create();
  Watch.Start;

  //  Arrange...
  ActualSB := TStringBuilder.Create;
  try
    //  Act...
    for Idx := 0 to 1000000 do
      ActualSB.Append(Idx.ToString);

    //  Assert...
    Assert.AreEqual(5888897, ActualSB.Length);
  finally
    ActualSB.Free;
  end;

  Watch.Stop;
  Assert.IsTrue((Watch.ElapsedTicks < 800000),
    Format(DiagnosticsMessageDurationTests, [Watch.ElapsedTicks]));
end;

procedure TSystemDiagnosticsTest.Dummy(MYProc: TProc; MYWatch: TProc<TStopWatch>);
begin
  MYProc;
  Sleep(10); //  Do something...
  MYWatch(TStopWatch.Create);
end;

procedure TSystemDiagnosticsTest.TestMeasureWithTestMethod();
var
  My: TMeasureProc<TProc, TProc<TStopWatch>>;
begin
  //  Variant 1...
  My := Dummy;

  //  Variant 2...
  //  My := procedure(MYProc: TProc; MYWatch: TProc<TStopWatch>)
  //    begin
  //      MYProc;
  //      Sleep(10); //  Do something...
  //      MYWatch(TStopWatch.Create);
  //    end;

  //  Need it for Variant 1 + 2...
  TStopwatch.Test(My);

  //  Variant 3...
  //  TStopwatch.Test(procedure(MYProc: TProc; MYWatch: TProc<TStopWatch>)
  //    begin
  //      MYProc;
  //      Sleep(10); //  Do something...
  //      MYWatch(TStopWatch.Create);
  //    end);

  Assert.IsTrue(True);
end;

initialization
  TDUnitX.RegisterTestFixture(TSystemDiagnosticsTest);

end.
