program LampertTimeDemo;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  Lampert.Base in 'src\Lampert.Base.pas';

  //  https://www.youtube.com/watch?v=zUSgoXPTjyo
  //  https://www.delphipraxis.net/203071-tmessagemanager-sendmessage-2.html
  //  http://docwiki.embarcadero.com/CodeExamples/Sydney/en/TVirtualMethodInterceptor_(Delphi)

var
  LB01: ILamportLogicalClock;
  LB02: ILamportLogicalClock;
  LB03: ILamportLogicalClock;
begin
  try
    LB01 := TLamportLogicalClock.Create;
    LB02 := TLamportLogicalClock.Create;
    LB03 := TLamportLogicalClock.Create;

    LB01.Send(nil); //                 LB01 = 1
    LB01.Send(nil); //                 LB01 = 2
    LB01.Send(nil); //                 LB01 = 3

    LB02.Send(nil); //                          LB02 = 1
    LB02.Send(nil); //                          LB02 = 2

    LB01.Receive(LB02.Clock, nil); //  LB01 = 4
    LB01.Send(nil); //                 LB01 = 5

    LB02.Send(nil); //                          LB02 = 3
    LB02.Send(nil); //                          LB02 = 4
    LB02.Send(nil); //                          LB02 = 5
    LB02.Send(nil); //                          LB02 = 6

    LB01.Send(nil); //                 LB01 = 6
    LB01.Send(nil); //                 LB01 = 7

    LB02.Receive(LB01.Clock, nil); //           LB02 = 8

    LB03.Receive(LB02.Clock, nil); //                   LB03 = 9

    writeln('Lamport 01: ' + LB01.Clock.ToString);  //  7
    writeln('Lamport 02: ' + LB02.Clock.ToString);  //  8
    writeln('Lamport 03: ' + LB03.Clock.ToString);  //  9

    Readln;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
