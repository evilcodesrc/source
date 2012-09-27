#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Outfile=Conv bin-esa-ott.exe
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
;===========================================
;===Created by: evilcode====================
;===Last update: 27/09/2012=================
;===Creative Commons(http://bit.ly/evilcc)==
;===========================================

;Includere _NumBaseConvert: http://pastebin.com/vBDRvEbR

#include <ComboConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <NumBaseConvert.au3>

Opt("GUIOnEventMode", 1)
#Region ### START Koda GUI section ### Form=
$Form1 = GUICreate("Conv bin-esa-ott", 238, 126, -1, -1)
GUISetOnEvent($GUI_EVENT_CLOSE, "Form1Close")
$Input4 = GUICtrlCreateInput("", 18, 40, 121, 21) ;binario
$Input2 = GUICtrlCreateInput("", 18, 64, 121, 21) ;esadecimale
$Input3 = GUICtrlCreateInput("", 18, 88, 121, 21) ;ottale
$Input1 = GUICtrlCreateInput("", 18, 16, 121, 21)
GUICtrlSetState(-1, $GUI_FOCUS)
GUICtrlCreateLabel("<- Decimale", 150, 19)
GUICtrlCreateLabel("<- Binario", 150, 43)
GUICtrlCreateLabel("<- Esadecimale", 150, 67)
GUICtrlCreateLabel("<- Ottale", 150, 91)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###



While 1
	Sleep(100)
	Conv()
WEnd

Func conv()
	GUICtrlSetData($input4, _NumBaseConvert(GUICtrlRead($Input1),10,2))
	GUICtrlSetData($Input2, _NumBaseConvert(GUICtrlRead($Input1),10,16))
	GUICtrlSetData($Input3, _NumBaseConvert(GUICtrlRead($Input1),10,8))
EndFunc

Func Form1Close()
	Exit
EndFunc