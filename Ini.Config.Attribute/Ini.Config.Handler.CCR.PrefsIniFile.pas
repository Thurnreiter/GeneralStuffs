unit Ini.Config.Handler.CCR.PrefsIniFile;

interface

uses
  System.IniFiles,
  CCR.PrefsIniFile,
  Ini.Config;

{$M+}

type
  TCCRSettingHandler = class(TSettingHandler)
  private
    FIniFile: TCustomIniFile;
  public
    constructor Create();
    destructor Destroy; override;

    function ReadString(const ASection, AKey, ADefaultValue: string): string; override;
    procedure WriteString(const ASection, AKey, AValue: string); override;
  end;

{$M-*}

implementation

 uses
  System.Classes,
  System.SysUtils,
  System.IOUtils;

{ **************************************************************************** }

{ TCCRSettingHandler }

constructor TCCRSettingHandler.Create();
begin
  inherited Create;
  {$IFDEF MSWINDOWS}
    FIniFile := CreateUserPreferencesIniFile(TWinLocation.IniFile);
  {$ELSE}
    FIniFile := CreateUserPreferencesIniFile;
  {$ENDIF}
end;

destructor TCCRSettingHandler.Destroy;
begin
  FIniFile.Free;
  inherited;
end;

function TCCRSettingHandler.ReadString(const ASection, AKey, ADefaultValue: string): string;
begin
  inherited;
  Result := FIniFile.ReadString(ASection, AKey, ADefaultValue)
end;

procedure TCCRSettingHandler.WriteString(const ASection, AKey, AValue: string);
begin
  inherited;
  FIniFile.WriteString(ASection, AKey, AValue);
  FIniFile.UpdateFile;
end;

end.
