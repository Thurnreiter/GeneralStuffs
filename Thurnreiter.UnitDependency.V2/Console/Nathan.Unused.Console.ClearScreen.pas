unit Nathan.Unused.Console.ClearScreen;

interface

type
  NathanUnusedConsoleHelper = record
    class procedure ClearScreen(); static;
  end;

implementation

uses
  System.SysUtils{$IFDEF MSWINDOWS}, Winapi.Windows, Winapi.Messages{$ENDIF MSWINDOWS};

{ NathanUnusedConsoleHelper }

class procedure NathanUnusedConsoleHelper.ClearScreen;
{$IFDEF MSWINDOWS}
var
  Idx: Integer;
  hConsoleOutput: HWnd;
  lpConsoleScreenBufferInfo: TConsoleScreenBufferInfo;
  Coord: TCoord;
{$ENDIF MSWINDOWS}
begin
{$IFDEF MSWINDOWS}
  hConsoleOutput := GetStdHandle(STD_OUTPUT_HANDLE);
  GetConsoleScreenBufferInfo(hConsoleOutput, lpConsoleScreenBufferInfo);

  //  The GetConsoleScreenBufferInfo API gets the size of the buffer Index which I need it...
  for Idx := 1 to lpConsoleScreenBufferInfo.dwSize.Y do
    WriteLn('');

  Coord.X := 0;
  Coord.Y := 0;

  //  SetConsoleCursorPosition API sets the cursor to the Coord1 position, at 0, 0 at the begining...
  SetConsoleCursorPosition(hConsoleOutput, Coord);
{$ENDIF MSWINDOWS}
end;

end.
