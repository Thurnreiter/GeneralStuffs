program ProjectDemoPointer;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils;

type
  TDemoObject = class
  strict private
    FValue: string;
  public
    property Value: string read FValue write FValue;
  end;

  PDemoObject = ^TDemoObject; //  Typerisierter Pointer...

var
  X, Y: Integer;  // X and Y are Integer variables
  P: ^Integer;    // P points to an Integer
  Obj: TDemoObject;
  PObj: PDemoObject;

begin
  try
    X := 17;      // assign a value to X
    P := @X;      // assign the address of X to P, it's the same as function Addr()
    Y := P^;      // dereference P; assign the result to Y

    Writeln('Integer variable address P ', NativeUInt(P));
    Writeln('Integer variable address @X Int ' + Integer(@X).ToString);
    Writeln('Integer variable address @X Hex ' + Integer(@X).ToHexString);
    Writeln('Integer variable address Addr(X) Hex ' + Integer(Addr(X)).ToHexString);

    Writeln('Integer variable address @Y Int ' + Integer(@Y).ToString);
    Writeln('Integer variable address @Y Hex ' + Integer(@Y).ToHexString);
    Writeln('Content of PInteger(@Y)^ ' + PInteger(@Y)^.ToString);
    Writeln('Content of Ptr(P) ' + Integer(Ptr(P^)).ToString);

    Writeln('X ' + X.ToString);
    Writeln('Y ' + Y.ToString);

    Writeln(sLineBreak + '--------' + sLineBreak);
    Obj := TDemoObject.Create;
    try
      Obj.Value := 'Demo';

      Writeln('Object address Obj ', NativeUInt(Obj).ToHexString);
      Writeln('Object address @Obj Hex ' + Integer(@Obj).ToHexString);
      Writeln('Object address Addr(Obj) Hex ' + Integer(Addr(Obj)).ToHexString);
      Writeln('Instance size: ' + TDemoObject.InstanceSize.ToString);
      Writeln('Instance allocated at: ' + Integer(Addr(Obj)).ToHexString);

      //  Same as: "Obj: TDemoObject $4268C4 : $428A1C0"
      //  Show the name, type and the address or memrory address position of examined object.
      PObj := @Obj;

      Writeln('Hex address from object: ' + NativeUInt(@Obj).ToHexString);
      Writeln('Value Property: ' + PDemoObject(@Obj).Value);

      Writeln('Value Property over PObj: ' + PDemoObject(PObj).Value);
      Writeln('Hex address from pointer content: ' + NativeUInt(PObj).ToHexString);

      Writeln('Hex address from pointer: ' + NativeUInt(@PObj).ToHexString);

      //  Holen aus der Adresse des typisierten Pointer PObj den Inhalt, welcher
      //  auf unsere Instanz von TDemoObject zeigt. Über das casting per
      //  typisierten Pointer greifen wir auf das Property unserer Instanz zu.

      //  Obj: TDemoObject $4268C4 : $435A1C0
      //  @Obj =           $4268C4             Adresse der Variablen
      //  PDemoObject($4268C4)^ = ('Demo')     Hier dereferenziert man über Caret den Pointer und liefert somit den Wert an der Speicheradresse, auf die der Pointer zeigt.
      //  NativeUInt(PDemoObject($4268C4)^).ToHexString   $435A1C0    Hier liegt das Object im Speicher.

      Writeln('Dereference "Value" Property over address from typed pointer: ' + PDemoObject(NativeUInt(@PObj^)).Value);
    finally
      Obj.Free;
    end;
   except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;

  Readln;
end.
