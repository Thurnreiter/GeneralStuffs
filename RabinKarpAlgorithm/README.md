# Thurnreiter.StringMatching.RabinKarpAlgorithm

Out of interest or curiosity, I implemented the string matching algorithm of Rabin and Karp in Delphi.
Rabin–Karp algorithm is a string-searching algorithm to find text with rolling hash.

You can see how it works from the tests.
#### And how to use them:
```delphi
procedure TTestRabinKarpAlgo.Test_SearchIgnoreCase(const AValueText, AValuePattern, AExpectedReturns: string);
var
  LExpectedReturns: TArray<string>;
  ActualMatches: TArray<Int64>;
begin
  //  Arrange...
  FCut := TRabinKarpAlgorithm.Create();
  LExpectedReturns := AExpectedReturns.Split([';']);

  //  Act...
  ActualMatches := FCut
    .IgnoreCase(True)
    .Search([AValuePattern], AValueText);

  //  Assert...
  AssertExpectedReturns(LExpectedReturns, ActualMatches);
end;
```
More examples can be found in the unit tests.
