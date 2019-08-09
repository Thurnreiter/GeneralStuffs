unit Apriori.Confidence;

interface

uses
  Apriori.Items;

{M+}

type
  /// <summary>Calculation the confidence of any rules.
  ///   Confidence(A=>B) = (Transactions containing both (A and B))/(Transactions containing A)
  /// </summary>
  TAprioriConfidence = record
  public
    class function AssociationRule(AItemSets: TItemSets; AToItems: TItemSet): Double; overload; static; {$IFNDEF DEBUG}inline;{$ENDIF}
    class function AssociationRule(AItemSets: TItemSets; AToItems: TItemSet; AUseOccurPerTransaction: Boolean): Double; overload; static; {$IFNDEF DEBUG}inline;{$ENDIF}
  end;

  AprioriConfidence = TAprioriConfidence;

{M-}

implementation

{ TAprioriConfidence }

class function TAprioriConfidence.AssociationRule(AItemSets: TItemSets; AToItems: TItemSet): Double;
begin
  Result := ((AItemSets.IntersectionOfSupport / AToItems.OccurTotal) * 100);
end;

class function TAprioriConfidence.AssociationRule(AItemSets: TItemSets; AToItems: TItemSet; AUseOccurPerTransaction: Boolean): Double;
begin
  if AUseOccurPerTransaction then
    Result := ((AItemSets.IntersectionOfSupport / AToItems.OccurPerTransaction) * 100)
  else
    Result := AssociationRule(AItemSets, AToItems);
end;

end.
