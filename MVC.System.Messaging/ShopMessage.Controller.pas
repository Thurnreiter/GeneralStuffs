unit ShopMessage.Controller;

interface

uses
  ShopMessage.Controller.Intf,
  ShowMessage.Model.Intf,
  ShowMessage.View.Intf;

{$M+}

type
  TShopMessageController = class(TInterfacedObject, IShopMessageController)
  private
    FView: IShowMessageView;
    FModel: IShopMessageModel;

    procedure ViewBtnCloseClick(Sender: TObject);
    procedure ViewBtnRefreshClick(Sender: TObject);
  public
    constructor Create(); overload;
    constructor Create(AModel: IShopMessageModel; AView: IShowMessageView); overload;
    destructor Destroy(); override;

    procedure ShowSelectionForm();
  end;

{$M-}

implementation

uses
  ShowMessage.Model,
  ShowMessage.View;

{ TShopMessageController }

constructor TShopMessageController.Create();
begin
  //  If we use VCL, then you need an owner. For example like this:
  //  constructor TShopMessageController.Create(AOwner: TComponent);

  Create(TShopMessageModel.Create, TFormShowMessage.Create(nil));
end;

constructor TShopMessageController.Create(AModel: IShopMessageModel; AView: IShowMessageView);
begin
  inherited Create();
  FModel := AModel;

  FView := AView;
  FView
    .OnBtnCloseClick(ViewBtnCloseClick)
    .OnBtnRefreshClick(ViewBtnRefreshClick);
end;

destructor TShopMessageController.Destroy();
begin
  FModel := nil;
  (FView as TFormShowMessage).Free;
  inherited;
end;

procedure TShopMessageController.ShowSelectionForm();
begin
  (FView as TFormShowMessage).Show(); //  If you want, you can use : *.ShowModal();
end;

procedure TShopMessageController.ViewBtnCloseClick(Sender: TObject);
begin
  (FView as TFormShowMessage).Close();
end;

procedure TShopMessageController.ViewBtnRefreshClick(Sender: TObject);
begin
  FModel.Refresh;
end;

end.
