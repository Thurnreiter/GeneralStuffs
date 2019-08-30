unit Ini.Config.AppSettings;

interface

uses
  Ini.Config;

{$M+}
type
  TAppSettings = class(TSettings)
  public
    constructor Create(); virtual;
  end;

{$M-}

implementation

uses
  System.IOUtils;

{ **************************************************************************** }

{ TAppSettings }

constructor TAppSettings.Create();
begin
  inherited;
  ConfigAddress := TPath.GetFileNameWithoutExtension(ParamStr(0)) + '.config';
end;

end.
