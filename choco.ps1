Start-Job -Name "WinFeature" -ScriptBlock {
    Write-Host "disabling the deprecated PowerShell 2.0"
    Disable-WindowsOptionalFeature -Online -FeatureName MicrosoftWindowsPowerShellV2Root
    Write-Output "Uninstalling Microsoft XPS Document Writer..."
    Get-WindowsOptionalFeature -Online | Where-Object { $_.FeatureName -eq "Printing-XPSServices-Features" } | Disable-WindowsOptionalFeature -Online -NoRestart -WarningAction SilentlyContinue | Out-Null

    Write-Host "disabling LocalPasswordResetQuestions"
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" -Name "NoLocalPasswordResetQuestions" -Type DWord -Value 1
    # New-LocalUser -Name "Elizabet" -Description "Test User" -NoPassword
    Write-Host "disabling LocalPasswordResetQuestions"
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows" -Name "WindowsUpdate" -Type DWord -Value 1
    # net stop wuauserv
    # sc config wuauserv start= disabled
}
# Default preset
$tweaks = @(
    ### Require administrator privileges ###
    "RequireAdmin",
    #"CreateRestorePoint"
    #"InstallTitusProgs", #REQUIRED FOR OTHER PROGRAM INSTALLS!
    "sosStartDebloat",
    "sosFixWhitelistedApps",
    "trbsUninstallOneDrive",
    #"trbsInstall",
    #"trbsSetVisualFXPerformance",
    #"InstallChocolateygui",
    #"Install1password",
    "WaitForKey"
)
Function trbsInstall {
    Write-Host "Install ALWAYS ================================================================================"

    choco install "7zip.install" -y
    choco install "git.install" -y
    choco install "nodejs-lts" -y
    choco install "vscode" -y
    choco install "googlechrome" -y
}
function sosStartDebloat {
    
    #Removes AppxPackages
    #Credit to Reddit user /u/GavinEke for a modified version of my whitelist code
    [regex]$WhitelistedApps = 'Microsoft.ScreenSketch|Microsoft.Paint3D|Microsoft.WindowsCalculator|Microsoft.WindowsStore|Microsoft.Windows.Photos|CanonicalGroupLimited.UbuntuonWindows|`
    Microsoft.MicrosoftStickyNotes|Microsoft.MSPaint|Microsoft.WindowsCamera|.NET|Framework|Microsoft.HEIFImageExtension|Microsoft.ScreenSketch|Microsoft.StorePurchaseApp|`
    Microsoft.VP9VideoExtensions|Microsoft.WebMediaExtensions|Microsoft.WebpImageExtension|Microsoft.DesktopAppInstaller'
    Get-AppxPackage -AllUsers | Where-Object { $_.Name -NotMatch $WhitelistedApps } | Remove-AppxPackage -ErrorAction SilentlyContinue
    #Run this again to avoid error on 1803 or having to reboot.
    Get-AppxPackage -AllUsers | Where-Object { $_.Name -NotMatch $WhitelistedApps } | Remove-AppxPackage -ErrorAction SilentlyContinue
    $AppxRemoval = Get-AppxProvisionedPackage -Online | Where-Object { $_.PackageName -NotMatch $WhitelistedApps } 
    ForEach ( $App in $AppxRemoval) {
        Write-Host "Trying to remove $App ."
        Remove-AppxProvisionedPackage -Online -PackageName $App.PackageName 
        
    }
}
#This includes fixes by xsisbest
function sosFixWhitelistedApps {
    
    If (!(Get-AppxPackage -AllUsers | Select-Object Microsoft.Paint3D, Microsoft.MSPaint, Microsoft.WindowsCalculator, Microsoft.WindowsStore, Microsoft.MicrosoftStickyNotes, Microsoft.WindowsSoundRecorder, Microsoft.Windows.Photos)) {
    
        #Credit to abulgatz for the 4 lines of code
        Get-AppxPackage -allusers Microsoft.Paint3D | ForEach-Object { Add-AppxPackage -DisableDevelopmentMode -Register "$($_.InstallLocation)\AppXManifest.xml" }
        Get-AppxPackage -allusers Microsoft.MSPaint | ForEach-Object { Add-AppxPackage -DisableDevelopmentMode -Register "$($_.InstallLocation)\AppXManifest.xml" }
        Get-AppxPackage -allusers Microsoft.WindowsCalculator | ForEach-Object { Add-AppxPackage -DisableDevelopmentMode -Register "$($_.InstallLocation)\AppXManifest.xml" }
        Get-AppxPackage -allusers Microsoft.WindowsStore | ForEach-Object { Add-AppxPackage -DisableDevelopmentMode -Register "$($_.InstallLocation)\AppXManifest.xml" }
        Get-AppxPackage -allusers Microsoft.MicrosoftStickyNotes | ForEach-Object { Add-AppxPackage -DisableDevelopmentMode -Register "$($_.InstallLocation)\AppXManifest.xml" }
        Get-AppxPackage -allusers Microsoft.WindowsSoundRecorder | ForEach-Object { Add-AppxPackage -DisableDevelopmentMode -Register "$($_.InstallLocation)\AppXManifest.xml" }
        Get-AppxPackage -allusers Microsoft.Windows.Photos | ForEach-Object { Add-AppxPackage -DisableDevelopmentMode -Register "$($_.InstallLocation)\AppXManifest.xml" } 
    }
}

Function trbsSetVisualFXPerformance {
    Write-Output "Die aktuelle Version von Windows 10 dauerhaft auf dem Desktop anzeigen ..."
    #Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "PaintDesktopVersion" -Type DWord -Value 0
    Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "PaintDesktopVersion" -Type DWord -Value 1
    Write-Output "Showing known file extensions..."
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "HideFileExt" -Type DWord -Value 0

    # Write-output "Enabling .NET strong cryptography..."
    # Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\.NETFramework\v4.0.30319" -Name "SchUseStrongCrypto" -Type DWord -Value 1
    # Set-ItemProperty -Path "HKLM:\SOFTWARE\Wow6432Node\Microsoft\.NETFramework\v4.0.30319" -Name "SchUseStrongCrypto" -Type DWord -Value 1
    # Write-output "Disabling .NET strong cryptography..."
    # Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\.NETFramework\v4.0.30319" -Name "SchUseStrongCrypto" -ErrorAction SilentlyContinue
    # Remove-ItemProperty -Path "HKLM:\SOFTWARE\Wow6432Node\Microsoft\.NETFramework\v4.0.30319" -Name "SchUseStrongCrypto" -ErrorAction SilentlyContinue

    Write-output "erstelle windows update shortcut..."
    $WshShell = New-Object -comObject WScript.Shell
    $myName = Get-Date -Format "yyMM"
    $myUpdateDateVernuepfung = "(" + $myName + ")"

    
    $Shortcut = $WshShell.CreateShortcut("$Home\Desktop\update " + $myUpdateDateVernuepfung + ".lnk")
    $Shortcut.TargetPath = "ms-settings:windowsupdate-action"
    $Shortcut.Save()
    EnableFDResPub

    $RegKey = "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\"
    Set-ItemProperty -path $RegKey -Name "RegisteredOwner"  -value install
    Set-ItemProperty -path $RegKey -name "RegisteredOrganization"  -value "trbs $myUpdateDateVernuepfung"
}
Function EnableFDResPub {
    # :: https://www.tenforums.com/performance-maintenance/138011-restore-windows-services-default-startup-settings.html
    # :: sc config fdPHost start=auto
    # :: net start fdPHost 

    # :: Funktionssuche-Ressourcenveröffentlichung
    # sc config FDResPub start=auto
    # net start FDResPub 
    Write-Output "Aktiviere Funktionssuche-Ressourcenveröffentlichung..."
    Set-Service "FDResPub" -StartupType Automatic
    Start-Service "FDResPub" -WarningAction SilentlyContinue
}
function trbsUninstall {

    

    Write-Output "Uninstalling default Microsoft applications..."
    Get-AppxPackage "Microsoft.YourPhone" | Remove-AppxPackage
    Get-AppxPackage "Microsoft.Office.OneNote" | Remove-AppxPackage
    Get-AppxPackage "Microsoft.MixedReality.Portal" | Remove-AppxPackage
    Get-AppxPackage "Microsoft.MicrosoftStickyNotes" | Remove-AppxPackage
    Get-AppxPackage "Microsoft.MicrosoftOfficeHub" | Remove-AppxPackage

    Write-Output "Uninstalling default third party applications..."
    Get-AppxPackage "SpotifyAB.SpotifyMusic" | Remove-AppxPackage
    Get-AppxPackage "XINGAG.XING" | Remove-AppxPackage
    
}

function trbsUninstallOneDrive {
    
    If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\OneDrive")) {
        New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\OneDrive" | Out-Null
    }
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\OneDrive" -Name "DisableFileSyncNGSC" -Type DWord -Value 1
    Write-Host "Uninstalling OneDrive..."
    Stop-Process -Name "OneDrive" -ErrorAction SilentlyContinue
    Start-Sleep -s 2
    $onedrive = "$env:SYSTEMROOT\SysWOW64\OneDriveSetup.exe"
    If (!(Test-Path $onedrive)) {
        $onedrive = "$env:SYSTEMROOT\System32\OneDriveSetup.exe"
    }
    Start-Process $onedrive "/uninstall" -NoNewWindow -Wait
    Start-Sleep -s 2
    Stop-Process -Name "explorer" -ErrorAction SilentlyContinue
    Start-Sleep -s 2
    Remove-Item -Path "$env:USERPROFILE\OneDrive" -Force -Recurse -ErrorAction SilentlyContinue
    Remove-Item -Path "$env:LOCALAPPDATA\Microsoft\OneDrive" -Force -Recurse -ErrorAction SilentlyContinue
    Remove-Item -Path "$env:PROGRAMDATA\Microsoft OneDrive" -Force -Recurse -ErrorAction SilentlyContinue
    Remove-Item -Path "$env:SYSTEMDRIVE\OneDriveTemp" -Force -Recurse -ErrorAction SilentlyContinue
    If (!(Test-Path "HKCR:")) {
        New-PSDrive -Name HKCR -PSProvider Registry -Root HKEY_CLASSES_ROOT | Out-Null
    }
    Remove-Item -Path "HKCR:\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" -Recurse -ErrorAction SilentlyContinue
    Remove-Item -Path "HKCR:\Wow6432Node\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" -Recurse -ErrorAction SilentlyContinue
    #$wshell.Popup("Operation Completed", 0, "Done", 0x0)
}

#region "Recommended Titus Customizations"
#########
# Recommended Titus Customizations
#########

function Show-Choco-Menu {
    param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$Title,
    
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$ChocoInstall
    )
   
    do {
        Write-Host "=== $Title ================"
        Write-Host "Y: Press 'Y' t
        o do this."
        Write-Host "2: Press 'N' to skip this."
        Write-Host "Q: Press 'Q' to stop the entire script."
        $selection = Read-Host "Please make a selection"
        switch ($selection) {
            'y' { choco install $ChocoInstall -y }
            'n' { Break }
            'q' { Exit }
        }
    }
    until ($selection -match "y" -or $selection -match "n" -or $selection -match "q")
}
# Set-ExecutionPolicy -ExecutionPolicy RemoteSigned

Function InstallTitusProgs {
    Write-Output "Installing Chocolatey"
    Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
    choco install chocolatey-core.extension -y
    # Write-Output "Running O&O Shutup with Recommended Settings"
    # Import-Module BitsTransfer
    # Start-BitsTransfer -Source "https://raw.githubusercontent.com/ChrisTitusTech/win10script/master/ooshutup10.cfg" -Destination ooshutup10.cfg
    # Start-BitsTransfer -Source "https://dl5.oo-software.com/files/ooshutup10/OOSU10.exe" -Destination OOSU10.exe
    # ./OOSU10.exe ooshutup10.cfg /quiet
}



#endregion

#region "CHOCO Install Questions"

Function InstallVscode {
    Show-Choco-Menu -Title "Do you want to install VSCODE ?" -ChocoInstall "vscode"
}
Function Install7Zip {
    Show-Choco-Menu -Title "Do you want to install 7zip ?" -ChocoInstall "7zip.install"
}
Function InstallNodeJs {
    Show-Choco-Menu -Title "Do you want to install NodeJs ?" -ChocoInstall "nodejs-lts"
}
Function InstallGit {
    Show-Choco-Menu -Title "Do you want to install GIT ?" -ChocoInstall "git.install"
}
Function Install1password {
    Show-Choco-Menu -Title "Do you want to 1password ?" -ChocoInstall "1password"
}
Function InstallFilezilla {
    Show-Choco-Menu -Title "Do you want to install filezilla ?" -ChocoInstall "filezilla"
}
Function InstallChocolateygui {
    Show-Choco-Menu -Title "install chocolateygui ?" -ChocoInstall "chocolateygui"
}

#
# NOT USED
#
# choco install google-drive-file-stream
# choco install postman
# choco install fiddler
# choco install sonos-controller
# choco install 1password
# choco install whatsapp
# choco install ilspy

Function InstallAdobe {
    Show-Choco-Menu -Title "Do you want to install Adobe Acrobat Reader?" -ChocoInstall "adobereader"
}

Function InstallBrave {
    do {
        Clear-Host
        Write-Host "================ Do You Want to Install Brave Browser? ================"
        Write-Host "Y: Press 'Y' to do this."
        Write-Host "2: Press 'N' to skip this."
        Write-Host "Q: Press 'Q' to stop the entire script."
        $selection = Read-Host "Please make a selection"
        switch ($selection) {
            'y' { 
                Invoke-WebRequest -Uri "https://laptop-updates.brave.com/download/CHR253" -OutFile $env:USERPROFILE\Downloads\brave.exe
                ~/Downloads/brave.exe
            }
            'n' { Break }
            'q' { Exit }
        }
    }
    until ($selection -match "y" -or $selection -match "n" -or $selection -match "q")
	
}
Function Install7Zip {
    Show-Choco-Menu -Title "Do you want to install 7-Zip?" -ChocoInstall "7zip"
}

Function InstallNotepadplusplus {
    Show-Choco-Menu -Title "Do you want to install Notepad++?" -ChocoInstall "notepadplusplus"
}

Function InstallVLC {
    Show-Choco-Menu -Title "Do you want to install VLC?" -ChocoInstall "vlc"
}

Function InstallIrfanview {
    Show-Choco-Menu -Title "Do you want to install Irfanview?" -ChocoInstall "irfanview"
}

Function ChangeDefaultApps {
    Write-Output "Setting Default Programs - Notepad++ Brave VLC IrFanView"
    Start-BitsTransfer -Source "https://raw.githubusercontent.com/ChrisTitusTech/win10script/master/MyDefaultAppAssociations.xml" -Destination $HOME\Desktop\MyDefaultAppAssociations.xml
    dism /online /Import-DefaultAppAssociations:"%UserProfile%\Desktop\MyDefaultAppAssociations.xml"
}

#endregion

##########
# Auxiliary Functions
##########

#region Auxiliary Functions
# Relaunch the script with administrator privileges
Function RequireAdmin {
    If (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]"Administrator")) {
        Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`" $PSCommandArgs" -WorkingDirectory $pwd -Verb RunAs
        Exit
    }
    Write-Output "welcome administrator..."
    pause
}

# Wait for key press
Function WaitForKey {
    Write-Output "Press any key to continue..."
    [Console]::ReadKey($true) | Out-Null
}

# Restart computer
Function Restart {
    Write-Output "Restarting..."
    Restart-Computer
}
Function CreateRestorePoint {
    Write-Output "Creating Restore Point incase something bad happens"
    Enable-ComputerRestore -Drive "C:\"
    $myName = Get-Date -Format "yyMM"
    #$restorePointName = ("TR-Config RestorePoint " + $myName)
    Checkpoint-Computer -Description "trbs autoRestorePoint $myName ================"  -RestorePointType "MODIFY_SETTINGS"
}
#endregion


# Normalize path to preset file
$preset = ""
$PSCommandArgs = $args
If ($args -And $args[0].ToLower() -eq "-preset") {
    $preset = Resolve-Path $($args | Select-Object -Skip 1)
    $PSCommandArgs = "-preset `"$preset`""
}

# Load function names from command line arguments or a preset file
If ($args) {
    $tweaks = $args
    If ($preset) {
        $tweaks = Get-Content $preset -ErrorAction Stop | ForEach { $_.Trim() } | Where { $_ -ne "" -and $_[0] -ne "#" }
    }
}

# Call the desired tweak functions
$tweaks | ForEach { Invoke-Expression $_ }



Write-Output "How to view installed apps with PowerShell on Windows 10..."
Write-Output "Get-AppxPackage -AllUsers | Select Name, PackageFullName"