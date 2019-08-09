program VisitorPattern;

//  Another cool code from Stefan Glienke:
//  https://bitbucket.org/snippets/sglienke/A8kRL/visitor-pattern-dynamic

{$APPTYPE CONSOLE}

uses
  Generics.Collections,
  SysUtils;

type
  TAction<T> = reference to procedure(const obj: T);

  IVisitor = interface
    procedure Visit(const value: TObject);
  end;

  IVisitorRegistry = interface(IVisitor)
    procedure RegisterVisitor(cls: TClass; const action: TAction<TObject>);
  end;

  TVisitorRegistry = class(TInterfacedObject, IVisitor, IVisitorRegistry)
  private
    fVisitors: TDictionary<TClass,TAction<TObject>>;
  public
    constructor Create;
    destructor Destroy; override;

    procedure RegisterVisitor(cls: TClass; const action: TAction<TObject>);
    procedure Visit(const value: TObject);
  end;

{ TVisitorRegistry }

constructor TVisitorRegistry.Create;
begin
  inherited Create;
  fVisitors := TDictionary<TClass,TAction<TObject>>.Create;
end;

destructor TVisitorRegistry.Destroy;
begin
  fVisitors.Free;
  inherited;
end;

procedure TVisitorRegistry.RegisterVisitor(cls: TClass; const action: TAction<TObject>);
begin
  fVisitors.Add(cls, action);
end;

procedure TVisitorRegistry.Visit(const value: TObject);
var
  cls: TClass;
  action: TAction<TObject>;
begin
  cls := value.ClassType;
  repeat
    if fVisitors.TryGetValue(cls, action) then
    begin
      action(value);
      Break;
    end;
    cls := cls.ClassParent;
  until cls = nil;
end;

type
  TFoo = class
  end;

  TBar = class
  end;

  TFooBar = class(TBar)
  end;

var
  visitor: IVisitorRegistry;
  foo: TFoo;
  bar: TBar;
  fooBar: TFooBar;
begin
  visitor := TVisitorRegistry.Create;
  visitor.RegisterVisitor(TFoo, TAction<TObject>(procedure(const x: TFoo) begin Writeln(x.ClassName) end));
  visitor.RegisterVisitor(TBar, TAction<TObject>(procedure(const x: TBar) begin Writeln(x.ClassName) end));

  foo := TFoo.Create;
  bar := TBar.Create;
  visitor.Visit(foo);
  visitor.Visit(bar);

  fooBar := TFooBar.Create;
  visitor.Visit(fooBar);

  Readln;
end.
