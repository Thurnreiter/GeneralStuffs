unit Main.View;

interface

uses
  System.SysUtils,
  System.Classes,
  FMX.Forms,
  FMX.Dialogs,
  FMX.Types,
  FMX.Controls,
  FMX.Controls.Presentation,
  FMX.StdCtrls,
  ShopMessage.Controller.Intf;

type
  TFormMainView = class(TForm)
    FBtnMVCClientController: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FBtnMVCClientControllerClick(Sender: TObject);
  private
    FCtr: IShopMessageController;
  end;

var
  FormMainView: TFormMainView;

implementation

uses
  ShopMessage.Controller;

{$R *.fmx}

procedure TFormMainView.FormCreate(Sender: TObject);
begin
  FCtr := TShopMessageController.Create();
end;

procedure TFormMainView.FormDestroy(Sender: TObject);
begin
  FCtr := nil;
end;

procedure TFormMainView.FBtnMVCClientControllerClick(Sender: TObject);
begin
  FCtr.ShowSelectionForm();
end;

end.
