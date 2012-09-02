#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Outfile_x64=..\..\..\Users\RedFenix\Desktop\MC Snap.exe
#AutoIt3Wrapper_UseX64=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <INet.au3>
#include <Array.au3>

$anno = "12"

Opt("GUIOnEventMode", 1)
#Region ### START Koda GUI section ### Form=
$Form1 = GUICreate("MC Snapshot DL", 235, 97, -1, -1)
GUISetOnEvent($GUI_EVENT_CLOSE, "Form1Close")
$Button1 = GUICtrlCreateButton("Last Jar", 14, 48, 90, 33)
GUICtrlSetOnEvent(-1, "Button1Click")
GUICtrlSetState(-1,$GUI_ENABLE)
$Button2 = GUICtrlCreateButton("Custom Jar", 125, 48, 90, 33)
GUICtrlSetOnEvent(-1, "Button2Click")
$Input1 = GUICtrlCreateInput("", 59, 16, 121, 21, BitOR($GUI_SS_DEFAULT_INPUT,$ES_CENTER))
GUISetState(@SW_SHOW)
GUICtrlSetState(-1,$GUI_DISABLE)
#EndRegion ### END Koda GUI section ###

Global $search, $result, $link, $string
$download = 0
$file = @ScriptDir & "\list.txt"

While 1
	Sleep(100)
WEnd

Func Button1Click()
	If $download = 0 Then
	FileDelete($file)
	GUICtrlSetState($Button1, $GUI_DISABLE)
	GUICtrlSetData($Button1, "Genero lista...")
	$source = _INetGetSource("http://www.minecraftwiki.net/wiki/Version_history/Development_versions")
		For $i = 52 To 1 Step -1
			$string = $anno & "w" & $i & "a"
			$search = StringInStr($source,$string)
			If $search > 0 Then
				$active = 1
			Else
				$active = 0
			EndIf
			FileWrite($file,$string & ";" & $active & @CRLF)
		Next
				GUICtrlSetData($Button1, "Genero...")
;~ 				$array = StringRegExp(FileRead(@ScriptDir & "\list.txt"),';0(.);1',1)
;~ 				_ArrayDisplay($array)
				$hdfile = FileOpen($file)
				While 1
					Local $line = FileReadLine($hdfile)
					If @error = -1 Then ExitLoop
					If StringRight($line,1) = 1 Then
						$string = StringLeft($line,StringLen($line)-2)
						ExitLoop
					EndIf
				WEnd
				FileClose($file)
				GUICtrlSetData($Button1, "Genero link...")
				$link = "http://assets.minecraft.net/" & $string & "/minecraft.jar"
				GUICtrlSetData($Input1, $string)
				GUICtrlSetState($Button1, $GUI_ENABLE)
				GUICtrlSetData($Button1, "Download")
				$download = 1
	Else
		GUICtrlSetData($Button1, "Download...")
		InetGet($link,@DesktopDir & "\minecraft.jar")
		$msg = MsgBox(4,"Download completato!","Inserire il file (minecraft.jar) scaricato in minecraft, sovrascrivendo la versione precedente?")
		If $msg = 6 Then
			FileMove(@DesktopDir & "\minecraft.jar", @AppDataDir & "\.minecraft\bin\",1)
			MsgBox(0,"Fatto!","Operazione completata!")
		EndIf
		GUICtrlSetData($Button1, "DL Last Snapshot")
	EndIf
	FileDelete($file)
EndFunc

Func Button2Click()
	$specify = FileOpenDialog("Seleziona manualmente il minecraft.jar",@DesktopDir,"Jar (*.Jar)")
	FileCopy($specify, @AppDataDir & "\.minecraft\bin\",1)
	MsgBox(0,"Fatto!","Operazione Completata!")
EndFunc

Func Form1Close()
   Exit
EndFunc