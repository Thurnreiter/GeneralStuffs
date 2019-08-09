unit Nathan.UnitDependencyV2.Xml.Worker;

interface

uses
  System.SysUtils,
  System.RegularExpressions,
  Xml.XMLIntf,
  Nathan.UnitDependencyV2.Dtos;

{$M+}

type
  /// <summary>
  ///   Set under the project configuration:
  ///   "Delphi Compiler" - "Compiling" - "Other options" - "Assitional options to pass to the compiler"
  ///   the value "--symbol-report"
  /// </summary>
  INathanUDV2XmlWorker = interface
    ['{B60D192E-7563-4E4F-B67A-3E2452E96173}']
    function Xml(): string; overload;
    function Xml(const Value: string): INathanUDV2XmlWorker; overload;

    function Filter(): TFunc<TNathanUDV2Dto, TArray<string>>; overload;
    function Filter(const Value: TFunc<TNathanUDV2Dto, TArray<string>>): INathanUDV2XmlWorker; overload;

    function Execute(): TNathanUDV2Dto;
  end;

  TNathanUDV2XmlWorker = class(TInterfacedObject, INathanUDV2XmlWorker)
  strict private
    FXml: string;
    FFilter: TFunc<TNathanUDV2Dto, TArray<string>>;
    FXmlDoc: IXMLDocument;
  private
    function ReplaceInvalidXmlCharacters(const Match: TMatch): string;
    procedure OpenXmlDoc();
  public
    constructor Create();
    destructor Destroy(); override;

    function Xml(): string; overload;
    function Xml(const Value: string): INathanUDV2XmlWorker; overload;

    function Filter(): TFunc<TNathanUDV2Dto, TArray<string>>; overload;
    function Filter(const Value: TFunc<TNathanUDV2Dto, TArray<string>>): INathanUDV2XmlWorker; overload;

    function Execute(): TNathanUDV2Dto;
  end;

{$M-}

implementation

uses
  {$IFDEF MSWINDOWS}Winapi.ActiveX,{$ENDIF}
  Xml.XMLDoc,
  Xml.xmldom;
  //  Xml.omnixmldom => DefaultDOMVendor := sOmniXmlVendor;
  // Xml.Win.msxmldom => DefaultDOMVendor := SMSXML;


{ TNathanUDV2XmlWorker }

constructor TNathanUDV2XmlWorker.Create;
begin
  inherited;
  {$IFDEF MSWINDOWS}CoInitialize(nil);{$ENDIF}
  FXmlDoc := TXMLDocument.Create(nil);
end;

destructor TNathanUDV2XmlWorker.Destroy;
begin
  FXmlDoc.Active := False;
  FXmlDoc := nil;
  {$IFDEF MSWINDOWS}CoUninitialize;{$ENDIF}
  inherited;
end;

function TNathanUDV2XmlWorker.ReplaceInvalidXmlCharacters(const Match: TMatch): string;
begin
  //  Found symbol files with invalid characters in attribute, sample:
  //  <symbol name="{System.Generics.Collections}TList<System.Tether.Manager.TTetheringProfileInfo>.GetItem"/>
  Result := Match
    .Value
    .Replace('<', '&lt;')
    .Replace('>', '&gt;')
    .Replace('&', '&amp;');
//    .Replace('"', '&quot;')
//    .Replace('''', '&apos;');
end;

procedure TNathanUDV2XmlWorker.OpenXmlDoc;
begin
  FXmlDoc.Active := False;
  if FXml.IsEmpty then
    Exit;

  //  https://dvteclipse.com/documentation/svlinter/How_to_use_special_characters_in_XML.3F.html
  FXml := TRegEx.Replace(FXml, 'name=\"[^\"]*\"', ReplaceInvalidXmlCharacters);

  FXmlDoc.LoadFromXML(FXml);
  FXmlDoc.Options := FXmlDoc.Options + [doNodeAutoIndent];
  FXmlDoc.Active := True;
end;

function TNathanUDV2XmlWorker.Xml: string;
begin
  Result := FXml;
end;

function TNathanUDV2XmlWorker.Xml(const Value: string): INathanUDV2XmlWorker;
begin
  FXml := Value;
  Result := Self;
end;

function TNathanUDV2XmlWorker.Filter: TFunc<TNathanUDV2Dto, TArray<string>>;
begin
  Result := FFilter;
end;

function TNathanUDV2XmlWorker.Filter(const Value: TFunc<TNathanUDV2Dto, TArray<string>>): INathanUDV2XmlWorker;
begin
  FFilter := Value;
  Result := Self;
end;

function TNathanUDV2XmlWorker.Execute: TNathanUDV2Dto;
var
  Idx: Integer;
  At: Integer;
begin
  OpenXmlDoc;

  for Idx := 0 to FXmlDoc.DocumentElement.ChildNodes.Count - 1 do
  begin
    if (FXmlDoc.DocumentElement.ChildNodes[Idx].ChildNodes.Count = 0) then
    begin
      At := (Length(Result.Namespaces) + 1);
      Insert(string(FXmlDoc.DocumentElement.ChildNodes[Idx].Attributes['name']), Result.Namespaces, At);
    end;
  end;

  if Assigned(FFilter) then
    Result.Namespaces := FFilter(Result);
end;

end.
