# Demo GetIt Packagemanager 
An example of how to create a local package and then load it.
The example does not install any library and does nothing practical. It only serves as a basis or example.

# Actions Data Index
Finding out the "ActionID" is a bit complicated. Here is a list with "ActionID" and the function behind it.
I'm not sure are all ActionId's correctly. 

| ActionId | Available Actionname           | Desc. |
| -------- | ------------------------------ |------ |
| 01       | AddOptionPath                  |  1 |
| 02       | RemoveOptionPath               |  2 |
| 03       | ExecuteProgram                 |  3 |
|          | InstallCHM                     |  4 |
|          | UninstallCHM                   |  5 |
| 06       | CompileProject                 |  6 |
|          | CleanProject                   |  7 |
|          | InstallPackage                 |  8 |
|          | UninstallPackage               |  9 |
|          | UninstallProgram               | 10 |
|          | ExecuteCommand                 | 11 |
| 16       | WarmNeededIDERestart           | 12 Sie müssen RAD Studio neu starten, um diese Änderungen zu übernehmen. |
|          | InstallIDEPackage              | 13 |
|          | UninstallIDEPackage            | 14 |
|          | CopyFile                       | 15 |
|          | UnzipFile                      | 16 |
| 21       | RestartIDE                     | 17 Am Ende dieser Aktion ist ein Neustart von RAD Studio erforderlich. Fortsetzen? |
|          | AddValueToRegistry             | 18 |
|          | DeleteValueFromRegistry        | 19 |
|          | DeleteFile                     | 20 |
|          | AddEnvironmentVariable         | 21 |
|          | RemoveEnvironmentVariable      | 22 |
|          | AddTemporalVariable            | 23 |
|          | RemoveTemporalVariable         | 24 |
|          | MoveFile                       | 25 |
|          | ReplaceStrFromFile             | 26 |
|          | CreateShortcut                 | 27 |
|          | CopyFolder                     | 28 |
|          | OpenCloseProject               | 29 |
|          | MoveFolder                     | 30 |
|          | Predefined Temporary Variables | 31 |


Documentation here:   
https://docwiki.embarcadero.com/RADStudio/Athens/en/Local_GetIt_Packages_Actions_Data_Index


# Links
GetIt local files guide:
https://docwiki.embarcadero.com/RADStudio/Athens/en/GetIt_Local_Files_Guide_Index

