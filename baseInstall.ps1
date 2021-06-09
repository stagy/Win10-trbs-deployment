function basisinstall {

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
            Write-Host "winget install 7zip.7zip"
            Write-Host "winget install Git.Git"
            Write-Host "winget install OpenJS.NodeJSLTS"
            Write-Host "winget install Microsoft.VisualStudioCode"
            Write-Host "winget install Google.Chrome"
    }

    # Drops a warnig if App Installer does not meet the requirements
    else {
        write-warning "AppInstaller wird mindestens in der Version $minRequiredVersion benötigt."
        write-warning "Die aktuelle Version des AppInstaller ist $Version" 
    } 
}


basisinstall

