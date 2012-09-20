#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Outfile=..\..\..\Users\RedFenix\Desktop\Convertitore euro-dollaro.exe
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
;===========================================
;===Created by: evilcode====================
;===Last update: 20/09/2012=================
;===Creative Commons(http://bit.ly/evilcc)==
;===========================================
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <Misc.au3>
#include <Array.au3>
#include <INET.au3>
Opt("GUIOnEventMode", 1)

$src = _INetGetSource('http://www.cambioeurodollaro.it/')
$split = StringSplit($src,@CRLF)
For $i = 0 To $split[0]
	If StringInStr($split[$i],'<p class="cambiogiorno"><strong>') > 0 Then
		$nstring = $split[$i+0]
		$num = StringLen($nstring)
		$nstring = StringRight($nstring,$num - 40)
		$nstring = StringSplit($nstring, "$")
		ExitLoop
	EndIf
Next
$num = StringLen($nstring[1])
$nstring = StringLeft($nstring[1], $num - 1)
$veuro = $nstring ;1€ = ... dollari

#Region ### START Koda GUI section ### Form=
$Form1 = GUICreate("Convertitore valuta $ - €", 284, 70, -1, -1)
GUISetOnEvent($GUI_EVENT_CLOSE, "Form1Close")
$Input1 = GUICtrlCreateInput("0", 15, 24, 121, 21)
$Input2 = GUICtrlCreateInput("0", 151, 24, 121, 21)
$Label1 = GUICtrlCreateLabel("Dollaro", 16, 8, 37, 15)
$Label2 = GUICtrlCreateLabel("Euro", 152, 8, 26, 16)
$Button1 = GUICtrlCreateButton("<->",  114, 47, 55, 20)
GUICtrlSetOnEvent(-1, "Button1Click")
$Label3 = GUICtrlCreateLabel("1 € = " & $veuro & "$", 15, 47)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

Global $dollaro,$euro = 1
Change()

While 1
	Sleep(100)
	If $dollaro = 1 Then
	GUICtrlSetData($Input2,GUICtrlRead($Input1)/$veuro)
	EndIf
	If $euro = 1 Then
	GUICtrlSetData($Input1,GUICtrlRead($Input2)*$veuro)
	EndIf
WEnd

Func Button1Click()
	GUICtrlSetData($Input1, "0")
	GUICtrlSetData($Input2, "0")
	Change()
EndFunc

Func Change()
	If $euro = 1 Then
		GUICtrlSetState($Input1, $GUI_ENABLE)
		GUICtrlSetState($Input2, $GUI_DISABLE)
		$euro = 0
		$dollaro = 1
	ElseIf $dollaro = 1 Then
		GUICtrlSetState($Input2, $GUI_ENABLE)
		GUICtrlSetState($Input1, $GUI_DISABLE)
		$dollaro = 0
		$euro = 1
	Else
		Return($Form1)
	EndIf
EndFunc
Func Form1Close()
	Exit
EndFunc