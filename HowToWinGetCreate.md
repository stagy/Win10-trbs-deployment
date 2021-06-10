# HowToWinGetCreate

Step by step instructions for creating a manifest for the command 
```powershell
winget install --manifest \<file>
```


## Install winget and wingetcreate

To create your own manifest it is best to install winget first and get it running.
There are several instructions to get winget up and running.

Use the command
```powershell
winget install wingetcreate
``` 
to install the Windows Package Manager Manifest Creator.


## Create Manifest with wingetcreate

You will need a unique download link to a program installer. The setup should also support a silent setup.

Start the creation of a new manifest with the command 
```powershell
wingetcreate new
``` 

Specify the link and click through the options from the creater tool and in the end do NOT submit the manifest to the Windows package manager repository. 

If the creator has run through, the locale path where the manifest is located is given at the end.

## Install a Programm 

With the command
```powershell
winget install --manifest \<file>
``` 
a locally stored manifest can be installed. Of course, the correct path to the manifest must be specified instead of "\<file>".
