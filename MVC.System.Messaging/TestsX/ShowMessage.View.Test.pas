unit ShowMessage.View.Test;

interface

uses
  System.UITypes,
  DUnitX.TestFramework,
  ShowMessage.View.Intf;

type

  [TestFixture]
  TMyTestObject = class(TObject)
  strict private
    FSut: IShowMessageView;
  private
    procedure TestFormClose(Sender: TObject; var Action: TCloseAction);
  public
    [Setup]
    procedure Setup;

    [TearDown]
    procedure TearDown;

    [Test]
    procedure Test;
  end;

implementation

uses
  System.SysUtils,
  System.Messaging,
  ShowMessage.View;

procedure TMyTestObject.Setup;
begin
  FSut := TFormShowMessage.Create(nil);
  (FSut as TFormShowMessage).OnClose := TestFormClose;
end;

procedure TMyTestObject.TearDown;
begin
  (FSut as TFormShowMessage).Close();
  (FSut as TFormShowMessage).Free;
end;

procedure TMyTestObject.TestFormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := TCloseAction.caFree;
end;

procedure TMyTestObject.Test;
begin
  TMessageManager.DefaultManager.SendMessage(Self, TMessage<String>.Create(TimeToStr(Now)));
  Assert.IsTrue(1 = 1);
end;

initialization
  TDUnitX.RegisterTestFixture(TMyTestObject);

end.
