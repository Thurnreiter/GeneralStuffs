unit Main.Form;

interface

uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  System.Variants,
  FMX.Types,
  FMX.Controls,
  FMX.Forms,
  FMX.Graphics,
  FMX.Dialogs,
  FMX.Controls.Presentation,
  FMX.ScrollBox,
  FMX.Memo, FMX.StdCtrls, FMX.Effects;

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    BtnStart: TButton;
    BtnStartThread: TButton;
    BtnStartTimerThread: TButton;
    TimerThread: TTimer;
    ShadowEffect1: TShadowEffect;
    procedure BtnStartClick(Sender: TObject);
    procedure BtnStartThreadClick(Sender: TObject);
    procedure BtnStartTimerThreadClick(Sender: TObject);
    procedure TimerThreadTimer(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

uses
  System.IOUtils,
  System.Threading,
  System.Hash;

procedure TForm1.FormCreate(Sender: TObject);
begin
  TimerThread.Enabled := False;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  TimerThread.Enabled := False;
end;

procedure TForm1.BtnStartClick(Sender: TObject);
begin
  Memo1.Lines.Add(THashMD5.GetHashStringFromFile(ParamStr(0)));
end;

procedure TForm1.BtnStartThreadClick(Sender: TObject);
begin
  TTask.Run(
    procedure
    var
      MyHash: string;
    begin
      MyHash := THashMD5.GetHashStringFromFile(ParamStr(0));
      TThread.Synchronize(nil,
        procedure()
        begin
          Memo1.Lines.Add(MyHash);
        end);
    end);
end;

procedure TForm1.BtnStartTimerThreadClick(Sender: TObject);
begin
  //  https://www.thedelphigeek.com/2015/10/updating-progress-bar-from-parallel-for.html

  //  While the parallel code is running, main form must process messages, so we
  //  have to push a TParallel.For into background by wrapping it inside a task.

//  FTask := TTask.Run(
//    procedure
//    var
//      processed: integer; // shared counter
//      total    : integer; // total number of items to be processed
//    begin
//      processed := 0;
//      total := 1000;
//      TParallel.For(1, 1000,
//        procedure (i: integer)
//        var
//          new: integer;
//        begin
//          Sleep(10); //do the work
//          new := TInterlocked.Increment(processed); // increment the shared counter
//          if (new mod 10) = 0 then // update the progress bar every 10 processed items
//            // Even with one reader and one writer accessing an 'integer'
//            // is not atomic!
//            TInterlocked.Exchange(FProgress, Round(new / total * 100));
//        end
//      ); // TParallel.For
//
//      // Disable the timer when everything is processed.
//      TThread.Queue(nil,
//        procedure
//        begin
//          // We have no idea if timer proc 'saw' FProgress = 100 so let's force
//          // the last update.
//          pbParallel.Position := 100;
//          tmrUpdateProgress.Enabled := false;
//          AfterTest;
//        end
//      ); //TThread.Queue
//    end
//  ); // TTask.Run

  TimerThread.Enabled := not TimerThread.Enabled;
end;

procedure TForm1.TimerThreadTimer(Sender: TObject);
begin
  TTask.Run(
    procedure
    var
      MyHash: string;
    begin
      MyHash := THashMD5.GetHashStringFromFile(ParamStr(0));
      TThread.Synchronize(nil,
        procedure()
        begin
          Memo1.Lines.Add(MyHash);
        end);
    end);
end;

end.
