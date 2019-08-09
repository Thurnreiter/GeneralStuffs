unit Test.Permutation;

interface

uses
  DUnitX.TestFramework;

type
  [TestFixture]
  TTestPermutation = class(TObject)
  public
    [Test]
    procedure Test1;

    [Test]
    [TestCase('nCr001','10,3,120')]
    [TestCase('nCr002','4,2,6')]
    [TestCase('nCr003','6,6,1')]
    [TestCase('nCr005','6,2,15')]
    [TestCase('nCr006','49,6,2053351')]
    [TestCase('nCr007','2,8,-1')]
    procedure Test_nCr_KombinationOhneWiederholung(const ATotalValue, ASubset, AReturn: Integer);

    [Test]
    [TestCase('nPr001','10,3,720')]
    [TestCase('nPr002','4,2,12')]
    [TestCase('nPr003','6,6,720')]
    [TestCase('nPr005','6,2,30')]
    [TestCase('nPr006','49,6,10068347520')]
    [TestCase('nPr007','2,8,0')]
    procedure Test_nPr_VariationOhneWiederholung(const ATotalValue, ASubset, AReturn: Integer);
  end;

implementation

uses
  Nathan.Permutation;

procedure TTestPermutation.Test1;
begin
end;

procedure TTestPermutation.Test_nCr_KombinationOhneWiederholung(const ATotalValue, ASubset, AReturn: Integer);
var
  Actual: Integer;
begin
  Actual := Permutations.nCr(ATotalValue, ASubset);
  Assert.AreEqual(AReturn, Actual);
end;

procedure TTestPermutation.Test_nPr_VariationOhneWiederholung(const ATotalValue, ASubset, AReturn: Integer);
var
  Actual: Integer;
begin
  Actual := Permutations.nPr(ATotalValue, ASubset);
  Assert.AreEqual(AReturn, Actual);
end;

initialization
  TDUnitX.RegisterTestFixture(TTestPermutation);

end.
