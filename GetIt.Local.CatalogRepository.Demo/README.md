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
| 04       | InstallCHM                     |  4  Installs Help |
| 05       | UninstallCHM                   |  5  Uninstalls Help |
| 06       | CompileProject                 |  6 |
|          | CleanProject                   |  7 |
| 07       | InstallPackage                 |  8  Installs Package |
| 08       | UninstallPackage               |  9  Uninstalls package (.bpl) |
| 11       | UninstallProgram               | 10  Uninstall |
| 12       | ExecuteCommand                 | 11  Copy Sample Folder if possible |
| 16       | WarmNeededIDERestart           | 12  Sie müssen RAD Studio neu starten, um diese Änderungen zu übernehmen. |
|          | InstallIDEPackage              | 13 |
|          | UninstallIDEPackage            | 14 |
|          | CopyFile                       | 15 |
|          | UnzipFile                      | 16 |
| 21       | RestartIDE                     | 17  Am Ende dieser Aktion ist ein Neustart von RAD Studio erforderlich. Fortsetzen? User must restart the IDE to apply these changes |
| 24       | AddValueToRegistry             | 18 |
| 25       | DeleteValueFromRegistry        | 19  Delete Registry key for.bpl |
| 32       | DeleteFile                     | 20  Remove project |
| 33       | AddEnvironmentVariable         | 21  Add %DEMOSDIR% if not exists |
|          | RemoveEnvironmentVariable      | 22 |
|          | AddTemporalVariable            | 23 |
|          | RemoveTemporalVariable         | 24 |
|          | MoveFile                       | 25 |
|          | ReplaceStrFromFile             | 26 |
|          | CreateShortcut                 | 27 |
|          | CopyFolder                     | 28 |
| 41       | OpenCloseProject               | 29  Open the project Demo |
| 42       | MoveFolder                     | 30  Move $(_CatalogRepository)\/TARGETDIR\/ to $(BDS) |
|          | Predefined Temporary Variables | 31 |
| 28       | RemoveFilesFromPackage         | 32  Remove devices pas files on |
| 27       | AddFilesOnPackage              | 33  Add devices pas files on .cbproj |
| 10       | CheckProgramUninstalled        | 33  Check if any app are already installed |



Documentation here:   
https://docwiki.embarcadero.com/RADStudio/Athens/en/Local_GetIt_Packages_Actions_Data_Index


# Links
GetIt local files guide:
https://docwiki.embarcadero.com/RADStudio/Athens/en/GetIt_Local_Files_Guide_Index

Find out over https://getit-1032.embarcadero.com/#!/catalog/info and details by https://getit-1032.embarcadero.com/#!/catalog/installbyids
It works very simple. Pick the ID from the respone at the catalog-info and search it in catalog-installbyids.
