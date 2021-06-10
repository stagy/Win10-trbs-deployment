

    # The minimum needed Verson of App Installer
    $minRequiredVersion = "1.11.11451.0"  
    $minRequiredVersionParts = $minRequiredVersion -split "\."
    $minRequiredVersionNumber = $minRequiredVersionParts[0]+$minRequiredVersionParts[1]+$minRequiredVersionParts[2]+$minRequiredVersionParts[3]

    # Checks the Version of App Installer
    $Version = (Get-AppxPackage Microsoft.DesktopAppInstaller).Version 
    $VersionParts = $Version -split "\."
    $VersionNumber = $VersionParts[0]+$VersionParts[1]+$VersionParts[2]+$VersionParts[3]
       
    # Installs the basic Software if App Installer meet the requirements
    if ($VersionNumber -ge $minRequiredVersionNumber) {

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
            git clone https://github.com/stagy/Win10-trbs-deployment C:\Users\$env:UserName\AppData\Local\Temp\gitrepo

            #Installs all Local Programms from Manifest 
            Write-Host "Installiert Asana"
            winget install --manifest C:\Users\$env:UserName\AppData\Local\Temp\gitrepo\manifests\a\Asana,Inc\AsanaforWindows\1.1.0

            #Deletes temp git repo
            #Remove-Item 'C:\Users\$env:UserName\AppData\Local\Temp\gitrepo' -Recurse


            Write-Host "Alle Programme Instaliert"
            winget
    }

    # Drops a warnig if App Installer does not meet the requirements
    else {
        write-warning "AppInstaller wird mindestens in der Version $minRequiredVersion benötigt."
        write-warning "Die aktuelle Version des AppInstaller ist $Version"
        Write-Host "Das AppInstaller Update bekommst du hier: ms-appinstaller:?source=https://aka.ms/getwinget "
        Write-Host "Einfach den link in einen Browser kopieren und ausführen."
    } 

