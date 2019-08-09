unit Rectangle.View.Intf;

interface

{$M+}

type
  IRectangleView = interface
    ['{715679CA-5EAE-4951-8C1B-D53621082691}']
    function GetLengthText: string;
    procedure SetLengthText(const AValue: string);

    function GetBreadthText: string;
    procedure SetBreadthText(const AValue: string);

    function GetAreaText: string;
    procedure SetAreaText(const AValue: string);

    property LengthText: string read GetLengthText write SetLengthText;
    property BreadthText: string read GetBreadthText write SetBreadthText;
    property AreaText: string read GetAreaText write SetAreaText;
  end;

{$M-}

implementation

end.
