#AutoIt3Wrapper_Run_After=del "%scriptfile%_x32.exe"
#AutoIt3Wrapper_Run_After=ren "%out%" "%scriptfile%_x32.exe"
#AutoIt3Wrapper_Run_After=del "%scriptfile%_stripped.au3"
#AutoIt3Wrapper_Run_Au3Stripper=y
#Au3Stripper_Parameters=/PreExpand /StripOnly /RM ;/RenameMinimum
#AutoIt3Wrapper_Compile_both=y
#AutoIt3Wrapper_Res_Description=AutoRun LWMenu
#AutoIt3Wrapper_Res_Fileversion=1.4.2.2
#AutoIt3Wrapper_Res_LegalCopyright=Copyright (C) https://lior.weissbrod.com

#cs
Copyright (C) https://lior.weissbrod.com

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <https://www.gnu.org/licenses/>.

Additional restrictions under GNU GPL version 3 section 7:

In accordance with item 7b), it is required to preserve the reasonable legal notices/author attributions in the material and in the Appropriate Legal Notices displayed by works containing it (including in the footer).
In accordance with item 7c), misrepresentation of the origin of the material must be marked in reasonable ways as different from the original version.
#ce

;#include <Date.au3>
;#Include <Crypt.au3>
#include <associative.au3>
#include <ColorConstants.au3>
#include <StaticConstants.au3>
#include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <File.au3>

;Opt('ExpandEnvStrings', 1)
Opt("GUIOnEventMode", 1)
$programname = "AutoRun LWMenu"
$version = "1.4.2 beta 2"
$thedate = "2023"
$pass = "*****"
$product_id = "702430" ;"284748"
$keygen_url = "https:/no-longer-used.com/keygen?action={action}&productId={product_id}&key={key}&uniqueMachineId={unique_id}"
$keygen_return = "[\s\S]+<{tag}>(.+)</{tag}>[\s\S]+"
$validate = "validate"
$register = "register"
$unregister = "unregister"
$s_Config = "autorun.inf"
$shareware = False ; True requires to uncomment <Date.au3> and <Crypt.au3> statements
$fakecmd = ""

; If @Compiled Then
if $cmdline[0] > 0 then
	$thecmdline = $cmdline
ElseIf $fakecmd <> "" Then
	$thecmdline = StringRegExp($fakecmd, '[^,\s"]+|("[^"]*"\h*)', 3)
	$thecmdline = StringSplit(StringReplace(_ArrayToString($thecmdline), """", ""), "|")
Else
	Local $thecmdline[1] = [0]
EndIf

If $shareware Then
	$keygen_url = StringReplace($keygen_url, "{product_id}", $product_id)
	$keyfile = @ScriptDir & "\" & StringLeft(@ScriptName, StringLen(@ScriptName) - StringLen(".au3")) & ".key"
EndIf
$width = StringLen("word1 word2 word3 word4 word5") * 20
;$height=
$left_align = (@DesktopWidth - $width) / 2
$top = 30
If @DesktopWidth / @DesktopHeight < 1.37 Then
	$left = @DesktopWidth / 3
Else
	$left = @DesktopWidth / 4
EndIf

If Not $shareware Then
	$trial = False
ElseIf Not FileExists($keyfile) Then
	$trial = True
Else
	$trial = False
	If StringInStr(FileGetAttrib($keyfile), "R") Then
		FileSetAttrib($keyfile, "-R")
	EndIf
	$keytime = FileGetTime($keyfile)
	;$datediff=_DateDiff("D", $keytime[0] & "/" & $keytime[1] & "/" & $keytime[2] & " " & $keytime[3] & ":" & $keytime[4] & ":" & _
	;$keytime[5], _NowCalc()) ;requires <Date.au3>
	;if FileGetTime($keyfile, default, 1)<FileGetTime(@ScriptFullPath, default, 1) or $datediff>90 Then; requires <Date.au3>
	;validate($datediff)
	;endif
EndIf

Global $Form1, $nav

load()

While 1
	Sleep(100)
WEnd

Func load()
	x_unset('')
	; Set defaults
	x('CUSTOM CD MENU.fontface', 'helvetica')
	x('CUSTOM CD MENU.fontsize', '10')
	;x('CUSTOM CD MENU.buttoncolor', '#fefee0')
	x('CUSTOM CD MENU.buttonwidth', ($width - $left) / 3 + $left)
	x('CUSTOM CD MENU.buttonheight', '50')
	x('CUSTOM CD MENU.titletext', $programname)

	If $thecmdline[0] > 0 Then ;and FileExists($thecmdline[1]) and FileGetAttrib($thecmdline[1])="D" then
		$thepath = $thecmdline[1]
		If StringRight($thepath, 1) = '\' Then
			$thepath = StringTrimRight($thepath, 1)
		EndIf
		FileChangeDir(_PathFull($thepath))
		if _ArraySearch($thecmdline, "/simulate", 1) > -1 Then
			x('CUSTOM CD MENU.simulate', true)
		endif
	EndIf

	ini_to_x(@WorkingDir & "\" & $s_Config)

	colorcode("CUSTOM CD MENU.buttoncolor")
	colorcode("CUSTOM CD MENU.menucolor")
	x_extra()

	If $trial Then
		x('CUSTOM CD MENU.titletext', x('CUSTOM CD MENU.titletext') & ' (trial mode)')
	EndIf
	If x('CUSTOM CD MENU.simulate') Then
		x('CUSTOM CD MENU.titletext', x('CUSTOM CD MENU.titletext') & ' (simulation mode)')
	EndIf

	If x('CUSTOM CD MENU.skiptobutton') > 0 Then
		$skiptobutton = x('BUTTON' & x('CUSTOM CD MENU.skiptobutton') & '.buttontext')
		If ($skiptobutton <> "") Then
			displaybuttons(False, $skiptobutton)
		EndIf
	EndIf

	#Region ### START Koda GUI section ### Form=
	$Form1 = GUICreate(x('CUSTOM CD MENU.titletext'), $width, 0, $left_align, @DesktopHeight, BitOR($GUI_SS_DEFAULT_GUI, $WS_MAXIMIZEBOX))
	$nav = GUICtrlCreateMenu("&Navigation")
	$help = GUICtrlCreateMenu("&Help")
	$upper_enabled = False
	If FileExists(StringRegExpReplace(@WorkingDir, "(^.*)\\(.*)", "\1") & "\" & $s_Config) Then
		$upper = GUICtrlCreateMenuItem("&Up" & @TAB & "Backspace", $nav)
		GUICtrlSetOnEvent(-1, "upper")
		$upper_enabled = True
	EndIf
	$reload = GUICtrlCreateMenuItem("&Reload" & @TAB & "F5", $nav)
	GUICtrlSetOnEvent(-1, "reload")
	If $upper_enabled Then
		Local $AccelKeys2[2][2] = [["{Backspace}", $upper], ["{F5}", $reload]]
	Else
		Local $AccelKeys2[1][2] = [["{F5}", $reload]]
	EndIf
	GUISetAccelerators($AccelKeys2)
	GUICtrlCreateMenuItem("&Scan", $nav)
	GUICtrlSetOnEvent(-1, "scanfiles")
	If $trial Then
		GUICtrlCreateMenuItem("&Register", $help)
		GUICtrlSetOnEvent(-1, "register")
	ElseIf $shareware Then
		GUICtrlCreateMenuItem("&Unregister", $help)
		GUICtrlSetOnEvent(-1, "unregister")
		;GUICtrlCreateMenuItem("&Validate", $help)
		;GUICtrlSetOnEvent(-1, "validate")
	EndIf
	GUICtrlCreateMenuItem("&About", $help)
	GUICtrlSetOnEvent(-1, "about")

	If x('CUSTOM CD MENU.menucolor') <> "" Then
		GUISetBkColor(x('CUSTOM CD MENU.menucolor'))
	EndIf
	$Label1 = GUICtrlCreateLabel(x('CUSTOM CD MENU.titletext'), ($width - $left) / 3, -1, x('CUSTOM CD MENU.buttonwidth'), $top, BitOR($GUI_SS_DEFAULT_LABEL, $SS_CENTER))
	If x('CUSTOM CD MENU.buttoncolor') <> "" Then
		GUICtrlSetDefBkColor(x('CUSTOM CD MENU.buttoncolor'))
	EndIf
	GUICtrlSetFont(-1, x('CUSTOM CD MENU.fontsize') * 2, 1000, 0, x('CUSTOM CD MENU.fontface'))
	GUISetOnEvent($GUI_EVENT_CLOSE, "Form1Close")
	GUISetOnEvent($GUI_EVENT_MINIMIZE, "Form1Minimize")
	GUISetOnEvent($GUI_EVENT_MAXIMIZE, "Form1Maximize")
	GUISetOnEvent($GUI_EVENT_RESTORE, "Form1Restore")

	displaybuttons()

	GUISetState(@SW_SHOW)
	#EndRegion ### END Koda GUI section ###

EndFunc   ;==>load

func EnvGet_Full($string)
	return Execute("'" & StringRegExpReplace($string, "%(\w+)%",  "' & EnvGet('$1') & '" ) & "'")
EndFunc

Func readxml($url, $type, $datediff = 0)
	$content = BinaryToString(InetRead($url))
	x('activate.status', StringRegExpReplace($content, StringReplace($keygen_return, "{tag}", "status"), "$1"))
	$replace = StringRegExpReplace($content, StringReplace($keygen_return, "{tag}", "days_till_expiration"), "$1")
	If @extended > 0 Then
		x('activate.days', $replace)
	EndIf
	$replace = StringRegExpReplace($content, StringReplace($keygen_return, "{tag}", "use_count"), "$1")
	If @extended > 0 Then
		x('activate.use', $replace)
	EndIf
	Switch x('activate.status')
		Case "SUCCESS"
			x('activate.message', 'Successfully ' & $type & '!')
			If $type = "validated" Then
				x('activate.message', x('activate.message') & _
						@CRLF & '(This is an occasional anti-crack check.' & _
						@CRLF & 'Sorry for the inconvenience.)')
			EndIf
		Case "ERROR_INVALIDKEY"
			x('activate.message', 'Invalid key')
		Case "ERROR_INVALIDPRODUCT"
			x('activate.message', 'Invalid product')
		Case "ERROR_EXPIREDKEY"
			x('activate.message', 'Expired key')
		Case "ERROR_INVALIDMACHINE"
			x('activate.message', 'Invalid machine')
		Case "ERROR_ALREADYREG"
			x('activate.message', 'This machine is already registered')
		Case "ERROR_MAXCOUNT"
			x('activate.message', 'Already registered on multiple machines')
		Case Else
			x('activate.status', 'Else')
			x('activate.message', 'Problem accessing the server in order to get ' & $type & '.' & _
					@CRLF & @CRLF & _
					'Consider upgrading the software, if a new version exist.' & _
					@CRLF & @CRLF & _
					'This could also mean either the server or your Internet connection are down.' & _
					@CRLF & 'Please accept our apologies and try again later.')
			If $datediff > 95 Then
				x('activate.message', x('activate.message') & _
						@CRLF & @CRLF & _
						'In the mean time, we will have to enter you in TRIAL mode.' & _
						@CRLF & @CRLF & _
						'If this is an unfortunate mistake, please click register' & _
						@CRLF & 'when possible, and use your license key again.')
			EndIf
	EndSwitch
	If x('activate.days') <> "" Then
		$plusorminus = StringLeft(x('activate.days'), StringLen("+"))
		x('activate.days', StringMid(x('activate.days'), StringLen("+") + 1))
		If $plusorminus = "+" Then
			$message = "Reminder: your general registration will expire at " & @CRLF & x('activate.days')
		Else
			$message = "Your registration expired at " & @CRLF & x('activate.days')
		EndIf
		x('activate.message', x('activate.message') & _
				@CRLF & @CRLF & $message)
	EndIf
	If x('activate.use') <> "" Then
		$message = "This key has been in use " & x('activate.use') & " time"
		If x('activate.use') > 1 Then $message &= "s"
		x('activate.message', x('activate.message') & _
				@CRLF & @CRLF & $message)
	EndIf
EndFunc   ;==>readxml

Func upper()
	FileChangeDir(StringRegExpReplace(@WorkingDir, "(^.*)\\(.*)", "\1"))
	reload()
EndFunc   ;==>upper

Func scanfiles()
	GUICtrlSetData(@GUI_CtrlId, "[Scan completed]")
	GUICtrlSetState(@GUI_CtrlId, $GUI_DISABLE)
	$search = FileFindFirstFile("*")
	If $search = -1 Then Return
	While 1
		$file = FileFindNextFile($search)
		If @error Then ExitLoop
		If StringInStr(FileGetAttrib($file), "D") And FileExists($file & "\" & $s_Config) Then
			GUICtrlCreateMenuItem($file, $nav)
			GUICtrlSetOnEvent(-1, "subber")
		EndIf
	WEnd
	FileClose($search)
	Send("!N")
EndFunc   ;==>scanfiles

Func subber()
	FileChangeDir(GUICtrlRead(@GUI_CtrlId, 1))
	reload()
EndFunc   ;==>subber

Func reload()
	GUIDelete()
	load()
EndFunc   ;==>reload

Func unique_id()
	Return DriveGetSerial("")
EndFunc   ;==>unique_id

Func keyfile()
	$thekeyfile = FileOpen($keyfile)
	$thekey = FileReadLine($thekeyfile)
	;$thekey=_Crypt_DecryptData($thekey, $pass, $CALG_RC4) ;requires <Crypt.au3>
	FileClose($thekeyfile)
	Return $thekey
EndFunc   ;==>keyfile

Func validate($datediff)
	$keygen_validate = $keygen_url
	$keygen_validate = StringReplace($keygen_validate, "{action}", $validate)
	$keygen_validate = StringReplace($keygen_validate, "{key}", keyfile())
	$keygen_validate = StringReplace($keygen_validate, "{unique_id}", unique_id())
	readxml($keygen_validate, "validated", $datediff)
	If x('activate.status') = "SUCCESS" Then
		FileSetTime($keyfile, "")
	ElseIf x('activate.status') <> "Else" Or $datediff > 95 Then
		FileDelete($keyfile)
	EndIf
	MsgBox(0, $programname, x('activate.message'))
	If (x('activate.status') = "SUCCESS" And $trial) Or (x('activate.status') <> "SUCCESS" And Not $trial) Then
		selfrestart()
	EndIf
EndFunc   ;==>validate

Func register()
	$keygen_register = $keygen_url
	$input = InputBox("Key code", "What is your key code?", Default, Default, Default, Default, Default, Default, Default, $Form1)
	If $input <> "" Then
		$keygen_register = StringReplace($keygen_register, "{action}", $register)
		$keygen_register = StringReplace($keygen_register, "{key}", $input)
		$keygen_register = StringReplace($keygen_register, "{unique_id}", unique_id())
		;readxml($keygen_register, "registered")
		x('activate.status', "SUCCESS")
		If x('activate.status') = "SUCCESS" Then
			$file = FileOpen($keyfile, 2)
			;filewrite($file, _Crypt_EncryptData($input, $pass, $CALG_RC4)) ;requires <Crypt.au3>
			FileClose($file)
		EndIf
		MsgBox(0, $programname, x('activate.message'))
		If x('activate.status') = "SUCCESS" Then selfrestart()
	EndIf
EndFunc   ;==>register

Func unregister()
	$keygen_unregister = $keygen_url
	$keygen_unregister = StringReplace($keygen_unregister, "{action}", $unregister)
	$keygen_unregister = StringReplace($keygen_unregister, "{key}", keyfile())
	$keygen_unregister = StringReplace($keygen_unregister, "{unique_id}", unique_id())
	readxml($keygen_unregister, "unregistered")
	If x('activate.status') = "SUCCESS" Then
		FileDelete($keyfile)
	EndIf
	MsgBox(0, $programname, x('activate.message'))
	If x('activate.status') = "SUCCESS" Then selfrestart()
EndFunc   ;==>unregister

Func about()
	Opt("GUIOnEventMode", 0)
	GUICreate("About " & $programname, -1, 450, -1, -1, -1, $WS_EX_MDICHILD, $Form1)
	$localleft = 10
	$localtop = 10
	$message = $programname & " - Version " & $version & @CRLF & _
			@CRLF & _
			$programname & " is a portable program that lets you control menus" & _
			@CRLF & "via " & $s_Config & " files." & _
			@CRLF & @CRLF & _
			"It also serves as a portable enforcer/simulator for semi-portable programs" & _
			@CRLF & "that don't need installation but do otherwise leave leftovers forever."
	If $shareware Then
		$message &= @CRLF & @CRLF & "This is the "
		If Not $trial Then
			$message &= "full version. Thank you for supporting future development!"
		Else
			$message &= "shareware version. Please support future development registering."
		EndIf
	EndIf
	GUICtrlCreateLabel($message, $localleft, $localtop)
	$message = Chr(169) & $thedate & " LWC"
	GUICtrlCreateLabel($message, $localleft, ControlGetPos(GUICtrlGetHandle(-1), "", 0)[3] + 18)
	Local $aLabel = GUICtrlCreateLabel("https://lior.weissbrod.com", ControlGetPos(GUICtrlGetHandle(-1), "", 0)[2] + 10, _
			ControlGetPos(GUICtrlGetHandle(-1), "", 0)[1] + ControlGetPos(GUICtrlGetHandle(-1), "", 0)[3] - $localtop - 12)
	GUICtrlSetFont(-1, -1, -1, 4)
	GUICtrlSetColor(-1, 0x0000cc)
	GUICtrlSetCursor(-1, 0)
	$message = "    This program is free software: you can redistribute it and/or modify" & _
			@CRLF & "    it under the terms of the GNU General Public License as published by" & _
			@CRLF & "    the Free Software Foundation, either version 3 of the License, or" & _
			@CRLF & "    (at your option) any later version." & _
			@CRLF & _
			@CRLF & "    This program is distributed in the hope that it will be useful," & _
			@CRLF & "    but WITHOUT ANY WARRANTY; without even the implied warranty of" & _
			@CRLF & "    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the" & _
			@CRLF & "    GNU General Public License for more details." & _
			@CRLF & _
			@CRLF & "    You should have received a copy of the GNU General Public License" & _
			@CRLF & "    along with this program.  If not, see <https://www.gnu.org/licenses/>." & _
			@CRLF & @CRLF & _
			"Additional restrictions under GNU GPL version 3 section 7:" & _
			@CRLF & @CRLF & _
			"* In accordance with item 7b), it is required to preserve the reasonable legal notices/author attributions in the material and in the Appropriate Legal Notices displayed by works containing it (including in the footer)." & _
			@CRLF & @CRLF & _
			"* In accordance with item 7c), misrepresentation of the origin of the material must be marked in reasonable ways as different from the original version."
	#cs
	  $message = "Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the ""Software""), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:" & _
	  @crlf & @crlf & _
	  "The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software." & _
	  @crlf & @crlf & _
	  "THE SOFTWARE IS PROVIDED ""AS IS"", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE."
	#ce
	GUICtrlCreateLabel($message, $localleft, ControlGetPos(GUICtrlGetHandle(-1), "", 0)[1] + ControlGetPos(GUICtrlGetHandle(-1), "", 0)[3], 380, 280)
	$okay = GUICtrlCreateButton("OK", $localleft + 140, $localtop + 410, 100)

	GUISetState(@SW_SHOW)
	While 1
		$msg = GUIGetMsg()
		Switch $msg
			Case $GUI_EVENT_CLOSE, $okay
				Form2Close()
				ExitLoop
			Case $aLabel
				clicker(GUICtrlRead($msg))
		EndSwitch
	WEnd
EndFunc   ;==>about

Func selfrestart()
	Form2Close()
	If @Compiled Then
		Run(FileGetShortName(@ScriptFullPath))
	Else
		Run(FileGetShortName(@AutoItExe) & " " & Chr(34) & @ScriptFullPath & Chr(34))
	EndIf
	Form1Close()
EndFunc   ;==>selfrestart

Func clicker($item)
	ShellExecute($item)
EndFunc   ;==>clicker

Func Form2Close()
	GUIDelete()
	Opt("GUIOnEventMode", 1)
EndFunc   ;==>Form2Close

Func Form1Close()
	Exit
EndFunc   ;==>Form1Close

Func Form1Maximize()

EndFunc   ;==>Form1Maximize
Func Form1Minimize()

EndFunc   ;==>Form1Minimize
Func Form1Restore()

EndFunc   ;==>Form1Restore

Func ini_to_x($hIniLocation)
	If Not FileExists($hIniLocation) Then Return
	Local $aSections = IniReadSectionNames($hIniLocation), $filecontent, $aKV, $iCount, $xCount, $value, $value_temp
	If @error Then
		$filecontent = FileRead($hIniLocation)
		If @error Then
			MsgBox(48, "No access", "Access to " & $hIniLocation & " denied with the following error codes: " & @CRLF & @error & @CRLF & @extended)
			Return
		Else
			$aSections = StringRegExp($filecontent, '^|(?m)^\s*\[([^\]]+)', 3)
			$aSections[0] = UBound($aSections) - 1
		EndIf
	EndIf
	;Get All The Keys and Values for Each section
	For $iCount = 1 To $aSections[0]
		If $filecontent = "" Then
			$aKV = IniReadSection($hIniLocation, $aSections[$iCount])
			If @error Then ; If empty section then ignore (treat as void)
				ContinueLoop
			EndIf
		Else
			$value = StringRegExp($filecontent, "\Q" & $aSections[$iCount] & ']\E\s+([^\[]+)', 1)
			If Not IsArray($value) Then ; If empty section then ignore (treat as void)
				ContinueLoop
			EndIf
			If StringInStr($value[0], @CRLF, 1, 1) Then
				$value = StringSplit(StringStripCR($value[0]), @LF)
			ElseIf StringInStr($value[0], @LF, 1, 1) Then
				$value = StringSplit($value[0], @LF)
			Else
				$value = StringSplit($value[0], @CR)
			EndIf
			Local $aKV[1][2]
			For $xCount = 1 To $value[0]
				If $value[$xCount] = "" Or StringLeft($value[$xCount], 1) = ";" Then ContinueLoop
				ReDim $aKV[UBound($aKV) + 1][UBound($aKV, 2)]
				$value_temp = StringSplit($value[$xCount], "=", 2)
				$aKV[UBound($aKV) - 1][0] = $value_temp[0]
				$aKV[UBound($aKV) - 1][1] = $value_temp[1]
				$aKV[0][0] += 1
			Next
			If $aKV[0][0] = "" Then ContinueLoop
		EndIf
		For $xCount = 1 To $aKV[0][0]
			$value = StringSplit($aKV[$xCount][1], ";") ; Support for mid-sentence comments
			$value = StringStripWS($value[1], 3)
			x($aSections[$iCount] & '.' & $aKV[$xCount][0], $value)
		Next
	Next
EndFunc   ;==>ini_to_x

Func x_extra()
	specialbutton("CUSTOM CD MENU.button_browse")
	specialbutton("CUSTOM CD MENU.button_edit")
	specialbutton("CUSTOM CD MENU.button_close")

	x('CUSTOM CD MENU.skiptobutton', Number(x('CUSTOM CD MENU.skiptobutton')))

	If x('CUSTOM CD MENU.button_browse') = "" Or x('CUSTOM CD MENU.button_browse') <> "hidden" Then
		x('button_browse.buttontext', 'Browse Folder')
		x('button_browse.relativepathandfilename', 'explorer')
		x('button_browse.optionalcommandlineparams', '.')
		x('button_browse.programpath', '.')
		x('button_browse.closemenuonclick', '1')
		If x('CUSTOM CD MENU.button_browse') = "blocked" Then
			x('button_browse.show', x('CUSTOM CD MENU.button_browse'))
		EndIf
	EndIf

	If x('CUSTOM CD MENU.button_edit') = "" Or x('CUSTOM CD MENU.button_edit') <> "hidden" Then
		x('button_edit.buttontext', 'Edit ' & $s_Config)
		x('button_edit.relativepathandfilename', $s_Config)
		x('button_edit.closemenuonclick', '1')
		If x('CUSTOM CD MENU.button_edit') = "blocked" Then
			x('button_edit.show', x('CUSTOM CD MENU.button_edit'))
		EndIf
	EndIf

	If x('CUSTOM CD MENU.button_close') = "" Or x('CUSTOM CD MENU.button_close') <> "hidden" Then
		x('button_close.buttontext', 'Close menu')
		If x('CUSTOM CD MENU.button_close') = "blocked" Then
			x('button_close.show', x('CUSTOM CD MENU.button_close'))
		EndIf
	EndIf
EndFunc   ;==>x_extra

Func displaybuttons($all = True, $skiptobutton = False) ; False is for actual button clicks
	If IsDeclared("all") And $all = True Then
		$defpush = True
		$space = 55
		$pad = 10
		$localtop = $top + $pad
	EndIf
	For $key In x('')
		If StringLeft($key, StringLen('button')) = "button" Then ; is it a button?
			If IsDeclared("all") And $all = True Then
				$buttonstyle = -1
				If x($key & '.buttontext') = "" Or ($key <> 'button_close' And x($key & '.relativepathandfilename') = "") Then
					$buttonstyle = $WS_DISABLED
				ElseIf x($key & '.show') <> "" And x($key & '.show') = "blocked" Then
					$buttonstyle = $WS_DISABLED
					x($key & '.buttontext', x($key & '.buttontext') & " <blocked>")
				ElseIf $key <> 'button_close' And _
						StringRegExp(x($key & '.relativepathandfilename'), "^\S+:\S+$") = 0 And _ ; if not URLs (protocol:...)
						StringInStr(x($key & '.relativepathandfilename'), ".") > 0 And _ ; if not internal OS commands (no ".")
						Not FileExists(FileGetLongName(EnvGet_Full(x($key & '.relativepathandfilename')), 1)) And _;Then
						Not FileExists(FileGetLongName(EnvGet_Full(x($key & '.programpath') & "\" & x($key & '.relativepathandfilename')), 1)) Then
					$buttonstyle = $WS_DISABLED
					x($key & '.buttontext', x($key & '.buttontext') & " <File not found>")
				EndIf
				if x($key & '.simulate') then
					x($key & '.buttontext', x($key & '.buttontext') & " (Simulation mode)")
				EndIf
				If $defpush And $buttonstyle = -1 Then
					$buttonstyle = $BS_DEFPUSHBUTTON
					$defpush = False
				EndIf
				GUICtrlCreateButton(x($key & '.buttontext'), -1, $localtop, x('CUSTOM CD MENU.buttonwidth'), x('CUSTOM CD MENU.buttonheight'), $buttonstyle)
				GUICtrlSetFont(-1, x('CUSTOM CD MENU.fontsize'), 1000, 0, x('CUSTOM CD MENU.fontface'))
				GUICtrlSetOnEvent(-1, "displaybuttons")
				$localtop += $space
			ElseIf (IsDeclared("skiptobutton") And x($key & '.buttontext') = $skiptobutton) Or ($Form1 <> "" And x($key & '.buttontext') = GUICtrlRead(@GUI_CtrlId)) Then
				If $key = 'button_close' Then
					Form1Close()
				EndIf
				$simulate = false
				if x('CUSTOM CD MENU.simulate') or x($key & '.simulate') then
					$simulate = true
				EndIf
				Switch x($key & '.show')
					Case ""
						$show = True
					Case "hidden"
						$show = @SW_HIDE
					Case "minimized"
						$show = @SW_MINIMIZE
					Case "maximized"
						$show = @SW_MAXIMIZE
				EndSwitch
				$programfile = FileGetLongName(EnvGet_Full(x($key & '.relativepathandfilename')), 1)
				If x($key & '.programpath') = "" Then
					$programpath = StringRegExpReplace($programfile, "(^.*)\\(.*)", "\1")
				Else
					$programpath = FileGetLongName(EnvGet_Full(x($key & '.programpath')), 1)
				EndIf
				If $trial And (x($key & '.deletefolders') <> "" Or x($key & '.deletefiles') <> "") Then
					$note = "The following files/folders would not be able to be deleted/created:" & @CRLF & @CRLF
					If x($key & '.deletefolders') <> "" Then $note &= x($key & '.deletefolders') & @CRLF
					If x($key & '.deletefiles') <> "" Then $note &= x($key & '.deletefiles') & @CRLF
					$note &= @CRLF & "in trial mode. Do you still wish to continue?"
					$input = MsgBox(4, "Please consider registering", $note)
					If $input = 7 Then
						Return
					Else
						If x($key & '.deletefolders') <> "" Then x($key & '.deletefolders', '')
						If x($key & '.deletefiles') <> "" Then x($key & '.deletefiles', '')
					EndIf
				EndIf
				If StringInStr(FileGetAttrib($programfile), "D") Then
					$temp_programfile = $programfile
					If StringRight($temp_programfile, 1) == "\" Then $temp_programfile = StringTrimRight($temp_programfile, 1)
					If FileExists($programfile & "\" & $s_Config) Then
						FileChangeDir($programfile)
						GUIDelete()
						load()
						ExitLoop
					EndIf
				EndIf
				If Not IsDeclared("skiptobutton") And x($key & '.closemenuonclick') = 1 Then
					GUIDelete()
				EndIf
				If x($key & '.registry') <> "" Or x($key & '.deletefolders') <> "" Or x($key & '.deletefiles') <> "" Then
					$registry = doublesplit(x($key & '.registry'))
					$deletefolders = doublesplit(x($key & '.deletefolders'))
					$deletefiles = doublesplit(x($key & '.deletefiles'))
					Local $backuppath = ""
					If x($key & '.backuppath') <> "" Then
						$backuppath = x($key & '.backuppath')
						If $backuppath = "." Then
							$backuppath = @WorkingDir
						Else
							$backuppath = absolute_or_relative(@WorkingDir, $backuppath)
						EndIf
					EndIf
					If x($key & '.registry') <> "" And StringInStr(x($key & '.registry'), "+") > 0 Then
						Local $regfile = "0.reg"
						For $i = 0 To UBound($registry) - 1
							If StringLeft($registry[$i], StringLen("+")) = "+" Then
								$registry_temp = StringMid($registry[$i], StringLen("+") + 1)
								$registry_temp = StringSplit($registry_temp, ",")
								If @error Then
									If $backuppath <> "" then
										if FileExists($backuppath & "\" & $regfile) Then
											if $simulate then
												msgbox($MB_ICONINFORMATION, "Simulation mode", "Would have deleted " & $registry_temp[1])
											else
												RegDelete($registry_temp[1])
											EndIf
										EndIf
									Else
										if $simulate then
											msgbox($MB_ICONINFORMATION, "Simulation mode", "Would have written " & $registry_temp[1])
										Else
											RegWrite($registry_temp[1])
										endif
									EndIf
								ElseIf $registry_temp[0] >= 2 Then
									If $backuppath <> "" Then
										if FileExists($backuppath & "\" & $regfile) Then
											if $simulate then
												msgbox($MB_ICONINFORMATION, "Simulation mode", "Would have deleted " & $registry_temp[2])
											else
												RegDelete($registry_temp[1], $registry_temp[2])
											EndIf
										EndIf
									Else
										if $simulate then
											msgbox($MB_ICONINFORMATION, "Simulation mode", "Would have written " & $registry_temp[2] & " as REG_SZ " & (($registry_temp[0] = 2) ? "" : $registry_temp[3]))
										else
											RegWrite($registry_temp[1], $registry_temp[2], "REG_SZ", ($registry_temp[0] = 2) ? "" : $registry_temp[3])
										endif
									EndIf
								EndIf
							EndIf
						Next
						If $backuppath <> "" Then
							If FileExists($backuppath & "\" & $regfile) Then; 1 overall import for everything since an import can contain multiple entries
								if $simulate then
									msgbox($MB_ICONINFORMATION, "Simulation mode", "Would have imported " & $regfile & @crlf & "from " & $backuppath)
								else
									Local $iPID = Run("reg import " & chr(34) & $regfile & chr(34), $backuppath, @SW_HIDE, $STDERR_MERGED)
									ProcessWaitClose($iPID)
									Local $sOutput = StdoutRead($iPID)
									If @extended == 1 then
										MsgBox($MB_ICONWARNING, "Error", $backuppath & "\" & $regfile & @CRLF & @CRLF & $sOutput)
									EndIf
								EndIf
							EndIf
						EndIf
					EndIf
					If x($key & '.set_variable') <> "" Then
						$set_string_temp = x($key & '.set_string')
						If $backuppath <> "" Then
							$set_string_temp = StringReplace($set_string_temp, "%backuppath%", $backuppath)
						EndIf
						if $simulate then
							msgbox($MB_ICONINFORMATION, "Simulation mode", "Would have set " & x($key & '.set_variable') & " as " & $set_string_temp)
						else
							EnvSet(x($key & '.set_variable'), $set_string_temp)
						EndIf
					EndIf
					If x($key & '.deletefolders') <> "" And StringInStr(x($key & '.deletefolders'), "+") > 0 Then
						For $i = 0 To UBound($deletefolders) - 1
							If StringLeft($deletefolders[$i], StringLen("+")) = "+" Then
								$remotefolder_temp = absolute_or_relative($programpath, StringMid(EnvGet_Full($deletefolders[$i]), StringLen("+") + 1))
								If $backuppath <> "" Then
									if FileExists($backuppath & "\" & StringReplace(StringReplace(StringMid($deletefolders[$i], StringLen("+") + 1), "\", "_"), ":", "@")) then
										if $simulate then
											msgbox($MB_ICONINFORMATION, "Simulation mode", "Would have replaced " & $remotefolder_temp & @crlf & "with " & $backuppath & "\" & StringReplace(StringReplace(StringMid($deletefolders[$i], StringLen("+") + 1), "\", "_"), ":", "@"))
										else
											DirRemove($remotefolder_temp, $DIR_REMOVE)
											DirCopy($backuppath & "\" & StringReplace(StringReplace(StringMid($deletefolders[$i], StringLen("+") + 1), "\", "_"), ":", "@"), $remotefolder_temp, $FC_OVERWRITE)
										EndIf
									EndIf
								Else
									if $simulate then
										msgbox($MB_ICONINFORMATION, "Simulation mode", "Would have created " & $remotefolder_temp)
									else
										DirCreate($remotefolder_temp)
									EndIf
								EndIf
							EndIf
						Next
					EndIf
					If x($key & '.deletefiles') <> "" And StringInStr(x($key & '.deletefiles'), "+") > 0 Then
						For $i = 0 To UBound($deletefiles) - 1
							If StringLeft($deletefiles[$i], StringLen("+")) = "+" Then
								$remotefile_temp = absolute_or_relative($programpath, StringMid(EnvGet_Full($deletefiles[$i]), StringLen("+") + 1))
								If $backuppath <> "" Then
									$localfile_temp = StringSplit(StringMid($deletefiles[$i], StringLen("+") + 1), "\")
									if FileExists($backuppath & "\" & StringReplace(StringReplace(_ArrayToString($localfile_temp, "\", 1, $localfile_temp[0] - 1), "\", "_"), ":", "@") & "\" & $localfile_temp[$localfile_temp[0]]) then
										if $simulate then
											msgbox($MB_ICONINFORMATION, "Simulation mode", "Would have replaced " & $remotefile_temp & @CRLF & "with " & $backuppath & "\" & StringReplace(StringReplace(_ArrayToString($localfile_temp, "\", 1, $localfile_temp[0] - 1), "\", "_"), ":", "@") & "\" & $localfile_temp[$localfile_temp[0]])
										else
											FileDelete($remotefile_temp)
											FileCopy($backuppath & "\" & StringReplace(StringReplace(_ArrayToString($localfile_temp, "\", 1, $localfile_temp[0] - 1), "\", "_"), ":", "@") & "\" & $localfile_temp[$localfile_temp[0]], $remotefile_temp, $FC_OVERWRITE + $FC_CREATEPATH) ;StringRegExpReplace($remotefile_temp, "(^.*)\\(.*)", "\1") & "\" & $localfile_temp[$localfile_temp[0]]
										endif
									EndIf
								Else
									if $simulate then
										msgbox($MB_ICONINFORMATION, "Simulation mode", "Would have emptied " & $remotefile_temp)
									else
										FileWrite($remotefile_temp, "")
									EndIf
								EndIf
							EndIf
						Next
					EndIf
					if $simulate then
						msgbox($MB_ICONINFORMATION, "Simulation mode", "Would have run" & @crlf & @crlf & $programfile & " " & EnvGet_Full(x($key & '.optionalcommandlineparams')) & @crlf & @crlf & "Under " & $programpath & @crlf & @crlf & "With Show " & $show)
					else
						ShellExecuteWait($programfile, EnvGet_Full(x($key & '.optionalcommandlineparams')), $programpath, Default, $show)
					EndIf
					If x($key & '.registry') <> "" Then
						Local $cache = "", $found = false, $regfile_temp = "0_temp.reg"
						For $i = 0 To UBound($registry) - 1
							local $reg_temp = (StringLeft($registry[$i], StringLen("+")) <> "+") ? $registry[$i] : StringMid($registry[$i], StringLen("+") + 1)
							If $backuppath = "" or StringLeft($registry[$i], StringLen("+")) <> "+" or (StringInStr($reg_temp, ",")>0 and StringSplit($reg_temp, ",")[0] >= 2) Then
								if StringInStr($reg_temp, ",")>0 and StringSplit($reg_temp, ",")[0] >= 2 then
									$reg_temp = StringSplit($reg_temp, ",")
									if $simulate then
										msgbox($MB_ICONINFORMATION, "Simulation mode", "Would have deleted value name " & Chr(34) & $reg_temp[2] & Chr(34) & " from key " & $reg_temp[1])
									else
										RegDelete($reg_temp[1], $reg_temp[2])
									EndIf
								else
									if $simulate then
										msgbox($MB_ICONINFORMATION, "Simulation mode", "Would have deleted " & $reg_temp)
									else
										RegDelete($reg_temp)
									EndIf
								EndIf
							elseif $backuppath <> "" and StringInStr($registry[$i], ",")=0 Then
								Local $regkey = StringMid($registry[$i], StringLen("+") + 1)
								if $simulate then
									msgbox($MB_ICONINFORMATION, "Simulation mode", "Would have exported " & $regkey & @crlf & "to " & $regfile_temp & @CRLF & "at " & $backuppath)
								else
									Local $iPID = Run("reg export " & chr(34) & $regkey & chr(34) & " " & chr(34) & $regfile_temp & chr(34) & " /y", $backuppath, @SW_HIDE, $STDERR_MERGED)
									ProcessWaitClose($iPID)
									Local $sOutput = StdoutRead($iPID)
								EndIf
								If not $simulate and @extended == 1 then
									MsgBox($MB_ICONWARNING, "Error", $backuppath & "\" & $regfile & @CRLF & @CRLF & $sOutput)
								Else
									$cache_temp = StringTrimRight(fileread($backuppath & "\" & $regfile_temp), StringLen(@crlf))
									$cache &= $found ? StringTrimLeft($cache_temp, StringInStr($cache_temp, @CRLF & @crlf) + 1) : $cache_temp
									if $simulate then
										msgbox($MB_ICONINFORMATION, "Simulation mode", "Would have deleted " & @crlf & $backuppath & "\" & $regfile_temp & @CRLF & "and" & @crlf & $regkey)
									else
										FileDelete($backuppath & "\" & $regfile_temp)
										RegDelete($regkey)
									EndIf
								EndIf
								if not $found then $found = true
							EndIf
						Next
						if $cache<>"" and $cache<>FileRead($backuppath & "\" & $regfile) then
							if $simulate then
								msgbox($MB_ICONINFORMATION, "Simulation mode", "Would have created " & $backuppath & "\" & $regfile & @crlf & "with" & @crlf & $cache)
							else
								$filehandle = fileopen($backuppath & "\" & $regfile, $FO_OVERWRITE)
								FileWrite($filehandle, $cache)
								FileClose($filehandle)
							EndIf
						endif
					EndIf
					If x($key & '.deletefolders') <> "" Then
						For $i = 0 To UBound($deletefolders) - 1
							$deletefolder_temp = absolute_or_relative($programpath, EnvGet_Full((StringLeft($deletefolders[$i], StringLen("+")) = "+") ? StringMid($deletefolders[$i], StringLen("+") + 1) : $deletefolders[$i]))
							if $backuppath <> "" and StringLeft($deletefolders[$i], StringLen("+")) = "+" Then
								$folder_temp = absolute_or_relative($backuppath, StringReplace(StringReplace(StringMid($deletefolders[$i], StringLen("+") + 1), "\", "_"), ":", "@"))
								if $simulate then
									msgbox($MB_ICONINFORMATION, "Simulation mode", "If " & $deletefolder_temp & " exists at this point, would move it to " & $folder_temp)
								else
									if FileExists($deletefolder_temp) then
										DirRemove($folder_temp, $DIR_REMOVE)
										DirMove($deletefolder_temp, $folder_temp, $FC_OVERWRITE)
									EndIf
								EndIf
							else
								if $simulate then
									msgbox($MB_ICONINFORMATION, "Simulation mode", "Would have deleted " & $deletefolder_temp)
								else
									DirRemove($deletefolder_temp, 1)
								EndIf
							EndIf
						Next
					EndIf
					If x($key & '.deletefiles') <> "" Then
						For $i = 0 To UBound($deletefiles) - 1
							$deletefile_temp = absolute_or_relative($programpath, EnvGet_Full((StringLeft($deletefiles[$i], StringLen("+")) = "+") ? StringMid($deletefiles[$i], StringLen("+") + 1) : $deletefiles[$i]))
							$folder_temp = StringRegExpReplace($deletefile_temp, "\\[^\\]+$", "")
							if $backuppath <> "" and StringLeft($deletefiles[$i], StringLen("+")) = "+" Then
								$localfile_temp = StringSplit(StringMid($deletefiles[$i], StringLen("+") + 1), "\")
								if $simulate then
									msgbox($MB_ICONINFORMATION, "Simulation mode", "Would have moved " & $deletefile_temp & @crlf & "to " & $backuppath & "\" & StringReplace(StringReplace(_ArrayToString($localfile_temp, "\", 1, $localfile_temp[0] - 1), "\", "_"), ":", "@") & "\" & $localfile_temp[$localfile_temp[0]])
								else
									FileMove($deletefile_temp, $backuppath & "\" & StringReplace(StringReplace(_ArrayToString($localfile_temp, "\", 1, $localfile_temp[0] - 1), "\", "_"), ":", "@") & "\" & $localfile_temp[$localfile_temp[0]], $FC_OVERWRITE + $FC_CREATEPATH)
								EndIf
							else
								if $simulate then
									msgbox($MB_ICONINFORMATION, "Simulation mode", "Would have deleted " & $deletefile_temp)
								else
									FileDelete($deletefile_temp)
								EndIf
							EndIf
							$sizefldr1 = DirGetSize($folder_temp, 1)
							If $simulate or (Not @error and Not $sizefldr1[1] And Not $sizefldr1[2]) Then
								if $simulate then
									msgbox($MB_ICONINFORMATION, "Simulation mode", "If the file deletion had made its folder empty, would have deleted " & $folder_temp)
								else
									DirRemove($folder_temp, 1)
								EndIf
							EndIf
						Next
					EndIf
				Else
					If x($key & '.set_variable') <> "" Then
						$set_string_temp = x($key & '.set_string')
						If $backuppath <> "" Then
							$set_string_temp = StringReplace($set_string_temp, "%backuppath%", $backuppath)
						EndIf
						if $simulate then
							msgbox($MB_ICONINFORMATION, "Simulation mode", "Would have set " & x($key & '.set_variable') & " as " & $set_string_temp)
						else
							EnvSet(x($key & '.set_variable'), $set_string_temp)
						EndIf
					EndIf
					if $simulate then
						msgbox($MB_ICONINFORMATION, "Simulation mode", "Would have run" & @crlf & @crlf & $programfile & " " & EnvGet_Full(x($key & '.optionalcommandlineparams')) & @crlf & @crlf & "Under " & $programpath & @crlf & @crlf & "With Show " & $show)
					else
						ShellExecute($programfile, EnvGet_Full(x($key & '.optionalcommandlineparams')), $programpath, Default, $show)
					endif
				EndIf
				If IsDeclared("skiptobutton") Or x($key & '.closemenuonclick') = 1 Then Form1Close()
				ExitLoop
			EndIf
		EndIf
	Next
	If IsDeclared("all") And $all = True Then
		$height = $localtop + $pad
		If $height >= @DesktopHeight Then
			$height = @DesktopHeight
		EndIf
		WinMove($Form1, "", Default, (@DesktopHeight - $height) / 2, Default, $localtop + $space + $pad)
	EndIf
EndFunc   ;==>displaybuttons

Func absolute_or_relative($root, $path)
	If StringRegExp($path, "^\S+:\\") = 0 Then ; If doesn't start with x:\
		$path = $root & "\" & $path
	EndIf
	Return $path
EndFunc   ;==>absolute_or_relative

Func specialbutton($button)
	If $trial And x($button) <> "" And x($button) = "hidden" Then
		x($button, 'blocked')
	EndIf
EndFunc   ;==>specialbutton

Func colorcode($color)
	If x($color) <> "" Then
		If StringLeft(x($color), StringLen("#")) = "#" Then
			x($color, '0x' & StringMid(x($color), StringLen("#") + 1))
		Else
			$color_eval = "COLOR" & "_" & $color ; bypassing eval's possible warning about running strings directly
			x($color, Eval($color_eval))
		EndIf
	EndIf
EndFunc   ;==>colorcode

Func doublesplit($string)
	$res = StringRegExp($string, '("[^"]*"|[^\s"]+)', 3)
	For $i = 0 To UBound($res) - 1
		If StringInStr($res[$i], '"') > 0 Then
			$res[$i] = StringReplace($res[$i], '"', '')
		EndIf
	Next
	Return $res
EndFunc   ;==>doublesplit
