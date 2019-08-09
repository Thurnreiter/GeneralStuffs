unit Apriori.Lift;

interface

uses
  Apriori.Items;

{M+}

type
  TAprioriLift = record
  public
    class function AssociationRule(AItemSets: TItemSets; AToItems: TItemSet): Double; static; inline;
  end;

  AprioriLift = TAprioriLift;

{M-}

implementation

{ TAprioriLift }

class function TAprioriLift.AssociationRule(AItemSets: TItemSets; AToItems: TItemSet): Double;
begin
  Result := 0.00; //  under construction...
end;

end.
