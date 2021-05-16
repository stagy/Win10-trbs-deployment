net stop wuauserv 
net stop bits 
rd /s /q %windir%\SoftwareDistribution\Download 
net start wuauserv 
net start bits wuauclt.exe /updatenow