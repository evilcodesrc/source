#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Outfile=Naruto Capitoli Downloader 1.6.exe
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
;===========================================
;===Created by: evilcode====================
;===Last update: 25/10/2012=================
;===Creative Commons(http://bit.ly/evilcc)==
;===========================================
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <Process.au3>
#include <Zip.au3>
#include <WinAPI.au3>
#NoTrayIcon

If Not FileExists(@ScriptDir & "\stream\stream.exe") Then
	MsgBox(16,"Errore","Il programma non ha trovato l'eseguibile per lo stream dei capitoli, riscarica il pacchetto da evil-code.net")
	Exit
EndIf

If InetGetSize("http://redfenix.altervista.org/narutosw/stream.txt") = 0 Then
	MsgBox(48,"Errore di connessione","La connessione sembra essere inattiva, riprova pi� tardi.")
	Exit
EndIf

if @Compiled Then
	If Ping("www.narutoplanet.it") = 0 Then
		MsgBox(0,"Errore","Il server per i capitoli non sembra essere disponibile, riprova pi� tardi.")
		Exit
	EndIf
EndIf

if FileExists(@ScriptDir & "\hide.txt") = 1 Then
	$func = 170
	$debug = 1
Else
	$func = 150
	$debug = 0
EndIf

$ver = "1.6"
$cap = "..."

Opt("GUIOnEventMode", 1)
#Region ### START Koda GUI section ### Form=
$FormCap = GUICreate("Attendi...", 188, $func, -1, -1)
GUISetOnEvent($GUI_EVENT_CLOSE, "FormCapClose")
$ButtonCap = GUICtrlCreateButton("Download ultimo cap. " & $cap, 8, 10, 171, 25)
GUICtrlSetOnEvent(-1, "ButtonCapClick")
$ButtonStream =  GUICtrlCreateButton("Leggi online l'ultimo capitolo!", 8, 35, 171, 25)
GUICtrlSetOnEvent(-1,"ButtonStreamClick")
$InputCap = GUICtrlCreateInput("", 8, 85, 65, 21, BitOR($GUI_SS_DEFAULT_INPUT,$ES_NUMBER))
$Label12 = GUICtrlCreateLabel("Capitolo personalizzato:", 36, 68, 115, 17)
$ButtonCap2 = GUICtrlCreateButton("Download", 80, 85, 83, 21)
GUICtrlSetOnEvent(-1, "ButtonCap2Click")
$ButtonReload = GUICtrlCreateButton("Aggiorna", 52, 120, 83, 25)
GUICtrlSetOnEvent(-1, "ButtonReloadClick")
GUISetState(@SW_HIDE)
#EndRegion ### END Koda GUI section ###

If $debug = 1 Then
	$labeld = GUICtrlCreateLabel("..............................", 8, 156)
EndIf

Global $msize, $cap2, $ctrl, $linkc,$labeld
Disable_All()
GUISetState(@SW_SHOW)
Check()
_WinAPI_SetWindowText($FormCap, "NDCap " & $ver)

While 1
	Sleep(100)
WEnd

Func Check()
		$linkc = "http://www.narutoplanet.it/downloads/naruto-capitolo-"
	If RegRead("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\MyKeys","KeyND") = "" Then
		$cap = 600
	Else
		$cap = RegRead("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\MyKeys","KeyND")
	EndIf
		ConsoleWrite($cap & "<----" & @CRLF & @CRLF)
		$begin = TimerInit()
		While 1
			ConsoleWrite($cap & " online" & @CRLF)
			GUICtrlSetData($labeld,$cap & " online") ;debug
			If InetGetSize($linkc & $cap & ".zip",1) = 0 Then
				ExitLoop
			Else
				$cap = $cap + 1
			EndIf
			$diff = TimerDiff($begin)
			ConsoleWrite(Int($diff) & " millisecondi" & @CRLF)
			GUICtrlSetData($labeld,Int($diff) & " millisecondi") ;debug
			If $diff > 60000 Then
				MsgBox(0,"Problemi di connessione","Il programma sta impiegando troppo tempo a caricare i capitoli, permi Ok per chiuderlo.")
				Exit
			EndIf
		WEnd
		$cap = $cap - 1
		ConsoleWrite(@CRLF & "Capitolo in uso: " & $cap)
		GUICtrlSetData($labeld,"Capitolo in uso: " & $cap) ;debug
		$msize = InetGetSize($linkc & $cap & ".zip")

		If $cap > RegRead("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\MyKeys","KeyND") Then
			RegWrite("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\MyKeys","KeyND","REG_SZ",$cap)
		EndIf

		If $cap < RegRead("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\MyKeys","KeyND") Then
			MsgBox(48,"Hmm, possibili rallentamenti!","Il programma ha subito rallentamenti nella ricerca dei capitoli, potrebbe non aver trovato il corretto ultimo capitolo." & @CRLF & "Se il problema persiste disattiva il firewall o l'antivirus.")
		EndIf

		GUICtrlSetData($ButtonCap, "Download ultimo cap. " & $cap)
		Enable_All()
EndFunc

Func ButtonReloadClick()
	Disable_All()
	GUISetState(@SW_SHOW)
	Check()
EndFunc

Func ButtonStreamClick()
	If FileExists(@ScriptDir & "\stream\lastc.txt") Then
		FileDelete(@ScriptDir & "\stream\lastc.txt")
	EndIf
	FileWrite(@ScriptDir & "\stream\lastc.txt",$cap)
	ShellExecuteWait(@ScriptDir & "\stream\stream.exe")
EndFunc

Func Disable1()
	GUICtrlSetColor($Label12,"0x999999")
	GUICtrlSetState($InputCap,$GUI_DISABLE)
	GUICtrlSetState($ButtonCap,$GUI_DISABLE)
	GUICtrlSetState($ButtonCap2,$GUI_DISABLE)
	GUICtrlSetState($ButtonStream,$GUI_DISABLE)
	GUICtrlSetState($ButtonReload,$GUI_DISABLE)
EndFunc

Func Enable1()
	GUICtrlSetColor($Label12,"0x000000")
	GUICtrlSetState($InputCap,$GUI_ENABLE)
	GUICtrlSetState($ButtonCap,$GUI_ENABLE)
	GUICtrlSetState($ButtonCap2,$GUI_ENABLE)
	GUICtrlSetState($ButtonStream,$GUI_ENABLE)
	GUICtrlSetState($ButtonReload,$GUI_ENABLE)
EndFunc

Func ButtonCapClick()
	Disable1()
	GUICtrlSetData($ButtonCap,"Attendo...")
	$savem = FileSaveDialog("Dove salvo il file?",@desktopdir,"Archivio (*.zip)","",$cap)
	If @error Then
		Enable1()
		GUICtrlSetData($ButtonCap,"Download ultimo cap. " & $cap)
		Return($FormCap)
	EndIf
	$msize = InetGetSize($linkc & $cap & ".zip")
	$mdown = InetGet($linkc & $cap & ".zip",$savem & ".zip",1,1)
	Do
		$bytes = InetGetInfo($mdown, 0)
		$mperc = Int($bytes / $msize * 100)
		GUICtrlSetData($ButtonCap,"Scarico: "&$mperc&"%")
		Sleep(1)
	Until InetGetInfo($mdown, 2)
    InetClose($mdown)
	GUICtrlSetData($ButtonCap,"Download ultimo cap. " & $cap)
	Enable1()
	$dom = MsgBox(4,"Completato!","Download completato, estrarre i file dall'archivio .zip?")
	If $dom = 6 Then
		 _Zip_UnzipAll($savem & ".zip",$savem & "\Capitolo " & $cap & " (downloaded with narutodl)")
	EndIf
EndFunc

Func Enable_All()
	GUICtrlSetColor($Label12,"0x000000")
	GUICtrlSetState($ButtonStream, $GUI_ENABLE)
	GUICtrlSetState($ButtonCap, $GUI_ENABLE)
	GUICtrlSetState($InputCap, $GUI_ENABLE)
	GUICtrlSetState($ButtonCap2, $GUI_ENABLE)
	GUICtrlSetState($ButtonReload,$GUI_ENABLE)
EndFunc

Func Disable_All()
	GUICtrlSetColor($Label12,"0x999999")
	GUICtrlSetState($ButtonStream, $GUI_DISABLE)
	GUICtrlSetState($ButtonCap, $GUI_DISABLE)
	GUICtrlSetState($InputCap, $GUI_DISABLE)
	GUICtrlSetState($ButtonCap2, $GUI_DISABLE)
	GUICtrlSetState($ButtonReload,$GUI_DISABLE)
EndFunc

Func ButtonCap2Click()
	If GUICtrlRead($InputCap) = "" Then
		MsgBox(16,"Errore","Inserisci il numero del capitolo nell'apposito spazio")
		Return($FormCap)
	EndIf
	$cap2 = GUICtrlRead($InputCap)
	Controllo()
	If $ctrl = 1 Then
		Return($FormCap)
	EndIf
	Disable1()
	GUICtrlSetData($ButtonCap2,"Attendo...")
	$savem = FileSaveDialog("Dove salvo il file?",@desktopdir,"Archivio (*.zip)","",$cap2)
	If @error Then
		Enable1()
		GUICtrlSetData($ButtonCap2,"Download")
		Return($FormCap)
	EndIf
	$msize = InetGetSize($linkc & $cap2 & ".zip")
	$mdown = InetGet($linkc & $cap2 & ".zip",$savem & ".zip",1,1)
	Do
		$bytes = InetGetInfo($mdown, 0)
		$mperc = Int($bytes / $msize * 100)
		GUICtrlSetData($ButtonCap2,"Scarico: "&$mperc&"%")
		Sleep(1)
	Until InetGetInfo($mdown, 2)
    InetClose($mdown)
	GUICtrlSetData($ButtonCap2,"Download")
	Enable1()
	$dom = MsgBox(4,"Completato!","Download completato, estrarre i file dall'archivio .zip?")
	If $dom = 6 Then
		 _Zip_UnzipAll($savem & ".zip",$savem & "\Capitolo " & $cap & " (downloaded with narutodl)")
	EndIf
EndFunc

Func Controllo()
	$ctrl = 0
	If GUICtrlRead($InputCap) > $cap Then
		$nocap = MsgBox(48,"Capitolo non disponibile","Il capitolo richiesto non � ancora stato inserito o il link � danneggiato."&@CRLF&"Per ulteriori informazioni visita il link: www.narutoplanet.it")
		$ctrl = 1
	EndIf
EndFunc

Func FormCapClose()
	Exit
EndFunc