program ClassFactory;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  FastMM4,
  System.SysUtils,
  Nathan.Factory in 'Nathan.Factory.pas',
  Nathan.Generic.Factory in 'Nathan.Generic.Factory.pas';

var
  myinstance: IDummy;
begin
  ReportMemoryLeaksOnShutdown := True;
  try
    myinstance := TNathanFactory.GetInstance('haha');
    if Assigned(myinstance) then
      myinstance.Dosomething()
    else
      Writeln(Format('No registed class found "%s"!', ['haha']));

    myinstance := TNathanFactory.GetInstance('Thurnreiter');
    if Assigned(myinstance) then
      myinstance.Dosomething()
    else
      Writeln(Format('No registed class found "%s"!', ['Thurnreiter']));

    Writeln('--------');

    TThurnreiterFactory<TThurnreiterDummy>.RegisteringClass('abc');

    myinstance := TThurnreiterFactory<TThurnreiterDummy>.GetInstance('abc');
    if (Assigned(myinstance)) then
      myinstance.Dosomething
    else
      Writeln(Format('No registed class found "%s"!', ['Thurnreiter']));
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;

  Readln;
end.
