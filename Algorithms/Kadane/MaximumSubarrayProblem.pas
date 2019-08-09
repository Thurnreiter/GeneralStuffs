unit MaximumSubarrayProblem;

interface

{$REGION 'Info'}
{
  Maximum subarray problem:
  Kadane's Algorithm or maximum subarray sum using divide and conquer algorithm.

  You get a one-dimensional array that can contain both positive and negative integers,
  find the sum of the contiguous subarrays of numbers that has the largest sum.
  For example, if the given array is:
  [-2, -5, 6, -2, -3, 1, 5, -6]
           6, -2, -3, 1, 5       = 7
  then the maximum subarray sum is 7 (see highlighted elements).

  For what can I use the maximum subarray problems in applications?

  German:
  Sie haben eine Liste mit Einkommensdetails für jeden Monat der Firma,
  die als xxx für ein Jahr 2019 benannt ist. Sie müssen nun herausfinden,
  in welchem Teil des Jahres die Firma mehr Einkommen verdient und wieviel.
  Auch die Maximum-Likelihood-Schätzung wäre eine Anwendung.
}
{$ENDREGION}

{M+}

type
  TMaximumSubarray = class
  public
    class function Formula(AList: TArray<Integer>): Integer; overload;
    class function Formula(AList: TArray<Integer>; var AStartIndex, AEndIndex: Integer): Integer; overload;
  end;

{M-}

implementation

uses
  System.SysUtils;

class function TMaximumSubarray.Formula(AList: TArray<Integer>): Integer;
var
  Idx: Integer;
  SumMax: Integer;
begin
  Result := Integer.MinValue;
  SumMax := Default(Integer);
  for Idx := Low(AList) to High(AList) do
  begin
    SumMax := SumMax + AList[Idx];
    if (SumMax < 0) then
      SumMax := 0
    else
    if (Result < SumMax) then
      Result := SumMax;
  end;
end;

class function TMaximumSubarray.Formula(AList: TArray<Integer>; var AStartIndex, AEndIndex: Integer): Integer;
var
  Idx: Integer;
  SumMax: Integer;
begin
  Result := Integer.MinValue;
  SumMax := Default(Integer);
  AStartIndex := Default(Integer);
  AEndIndex := Default(Integer);
  for Idx := Low(AList) to High(AList) do
  begin
    SumMax := SumMax + AList[Idx];
    if (SumMax < 0) then
    begin
      SumMax := 0;
      AStartIndex := Idx + 1;
    end
    else
    if (Result < SumMax) then
    begin
      Result := SumMax;
      AEndIndex := Idx;
    end;
  end;
end;

end.
