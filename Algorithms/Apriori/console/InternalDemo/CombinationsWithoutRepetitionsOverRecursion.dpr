program CombinationsWithoutRepetitionsOverRecursion;

{$H+}

uses
  System.SysUtils;

  function InnerLoopRecursive(AMsg: string; AFromIndex, AToIndex, ALimit, AActualLevel: Integer): string;
  var
    Idx: Integer;
  begin
    if (AActualLevel < ALimit) then
    begin
      for Idx := AFromIndex to AToIndex do
        Result := InnerLoopRecursive(AMsg + ',' + Idx.ToString, Idx + 1, AToIndex, ALimit, AActualLevel + 1);
    end
    else
    begin
      WriteLn(AMsg);
      Result := '';
    end;
  end;

  procedure GetWordPart(CharList: string; WordLength: Integer; var Count: Integer; Str: string);
  var
    I: Integer;
    S: string;
  begin
    for I := 1 to Length(CharList) do
    begin
      S := CharList[I];
      if WordLength > 1 then
        GetWordPart(CharList,WordLength-1,Count,Str+S)
      else
        Inc(Count);
    end;

  end;

  function GetAllPossibleWords(CharList: string; WordLength: Integer):integer;
  var
    I,J: Integer;
    S: string;
    Count: Integer;
  begin
    GetWordPart(CharList, WordLength, count, '');
    Result := count;
  end;

var
  N: Integer; //  Set size...
  K: Integer; //  Subset size...
  Loop: Integer;
begin
  N := 4;
  K := 2;
  for Loop := 1 to N - K + 1 do
    InnerLoopRecursive(Loop.ToString, Loop + 1, N, K, 1);

  WriteLn('----');

  N := 4;
  K := 3;
  for Loop := 1 to N - K + 1 do
    InnerLoopRecursive(Loop.ToString, Loop + 1, N, K, 1);


  WriteLn(GetAllPossibleWords('ABCD', 2).ToString);
  Readln;
end.


