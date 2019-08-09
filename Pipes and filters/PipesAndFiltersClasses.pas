unit PipesAndFiltersClasses;

interface

uses
  System.Classes,
  System.SysUtils;

type
  TFilter = class
    //  Get input data...
    //  Performs a function on its input data...
    //  Supplies outpput data...

    //  Collaborators: Pipe
  end;

  TPipe = class
    //  Transfers data
    //  Duffers data
    //  Synchronizes active neighbors

    //  Collaborators: Data Source, Data Sink, Filter
  end;

  TDataSource = class
    //  Delivers input to processing pieline

    //  Collaborators: Pipe
  end;

  TDataSink = class
    //  Consumes output...

    //  Collaborators: Pipe
  end;


  //  Passive Filter:

  //  Push pipeline: DataSource -> write -> Filter1 -> write -> Filter2 -> write -> DataSink ...
  //  Hier wird per write die Daten vom DataSource durch alle Filter an die DataSink geschoben.

  //  Pull pipeline: Filter1 -> read -> DataSource ...
  //  Hier holt sich die DataSink die Daten von allen vorherigen Filtern bis zum DataSource.



  //  Active Filter: Push/pull pipeline


  TAnyDataStream = class   //  Daten für den Datenstrom...
  strict private
    FText: string;
  public
    property Text: string read FText write FText;
  end;

  TAnyPipe = class
  private
    FOnReceive: TNotifyEvent;
  public
    property OnNewData: TNotifyEvent read FOnReceive write FOnReceive;

    procedure Write(AData: TAnyDataStream); virtual; abstract;
    procedure Read(AData: TAnyDataStream); virtual; abstract;
    procedure Clear; virtual; abstract;
  end;

  TAnyFilter = class
  private
    FIn: TAnyDataStream;  //  Hier kommt der Input her; wird über OnNewData erkannt...
    FOut: TAnyDataStream; //  Ausgabe-Datenstrom...
  public
    constructor Create(AIn: TAnyDataStream); // der Konstruktor legt den Eingabedatenstrom fest

    procedure Reset; virtual; // das setzt den Filter (der kann ja zustandsbehaftet sein) wieder in den Ausgangszustand zurück

    property &Out: TAnyDataStream read FOut; // auf Out darf man lesend zugreifen, damit man aus der Pipe lesen kann
  end;


  TDataSource1 = class(TAnyFilter)
  end;

  TDataSink1 = class(TAnyFilter)
  end;

  //  // und so baut man die einzelnen Filter zusammen:
  //  dataSource := TDataSourceFilter.Create;
  //  filter1 := TAnyFilter.Create(dataSource.Out);
  //  filter2 := TAnyFilter.Create(filter1.Out);
  //  dataSink := TSomeDataSink.Create(filter2.Out);
  //
  //
  //  procedure TSomePipe.Read(AData: TSomeData);
  //  begin
  //    ...
  //    AData.Assign(data); // Assign kopiert die Daten in das übergebene Objekt
  //    data.Free; // eigenes Objekt freigeben
  //  end;


implementation

{ **************************************************************************** }

{ TAnyPipe }

{ **************************************************************************** }

{ TAnyFilter }

constructor TAnyFilter.Create(AIn: TAnyDataStream);
begin
  inherited Create();
end;

procedure TAnyFilter.Reset;
begin
  //...
end;

end.
