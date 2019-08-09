unit Nathan.Visitor;

interface

{M+}

type
  IZuBesuchendesObjekt = interface;

  IBesucher = interface
    ['{AA48CF5C-F0BD-40D4-B3F0-8789A4893977}']
    procedure Visit(Instance: IZuBesuchendesObjekt);
  end;

  IZuBesuchendesObjekt = interface
    ['{2A5B1541-EFE0-4677-92D9-B8104DF4D0C0}']
    procedure Accept(AVisitor: IBesucher);
  end;



  TZuBesuchendesObjekt = class(TInterfacedObject, IZuBesuchendesObjekt)
  public
    procedure Accept(AVisitor: IBesucher);
  end;

  TBesucher = class(TInterfacedObject, IBesucher)
  public
    procedure Visit(Instance: IZuBesuchendesObjekt);
  end;

  TBesucher001 = class(TInterfacedObject, IBesucher)
  public
    procedure Visit(Instance: IZuBesuchendesObjekt);
  end;

  TBesucher002 = class(TInterfacedObject, IBesucher)
  public
    procedure Visit(Instance: IZuBesuchendesObjekt);
  end;

{M-}

implementation

{ TZuBesuchendesObjekt }

procedure TZuBesuchendesObjekt.Accept(AVisitor: IBesucher);
begin
  AVisitor.Visit(Self);
end;

{ TBesucher }

procedure TBesucher.Visit(Instance: IZuBesuchendesObjekt);
begin
  //  { provide implementation here }
  Writeln(Self.ClassName + '.Visit(): 000');
end;

{ TBesucher001 }

procedure TBesucher001.Visit(Instance: IZuBesuchendesObjekt);
begin
  Writeln(Self.ClassName + '.Visit(): 001');
end;

{ TBesucher002 }

procedure TBesucher002.Visit(Instance: IZuBesuchendesObjekt);
begin
  Writeln(Self.ClassName + '.Visit(): 002');
end;

end.
