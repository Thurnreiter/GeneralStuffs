unit Test.FunctionHigherOrder;

interface

uses
  System.SysUtils,
  System.Diagnostics,
  DUnitX.TestFramework,
  Dummy.Form;

type
  [TestFixture]
  THigherOrderTest = class(TObject)
  private
    procedure ExecuteProcessLogGS(const AMainText: string; AWorker: TProc<TProc<string>>;
      ADefaultOptions: TProcessLogOptionsGS = [propHistoryVisible, propMainAreaToHist, propProgressVisible]);
  public
    [Test]
    procedure TestHelperAsASample;
  end;

implementation

uses
  Vcl.Forms;

procedure THigherOrderTest.ExecuteProcessLogGS(
  const AMainText: string;
  AWorker: TProc<TProc<string>>;
  ADefaultOptions: TProcessLogOptionsGS);
var
  DummyForm: TDummyForm;
begin
  DummyForm := TDummyForm.Create(Application.MainForm);
  try
    DummyForm.Options := ADefaultOptions;
    DummyForm.SetMainAreaText(AMainText);
    DummyForm.RunProcess;
//    StartTransaction;
    try
      AWorker(
        procedure(AMsg: string)
        begin
          DummyForm.AddHistoryInfoText(AMsg);
        end);

//      Commit;
    except
      on E: Exception do
      begin
        DummyForm.AddHistoryErrorText('Write error message...');
        DummyForm.AddHistoryErrorText(E.Message);
//        RollbackTrans;
      end;
    end;

    DummyForm.FinishAndDisplayResults;
  finally
    DummyForm.Release;
    FreeAndNil(DummyForm);
  end;
end;

procedure THigherOrderTest.TestHelperAsASample;
var
  InnerEOF: Boolean;
  InnerIdx: Integer;
begin
  //  Arrange...
  InnerEOF := False;
  InnerIdx := 0;

  //  Act...
  ExecuteProcessLogGS(
    'Any caption',
    procedure(AStepMsg: TProc<string>)
    begin
      while not InnerEOF do
      begin
        AStepMsg(Format('%.8d', [InnerIdx]));
        Inc(InnerIdx);

        InnerEOF := (InnerIdx > 1000);
      end;
    end);

  //  Assert...
  Assert.IsTrue(InnerEof);
end;

initialization
  TDUnitX.RegisterTestFixture(THigherOrderTest);

end.
