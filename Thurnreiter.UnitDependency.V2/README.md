# Thurnreiter.UnitDependency.V2
The program evaluates "*.symbol_report" files from Delphi Compiler. This allows unused namespaces to be identified. 
The value **"--symbol-report"** must be entered under the project configuration ("Delphi Compiler" - "Compiling" - "Other options" - "Assitional options to pass to the compiler").
<br>
<br>
Follow the link from [wiert.me](https://wiert.me/2019/01/31/passing-the-symbol-report-to-the-delphi-compiler-gives-you-a-nice-xml-overview-with-all-symbols-used/, "https://wiert.me/2019/01/31...."). It's been a great help, the tip. Thank you.
<br>
<br>
Sample how to call the console app:<br>
**Nathan.Unused.Symbols.exe -Path:D:\Dev\src\AnyApp\dcu\Debug -Filter:SysInit,System.IOUtils >>c:\temp\unused.json**
<br>
<br>
The output is now in json format. The parameter *PATH* is required. The parameter "FILTER" is only necessary if you want to filter out any other "Units".
