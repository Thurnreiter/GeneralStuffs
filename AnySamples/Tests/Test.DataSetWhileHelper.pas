unit Test.DataSetWhileHelper;

interface

uses
  System.SysUtils,
  Data.DB,
  Datasnap.DBClient,
  DUnitX.TestFramework;

type
  //  Sample based on:
  //  https://github.com/amarildolacerda/helpers/blob/master/Data.DB.Helper.pas
  //  http://www.tireideletra.com.br/?p=81
  TDatasetHelper = class helper for TDataset
  public
    procedure DoLoop(AEvent: TProc); overload;
    procedure DoLoop(AEvent: TProc<TDataset>); overload;
  end;

  [TestFixture]
  THelperDataSetTest = class(TObject)
  private
    FClientDataSet: TClientDataSet;
  public
    [Setup]
    procedure Setup;

    [TearDown]
    procedure TearDown;

    [Test]
    procedure TestHelperAsASample;
  end;

implementation

uses
  System.Classes;

{ TDatasetHelper }

procedure TDatasetHelper.DoLoop(AEvent: TProc);
begin
  DoLoop(procedure(ds: TDataSet)
    begin
      AEvent;
    end);
end;

procedure TDatasetHelper.DoLoop(AEvent: TProc<TDataset>);
//var
//  book: TBookMark;
begin
  //  book := GetBookmark;
  try
    Self.DisableControls;
    Self.First;
    while not Self.Eof do
    begin
      AEvent(Self);
      Self.Next;
    end;
  finally
    //  Self.GotoBookmark(book);
    //  Self.FreeBookmark(book);
    Self.EnableControls;
  end;
end;

{ THelperDataSetTest }

procedure THelperDataSetTest.Setup;
var
  SS: TStringStream;
begin
  SS := TStringStream.Create('Nathan Chanan Thurnreiter');
  try
    FClientDataSet := TClientDataSet.Create(nil); //  TClientDataSet.Create(Application);
    FClientDataSet.FieldDefs.Clear();
    //  FClientDataSet.FieldDefs.Add('DataBlob', ftBlob);
    //  FClientDataSet.FieldDefs.Add('DataInt', ftInteger, 0);
    FClientDataSet.FieldDefs.Add('DataString', ftString, 35);

    //  FClientDataSet.FieldDefs.Items[0].CreateField(FClientDataSet);
    FClientDataSet.Active := False;
    FClientDataSet.CreateDataSet();
    FClientDataSet.Active := True;
    FClientDataSet.First();
    while not FClientDataSet.Eof do
      FClientDataSet.Delete();

    FClientDataSet.Append();
    //  FClientDataSet.FieldByName('DataInt').AsInteger := 4711;
    //  TBlobField(FClientDataSet.FieldByName('Data')).LoadFromStream(SS);
    FClientDataSet.FieldByName('DataString').AsString := 'Nathan Chanan Thurnreiter';
    FClientDataSet.Post();
  finally
    SS.Free;
  end;
end;

procedure THelperDataSetTest.TearDown;
begin
  FClientDataSet.Active := False;
  FClientDataSet.FieldDefs.Clear();
  FClientDataSet.Free();
end;

procedure THelperDataSetTest.TestHelperAsASample;
var
  InnerLoop: Boolean;
begin
  //  Arrange...
  InnerLoop := False;

  //  Act...

  //  Old style stuff...
  //  FClientDataSet.First();
  //  while (not FClientDataSet.Eof) do
  //  begin
  //    FClientDataSet.Next();
  //  end;

  //  FClientDataSet.DoLoop(
  //    procedure
  //    begin
  //      InnerLoop := True;
  //    end);

  FClientDataSet.DoLoop(
    procedure(ADataset: TDataSet)
    begin
      InnerLoop := (ADataset.FieldByName('DataString').AsString.Length > 0);
    end);

  //  Assert...
  Assert.IsTrue(InnerLoop);
end;

initialization
  TDUnitX.RegisterTestFixture(THelperDataSetTest);

end.
