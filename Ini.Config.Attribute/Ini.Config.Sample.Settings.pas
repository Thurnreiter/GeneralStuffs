unit Ini.Config.Sample.Settings;

interface

uses
  Ini.Config,
  Ini.Config.AppSettings;

{$M+}

type
  ISampleSettings = interface(ISettings)
    ['{B40DDCB3-84D0-46B7-AAD2-250F4D97A707}']
    function GetBackupPath: string;
    function GetDatabaseServer: string;
    function GetDatabaseAlias: string;
    function GetLicence: string;
    function GetClient: Integer;
    function GetSqlMonitor(): Boolean;

    procedure SetBackupPath(const value: string);
    procedure SetDatabaseServer(const value: string);
    procedure SetDatabaseAlias(const value: string);
    procedure SetLicence(const value: string);
    procedure SetClient(value: Integer);
    procedure SetSqlMonitor(value: Boolean);

    property Client: Integer read GetClient;
    property Licence: string read GetLicence;
    property DatabaseAlias: string read GetDatabaseAlias;
    property DatabaseServer: string read GetDatabaseServer;
    property BackupPath: string read GetBackupPath;
    property SqlMonitor: Boolean read GetSqlMonitor;
  end;

  TSampleSettings = class(TAppSettings, ISampleSettings)
  strict private
    [Setting('System', 'Client')]
    FClient: Integer;

    [Setting('System', 'Licence')]
    FLicence: string;

    [Setting('System', 'Server', 'localhost/3050')]
    FDBServer: string;

    [Setting('System', 'Alias', 'dbname')]
    FDatabaseAlias: string;

    [Setting('System', 'BackupPath', '..\Backup')]
    FBackupPath: string;

    [Setting('System', 'SqlMonitor', False)]
    FSqlMonitor: Boolean;
  private
    function GetLicence: string;
    function GetClient: Integer;
    function GetDatabaseServer: string;
    function GetDatabaseAlias: string;
    function GetBackupPath: string;
    function GetSqlMonitor(): Boolean;

    procedure SetClient(value: Integer);
    procedure SetLicence(const value: string);
    procedure SetDatabaseServer(const value: string);
    procedure SetDatabaseAlias(const value: string);
    procedure SetBackupPath(const value: string);
    procedure SetSqlMonitor(value: Boolean);
  public
    const SampleIni = 'Sample.ini';
  public
    constructor Create(); override;
  end;

{$M+}

implementation

uses
  System.SysUtils,
  System.IOUtils;

{ **************************************************************************** }

{ TSampleSettings }

constructor TSampleSettings.Create;
begin
  inherited Create;
  ConfigAddress := TPath.Combine(TPath.GetDirectoryName(ParamStr(0)), SampleIni);
end;

function TSampleSettings.GetBackupPath: string;
begin
  Result := FBackupPath;
end;

function TSampleSettings.GetDatabaseAlias: string;
begin
  Result := FDatabaseAlias;
end;

function TSampleSettings.GetDatabaseServer: string;
begin
  Result := FDBServer;
end;

function TSampleSettings.GetLicence: string;
begin
  Result := FLicence;
end;

function TSampleSettings.GetClient: Integer;
begin
  Result := FClient;
end;

function TSampleSettings.GetSqlMonitor: Boolean;
begin
  Result := FSqlMonitor;
end;

procedure TSampleSettings.SetDatabaseAlias(const value: string);
begin
  FDatabaseAlias := value;
end;

procedure TSampleSettings.SetDatabaseServer(const value: string);
begin
  FDBServer := value;
end;

procedure TSampleSettings.SetBackupPath(const value: string);
begin
  FBackupPath := value;
end;

procedure TSampleSettings.SetLicence(const value: string);
begin
  FLicence := value;
end;

procedure TSampleSettings.SetClient(value: Integer);
begin
  FClient := value;
end;

procedure TSampleSettings.SetSqlMonitor(value: Boolean);
begin
  FSqlMonitor := value;
end;

end.
