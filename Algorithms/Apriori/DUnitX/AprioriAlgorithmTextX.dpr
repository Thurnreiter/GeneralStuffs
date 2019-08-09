program AprioriAlgorithmTextX;

{$IFNDEF TESTINSIGHT}
{$APPTYPE CONSOLE}
{$ENDIF}{$STRONGLINKTYPES ON}
uses
  System.SysUtils,
  {$IFDEF TESTINSIGHT}
  TestInsight.DUnitX,
  {$ENDIF }
  DUnitX.Loggers.Console,
  DUnitX.Loggers.Xml.NUnit,
  DUnitX.TestFramework,
  Test.Apriori.Impl in 'Test.Apriori.Impl.pas',
  Nathan.Permutation in '..\..\PermutationsAndCombinations\Nathan.Permutation.pas',
  Nathan.TArrayHelper in '..\..\..\..\Thurnreiter.Lib\Nathan.TArrayHelper.pas',
  Apriori.Algo in '..\Apriori.Algo.pas',
  Apriori.Items in '..\Apriori.Items.pas',
  Apriori.Confidence in '..\Apriori.Confidence.pas',
  Apriori.Lift in '..\Apriori.Lift.pas',
  Apriori.TransationConverter in '..\Apriori.TransationConverter.pas',
  Test.Apriori.TransactionConverter in 'Test.Apriori.TransactionConverter.pas',
  Apriori.TransationConverter.Enumerators in '..\Apriori.TransationConverter.Enumerators.pas',
  Test.Apriori.Impl.ExternalReference in 'Test.Apriori.Impl.ExternalReference.pas',
  Apriori.Provider in '..\Apriori.Provider.pas',
  Test.Apriori.Impl.Provider in 'Test.Apriori.Impl.Provider.pas';

var
  runner : ITestRunner;
  results : IRunResults;
  logger : ITestLogger;
  nunitLogger : ITestLogger;
begin
  ReportMemoryLeaksOnShutdown := (DebugHook > 0);
{$IFDEF TESTINSIGHT}
  TestInsight.DUnitX.RunRegisteredTests;
  exit;
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
