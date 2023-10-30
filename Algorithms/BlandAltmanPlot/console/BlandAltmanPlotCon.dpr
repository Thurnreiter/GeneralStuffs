program BlandAltmanPlotCon;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  BlandAltmanPlot.Algo in '..\src\BlandAltmanPlot.Algo.pas';

var
  BlandAltmanPlot: IBlandAltmanPlot;

begin
  try
    //  https://www.youtube.com/watch?v=l6TPfgmooqM

    BlandAltmanPlot := TBlandAltmanPlot.Create;
    BlandAltmanPlot
      .ConfidenceInterval(1.96)   // Measurement series...
      .RaterSeries([
        [105.0, 100.0],
        [155.0, 150.0],
        [85.0, 82.0],
        [120.0, 118.0],
        [190.0, 187.0],
        [140.0, 135.0],
        [110.0, 105.0],
        [95.0, 93.0],
        [180.0, 176.0],
        [165.0, 162.0]
        ])
      .Calc;

    for var Item: TItemSet in BlandAltmanPlot.GetResults do
    begin
      Writeln('Difference: ' + Item.Difference.ToString + '  Average: ' + Item.Average.ToString);
    end;

    Writeln('Bias: ' + BlandAltmanPlot.GetBias.ToString);   // Here must have a value of 3.7
    Writeln('Upper limits of agreement: ' + BlandAltmanPlot.GetUpperBound.ToString);   // Here must have a value of 6.25
    Writeln('Lower limits of agreement: ' + BlandAltmanPlot.GetLowerBound.ToString);   // Here must have a value of 1.25

    BlandAltmanPlot.ExportToCSV;

    Writeln('Press any key to continue...');
    ReadLn;
  except
    on E: Exception do
    begin
      Writeln(E.ClassName, ': ', E.Message);
      ReadLn;
    end;
  end;
end.
