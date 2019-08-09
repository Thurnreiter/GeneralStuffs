unit Test.Data;

interface

{M+}

type
  TTestData = record
    ID: string;
    Items: TArray<string>;

    constructor Create(AID: string; AItems: TArray<string>);
  end;

{M+}

implementation

{ TTestData }

constructor TTestData.Create(AID: string; AItems: TArray<string>);
begin
  ID := AID;
  Items := AItems;
end;

end.
