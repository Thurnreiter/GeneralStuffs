unit System.Diagnostics.Measure;

interface

uses
  System.SysUtils,
  System.Diagnostics;

type
  {$M+}
  TMeasureProc<TProcIn, TProcOut> = reference to procedure (Arg1: TProc; Arg2: TProc<TStopWatch>);

  TMeasureHelper = record helper for TStopWatch
    class procedure Measure(InAction: TProc; OutAction: TProc<Integer>); overload; static;
    class procedure Measure(InAction: TProc; OutAction: TProc<TStopWatch>); overload; static;

    class procedure Test(MP: TMeasureProc<TProc, TProc<TStopWatch>>); static;
  end;
  {$M-}

implementation

{ TMeasureHelper }

class procedure TMeasureHelper.Measure(InAction: TProc; OutAction: TProc<Integer>);
begin
  Measure(InAction,
    procedure(Watch: TStopWatch)
    begin
      OutAction(Watch.ElapsedTicks);
    end);
end;

class procedure TMeasureHelper.Measure(InAction: TProc; OutAction: TProc<TStopWatch>);
var
  Watch: TStopWatch;
begin
  Watch := TStopWatch.Create();
  Watch.Start;
  InAction();
  Watch.Stop;
  if Assigned(OutAction) then
    OutAction(Watch);
end;

class procedure TMeasureHelper.Test(MP: TMeasureProc<TProc, TProc<TStopWatch>>);
var
  MYProc: TProc;
  MYWatch: TProc<TStopWatch>;
begin
  //  Beispiele:
  //  MPNEW.View.JobsModel.pas
  //  procedure TJobsModel.CatchExceptionsBeforeSettingQuote(Value: TFunc < IList < IJob >> );
  //  begin
  //    CatchExceptionsBeforeSet < IList < IJob >> (Value, AddEachToSelectedMenus);
  //    AddLinkedJobsAutomaticallyToQuote();
  //  end;

  MYProc :=
    procedure()
    begin
      Sleep(10); //  Do something that is measured...
    end;

  MYWatch :=
    procedure(Watch: TStopWatch)
    begin
      Sleep(10); //  Give back the result...
    end;

  if Assigned(MP) then
    MP(MYProc, MYWatch);
end;

end.

