#AutoIt3Wrapper_Run_After=del "%scriptfile%_x32.exe"
#AutoIt3Wrapper_Run_After=ren "%out%" "%scriptfile%_x32.exe"
#AutoIt3Wrapper_Run_After=del "%scriptfile%_stripped.au3"
#AutoIt3Wrapper_Run_Au3Stripper=y
#Au3Stripper_Parameters=/PreExpand /StripOnly /RM ;/RenameMinimum
#AutoIt3Wrapper_Compile_both=y
#AutoIt3Wrapper_Res_Description=AutoRun LWMenu
#AutoIt3Wrapper_Res_Fileversion=1.3.4
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

Opt('ExpandEnvStrings', 1)
Opt("GUIOnEventMode", 1)
$programname="AutoRun LWMenu"
$version="1.3.4"
$thedate="2020"
$pass="*****"
$product_id="702430" ;"284748"
$keygen_url="https:/no-longer-used.com/keygen?action={action}&productId={product_id}&key={key}&uniqueMachineId={unique_id}"
$keygen_return="[\s\S]+<{tag}>(.+)</{tag}>[\s\S]+"
$validate="validate"
$register="register"
$unregister="unregister"
$s_Config = "autorun.inf"
$shareware = false ; True requires to uncomment any requires <Date.au3> and requires <Crypt.au3> statements

if $shareware then
	$keygen_url=stringreplace($keygen_url, "{product_id}", $product_id)
	$keyfile=@scriptdir & "\" & Stringleft(@scriptname, stringlen(@scriptname)-stringlen(".au3")) & ".key"
endif
$width=stringlen("word1 word2 word3 word4 word5")*20
;$height=
$left_align=(@desktopwidth-$width)/2
$top=30
if @DesktopWidth/@DesktopHeight<1.37 Then
	$left=@DesktopWidth/3
Else
	$left=@DesktopWidth/4
EndIf

if not $shareware then
	$trial=false
elseif not fileexists($keyfile) Then
	$trial=true
else
	$trial=false
	if StringInStr(FileGetAttrib($keyfile), "R") Then
		FileSetAttrib($keyfile, "-R")
	EndIf
	$keytime=FileGetTime($keyfile)
	;$datediff=_DateDiff("D", $keytime[0] & "/" & $keytime[1] & "/" & $keytime[2] & " " & $keytime[3] & ":" & $keytime[4] & ":" & _
	;$keytime[5], _NowCalc()) ;requires <Date.au3>
	;if FileGetTime($keyfile, default, 1)<FileGetTime(@ScriptFullPath, default, 1) or $datediff>90 Then; requires <Date.au3>
			;validate($datediff)
	;endif
EndIf

global $Form1, $nav

load()

While 1
	Sleep(100)
WEnd

func load()
x_unset('')
x('CUSTOM CD MENU.fontface', 'helvetica')
x('CUSTOM CD MENU.fontsize', '10')
;x('CUSTOM CD MENU.buttoncolor', '#fefee0')
x('CUSTOM CD MENU.buttonwidth', ($width-$left)/3+$left)
x('CUSTOM CD MENU.buttonheight', '50')
x('CUSTOM CD MENU.titletext', $programname)

if $CmdLine[0]>0 then ;and FileExists($CmdLine[1]) and FileGetAttrib($CmdLine[1])="D" then
	$thepath=$CmdLine[1]
	If StringRight($thepath, 1) = '\' Then
		$thepath = StringTrimRight($thepath, 1)
	endif
	FileChangeDir(_PathFull($thepath))
endif

ini_to_x(@WorkingDir & "\" & $s_Config)

colorcode("CUSTOM CD MENU.buttoncolor")
colorcode("CUSTOM CD MENU.menucolor")
x_extra()

if $trial then
	x('CUSTOM CD MENU.titletext', x('CUSTOM CD MENU.titletext') & ' (trial mode)')
EndIf

#Region ### START Koda GUI section ### Form=
$Form1 = GUICreate(x('CUSTOM CD MENU.titletext'), $width, 0, $left_align, @desktopheight, BitOr($GUI_SS_DEFAULT_GUI, $WS_MAXIMIZEBOX))
$nav = GUICtrlCreateMenu("&Navigation")
$help = GUICtrlCreateMenu("&Help")
$upper_enabled=false
if FileExists(StringRegExpReplace(@workingdir, "(^.*)\\(.*)", "\1") & "\" & $s_Config) then
	$upper=GUICtrlCreateMenuItem("&Up" & @tab & "Backspace", $nav)
	GUICtrlSetOnEvent(-1, "upper")
	$upper_enabled=true
endif
$reload=GUICtrlCreateMenuItem("&Reload" & @tab & "F5", $nav)
GUICtrlSetOnEvent(-1, "reload")
if $upper_enabled then
	local $AccelKeys2[2][2]=[["{Backspace}", $upper], ["{F5}", $reload]]
Else
	local $AccelKeys2[1][2]=[["{F5}", $reload]]
endif
GUISetAccelerators($AccelKeys2)
GUICtrlCreateMenuItem("&Scan", $nav)
GUICtrlSetOnEvent(-1, "scanfiles")
if $trial Then
	GUICtrlCreateMenuItem("&Register", $help)
	GUICtrlSetOnEvent(-1, "register")
Elseif $shareware then
	GUICtrlCreateMenuItem("&Unregister", $help)
	GUICtrlSetOnEvent(-1, "unregister")
	;GUICtrlCreateMenuItem("&Validate", $help)
	;GUICtrlSetOnEvent(-1, "validate")
EndIf
GUICtrlCreateMenuItem("&About", $help)
GUICtrlSetOnEvent(-1, "about")

if x('CUSTOM CD MENU.menucolor')<>"" Then
	GUISetBkColor(x('CUSTOM CD MENU.menucolor'))
endif
$Label1 = GUICtrlCreateLabel(x('CUSTOM CD MENU.titletext'), ($width-$left)/3, -1, x('CUSTOM CD MENU.buttonwidth'), $top, BitOR($GUI_SS_DEFAULT_LABEL, $SS_CENTER))
if x('CUSTOM CD MENU.buttoncolor')<>"" Then
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

endfunc

Func readxml($url, $type, $datediff=0)
	$content=BinaryToString(InetRead($url))
	x('activate.status', StringRegExpReplace($content, StringReplace($keygen_return, "{tag}", "status"), "$1"))
	$replace=StringRegExpReplace($content, StringReplace($keygen_return, "{tag}", "days_till_expiration"), "$1")
	if @Extended>0 then
		x('activate.days', $replace)
	EndIf
	$replace=StringRegExpReplace($content, StringReplace($keygen_return, "{tag}", "use_count"), "$1")
	if @Extended>0 then
		x('activate.use', $replace)
	EndIf
	switch x('activate.status')
		case "SUCCESS"
			x('activate.message', 'Successfully ' & $type & '!')
			if $type="validated" Then
				x('activate.message', x('activate.message') & _
				@crlf & '(This is an occasional anti-crack check.' & _
				@crlf & 'Sorry for the inconvenience.)')
			EndIf
		case "ERROR_INVALIDKEY"
			x('activate.message', 'Invalid key')
		case "ERROR_INVALIDPRODUCT"
			x('activate.message', 'Invalid product')
		case "ERROR_EXPIREDKEY"
			x('activate.message', 'Expired key')
		case "ERROR_INVALIDMACHINE"
			x('activate.message', 'Invalid machine')
		case "ERROR_ALREADYREG"
			x('activate.message', 'This machine is already registered')
		case "ERROR_MAXCOUNT"
			x('activate.message', 'Already registered on multiple machines')
		case Else
			x('activate.status', 'Else')
			x('activate.message', 'Problem accessing the server in order to get ' & $type & '.' & _
			@crlf & @crlf & _
			'Consider upgrading the software, if a new version exist.' & _
			@crlf & @crlf & _
			'This could also mean either the server or your Internet connection are down.' & _
			@crlf & 'Please accept our apologies and try again later.')
			If $datediff>95 Then
				x('activate.message', x('activate.message') & _
				@crlf & @crlf & _
				'In the mean time, we will have to enter you in TRIAL mode.' & _
				@crlf & @crlf & _
				'If this is an unfortunate mistake, please click register' & _
				@crlf & 'when possible, and use your license key again.')
			endif
	EndSwitch
	if x('activate.days')<>"" Then
		$plusorminus=stringleft(x('activate.days'), stringlen("+"))
		x('activate.days', stringmid(x('activate.days'), stringlen("+")+1))
		if $plusorminus="+" Then
			$message="Reminder: your general registration will expire at " & @crlf & x('activate.days')
		Else
			$message="Your registration expired at " & @crlf & x('activate.days')
		EndIf
		x('activate.message', x('activate.message') & _
		@crlf & @crlf & $message)
	EndIf
	if x('activate.use')<>"" Then
		$message="This key has been in use " & x('activate.use') & " time"
		if x('activate.use')>1 Then $message&="s"
		x('activate.message', x('activate.message') & _
		@crlf & @crlf & $message)
	EndIf
EndFunc

Func upper()
	FileChangeDir(StringRegExpReplace(@workingdir, "(^.*)\\(.*)", "\1"))
	reload()
EndFunc

Func scanfiles()
	GUICtrlSetData(@GUI_CTRLID, "[Scan completed]")
	GUICtrlSetState(@GUI_CTRLID, $GUI_DISABLE)
	$search = FileFindFirstFile("*")
	If $search = -1 Then return
	While 1
		$file = FileFindNextFile($search)
		If @error Then ExitLoop
		if StringInStr(FileGetAttrib($file), "D") and fileexists($file & "\" & $s_Config) Then
			GUICtrlCreateMenuItem($file, $nav)
			GUICtrlSetOnEvent(-1, "subber")
		endif
	Wend
	FileClose($search)
	send("!N")
EndFunc

Func subber()
	FileChangeDir(GUICtrlRead(@GUI_CTRLID,1))
	reload()
EndFunc

Func reload()
	guidelete()
	load()
EndFunc

Func unique_id()
	return DriveGetSerial("")
EndFunc

Func keyfile()
	$thekeyfile=FileOpen($keyfile)
	$thekey = FileReadLine($thekeyfile)
	;$thekey=_Crypt_DecryptData($thekey, $pass, $CALG_RC4) ;requires <Crypt.au3>
	fileclose($thekeyfile)
	return $thekey
EndFunc

Func validate($datediff)
	$keygen_validate=$keygen_url
	$keygen_validate=StringReplace($keygen_validate, "{action}", $validate)
	$keygen_validate=StringReplace($keygen_validate, "{key}", keyfile())
	$keygen_validate=StringReplace($keygen_validate, "{unique_id}", unique_id())
	readxml($keygen_validate, "validated", $datediff)
	if x('activate.status')="SUCCESS" Then
		FileSetTime($keyfile, "")
	Elseif x('activate.status')<>"Else" or $datediff>95 Then
		filedelete($keyfile)
	EndIf
	msgbox(0, $programname, x('activate.message'))
	if (x('activate.status')="SUCCESS" and $trial) or (x('activate.status')<>"SUCCESS" and not $trial) then
		selfrestart()
	endif
EndFunc

Func register()
	$keygen_register=$keygen_url
	$input=inputbox("Key code", "What is your key code?", default, default, default, default, default, default, default, $Form1)
	if $input<>"" Then
		$keygen_register=StringReplace($keygen_register, "{action}", $register)
		$keygen_register=StringReplace($keygen_register, "{key}", $input)
		$keygen_register=StringReplace($keygen_register, "{unique_id}", unique_id())
		;readxml($keygen_register, "registered")
		x('activate.status', "SUCCESS")
		if x('activate.status')="SUCCESS" Then
			$file = FileOpen($keyfile, 2)
			;filewrite($file, _Crypt_EncryptData($input, $pass, $CALG_RC4)) ;requires <Crypt.au3>
			fileclose($file)
		EndIf
		msgbox(0, $programname, x('activate.message'))
		if x('activate.status')="SUCCESS" Then selfrestart()
	EndIf
EndFunc

Func unregister()
	$keygen_unregister=$keygen_url
	$keygen_unregister=StringReplace($keygen_unregister, "{action}", $unregister)
	$keygen_unregister=StringReplace($keygen_unregister, "{key}", keyfile())
	$keygen_unregister=StringReplace($keygen_unregister, "{unique_id}", unique_id())
	readxml($keygen_unregister, "unregistered")
	if x('activate.status')="SUCCESS" Then
		filedelete($keyfile)
	EndIf
	msgbox(0, $programname, x('activate.message'))
	if x('activate.status')="SUCCESS" Then selfrestart()
endfunc

Func about()
  Opt("GUIOnEventMode", 0)
  GUICreate("About " & $programname, -1, 450, -1, -1, -1, $WS_EX_MDICHILD, $Form1)
  $localleft=10
  $localtop=10
  $message=$programname & " - Version " & $version & @crlf & _
  @crlf & _
  $programname & " is a portable program that lets you control menus" & _
  @crlf & "via " & $s_Config & " files." & _
  @crlf & @crlf & _
  "It also serves as a portable enforcer/simulator for semi-portable programs" & _
  @crlf & "that don't need installation but do otherwise leave leftovers forever."
  if $shareware Then
	$message &= @crlf & @crlf & "This is the "
	if not $trial Then
		$message&="full version. Thank you for supporting future development!"
	Else
		$message&="shareware version. Please support future development registering."
	EndIf
  endif
  GUICtrlCreateLabel($message, $localleft, $localtop)
  $message = chr(169) & $thedate & " LWC"
  GUICtrlCreateLabel($message, $localleft, ControlGetPos(GUICtrlGetHandle(-1), "", 0)[3]+18)
  local $aLabel = GUICtrlCreateLabel("https://lior.weissbrod.com", ControlGetPos(GUICtrlGetHandle(-1), "", 0)[2]+10, _
  ControlGetPos(GUICtrlGetHandle(-1), "", 0)[1]+ControlGetPos(GUICtrlGetHandle(-1), "", 0)[3]-$localtop-12)
  GUICtrlSetFont(-1,-1,-1,4)
  GUICtrlSetColor(-1,0x0000cc)
  GUICtrlSetCursor(-1,0)
  $message="    This program is free software: you can redistribute it and/or modify" & _
@crlf & "    it under the terms of the GNU General Public License as published by" & _
@crlf & "    the Free Software Foundation, either version 3 of the License, or" & _
@crlf & "    (at your option) any later version." & _
@crlf & _
@crlf & "    This program is distributed in the hope that it will be useful," & _
@crlf & "    but WITHOUT ANY WARRANTY; without even the implied warranty of" & _
@crlf & "    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the" & _
@crlf & "    GNU General Public License for more details." & _
@crlf & _
@crlf & "    You should have received a copy of the GNU General Public License" & _
@crlf & "    along with this program.  If not, see <https://www.gnu.org/licenses/>." & _
@crlf & @crlf & _
"Additional restrictions under GNU GPL version 3 section 7:" & _
@crlf & @crlf & _
"* In accordance with item 7b), it is required to preserve the reasonable legal notices/author attributions in the material and in the Appropriate Legal Notices displayed by works containing it (including in the footer)." & _
@crlf & @crlf & _
"* In accordance with item 7c), misrepresentation of the origin of the material must be marked in reasonable ways as different from the original version."
#cs
  $message = "Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the ""Software""), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:" & _
  @crlf & @crlf & _
  "The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software." & _
  @crlf & @crlf & _
  "THE SOFTWARE IS PROVIDED ""AS IS"", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE."
#ce
  GUICtrlCreateLabel($message, $localleft, ControlGetPos(GUICtrlGetHandle(-1), "", 0)[1]+ControlGetPos(GUICtrlGetHandle(-1), "", 0)[3], 380, 280)
  $okay=GUICtrlCreateButton("OK", $localleft+140, $localtop+410, 100)

  GUISetState(@SW_SHOW)
  While 1
	$msg=guigetmsg()
	switch $msg
		case $GUI_EVENT_CLOSE, $okay
			form2close()
			ExitLoop
		case $aLabel
			clicker(GUICtrlRead($msg))
	endswitch
  WEnd
EndFunc

func selfrestart()
	form2close()
	If @Compiled Then
		Run(FileGetShortName(@ScriptFullPath))
    Else
		Run(FileGetShortName(@AutoItExe) & " " & chr(34) & @ScriptFullPath & chr(34))
    EndIf
	form1close()
EndFunc

func clicker($item)
  ShellExecute($item)
EndFunc

Func Form2Close()
	guidelete()
	Opt("GUIOnEventMode", 1)
EndFunc

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
	if not FileExists($hIniLocation) then Return
	Local $aSections = IniReadSectionNames($hIniLocation), $filecontent, $aKV, $iCount, $xCount, $value, $value_temp
	If @error Then
		$filecontent = FileRead($hIniLocation)
		if @error then
			msgbox(48, "No access", "Access to " & $hIniLocation & " denied with the following error codes: " & @crlf & @error & @crlf & @extended)
			return
		else
			$aSections = StringRegExp($filecontent, '^|(?m)^\s*\[([^\]]+)', 3)
			$aSections[0] = UBound($aSections)-1
		endif
	endif
	;Get All The Keys and Values for Each section
	For $iCount = 1 To $aSections[0]
		if $filecontent="" then
			$aKV = IniReadSection($hIniLocation, $aSections[$iCount])
			If @error Then ; If empty section then ignore (treat as void)
				ContinueLoop
			endif
		else
			$value = StringRegExp($filecontent, "\Q" & $aSections[$iCount] & ']\E\s+([^\[]+)', 1)
			If not IsArray($value) Then ; If empty section then ignore (treat as void)
				ContinueLoop
			endif
			If StringInStr($value[0], @CRLF, 1, 1) Then
				$value = StringSplit(StringStripCR($value[0]), @LF)
			ElseIf StringInStr($value[0], @LF, 1, 1) Then
				$value = StringSplit($value[0], @LF)
			Else
				$value = StringSplit($value[0], @CR)
			EndIf
			local $aKV[1][2]
			For $xCount = 1 To $value[0]
				if $value[$xCount]="" or StringLeft($value[$xCount], 1)=";" then ContinueLoop
				ReDim $aKV[ubound($aKV)+1][ubound($aKV, 2)]
				$value_temp = StringSplit($value[$xCount], "=", 2)
				$aKV[ubound($aKV)-1][0] = $value_temp[0]
				$aKV[ubound($aKV)-1][1] = $value_temp[1]
				$aKV[0][0] += 1
			next
			if $aKV[0][0]="" then ContinueLoop
		EndIf
		For $xCount = 1 To $aKV[0][0]
			$value = StringSplit($aKV[$xCount][1], ";") ; Support for mid-sentence comments
			$value = StringStripWS($value[1], 3)
			x($aSections[$iCount] & '.' & $aKV[$xCount][0], $value)
		Next
	Next
EndFunc

Func x_extra()
    specialbutton("CUSTOM CD MENU.button_browse")
    specialbutton("CUSTOM CD MENU.button_edit")
    specialbutton("CUSTOM CD MENU.button_close")

    if x('CUSTOM CD MENU.button_browse')="" or x('CUSTOM CD MENU.button_browse')<>"hidden" then
		x('button_browse.buttontext', 'Browse Folder')
		x('button_browse.relativepathandfilename', 'explorer')
		x('button_browse.optionalcommandlineparams', '.')
		x('button_browse.programpath', '.')
		x('button_browse.closemenuonclick', '1')
		if x('CUSTOM CD MENU.button_browse')="blocked" then
			x('button_browse.show', x('CUSTOM CD MENU.button_browse'))
		endif
	endif

    if x('CUSTOM CD MENU.button_edit')="" or x('CUSTOM CD MENU.button_edit')<>"hidden" then
		x('button_edit.buttontext', 'Edit ' & $s_Config)
		x('button_edit.relativepathandfilename', $s_Config)
		x('button_edit.closemenuonclick', '1')
		if x('CUSTOM CD MENU.button_edit')="blocked" then
			x('button_edit.show', x('CUSTOM CD MENU.button_edit'))
		endif
	endif

	if x('CUSTOM CD MENU.button_close')="" or x('CUSTOM CD MENU.button_close')<>"hidden" then
		x('button_close.buttontext', 'Close menu')
		if x('CUSTOM CD MENU.button_close')="blocked" then
			x('button_close.show', x('CUSTOM CD MENU.button_close'))
		endif
	EndIf
EndFunc

Func displaybuttons($all = True)
	$defpush=true
	$space=55
	$pad=10
    If IsDeclared("all") Then
		$localtop=$top+$pad
	endif
	For $key In x('')
		If StringLeft($key, StringLen('button')) = "button" Then
			If IsDeclared("all") Then
				$buttonstyle = -1
				If x($key & '.buttontext')="" or ($key<>'button_close' and x($key & '.relativepathandfilename')="") then
					$buttonstyle = $WS_DISABLED
				elseIf x($key & '.show')<>"" and x($key & '.show')="blocked" then
					$buttonstyle = $WS_DISABLED
					x($key & '.buttontext', x($key & '.buttontext') & " <blocked>")
				elseIf $key<>'button_close' and _
				StringRegExp(x($key & '.relativepathandfilename'), "^\S+:\S+$")=0 and _ ; if not URLs (protocol:...)
				stringinstr(x($key & '.relativepathandfilename'), ".")>0 and _ ; if not internal OS commands (no ".")
				not FileExists(FileGetLongName(x($key & '.relativepathandfilename'), 1)) Then
					$buttonstyle = $WS_DISABLED
					x($key & '.buttontext', x($key & '.buttontext') & " <File not found>")
				EndIf
				if $defpush and $buttonstyle=-1 Then
					$buttonstyle=$BS_DEFPUSHBUTTON
					$defpush=false
				endif
				GUICtrlCreateButton(x($key & '.buttontext'), -1, $localtop, x('CUSTOM CD MENU.buttonwidth'), x('CUSTOM CD MENU.buttonheight'), $buttonstyle)
				GUICtrlSetFont(-1, x('CUSTOM CD MENU.fontsize'), 1000, 0, x('CUSTOM CD MENU.fontface'))
				GUICtrlSetOnEvent(-1, "displaybuttons")
				$localtop+=$space
			ElseIf x($key & '.buttontext') = GUICtrlRead(@GUI_CtrlId) Then
				If $key = 'button_close' Then
					Form1Close()
				EndIf
				switch x($key & '.show')
					case ""
						$show=true
					case "hidden"
						$show=@SW_HIDE
					case "minimized"
						$show=@SW_MINIMIZE
					case "maximized"
						$show=@SW_MAXIMIZE
				EndSwitch
				$programfile = FileGetLongName(x($key & '.relativepathandfilename'), 1)
				If x($key & '.programpath')="" Then
					$programpath=StringRegExpReplace($programfile, "(^.*)\\(.*)", "\1")
				Else
					$programpath = FileGetLongName(x($key & '.programpath'), 1)
				EndIf
				if $trial and (x($key & '.deletefolders')<>"" or x($key & '.deletefiles')<>"") Then
					$note="The following files/folders would not be able to be deleted/created:" & @crlf & @crlf
					if x($key & '.deletefolders')<>"" Then $note&=x($key & '.deletefolders') & @crlf
					if x($key & '.deletefiles')<>"" Then $note&=x($key & '.deletefiles') & @crlf
					$note&=@crlf & "in trial mode. Do you still wish to continue?"
					$input=msgbox(4, "Please consider registering", $note)
					if $input=7 then
						return
					Else
					    if x($key & '.deletefolders')<>"" Then x($key & '.deletefolders', '')
					    if x($key & '.deletefiles')<>"" Then x($key & '.deletefiles', '')
					EndIf
				EndIf
				if StringInStr(FileGetAttrib($programfile), "D") Then
					$temp_programfile=$programfile
				    If StringRight($temp_programfile, 1)=="\" Then $temp_programfile=StringTrimRight($temp_programfile, 1)
					if FileExists($programfile & "\" & $s_Config) then
						filechangedir($programfile)
						guidelete()
						load()
						exitloop
					endif
				endif
                If x($key & '.closemenuonclick') = 1 Then
					guidelete()
				endif
				if x($key & '.registry')<>"" or x($key & '.deletefolders')<>"" or x($key & '.deletefiles')<>"" Then
					$registry=doublesplit(x($key & '.registry'))
					$deletefolders=doublesplit(x($key & '.deletefolders'))
					$deletefiles=doublesplit(x($key & '.deletefiles'))
					if x($key & '.registry')<>"" Then
						For $i=0 To ubound($registry)-1
							if stringleft($registry[$i], StringLen("+"))="+" Then
								$registry_temp=stringmid($registry[$i], StringLen("+")+1)
					            $registry_temp=StringSplit($registry_temp, ",")
								regwrite($registry_temp[1], $registry_temp[2], "REG_SZ", $registry_temp[3])
						    EndIf
					    Next
					EndIf
					if x($key & '.set_variable')<>"" Then
						envset(x($key & '.set_variable'), x($key & '.set_string'))
					endif
					ShellExecuteWait($programfile, x($key & '.optionalcommandlineparams'), $programpath, default, $show)
					if x($key & '.registry')<>"" Then
						For $i=0 To ubound($registry)-1
							if stringleft($registry[$i], StringLen("+"))<>"+" Then
								regdelete($registry[$i])
						    EndIf
					    Next
					EndIf
					if x($key & '.deletefolders')<>"" Then
						For $i=0 To ubound($deletefolders)-1
							if stringleft($deletefolders[$i], StringLen("+"))="+" Then
								$deletefolders_temp=absolute_or_relative($programpath, stringmid($deletefolders[$i], StringLen("+")+1))
								DirRemove($deletefolders_temp, 1)
								DirCreate($deletefolders_temp)
						    Else
								DirRemove(absolute_or_relative($programpath, $deletefolders[$i]), 1)
						    EndIf
					    Next
					EndIf
					if x($key & '.deletefiles')<>"" Then
						For $i=0 To ubound($deletefiles)-1
							FileDelete(absolute_or_relative($programpath, $deletefiles[$i]))
					    Next
					EndIf
				Else
					if x($key & '.set_variable')<>"" Then
						envset(x($key & '.set_variable'), x($key & '.set_string'))
					endif
					ShellExecute($programfile, x($key & '.optionalcommandlineparams'), $programpath, default, $show)
				EndIf
				If x($key & '.closemenuonclick') = 1 Then form1close()
				exitloop
			EndIf
		EndIf
	Next
	If IsDeclared("all") Then
		$height=$localtop+$pad
		if $height>=@desktopheight Then
			$height=@desktopheight
		endif
		winmove($form1, "", default, (@desktopheight-$height)/2, default, $localtop+$space+$pad)
	endif
EndFunc

Func absolute_or_relative($root, $path)
	if StringRegExp($path, "^\S+:\\")=0 Then ; If doesn't start with x:\
		$path=$root & "\" & $path
	EndIf
	return $path
EndFunc

func specialbutton($button)
	if $trial and x($button)<>"" and x($button)="hidden" Then
		x($button, 'blocked')
	EndIf
EndFunc

func colorcode($color)
	if x($color)<>"" Then
	  if stringleft(x($color), StringLen("#"))="#" Then
  	    x($color, '0x' & Stringmid(x($color), stringlen("#")+1))
      Else
		$color_eval = "COLOR" & "_" & $color ; bypassing eval's possible warning about running strings directly
	    x($color, eval($color_eval))
      endif
	EndIf
EndFunc

Func doublesplit($string)
	$res=StringRegExp($string,'("[^"]*"|[^\s"]+)',3)
	For $i = 0 To UBound($res)-1
		if stringinstr($res[$i], '"')>0 then
			$res[$i]=stringreplace($res[$i], '"', '')
		EndIf
	next
	return $res
EndFunc
