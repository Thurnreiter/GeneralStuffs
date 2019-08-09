unit Dummy.Form;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TProcessLogOptionGS = (propSubAreaVisible,
                         propAVIVisible,
                         propProgressVisible,
                         propHistoryVisible,
                         propMainAreaToHist,
                         propSubAreaToHist,
                         propNoStartEndProcessToHist,
                         propCanCancel,
                         propFormWidthToAVI,
                         propFixedHistoryFont,
                         propSaveHistoryNoDateTime,
                         propStayOnTop,
                         propNeverGetModal,
                         propLogWithoutForm,
                         propLockBackgroundWindows);

  TProcessLogOptionsGS = set of TProcessLogOptionGS;

  TDummyForm = class(TForm)
    Memo1: TMemo;
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
    Options: TProcessLogOptionsGS;
    procedure SetMainAreaText(const AMainText: string);
    procedure RunProcess;
    procedure AddHistoryInfoText(const ALog: string);
    procedure AddHistoryErrorText(const ALog: string);
    procedure FinishAndDisplayResults();
  end;

var
  DummyForm: TDummyForm;

implementation

{$R *.dfm}

{ TDummyForm }

procedure TDummyForm.AddHistoryErrorText(const ALog: string);
begin
  AddHistoryInfoText(ALog);
end;

procedure TDummyForm.AddHistoryInfoText(const ALog: string);
begin
  Memo1.Lines.Add(ALog);
end;

procedure TDummyForm.FinishAndDisplayResults;
begin

end;

procedure TDummyForm.RunProcess;
begin
  Show;
end;

procedure TDummyForm.SetMainAreaText(const AMainText: string);
begin
  Caption := AMainText;
end;

end.
