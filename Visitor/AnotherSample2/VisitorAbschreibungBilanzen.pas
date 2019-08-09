unit VisitorAbschreibungBilanzen;

interface

{M+}

type
  TVisitor = class;

  TBilanzposten = class
  strict private
    FWert: Double;
  public
    procedure Accept(AVisitor: TVisitor); virtual; abstract;

    property Wert: Double read FWert write FWert;
  end;


  TGebaeude = class(TBilanzposten)
  public
    procedure Accept(AVisitor: TVisitor); override;
  end;

  TFahrzeug = class(TBilanzposten)
  public
    procedure Accept(AVisitor: TVisitor); override;
  end;


  TVisitor = class
  public
    procedure Visit(Fahrzeug: TFahrzeug); overload; virtual; abstract;
    procedure Visit(Gebaeude: TGebaeude); overload; virtual; abstract;
  end;

  TAbscheibung = class(TVisitor)
  public
    procedure Visit(Fahrzeug: TFahrzeug); overload; override;
    procedure Visit(Gebaeude: TGebaeude); overload; override;
  end;

  TBilanzsumme = class(TVisitor)
  strict private
    FSumme: Double;
  public
    procedure Visit(Fahrzeug: TFahrzeug); overload; override;
    procedure Visit(Gebaeude: TGebaeude); overload; override;

    property Summe: Double read FSumme write FSumme;
  end;

{M+}

implementation

{ TGebaeude }

procedure TGebaeude.Accept(AVisitor: TVisitor);
begin
  AVisitor.Visit(Self);
end;

{ TFahrzeug }

procedure TFahrzeug.Accept(AVisitor: TVisitor);
begin
  AVisitor.Visit(Self);
end;

{ TAbscheibung }

procedure TAbscheibung.Visit(Fahrzeug: TFahrzeug);
begin
  Fahrzeug.Wert := Fahrzeug.Wert * 0.9;
end;

procedure TAbscheibung.Visit(Gebaeude: TGebaeude);
begin
  Gebaeude.Wert := Gebaeude.Wert * 0.75;
end;

{ TBilanzsumme }

procedure TBilanzsumme.Visit(Fahrzeug: TFahrzeug);
begin
  FSumme := FSumme + Fahrzeug.Wert;
end;

procedure TBilanzsumme.Visit(Gebaeude: TGebaeude);
begin
  FSumme := FSumme + Gebaeude.Wert;
end;

end.
