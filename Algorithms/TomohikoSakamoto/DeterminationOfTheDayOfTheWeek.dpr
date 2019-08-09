program DeterminationOfTheDayOfTheWeek;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  System.DateUtils,
  System.Math;

type
  /// <summary>
  ///   Determines the day name of the week using Tomohiko Sakamoto's Algorithm
  ///   to calculate Day of Week based on Gregorian calendar.
  /// </summary>
  TBigBang = class
    class function DayOfWeek(AYear, AMonth, ADay: Integer): Integer;
    class function DayNameOfWeek(AYear, AMonth, ADay: Integer): string; overload;
    class function DayNameOfWeek(ADate: TDate): string; overload;
  end;

{ TBigBang }

class function TBigBang.DayOfWeek(AYear, AMonth, ADay: Integer): Integer;
const
  FirstMonth = 0;
  LastMonth = 11;
  GaussTable: array[FirstMonth..LastMonth] of Integer = (0, 3, 2, 5, 0, 3, 5, 1, 4, 6, 2, 4);
begin
  AYear := AYear - IfThen((AMonth < 3), 1, 0);
  Result := (AYear + Trunc(AYear / 4) - Trunc(AYear / 100) + Trunc(AYear / 400) + GaussTable[(AMonth - 1)] + ADay) mod 7;
end;

class function TBigBang.DayNameOfWeek(AYear, AMonth, ADay: Integer): string;
const
  Daynames: array[0..6] of string =
    ('Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday') ;
begin
  Result := Daynames[DayOfWeek(AYear, AMonth, ADay)];
end;

class function TBigBang.DayNameOfWeek(ADate: TDate): string;
var
  LYear, LMonth, LDay: Word;
begin
  DecodeDate(ADate, LYear, LMonth, LDay);
  Result := DayNameOfWeek(LYear, LMonth, LDay);
end;


{ **************************************************************************** }

var
  IntDay: Integer;
begin
  Writeln('');

  IntDay := TBigBang.DayOfWeek(2019, 05, 29);
  Writeln(IntDay.ToString);
  Writeln(TBigBang.DayNameOfWeek(2019, 05, 29));
  Writeln('29.05.2019 ' + TBigBang.DayNameOfWeek(StrToDate('29.05.2019'))); //  Wednesday
  Writeln('01.05.1896 ' + TBigBang.DayNameOfWeek(StrToDate('01.05.1896'))); //  Saturday
  Writeln('10.12.1948 ' + TBigBang.DayNameOfWeek(StrToDate('10.12.1948'))); //  Friday
  Writeln('15.01.2001 ' + TBigBang.DayNameOfWeek(StrToDate('15.01.2001'))); //  Monday
  Writeln('10.10.2017 ' + TBigBang.DayNameOfWeek(StrToDate('10.10.2017'))); //  Tuesday
  Writeln('01.01.2019 ' + TBigBang.DayNameOfWeek(StrToDate('01.01.2019'))); //  Tuesday
  Writeln('31.12.2018 ' + TBigBang.DayNameOfWeek(StrToDate('31.12.2018'))); //  Monday
  Writeln('28.10.1972 ' + TBigBang.DayNameOfWeek(StrToDate('28.10.1972'))); //  Saturday
  Writeln('10.03.1983 ' + TBigBang.DayNameOfWeek(StrToDate('10.03.1983'))); //  Thursday
  Writeln('21.06.2018 ' + TBigBang.DayNameOfWeek(StrToDate('21.06.2018'))); //  Thursday

  Writeln('');
  Writeln('Press any key to continue...');
  ReadLn
end.
