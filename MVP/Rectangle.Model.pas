unit Rectangle.Model;

interface

{$M+}

type
  TRectangleModel = class
  strict private
    FLength: Integer;
    FBreadth: Integer;
  public
    property Length: Integer read FLength write FLength;
    property Breadth: Integer read FBreadth write FBreadth;

    function CalulateArea(): Integer;
  end;

{$M-}

implementation

function TRectangleModel.CalulateArea: Integer;
begin
  Result := FLength * FBreadth;
end;

end.
