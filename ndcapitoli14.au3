#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Outfile=Naruto Capitoli Downloader 1.4.exe
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
;===========================================
;===Created by: evilcode====================
;===Last update: 26/09/2012=================
;===Creative Commons(http://bit.ly/evilcc)==
;===========================================
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <Process.au3>
#include <Zip.au3>

If InetGetSize("http://redfenix.altervista.org/narutosw/stream.txt") = 0 Then
	MsgBox(48,"Errore di connessione","La connessione sembra essere inattiva, riprova più tardi.")
	Exit
EndIf
If Ping("www.narutoplanet.it") = 0 Then
	MsgBox(0,"Errore","Il server per i capitoli non sembra essere disponibile, riprova più tardi.")
	Exit
EndIf

$ver = "1.4"
$cap = "..."

Opt("GUIOnEventMode", 1)
#Region ### START Koda GUI section ### Form=
$FormCap = GUICreate("NCap " & $ver, 188, 142, -1, -1)
GUISetOnEvent($GUI_EVENT_CLOSE, "FormCapClose")
$ButtonCap = GUICtrlCreateButton("Download ultimo cap. " & $cap, 8, 16, 171, 25)
GUICtrlSetOnEvent(-1, "ButtonCapClick")
$InputCap = GUICtrlCreateInput("", 63, 85, 65, 21, BitOR($GUI_SS_DEFAULT_INPUT,$ES_NUMBER))
$Label12 = GUICtrlCreateLabel("Capitolo personalizzato:", 36, 68, 115, 17)
$ButtonCap2 = GUICtrlCreateButton("Download", 52, 109, 83, 25)
GUICtrlSetOnEvent(-1, "ButtonCap2Click")
$Status = GUICtrlCreateLabel("Carico capitoli...", 8, 45, -1, 17)
GUICtrlSetColor(-1,0xff0000)
GUISetState(@SW_HIDE)
#EndRegion ### END Koda GUI section ###

Global $msize, $cap2, $ctrl, $linkc
Disable_All()
GUISetState(@SW_SHOW)
Check()

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
			If InetGetSize($linkc & $cap & ".zip",1) = 0 Then
				ExitLoop
			Else
				$cap = $cap + 1
			EndIf
			$diff = TimerDiff($begin)
			ConsoleWrite(Int($diff) & " millisecondi" & @CRLF)
			If $diff > 60000 Then
				MsgBox(0,"Problemi di connessione","Il programma sta impiegando troppo tempo a caricare i capitoli, permi Ok per chiuderlo.")
				Exit
			EndIf
		WEnd
		$cap = $cap - 1
		ConsoleWrite(@CRLF & "Capitolo in uso: " & $cap)
		$msize = InetGetSize($linkc & $cap & ".zip")

		If $cap > RegRead("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\MyKeys","KeyND") Then
			RegWrite("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\MyKeys","KeyND","REG_SZ",$cap)
		EndIf

		If $cap < RegRead("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\MyKeys","KeyND") Then
			MsgBox(48,"Hmm, possibili rallentamenti!","Il programma ha subito rallentamenti nella ricerca dei capitoli, potrebbe non aver trovato il corretto ultimo capitolo." & @CRLF & "Se il problema persiste disattiva il firewall o l'antivirus.")
		EndIf

		GUICtrlSetData($ButtonCap, "Download ultimo cap. " & $cap)
		Enable_All()
		GUICtrlSetData($Status, "")
EndFunc

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
	$dom = MsgBox(4,"Completato!","Download completato, estrarre i file dall'archivio .zip?")
	If $dom = 6 Then
		 _Zip_UnzipAll($savem & ".zip",$savem & "\Capitolo " & $cap & " (downloaded with narutodl)")
	EndIf
EndFunc

Func Enable_All()
	GUICtrlSetState($ButtonCap, $GUI_ENABLE)
	GUICtrlSetState($InputCap, $GUI_ENABLE)
	GUICtrlSetState($ButtonCap2, $GUI_ENABLE)
EndFunc

Func Disable_All()
	GUICtrlSetState($ButtonCap, $GUI_DISABLE)
	GUICtrlSetState($InputCap, $GUI_DISABLE)
	GUICtrlSetState($ButtonCap2, $GUI_DISABLE)
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
	$dom = MsgBox(4,"Completato!","Download completato, estrarre i file dall'archivio .zip?")
	If $dom = 6 Then
		 _Zip_UnzipAll($savem & ".zip",$savem & "\Capitolo " & $cap & " (downloaded with narutodl)")
	EndIf
EndFunc

Func Controllo()
	$ctrl = 0
	If GUICtrlRead($InputCap) > $cap Then
		$nocap = MsgBox(48,"Capitolo non disponibile","Il capitolo richiesto non è ancora stato inserito o il link è danneggiato."&@CRLF&"Per ulteriori informazioni visita il link: www.narutoplanet.it")
		$ctrl = 1
	EndIf
EndFunc

Func FormCapClose()
	Exit
EndFunc