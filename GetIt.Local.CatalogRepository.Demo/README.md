# Demo GetIt Packagemanager 
An example of how to create a local package and then load it.
The example does not install any library and does nothing practical. It only serves as a basis or example.

# Actions Data Index
Finding out the "ActionID" is a bit complicated. Here is a list with "ActionID" and the function behind it.
I'm not sure are all ActionId's correctly. 

| Id | Available Actionname           | Desc. |
| -- | ------------------------------ |  |
| 01 | AddOptionPath                  |  |
| 02 | RemoveOptionPath               |  |
| 03 | ExecuteProgram                 |  |
|    | InstallCHM                     |  |
|    | UninstallCHM                   |  |
| 06 | CompileProject                 |  |
|    | CleanProject                   |  |
|    | InstallPackage                 |  |
|    | UninstallPackage               |  |
|    | UninstallProgram               |  |
|    | ExecuteCommand                 |  |
| 12 | WarmNeededIDERestart           |  |
|    | InstallIDEPackage              |  |
|    | UninstallIDEPackage            |  |
|    | CopyFile                       |  |
|    | UnzipFile                      |  |
| 16 | RestartIDE                     | Sie müssen RAD Studio neu starten, um diese Änderungen zu übernehmen. |
|    | AddValueToRegistry             |  |
|    | DeleteValueFromRegistry        |  |
|    | DeleteFile                     |  |
|    | AddEnvironmentVariable         |  |
|    | RemoveEnvironmentVariable      |  |
|    | AddTemporalVariable            |  |
|    | RemoveTemporalVariable         |  |
|    | MoveFile                       |  |
|    | ReplaceStrFromFile             |  |
|    | CreateShortcut                 |  |
|    | CopyFolder                     |  |
|    | OpenCloseProject               |  |
|    | MoveFolder                     |  |
|    | Predefined Temporary Variables |  |


Documentation here:   
https://docwiki.embarcadero.com/RADStudio/Athens/en/Local_GetIt_Packages_Actions_Data_Index


# Links
GetIt local files guide:
https://docwiki.embarcadero.com/RADStudio/Athens/en/GetIt_Local_Files_Guide_Index

