program PipesAndFilters;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  FastMM4,
  System.Classes,
  System.SysUtils,
  PipesAndFiltersSample1 in 'PipesAndFiltersSample1.pas',
  PipesAndFiltersSample2 in 'PipesAndFiltersSample2.pas';

var
  //  Inner: TStringList;
  InnerPipeline: IBasePipe<string>;

  PipesAndFilter: IPipesAndFilters<string>;
  PipesAndFilterDS: IPipesAndFilters<string>;
  PipesAndFilterUpper: IPipesAndFilters<string>;
  PipesAndFilterSink: IPipesAndFiltersSink<string>;

  Output: string;
begin
  ReportMemoryLeaksOnShutdown := True;
  //  Inner := TStringList.Create;

  //  First option...
  InnerPipeline := TBasePipe<string>.Create;
  Output := InnerPipeline
    .Register(TStringUpperFilter.Create)
    .Register(TStringLowerFilter.Create)
    .Register(TStringDotsFilter.Create)
    .Register(TStringAddBeginFilter.Create('BEGIN => '))
    .Register(TStringAddEndFilter.Create(' <= END'))
    .Process('HeLLo...');

  Writeln(Output);

  //  Second one option, push scenario over write method. Start from source...
//  PipesAndFilterDS := TPipesAndFiltersSource.Create();
//  PipesAndFilterUpper := TPipesAndFiltersUpper.Create();
//  PipesAndFilterSink := TPipesAndFiltersSink.Create();
//
//  PipesAndFilterDS.Filter := PipesAndFilterUpper;
//  PipesAndFilterUpper.Filter := PipesAndFilterSink;
//
//  PipesAndFilterDS.Write('Start Push =>'); //  Push scenario...
//  Output := PipesAndFilterSink.GetValue;
//  Writeln(Output);


//  PipesAndFilterSink := TPipesAndFiltersSink.Create(nil);
//  PipesAndFilter := TPipesAndFiltersSource
//    .Create(
//      TPipesAndFiltersUpper
//        .Create(PipesAndFilterSink)
//    );
//
//  PipesAndFilter.Write('Start Push =>'); //  Push scenario...
//  Output := PipesAndFilterSink.GetValue;
//  Writeln(Output);



  //  Second two option, pull scenario over read method. Start from sink...
//  PipesAndFilterDS := TPipesAndFiltersSource.Create(nil);
//  PipesAndFilterUpper := TPipesAndFiltersUpper.Create(nil);
//  PipesAndFilterSink := TPipesAndFiltersSink.Create(nil);
//
//  PipesAndFilterUpper.Filter := PipesAndFilterDS;
//  PipesAndFilterSink.Filter := PipesAndFilterUpper;
//
//  PipesAndFilterSink.Read('<= End Pull'); //  Pull scenario...
//  Output := PipesAndFilterSink.GetValue;
//  Writeln(Output);



  //  Third scenario is mixed between push and pull. We start by a filter between source and sink...
  PipesAndFilterDS := TPipesAndFiltersSource.Create(nil);
  PipesAndFilterUpper := TPipesAndFiltersUpper.Create(nil);
  PipesAndFilterSink := TPipesAndFiltersSink.Create(nil);

  PipesAndFilterUpper.Filter := PipesAndFilterDS;
  PipesAndFilterSink.Filter := PipesAndFilterUpper;

  Output := PipesAndFilterUpper.Read('<= Filter Start'); //  Pull scenario...
  Writeln(Output);
  PipesAndFilterSink.Write(Output); //  Push scenario...
  Output := PipesAndFilterSink.GetValue;
  Writeln(Output);

  ReadLn;
end.
