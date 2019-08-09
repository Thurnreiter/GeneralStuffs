unit Test.Apriori.Impl.ExternalReference;

interface

uses
  System.SysUtils,
  DUnitX.TestFramework,
  Apriori.Algo,
  Apriori.Items,
  Apriori.Confidence;

type
  [TestFixture]
  TTestAprioriImplExternalReference = class(TObject)
  //  Data from: http://p-nand-q.com/business/4/apriori.html
  strict private
    FCut: IApriori;
    FDemoData: TArray<TArray<string>>;
  public
    [Setup]
    procedure Setup;

    [TearDown]
    procedure TearDown;

    [Test]
    procedure Test_GetAlgoFromWebSample_C1;

    [Test]
    procedure Test_GetAlgoFromWebSample_L1;

    [Test]
    procedure Test_GetAlgoFromWebSample_L2;

    [Test]
    procedure Test_GetAlgoFromWebSample_L3;

    [Test]
    procedure Test_GetAlgoFromWebSample_L4;
  end;

implementation

uses
  System.Generics.Collections;

procedure TTestAprioriImplExternalReference.Setup;
begin
  FDemoData := [
    ['bread', 'butter', 'salt', 'meat', 'sugar', 'flour', 'nuts', 'backing'],
    ['bread', 'butter', 'wine', 'cookies', 'fruit'],
    ['bread', 'wine', 'milk', 'butter', 'newspaper', 'yoghurt'],
    ['bread', 'newspaper', 'wine', 'milk', 'newspaper'],
    ['wine', 'cracker', 'bread', 'meat', 'chocolate', 'newspaper'],
    ['wine', 'cracker', 'salt', 'fish', 'meat', 'butter', 'milk', 'chocolate'],
    ['wine', 'sugar', 'flour', 'baking powder', 'milk', 'butter'],
    ['newspaper', 'beer', 'wine', 'bread']];
  FCut := TApriori.Create(FDemoData);
end;

procedure TTestAprioriImplExternalReference.TearDown;
begin
  FCut := nil;
end;

procedure TTestAprioriImplExternalReference.Test_GetAlgoFromWebSample_C1;
var
  ListC1: TArray<TItemSet>;
//  ListCN: TArray<TItemSets>;
begin
  //  Arrange...
  //  Act...
  ListC1 := FCut
    .GetC1Support();

  ListC1 := FCut.GetLN(ListC1);

  //  Assert C1...
  Assert.AreEqual(19, Length(ListC1));

  Assert.AreEqual('beer', ListC1[0].Item);
  Assert.AreEqual('baking powder', ListC1[1].Item);
  Assert.AreEqual('fish', ListC1[2].Item);
  Assert.AreEqual('chocolate', ListC1[3].Item);
  Assert.AreEqual('cracker', ListC1[4].Item);
  Assert.AreEqual('yoghurt', ListC1[5].Item);
  Assert.AreEqual('newspaper', ListC1[6].Item);
  Assert.AreEqual('milk', ListC1[7].Item);
  Assert.AreEqual('fruit', ListC1[8].Item);
  Assert.AreEqual('cookies', ListC1[9].Item);
  Assert.AreEqual('wine', ListC1[10].Item);
  Assert.AreEqual('backing', ListC1[11].Item);
  Assert.AreEqual('nuts', ListC1[12].Item);
  Assert.AreEqual('flour', ListC1[13].Item);
  Assert.AreEqual('sugar', ListC1[14].Item);
  Assert.AreEqual('meat', ListC1[15].Item);
  Assert.AreEqual('salt', ListC1[16].Item);
  Assert.AreEqual('butter', ListC1[17].Item);
  Assert.AreEqual('bread', ListC1[18].Item);

  Assert.AreEqual<Double>(12.5, ListC1[0].Support);
  Assert.AreEqual<Double>(12.5, ListC1[1].Support);
  Assert.AreEqual<Double>(12.5, ListC1[2].Support);
  Assert.AreEqual<Double>(25.0, ListC1[3].Support);
  Assert.AreEqual<Double>(25.0, ListC1[4].Support);
  Assert.AreEqual<Double>(12.5, ListC1[5].Support);
  Assert.AreEqual<Double>(50.0, ListC1[6].Support);
  Assert.AreEqual<Double>(50.0, ListC1[7].Support);
  Assert.AreEqual<Double>(12.5, ListC1[8].Support);
  Assert.AreEqual<Double>(12.5, ListC1[9].Support);
  Assert.AreEqual<Double>(87.5, ListC1[10].Support);
  Assert.AreEqual<Double>(12.5, ListC1[11].Support);
  Assert.AreEqual<Double>(12.5, ListC1[12].Support);
  Assert.AreEqual<Double>(25.0, ListC1[13].Support);
  Assert.AreEqual<Double>(25.0, ListC1[14].Support);
  Assert.AreEqual<Double>(37.5, ListC1[15].Support);
  Assert.AreEqual<Double>(25.0, ListC1[16].Support);
  Assert.AreEqual<Double>(62.5, ListC1[17].Support);
  Assert.AreEqual<Double>(75.0, ListC1[18].Support);
end;

procedure TTestAprioriImplExternalReference.Test_GetAlgoFromWebSample_L1;
var
  ListC1: TArray<TItemSet>;
//  ListCN: TArray<TItemSets>;
begin
  //  Arrange...
  //  Act...
  ListC1 := FCut
    .MinimumSupport(50.00)
    .GetC1Support();
  ListC1 := FCut.GetLN(ListC1);

  //  Assert L1...
  Assert.AreEqual(5, Length(ListC1));

  Assert.AreEqual('newspaper', ListC1[0].Item);
  Assert.AreEqual('milk', ListC1[1].Item);
  Assert.AreEqual('wine', ListC1[2].Item);
  Assert.AreEqual('butter', ListC1[3].Item);
  Assert.AreEqual('bread', ListC1[4].Item);
end;

procedure TTestAprioriImplExternalReference.Test_GetAlgoFromWebSample_L2;
var
  ListC1: TArray<TItemSet>;
  ListCN: TArray<TItemSets>;
begin
  //  Arrange...
  //  Act...
  ListC1 := FCut.GetC1Support();
  ListCN := FCut.GetNextCandidates(ListC1, 2);
  ListCN := FCut.MinimumSupport(50.00).GetLN(ListCN);

  //  Assert C1...
  Assert.AreEqual(19, Length(ListC1));
  Assert.AreEqual(5, Length(ListCN));

  Assert.AreEqual('wine', ListCN[0].Items[0].Item);
  Assert.AreEqual('newspaper', ListCN[0].Items[1].Item);
  Assert.AreEqual<Double>(50.00, ListCN[0].Support);

  Assert.AreEqual('wine', ListCN[1].Items[0].Item);
  Assert.AreEqual('milk', ListCN[1].Items[1].Item);
  Assert.AreEqual<Double>(50.00, ListCN[1].Support);

  Assert.AreEqual('butter', ListCN[2].Items[0].Item);
  Assert.AreEqual('wine', ListCN[2].Items[1].Item);
  Assert.AreEqual<Double>(50.00, ListCN[2].Support);

  Assert.AreEqual('bread', ListCN[3].Items[0].Item);
  Assert.AreEqual('newspaper', ListCN[3].Items[1].Item);
  Assert.AreEqual<Double>(50.00, ListCN[3].Support);

  Assert.AreEqual('bread', ListCN[4].Items[0].Item);
  Assert.AreEqual('wine', ListCN[4].Items[1].Item);
  Assert.AreEqual<Double>(62.50, ListCN[4].Support);

  //  Confidences:
  //  Bread => Wine
  Assert.AreEqual(83.33, AprioriConfidence.AssociationRule(ListCN[4], ListCN[4].Items[0]), 0.1);

  //  Bread => Newspaper
  Assert.AreEqual(67.66, AprioriConfidence.AssociationRule(ListCN[3], ListCN[3].Items[0]), 1.0);

  //  Butter => Wine
  Assert.AreEqual(80.00, AprioriConfidence.AssociationRule(ListCN[2], ListCN[2].Items[0]), 0.1);

  //  Milk => Wine
  Assert.AreEqual(100.00, AprioriConfidence.AssociationRule(ListCN[1], ListCN[1].Items[1]), 0.1);

  //  Wine => Bread
  Assert.AreEqual(71.42, AprioriConfidence.AssociationRule(ListCN[4], ListCN[4].Items[1]), 0.1);

  //  Wine => Butter
  Assert.AreEqual(57.14, AprioriConfidence.AssociationRule(ListCN[2], ListCN[2].Items[1]), 0.1);

  //  Wine => Milk
  Assert.AreEqual(57.14, AprioriConfidence.AssociationRule(ListCN[1], ListCN[1].Items[0]), 0.1);

  //  Wine => Newspaper
  Assert.AreEqual(57.14, AprioriConfidence.AssociationRule(ListCN[0], ListCN[0].Items[0]), 0.1);

  //  Newspaper => Bread
  Assert.AreEqual(100.00, AprioriConfidence.AssociationRule(ListCN[3], ListCN[3].Items[1], True), 0.1);

  //  Newspaper => Wine
  Assert.AreEqual(100.00, AprioriConfidence.AssociationRule(ListCN[0], ListCN[0].Items[1], True), 0.1);
end;

procedure TTestAprioriImplExternalReference.Test_GetAlgoFromWebSample_L3;
var
  ListC1: TArray<TItemSet>;
  ListCN: TArray<TItemSets>;
  Rules: TArray<TConfidenceRules>;
begin
  //  Arrange...
  //  Act...
  ListC1 := FCut.GetC1Support();
  ListCN := FCut.GetNextCandidates(ListC1, 3);
  ListCN := FCut.MinimumSupport(50.00).GetLN(ListCN);

  //  Assert...
  Assert.AreEqual(19, Length(ListC1));
  Assert.AreEqual(1, Length(ListCN));

  Assert.AreEqual('bread', ListCN[0].Items[0].Item);
  Assert.AreEqual('wine', ListCN[0].Items[1].Item);
  Assert.AreEqual('newspaper', ListCN[0].Items[2].Item);
  Assert.AreEqual<Double>(50.00, ListCN[0].Support);

  //  Confidences:

  //  Calculate rules automatic...
  Rules := FCut
    .MinimumConfidence(50.00)
    .ConfidencesRules(ListCN, True);
  Assert.AreEqual(3, Length(Rules));
  Assert.AreEqual('bread', Rules[0].Item.Item);
  Assert.AreEqual('wine', Rules[1].Item.Item);
  Assert.AreEqual('newspaper', Rules[2].Item.Item);
  Assert.AreEqual(67.66, Rules[0].Confidence, 1.0);
  Assert.AreEqual(57.14, Rules[1].Confidence, 1.0);
  Assert.AreEqual(100.00, Rules[2].Confidence, 1.0);

  //  Bread => Newspaper, Wine
  Assert.AreEqual(67.66, AprioriConfidence.AssociationRule(ListCN[0], ListCN[0].Items[0]), 1.0);

  //  Wine => Newspaper, Bread
  Assert.AreEqual(57.14, AprioriConfidence.AssociationRule(ListCN[0], ListCN[0].Items[1]), 1.0);

  //  Newspaper => Wine, Bread
  Assert.AreEqual(100.00, AprioriConfidence.AssociationRule(ListCN[0], ListCN[0].Items[2], True), 1.0);

  Rules := FCut
    .MinimumConfidence(80.00)
    .ConfidencesRules(ListCN, True);
  Assert.AreEqual(1, Length(Rules));
end;

procedure TTestAprioriImplExternalReference.Test_GetAlgoFromWebSample_L4;
var
  ListC1: TArray<TItemSet>;
  ListCN: TArray<TItemSets>;
  Rules: TArray<TConfidenceRules>;
begin
  //  Arrange...
  //  Act...
  ListC1 := FCut.GetC1Support();
  ListCN := FCut.GetNextCandidates(ListC1, 4);
  ListCN := FCut.MinimumSupport(50.00).GetLN(ListCN);

  //  Calculate rules automatic...
  Rules := FCut.ConfidencesRules(ListCN, True);

  //  Assert...
  Assert.AreEqual(19, Length(ListC1));
  Assert.AreEqual(0, Length(ListCN));
  Assert.AreEqual(0, Length(Rules));
end;

initialization
  TDUnitX.RegisterTestFixture(TTestAprioriImplExternalReference, 'AlgoER');

end.
