unit Test.Dto.Serializer;

interface

{$M+}

uses
  DUnitX.TestFramework;

type
  [TestFixture]
  TTestJsonDtoSerializer = class
  public
    [Test]
    procedure Test_Dto_Record;

    [Test]
    procedure Test_Dtos_Record;
  end;

{$M-}

implementation

uses
  System.SysUtils,
  Nathan.UnitDependencyV2.Dtos;

procedure TTestJsonDtoSerializer.Test_Dto_Record;
const
  ExpectedJson = '{"file":"my.txt","pas":"my.pas","namespaces":["First","Second"]}';
var
  Actual: string;
  Dto: TNathanUDV2Dto;
begin
  //  Arrange...
  Dto.SymbolFilename := 'my.txt';
  Dto.Namespaces := ['First', 'Second'];

  //  Act...
  Actual := Dto
    .ToJson
    .Replace(sLineBreak, '')
    .Replace(' ', '');

  //  Assert...
  Assert.AreEqual(ExpectedJson, Actual);
end;

procedure TTestJsonDtoSerializer.Test_Dtos_Record;
const
  ExpectedJson = '{"path":"C:\\Temp","list":[{"file":"my.txt","pas":"my.pas","namespaces":["First","Second"]},{"file":"my.txt","pas":"my.pas","namespaces":["Third","Fourth"]}]}';
var
  Cut: TNathanUDV2Dtos;
  Dto1: TNathanUDV2Dto;
  Dto2: TNathanUDV2Dto;
begin
  Dto1.SymbolFilename := 'my.txt';
  Dto1.Namespaces := ['First', 'Second'];

  Dto2.SymbolFilename := 'my.txt';
  Dto2.Namespaces := ['Third', 'Fourth'];

  Cut.Path := 'C:\Temp';
  Cut.List := [Dto1, Dto2];

  Assert.AreEqual(2, Length(Cut.List));
  Assert.AreEqual(ExpectedJson, Cut.ToJson.Replace(sLineBreak, '').Replace(' ', ''));
end;

initialization
  TDUnitX.RegisterTestFixture(TTestJsonDtoSerializer, 'Serializer');

end.
