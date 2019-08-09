unit Nathan.OOS.Logger;

interface

uses
  System.SysUtils;

{$M+}

type
  ILog = interface
    ['{4A2AC201-0B23-4FD8-8A74-9CE4AB523654}']
    procedure Info(const LoggingMsg: string);
  end;

  TLog = class(TInterfacedObject, ILog)
    procedure Info(const LoggingMsg: string);
  end;
  /// <summary>
  ///   How to write the entered and leaving only in one line of code in a method.
  /// </summary>
  INathanOutOfScopLogger = interface
    ['{C8525327-5471-4051-978A-AD3C129A3C0A}']
  end;

  /// <summary>
  ///   Look at: <see cref="Nathan.OOS.Logger|INathanOutOfScopLogger">INathanOutOfScopLogger</see>
  /// </summary>
  TNathanOutOfScopLogger = class(TInterfacedObject, INathanOutOfScopLogger)
  private
    FLeaveProc: TProc;
  protected
    constructor Create(AEnterProc, ALeaveProc: TProc);
  public
    class function EnterLeave(const Methodname: string): INathanOutOfScopLogger; overload;
    class function EnterLeave(const Methodname: string; ALog: ILog): INathanOutOfScopLogger; overload;
    class function EnterLeave(AEnterProc, ALeaveProc: TProc): INathanOutOfScopLogger; overload;

    destructor Destroy(); override;
  end;

  NOOSLogger = TNathanOutOfScopLogger;

{$M-}

implementation

{ TLog }

procedure TLog.Info(const LoggingMsg: string);
begin
  Writeln(LoggingMsg);
end;

{ TNathanOutOfScopLogger }

constructor TNathanOutOfScopLogger.Create(AEnterProc, ALeaveProc: TProc);
begin
  inherited Create();
  AEnterProc;
  FLeaveProc := ALeaveProc;
end;

destructor TNathanOutOfScopLogger.Destroy;
begin
  FLeaveProc;
  inherited;
end;

class function TNathanOutOfScopLogger.EnterLeave(const Methodname: string): INathanOutOfScopLogger;
begin
  Result := EnterLeave(Methodname, TLog.Create as ILog);
end;

class function TNathanOutOfScopLogger.EnterLeave(const Methodname: string; ALog: ILog): INathanOutOfScopLogger;
begin
  Result := EnterLeave(
    procedure
    begin
      ALog.Info('Entered ' + Methodname);
    end,
    procedure
    begin
      ALog.Info('Leaving ' + Methodname);
    end);
end;

class function TNathanOutOfScopLogger.EnterLeave(AEnterProc, ALeaveProc: TProc): INathanOutOfScopLogger;
begin
  Result := TNathanOutOfScopLogger.Create(AEnterProc, ALeaveProc);
end;

end.
