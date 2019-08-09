unit Apriori.Algo;

interface

uses
  Apriori.Items;

{M+}

type
  /// <summary>A market basket analysis</summary>
  IApriori = interface
    ['{59DEA6C9-1D9A-4E72-8637-C43C72D5799F}']
    /// <summary>Calculates the average of elements per transaction.</summary>
    function GetAverage(AListC: TArray<TItemSet>): Double;

    /// <summary>Calculate the support value from all elements in transactions.</summary>
    /// <returns>Returns a list of C1 supports.</returns>
    function GetC1Support(): TArray<TItemSet>;

    /// <summary>Calculate combinations.</summary>
    /// <param name="AListLN">It must be always the baselist C1.</param>
    /// <param name="ALimitK">Indicates how many elements should be combined.</param>
    /// <returns>Returns a list of relevant combinations.</returns>
    function GetNextCandidates(AListLN: TArray<TItemSet>; ALimitK: Integer): TArray<TItemSets>;

    /// <summary>Filters the list based on "MinimumSupport". Returns only valid ones.</summary>
    /// <param name="AListC">An unfiltered list.</param>
    /// <returns>Returns a filtered list of <c>TArray<TItemSet></c>.</returns>
    function GetLN(AListC: TArray<TItemSet>): TArray<TItemSet>; overload;

    /// <summary>Filters the list based on "MinimumSupport". Returns only valid ones.</summary>
    /// <param name="AListCN">An unfiltered list.</param>
    /// <returns>Returns a filtered list of <c>TArray<TItemSets></c>.</returns>
    function GetLN(AListCN: TArray<TItemSets>): TArray<TItemSets>; overload;

    /// <summary>Number of transactions.</summary>
    function Transactions(): Integer;

    /// <summary>Set the "MinimumSupport" value (same as a setter).</summary>
    /// <param name="AValue">The support value as Double in percent.</param>
    function MinimumSupport(AValue: Double): IApriori; overload;

    /// <summary>Get the "MinimumSupport" value (same as a getter).</summary>
    function MinimumSupport(): Double; overload;

    /// <summary>Set the "MinimumConfidence" value (same as a setter).</summary>
    /// <param name="AValue">The confidence value as Double in percent.</param>
    function MinimumConfidence(AValue: Double): IApriori; overload;

    /// <summary>Get the "MinimumConfidence" value (same as a getter).</summary>
    function MinimumConfidence(): Double; overload;

    function ConfidencesRules(AListCN: TArray<TItemSets>; AUseOccurPerTransaction: Boolean = False): TArray<TConfidenceRules>;
  end;


  /// <returns>Implementation of Interface <c>IApriori</c> function.</returns>
  /// <summary>
  ///   Look at: <see cref="Apriori.Algo|IApriori">IApriori</see>
  /// <summary>
  TApriori = class(TInterfacedObject, IApriori)
  strict private
    FCurrentTransactionsQuantity: Integer;
    FMinimumSupport: Double;
    FMinimumConfidence: Double;
    FData: TArray<TArray<string>>;
  strict private
    FCurrentSet: Integer;
    FReturnSets: TArray<TItemSets>;

    function CalcC1Support(AListC1: TArray<TItemSet>): TArray<TItemSet>;
    function CalcCNSupport(AListCN: TArray<TItemSets>): TArray<TItemSets>;

    function GetNextCandidatesFirstLevel(AListLN: TArray<TItemSet>; ALevelOrSubsetSize: Integer): TArray<TItemSets>;
  public
    /// <summary>Calculates the average of elements per transaction.
    ///  The constructor needs the cleaned basic data.
    ///  So a 2 dimensional array with transaction[string].
    /// </summary>
    constructor Create(AData: TArray<TArray<string>>);

    function GetAverage(AListC: TArray<TItemSet>): Double;
    function GetC1Support(): TArray<TItemSet>;
    function GetNextCandidates(AListLN: TArray<TItemSet>; ALimitK: Integer): TArray<TItemSets>;
    function GetLN(AListC: TArray<TItemSet>): TArray<TItemSet>; overload;
    function GetLN(AListCN: TArray<TItemSets>): TArray<TItemSets>; overload;
    function Transactions(): Integer;
    function MinimumSupport(AValue: Double): IApriori; overload;
    function MinimumSupport(): Double; overload;
    function MinimumConfidence(AValue: Double): IApriori; overload;
    function MinimumConfidence(): Double; overload;

    function ConfidencesRules(AListCN: TArray<TItemSets>; AUseOccurPerTransaction: Boolean = False): TArray<TConfidenceRules>;
  end;

{M-}

implementation

uses
  System.SysUtils,
  System.Math,
  System.Generics.Collections, // System.Generics.Defaults,
  System.Threading,
  Nathan.Permutation,
  Nathan.TArrayHelper,
  Apriori.Confidence;

{ **************************************************************************** }

{ TApriori }

constructor TApriori.Create(AData: TArray<TArray<string>>);
begin
  inherited Create;
  FData := AData;
  FCurrentTransactionsQuantity := -1;
  FReturnSets := Default(TArray<TItemSets>);
end;

function TApriori.GetC1Support: TArray<TItemSet>;
var
  Idx1, Idx2: Integer;
  FindIndex: Integer;
  //  ItemSet: TItemSet;
  s: string;
  C1: TArray<TItemSet>;
begin
  FCurrentTransactionsQuantity := Length(FData);

  C1 := Default(TArray<TItemSet>);

  s := '';
  for Idx1 := Low(FData) to High(FData) do
  begin
    for Idx2 := Low(FData[Idx1]) to High(FData[Idx1]) do
    begin
      FindIndex := TArray.FindIndex<TItemSet>(
          C1,
          function(x: TItemSet): Boolean
          begin
            Result := x.Item.Contains(FData[Idx1][Idx2]);
          end);

      if (FindIndex = -1) then
      begin
        //  ItemSet := TItemSet.Create(FData[Idx1][Idx2], 1);
        TArray.Add<TItemSet>(C1, TItemSet.Create(FData[Idx1][Idx2], 1, Idx1));
      end
      else
      begin
        C1[FindIndex].OccurTotal := C1[FindIndex].OccurTotal + 1;
        if (TArray.IndexOf<Integer>(C1[FindIndex].TransactionIndices, Idx1) = -1) then
          C1[FindIndex].OccurPerTransaction := C1[FindIndex].OccurPerTransaction + 1;

        C1[FindIndex].TransactionIndices := C1[FindIndex].TransactionIndices + [Idx1];
      end;
    end;
  end;

  Result := CalcC1Support(C1);
end;

function TApriori.CalcC1Support(AListC1: TArray<TItemSet>): TArray<TItemSet>;
var
  Idx: Integer;
begin
  for Idx := Low(AListC1) to High(AListC1) do
    AListC1[Idx].Support := ((AListC1[Idx].OccurPerTransaction / Transactions) * 100);

  Result := AListC1;
end;

function TApriori.CalcCNSupport(AListCN: TArray<TItemSets>): TArray<TItemSets>;
var
  ActionCalcSupportN: TFunc<TArray<TItemSet>, Integer>;
begin
  ActionCalcSupportN :=
    function(Items: TArray<TItemSet>): Integer
    var
      IntersectionArray: TArray<Integer>;
    begin
      IntersectionArray := TArray(Items[Low(Items)].TransactionIndices).Filter<Integer>(
        function(x: Integer): Boolean
        var
          IdxInnerMain: Integer;
        begin
          Result := True;
          for IdxInnerMain := Succ(Low(Items)) to High(Items) do
            Result := Result and (TArray.IndexOf<Integer>(Items[IdxInnerMain].TransactionIndices, x) > -1);
        end);

        Result := Length(IntersectionArray);
    end;

  //  Can works parallel...
  //  for Idx := Low(AListCN) to High(AListCN) do
  //    AListCN[Idx].Support := ActionCalcSupportN(AListCN[Idx].Items);
  TParallel.For(Low(AListCN), High(AListCN),
    procedure(I: Integer)
    begin
      AListCN[I].IntersectionOfSupport := ActionCalcSupportN(AListCN[I].Items);
      AListCN[I].Support := ((AListCN[I].IntersectionOfSupport / FCurrentTransactionsQuantity) * 100);
//      AListCN[I].Confidence := 0.0;
    end);

  Result := AListCN;
  ActionCalcSupportN := nil;
end;

function TApriori.GetNextCandidatesFirstLevel(AListLN: TArray<TItemSet>; ALevelOrSubsetSize: Integer): TArray<TItemSets>;
var
  Idx1, Idx2, IdxReturn: Integer;
  Size: Integer;
  CN: TArray<TItemSets>;
begin
  CN := Default(TArray<TItemSets>);

  {$REGION 'Info how to calculate size or permutation'}
  //  Calculate size or permutation (https://matheguru.com/stochastik/kombination-ohne-wiederholung.html):
  //  Sample permutation without repetition:
  //  Combination to 4 letters with 2 combinations each.
  //  Basedata = 4 letter (A, B, C, D) => (AB, AC, AD, BC, BD, CD) = 6
  //  Formula: n! / n! (n - k)!
  //           4! / 2! (4 - k)!
  //           (4 * 3 * 2 * 1) / (2 * 1) (2 * 1)
  //           (24) / (4) = 6
  {$ENDREGION}

  IdxReturn := 0;
  Size := Permutations.nCr(Length(AListLN), ALevelOrSubsetSize);
  SetLength(CN, Size);

  //  Temp := string.Empty;
  for Idx1 := Low(AListLN) to High(AListLN) do
  begin
    for Idx2 := Idx1 + 1 to High(AListLN) do
    begin
      //  Temp := Format('%s%s|%s%s', [Temp, AListLN[Idx1].Item, AListLN[Idx2].Item, '  ']);
      CN[IdxReturn].Items := [AListLN[Idx1], AListLN[Idx2]];
      CN[IdxReturn].Support := 0.0;
      Inc(IdxReturn);
    end;
  end;

  //  Temp := Temp.Trim;
  Result := CN;
end;

function TApriori.GetNextCandidates(AListLN: TArray<TItemSet>; ALimitK: Integer): TArray<TItemSets>;
var
  Idx: Integer;
  GetNextCombination: TProc<Integer, TArray<TItemSet>, Integer, Integer>;
begin
  {$REGION 'Basics'}
  //  for Idx1 := Low(AListLN) to High(AListLN) do
  //  begin
  //    for Idx2 := Idx1 + 1 to High(AListLN) do
  //    begin
  //      for Idx3 := Idx2 + 1 to High(AListLN) do
  //      begin
  ////        for Idx4 := Idx3 + 1 to High(AListLN) do
  ////        begin
  ////          FReturnSets[FCurrentSet].Items := [AListLN[Idx1], AListLN[Idx2], AListLN[Idx3], AListLN[Idx4]];
  //          FReturnSets[FCurrentSet].Items := [AListLN[Idx1], AListLN[Idx2], AListLN[Idx3]];
  //          FReturnSets[FCurrentSet].Support := 0.0;
  //          Inc(FCurrentSet);
  ////        end;
  //      end;
  //    end;
  //  end;
  {$ENDREGION}

  FCurrentSet := 0;
  SetLength(FReturnSets, 0);

  GetNextCombination :=
    procedure(AStart: Integer; AItemsXN: TArray<TItemSet>; ALimitK, ACurrentLevel: Integer)
    var
      IX: Integer;
    begin
      for IX := AStart to High(AListLN) do
      begin
        if ((ALimitK - 1) = ACurrentLevel) then
        begin
          SetLength(FReturnSets, Length(FReturnSets) + 1);
          FReturnSets[FCurrentSet].Items := AItemsXN + [AListLN[IX]];
          FReturnSets[FCurrentSet].Support := 0.0;
          Inc(FCurrentSet);
        end
        else
          GetNextCombination((IX + 1), (AItemsXN + [AListLN[IX]]), ALimitK, (ACurrentLevel + 1));
      end;
    end;

  for Idx := Low(AListLN) to High(AListLN) do
    GetNextCombination((Idx + 1), [AListLN[Idx]], ALimitK, 1);

  Result := CalcCNSupport(FReturnSets);
  //  Result := FReturnSets;
  GetNextCombination := nil;
end;

function TApriori.GetAverage(AListC: TArray<TItemSet>): Double;
var
  Idx: Integer;
  Cpt: Double;
begin
  if (Length(AListC) = 0) then
    Exit(0);

  Cpt := 0;
  for Idx := Low(AListC) to High(AListC) do
    Cpt := Cpt + AListC[Idx].OccurTotal;

  Result := Cpt / Length(AListC);
end;

function TApriori.GetLN(AListC: TArray<TItemSet>): TArray<TItemSet>;
var
  LN: TArray<TItemSet>;
begin
  LN := TArray(AListC).Filter<TItemSet>(
    function(x: TItemSet): Boolean
    begin
      Result := (x.Support >= FMinimumSupport);
    end);

  Result := LN;
end;

function TApriori.GetLN(AListCN: TArray<TItemSets>): TArray<TItemSets>;
var
  LN: TArray<TItemSets>;
begin
  LN := TArray(AListCN).Filter<TItemSets>(
    function(x: TItemSets): Boolean
    begin
      Result := (x.Support >= FMinimumSupport);
    end);

  Result := LN;
end;

function TApriori.MinimumSupport(AValue: Double): IApriori;
begin
  FMinimumSupport := AValue;
  Result := Self;
end;

function TApriori.MinimumSupport: Double;
begin
  Result := FMinimumSupport;
end;

function TApriori.MinimumConfidence(AValue: Double): IApriori;
begin
  FMinimumConfidence := AValue;
  Result := Self;
end;

function TApriori.MinimumConfidence: Double;
begin
  Result := FMinimumConfidence;
end;

function TApriori.Transactions: Integer;
begin
  Result := FCurrentTransactionsQuantity;
end;

function TApriori.ConfidencesRules(AListCN: TArray<TItemSets>; AUseOccurPerTransaction: Boolean): TArray<TConfidenceRules>;
var
  ConfidenceRules: TConfidenceRules;
  Idx1, Idx2: Integer;
  Conf: Double;
begin
  Result := [];
  for Idx1 := Low(AListCN) to High(AListCN) do
  begin
    for Idx2 := Low(AListCN[Idx1].Items) to High(AListCN[Idx1].Items) do
    begin
      Conf := AprioriConfidence.AssociationRule(AListCN[Idx1], AListCN[Idx1].Items[Idx2], AUseOccurPerTransaction);
      if (Conf >= FMinimumConfidence) then
      begin
        ConfidenceRules := TConfidenceRules.Create(AListCN[Idx1].Items[Idx2], TArray.Clone<TItemSet>(AListCN[Idx1].Items), Conf);
        TArray.RemoveAt<TItemSet>(ConfidenceRules.Items, Idx2);
        Result := Result + [ConfidenceRules];
      end;
    end;
  end;
end;

end.
