unit PipesAndFiltersSample2;

interface

uses
  System.Classes,
  System.SysUtils,
  System.Generics.Collections,
  System.Generics.Defaults;

{$M+}

type
  {$REGION 'Interfaces'}
  IPipesAndFilters<T> = interface
    ['{4FD6FAC6-692C-482C-BA2F-1467A0224978}']
    function GetFilter(): IPipesAndFilters<T>;
    procedure SetFilter(value: IPipesAndFilters<T>);

    function Read(Data: T): T;  //  From data sink to data source...
    procedure Write(Data: T); //  From data source to data sink...

    property Filter: IPipesAndFilters<T> read GetFilter write SetFilter;
  end;

  IPipesAndFiltersSink<T> = interface(IPipesAndFilters<T>)
    ['{219776F2-1892-4B41-A1ED-12B9979CC069}']
    function GetValue(): T;
  end;

  {$ENDREGION}

  TPipesAndFilters<T> = class(TInterfacedObject, IPipesAndFilters<T>)
  strict private
    FPipesAndFiltersChain: IPipesAndFilters<T>;
  private
    function GetFilter(): IPipesAndFilters<T>;
    procedure SetFilter(value: IPipesAndFilters<T>);
  public
    constructor Create(Filter: IPipesAndFilters<T>); overload;
    constructor Create(); overload;

    function Read(Data: T): T; virtual;
    procedure Write(Data: T); virtual;
  end;

  TPipesAndFiltersSource = class(TPipesAndFilters<string>)
  public
    function Read(Data: string): string; override;
    procedure Write(Data: string); override;
  end;

  TPipesAndFiltersUpper = class(TPipesAndFilters<string>)
  public
    function Read(Data: string): string; override;
    procedure Write(Data: string); override;
  end;

  TPipesAndFiltersSink = class(TPipesAndFilters<string>, IPipesAndFiltersSink<string>)
  strict private
    FInnerValue: string;
  public
    function Read(Data: string): string; override;
    procedure Write(Data: string); override;

    function GetValue(): string;
  end;

{$M-}

implementation

{ **************************************************************************** }

{ TPipesAndFilters<T> }

constructor TPipesAndFilters<T>.Create(Filter: IPipesAndFilters<T>);
begin
  inherited Create;
  SetFilter(Filter);
end;

constructor TPipesAndFilters<T>.Create;
begin
  Create(nil);
end;

function TPipesAndFilters<T>.GetFilter: IPipesAndFilters<T>;
begin
  Result := FPipesAndFiltersChain;
end;

procedure TPipesAndFilters<T>.SetFilter(value: IPipesAndFilters<T>);
begin
  FPipesAndFiltersChain := Value;
end;

function TPipesAndFilters<T>.Read(Data: T): T;
begin
  //  Most of scenario 2 (pull pipeline). Start from the end, data sink...
  //  Data sink pull it from filter two, filter tow pull it from filter one and filter one pull data source.
  //  Datatype T read() { return f(filter.read()); }

  if Assigned(FPipesAndFiltersChain) then
    Result := FPipesAndFiltersChain.Read(Data)
  else
    Result := Data
end;

procedure TPipesAndFilters<T>.Write(Data: T);
begin
  //  Most of scenario 1 (push pipeline). Start from data source...
  //  Data source psuh it to filter one, filter one push it to data sink.

  //  Function, do anything with my data and give it to the next filter in chain.
  //  FPipesAndFiltersChain.Write(f(Data));

  if Assigned(FPipesAndFiltersChain) then
    FPipesAndFiltersChain.Write(Data); //  "else" we are the data sink object...
end;

{ **************************************************************************** }

{ TPipesAndFiltersSource }

function TPipesAndFiltersSource.Read(Data: string): string;
begin
  Result := ' 1.Source ' + inherited Read(Data);
end;

procedure TPipesAndFiltersSource.Write(Data: string);
begin
  inherited Write(Data + ' 1.Source ');
end;

{ **************************************************************************** }

{ TPipesAndFiltersUpper }

function TPipesAndFiltersUpper.Read(Data: string): string;
begin
  Result := ' 2.UPPER ' + inherited Read(Data);
end;

procedure TPipesAndFiltersUpper.Write(Data: string);
begin
  inherited Write(Data + ' 2.UPPER ');
end;

{ **************************************************************************** }

{ TPipesAndFiltersSink }

function TPipesAndFiltersSink.GetValue: string;
begin
  Result := FInnerValue;
end;

function TPipesAndFiltersSink.Read(Data: string): string;
begin
  FInnerValue := ' 3.Sink ' + inherited Read(Data);
  Result := FInnerValue;
end;

procedure TPipesAndFiltersSink.Write(Data: string);
begin
  FInnerValue := Data + ' 3.Sink ';
  inherited Write(FInnerValue);
end;

end.
