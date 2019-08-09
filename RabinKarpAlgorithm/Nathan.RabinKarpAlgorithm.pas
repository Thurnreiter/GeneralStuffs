unit Nathan.RabinKarpAlgorithm;

interface

{$M+}

type
  IRabinKarpAlgorithm = interface
    ['{33A6874B-E1B1-4396-8DA2-579CC3D09229}']
    function IgnoreCase(AValue: Boolean): IRabinKarpAlgorithm; overload;
    function IgnoreCase(): Boolean; overload;

    function Search(const APattern, AText: string): Int64; overload;
    function Search(APattern: TArray<string>; AText: string): TArray<Int64>; overload;
  end;

  TRabinKarpAlgorithm = class(TInterfacedObject, IRabinKarpAlgorithm)
  strict private
    type
      TMaxFactDict = record
        MaxFactor: TArray<Int64>; //  We store the prime ^ size-1 value, so we don't have to calc it everytime...
        PatternHashs: TArray<Int64>;
        TextHashs: TArray<Int64>;
      end;
  strict private
    FIgnoreCase: Boolean;
    FPrimeBase: Int64;
    FPrimeMod: Int64;
    function CalculateHash(APattern: TArray<string>): TMaxFactDict;
    function RabinKarpSearch(APattern: TArray<string>; const AText: string): TArray<Int64>;
  public
    const DefaultPrimeBase = 257;
    const DefaultPrimeMod = 1000000007;
  public
    constructor Create(); overload;
    constructor Create(APrimeBase, APrimeMod: Integer); overload;

    function IgnoreCase(AValue: Boolean): IRabinKarpAlgorithm; overload;
    function IgnoreCase(): Boolean; overload;

    function Search(const APattern, AText: string): Int64; overload;
    function Search(APattern: TArray<string>; AText: string): TArray<Int64>; overload;
  end;

{$M-}

implementation

uses
  System.SysUtils;

{ TRabinKarpAlgorithm }

constructor TRabinKarpAlgorithm.Create;
begin
  Create(DefaultPrimeBase, DefaultPrimeMod);
end;

constructor TRabinKarpAlgorithm.Create(APrimeBase, APrimeMod: Integer);
begin
  inherited Create();
  FIgnoreCase := False;
  FPrimeBase := APrimeBase;
  FPrimeMod := APrimeMod;
end;

function TRabinKarpAlgorithm.IgnoreCase: Boolean;
begin
  Result := FIgnoreCase;
end;

function TRabinKarpAlgorithm.IgnoreCase(AValue: Boolean): IRabinKarpAlgorithm;
begin
  FIgnoreCase := AValue;
  Result := Self;
end;

function TRabinKarpAlgorithm.Search(const APattern, AText: string): Int64;
begin
  Result := Search([APattern], AText)[0];
end;

function TRabinKarpAlgorithm.Search(APattern: TArray<string>; AText: string): TArray<Int64>;
var
  Idx: Integer;
begin
  if FIgnoreCase then
  begin
    for Idx := Low(APattern) to High(APattern) do
      APattern[Idx] := APattern[Idx].ToLower;

    Result := RabinKarpSearch(APattern, AText.ToLower);
  end
  else
    Result := RabinKarpSearch(APattern, AText);

  if (Length(Result) = 0) then
    Result := [-1];
end;

function TRabinKarpAlgorithm.RabinKarpSearch(APattern: TArray<string>; const AText: string): TArray<Int64>;
var
  IdxChar: Int64;
  IdxPattern: Integer;
  MaxFactDict: TMaxFactDict;
begin
  {$REGION 'Links & Infos'}
  //  Benefit of Rabin-Karp algorithm:
  //  http://www.it-cow.de/?tag=/Rabin-Karp-Algorithmus
  //  http://www.it-cow.de/post/Der-Rabin-Karp-Algorithmus.aspx
  //  abracadabra
  //  abr         -a 97 * Power(Prime, 2)
  //   bra        +a 97 * Power(Prime, 0) = 1
  //
  //  abr
  //  abracadabra
  //  abr          = 1
  //     acad
  //         abr   = 8
  //            a
  //  Thanks to: https://stackoverflow.com/questions/711770/fast-implementation-of-rolling-hash
  {$ENDREGION}

  //  If the pattern is empty or the "AText" is smaller than the pattern,
  //  the pattern cannot occur anything...
  if (APattern[0].IsEmpty or (AText.Length < APattern[0].Length)) then
    Exit(Default(TArray<Int64>));

  //  Init...
  MaxFactDict := CalculateHash(APattern);

  //  Calulate the hash value from corresponding size of  "AText"...
  //  Remove leading digit, add trailing digit, check for match...
  //  Lopp over the rest of "AText"...
  for IdxChar := 1 to AText.Length do
  begin
    for IdxPattern := Low(MaxFactDict.PatternHashs) to High(MaxFactDict.PatternHashs) do
    begin
      //  Add the last letter...
      MaxFactDict.TextHashs[IdxPattern] := MaxFactDict.TextHashs[IdxPattern] * FPrimeBase + Ord(AText[IdxChar]);
      MaxFactDict.TextHashs[IdxPattern] := MaxFactDict.TextHashs[IdxPattern] mod FPrimeMod;

      //  Remove the first character, if needed...
      if (IdxChar >= APattern[IdxPattern].Length) then
      begin
        //  Now we are over the length of pattern in text...
        MaxFactDict.TextHashs[IdxPattern] := MaxFactDict.TextHashs[IdxPattern] - (MaxFactDict.MaxFactor[IdxPattern] * Ord(AText[IdxChar - APattern[IdxPattern].Length]) mod FPrimeMod);
        if (MaxFactDict.TextHashs[IdxPattern] < 0) then //  A negative hash value can be made it positive, with mod function...
          MaxFactDict.TextHashs[IdxPattern] := MaxFactDict.TextHashs[IdxPattern] + FPrimeMod;
      end;

      //  Match it? In two steps, is easy to understand, but in Delphi it is
      //  possible to write in one expression...

      //  1. If the hash value of the pattern matches the hash value of the text excerpt.
      //  2. And the strings at the location also match to intercept collisions..
      if (MaxFactDict.PatternHashs[IdxPattern] = MaxFactDict.TextHashs[IdxPattern]) then //  if (Idx >= APattern.Length - 1) and (Hash1 = Hash2) then
      begin
        if APattern[IdxPattern].Contains(AText.Substring((IdxChar - APattern[IdxPattern].Length), APattern[IdxPattern].Length)) then
        begin
          SetLength(Result, (Length(Result) + 1));
          Result[High(Result)] := (IdxChar - (APattern[IdxPattern].Length - 1) - 1);
        end;
      end;
    end;
  end;
end;

function TRabinKarpAlgorithm.CalculateHash(APattern: TArray<string>): TMaxFactDict;
var
  IdxElement: Integer;
  IdxChar: Int64;
  HashPattern: Int64;
begin
  SetLength(Result.PatternHashs, Length(APattern));
  SetLength(Result.TextHashs, Length(APattern));
  SetLength(Result.MaxFactor, Length(APattern));

  for IdxElement := Low(APattern) to High(APattern) do
  begin
    Result.MaxFactor[IdxElement] := 1;
    HashPattern := 0;
    for IdxChar := 1 to APattern[IdxElement].Length do
    begin
      HashPattern := HashPattern * FPrimeBase;
      HashPattern := HashPattern + Ord(APattern[IdxElement][IdxChar]);
      HashPattern := HashPattern mod FPrimeMod;

      Result.MaxFactor[IdxElement] := (Result.MaxFactor[IdxElement] * FPrimeBase) mod FPrimeMod;
    end;

    Result.PatternHashs[IdxElement] := HashPattern;
  end;
end;

end.
