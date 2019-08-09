program VisitorPatternDemo;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  //  FastMM4,
  System.Classes,
  System.SysUtils,
  Nathan.Visitor in 'Nathan.Visitor.pas';

var
  n: IZuBesuchendesObjekt;

begin
  try
    ReportMemoryLeaksOnShutdown := True;

    n := TZuBesuchendesObjekt.Create;
    n.Accept(TBesucher.Create);
    n.Accept(TBesucher001.Create);
    n.Accept(TBesucher002.Create);

    Writeln('');
    Writeln('Press any key to close...');
    Readln;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
