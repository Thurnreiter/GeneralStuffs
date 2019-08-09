unit Apriori.Items;

interface

{M+}

type
  TItemSet = record
    /// <summary>Product or item name.</summary>
    Item: string;

    /// <summary>Occurrence Total, over all transaction.</summary>
    OccurTotal: Integer;

    /// <summary>Occurrence per transaction. Twice in one transaction, counts as one.</summary>
    OccurPerTransaction: Integer;

    /// <summary>Support value of item.</summary>
    Support: Double;

    /// <summary>List of transaction indexes per item.</summary>
    TransactionIndices: TArray<Integer>;

    constructor Create(AItem: string; AOccurTotal, ATransactionIndices: Integer);
  end;

  TItemSets = record
    Items: TArray<TItemSet>;
    Support: Double;
    IntersectionOfSupport: Integer;
    constructor Create(AItems: TArray<TItemSet>; ASupp: Double = 1);
  end;

  TConfidenceRules = record
    Item: TItemSet;
    Items: TArray<TItemSet>;
    Confidence: Double;
    constructor Create(AItem: TItemSet; AItems: TArray<TItemSet>; AConfidence: Double);
  end;

{M-}

implementation

{ **************************************************************************** }

{ TItemSet }

constructor TItemSet.Create(AItem: string; AOccurTotal, ATransactionIndices: Integer);
begin
  Item := AItem;
  Support := 0.00;
  OccurTotal := AOccurTotal;
  OccurPerTransaction := AOccurTotal;
  TransactionIndices := [ATransactionIndices];
end;

{ **************************************************************************** }

{ TItemSets }

constructor TItemSets.Create(AItems: TArray<TItemSet>; ASupp: Double);
begin
  Items := AItems;
  Support := ASupp;
end;

{ **************************************************************************** }

{ TConfidenceRules }

constructor TConfidenceRules.Create(AItem: TItemSet; AItems: TArray<TItemSet>; AConfidence: Double);
begin
  Item := AItem;
  Items := AItems;
  Confidence := AConfidence;
end;

end.
