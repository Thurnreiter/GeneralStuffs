unit Ini.Config.Sample.Config;

interface

uses
  System.SysUtils,
  Ini.Config.Sample.Settings;

{$M+}

type
  ///  <summary>
  ///  The exception raised when a configuration entry is invalid.
  ///  </summary<
  EInvalidConfiguration = class(Exception);

  IConfig = interface
    ['{A7F3D9F0-F0E7-4152-B37E-023ACE26E404}']

    function GetClient(): Integer;
    function GetLicence(): string;

    function GetDatabaseServer(): string;
    function GetDatabasePort(): Integer;
    function GetDatabaseAlias(): string;

    function GetBackupPath(): string;
    function GetSqlMonitor(): Boolean;

    function GetIsInternal: Boolean;

    property Client: Integer read GetClient;
    property Licence: string read GetLicence;
    property DatabaseServer: string read GetDatabaseServer;
    property DatabasePort: Integer read GetDatabasePort;
    property DatabaseAlias: string read GetDatabaseAlias;
    property BackupPath: string read GetBackupPath;
    property SqlMonitor: Boolean read GetSqlMonitor;
    property IsInternal: Boolean read GetIsInternal;
  end;

  TConfigImpl = class(TInterfacedObject, IConfig)
  strict private
    FSampleSettings: ISampleSettings;
  public const
    EInvConfMsg = 'Configuration error: The value for %s was not specified.';
  protected
    function GetClient(): Integer;
    function GetLicence(): string;

    function GetDatabaseServer(): string;
    function GetDatabasePort(): Integer;
    function GetDatabaseAlias(): string;

    function GetBackupPath(): string;
    function GetSqlMonitor(): Boolean;

    function GetIsInternal: Boolean;
  public
    const SampleIni = TSampleSettings.SampleIni;
  public
    constructor Create(); overload;
    constructor Create(ASampleSettings: ISampleSettings); overload;
  end;

{$M-}

implementation

uses
  System.StrUtils,
  System.IOUtils;

{ **************************************************************************** }

{ TConfigImpl }

constructor TConfigImpl.Create;
begin
  inherited Create;

  //  ToDo: Use IoC Provider...
  //  Old Stuff: Create(TSampleIni.Create());
  FSampleSettings := nil;
end;

constructor TConfigImpl.Create(ASampleSettings: ISampleSettings);
begin
  inherited Create;

  //  ToDo: Use IoC Provider...
  FSampleSettings := ASampleSettings;
end;

function TConfigImpl.GetClient: Integer;
begin
  Result := FSampleSettings.Client;
  if (Result <= 0) then
    raise EInvalidConfiguration.CreateFmt(EInvConfMsg, ['Client']);
end;

function TConfigImpl.GetLicence: string;
begin
  Result := FSampleSettings.Licence;
  if (Result.IsEmpty) then
    raise EInvalidConfiguration.CreateFmt(EInvConfMsg, ['Licence']);
end;

function TConfigImpl.GetDatabaseServer: string;
begin
  Result := FSampleSettings.DatabaseServer;

  if (Result.IsEmpty) then
    Exit('localhost');

  Result := Result.Split(['/'])[0]
end;

function TConfigImpl.GetIsInternal: Boolean;
begin
  Result := GetClient() >= 99999;
end;

function TConfigImpl.GetDatabasePort: Integer;
var
  DBSrvName: string;
  DBSrvNameSplit: TArray<string>;
begin
  DBSrvName := FSampleSettings.DatabaseServer + '/';
  DBSrvNameSplit := DBSrvName.Split(['/']);
  if (Length(DBSrvNameSplit) <= 1) then
    Result := 3050
  else
    Result := StrToIntDef(DBSrvNameSplit[1], 3050);
end;

function TConfigImpl.GetDatabaseAlias: string;
begin
  Result := FSampleSettings.DatabaseAlias;
  if (Result.IsEmpty) then
    Result := 'Sample';
end;

function TConfigImpl.GetBackupPath: string;
begin
  Result := FSampleSettings.BackupPath;
  if (Result.IsEmpty) then
    Result := TPath.GetFullPath(ExtractFilePath(ParamStr(0)) + '..\Backup');
end;

function TConfigImpl.GetSqlMonitor(): Boolean;
begin
  Result := FSampleSettings.SqlMonitor;
end;

//function TConfigImpl.GetUpdateUri: TUri;
//var
//  Uri: string;
//begin
//  Uri := FSampleSettings.UpdateUri;
//  Result := TUri.Create(IfThen(Uri <> '', Uri, 'https://www.ww.ch/myservices/2020/updates'));
//end;

end.
