unit ShowMessage.Model;

interface

uses
  ShowMessage.Model.Intf;

{$M+}

type
  TShopMessageModel = class(TInterfacedObject, IShopMessageModel)
  public
    procedure Refresh();
  end;

{$M-}

implementation

uses
  System.Classes,
  System.SysUtils,
  System.Threading,
  System.Messaging;

{ TShopMessageModel }

procedure TShopMessageModel.Refresh;
begin
  //  We can do anything...
  TTask.Run(
    procedure
    begin
      //  TThread.Synchronize vs Queue:
      //    Synchronize() versucht sofort auf den Mainthread zuzugreifen
      //    während Queue() ein Idle abwartet. Synchronize tendenziell eher Deadlocks!
      //    nil anstatt TThread.CurrentThread weil wir auf den Mainthread zurücksychronisieren wollen..
      TThread.Synchronize(nil,
        Procedure()
        begin
          TMessageManager.DefaultManager.SendMessage(Self, TMessage<String>.Create(TimeToStr(Now)));
        end);

      TThread.Queue(nil,
        Procedure()
        begin
          TMessageManager.DefaultManager.SendMessage(Self, TMessage<String>.Create('Next step...'));
        end);
    end);
end;

end.
