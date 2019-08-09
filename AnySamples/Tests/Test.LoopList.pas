unit Test.LoopList;

interface

uses
  System.SysUtils,
  System.Generics.Collections,
  DUnitX.TestFramework;

type
  TMyObject = class
  strict private
    FTag: Integer;
  public
    property Tag: Integer read FTag write FTag;
  end;

  //  Tests based on blog article:
  //  https://www.heise.de/developer/artikel/Weg-mit-den-Schleifen-4009774.html?seite=all
  [TestFixture]
  TLoopListTest = class(TObject)
  private
    FActual: TList<TMyObject>;
  public
    [Setup]
    procedure Setup;

    [TearDown]
    procedure TearDown;

    [Test]
    procedure TestLoopList;
  end;

implementation

uses
  System.LoopList;

procedure TLoopListTest.Setup;
begin
  FActual := TList<TMyObject>.Create;
end;

procedure TLoopListTest.TearDown;
begin
  FActual.Free;
end;

procedure TLoopListTest.TestLoopList;
var
  MyObj: TMyObject;
begin
  //  Arrange...
  MyObj := TMyObject.Create;
  MyObj.Tag := 1;
  FActual.Add(MyObj);

  MyObj := TMyObject.Create;
  MyObj.Tag := 2;
  FActual.Add(MyObj);

  //  Act...
  TLoopList.Loop<TMyObject>(FActual,
    procedure(I: Integer; List: TList<TMyObject>)
    begin
      List.Items[I].Tag := List.Items[I].Tag + 100;
    end);

  //  Assert...
  Assert.AreEqual(101, FActual.Items[0].Tag);
  Assert.AreEqual(102, FActual.Items[1].Tag);

  FActual.Items[0].Free;
  FActual.Items[1].Free;
end;


initialization
  TDUnitX.RegisterTestFixture(TLoopListTest);

end.
