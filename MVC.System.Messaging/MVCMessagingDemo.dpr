program MVCMessagingDemo;

uses
  System.StartUpCopy,
  FMX.Forms,
  Main.View in 'Main.View.pas' {FormMainView},
  ShowMessage.View in 'ShowMessage.View.pas' {FormShowMessage},
  ShowMessage.View.Intf in 'ShowMessage.View.Intf.pas',
  ShopMessage.Controller in 'ShopMessage.Controller.pas',
  ShopMessage.Controller.Intf in 'ShopMessage.Controller.Intf.pas',
  ShowMessage.Model.Intf in 'ShowMessage.Model.Intf.pas',
  ShowMessage.Model in 'ShowMessage.Model.pas';

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := (DebugHook > 0);
  Application.Initialize;
  Application.CreateForm(TFormMainView, FormMainView);
  Application.Run;
end.
