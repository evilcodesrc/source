#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Outfile=FileUpload.exe
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <FTPEx.au3>
#include <Array.au3>
#include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#Include <File.au3>

If Not FileExists(@ScriptDir & "/load.ini") Then
	$msg = MsgBox(4,"Configurazione","File di configurazione non trovato, crearlo ora?")
	If $msg = 6 Then
		$serverw = InputBox("Server","Indirizzo del server (es. sito.altervista.org)")
		If @error = 1 Then Exit
		IniWrite(@ScriptDir & "/load.ini","login","site",$serverw)
		$userw = InputBox("Username","Nome per collegarsi al server")
		If @error = 1 Then Exit
		IniWrite(@ScriptDir & "/load.ini","login","user",$userw)
		$passw = InputBox("Password","Password per accedere al sito")
		If @error = 1 Then Exit
		IniWrite(@ScriptDir & "/load.ini","login","password",$passw)
		MsgBox(0,"Fatto!","Fatto! Il programma ora si chiuder� per applicare le modifiche")
	EndIf
	Exit
EndIf

$username = IniRead(@ScriptDir & "/load.ini","login","user","")
$server = IniRead(@ScriptDir & "/load.ini","login","site","")
$pass = IniRead(@ScriptDir & "/load.ini","login","password","")
ConsoleWrite($server & " " & $username & " " & $pass)
Opt("GUIOnEventMode", 1)
#Region ### START Koda GUI section ### Form=
$Form1 = GUICreate("FileUpload", 212, 86, -1, -1)
GUISetOnEvent($GUI_EVENT_CLOSE, "Form1Close")
$Button1 = GUICtrlCreateButton("Download", 24, 32, 75, 25)
GUICtrlSetOnEvent(-1, "Button1Click")
GUICtrlSetState(-1, $GUI_DISABLE)
$Button2 = GUICtrlCreateButton("Upload", 112, 32, 75, 25)
GUICtrlSetOnEvent(-1, "Button2Click")
GUICtrlSetState(-1, $GUI_DISABLE)
$Label = GUICtrlCreateLabel("Connetto...", 24, 10, 200, 12)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

Sleep(2000)

Global $Open, $Conn, $Drive, $Dir, $Name, $Ext, $SelFile, $Link, $server
Connect()

While 1
	Sleep(100)
WEnd

Func Connect()
$Open = _FTP_Open('MyFTP Control')
$Conn = _FTP_Connect($Open, $server, $username, $pass)
If $Open = 0 Then
	GUICtrlSetData($Label,"Errore connessione. Riavvia il programma.")
Else
	GUICtrlSetData($Label,"Connesso!")
	GUICtrlSetState($Button1, $GUI_ENABLE)
	GUICtrlSetState($Button2, $GUI_ENABLE)
EndIf
EndFunc

Func Form1Close()
	$Ftpc = _FTP_Close($Open)
	Exit
EndFunc

Func Button1Click()
	GUICtrlSetState($Button1, $GUI_DISABLE)
	$SelFile = InputBox("Nome File","Inserisci il NOME del file da scaricare (ricorda l'estensione!), verr� scaricato sul desktop. RICORDA DI RISPETTARE LE MAIUSCOLE!")
	If @error Then
		GUICtrlSetState($Button1, $GUI_ENABLE)
		Return($Form1)
	EndIf
	GUICtrlSetData($Label,"Scarico...")
	If InetGetSize("http://"&$server&"/ul/" & $SelFile) = 0 Then
		GUICtrlSetData($Label,"Il file non esiste!")
		GUICtrlSetState($Button1, $GUI_ENABLE)
		Return($Form1)
	EndIf
	InetGet("http://"&$server&"/ul/" & $SelFile, @DesktopDir & "/" & $SelFile)
	GUICtrlSetData($Label,"Download completato!")
	GUICtrlSetState($Button1, $GUI_ENABLE)
EndFunc

Func Button2Click()
	GUICtrlSetState($Button2, $GUI_DISABLE)
	GUICtrlSetState($Button1, $GUI_DISABLE)
	$SelFile = FileOpenDialog("Seleziona il file da caricare",@DesktopDir,"All(*.*)")
	If @error > 0 Then
		GUICtrlSetState($Button2, $GUI_ENABLE)
		GUICtrlSetState($Button1, $GUI_ENABLE)
		Return($Form1)
	EndIf
	GUICtrlSetData($Label,"Carico...")
	_PathSplit($SelFile,$Drive,$Dir,$Name,$Ext)
	$ul = _FTP_FilePut($Conn, $SelFile, "/ul/" & $Name & $Ext)
	If $ul = 1 Then
		GUICtrlSetData($Label,"Caricamento completato :)")
		ExpandLink()
	Else
		GUICtrlSetData($Label,"Caricamento fallito :(")
	EndIf
	GUICtrlSetState($Button1, $GUI_ENABLE)
EndFunc

Func ExpandLink()
	$Pos = WinGetPos("FileUpload")
	For $i = 86 To 170
		Sleep(5)
		WinMove("FileUpload","",$Pos[0],$Pos[1],212,$i)
	Next
	$Link = GUICtrlCreateInput($server & "/ul/" & $Name & $Ext, 24, 82, 158, 21)
	$CopyLink = GUICtrlCreateButton("Copia Link", 24, 107, 75, 25)
	GUICtrlSetOnEvent(-1, "Button3Click")
EndFunc

Func Button3Click()
	ClipPut(GUICtrlRead($Link))
	GUICtrlSetData($Label,"Link copiato negli appunti!")
EndFunc