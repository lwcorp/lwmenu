#include-once
#include <GUIConstantsEx.au3> ; for $GUI_EVENT_CLOSE
#include <WinAPIGdi.au3>

; #FUNCTION# ====================================================================================================================
; Description ...: Create a GUI on a specific monitor
; Parameters ....: $iMonitorNumber     - Monitor number (1-based index) or 0 for Primary or empty for Windows to decide
;                  $iCreate            - Actually create the GUI, otherwise just return an array of its potential values
;                  $sTitle             - Title to use for GUI
;                  $iWidth             - Width to use for GUI - can be number or "max"
;                  $iHeight            - Height to use for GUI - can be number or "max"
;                  $oLeft              - Left side to use for GUI - can be number or "center" or "max"
;                  $oTop               - Top side to use for GUI - can be number or "center" or "max"
;				   $iStyle             - Style to use for GUI
;                  $iExStyle           - Extended style to use for GUI
;                  $iParent            - Parent to use for GUI
; Return values .: See GUICreate
; Author ........: LWC <https://lior.weissbrod.com>
; Modified ......:
; ==================================================================================================================
Func GUICreateOnMonitor($iMonitorNumber, $iCreate, $sTitle, $iWidth = 0, $iHeight = 0, $oLeft = 0, $oTop = 0, $iStyle = "", $iExStyle = "", $iParent = "")
	if IsNumber($iMonitorNumber) then
		; Get monitor information
		Local $aMonitorData = GetMonitorInfo()
		Local $aMonitors = $aMonitorData[0]
		Local $iPrimaryMonitorIndex = $aMonitorData[1]
		Local $iMonitorCount = UBound($aMonitors)
	EndIf

    ; Fallback for an non exising monitor
    If IsNumber($iMonitorNumber) and ($iMonitorNumber < 1 Or $iMonitorNumber > $iMonitorCount) Then
        If $iPrimaryMonitorIndex >= 0 Then
            $iMonitorNumber = $iPrimaryMonitorIndex + 1  ; Convert to 1-based index
        Else
            $iMonitorNumber = 1
        EndIf
    EndIf

    ; Get monitor position
    Local $iMonitorIndex = IsNumber($iMonitorNumber) ? $iMonitorNumber - 1 : ""  ; (1-based index to 0-based array)
    Local $iMonitorWidth = IsNumber($iMonitorNumber) ? $aMonitors[$iMonitorIndex][3] : @DesktopWidth
    Local $iMonitorHeight = IsNumber($iMonitorNumber) ? $aMonitors[$iMonitorIndex][4] : @DesktopHeight
    Local $iLeft = IsNumber($iMonitorNumber) ? $aMonitors[$iMonitorIndex][1] : 0
    Local $iTop = IsNumber($iMonitorNumber) ? $aMonitors[$iMonitorIndex][2] : 0

    ; Position window on monitor
	If $iWidth == "max" Then $iWidth = $iMonitorWidth
	If $iHeight == "max" Then $iHeight = $iMonitorHeight
    Local $iWindowLeft = $iLeft + (($oLeft == "max") ? $iMonitorWidth : (($oLeft == "center") ? ($iMonitorWidth - $iWidth) / 2 : $oLeft))
    Local $iWindowTop = $iTop + (($oTop == "max") ? $iMonitorHeight : (($oTop == "center") ? ($iMonitorHeight - $iHeight) / 2 : $oTop))

	Local $iSimulate = False
	If $iSimulate Then
		MsgBox($MB_ICONINFORMATION, "Simulation", "GUICreate(" & Chr(34) & $sTitle & Chr(34) & ", " & (($iWidth == "") ? "Default" : $iWidth) & ", " & (($iHeight == "") ? "Default" : $iHeight) & ", " & $iWindowLeft & ", " & $iWindowTop & " ," & (($iStyle == "") ? "Default" : $iStyle) & ", " & (($iExStyle == "") ? "Default" : $iExStyle) & ", " & (($iParent == "") ? "Default" : $iParent) & ")")
	EndIf
    Local $return = [IsNumber($iMonitorNumber) ? $iMonitorNumber : "", $iMonitorWidth, $iMonitorHeight, $iWindowLeft, $iWindowTop]
	Return $iCreate ? ($iSimulate ? 0 : GUICreate($sTitle, ($iWidth == "") ? Default : $iWidth, ($iHeight == "") ? Default : $iHeight, $iWindowLeft, $iWindowTop, ($iStyle == "") ? Default : $iStyle, ($iExStyle == "") ? Default : $iExStyle, ($iParent == "") ? Default : $iParent)) : $return
EndFunc

; #FUNCTION# ====================================================================================================================
; Description ...: Get monitor information (filtered for physical monitors)
; Parameters ....: None
; Return values .: Array (empty if no info)
; Author ........: LWC <https://lior.weissbrod.com>
; Modified ......:
; ==================================================================================================================
Func GetMonitorInfo()
    Local $aMonitors[0][5] ; [index][0=handle, 1=left, 2=top, 3=width, 4=height]
    Local $iMonitorCount = 0

    Local $aResult = _WinAPI_EnumDisplayMonitors()

    If @error Or Not IsArray($aResult) Then
        Return $aMonitors
    EndIf

    $iMonitorCount = UBound($aResult)

    ; Filter out virtual monitors (those with very small dimensions or zero dimensions)
    Local $aFilteredMonitors[0][5]
    Local $iFilteredCount = 0
    Local $iPrimaryMonitorIndex = -1  ; Track which monitor is primary

    For $i = 0 To $iMonitorCount - 1
        ; Get monitor handle from the enumeration result
        Local $hMonitor = $aResult[$i][0]

        ; Skip null/invalid handles
        If $hMonitor = 0 Then
            ContinueLoop
        EndIf

        Local $aMonitorInfo = _WinAPI_GetMonitorInfo($hMonitor)

        If @error Then
            ContinueLoop
        EndIf

        ; Extract rectangle data from the monitor info
        ; $aMonitorInfo[0] = $tagRECT structure for monitor rectangle
        Local $tRect = $aMonitorInfo[0]
        Local $iLeft = DllStructGetData($tRect, 1)
        Local $iTop = DllStructGetData($tRect, 2)
        Local $iRight = DllStructGetData($tRect, 3)
        Local $iBottom = DllStructGetData($tRect, 4)
        Local $iWidth = $iRight - $iLeft
        Local $iHeight = $iBottom - $iTop

        ; Filter out monitors with dimensions less than 100x100 (likely virtual)
        If $iWidth >= 100 And $iHeight >= 100 Then
            ReDim $aFilteredMonitors[$iFilteredCount + 1][5]
            $aFilteredMonitors[$iFilteredCount][0] = $hMonitor        ; handle
            $aFilteredMonitors[$iFilteredCount][1] = $iLeft           ; left
            $aFilteredMonitors[$iFilteredCount][2] = $iTop            ; top
            $aFilteredMonitors[$iFilteredCount][3] = $iWidth          ; width
            $aFilteredMonitors[$iFilteredCount][4] = $iHeight         ; height

            ; Check if this is the primary monitor
            If $aMonitorInfo[2] = 1 Then  ; Primary flag
                $iPrimaryMonitorIndex = $iFilteredCount
            EndIf

            $iFilteredCount += 1
        EndIf
    Next

    ; Store primary monitor index in the first element for easy access
    Local $aResult[2]
    $aResult[0] = $aFilteredMonitors
    $aResult[1] = $iPrimaryMonitorIndex
    Return $aResult
EndFunc

; #FUNCTION# ====================================================================================================================
; Description ...: Create a sample GUI on a specific monitor
; Parameters ....: See CreateGUIOnMonitor
; Return values .: None
; Author ........: LWC <https://lior.weissbrod.com>
; Modified ......:
; ==================================================================================================================
Func sampleGUICreateOnMonitor($iMonitorNumber, $iCreate, $sTitle, $iWidth = 0, $iHeight = 0, $oLeft = 0, $oTop = 0, $iStyle = "", $iExStyle = "", $iParent = "")
	Local $hGUI = GUICreateOnMonitor($iMonitorNumber, $iCreate, $sTitle, $iWidth, $iHeight, $oLeft, $oTop, $iStyle, $iExStyle, $iParent)
	if $hGUI <> 0 then
		GUISetState(@SW_SHOW, $hGUI)

		While 1
			Local $nMsg = GUIGetMsg()
			Switch $nMsg
				Case $GUI_EVENT_CLOSE
					GUIDelete($hGUI)
					ExitLoop
			EndSwitch
		WEnd
	EndIf
EndFunc

; sampleGUICreateOnMonitor(1, True, "Sample GUI", 400, 300, "center", "center")
; sampleGUICreateOnMonitor(1, True, "Sample GUI", "max", "max")