program FibonacciDemo;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  System.Math,
  System.Diagnostics;

type
  /// <summary>
  ///   To check online use: https://www.tools4noobs.com/online_tools/fibonacci
  ///   Definition: fn = fn-1 + fn-2
  ///   Step n                 fn
  ///    0      (modern way) =  0
  ///    1                   =  1
  ///    2      0 +  1       =  1
  ///    3      1 +  1       =  2
  ///    4      1 +  2       =  3
  ///    5      2 +  3       =  5
  ///    6      3 +  5       =  8
  ///    7      5 +  8       = 13
  ///    8      8 + 13       = 21
  ///    9     13 + 21       = 34  fn-1 + fn-2 = 13 + 21 = 34
  ///   10     21 + 34       = 55
  ///
  ///   ...
  /// </summary>
  TFibonacci = class
  private
    class procedure ExIsNegative(ASteps: Integer);
  public
    class function Iterative(ASteps: Integer): Int64;
    class function Iterative2(ASteps: Integer): Int64;
    class function Iterative3(ASteps: Integer): Int64;
    class function Rekursive(ASteps: Integer): Int64;
    class function Rekursive2(ASteps: Integer): Int64;
    class function Rekursive3(ASteps: Integer): Int64;
    class function Rekursive4(ASteps: Integer): Int64;
    class function Fibonacci_Hagen2(N: Byte): Int64;
    class function Formula(ASteps: Integer): Int64;
  end;

{ TFibonacci }

//  https://www.codeproject.com/Articles/509627/Generating-Fibonacci-Numbers-in-Delphi-Recursive-a
//  https://www.delphipraxis.net/44105-fibonacci-6-versionen.html
{
  FibFixArr: array[0..92] of Int64 =
    (0, 1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144, 233, 377, 610, 987, 1597, 2584, 4181,
     6765, 10946, 17711, 28657, 46368, 75025, 121393, 196418, 317811, 514229, 832040,
     1346269, 2178309, 3524578, 5702887, 9227465, 14930352, 24157817, 39088169, 63245986,
     102334155, 165580141, 267914296, 433494437, 701408733, 1134903170, 1836311903,
     2971215073, 4807526976, 7778742049, 12586269025, 20365011074, 32951280099,
     53316291173, 86267571272, 139583862445, 225851433717, 365435296162, 591286729879,
     956722026041, 1548008755920, 2504730781961, 4052739537881, 6557470319842, 10610209857723,
     17167680177565, 27777890035288, 44945570212853, 72723460248141, 117669030460994,
     190392490709135, 308061521170129, 498454011879264, 806515533049393, 1304969544928657,
     2111485077978050, 3416454622906707, 5527939700884757, 8944394323791464, 14472334024676221,
     23416728348467685, 37889062373143906, 61305790721611591, 99194853094755497, 160500643816367088,
     259695496911122585, 420196140727489673, 679891637638612258, 1100087778366101931,
     1779979416004714189, 2880067194370816120, 4660046610375530309, 7540113804746346429);
}


class procedure TFibonacci.ExIsNegative(ASteps: Integer);
begin
  if ASteps < 0 then
    raise Exception.Create('The Fibonacci sequence is only possible with positive numbers.');
end;

class function TFibonacci.Iterative(ASteps: Integer): Int64;
var
  forelast, last: Int64;
  currentvalue: Int64;
begin
  ExIsNegative(ASteps);
  currentvalue := Default(Int64);
  forelast := 1;
  last := 0;
  while (ASteps > 0) do
  begin
    currentvalue := forelast;
    forelast := forelast + last;
    last := currentvalue;
    Dec(ASteps);
  end;

  Result := currentvalue;
end;

class function TFibonacci.Iterative2(ASteps: Integer): Int64;
var
  Idx, N_1, N_2, N: Int64;
begin
  ExIsNegative(ASteps);

  case ASteps of
    0: Result := 0;
    1: Result := 1;
  else
    begin
      N := Default(Int64);
      N_1 := 0;
      N_2 := 1;
      for Idx := 2 to ASteps do
      begin
        N := N_1 + N_2;
        N_1 := N_2;
        N_2 := N;
      end;
      Result := N;
    end;
  end;
end;

class function TFibonacci.Iterative3(ASteps: Integer): Int64;
var
  Idx: Integer;
  forelast, last, current: Int64;
begin
  ExIsNegative(ASteps);

  if (ASteps = 0) then
    Result := 0
  else
  if (ASteps = 1) then
    Result := 1
  else
  begin
    current := Default(Int64);
    forelast := 0;
    last := 1;
    for Idx := 2 to ASteps do
    begin
      current := forelast + last;
      forelast := last;
      last := current;
    end;
    Result := current;
  end;
end;

class function TFibonacci.Rekursive(ASteps: Integer): Int64;
begin
  ExIsNegative(ASteps);

  case ASteps of
    1, 2: Result := 1;
  else
    Result := Rekursive(ASteps - 2) + Rekursive(ASteps - 1);
  end;
end;

class function TFibonacci.Rekursive2(ASteps: Integer): Int64;
begin
  ExIsNegative(ASteps);

  case ASteps of
    0: Result := 0;
    1: Result := 1;
  else
    Result := Rekursive2(ASteps - 1) + Rekursive2(ASteps - 2);
  end;;
end;

class function TFibonacci.Rekursive3(ASteps: Integer): Int64;
  function Fibonacci_Rekursiv_Inner(f1, f2, N: Int64): Int64;
  begin
    if N = 0 then
      Result := f1
    else
      Result := Fibonacci_Rekursiv_Inner(f2, f1 + f2, N - 1);
  end;

begin
  case ASteps of
    1, 2 : Result := 1;
  else
    Result := Fibonacci_Rekursiv_Inner(0, 1, ASteps);
  end;
end;

class function TFibonacci.Rekursive4(ASteps: Integer): Int64;
var
  InnerAction: TFunc<Int64, Int64, Int64, Int64>;
begin
  InnerAction :=
    function(f1, f2, N: Int64): Int64
    begin
      if N = 0 then
        Result := f1
      else
        Result := InnerAction(f2, f1 + f2, N - 1);
    end;

  case ASteps of
    1, 2 : Result := 1;
  else
    Result := InnerAction(0, 1, ASteps);
  end;
end;

class function TFibonacci.Fibonacci_Hagen2(N: Byte): Int64;

  function Log2(A: Cardinal): Cardinal; register;
  asm
    BSR EAX,EAX
  end;

var
  E, F, T, S: Int64;
  M: Byte;
begin
  M := 1 shl Log2(N);
  F := 1;
  E := 0;
  while M > 1 do
  begin
    M := M shr 1;
    T := E * F;
    F := F * F;
    E := E * E + F;
    T := T + T + F;
    if N and M <> 0 then
    begin
      S := E;
      E := T;
      T := T + S;
    end;
    S := T;
    T := F;
    F := S;
  end;
  Result := F;
end;


class function TFibonacci.Formula(ASteps: Integer): Int64;
begin
  Result := Round((1 / Sqrt(5)) * (Power((1 + Sqrt(5)) / 2, ASteps - 1) - Power((1 - Sqrt(5)) / 2, ASteps - 1)));
end;

{ **************************************************************************** }

const
//  FibBase = 10; //  Return by index 10 has to be 55...
  FibBase = 20; //  Return by index 20 has to be 6765...
//  FibBase = 50; //  Return by index 50 has to be 12586269025...
var
  IdxWatch: Integer;
  execute: TProc<Int64, string>;
  watch: TStopwatch;
begin
  watch := TStopwatch.Create;
  execute :=
    procedure(Return: Int64; AName: string)
    begin
      watch.Stop;
      Writeln(Format('Return: %s Ticks: %8.8s %s', [Return.ToString, watch.ElapsedTicks.ToString, AName]));
      watch.Reset;
    end;

  for IdxWatch := 0 to 20 do
  begin
    watch.Start;
    execute(TFibonacci.Iterative(FibBase), 'Iterative');

    watch.Start;
    execute(TFibonacci.Iterative2(FibBase), 'Iterative2');

    watch.Start;
    execute(TFibonacci.Iterative3(FibBase), 'Iterative3 (On average the fastest)');

    watch.Start;
    execute(TFibonacci.Rekursive(FibBase), 'Rekursive');

    watch.Start;
    execute(TFibonacci.Rekursive2(FibBase), 'Rekursive2');

    watch.Start;
    execute(TFibonacci.Rekursive3(FibBase), 'Rekursive3');

    watch.Start;
    execute(TFibonacci.Rekursive3(FibBase), 'Rekursive4');

    watch.Start;
    execute(TFibonacci.Fibonacci_Hagen2(FibBase), 'Fibonacci_Hagen2');

    watch.Start;
    execute(TFibonacci.Formula(FibBase), 'Formula');

    Writeln('----------------------------------------');
  end;

  Writeln('');
  Writeln('Press any key to continue...');
  ReadLn
end.
