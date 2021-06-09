# Win10-trbs-deployment

This is the Windows 10 Script for trbs. I also added Chocolatey and other tools to the script that I install on every machine.

### Getting started

```powershell
iwr -useb 'https://raw.githubusercontent.com/stagy/Win10-trbs-deployment/main/choco.ps1'|iex

iwr -useb 'https://raw.githubusercontent.com/stagy/Win10-trbs-deployment/main/cleaner.ps1'|iex
```

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File choco.ps1

iex ((New-Object System.Net.WebClient).DownloadString('https://git.io/JJ8R4'))
:: Set-ExecutionPolicy -ExecutionPolicy 'RemoteSigned' -Scope 'CurrentUser'
:: iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/stagy/Win10-trbs-deployment/main/cleaner.ps1'))

:: iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/stagy/Win10-trbs-deployment/main/baseinstall.ps1'))

```

## Additional configurations were considered from:

- [Windows-Optimize-Harden-Debloat
  ](https://github.com/simeononsecurity/Windows-Optimize-Harden-Debloat/)
- [Win10script January 2021 Update
  ](https://github.com/ChrisTitusTech/win10script)

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
iwr -useb 'https://github.com/simeononsecurity/Windows-Optimize-Harden-Debloat/blob/master/sos-optimize-windows.ps1'|iex
```

iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/simeononsecurity/Windows-Optimize-Harden-Debloat/master/sos-optimize-windows.ps1'))
