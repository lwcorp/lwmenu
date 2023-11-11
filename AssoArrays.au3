#include-once
#include <GUIConstantsEx.au3>

; #INDEX# =======================================================================================================================
; Title .........: xHashCollection
; AutoIt Version : 3.3.4.0
; Language ......: English
; Description ...: Create and use Multidimentional Associative arrays
; Author ........: OHB <me at orangehairedboy dot com>
; ===============================================================================================================================
;~ $tt = TimerInit()
Global $_xHashCollection = ObjCreate( "Scripting.Dictionary" ), $_xHashCache
;~ ConsoleWrite("Asso Array Load up time: "&Round(TimerDiff($tt) ) & @CRLF)

; #FUNCTION# ====================================================================================================================
; Name...........: x
; Description ...: Gets or sets a value in an Associative Array
; Syntax.........: SET: x( $sKey , $vValue )
;                 GET: x( $key )
; Parameters ....: $sKey - the key to set or get. Examples:
;                 x( 'foo' )           gets value of foo
;                 x( 'foo.bar' )       gets value of bar which is a key of foo
;                 $bar = "baz"
;                 x( 'foo.$bar' )     gets value of baz which is a key of foo (variables are expanded)
; Return values .: Success - When setting, return the value set. When getting, returns the requested value.
;                 Failure - Returns a 0
; Author ........: OHB <me at orangehairedboy dot com>
; ===============================================================================================================================
Func x( $sKey = '' , $vValue = '' )
    $func = "get"
    If @NumParams <> 1 Then $func = "set"
    If $sKey == '' Then
        If $func == "get" Then
            Return $_xHashCollection
        Else
            $_xHashCollection.removeAll
            Return ''
        EndIf
    EndIf
    $parts = StringSplit( $sKey , "." )
    $last_key = $parts[$parts[0]]
    $cur = $_xHashCollection
    For $x = 1 To $parts[0] - 1
        If Not $cur.exists( $parts[$x] ) Then
            If $func == "get" Then Return
            $cur.add( $parts[$x] , ObjCreate( "Scripting.Dictionary" ) )
        EndIf
        $cur = $cur.item( $parts[$x] )
    Next
    If IsPtr( $vValue ) Then $vValue = String( $vValue )
    If $func == "get" Then
        If Not $cur.exists( $last_key ) Then Return
        $item = $cur.item( $last_key )
        Return $item
    ElseIf Not $cur.exists( $last_key ) Then
        $cur.add( $last_key , $vValue )
    Else
        $cur.item( $last_key ) = $vValue
    EndIf
    Return $vValue
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: x_del
; Description ...: Removes a key from an Associative Array
; Syntax.........: x_del( $sKey )
; Parameters ....: $sKey - the key to remove.
; Return values .: Success - True
;                 Failure - False
; Author ........: OHB <me at orangehairedboy dot com>
; ===============================================================================================================================
Func x_del( $sKey )
    If $sKey == '' Then Return x( '' , '' )
    $parts = StringSplit( $sKey , "." )
    $cur = $_xHashCollection
    For $x = 1 To $parts[0] - 1
        If Not $cur.exists( $parts[$x] ) Then Return False
        $cur = $cur.item( $parts[$x] )
        If Not IsObj($cur) Then Return False
    Next
    If Not $cur.exists( $parts[$parts[0]] ) Then Return False
    $cur.remove( $parts[$parts[0]] )
    Return True
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: x_display
; Description ...: Displays the contents of an Associative Array
; Syntax.........: x_display( $sKey )
; Parameters ....: $sKey - the key to display. Examples:
;                 x_display()         displays everything
;                 x_display( 'foo' )   displays the contents of foo
; Author ........: OHB <me at orangehairedboy dot com>
; ===============================================================================================================================
Func x_display( $key = '' )
    $text = $key
    If $key <> '' Then $text &= " "
    $text &= StringTrimRight( _x_display( x( $key ) , '' ) , 2 )
    ConsoleWrite($text & @LF)
    $wHnd = GUICreate( "Array " & $key , 700 , 500 )
    GUISetState( @SW_SHOW , $wHnd )
    $block = GUICtrlCreateEdit( $text , 5 , 5 , 690 , 490 )
    GUICtrlSetFont( $block , 10 , 400 , -1 , 'Courier' )
    While 1
        If GUIGetMsg() == -3 Then ExitLoop
    WEnd
    GUISetState( @SW_HIDE , $wHnd )
    GUIDelete( $wHnd )
EndFunc

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: _x_display
; Description ...: Itterates through an array and builds output for x_display
; Author ........: OHB <me at orangehairedboy dot com>
; ===============================================================================================================================
Func _x_display( $item , $tab )
    If IsObj( $item ) Then
        $text = 'Array (' & @CRLF
        $itemAdded = False
        For $i In $item
            $text &= $tab & "  [" & $i & "] => " & _x_display( $item.item($i) , $tab & "  " )
            $itemAdded = True
        Next
        If Not $itemAdded Then $text &= @CRLF
        $text &= $tab & ')'
    ElseIf IsArray( $item ) Then
        $text = "Array"
        $totalItems = 1
        $dimensions = UBound( $item , 0 )
        For $dimension = 1 To $dimensions
            $size = UBound( $item , $dimension )
            $totalItems *= $size
            $text &= "[" & $size & "]"
        Next
        $text &= " (" & @CRLF
        For $itemID = 0 To $totalItems - 1
            $idName = ''
            $idNum = $itemID
            For $dimension = 1 To $dimensions - 1
                $mul = ( $totalItems / UBound( $item , $dimension ) )
                $a = Floor( $idNum / $mul )
                $idName &= '[' & $a & ']'
                $idNum -= ( $a * $mul )
            Next
            $idName &= '[' & $idNum & ']'
            $text &= $tab & "  " & $idName & " => " & _x_display( Execute( "$item" & $idName ) , $tab & "  " )
        Next
        $text &= $tab & ")"
    Else
        $text = $item
    EndIf
    $text &= @CRLF
    Return $text
EndFunc


; Name...........: x_count
; Description ...: Returns a count of items
; Syntax.........: x_count( $sKey )
; Parameters ....: $sKey - the key
; Return values .: Success: count of items of a provided key
;                          x_count() returns count os keys on first level
;                 Failure: 0, set error to:
;                               -1 = the key is not an object, but an item with a value
;                               -2 = the key does not exist
; Author ........:  shEiD (original "x" UDF by: OHB)
Func x_count($sKey = '')
    If $sKey == '' Then Return $_xHashCollection.Count
    Local $cur = $_xHashCollection
    Local $parts = StringSplit($sKey, ".")
    For $x = 1 To $parts[0]
        If Not $cur.exists($parts[$x]) Then Return SetError(-2, 0, 0)
        $cur = $cur.item($parts[$x])
    Next
    If Not IsObj($cur) Then SetError(-1, 0, 0)
    Return $cur.Count
EndFunc   ;==>x_count


; Author: MilesAhead
; http://www.autoitscript.com/forum/topic/110768-itaskbarlist3/page__view__findpost__p__910631
;write AssocArray to IniFile Section
;returns 1 on success - sets @error on failure
Func _WriteAssocToIni($myIni = 'config.ini', $mySection = '', $bEraseAll = false, $sSep = "|")
    If Not StringInStr($myIni,".") Then $myIni &= ".ini"

    If $bEraseAll then
        $temp = FileOpen($myIni, 2)
        FileClose($temp)
    EndIf

    Local $sIni = StringLeft($myIni,StringInStr($myIni,".")-1)

    If Not $_xHashCollection.Exists($sIni) Then Return SetError(-1, 0, 0)

    If $mySection == '' Then
        $aSection = $_xHashCollection($sIni).Keys(); All sections
    Else
        Dim $aSection[1] = [$mySection]; specific Section
    EndIf
    Local $retVal = 0
    For $i = 0 To UBound($aSection)-1
        $cur = x($sIni&"."&$aSection[$i])
        $retVal = 0
        If $cur.Count() < 1 Then
            Return SetError(-2, 0, 0)
        EndIf
        Local $iArray[$cur.Count()][2]
        Local $aArray = $cur.Keys()
        For $x = 0 To UBound($aArray) - 1
            $iArray[$x][0] = $aArray[$x]
            $value = x($sIni&"."&$aSection[$i]&"."&$aArray[$x])
            If IsArray($value) then
                $iArray[$x][1] = _MakePosString($value, $sSep)
            Else
                $iArray[$x][1] = $value
            EndIf
        Next
        $retVal = IniWriteSection($myIni, $aSection[$i], $iArray, 0)
    next

    Return SetError(@error, 0, $retVal)
EndFunc   ;==>_WriteAssocToIni

;read AssocArray from IniFile Section
;returns number of items read - sets @error on failure
Func _ReadAssocFromIni($myIni = 'config.ini', $mySection = '', $sSep = "|")
    If Not StringInStr($myIni,".") Then $myIni &= ".ini"
    Local $sIni = StringLeft($myIni,StringInStr($myIni,".")-1)

    If $mySection == '' Then
        $aSection = IniReadSectionNames ($myIni); All sections
        If @error Then Return SetError(@error, 0, 0)
    Else
        Dim $aSection[2] = [1,$mySection]; specific Section
    EndIf

    For $i = 1 To UBound($aSection)-1

        Local $sectionArray = IniReadSection($myIni, $aSection[$i])
        If @error Then Return SetError(-1, 0, 0)
        For $x = 1 To $sectionArray[0][0]
            If StringInStr($sectionArray[$x][1], $sSep) then
                $posS = _MakePosArray($sectionArray[$x][1], $sSep)
            Else
                $posS = $sectionArray[$x][1]
            EndIf
            x($sIni&"."&$aSection[$i]&"."&$sectionArray[$x][0], $posS)
        Next

    next
    Return $sectionArray[0][0]
EndFunc   ;==>_ReadAssocFromIni

;makes a Position string using '#' number separator
Func _MakePosString($posArray, $sSep = "|")
    Local $str = ""
    For $x = 0 To UBound($posArray) - 2
        $str &= String($posArray[$x]) & $sSep
    Next
    $str &= String($posArray[UBound($posArray) - 1])
    Return $str
EndFunc   ;==>_MakePosString

;makes a Position array from a Position string
Func _MakePosArray($posString, $sSep = "|")
    Return StringSplit($posString, $sSep, 2)
EndFunc   ;==>_MakePosArray
