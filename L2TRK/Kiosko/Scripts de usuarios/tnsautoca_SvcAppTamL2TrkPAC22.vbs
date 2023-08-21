On error resume next

'=============================================== VARS ===============================================
dontShowWindow = 0 	
bWaitOnReturn = True		

Set fso = CreateObject("Scripting.FileSystemObject")
Set shell = CreateObject("WScript.Shell")

FileDirectory = fso.GetParentFolderName(WScript.ScriptFullName)
ParentFileDirectory = fso.GetParentFolderName(FileDirectory)

PinLinks_path = ParentFileDirectory & "\Common\DesktopL2.vbs APP_CAB_HOR_DESKTOP"

'=============================================== MAIN ===============================================

shell.run PinLinks_path,dontShowWindow,bWaitOnReturn


Call shell.run("%COMSPEC% /c mkdir ""D:\Appls""",0,true)
 
Call shell.run("%COMSPEC% /c mkdir ""%APPDATA%\Tenaris.Service.ClientLauncher""",0,true)
  
fso.copyfolder "\\TNACAWFM197.tnsautoca.techint.net\Appls\ClientLauncher", "D:\Appls\Tenaris" ,true

Set WSHNetwork = CreateObject("WScript.Network")

strUser = CreateObject("WScript.Network").UserName

WSHNetwork.MapNetworkDrive "D:", "\\TNACAWFM197.tnsautoca.techint.net\Appls\Logs\" + strUser

shell.run """C:\Users\" + "%USERNAME%" + "\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\1-TENARIS_LAUNCHER.lnk"""



'Shell.run """powershell.exe""" + """D:\Appls\Tenaris\Tenaris.SetCulture.ps1"""









