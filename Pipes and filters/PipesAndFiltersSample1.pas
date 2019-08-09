unit PipesAndFiltersSample1;

interface

uses
  System.Classes,
  System.SysUtils,
  System.Generics.Collections,
  System.Generics.Defaults;

{$M+}

type
  {$REGION 'Interfaces'}
  IBaseFilter<T> = interface
    ['{ED5750F6-4235-491E-974D-D139199DAB19}']
    function Execute(Input: T): T;
  end;


  IBasePipe<T> = interface
    ['{3A179968-38BD-4221-A251-C8878CFA22F7}']
    function &Register(Filter: IBaseFilter<T>): IBasePipe<T>;
    function Process(Input: T): T;
  end;
  {$ENDREGION}


  {$REGION 'Implemtnation Pipe'}
  TBasePipe<T> = class(TInterfacedObject, IBasePipe<T>)
  strict private
    FList: TList<IBaseFilter<T>>;
  public
    constructor Create;
    destructor Destroy; override;

    function &Register(Filter: IBaseFilter<T>): IBasePipe<T>;
    function Process(Input: T): T;
  end;
  {$ENDREGION}


  {$REGION 'Implementation Filter'}
  TBaseFilter<T> = class(TInterfacedObject, IBaseFilter<T>)
  public
    function Execute(Input: T): T; virtual; abstract;
  end;

  TStringUpperFilter = class(TBaseFilter<string>)
  public
    function Execute(Input: string): string; override;
  end;

  TStringLowerFilter = class(TBaseFilter<string>)
  public
    function Execute(Input: string): string; override;
  end;

  TStringDotsFilter = class(TBaseFilter<string>)
  public
    function Execute(Input: string): string; override;
  end;

  TStringAddEndFilter = class(TBaseFilter<string>)
  strict private
    FAddEnd: string;
  public
    constructor Create(const AddEnd: string);

    function Execute(Input: string): string; override;
  end;

  TStringAddBeginFilter = class(TBaseFilter<string>)
  strict private
    FAddBegin: string;
  public
    constructor Create(const AddBegin: string);

    function Execute(Input: string): string; override;
  end;
  {$ENDREGION}

{$M-}

implementation

{ **************************************************************************** }

{ TBasePipeline<T> }

constructor TBasePipe<T>.Create;
begin
  inherited;
  FList := TList<IBaseFilter<T>>.Create;
end;

destructor TBasePipe<T>.Destroy;
begin
  FList.Free;
  inherited;
end;

function TBasePipe<T>.Process(Input: T): T;
var
  Each: IBaseFilter<T>;
begin
  for Each in FList do
    Input := Each.Execute(Input);

  Result := Input;
end;

function TBasePipe<T>.&Register(Filter: IBaseFilter<T>): IBasePipe<T>;
begin
  FList.Add(Filter);
  Result := Self;
end;

{ **************************************************************************** }

{ TStringUpperFilter }

function TStringUpperFilter.Execute(Input: string): string;
begin
  Result := Input.ToUpper;
end;

{ **************************************************************************** }

{ TStringLowerFilter }

function TStringLowerFilter.Execute(Input: string): string;
begin
  Result := Input.ToLower;
end;

{ **************************************************************************** }

{ TStringDotsFilter }

function TStringDotsFilter.Execute(Input: string): string;
begin
  Result := Input.Replace('.', '');
end;

{ **************************************************************************** }

{ TStringAddEndFilter }

constructor TStringAddEndFilter.Create(const AddEnd: string);
begin
  inherited Create();
  FAddEnd := AddEnd;
end;

function TStringAddEndFilter.Execute(Input: string): string;
begin
  Result := Input + FAddEnd;
end;

{ **************************************************************************** }

{ TStringAddBeginFilter }

constructor TStringAddBeginFilter.Create(const AddBegin: string);
begin
  inherited Create;
  FAddBegin := AddBegin;
end;

function TStringAddBeginFilter.Execute(Input: string): string;
begin
  Result := FAddBegin + Input;
end;

end.
