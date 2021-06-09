# Win10-trbs-deployment

This is the Windows 10 Script for trbs. 



## Getting started

Open Windows PowerShell as administrator and copy: 

```powershell
iwr -useb 'https://raw.githubusercontent.com/stagy/Win10-trbs-deployment/main/configure.ps1'|iex
```
This Script will configure your Windows 10 and at the end suggest some more options.



## Install Software

This script will activate "winget" and install a few basic programs (see list below).

Copy the followed line in PowerShell (run as administrator).
```powershell
iwr -useb 'https://raw.githubusercontent.com/stagy/Win10-trbs-deployment/main/baseInstall.ps1'|iex
```

List of Installing Programs:
- 7zip
- Git
- NodeJS
- Visual Studio Code
- Google Chrome
- 1Password



## Additional configurations were considered from:

- [Windows-Optimize-Harden-Debloat
  ](https://github.com/simeononsecurity/Windows-Optimize-Harden-Debloat/)
- [Win10script January 2021 Update
  ](https://github.com/ChrisTitusTech/win10script)


