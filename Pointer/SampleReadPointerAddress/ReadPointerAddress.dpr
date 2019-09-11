program ReadPointerAddress;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils;

var
  PointertoObject: TObject;
  PointerToString: ^String;
begin
  try
    New(PointerToString);
    PointerToString^ := 'Hello Nathan...';

    //  https://www.delphipraxis.net/201931-pointeradresse-auslesen.html#post1445674
    Writeln(PointerToString^);                          // The content of string variable...
    Writeln(Integer(PointerToString).ToString);         // Address from the "New" allocated memory area...
    Writeln(Integer(@PointerToString).ToString);        // Address of variable "PointerToString"
    Writeln(Integer(Addr(PointerToString)).ToString);   // ditto, the same as @
    Writeln(Integer(@PointerToString).ToHexString);     // Address of variable "PointerToString" as hex...

    Dispose(PointerToString);

    Writeln('');

    PointertoObject := TObject.Create;
    Writeln(Integer(@PointertoObject).ToString);        // Address of variable "PointerToObject"
    Writeln(Integer(@PointerToObject).ToHexString);     // Address of variable "PointerToObject" as hex...

    Readln;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
