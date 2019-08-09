unit Test.Apriori.Impl;

interface

uses
  System.SysUtils,
  DUnitX.TestFramework,
  Apriori.Algo,
  Apriori.Items,
  Apriori.Confidence;

type
  [TestFixture]
  TTestAprioriImpl = class(TObject)
  strict private
    FCut: IApriori;
    FCharacterDemoData: TArray<TArray<string>>;

    function Test_IntersectionOfSetTheory_OptionStopwatch(AProc: TProc<TArray<Integer>, TArray<Integer>, TArray<Integer>>): Int64;
  public
    [Setup]
    procedure Setup;

    [TearDown]
    procedure TearDown;

    [Test]
    procedure Test_HasNoMemoryLeaks;

    [Test]
    procedure Test_GetC1Support();

    [Test]
    procedure Test_GetAverageFromC1_SupportCountAverage();

    [Test]
    procedure Test_SetMinimumSupport_And_GetL1_FromC1();

    [Test]
    [TestCase('TestK001','2,6')]  //  (((('A', 3), ('B', 4)), 0), ((('A', 3), ('C', 2)), 0), ((('A', 3), ('D', 3)), 0), ((('B', 4), ('C', 2)), 0), ((('B', 4), ('D', 3)), 0), ((('C', 2), ('D', 3)), 0))
    [TestCase('TestK002','3,4')]  //  (((('A', 3), ('B', 4), ('C', 2)), 0), ((('A', 3), ('B', 4), ('D', 3)), 0), ((('A', 3), ('C', 2), ('D', 3)), 0), ((('B', 4), ('C', 2), ('D', 3)), 0))
    [TestCase('TestK003','4,1')]  //  (((('A', 3), ('B', 4), ('C', 2), ('D', 3)), 0))
    procedure Test_GetNextCandidates(K, Return: Integer);

    [Test]
    procedure Test_GetNextCandidates_TwoTimesInSequence;

    [Test]
    procedure Test_GetNextCandidates_RandomData_01;

    [Test]
    procedure Test_GetNextCandidates_RandomData_02;

    [Test]
    procedure Test_GetNextCandidates_RandomData_03;

    [Test]
    procedure Test_GetNextCandidates_RandomData_04;

    [Test]
    procedure Test_IntersectionOfSetTheory_InternalTests;

    [Test({$IFDEF DEBUG}True{$ELSE}False{$ENDIF})]
    procedure Test_IntersectionOfSetTheory_OptionWithTDictionary;

    [Test({$IFDEF DEBUG}True{$ELSE}False{$ENDIF})]
    procedure Test_IntersectionOfSetTheory_OptionWithArrayFilters;

    [Test]
    procedure Test_GetAverageFromEmptyBaseData();

    [Test]
    procedure Test_CheckGetterAndSetterMinimum();

    [Test]
    procedure Test_GetAlgoFromWeb;
  end;

implementation

uses
  System.Diagnostics,
  System.Generics.Collections,
  Nathan.TArrayHelper; // System.Generics.Defaults,

{$I BigData.inc}

procedure TTestAprioriImpl.Setup;
begin
  FCut := nil;
  FCharacterDemoData := [['A', 'B', 'C'], ['A', 'B', 'D'], ['A', 'B', 'C', 'D'], ['B', 'D']];
end;

procedure TTestAprioriImpl.TearDown;
begin
  FCut := nil;
end;

procedure TTestAprioriImpl.Test_HasNoMemoryLeaks;
begin
  FCut := TApriori.Create(FCharacterDemoData);
  Assert.IsNotNull(FCut);
end;

procedure TTestAprioriImpl.Test_GetC1Support;
var
  Actual: TArray<TItemSet>;
begin
  //  Arrange...
  FCut := TApriori.Create(FCharacterDemoData);

  //  Act...
  Actual := FCut.GetC1Support();

  //  Assert...
  Assert.AreEqual(4, Length(Actual));

  Assert.AreEqual('A', Actual[0].Item);
  Assert.AreEqual(3, Actual[0].OccurTotal);
  Assert.AreEqual<Double>(75.00, Actual[0].Support);

  Assert.AreEqual('B', Actual[1].Item);
  Assert.AreEqual(4, Actual[1].OccurTotal);
  Assert.AreEqual<Double>(100.00, Actual[1].Support);

  Assert.AreEqual('C', Actual[2].Item);
  Assert.AreEqual(2, Actual[2].OccurTotal);
  Assert.AreEqual<Double>(50.00, Actual[2].Support);

  Assert.AreEqual('D', Actual[3].Item);
  Assert.AreEqual(3, Actual[3].OccurTotal);
  Assert.AreEqual<Double>(75.00, Actual[3].Support);
end;

procedure TTestAprioriImpl.Test_GetAverageFromC1_SupportCountAverage;
var
  Actual: Double;
  ListC1: TArray<TItemSet>;
begin
  //  Arrange...
  FCut := TApriori.Create(FCharacterDemoData);

  //  Act...
  ListC1 := FCut.GetC1Support();
  Actual := FCut.GetAverage(ListC1);

  //  Assert...
  Assert.AreEqual<Double>(3.0, Actual);
end;

procedure TTestAprioriImpl.Test_SetMinimumSupport_And_GetL1_FromC1();
var
  Actual: TArray<TItemSet>;
  ListC1: TArray<TItemSet>;
begin
  //  Arrange...
  FCut := TApriori.Create(FCharacterDemoData);

  //  Act...
  FCut.MinimumSupport(2);
  ListC1 := FCut.GetC1Support();
  Actual := FCut.GetLN(ListC1);

  //  Assert...
  Assert.AreEqual(4, Length(Actual));

  Assert.AreEqual('D', Actual[0].Item);
  Assert.AreEqual(3, Actual[0].OccurTotal);
  Assert.AreEqual<Double>(75.00, Actual[0].Support);

  Assert.AreEqual('C', Actual[1].Item);
  Assert.AreEqual(2, Actual[1].OccurTotal);
  Assert.AreEqual<Double>(50.00, Actual[1].Support);

  Assert.AreEqual('B', Actual[2].Item);
  Assert.AreEqual(4, Actual[2].OccurTotal);
  Assert.AreEqual<Double>(100.00, Actual[2].Support);

  Assert.AreEqual('A', Actual[3].Item);
  Assert.AreEqual(3, Actual[3].OccurTotal);
  Assert.AreEqual<Double>(75.00, Actual[3].Support);
end;

procedure TTestAprioriImpl.Test_GetNextCandidates(K, Return: Integer);
var
  Actual: TArray<TItemSets>;
  ListC1: TArray<TItemSet>;
begin
  //  Arrange...
  FCut := TApriori.Create(FCharacterDemoData);

  //  Act...
  ListC1 := FCut.GetC1Support();
  Actual := FCut.GetNextCandidates(ListC1, K);

  //  Assert...
  Assert.AreEqual(Return, Length(Actual));
end;

procedure TTestAprioriImpl.Test_GetNextCandidates_TwoTimesInSequence;
var
  Actual: TArray<TItemSets>;
  ListC1: TArray<TItemSet>;
begin
  FCut := TApriori.Create(FCharacterDemoData);

  ListC1 := FCut.GetC1Support();

  Actual := FCut.GetNextCandidates(ListC1, 2);
  Assert.AreEqual(6, Length(Actual));

  Actual := FCut.GetNextCandidates(ListC1, 3);
  Assert.AreEqual(4, Length(Actual));
end;

procedure TTestAprioriImpl.Test_GetNextCandidates_RandomData_01;
var
  Actual: TArray<TItemSets>;
  RandomDemoData: TArray<TArray<string>>;
  ListC1: TArray<TItemSet>;
begin
  //  Arrange...
  {$REGION 'Random Demo Data'}
    //  Generate online:
    //  Four items, with 4 transaktions:
    //  [C, A, D]
    //  [A, C]
    //  [C, B, A, D]
    //  [B]
    //
    //  Support Threshold (%):    40%
    //  Confidence Threshold (%): 70%
    //
    //  8 Large Itemsets (by Apriori):
    //  {C} (support: 75%)
    //  {A} (support: 75%)
    //  {D} (support: 50%)
    //  {B} (support: 50%)
    //  {C, A} (support: 75%)
    //  {C, D} (support: 50%)
    //  {A, D} (support: 50%)
    //  {C, A, D} (support: 50%)
    //
    //  7 Association Rules
    //  {C} => {A} (Support: 75.00%,  Confidence: 100.00%)
    //  {A} => {C} (Support: 75.00%,  Confidence: 100.00%)
    //  {D} => {C} (Support: 50.00%,  Confidence: 100.00%)
    //  {D} => {A} (Support: 50.00%,  Confidence: 100.00%)
    //  {D} => {C, A} (Support: 50.00%,  Confidence: 100.00%)
    //  {C, D} => {A} (Support: 50.00%,  Confidence: 100.00%)
    //  {A, D} => {C} (Support: 50.00%,  Confidence: 100.00%)
  {$ENDREGION}
  RandomDemoData := [['C', 'A', 'D'], ['A', 'C'], ['C', 'B', 'A', 'D'], ['B']];

  FCut := TApriori.Create(RandomDemoData);

  //  Act...
  ListC1 := FCut.GetC1Support();
  Actual := FCut.GetNextCandidates(ListC1, 2);

  //  Assert...

  //  C1 Data...
  Assert.AreEqual(4, Length(ListC1));

  Assert.AreEqual('C', ListC1[0].Item);
  Assert.AreEqual(3, ListC1[0].OccurTotal);
  Assert.AreEqual(3, ListC1[0].OccurPerTransaction);
  Assert.AreEqual<Double>(75.00, ListC1[0].Support);

  Assert.AreEqual('A', ListC1[1].Item);
  Assert.AreEqual(3, ListC1[1].OccurTotal);
  Assert.AreEqual(3, ListC1[1].OccurPerTransaction);
  Assert.AreEqual<Double>(75.00, ListC1[1].Support);

  Assert.AreEqual('D', ListC1[2].Item);
  Assert.AreEqual(2, ListC1[2].OccurTotal);
  Assert.AreEqual(2, ListC1[2].OccurPerTransaction);
  Assert.AreEqual<Double>(50.00, ListC1[2].Support);

  Assert.AreEqual('B', ListC1[3].Item);
  Assert.AreEqual(2, ListC1[3].OccurTotal);
  Assert.AreEqual(2, ListC1[3].OccurPerTransaction);
  Assert.AreEqual<Double>(50.00, ListC1[3].Support);

  //  CN Data...
  Assert.AreEqual(6, Length(Actual));

  //  Like: {C, A} (support: 75%)
  Assert.AreEqual(2, Length(Actual[0].Items));  //  Same size as K...

  Assert.AreEqual('C', Actual[0].Items[0].Item);
  Assert.AreEqual('A', Actual[0].Items[1].Item);
  Assert.AreEqual<Double>(75.00, Actual[0].Support);
  Assert.AreEqual<Double>(100.00, AprioriConfidence.AssociationRule(Actual[0], Actual[0].Items[0]));

  {$REGION 'Why do the values have to be exactly like this (intersection)?'}
  //  [C, A, D]
  //  [A, C]
  //  [C, B, A, D]
  //  [B]
  //
  //  C 1 2 3   |
  //  D 1 2      = 50%
  //
  //  A 1 2 3   |
  //  B     3 4  = 25%
  {$ENDREGION}
  Assert.AreEqual('C', Actual[1].Items[0].Item);
  Assert.AreEqual('D', Actual[1].Items[1].Item);
  Assert.AreEqual<Double>(50.00, Actual[1].Support);
  Assert.AreEqual<Double>(100.00, AprioriConfidence.AssociationRule(Actual[0], Actual[0].Items[0]));

  Assert.AreEqual('A', Actual[4].Items[0].Item);
  Assert.AreEqual('B', Actual[4].Items[1].Item);
  Assert.AreEqual<Double>(25.00, Actual[2].Support);
end;

procedure TTestAprioriImpl.Test_GetNextCandidates_RandomData_02;
var
  RandomDemoData: TArray<TArray<string>>;

  ListC1: TArray<TItemSet>;
  ListCN: TArray<TItemSets>;

  conf_E_B: Double;
begin
  //  Arrange...
  {$REGION 'Random Demo Data'}
    //  Generate online:
    //  Five items, with 5 transaktions:
    //  [E, C, B]
    //  [B]
    //  [B, D]
    //  [A, B, E]
    //  [B, E]
    //
    //  Support Threshold (%):    40%
    //  Confidence Threshold (%): 70%
    //
    //  3 Large Itemsets (by Apriori):
    //  {E} (support: 60%)
    //  {B} (support: 100%)
    //  {E, B} (support: 60%)
    //
    //  1 Association Rules
    //  {E} => {B} (Support: 60.00%,  Confidence: 100.00%)
  {$ENDREGION}
  RandomDemoData := [['E', 'C', 'B'], ['B'], ['B', 'D'], ['A', 'B', 'E'], ['B', 'E']];
  FCut := TApriori.Create(RandomDemoData);

  //  Act & Assert...

  FCut.MinimumSupport(40);
  ListC1 := FCut.GetC1Support();
  Assert.AreEqual(5, Length(ListC1));

  ListC1 := FCut.GetLN(ListC1);
  Assert.AreEqual(2, Length(ListC1));

  //  Rules with twice items...
  ListCN := FCut.GetNextCandidates(ListC1, 2);
  Assert.AreEqual(1, Length(ListCN));

  Assert.AreEqual('B', ListCN[0].Items[0].Item);
  Assert.AreEqual<Double>(100.00, ListCN[0].Items[0].Support);

  Assert.AreEqual('E', ListCN[0].Items[1].Item);
  Assert.AreEqual<Double>(60.00, ListCN[0].Items[1].Support);

  Assert.AreEqual<Double>(60.00, ListCN[0].Support);
  conf_E_B := AprioriConfidence.AssociationRule(ListCN[0], ListCN[0].Items[1]);
  Assert.AreEqual<Double>(100.00, conf_E_B);


  //  Here stopps the algorithm, because we don't have more combinations...
  ListCN := FCut.GetNextCandidates(ListC1, 3);
  Assert.AreEqual(0, Length(ListCN));
end;

procedure TTestAprioriImpl.Test_GetNextCandidates_RandomData_03;
var
  RandomDemoData: TArray<TArray<string>>;

  ListC1: TArray<TItemSet>;
  ListCN: TArray<TItemSets>;

  conf: Double;
begin
  //  Arrange...
  {$REGION 'Random Demo Data'}
    //  Generate online:
    //  Five items, with 5 transaktions:
    //    cheese, diaper, water, bread, umbrella
    //    diaper, water
    //    cheese, diaper, milk
    //    diaper, cheese, detergent
    //    cheese, milk, beer
    //
    //  Support Threshold (%):    40%
    //  Confidence Threshold (%): 70%
    //
    //  7 Large Itemsets (by Apriori):
    //  {cheese} (support: 80%)
    //  {diaper} (support: 80%)
    //  {water} (support: 40%)
    //  {milk} (support: 40%)
    //  {cheese, diaper} (support: 60%)
    //  {diaper, water} (support: 40%)
    //  {cheese, milk} (support: 40%)
    //
    //  4 Association Rules
    //  {cheese} => {diaper} (Support: 60.00%,  Confidence: 75.00%)
    //  {diaper} => {cheese} (Support: 60.00%,  Confidence: 75.00%)
    //  {water} => {diaper} (Support: 40.00%,  Confidence: 100.00%)
    //  {milk} => {cheese} (Support: 40.00%,  Confidence: 100.00%)
  {$ENDREGION}
  RandomDemoData := [
    ['cheese', 'diaper', 'water', 'bread', 'umbrella'],
    ['diaper', 'water'],
    ['cheese', 'diaper', 'milk'],
    ['diaper', 'cheese', 'detergent'],
    ['cheese', 'milk', 'beer']];

  FCut := TApriori.Create(RandomDemoData);

  //  Act & Assert...
  ListC1 := FCut
    .MinimumSupport(40)
    .MinimumConfidence(70)
    .GetC1Support();
  ListC1 := FCut.GetLN(ListC1);
  Assert.AreEqual(4, Length(ListC1));
  Assert.AreEqual('milk', ListC1[0].Item);
  Assert.AreEqual('water', ListC1[1].Item);
  Assert.AreEqual('diaper', ListC1[2].Item);
  Assert.AreEqual('cheese', ListC1[3].Item);

  ListCN := FCut.GetNextCandidates(ListC1, 2);
  ListCN := FCut.GetLN(ListCN);
  Assert.AreEqual(3, Length(ListCN));
  Assert.AreEqual('diaper', ListCN[0].Items[0].Item);
  Assert.AreEqual('cheese', ListCN[0].Items[1].Item);
  Assert.AreEqual('water', ListCN[1].Items[0].Item);
  Assert.AreEqual('diaper', ListCN[1].Items[1].Item);
  Assert.AreEqual('milk', ListCN[2].Items[0].Item);
  Assert.AreEqual('cheese', ListCN[2].Items[1].Item);

  //  {cheese} => {diaper} (Support: 60.00%,  Confidence: 75.00%)
  conf := AprioriConfidence.AssociationRule(ListCN[0], ListCN[0].Items[1]);
  Assert.AreEqual<Double>(75.00, conf);

  //  {water} => {diaper} (Support: 40.00%,  Confidence: 100.00%)
  conf := AprioriConfidence.AssociationRule(ListCN[1], ListCN[1].Items[0]);
  Assert.AreEqual<Double>(100.00, conf);

  //  {milk} => {cheese} (Support: 40.00%,  Confidence: 100.00%)
  conf := AprioriConfidence.AssociationRule(ListCN[2], ListCN[2].Items[0]);
  Assert.AreEqual<Double>(100.00, conf);
end;

procedure TTestAprioriImpl.Test_GetNextCandidates_RandomData_04;
var
  ListC1: TArray<TItemSet>;
  ListCN: TArray<TItemSets>;

  conf: Double;
begin
  //  Arrange...
  {$REGION 'Random Demo Data'}
    //  Generate online:
    //  Items {A, B, C, D, E, F, G, H}, with 500000 transaktions:
    //    look under inc file
    //
    //  Support Threshold (%):    40%
    //  Confidence Threshold (%): 70%
    //
    //  8 Large Itemsets (by Apriori):
    //  {G} (support: 42.756%)
    //  {A} (support: 42.948%)
    //  {C} (support: 42.868%)
    //  {B} (support: 42.732%)
    //  {H} (support: 42.614000000000004%)
    //  {D} (support: 42.778%)
    //  {F} (support: 42.642%)
    //  {E} (support: 43.07%)
    //
    //  0 Association Rules
  {$ENDREGION}
  FCut := TApriori.Create(RandomDemoData04);

  //  Act & Assert...
  ListC1 := FCut
    .MinimumSupport(40)
    .MinimumConfidence(70)
    .GetC1Support();
  ListC1 := FCut.GetLN(ListC1);

  Assert.AreEqual(8, Length(ListC1));

  Assert.AreEqual('E', ListC1[0].Item);
  Assert.AreEqual('F', ListC1[1].Item);
  Assert.AreEqual('D', ListC1[2].Item);
  Assert.AreEqual('H', ListC1[3].Item);
  Assert.AreEqual('B', ListC1[4].Item);
  Assert.AreEqual('C', ListC1[5].Item);
  Assert.AreEqual('A', ListC1[6].Item);
  Assert.AreEqual('G', ListC1[7].Item);

  Assert.AreEqual<Double>(43.070, ListC1[0].Support);
  Assert.AreEqual<Double>(42.642, ListC1[1].Support);
  Assert.AreEqual<Double>(42.778, ListC1[2].Support);
  Assert.AreEqual<Double>(42.614, ListC1[3].Support);
  Assert.AreEqual<Double>(42.732, ListC1[4].Support);
  Assert.AreEqual<Double>(42.868, ListC1[5].Support);
  Assert.AreEqual<Double>(42.948, ListC1[6].Support);
  Assert.AreEqual<Double>(42.756, ListC1[7].Support);

//  ListCN := FCut.GetNextCandidates(ListC1, 2);
//  ListCN := FCut.GetLN(ListCN);
//  Assert.AreEqual(3, Length(ListCN));
//  Assert.AreEqual('diaper', ListCN[0].Items[0].Item);
//  Assert.AreEqual('cheese', ListCN[0].Items[1].Item);
//  Assert.AreEqual('water', ListCN[1].Items[0].Item);
//  Assert.AreEqual('diaper', ListCN[1].Items[1].Item);
//  Assert.AreEqual('milk', ListCN[2].Items[0].Item);
//  Assert.AreEqual('cheese', ListCN[2].Items[1].Item);
//
//  //  {cheese} => {diaper} (Support: 60.00%,  Confidence: 75.00%)
//  conf := AprioriConfidence.AssociationRule(ListCN[0], ListCN[0].Items[1]);
//  Assert.AreEqual<Double>(75.00, conf);
//
//  //  {water} => {diaper} (Support: 40.00%,  Confidence: 100.00%)
//  conf := AprioriConfidence.AssociationRule(ListCN[1], ListCN[1].Items[0]);
//  Assert.AreEqual<Double>(100.00, conf);
//
//  //  {milk} => {cheese} (Support: 40.00%,  Confidence: 100.00%)
//  conf := AprioriConfidence.AssociationRule(ListCN[2], ListCN[2].Items[0]);
//  Assert.AreEqual<Double>(100.00, conf);
end;

procedure TTestAprioriImpl.Test_IntersectionOfSetTheory_InternalTests;
var
  Idx: Integer;
  A1, A2, A3: TArray<Integer>;
  Actual: TArray<Integer>;
  arr1, arr2: TArray<Integer>;
  FoundIndex: Integer;

  hash: TDictionary<Integer,Integer>;
  hashaction: TProc<TArray<Integer>, TDictionary<Integer,Integer>>;
  return: TArray<TPair<Integer, Integer>>;
begin
  //  Option 1, with BinarySearch...
  //  https://www.geeksforgeeks.org/find-union-and-intersection-of-two-unsorted-arrays/
  arr1 := [3, 8, 6, 20, 7];
  arr2 := [7, 1, 5, 2, 3, 6];
  //  Be sure the first one's smaller, otherwise exchange the elements...
  //  Sort smaller array arr1[0..n-1]...
  TArray.Sort<Integer>(arr1);

  //  Search every element of bigger array in smaller array and print the element if found...
  for Idx := Low(arr2) to High(arr2) do
  begin
    if (TArray.BinarySearch<Integer>(arr1, arr2[Idx], FoundIndex)) then
      Actual := Actual + [arr1[FoundIndex]];
  end;

  Assert.AreEqual(3, Length(Actual));
  Assert.AreEqual(7, Actual[0]);
  Assert.AreEqual(3, Actual[1]);
  Assert.AreEqual(6, Actual[2]);

  //  Option 2, with TDictionary...
  //  Sample with intersection of N arrays. The BinarySearch works only with 2 arrays..
  Actual := [];
  A1 := [1, 2, 3];
  A2 := [3, 4];
  A3 := [2, 3, 4, 5];

  hashaction :=
    procedure(AArray: TArray<Integer>; AHashDic: TDictionary<Integer,Integer>)
    var
      Inner: Integer;
    begin
      for Inner := Low(AArray) to High(AArray) do
      begin
        if AHashDic.ContainsKey(AArray[Inner]) then
          AHashDic.Items[AArray[Inner]] := AHashDic.Items[AArray[Inner]] + 1
        else
          AHashDic.Add(AArray[Inner], 1);
      end;
    end;

  hash := TDictionary<Integer,Integer>.Create;
  try
    hashaction(A1, hash);
    hashaction(A2, hash);
    hashaction(A3, hash);

    Actual := [];
    return := hash.ToArray;
    for Idx := Low(return) to High(return) do
      if (return[Idx].Value = 3) then
        Actual := Actual + [return[Idx].Key];
  finally
    hash.Free;
  end;

  Assert.AreEqual(1, Length(Actual));
  Assert.AreEqual(3, Actual[0]);

  //  Option 3, with array filters...
  //  https://medium.com/@alvaro.saburido/set-theory-for-arrays-in-es6-eb2f20a61848
  Actual := TArray(A1).Filter<Integer>(
    function(x: Integer): Boolean
    begin
      Result := (TArray.IndexOf<Integer>(A2, x) > -1) and (TArray.IndexOf<Integer>(A3, x) > -1);
    end);

  Assert.AreEqual(1, Length(Actual));
  Assert.AreEqual(3, Actual[0]);
end;

function TTestAprioriImpl.Test_IntersectionOfSetTheory_OptionStopwatch(
  AProc: TProc<TArray<Integer>, TArray<Integer>, TArray<Integer>>): Int64;
var
  Watch: TStopwatch;
  A1, A2, A3: TArray<Integer>;
begin
  A1 := [1, 2, 3];
  A2 := [3, 4];
  A3 := [2, 3, 4, 5];

  Watch := TStopwatch.Create;
  Watch.Reset;
  Watch.Start;
  AProc(A1, A2, A3);
  Watch.Stop;
  Result := Watch.ElapsedTicks;
end;

procedure TTestAprioriImpl.Test_IntersectionOfSetTheory_OptionWithTDictionary;
var
  Duration: Int64;
begin
  Duration := Test_IntersectionOfSetTheory_OptionStopwatch(
    procedure(A1, A2, A3: TArray<Integer>)
    var
      Idx: Integer;
      IntersectionArray: TArray<Integer>;
      hash: TDictionary<Integer,Integer>;
      hashaction: TProc<TArray<Integer>, TDictionary<Integer,Integer>>;
      return: TArray<TPair<Integer, Integer>>;
    begin
      hashaction :=
        procedure(AArray: TArray<Integer>; AHashDic: TDictionary<Integer,Integer>)
        var
          Inner: Integer;
        begin
          for Inner := Low(AArray) to High(AArray) do
          begin
            if AHashDic.ContainsKey(AArray[Inner]) then
              AHashDic.Items[AArray[Inner]] := AHashDic.Items[AArray[Inner]] + 1
            else
              AHashDic.Add(AArray[Inner], 1);
          end;
        end;

        hash := TDictionary<Integer,Integer>.Create;
        try
          hashaction(A1, hash);
          hashaction(A2, hash);
          hashaction(A3, hash);

          IntersectionArray := [];
          return := hash.ToArray;
          for Idx := Low(return) to High(return) do
            if (return[Idx].Value = 3) then
              IntersectionArray := IntersectionArray + [return[Idx].Key];
        finally
          hash.Free;
        end;

        Assert.AreEqual(1, Length(IntersectionArray));
        Assert.AreEqual(3, IntersectionArray[0]);
    end);

  Assert.AreEqual<Int64>(1, Duration);  //  Must be failed...
end;

procedure TTestAprioriImpl.Test_IntersectionOfSetTheory_OptionWithArrayFilters;
var
  Duration: Int64;
begin
  Duration := Test_IntersectionOfSetTheory_OptionStopwatch(
    procedure(A1, A2, A3: TArray<Integer>)
    var
      IntersectionArray: TArray<Integer>;
    begin
      IntersectionArray := TArray(A1).Filter<Integer>(
        function(x: Integer): Boolean
        begin
          Result := (TArray.IndexOf<Integer>(A2, x) > -1) and (TArray.IndexOf<Integer>(A3, x) > -1);
        end);

      Assert.AreEqual(1, Length(IntersectionArray));
      Assert.AreEqual(3, IntersectionArray[0]);
    end);

  Assert.AreEqual<Int64>(1, Duration);  //  Must be failed...
end;

procedure TTestAprioriImpl.Test_GetAverageFromEmptyBaseData;
var
  Actual: Double;
  ListC1: TArray<TItemSet>;
begin
  //  Arrange...
  FCut := TApriori.Create(nil);

  //  Act...
  ListC1 := FCut.GetC1Support();
  Actual := FCut.GetAverage(ListC1);

  //  Assert...
  Assert.AreEqual<Double>(0.0, Actual);
end;

procedure TTestAprioriImpl.Test_CheckGetterAndSetterMinimum;
begin
  //  Arrange...
  FCut := TApriori.Create(FCharacterDemoData);

  //  Act...
  FCut
    .MinimumSupport(40.00)
    .MinimumConfidence(80.00);

  //  Assert...
  Assert.AreEqual<Double>(40.00, FCut.MinimumSupport);
  Assert.AreEqual<Double>(80.00, FCut.MinimumConfidence);
end;

procedure TTestAprioriImpl.Test_GetAlgoFromWeb;
var
  DemoData: TArray<TArray<string>>;

  ListC1: TArray<TItemSet>;
  ListCN: TArray<TItemSets>;
begin
  //  Data from: https://rasbt.github.io/mlxtend/user_guide/frequent_patterns/apriori/

  //  Arrange...
  DemoData := [
    ['Milk', 'Onion', 'Nutmeg', 'Kidney Beans', 'Eggs', 'Yogurt'],
    ['Dill', 'Onion', 'Nutmeg', 'Kidney Beans', 'Eggs', 'Yogurt'],
    ['Milk', 'Apple', 'Kidney Beans', 'Eggs'],
    ['Milk', 'Unicorn', 'Corn', 'Kidney Beans', 'Yogurt'],
    ['Corn', 'Onion', 'Onion', 'Kidney Beans', 'Ice cream', 'Eggs']];

  FCut := TApriori.Create(DemoData);

  //  Act...
  ListC1 := FCut
    .MinimumSupport(60.00)
    .GetC1Support();
  ListC1 := FCut.GetLN(ListC1);

  //  Assert C1...
  Assert.AreEqual(5, Length(ListC1));

  Assert.AreEqual('Yogurt', ListC1[0].Item);
  Assert.AreEqual<Double>(60.00, ListC1[0].Support);

  Assert.AreEqual('Eggs', ListC1[1].Item);
  Assert.AreEqual<Double>(80.00, ListC1[1].Support);

  Assert.AreEqual('Kidney Beans', ListC1[2].Item);
  Assert.AreEqual<Double>(100.00, ListC1[2].Support);

  Assert.AreEqual('Onion', ListC1[3].Item);
  Assert.AreEqual<Double>(60.00, ListC1[3].Support);  //  Must be 60 percent, because Onion in one transaction two times.

  Assert.AreEqual('Milk', ListC1[4].Item);
  Assert.AreEqual<Double>(60.00, ListC1[4].Support);


  //  Act & Assert CN twice items...
  ListCN := FCut.GetNextCandidates(ListC1, 2);
  ListCN := FCut.GetLN(ListCN);

  Assert.AreEqual(5, Length(ListCN));

  Assert.AreEqual('Kidney Beans', ListCN[0].Items[0].Item);
  Assert.AreEqual('Milk', ListCN[0].Items[1].Item);
  Assert.AreEqual<Double>(60.00, ListCN[0].Support);

  Assert.AreEqual('Kidney Beans', ListCN[1].Items[0].Item);
  Assert.AreEqual('Onion', ListCN[1].Items[1].Item);
  Assert.AreEqual<Double>(60.00, ListCN[1].Support);

  Assert.AreEqual('Eggs', ListCN[2].Items[0].Item);
  Assert.AreEqual('Onion', ListCN[2].Items[1].Item);
  Assert.AreEqual<Double>(60.00, ListCN[2].Support);

  Assert.AreEqual('Eggs', ListCN[3].Items[0].Item);
  Assert.AreEqual('Kidney Beans', ListCN[3].Items[1].Item);
  Assert.AreEqual<Double>(80.00, ListCN[3].Support);

  Assert.AreEqual('Yogurt', ListCN[4].Items[0].Item);
  Assert.AreEqual('Kidney Beans', ListCN[4].Items[1].Item);
  Assert.AreEqual<Double>(60.00, ListCN[4].Support);

  //  Act & Assert CN triply items...
  ListCN := FCut.GetNextCandidates(ListC1, 3);
  ListCN := FCut.GetLN(ListCN);

  Assert.AreEqual(1, Length(ListCN));

  Assert.AreEqual('Eggs', ListCN[0].Items[0].Item);
  Assert.AreEqual('Kidney Beans', ListCN[0].Items[1].Item);
  Assert.AreEqual('Onion', ListCN[0].Items[2].Item);
  Assert.AreEqual<Double>(60.00, ListCN[0].Support);
end;

initialization
  TDUnitX.RegisterTestFixture(TTestAprioriImpl, 'Algo');

end.
