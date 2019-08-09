unit Apriori.Provider;

interface

uses
  Apriori.Algo,
  Apriori.Items;

{M+}

type
  IAprioriProvider = interface
    ['{4CC95F22-7F77-4094-8209-3FECB769AA20}']
    function MinimumSupport(AValue: Double): IAprioriProvider; overload;
    function MinimumSupport(): Double; overload;

    function MinimumConfidence(AValue: Double): IAprioriProvider; overload;
    function MinimumConfidence(): Double; overload;

    function Apriori(): IApriori;

    function C1(): TArray<TItemSet>;

    function LN(): TArray<TItemSets>; overload;
    function LN(AC1: TArray<TItemSet>): TArray<TItemSets>; overload;
  end;

  TAprioriProvider = class(TInterfacedObject, IAprioriProvider)
  strict private
    FApriori: IApriori;
    FC1: TArray<TItemSet>;
  public
    constructor Create(AData: TArray<TArray<string>>);
    destructor Destroy; override;

    function MinimumSupport(AValue: Double): IAprioriProvider; overload;
    function MinimumSupport(): Double; overload;

    function MinimumConfidence(AValue: Double): IAprioriProvider; overload;
    function MinimumConfidence(): Double; overload;

    function Apriori(): IApriori;

    function C1(): TArray<TItemSet>;

    function LN(): TArray<TItemSets>; overload;
    function LN(AC1: TArray<TItemSet>): TArray<TItemSets>; overload;
  end;

{M-}

implementation

{ TAprioriProvider }

constructor TAprioriProvider.Create(AData: TArray<TArray<string>>);
begin
  inherited Create;
  FC1 := Default(TArray<TItemSet>);
  FApriori := TApriori.Create(AData);
end;

destructor TAprioriProvider.Destroy;
begin
  FApriori := nil;
  inherited;
end;

function TAprioriProvider.MinimumSupport(AValue: Double): IAprioriProvider;
begin
  FApriori.MinimumSupport(AValue);
  Result := Self;
end;

function TAprioriProvider.MinimumSupport: Double;
begin
  Result := FApriori.MinimumSupport;
end;

function TAprioriProvider.MinimumConfidence(AValue: Double): IAprioriProvider;
begin
  FApriori.MinimumConfidence(AValue);
  Result := Self;
end;

function TAprioriProvider.MinimumConfidence: Double;
begin
  Result := FApriori.MinimumConfidence;
end;

function TAprioriProvider.Apriori: IApriori;
begin
  Result := FApriori;
end;

function TAprioriProvider.C1: TArray<TItemSet>;
begin
  if (FC1 = Default(TArray<TItemSet>)) then
    FC1 := FApriori.GetC1Support;

  Result := FC1;
end;

function TAprioriProvider.LN: TArray<TItemSets>;
begin
  Result := LN(C1);
end;

function TAprioriProvider.LN(AC1: TArray<TItemSet>): TArray<TItemSets>;
var
  Level: Integer;
  Return: TArray<TItemSets>;
begin
  Level := 2;
  Return := FApriori.GetNextCandidates(AC1, Level);
  while (Length(Return) > 0) and (Level <= High(AC1)) do
  begin
    Return := FApriori.GetNextCandidates(AC1, Level);
    Return := FApriori.GetLN(Return);
    Inc(Level);
  end;

  Result := FApriori.GetNextCandidates(AC1, (Level - 2));
  Result := FApriori.GetLN(Result);
end;

end.
