program CombinationsWithoutRepetitions;

{$APPTYPE CONSOLE}

//  Write out a single combination like {1, 2}...
procedure PrintCombines(const comb: array of Integer; k: Integer);
var
  Idx: Integer;
begin
  Write('{');

  for Idx := 0 to k - 1 do
  begin
    Write(comb[Idx] + 1);
    if Idx < (k-1) then
      Write(',');
  end;

  Writeln('}');
end;

{
  Generates the next combination of n elements as k after comb
    comb => the previous combination ( use (0, 1, 2, ..., k) for first)
    k => the size of the subsets to generate
    n => the size of the original set

    Returns: True if a valid combination was found, False otherwise
}
function NextCombination(var comb: array of Integer; k, n: Integer): Boolean;
var
  Idx: Integer;
begin
  Idx := k - 1;
  Inc(comb[Idx]);
  while (Idx > 0) and (comb[Idx] >= n - k + 1 + Idx) do
  begin
    dec(Idx);
    inc(comb[Idx]);
  end;

  if comb[0] > n - k then// Combination (n-k, n-k+1, ..., n) reached
  begin
    // No more combinations can be generated
    Result := False;
    Exit;
  end;

  // comb now looks like (..., x, n, n, n, ..., n).
  // Turn it into (..., x, x + 1, x + 2, ...)
  for Idx := Idx + 1 to k - 1 do
    comb[Idx] := comb[Idx - 1] + 1;

  Result := True;
end;

procedure Main;
const
  n = 4;  // The size of the set; for {1, 2, 3, 4} it's 4

  //  k = 2;  // The size of the subsets; for {1, 2}, {1, 3}, ... it's 2
  k = 3;  // The size of the subsets; for {1, 2, 3}, {1, 2, 4}, ... it's 3
var
  Idx: Integer;
  comb: array of Integer;
begin
  SetLength(comb, k);// comb[i] is the index of the i-th element in the combination

  //  Setup comb for the initial combination, here 1, 2, 3, 4...
  for Idx := 0 to k - 1 do
    comb[Idx] := Idx;

  //  Print the first combination...
  PrintCombines(comb, k);

  //  Generate and print all the other combinations...
  while NextCombination(comb, k, n) do
    PrintCombines(comb, k);
end;

begin
  Main;
  Readln;
end.
