unit Ini.Config.Handler.Json;

interface

uses
  Ini.Config;

{$M+}

type
  TJsonSettingHandler = class(TSettingHandler)
  private
    FFilename: string;
  public
    constructor Create(const AFilename: string);

    function ReadString(const ASection, AKey, ADefaultValue: string): string; override;
    procedure WriteString(const ASection, AKey, AValue: string); override;
  end;

{$M-*}

implementation

 uses
  System.Classes,
  System.SysUtils,
  System.IOUtils,

  System.JSON,
  System.JSON.Types,
  System.JSON.Builders,
  System.JSON.Writers,
  System.JSON.Readers;

{ **************************************************************************** }

{ TJsonSettingHandler }

constructor TJsonSettingHandler.Create(const AFilename: string);
begin
  inherited Create;
  FFilename := AFilename;
end;

function TJsonSettingHandler.ReadString(const ASection, AKey, ADefaultValue: string): string;
var
  LJsonString: string;
  LStringReader: TStringReader;
  LJsonReader: TJsonTextReader;
begin
  inherited;

  if TFile.Exists(FFilename) then
    LJsonString := TFile.ReadAllText(FFilename);

  //  http://docwiki.embarcadero.com/RADStudio/Tokyo/de/JSON
  //  http://docwiki.embarcadero.com/CodeExamples/Tokyo/en/RTL.JSONReader
  //  LStringReader := TStringReader.Create('{"colors":[{"name":"red", "hex":"#f00"}]}');
  Result := '';
  LStringReader := TStringReader.Create(LJsonString);
  try
    LJsonReader := TJsonTextReader.Create(LStringReader);
    try
      while LJsonReader.Read do
      begin
        if (not ((ASection + '[0].' + AKey).ToLower = LJsonReader.Path.ToLower)) then
          Continue;

        if (LJsonReader.TokenType <> TJsonToken.PropertyName) then
        begin
          Result := LJsonReader.Value.ToString;
          Break;
        end;
      end;
    finally
      LJsonReader.Free;
    end;
  finally
    LStringReader.Free;
  end;

  if Result.IsEmpty then
    Result := ADefaultValue;
end;

procedure TJsonSettingHandler.WriteString(const ASection, AKey, AValue: string);
var
  LJsonWriter: TJsonTextWriter;
  LJsonBuilder: TJSONObjectBuilder;
  LStringWriter: TStringWriter;
begin
  inherited;
  LStringWriter := TStringWriter.Create();
  LJsonWriter := TJsonTextWriter.Create(LStringWriter);
  LJsonWriter.Formatting := TJsonFormatting.None;      //  All collapsed...
  LJsonBuilder := TJSONObjectBuilder.Create(LJsonWriter);
  try
    LJsonBuilder
      .BeginObject
        .BeginArray(ASection)
          .BeginObject
            .Add(AKey, AValue)
          .EndObject
      .EndArray
    .EndObject;

    if TFile.Exists(FFilename) then
      TFile.WriteAllText(FFilename, LStringWriter.ToString);
  finally
    LJsonWriter.Free();
    LJsonBuilder.Free();
    LStringWriter.Free();
  end;
end;

end.
