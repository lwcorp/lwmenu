;#RequireAdmin
#AutoIt3Wrapper_Run_After=del "%scriptfile%_x32.exe"
#AutoIt3Wrapper_Run_After=ren "%out%" "%scriptfile%_x32.exe"
#AutoIt3Wrapper_Run_After=del "%scriptfile%_stripped.au3"
#AutoIt3Wrapper_Run_Au3Stripper=y
#Au3Stripper_Parameters=/PreExpand /StripOnly /RM ;/RenameMinimum
#AutoIt3Wrapper_Compile_both=y
#AutoIt3Wrapper_Res_Description=AutoRun LWMenu
#cs
[FileVersion]
#ce
#AutoIt3Wrapper_Res_Fileversion=1.5.6
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
#include <AssoArrays.au3>
#include <ColorConstants.au3>
#include <StaticConstants.au3>
#include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <File.au3>
#include <WinAPIFiles.au3>
#include <WinAPIProc.au3>

;Opt('ExpandEnvStrings', 1)
Opt("GUIOnEventMode", 1)
$programname = "AutoRun LWMenu"
$version =StringRegExpReplace(@Compiled ? StringRegExpReplace(FileGetVersion(@ScriptFullPath), "\.0+$", "") : IniRead(@ScriptFullPath, "FileVersion", "#AutoIt3Wrapper_Res_Fileversion", "0.0.0"), "(\d+\.\d+\.\d+)\.(\d+)", "$1 beta $2")
$thedate = "2024"
$pass = "*****"
$product_id = "702430" ;"284748"
$keygen_url = "https:/no-longer-used.com/keygen?action={action}&productId={product_id}&key={key}&uniqueMachineId={unique_id}"
$keygen_return = "[\s\S]+<{tag}>(.+)</{tag}>[\s\S]+"
$validate = "validate"
$register = "register"
$unregister = "unregister"
$s_Config = "autorun.inf"
$taskbartitle = "[CLASS:Shell_TrayWnd]"
$taskbartext = ""
$taskbarbuttons = "[CLASS:MSTaskListWClass]"
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

Func load($check_cmd = True, $skiptobutton = False)
	x_del('')
	local $cmd_used = StringSplit("simulate skiptobutton focusbutton", " ", $STR_ENTIRESPLIT), $cmd_matches[0], $cmd_found
	If $thecmdline[0] > 0 Then ;and FileExists($thecmdline[1]) and FileGetAttrib($thecmdline[1])="D" then
		if $check_cmd then
			if _ArraySearch($thecmdline, "^[-/](help|h|\?)$", 1, default, default, 3) > - 1 then
				commandlinesyntax()
				Form1Close()
			Else
				local $i
			EndIf
			local $thepath = $thecmdline[$thecmdline[0]]
			if StringRegExp($thepath, "^[^-/]") then ; if not actual commands
				local $sim_mode = _ArraySearch($thecmdline, "^[-/]simulate(=\d+|)$", 1, default, default, 3)>-1
				If FileExists($thepath) and StringRight($thepath, 1) = '\' Then ; if a folder
					$thepath = StringTrimRight($thepath, 1)
				ElseIf not FileExists($thepath) or not StringInStr(FileGetAttrib($thepath), "D") > 0 then ; if neither a file nor a folder
					if not x('CUSTOM CD MENU.cmd_passed') Then ; The only way it exists is if it's a program default
						x('CUSTOM CD MENU.cmd_passed', $thepath)
						if x('CUSTOM CD MENU.simulate') or $sim_mode Then
							msgbox($MB_ICONINFORMATION, "Simulation prompt", "Will add" & @crlf & $thepath & @crlf & "to all command line parameters")
						EndIf
					EndIf
					$thepath = @ScriptDir
				EndIf
				$thepath = _PathFull($thepath)
				if @WorkingDir = $thepath then
					If x('CUSTOM CD MENU.simulate') or $sim_mode Then
						msgbox($MB_ICONINFORMATION, "Simulation prompt", "Did not change paths since" & @crlf & $thepath & @crlf & "is already the working folder")
					EndIf
				else
					local $original_path = @WorkingDir
					if FileChangeDir($thepath) = 0 Then
						msgbox($MB_ICONWARNING, "Failed to change paths", "Could not change" & @crlf & $original_path & @crlf & "to " & @crlf &  $thepath)
					ElseIf x('CUSTOM CD MENU.simulate') or $sim_mode Then
						msgbox($MB_ICONINFORMATION, "Simulation prompt", "Succesfully changed" & @crlf & $original_path & @crlf & "to " & @crlf &  $thepath)
					EndIf
				EndIf
			EndIf
		EndIf
		For $i = 1 To $cmd_used[0]
			$cmd_found = _ArraySearch($thecmdline, "^[-/]" & $cmd_used[$i] & "(=\d+|)$", 1, default, default, 3)
			if $cmd_found>-1 Then
				_ArrayAdd($cmd_matches, StringMid($thecmdline[$cmd_found], 2) & ((StringInStr($thecmdline[$cmd_found], "=", default, default, 2)>0) ? "" : "=1"))
			endif
		Next
	EndIf
	FileInstall("Autorun.inf", $s_Config)
	_ReadAssocFromIni_alt(@WorkingDir & "\" & $s_Config, False, '', '~')
	For $i = 0 To ubound($cmd_matches)-1
		$cmd_found = StringSplit($cmd_matches[$i], "=", 2)
		if not x('CUSTOM CD MENU.' & $cmd_found[0]) or x('CUSTOM CD MENU.' & $cmd_found[0])<>$cmd_found[1] Then
			x('CUSTOM CD MENU.' & $cmd_found[0], $cmd_found[1])
		endif
	Next

	; Set defaults
	x_default('CUSTOM CD MENU.fontface', 'helvetica')
	x_default('CUSTOM CD MENU.fontsize', '10')
	;x_default('CUSTOM CD MENU.buttoncolor', '#fefee0')
	x_default('CUSTOM CD MENU.buttonwidth', ($width - $left) / 3 + $left)
	x_default('CUSTOM CD MENU.buttonheight', '50')
	x_default('CUSTOM CD MENU.titletext', $programname)

	colorcode("CUSTOM CD MENU.buttoncolor")
	colorcode("CUSTOM CD MENU.menucolor")
	x_extra()

	If $trial Then
		x('CUSTOM CD MENU.titletext', x('CUSTOM CD MENU.titletext') & ' (trial mode)')
	EndIf
	If x('CUSTOM CD MENU.simulate') Then
		x('CUSTOM CD MENU.titletext', x('CUSTOM CD MENU.titletext') & ' (simulation mode)')
	EndIf

	If x('CUSTOM CD MENU.hidetrayicon') > 0 Then
		Opt("TrayIconHide", 1)
	EndIf
	If (IsDeclared("skiptobutton") and $skiptobutton > 0) or x('CUSTOM CD MENU.skiptobutton') > 0 Then
		displaybuttons(False, Number((IsDeclared("skiptobutton") and $skiptobutton > 0) ? $skiptobutton : x('CUSTOM CD MENU.skiptobutton')))
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
	GUICtrlCreateMenuItem("&Command line syntax", $help)
	GUICtrlSetOnEvent(-1, "commandlinesyntax")
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
	local $dummy = chr(1)
	$string = StringReplace($string, "'", $dummy)
	$string = Execute("'" & StringRegExpReplace($string, "%([\w\(\)]+)%",  "' & EnvGet('$1') & '" ) & "'")
	$string = StringReplace($string, $dummy, "'")
	return $string
EndFunc

func mklink($link, $target, $is_folder)
	If Number(_WinAPI_GetVersion()) < 6.0 Then
		MsgBox(($MB_ICONERROR + $MB_SYSTEMMODAL), 'Error', 'Require Windows Vista or later.')
        return false
	EndIf

	; Enable "SeCreateSymbolicLinkPrivilege" privilege to create a symbolic links
	Local $hToken = _WinAPI_OpenProcessToken(BitOR($TOKEN_ADJUST_PRIVILEGES, $TOKEN_QUERY))
	Local $aAdjust
	_WinAPI_AdjustTokenPrivileges($hToken, $SE_CREATE_SYMBOLIC_LINK_NAME, $SE_PRIVILEGE_ENABLED, $aAdjust)
	If @error Or @extended Then
			MsgBox(($MB_ICONERROR + $MB_SYSTEMMODAL), 'Error', 'You do not have the required privileges.')
			return false
	EndIf

	; Create symbolic link to the directory where this file is located with prefix "@" on your Desktop
	if not FileExists($target) and (($is_folder and not DirCreate($target)) or (not $is_folder and FileOpen($target, $FO_APPEND + $FO_CREATEPATH) = -1)) then
		MsgBox(($MB_ICONERROR + $MB_SYSTEMMODAL), 'Error', "Couldn't create " & $target)
		return false
	EndIf
	If Not _WinAPI_CreateSymbolicLink($link, $target, $is_folder) Then
			_WinAPI_ShowLastError()
			FileDelete($target)
			return false
	EndIf

	; Restore "SeCreateSymbolicLinkPrivilege" privilege by default
	_WinAPI_AdjustTokenPrivileges($hToken, $aAdjust, 0, $aAdjust)
	_WinAPI_CloseHandle($hToken)
	return true
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
	load(false)
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

Func commandlinesyntax()
	msgbox($MB_ICONINFORMATION, "Command line syntax", "[/simulate] [/skiptobutton=X] [[drive:]path]" & @crlf & _
	"[/?]" & @crlf & @crlf & _
	chr(32) & "/simulate" & chr(9) & "Run in simulation mode" & @crlf & @crlf & _
	chr(32) & "/skiptobutton=X" & chr(9) & "Skip to button X (e.g. /skiptobutton=5)" & @crlf & @crlf & _
	chr(32) & "[drive:]path" & chr(9) & "A folder that contains " & $s_Config & @crlf & @crlf & _
	chr(32) & "/?" & chr(9) & "Displays this help")
EndFunc

Func selfrestart($admin = false, $key = "")
	local $thecmdlineTemp = ""
	if $thecmdline[0] > 0 then
		$thecmdlineTemp = $thecmdline
	EndIf
	if ($key = "") then
		Form2Close()
	else
		$key = StringReplace($key, "BUTTON", "")
		local $pos, $extra = "/skiptobutton=" & $key
		if $thecmdline[0] > 0 then
			$pos = _ArraySearch($thecmdlineTemp, "[-/]skiptobutton=\d+$", 1, default, default, 3)
			if $pos = -1 Then
				_ArrayInsert($thecmdlineTemp, 1, $extra)
			else
				if StringSplit($thecmdlineTemp[$pos], "=", 2)[1] <> $key then
					$thecmdlineTemp[$pos] = $extra
				EndIf
			EndIf
			$thecmdlineTemp = _ArrayToString(addCMDQuotes($thecmdlineTemp), " ", 1)
		Else
			$thecmdlineTemp = $extra
		EndIf
	EndIf
	if $admin then
		ShellExecute(@Compiled ? @ScriptName : @AutoItExe, (@compiled ? "" : (chr(34) & @ScriptFullPath & chr(34) & " ")) & (IsDeclared("thecmdlineTemp") ? $thecmdlineTemp : ""), Default, "runas")
	else
		ShellExecute(@Compiled ? @ScriptName : @AutoItExe, (@compiled ? "" : (chr(34) & @ScriptFullPath & chr(34) & " ")) & (IsDeclared("thecmdlineTemp") ? $thecmdlineTemp : ""))
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

Func IniReadSectionNames_alt($hIniLocation)
	local $aSections = IniReadSectionNames($hIniLocation)
	if not @error then
		return $aSections
	EndIf
	local $filecontent = FileRead($hIniLocation)
	if @error Then
		SetError(@error)
	else
		local $aSections = StringRegExp($filecontent, '^|(?m)^\s*\[([^\]]+)', 3)
		$aSections[0] = UBound($aSections) - 1
		return $aSections
	EndIf
EndFunc

Func IniReadSection_alt($hIniLocation, $aSection)
	local $aKV = IniReadSection($hIniLocation, $aSection)
	if not @error then
		return $aKV
	else
		IniReadSectionNames($hIniLocation) ; In case reading a specific section failed, try reading them all
		if not @error Then
			SetError(1) ; Fake an error if reading them all worked, proving reading a specific section isn't the problem
		else
			local $filecontent = FileRead($hIniLocation)
			if @error Then
				SetError(@error)
			else
				local $value = StringRegExp($filecontent, "\Q" & $aSection & ']\E\s+([^\[]+)', 1)
				If Not IsArray($value) Then
					SetError(1) ; Fake an error if a section couldn't be found
				else
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
						$value_temp = StringSplit($value[$xCount], "=", 3)
						$aKV[UBound($aKV) - 1][0] = $value_temp[0]
						$aKV[UBound($aKV) - 1][1] = _ArrayToString($value_temp, "=", 1)
						$aKV[0][0] += 1
					Next
					If $aKV[0][0] = "" Then SetError(1) ; Fake an error if a section is empty
					return $aKV
				EndIf
			EndIf
		EndIf
	EndIf
EndFunc

;read AssocArray from IniFile Section
;returns number of items read - sets @error on failure
Func _ReadAssocFromIni_alt($myIni = 'config.ini', $multi = True, $mySection = '', $sSep = "|")
    If Not StringInStr($myIni,".") Then $myIni &= ".ini"
	if $multi then
		Local $sIni = StringLeft($myIni,StringInStr($myIni,".")-1)
	EndIf

    If $mySection == '' Then
        $aSection = IniReadSectionNames_alt($myIni); All sections
        If @error Then Return SetError(@error, 0, 0)
    Else
        Dim $aSection[2] = [1,$mySection]; specific Section
    EndIf

    For $i = 1 To UBound($aSection)-1

        Local $sectionArray = IniReadSection_alt($myIni, $aSection[$i])
        If @error Then ContinueLoop
        For $x = 1 To $sectionArray[0][0]
			local $valTemp = ($multi ? $sIni&"." : "")&$aSection[$i]&"."&$sectionArray[$x][0]
			If x($valTemp) or IsArray(x($valTemp)) Then
				$sectionArray[$x][1] = (x($valTemp) ? x($valTemp) : _ArrayToString(x($valTemp), $sSep)) & $sSep & $sectionArray[$x][1]
			EndIf
			$sectionArray[$x][1] = StringStripWS(StringSplit($sectionArray[$x][1], ";")[1], 3) ; Support for mid-sentence comments
            If StringInStr($sectionArray[$x][1], $sSep) then
                $posS = _MakePosArray($sectionArray[$x][1], $sSep)
			Else
                $posS = $sectionArray[$x][1]
            EndIf
			x($valTemp, $posS)
        Next

    next
    Return $sectionArray[0][0]
EndFunc   ;==>_ReadAssocFromIni

Func x_default($key, $default)
	if not x($key) Then
		x($key, $default)
	EndIf
EndFunc

Func x_extra()
	specialbutton("CUSTOM CD MENU.button_browse")
	specialbutton("CUSTOM CD MENU.button_edit")
	specialbutton("CUSTOM CD MENU.button_close")

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
	If IsDeclared("skiptobutton") and $skiptobutton > 0 then
		local $has_command = x('BUTTON' & $skiptobutton & '.relativepathandfilename')
		$skiptobutton = x('BUTTON' & $skiptobutton & '.buttontext') ? x('BUTTON' & $skiptobutton & '.buttontext') : ""
		if ($skiptobutton = "" or not $has_command) and not $all Then
			Return
		EndIf
	EndIf
	If IsDeclared("all") And $all = True Then
		$defpush = True
		$space = 55
		$pad = 10
		$localtop = $top + $pad
	EndIf
	For $key In x('')
		If StringLeft($key, StringLen('button')) = "button" Then ; is it a button?
			If $key <> 'button_close' then
				IfStringThenArray($key & ".setenv")
				IfStringThenArray($key & ".symlink")
				local $optionalcommandlineparams = (not x($key & '.optionalcommandlineparams')) ? "" : x($key & '.optionalcommandlineparams')
				if x('CUSTOM CD MENU.cmd_passed') then
					$optionalcommandlineparams = ($optionalcommandlineparams = "") ? x('CUSTOM CD MENU.cmd_passed') : ($optionalcommandlineparams & " " & x('CUSTOM CD MENU.cmd_passed'))
				EndIf
			EndIf
			If IsDeclared("all") And $all = True Then
				if x($key & '.hidefrommenu') > 0 then
					ContinueLoop
				EndIf
				$buttonstyle = -1
				If x($key & '.buttontext') = "" Or ($key <> 'button_close' And x($key & '.relativepathandfilename') = "") Then
					$buttonstyle = $WS_DISABLED
				ElseIf x($key & '.show') <> "" And x($key & '.show') = "blocked" Then
					$buttonstyle = $WS_DISABLED
					x($key & '.buttontext', x($key & '.buttontext') & " <blocked>")
				ElseIf $key <> 'button_close' And ( _
					StringRegExp(x($key & '.relativepathandfilename'), "^\S+:\S+$") = 0 And _ ; if not URLs (protocol:...)
					StringInStr(x($key & '.relativepathandfilename'), ".") > 0 And _ ; if not OS paths (no ".")
					Not FileExists(FileGetLongName(EnvGet_Full(x($key & '.relativepathandfilename')), 1)) And _;Then
					Not FileExists(FileGetLongName(EnvGet_Full(x($key & '.programpath') & "\" & x($key & '.relativepathandfilename')), 1))) _
					or (x($key & ".set_variable") or x($key & ".symlink_link")) Then ; Obsolete variants
						$buttonstyle = $WS_DISABLED
						local $blocked_msg
						Select
							case x($key & ".set_variable") or x($key & ".symlink_link")
								$blocked_msg = "Use " & (x($key & ".set_variable") ? "setenv" : "symlink") & " instead of " & (x($key & ".set_variable") ? "set_variable" : "symlink_link")
							case Else
								$blocked_msg = "File not found"
						EndSelect
						x($key & '.buttontext', x($key & '.buttontext') & " <" & $blocked_msg & ">")
				EndIf
				if not x($key & '.buttontext') then
					x($key & '.buttontext', $key)
				EndIf
				if x($key & '.simulate') then
					x($key & '.buttontext', x($key & '.buttontext') & " (Simulation mode)")
				EndIf
				If $defpush And $buttonstyle = -1 Then
					$buttonstyle = $BS_DEFPUSHBUTTON
					$defpush = False
				EndIf
				x('ctrlIds.' & $key, GUICtrlCreateButton(x($key & '.buttontext'), -1, $localtop, x('CUSTOM CD MENU.buttonwidth'), x('CUSTOM CD MENU.buttonheight'), $buttonstyle))
				if x('CUSTOM CD MENU.focusbutton') and x('CUSTOM CD MENU.focusbutton')<>"" and $key = "BUTTON" & x('CUSTOM CD MENU.focusbutton') then
					GUICtrlSetState(-1, $GUI_FOCUS)
				EndIf
				GUICtrlSetFont(-1, x('CUSTOM CD MENU.fontsize'), 1000, 0, x('CUSTOM CD MENU.fontface'))
				GUICtrlSetOnEvent(-1, "displaybuttons")
				$localtop += $space
			ElseIf (IsDeclared("skiptobutton") And x($key & '.buttontext') = $skiptobutton) Or (not IsDeclared("skiptobutton") and $Form1 <> "" And GUICtrlRead(@GUI_CtrlId)<>"" and x($key & '.buttontext') = GUICtrlRead(@GUI_CtrlId)) Then
				if IsDeclared("skiptobutton") and (x($key & ".set_variable") or x($key & ".symlink_link")) Then ; Obsolete variants
					msgbox($MB_ICONWARNING, "Needs migration", "Use " & (x($key & ".set_variable") ? "setenv" : "symlink") & " instead of " & (x($key & ".set_variable") ? "set_variable" : "symlink_link"))
					Form1Close()
				EndIf
				If $key = 'button_close' Then
					Form1Close()
				EndIf
				$simulate = false
				if x('CUSTOM CD MENU.simulate') or x($key & '.simulate') then
					$simulate = true
				EndIf
				local $basefile = StringRegExpReplace(x($key & '.relativepathandfilename'), ".*\\", "")
				if StringInStr($basefile, ".") = 0 then $basefile &= ".exe"
				if (x('CUSTOM CD MENU.singlerun') or x($key & '.singlerun')) and ProcessExists($basefile) and msgbox($MB_ICONQUESTION + $MB_YESNO, "Another instance already runs", $basefile & " is already running, would you like to launch another instance of it anyway?") <> $IDYES then
					If (IsDeclared("skiptobutton") and $skiptobutton <> "") then
						Form1Close()
					else
						ExitLoop
					EndIf
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
						reload()
						ExitLoop
					EndIf
				EndIf
				If (Not IsDeclared("skiptobutton") or $skiptobutton = "") And x($key & '.closemenuonclick') = 1 Then
					GUIDelete()
				EndIf
				Local $backuppath = ""
				If x($key & '.backuppath') <> "" Then
					$backuppath = x($key & '.backuppath')
					If $backuppath = "." Then
						$backuppath = @WorkingDir
					Else
						$backuppath = absolute_or_relative(@WorkingDir, $backuppath)
					EndIf
				EndIf
				local $blinktaskbarwhendone = false, $netaccess_check = false, $netaccess = -1
				if x('CUSTOM CD MENU.blinktaskbarwhendone') or x($key & '.blinktaskbarwhendone') Then
					$blinktaskbarwhendone = true
				EndIf
				if x($key & '.netaccess') Then
					$netaccess = x($key & '.netaccess')
				elseif x('CUSTOM CD MENU.netaccess') then
					$netaccess = x('CUSTOM CD MENU.netaccess')
				EndIf
				if $netaccess <> -1 and ($netaccess="0" or $netaccess="1") Then
					$netaccess_check = true
					$netaccess = Number($netaccess)
				endif
				If x($key & ".buttonafter") <> "" or x($key & '.registry') <> "" Or x($key & '.deletefolders') <> "" Or x($key & '.deletefiles') <> "" or (x($key & '.backuppath') <> "" and IsArray(x($key & '.symlink'))) or $blinktaskbarwhendone or $netaccess_check Then
					$specific_button = True;
					$registry = doublesplit(x($key & '.registry'))
					$deletefolders = doublesplit(x($key & '.deletefolders'))
					$deletefiles = doublesplit(x($key & '.deletefiles'))
					local $symbolic_check = false, $symbolic_failed = false
					if $netaccess_check Then
						if $simulate then
							msgbox($MB_ICONINFORMATION, "Simulation mode", "Would have " & (($netaccess = 0) ? "blocked" : "allowed") & " both Inbound and Outbound net access for " & $programfile)
						else
							if checknetstop($key, 1, $programfile, 1, $netaccess) = 1 then ExitLoop
							if checknetstop($key, 1, $programfile, 2, $netaccess) = 1 then ExitLoop
						EndIf
					EndIf
					if x($key & '.backuppath') <> "" and IsArray(x($key & '.symlink')) Then
						$symbolic_check = true
						if not IsAdmin() then
							$symbolic_failed = True
						EndIf
						For $i = 0 To UBound(x($key & '.symlink'))-1
							if StringInStr(x($key & '.symlink')[$i], "|") > 0 Then
								$symbolic_arr = StringSplit(StringReplace(x($key & '.symlink')[$i], " | ", "|"), "|", 2)
								$symbolic_temp = absolute_or_relative($backuppath, StringReplace(StringReplace($symbolic_arr[1], "\", "_"), ":", "@"))
								$symbolic_folder = false
								if StringRight($symbolic_arr[0], 1) = "\" Then
									$symbolic_folder = true
								EndIf
								if $symbolic_folder and StringRight($symbolic_temp, 1) <> "\" then
									$symbolic_temp &= "\"
								EndIf
								if not FileExists(EnvGet_Full($symbolic_arr[0])) then
									if not $symbolic_failed then
										if $simulate then
												msgbox($MB_ICONINFORMATION, "Simulation mode", "Would have created a symbolic link " & $symbolic_arr[0] & " targeting " & Chr(34) & $symbolic_temp & Chr(34))
										else
											mklink(EnvGet_Full($symbolic_arr[0]), $symbolic_temp, ($symbolic_folder = "\") ? 1 : 0)
										EndIf
									Else
										local $msgReturn = msgbox($MB_ICONQUESTION + $MB_YESNOCANCEL, "Requires admin", "Run this program as admin if you like to create a symbolic link " & $symbolic_arr[0] & " targeting " & Chr(34) & $symbolic_temp & Chr(34) & @crlf & @crlf & "Would you like to run " & $programfile & " as admin?" & @crlf & @crlf & "Yes - Relaunch as admin" & @crlf & "No - Continue anyway")
										if $msgReturn = $IDCANCEL then
											if x($key & '.closemenuonclick') = 1 then
												Form1Close()
											Else
												ExitLoop 2
											EndIf
										elseif $msgReturn = $IDYES Then
											selfrestart(true, $key)
										EndIf
									EndIf
								EndIf
							EndIf
						Next
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
											msgbox($MB_ICONINFORMATION, "Simulation mode", "Would have written " & Chr(34) & $registry_temp[2] & Chr(34) & " as REG_SZ " & (($registry_temp[0] = 2) ? "" : ($registry_temp[3] & " under " & $registry_temp[1])))
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
					If IsArray(x($key & '.setenv')) Then
						For $i = 0 To UBound(x($key & '.setenv'))-1
							if StringInStr(x($key & '.setenv')[$i], "|") > 0 Then
								$set_arr = StringSplit(StringReplace(x($key & '.setenv')[$i], " | ", "|"), "|", 2)
								If $backuppath <> "" Then
									$set_arr[1] = StringReplace($set_arr[1], "%backuppath%", $backuppath)
								EndIf
								if $simulate then
									msgbox($MB_ICONINFORMATION, "Simulation mode", "Would have set " & $set_arr[0] & " as " & $set_arr[1])
								else
									EnvSet($set_arr[0], $set_arr[1])
								EndIf
							EndIf
						Next
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
						msgbox($MB_ICONINFORMATION, "Simulation mode", "Would have run" & @crlf & @crlf & $programfile & " " & EnvGet_Full($optionalcommandlineparams) & @crlf & @crlf & "Under " & $programpath & @crlf & @crlf & "With Show " & $show)
					else
						ShellExecuteWait($programfile, EnvGet_Full($optionalcommandlineparams), $programpath, Default, $show)
					EndIf
					if $netaccess_check Then
						if $simulate then
							msgbox($MB_ICONINFORMATION, "Simulation mode", "Would have removed the " & (($netaccess = 0) ? "block" : "allow") & " status from " & $programfile)
						else
							checknetstop($key, 0, $programfile, 1, $netaccess)
							checknetstop($key, 0, $programfile, 2, $netaccess)
						EndIf
					EndIf
					if $symbolic_check then
						For $i = 0 To UBound(x($key & '.symlink'))-1
							if StringInStr(x($key & '.symlink')[$i], "|") > 0 Then
								$symbolic_arr = StringSplit(StringReplace(x($key & '.symlink')[$i], " | ", "|"), "|", 2)
								if $symbolic_failed then
									msgbox($MB_ICONWARNING, "Symbolic deletion failed", "Can't delete symbolic link " & $symbolic_arr[0] & " due to not running as admin")
								Else
									if $simulate then
										msgbox($MB_ICONINFORMATION, "Simulation mode", "Would have deleted symbolic link " & $symbolic_arr[0])
									else
										;if not FileDelete(EnvGet_Full(x($key & '.symlink_link'))) Then
										$symbolic_folder = false
										if StringRight($symbolic_arr[0], 1) = "\" Then
											$symbolic_folder = true
										EndIf
										if ($symbolic_folder and not _WinAPI_RemoveDirectory(EnvGet_Full($symbolic_arr[0]))) or (not $symbolic_folder and not _WinAPI_DeleteFile(EnvGet_Full($symbolic_arr[0]))) then
											msgbox($MB_ICONINFORMATION, "Symbolic deletion failed", "Couldn't delete symbolic link " & @crlf & EnvGet_Full($symbolic_arr[0]) & @crlf & "due to " & _WinAPI_GetLastError() & ": " & _WinAPI_GetLastErrorMessage())
										EndIf
									EndIf
								EndIf
							EndIf
						Next
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
								$filehandle = fileopen($backuppath & "\" & $regfile, $FO_OVERWRITE + $FO_UNICODE)
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
									If (StringLeft($deletefolders[$i], StringLen("+")) = "+" and StringInStr($deletefolders[$i], "*", default, default, StringLen("+"))>0) or StringInStr($deletefolders[$i], "*")>0 Then
										$deletefolder_temp = StringRegExp($deletefolder_temp, "(.*\\)(.*)", 3)
										DirRemoveWildCard($deletefolder_temp[0], $deletefolder_temp[1], 1)
									else
										DirRemove($deletefolder_temp, 1)
									EndIf
								EndIf
							EndIf
						Next
					EndIf
					If x($key & '.deletefiles') <> "" Then
						For $i = 0 To UBound($deletefiles) - 1
							$deletefile_temp = absolute_or_relative($programpath, EnvGet_Full((StringLeft($deletefiles[$i], StringLen("+")) = "+") ? StringMid($deletefiles[$i], StringLen("+") + 1) : $deletefiles[$i]))
							$folder_temp = StringRegExpReplace($deletefile_temp, "\\[^\\]+$", "")
							if $backuppath <> "" and StringLeft($deletefiles[$i], StringLen("+")) = "+" Then
								$localfile_temp = absolute_or_relative($backuppath, StringReplace(StringReplace(StringMid($deletefiles[$i], StringLen("+") + 1), "\", "_"), ":", "@"))
								if $simulate then
									msgbox($MB_ICONINFORMATION, "Simulation mode", "Would have moved " & $deletefile_temp & @crlf & "to " & $localfile_temp)
								else
									FileMove($deletefile_temp, $localfile_temp, $FC_OVERWRITE + $FC_CREATEPATH)
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
					if $blinktaskbarwhendone Then
						if $simulate then
							msgbox($MB_ICONINFORMATION, "Simulation mode", "Would have blinked the taskbar upon completion")
						else
							ControlHide($taskbartitle, $taskbartext, $taskbarbuttons)
							sleep(100)
							ControlShow($taskbartitle, $taskbartext, $taskbarbuttons)
						EndIf
					EndIf
				Else
					If IsArray(x($key & '.setenv')) Then
						For $i = 0 To UBound(x($key & '.setenv'))-1
							if StringInStr(x($key & '.setenv')[$i], "|") > 0 Then
								$set_arr = StringSplit(StringReplace(x($key & '.setenv')[$i], " | ", "|"), "|", 2)
								If $backuppath <> "" Then
									$set_arr[1] = StringReplace($set_arr[1], "%backuppath%", $backuppath)
								EndIf
								if $simulate then
									msgbox($MB_ICONINFORMATION, "Simulation mode", "Would have set " & $set_arr[0] & " as " & $set_arr[1])
								else
									EnvSet($set_arr[0], $set_arr[1])
								EndIf
							EndIf
						Next
					EndIf
					if $simulate then
						msgbox($MB_ICONINFORMATION, "Simulation mode", "Would have run" & @crlf & @crlf & $programfile & " " & EnvGet_Full($optionalcommandlineparams) & @crlf & @crlf & "Under " & $programpath & @crlf & @crlf & "With Show " & $show)
					else
						ShellExecute($programfile, EnvGet_Full($optionalcommandlineparams), $programpath, Default, $show)
					endif
				EndIf
				if x($key & '.focusbutton') and x($key & '.focusbutton')<>"" and x('ctrlIds.BUTTON' & x($key & '.focusbutton')) then
					GUICtrlSetState(x('ctrlIds.BUTTON' & x($key & '.focusbutton')), $GUI_FOCUS)
					x_del(x('ctrlIds'))
				EndIf
				$closing = False
				If (IsDeclared("skiptobutton") and $skiptobutton <> "") Or x($key & '.closemenuonclick') = 1 Then
					if x($key & ".buttonafter") > 0 then
						$closing = true
						GUIDelete()
					Else
						Form1Close()
					EndIf
				EndIf
				if x($key & ".buttonafter") > 0 then
					If $closing Then
						load(False, x($key & ".buttonafter"))
					Else
						displaybuttons(False, x($key & ".buttonafter"))
					EndIf
				EndIf
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

func DirRemoveWildCard($sPath, $wildcard, $recursive)
	$aList = _FileListToArray($sPath, $wildcard, 2)
	For $i = 1 To $aList[0]
		DirRemove($sPath & $aList[$i], $recursive)
	Next
EndFunc

Func _AddRemoveFirewallProfile($_intEnableDisable, $_appName, $_applicationFullPath, $_direction = 1, $_action = 0, $_protocol = -1, $_port = 0, $_profile = 0) ;Add/Remove/Enable/Disable Firewall Exception
	If not IsAdmin() Then
		Return SetError(0, 0, "Must be run as admin")
	EndIf
	If Not StringInStr("WIN_XPe", @OSVersion) Then
		$Policy = ObjCreate("HNetCfg.FwPolicy2")
		If Not @error Then
			$RulesObject = $Policy.Rules
			Local $appNameAndDirection = $_appName & " - " & (($_direction = 2) ? "Out" : "In")
			For $Rule In $RulesObject
				If $Rule.name = $appNameAndDirection Then $RulesObject.Remove($Rule.name)
			Next
			If Not $_intEnableDisable Then
				Return 1
			EndIf
			$newApplication = ObjCreate("HNetCfg.FWRule")
			If Not @error Then
				$newApplication.Name = $appNameAndDirection
				$newApplication.Description = $_appName
				$newApplication.Applicationname = $_applicationFullPath
				If Not $_protocol > -1 Then $newApplication.Protocol = $_protocol ; 17 = UDP, 6 = TCP, 0 = HOPOPT
				If Not $_port > 0 Then $newApplication.LocalPorts = $_port
				$newApplication.Direction = $_direction ; 1 = in; 2 = out
				$newApplication.InterfaceTypes = "All"
				$newApplication.Enabled = $_intEnableDisable
				$newApplication.Profiles = ($_profile > 0) ? $_profile : 2147483647 ; 1 = Domain, 2 = Private, Domain/Profile = 3, Public=4; 2147483647 = all
				$newApplication.Action = $_action ; 1 = allow
				$RulesObject.Add($newApplication)
				Return 1
			Else
				Return SetError(2, 0, "Couldn't create HNetCfg.FWRule")
			EndIf
		Else
			Return SetError(1, 0, "Couldn't create HNetCfg.FwPolicy2")
		EndIf
	Else ; legacy
		$Firewall = ObjCreate("HNetCfg.FwMgr")
		If Not @error Then
			$Policy = $Firewall.LocalPolicy
			$Profile = $Policy.GetProfileByType(1)
			$colApplications = $Profile.AuthorizedApplications
			For $App In $colApplications
				If $App.ProcessImageFileName = $_applicationFullPath Then
					$colApplications.Remove($App)
				EndIf
			Next
			If Not $_intEnableDisable Then
				Return 1
			EndIf
			$newApplication = ObjCreate("HNetCfg.FwAuthorizedApplication")
			If Not @error Then
				$newApplication.Name = $_appName
				$newApplication.IpVersion = 2
				$newApplication.ProcessImageFileName = $_applicationFullPath
				$newApplication.RemoteAddresses = "*"
				$newApplication.Scope = 0
				$newApplication.Enabled = $_intEnableDisable
				$colApplications.Add($newApplication)
				Return 1
			Else
				Return SetError(2, 0, "Couldn't create HNetCfg.FwAuthorizedApplication")
			EndIf
		Else
			Return SetError(1, 0, "Couldn't create HNetCfg.FwMgr")
		EndIf
	EndIf
EndFunc ;==>_AddFirewallProfile

Func checknetstop($key, $activate, $filename, $dir, $action)
	local $result = _AddRemoveFirewallProfile($activate, "BlockInternet", $filename, $dir, $action)
	if not IsInt($result) Then
		local $title = "Failed to " & (($activate = 0) ? "Disable" : "Enable") & " " & (($dir = 1) ? "Inbound" : "Outbound") & " Net Access"
		local $msg = (($dir = 1) ? "Inbound" : "Outbound") & " access failed due to: Error " & @error & "." & @extended & ". " & $result
		if $activate Then
			local $msgReturn = (@error > 0) ? msgbox($MB_ICONQUESTION + $MB_YESNO, $title, $msg & @crlf & @crlf & "Would you like to run " & $filename & " anyway?") : msgbox($MB_ICONQUESTION + $MB_YESNOCANCEL, $title, $msg & @crlf & @crlf & "Would you like to launch " & $filename & " as admin?" & @crlf & @crlf & "Yes - Relaunch as admin" & @crlf & "No - Continue anyway")
			if (@error > 0 and $msgReturn <> $IDYES) or $msgReturn = $IDCANCEL then
				if x($key & '.closemenuonclick') = 1 then
					Form1Close()
				Else
					Return 1
				EndIf
			ElseIf @error = 0 and $msgReturn = $IDYES Then
				selfrestart(true, $key)
			EndIf
		elseif not $activate then
			MsgBox(($MB_ICONERROR + $MB_SYSTEMMODAL), $title, $msg)
		EndIf
	EndIf
EndFunc

Func IfStringThenArray($key)
	if x($key) then
		local $key_temp[1] = [x($key)]
		x($key, $key_temp)
	EndIf
EndFunc

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

Func addCMDQuotes($aArray)
	Local $sModifiedString = "", $found
	For $i = 1 To $aArray[0]
		$found = false
		if StringRegExp(StringLeft($aArray[$i], 1), "[-/]") then
			$found = true
		EndIf
		$aArray[$i] = ($found ? '' : '"') & $aArray[$i] & ($found ? '' : '"')
	Next
	return $aArray
EndFunc
