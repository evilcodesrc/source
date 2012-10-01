#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Outfile=..\..\..\Users\RedFenix\Desktop\AutoScreen.exe
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
;===========================================
;===Created by: evilcode====================
;===Last update: 01/10/2012=================
;===Creative Commons(http://bit.ly/evilcc)==
;===========================================
#include <FTPEx.au3>
#include <Array.au3>
#include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#Include <File.au3>
#include <ScreenCapture.au3>

Global $Conn, $Open, $username, $pass, $server

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
		MsgBox(0,"Fatto!","Fatto! Il programma ora si chiuderà per applicare le modifiche")
	EndIf
	Exit
EndIf

$username = IniRead(@ScriptDir & "/load.ini","login","user","")
$server = IniRead(@ScriptDir & "/load.ini","login","site","")
$pass = IniRead(@ScriptDir & "/load.ini","login","password","")
Connect()

Func Connect()
$Open = _FTP_Open('MyFTP Control')
$Conn = _FTP_Connect($Open, $server, $username, $pass)
If $Open = 0 Then
	MsgBox(0,"","Errore connessione")
	Exit
EndIf
EndFunc

HotKeySet("{F6}","Chiudi")
HotKeySet("{F7}","Screen")
TrayTip("","Avviato" & @CRLF & "F7: screen" & @CRLF & "F6: chiudi",1)

While 1
	Sleep(100)
WEnd

Func Screen()
	$random = Int(Random(1, 10000000))
	_ScreenCapture_Capture(@ScriptDir & "\" & $random & ".jpg")
	TrayTip("","Elaboro...",10)
	$upload = _FTP_FilePut($Conn, @ScriptDir & "\" & $random & ".jpg","/img/images/" & $random & ".jpg")
	If $upload = 0 Then
		MsgBox(0,"Errore","Errore durante il caricamento del file")
		Exit
	EndIf
	ClipPut("http://" & $server & "/img/images/" & $random & ".jpg")
	TrayTip("","Link copiato negli appunti",5)
	FileDelete(@ScriptDir & "\" & $random & ".jpg")
EndFunc

Func Chiudi()
	$Ftpc = _FTP_Close($Open)
	Exit
EndFunc