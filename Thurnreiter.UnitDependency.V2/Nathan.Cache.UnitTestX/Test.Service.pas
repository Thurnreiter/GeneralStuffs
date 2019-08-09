unit Test.Service;

interface

{$M+}

uses
  DUnitX.TestFramework,
  System.Diagnostics,
  Nathan.UnitDependencyV2.Service;

{$I Test.Xml.Worker.inc}

type
  [TestFixture]
  TTestService = class
  strict private
    FCut: INathanUDV2Service;
    FStopuhr: TStopWatch;
  private const
    DemoSymbolPath = '.\pas';
    DemoSymbolFile1 = DemoSymbolPath + '\demo1.symbol_report';
    DemoSymbolFile2 = DemoSymbolPath + '\demo2.symbol_report';
    DemoSymbolFile3 = DemoSymbolPath + '\demo3.symbol_report';
    DemoSymbolFile4 = DemoSymbolPath + '\demo4.symbol_report';
    DemoSymbolFile5 = DemoSymbolPath + '\demo5.symbol_report';
    DemoSymbolFile6 = DemoSymbolPath + '\demo6.symbol_report';
    Unit1SymbolFile = DemoSymbolPath + '\Unit1.symbol_report';
    Unit1Pas = DemoSymbolPath + '\Unit1.pas';
  public
    [SetupFixture]
    procedure SetupFixture;

    [Setup]
    procedure Setup();

    [TearDown]
    procedure TearDown();

    [Test]
    procedure Test_Execute_ToJson;

    [Test]
    procedure Test_Execute_WithTwoFiles;

    [Test]
    procedure Test_Execute_FilteredValues;

    [Test]
    procedure Test_Execute_FilteredValuesMore;

    [Test]
    procedure Test_Execute_FilteredValuesWithWildcard;

    [Test]
    procedure Test_Execute_WithInvalidXml;

    [Test]
    procedure Test_Execute_WithInvalidXmlOneMore;

    [Test]
    procedure Test_Execute_NoFileFound;

    [Test]
    procedure Test_Execute_Filter;

    [Test]
    procedure Test_Execute_Clean_Unit1;

    [Test]
    procedure Test_Execute_OnProcess;

    [Test]
    procedure Test_Execute_OnProcessDto;

    [Test]
    procedure Test_Execute_ToJson_JustWithOneFileOverName;

    [Test]
    procedure Test_Execute_BigSymbolReport;
  end;

{$M-}

implementation

uses
  System.SysUtils,
  System.IOUtils,
  System.Generics.Collections,
  Nathan.UnitDependencyV2.Dtos;

procedure TTestService.Setup();
begin
  FCut := TNathanUDV2Service.Create;
  TDirectory.CreateDirectory(DemoSymbolPath);
end;

procedure TTestService.SetupFixture;
begin
  if TDirectory.Exists(DemoSymbolPath) then
    TDirectory.Delete(DemoSymbolPath, True);
end;

procedure TTestService.TearDown();
begin
  FCut := nil;

  TDirectory.Delete(DemoSymbolPath, True);
end;

procedure TTestService.Test_Execute_ToJson;
const
  ExpectedJson = '{"path":".\\pas","list":[{"file":"demo1.symbol_report","pas":"demo1.pas","namespaces":["System.Math"]}]}';
var
  Actual: string;
begin
  //  Has memory leaks...
  //  Arrange...
  TFile.WriteAllText(DemoSymbolFile1, demo1_symbol_report);

  //  Act...
  Actual := FCut
    .SymbolReportPath(DemoSymbolPath)
    .Execute
    .Replace(sLineBreak, '')
    .Replace(' ', '');

  //  Assert...
  Assert.AreEqual(ExpectedJson, Actual);
end;

procedure TTestService.Test_Execute_WithTwoFiles;
const
  ExpectedJson = '{"path":".\\pas","list":[{"file":"demo1.symbol_report","pas":"demo1.pas","namespaces":["System.Math"]}]}';
var
  Actual: string;
begin
  //  Arrange...
  TFile.WriteAllText(DemoSymbolFile1, demo1_symbol_report);
  TFile.WriteAllText(DemoSymbolFile2, demo2_symbol_report);

  //  Act...
  Actual := FCut
    .SymbolReportPath(DemoSymbolPath)
    .Execute
    .Replace(sLineBreak, '')
    .Replace(' ', '');

  //  Assert...
  Assert.AreEqual(ExpectedJson, Actual);
end;

procedure TTestService.Test_Execute_FilteredValues;
const
  ExpectedJson = '{"path":".\\pas","list":[{"file":"demo1.symbol_report","pas":"demo1.pas","namespaces":["System.Math"]}]}';
var
  Actual: string;
begin
  //  Arrange...
  TFile.WriteAllText(DemoSymbolFile1, demo1_symbol_report);

  //  Act...
  Actual := FCut
    .SymbolReportPath(DemoSymbolPath)
    .FilteredValues(['SysInit'])
    .Execute
    .Replace(sLineBreak, '')
    .Replace(' ', '');

  //  Assert...
  Assert.AreEqual(ExpectedJson, Actual);
end;

procedure TTestService.Test_Execute_FilteredValuesMore;
const
  ExpectedJson = '{"path":".\\pas","list":[{"file":"demo5.symbol_report","pas":"demo5.pas","namespaces":["Vcl.Dialogs","Vcl.Controls"]}]}';
var
  Actual: string;
begin
  //  Arrange...
  TFile.WriteAllText(DemoSymbolFile5, demo5_symbol_report);

  //  Act...
  Actual := FCut
    .SymbolReportPath(DemoSymbolPath)
    .FilteredValues(['SysInit', 'Winapi.Windows'])
    .Execute
    .Replace(sLineBreak, '')
    .Replace(' ', '');

  //  Assert...
  Assert.AreEqual(ExpectedJson, Actual);
end;

procedure TTestService.Test_Execute_FilteredValuesWithWildcard;
const
  ExpectedJson = '{"path":".\\pas","list":[{"file":"demo5.symbol_report","pas":"demo5.pas","namespaces":["Vcl.Dialogs","Vcl.Controls"]}]}';
var
  Actual: string;
begin
  //  Arrange...
  TFile.WriteAllText(DemoSymbolFile5, demo5_symbol_report);
  FStopuhr := TStopWatch.StartNew;

  //  Act...
  Actual := FCut
    .SymbolReportPath(DemoSymbolPath)
    .FilteredValues(['SysInit', 'Winapi.*'])
    .Execute
    .Replace(sLineBreak, '')
    .Replace(' ', '');

  FStopuhr.Stop;

  //  Assert...
  Assert.AreEqual(ExpectedJson, Actual);
  Assert.IsTrue(FStopuhr.ElapsedMilliseconds < 50);
end;

procedure TTestService.Test_Execute_NoFileFound;
const
  ExpectedJson = '{"path":".\\pas","list":null}';
var
  Actual: string;
begin
  //  Arrange...
  //  Act...
  Actual := FCut
    .SymbolReportPath(DemoSymbolPath)
    .Execute
    .Replace(sLineBreak, '')
    .Replace(' ', '');

  //  Assert...
  Assert.AreEqual(ExpectedJson, Actual);
end;

procedure TTestService.Test_Execute_WithInvalidXml;
const
  ExpectedJson = '{"path":".\\pas","list":[{"file":"demo3.symbol_report","pas":"demo3.pas","namespaces":["System.Hash","IPPeerServer","IPPeerClient"]}]}';
var
  Actual: string;
begin
  //  Arrange...
  TFile.WriteAllText(DemoSymbolFile3, demo3_symbol_report);

  //  Act...
  Actual := FCut
    .SymbolReportPath(DemoSymbolPath)
    .Execute
    .Replace(sLineBreak, '')
    .Replace(' ', '');

  //  Assert...
  Assert.AreEqual(ExpectedJson, Actual);
end;

procedure TTestService.Test_Execute_WithInvalidXmlOneMore;
var
  Actual: string;
begin
  //  Arrange...
  TFile.WriteAllText(DemoSymbolFile4, demo4_symbol_report);

  //  Act...
  Actual := FCut
    .SymbolReportPath(DemoSymbolPath)
    .Execute
    .Replace(sLineBreak, '')
    .Replace(' ', '');

  //  Assert...
  Assert.AreEqual('{"path":".\\pas","list":null}', Actual);
end;

procedure TTestService.Test_Execute_Filter;
const
  ExpectedJson = '{"path":".\\pas","list":[{"file":"demo1.symbol_report","pas":"demo1.pas","namespaces":["System.Math"]}]}';
var
  Actual: string;
begin
  //  Arrange...
  TFile.WriteAllText(DemoSymbolFile1, demo1_symbol_report);

  //  Act...
  Actual := FCut
    .SymbolReportPath(DemoSymbolPath)
    .Execute
    .Replace(sLineBreak, '')
    .Replace(' ', '');

  //  Assert...
  Assert.AreEqual(ExpectedJson, Actual);
end;

procedure TTestService.Test_Execute_Clean_Unit1;
const
  ExpectedJson = '{"path":".\\pas","list":[{"file":"demo1.symbol_report","pas":"demo1.pas",'
    + '"namespaces":["System.Math"]},{"file":"Unit1.symbol_report","pas":"Unit1.pas",'
    + '"namespaces":["Vcl.Dialogs","Vcl.Forms","System.ImageList","System.Actions","System.Classes",'
    + '"System.Variants","System.SysUtils","Winapi.Messages","Winapi.Windows","System"]}]}';

  ExspectedContent = 'unit Unit1;  interface  uses                implementation  uses      end.';
var
  Actual: string;
  ActualContent: string;
begin
  //  Has memory leaks...
  //  Arrange...
  TFile.WriteAllText(DemoSymbolFile1, demo1_symbol_report);
  TFile.WriteAllText(Unit1SymbolFile, Unit1_symbol_report);
  TFile.WriteAllText(Unit1Pas, Unit1_pas);

  //  Act...
  Actual := FCut
    .SymbolReportPath(DemoSymbolPath)
    .Clean(DemoSymbolPath)
    .Replace(sLineBreak, '')
    .Replace(' ', '');

  ActualContent := TFile.ReadAllText(Unit1Pas).Replace(sLineBreak, '');

  //  Assert...
  Assert.AreEqual(ExpectedJson, Actual);

  //  I now, the result is not very nice but the first approach. Is importend
  //  to now, that after this clearing method, that the pas file are demaged.
  Assert.AreEqual(ExspectedContent, ActualContent);
end;

procedure TTestService.Test_Execute_OnProcess;
var
  Actual: string;
begin
  //  Arrange...
  Actual := string.Empty;
  TFile.WriteAllText(DemoSymbolFile1, demo1_symbol_report);

  //  Act...
  FCut
    .SymbolReportPath(DemoSymbolPath)
    .OnProcess(
      procedure (Symbole: string)
      begin
        Actual := Symbole;
      end)
    .Execute
    .Replace(sLineBreak, '')
    .Replace(' ', '');

  //  Assert...
  Assert.AreEqual(DemoSymbolFile1, Actual);
end;

procedure TTestService.Test_Execute_OnProcessDto;
var
  Actual: string;
begin
  //  Arrange...
  Actual := string.Empty;
  TFile.WriteAllText(DemoSymbolFile1, demo1_symbol_report);

  //  Act...
  FCut
    .SymbolReportPath(DemoSymbolPath)
    .OnProcess(
      procedure (SymboleDto: TNathanUDV2Dto)
      begin
        Actual := SymboleDto.SymbolFilename;
      end)
    .Execute
    .Replace(sLineBreak, '')
    .Replace(' ', '');

  //  Assert...
  Assert.AreEqual('demo1.symbol_report', Actual);
end;

procedure TTestService.Test_Execute_ToJson_JustWithOneFileOverName;
const
  ExpectedJson = '{"path":".\\pas","list":[{"file":"demo1.symbol_report","pas":"demo1.pas","namespaces":["System.Math"]}]}';
var
  Actual: string;
begin
  //  Has memory leaks...
  //  Arrange...
  TFile.WriteAllText(DemoSymbolFile1, demo1_symbol_report);

  //  Act...
  Actual := FCut
    .SymbolReportFile(DemoSymbolFile1)
    .Execute
    .Replace(sLineBreak, '')
    .Replace(' ', '');

  //  Assert...
  Assert.AreEqual(ExpectedJson, Actual);
end;

procedure TTestService.Test_Execute_BigSymbolReport;
const
  ExpectedJson = '{"path":".\\pas","list":null}';
var
  Actual: string;
begin
  //  Arrange...
  TFile.WriteAllText(DemoSymbolFile6, demo6_symbol_report);
  FStopuhr := TStopWatch.StartNew;

  //  Act...
  Actual := FCut
    .SymbolReportPath(DemoSymbolPath)
    .Execute
    .Replace(sLineBreak, '')
    .Replace(' ', '');

  FStopuhr.Stop;

  //  Assert...
  Assert.AreEqual(ExpectedJson, Actual);
  Assert.IsTrue(FStopuhr.ElapsedMilliseconds < 100);
end;

initialization
  TDUnitX.RegisterTestFixture(TTestService, 'Service');

end.
