unit Ini.Config.Handler.IniFiles;

interface

uses
  System.IniFiles,
  Ini.Config;

{$M+}

type
  TIniSettingHandler = class(TSettingHandler)
  private
    FInnerHandler: TIniFile;
  public
    constructor Create(const AFilename: string);
    destructor Destroy; override;

    function ReadString(const ASection, AKey, ADefaultValue: string): string; override;
    procedure WriteString(const ASection, AKey, AValue: string); override;
  end;

{$M-*}

implementation

{ **************************************************************************** }

{ TIniSettingHandler }

constructor TIniSettingHandler.Create(const AFilename: string);
begin
  inherited Create;
  FInnerHandler := TIniFile.Create(AFilename);
end;

destructor TIniSettingHandler.Destroy;
begin
  FInnerHandler.Free;
  inherited;
end;

function TIniSettingHandler.ReadString(const ASection, AKey, ADefaultValue: string): string;
begin
  inherited;
  Result := FInnerHandler.ReadString(ASection, AKey, ADefaultValue);
end;

procedure TIniSettingHandler.WriteString(const ASection, AKey, AValue: string);
begin
  inherited;
  FInnerHandler.WriteString(ASection, AKey, AValue);
end;

end.
