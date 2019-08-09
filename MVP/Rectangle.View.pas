unit Rectangle.View;

interface

uses
  System.SysUtils,
  System.Classes,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.Controls,
  Vcl.StdCtrls,
  Rectangle.View.Intf;

type
  TFormRectangleView = class(TForm, IRectangleView)
    Label1: TLabel;
    EditLength: TEdit;
    Label2: TLabel;
    EditBreadth: TEdit;
    Button1: TButton;
    LabelResult: TLabel;
    procedure Button1Click(Sender: TObject);
  private
    function GetLengthText: string;
    procedure SetLengthText(const AValue: string);

    function GetBreadthText: string;
    procedure SetBreadthText(const AValue: string);

    function GetAreaText: string;
    procedure SetAreaText(const AValue: string);
  end;

var
  FormRectangleView: TFormRectangleView;

implementation

uses
  Rectangle.Presenter;

{$R *.dfm}

{ TFormRectangleView }


function TFormRectangleView.GetLengthText: string;
begin
  Result := EditLength.Text;
end;

procedure TFormRectangleView.SetLengthText(const AValue: string);
begin
  EditLength.Text := AValue;
end;


function TFormRectangleView.GetBreadthText: string;
begin
  Result := EditBreadth.Text;
end;

procedure TFormRectangleView.SetBreadthText(const AValue: string);
begin
  EditBreadth.Text := AValue;
end;


procedure TFormRectangleView.SetAreaText(const AValue: string);
begin
  LabelResult.Caption := AValue + ' Sq CM';
end;

function TFormRectangleView.GetAreaText: string;
begin
  Result := LabelResult.Caption;
end;


procedure TFormRectangleView.Button1Click(Sender: TObject);
var
  RectanglePresenter: TRectanglePresenter;
begin
  RectanglePresenter := TRectanglePresenter.Create(Self);
  try
    RectanglePresenter.CalulateArea;
  finally
    RectanglePresenter.Free;
  end;
end;

end.
