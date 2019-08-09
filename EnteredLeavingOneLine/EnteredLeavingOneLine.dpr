program EnteredLeavingOneLine;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  Nathan.OOS.Logger in 'Nathan.OOS.Logger.pas';

procedure Dummy();
var
  Idx: Integer;
begin
  NOOSLogger.EnterLeave('Dummy');

  //  Do something...
  for Idx := 0 to 10 do
    Writeln(Idx.ToString);
end;

begin
  try
    Dummy();
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;

  Readln;
end.
