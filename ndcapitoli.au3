#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Outfile=Naruto Capitoli Downloader 1.2.exe
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>

#include <Process.au3>

If InetGetSize("http://redfenix.altervista.org/narutosw/stream.txt") = 0 Then
	MsgBox(48,"Errore di connessione","La connessione sembra essere inattiva, riprova più tardi.")
	Exit
EndIf

TrayTip("","Carico capitoli...",30)
$linkc = "http://www.narutoplanet.it/downloads/naruto-capitolo-"
If RegRead("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\MyKeys","KeyND") = "" Then
	$cap = 596
Else
	$cap = RegRead("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\MyKeys","KeyND")
EndIf
ConsoleWrite($cap & "<----" & @CRLF & @CRLF)
While 1
	ConsoleWrite($cap & " online" & @CRLF)
	If InetGetSize($linkc & $cap & ".zip",1) = 0 Then
		ExitLoop
	Else
		$cap = $cap + 1
	EndIf
WEnd
$cap = $cap - 1
ConsoleWrite(@CRLF & $cap)
$msize = InetGetSize($linkc & $cap & ".zip")
TrayTip("","",1)

RegWrite("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\MyKeys","KeyND","REG_SZ",$cap)

Opt("GUIOnEventMode", 1)
#Region ### START Koda GUI section ### Form=
$FormCap = GUICreate("Naruto Cap DL", 188, 142, -1, -1)
GUISetOnEvent($GUI_EVENT_CLOSE, "FormCapClose")
$ButtonCap = GUICtrlCreateButton("Download ultimo cap. " & $cap, 8, 16, 171, 25)
GUICtrlSetOnEvent(-1, "ButtonCapClick")
$InputCap = GUICtrlCreateInput("", 63, 80, 65, 21, BitOR($GUI_SS_DEFAULT_INPUT,$ES_NUMBER))
$Label12 = GUICtrlCreateLabel("Capitolo personalizzato:", 36, 63, 115, 17)
$ButtonCap2 = GUICtrlCreateButton("Download", 52, 104, 83, 25)
GUICtrlSetOnEvent(-1, "ButtonCap2Click")
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

Global $msize, $cap2, $ctrl

HotKeySet("{F5}","SetCustomCap")

While 1
	Sleep(100)
WEnd

Func ButtonCapClick()
	GUICtrlSetState($InputCap,$GUI_DISABLE)
	GUICtrlSetState($ButtonCap,$GUI_DISABLE)
	GUICtrlSetState($ButtonCap2,$GUI_DISABLE)
	GUICtrlSetData($ButtonCap,"Attendo...")
	$savem = FileSaveDialog("Dove salvo il file?",@desktopdir,"Archivio (*.zip)","",$cap)
	If @error Then
		GUICtrlSetState($InputCap,$GUI_ENABLE)
		GUICtrlSetState($ButtonCap,$GUI_ENABLE)
	GUICtrlSetState($ButtonCap2,$GUI_ENABLE)
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
	GUICtrlSetState($ButtonCap2,$GUI_ENABLE)
	GUICtrlSetState($ButtonCap,$GUI_ENABLE)
	GUICtrlSetState($InputCap,$GUI_ENABLE)
	MsgBox(0,"Completato!","Download completato!")
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
	GUICtrlSetState($InputCap,$GUI_DISABLE)
	GUICtrlSetState($ButtonCap2,$GUI_DISABLE)
	GUICtrlSetData($ButtonCap2,"Attendo...")
	$savem = FileSaveDialog("Dove salvo il file?",@desktopdir,"Archivio (*.zip)","",$cap2)
	If @error Then
		GUICtrlSetState($InputCap,$GUI_ENABLE)
		GUICtrlSetState($ButtonCap2,$GUI_ENABLE)
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
	GUICtrlSetState($ButtonCap2,$GUI_ENABLE)
	GUICtrlSetState($InputCap,$GUI_ENABLE)
	MsgBox(0,"Completato!","Download completato!")
EndFunc

Func Controllo()
	$ctrl = 0
	If GUICtrlRead($InputCap) > $cap Then
		$nocap = MsgBox(48,"Capitolo non disponibile","Il capitolo richiesto non è ancora stato inserito o il link è danneggiato."&@CRLF&"Per ulteriori informazioni visita il link: www.narutoplanet.it")
		$ctrl = 1
	EndIf
EndFunc

Func SetCustomCap()
	$customcap = InputBox("Imposta capitolo","FUNZIONE DEBUG:"&@CRLF&"Per attivare il controllo automatico a partire da un determinato capitolo, scrivilo qui sotto :D")
	If @error Then
		Return($FormCap)
	EndIf
	RegWrite("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\MyKeys","KeyND","REG_SZ",$customcap)
	MsgBox(0,"Fatto!","Completato!")
EndFunc

Func FormCapClose()
	Exit
EndFunc