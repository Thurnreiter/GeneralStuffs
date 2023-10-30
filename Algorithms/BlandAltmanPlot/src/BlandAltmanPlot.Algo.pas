unit BlandAltmanPlot.Algo;

interface

uses
  System.SysUtils;

type
  ListOfSequences = TArray<TArray<Double>>;  // Init = [[1.1, 2.2], [3.3, 4.5]]

  TItemSet = record
    Rater1: Double;
    Rater2: Double;
    Difference: Double;
    Average: Double;
  end;

  IBlandAltmanPlot = interface(IInvokable)
    ['{3CA5EE18-444B-4174-AD6B-B623D2DC9A10}']
    function RaterSeries(Value: TArray<TArray<Double>>): IBlandAltmanPlot; overload;
    function RaterSeries(): TArray<TArray<Double>>; overload;

    function ConfidenceInterval(Value: Double): IBlandAltmanPlot; overload;
    function ConfidenceInterval(): Double; overload;

    function GetResults(): TArray<TItemSet>;
    function GetBias(): Double;
    function GetStandardDeviation(): Double;
    function GetUpperBound(): Double;
    function GetLowerBound(): Double;

    procedure Calc();

    procedure ExportToCSV();
  end;

  TBlandAltmanPlot = class(TInterfacedObject, IBlandAltmanPlot)
  strict private
    FData: TArray<TItemSet>;
    FBias: Double;
    FConfidenceInterval: Double;
    FRaterSeries: TArray<TArray<Double>>;
  private
    procedure CalcDifferencesAndAverage();
  public
    constructor Create();
    destructor Destroy; override;

    function RaterSeries(Value: TArray<TArray<Double>>): IBlandAltmanPlot; overload;
    function RaterSeries(): TArray<TArray<Double>>; overload;

    function ConfidenceInterval(Value: Double): IBlandAltmanPlot; overload;
    function ConfidenceInterval(): Double; overload;

    function GetResults(): TArray<TItemSet>;
    function GetBias(): Double;
    function GetStandardDeviation(): Double;
    function GetUpperBound(): Double;   //  Upper limits of agreement
    function GetLowerBound(): Double;   //  Lower limits of agreement

    procedure Calc();

    procedure ExportToCSV();
  end;

implementation

uses
  System.Types,
  System.Classes,
  System.Math,
  System.IOUtils;

{ TBlandAltmanPlot }

constructor TBlandAltmanPlot.Create;
begin
  inherited Create();
  FBias := 0.0;
  FConfidenceInterval := 1.96; //  Here my default are 95%
end;

destructor TBlandAltmanPlot.Destroy;
begin
//
  inherited;
end;

function TBlandAltmanPlot.RaterSeries(Value: TArray<TArray<Double>>): IBlandAltmanPlot;
begin
  FRaterSeries := Value;
  Result := Self;
end;

function TBlandAltmanPlot.RaterSeries: TArray<TArray<Double>>;
begin
  Result := FRaterSeries;
end;

procedure TBlandAltmanPlot.CalcDifferencesAndAverage;
begin
  SetLength(FData, Length(FRaterSeries));
  for var Idx1 := Low(FRaterSeries) to High(FRaterSeries) do
  begin
    for var Idx2 := Low(FRaterSeries[Idx1]) to High(FRaterSeries[Idx1]) do
    begin
      FData[Idx1].Rater1 := FRaterSeries[Idx1][0];
      FData[Idx1].Rater2 := FRaterSeries[Idx1][1];

      FData[Idx1].Difference := (FData[Idx1].Rater1 - FData[Idx1].Rater2);
      FData[Idx1].Average := ((FData[Idx1].Rater1 + FData[Idx1].Rater2) / 2);
    end;
  end;
end;

function TBlandAltmanPlot.ConfidenceInterval(Value: Double): IBlandAltmanPlot;
begin
  FConfidenceInterval := Value;
  Result := Self;
end;

function TBlandAltmanPlot.ConfidenceInterval: Double;
begin
  Result := FConfidenceInterval;
end;

function TBlandAltmanPlot.GetBias: Double;
begin
  if (FBias <> 0.0) then
  begin
    Exit(FBias);
  end;

  for var Item: TItemSet in FData do
  begin
    FBias := (FBias + Item.Difference);
  end;

  FBias := (FBias / Length(FData));
  Result := FBias;
end;

function TBlandAltmanPlot.GetResults: TArray<TItemSet>;
begin
  Result := FData;
end;

function TBlandAltmanPlot.GetStandardDeviation: Double;
var
  InnerData: TArray<Double>;
  Mean, StdDev: Double;
begin
  SetLength(InnerData, Length(FData));

  for var Idx := Low(FData) to High(FData) do
  begin
    InnerData[Idx] := FData[Idx].Difference;
  end;

  System.Math.MeanAndStdDev(InnerData, Mean, StdDev);
  Result := StdDev; //  Result := 1.25;
end;

function TBlandAltmanPlot.GetUpperBound: Double;
begin
  if (FBias = 0.0) then
     GetBias();

  Result := (FBias + FConfidenceInterval * GetStandardDeviation);
end;

function TBlandAltmanPlot.GetLowerBound: Double;
begin
  if (FBias = 0.0) then
     GetBias();

  Result := (FBias - FConfidenceInterval * GetStandardDeviation);
end;

procedure TBlandAltmanPlot.Calc;
begin
  if (High(FRaterSeries) = -1) then
    Exception.Create('No Rater series found. Please specify 2.');

  CalcDifferencesAndAverage;
end;

procedure TBlandAltmanPlot.ExportToCSV;
var
  OutData: string;
begin
  OutData := 'Rater1;Rater2;Difference;Average' + sLineBreak;
  for var Item: TItemSet in FData do
  begin
    OutData := OutData
      + Item.Rater1.ToString + ';'
      + Item.Rater2.ToString + ';'
      + Item.Difference.ToString + ';'
      + Item.Average.ToString + ';'
      + sLineBreak;
  end;

  OutData := OutData
    + sLineBreak
    + 'BIAS;' + FBias.ToString
    + sLineBreak
    + 'Upper limits of agreement;' + GetUpperBound.ToString
    + sLineBreak
    + 'Lower limits of agreement;' + GetLowerBound.ToString;

  TFile.WriteAllText(TPath.Combine(TPath.GetLibraryPath(), 'Data.csv'), OutData);
end;

end.
