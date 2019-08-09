unit ShowMessage.View;

interface

uses
  System.SysUtils,
  System.Classes,
  FMX.Dialogs,
  FMX.Types,
  FMX.Controls,
  FMX.Forms,
  FMX.StdCtrls,
  FMX.Controls.Presentation,
  FMX.ScrollBox,
  FMX.Memo,
  ShowMessage.View.Intf;

type
  TFormShowMessage = class(TForm, IShowMessageView)
    Memo1: TMemo;
    Label1: TLabel;
    ButtonClose: TButton;
    ButtonRefresh: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  strict private
    FSubscriptionId: Integer;
  private
    function OnBtnCloseClick(AValue: TNotifyEvent): IShowMessageView;
    function OnBtnRefreshClick(AValue: TNotifyEvent): IShowMessageView;
  end;

var
  FormShowMessage: TFormShowMessage;

implementation

uses
  System.Messaging;

{$R *.fmx}

{ TFormShowMessage }

procedure TFormShowMessage.FormCreate(Sender: TObject);
begin
  FSubscriptionId := TMessageManager.DefaultManager.SubscribeToMessage(TMessage<String>,
    procedure(const Sender: TObject; const AMessage: TMessage)
    begin
      Memo1.Lines.Add((AMessage as TMessage<String>).Value);
    end);
end;

procedure TFormShowMessage.FormDestroy(Sender: TObject);
begin
  TMessageManager.DefaultManager.Unsubscribe(TMessage<String>, FSubscriptionId, False);
end;

function TFormShowMessage.OnBtnCloseClick(AValue: TNotifyEvent): IShowMessageView;
begin
  ButtonClose.OnClick := AValue;
  Result := Self;
end;

function TFormShowMessage.OnBtnRefreshClick(AValue: TNotifyEvent): IShowMessageView;
begin
  ButtonRefresh.OnClick := AValue;
  Result := Self;
end;

end.
