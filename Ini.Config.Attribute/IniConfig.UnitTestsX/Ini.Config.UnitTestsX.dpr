program Ini.Config.UnitTestsX;

{$IFNDEF TESTINSIGHT}
  {$APPTYPE CONSOLE}
{$ENDIF}

{$STRONGLINKTYPES ON}

{$R *.dres}

uses
  System.SysUtils,
  {$IFDEF TESTINSIGHT}
  TestInsight.DUnitX,
  {$ENDIF }
  DUnitX.Loggers.Console,
  DUnitX.Loggers.Xml.NUnit,
  DUnitX.TestFramework,

  Ini.Config in '..\Ini.Config.pas',
  Ini.Config.AppSettings.Test in 'tests\Ini.Config.AppSettings.Test.pas',
  Ini.Config.BaseTester in 'tests\Ini.Config.BaseTester.pas',
  Ini.Config.CCRIniFile.Test in 'tests\Ini.Config.CCRIniFile.Test.pas',
  Ini.Config.Ini.Test in 'tests\Ini.Config.Ini.Test.pas',
  Ini.Config.Json.Test in 'tests\Ini.Config.Json.Test.pas',
  Ini.Config.Reflection.Test in 'tests\Ini.Config.Reflection.Test.pas',
  Ini.Config.Sample.Config.Test in 'tests\Ini.Config.Sample.Config.Test.pas',
  Ini.Config.Sample.Provider.Test in 'tests\Ini.Config.Sample.Provider.Test.pas',
  Ini.Config.Sample.Test in 'tests\Ini.Config.Sample.Test.pas',
  Ini.Config.Sample.VI.Test in 'tests\Ini.Config.Sample.VI.Test.pas',
  Ini.Config.AppSettings in '..\Ini.Config.AppSettings.pas',
  Ini.Config.Handler.CCR.PrefsIniFile in '..\Ini.Config.Handler.CCR.PrefsIniFile.pas',
  Ini.Config.Handler.IniFiles in '..\Ini.Config.Handler.IniFiles.pas',
  Ini.Config.Handler.Json in '..\Ini.Config.Handler.Json.pas',
  Ini.Config.Sample.Config in '..\Ini.Config.Sample.Config.pas',
  Ini.Config.Sample.Provider.Alias in '..\Ini.Config.Sample.Provider.Alias.pas',
  Ini.Config.Sample.Provider in '..\Ini.Config.Sample.Provider.pas',
  Ini.Config.Sample.Settings in '..\Ini.Config.Sample.Settings.pas',
  Ini.Config.Sample.VI in '..\Ini.Config.Sample.VI.pas';

var
  runner: ITestRunner;
  results: IRunResults;
  logger: ITestLogger;
  nunitLogger: ITestLogger;

begin
  ReportMemoryLeaksOnShutdown := (DebugHook > 0);
{$IFDEF TESTINSIGHT}
  TestInsight.DUnitX.RunRegisteredTests;
  Exit;
{$ENDIF}
  try
    //Check command line options, will exit if invalid
    TDUnitX.CheckCommandLine;
    //Create the test runner
    runner := TDUnitX.CreateRunner;
    //Tell the runner to use RTTI to find Fixtures
    runner.UseRTTI := True;
    //tell the runner how we will log things
    //Log to the console window
    logger := TDUnitXConsoleLogger.Create(true);
    runner.AddLogger(logger);
    //Generate an NUnit compatible XML File
    nunitLogger := TDUnitXXMLNUnitFileLogger.Create(TDUnitX.Options.XMLOutputFile);
    runner.AddLogger(nunitLogger);
    runner.FailsOnNoAsserts := False; //When true, Assertions must be made during tests;

    //Run tests
    results := runner.Execute;
    if not results.AllPassed then
      System.ExitCode := EXIT_ERRORS;

    {$IFNDEF CI}
    //We don't want this happening when running under CI.
    if TDUnitX.Options.ExitBehavior = TDUnitXExitBehavior.Pause then
    begin
      System.Write('Done.. press <Enter> key to quit.');
      System.Readln;
    end;
    {$ENDIF}
  except
    on E: Exception do
      System.Writeln(E.ClassName, ': ', E.Message);
  end;
end.
