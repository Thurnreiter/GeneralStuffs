unit Rectangle.Presenter;

interface

uses
  Rectangle.View.Intf,
  Rectangle.Model;

{$M+}

type
  TRectanglePresenter = class
  strict private
    FRectangleView: IRectangleView;
  public
    constructor Create(ARectangleView: IRectangleView);

    procedure CalulateArea();
  end;

{$M-}

implementation

uses
  System.SysUtils;

{ TRectanglePresenter }

constructor TRectanglePresenter.Create(ARectangleView: IRectangleView);
begin
  inherited Create();
  FRectangleView := ARectangleView;
end;

procedure TRectanglePresenter.CalulateArea;
var
  RectangleModel: TRectangleModel;
begin
  RectangleModel := TRectangleModel.Create();
  try
    RectangleModel.Length := FRectangleView.LengthText.ToInteger();
    RectangleModel.Breadth := FRectangleView.BreadthText.ToInteger();

    FRectangleView.AreaText := RectangleModel.CalulateArea.ToString;
  finally
    RectangleModel.Free;
  end;
end;

end.
