unit Nathan.Sorting;

interface

uses
  System.Types;

{$M+}

type
  TSorting = record
    {$REGION 'Description and Links to Counting Sort'}
    //  Bitte beachten, Counting Sort ist nur für abzählbare endliche Mengen anwendbar.
    //  Der Algorithmus ist einer der wenigen welcher nicht vergleicht, sondern vorkommen
    //  zählt und in ein gleich grosses Array ablegt. Speicherverbrauch beachten.
    //  Counting Sort ist bei Listen mit kleinen Werten und häufigen Vorkommen schnell.
    //
    //  Links:
    //    https://www.proggen.org/doku.php?id=algo:countingsort
    //    https://de.wikipedia.org/wiki/Countingsort
    //    https://stackoverflow.com/questions/33666488/how-to-make-generic-counting-sort-method
    //    https://rosettacode.org/wiki/Sorting_algorithms/Counting_sort#Pascal
    //    http://algorithms.tutorialhorizon.com/counting-sort/
    //
    //  Beispiel:
    //  9, 4, 10, 8, 2, 4  Unsorted Values.
    //
    //  Min = 2, Max = 10 kleinster bzw. grösster Wert berrechnen.
    //
    //  [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10] Array von 0 bis Max. Index.
    //  [0, 0, 1, 0, 2, 0, 0, 0, 1, 1, 1]  Anzahl vorkommen. Count oder Value der Elemente.
    //
    //  [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10] Noch einmal zur Erinnerung.
    //  [0, 0, 1, 0, 2, 0, 0, 0, 1, 1, 1]  Anzahl vorkommen "ausmultipizieren".
    //   0, 0, 2, 0,
    //               4, 4
    //                  0, 0, 0, 8, 9, 10
    //
    //  Ergibt folgende Reihenfolge, nachdem die Nullen entfernt wurden:
    //  2, 4, 4, 8, 9, 10
    //  9, 4, 10, 8, 2, 4  Unsorted Values. Zu Vergleich noch einmal.
    {$ENDREGION}
    class procedure CountingSort(ListOfInteger: TIntegerDynArray; Ascending: Boolean = True); static; inline;
    class function CountingSort2(InputOfInteger: TIntegerDynArray): TIntegerDynArray; static; inline;

    {$REGION 'Description and Links to Merge Sort'}
    //  This is an attempt to implement the sorting process Mergesort in Delphi, with regard to "External Merge".
    //
    //  Links:
    //    https://en.m.wikipedia.org/wiki/External_sorting
    //    http://www.iti.fh-flensburg.de/lang/algorithmen/sortieren/merge/externalmerge.htm
    //    https://de.wikipedia.org/wiki/Mergesort
    //    http://www.delphipraxis.net/56669-mergesort-quellcode.html
    //    http://www.delphipraxis.net/166903-mergesort-implementation-optimierungsbedraf.html
    //    http://www.iti.fh-flensburg.de/lang/algorithmen/sortieren/merge/merge.htm
    //    https://www.youtube.com/watch?v=EeQ8pwjQxTM
    //    http://www.algorithmist.com/index.php/Merge_sort
    //
    //    Mergesort3 comes from forum www.delphipraxis.net and serves as a reference.
    {$ENDREGION}
    class procedure Mergesort(StartToSort, EndToSort: Integer; InputOfInteger: TIntegerDynArray); static; inline;
    class procedure Merge(StartToSort, EndToSort: Integer; InputOfInteger: TIntegerDynArray); static; inline;
    class procedure Mergesort3(StartSort, EndSort: Integer; IntArray: TIntegerDynArray); static;
  end;

{$M-}

implementation

uses
  System.Threading,
  System.Math;

class procedure TSorting.CountingSort(ListOfInteger: TIntegerDynArray; Ascending: Boolean);
var
  Idx: Integer;
  IdxWrite: Integer;
  IdxInsert: Integer;
  MaxValue: Integer;
  ArrayFromMinToMax: array of Integer;
begin
  //  1. kleinster bzw. grösster Wert berrechnen...
  MaxValue := MaxIntValue(ListOfInteger);

  //  2. Array von Min bis Max....
  SetLength(ArrayFromMinToMax, (MaxValue + 1));

  //  3. Initialisiere grosses Array von min bis max mit 0...
  for Idx := Low(ArrayFromMinToMax) to High(ArrayFromMinToMax) do
    ArrayFromMinToMax[Idx] := 0;

  //  4. Vorkommen zählen und an die entsprechende Position einfügen...
  for Idx := Low(ListOfInteger) to High(ListOfInteger) do
    ArrayFromMinToMax[ListOfInteger[Idx]] := ArrayFromMinToMax[ListOfInteger[Idx]] + 1;

  //  5. ArrayFromMinToMax "ausmultiplizieren"...
  if Ascending then
    IdxInsert := 0
  else
    IdxInsert := High(ListOfInteger);

  for Idx := Low(ArrayFromMinToMax) to High(ArrayFromMinToMax) do
  begin
    if (ArrayFromMinToMax[Idx] = 0) then
      Continue;

    for IdxWrite := 1 to ArrayFromMinToMax[Idx] do
    begin
      ListOfInteger[IdxInsert] := Idx;
      if Ascending then
        Inc(IdxInsert)
      else
        Dec(IdxInsert);
    end;
  end;
end;

class function TSorting.CountingSort2(InputOfInteger: TIntegerDynArray): TIntegerDynArray;
var
  Idx: Integer;
  IdxInsert: Integer;
  MinValue: Integer;
  MaxValue: Integer;
  CounterArray: TIntegerDynArray;
begin
  //  1. Create an equals size array like InputOfInteger...
  SetLength(Result, Length(InputOfInteger));

  //  2. Calculate min and max values from InputOfInteger...
  MinValue := InputOfInteger[High(InputOfInteger)];
  MaxValue := MinValue;
  for Idx := Low(InputOfInteger) to High(InputOfInteger) do
  begin
    if (InputOfInteger[Idx] < MinValue) then
      MinValue := InputOfInteger[Idx];

    if (InputOfInteger[Idx] > MaxValue) then
      MaxValue := InputOfInteger[Idx];
  end;

  //  3. Create the counter array for all occurrences...
  //  SetLength(CounterArray, (MaxValue - MinValue + 1));
  SetLength(CounterArray, (MaxValue + 1));

  //  4. Initialize the couter array with zero values...
  for Idx := Low(CounterArray) to High(CounterArray) do
    CounterArray[Idx] := 0;

  //  5. Now will store the counts of each integer in the given array...
  for Idx := Low(InputOfInteger) to High(InputOfInteger) do
    CounterArray[InputOfInteger[Idx]] := CounterArray[InputOfInteger[Idx]] + 1;

  //  6. The modified array add each element to the previous one...
  //  Unstructed array [4, 2, 1, 5, 1] now before [0, 2, 1, 0, 1, 1] and after [0, 2, 3, 3, 4, 5]
  for Idx := Low(CounterArray) + 1 to High(CounterArray) do
    CounterArray[Idx] := CounterArray[Idx] + CounterArray[Idx - 1];

  //  7. Now loop over the input array, pick the value and put the value to the
  //  Index of result array, which has the same size. Example:
  //  Now we have the counter array [0, 2, 3, 3, 4, 5] and the input [4, 2, 1, 5, 1]
  //  First we take the 4 from the first index of input array.
  //  Take the Index from counter array, here CounterArray[4] = 4 and put the value
  //  from input to result array. Second again:
  //  Second value from input is 2. 2 from CounterArrray[2] = 3. Put into result.
  //  The index for result is - 1, because we start with zero.
  for Idx := Low(InputOfInteger) to High(InputOfInteger) do
  begin
    IdxInsert := CounterArray[InputOfInteger[Idx]];
    Result[IdxInsert - 1] := InputOfInteger[Idx];
    Dec(IdxInsert);
    CounterArray[InputOfInteger[Idx]] := IdxInsert;
  end;
end;

{$REGION 'Does not work yet.'}
//class procedure TSorting.CountingSortGen<T>(ListOf: array of T; Ascending: Boolean);
//type
//  TIntList = array[0..1] of Integer;
//var
//  //  Info: PTypeInfo;  //  http://docwiki.embarcadero.com/CodeExamples/Berlin/en/TypInfoGetEnumName_(Delphi)
//  //  Data: PTypeData;
//
//  Idx: Integer;
//  MinValue: T;
//  MaxValue: T;
//
//  //  MinValueVal: Integer;
//  //  MaxValueVal: Integer;
//
//  IdxWrite: Integer;
//  IdxInsert: Integer;
//  ArrayFromMinToMax: array of TIntList;
//begin
//  //  1. kleinster bzw. grösster Wert berrechnen...
//  MinValue := ListOf[High(ListOf)];
//  MaxValue := MinValue;
//  for Idx := Low(ListOf) to High(ListOf) do
//  begin
//    //  if (GetTypeKind(MaxValue) = tkInteger) then
//    //    MaxValue := MaxValue;
//    //
//    //    if (ListOf[Idx] < MinValue) then
//    //      MinValue := ListOf[Idx];
//    //
//    //    TEqualityComparer<T>.Default.Equals(MinValue, ListOf[Idx]);
//    //    TComparer<T>.Construct(
//    //      function(const Left, Right: T): Integer
//    //      begin
//    //        Result := CompareMem(@Left, @Right, SizeOf(Left));
//    //      end);
//    //
//    //    if (ListOf[Idx] > MaxValue) then
//    //      MaxValue := ListOf[Idx];
//
//    //  Das Ergebnis ist kleiner als Null (<0). Left ist kleiner als Right.
//    //  Das Ergebnis ist gleich Null (=0). Left ist gleich Right.
//    //  Das Ergebnis ist größer als Null (>0). Left ist größer als Right.
//
//    if (TComparer<T>.Default.Compare(ListOf[Idx], MinValue) < 0) then
//      MinValue := ListOf[Idx];
//
//    if (TComparer<T>.Default.Compare(ListOf[Idx], MaxValue) > 0) then
//      MaxValue := ListOf[Idx];
//  end;
//
//  //  Info := System.TypeInfo(T);
//  //  Data := GetTypeData(Info);
//  //  MaxValueVal := Data.MaxValue;
//  //  MinValueVal := Data^.MinValue;
//
//  //  2. Array von Min bis Max....
//  SetLength(ArrayFromMinToMax, (Length(ListOf) + 1));
//
//  //  3. Initialisiere grosses Array von min bis max mit 0...
//  for Idx := Low(ArrayFromMinToMax) to High(ArrayFromMinToMax) do
//  begin
//    ArrayFromMinToMax[Idx][0] := 0;
//    ArrayFromMinToMax[Idx][1] := 0;
//  end;
//
//  //  4. Vorkommen zählen und an die entsprechende Position einfügen...
//  for Idx := Low(ListOf) to High(ListOf) do
//  begin
//    ArrayFromMinToMax[Idx][0] := Idx;
//    ArrayFromMinToMax[Idx][1] := ArrayFromMinToMax[Idx][1] + 1;
//  end;
//
//  //  5. ArrayFromMinToMax "ausmultiplizieren"...
//  IdxInsert := 0;
//  for Idx := Low(ArrayFromMinToMax) to High(ArrayFromMinToMax) do
//  begin
//    if (ArrayFromMinToMax[Idx][1] = 0) then
//      Continue;
//
//    for IdxWrite := 1 to ArrayFromMinToMax[Idx][1] do
//    begin
////      ListOf[IdxInsert] := Idx;
//      Inc(IdxInsert)
//    end;
//  end;
//
//end;
{$ENDREGION}















class procedure TSorting.Mergesort(StartToSort, EndToSort: Integer; InputOfInteger: TIntegerDynArray);
var
  StartRange: Integer;
  EndRange: Integer;
  //  SplitMergeTask: ITask;
begin
  if (Length(InputOfInteger) = 1) then
    Exit;

  {$REGION 'Without Thread'}
//  //  Need it do merge into the original array...
//  MergeOffset := StartToSort;
  {$ENDREGION}

  //  Calculate the half of the array and call it recursively until there are
  //  only 2 elements left and right.
  EndRange := StartToSort + ((EndToSort - StartToSort) div 2);
  StartRange := EndRange + 1;

  //  For the left side...
  if (StartToSort <> EndRange) then
    MergeSort(StartToSort, EndRange, InputOfInteger);

  //  For the right side...
  if (StartRange <> EndToSort) then
    MergeSort(StartRange, EndToSort, InputOfInteger);

  Merge(StartToSort, EndToSort, InputOfInteger);

  {$REGION 'With Thread'}
//  SplitMergeTask := TTask.Create(
//    procedure ()
//    var
//      StartRange: Integer;
//      EndRange: Integer;
//    begin
//      //  Calculate the half of the array and call it recursively until there are
//      //  only 2 elements left and right.
//      EndRange := StartToSort + ((EndToSort - StartToSort) div 2);
//      StartRange := EndRange + 1;
//
//      //  For the left side...
//      if (StartToSort <> EndRange) then
//        MergeSort(StartToSort, EndRange, InputOfInteger);
//
//      //  For the right side...
//      if (StartRange <> EndToSort) then
//        MergeSort(StartRange, EndToSort, InputOfInteger);
//
//      Merge(StartToSort, EndToSort, InputOfInteger);
//    end);
//  SplitMergeTask.Start;
  {$ENDREGION}

  {$REGION 'Without Thread'}
  Merge(StartToSort, EndToSort, InputOfInteger);
  {$ENDREGION}
end;

class procedure TSorting.Merge(StartToSort, EndToSort: Integer; InputOfInteger: TIntegerDynArray);
var
  Idx: Integer;
  ResultArray: TIntegerDynArray;

  MergeOffset: Integer;
  LeftStart: Integer;
  LeftEnd: Integer;
  RightStart: Integer;
  RightEnd: Integer;
  Middle: Integer;
begin
  MergeOffset := StartToSort;

  //  Create the helper array...
  SetLength(ResultArray, (EndToSort - StartToSort) + 1);

  //  Is doubly but first times no preference...
  Middle := StartToSort + ((EndToSort - StartToSort) div 2);

  //  Range of left array...
  LeftStart := StartToSort;
  LeftEnd := Middle;

  //  Range of right array...
  RightStart := Middle + 1;
  RightEnd := EndToSort;

  //  Vergleiche estes Element der "linken Liste" mit dem ersten Element der
  //  "rechten Liste" und schreibe das kleine in das ResultArray. Example:
  //  [3, 5]  -  [10, 22]
  //  3 < 10 => ResultArray[3, , , ]
  //  5 < 10 => ResultArray[3, 5, , ]
  //  ResultArray[3, 5, , ] + [10, 22] => ResultArray[3, 5, 10, 22]
  //  while (LeftStart <= LeftEnd) do

  Idx := 0;

  //  Comapre the first element from left range with the first element from the right.
  while (not (LeftStart > LeftEnd)) and (not (RightStart > RightEnd)) do
  begin
    if (InputOfInteger[LeftStart] < InputOfInteger[RightStart]) then
    begin
      ResultArray[Idx] := InputOfInteger[LeftStart];
      Inc(LeftStart);
    end
    else
    begin
      ResultArray[Idx] := InputOfInteger[RightStart];
      Inc(RightStart);
    end;

    Inc(Idx);
  end;

  //  Copy the rest to the helper array, from left range...
  while (not (LeftStart > LeftEnd)) do
  begin
    ResultArray[Idx] := InputOfInteger[LeftStart];
    Inc(LeftStart);
    Inc(Idx);
  end;

  //  Copy the rest to the helper array, from right range...
  while (not (RightStart > RightEnd)) do
  begin
    ResultArray[Idx] := InputOfInteger[RightStart];
    Inc(RightStart);
    Inc(Idx);
  end;

  //  Now merge or copy all together in the main array...
  for Idx := Low(ResultArray) to High(ResultArray) do
    InputOfInteger[MergeOffset + Idx] := ResultArray[Idx];
end;












class procedure TSorting.Mergesort3(StartSort, EndSort: Integer; IntArray: TIntegerDynArray);
var
  NewEnd: Integer;
  NewStart: Integer;
  StartGO: Integer;
  I: Integer;
  ArrayResult: TIntegerDynArray;
begin
  StartGO := StartSort;
  if (High(IntArray) > 0) then
  begin
    NewEnd := StartSort + ((EndSort - StartSort) div 2);
    NewStart := NewEnd + 1;

    if (StartSort <> NewEnd) then
      MergeSort3(StartSort, NewEnd, IntArray);

    if (NewStart <> EndSort) then
      MergeSort3(NewStart, EndSort, IntArray);

    I := 0;
    SetLength(ArrayResult, 1);
    while (StartSort <= NewEnd) and (NewStart <= EndSort) do
    begin
      if (IntArray[StartSort] > IntArray[NewStart]) then
      begin
        ArrayResult[I] := IntArray[NewStart];
        Inc(NewStart);
      end
      else
      begin
        ArrayResult[I] := IntArray[StartSort];
        Inc(StartSort);
      end;

      Inc(I);
      SetLength(ArrayResult, High(ArrayResult) + 2);
    end;

    while (StartSort <= NewEnd) or (NewStart <= EndSort) do
    begin
      if (StartSort <= NewEnd) then
      begin
        ArrayResult[I] := IntArray[StartSort];
        Inc(StartSort);
      end
      else
      begin
        ArrayResult[I] := IntArray[NewStart];
        Inc(NewStart);
      end;

      Inc(I);
      SetLength(ArrayResult, High(ArrayResult) + 2);
    end;

    //    I := 0;
    for I := Low(ArrayResult) to High(ArrayResult) - 1 do
      IntArray[StartGO + I] := ArrayResult[I];
  end;
end;

end.
