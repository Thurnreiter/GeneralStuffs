unit ShowMessage.View.Intf;

interface

uses
  System.Classes;

{$M+}

type
  IShowMessageView = interface
    ['{DC2A2709-4B2E-4FF7-82C1-CB36AF77A643}']
    function OnBtnCloseClick(AValue: TNotifyEvent): IShowMessageView;
    function OnBtnRefreshClick(AValue: TNotifyEvent): IShowMessageView;
  end;

{$M-}

implementation

end.
