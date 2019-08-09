unit Test.Apriori.Impl.Provider;

interface

uses
  DUnitX.TestFramework,
  Apriori.Provider;

type
  [TestFixture]
  TTestAprioriImplProvider = class(TObject)
  strict private
    FCut: IAprioriProvider;
  public
    [Setup]
    procedure Setup;

    [TearDown]
    procedure TearDown;

    [Test]
    procedure Test_HasNoMemoryLeaks;

    [Test]
    procedure Test_HasC1;

    [Test]
    procedure Test_HasLNWitoutParam;
  end;

implementation

uses
  Apriori.Items;

procedure TTestAprioriImplProvider.Setup;
var
  DemoData: TArray<TArray<string>>;
begin
  DemoData := [
    ['bread', 'butter', 'salt', 'meat', 'sugar', 'flour', 'nuts', 'backing'],
    ['bread', 'butter', 'wine', 'cookies', 'fruit'],
    ['bread', 'wine', 'milk', 'butter', 'newspaper', 'yoghurt'],
    ['bread', 'newspaper', 'wine', 'milk', 'newspaper'],
    ['wine', 'cracker', 'bread', 'meat', 'chocolate', 'newspaper'],
    ['wine', 'cracker', 'salt', 'fish', 'meat', 'butter', 'milk', 'chocolate'],
    ['wine', 'sugar', 'flour', 'baking powder', 'milk', 'butter'],
    ['newspaper', 'beer', 'wine', 'bread']];
  FCut := TAprioriProvider.Create(DemoData);
end;

procedure TTestAprioriImplProvider.TearDown;
begin
  FCut := nil;
end;

procedure TTestAprioriImplProvider.Test_HasNoMemoryLeaks;
begin
  Assert.IsNotNull(FCut);
end;

procedure TTestAprioriImplProvider.Test_HasC1;
begin
  Assert.AreEqual(19, Length(FCut.C1));
  Assert.AreEqual(19, Length(FCut.C1));
end;

procedure TTestAprioriImplProvider.Test_HasLNWitoutParam;
var
  Actual: TArray<TItemSets>;
begin
  Actual := FCut
    .MinimumSupport(50.00)
    .MinimumConfidence(50.00)
    .LN;
  Assert.AreEqual(1, Length(Actual));
end;

initialization
  TDUnitX.RegisterTestFixture(TTestAprioriImplProvider, 'AlgoProvider');

end.
