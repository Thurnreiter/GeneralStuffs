unit Apriori.TransationConverter;

interface

uses
  System.Generics.Collections,
  System.SysUtils;

{M+}

type
  /// <summary>Convert an data to the format of TArray<TArray<string>> for Apriori.</summary>
  IAprioriTransationConverter = interface
    ['{498AB89C-35DE-4220-9302-4D4B69F55413}']
    /// <summary>The property "Splitter", offers the possibility to specify a function that defines the split criterion.</summary>
    /// <param name="AValue">Delegate to function(x: string): TArray<string>.</param>
    /// <returns>Returns itself.</returns>
    function Splitter(): TFunc<string, TArray<string>>; overload;
    function Splitter(AValue: TFunc<string, TArray<string>>): IAprioriTransationConverter; overload;

    function Enumerator(): TEnumerator<string>; overload;
    function Enumerator(AValue: TEnumerator<string>): IAprioriTransationConverter; overload;

    /// <summary>The property "Filter", filter any lines of data.</summary>
    /// <param name="AValue">Delegate to function(x: TArray<string>): Boolean.</param>
    /// <returns>Returns itself.</returns>
    function Filter(): TFunc<TArray<string>, Boolean>; overload;
    function Filter(AValue: TFunc<TArray<string>, Boolean>): IAprioriTransationConverter; overload;

    /// <summary>With the property "Rules", it is possible to define own rules for data.</summary>
    /// <param name="AValue">Delegate to function(x: TArray<string>): TArray<string>.</param>
    /// <returns>Returns itself.</returns>
    function Rules(): TFunc<TArray<string>, TArray<string>>; overload;
    function Rules(AValue: TFunc<TArray<string>, TArray<string>>): IAprioriTransationConverter; overload;

    function GroupBy(): TFunc<TArray<string>, string>; overload;
    function GroupBy(AValue: TFunc<TArray<string>, string>): IAprioriTransationConverter; overload;

    /// <summary>Give us the coresponding array for the algorithm.</summary>
    /// <returns>Returns TArray<TArray<string>>.</returns>
    function Execute(): TArray<TArray<string>>;
  end;


  /// <returns>Implementation of Interface <c>IAprioriTransationConverter</c> function.</returns>
  /// <summary>
  ///   Look at: <see cref="Apriori.TransationConverter|IAprioriTransationConverter">IAprioriTransationConverter</see>
  /// <summary>
  TAprioriTransationConverter = class(TInterfacedObject, IAprioriTransationConverter)
  strict private
    FSplitter: TFunc<string, TArray<string>>;
    FEnumerator: TEnumerator<string>;
    FFilter: TFunc<TArray<string>, Boolean>;
    FRules: TFunc<TArray<string>, TArray<string>>;
    FGroupBy: TFunc<TArray<string>, string>;
  public
    constructor Create();
    destructor Destroy(); override;

    function Splitter(): TFunc<string, TArray<string>>; overload;
    function Splitter(AValue: TFunc<string, TArray<string>>): IAprioriTransationConverter; overload;

    function Enumerator(): TEnumerator<string>; overload;
    function Enumerator(AValue: TEnumerator<string>): IAprioriTransationConverter; overload;

    function Filter(): TFunc<TArray<string>, Boolean>; overload;
    function Filter(AValue: TFunc<TArray<string>, Boolean>): IAprioriTransationConverter; overload;

    function Rules(): TFunc<TArray<string>, TArray<string>>; overload;
    function Rules(AValue: TFunc<TArray<string>, TArray<string>>): IAprioriTransationConverter; overload;

    function GroupBy(): TFunc<TArray<string>, string>; overload;
    function GroupBy(AValue: TFunc<TArray<string>, string>): IAprioriTransationConverter; overload;

    function Execute(): TArray<TArray<string>>;
  end;

{M-}

implementation

uses
  System.Classes,
  Nathan.TArrayHelper;

{ TAprioriTransationConverter }

constructor TAprioriTransationConverter.Create();
begin
  inherited Create;
  FEnumerator := nil;
  FFilter :=
    function(x: TArray<string>): Boolean
    begin
      Result := True;
    end;

  FSplitter :=
    function(x: string): TArray<string>
    begin
      Result := x.Split([';', ',', #9]);
    end;

  FRules :=
    function(x: TArray<string>): TArray<string>
    begin
      Result := x;
    end;
end;

destructor TAprioriTransationConverter.Destroy;
begin
  if Assigned(FEnumerator) then
    FEnumerator.Free;

  FSplitter := nil;
  FFilter := nil;
  FRules := nil;
  inherited;
end;

function TAprioriTransationConverter.Enumerator: TEnumerator<string>;
begin
  Result := FEnumerator;
end;

function TAprioriTransationConverter.Enumerator(AValue: TEnumerator<string>): IAprioriTransationConverter;
begin
  FEnumerator := AValue;
  Result := Self;
end;

function TAprioriTransationConverter.Splitter: TFunc<string, TArray<string>>;
begin
  Result := FSplitter;
end;

function TAprioriTransationConverter.Splitter(AValue: TFunc<string, TArray<string>>): IAprioriTransationConverter;
begin
  FSplitter := AValue;
  Result := Self;
end;

function TAprioriTransationConverter.Filter: TFunc<TArray<string>, Boolean>;
begin
  Result := FFilter;
end;

function TAprioriTransationConverter.Filter(AValue: TFunc<TArray<string>, Boolean>): IAprioriTransationConverter;
begin
  FFilter := AValue;
  Result := Self;
end;

function TAprioriTransationConverter.Rules: TFunc<TArray<string>, TArray<string>>;
begin
  Result := FRules;
end;

function TAprioriTransationConverter.Rules(AValue: TFunc<TArray<string>, TArray<string>>): IAprioriTransationConverter;
begin
  FRules := AValue;
  Result := Self;
end;

function TAprioriTransationConverter.GroupBy: TFunc<TArray<string>, string>;
begin
  Result := FGroupBy;
end;

function TAprioriTransationConverter.GroupBy(AValue: TFunc<TArray<string>, string>): IAprioriTransationConverter;
begin
  FGroupBy := AValue;
  Result := Self;
end;

function TAprioriTransationConverter.Execute: TArray<TArray<string>>;
var
  Return: TArray<TArray<string>>;
  Action: TProc<string>;
  InnerGroupBy: string;
  Grouped: TArray<string>;
begin
  Return := [];
  Grouped := [];
  InnerGroupBy := string.Empty;
  Action :=
    procedure(AData: string)
    var
      Each: TArray<string>;
    begin
      Each := FSplitter(AData);
      if FFilter(Each) then
        if Assigned(FGroupBy) then
        begin
          if ((not InnerGroupBy.IsEmpty) and (InnerGroupBy <> FGroupBy(Each))) then
          begin
            TArray.Add<TArray<string>>(Return, Grouped);
            Grouped := FRules(Each);
          end
          else
            Grouped := Grouped + FRules(Each);

          InnerGroupBy := FGroupBy(Each);
        end
        else
          TArray.Add<TArray<string>>(Return, FRules(Each))
    end;

  Action(FEnumerator.Current);
  while FEnumerator.MoveNext do
    Action(FEnumerator.Current);

  if Assigned(FGroupBy) and (Length(Grouped) > 0) then
    TArray.Add<TArray<string>>(Return, Grouped);

  Result := Return;
end;

end.
