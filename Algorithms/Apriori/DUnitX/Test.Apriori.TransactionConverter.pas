unit Test.Apriori.TransactionConverter;

interface

uses
  System.SysUtils,
  System.Generics.Collections,
  DUnitX.TestFramework,
  Apriori.TransationConverter;

type
  [TestFixture]
  TTestAprioriTransactionConverter = class(TObject)
  strict private
    FCut: IAprioriTransationConverter;
  private const
    Data = 'Col1;Col2;Col3;"Col4;44";Col5' + sLineBreak
      + 'ColA;ColB;ColC;"ColD;DD";ColE' + sLineBreak
      + 'ColZ;ColW;ColX;"ColY;YY";ColQQ';
  public
    [Setup]
    procedure Setup;

    [TearDown]
    procedure TearDown;

    [Test]
    procedure Test_HasNoMemoryLeaks;

    [Test]
    procedure Test_WithOwnSplitter;

    [Test]
    procedure Test_FileEnumerator;

    [Test]
    procedure Test_Execute;

    [Test]
    procedure Test_ExecuteWithFilter;

    [Test]
    procedure Test_ExecuteWithFilterAndRules;

    [Test]
    procedure Test_WithOwnSplitterByCrLfInColumn;

    [Test]
    procedure Test_WithTypicalBasketData;
  end;

implementation

uses
  Apriori.TransationConverter.Enumerators;

{ TTestAprioriTransactionConverter }

procedure TTestAprioriTransactionConverter.Setup;
begin
  FCut := TAprioriTransationConverter.Create;
end;

procedure TTestAprioriTransactionConverter.TearDown;
begin
  FCut := nil;
end;

procedure TTestAprioriTransactionConverter.Test_HasNoMemoryLeaks;
begin
  Assert.IsNotNull(FCut);
end;

procedure TTestAprioriTransactionConverter.Test_WithOwnSplitter;
const
  Line = 'Col1;Col2;Col3;"Col4;44";Col5';
var
  Actual: TArray<string>;
begin
  //  Arrange...
  FCut.Splitter(
    function(x: string): TArray<string>
    begin
      Result := x.Split([';', #9], '"', '"');
    end);

  //  Act...
  Actual := FCut.Splitter()(Line);

  //  Assert...
  Assert.AreEqual(5, Length(Actual));
end;

procedure TTestAprioriTransactionConverter.Test_WithOwnSplitterByCrLfInColumn;
const
  Lines = 'Col1;Col2;Col3;"Col4;44";Col5' + sLineBreak
      + 'ColA;ColB;ColC;"ColD;' + sLineBreak + 'DD";ColE' + sLineBreak
      + 'ColZ;ColW;ColX;"ColY;YY";ColQQ';
var
  Actual: TArray<TArray<string>>;
begin
  Actual := FCut
    .Enumerator(TStringEnumerator.Create(Lines))
    .Splitter(
      function(x: string): TArray<string>
      begin
        Result := x.Split([';'], '"', '"');
      end)
    .Execute;

  Assert.AreEqual(4, Length(Actual));
end;

procedure TTestAprioriTransactionConverter.Test_FileEnumerator;
var
  Enum: TEnumerator<string>;
  Actual: TArray<TArray<string>>;
begin
  Enum := TStringFileEnumerator.Create('..\..\BeachData.csv');

  Actual := FCut
    .Enumerator(Enum)
    .Filter(
      function(x: TArray<string>): Boolean
      begin
        Result := (High(x) > -1);
      end)
    .Execute;

  Assert.AreEqual(20, Length(Actual));
end;

procedure TTestAprioriTransactionConverter.Test_Execute;
var
  Enum: TStringEnumerator;
  Actual: TArray<TArray<string>>;
begin
  Enum := TStringEnumerator.Create(Data);
  FCut.Enumerator(Enum);
  Actual := FCut.Execute;

  Assert.AreEqual(3, Length(Actual));
end;

procedure TTestAprioriTransactionConverter.Test_ExecuteWithFilter;
var
  Enum: TStringEnumerator;
  Actual: TArray<TArray<string>>;
begin
  Enum := TStringEnumerator.Create(Data);
  FCut
    .Enumerator(Enum)
    .Filter(
      function(x: TArray<string>): Boolean
      begin
        Result := (not x[0].Contains('Col1'));
      end);

  Actual := FCut.Execute;

  Assert.AreEqual(2, Length(Actual));
end;

procedure TTestAprioriTransactionConverter.Test_ExecuteWithFilterAndRules;
var
  Actual: TArray<TArray<string>>;
begin
  FCut
    .Enumerator(TStringEnumerator.Create(Data))
    .Filter(
      function(x: TArray<string>): Boolean
      begin
        Result := (not x[0].Contains('Col1'));
      end)
    .Rules(
      function(x: TArray<string>): TArray<string>
      var
        Idx: Integer;
      begin
        for Idx := Low(x) to High(x) do
        begin
          x[Idx] := x[Idx].Replace('Col', 'Column');
        end;
        Result := x;
      end);

  Actual := FCut.Execute;

  Assert.AreEqual(2, Length(Actual));
  Assert.StartsWith('ColumnA', Actual[0][0]);
  Assert.StartsWith('ColumnZ', Actual[1][0]);
end;

procedure TTestAprioriTransactionConverter.Test_WithTypicalBasketData;
const
  BasketData = 'ID;Timestamp;TransactionID;Product' + sLineBreak
      + '1;25.06.2019 14:30;4711;Bread' + sLineBreak
      + '2;25.06.2019 14:30;4711;Salt' + sLineBreak
      + '3;25.06.2019 14:30;4711;Milk' + sLineBreak
      + '4;25.06.2019 14:30;4711;Butter' + sLineBreak
      + '5;25.06.2019 14:30;4711;Jam' + sLineBreak
      + '6;25.06.2019 08:16;4712;Bread' + sLineBreak
      + '7;25.06.2019 08:16;4712;Coffee' + sLineBreak
      + '8;25.06.2019 08:16;4712;Milk';
var
  Actual: TArray<TArray<string>>;
begin
  FCut
    .Enumerator(TStringEnumerator.Create(BasketData))
    .Filter(
      function(x: TArray<string>): Boolean
      begin
        //  Header...
        Result := not (x[0].Contains('ID')
          and x[1].Contains('Timestamp')
          and x[2].Contains('TransactionID')
          and x[3].Contains('Product'));
      end)
    .GroupBy(
      function(x: TArray<string>): string
      begin
        Result := x[2];
      end)
    .Rules(
      function(x: TArray<string>): TArray<string>
      begin
        Result := Result + [x[3]];
      end);

  Actual := FCut.Execute;

  Assert.AreEqual(2, Length(Actual));
  Assert.AreEqual(5, Length(Actual[0]));  //  Products of transaction 4711
  Assert.AreEqual(3, Length(Actual[1]));  //  Products of transaction 4712

  Assert.StartsWith('Bread', Actual[0][0]);
  Assert.StartsWith('Salt', Actual[0][1]);
  Assert.StartsWith('Milk', Actual[0][2]);
  Assert.StartsWith('Butter', Actual[0][3]);
  Assert.StartsWith('Jam', Actual[0][4]);

  Assert.StartsWith('Bread', Actual[1][0]);
  Assert.StartsWith('Coffee', Actual[1][1]);
  Assert.StartsWith('Milk', Actual[1][2]);
end;

initialization
  TDUnitX.RegisterTestFixture(TTestAprioriTransactionConverter, 'Conv');

end.
