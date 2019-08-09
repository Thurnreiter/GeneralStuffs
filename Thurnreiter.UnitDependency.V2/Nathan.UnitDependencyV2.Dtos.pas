unit Nathan.UnitDependencyV2.Dtos;

interface

uses
  System.JSON.Serializers,
  System.JSON.Converters;

{$M+}

type
  [JsonSerialize(TJsonMemberSerialization.&In)]
  TNathanUDV2Dto = record
  private
    [JsonIn]
    [JsonName('file')]
    FSymbolFilename: string;

    function GetSymbolFilename(): string;
    procedure SetSymbolFilename(const value: string);
  public
    [JsonIn]
    [JsonName('pas')]
	  PossiblyRelevantPasName: string;

    [JsonIn]
    [JsonName('namespaces')]
    Namespaces: TArray<string>;

    function ToJson(): string;

    property SymbolFilename: string read GetSymbolFilename write SetSymbolFilename;
  end;

  TNathanUDV2Dtos = record
    [JsonIn]
    [JsonName('path')]
    Path: string;

    [JsonIn]
    [JsonName('list')]
    List: array of TNathanUDV2Dto;

    function ToJson(): string;
  end;

{$M-}

implementation

uses
  System.IOUtils,
  System.JSON.Types;

{ **************************************************************************** }

{ TNathanUDV2DtoXXX }

function TNathanUDV2Dto.GetSymbolFilename: string;
begin
  Result := FSymbolFilename;
end;

procedure TNathanUDV2Dto.SetSymbolFilename;
begin
  FSymbolFilename := value;
  PossiblyRelevantPasName := TPath.GetFileNameWithoutExtension(FSymbolFilename) + '.pas';
end;

function TNathanUDV2Dto.ToJson: string;
var
  Serializer: TJsonSerializer;
begin
  if (Length(Namespaces) = 0) then
    Exit('');

  PossiblyRelevantPasName := TPath.GetFileNameWithoutExtension(SymbolFilename) + '.pas';
  Serializer := TJsonSerializer.Create;
  try
    Result := Serializer.Serialize<TNathanUDV2Dto>(Self);
  finally
    Serializer.Free;
  end;
end;

{ **************************************************************************** }

{ TNathanUDV2DtosXXX }

function TNathanUDV2Dtos.ToJson: string;
var
  Serializer: TJsonSerializer;
begin
  Serializer := TJsonSerializer.Create;
  try
    Serializer.Formatting := TJsonFormatting.Indented;  //  Line Breaks...
    Result := Serializer.Serialize<TNathanUDV2Dtos>(Self);
  finally
    Serializer.Free;
  end;
end;

end.
