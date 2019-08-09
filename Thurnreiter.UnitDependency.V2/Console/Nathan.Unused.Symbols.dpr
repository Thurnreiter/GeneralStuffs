program Nathan.Unused.Symbols;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.Types,
  System.SysUtils,
  System.Generics.Collections,
  Nathan.UnitDependencyV2.Service in '..\Nathan.UnitDependencyV2.Service.pas',
  Nathan.UnitDependencyV2.Xml.Worker in '..\Nathan.UnitDependencyV2.Xml.Worker.pas',
  Nathan.UnitDependencyV2.Dtos in '..\Nathan.UnitDependencyV2.Dtos.pas',
  Nathan.Unused.Console.ClearScreen in 'Nathan.Unused.Console.ClearScreen.pas';

var
  Service: INathanUDV2Service;
  ParamFileValue: string;
  ParamPathValue: string;
  ParamFilterValue: string;
  ParamCleanSearchPathValue: string;
  JsonOutput: string;
begin
  try
    if FindCmdLineSwitch('HELP') then
    begin
      Writeln('List of all unused namespace');
      Writeln('Nathan.Unused.Symbols');
      Writeln('  -Path:[Path of *.symbol_report files.]');
      Writeln('  -File:[The *.symbol_report filename with path.]');
      Writeln('  -Filter:[Strings of exclude namespaces, comma');
      Writeln('   or semicolon seperated. Default are empty.]');
      Writeln('  -Clean:[Search path for corresponding *.pas files. ');
      Writeln('   Comma or semicolon seperated.]');
      Writeln('Output are a json string.');
      Exit;
    end;

    FindCmdLineSwitch('FILE', ParamFileValue, True);
    if  ((not FindCmdLineSwitch('PATH', ParamPathValue, True)) or ParamPathValue.IsEmpty)
    and (ParamFileValue.IsEmpty) then
      ParamPathValue := '.\';

    FindCmdLineSwitch('FILTER', ParamFilterValue, True);
    FindCmdLineSwitch('CLEAN', ParamCleanSearchPathValue, True);

    Service := TNathanUDV2Service.Create;

    if ParamFileValue.IsEmpty then
      Service.SymbolReportPath(ParamPathValue)
    else
      Service.SymbolReportFile(ParamFileValue);

    Service
      .OnProcess(
        procedure (Symbole: string)
        begin
          {$IFDEF DEBUG}Write('.'){$ENDIF}
        end);

    if (not ParamFilterValue.IsEmpty) then
      Service.FilteredValues(ParamFilterValue.Split([',', ';', '|']));

    if ParamCleanSearchPathValue.IsEmpty then
      JsonOutput := Service.Execute
    else
      JsonOutput := Service.Clean(ParamCleanSearchPathValue);

    {$IFDEF DEBUG}NathanUnusedConsoleHelper.ClearScreen;{$ENDIF}
    Writeln(JsonOutput)
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
  {$IFDEF DEBUG}Readln{$ENDIF}
end.
