unit Apriori.TransationConverter.Enumerators;

interface

uses
  System.Generics.Collections,
  System.Classes;

{M+}

type
  TStringEnumerator = class(TEnumerator<string>)
  private
    FIndex: Integer;
    FInput: TArray<string>; //  TFile...
  protected
    function DoGetCurrent: string; override;
    function DoMoveNext(): Boolean; override;
  public
    constructor Create(const AInput: string); overload;
  end;

  TStringFileEnumerator = class(TEnumerator<string>)
  private
    FCurrent: string;
    FFileStream: TStreamReader;
    function DoGetCurrent: string; override;
    function DoMoveNext(): Boolean; override;
  public
    constructor Create(const AFilename: string); overload;
    destructor Destroy; override;
  end;

{M-}

implementation

uses
  System.SysUtils,
  System.IOUtils;

{ **************************************************************************** }

{ TStringEnumerator }

constructor TStringEnumerator.Create(const AInput: string);
begin
  inherited Create;
  FInput := AInput.Split([sLineBreak]);
  FIndex := 0;
end;

function TStringEnumerator.DoGetCurrent: string;
begin
  Result := FInput[FIndex];
end;

function TStringEnumerator.DoMoveNext: Boolean;
begin
  Inc(FIndex);
  Result := FIndex < Length(FInput);
end;

{ **************************************************************************** }

{ TStringFileEnumerator }

constructor TStringFileEnumerator.Create(const AFilename: string);
begin
  inherited Create;
  FFileStream := TFile.OpenText(AFilename);
end;

destructor TStringFileEnumerator.Destroy;
begin
  FFileStream.Free;
  inherited;
end;

function TStringFileEnumerator.DoGetCurrent: string;
begin
  Result := FCurrent;
end;

function TStringFileEnumerator.DoMoveNext: Boolean;
begin
  Result := (not FFileStream.EndOfStream);
  if Result then
    FCurrent := FFileStream.ReadLine;
end;

end.
