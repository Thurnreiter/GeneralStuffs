program AprioriAlgorithm;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  System.Generics.Collections,
  System.Generics.Defaults,
  Test.Data in 'Test.Data.pas',
  Nathan.TArrayHelper in '..\..\..\..\Thurnreiter.Lib\Nathan.TArrayHelper.pas',
  Nathan.Permutation in '..\..\PermutationsAndCombinations\Nathan.Permutation.pas',
  Apriori.Algo in '..\Apriori.Algo.pas';

//  https://de.wikipedia.org/wiki/Apriori-Algorithmus
  //  Sample Data:
  //    https://github.com/MrPatel95/Apriori-Algorithm/blob/master/food.txt
  //    https://www.kaggle.com/sulmansarwar/transactions-from-a-bakery
  //  Online Check:
  //    http://codeding.com/?article=13
  //  Coding stuff:
  //    https://www.geeksforgeeks.org/apriori-algorithm/
  //    https://www.heise.de/developer/artikel/Data-Science-Warenkorbanalyse-in-30-Minuten-4425737.html?view=print
  //    https://github.com/SohaibAjmal/DataMining-Project-CSharp/blob/master/Apriori/Apriori/Apriori.cs
  //    https://github.com/lagripe/Association-rules-algorithms/blob/master/Apriori-FP_Growth/Program.cs
  //    https://www.hackerearth.com/blog/developers/beginners-tutorial-apriori-algorithm-data-mining-r-implementation/
  //    https://www.digitalvidya.com/blog/apriori-algorithms-in-data-mining/
  //    https://annalyzin.wordpress.com/2016/04/01/association-rules-and-the-apriori-algorithm/
  //    https://stackabuse.com/association-rule-mining-via-apriori-algorithm-in-python/
  //  Examples:
  //    http://p-nand-q.com/business/4/apriori.html

var
  Idx: Integer;
  Idx2: Integer;
  //  Apriori: TMarketBasketAnalysis;
  Apriori: TApriori;
  TestData: TArray<TTestData>;
  MyData: TArray<TArray<string>>;
  ListC1: TArray<TApriori.TItemSet>;
  ListL1: TArray<TApriori.TItemSet>;
  ListCN: TArray<TApriori.TItemSets>;
  Min_Sup: Integer;
begin
  ReportMemoryLeaksOnShutdown := True;
  TestData := TArray<TTestData>
    .Create(
      TTestData.Create('Kunde 1', ['Brot', 'Milch', 'Butter']),
      TTestData.Create('Kunde 2', ['Brot', 'Zucker', 'Milch']),
      TTestData.Create('Kunde 3', ['Brot', 'Milch', 'Butter', 'Mehl']),
      TTestData.Create('Kunde 4', ['Zucker', 'Sahne']));

  Writeln(TPermutationsAndCombinations.nPr(10, 3) .ToString);  //  720
  Writeln(TPermutationsAndCombinations.nCr(10, 3).ToString);  //  120


  MyData := [['Brot', 'Milch', 'Butter'], ['Brot', 'Zucker', 'Milch'], ['Brot', 'Milch', 'Butter', 'Mehl'], ['Zucker', 'Sahne']];
  MyData := [['A', 'B', 'C'], ['A', 'B', 'D'], ['A', 'B', 'C', 'D'], ['B', 'D']];

  Apriori := TApriori.Create(MyData);
  try
    ListC1 := Apriori.GetC1Support();
    Writeln('Support Count Average = ' + Apriori.GetAverage(ListC1).ToString);

    WriteLn('--------C1----------');
    for Idx := Low(ListC1) to High(ListC1) do
      Writeln(Format('%8.8s - %s', [ListC1[Idx].Item, ListC1[Idx].Support.ToString]));

    Min_Sup := 2;
    Write('Enter a minimum support = (Sample ' + Min_Sup.ToString + '): ');
//    Readln(Min_Sup);
    Apriori.SetMinimumSupport(Min_Sup);

    WriteLn('--------L1----------');
    ListL1 := Apriori.GetLN(ListC1);
    for Idx := Low(ListL1) to High(ListL1) do
      Writeln(Format('%8.8s - %s', [ListL1[Idx].Item, ListL1[Idx].Support.ToString]));

    WriteLn('--------CN----------');
    ListCN := Apriori.GetNextCandidates(ListC1, 2);
    for Idx := Low(ListCN) to High(ListCN) do
    begin
      for Idx2 := Low(ListCN[Idx].Items) to High(ListCN[Idx].Items) do
        Write(Format('%3.3s,', [ListCN[Idx].Items[Idx2].Item]));

      Writeln(Format(' : %s', [ListCN[Idx].Support.ToString]));
    end;

    WriteLn('--------CN----------');
    ListCN := Apriori.GetNextCandidates(ListC1, 3);
    for Idx := Low(ListCN) to High(ListCN) do
    begin
      for Idx2 := Low(ListCN[Idx].Items) to High(ListCN[Idx].Items) do
        Write(Format('%3.3s,', [ListCN[Idx].Items[Idx2].Item]));

      Writeln(Format(': %s', [ListCN[Idx].Support.ToString]));
    end;
  finally
    Apriori.Free;
  end;

  Writeln('');
  Writeln('Press any key to continue...');
  ReadLn;
end.
