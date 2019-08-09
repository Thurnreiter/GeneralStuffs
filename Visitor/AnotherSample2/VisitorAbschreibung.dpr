program VisitorAbschreibung;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  System.Generics.Collections,
  VisitorAbschreibungBilanzen in 'VisitorAbschreibungBilanzen.pas';

var
  Vermoergen: TList<TBilanzposten>;
  Item: TBilanzposten;
  Ab: TAbscheibung;
  Bs: TBilanzsumme;

  G: TGebaeude;
  F: TFahrzeug;

begin
  try
    G := TGebaeude.Create;
    G.Wert := 100;
    F := TFahrzeug.Create;
    F.Wert := 2;

    Writeln('Wert des Gebäude bisher: ' + G.Wert.ToString);
    Writeln('Wert des Fahrzeug bisher: ' + F.Wert.ToString);
    Writeln('');
    Writeln('Jetzt führen wir die Abschreibung durch!');
    Writeln('');

    Vermoergen := TList<TBilanzposten>.Create;
    Vermoergen.Add(G);
    Vermoergen.Add(F);

    Ab := TAbscheibung.Create;
    for Item in Vermoergen do
    begin
      Item.Accept(Ab);
    end;

    Writeln('Wert des Gebäude neu: ' + G.Wert.ToString);
    Writeln('Wert des Fahrzeug neu: ' + F.Wert.ToString);

    Bs := TBilanzsumme.Create;
    for Item in Vermoergen do
    begin
      Item.Accept(Bs);
    end;

    Writeln('');
    Writeln('Bilanzsumme: ' + Bs.Summe.ToString);

    G.Free;
    F.Free;
    Vermoergen.Free;
    Ab.Free;
    Bs.Free;

    Writeln('');
    Write('Press [ENTER] to continue...');
    Readln;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
