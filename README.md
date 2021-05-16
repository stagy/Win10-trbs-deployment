# Win10-trbs-deployment
This is the  Windows 10 Script for trbs. I also added Chocolatey and other tools to the script that I install on every machine.


### Getting started
<code style="background-color:grey">(new-object Net.WebClient).DownloadString("https://raw.githubusercontent.com/ligershark/nuget-powershell/master/get-nugetps.ps1") | iex</code>

powershell.exe -NoProfile -ExecutionPolicy Bypass -File choco.ps1

:: Set-ExecutionPolicy -ExecutionPolicy 'RemoteSigned' -Scope 'CurrentUser'
:: iex ((New-Object System.Net.WebClient).DownloadString('https://git.io/JJ8R4'))

## Additional configurations were considered from:
- [Windows-Optimize-Harden-Debloat
](https://github.com/simeononsecurity/Windows-Optimize-Harden-Debloat/)

## How to run the script
### Manual Install:
If manually downloaded, the script must be launched from an administrative powershell in the directory containing all the files from the [GitHub Repository](https://github.com/simeononsecurity/Windows-Optimize-Harden-Debloat)
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Force
Get-ChildItem -Recurse *.ps1 | Unblock-File
.\sos-optimize-windows.ps1
```
### Automated Install:
Use this one-liner to automatically download, unzip all supporting files, and run the latest version of the script.
```powershell
iwr -useb 'https://simeononsecurity.ch/scripts/windowsoptimizeandharden.ps1'|iex
```