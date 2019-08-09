unit Test.Xml.Worker;

interface

{$M+}

uses
  DUnitX.TestFramework,
  Nathan.UnitDependencyV2.Xml.Worker;

{$I Test.Xml.Worker.inc}

type
  [TestFixture]
  TTestXmlWorker = class
  strict private
    FCut: INathanUDV2XmlWorker;
  public
    [Setup]
    procedure Setup();

    [TearDown]
    procedure TearDown();

    [Test]
    [Ignore('Ignore this test')]
    procedure Test_HasNoMemoryLeaks;

    [Test]
    [TestCase('Xml001', '<?xml version="1.0" encoding="UTF-8"?><unit name="ac"></unit>')]
    [TestCase('Xml002', demo1_symbol_report)]
    procedure Test_XmlProperty(const Value: string);

    [Test]
    [TestCase('Exec001', '0,<?xml version="1.0" encoding="UTF-8"?><unit name="ac"></unit>')]
    [TestCase('Exec002', '2,' + demo1_symbol_report)]
    procedure Test_Execute(Counter: Integer; const Value: string);

    [Test]
    procedure Test_Execute_Filter;

    [Test]
    procedure Test_Execute_DeleteWithFilter;

    [Test]
    procedure Test_Execute_DeleteWithFilterWithoutAnyFind;
  end;

{$M-}

implementation

uses
  System.Generics.Defaults,
  System.Generics.Collections,
  Nathan.UnitDependencyV2.Dtos;

procedure TTestXmlWorker.Setup();
begin
  FCut := TNathanUDV2XmlWorker.Create;
end;

procedure TTestXmlWorker.TearDown();
begin
  FCut := nil;
end;

procedure TTestXmlWorker.Test_HasNoMemoryLeaks;
begin
  //  Assert...
  Assert.IsNotNull(FCut);
end;

procedure TTestXmlWorker.Test_XmlProperty(const Value: string);
begin
  //  Arrange...
  FCut.Xml(Value);

  //  Assert...
  Assert.AreEqual(Value, FCut.Xml);
end;

procedure TTestXmlWorker.Test_Execute(Counter: Integer; const Value: string);
var
  Actual: TNathanUDV2Dto;
begin
  //  Arrange...
  FCut.Xml(Value);

  //  Act...
  Actual := FCut.Execute;

  //  Assert...
  Assert.AreEqual(Counter, Length(Actual.Namespaces));
end;

procedure TTestXmlWorker.Test_Execute_Filter;
var
  FoundIndex: Integer;
  Actual: TNathanUDV2Dto;
begin
  //  Arrange...
  FCut
    .Xml(demo1_symbol_report)
    .Filter(
      function (value: TNathanUDV2Dto): TArray<string>
      begin
        Result := value.Namespaces;
        if (Result[1] = 'SysInit') then
          FoundIndex := 1;
      end);


  //  Act...
  Actual := FCut.Execute;

  //  Assert...
  Assert.AreEqual('System.Math', Actual.Namespaces[0]);
  Assert.AreEqual('SysInit', Actual.Namespaces[High(Actual.Namespaces)]);
  Assert.AreEqual('SysInit', Actual.Namespaces[FoundIndex]);
end;

procedure TTestXmlWorker.Test_Execute_DeleteWithFilter;
var
  Actual: TNathanUDV2Dto;
begin
  //  Arrange...
  FCut
    .Xml(demo1_symbol_report)
    .Filter(
      function (value: TNathanUDV2Dto): TArray<string>
      var
        Idx: Integer;
        Comparer: IComparer<string>;
      begin
        Result := value.Namespaces;
        Comparer := TComparer<string>.Default;
        for Idx := Low(Result) to High(Result) do
          if (Comparer.Compare(Result[Idx], 'SysInit') = 0) then
            Break;

        Delete(Result, Idx, 1);
      end);

  //  Act...
  Actual := FCut.Execute;

  //  Assert...
  Assert.AreEqual('System.Math', Actual.Namespaces[0]);
  Assert.AreEqual(1, Length(Actual.Namespaces));
end;

procedure TTestXmlWorker.Test_Execute_DeleteWithFilterWithoutAnyFind;
var
  Actual: TNathanUDV2Dto;
begin
  //  Arrange...
  FCut
    .Xml(demo1_symbol_report)
    .Filter(
      function (value: TNathanUDV2Dto): TArray<string>
      var
        IdxFind: Integer;
        IdxDelete: Integer;
        Comparer: IComparer<string>;
      begin
        Result := value.Namespaces;
        IdxDelete := -1;
        Comparer := TComparer<string>.Default;
        for IdxFind := Low(Result) to High(Result) do
          if (Comparer.Compare(Result[IdxFind], 'haha') = 0) then
          begin
            IdxDelete := IdxFind;
            Break;
          end;

        if (IdxDelete > -1) then
          Delete(Result, IdxDelete, 1);
      end);

  //  Act...
  Actual := FCut.Execute;

  //  Assert...
  Assert.AreEqual('System.Math', Actual.Namespaces[0]);
  Assert.AreEqual('SysInit', Actual.Namespaces[1]);
  Assert.AreEqual(2, Length(Actual.Namespaces));
end;

initialization
  TDUnitX.RegisterTestFixture(TTestXmlWorker, 'XmlWorker');

end.
