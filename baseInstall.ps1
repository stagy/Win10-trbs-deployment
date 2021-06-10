

    # The minimum needed Verson of App Installer
    $minRequiredVersion = "1.11.11451.0"  
    $minRequiredVersionParts = $minRequiredVersion -split "\."
    $minRequiredVersionNumber = $minRequiredVersionParts[0]+$minRequiredVersionParts[1]+$minRequiredVersionParts[2]+$minRequiredVersionParts[3]

    # Checks the Version of App Installer
    $Version = (Get-AppxPackage Microsoft.DesktopAppInstaller).Version 
    $VersionParts = $Version -split "\."
    $VersionNumber = $VersionParts[0]+$VersionParts[1]+$VersionParts[2]+$VersionParts[3]
       
    # check if App Installer meet the requirements
    $passcheck = 0
    if ($VersionNumber -ge $minRequiredVersionNumber) {
        $passcheck = 1  
    }

    # Drops a warnig if App Installer does not meet the requirements
    else {
        write-warning "AppInstaller wird mindestens in der Version $minRequiredVersion benötigt."
        write-warning "Die aktuelle Version des AppInstaller ist $Version"
        Start ms-appinstaller:?source=https://aka.ms/getwinget
        $confirmation = Read-Host "Bitte den AppInstaller Aktualiseren und DANACH y Drücken"
            if ($confirmation -eq 'y') {
                $passcheck = 1 
            }
    }


    
        # Installs the basic Software
    if ($passcheck -eq 1) {

            #Instslls all Online Programms
            Write-Host "Installiert 7zip"
            winget install 7zip.7zip
            Write-Host "Installiert Git"
            winget install Git.Git
            Write-Host "Installiert NodeJS"
            winget install OpenJS.NodeJSLTS
            Write-Host "Installiert Visual Studio Code"
            winget install Microsoft.VisualStudioCode
            Write-Host "Installiert Google Chrome"
            winget install Google.Chrome
            Write-Host "Installiert 1Password"
            winget install AgileBits.1Password

            #Download git rebo for local Install
            #its open a new powershell because we just installed git in this script and Powershell needs a restart to know the commands for git
            Start-Process PowerShell "git clone https://github.com/stagy/Win10-trbs-deployment C:\Users\$env:UserName\AppData\Local\Temp\gitrepo"

            #Installs all Local Programms from Manifest 
            Write-Host "Installiert Asana"
            winget install --manifest C:\Users\$env:UserName\AppData\Local\Temp\gitrepo\manifests\a\Asana,Inc\AsanaforWindows\1.1.0
            Write-Host "Installiert Clockodo"
            winget install --manifest C:\Users\$env:UserName\AppData\Local\Temp\gitrepo\manifests\c\clickbitsGmbH\clockodo\6.0.10

            #Deletes temp git repo
            #Remove-Item 'C:\Users\$env:UserName\AppData\Local\Temp\gitrepo' -Recurse


            Write-Host "Alle Programme Instaliert"
            winget
    }
