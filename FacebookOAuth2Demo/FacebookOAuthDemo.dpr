program FacebookOAuthDemo;

uses
  Vcl.Forms,
  Form.Main in 'Form.Main.pas' {MainForm};

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := DebugHook <> 0;
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
