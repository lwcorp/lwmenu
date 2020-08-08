#include-once
; #INDEX# =======================================================================================================================
; Title .........: xHashCollection
; AutoIt Version : 3.3.4.0
; Language ......: English
; Description ...: Create and use Multidimentional Associative Arrays
; Author ........: OHB <me at orangehairedboy dot com>
; ===============================================================================================================================
Global $_xHashCollection = ObjCreate( "Scripting.Dictionary" ), $_xHashCache

; #FUNCTION# ====================================================================================================================
; Name...........: x
; Description ...: Gets or sets a value in an Associative Array
; Syntax.........: SET: x( $sKey , $vValue )
;                  GET: x( $key )
; Parameters ....: $sKey - the key to set or get. Examples:
;                  x( 'foo' )           gets value of foo
;                  x( 'foo.bar' )       gets value of bar which is a key of foo
;                  $bar = "baz"
;                  x( 'foo.$bar' )      gets value of baz which is a key of foo (variables are expanded)
; Return values .: Success - When setting, return the value set. When getting, returns the requested value.
;                  Failure - Returns a 0
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
; Name...........: x_unset
; Description ...: Removes a key from an Associative Array
; Syntax.........: x_unset( $sKey )
; Parameters ....: $sKey - the key to remove.
; Return values .: Success - True
;                  Failure - False
; Author ........: OHB <me at orangehairedboy dot com>
; ===============================================================================================================================
Func x_unset( $sKey )
    If $sKey == '' Then Return x( '' , '' )
    $parts = StringSplit( $sKey , "." )
    $cur = $_xHashCollection
    For $x = 1 To $parts[0] - 1
        If Not $cur.exists( $parts[$x] ) Then Return False
        $cur = $cur.item( $parts[$x] )
    Next
    $cur.remove( $parts[$parts[0]] )
    Return True
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: x_display
; Description ...: Displays the contents of an Associative Array
; Syntax.........: x_display( $sKey )
; Parameters ....: $sKey - the key to display. Examples:
;                  x_display()          displays everything
;                  x_display( 'foo' )   displays the contents of foo
; Author ........: OHB <me at orangehairedboy dot com>
; ===============================================================================================================================
Func x_display( $key = '' )
    $text = $key
    If $key <> '' Then $text &= " "
    $text &= StringTrimRight( _x_display( x( $key ) , '' ) , 2 )
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