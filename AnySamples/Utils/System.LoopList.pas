unit System.LoopList;

interface

uses
  System.SysUtils,
  System.Generics.Collections;

type
  TLoopList = class
  public
    class procedure Loop<T>(var Source: TList<T>; DoSomeWork: TProc<Integer, TList<T>>);
  end;

implementation

{ TLoopList<T> }

class procedure TLoopList.Loop<T>(var Source: TList<T>; DoSomeWork: TProc<Integer, TList<T>>);
var
  Index: Integer;
begin
  if (not Assigned(DoSomeWork)) then
    Exit;

  for Index := 0 to Source.Count -1 do
    DoSomeWork(Index, Source);
end;

end.

