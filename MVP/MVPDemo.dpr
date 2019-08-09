program MVPDemo;

uses
  Vcl.Forms,
  Rectangle.Model in 'Rectangle.Model.pas',
  Rectangle.View.Intf in 'Rectangle.View.Intf.pas',
  Rectangle.Presenter in 'Rectangle.Presenter.pas',
  Rectangle.View in 'Rectangle.View.pas' {FormRectangleView};

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := True;
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFormRectangleView, FormRectangleView);
  Application.Run;
end.
