# net stop wuauserv 
# net stop bits 
# rd /s /q %windir%\SoftwareDistribution\Download 
# net start wuauserv 
# net start bits wuauclt.exe /updatenow

Stop-Service wuauserv
Stop-Service bits
Remove-Item "$env:windir\SoftwareDistribution\Download" -Recurse # -ErrorAction SilentlyContinue
Start-Service wuauserv 
#net start bits wuauclt.exe /updatenow
Start-Service bits 
#Wuauclt /dectectnow /updatenow

(New-Object -ComObject Microsoft.Update.AutoUpdate).DetectNow()