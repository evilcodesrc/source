#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Outfile=MinecraftInstaller v2.exe
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
;===========================================
;===Created by: evilcode====================
;===Last update: 15/10/2012=================
;===Creative Commons(http://bit.ly/evilcc)==
;===========================================
#include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>
#include <ProgressConstants.au3>
#include <WindowsConstants.au3>
#include <Zip.au3>
#include <INet.au3>
#include <Process.au3>
Opt("GUIOnEventMode", 1)

if @Compiled Then
	If FileExists(@AppDataDir & "/.minecraft/lastlogin") Then
		MsgBox(0,"Minecraft è già installato!","Minecraft è già installato!")
		Exit
	EndIf
EndIf

$link = "http://redfenix.altervista.org/minecraft.zip"
$link2 = "http://redfenix.altervista.org/MinecraftSP.exe"
$ver = _INetGetSource("http://redfenix.altervista.org/mcver.html")

#Region ### START Koda GUI section ### Form=
$Form1 = GUICreate("MCInstaller", 237, 94, -1, -1)
GUISetOnEvent($GUI_EVENT_CLOSE, "Form1Close")
$Installa = GUICtrlCreateButton("Installa", 80, 16, 83, 41)
GUICtrlSetOnEvent(-1, "InstallaClick")
$java = GUICtrlCreateButton("Java", 168, 40, 59, 17)
GUICtrlSetOnEvent(-1, "javaClick")
$ati = GUICtrlCreateButton("Driver ATI", 8, 40, 67, 17)
GUICtrlSetOnEvent(-1, "atiClick")
$nvidia = GUICtrlCreateButton("Driver nVidia", 8, 16, 67, 17)
GUICtrlSetOnEvent(-1, "nvidiaClick")
$Progress = GUICtrlCreateProgress(7, 72, 222, 17)
GUICtrlCreateLabel("MC: " & $ver, 168, 16)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

While 1
	Sleep(100)
WEnd

Func Form1Close()
	Exit
EndFunc

Func InstallaClick()
	DisableAll()
	if FileExists(@ScriptDir & "\minecraft.zip") = 0 Then
		$download = InetGet($link,@ScriptDir & "\minecraft.zip",1,1)
		$size = InetGetSize($link)
		If $size = 0 Then
			MsgBox(0,"Errore","Errore nel download: file non trovato")
			Return($Form1)
		EndIf
		Do
			$bytes = InetGetInfo($Download, 0)
			$nbytes = $bytes / $size * 100
			$perc = Int($bytes / $size * 100)
			GUICtrlSetData($Progress,$nbytes)
			Sleep(1)
		Until InetGetInfo($download, 2)
		Extract()
	Else
		Extract()
	EndIf
	GUICtrlSetData($Progress,100)
	if FileExists(@ScriptDir & "\minecraftsp.exe") = 0 Then
		$download = InetGet($link2,@ScriptDir & "\minecraftsp.exe",1)
	EndIf
	FileMove(@ScriptDir & "\minecraftsp.exe",@DesktopDir & "\MinecraftSP.exe")
	FileDelete(@ScriptDir & "\minecraft.zip")
	MsgBox(0,"Completato!","Operazione completata!")
	EnableAll()
EndFunc

Func Extract()
	_Zip_UnzipAll(@ScriptDir & "\minecraft.zip",@AppDataDir)
EndFunc

Func DisableAll()
	GUICtrlSetData($installa,"Attendi...")
	GUICtrlSetState($ati,$GUI_DISABLE)
	GUICtrlSetState($nvidia,$GUI_DISABLE)
	GUICtrlSetState($installa,$GUI_DISABLE)
	GUICtrlSetState($java,$GUI_DISABLE)
EndFunc

Func EnableAll()
	GUICtrlSetState($ati,$GUI_ENABLE)
	GUICtrlSetState($nvidia,$GUI_ENABLE)
	GUICtrlSetState($installa,$GUI_ENABLE)
	GUICtrlSetState($java,$GUI_ENABLE)
	GUICtrlSetData($installa,"Installa")
	GUICtrlSetData($Progress,0)
EndFunc

Func javaClick()
	_RunDos("start http://www.java.com/it/download/")
EndFunc

Func nvidiaClick()
	_RunDos("start http://www.nvidia.it/Download/index.aspx?lang=it")
EndFunc

Func atiClick()
	_RunDos("start http://support.amd.com/it/gpudownload/windows/Pages/auto_detect.aspx")
EndFunc