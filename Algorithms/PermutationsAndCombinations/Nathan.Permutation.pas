unit Nathan.Permutation;

interface

{$M+}

type
  /// <summary>
  ///   Calculate permutations and combinations:
  ///   nPr = n! / (n - r)!
  ///   nCr = n! / r! (n - r)!
  ///   Thanks to: https://stackoverflow.com/questions/26311984/permutation-and-combination-in-c-sharp
  ///
  ///   Example how to calculate size or permutation'}
  ///   Online calculate size or permutation
  ///     https://matheguru.com/stochastik/kombination-ohne-wiederholung.html
  ///     https://esb1jockisch.lima-city.de/math/math12/Kombinatorik/rechnungen.htm#pm
  ///
  ///   Sample permutation without repetition:
  ///   Combination to 4 letters with 2 combinations each.
  ///   Basedata = 4 letter (A, B, C, D) => (AB, AC, AD, BC, BD, CD) = 6
  ///   Formula: n! / n! (n - k)!
  ///            4! / 2! (4 - k)!
  ///            (4 * 3 * 2 * 1) / (2 * 1) (2 * 1)
  ///            (24) / (4) = 6
  /// </summary>
  TPermutationsAndCombinations = record
  private
    class function FactorialDivision(ATopFactorial: Integer; ADivisorFactorial: Integer): Integer; static;
    class function Factorial(I: Integer): Integer; static;
  public
    class function nCr(N: Integer; R: Integer): Integer; static;  //  Combination without repetition...
    class function nPr(N: Integer; R: Integer): Integer; static;  //  Variation without repetition...
  end;

  Permutations = TPermutationsAndCombinations;

{$M-}

implementation

{ TPermutationsAndCombinations }

class function TPermutationsAndCombinations.Factorial(I: Integer): Integer;
begin
  if (I <= 1) then
    Exit(1);

  Result := I * Factorial(I - 1);
end;

class function TPermutationsAndCombinations.FactorialDivision(ATopFactorial, ADivisorFactorial: Integer): Integer;
var
  Idx: Integer;
begin
  //  long result = 1;
  //  for (int i = topFactorial; i > divisorFactorial; i--)
  //    result *= i;
  Result := 1;
  Idx := ATopFactorial;
  while (Idx > ADivisorFactorial) do
  begin
    Result := Result * Idx;
    Dec(Idx);
  end;
end;

class function TPermutationsAndCombinations.nCr(N, R: Integer): Integer;
begin
  //  naive: Factorial(n) / (Factorial(r) * Factorial(n - r));
  if (R > N) then
    Exit(-1);

  Result := Trunc(nPr(N, R) / Factorial(R));
end;

class function TPermutationsAndCombinations.nPr(N, R: Integer): Integer;
begin
  //  naive: Factorial(n) / Factorial(n - r);
  Result := FactorialDivision(N, N - R);
end;

end.
