unit Nathan.UnitDependencyV2.Service;

interface

uses
  System.SysUtils,
  System.Generics.Collections,
  Nathan.UnitDependencyV2.Dtos,
  Nathan.UnitDependencyV2.Xml.Worker;

{$M+}

type
  INathanUDV2Service = interface
    ['{51F76CC8-3C94-4C9E-8DA7-A127CA039DAB}']
    function SymbolReportFile(): string; overload;
    function SymbolReportFile(const Value: string): INathanUDV2Service; overload;

    function SymbolReportPath(): string; overload;
    function SymbolReportPath(const Value: string): INathanUDV2Service; overload;

    function Worker(): INathanUDV2XmlWorker; overload;
    function Worker(Value: INathanUDV2XmlWorker): INathanUDV2Service; overload;

    function FilteredValues(): TArray<string>; overload;
    function FilteredValues(Value: TArray<string>): INathanUDV2Service; overload;

    function OnProcess(): TProc<string>; overload;
    function OnProcess(Action: TProc<string>): INathanUDV2Service; overload;
    function OnProcess(Action: TProc<TNathanUDV2Dto>): INathanUDV2Service; overload;

    /// <summary>
    ///   List of all unused namespace.
    ///   Same list of all unused namespace, but in json.
    ///   In futur we generate a list of all namespaces with occur.
    /// </summary>
    /// <returns>Return a <c>JSON</c> string.</returns>
    function Execute(): string;

    /// <summary>
    ///   Delete all namespaces in *.pas, where found it over the execute method.
    /// </summary>
    /// <param name="SearchPaths">
    ///   SearchPaths is a string variable, seperated with comma and give
    ///   us the search paths for corresponding *.pas file.
    /// </param>
    /// <returns>Return a <c>JSON</c> string.</returns>
    function Clean(const SearchPaths: string): string;
  end;

  TNathanUDV2Service = class(TInterfacedObject, INathanUDV2Service)
  strict private
    FSymbolReportFile: string;
    FSymbolReportPath: string;
    FWorker: INathanUDV2XmlWorker;
    FFilteredValues: TArray<string>;
    FOnProcess: TProc<string>;
    FOnProcessDto: TProc<TNathanUDV2Dto>;
  private
    function InnerLoop(FuncDelegate: TFunc<string, TNathanUDV2Dto>): TNathanUDV2Dto;
    function ExecuteAsDto(): TNathanUDV2Dtos;
    procedure CleanPasFile(const PasFilename: string; NamespacesToDelete: TArray<string>);
  public
    constructor Create();
    destructor Destroy(); override;

    function SymbolReportFile(): string; overload;
    function SymbolReportFile(const Value: string): INathanUDV2Service; overload;

    function SymbolReportPath(): string; overload;
    function SymbolReportPath(const Value: string): INathanUDV2Service; overload;

    function Worker(): INathanUDV2XmlWorker; overload;
    function Worker(Value: INathanUDV2XmlWorker): INathanUDV2Service; overload;

    function FilteredValues(): TArray<string>; overload;
    function FilteredValues(Value: TArray<string>): INathanUDV2Service; overload;

    function OnProcess(): TProc<string>; overload;
    function OnProcess(Action: TProc<string>): INathanUDV2Service; overload;
    function OnProcess(Action: TProc<TNathanUDV2Dto>): INathanUDV2Service; overload;

    function Execute(): string;

    function Clean(const SearchPaths: string): string;
  end;

{$M-}

implementation

uses
  System.Types,
  System.IOUtils,
  System.Masks,
  System.Generics.Defaults,
  System.RegularExpressions;

{ TNathanUDV2Service }

constructor TNathanUDV2Service.Create;
begin
  inherited;
  Worker(TNathanUDV2XmlWorker.Create);
  FilteredValues(['SysInit']);
end;

destructor TNathanUDV2Service.Destroy;
begin
  //...
  inherited;
end;

function TNathanUDV2Service.SymbolReportPath: string;
begin
  Result := FSymbolReportPath;
end;

function TNathanUDV2Service.SymbolReportFile: string;
begin
  Result := FSymbolReportFile;
end;

function TNathanUDV2Service.SymbolReportFile(const Value: string): INathanUDV2Service;
begin
  FSymbolReportFile := Value;
  Result := Self;
end;

function TNathanUDV2Service.SymbolReportPath(const Value: string): INathanUDV2Service;
begin
  FSymbolReportPath := Value;
  Result := Self;
end;

function TNathanUDV2Service.FilteredValues: TArray<string>;
begin
  Result := FFilteredValues;
end;

function TNathanUDV2Service.FilteredValues(Value: TArray<string>): INathanUDV2Service;
begin
  FFilteredValues := Value;
  Result := Self;
end;

function TNathanUDV2Service.Worker: INathanUDV2XmlWorker;
begin
  Result := FWorker;
end;

function TNathanUDV2Service.Worker(Value: INathanUDV2XmlWorker): INathanUDV2Service;
begin
  FWorker := Value;
  Result := Self;
end;

function TNathanUDV2Service.InnerLoop(FuncDelegate: TFunc<string, TNathanUDV2Dto>): TNathanUDV2Dto;
var
  Each: string;
  Files: TStringDynArray;
begin
  if FSymbolReportFile.IsEmpty then
    Files := TDirectory.GetFiles(FSymbolReportPath, '*.symbol_report')
  else
    Files := TDirectory.GetFiles(TPath.GetDirectoryName(FSymbolReportFile), TPath.GetFileName(FSymbolReportFile));

  for Each in Files do
  begin
    Result := FuncDelegate(Each);
    Result.SymbolFilename := TPath.GetFileName(Each);
    if Assigned(FOnProcess) then
      FOnProcess(Each);

    if Assigned(FOnProcessDto) then
      FOnProcessDto(Result);
  end;
end;

function TNathanUDV2Service.OnProcess: TProc<string>;
begin
  Result := FOnProcess;
end;

function TNathanUDV2Service.OnProcess(Action: TProc<string>): INathanUDV2Service;
begin
  FOnProcess := Action;
  Result := Self;
end;

function TNathanUDV2Service.OnProcess(Action: TProc<TNathanUDV2Dto>): INathanUDV2Service;
begin
  FOnProcessDto := Action;
  Result := Self;
end;

function TNathanUDV2Service.ExecuteAsDto: TNathanUDV2Dtos;
var
  Dtos: TNathanUDV2Dtos;
  InnerFilteredValues: TArray<string>;
begin
  InnerFilteredValues := FilteredValues;
  Worker.Filter(
    function (value: TNathanUDV2Dto): TArray<string>
    var
      Idx: Integer;
      IdxFind: Integer;
      IdxDelete: Integer;
//      Comparer: IComparer<string>;
    begin
      //  Here filter "System" symbols...
      Result := value.Namespaces;
//      Comparer := TComparer<string>.Default;

//      Comparer := TDelegatedComparer<String>.Create(
//        function(const Left, Right: String): Integer
//        begin
//          Result := Left.ToInteger - Right.ToInteger;
//          Result := -1;
//        end);

      if (High(InnerFilteredValues) > -1) then
        for Idx := Low(InnerFilteredValues) to High(InnerFilteredValues) do
        begin
          IdxDelete := -1;
          for IdxFind := Low(Result) to High(Result) do
          begin
//            if (Comparer.Compare(Result[IdxFind], InnerFilteredValues[Idx]) = 0) then
            if TRegEx.IsMatch(Result[IdxFind], InnerFilteredValues[Idx]) then
            begin
              IdxDelete := IdxFind;
              Break;
            end;
          end;

          if (IdxDelete > -1) then
            Delete(Result, IdxDelete, 1);
        end;
    end);

  InnerLoop(
    function (Each: string): TNathanUDV2Dto
    var
      At: Integer;
      Dto: TNathanUDV2Dto;
    begin
      Worker.Xml(TFile.ReadAllText(Each));
      Dto := Worker.Execute;
      if (Length(Dto.Namespaces) > 0) then
      begin
        Dto.SymbolFilename := TPath.GetFileName(Each);

        At := (Length(Dtos.List) + 1);
        Insert(Dto, Dtos.List, At);
      end;
    end);

  if FSymbolReportFile.IsEmpty then
    Dtos.Path := SymbolReportPath
  else
    Dtos.Path := TPath.GetDirectoryName(FSymbolReportFile);

  Result := Dtos;
end;

function TNathanUDV2Service.Execute: string;
begin
  Result := ExecuteAsDto.ToJson;
end;

function TNathanUDV2Service.Clean(const SearchPaths: string): string;
var
  IdxPas: Integer;
  EachDir: string;
  InnerDirectories: TArray<string>;
  PasFile: TStringDynArray;
begin
  if SearchPaths.IsEmpty then
    Exit('{}');

  InnerDirectories := SearchPaths.Split([',', ';']);

  for IdxPas := Low(ExecuteAsDto.List) to High(ExecuteAsDto.List) do
  begin
    for EachDir in InnerDirectories do
    begin
      if TDirectory.Exists(EachDir) then
        PasFile := TDirectory.GetFiles(EachDir, ExecuteAsDto.List[IdxPas].PossiblyRelevantPasName);

      if (Length(PasFile) > 0) then
      begin
        CleanPasFile(PasFile[0], ExecuteAsDto.List[IdxPas].Namespaces); //  We just take only the first one...
        Break;
      end;
    end;
  end;

  Result := ExecuteAsDto.ToJson;
end;

procedure TNathanUDV2Service.CleanPasFile;
var
  Idx: Integer;
  PasContent: string;
  Pattern: string;
//  Matches: TMatchCollection;
//  Match: TMatch;
//  MatchCount: Integer;
//  TextInternal: string;
begin
//  Matches := TRegEx.Matches(Unit1_pas, '(\bSystem.SysUtils\.*[,])', [roNotEmpty, roIgnoreCase]);
//  MatchCount := Matches.Count;
//  if (MatchCount > 0) then
//  begin
//    for Match in Matches do
//    begin
////      Match.Index
////      Match.Length
//    end;
//  end;
//  TextInternal := TRegEx.Replace(Unit1_pas, '(\bSystem.SysUtils\.*[,])', '');

  if (not TFile.Exists(PasFilename)) then
    Exit;

  PasContent := TFile.ReadAllText(PasFilename);
  for Idx := Low(NamespacesToDelete) to High(NamespacesToDelete) do
  begin
//    Pattern := Format('(\b%s\.*[,])', [NamespacesToDelete[Idx]]);
//    Pattern := Format('(\bSystem.ImageList\.*[,])|(\bSystem.ImageList\.*[;])', [NamespacesToDelete[Idx]]);
//    PasContent := TRegEx.Replace(PasContent, '(\bSystem.SysUtils\.*[,])', '');
    Pattern := Format('(\b%0:s\.*[,])|(\b%0:s\.*[;])', [NamespacesToDelete[Idx]]);
    PasContent := TRegEx.Replace(PasContent, Pattern, '', [roNotEmpty, roIgnoreCase]);
  end;

  TFile.WriteAllText(PasFilename, PasContent);
end;

end.
