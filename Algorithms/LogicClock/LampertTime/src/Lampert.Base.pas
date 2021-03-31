unit Lampert.Base;

interface

uses
  System.SysUtils;

type
  ILamportLogicalClock = interface(IInvokable)
    ['{704D0936-21FA-402B-9409-F43D759D84AE}']
    function Clock(): Integer; overload;
    function Clock(AValue: Integer): ILamportLogicalClock; overload;

    procedure Send(AWorker: TProc);
    procedure Receive(ASenderClock: Integer; AWorker: TProc);
  end;

  TLamportLogicalClock = class(TInterfacedObject, ILamportLogicalClock)
  strict private
    //  FSubscriptionId: Integer;
    FClock: Integer;
  public
    constructor Create;
    destructor Destroy; override;

    function Clock(): Integer; overload;
    function Clock(AValue: Integer): IlamportLogicalClock; overload;

    procedure Send(AWorker: TProc); virtual;
    procedure Receive(ASenderClock: Integer; AWorker: TProc); virtual;
  end;

implementation

uses
  System.Math,
  System.Messaging;

{ TLamportLogicalClock }

constructor TLamportLogicalClock.Create;
begin
  inherited Create;
  FClock := 0;

  //  First consideration or variant.
  //  Next step, will be with the TVirtualMethodInterceptor class.

  //  FSubscriptionId := TMessageManager.DefaultManager.SubscribeToMessage(TMessage<Integer>,
  //    procedure(const Sender: TObject; const AMessage: TMessage)
  //    begin
  //      if (AMessage as TMessage<Integer>).Value then
  //        LoadImage();
  //      //FClock := InterlockedIncrement(AMessage as TMessage<Integer>).Value);
  //      FClock := AtomicIncrement(AMessage as TMessage<Integer>).Value);
  //      //TInterlocked.Increment(AMessage as TMessage<Integer>).Value);
  //    end);
end;

destructor TLamportLogicalClock.Destroy;
begin
  //  TMessageManager.DefaultManager.Unsubscribe(TMessage<Integer>, FSubscriptionId, False);

  inherited;
end;

function TLamportLogicalClock.Clock(AValue: Integer): IlamportLogicalClock;
begin
  FClock := AValue;
end;

function TLamportLogicalClock.Clock: Integer;
begin
  Result := FClock;
end;

procedure TLamportLogicalClock.Send(AWorker: TProc);
begin
  inherited;

  //  TMessageManager.DefaultManager.SendMessage(Self, TMessage<Integer>.Create(FClock));

  try
    if Assigned(AWorker) then
      AWorker();
  finally
    Inc(FClock);
  end;
end;

procedure TLamportLogicalClock.Receive(ASenderClock: Integer; AWorker: TProc);
begin
  inherited;

  try
    if Assigned(AWorker) then
      AWorker();
  finally
    FClock := Max(ASenderClock, FClock) + 1;
  end;
end;

end.
